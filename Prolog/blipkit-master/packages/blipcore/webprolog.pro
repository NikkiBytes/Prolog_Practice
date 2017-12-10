:- module(webprolog,
          [
           start_server/0,
           start_server/1
          ]).

:- use_module(interprocess).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_client)).

:- multifile http:location/3.
:- dynamic   http:location/3.

http:location(www, /, []).
http:location(webprolog, '/', []).
http:location(script, www(script), []).
http:location(css, www(css), []).

background:-
        repeat,
        fail.

start_server :-
        start_server(9090).

start_server(Port) :-
        http_server(http_dispatch, [port(Port)]).
        %http_server(reply, [port(Port)]).

:- http_handler(webprolog(.), root, [prefix]).
:- http_handler(webprolog('_all_dbs'), all_dbs, []).
%:- http_handler(webprolog(js), js_dir, [prefix]).

% TODO

% put vs get
root(Request) :-
        debug(webprolog,'Req: ~w',[Request]),
        member(method(Method), Request), !,
        root(Method,Request).

% PUT - assert or create
root(put,Request) :-
        request_path_local(Request,root,Db),
        debug(webprolog,'Db: ~w',[Db]),
        put_database(Db,Request).

root(delete,Request) :-
        request_path_local(Request,root,Db),
        debug(webprolog,'Db: ~w',[Db]),
        delete_database(Db,Request).

% GET
root(_,Request) :-
        debug(webprolog,'R: ~w',[Request]),
        http_parameters(Request,
                        [
                         call(IsCall, [boolean,optional(true),default(false)])
                        ],
                        [
                         attribute_declarations(param)
                        ]),
        request_path_local(Request,root,Path),
        debug(webprolog,'Path: ~w',[Path]),
        concat_atom([Db|Parts],'/',Path),
        concat_atom(Parts,'/',Q),
        debug(webprolog,'Query: ~w for ~w // ~w',[Db,Q,IsCall]),
        (   IsCall=true
        ->  query_database_via_call(Db,Q)
        ;   query_database(Db,Q)).


query_database('','') :-
        % list all dbs
        all_dbs(_).

query_database(Db,'') :-
        reply_json(json([db=Db])).

query_database(Db,A) :-
        atom_to_term(A,Q,Bindings),
        debug(webprolog,'Query[pl]: ~q bindings: ~w',[Q,Bindings]),
        db_stream(Db,S),
        debug(webprolog,'  s: ~w',[S]),
        ipr_query(S,json(Bindings),Q,L),
        debug(webprolog,'Results: ~w',[L]),
        reply_json(json([results=L])).

query_database_via_call(Db,A) :-
        atom_to_term(A,Q,_Bindings),
        db_stream(Db,S),
        debug(webprolog,'  s: ~w',[S]),
        ipr_call(S,Q,L),
        debug(webprolog,'CallResults: ~w',[L]),
        reply_json(json([results=L])).

put_database(Db,Request) :-
        member(content_length(Len),Request),
        Len>1,
        !,
        http_read_data(Request, Data, [to(atom)]),
        debug(webprolog,'Data: ~w',[Data]),
        atom_to_term(Data,Term,_),
        database_assert(Db,Term),
        reply_json(json([ok=true,number_of_facts=1])).
        
put_database(Db,Request) :-
        http_parameters(Request,
                        [
                         engine(Engine, [optional(true),default(blip)])
                        ],
                        [
                         attribute_declarations(param)
                        ]),
        create_database(Db,Engine).

% HTTP UTIL

request_path_local(Request,Loc,X) :-
        memberchk(path(ReqPath), Request),
	http_location_by_id(Loc, Me),
	atom_concat(Me, X, ReqPath).

% LOGIC

:- dynamic db_stream/2.

database_assert(Db,Term) :-
        db_stream(Db,S),
        !,
        debug(webprolog,'Asserting: ~w in ~w',[Term,S]),
        ipr_assert(S,Term).

create_database(Db,_) :-
        db_stream(Db,_),
        !,
        reply_json(json([error=db_exists])).

create_database(Db,Engine) :-
        \+ db_stream(Db,_),
        !,
        debug(webprolog,'initializing: ~w',[Db]),
        init_ipr_session(S,[exe(Engine)]), % can also change to exe(swipl)
        debug(webprolog,'stream: ~w',[S]),
        assert(db_stream(Db,S)),
        reply_json(json([ok=true])).

delete_database(Db,_) :-
        db_stream(Db,S),
        !,
        debug(webprolog,'killing: ~w',[Db]),
        kill_ipr_session(S),
        retractall(db_stream(Db,S)),
        reply_json(json([ok=true])).
delete_database(_,_) :-
        reply_json(json([error=no_such_db])).

all_dbs(_) :-
        findall(Db,db_stream(Db,_),Dbs),
        reply_json(json([dbs=Dbs])).

/*

  ---+ Web Prolog Server

  allows remote clients to run prolog sessions via REST calls, receiving json objects
  
  ---++ start the server

  ==
  swipl
  use_module(webprolog).
  start_server.
  ==

  ---++ Talking to the server
  
  do the following from command line in separate terminal. Assume curl or similar tool installed.

  ---+++ initiate a database

  ==
  $ curl -XPUT "http://127.0.0.1:9090/mydb"
{"ok":"true"}
  ==

  ---+++ add some facts

  ==
 $ curl -XPUT --data "isa(dog,mammal)" http://127.0.0.1:9090/mydb
{"ok":"true", "number_of_facts":1} 
 $ curl -XPUT --data "isa(mammal,animal)" http://127.0.0.1:9090/mydb
{"ok":"true", "number_of_facts":1}
  ==

    ---+++ query the database

  ==
$ curl "http://127.0.0.1:9090/mydb/isa(X,Y)"
{
  "results": [ {"X":"dog", "Y":"mammal"},  {"X":"mammal", "Y":"animal"}]
}  
  ==
  
  ---+++ now with rules
  
  ==
$ curl -XPUT --data "isaT(X,Y) :- isa(X,Y)" http://127.0.0.1:9090/mydb
{"ok":"true", "number_of_facts":1}
$  curl -XPUT --data "isaT(X,Y) :- isa(X,Z),isaT(Z,Y)" http://127.0.0.1:9090/mydb
{"ok":"true", "number_of_facts":1}
  ==

  ==
$ curl "http://127.0.0.1:9090/mydb/isaT(X,Y)"
{
  "results": [
     {"X":"dog", "Y":"mammal"},
     {"X":"mammal", "Y":"animal"},
     {"X":"dog", "Y":"animal"}
  ]
}  
  ==

  ---+++ Kill database

  do this at the end of your session (warning - the server doesnt
  currently kill inactive sessions, so if you don't do this there will
  be lots of inactive swipl processes on the server)
  
  ==
$ curl -XDELETE http://127.0.0.1:9090/mydb
  ==


  ---+ TODO

  * authentication
  * use safe_interpreter
  * kill inactive sessions
  

*/
