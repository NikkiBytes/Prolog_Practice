:- module(ontol_restful,
          [
           idspace_url_format/3,
           ont_idspace/2,
           id_url/2,
           id_url/3,
           id_imgurl/2,
           class_thumbnail/2,
           id_params_url/3,
           id_params_url/4,
           params_hidden/2,
           params_drels_crels/3,
	   knowsabout/1,
           id_wikipage/2,
           parse_id_idspace/2,
           parse_id_idspace/3,
           id_exturl/2,
           ontol_page/2,
           hidden/1
          ]).

:- use_module(bio(serval)).
:- use_module(bio(ontol_db)).
:- use_module(bio(ontol_lookup)).
:- use_module(bio(ontol_segmenter)).
:- use_module(bio(ontol_writer_dot)).
:- use_module(bio(metadata_db)).
:- use_module(bio(io)).
:- use_module(bio(quickterm)).
:- use_module(bio(bioprolog_util),[solutions/3]).
:- use_module(bio(blipkit_ontol)).
:- use_module(bio(safe_interpreter),[safe/1]).

idspace_confmod(upheno,ontol_config_upheno).
idspace_confmod('PATO',ontol_config_pato).
idspace_confmod('FMA',ontol_config_fma).
idspace_confmod('MA',ontol_config_ma).
idspace_confmod('SO',ontol_config_so).
idspace_confmod('GAZ',ontol_config_gaz).
idspace_confmod('UBERON',ontol_config_uberon).
idspace_confmod('OBI',ontol_config_obi).
idspace_confmod('FBdv',ontol_config_fbdv).
idspace_confmod('ZFA',ontol_config_zfa).
idspace_confmod('FBbt',ontol_config_zfa). % todo - generic anatomy config?
idspace_confmod('XAO',ontol_config_xao).
idspace_confmod('NCBITaxon',ontol_config_ncbi_taxonomy).
idspace_confmod('NIF_GrossAnatomy',ontol_config_nif).
idspace_confmod('CHEBI',ontol_config_default).
idspace_confmod('GOCHE',ontol_config_goche).

idspace_import_confmod('CHEBI','GOCHE',ontol_config_goche).
idspace_import_confmod('GOCHE','CHEBI',ontol_config_goche).


% maps an ontology (e.g. biological_process) onto an IDspace (e.g. GO) via
% settings in ontology metadata file
ont_idspace(Ont,IDSpace):- inst_sv(Ont,namespace,IDSpace,_).

% chebi images
% http://www.ebi.ac.uk/chebi/displayImage.do?defaultImage=true&imageIndex=0&chebiId=16977
id_imgurl(ID,URL) :-
        parse_id_idspace(ID,'CHEBI'),
        id_localid(ID,Num),
        atom_concat('http://www.ebi.ac.uk/chebi/displayImage.do?defaultImage=true&imageIndex=0&chebiId=',Num,URL).
id_imgurl(ID,URL) :-
        class_thumbnail(ID,URL).

class_thumbnail(ID,URL) :-
        (   def_xref(ID,URL)
        ;   entity_xref(ID,URL)),
        sub_atom(URL,_,4,_,Suffix),
        downcase_atom(Suffix,Suffix2),
        img_suffix(Suffix2).

img_suffix('.png').
img_suffix('.PNG').
img_suffix('.gif').
img_suffix('.GIF').
img_suffix('.jpg').
img_suffix('.JPG').


ont_refs(Ont,Ont2):-
        inst_sv(Ont,xrefs_to,A),
        concat_atom(L,',',A),
        member(Ont2,L).
ont_refs(Ont,Ont2):-
        inst_sv(Ont,uses,Ont2,_).
ont_refs(Ont,Ont2):-
        inst_sv(Ont,extends,Ont2,_).

%% idspace_url_format(+IDSpace,?URL,?Fmt)
% E.g. CL --> http://purl.org/obo/obo/CL.obo, obo
% TODO: remove hardcoding
idspace_url_format('NIF_Subcellular',URL,Fmt) :- idspace_url_format('PKB',URL,Fmt).
idspace_url_format('NIF_Investigation',URL,Fmt) :- idspace_url_format('PKB',URL,Fmt).
idspace_url_format(snap,URL,Fmt) :- idspace_url_format(bfo,URL,Fmt).
idspace_url_format(span,URL,Fmt) :- idspace_url_format(bfo,URL,Fmt).
idspace_url_format(ncithesaurus,URL,Fmt) :- idspace_url_format('NCIt',URL,Fmt). % tmp
idspace_url_format('GO','http://www.geneontology.org/ontology/obo_format_1_2/gene_ontology_ext.obo',obo).
idspace_url_format('upheno','http://obo.cvs.sourceforge.net/viewvc/obo/obo/ontology/phenotype/phenotype_xp/uberpheno/uberpheno-full.obo',obo).
idspace_url_format('UBERON_IMG','http://github.com/cmungall/uberon/raw/master/uberon-thumbnail-xrefs.obo',obo).
idspace_url_format('GOCHE','http://www.geneontology.org/ontology/editors/goche.obo',obo).
idspace_url_format(IDSpace,URL,obo) :-
        sformat(URL,'http://purl.org/obo/obo/~w.obo',[IDSpace]).

idspace_refs(S,S2):-
        ont_idspace(Ont,S),
        ont_refs(Ont,Ont2),
        ont_idspace(Ont2,S2).

listatom_ids(IDListAtom,IDs):-
        atom(IDListAtom),
	concat_atom(IDs,'+',IDListAtom),
	IDs = [_,_|_].


% lists
id_url(Xs,Fmt,URL):- is_list(Xs),!,concat_atom(Xs,'+',X),id_url(X,Fmt,URL).
id_url(Xs,URL):- is_list(Xs),!,concat_atom(Xs,'+',X),id_url(X,URL).
id_url(X/T,URL):- !,id_url(X,URL1),concat_atom([URL1,T],'/',URL).

id_url(X,X):- atom_concat('http:',_,X),!.
id_url(X,URL):- sformat(URL,'/obo/~w',[X]).
id_url(X,Fmt,URL):- sformat(URL,'/obo/~w.~w',[X,Fmt]).

% adds hidden params + additional import
id_params_url(X,Params,FullURL,Context) :-
        id_url(X,URL),
        params_hidden([import=Context|Params],Extra), 
        sformat(FullURL,'~w?~w',[URL,Extra]). % TODO -- what if we have params already?

% adds hidden params
id_params_url(X,Params,FullURL) :-
        id_url(X,URL),
        params_hidden(Params,Extra), 
        sformat(FullURL,'~w?~w',[URL,Extra]). % TODO -- what if we have params already?

%% params_hidden(+Params,?Extra)
params_hidden(Params,Extra) :-
        findall(PA,(hidden(P),
                    member(P=V,Params),
                    sformat(PA,'~w=~w',[P,V])),
                PAs),
        concat_atom(PAs,'&',Extra).

hidden(import).
hidden('GALAXY_URL').


knowsabout(ID) :-
	parse_id_idspace(ID,S,_),
	\+ \+ inst_sv(_,namespace,S,_).
	       
remove_pro_files(F) :-
        atom_concat(F,'.pro',X),
        exists_file(X),
        delete_file(X),
        fail.
remove_pro_files(F) :-
        atom_concat(F,'.qlf',X),
        exists_file(X),
        delete_file(X),
        fail.
remove_pro_files(_).



id_wikipage(ID,Page):- def_xref(ID,X),xref_wikipage(X,Page).
id_wikipage(ID,Page):- entity_xref(ID,X),xref_wikipage(X,Page).
xref_wikipage(X,Page):- parse_id_idspace(X,'Wikipedia',Page),\+ sub_atom(Page,0,_,_,'http:').
xref_wikipage(X,Page):- parse_id_idspace(X,'Wikipedia',URL),sub_atom(URL,0,_,_,'http:'),xref_wikipage(URL,Page).
xref_wikipage(X,Page):- parse_id_idspace(X,url,URL),sub_atom(URL,0,_,_,'http:'),xref_wikipage(URL,Page).
xref_wikipage(X,Page):- atom_concat('http://en.wikipedia.org/wiki/',Page,X).

parse_id_idspace(ID,S):-
        parse_id_idspace(ID,S,_).
parse_id_idspace(ID,S,Local):-
        !,
        concat_atom([S|LocalParts],':',ID),
        LocalParts\=[],
        concat_atom(LocalParts,':',Local).
parse_id_idspace(ID,obo,ID).

id_exturl(ID,URL):-
        parse_id_idspace(ID,S,Local),
        inst_sv(S,'GOMetaModel:url_syntax',Ex,_),
        atom_concat(Base,'[example_id]',Ex),
        atom_concat(Base,Local,URL).

% display relations and containment relations from parameters
params_drels_crels(Params,AllRels,CRels) :-
        params_drels_crels1(Params,Rels,CRels),
        (   Rels=[all]
        ->  AllRels=[]
        ;   AllRels=[subclass|Rels]).

params_drels_crels1(Params,AllRels,CRels) :-
        \+ member(rel=_,Params),
        \+ member(cr=_,Params),
        debug(ontol_rest,' Fetching config display parameters',[]),
        setof(R,user:graphviz_ontol_param(display_relation(Ont),R),AllRels),
        solutions(R,user:graphviz_ontol_param(containment_relation(Ont),R),CRels),
        debug(ontol_rest,' Using display params for ~w : ~w & ~w',[Ont,AllRels,CRels]),
	% avoid combining multiple display relations from multiple configs
        \+ ((user:graphviz_ontol_param(display_relation(Ont2),_),Ont2\=Ont)),
        \+ ((user:graphviz_ontol_param(containment_relation(Ont2),_),Ont2\=Ont)),
        !.

params_drels_crels1(Params,AllRels,CRels) :-
        findall(Rel,member(rel=Rel,Params),AllRels),
        findall(Rel,member(cr=Rel,Params),CRels).


%% searchterm_entities(S,L) is semidet
searchterm_entities(S,L):-
        sformat(S1,'%~w%',[S]),
        setof(X,lookup_class(search(S1),X),L).

emit_content_type(CT):-
        format('Content-type: ~w~n~n', [CT]).

emit_content_type_text_html:-
        set_stream(user_output,encoding(utf8)),
        emit_content_type('text/html; charset=utf-8').


preload(ID,Params):-
        concat_atom([IDSpace,_LocalID],':',ID),
        preload_ont(IDSpace,Params).

preload_revlinks(ID,Params):-
        load_bioresource(obo_meta_xp),
        concat_atom([IDSpace,_LocalID],':',ID),
        debug(ontol_rest,'Fetching all onts that link to ~w',[IDSpace]),
        solutions(X,
                  idspace_refs(X,IDSpace),
                  Xs),
        debug(ontol_rest,'  All: ~w',[Xs]),
        forall(member(X,Xs),
               preload_ont(X,Params)).

%% preload_ont(+IDSpace,+Params)
% 
% IDSpace is an ontology IDSpace such as GO, CL, etc.
preload_ont(IDSpace,Params):-   % ont is NOT specified on param list
        \+ member(ont=_,Params),
        !,
        % some ontologies trigger the loading of species configurations
        % for graph drawing. we only do this in situations where a single
        % ontology is loaded. if there is an import, then we only go with the
        % default configuration.
        % allow for the situation where specific combos are allowed via idspace_import_confmod/3
        (   \+ member(import=_,Params)
        ->  forall(idspace_confmod(IDSpace,Mod),
                   consult(bio(Mod)))
        ;   forall((member(import=Import,Params),
                    idspace_import_confmod(IDSpace,Import,Mod)),
                   consult(bio(Mod)))),
        % TODO: check if this is registered
        debug(ontol_rest,'Loading IDSpace ~w',[IDSpace]),
        % E.g. CL --> http://purl.org/obo/obo/CL
        idspace_url_format(IDSpace,URL,Fmt),
        % make sure the import chain is followed (if any)
        catch((load_biofile(Fmt,url(URL)),
               ontol_db:import_all_ontologies),
              _,
              true).
preload_ont(_IDSpace,Params):-  % ont IS specified on param list; ignore IDSpace
        setof(Ont,member(ont=Ont,Params),Onts),
        debug(ontol_rest,'Loading ~w',[Onts]),
        maplist(load_bioresource,Onts),
        debug(ontol_rest,'Loaded ~w',[Onts]),
        ontol_db:import_all_ontologies.

%% preload_ont_plus_dependencies(+IDSpace,+Params)
% as preload_ont/2, but in addition will load other
% IDSpaces based on idspace_refs/2
preload_ont_plus_dependencies(IDSpace,Params):-
        %load_bioresource(obo_meta),
        load_bioresource(obo_meta_xp),
        preload_ont(IDSpace,Params),
        solutions(X,
                  idspace_refs(IDSpace,X),
                  Xs),
        debug(ontol_rest,'  All: ~w',[Xs]),
        forall(member(X,Xs),
               preload_ont(X,Params)).

:- multifile ontol_page_hook/2.

% load all imported ontologies
ontol_page(Path,Params) :-
        forall(member(import=Ont,Params),
               preload_ont_plus_dependencies(Ont,Params)),
        ontol_page_actual(Path,Params).

ontol_page_actual(Path,Params):-
        ontol_page_hook(Path,Params),
        !.
        
ontol_page_actual(Path,Params):-
        \+ is_list(Path),
        !,
        concat_atom(PathElts,'/',Path),
        ontol_page_actual(PathElts,Params).

ontol_page_actual([],Params):-
        %load_bioresource(obo_meta),
        emit_content_type_text_html,
        emit_page(entry_page,Params).

% remove trailing slash
ontol_page_actual(L,Params):-
        append(L1,[''],L),
        !,
        ontol_page_actual(L1,Params).

ontol_page_actual([mappings],Params):-
        load_bioresource(obo_meta_xp),
        emit_content_type_text_html,
        emit_page(mappings_entry_page,Params).

ontol_page_actual([''],Params):-
        ontol_page_actual([],Params).

ontol_page_actual([help],Params):-
        emit_content_type_text_html,
        emit_page(help_page,Params).

% multiple IDs specified as multiple?id=A&id=B&...
ontol_page_actual([multiple],Params):-
        findall(ID,member(id=ID,Params),IDs),
	!,
	forall(member(ID,IDs),
	       preload(ID,Params)),
	emit_content_type_text_html,
	emit_page(multiple(IDs),Params).

ontol_page_actual([ID_Base],Params):-
        member(compare=structure,Params),
        !,
        id_idspace(ID_Base,Ont),
        findall(ID,member(id=ID,Params),SelectedIDs),
        IDs=[ID_Base|SelectedIDs],
	forall(member(ID,IDs),
	       preload(ID,Params)),
	emit_content_type_text_html,
	emit_page(structural_comparison(IDs,Ont),Params).

ontol_page_actual([ID_Base],Params):-
        member(compare=_,Params),
        !,
        findall(ID,member(id=ID,Params),SelectedIDs),
        IDs=[ID_Base|SelectedIDs],
	forall(member(ID,IDs),
	       preload(ID,Params)),
	emit_content_type_text_html,
	emit_page(multiple(IDs),Params).

ontol_page_actual([Last],Params):-
        concat_atom([ID,Fmt],'.',Last),
        !,
        debug(ontol_rest,'id=~q fmt=~w',[ID,Fmt]),
        ontol_page_actual([Fmt,ID],Params).

ontol_page_actual([S],Params):-
        concat_atom([_],':',S),
        !,
        ontol_page_actual([ontology_entry,S],Params).

% multiple IDs can be specified A+B+...+Z
ontol_page_actual([IDListAtom],Params):-
	listatom_ids(IDListAtom,IDs),
	!,
	forall(member(ID,IDs),
	       preload(ID,Params)),
	emit_content_type_text_html,
	emit_page(multiple(IDs),Params).


ontol_page_actual([ID],Params):-
        preload(ID,Params),
        (   soft_redirect(ID,ID2)
        ->  true
        ;   ID2=ID),
        (   redirect(ID2,Type,URL)
        ->  format('HTTP/1.1 ~w~nStatus: ~w~nLocation: ~w~n~n',[Type,Type,URL])
        ;   emit_content_type_text_html,
            emit_page(basic(ID2),Params)).
        
ontol_page_actual([''|L],Params):-
        !,
        ontol_page_actual(L,Params).

ontol_page_actual([png,IDListAtom],Params):-
	listatom_ids(IDListAtom,IDs),
	!,
        ontol_page_actual([png,IDs],Params).

ontol_page_actual([png,IDs],Params):-
        is_list(IDs),
	!,
        debug(ontol_rest,' multiple IDs (will cluster)=~w',[IDs]),
        emit_content_type('image/png'),
        % treat xrefs like normal relations - useful for comparing two ontologies side-by-side
        (   IDs=[_,_|_]
	->  ensure_loaded(bio(ontol_manifest_relation_from_xref))
        ;   true),

        % this is a bit of a hack as we can't bypass info into the graph structure;
        % ontol_config_default handles this
        forall(member(focus=Focus,Params),
               assert(user:focus(Focus))),
        forall(member(Focus,IDs),
               assert(user:focus(Focus))),
        forall(member(focus=Focus,Params),
               assert(user:graphviz_color_node(Focus,yellow))),
        forall(member(Focus,IDs),
               assert(user:graphviz_color_node(Focus,yellow))),
        
	forall(member(ID,IDs),
	       preload(ID,Params)),
        params_drels_crels(Params,AllRels,CRels),
        % TODO -- better way of handling xrefs
        (   AllRels=[]
        ->  AllRelsActual=[]
        ;   AllRelsActual=[xref|AllRels]),
        debug(ontol_rest,'   Display=~w Contain=~w DisplayActual=~w',[AllRels,CRels,AllRelsActual]),
        Opts=[cluster_pred(belongs(X,Ontol),X,Ontol), % we may have multiple ontologies
	      collapse_predicate(fail),
	      relations(AllRelsActual),containment_relations(CRels)],
        ontology_segment(IDs,Edges,_OutNodes,Opts),
        debug(ontol_rest,' Edges=~w',[Edges]),
        write_edges_to_image(Edges,Opts).

ontol_page_actual([png,ID],Params):-
        \+ is_list(ID),
        member(import=_,Params),
        !,
        ontol_page_actual([png,[ID]],Params).

ontol_page_actual([png,ID],Params):-
        emit_content_type('image/png'),
        preload(ID,Params),
        debug(ontol_rest,' Params=~w',[Params]),
        params_drels_crels(Params,AllRels,CRels),
        debug(ontol_rest,'   Display=~w Contain=~w',[AllRels,CRels]),
        Opts=[collapse_predicate(fail),relations(AllRels),containment_relations(CRels)],
        debug(ontol_rest,' Opts=~w',[Opts]),
        ontology_segment([ID],Edges,_OutNodes,Opts),
        debug(ontol_rest,' Edges=~w',[Edges]),
        write_edges_to_image(Edges,Opts).

ontol_page_actual([obo,ID],Params):-
        emit_content_type('text/plain'),
        write_obo(ID,Params).

ontol_page_actual([pro,ID],Params):-
        emit_content_type('text/plain'),
        write_fmt(ID,pro,Params).

ontol_page_actual([json,ID],Params):-
        emit_content_type('text/plain'),
        write_fmt(ID,jsontree,Params).

ontol_page_actual([Fmt,ID],Params):-
        fmt_ct_exec(Fmt,CT,Exec),
        emit_content_type(CT),
        tmp_file(obo,F),
        tell(F),
        write_obo(ID,Params),
        told,
        sformat(Cmd,'~w ~w',[Exec,F]),
        debug(ontol_rest,'executing: ~w',[Cmd]),
        shell(Cmd),
        remove_pro_files(F).


ontol_page_actual([revlinks,ID],Params):-
        debug(ontol_rest,'revlinks ~w',[ID]),
        emit_content_type_text_html,
        preload(ID,Params),
        preload_revlinks(ID,Params),
        emit_page(what_links_here_table(ID),Params).

ontol_page_actual([meta_search,ID],Params):-
        ensure_loaded(bio(web_search_expander)),
        debug(ontol_rest,'metasearch ~w',[ID]),
        emit_content_type_text_html,
        preload(ID,Params),
        findall(Type-URL,
                create_search_url(ID,Type,URL),
                Pairs),
        emit_page(meta_search_urls_table(Pairs),Params).

ontol_page_actual([ontology_entry,ID],Params):-
        emit_content_type_text_html,
        debug(ontol_rest,'ontology entry ~w',[ID]),
        (   member(search_term=S,Params),
            preload_ont(ID,Params)
        ->  (   searchterm_entities(S,L)
            ->  emit_page(ontology_filtered(ID,S,L),Params)
            ;   emit_page(noresults(ID,S),Params))
        ;   emit_page(ontology_entry(ID),Params)).

/*
ontol_page_actual([quickterm,S,login],Params):-
        member(submit=_,Params),
        !,
        format('Content-type: text/html~n',[]),
        format('Set-Cookie: foo=bar~n~n',[]),
        emit_page(quickterm_login(S),Params).
ontol_page_actual([quickterm,S,login],Params):-
        
        emit_content_type_text_html,
        emit_page(quickterm_login(S),Params).
*/


template_user_err(_,'',Params,must_supply_username_for_commit) :-
        member(commit=Commit,Params),
        Commit\=false.
template_user_err(T,U,Params,incorrect_password) :-
        U\='',
        \+ ((member(password=P,Params),
             template_check_user_password(T,U,P))).
template_user_err(T,U,Params,no_permission_for_this_template) :-
        member(commit=Commit,Params),
        Commit\=false,
        \+ qtt_permitted_user(T,U).

ontol_page_actual([quickterm,S],Params):-
        emit_content_type_text_html,
        %preload_ont(S,Params),
        debug(ontol_rest,' Loading editors file: ~w',[S]),
        load_editors_file(S),
        debug(ontol_rest,' Quickterm Params= ~w',[Params]),
        (   member(template=T,Params)
        ->  true
        ;   T=''),
        debug(ontol_rest,' selected template = ~w',[T]),
        (   member(submit=submit,Params),
            (   member(commit=Commit,Params)
            ->  true
            ;   Commit=false)
        ->  debug(ontol_rest,' submitting [commit= ~w]',[Commit]),
            forall(qtt_external(T,ExtOnt),
                   preload_ont(ExtOnt,Params)),
            (   member(username=UserIn,Params),
                atom_alphanumeric(UserIn,User)
            ->  true
            ;   User=''),

            % VALIDATE
            (   template_user_err(T,User,Params,Err)
            ->  Errs=[Err]
            ;   template_resolve_args(T,Params,Template,Errs)),

            debug(ontol_rest,'template= ~w commit=~w // Errs=~w',[Template,Commit,Errs]),
            (   Errs=[]
            ->  findall(Opt,
                        (   member(P,[subtemplate,name,comment,def,def_xref]),
                            member(P=V,Params),
                            V\='',
                            Opt=..[P,V]),
                        Opts),
                %findall(subtemplate(W),
                %        member(subtemplate=W,Params),
                %        Opts),
                template_request(Template,Msg,[commit(Commit),
                                               username(User) |
                                              Opts
                                              ]),
                %debug(ontol_rest,'  qt_results=~w~nS: ~w~nM: ~w',[T,S,Msg]),
                emit_page(quickterm_results(T,S,Msg),Params)
            ;   emit_page(quickterm_errors(T,S,Errs),Params))
        ;   debug(ontol_rest,' ( not a commit)',[]),
            emit_page(quickterm(T,S),Params)).


ontol_page_actual([ontology,ID],Params):-
        emit_content_type_text_html,
        preload_ont(ID,Params),
        (   member(search_term=S,Params)
        ->  (   searchterm_entities(S,L)
            ->  emit_page(ontology_filtered(ID,S,L),Params)
            ;   emit_page(noresults(ID,S),Params))
        ;   emit_page(ontology(ID),Params)).

ontol_page_actual([ontology_table,ID],Params):-
        emit_content_type_text_html,
        preload_ont(ID,Params),
        emit_page(ontology_table(ID),Params).

ontol_page_actual([new,Local],Params):-
        concat_atom([S|T],'_',Local),
        concat_atom(T,'_',NewLocal),
        concat_atom([S,NewLocal],':',ID),
        ontol_page_actual([ID],Params).

ontol_page_actual([metadata,ID],Params):-
        emit_content_type_text_html,
        preload_ont(ID,Params),
        %load_bioresource(obo_meta),
        load_bioresource(obo_meta_xp),
        emit_page(ontology_metadata(ID),Params).

ontol_page_actual([tree,Ont],Params):-
        debug(ontol_rest,' params=~w',[Params]),
        emit_content_type_text_html,
        preload_ont(Ont,Params),
        emit_page(ontology_browsable_tree(Ont),Params).

ontol_page_actual([tree,Ont,Open],Params):-
        debug(ontol_rest,' params=~w',[Params]),
        emit_content_type_text_html,
        preload_ont(Ont,Params),
        solutions(P,subclassRT(Open,P),OpenNodes),
        emit_page(ontology_browsable_tree(Ont,OpenNodes),Params).

ontol_page_actual([open_node,ID,DepthA],Params):-
        preload(ID,Params),
        atom_number(DepthA,Depth),
        Depth2 is Depth+1,
        emit_json(browser_subnodes_json(Depth2,ID),Params).

% class expression
ontol_page_actual([open_node,R,ID,DepthA],Params):-
        preload(ID,Params),
        atom_number(DepthA,Depth),
        Depth2 is Depth+1,
        emit_json(browser_subnodes_json(Depth2,R,ID),Params).


ontol_page_actual([query,Ont],Params):-
        debug(ontol_rest,' params=~w',[Params]),
        (   member(query=QA,Params)
        ->  true
        ;   QA=true),
        debug(ontol_rest,' QA=~w',[QA]),
        (   member(select=SA,Params),SA\=''
        ->  true
        ;   SA=QA),
        debug(ontol_rest,' SA=~w',[SA]),
        ontol_page_actual([query,Ont,QA,SA],Params).
ontol_page_actual([query,Ont,QueryAtom,SelectAtom],Params):-
        emit_content_type_text_html,
        debug(ontol_rest,'QueryAtom=~w',[QueryAtom]),
        (   listatom_ids(Ont,Onts)
        ->  forall(member(O1,Onts),preload_ont(O1,Params))
        ;   preload_ont(Ont,Params)),
        sformat(QSA,'all((~w),(~w))',[QueryAtom,SelectAtom]),
        debug(ontol_rest,'QSA=~w',[QSA]),
        catch(atom_to_term(QSA,all(Query,Select),_Bindings),_,(Query=true,Select=true)),
        debug(ontol_rest,'QSA=~w',[Query,Select]),
        %catch(atom_to_term(QueryAtom,Query,_Bindings),_,Query=true),
        %catch(atom_to_term(SelectAtom,Select,_Bindings),_,Select=true),
        debug(ontol_rest,'Query=~w',[Query]),
        (   safe(Query)
        ->  (   catch(findall(Select,Query,Results),E,fail)
            ->  emit_page(ontology_query(Ont,QueryAtom,Results),Params)
            ;   emit_page(ontology_query(Ont,QueryAtom,[query_failed(E)]),Params))
        ;   emit_page(ontology_query(Ont,QueryAtom,[unsafe_query(Query)]),Params)).



ontol_page_actual([xps,S],Params):-
        emit_content_type_text_html,
        preload_ont_plus_dependencies(S,Params),
        emit_page(xps(S),Params).

ontol_page_actual([statements,S],Params):-
        emit_content_type_text_html,
        preload_ont(S,Params),
        %preload_ont_plus_dependencies(S,Params),
        emit_page(ontology_statements(S),Params).

ontol_page_actual([relationships,Ont,R],Params):-
        emit_content_type_text_html,
        preload_ont(Ont,Params),
        emit_page(ontology_relationships(Ont,R),Params).


write_obo(ID,Params):-
        write_fmt(ID,obo,Params).

write_fmt(IDListAtom,Fmt,Params):-
	listatom_ids(IDListAtom,IDs),
	!,
	forall(member(ID,IDs),
	       preload(ID,Params)),
        (   member(rel=all,Params)
        ->  Opts=[relations([])]
        ;   findall(Rel,member(rel=Rel,Params),Rels),
            Opts=[relations([subclass|Rels])]),
        debug(ontol_rest,'Opts=',[Opts]),
        ontology_segment(IDs,Edges,_,Opts),
        blipkit_ontol:show_ontol_subset_by_edges(Fmt,Edges,Opts).

write_fmt(ID,Fmt,Params):-
        preload(ID,Params),
        (   member(rel=all,Params)
        ->  Opts=[relations([])]
        ;   findall(Rel,member(rel=Rel,Params),Rels),
            Opts=[relations([subclass|Rels])]),
        debug(ontol_rest,'Opts=',[Opts]),
        ontology_segment([ID],Edges,_,Opts),
        blipkit_ontol:show_ontol_subset_by_edges(Fmt,Edges,Opts).


emit_page(Page,Params):-
        user:consult(bio(ontol_webpages)),
        % X=xml([]),
        write_sterm(Params,Page).

emit_json(Page,Params):-
        user:consult(bio(ontol_webpages)),
        emit_content_type('application/json'),
        write_sterm(Params,xml([]),Page).

load_mods:-
        serval:ensure_loaded(bio(metadata_db)),
        serval:ensure_loaded(bio(ontol_db)).

soft_redirect(From,To):-
        \+ class(From),
        parse_id_idspace(From,_,Name),
        format(user_error,'Q: ~w~n',[Name]),
        entity_label(To,Name).


redirect(ID,'301 Moved Permanently',URL):-
        entity_obsolete(ID,_),
        (   entity_replaced_by(ID,X)
        ;   entity_consider(ID,X)),
        id_url(X,URL).

fmt_ct_exec(owl,'text/xml',go2owl).
fmt_ct_exec(owl2,'text/xml','blip.local io-convert -to owl2 -f obo -u ontol_bridge_to_owl2_and_iao -i').
fmt_ct_exec(obox,'text/xml',go2xml).
fmt_ct_exec(chado,'text/xml',go2chadoxml).

atom_alphanumeric(In,Alpha) :-
        downcase_atom(In,Dn),
        atom_chars(Dn,Chars),
        findall(Char,
                (   member(Char,Chars),
                    (   (   Char@>='a',Char@=<'z')
                    ;   (   Char@>='0',Char@=<'9'))),
                AlphaChars),
        atom_chars(Alpha,AlphaChars).



/** <module> 

  ---+ Synopsis

==
:- use_module(bio(ontol_restful)).

% 
demo:-
  nl.
  

==

---+ Details



---+ Additional Information

This module is part of blip. For more details, see http://www.blipkit.org

@author  Chris Mungall
@version $Revision$
@see     README
@license License


*/
