--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: customworkflow; Type: DATABASE; Schema: -; Owner: bsiquei
--

CREATE DATABASE customworkflow WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'pt_BR.UTF-8' LC_CTYPE = 'pt_BR.UTF-8';


ALTER DATABASE customworkflow OWNER TO bsiquei;

\connect customworkflow

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: configuracoes; Type: SCHEMA; Schema: -; Owner: bsiquei
--

CREATE SCHEMA configuracoes;


ALTER SCHEMA configuracoes OWNER TO bsiquei;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = configuracoes, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: tecnologias; Type: TABLE; Schema: configuracoes; Owner: postgres
--

CREATE TABLE tecnologias (
    id integer NOT NULL,
    tecnologia character varying
);


ALTER TABLE tecnologias OWNER TO postgres;

--
-- Name: tecnologias_id_seq; Type: SEQUENCE; Schema: configuracoes; Owner: postgres
--

CREATE SEQUENCE tecnologias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tecnologias_id_seq OWNER TO postgres;

--
-- Name: tecnologias_id_seq; Type: SEQUENCE OWNED BY; Schema: configuracoes; Owner: postgres
--

ALTER SEQUENCE tecnologias_id_seq OWNED BY tecnologias.id;


SET search_path = public, pg_catalog;

--
-- Name: processos; Type: TABLE; Schema: public; Owner: postgres
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
    p_bisavo.id AS bisavo,
    p_netos.id AS neto
   FROM ((((processos p
     LEFT JOIN processos p_filhos ON ((p_filhos.idpai = p.id)))
     LEFT JOIN processos p_avo ON ((p_avo.id = p.idpai)))
     LEFT JOIN processos p_bisavo ON ((p_bisavo.id = p_avo.idpai)))
     LEFT JOIN processos p_netos ON ((p_netos.idpai = p_filhos.id)));


ALTER TABLE arvore_processo OWNER TO postgres;

--
-- Name: atores; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: filtros_postos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE filtros_postos (
    id integer NOT NULL,
    idposto integer,
    idpostocampo integer,
    tipofiltro character varying
);


ALTER TABLE filtros_postos OWNER TO postgres;

--
-- Name: filtros_postos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE filtros_postos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE filtros_postos_id_seq OWNER TO postgres;

--
-- Name: filtros_postos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE filtros_postos_id_seq OWNED BY filtros_postos.id;


--
-- Name: funcoes_posto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE funcoes_posto (
    id integer NOT NULL,
    idposto integer,
    funcao character varying,
    goto integer
);


ALTER TABLE funcoes_posto OWNER TO postgres;

--
-- Name: funcoes_posto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE funcoes_posto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE funcoes_posto_id_seq OWNER TO postgres;

--
-- Name: funcoes_posto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE funcoes_posto_id_seq OWNED BY funcoes_posto.id;


--
-- Name: notificacoes_email; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: posto_acao; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: postos_campo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE postos_campo (
    id integer NOT NULL,
    idposto integer,
    campo character varying,
    obrigatorio integer,
    maxlenght integer,
    inputtype character varying,
    txtarea_cols integer,
    txtarea_rows integer,
    dica_preenchimento character varying,
    valor_default character varying
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
-- Name: postos_campo_lista; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: relacionamento_postos; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: sla; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE sla (
    id integer NOT NULL,
    nomeregra character varying,
    idnotificacao integer,
    tabela character varying,
    sla_emhorascorridas integer,
    campo_calculado character varying,
    campo_localizador character varying,
    valor_localizador character varying,
    where_tabela character varying,
    idpai integer
);


ALTER TABLE sla OWNER TO postgres;

--
-- Name: sla_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sla_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sla_id_seq OWNER TO postgres;

--
-- Name: sla_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sla_id_seq OWNED BY sla.id;


--
-- Name: sla_notificacoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE sla_notificacoes (
    id integer NOT NULL,
    idsla integer,
    datanotificacao timestamp without time zone,
    chave character varying
);


ALTER TABLE sla_notificacoes OWNER TO postgres;

--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sla_notificacoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sla_notificacoes_id_seq OWNER TO postgres;

--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sla_notificacoes_id_seq OWNED BY sla_notificacoes.id;


--
-- Name: tipos_processo; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: usuario_atores; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: usuarios_avaliadores_tecnologias; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: workflow; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: workflow_dados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE workflow_dados (
    id integer NOT NULL,
    idpostocampo integer,
    valor character varying,
    idprocesso integer,
    registro timestamp without time zone,
    idposto integer,
    idworkflowtramitacao integer
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
-- Name: workflow_postos; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: workflow_tramitacao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE workflow_tramitacao (
    id integer NOT NULL,
    idprocesso integer,
    idworkflowposto integer,
    inicio timestamp without time zone,
    fim timestamp without time zone,
    id_usuario_associado integer
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


SET search_path = configuracoes, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: configuracoes; Owner: postgres
--

ALTER TABLE ONLY tecnologias ALTER COLUMN id SET DEFAULT nextval('tecnologias_id_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY atores ALTER COLUMN id SET DEFAULT nextval('atores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY filtros_postos ALTER COLUMN id SET DEFAULT nextval('filtros_postos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY funcoes_posto ALTER COLUMN id SET DEFAULT nextval('funcoes_posto_id_seq'::regclass);


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

ALTER TABLE ONLY sla ALTER COLUMN id SET DEFAULT nextval('sla_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sla_notificacoes ALTER COLUMN id SET DEFAULT nextval('sla_notificacoes_id_seq'::regclass);


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


SET search_path = configuracoes, pg_catalog;

--
-- Data for Name: tecnologias; Type: TABLE DATA; Schema: configuracoes; Owner: postgres
--

COPY tecnologias (id, tecnologia) FROM stdin;
1	android
2	java
3	php
4	python
5	NodeJs
6	Ruby
\.


--
-- Name: tecnologias_id_seq; Type: SEQUENCE SET; Schema: configuracoes; Owner: postgres
--

SELECT pg_catalog.setval('tecnologias_id_seq', 6, true);


SET search_path = public, pg_catalog;

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
-- Data for Name: filtros_postos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY filtros_postos (id, idposto, idpostocampo, tipofiltro) FROM stdin;
1	2	13	COMBO
2	2	1	COMBO
3	3	11	COMBO
4	3	12	COMBO
5	3	13	COMBO
6	4	4	COMBO
7	4	11	COMBO
8	4	13	COMBO
9	5	4	COMBO
10	5	10	COMBO
11	5	11	COMBO
12	5	12	COMBO
13	5	13	COMBO
14	5	5	COMBO
15	6	4	COMBO
16	6	10	COMBO
17	6	5	COMBO
18	6	11	COMBO
19	6	12	COMBO
20	6	13	COMBO
21	6	6	COMBO
22	8	4	COMBO
23	8	10	COMBO
24	8	5	COMBO
25	8	11	COMBO
26	8	12	COMBO
27	8	13	COMBO
28	8	7	COMBO
29	8	6	COMBO
30	7	4	COMBO
31	7	11	COMBO
32	7	12	COMBO
33	7	13	COMBO
34	7	163	COMBO
35	7	164	COMBO
36	280	1	COMBO
37	280	13	COMBO
38	280	11	COMBO
39	280	12	COMBO
40	280	4	COMBO
51	3	166	COMBO
52	4	166	COMBO
53	5	166	COMBO
54	6	166	COMBO
55	7	166	COMBO
56	8	166	COMBO
57	280	166	COMBO
58	280	177	COMBO
59	287	11	COMBO
60	287	12	COMBO
61	287	13	COMBO
63	287	166	COMBO
64	4	182	COMBO
65	4	180	COMBO
66	290	13	COMBO
67	290	174	COMBO
68	290	1	COMBO
\.


--
-- Name: filtros_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('filtros_postos_id_seq', 68, true);


--
-- Data for Name: funcoes_posto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY funcoes_posto (id, idposto, funcao, goto) FROM stdin;
1	2	Criar nova Vaga	1
\.


--
-- Name: funcoes_posto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('funcoes_posto_id_seq', 1, true);


--
-- Data for Name: notificacoes_email; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY notificacoes_email (id, de, para, titulo, corpo) FROM stdin;
5	{5}	{166}	[Processo de Contratacão] Negociacao com candidato {11}	Ola {166},\n\nPor favor, poderia iniciar o processo de negociacao com o candidato {11}, referente ao processo seletivo {idprocesso}\n\nAtenciosamente,\n{5}
14	devcontrat@walmart.com	{gestorselecao}	[Processo de Contratação] SLA do processo de seleção vencido	\nOlá {gestorselecao},\nGostaríamos de informar que o candidato {11} encontra-se no processo de seleção além do máximo considerado.\n\nGentileza, verificar. \n\nAbs,\nBruno
9	devcontrat@walmart.com	{5}	[Processo de Contratação] SLA Vencido, Negociação com Consultoria	\nOlá {5},\nGostaríamos de informar que o SLA de Negociação com a COnusltoria do candidato {11} referente ao processo seletivo {idprocesso} encontra-se vencido.\n\nFavor agilizar.\n\nAbs,\nBruno\n
10	devcontrat@walmart.com	{5}	[Processo de Contratação] SLA Vencido, Negociação com Consultoria	\nOlá {5},\nGostaríamos de informar que o SLA de revisão dos candidatos entrevistados, especificamento o candidato {11} referente ao processo seletivo {idprocesso} encontra-se vencido.\n\nFavor agilizar.\n\nAbs,\nBruno\n
15	devcontrat@walmart.com	{usuarioassociado}	[Processo de Contratação] SLA Vencido da Avalição do candidato {11}	Olá {usuarioassociado},\nGostaríamos de solicitar que você avaliasse o candidato {11} o mais rapido possível. O SLA padrão desta atividade já foi rompido.
2	devcontrat@walmart.com	{usuarioassociado}	[Processo de Contratacão] Novo candidato para ser Classificado - {12}	Olá,\nUm novo candidato do nosso processo de selecão enviou submeteu seu teste e gostariamos da sua ajuda para avalia-lo.\nVocê ira encontrar todos os dados necessarios no sistema mas adiantamos:\nProcesso Seletivo: {idprocesso}\n\n\t\t\nLembramos que: \n1 - O objetivo desta classificacao e enquadra-lo de acordo com as metricas de avaliacão do Walmart. Confira em: \n\t\t\nAtenciosamente, \nEquipe de Contratação de Desenvolvedores\ndevcontrat@walmart.com
7	devcontrat@walmart.com	{177}	{11}, {177} Bem Vindo ao Walmart.com	Olá {11},\nEste é seu primeiro email e que seja de boas vindas!\n\nEm tempo, gostaríamos de saber como foi seu processo de onboarding.\nPoderia nos responder as perguntas abaixo:\n1. Você recebeu instrucões sobre a visão de negocios, roadmap atual e futuro do produto que você vai trabalhar ? Como foi a experiência ?\n2. Você recebeu instrucões sobre a arquitetura, dependências e quais sistemas dependem do seu produto ? Como foi a experiência ?\n3. Você recebeu instrucões sobre o processo de trabalho do Walmart.com ? Como foi a experiência ?\n\nEsta faltando alguma coisa ? Em que mais podemos lhe ajudar ?\n\nVocê tem 7 dias para responder este email! Seu feedback e importante para continuarmos melhorando.\n\nAtenciosamente,\nEquipe de Contratacão de Desenvolvedores
17	devcontrar@walmart.com	gerente@walmart	[Processo de Contratação] Escalonamento, candidato {11} atingiu tempo máximo no processo	Olá {gestorselecao}, O candidato {11} do processo {idprocesso} atingiu o tempo máximo no processo.
11	devcontrat@walmart.com	{5}	[Processo de Contratação] SLA Vencido, Negociação com Consultoria	\nOlá {5},\nGostaríamos de informar que o SLA de Entrevista, especificamente do candidato {11} referente ao processo seletivo {idprocesso} encontra-se vencido.\n\nFavor agilizar.\n\nAbs,\nBruno
13	devcontrat@walmart.com	{5}	[Processo de Contratação] SLA de Onboarding vencido	\nOlá {5},\nGostaríamos de informar que o SLA de Onboarding do novo membro {11} encontra-se vencido.\n\nGentileza, agilizar. \n\nAbs,\nBruno
6	{5}	{166}	[Processo de Contratação] Contratar:{11} - Processo Seletivo: {idprocesso}	Olá {166},\n\nGostaria de comunicar a aprovação do candidato {11}, referente ao processo seletivo {idprocesso}.\n\nData de Inicio esperada: {data de inicio}\nValor/Hora negociada: {Valor/Hora}\n\nAtenciosamente, \n{5}\n
4	devcontrat@walmart.com	{5}	[Processo de Contratacão] Entrevista Candidato: {11}	{5},\n\nFavor entrevista o candidato {11} o mais rapido possivel, caso ele nao se encaixe no perfil que voce deseja outro gestor poderia considera-lo\n\n\nAtenciosamente,\nEquipe de Contratacão de Desenvolvedores
16	devcontrat@walmart.com	diretor@walmart	[Processo de Contratação] Escalonamento: Posto de Primeira avaliação	Olá,\nGostaríamos de pedir sua ajuda, o teste do candidato {11} continua no mesmo posto desde {entradanoposto} e já foi escalado para {usuarioassociado}.
12	devcontrat@walmart.com	{usuarioassociado}	[Processo de Contratação] Avaliação do Teste	\nOlá {usuarioassociado},\nGostaríamos de informar que o SLA de Avaliação do Teste Técnico, especificamente do candidato {11} referente ao processo seletivo {idprocesso} encontra-se vencido.\n\nGentileza, verificar ASAP.\n\nAbs,\nBruno
18	devcontrat@walmart.com	diretor@walmart	[Processo de Contratação] Escalonamento, nível 2, candidato {11} a muito tmepo no processo.	Olá,\nGostaríamos de pedir sua ajuda, o candidato {11} está no processo desde {inicioprocesso} e já foi escalado para {gestorselecao}. Precisamos encerrar sua vida no processo.
3	devcontrat@walmart.com	{atoresdoposto}	[Processo de Contratação] Candidato pronto para Roteamento - {12}:{4}	Gestores, \nExiste um novo candidato pronto para ser entrevistado.\n\nProcesso Seletivo: {idprocesso}\nNome do Candidato: {11}\n\nAtenciosamente, \nEquipe de Contratação de Desenvolvedores\ndevcontrat@walmart.com\n
1	rodrigues@simonsen.br	{186}	[Walmart.com] Abertura de Vaga - Processo Seletivo #{idprocesso}	Olá,\nComunicamos de abertura de nova vaga, Processo Seletivo #{idprocesso}.\n\nJob Description: {1}\nTipo de Vaga: {13}\n\t\t\nLembramos que: \n1 - Os candidatos que atenderem as exigências da vaga deverão executar o teste abaixo, em caráter eliminatório.\nhttp://www. github.com. aihua/ teste blabla\n\t\t\n2 - Toda a comunicação a respeito de um candidato deve preservar o número do Processo Seletivo.\n\n3 - Somente serão considerados os candidatos com teste concluído e data de resposta de no máximo um mês a partir deste email.\n\t\t\nAtenciosamente, \nEquipe de Contratação de Desenvolvedores\ndevcontrat@walmart.com
19	{usuario_logado.email}	{184}	[Walmart.com] Processo Seletivo #{idprocesso}	Olá, (Este é um re-envio desta vaga)\nComunicamos de abertura de nova vaga, Processo Seletivo #{idprocesso}.\n\nJob Description: {1}\nTipo de Vaga: {13}\n\t\t\nLembramos que: \n1 - Os candidatos que atenderem as exigências da vaga deverão executar o teste abaixo, em caráter eliminatório.\nhttp://www. github.com. aihua/ teste blabla\n\t\t\n2 - Toda a comunicação a respeito de um candidato deve preservar o número do Processo Seletivo.\n\n3 - Somente serão considerados os candidatos com teste concluído e data de resposta de no máximo um mês a partir deste email.\n\t\t\nAtenciosamente, \nEquipe de Contratação de Desenvolvedores\ndevcontrat@walmart.com
20	devcontrat@walmart.com	{184},{186}	[Walmart.com] Encerramento do Processo Seletivo : {idprocesso}	Olá,\rGostaríamos de comunicar o encerramento deste processo seletivo. \rMais detalhes: {183}
8	devcontrat@walmart.com	devcontrat@walmart.com	[Processo de Contratação] SLA Vencido, Posto Roteamento	Olá,\n\nO SLA do posto foi vencido e solicitamos que o roteamento dos candidatos aprovados seja logo realizado.
\.


--
-- Name: notificacoes_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('notificacoes_email_id_seq', 20, true);


--
-- Data for Name: posto_acao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY posto_acao (id, idposto, acao, goto) FROM stdin;
1	1	Lançar	2
3	3	Classificar	274
4	4	Designar Gestor	275
310	7	Finalizar2	279
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
2	2	Lançar Candidato de Consultoria	273
319	2	Encerrar Vaga	292
318	2	Enviar para	294
\.


--
-- Name: posto_acao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('posto_acao_id_seq', 319, true);


--
-- Data for Name: postos_campo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY postos_campo (id, idposto, campo, obrigatorio, maxlenght, inputtype, txtarea_cols, txtarea_rows, dica_preenchimento, valor_default) FROM stdin;
11	273	nome	1	50	text	\N	\N	\N	\N
13	1	tipovaga	1	30	text	\N	\N	\N	\N
4	274	senioridade	\N	\N	\N	\N	\N	\N	\N
163	278	Valor/Hora	\N	\N	\N	\N	\N	\N	\N
164	278	Data de Inicio	\N	\N	\N	\N	\N	\N	\N
5	275	Gestor Interessado	\N	\N	\N	\N	\N	\N	\N
171	284	tst	\N	\N	\N	\N	\N	\N	\N
177	279	Email	\N	\N	\N	\N	\N	\N	\N
8	8	dados da negociacao	1	\N	textarea	90	10	\N	\N
9	279	checklist executado ?	1	\N	textarea	90	10	\N	\N
10	274	Parecer da Classificação dos Devs	1	\N	textarea	90	10	\N	\N
6	276	Parecer do Gestor em Entrevista Presencial	1	\N	textarea	90	10	\N	\N
7	277	Pos Entrevista, parecer decisorio	1	\N	textarea	90	10	\N	\N
167	281	Motivo da ReprovacÃo	1	\N	textarea	90	10	\N	\N
168	282	Motivo da ReprovacÃo	1	\N	textarea	90	10	\N	\N
169	283	Motivo do Declinio	1	\N	textarea	90	10	\N	\N
170	285	Justificativa da reativacão do Processo	1	\N	textarea	90	10	\N	\N
172	286	Motivo do Arquivamento	1	\N	textarea	90	10	\N	\N
174	1	Enunciado e Regras do Teste Técnico	1	\N	textarea	90	10	\N	\N
1	1	job description	1	\N	textarea	90	10	\N	\N
179	287	Parecer da Classificação dos Devs	1	\N	textarea	90	10	\N	\N
180	288	senioridade	\N	\N	\N	\N	\N	\N	\N
181	288	Parecer da Classificação dos Devs	1	\N	textarea	90	10	\N	\N
183	292	Motivo do Encerramento da Vaga	1	\N	textarea	90	10	\N	\N
184	294	Novos Destinatários	\N	\N	textarea	90	2	Separar os emails por ",". Exemplo: usuario@email.com, usuario2@email.com	\N
186	1	Destinatários	1	\N	textarea	90	2	Separar os emails por ",". Exemplo: usuario@email.com, usuario2@email.com	consultoria1@email.com, consultoria2@eail.com
182	273	Tecnologias que domina	1	\N	list	\N	\N	\N	{configuracoes.tecnologias}
2	273	github	1	\N	\N	\N	\N	\N	\N
166	273	Consultoria	1	\N	\N	\N	\N	\N	\N
12	273	Tecnologia que o candidato fez o teste	1	\N	list	\N	\N	\N	{configuracoes.tecnologias}
3	273	cv	\N	\N	file	\N	\N	\N	\N
\.


--
-- Name: postos_campo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_id_seq', 186, true);


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
9	4	11	\N	\N
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
80	4	182	\N	\N
81	4	180	\N	\N
82	290	13	\N	\N
83	290	174	\N	\N
84	290	1	\N	\N
\.


--
-- Name: postos_campo_lista_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_lista_id_seq', 84, true);


--
-- Data for Name: processos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY processos (id, idpai, idtipoprocesso, inicio, idworkflow, status, regra_finalizacao) FROM stdin;
47673	\N	1	2016-06-27 13:33:17.065742	1	Em Andamento	\N
47674	\N	1	2016-06-27 13:45:43.729988	1	Em Andamento	\N
47675	\N	1	2016-06-27 13:46:21.825119	1	Em Andamento	\N
47676	47673	2	2016-06-27 13:53:25.849814	1	\N	\N
47677	47676	3	2016-06-27 13:53:25.853577	1	\N	\N
47678	47673	2	2016-06-27 14:00:33.969134	1	\N	\N
47679	47678	3	2016-06-27 14:00:33.972665	1	\N	\N
47680	47673	2	2016-06-27 14:01:45.383346	1	\N	\N
47681	47680	3	2016-06-27 14:01:45.391167	1	\N	\N
47682	47673	2	2016-06-27 14:05:18.838041	1	\N	\N
47683	47682	3	2016-06-27 14:05:18.841594	1	\N	\N
47684	47673	2	2016-06-27 14:07:28.700764	1	\N	\N
47685	47684	3	2016-06-27 14:07:28.704448	1	\N	\N
47686	47673	2	2016-06-27 14:12:54.394366	1	\N	\N
47687	47686	3	2016-06-27 14:12:54.398041	1	\N	\N
47688	47673	2	2016-06-27 14:13:48.490355	1	\N	\N
47689	47688	3	2016-06-27 14:13:48.493777	1	\N	\N
47690	47675	2	2016-06-27 14:38:58.324366	1	\N	\N
47691	47690	3	2016-06-27 14:38:58.327464	1	\N	\N
47692	47674	2	2016-06-27 14:40:46.548491	1	\N	\N
47693	47692	3	2016-06-27 14:40:46.552001	1	\N	\N
47694	47673	2	2016-06-27 14:41:57.643825	1	\N	\N
47695	47694	3	2016-06-27 14:41:57.646957	1	\N	\N
47696	47673	2	2016-06-27 16:34:36.552869	1	\N	\N
47697	47696	3	2016-06-27 16:34:36.556368	1	\N	\N
47698	47673	2	2016-06-27 16:35:24.424783	1	\N	\N
47699	47698	3	2016-06-27 16:35:24.428156	1	\N	\N
47700	47673	2	2016-06-27 16:37:01.417939	1	\N	\N
47701	47700	3	2016-06-27 16:37:01.421223	1	Em Andamento	\N
47702	47700	3	2016-06-27 16:37:01.486005	1	Em Andamento	\N
47703	47673	2	2016-06-27 16:37:24.630629	1	\N	\N
47704	47703	3	2016-06-27 16:37:24.633652	1	\N	\N
47705	47673	2	2016-06-27 16:39:22.852061	1	\N	\N
47706	47705	3	2016-06-27 16:39:22.859928	1	Em Andamento	\N
47707	47705	3	2016-06-27 16:39:22.909113	1	Em Andamento	\N
47708	47673	2	2016-06-27 16:39:45.423914	1	\N	\N
47709	47708	3	2016-06-27 16:39:45.427853	1	\N	\N
47710	47673	2	2016-06-27 16:40:20.717267	1	\N	\N
47711	47710	3	2016-06-27 16:40:20.721086	1	\N	\N
47712	47673	2	2016-06-27 16:40:29.193558	1	\N	\N
47713	47712	3	2016-06-27 16:40:29.201474	1	\N	\N
47714	47673	2	2016-06-27 16:43:09.222313	1	\N	\N
47715	47714	3	2016-06-27 16:43:09.230283	1	Em Andamento	\N
47716	47714	3	2016-06-27 16:43:09.280354	1	Em Andamento	\N
47717	47696	3	2016-06-27 17:00:30.246609	1	Em Andamento	\N
47718	47696	3	2016-06-27 17:00:30.296481	1	Em Andamento	\N
47719	\N	1	2016-06-27 18:13:33.878173	1	Em Andamento	\N
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 47719, true);


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
25	293	292
26	295	294
\.


--
-- Name: relacionamento_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('relacionamento_postos_id_seq', 26, true);


--
-- Data for Name: sla; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sla (id, nomeregra, idnotificacao, tabela, sla_emhorascorridas, campo_calculado, campo_localizador, valor_localizador, where_tabela, idpai) FROM stdin;
41	Tempo no posto Roteamento	8	workflow_tramitacao wt	1	wt.inicio	wt.id	4	wt.fim is null and wt.idworkflowposto = 4	\N
46	Tempo no Posto Negociar com COnsultoria	9	workflow_tramitacao wt	1	wt.inicio	wt.id	8	wt.fim is null and wt.idworkflowposto = 8	\N
45	Tempo no Posto Entrevistados	10	workflow_tramitacao wt	1	wt.inicio	wt.id	6	wt.fim is null and wt.idworkflowposto = 6	\N
44	Tempo no Posto Entrevista Presencial	11	workflow_tramitacao wt	1	wt.inicio	wt.id	5	wt.fim is null and wt.idworkflowposto = 5	\N
42	Tempo no Posto Primeira Avaliação	12	workflow_tramitacao wt	1	wt.inicio	wt.id	3	wt.fim is null and wt.idworkflowposto = 3	\N
43	Tempo no Posto Segunda Avaliação	12	workflow_tramitacao wt	1	wt.inicio	wt.id	287	wt.fim is null and wt.idworkflowposto = 287	\N
39	Tempo no Posto Onboarding	13	workflow_tramitacao wt	1	wt.inicio	wt.id	7	wt.fim is null and wt.idworkflowposto = 7	\N
40	Tempo máximo de Candidatura	14	processos p	1	p.inicio	p.id		p.status IN (null,   'Em Andamento') and p.idtipoprocesso = 2	\N
49	Escalonamento, nível 1, Tempo máximo de candidatura	17	sla_notificacoes sn 	1	sn.datanotificacao	sn.chave	\N	sn.idsla = 40	40
48	Escalonamento, nível 2, posto Primeira Avaliação	16	sla_notificacoes sn	1	sn.datanotificacao	sn.chave	\N	sn.idsla = 47	47
50	Escalonamento nível 2, tempo máximo de processo do candidato	18	sla_notificacoes sn	1	sn.datanotificacao	sn.chave	\N	sn.idsla = 49	49
47	Escalonamento, nível 1, posto Primeira Avaliação	15	sla_notificacoes sn	1	sn.datanotificacao	sn.chave	\N	sn.idsla = 42	42
\.


--
-- Name: sla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_id_seq', 50, true);


--
-- Data for Name: sla_notificacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sla_notificacoes (id, idsla, datanotificacao, chave) FROM stdin;
29547	42	2016-06-27 14:00:34.216512	2819
29548	42	2016-06-27 14:01:40.785688	2820
29549	42	2016-06-27 14:01:40.79227	2819
29550	47	2016-06-27 14:01:40.801122	2819
29551	42	2016-06-27 14:02:49.231568	2820
29552	42	2016-06-27 14:02:49.238036	2819
29553	42	2016-06-27 14:02:49.243776	2821
29554	48	2016-06-27 14:02:49.25255	2819
29555	47	2016-06-27 14:02:49.258962	2820
29556	47	2016-06-27 14:02:49.265657	2819
29557	42	2016-06-27 14:05:19.083611	2820
29558	42	2016-06-27 14:05:19.090249	2819
29559	42	2016-06-27 14:05:19.096316	2821
29560	48	2016-06-27 14:05:19.104854	2820
29561	48	2016-06-27 14:05:19.111293	2819
29562	47	2016-06-27 14:05:19.11789	2821
29563	47	2016-06-27 14:05:19.124209	2820
29564	47	2016-06-27 14:05:19.130265	2819
29565	42	2016-06-27 14:06:37.082067	2820
29566	42	2016-06-27 14:06:37.089972	2819
29567	42	2016-06-27 14:06:37.09706	2822
29568	42	2016-06-27 14:06:37.105041	2821
29569	48	2016-06-27 14:06:37.114466	2821
29570	48	2016-06-27 14:06:37.121005	2820
29571	48	2016-06-27 14:06:37.128636	2819
29572	47	2016-06-27 14:06:37.135424	2821
29573	47	2016-06-27 14:06:37.142371	2820
29574	47	2016-06-27 14:06:37.148933	2819
29575	42	2016-06-27 14:09:52.849039	2820
29576	42	2016-06-27 14:09:52.855309	2819
29577	42	2016-06-27 14:09:52.861505	2822
29578	42	2016-06-27 14:09:52.867688	2821
29579	42	2016-06-27 14:09:52.875042	2823
29580	48	2016-06-27 14:09:52.884377	2821
29581	48	2016-06-27 14:09:52.890332	2820
29582	48	2016-06-27 14:09:52.896569	2819
29583	47	2016-06-27 14:09:52.903571	2821
29584	47	2016-06-27 14:09:52.909773	2820
29585	47	2016-06-27 14:09:52.915524	2822
29586	47	2016-06-27 14:09:52.92177	2819
29587	42	2016-06-27 14:10:55.237695	2820
29588	42	2016-06-27 14:10:55.243983	2819
29589	42	2016-06-27 14:10:55.250732	2822
29590	42	2016-06-27 14:10:55.256693	2821
29591	42	2016-06-27 14:10:55.263429	2823
29592	48	2016-06-27 14:10:55.271687	2821
29593	48	2016-06-27 14:10:55.278131	2820
29594	48	2016-06-27 14:10:55.284445	2822
29595	48	2016-06-27 14:10:55.290172	2819
29596	47	2016-06-27 14:10:55.29689	2821
29597	47	2016-06-27 14:10:55.302687	2820
29598	47	2016-06-27 14:10:55.308554	2822
29599	47	2016-06-27 14:10:55.314664	2819
29600	47	2016-06-27 14:10:55.320858	2823
29601	42	2016-06-27 14:12:54.537016	2820
29602	42	2016-06-27 14:12:54.543603	2819
29603	42	2016-06-27 14:12:54.549563	2822
29604	42	2016-06-27 14:12:54.555424	2821
29605	42	2016-06-27 14:12:54.561118	2823
29606	48	2016-06-27 14:12:54.569272	2821
29607	48	2016-06-27 14:12:54.576209	2820
29608	48	2016-06-27 14:12:54.583034	2822
29609	48	2016-06-27 14:12:54.589902	2819
29610	48	2016-06-27 14:12:54.596895	2823
29611	47	2016-06-27 14:12:54.605669	2821
29612	47	2016-06-27 14:12:54.612556	2822
29613	47	2016-06-27 14:12:54.619079	2819
29614	47	2016-06-27 14:12:54.625395	2823
29615	47	2016-06-27 14:12:54.631616	2820
29616	42	2016-06-27 14:33:54.344783	2820
29617	42	2016-06-27 14:33:54.35121	2825
29618	42	2016-06-27 14:33:54.357077	2819
29619	42	2016-06-27 14:33:54.362992	2822
29620	42	2016-06-27 14:33:54.369697	2821
29621	42	2016-06-27 14:33:54.375362	2824
29622	42	2016-06-27 14:33:54.380986	2823
29623	48	2016-06-27 14:33:54.389607	2821
29624	48	2016-06-27 14:33:54.395597	2822
29625	48	2016-06-27 14:33:54.401894	2819
29626	48	2016-06-27 14:33:54.40811	2823
29627	48	2016-06-27 14:33:54.414213	2820
29628	47	2016-06-27 14:33:54.420467	2821
29629	47	2016-06-27 14:33:54.426188	2822
29630	47	2016-06-27 14:33:54.432262	2819
29631	47	2016-06-27 14:33:54.438099	2823
29632	47	2016-06-27 14:33:54.444075	2820
29633	42	2016-06-27 14:38:01.129169	2820
29634	42	2016-06-27 14:38:01.13603	2825
29635	42	2016-06-27 14:38:01.142083	2819
29636	42	2016-06-27 14:38:01.148382	2822
29637	42	2016-06-27 14:38:01.154072	2821
29638	42	2016-06-27 14:38:01.159942	2824
29639	42	2016-06-27 14:38:01.166103	2823
29640	48	2016-06-27 14:38:01.174977	2821
29641	48	2016-06-27 14:38:01.181393	2822
29642	48	2016-06-27 14:38:01.187698	2819
29643	48	2016-06-27 14:38:01.195077	2823
29644	48	2016-06-27 14:38:01.200862	2820
29645	47	2016-06-27 14:38:01.207112	2821
29646	47	2016-06-27 14:38:01.213401	2822
29647	47	2016-06-27 14:38:01.219722	2825
29648	47	2016-06-27 14:38:01.225721	2819
29649	47	2016-06-27 14:38:01.231838	2823
29650	47	2016-06-27 14:38:01.237523	2824
29651	47	2016-06-27 14:38:01.24328	2820
29652	42	2016-06-27 14:40:01.473929	2820
29653	42	2016-06-27 14:40:01.480908	2825
29654	42	2016-06-27 14:40:01.487661	2826
29655	42	2016-06-27 14:40:01.493949	2819
29656	42	2016-06-27 14:40:01.49993	2822
29657	42	2016-06-27 14:40:01.506061	2821
29658	42	2016-06-27 14:40:01.512446	2824
29659	42	2016-06-27 14:40:01.518431	2823
29660	48	2016-06-27 14:40:01.526895	2821
29661	48	2016-06-27 14:40:01.532847	2822
29662	48	2016-06-27 14:40:01.538593	2825
29663	48	2016-06-27 14:40:01.544636	2819
29664	48	2016-06-27 14:40:01.550586	2823
29665	48	2016-06-27 14:40:01.556482	2824
29666	48	2016-06-27 14:40:01.563015	2820
29667	47	2016-06-27 14:40:01.569602	2821
29668	47	2016-06-27 14:40:01.575476	2822
29669	47	2016-06-27 14:40:01.581257	2825
29670	47	2016-06-27 14:40:01.587227	2819
29671	47	2016-06-27 14:40:01.594027	2823
29672	47	2016-06-27 14:40:01.60071	2824
29673	47	2016-06-27 14:40:01.606409	2820
29674	42	2016-06-27 14:41:05.340479	2820
29675	42	2016-06-27 14:41:05.346988	2825
29676	42	2016-06-27 14:41:05.353601	2826
29677	42	2016-06-27 14:41:05.359888	2819
29678	42	2016-06-27 14:41:05.366426	2822
29679	42	2016-06-27 14:41:05.37247	2821
29680	42	2016-06-27 14:41:05.379082	2824
29681	42	2016-06-27 14:41:05.385575	2823
29682	48	2016-06-27 14:41:05.394386	2821
29683	48	2016-06-27 14:41:05.401107	2822
29684	48	2016-06-27 14:41:05.40765	2825
29685	48	2016-06-27 14:41:05.414398	2819
29686	48	2016-06-27 14:41:05.421113	2823
29687	48	2016-06-27 14:41:05.427442	2824
29688	48	2016-06-27 14:41:05.434681	2820
29689	47	2016-06-27 14:41:05.442196	2822
29690	47	2016-06-27 14:41:05.448394	2825
29691	47	2016-06-27 14:41:05.455074	2819
29692	47	2016-06-27 14:41:05.461212	2823
29693	47	2016-06-27 14:41:05.467272	2826
29694	47	2016-06-27 14:41:05.473509	2824
29695	47	2016-06-27 14:41:05.479809	2820
29696	47	2016-06-27 14:41:05.486114	2821
29697	42	2016-06-27 14:41:57.818442	2827
29698	42	2016-06-27 15:24:08.298101	2820
29699	42	2016-06-27 15:24:08.304684	2825
29700	42	2016-06-27 15:24:08.311156	2826
29701	42	2016-06-27 15:24:08.317056	2819
29702	42	2016-06-27 15:24:08.323222	2822
29703	42	2016-06-27 15:24:08.329788	2821
29704	42	2016-06-27 15:24:08.335358	2827
29705	42	2016-06-27 15:24:08.34212	2824
29706	42	2016-06-27 15:24:08.34823	2823
29707	42	2016-06-27 15:24:08.353997	2828
29708	48	2016-06-27 15:24:08.362851	2822
29709	48	2016-06-27 15:24:08.368821	2825
29710	48	2016-06-27 15:24:08.375121	2819
29711	48	2016-06-27 15:24:08.381165	2823
29712	48	2016-06-27 15:24:08.386785	2826
29713	48	2016-06-27 15:24:08.392663	2824
29714	48	2016-06-27 15:24:08.399259	2820
29715	48	2016-06-27 15:24:08.405333	2821
29716	47	2016-06-27 15:24:08.412745	2822
29717	47	2016-06-27 15:24:08.418654	2825
29718	47	2016-06-27 15:24:08.425631	2819
29719	47	2016-06-27 15:24:08.431395	2823
29720	47	2016-06-27 15:24:08.437108	2826
29721	47	2016-06-27 15:24:08.443148	2827
29722	47	2016-06-27 15:24:08.44882	2824
29723	47	2016-06-27 15:24:08.454665	2820
29724	47	2016-06-27 15:24:08.46048	2821
29725	42	2016-06-27 15:39:43.429741	2820
29726	42	2016-06-27 15:39:43.435736	2825
29727	42	2016-06-27 15:39:43.441105	2826
29728	42	2016-06-27 15:39:43.446815	2819
29729	42	2016-06-27 15:39:43.45314	2822
29730	42	2016-06-27 15:39:43.458876	2821
29731	42	2016-06-27 15:39:43.464593	2827
29732	42	2016-06-27 15:39:43.470587	2824
29733	42	2016-06-27 15:39:43.476215	2823
29734	42	2016-06-27 15:39:43.481809	2828
29735	48	2016-06-27 15:39:43.490027	2819
29736	48	2016-06-27 15:39:43.496012	2823
29737	48	2016-06-27 15:39:43.501852	2826
29738	48	2016-06-27 15:39:43.507691	2827
29739	48	2016-06-27 15:39:43.513739	2824
29740	48	2016-06-27 15:39:43.519906	2820
29741	48	2016-06-27 15:39:43.526018	2821
29742	48	2016-06-27 15:39:43.53205	2822
29743	48	2016-06-27 15:39:43.538502	2825
29744	47	2016-06-27 15:39:43.544947	2819
29745	47	2016-06-27 15:39:43.550766	2823
29746	47	2016-06-27 15:39:43.5564	2826
29747	47	2016-06-27 15:39:43.56278	2827
29748	47	2016-06-27 15:39:43.56934	2824
29749	47	2016-06-27 15:39:43.575369	2820
29750	47	2016-06-27 15:39:43.581136	2821
29751	47	2016-06-27 15:39:43.587103	2828
29752	47	2016-06-27 15:39:43.592926	2822
29753	47	2016-06-27 15:39:43.598627	2825
29754	42	2016-06-27 16:32:37.47877	2826
29755	42	2016-06-27 16:32:37.486232	2819
29756	42	2016-06-27 16:32:37.492541	2820
29757	42	2016-06-27 16:32:37.499235	2825
29758	42	2016-06-27 16:32:37.506108	2822
29759	42	2016-06-27 16:32:37.512514	2824
29760	42	2016-06-27 16:32:37.518893	2823
29761	42	2016-06-27 16:32:37.525465	2821
29762	42	2016-06-27 16:32:37.53197	2828
29763	42	2016-06-27 16:32:37.537717	2827
29764	48	2016-06-27 16:32:37.546738	2819
29765	48	2016-06-27 16:32:37.553049	2823
29766	48	2016-06-27 16:32:37.559537	2826
29767	48	2016-06-27 16:32:37.566436	2827
29768	48	2016-06-27 16:32:37.572757	2824
29769	48	2016-06-27 16:32:37.581883	2820
29770	48	2016-06-27 16:32:37.588643	2821
29771	48	2016-06-27 16:32:37.594807	2828
29772	48	2016-06-27 16:32:37.601584	2822
29773	48	2016-06-27 16:32:37.607796	2825
29774	47	2016-06-27 16:32:37.614519	2819
29775	47	2016-06-27 16:32:37.620938	2823
29776	47	2016-06-27 16:32:37.626677	2826
29777	47	2016-06-27 16:32:37.634525	2827
29778	47	2016-06-27 16:32:37.641214	2824
29779	47	2016-06-27 16:32:37.648013	2820
29780	47	2016-06-27 16:32:37.655968	2821
29781	47	2016-06-27 16:32:37.661921	2828
29782	47	2016-06-27 16:32:37.668678	2822
29783	47	2016-06-27 16:32:37.675059	2825
29784	42	2016-06-27 16:33:52.191306	2826
29785	42	2016-06-27 16:33:52.198668	2819
29786	42	2016-06-27 16:33:52.204791	2820
29787	42	2016-06-27 16:33:52.210887	2825
29788	42	2016-06-27 16:33:52.217241	2822
29789	42	2016-06-27 16:33:52.22293	2824
29790	42	2016-06-27 16:33:52.228754	2823
29791	42	2016-06-27 16:33:52.234545	2821
29792	42	2016-06-27 16:33:52.240223	2828
29793	42	2016-06-27 16:33:52.24633	2827
29794	48	2016-06-27 16:33:52.254415	2819
29795	48	2016-06-27 16:33:52.261978	2823
29796	48	2016-06-27 16:33:52.26822	2826
29797	48	2016-06-27 16:33:52.274325	2827
29798	48	2016-06-27 16:33:52.280803	2824
29799	48	2016-06-27 16:33:52.286852	2820
29800	48	2016-06-27 16:33:52.293133	2821
29801	48	2016-06-27 16:33:52.299458	2828
29802	48	2016-06-27 16:33:52.305564	2822
29803	48	2016-06-27 16:33:52.312434	2825
29804	47	2016-06-27 16:33:52.319132	2819
29805	47	2016-06-27 16:33:52.325124	2823
29806	47	2016-06-27 16:33:52.331583	2826
29807	47	2016-06-27 16:33:52.338202	2827
29808	47	2016-06-27 16:33:52.34491	2824
29809	47	2016-06-27 16:33:52.351337	2820
29810	47	2016-06-27 16:33:52.35746	2821
29811	47	2016-06-27 16:33:52.364599	2828
29812	47	2016-06-27 16:33:52.370841	2822
29813	47	2016-06-27 16:33:52.377404	2825
29814	42	2016-06-27 16:34:58.723078	2826
29815	42	2016-06-27 16:34:58.730385	2819
29816	42	2016-06-27 16:34:58.737147	2820
29817	42	2016-06-27 16:34:58.743905	2825
29818	42	2016-06-27 16:34:58.750771	2822
29819	42	2016-06-27 16:34:58.756707	2824
29820	42	2016-06-27 16:34:58.765255	2823
29821	42	2016-06-27 16:34:58.772148	2821
29822	42	2016-06-27 16:34:58.778392	2828
29823	42	2016-06-27 16:34:58.785627	2827
29824	48	2016-06-27 16:34:58.794132	2819
29825	48	2016-06-27 16:34:58.800719	2823
29826	48	2016-06-27 16:34:58.806873	2826
29827	48	2016-06-27 16:34:58.812902	2827
29828	48	2016-06-27 16:34:58.819237	2824
29829	48	2016-06-27 16:34:58.825325	2820
29830	48	2016-06-27 16:34:58.831505	2821
29831	48	2016-06-27 16:34:58.838061	2828
29832	48	2016-06-27 16:34:58.844668	2822
29833	48	2016-06-27 16:34:58.851218	2825
29834	47	2016-06-27 16:34:58.858445	2819
29835	47	2016-06-27 16:34:58.8649	2823
29836	47	2016-06-27 16:34:58.871119	2826
29837	47	2016-06-27 16:34:58.877126	2827
29838	47	2016-06-27 16:34:58.883217	2824
29839	47	2016-06-27 16:34:58.889562	2820
29840	47	2016-06-27 16:34:58.896209	2821
29841	47	2016-06-27 16:34:58.902639	2828
29842	47	2016-06-27 16:34:58.908698	2822
29843	47	2016-06-27 16:34:58.914573	2825
29844	42	2016-06-27 16:37:05.862326	2826
29845	42	2016-06-27 16:37:05.870178	2819
29846	42	2016-06-27 16:37:05.876727	2820
29847	42	2016-06-27 16:37:05.883025	2825
29848	42	2016-06-27 16:37:05.889577	2822
29849	42	2016-06-27 16:37:05.895595	2823
29850	42	2016-06-27 16:37:05.902185	2821
29851	42	2016-06-27 16:37:05.90794	2828
29852	42	2016-06-27 16:37:05.913902	2827
29853	42	2016-06-27 16:37:05.920075	2829
29854	42	2016-06-27 16:37:05.926286	2830
29855	42	2016-06-27 16:37:05.932031	2824
29856	48	2016-06-27 16:37:05.940838	2819
29857	48	2016-06-27 16:37:05.946964	2823
29858	48	2016-06-27 16:37:05.953192	2826
29859	48	2016-06-27 16:37:05.95973	2827
29860	48	2016-06-27 16:37:05.965887	2824
29861	48	2016-06-27 16:37:05.972109	2820
29862	48	2016-06-27 16:37:05.979141	2821
29863	48	2016-06-27 16:37:05.985721	2828
29864	48	2016-06-27 16:37:05.992017	2822
29865	48	2016-06-27 16:37:05.998047	2825
29866	47	2016-06-27 16:37:06.004633	2819
29867	47	2016-06-27 16:37:06.0107	2823
29868	47	2016-06-27 16:37:06.016637	2826
29869	47	2016-06-27 16:37:06.022923	2827
29870	47	2016-06-27 16:37:06.029025	2824
29871	47	2016-06-27 16:37:06.03537	2820
29872	47	2016-06-27 16:37:06.041416	2821
29873	47	2016-06-27 16:37:06.047381	2828
29874	47	2016-06-27 16:37:06.053497	2822
29875	47	2016-06-27 16:37:06.059474	2825
29876	42	2016-06-27 16:38:03.50928	2831
29877	43	2016-06-27 16:38:03.516842	2832
29878	42	2016-06-27 16:38:32.512134	2826
29879	42	2016-06-27 16:38:32.519381	2819
29880	42	2016-06-27 16:38:32.525161	2820
29881	42	2016-06-27 16:38:32.531223	2825
29882	42	2016-06-27 16:38:32.537232	2822
29883	42	2016-06-27 16:38:32.543529	2821
29884	42	2016-06-27 16:38:32.549594	2828
29885	42	2016-06-27 16:38:32.55509	2833
29886	42	2016-06-27 16:38:32.562272	2827
29887	42	2016-06-27 16:38:32.569532	2829
29888	42	2016-06-27 16:38:32.575853	2830
29889	42	2016-06-27 16:38:32.581948	2824
29890	42	2016-06-27 16:38:32.593596	2823
29891	48	2016-06-27 16:38:32.607791	2819
29892	48	2016-06-27 16:38:32.613961	2823
29893	48	2016-06-27 16:38:32.619881	2826
29894	48	2016-06-27 16:38:32.626366	2827
29895	48	2016-06-27 16:38:32.632722	2824
29896	48	2016-06-27 16:38:32.639154	2820
29897	48	2016-06-27 16:38:32.645275	2821
29898	48	2016-06-27 16:38:32.651395	2828
29899	48	2016-06-27 16:38:32.65785	2822
29900	48	2016-06-27 16:38:32.664095	2825
29901	47	2016-06-27 16:38:32.670901	2819
29902	47	2016-06-27 16:38:32.677102	2823
29903	47	2016-06-27 16:38:32.683365	2826
29904	47	2016-06-27 16:38:32.689557	2827
29905	47	2016-06-27 16:38:32.695643	2824
29906	47	2016-06-27 16:38:32.701605	2820
29907	47	2016-06-27 16:38:32.707544	2830
29908	47	2016-06-27 16:38:32.714063	2821
29909	47	2016-06-27 16:38:32.719976	2828
29910	47	2016-06-27 16:38:32.726027	2822
29911	47	2016-06-27 16:38:32.731913	2825
29912	47	2016-06-27 16:38:32.738009	2829
29913	42	2016-06-27 16:39:13.615612	2831
29914	43	2016-06-27 16:39:13.627741	2832
29915	47	2016-06-27 16:39:13.765371	2831
29916	42	2016-06-27 16:39:34.624662	2826
29917	42	2016-06-27 16:39:34.632712	2819
29918	42	2016-06-27 16:39:34.638802	2820
29919	42	2016-06-27 16:39:34.644679	2825
29920	42	2016-06-27 16:39:34.651398	2822
29921	42	2016-06-27 16:39:34.657239	2821
29922	42	2016-06-27 16:39:34.663936	2828
29923	42	2016-06-27 16:39:34.670157	2833
29924	42	2016-06-27 16:39:34.676058	2827
29925	42	2016-06-27 16:39:34.68224	2829
29926	42	2016-06-27 16:39:34.688343	2830
29927	42	2016-06-27 16:39:34.694113	2824
29928	42	2016-06-27 16:39:34.705918	2823
29929	48	2016-06-27 16:39:34.720276	2819
29930	48	2016-06-27 16:39:34.726496	2823
29931	48	2016-06-27 16:39:34.733415	2826
29932	48	2016-06-27 16:39:34.739581	2827
29933	48	2016-06-27 16:39:34.74575	2824
29934	48	2016-06-27 16:39:34.752593	2820
29935	48	2016-06-27 16:39:34.759303	2830
29936	48	2016-06-27 16:39:34.766245	2821
29937	48	2016-06-27 16:39:34.772538	2828
29938	48	2016-06-27 16:39:34.778701	2822
29939	48	2016-06-27 16:39:34.785438	2825
29940	48	2016-06-27 16:39:34.791686	2829
29941	47	2016-06-27 16:39:34.799054	2819
29942	47	2016-06-27 16:39:34.805223	2823
29943	47	2016-06-27 16:39:34.811135	2826
29944	47	2016-06-27 16:39:34.817686	2827
29945	47	2016-06-27 16:39:34.823735	2824
29946	47	2016-06-27 16:39:34.82964	2820
29947	47	2016-06-27 16:39:34.836355	2830
29948	47	2016-06-27 16:39:34.842644	2821
29949	47	2016-06-27 16:39:34.849446	2828
29950	47	2016-06-27 16:39:34.855566	2822
29951	47	2016-06-27 16:39:34.861982	2825
29952	47	2016-06-27 16:39:34.869016	2829
29953	47	2016-06-27 16:39:34.881502	2833
29954	42	2016-06-27 16:40:20.937829	2831
29955	43	2016-06-27 16:40:20.950633	2832
29956	48	2016-06-27 16:40:21.037794	2831
29957	47	2016-06-27 16:40:21.114935	2831
29958	42	2016-06-27 16:40:24.797718	2834
29959	43	2016-06-27 16:40:24.861557	2835
29960	42	2016-06-27 16:43:13.750169	2837
29961	42	2016-06-27 16:43:13.75772	2819
29962	42	2016-06-27 16:43:13.763935	2820
29963	42	2016-06-27 16:43:13.769966	2825
29964	42	2016-06-27 16:43:13.776951	2834
29965	42	2016-06-27 16:43:13.783036	2822
29966	42	2016-06-27 16:43:13.789028	2821
29967	42	2016-06-27 16:43:13.795061	2827
29968	42	2016-06-27 16:43:13.800951	2829
29969	42	2016-06-27 16:43:13.807267	2830
29970	42	2016-06-27 16:43:13.8133	2824
29971	42	2016-06-27 16:43:13.819258	2831
29972	42	2016-06-27 16:43:13.825059	2823
29973	42	2016-06-27 16:43:13.831694	2838
29974	42	2016-06-27 16:43:13.838936	2828
29975	42	2016-06-27 16:43:13.845417	2833
29976	42	2016-06-27 16:43:13.851218	2826
29977	42	2016-06-27 16:43:13.857107	2836
29978	43	2016-06-27 16:43:13.863691	2835
29979	43	2016-06-27 16:43:13.869721	2832
29980	48	2016-06-27 16:43:13.878527	2819
29981	48	2016-06-27 16:43:13.885035	2823
29982	48	2016-06-27 16:43:13.891301	2826
29983	48	2016-06-27 16:43:13.898242	2827
29984	48	2016-06-27 16:43:13.904654	2824
29985	48	2016-06-27 16:43:13.911366	2820
29986	48	2016-06-27 16:43:13.917843	2830
29987	48	2016-06-27 16:43:13.926621	2821
29988	48	2016-06-27 16:43:13.933449	2828
29989	48	2016-06-27 16:43:13.940088	2822
29990	48	2016-06-27 16:43:13.94678	2825
29991	48	2016-06-27 16:43:13.953258	2829
29992	48	2016-06-27 16:43:13.959776	2831
29993	48	2016-06-27 16:43:13.967697	2833
29994	47	2016-06-27 16:43:13.975001	2819
29995	47	2016-06-27 16:43:13.981747	2823
29996	47	2016-06-27 16:43:13.987848	2826
29997	47	2016-06-27 16:43:13.994169	2827
29998	47	2016-06-27 16:43:14.00067	2824
29999	47	2016-06-27 16:43:14.006851	2820
30000	47	2016-06-27 16:43:14.013499	2830
30001	47	2016-06-27 16:43:14.020043	2821
30002	47	2016-06-27 16:43:14.026331	2828
30003	47	2016-06-27 16:43:14.032802	2822
30004	47	2016-06-27 16:43:14.039392	2825
30005	47	2016-06-27 16:43:14.046012	2829
30006	47	2016-06-27 16:43:14.052226	2831
30007	47	2016-06-27 16:43:14.058331	2834
30008	47	2016-06-27 16:43:14.064186	2833
30009	42	2016-06-27 16:45:26.599335	2837
30010	42	2016-06-27 16:45:26.606178	2820
30011	42	2016-06-27 16:45:26.612908	2825
30012	42	2016-06-27 16:45:26.61916	2822
30013	42	2016-06-27 16:45:26.625631	2821
30014	42	2016-06-27 16:45:26.631834	2827
30015	42	2016-06-27 16:45:26.638248	2829
30016	42	2016-06-27 16:45:26.644802	2830
30017	42	2016-06-27 16:45:26.650961	2824
30018	42	2016-06-27 16:45:26.65697	2839
30019	42	2016-06-27 16:45:26.663947	2831
30020	42	2016-06-27 16:45:26.670834	2823
30021	42	2016-06-27 16:45:26.677262	2838
30022	42	2016-06-27 16:45:26.683359	2828
30023	42	2016-06-27 16:45:26.689203	2833
30024	42	2016-06-27 16:45:26.695676	2826
30025	42	2016-06-27 16:45:26.701725	2836
30026	42	2016-06-27 16:45:26.707897	2819
30027	42	2016-06-27 16:45:26.713842	2834
30028	43	2016-06-27 16:45:26.720139	2832
30029	43	2016-06-27 16:45:26.726602	2835
30030	43	2016-06-27 16:45:26.732676	2840
30031	48	2016-06-27 16:45:26.741124	2819
30032	48	2016-06-27 16:45:26.747654	2823
30033	48	2016-06-27 16:45:26.754477	2826
30034	48	2016-06-27 16:45:26.761637	2827
30035	48	2016-06-27 16:45:26.768221	2824
30036	48	2016-06-27 16:45:26.774646	2820
30037	48	2016-06-27 16:45:26.781176	2821
30038	48	2016-06-27 16:45:26.787764	2828
30039	48	2016-06-27 16:45:26.794428	2822
30040	48	2016-06-27 16:45:26.800924	2825
30041	48	2016-06-27 16:45:26.807057	2829
30042	48	2016-06-27 16:45:26.814459	2831
30043	48	2016-06-27 16:45:26.821625	2834
30044	48	2016-06-27 16:45:26.828134	2833
30045	48	2016-06-27 16:45:26.834663	2830
30046	47	2016-06-27 16:45:26.84138	2838
30047	47	2016-06-27 16:45:26.848078	2819
30048	47	2016-06-27 16:45:26.854647	2823
30049	47	2016-06-27 16:45:26.861206	2826
30050	47	2016-06-27 16:45:26.867621	2827
30051	47	2016-06-27 16:45:26.873992	2824
30052	47	2016-06-27 16:45:26.881127	2820
30053	47	2016-06-27 16:45:26.887174	2836
30054	47	2016-06-27 16:45:26.893875	2821
30055	47	2016-06-27 16:45:26.90011	2828
30056	47	2016-06-27 16:45:26.906569	2822
30057	47	2016-06-27 16:45:26.913614	2825
30058	47	2016-06-27 16:45:26.919843	2829
30059	47	2016-06-27 16:45:26.926001	2831
30060	47	2016-06-27 16:45:26.932389	2834
30061	47	2016-06-27 16:45:26.939124	2837
30062	47	2016-06-27 16:45:26.9455	2833
30063	47	2016-06-27 16:45:26.951824	2830
30064	42	2016-06-27 16:53:18.090694	2837
30065	42	2016-06-27 16:53:18.136534	2820
30066	42	2016-06-27 16:53:18.144805	2825
30067	42	2016-06-27 16:53:18.154654	2822
30068	42	2016-06-27 16:53:18.16142	2821
30069	42	2016-06-27 16:53:18.16929	2827
30070	42	2016-06-27 16:53:18.208421	2829
30071	42	2016-06-27 16:53:18.220907	2830
30072	42	2016-06-27 16:53:18.22795	2824
30073	42	2016-06-27 16:53:18.24162	2839
30074	42	2016-06-27 16:53:18.262087	2831
30075	42	2016-06-27 16:53:18.275269	2823
30076	42	2016-06-27 16:53:18.297659	2838
30077	42	2016-06-27 16:53:18.31915	2828
30078	42	2016-06-27 16:53:18.333607	2833
30079	42	2016-06-27 16:53:18.354907	2826
30080	42	2016-06-27 16:53:18.370567	2836
30081	42	2016-06-27 16:53:18.386341	2819
30082	42	2016-06-27 16:53:18.403037	2834
30083	43	2016-06-27 16:53:18.409846	2832
30084	43	2016-06-27 16:53:18.424637	2835
30085	43	2016-06-27 16:53:18.432268	2840
30086	48	2016-06-27 16:53:18.453166	2838
30087	48	2016-06-27 16:53:18.466801	2823
30088	48	2016-06-27 16:53:18.47598	2824
30089	48	2016-06-27 16:53:18.493523	2820
30090	48	2016-06-27 16:53:18.500205	2836
30091	48	2016-06-27 16:53:18.518957	2821
30092	48	2016-06-27 16:53:18.533565	2828
30093	48	2016-06-27 16:53:18.545145	2822
30094	48	2016-06-27 16:53:18.552397	2825
30095	48	2016-06-27 16:53:18.565055	2829
30096	48	2016-06-27 16:53:18.57857	2831
30097	48	2016-06-27 16:53:18.592342	2834
30098	48	2016-06-27 16:53:18.604113	2837
30099	48	2016-06-27 16:53:18.61555	2833
30100	48	2016-06-27 16:53:18.623046	2830
30101	48	2016-06-27 16:53:18.635784	2819
30102	48	2016-06-27 16:53:18.644599	2826
30103	48	2016-06-27 16:53:18.651335	2827
30104	47	2016-06-27 16:53:18.659227	2838
30105	47	2016-06-27 16:53:18.666111	2823
30106	47	2016-06-27 16:53:18.672472	2824
30107	47	2016-06-27 16:53:18.679644	2820
30108	47	2016-06-27 16:53:18.686746	2836
30109	47	2016-06-27 16:53:18.692988	2821
30110	47	2016-06-27 16:53:18.700209	2828
30111	47	2016-06-27 16:53:18.709308	2822
30112	47	2016-06-27 16:53:18.716351	2825
30113	47	2016-06-27 16:53:18.723047	2829
30114	47	2016-06-27 16:53:18.729283	2839
30115	47	2016-06-27 16:53:18.736298	2831
30116	47	2016-06-27 16:53:18.743433	2834
30117	47	2016-06-27 16:53:18.750056	2837
30118	47	2016-06-27 16:53:18.756701	2833
30119	47	2016-06-27 16:53:18.763195	2830
30120	47	2016-06-27 16:53:18.77012	2819
30121	47	2016-06-27 16:53:18.778609	2826
30122	47	2016-06-27 16:53:18.785186	2827
30123	42	2016-06-27 17:00:09.794212	2837
30124	42	2016-06-27 17:00:09.806187	2820
30125	42	2016-06-27 17:00:09.864951	2825
30126	42	2016-06-27 17:00:09.888207	2822
30127	42	2016-06-27 17:00:09.90016	2821
30128	42	2016-06-27 17:00:09.914087	2827
30129	42	2016-06-27 17:00:09.930971	2829
30130	42	2016-06-27 17:00:09.939014	2830
30131	42	2016-06-27 17:00:09.945053	2824
30132	42	2016-06-27 17:00:09.951451	2839
30133	42	2016-06-27 17:00:09.957214	2831
30134	42	2016-06-27 17:00:09.963149	2823
30135	42	2016-06-27 17:00:09.968905	2838
30136	42	2016-06-27 17:00:09.974842	2828
30137	42	2016-06-27 17:00:09.980595	2833
30138	42	2016-06-27 17:00:09.986717	2826
30139	42	2016-06-27 17:00:09.992543	2836
30140	42	2016-06-27 17:00:09.99835	2819
30141	42	2016-06-27 17:00:10.003947	2834
30142	43	2016-06-27 17:00:10.010117	2832
30143	43	2016-06-27 17:00:10.016052	2835
30144	43	2016-06-27 17:00:10.021803	2840
30145	48	2016-06-27 17:00:10.030476	2838
30146	48	2016-06-27 17:00:10.036856	2823
30147	48	2016-06-27 17:00:10.043456	2824
30148	48	2016-06-27 17:00:10.049785	2820
30149	48	2016-06-27 17:00:10.05592	2836
30150	48	2016-06-27 17:00:10.062206	2821
30151	48	2016-06-27 17:00:10.069094	2828
30152	48	2016-06-27 17:00:10.07655	2822
30153	48	2016-06-27 17:00:10.083042	2825
30154	48	2016-06-27 17:00:10.089881	2829
30155	48	2016-06-27 17:00:10.096095	2839
30156	48	2016-06-27 17:00:10.10261	2831
30157	48	2016-06-27 17:00:10.109132	2834
30158	48	2016-06-27 17:00:10.115585	2837
30159	48	2016-06-27 17:00:10.12196	2833
30160	48	2016-06-27 17:00:10.128526	2830
30161	48	2016-06-27 17:00:10.135063	2819
30162	48	2016-06-27 17:00:10.141639	2826
30163	48	2016-06-27 17:00:10.148142	2827
30164	47	2016-06-27 17:00:10.155567	2838
30165	47	2016-06-27 17:00:10.162134	2823
30166	47	2016-06-27 17:00:10.168285	2824
30167	47	2016-06-27 17:00:10.175005	2820
30168	47	2016-06-27 17:00:10.181002	2836
30169	47	2016-06-27 17:00:10.187343	2821
30170	47	2016-06-27 17:00:10.194176	2828
30171	47	2016-06-27 17:00:10.200611	2822
30172	47	2016-06-27 17:00:10.207242	2825
30173	47	2016-06-27 17:00:10.214279	2829
30174	47	2016-06-27 17:00:10.221247	2839
30175	47	2016-06-27 17:00:10.227473	2831
30176	47	2016-06-27 17:00:10.233636	2834
30177	47	2016-06-27 17:00:10.239733	2837
30178	47	2016-06-27 17:00:10.246171	2833
30179	47	2016-06-27 17:00:10.252643	2830
30180	47	2016-06-27 17:00:10.258927	2819
30181	47	2016-06-27 17:00:10.265205	2826
30182	47	2016-06-27 17:00:10.271838	2827
30183	42	2016-06-27 17:49:07.263222	2837
30184	42	2016-06-27 17:49:07.278288	2820
30185	42	2016-06-27 17:49:07.293173	2825
30186	42	2016-06-27 17:49:07.314525	2821
30187	42	2016-06-27 17:49:07.336641	2827
30188	42	2016-06-27 17:49:07.350946	2829
30189	42	2016-06-27 17:49:07.360535	2830
30190	42	2016-06-27 17:49:07.376791	2841
30191	42	2016-06-27 17:49:07.39813	2824
30192	42	2016-06-27 17:49:07.404647	2839
30193	42	2016-06-27 17:49:07.420116	2831
30194	42	2016-06-27 17:49:07.426759	2823
30195	42	2016-06-27 17:49:07.445899	2838
30196	42	2016-06-27 17:49:07.461538	2828
30197	42	2016-06-27 17:49:07.470415	2833
30198	42	2016-06-27 17:49:07.487903	2826
30199	42	2016-06-27 17:49:07.495166	2836
30200	42	2016-06-27 17:49:07.513566	2819
30201	42	2016-06-27 17:49:07.527966	2834
30202	42	2016-06-27 17:49:07.539436	2822
30203	43	2016-06-27 17:49:07.547044	2842
30204	43	2016-06-27 17:49:07.560083	2835
30205	43	2016-06-27 17:49:07.56617	2840
30206	43	2016-06-27 17:49:07.577073	2832
30207	48	2016-06-27 17:49:07.592021	2838
30208	48	2016-06-27 17:49:07.609147	2823
30209	48	2016-06-27 17:49:07.61786	2824
30210	48	2016-06-27 17:49:07.62544	2820
30211	48	2016-06-27 17:49:07.63181	2836
30212	48	2016-06-27 17:49:07.638384	2821
30213	48	2016-06-27 17:49:07.64531	2828
30214	48	2016-06-27 17:49:07.6517	2822
30215	48	2016-06-27 17:49:07.659085	2825
30216	48	2016-06-27 17:49:07.665454	2829
30217	48	2016-06-27 17:49:07.671963	2839
30218	48	2016-06-27 17:49:07.679608	2831
30219	48	2016-06-27 17:49:07.685852	2834
30220	48	2016-06-27 17:49:07.692723	2837
30221	48	2016-06-27 17:49:07.698931	2833
30222	48	2016-06-27 17:49:07.705355	2830
30223	48	2016-06-27 17:49:07.712133	2819
30224	48	2016-06-27 17:49:07.718361	2826
30225	48	2016-06-27 17:49:07.725387	2827
30226	47	2016-06-27 17:49:07.732318	2838
30227	47	2016-06-27 17:49:07.738821	2823
30228	47	2016-06-27 17:49:07.746003	2824
30229	47	2016-06-27 17:49:07.754496	2820
30230	47	2016-06-27 17:49:07.760818	2836
30231	47	2016-06-27 17:49:07.767256	2821
30232	47	2016-06-27 17:49:07.773479	2828
30233	47	2016-06-27 17:49:07.780554	2822
30234	47	2016-06-27 17:49:07.787776	2825
30235	47	2016-06-27 17:49:07.796641	2829
30236	47	2016-06-27 17:49:07.806705	2839
30237	47	2016-06-27 17:49:07.814534	2831
30238	47	2016-06-27 17:49:07.820584	2834
30239	47	2016-06-27 17:49:07.826929	2837
30240	47	2016-06-27 17:49:07.833195	2833
30241	47	2016-06-27 17:49:07.839337	2830
30242	47	2016-06-27 17:49:07.845609	2819
30243	47	2016-06-27 17:49:07.851406	2826
30244	47	2016-06-27 17:49:07.857659	2827
30245	42	2016-06-27 18:13:17.630246	2837
30246	42	2016-06-27 18:13:17.637192	2820
30247	42	2016-06-27 18:13:17.643225	2825
30248	42	2016-06-27 18:13:17.649068	2821
30249	42	2016-06-27 18:13:17.656103	2827
30250	42	2016-06-27 18:13:17.662224	2829
30251	42	2016-06-27 18:13:17.668218	2830
30252	42	2016-06-27 18:13:17.674593	2841
30253	42	2016-06-27 18:13:17.680405	2824
30254	42	2016-06-27 18:13:17.686654	2839
30255	42	2016-06-27 18:13:17.693177	2831
30256	42	2016-06-27 18:13:17.699228	2823
30257	42	2016-06-27 18:13:17.706138	2838
30258	42	2016-06-27 18:13:17.712085	2828
30259	42	2016-06-27 18:13:17.719043	2833
30260	42	2016-06-27 18:13:17.724922	2826
30261	42	2016-06-27 18:13:17.730995	2836
30262	42	2016-06-27 18:13:17.737828	2819
30263	42	2016-06-27 18:13:17.743706	2834
30264	42	2016-06-27 18:13:17.749708	2822
30265	43	2016-06-27 18:13:17.756341	2842
30266	43	2016-06-27 18:13:17.762041	2835
30267	43	2016-06-27 18:13:17.770388	2840
30268	43	2016-06-27 18:13:17.776579	2832
30269	48	2016-06-27 18:13:17.785621	2838
30270	48	2016-06-27 18:13:17.7925	2823
30271	48	2016-06-27 18:13:17.798764	2824
30272	48	2016-06-27 18:13:17.806535	2820
30273	48	2016-06-27 18:13:17.81287	2836
30274	48	2016-06-27 18:13:17.81979	2821
30275	48	2016-06-27 18:13:17.826397	2828
30276	48	2016-06-27 18:13:17.832665	2822
30277	48	2016-06-27 18:13:17.839702	2825
30278	48	2016-06-27 18:13:17.846098	2829
30279	48	2016-06-27 18:13:17.852884	2839
30280	48	2016-06-27 18:13:17.859415	2831
30281	48	2016-06-27 18:13:17.865596	2834
30282	48	2016-06-27 18:13:17.87259	2837
30283	48	2016-06-27 18:13:17.878821	2833
30284	48	2016-06-27 18:13:17.885205	2830
30285	48	2016-06-27 18:13:17.891978	2819
30286	48	2016-06-27 18:13:17.898028	2826
30287	48	2016-06-27 18:13:17.905072	2827
30288	47	2016-06-27 18:13:17.91194	2838
30289	47	2016-06-27 18:13:17.918292	2823
30290	47	2016-06-27 18:13:17.924399	2824
30291	47	2016-06-27 18:13:17.93049	2820
30292	47	2016-06-27 18:13:17.936805	2836
30293	47	2016-06-27 18:13:17.943352	2821
30294	47	2016-06-27 18:13:17.950221	2828
30295	47	2016-06-27 18:13:17.956829	2822
30296	47	2016-06-27 18:13:17.96305	2825
30297	47	2016-06-27 18:13:17.969216	2829
30298	47	2016-06-27 18:13:17.975682	2839
30299	47	2016-06-27 18:13:17.98202	2831
30300	47	2016-06-27 18:13:17.98813	2834
30301	47	2016-06-27 18:13:17.994905	2837
30302	47	2016-06-27 18:13:18.001176	2841
30303	47	2016-06-27 18:13:18.007542	2833
30304	47	2016-06-27 18:13:18.013953	2830
30305	47	2016-06-27 18:13:18.020162	2819
30306	47	2016-06-27 18:13:18.02649	2826
30307	47	2016-06-27 18:13:18.033008	2827
\.


--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_notificacoes_id_seq', 30307, true);


--
-- Data for Name: tipos_processo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipos_processo (id, tipo, id_pai, regra_finalizacao, regra_handover, avanca_processo_filhos_fechados) FROM stdin;
3	Avaliação	2	\N	ANYTIME	\N
1	Vaga	\N	\N	ANYTIME	\N
4	Prospecção	1	\N	ANYTIME	\N
2	Candidato	1	\N	TODOS_FILHOS_FECHADOS	4
\.


--
-- Name: tipos_processo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipos_processo_id_seq', 4, true);


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
37	3	1
38	5	2
39	6	3
40	7	4
41	3	4
42	5	3
43	7	1
\.


--
-- Name: usuarios_avaliadores_tecnologias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuarios_avaliadores_tecnologias_id_seq', 43, true);


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

COPY workflow_dados (id, idpostocampo, valor, idprocesso, registro, idposto, idworkflowtramitacao) FROM stdin;
6117	13	Android	47673	2016-06-27 13:33:17.189313	1	2813
6118	174	 \r\n3) Teste Técnico\r\n\r\nCrie um aplicativo android para organizar a agenda de compromissos do seu usuário.\r\n\r\nEsta agenda deve:\r\n\r\n  *   Ter um sistema de autenticação para identificar o usuário.\r\n  *   Incluir novo compromisso.\r\n  *   Alterar compromisso.\r\n  *   Excluir um compromisso.\r\n  *   Buscar um compromisso.\r\n  *   Criar um alerta de um compromisso iminente. A antecedência deste alerta deve ser configurada pelo usuário.\r\n\r\nExigências:\r\n\r\n  *   Toda a comunicação deste app deve ocorrer ocorrer via webservices.\r\n  *   Todo o projeto deve ser submetido no github ou outro similar que use GIT.\r\n  *   Não se esqueça de justificar as suas escolhas (de tecnologia, layout, etc...) no arquivo README que deve acompanhar sua solução. Além de nos informar como proceder para fazer o build do APK.\r\n\r\nOutras informações\r\n\r\n  *   Documentação e testes serão avaliados também =)\r\n  *   A criação dos webservices e a tecnologia utilizadas ficam a critério do candidato.\r\n  *   O layout também fica a critério do candidato.	47673	2016-06-27 13:33:17.196782	1	2813
6119	1	Gostaríamos de anunciar que estamos buscando um novo perfil, se julgar do seu interesse fique a vontade para buscar os candidatos.\r\nLembrando que ao identificar um candidato que atenda as exigência da vaga, deve-se aplicar o teste que segue abaixo.\r\n\r\nEm tempo, seguem algumas considerações:\r\n\r\n  *   O tempo máximo para desenvolvimento do teste pelo candidato são de 15 dias corridos a partir do seu envio;\r\n  *   Somente consideraremos candidatos com teste concluído;\r\n  *   Aceitamos candidaturas (com teste) para esta vaga até o dia 25/06.\r\n\r\n1) Título da Vaga\r\nDesenvolvedor Android\r\n\r\n2) Perfil da Vaga\r\nVocê será responsável por entregar soluções inovadoras para ajudar os usuários do Walmart.com que utilizam dispositivos móveis. As soluções devem ser escaláveis para suportar milhões de clientes no Brasil e no mundo. Além de auxiliar na evolução do produto e resolver problemas que afetam o cliente durante toda a sua jornada: em busca de sortimento/catálogo de produtos, pagamento e acompanhamento de duas compras. Sempre integrado a outros times para desenvolver as melhores soluções e ferramentas para atender às necessidades de nossos usuários.\r\n\r\nConhecimentos e Experiência Profissional\r\n\r\n  *   Domínio da plataforma Java e frameworks de desenvolvimento de sistemas Web (back end)\r\n  *   Experiência no uso de tecnologias baseadas em Android,  Android SDK  e Android studio.\r\n  *   Conhecimento de estruturas com Apis Google.\r\n  *   Experiência de desenvolvimento de sistemas em ambientes distribuídos, escaláveis e de alta disponibilidade.\r\n  *   Sólidos conhecimentos em aplicações que atuam tanto como produtores quanto clientes de serviços RESTful\r\n  *   Familiaridade com NodeJS será um diferencial\r\n  *   Conhecimento de automação de testes: unitários, funcionais ou testes de integração\r\n  *   Experiência em controle de versionamento com Git (desejável)\r\n  *   Vivência com um ou mais métodos ágeis de desenvolvimento: XP (principalmente as práticas de pair programming e TDD), Scrum e Kanban\r\n  *   Inglês em nível avançado para leitura e escrita e intermediário para conversação\r\n\r\nPrincipais responsabilidades\r\n\r\n  *   Criar protótipos, executar testes, debugging, manutenção e updates nos sistemas da plataforma\r\n  *   Conceber, construir e entregar soluções enxutas, escaláveis, seguras e de fácil manutenção\r\n  *   Colaborar com outros engenheiros e gerentes de produto para impulsionar a evolução da plataforma de e-commerce do Walmart.com, criando aplicações que sigam as melhores práticas de desenvolvimento\r\n  *   Escrever e revisar documentação técnica, incluindo design/UX, desenvolvimento e código-fonte\r\n  *   Analisar, revisar e modificar software para aumentar a eficiência operacional de nossos sistemas\r\n\r\nEducação\r\n\r\n  *   Bacharelado em Ciência da Computação, Análise de Sistemas ou qualquer campo técnico relacionado (ou experiência prática equivalente)\r\n\r\nCompetências\r\n\r\n  *   Capacidade de criar soluções técnicas enxutas, inteligentes, seguras e escaláveis\r\n  *   Paixão por ouvir o cliente e trabalhar por sua satisfação\r\n  *   Paixão por inovação e espírito empreendedor\r\n  *   Perfil colaborativo, de escuta ativa, capaz de entender e traduzir casos de uso em software em produção\r\n  *   Auto-didatismo\r\n	47673	2016-06-27 13:33:17.197517	1	2813
6120	186	todas as consultorias	47673	2016-06-27 13:33:17.219056	1	2813
6121	13	Full Stack	47674	2016-06-27 13:45:43.815391	1	2815
6122	174	\r\nO Walmart possui um site bastante conhecido pela sua rapidez, qualidade do design e experiência com o usuário. Para isso resolvemos propor que você crie parte dessa experiência como teste para a vaga de Full-Stack Developer. O fluxo e os requisitos a serem desenvolvidos estão descritos a seguir:\r\n\r\n\r\nPara desenvolver esse fluxo, algumas telas devem ser criadas:\r\n- Cadastro de Produto.\r\n- Listagem dos Produto (Carrinho).\r\n- Conclusão de Compra (Checkout).\r\nRequisitos mínimos para a aplicação:\r\n- Usuário pode criar mais de um produto com o Nome e Valor como requisitos mínimos.\r\n- Aplicação deve exibir todos os produtos cadastrados e permitir que o usuário altere a quantidade de cada produto que deseja comprar na tela de Carrinho.\r\n- A compra mínima (soma de todos os valores e quantidades do produtos) deve ser de 200 reais, impossibilitando a ida para a tela de Conclusão de Compra no caso de valores menores.\r\n- Caso a compra total for maior que 400 reais, deve ser aplicado alguns dos descontos:\r\n     - Se maior que 500 reais, desconto de 5% no valor total da compra.\r\n     - Se maior que 600 reais, desconto de 10% no valor total da compra.\r\n     - Se maior que 700 reais, desconto de 15% no valor total da compra.\r\n- Caso seja entre 200 e 400 reais, não aplicar nenhum desconto.\r\n- Após os cálculos, exibir na tela de Conclusão de Compra o valor final da compra e o desconto obtido.\r\nIremos analisar os seguintes detalhes:\r\nCapacidade de resolver o problema da forma mais simples, utilizando o mínimo de código possível.\r\nManipulação correta dos valores e cálculos de desconto.\r\nOrganização da regra de negócio de uma forma coesa para as duas seguintes partes do problema:\r\nCálculo do somatório de produtos.\r\nCálculo do valor de desconto.\r\nCapacidade de reprodução do layout, estilos e design sugerido nas telas do Carrinho e Checkout. \r\nCriação da tela de cadastro nos padrões das outras duas telas.\r\nDetalhes do projeto:\r\n- Todo o projeto deve ser submetido no github ou outro similar que use GIT.\r\n- Não se esqueça de justificar as suas escolhas (de tecnologia, layout, etc...) no arquivo README que deve acompanhar sua solução. Além de nos informar como proceder para testarmos sua aplicação.\r\n\r\nOutras informações:\r\n- Documentação e testes serão avaliados também.\r\n- A utilização de ferramentas de geração de CRUD e helpers serão analisadas com critérios.\r\n- Junto ao teste deve conter como guia duas ilustrações (design) das telas de Carrinho e Checkout que gostaríamos que se baseasse para desenvolver as telas da aplicação. Seguir o mais fiel possível.\r\n\r\n\r\n \r\nDesign das Telas\r\n \r\n \r\nTela de Carrinho de Compras\r\n\r\nTela de Conclusão de Compras\r\n\r\n	47674	2016-06-27 13:45:43.816095	1	2815
6123	1	Gostaríamos de anunciar que estamos buscando um novo perfil, se julgar do seu interesse fique a vontade para buscar os candidatos. \r\nLembrando que ao identificar um candidato que atenda as exigência da vaga, deve-se aplicar o teste que segue abaixo.\r\n\r\nEm tempo, seguem algumas considerações:\r\nO tempo máximo para desenvolvimento do teste pelo candidato são de 15 dias corridos a partir do seu envio;\r\nSomente consideraremos candidatos com teste concluído;\r\nAceitamos candidaturas (com teste) para esta vaga até o dia 13/07.\r\n\r\n1) Título da Vaga\r\nDesenvolvedor\r\n\r\n2) Requisitos da Vaga\r\nRuby ; Rails ; Sidekiq ; HTML5 ; CSS ; Javascript ; SQL\r\nDiferenciais:   Chef ; Jenkins ; Vagrant ; Oracle ; SASS ; jQuery\r\n\r\n3) Teste Técnico\r\nO teste será enviado ainda esta semana.	47674	2016-06-27 13:45:43.81679	1	2815
6124	186	todas as consultorias	47674	2016-06-27 13:45:43.817208	1	2815
6125	13	Full Stack	47675	2016-06-27 13:46:21.899278	1	2817
6126	174	\r\nO Walmart possui um site bastante conhecido pela sua rapidez, qualidade do design e experiência com o usuário. Para isso resolvemos propor que você crie parte dessa experiência como teste para a vaga de Full-Stack Developer. O fluxo e os requisitos a serem desenvolvidos estão descritos a seguir:\r\n\r\n\r\nPara desenvolver esse fluxo, algumas telas devem ser criadas:\r\n- Cadastro de Produto.\r\n- Listagem dos Produto (Carrinho).\r\n- Conclusão de Compra (Checkout).\r\nRequisitos mínimos para a aplicação:\r\n- Usuário pode criar mais de um produto com o Nome e Valor como requisitos mínimos.\r\n- Aplicação deve exibir todos os produtos cadastrados e permitir que o usuário altere a quantidade de cada produto que deseja comprar na tela de Carrinho.\r\n- A compra mínima (soma de todos os valores e quantidades do produtos) deve ser de 200 reais, impossibilitando a ida para a tela de Conclusão de Compra no caso de valores menores.\r\n- Caso a compra total for maior que 400 reais, deve ser aplicado alguns dos descontos:\r\n     - Se maior que 500 reais, desconto de 5% no valor total da compra.\r\n     - Se maior que 600 reais, desconto de 10% no valor total da compra.\r\n     - Se maior que 700 reais, desconto de 15% no valor total da compra.\r\n- Caso seja entre 200 e 400 reais, não aplicar nenhum desconto.\r\n- Após os cálculos, exibir na tela de Conclusão de Compra o valor final da compra e o desconto obtido.\r\nIremos analisar os seguintes detalhes:\r\nCapacidade de resolver o problema da forma mais simples, utilizando o mínimo de código possível.\r\nManipulação correta dos valores e cálculos de desconto.\r\nOrganização da regra de negócio de uma forma coesa para as duas seguintes partes do problema:\r\nCálculo do somatório de produtos.\r\nCálculo do valor de desconto.\r\nCapacidade de reprodução do layout, estilos e design sugerido nas telas do Carrinho e Checkout. \r\nCriação da tela de cadastro nos padrões das outras duas telas.\r\nDetalhes do projeto:\r\n- Todo o projeto deve ser submetido no github ou outro similar que use GIT.\r\n- Não se esqueça de justificar as suas escolhas (de tecnologia, layout, etc...) no arquivo README que deve acompanhar sua solução. Além de nos informar como proceder para testarmos sua aplicação.\r\n\r\nOutras informações:\r\n- Documentação e testes serão avaliados também.\r\n- A utilização de ferramentas de geração de CRUD e helpers serão analisadas com critérios.\r\n- Junto ao teste deve conter como guia duas ilustrações (design) das telas de Carrinho e Checkout que gostaríamos que se baseasse para desenvolver as telas da aplicação. Seguir o mais fiel possível.\r\n\r\n\r\n \r\nDesign das Telas\r\n \r\n \r\nTela de Carrinho de Compras\r\n\r\nTela de Conclusão de Compras\r\n\r\n	47675	2016-06-27 13:46:21.899971	1	2817
6127	1	Gostaríamos de anunciar que estamos buscando um novo perfil, se julgar do seu interesse fique a vontade para buscar os candidatos. \r\nLembrando que ao identificar um candidato que atenda as exigência da vaga, deve-se aplicar o teste que segue abaixo.\r\n\r\nEm tempo, seguem algumas considerações:\r\nO tempo máximo para desenvolvimento do teste pelo candidato são de 15 dias corridos a partir do seu envio;\r\nSomente consideraremos candidatos com teste concluído;\r\nAceitamos candidaturas (com teste) para esta vaga até o dia 13/07.\r\n\r\n1) Título da Vaga\r\nDesenvolvedor\r\n\r\n2) Requisitos da Vaga\r\nAngular ; Node.js ; Python ; Django ; HTML5 ; CSS3 ; Javascript ; APIs Rest ; SQL ; Processamento assíncrono de requisições \r\nDiferenciais:\r\nRabbit MQ ; Docker ; Jenkins ; EcmaScript6 ; Testes com mocha ; synon, should, etc. ; Promises (Q) ; Frameworks: Express e Loopback\r\n	47675	2016-06-27 13:46:21.900541	1	2817
6128	186	todas as consultorias	47675	2016-06-27 13:46:21.900935	1	2817
6129	11	Gustavo Vieira	47676	2016-06-27 13:53:25.850593	273	2814
6130	2	https://drive.google.com/a/avenuecode.com/file/d/0B-dYXZ2cOfG1NnpRbXBfTUxVQWs/view?usp=sharing	47676	2016-06-27 13:53:25.851415	273	2814
6131	166	Avenue Code	47676	2016-06-27 13:53:25.851826	273	2814
6132	182	1	47676	2016-06-27 13:53:25.852217	273	2814
6133	12	1	47676	2016-06-27 13:53:25.852612	273	2814
6134	11	Alex Zacarias Soares	47678	2016-06-27 14:00:33.969884	273	2814
6135	2	https://bitbucket.org/asoares99/agendacompromissowalmart	47678	2016-06-27 14:00:33.970405	273	2814
6136	166	Mazza	47678	2016-06-27 14:00:33.971184	273	2814
6137	182	1	47678	2016-06-27 14:00:33.971618	273	2814
6138	12	1	47678	2016-06-27 14:00:33.97205	273	2814
6139	11	Deiwson Pinheiro dos Santos	47680	2016-06-27 14:01:45.384144	273	2814
6140	2	ü  https://1drv.ms/u/s!AjrLj_yqmHgWiGduErvErzeFK7RA ü  link download  arquivo ü  https://koreaBit@bitbucket.org/tiware/testewalmart.git ü  https://koreaBit@bitbucket.org/nbportalweb/walmartserver.git	47680	2016-06-27 14:01:45.384653	273	2814
6141	166	mazza	47680	2016-06-27 14:01:45.385047	273	2814
6142	182	1	47680	2016-06-27 14:01:45.385493	273	2814
6143	12	1	47680	2016-06-27 14:01:45.385861	273	2814
6144	11	bruno rossetto	47682	2016-06-27 14:05:18.83884	273	2814
6145	2	https://github.com/haptico/agenda.git	47682	2016-06-27 14:05:18.839848	273	2814
6146	166	indicacao	47682	2016-06-27 14:05:18.840237	273	2814
6147	182	1,2,3,4	47682	2016-06-27 14:05:18.840623	273	2814
6148	12	1,4	47682	2016-06-27 14:05:18.841013	273	2814
6149	11	Victor Oliveira	47684	2016-06-27 14:07:28.701605	273	2814
6150	2	https://github.com/victor-machado/Agenda.git https://github.com/victor-machado/agenda-services.git	47684	2016-06-27 14:07:28.702607	273	2814
6151	166	verotthi	47684	2016-06-27 14:07:28.703047	273	2814
6152	182	1	47684	2016-06-27 14:07:28.703443	273	2814
6153	12	1	47684	2016-06-27 14:07:28.703846	273	2814
6154	11	Felipe Novaes	47686	2016-06-27 14:12:54.395187	273	2814
6155	2	https://bitbucket.org/kamikazebr/raabbit - Android app https://bitbucket.org/kamikazebr/raabbitserver - Nodejs server	47686	2016-06-27 14:12:54.395932	273	2814
6156	166	O2B	47686	2016-06-27 14:12:54.396366	273	2814
6157	182	1,5	47686	2016-06-27 14:12:54.396885	273	2814
6158	12	1,5	47686	2016-06-27 14:12:54.39741	273	2814
6159	11	Diego Cezimbra	47688	2016-06-27 14:13:48.491164	273	2814
6160	2	https://bitbucket.org/dicezimbra/projetodesafio-fcamara	47688	2016-06-27 14:13:48.491944	273	2814
6161	166	Fcamara	47688	2016-06-27 14:13:48.492359	273	2814
6162	182	1	47688	2016-06-27 14:13:48.492784	273	2814
6163	12	1	47688	2016-06-27 14:13:48.493187	273	2814
6164	11	Luiz Junqueira	47690	2016-06-27 14:38:58.325431	273	2818
6165	2	https://github.com/junqueira/shopapp	47690	2016-06-27 14:38:58.326013	273	2818
6166	166	Mazza	47690	2016-06-27 14:38:58.326427	273	2818
6167	182	1,4,6	47690	2016-06-27 14:38:58.326833	273	2818
6168	11	Luiz Junqueira	47692	2016-06-27 14:40:46.549288	273	2816
6169	2	https://github.com/junqueira/shopapp e https://shopeng.herokuapp.com/	47692	2016-06-27 14:40:46.550047	273	2816
6170	166	mazza	47692	2016-06-27 14:40:46.550508	273	2816
6171	182	2,4,6	47692	2016-06-27 14:40:46.550986	273	2816
6172	12	2,6	47692	2016-06-27 14:40:46.551392	273	2816
6173	11	George Luiz	47694	2016-06-27 14:41:57.644639	273	2814
6174	2	https://github.com/GeorgeSouzaFreire/AgendaCompromisso	47694	2016-06-27 14:41:57.645159	273	2814
6175	166	O2b	47694	2016-06-27 14:41:57.64556	273	2814
6176	182	1	47694	2016-06-27 14:41:57.645984	273	2814
6177	12	1	47694	2016-06-27 14:41:57.646395	273	2814
6178	11	novo candidato android	47696	2016-06-27 16:34:36.553626	273	2814
6179	2	123	47696	2016-06-27 16:34:36.554443	273	2814
6180	166	321	47696	2016-06-27 16:34:36.554937	273	2814
6181	182	2	47696	2016-06-27 16:34:36.555355	273	2814
6182	12	2	47696	2016-06-27 16:34:36.555771	273	2814
6183	11	novo candidato android	47698	2016-06-27 16:35:24.425633	273	2814
6184	2	123	47698	2016-06-27 16:35:24.426429	273	2814
6185	166	321	47698	2016-06-27 16:35:24.426764	273	2814
6186	182	2	47698	2016-06-27 16:35:24.427152	273	2814
6187	12	2	47698	2016-06-27 16:35:24.427543	273	2814
6188	11	novo candidato android	47700	2016-06-27 16:37:01.418754	273	2814
6189	2	123	47700	2016-06-27 16:37:01.419309	273	2814
6190	166	321	47700	2016-06-27 16:37:01.419742	273	2814
6191	182	2	47700	2016-06-27 16:37:01.420181	273	2814
6192	12	2	47700	2016-06-27 16:37:01.420635	273	2814
6193	11	xxxx	47703	2016-06-27 16:37:24.631433	273	2814
6194	2	c	47703	2016-06-27 16:37:24.632233	273	2814
6195	166	v	47703	2016-06-27 16:37:24.632643	273	2814
6196	182	2	47703	2016-06-27 16:37:24.63306	273	2814
6197	11	o	47705	2016-06-27 16:39:22.852909	273	2814
6198	182	2	47705	2016-06-27 16:39:22.853503	273	2814
6199	2	o	47705	2016-06-27 16:39:22.853905	273	2814
6200	166	o	47705	2016-06-27 16:39:22.854282	273	2814
6201	12	1	47705	2016-06-27 16:39:22.854675	273	2814
6202	11	node	47708	2016-06-27 16:39:45.42527	273	2814
6203	182	5	47708	2016-06-27 16:39:45.425942	273	2814
6204	2	dsa	47708	2016-06-27 16:39:45.426377	273	2814
6205	166	f	47708	2016-06-27 16:39:45.426778	273	2814
6206	12	5	47708	2016-06-27 16:39:45.427218	273	2814
6207	11	novo node	47710	2016-06-27 16:40:20.718213	273	2814
6208	182	5	47710	2016-06-27 16:40:20.719053	273	2814
6209	2	x	47710	2016-06-27 16:40:20.719463	273	2814
6210	166	c	47710	2016-06-27 16:40:20.719963	273	2814
6211	12	5	47710	2016-06-27 16:40:20.720426	273	2814
6212	11	novo node	47712	2016-06-27 16:40:29.1944	273	2814
6213	182	5	47712	2016-06-27 16:40:29.194867	273	2814
6214	2	x	47712	2016-06-27 16:40:29.195241	273	2814
6215	166	c	47712	2016-06-27 16:40:29.195612	273	2814
6216	12	5	47712	2016-06-27 16:40:29.195983	273	2814
6217	11	novo node	47714	2016-06-27 16:43:09.223163	273	2814
6218	182	5	47714	2016-06-27 16:43:09.223653	273	2814
6219	2	x	47714	2016-06-27 16:43:09.224039	273	2814
6220	166	c	47714	2016-06-27 16:43:09.224424	273	2814
6221	12	5	47714	2016-06-27 16:43:09.224818	273	2814
6222	11	Gustavo Vieira	47717	2016-06-27 17:00:30.293358	273	2841
6223	182	1	47717	2016-06-27 17:00:30.293955	273	2841
6224	2	https://drive.google.com/a/avenuecode.com/file/d/0B-dYXZ2cOfG1NnpRbXBfTUxVQWs/view?usp=sharing	47717	2016-06-27 17:00:30.294332	273	2841
6225	166	avenue code	47717	2016-06-27 17:00:30.294837	273	2841
6226	12	1	47717	2016-06-27 17:00:30.295252	273	2841
6227	11	Gustavo Vieira	47718	2016-06-27 17:00:30.333371	273	2842
6228	182	1	47718	2016-06-27 17:00:30.333856	273	2842
6229	2	https://drive.google.com/a/avenuecode.com/file/d/0B-dYXZ2cOfG1NnpRbXBfTUxVQWs/view?usp=sharing	47718	2016-06-27 17:00:30.334293	273	2842
6230	166	avenue code	47718	2016-06-27 17:00:30.334684	273	2842
6231	12	1	47718	2016-06-27 17:00:30.335063	273	2842
6232	13	cds	47719	2016-06-27 18:13:33.960867	1	2843
6233	174	cds	47719	2016-06-27 18:13:33.961595	1	2843
6234	1	cdscds	47719	2016-06-27 18:13:33.962021	1	2843
6235	186	cdscds	47719	2016-06-27 18:13:33.962442	1	2843
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 6235, true);


--
-- Name: workflow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_id_seq', 25, true);


--
-- Data for Name: workflow_postos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_postos (id, id_workflow, idator, posto, ordem_cronologica, principal, lista, idtipoprocesso, starter, notif_saindoposto, notif_entrandoposto, tipodesignacao, regra_finalizacao) FROM stdin;
281	1	85	Reprovacão de Candidato	\N	0	F	2	\N	\N	\N	\N	\N
282	1	85	Reprovacão de Candidato ja entrevistado	\N	0	F	2	\N	\N	\N	\N	\N
283	1	85	Negociacão Falha	\N	0	F	2	\N	\N	\N	\N	\N
284	1	85	TESTE	\N	0	F	2	\N	\N	\N	\N	\N
285	1	85	Re Ativar Processo Seletivo para este candidato	\N	0	F	2	\N	\N	\N	\N	\N
286	1	85	Arquivar processo de Candidato	\N	0	F	2	\N	\N	\N	\N	\N
275	1	\N	Encaminhar para Gestor	\N	0	F	2	\N	\N	\N	\N	\N
276	1	\N	Dados da Entrevista	\N	0	F	2	\N	\N	\N	\N	\N
277	1	\N	Encaminhar para Negociacão	\N	0	F	2	\N	\N	\N	\N	\N
274	1	1	Classificação de Senioridade	\N	0	F	3	\N	\N	\N	\N	\N
288	1	1	Classificação de Senioridade	\N	0	F	3	\N	\N	\N	\N	\N
287	1	2	Segunda Avaliação	3	1	L	3	\N	\N	\N	AUTO-DIRECIONADO	\N
3	1	2	Primeira Avaliação	3	1	L	3	\N	\N	2	AUTO-DIRECIONADO	\N
278	1	\N	Dados da Contratação	\N	0	F	2	\N	\N	\N	\N	\N
279	1	\N	Onboarding de novo membro	\N	0	F	2	\N	\N	\N	\N	\N
289	1	85	Relatórios	9	1	R	\N	\N	\N	\N	\N	\N
273	1	3	lançar candidato	\N	0	F	3	0	\N	\N	\N	\N
2	1	3	Vagas em Aberto	2	1	L	1	1	\N	\N	\N	\N
4	1	85	Candidatos Classificados	4	1	L	2	\N	\N	3	\N	\N
5	1	85	Candidatos para Entrevistar	5	1	L	2	\N	\N	4	\N	\N
6	1	85	Candidatos já Entrevistados	6	1	L	2	\N	\N	\N	\N	\N
8	1	85	Candidatos em Negociação	7	1	L	2	\N	6	5	\N	\N
280	1	\N	Candidatos Arquivados	9	1	L	\N	\N	\N	\N	\N	\N
7	1	85	Aguardando Onboarding	8	1	L	2	\N	7	\N	\N	\N
1	1	85	Lançar nova Vaga	0	0	F	1	1	1	\N	\N	\N
294	1	85	Enviar vaga para novos destinatários	\N	0	F	4	\N	\N	\N	\N	\N
295	1	85	Prospecções em Andamento	\N	0	L	4	\N	\N	19	\N	\N
292	1	85	Encerrar Vaga	\N	0	F	1	\N	\N	\N	\N	\N
293	1	85	Vagas Arquivadas	\N	0	L	1	\N	\N	20	\N	\N
\.


--
-- Name: workflow_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_postos_id_seq', 295, true);


--
-- Data for Name: workflow_tramitacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_tramitacao (id, idprocesso, idworkflowposto, inicio, fim, id_usuario_associado) FROM stdin;
2813	47673	1	2016-06-27 13:33:17.082575	2016-06-27 13:33:17.082575	\N
2814	47673	2	2016-06-27 13:33:17.149866	\N	\N
2815	47674	1	2016-06-27 13:45:43.731105	2016-06-27 13:45:43.731105	\N
2816	47674	2	2016-06-27 13:45:43.779707	\N	\N
2817	47675	1	2016-06-27 13:46:21.826294	2016-06-27 13:46:21.826294	\N
2818	47675	2	2016-06-27 13:46:21.867478	\N	\N
2819	47677	3	2016-06-27 13:53:25.854711	\N	\N
2820	47679	3	2016-06-27 14:00:33.973323	\N	\N
2821	47681	3	2016-06-27 14:01:45.392102	\N	\N
2822	47683	3	2016-06-27 14:05:18.842313	\N	\N
2823	47685	3	2016-06-27 14:07:28.705127	\N	\N
2824	47687	3	2016-06-27 14:12:54.398774	\N	\N
2825	47689	3	2016-06-27 14:13:48.494487	\N	\N
2826	47691	3	2016-06-27 14:38:58.328144	\N	\N
2827	47693	3	2016-06-27 14:40:46.552698	\N	\N
2828	47695	3	2016-06-27 14:41:57.647585	\N	\N
2829	47697	3	2016-06-27 16:34:36.557049	\N	\N
2830	47699	3	2016-06-27 16:35:24.429131	\N	\N
2831	47701	3	2016-06-27 16:37:01.421937	\N	5
2832	47702	287	2016-06-27 16:37:01.48667	\N	5
2833	47704	3	2016-06-27 16:37:24.634317	\N	\N
2834	47706	3	2016-06-27 16:39:22.860771	\N	3
2835	47707	287	2016-06-27 16:39:22.909788	\N	3
2836	47709	3	2016-06-27 16:39:45.428583	\N	\N
2837	47711	3	2016-06-27 16:40:20.721814	\N	\N
2838	47713	3	2016-06-27 16:40:29.202185	\N	\N
2839	47715	3	2016-06-27 16:43:09.231066	\N	\N
2840	47716	287	2016-06-27 16:43:09.282165	\N	\N
2841	47717	3	2016-06-27 17:00:30.247673	\N	5
2842	47718	287	2016-06-27 17:00:30.29729	\N	5
2843	47719	1	2016-06-27 18:13:33.87969	2016-06-27 18:13:33.87969	\N
2844	47719	2	2016-06-27 18:13:33.925668	\N	\N
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 2844, true);


--
-- Name: configuracoes; Type: ACL; Schema: -; Owner: bsiquei
--

REVOKE ALL ON SCHEMA configuracoes FROM PUBLIC;
REVOKE ALL ON SCHEMA configuracoes FROM bsiquei;
GRANT ALL ON SCHEMA configuracoes TO bsiquei;
GRANT ALL ON SCHEMA configuracoes TO postgres;


--
-- Name: public; Type: ACL; Schema: -; Owner: bsiquei
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM bsiquei;
GRANT ALL ON SCHEMA public TO bsiquei;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

