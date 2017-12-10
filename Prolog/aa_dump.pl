:- use_module(library(xpath)).
:- use_module(library(sgml)).

:- dynamic protein_table_page/1.

wiki_protein_table_capture :-
    (   protein_table_page(P)
    ->  true
    ;   load_xml('https://en.wikipedia.org/wiki/Proteinogenic_amino_acid', [P], []),
        assertz(protein_table_page(P))
    ),

    xpath(P, //table(@class='wikitable sortable'), Table),
    forall(xpath(Table, //tr, Tr), (
        xpath_chk(Tr, th(text), LongName),
        xpath_chk(Tr, td(1,text), Short),
        xpath_chk(Tr, td(2,text), Code),
        format('~q.~n', protein(LongName,Short,Code))
        ; true
    )).