% ----------------------------------------
% ontol_biosources_local
% ----------------------------------------
% this configuration should be used if you wish to use
% locally checked out versions of all ontologies.

:- [ontol_bioresources_shared].

:- multifile bioresource/2,bioresource/3,bioresource/4.



% assume that there is a common root directory
% in which all ontologies are checked out from
% cvs/svn/git.
% on my machine this is called ~/cvs/, but
% you can override this or make a symlink
user:file_search_path(local, Path) :-
	(   getenv('BLIP_LOCAL', Path)
	->  true
	;   getenv('HOME',HOME),
            concat_atom([HOME,'/','cvs'],Path)).

% ----------------------------------------
% GO
% ----------------------------------------
% assume go is checked out from geneontology.org cvs
% default location is $BLIP_LOCAL/go (~/cvs/go)

user:file_search_path(go, GO) :-
	(getenv('GO_HOME', GO)
	->  true
        ;   GO=local(go)).

user:file_search_path(go_gene_associations, go('gene-associations')).

% ----------------------------------------
% OBO
% ----------------------------------------
% assume go is checked out from obo.sf.net cvs
% default location is $BLIP_LOCAL/obo (~/cvs/obo)

user:file_search_path(obo_local, OBO) :-
	(getenv('OBO_HOME', OBO)
	->  true
        ;   OBO=local('obo/ontology')).


% --AUTOMATIC EXPANSION--


user:file_search_path(song, local(song)).
user:file_search_path(poc, local('Poc')).
user:file_search_path(planteome, local('Planteome')).
user:file_search_path(obo_download, local('obo/website/utils/obo-all')).
user:file_search_path(obo_metadata_local, local('obo/website/cgi-bin')).
user:file_search_path(pheno, local('phenotype-ontologies/src/ontology')).
user:file_search_path(obo_remote, 'http://purl.org/obo').
user:file_search_path(pir, local(pir)).
user:file_search_path(obol2, home(obol2)).
user:file_search_path(obolr, go(scratch/obol_results)).
user:file_search_path(uberon, local(uberon)).
user:file_search_path(oborel, local('obo-relations')).

% --OBO Ontologies--
user:bioresource(goche,go('ontology/editors/goche.obo'),obo).
user:bioresource(ions,go('ontology/editors/chebi-ion-syns.obo'),obo).
%user:bioresource(go_xp_chebi,home('repos/newgo/ontology/editors/gene_ontology_xp_write.obo'),obo).
user:bioresource(go_validated,home('repos/go/ontology/editors/validated.obo'),obo).
user:bioresource(go_xp,home('repos/go/ontology/editors/gene_ontology_xp_write.obo'),obo).
user:bioresource(go_xp_dev,home('repos/go/ontology/extensions/go-plus-dev-EquivalentClasses.obo'),obo).
user:bioresource(go_uxp,home('repos/go/ontology/editors/uberon-ecas-to-add.obo'),obo).
user:bioresource(go_mg,home('repos/go/ontology/extensions/go-plus-dev-mingraph.obo'),obo).
user:bioresource(oba,home('repos/bio-attribute-ontology/oba.obo'),obo).
user:bioresource(vt,home('repos/bio-attribute-ontology/src/ontology/modules/vt.obo'),obo).
user:bioresource(go_transport,home('repos/go/ontology/extensions/x-transport-and-localization.obo'),obo).
user:bioresource(interpro2go,home('repos/go/external2go/interpro2go'),go_xref).

%user:bioresource(caro,obo_local('anatomy/caro/caro.obo'),obo).
user:bioresource(caro1,home('repos/caro/src/ontology/attic/2011-12-14/caro.obo'),obo).
user:bioresource(caro,home('repos/caro/src/ontology/release/caro.obo'),obo).
user:bioresource(caro2,home('repos/caro/src/ontology/release/caro.obo'),obo).
user:bioresource(aeo,home('repos/human-developmental-anatomy-ontology/src/ontology/aeo.obo'),obo).
user:bioresource(caro_extra,obo_local('anatomy/caro/caro_extra.obo'),obo).
user:bioresource(relationship,obo_local('OBO_REL/ro.obo'),obo).
user:bioresource(ro_proposed,obo_local('OBO_REL/ro_proposed_edit.obo'),obo).
user:bioresource(ro2_owl,oborel('src/ontology/ro.owl'),owl).
user:bioresource(ro,oborel('src/ontology/ro.obo'),obo).
user:bioresource(biological_role,obolr('biological_role.obo'),obo).
user:bioresource(chebi,home('repos/go/ontology/extensions/chebi.obo'),obo).
user:bioresource(so,url('http://purl.obolibrary.org/obo/so.obo'),obo).
user:bioresource(so,song('so-xp.obo'),obo).
user:bioresource(sequence,song('so.obo'),obo). % synonym for SO
user:bioresource(soxp,song('so-xp.obo'),obo).
user:bioresource(so2,song('ontology/working_draft.obo'),obo).
user:bioresource(fpo,song('ontology/fpo/feature_property.obo'),obo).
user:bioresource(genbank_fpo,song('ontology/fpo/genbank_fpo.obo'),obo).
user:bioresource(sofa,song('ontology/sofa.obo'),obo).
user:bioresource(biological_process,obo_download('biological_process/biological_process.obo'),obo).
user:bioresource(go_synonyms,obol2('conf/go_synonyms.obo'),obo).

user:bioresource(chebi_slim,go('scratch/xps/chebi_relslim.obo'),obo).
user:bioresource(chebi_with_formula,go('scratch/obol_results/chebi_with_formula.obo'),obo).
user:bioresource(chego,go('scratch/obol_results/chego.obo'),obo).
user:bioresource(nbo,home('repos/behavior-ontology/nbo.obo'),obo).
%user:bioresource(nbo,local('behavior-ontology-read-only/behavior.obo'),obo).

user:bioresource(monarch,home('repos/monarch-ontology/monarch-merged-nd-reasoned.obo'),obo).

% --Disease--
user:bioresource(omia,home('repos/monarch-disease-ontology/src/omia/omia.obo'),obo).
user:bioresource(omim,home('repos/monarch-disease-ontology/src/omim/omim.obo'),obo).
user:bioresource(dmesh,home('repos/monarch-disease-ontology/src/mondo/mesh.obo'),obo).
user:bioresource(mondo,home('repos/monarch-disease-ontology/src/mondo/mondo.obo'),obo).
user:bioresource(mondoe,home('repos/monarch-disease-ontology/src/mondo/mondoe.obo'),obo).
user:bioresource(ordo,home('repos/monarch-disease-ontology/src/orphanet/orphanet-obostyle.obo'),obo).
user:bioresource(disease,home('repos/monarch-disease-ontology/src/doid/doid.obo'),obo).
user:bioresource('DOID',home('repos/monarch-disease-ontology/src/doid/doid.obo'),obo).

user:bioresource(pw,local('disease-miner/pw.obo'),obo).
user:bioresource(do_bridge,local('disease-miner/all-do-bridge.obo'),obo).
user:bioresource(do_plus,local('disease-miner/merged.obo'),obo).
user:bioresource(disease_stemmed,local('disease/DO_stemmed.pro'),pro,ontol_db).
user:bioresource(disease2gene,url('http://django.nubic.northwestern.edu/fundo/media/data/do_lite.txt'),txt).
user:bioresource(do_rif,url('http://projects.bioinformatics.northwestern.edu/do_rif/do_rif.human.txt'),do_rif).
user:bioresource(domim,home('repos/human-disease-ontology/src/ontology/doid-plus-omim.obo'),obo).
user:bioresource(generif,'/users/cjm/cvs/obo-database/build/build-ncbi-gene/generifs_basic.gz',gzip(gene_rif)).
user:bioresource(ido,obo_cvs('phenotype/infectious_disease.obo'),obo).
user:bioresource(icd9,home('repos/icd9/icd9.obo'),obo).
user:bioresource(medic,url('http://ctdbase.org/reports/CTD_diseases.obo.gz'),gzip(obo)).
user:bioresource(mgi_g2p,local('monarch-owlsim-data/data/Mus_musculus/Mm-gene-to-phenotype-BF.txt'),tbl(g2p)).

user:bioresource(ceph,home('repos/cephalopod-ontology/src/ontology/ceph.obo'),obo).
user:bioresource(spatial,home('repos/biological-spatial-ontology/src/ontology/bspo.obo'),obo).
user:bioresource(poro,home('repos/porifera-ontology/src/ontology/poro.obo'),obo).

user:bioresource(exo,home('repos/exo/src/ontology/exo.obo'),obo).

%user:bioresource(cell,home('repos/cell-ontology/src/ontology/cl-edit.obo'),obo).
user:bioresource(cell,home('repos/cell-ontology/src/ontology/cl.obo'),obo).
user:bioresource(cellb,home('repos/cell-ontology/src/ontology/cl-basic.obo'),obo).
user:bioresource('CL',home('repos/cell-ontology/src/ontology/cl.obo'),obo).
user:bioresource(hemo_CL,obo_local('anatomy/cell_type/hemo_CL.obo'),obo).
user:bioresource(cdo,obo_local('anatomy/cell_type/cdo.obo'),obo).
user:bioresource(cell2,obo_local('anatomy/cell_type/cell_cjm.obo'),obo).
user:bioresource(evoc_cell,obo_local('anatomy/cell_type/evoc_cell.obo'),obo).
user:bioresource('PO',poc('ontology/OBO_format/plant_ontology.obo'),obo).
user:bioresource(plant_anatomy_xp,poc('ontology/OBO_format/po_anatomy_xp.obo'),obo).
user:bioresource(plant_development,poc('ontology/OBO_format/po_temporal.obo'),obo).
%user:bioresource(plant_environment,obo_download('plant_environment/plant_environment.obo'),obo).
user:bioresource(plant_environment,poc('ontology/collaborators_ontology/plant_environment/environment_ontology.obo'),obo).
%user:bioresource(eo,poc('ontology/collaborators_ontology/plant_environment/environment_ontology.obo'),obo).
user:bioresource(po,planteome('plant-ontology/plant-ontology.obo'),obo).
user:bioresource(pdo,planteome('plant-stress-ontology/plant-disease-ontology.obo'),obo).
user:bioresource(plant,planteome('plant-ontology/plant-ontology.obo'),obo).
user:bioresource(plant_anatomy,planteome('plant-ontology/plant-ontology.obo'),obo).
user:bioresource(plant_trait,planteome('plant-trait-ontology/plant-trait-ontology.obo'),obo).
user:bioresource(to,planteome('plant-trait-ontology/plant-trait-ontology.obo'),obo).
user:bioresource(eo,planteome('plant-environment-ontology/plant-environment-ontology.obo'),obo).
user:bioresource(plant_trait_xp,poc('ontology/collaborators_ontology/gramene/traits/trait_xp.obo'),obo).
user:bioresource(zeco,home('repos/ZFIN-scratch/zeco.obo'),obo).
user:bioresource(pato,home('repos/pato/src/ontology/pato-edit.obo'),obo).
user:bioresource(feed,home('repos/feedontology-read-only/feed.obo'),obo).
user:bioresource(miro,obo_local('phenotype/mosquito_insecticide_resistance.obo'),obo).
user:bioresource(unit,obo_local('phenotype/unit.obo'),obo).
%user:bioresource('MPATH',obo_local('phenotype/mouse_pathology/mouse_pathology.obo'),obo).
%user:bioresource(mpath,obo_local('phenotype/mouse_pathology/mouse_pathology.obo'),obo).
user:bioresource(mpath,url('http://purl.obolibrary.org/obo/mpath.obo'),obo).
user:bioresource(taxrank,url('http://purl.obolibrary.org/obo/taxrank.obo'),obo).
%user:bioresource('MP',obo_local('phenotype/mammalian_phenotype.obo'),obo).
%user:bioresource(mammalian_phenotype,obo_local('phenotype/mammalian_phenotype.obo'),obo).
user:bioresource(mammalian_phenotype,home('repos/mammalian-phenotype-ontology/src/ontology/mp.obo'),obo).
user:bioresource('MP',home('repos/mammalian-phenotype-ontology/src/ontology/mp.obo'),obo).
user:bioresource(ascomycete_phenotype,obo_local('phenotype/ascomycete_phenotype.obo'),obo).
user:bioresource('APO',obo_local('phenotype/ascomycete_phenotype.obo'),obo).
user:bioresource(symp,url('http://purl.obolibrary.org/obo/symp.obo'),obo).
user:bioresource(clo,home('src/ontologies/clo.obo'),obo).
user:bioresource('HP',home('repos/human-phenotype-ontology/src/ontology/hp.obo'),obo).
user:bioresource(human_phenotype,home('repos/human-phenotype-ontology/src/ontology/hp.obo'),obo).
user:bioresource(hp_xp,home('repos/human-phenotype-ontology/src/ontology/subsets/hp-ldefs.obo'),obo).
user:bioresource(mp_xp,home('repos/mammalian-phenotype-ontology/src/ontology/subsets/mp-ldefs.obo'),obo).
user:bioresource(zp,home('repos/upheno/zp.obo'),obo).
%user:bioresource('HP',home('repos/phenotype-ontologies/src/ontology/hp/hp.obo'),obo).
%user:bioresource(hp_xp_all,obo_local('phenotype/human_phenotype_xp/human-phenotype-ontology_xp-merged.obo'),obo).
user:bioresource(genetic_context,obo_local('phenotype/genetic_context.obo'),obo).
user:bioresource(rkc,obo_local('phenotype/phenotype_xp/rkc.obo'),obo).
user:bioresource(yeast_phenotype,obo_local('phenotype/yeast_phenotype.obo'),obo).
user:bioresource(evidence_code,home('repos/evidenceontology/eco.obo'),obo).
%user:bioresource(obi,url('http://purl.obofoundry.org/obo/obi.owl'),owl).
%user:bioresource(obi,obo(obi),obo).
user:bioresource(brenda,url('http://purl.obolibrary.org/obo/bto.obo'),obo).
user:bioresource(fypo,url('http://purl.obolibrary.org/obo/fypo.obo'),obo).

user:bioresource(iao_om,url('http://purl.obolibrary.org/obo/iao/dev/ontology-metadata.owl'),owl).

user:bioresource(gene(Tax),home(Path),obo) :- sformat(Path,'repos/neo/neo-~w.obo',[Tax]).
user:bioresource(neo,home('repos/neo/neo.obo'),obo).

user:bioresource(mod(wb),Path,obo) :- user:bioresource(mod('Caenorhabditis_elegans'),Path,obo),!.

user:bioresource(mod(Sp),home(Path),obo) :- sformat(Path,'repos/omeo/build/~w-MOD.obo',[Sp]).
user:bioresource(omeo(Sp),home(Path),obo) :- sformat(Path,'repos/omeo/build/~w.obo',[Sp]).
user:bioresource(omeoc(Sp),home(Path),obo) :- sformat(Path,'repos/omeo/build/~w.obo',[Sp]).
user:bioresource(mart(M),home(Path),obo) :- sformat(Path,'repos/omeo/build/~w.mart',[M]).
user:bioresource(hsap(X),home(Path),obo) :- sformat(Path,'repos/omeo/build/Homo_sapiens-~w.obo',[X]).

user:bioresource(ibp(X),home(Path),obo) :- sformat(Path,'repos/Planteome/ibp-~w-traits/~w-trait-ontology.obo',[X,X]).

%user:bioresource(gotax,'/users/cjm/cvs/go/quality_control/annotation_checks/taxon_checks/taxon_go_triggers.obo',obo).
%user:bioresource(taxunion,'/users/cjm/cvs/go/quality_control/annotation_checks/taxon_checks/taxon_union_terms.obo',obo).
%user:bioresource(taxunionm,'/users/cjm/cvs/go/quality_control/annotation_checks/taxon_checks/taxon_union_materialized.obo',obo).

user:bioresource(taxonomy,home('repos/ncbitaxon/ncbitaxon.obo'),obo).
user:bioresource(ncbitaxon,home('repos/ncbitaxon/ncbitaxon.obo'),obo).
user:bioresource(taxslim,home('repos/ncbitaxon/subsets/taxslim.obo'),obo).
user:bioresource(eolmap,home('repos/ncbitaxon/mappings/ncbitaxon-to-eol.obo'),obo).
%user:bioresource(taxonomy_stemmed,ontdir('ncbi_taxonomy_stemmed.obo'),obo).

% XP
user:bioresource(pheno_align,pheno('hp-mp/mp_hp-align-equiv.obo'),obo).
%user:bioresource(mammalian_phenotype_xp,pheno('mp/mp-equivalence-axioms.obo'),obo).
%user:bioresource(mpx,pheno('mp/mp-edit-mn.obo'),obo).
%user:bioresource(mammalian_phenotype_xp_nif,obo_local('phenotype/mammalian_phenotype_xp/mammalian_phenotype_xp_nif.obo'),obo).
%user:bioresource(mammalian_phenotype_xp_uberon,obo_local('phenotype/mammalian_phenotype_xp/mammalian_phenotype_xp_uberon.obo'),obo).
user:bioresource(mp_xp_all,obo_local('phenotype/mammalian_phenotype_xp/mammalian_phenotype_xp-merged.obo'),obo).
user:bioresource(worm_phenotype_xp,obo_local('phenotype/worm_phenotype_xp.obo'),obo).
%user:bioresource(ro_ucdhsc,obo_local('cross_products/go_chebi_xp/ro_ucdhsc.obo'),obo).
user:bioresource(upheno,pheno('upheno.obo'),obo).


% UBERPHENO
user:bioresource(hp_mp,obo_local('phenotype/phenotype_xp/uberpheno/mp_hp-align-equiv.obo'),obo).
%user:bioresource(upheno,obo_local('phenotype/phenotype_xp/uberpheno/uberpheno-basic.obo'),obo).
%user:bioresource(upheno_full,obo_local('phenotype/phenotype_xp/uberpheno/uberpheno-full.obo'),obo).


user:bioresource(go_xp_all,'/users/cjm/cvs/go/scratch/xps/go_xp_all-merged.obo',obo).
user:bioresource(cc_xp_self,'/users/cjm/cvs/go/scratch/xps/cellular_component_xp_self-imports.obo',obo).

% --Relations hack--
%   part_of etc are in their own idspace
user:bioresource(flat_relations,local('flat_relations.obo'),obo).

user:bioresource(cfg,url('http://ontology.dumontierlab.com/cfg'),owl).

% --Anatomical Ontologies--
%user:bioresource(fma,local('FMA/fma_obo.obo'),obo).
%user:bioresource(fma_with_has_part,local('fma-conversion/fma_obo.obo'),obo).
%user:bioresource(fma,local('fma-conversion/fma2.obo'),obo).
%user:bioresource(fma_simple,local('fma-conversion/fma2-simple.obo'),obo).
%user:bioresource('FMA',local('fma-conversion/fma2-simple.obo'),obo).
user:bioresource('FMA',uberon('source-ontologies/fma-official.obo'),obo).
%user:bioresource(fma2,local('fma-conversion/fma2.obo'),obo). % NOW DEFAULT
%user:bioresource(fma3,local('fma-conversion/fma3.obo'),obo).
%user:bioresource(fma3h,local('fma-conversion/bioonto.de/fma1_obo-ontol_db.pro'),ontol_db:pro).
%user:bioresource(fma1,local('fma-conversion/fma-part-slim.obo'),obo).
%user:bioresource(fma,local('obo-database/conf/fma-part-slim.obo'),obo).
%user:bioresource(fma_downcase,local('fma-conversion/fma_downcase.obo'),obo).
user:bioresource(fma_downcase,uberon('source-ontologies/fma-official.obo'),obo).
%user:bioresource(fma_stemmed,local('FMA/fma_obo_stemmed.obo'),obo).
user:bioresource(rad1,uberon('rad.obo'),obo).
user:bioresource(rad,uberon('Chick_Merge_2013-01-29.obo'),obo).
user:bioresource(bgee_stages,uberon('stages.obo'),obo).
%user:bioresource(efo,url('http://sourceforge.net/p/efo/code/HEAD/tree/trunk/src/efoinobo/efo.obo'),obo).
user:bioresource(efo,uberon('source-ontologies/efo.obo'),obo).
user:bioresource(efo_anat,uberon('efo_anat.obo'),obo).
user:bioresource(coriell,'http://efo.svn.sourceforge.net/viewvc/efo/trunk/src/coriellinowl/coriell_release.owl',owl).
user:bioresource(hao,local('obo-svn/ontologies/trunk/HAO/hao.obo'),obo).
user:bioresource('HAO',local('obo-svn/ontologies/trunk/HAO/hao.obo'),obo).
user:bioresource(vhog,uberon('vHOG.obo'),obo).
user:bioresource(vhog_assoc,uberon('organ_association_vHOG.txt'),tbl(assoc)).
user:bioresource(hog,url('http://bgee.unil.ch/bgee/download/HOG.obo'),obo).
user:bioresource(hog_stages,url('http://bgee.unil.ch/bgee/download/stages.obo'),obo).
user:bioresource(caloha_orig,url('ftp://ftp.nextprot.org/pub/current_release/controlled_vocabularies/caloha.obo'),obo).
user:bioresource(caloha,uberon('xcaloha.obo'),obo).

user:bioresource(fungal_anatomy,obo_local('anatomy/gross_anatomy/microbial_gross_anatomy/fungi/fungal_anatomy.obo'),obo).
user:bioresource(tick_anatomy,uberon('source-ontologies/tick_anatomy_with_syns.obo'),obo).
user:bioresource('BSA',uberon('source-ontologies/bsa.obo'),obo).
user:bioresource('TADS',uberon('source-ontologies/tick_anatomy_with_syns.obo'),obo).
user:bioresource(flytest,'/Users/cjm/tmp/NB_CARO_dev.obo',obo).
user:bioresource(fly_anatomy,home('repos/fbbtdv/fbbt/releases/fbbt.obo'),obo).
user:bioresource('FBbt',home('repos/fbbtdv/fbbt/releases/fbbt.obo'),obo).
%user:bioresource('FBbt',url('http://purl.obolibrary.org/obo/fbbt.obo'),obo).
%user:bioresource('FBbt',obo_local('anatomy/gross_anatomy/animal_gross_anatomy/fly/fly_anatomy.obo'),obo).
user:bioresource(fly_anatomy_xp,obo_local('anatomy/gross_anatomy/animal_gross_anatomy/fly/fly_anatomy_XP.obo'),obo).
user:bioresource(fly_development,obo_local('developmental/animal_development/fly/fly_development.obo'),obo).
user:bioresource(worm_development,home('repos/Life-stage-obo/worm_development.obo'),obo).
user:bioresource('WBls',home('repos/Life-stage-obo/worm_development.obo'),obo).
user:bioresource(mosquito_anatomy,url('http://purl.obolibrary.org/obo/tgma.obo'),obo).
user:bioresource('TGMA',obo_local('anatomy/gross_anatomy/animal_gross_anatomy/mosquito_anatomy.obo'),obo).
user:bioresource(ehdaa,obo_local('anatomy/gross_anatomy/animal_gross_anatomy/human/human-dev-anat-abstract.obo'),obo).
user:bioresource('EHDAA',obo_local('anatomy/gross_anatomy/animal_gross_anatomy/human/human-dev-anat-abstract.obo'),obo).
user:bioresource(ehdaa2,home('repos/human-developmental-anatomy-ontology/src/ontology/ehdaa2.obo'),obo).
user:bioresource('EHDAA2',home('repos/human-developmental-anatomy-ontology/src/ontology/ehdaa2.obo'),obo).
user:bioresource(adult_mouse,obo_local('anatomy/gross_anatomy/animal_gross_anatomy/mouse/adult_mouse_anatomy.obo'),obo). % synonym
user:bioresource(mouse_anatomy,uberon('local-ma.obo'),obo).
user:bioresource('MA',uberon('local-ma.obo'),obo).
user:bioresource(emap,obo_local('anatomy/gross_anatomy/animal_gross_anatomy/mouse/EMAP.obo'),obo).
user:bioresource('EMAPA',home('repos/mouse-anatomy-ontology/src/ontology/emapa-edit.obo'),obo).
%user:bioresource('EMAPA',home('repos/mouse-anatomy-ontology/src/ontology/emapa-edit.obo'),obo).
%user:bioresource('EMAPA_ubr',uberon('source-ontologies/emapa.obo'),obo).
%user:bioresource('EMAPA_old',obo_local('anatomy/gross_anatomy/animal_gross_anatomy/mouse/EMAPA.obo'),obo).
%user:bioresource(emapa_old,obo_local('anatomy/gross_anatomy/animal_gross_anatomy/mouse/EMAPA.obo'),obo).
%user:bioresource(emapaa_remainder,uberon('emapaa-remainder.obo'),obo).
%user:bioresource(emapaa,uberon('emapaa.obo'),obo).
%user:bioresource(ehdaaa,uberon('ehdaaa.obo'),obo).
user:bioresource(cmetazoan,uberon('composite-metazoan.obo'),obo).
user:bioresource(neuronames,uberon('source-ontologies/NeuroNames.obo'),obo).
user:bioresource(spider_anatomy,url('http://purl.obolibrary.org/obo/spd.obo'),obo).
user:bioresource('SPD',obo_local('anatomy/gross_anatomy/animal_gross_anatomy/spider/spider_comparative_biology.obo'),obo).
user:bioresource(zebrafish_anatomy_public,obo_local('anatomy/gross_anatomy/animal_gross_anatomy/fish/zebrafish_anatomy.obo'),obo).
user:bioresource('ZFA',home('repos/zebrafish-anatomical-ontology-read-only/src/zebrafish_anatomy.obo'),obo).
%user:bioresource(zebrafish_anatomy,obo_local('anatomy/gross_anatomy/animal_gross_anatomy/fish/preversion.zfish.obo'),obo).
user:bioresource(zebrafish_anatomy,home('repos/zebrafish-anatomical-ontology-read-only/src/preversion.zfish.obo'),obo).
user:bioresource(zebrafish_stages,obo_local('anatomy/gross_anatomy/animal_gross_anatomy/fish/zebrafishstages.obo'),obo).
user:bioresource(hsapdv,home('repos/developmental-stage-ontologies/src/hsapdv/hsapdv.obo'),obo).
user:bioresource(mmusdv,home('repos/developmental-stage-ontologies/src/mmusdv/mmusdv.obo'),obo).
user:bioresource('ZFS',home('repos/developmental-stage-ontologies/src/zfs/zfs.obo'),obo).
%user:bioresource('ZFS',obo_local('anatomy/gross_anatomy/animal_gross_anatomy/fish/zebrafishstages.obo'),obo).
user:bioresource(tao_edit,uberon('phenoscape-vocab/teleost_anatomy_VAO_edit.obo'),obo).
%user:bioresource(teleost_anatomy,obo_local('anatomy/gross_anatomy/animal_gross_anatomy/fish/teleost_anatomy.obo'),obo).
%user:bioresource('TAO',obo_local('anatomy/gross_anatomy/animal_gross_anatomy/fish/teleost_anatomy.obo'),obo).
user:bioresource(teleost_anatomy,uberon('phenoscape-vocab/teleost_anatomy_VAO_edit.obo'),obo).
user:bioresource('TAO',uberon('phenoscape-vocab/teleost_anatomy_VAO_edit.obo'),obo).
user:bioresource(teleost_taxonomy,obo_local('taxonomy/teleost_taxonomy.obo'),obo).
user:bioresource(pext,url('http://purl.obolibrary.org/obo/uberon/phenoscape-ext-simple.obo'),obo).

user:bioresource(xenopus_anatomy,URL,Fmt) :- user:bioresource('XAO',URL,Fmt).
user:bioresource('XAO',home('repos/xenopus-anatomy-ontology-read-only/src/ontology/xenopus_anatomy_edit.obo'),obo).
user:bioresource(bao,obo_local('anatomy/gross_anatomy/animal_gross_anatomy/fish/BAO_BTO.obo'),obo).
user:bioresource(medaka_anatomy,obo_local('anatomy/gross_anatomy/animal_gross_anatomy/fish/medaka_ontology.obo'),obo).

user:bioresource(full_galen,url('http://www.co-ode.org/galen/full-galen.owl'),owl).
%user:bioresource(galen,url('http://www.cs.man.ac.uk/~horrocks/OWL/Ontologies/galen.owl'),owl).
%user:bioresource(galen,obo_local('scratch/full-galen-with-names.obo'),obo).
user:bioresource(murdoch,uberon('murdoch.obo'),obo).
user:bioresource(galen,uberon('source-ontologies/galen.obo'),obo).
user:bioresource(mesh,uberon('mesh.obo'),obo).
user:bioresource(vao,home('repos/phenoscape/vocab/skeletal/obo/vertebrate_anatomy_edit.obo'),obo).
user:bioresource(vsao,home('repos/phenoscape/vocab/skeletal/obo/vertebrate_skeletal_anatomy.obo'),obo).
user:bioresource(amniote,home('repos/phenoscape/vocab/amniote_draft.obo'),obo).
user:bioresource(snomed_anatomy,home('repos/snomed/snomed-anat.obo'),obo).
user:bioresource(snomed_disorder,home('repos/snomed/snomed-disorder.obo'),obo).
user:bioresource(snomed_tidy,home('repos/snomed/snomed-tidy.obo'),obo).
user:bioresource(sctid,home('repos/snomed/snomed-tidy.obo'),obo).


user:bioresource(worm_anatomy,home('repos/Wao/WBbt.obo'),obo).
user:bioresource('WBbt',home('repos/Wao/WBbt.obo'),obo).
%user:bioresource(worm_anatomy,[obo('worm_anatomy')]).
user:bioresource(worm_phenotype,url('http://tazendra.caltech.edu/~azurebrd/cgi-bin/forms/phenotype_ontology_obo.cgi'),obo).

user:bioresource(dicty_anatomy,home('repos/dictyBase/migration-data/ontologies/dicty_anatomy.obo'),obo).
user:bioresource(ddanat,home('repos/dictyBase/migration-data/ontologies/dicty_anatomy.obo'),obo).
user:bioresource(ddpheno,home('repos/dictyBase/migration-data/ontologies/dicty_phenotypes.obo'),obo).
user:bioresource(fungal_anatomy,obo_local('anatomy/gross_anatomy/microbial_gross_anatomy/dictyostelium/dictyostelium_anatomy.obo'),obo).
user:bioresource(uext,uberon('ext.obo'),obo).
user:bioresource(cyc,uberon('opencyc2.obo'),obo).
user:bioresource(sao_obo,uberon('sao.obo'),obo).
user:bioresource(sao,url('http://ccdb.ucsd.edu/SAO/1.2/SAO.owl'),owl).
user:bioresource(birndo,url('http://ccdb.ucsd.edu/SAO/PDPO/2.0/HumanPDPO.owl'),owl).
user:bioresource(birndpo,url('http://ccdb.ucsd.edu/SAO/DPO/1.0/DPO.owl'),owl).
user:bioresource(birnimg,url('http://ccdb.ucsd.edu/SAO/DPO/1.0/ImagePhenotype.owl'),owl).
%user:bioresource(nif,url('http://purl.org/nif/ontology/nif.owl'),owl).
user:bioresource(birnall,home('OBDAPI/conf/obd-birn/PKB_all.obo'),obo).
user:bioresource(pkb,home('repos/OBD-PKB/PKB.obo'),obo).
%user:bioresource(nif_downcase,home('repos/OBD-PKB/PKB_dn.obo'),obo).

user:bioresource(birnlex_anatomy,url('http://birnlex.nbirn.net/ontology/BIRNLex-Anatomy.owl'),owl).
user:bioresource(birnlex_anatomy_obo,uberon('birnlex_anatomy.obo'),obo).
user:bioresource(birnlex,url('http://purl.org/nbirn/birnlex'),owl).

user:bioresource(nif_anatomy_owl,url('http://nif.nbirn.net/ontology/NIF-Anatomy.owl'),owl).
user:bioresource(nif_anatomy,uberon('source-ontologies/NIF-GrossAnatomy.obo'),obo).
user:bioresource('NIFGA',uberon('source-ontologies/NIF-GrossAnatomy.obo'),obo).
user:bioresource(nlxa,home('repos/nlx-pl/nlx-ns-part-dn.obo'),obo).
user:bioresource(nlxn,home('repos/nlx-pl/nlx-neuron-dn.obo'),obo).
user:bioresource(nlxc,home('repos/nlx-pl/nlx-cell-dn.obo'),obo).
user:bioresource(nlx,home('repos/nlx-pl/nlx-owl-dn.obo'),obo).
user:bioresource(dmba,uberon('source-ontologies/allen-dmba.obo'),obo).
user:bioresource(hba,uberon('source-ontologies/allen-hba.obo'),obo).
user:bioresource(dhba,uberon('source-ontologies/allen-dhba.obo'),obo).
user:bioresource(pba,uberon('source-ontologies/allen-pba.obo'),obo).
user:bioresource(mba,uberon('source-ontologies/allen-mba.obo'),obo).
user:bioresource(aba,uberon('source-ontologies/allen-mba.obo'),obo).
user:bioresource('ABA',uberon('source-ontologies/allen-mba.obo'),obo).
user:bioresource(cmbn,uberon('source-ontologies/common-mammalian-nomencl-structural.obo'),obo).
user:bioresource(bm,uberon('BM.obo'),obo).
user:bioresource(bams,uberon('brain/bams-obo.obo'),obo).
user:bioresource(ubrain,uberon('subsets/nervous-minimal.obo'),obo).
%user:bioresource('NIF_GrossAnatomy',uberon('nif_anatomy.obo'),obo).
user:bioresource('NIF_Cell',uberon('nif_cell.obo'),obo).

user:bioresource(fly2fma,uberon('fly-to-fma-homology.obo'),obo).
user:bioresource(zf2fma,uberon('zfa-to-fma-homology.obo'),obo).
user:bioresource(mouse2fma,uberon('ma-to-fma-homology.obo'),obo).
user:bioresource(miaa,uberon('source-ontologies/MIAA.obo'),obo).
user:bioresource(bila,X,obo):-
        bioresource(obo(bila),X,obo).
user:bioresource(amphibian_anatomy,uberon('aao-fixed.obo'),obo).
user:bioresource('AAO',uberon('aao-fixed.obo'),obo).
%user:bioresource('AAO',home('repos/aao/AAO_v2.1.obo'),obo).
%user:bioresource('AAO',X,obo):- bioresource(obo(amphibian_anatomy),X,obo).
user:bioresource(uberon,uberon('uberon_edit.obo'),obo).
user:bioresource(uberon_closure,uberon('uberon_closure-ontol_db.pro'),ontol_db:pro).
user:bioresource(uberonp,uberon('uberon.obo'),obo).  % now merged
user:bioresource(uberonm,uberon('uberon-merged.obo'),obo).
user:bioresource(uberon_merged,uberon('merged.obo'),obo). % DEPRECATED
user:bioresource(uberons,uberon('basic.obo'),obo).
user:bioresource(uber_anatomy,uberon('uberon.obo'),obo).
user:bioresource(uberon_with_isa,uberon('uberon_edit-with-isa.obo'),obo).
user:bioresource(uberonp_with_isa,uberon('uberon-with-isa.obo'),obo).
user:bioresource(uberonp_v,uberon('uberon-with-isa-for-FMA-MA-ZFA.obo'),obo).
user:bioresource(wpanat,uberon('dbpedia/dbpedia_ontol.obo'),obo).
user:bioresource(ta,uberon('source-ontologies/ta.obo'),obo).
user:bioresource(mesh_anatomy,uberon('source-ontologies/mesh_anatomy.obo'),obo).
user:bioresource(ascidian_anatomy,uberon('ciona/ascidian.obo'),obo).
user:bioresource('ANISEED',uberon('ciona/ascidian.obo'),obo).
user:bioresource(geisha,uberon('kb/geisha.obo'),obo).

user:bioresource(gemina_anatomy,url('http://gemina.svn.sourceforge.net/viewvc/gemina/trunk/Gemina/ontologies/gemina_anatomy.obo'),obo).


% --Protein--
%user:bioresource(protein,[obo(protein)]).
%user:bioresource('PRO',obo_local('genomic-proteomic/pro.obo'),obo).
user:bioresource('PRO',url('http://purl.obolibrary.org/obo/pr.obo'),obo).
user:bioresource(protein,url('http://purl.obolibrary.org/obo/pr.obo'),obo).
user:bioresource(pro_wv,url('http://pir.georgetown.edu/projects/pro/pro_wv.obo'),obo).
user:bioresource(psimod,obo_local('genomic-proteomic/protein/psi-mod.obo'),obo).
user:bioresource(psimi,obo_local('genomic-proteomic/protein/psi-mi.obo'),obo).
user:bioresource(pro2uniprot_tbl,url('ftp://ftp.pir.georgetown.edu/databases/ontology/pro_obo/PRO_mappings/uniprotmapping.txt'),tbl).
user:bioresource(pro2uniprot,'/users/cjm/cvs/go/scratch/xps/pro2uniprot.obo',obo).
user:bioresource(unipro,home('repos/omeo/build/unipro.obo'),obo).


% --Env--
user:bioresource(envo,home('repos/envo/src/envo/envo.obo'),obo).
user:bioresource(gaz,home('repos/envo/src/gaz/gaz.obo'),obo).
%user:bioresource(gaz,obo_local('environmental/gaz.obo'),obo).
%user:bioresource(gaz2,obo_local('environmental/gaz2.obo'),obo).

user:bioresource(gemet,home('repos/sdgio/scratch/gemet-full.obo'),obo).
user:bioresource(agrovoc,home('repos/agrovoc-obo/agrovoc.obo'),obo).

user:bioresource(realm,home('repos/envo/src/envo/sources/realm.obo'),obo).
user:bioresource(earth,home('repos/envo/src/envo/sources/earth.obo'),obo).

user:bioresource(npo,home('repos/npo/npo.obo'),obo).
user:bioresource(exposure,home('repos/exposure-ontology/Exposure.obo'),obo).
user:bioresource(mre,home('repos/exposure-ontology/Exposure.obo'),obo).
user:bioresource(ecto,home('repos/environmental-conditions-and-exposures/src/ontology/ecto.obo'),obo).

% --Upper Ontologies--
user:bioresource(ubo,obo_local('upper_bio_ontology/ubo.obo'),obo).
%user:bioresource(bfo,obo_cvs('upper_bio_ontology/bfo.obo'),obo).
user:bioresource(bfo,[obo(bfo)]).
user:bioresource(bfo2_obo,home('repos/bfo/src/ontology/owl-ruttenberg/bfo2-classes.obo'),obo).
user:bioresource(bfo2_owl,home('repos/bfo/src/ontology/owl-ruttenberg/bfo2-classes.owl'),owl).
user:bioresource(bfo2_rel_obo,home('repos/bfo/src/ontology/bfo2-relations.obo'),obo).
user:bioresource(bfo2_rel_owl,home('repos/bfo/src/ontology/bfo2-relations.owl'),owl).
user:bioresource(dolcelite,ontdir('upper/DolceLite/DOLCE-Lite_397.owl'),owl).
user:bioresource(sumo,ontdir('upper/SUMO/SUMO.owl'),owl).
user:bioresource(sumo_pro,ontdir('upper/SUMO/SUMO.pro'),pro,ontol_db).
user:bioresource(opencyc,ontdir('upper/opencyc.owl'),owl).
user:bioresource(biotop,url('http://www.ifomis.org/biotop/biotop.owl'),owl).

% --Non-Bio Ontologies--
user:bioresource(wine,ontdir('wine.owl'),owl).
user:bioresource(bible,ontdir('NTNames.owl'),owl).
user:bioresource(food,ontdir('food.owl'),owl).
user:bioresource(koala,ontdir('koala.owl'),owl).

% --Other Bio-Ontologies--
user:bioresource(rex,obo_download('rex/rex.obo'),obo).
user:bioresource(neoplasm,url('http://build.berkeleybop.org/job/ncit-obo/lastStableBuild/artifact/build/subsets/neoplasm.obo'),obo).
user:bioresource(ncit,home('repos/ncit/Thesaurus.obo'),obo).
user:bioresource(ncit2,home('repos/ontodev/ncit-obo/build/ncit-obo.obo'),obo).
user:bioresource(neoplasm,home('repos/ontodev/ncit-obo/build/subsets/neoplasm.obo'),obo).
user:bioresource('NCITA',home('repos/ncit/ncit_anatomy.obo'),obo).
%user:bioresource(ncit_dn,obo_download('ncithesaurus/ncithesaurus.pro'),pro).
user:bioresource(pir,pir('PIRSF_ontology-02082005.dag'),dag).
user:bioresource(pir_uniprot,pir('PIRSF_UniProt_ontology-02082005.dag'),dag).
user:bioresource(evoc,ontdir('evoc.pro'),pro,ontol_db).
%user:bioresource(cco,ontdir('cco.owl'),owl).
user:bioresource(cco,url('http://www.cellcycleontology.org/ontology/cco.obo'),obo).
user:bioresource(cco_scer,url('http://www.semantic-systems-biology.org/ontology/obo/cco_S_cerevisiae.obo'),obo).
user:bioresource(f,home('repos/fantom/src/ontology/fantom5-edit.obo'),obo).

user:bioresource(hpoa,home('repos/human-disease-ontology/src/ontology/hpoa_dbfreq.pro'),pro).


%user:bioresource(acgt,url('http://www.ifomis.org/acgt/1.0' ),owl). % 1.0

% -- Obol --
user:bioresource(obol_av,obol2('vocab/vocab_obo.pro'),pro,av_db).

% --Chemistry--
user:bioresource(biochem_prim,url('http://ontology.dumontierlab.com/biochemistry-primitive'),owl).
user:bioresource(biochem_complex,url('http://ontology.dumontierlab.com/biochemistry-complex'),owl).
user:bioresource(xchebi,obolr('xchebi.obo'),obo).

% --GeneAssociations--
user:bioresource(uniprot_ga,gene_assoc('gene_association.goa_uniprot.lite.pro'),pro,ontol_db).
user:bioresource(tair_ga_xp,datadir('phenotype/tair_ga_xp.pro'),pro,ontol_db).
user:bioresource(fly_ga,gene_assoc('gene_association.fb.gz'),gzip(go_assoc)).


% mouse: special; includes CL,MA
user:bioresource(mgi_ga,datadir('phenotype/mgi_ga2.pro'),pro,goa_db).
user:bioresource(mgi_ga_xp,datadir('phenotype/mgi_ga2_xp.pro'),pro,goa_db).
user:bioresource(fly_ga_xp,datadir('phenotype/fb_ga_xp.pro'),pro,ontol_db).
user:bioresource(tair_ga,gene_assoc('gene_association.tair.pro',pro,ontol_db)).

% --PlantPhenAssocs--
user:bioresource(maize_pa,poc('associations/maize_ga.pro',pro,ontol_db)).
user:bioresource(gramene_pa,poc('associations/maize_ga.pro',pro,ontol_db)).
user:bioresource(worm_pa,'/users/cjm/obd/data/phenotype_annotation/WB/test_data/phenotype_association.WS186.wb',go_assoc).
user:bioresource(worm_ga,'/users/cjm/cvs/go/gene-associations/gene_association.wb.gz',gzip(go_assoc)).


% ----------------------------------------
% OBO METADATA
% ----------------------------------------

% http://obo.cvs.sourceforge.net/viewvc/*checkout*/obo/obo/website/cgi-bin/ontologies.txt
user:bioresource(obo_meta,obo_metadata_local('ontologies.txt'),tagval).
user:bioresource(obo_meta_xp,obo_metadata_local('mappings.txt'),tagval).


% ----------------------------------------
% REASONING
% ----------------------------------------
% use the 'implied' functor to retrieve a reasoned
% version of the ontology.
% for example:
%  load_bioresource(implied(cell)).


% post-reasoner results
user:bioresource(implied(Resource),PrologFile,'ontol_db:pro'):-
        nonvar(Resource),
        var(PrologFile),
        user:bioresource(Resource,InputFileTerm,_),
        !,
        expand_file_search_path(InputFileTerm,InputFile),
        concat_atom([InputFile,'-implied.pro'],PrologFile),
	(   exists_file(PrologFile),
	    time_file(PrologFile, PrologTime),
	    time_file(InputFile, InputTime),
            \+ user:recompile_all_biofiles,
            \+ (user:recompile_biofiles_before(Before),
                PrologTime < Before),
	    PrologTime >= InputTime
	->  true
	;   sformat(Cmd,'blip-reasoner -import_all -r ~w -to ontol_db:pro -o ~w.tmp && mv ~w.tmp ~w',[Resource,PrologFile,PrologFile,PrologFile]),
            shell(Cmd)
	->  true
	;   throw(cannot_execute(Cmd))).

user:bioresource(implied(InputFileTerm),PrologFile,'ontol_db:pro'):-
        nonvar(InputFileTerm),
        var(PrologFile),
        expand_file_search_path(InputFileTerm,InputFile),
        concat_atom([InputFile,'-implied.pro'],PrologFile),
	(   exists_file(PrologFile),
	    time_file(PrologFile, PrologTime),
	    time_file(InputFile, InputTime),
            \+ user:recompile_all_biofiles,
            \+ (user:recompile_biofiles_before(Before),
                PrologTime < Before),
	    PrologTime >= InputTime
	->  true
	;   sformat(Cmd,'blip-reasoner -import_all -i ~w -to ontol_db:pro -o ~w.tmp && mv ~w.tmp ~w',[InputFile,PrologFile,PrologFile,PrologFile]),
            shell(Cmd)
	->  true
	;   throw(cannot_execute(Cmd))).

% NEW
user:bioresource(inf(Resource),PrologFile,tbl(parentT)):-
        nonvar(Resource),
        var(PrologFile),
        user:bioresource(Resource,InputFileTerm,_),
        !,
        expand_file_search_path(InputFileTerm,InputFile),
        concat_atom([InputFile,'-inf.txt'],PrologFile),
	(   exists_file(PrologFile),
	    time_file(PrologFile, PrologTime),
	    time_file(InputFile, InputTime),
            \+ user:recompile_all_biofiles,
            \+ (user:recompile_biofiles_before(Before),
                PrologTime < Before),
	    PrologTime >= InputTime
	->  true
	;   sformat(Cmd,'owltools ~w  --save-closure-for-chado ~w.tmp && cut -f1,2,4 ~w.tmp | perl -npe s/OBO_REL:is_a/subclass/ > ~w && rm ~w.tmp',[InputFile,PrologFile,PrologFile,PrologFile,PrologFile]),
            shell(Cmd)
	->  true
	;   throw(cannot_execute(Cmd))).


% ----------------------------------------
% OTHERS...
% ----------------------------------------

% --SWEET--
% from NASA JPL





user:file_search_path(sweet_dir, local('SWEET')).

user:bioresource(sweet_biosphere,sweet_dir('biosphere.owl'),owl).
user:bioresource(sweet_data,sweet_dir('data.owl'),owl).
user:bioresource(sweet_data_center,sweet_dir('data_center.owl'),owl).
user:bioresource(sweet_earthrealm,sweet_dir('earthrealm.owl'),owl).
user:bioresource(sweet_human_activities,sweet_dir('human_activities.owl'),owl).
user:bioresource(sweet_material_thing,sweet_dir('material_thing.owl'),owl).
user:bioresource(sweet_numerics,sweet_dir('numerics.owl'),owl).
user:bioresource(sweet_phenomena,sweet_dir('phenomena.owl'),owl).
user:bioresource(sweet_process,sweet_dir('process.owl'),owl).
user:bioresource(sweet_property,sweet_dir('property.owl'),owl).
user:bioresource(sweet_sensor,sweet_dir('sensor.owl'),owl).
user:bioresource(sweet_space,sweet_dir('space.owl'),owl).
user:bioresource(sweet_substance,sweet_dir('substance.owl'),owl).
user:bioresource(sweet_sunrealm,sweet_dir('sunrealm.owl'),owl).
user:bioresource(sweet_time,sweet_dir('time.owl'),owl).
user:bioresource(sweet_units,sweet_dir('units.owl'),owl).          
user:bioresource(sweet(X),sweet_dir(File),owl):- atom_concat(X,'.owl',File).

user:bioresource(hydrology,url('http://www.ordnancesurvey.co.uk/ontology/Hydrology0.1.owl'),owl).
user:bioresource(ecological_concepts,url('http://wow.sfsu.edu/ontology/rich/EcologicalConcepts.owl'),owl).
        
% deprecated - use thea2 catalogs
user:uri_resolution('http://ccdb.ucsd.edu/PDStageOntology/1.0/','http://ccdb.ucsd.edu/SAO/PDSO/1.0/PDSO.owl').
