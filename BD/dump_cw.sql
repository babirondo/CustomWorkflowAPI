--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

CREATE DATABASE customworkflow WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';
--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: processos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE processos (
    id integer NOT NULL,
    idpai integer,
    idtipoprocesso integer,
    inicio timestamp without time zone,
    idworkflow integer,
    status character varying,
    regra_finalizacao character varying
);


ALTER TABLE processos OWNER TO postgres;

--
-- Name: arvore_processo; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW arvore_processo AS
 SELECT p.id AS proprio,
    p_filhos.id AS filho,
    p_avo.id AS avo,
    '' AS status,
    p_bisavo.id AS bisavo
   FROM (((processos p
     LEFT JOIN processos p_filhos ON ((p_filhos.idpai = p.id)))
     LEFT JOIN processos p_avo ON ((p_avo.id = p.idpai)))
     LEFT JOIN processos p_bisavo ON ((p_bisavo.id = p_avo.idpai)));


ALTER TABLE arvore_processo OWNER TO postgres;

--
-- Name: atores; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE atores (
    id integer NOT NULL,
    ator character varying
);


ALTER TABLE atores OWNER TO postgres;

--
-- Name: atores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE atores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE atores_id_seq OWNER TO postgres;

--
-- Name: atores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE atores_id_seq OWNED BY atores.id;


--
-- Name: notificacoes_email; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE notificacoes_email (
    id integer NOT NULL,
    de character varying,
    para character varying,
    titulo character varying,
    corpo character varying
);


ALTER TABLE notificacoes_email OWNER TO postgres;

--
-- Name: TABLE notificacoes_email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE notificacoes_email IS 'o campo corpo, tem os seguintes parametros:
{preenchido_no_posto} -> conteudo dos campos preenchidos no posto
{idprocesso} -> idprocesso do registro


 ';


--
-- Name: notificacoes_email_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE notificacoes_email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE notificacoes_email_id_seq OWNER TO postgres;

--
-- Name: notificacoes_email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE notificacoes_email_id_seq OWNED BY notificacoes_email.id;


--
-- Name: posto_acao; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE posto_acao (
    id integer NOT NULL,
    idposto integer,
    acao character varying,
    goto integer
);


ALTER TABLE posto_acao OWNER TO postgres;

--
-- Name: posto_acao_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE posto_acao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE posto_acao_id_seq OWNER TO postgres;

--
-- Name: posto_acao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE posto_acao_id_seq OWNED BY posto_acao.id;


--
-- Name: postos_campo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE postos_campo (
    id integer NOT NULL,
    idposto integer,
    campo character varying,
    obrigatorio integer,
    maxlenght integer,
    inputtype character varying,
    txtarea_cols integer,
    txtarea_rows integer
);


ALTER TABLE postos_campo OWNER TO postgres;

--
-- Name: postos_campo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE postos_campo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE postos_campo_id_seq OWNER TO postgres;

--
-- Name: postos_campo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE postos_campo_id_seq OWNED BY postos_campo.id;


--
-- Name: postos_campo_lista; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE postos_campo_lista (
    id integer NOT NULL,
    idposto integer,
    idpostocampo integer,
    atributo_campo character varying,
    atributo_valor character varying
);


ALTER TABLE postos_campo_lista OWNER TO postgres;

--
-- Name: postos_campo_lista_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE postos_campo_lista_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE postos_campo_lista_id_seq OWNER TO postgres;

--
-- Name: postos_campo_lista_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE postos_campo_lista_id_seq OWNED BY postos_campo_lista.id;


--
-- Name: processos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE processos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE processos_id_seq OWNER TO postgres;

--
-- Name: processos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE processos_id_seq OWNED BY processos.id;


--
-- Name: relacionamento_postos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE relacionamento_postos (
    id integer NOT NULL,
    avanca_processo integer,
    idposto_atual integer
);


ALTER TABLE relacionamento_postos OWNER TO postgres;

--
-- Name: relacionamento_postos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE relacionamento_postos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE relacionamento_postos_id_seq OWNER TO postgres;

--
-- Name: relacionamento_postos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE relacionamento_postos_id_seq OWNED BY relacionamento_postos.id;


--
-- Name: tecnologias; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tecnologias (
    id integer NOT NULL,
    tecnologia character varying
);


ALTER TABLE tecnologias OWNER TO postgres;

--
-- Name: tecnologias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tecnologias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tecnologias_id_seq OWNER TO postgres;

--
-- Name: tecnologias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tecnologias_id_seq OWNED BY tecnologias.id;


--
-- Name: tipos_processo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tipos_processo (
    id integer NOT NULL,
    tipo character varying,
    id_pai integer,
    regra_finalizacao character varying,
    regra_handover character varying,
    avanca_processo_filhos_fechados integer
);


ALTER TABLE tipos_processo OWNER TO postgres;

--
-- Name: tipos_processo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tipos_processo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tipos_processo_id_seq OWNER TO postgres;

--
-- Name: tipos_processo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tipos_processo_id_seq OWNED BY tipos_processo.id;


--
-- Name: usuario_atores; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuario_atores (
    id integer NOT NULL,
    idusuario integer,
    idator integer
);


ALTER TABLE usuario_atores OWNER TO postgres;

--
-- Name: usuario_atores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE usuario_atores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE usuario_atores_id_seq OWNER TO postgres;

--
-- Name: usuario_atores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE usuario_atores_id_seq OWNED BY usuario_atores.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuarios (
    id integer NOT NULL,
    email character varying,
    nome character varying,
    senha character varying,
    login character varying,
    admin integer
);


ALTER TABLE usuarios OWNER TO postgres;

--
-- Name: usuarios_avaliadores_tecnologias; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuarios_avaliadores_tecnologias (
    id integer NOT NULL,
    idusuario integer,
    idtecnologia integer
);


ALTER TABLE usuarios_avaliadores_tecnologias OWNER TO postgres;

--
-- Name: usuarios_avaliadores_tecnologias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE usuarios_avaliadores_tecnologias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE usuarios_avaliadores_tecnologias_id_seq OWNER TO postgres;

--
-- Name: usuarios_avaliadores_tecnologias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE usuarios_avaliadores_tecnologias_id_seq OWNED BY usuarios_avaliadores_tecnologias.id;


--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE usuarios_id_seq OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE usuarios_id_seq OWNED BY usuarios.id;


--
-- Name: workflow; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE workflow (
    id integer NOT NULL,
    workflow character varying,
    posto_inicial integer,
    posto_final integer,
    penultimo_posto integer
);


ALTER TABLE workflow OWNER TO postgres;

--
-- Name: workflow_dados; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE workflow_dados (
    id integer NOT NULL,
    idpostocampo integer,
    valor character varying,
    idprocesso integer,
    registro timestamp without time zone,
    idposto integer
);


ALTER TABLE workflow_dados OWNER TO postgres;

--
-- Name: workflow_dados_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE workflow_dados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workflow_dados_id_seq OWNER TO postgres;

--
-- Name: workflow_dados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE workflow_dados_id_seq OWNED BY workflow_dados.id;


--
-- Name: workflow_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE workflow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workflow_id_seq OWNER TO postgres;

--
-- Name: workflow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE workflow_id_seq OWNED BY workflow.id;


--
-- Name: workflow_postos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE workflow_postos (
    id integer NOT NULL,
    id_workflow integer,
    idator integer,
    posto character varying,
    ordem_cronologica integer,
    principal integer,
    lista character varying,
    idtipoprocesso integer,
    starter integer,
    notif_saindoposto integer,
    notif_entrandoposto integer,
    tipodesignacao character varying,
    regra_finalizacao character varying
);


ALTER TABLE workflow_postos OWNER TO postgres;

--
-- Name: workflow_postos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE workflow_postos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workflow_postos_id_seq OWNER TO postgres;

--
-- Name: workflow_postos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE workflow_postos_id_seq OWNED BY workflow_postos.id;


--
-- Name: workflow_tramitacao; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE workflow_tramitacao (
    id integer NOT NULL,
    idprocesso integer,
    idworkflowposto integer,
    inicio timestamp without time zone,
    fim timestamp without time zone
);


ALTER TABLE workflow_tramitacao OWNER TO postgres;

--
-- Name: TABLE workflow_tramitacao; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE workflow_tramitacao IS 'tipodesignacao = LIVRE - qualquer um pode trabalhar no processo daquele posto
tipodesignacao = ASSUMIR - qualquer usuario pode reinvicar o processo daquele posto
tipodesignacao = AUTO-DIRECIONADO - os processos serão automaticamente distribuidos';


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE workflow_tramitacao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workflow_tramitacao_id_seq OWNER TO postgres;

--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE workflow_tramitacao_id_seq OWNED BY workflow_tramitacao.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY atores ALTER COLUMN id SET DEFAULT nextval('atores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notificacoes_email ALTER COLUMN id SET DEFAULT nextval('notificacoes_email_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY posto_acao ALTER COLUMN id SET DEFAULT nextval('posto_acao_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY postos_campo ALTER COLUMN id SET DEFAULT nextval('postos_campo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY postos_campo_lista ALTER COLUMN id SET DEFAULT nextval('postos_campo_lista_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY processos ALTER COLUMN id SET DEFAULT nextval('processos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY relacionamento_postos ALTER COLUMN id SET DEFAULT nextval('relacionamento_postos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tecnologias ALTER COLUMN id SET DEFAULT nextval('tecnologias_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipos_processo ALTER COLUMN id SET DEFAULT nextval('tipos_processo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuario_atores ALTER COLUMN id SET DEFAULT nextval('usuario_atores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios ALTER COLUMN id SET DEFAULT nextval('usuarios_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios_avaliadores_tecnologias ALTER COLUMN id SET DEFAULT nextval('usuarios_avaliadores_tecnologias_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY workflow ALTER COLUMN id SET DEFAULT nextval('workflow_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY workflow_dados ALTER COLUMN id SET DEFAULT nextval('workflow_dados_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY workflow_postos ALTER COLUMN id SET DEFAULT nextval('workflow_postos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY workflow_tramitacao ALTER COLUMN id SET DEFAULT nextval('workflow_tramitacao_id_seq'::regclass);


--
-- Data for Name: atores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY atores (id, ator) FROM stdin;
2	avaliador
3	analista selecao
5	gestor selecao
85	Gestor Funcional
\.


--
-- Name: atores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('atores_id_seq', 85, true);


--
-- Data for Name: notificacoes_email; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY notificacoes_email (id, de, para, titulo, corpo) FROM stdin;
4	devcontrat@walmart.com	{gestor interessado}	[Processo de Contratacão] Entrevista Candidato: {nome}	{gestor interessado},\n\nFavor entrevista o candidato {nome} o mais rapido possivel, caso ele nao se encaixe no perfil que voce deseja outro gestor poderia considera-lo\n\n\nAtenciosamente,\nEquipe de Contratacão de Desenvolvedores 
5	{gestor interessado}	{consultoria}	[Processo de Contratacão] Negociacao com candidato {nome}	Ola {consultoria},\n\nPor favor, poderia iniciar o processo de negociacao com o candidato {nome}, referente ao processo seletivo {idprocesso}\n\nAtenciosamente,\n{gestor interessado}
1	rodrigues@simonsen.br	rodrigues@simonsen.br	[Walmart.com] Abertura de Vaga - Processo Seletivo #{idprocesso}	Olá,\nComunicamos de abertura de nova vaga, Processo Seletivo #{idprocesso}.\n\nJob Description: {job description}\nTipo de Vaga: {tipovaga}\n\t\t\nLembramos que: \n1 - Os candidatos que atenderem as exigências da vaga deverão executar o teste abaixo, em caráter eliminatório.\nhttp://www. github.com. aihua/ teste blabla\n\t\t\n2 - Toda a comunicação a respeito de um candidato deve preservar o número do Processo Seletivo.\n\n3 - Somente serão considerados os candidatos com teste concluído e data de resposta de no máximo um mês a partir deste email.\n\t\t\nAtenciosamente, \nEquipe de Contratação de Desenvolvedores\ndevcontrat@walmart.com
6	{gestor interessado}	{consultoria}	[Processo de Contratação] Contratar:{nome} - Processo Seletivo: {idprocesso}	Olá {consultoria},\n\nGostaria de comunicar a aprovação do candidato {nome}, referente ao processo seletivo {idprocesso}.\n\nData de Inicio esperada: {data de inicio}\nValor/Hora negociada: {Valor/Hora}\n\nAtenciosamente, \n{Gestor Interessado}\n
2	brunorodriguessiqueira@hotmail.com	brunorodriguessiqueira@hotmail.com	[Processo de Contratacão] Novo candidato para ser Classificado - {tecnologia}	Olá,\nUm novo candidato do nosso processo de selecão enviou submeteu seu teste e gostariamos da sua ajuda para avalia-lo.\nVocê ira encontrar todos os dados necessarios no sistema mas adiantamos:\nProcesso Seletivo: {idprocesso}\n{preenchido_no_posto}\n\t\t\nLembramos que: \n1 - O objetivo desta classificacao e enquadra-lo de acordo com as metricas de avaliacão do Walmart. Confira em: \n\t\t\nAtenciosamente, \nEquipe de Contratação de Desenvolvedores\ndevcontrat@walmart.com
7	devcontrat@walmart.com	{email}	{nome}, {email} Bem Vindo ao Walmart.com	Olá {nome},\nEste é seu primeiro email e que seja de boas vindas!\n\nEm tempo, gostaríamos de saber como foi seu processo de onboarding.\nPoderia nos responder as perguntas abaixo:\n1. Você recebeu instrucões sobre a visão de negocios, roadmap atual e futuro do produto que você vai trabalhar ? Como foi a experiência ?\n2. Você recebeu instrucões sobre a arquitetura, dependências e quais sistemas dependem do seu produto ? Como foi a experiência ?\n3. Você recebeu instrucões sobre o processo de trabalho do Walmart.com ? Como foi a experiência ?\n\nEsta faltando alguma coisa ? Em que mais podemos lhe ajudar ?\n\nVocê tem 7 dias para responder este email! Seu feedback e importante para continuarmos melhorando.\n\nAtenciosamente,\nEquipe de Contratacão de Desenvolvedores
3	devcontrat@walmart.com	{atores}	[Processo de Contratação] Candidato pronto para Roteamento - {tecnologia}:{senioridade}	Gestores, \nExiste um novo candidato pronto para ser entrevistado.\n\nProcesso Seletivo: {idprocesso}\nNome do Candidato: {nome}\n\nAtenciosamente, \nEquipe de Contratação de Desenvolvedores\ndevcontrat@walmart.com\n
\.


--
-- Name: notificacoes_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('notificacoes_email_id_seq', 7, true);


--
-- Data for Name: posto_acao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY posto_acao (id, idposto, acao, goto) FROM stdin;
1	1	Lançar	2
3	3	Classificar	274
4	4	Designar Gestor	275
310	7	Finalizar2	279
2	2	Lançar	273
5	5	Seguir com candidato	276
311	5	Devolver Candidato	281
7	6	Seguir para Negociacão	277
312	6	Devolver Candidato	282
10	8	Negociacão com Sucesso	278
313	8	Negociacao Declinou	283
316	280	test onboarding	284
315	280	Seguir para reconsideracão	285
12	4	Arquivar	286
317	287	Classificar	288
\.


--
-- Name: posto_acao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('posto_acao_id_seq', 317, true);


--
-- Data for Name: postos_campo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY postos_campo (id, idposto, campo, obrigatorio, maxlenght, inputtype, txtarea_cols, txtarea_rows) FROM stdin;
11	273	nome	1	50	text	\N	\N
13	1	tipovaga	1	30	text	\N	\N
12	273	tecnologia	\N	\N	\N	\N	\N
2	273	github	\N	\N	\N	\N	\N
4	274	senioridade	\N	\N	\N	\N	\N
163	278	Valor/Hora	\N	\N	\N	\N	\N
164	278	Data de Inicio	\N	\N	\N	\N	\N
5	275	Gestor Interessado	\N	\N	\N	\N	\N
166	273	Consultoria	\N	\N	\N	\N	\N
171	284	tst	\N	\N	\N	\N	\N
177	279	Email	\N	\N	\N	\N	\N
8	8	dados da negociacao	1	\N	textarea	90	10
9	279	checklist executado ?	1	\N	textarea	90	10
10	274	Parecer da Classificação dos Devs	1	\N	textarea	90	10
6	276	Parecer do Gestor em Entrevista Presencial	1	\N	textarea	90	10
7	277	Pos Entrevista, parecer decisorio	1	\N	textarea	90	10
167	281	Motivo da ReprovacÃo	1	\N	textarea	90	10
168	282	Motivo da ReprovacÃo	1	\N	textarea	90	10
169	283	Motivo do Declinio	1	\N	textarea	90	10
170	285	Justificativa da reativacão do Processo	1	\N	textarea	90	10
172	286	Motivo do Arquivamento	1	\N	textarea	90	10
174	1	Enunciado e Regras do Teste Técnico	1	\N	textarea	90	10
1	1	job description	1	\N	textarea	90	10
178	287	senioridade	\N	\N	\N	\N	\N
179	287	Parecer da Classificação dos Devs	1	\N	textarea	90	10
180	288	senioridade	\N	\N	\N	\N	\N
181	288	Parecer da Classificação dos Devs	1	\N	textarea	90	10
3	273	cv	\N	\N	file	\N	\N
\.


--
-- Name: postos_campo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_id_seq', 181, true);


--
-- Data for Name: postos_campo_lista; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY postos_campo_lista (id, idposto, idpostocampo, atributo_campo, atributo_valor) FROM stdin;
1	2	13	\N	\N
2	2	1	\N	\N
3	3	11	\N	\N
4	3	12	\N	\N
5	3	13	\N	\N
6	4	4	\N	\N
7	4	10	\N	\N
9	4	11	\N	\N
10	4	12	\N	\N
11	4	13	\N	\N
12	5	4	\N	\N
13	5	10	\N	\N
15	5	11	\N	\N
16	5	12	\N	\N
17	5	13	\N	\N
18	5	5	\N	\N
19	6	4	\N	\N
20	6	10	\N	\N
21	6	5	\N	\N
22	6	11	\N	\N
23	6	12	\N	\N
24	6	13	\N	\N
25	6	6	\N	\N
26	8	4	\N	\N
27	8	10	\N	\N
28	8	5	\N	\N
29	8	11	\N	\N
30	8	12	\N	\N
31	8	13	\N	\N
32	8	7	\N	\N
33	8	6	\N	\N
42	7	4	\N	\N
45	7	11	\N	\N
46	7	12	\N	\N
47	7	13	\N	\N
50	7	163	\N	\N
51	7	164	\N	\N
52	280	1	\N	\N
53	280	13	\N	\N
54	280	11	\N	\N
55	280	12	\N	\N
56	280	4	\N	\N
57	280	\N	Status do Processo	p_status
59	280	\N	Inicio do Processo	p_inicio
58	280	\N	No Posto desde	wt_inicio
60	4	\N	No Posto desde	wt_inicio
61	2	\N	No Posto desde	wt_inicio
62	3	\N	No Posto desde	wt_inicio
63	5	\N	No Posto desde	wt_inicio
64	6	\N	No Posto desde	wt_inicio
65	7	\N	No Posto desde	wt_inicio
66	8	\N	No Posto desde	wt_inicio
67	3	166	\N	\N
68	4	166	\N	\N
69	5	166	\N	\N
70	6	166	\N	\N
71	7	166	\N	\N
72	8	166	\N	\N
73	280	166	\N	\N
74	280	177	\N	\N
75	287	11	\N	\N
76	287	12	\N	\N
77	287	13	\N	\N
78	287	\N	No Posto desde	wt_inicio
79	287	166	\N	\N
\.


--
-- Name: postos_campo_lista_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_lista_id_seq', 79, true);


--
-- Data for Name: processos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY processos (id, idpai, idtipoprocesso, inicio, idworkflow, status, regra_finalizacao) FROM stdin;
47152	47151	2	2016-05-20 02:40:00.34	1	\N	\N
47135	\N	1	2016-05-20 01:50:11.324	1	Em Andamento	\N
47136	47135	2	2016-05-20 01:50:23.78	1	\N	\N
47137	47136	3	2016-05-20 01:50:23.788	1	Em Andamento	\N
47138	47136	3	2016-05-20 01:50:24.067	1	Em Andamento	\N
47140	47139	3	2016-05-20 01:52:24.543	1	Em Andamento	\N
47141	47139	3	2016-05-20 01:52:24.833	1	Em Andamento	\N
47153	47152	3	2016-05-20 02:40:00.35	1	Em Andamento	\N
47154	47152	3	2016-05-20 02:40:00.794	1	Em Andamento	\N
47143	47142	3	2016-05-20 02:06:28.53	1	Em Andamento	\N
47144	47142	3	2016-05-20 02:06:28.925	1	Em Andamento	\N
47139	47135	2	2016-05-20 01:52:24.535	1	Em Andamento	\N
47145	\N	1	2016-05-20 02:06:37.973	1	Em Andamento	\N
47142	46914	2	2016-05-20 02:06:28.525	1	Em Andamento	\N
47146	\N	1	2016-05-20 02:38:31.017	1	Em Andamento	\N
47147	\N	1	2016-05-20 02:38:45.032	1	Em Andamento	\N
47148	46914	2	2016-05-20 02:38:52.932	1	\N	\N
47149	47148	3	2016-05-20 02:38:52.937	1	Em Andamento	\N
47150	47148	3	2016-05-20 02:38:53.367	1	Em Andamento	\N
47151	\N	1	2016-05-20 02:39:52.336	1	Em Andamento	\N
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 47154, true);


--
-- Data for Name: relacionamento_postos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY relacionamento_postos (id, avanca_processo, idposto_atual) FROM stdin;
1	7	278
2	\N	280
3	4	281
4	4	282
5	280	283
6	7	284
7	4	285
8	280	286
9	280	279
11	\N	3
12	3	273
13	\N	4
14	\N	5
15	\N	6
16	\N	7
17	5	275
18	6	276
19	8	277
20	\N	8
21	\N	2
22	2	1
23	287	273
\.


--
-- Name: relacionamento_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('relacionamento_postos_id_seq', 23, true);


--
-- Data for Name: tecnologias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tecnologias (id, tecnologia) FROM stdin;
2	python
3	ruby
4	javascript
\.


--
-- Name: tecnologias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tecnologias_id_seq', 48, true);


--
-- Data for Name: tipos_processo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipos_processo (id, tipo, id_pai, regra_finalizacao, regra_handover, avanca_processo_filhos_fechados) FROM stdin;
3	Avaliação	2	\N	ANYTIME	\N
1	Vaga	\N	\N	ANYTIME	\N
2	Candidato	1	\N	TODOS_FILHOS_FECHADOS	4
\.


--
-- Name: tipos_processo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipos_processo_id_seq', 3, true);


--
-- Data for Name: usuario_atores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuario_atores (id, idusuario, idator) FROM stdin;
86	1	85
87	2	3
88	1	5
89	3	2
90	4	2
91	4	3
92	4	5
93	4	85
94	5	2
95	6	2
96	7	2
\.


--
-- Name: usuario_atores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuario_atores_id_seq', 96, true);


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarios (id, email, nome, senha, login, admin) FROM stdin;
2	babirondo@gmail.com	Analista de Seleção	analista	analista	\N
1	babirondo@gmail.com	Bruno Siqueira	bruno	bruno	\N
3	babirondo@gmail.com	Dev Avaliador	dev	dev	\N
5	\N	Dev 2	dev2	dev2	\N
6	\N	Dev 3	dev3	dev3	\N
7	\N	Dev 1	dev1	dev1	\N
4	babirondo@gmail.com	Total	total	total	1
\.


--
-- Data for Name: usuarios_avaliadores_tecnologias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarios_avaliadores_tecnologias (id, idusuario, idtecnologia) FROM stdin;
\.


--
-- Name: usuarios_avaliadores_tecnologias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuarios_avaliadores_tecnologias_id_seq', 36, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuarios_id_seq', 7, true);


--
-- Data for Name: workflow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow (id, workflow, posto_inicial, posto_final, penultimo_posto) FROM stdin;
25	fluxo 2 	\N	\N	\N
1	recrutamento e slecao de dev	1	280	7
\.


--
-- Data for Name: workflow_dados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_dados (id, idpostocampo, valor, idprocesso, registro, idposto) FROM stdin;
4902	13	front	47135	2016-05-20 01:50:11.331	1
4903	174	enucniado	47135	2016-05-20 01:50:11.332	1
4904	1	job	47135	2016-05-20 01:50:11.332	1
4905	11	nome candidato	47136	2016-05-20 01:50:23.786	273
4906	12		47136	2016-05-20 01:50:23.787	273
4907	2		47136	2016-05-20 01:50:23.787	273
4908	166		47136	2016-05-20 01:50:23.787	273
4911	4	jr	47137	2016-05-20 01:51:13.334	274
4912	10	xxxx	47137	2016-05-20 01:51:13.337	274
4913	180	pl	47138	2016-05-20 01:51:35.011	288
4914	181	oooo	47138	2016-05-20 01:51:35.012	288
4915	11	xx	47139	2016-05-20 01:52:24.541	273
4916	12		47139	2016-05-20 01:52:24.542	273
4917	2		47139	2016-05-20 01:52:24.542	273
4918	166		47139	2016-05-20 01:52:24.542	273
4921	4	sr	47140	2016-05-20 01:53:09.899	274
4922	10	ccc	47140	2016-05-20 01:53:09.904	274
4923	4	sr	47140	2016-05-20 01:53:31.145	274
4924	10	ccc	47140	2016-05-20 01:53:31.153	274
4925	180	jr	47141	2016-05-20 01:54:14.26	288
4926	181	jjjj	47141	2016-05-20 01:54:14.267	288
4927	180	jr	47141	2016-05-20 01:55:21.737	288
4928	181	jjjj	47141	2016-05-20 01:55:21.74	288
4929	180	jr	47141	2016-05-20 01:56:26.726	288
4930	181	jjjj	47141	2016-05-20 01:56:26.733	288
4931	180	jr	47141	2016-05-20 02:00:55.789	288
4932	181	jjjj	47141	2016-05-20 02:00:55.796	288
4933	180	jr	47141	2016-05-20 02:02:13.378	288
4934	181	jjjj	47141	2016-05-20 02:02:13.382	288
4935	180	jr	47141	2016-05-20 02:02:41.279	288
4936	181	jjjj	47141	2016-05-20 02:02:41.281	288
4937	180	jr	47141	2016-05-20 02:03:47.746	288
4938	181	jjjj	47141	2016-05-20 02:03:47.753	288
4939	180	jr	47141	2016-05-20 02:05:42.623	288
4940	181	jjjj	47141	2016-05-20 02:05:42.626	288
4941	4	sr	47140	2016-05-20 02:06:12.337	274
4942	10	ccc	47140	2016-05-20 02:06:12.34	274
4943	11	novo candidato para roteamento	47142	2016-05-20 02:06:28.527	273
4944	12	kkk	47142	2016-05-20 02:06:28.528	273
4945	2	mmm	47142	2016-05-20 02:06:28.528	273
4946	166	,,,,	47142	2016-05-20 02:06:28.529	273
4949	13	 mn	47145	2016-05-20 02:06:37.981	1
4950	174	 Nmm	47145	2016-05-20 02:06:37.982	1
4951	1	mmm	47145	2016-05-20 02:06:37.983	1
4952	5	ds1d1d1	47139	2016-05-20 02:10:14.529	275
4953	5	ds1d1d1	47139	2016-05-20 02:10:32.42	275
4954	6	dsadas	47139	2016-05-20 02:11:38.256	276
4955	7	d1d11d decisorio	47139	2016-05-20 02:12:09.077	277
4956	7	d1d11d decisorio	47139	2016-05-20 02:12:25.871	277
4957	163	132	47139	2016-05-20 02:13:19.947	278
4958	164	amanha	47139	2016-05-20 02:13:19.955	278
4959	163	132	47139	2016-05-20 02:13:39.645	278
4960	164	amanha	47139	2016-05-20 02:13:39.647	278
4961	163	132	47139	2016-05-20 02:16:49.175	278
4962	164	amanha	47139	2016-05-20 02:16:49.177	278
4963	163	132	47139	2016-05-20 02:17:32.469	278
4964	164	amanha	47139	2016-05-20 02:17:32.471	278
4965	163	132	47139	2016-05-20 02:19:18.624	278
4966	164	amanha	47139	2016-05-20 02:19:18.631	278
4967	163	132	47139	2016-05-20 02:20:13.592	278
4968	164	amanha	47139	2016-05-20 02:20:13.599	278
4969	163	132	47139	2016-05-20 02:20:46.626	278
4970	164	amanha	47139	2016-05-20 02:20:46.631	278
4971	163	132	47139	2016-05-20 02:21:42.089	278
4972	164	amanha	47139	2016-05-20 02:21:42.09	278
4973	163	132	47139	2016-05-20 02:25:00.945	278
4974	164	amanha	47139	2016-05-20 02:25:00.952	278
4975	163	132	47139	2016-05-20 02:26:14.98	278
4976	164	amanha	47139	2016-05-20 02:26:14.986	278
4977	163	132	47139	2016-05-20 02:30:04.012	278
4978	164	amanha	47139	2016-05-20 02:30:04.019	278
4979	163	132	47139	2016-05-20 02:30:26.587	278
4980	164	amanha	47139	2016-05-20 02:30:26.593	278
4981	163	132	47139	2016-05-20 02:31:51.625	278
4982	164	amanha	47139	2016-05-20 02:31:51.627	278
4983	177	kkkkk@kkk.com	47139	2016-05-20 02:33:19.274	279
4984	9	l;pos	47139	2016-05-20 02:33:19.281	279
4985	177	kkkkk@kkk.com	47139	2016-05-20 02:33:37.803	279
4986	9	l;pos	47139	2016-05-20 02:33:37.805	279
4987	163	132	47139	2016-05-20 02:34:16.142	278
4988	164	amanha	47139	2016-05-20 02:34:16.144	278
4989	177	kkkkk@kkk.com	47139	2016-05-20 02:34:26.804	279
4990	9	l;pos	47139	2016-05-20 02:34:26.806	279
4991	177	kkkkk@kkk.com	47139	2016-05-20 02:35:35.947	279
4992	9	l;pos	47139	2016-05-20 02:35:35.949	279
4993	177	kkkkk@kkk.com	47139	2016-05-20 02:35:59.698	279
4994	9	l;pos	47139	2016-05-20 02:35:59.705	279
4995	177	kkkkk@kkk.com	47139	2016-05-20 02:36:15.425	279
4996	9	l;pos	47139	2016-05-20 02:36:15.427	279
4997	177	kkkkk@kkk.com	47139	2016-05-20 02:37:54.313	279
4998	9	l;pos	47139	2016-05-20 02:37:54.319	279
4999	13	 mn	47146	2016-05-20 02:38:31.023	1
5000	174	 Nmm	47146	2016-05-20 02:38:31.025	1
5001	1	mmm	47146	2016-05-20 02:38:31.025	1
5002	13	 mn	47147	2016-05-20 02:38:45.039	1
5003	174	 Nmm	47147	2016-05-20 02:38:45.04	1
5004	1	mmm	47147	2016-05-20 02:38:45.04	1
5005	11	novo candidato para roteamento	47148	2016-05-20 02:38:52.934	273
5006	12	kkk	47148	2016-05-20 02:38:52.935	273
5007	2	mmm	47148	2016-05-20 02:38:52.936	273
5008	166	,,,,	47148	2016-05-20 02:38:52.936	273
5009	-1	3	47149	2016-05-20 02:38:53.353	3
5010	-1	7	47150	2016-05-20 02:38:54.009	287
5011	4	sr	47140	2016-05-20 02:39:02.215	274
5012	10	ccc	47140	2016-05-20 02:39:02.217	274
5013	180	jr	47141	2016-05-20 02:39:09.649	288
5014	181	jjjj	47141	2016-05-20 02:39:09.655	288
5015	5	ds1d1d1	47139	2016-05-20 02:39:17.396	275
5016	7	d1d11d decisorio	47139	2016-05-20 02:39:23.681	277
5017	163	132	47139	2016-05-20 02:39:31.176	278
5018	164	amanha	47139	2016-05-20 02:39:31.178	278
5019	177	kkkkk@kkk.com	47139	2016-05-20 02:39:38.761	279
5020	9	l;pos	47139	2016-05-20 02:39:38.769	279
5021	13	aaaaa	47151	2016-05-20 02:39:52.343	1
5022	174	KK	47151	2016-05-20 02:39:52.344	1
5023	1	K	47151	2016-05-20 02:39:52.344	1
5024	11	DSA	47152	2016-05-20 02:40:00.347	273
5025	12		47152	2016-05-20 02:40:00.348	273
5026	2		47152	2016-05-20 02:40:00.349	273
5027	166		47152	2016-05-20 02:40:00.349	273
5028	-1	5	47153	2016-05-20 02:40:00.784	3
5029	-1	6	47154	2016-05-20 02:40:01.153	287
5030	180	DSADSA	47144	2016-05-20 02:40:21.848	288
5031	181	DDD	47144	2016-05-20 02:40:21.85	288
5032	4	DDDV	47143	2016-05-20 02:40:36.994	274
5033	10	DDDDD	47143	2016-05-20 02:40:36.996	274
5034	5	D3	47142	2016-05-20 02:41:03.734	275
5035	6	R23R2	47142	2016-05-20 02:41:17.39	276
5036	6	R3R23R2	47139	2016-05-20 02:41:26.433	276
5037	7	R322AA	47142	2016-05-20 02:41:36.416	277
5038	163	2C2CC22C	47142	2016-05-20 02:41:47.231	278
5039	164	CS	47142	2016-05-20 02:41:47.233	278
5040	177	SSS	47142	2016-05-20 02:41:57.898	279
5041	9	CCCC	47142	2016-05-20 02:41:57.904	279
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 5041, true);


--
-- Name: workflow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_id_seq', 25, true);


--
-- Data for Name: workflow_postos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_postos (id, id_workflow, idator, posto, ordem_cronologica, principal, lista, idtipoprocesso, starter, notif_saindoposto, notif_entrandoposto, tipodesignacao, regra_finalizacao) FROM stdin;
280	1	\N	Processos Finalizados	9	1	L	\N	\N	\N	\N	\N	\N
281	1	85	Reprovacão de Candidato	\N	0	F	2	\N	\N	\N	\N	\N
282	1	85	Reprovacão de Candidato ja entrevistado	\N	0	F	2	\N	\N	\N	\N	\N
283	1	85	Negociacão Falha	\N	0	F	2	\N	\N	\N	\N	\N
284	1	85	TESTE	\N	0	F	2	\N	\N	\N	\N	\N
285	1	85	Re Ativar Processo Seletivo para este candidato	\N	0	F	2	\N	\N	\N	\N	\N
286	1	85	Arquivar processo de Candidato	\N	0	F	2	\N	\N	\N	\N	\N
4	1	85	roteamento	4	1	L	2	\N	\N	3	\N	\N
5	1	85	entrevista presencial	5	1	L	2	\N	\N	4	\N	\N
6	1	85	entrevistados	6	1	L	2	\N	\N	\N	\N	\N
275	1	\N	Encaminhar para Gestor	\N	0	F	2	\N	\N	\N	\N	\N
276	1	\N	Dados da Entrevista	\N	0	F	2	\N	\N	\N	\N	\N
277	1	\N	Encaminhar para Negociacão	\N	0	F	2	\N	\N	\N	\N	\N
2	1	3	cadastra retorno	2	1	L	1	1	\N	\N	\N	\N
1	1	85	job description	1	1	F	1	1	1	\N	\N	\N
274	1	1	Classificação de Senioridade	\N	0	F	3	\N	\N	\N	\N	\N
288	1	1	Classificação de Senioridade	\N	0	F	3	\N	\N	\N	\N	\N
287	1	2	Segunda Avaliação	3	1	L	3	\N	\N	\N	AUTO-DIRECIONADO	\N
3	1	2	Primeira Avaliação	3	1	L	3	\N	\N	2	AUTO-DIRECIONADO	\N
273	1	3	lançar candidato	\N	0	F	3	0	\N	\N	\N	\N
8	1	85	negociar com consultoria	7	1	L	2	\N	6	5	\N	\N
278	1	\N	Dados da Contratação	\N	0	F	2	\N	\N	\N	\N	\N
7	1	85	onboarding	8	1	L	2	\N	7	\N	\N	\N
279	1	\N	Onboarding de novo membro	\N	0	F	2	\N	\N	\N	\N	\N
\.


--
-- Name: workflow_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_postos_id_seq', 288, true);


--
-- Data for Name: workflow_tramitacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_tramitacao (id, idprocesso, idworkflowposto, inicio, fim) FROM stdin;
2274	47135	1	2016-05-20 01:50:11.333	2016-05-20 01:50:11.333
2275	47135	2	2016-05-20 01:50:11.358	\N
2276	47137	3	2016-05-20 01:50:23.79	2016-05-20 01:51:13.337
2277	47138	287	2016-05-20 01:50:24.068	2016-05-20 01:51:35.013
2281	47139	4	2016-05-20 02:00:55.818	\N
2282	47139	4	2016-05-20 02:02:13.401	\N
2283	47139	4	2016-05-20 02:02:41.299	\N
2284	47139	4	2016-05-20 02:03:47.791	\N
2285	47139	4	2016-05-20 02:05:42.656	\N
2286	47139	4	2016-05-20 02:06:12.367	\N
2289	47145	1	2016-05-20 02:06:37.984	2016-05-20 02:06:37.984
2290	47145	2	2016-05-20 02:06:38.014	\N
2291	47139	5	2016-05-20 02:10:14.537	2016-05-20 02:11:38.279
2294	47139	8	2016-05-20 02:12:09.082	\N
2297	47139	7	2016-05-20 02:13:39.649	\N
2298	47139	7	2016-05-20 02:16:49.179	\N
2299	47139	7	2016-05-20 02:17:32.474	\N
2300	47139	7	2016-05-20 02:19:18.633	\N
2301	47139	7	2016-05-20 02:20:13.6	\N
2302	47139	7	2016-05-20 02:20:46.633	\N
2303	47139	7	2016-05-20 02:21:42.092	\N
2304	47139	7	2016-05-20 02:25:00.955	\N
2305	47139	7	2016-05-20 02:26:14.988	\N
2306	47139	7	2016-05-20 02:30:04.022	\N
2307	47139	7	2016-05-20 02:30:26.595	\N
2308	47139	7	2016-05-20 02:31:51.629	\N
2309	47139	280	2016-05-20 02:33:19.283	\N
2310	47139	280	2016-05-20 02:33:37.807	\N
2311	47139	7	2016-05-20 02:34:16.146	\N
2312	47139	280	2016-05-20 02:34:26.807	\N
2313	47139	280	2016-05-20 02:35:35.951	\N
2314	47139	280	2016-05-20 02:35:59.707	\N
2315	47139	280	2016-05-20 02:36:15.428	\N
2316	47139	280	2016-05-20 02:37:54.321	\N
2317	47146	1	2016-05-20 02:38:31.027	2016-05-20 02:38:31.027
2318	47146	2	2016-05-20 02:38:31.058	\N
2319	47147	1	2016-05-20 02:38:45.042	2016-05-20 02:38:45.042
2320	47147	2	2016-05-20 02:38:45.07	\N
2321	47149	3	2016-05-20 02:38:52.94	\N
2322	47150	287	2016-05-20 02:38:53.37	\N
2278	47140	3	2016-05-20 01:52:24.544	2016-05-20 02:39:02.217
2323	47139	4	2016-05-20 02:39:02.24	\N
2279	47141	287	2016-05-20 01:52:24.834	2016-05-20 02:39:09.656
2324	47139	4	2016-05-20 02:39:09.681	\N
2325	47139	5	2016-05-20 02:39:17.405	\N
2280	47139	4	2016-05-20 01:56:26.751	2016-05-20 02:39:17.435
2326	47139	8	2016-05-20 02:39:23.69	\N
2293	47139	6	2016-05-20 02:11:38.261	2016-05-20 02:39:23.722
2327	47139	7	2016-05-20 02:39:31.18	\N
2295	47139	8	2016-05-20 02:12:25.875	2016-05-20 02:39:31.236
2328	47139	280	2016-05-20 02:39:38.771	\N
2296	47139	7	2016-05-20 02:13:19.957	2016-05-20 02:39:38.82
2329	47151	1	2016-05-20 02:39:52.346	2016-05-20 02:39:52.346
2330	47151	2	2016-05-20 02:39:52.373	\N
2331	47153	3	2016-05-20 02:40:00.353	\N
2332	47154	287	2016-05-20 02:40:00.795	\N
2288	47144	287	2016-05-20 02:06:28.927	2016-05-20 02:40:21.851
2287	47143	3	2016-05-20 02:06:28.531	2016-05-20 02:40:36.998
2333	47142	4	2016-05-20 02:40:37.024	2016-05-20 02:41:03.759
2334	47142	5	2016-05-20 02:41:03.738	2016-05-20 02:41:17.414
2336	47139	6	2016-05-20 02:41:26.435	\N
2292	47139	5	2016-05-20 02:10:32.427	2016-05-20 02:41:26.45
2335	47142	6	2016-05-20 02:41:17.398	2016-05-20 02:41:36.44
2337	47142	8	2016-05-20 02:41:36.423	2016-05-20 02:41:47.25
2339	47142	280	2016-05-20 02:41:57.906	\N
2338	47142	7	2016-05-20 02:41:47.234	2016-05-20 02:41:57.919
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 2339, true);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

