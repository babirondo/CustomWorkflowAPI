truncate table atores, posto_acao, postos_campo, tecnologias, usuarios, usuarios_avaliadores_tecnologias, 
workflow, workflow_postos;


insert into usuario_atores (idusuario, idator)
 values('1', '1' );
insert into usuario_atores (idusuario, idator)
 values('1', '5' );
insert into usuario_atores (idusuario, idator)
 values('1', '3' );
insert into usuario_atores (idusuario, idator)
 values('2', '2' );
insert into usuario_atores (idusuario, idator)
 values('3', '1' );
insert into usuario_atores (idusuario, idator)
 values('4', '3' );
insert into usuario_atores (idusuario, idator)
 values('5', '2' );


insert into postos_campo (  idposto, campo )
 values('1', 'job description' );
insert into postos_campo (  idposto, campo )
 values('2', 'github' );
insert into postos_campo (  idposto, campo )
 values('2', 'cv' );
insert into postos_campo (  idposto, campo )
 values('3', 'senioridade' );
insert into postos_campo (  idposto, campo )
 values('4', 'gestor' );
insert into postos_campo (  idposto, campo )
 values('5', 'parecer' );
insert into postos_campo (  idposto, campo )
 values('6', 'parecer' );
insert into postos_campo (  idposto, campo )
 values('8', 'dados da negociacao' );
insert into postos_campo (  idposto, campo )
 values('7', 'checklist executado ?' );


insert into tecnologias ( id, tecnologia )
 values('2', 'python'  );
insert into tecnologias ( id, tecnologia )
 values('3', 'ruby'  );
insert into tecnologias ( id, tecnologia )
 values('4', 'javascript'  );



 
insert into usuarios (id, nome)
 values('1', 'bruno' );
insert into usuarios (id, nome)
 values('2', 'mario' );
insert into usuarios (id, nome)
 values('3', 'paffi' );
insert into usuarios (id, nome)
 values('4', 'erica' );
insert into usuarios (id, nome)
 values('5', 'daniele' );


insert into workflow_postos (id_workflow, idator, posto, ordem_cronologica, sla, escalonamento, id )
 values('1', '1', 'job description', '1', 0,0, '1');
insert into workflow_postos (id_workflow, idator, posto, ordem_cronologica, sla, escalonamento, id )
 values('1', '3', 'cadastra retorno', '2', 0,0, '2');
insert into workflow_postos (id_workflow, idator, posto, ordem_cronologica, sla, escalonamento, id )
 values('1', '2', 'classificacao', '3', '3', 'bruno.siqueira@walmart.com', '3');
insert into workflow_postos (id_workflow, idator, posto, ordem_cronologica, sla, escalonamento, id )
 values('1', '5', 'roteamento', '4', '8', 'bruno.siqueira@walmart.com', '4');
insert into workflow_postos (id_workflow, idator, posto, ordem_cronologica, sla, escalonamento, id )
 values('1', '1', 'entrevista presencial', '5', '6', 'bruno.siqueira@walmart.com', '5');
insert into workflow_postos (id_workflow, idator, posto, ordem_cronologica, sla, escalonamento, id )
 values('1', '1', 'entrevistados', '6', '7', 'bruno.siqueira@walmart.com', '6');
insert into workflow_postos (id_workflow, idator, posto, ordem_cronologica, sla, escalonamento, id )
 values('1', '1', 'onboarding', '8', '7', 'bruno.siqueira@walmart.com', '7');
insert into workflow_postos (id_workflow, idator, posto, ordem_cronologica, sla, escalonamento, id )
 values('1', '1', 'negociar com consultoria', '7', '7', 'bruno.siqueira@walmart.com', '8');

insert into atores ( id,  ator )
 values('2', 'avaliador' );
insert into atores ( id,  ator )
 values('3', 'analista selecao' );
insert into atores ( id,  ator )
 values('5', 'gestor selecao' );

insert into workflow (id, workflow, posto_inicial, posto_final) values ( 1, 'recrutamento e slecao de dev', 2, 7);

insert into posto_acao (id, idposto, acao, goto)
 values('1','1', 'Lançar', '2' );
insert into posto_acao (id, idposto, acao, goto)
 values('2','2', 'Lançar', '3' );
insert into posto_acao (id, idposto, acao, goto)
 values('3','3', 'Classificar', '4' );
insert into posto_acao (id, idposto, acao, goto)
 values('4','4', 'Designar Gestor', '5' );
insert into posto_acao (id, idposto, acao, goto)
 values('5','5', 'Entrevistado', '6' );
insert into posto_acao (id, idposto, acao, goto)
 values('6','5', 'Voltar para Roteamento', '4' );
insert into posto_acao (id, idposto, acao, goto)
 values('7','6', 'negociar', '8' );
insert into posto_acao (id, idposto, acao, goto)
 values('8','6', 'Reprovado', '4' );
insert into posto_acao (id, idposto, acao, goto)
 values('9','7', 'Feito', 0 );
insert into posto_acao (id, idposto, acao, goto)
 values('10','8', 'fechado', '7' );
insert into posto_acao (id, idposto, acao, goto)
 values('11','8', 'negociacao cancelada', '4' );
insert into posto_acao (id, idposto, acao, goto)
 values('12','4', 'Arquivar', 0 );