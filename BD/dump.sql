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
\.


--
-- Name: tecnologias_id_seq; Type: SEQUENCE SET; Schema: configuracoes; Owner: postgres
--

SELECT pg_catalog.setval('tecnologias_id_seq', 4, true);


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
2	273	github	\N	\N	\N	\N	\N	\N	\N
4	274	senioridade	\N	\N	\N	\N	\N	\N	\N
163	278	Valor/Hora	\N	\N	\N	\N	\N	\N	\N
164	278	Data de Inicio	\N	\N	\N	\N	\N	\N	\N
5	275	Gestor Interessado	\N	\N	\N	\N	\N	\N	\N
166	273	Consultoria	\N	\N	\N	\N	\N	\N	\N
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
3	273	cv	\N	\N	file	\N	\N	\N	\N
183	292	Motivo do Encerramento da Vaga	1	\N	textarea	90	10	\N	\N
184	294	Novos Destinatários	\N	\N	textarea	90	2	Separar os emails por ",". Exemplo: usuario@email.com, usuario2@email.com	\N
186	1	Destinatários	1	\N	textarea	90	2	Separar os emails por ",". Exemplo: usuario@email.com, usuario2@email.com	consultoria1@email.com, consultoria2@eail.com
182	273	Tecnologias que domina	1	\N	list	\N	\N	\N	{configuracoes.tecnologias}
12	273	Tecnologia que o candidato fez o teste	\N	\N	list	\N	\N	\N	{configuracoes.tecnologias}
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
47664	\N	1	2016-06-09 00:29:13.308966	1	Em Andamento	\N
47666	47665	3	2016-06-09 00:29:30.150748	1	Em Andamento	\N
47667	47665	3	2016-06-09 00:29:30.196771	1	Em Andamento	\N
47665	47664	2	2016-06-09 00:29:30.147042	1	Em Andamento	\N
47668	47664	2	2016-06-11 22:59:32.002762	1	\N	\N
47669	47668	3	2016-06-11 22:59:32.266768	1	Em Andamento	\N
47670	47668	3	2016-06-11 22:59:32.319468	1	Em Andamento	\N
47671	47664	2	2016-06-12 00:18:40.851986	1	\N	\N
47672	47671	3	2016-06-12 00:18:40.855545	1	\N	\N
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 47672, true);


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
28622	42	2016-06-03 15:29:31.405391	2764
28623	42	2016-06-03 15:29:31.411221	2766
28624	42	2016-06-03 15:29:31.416326	2768
28625	43	2016-06-03 15:29:31.422243	2769
28626	43	2016-06-03 15:29:31.427637	2767
28627	43	2016-06-03 15:29:31.432995	2765
28628	42	2016-06-03 15:33:27.105414	2764
28629	42	2016-06-03 15:33:27.111222	2766
28630	42	2016-06-03 15:33:27.116676	2768
28631	43	2016-06-03 15:33:27.122209	2769
28632	43	2016-06-03 15:33:27.127602	2767
28633	43	2016-06-03 15:33:27.133122	2765
28634	47	2016-06-03 15:33:27.140452	2764
28635	47	2016-06-03 15:33:27.145864	2766
28636	47	2016-06-03 15:33:27.151003	2768
28637	42	2016-06-06 11:45:37.287225	2764
28638	42	2016-06-06 11:45:37.312422	2766
28639	42	2016-06-06 11:45:37.318759	2768
28640	43	2016-06-06 11:45:37.325051	2769
28641	43	2016-06-06 11:45:37.330515	2767
28642	43	2016-06-06 11:45:37.335725	2765
28643	48	2016-06-06 11:45:37.343638	2764
28644	48	2016-06-06 11:45:37.349376	2766
28645	48	2016-06-06 11:45:37.355264	2768
28646	47	2016-06-06 11:45:37.361119	2766
28647	47	2016-06-06 11:45:37.36655	2768
28648	47	2016-06-06 11:45:37.372194	2764
28649	42	2016-06-08 22:58:47.513754	2764
28650	42	2016-06-08 22:58:47.889703	2766
28651	42	2016-06-08 22:58:47.978012	2768
28652	43	2016-06-08 22:58:48.030971	2769
28653	43	2016-06-08 22:58:48.105577	2767
28654	43	2016-06-08 22:58:48.18005	2765
28655	48	2016-06-08 22:58:48.275617	2766
28656	48	2016-06-08 22:58:48.323502	2768
28657	48	2016-06-08 22:58:48.386367	2764
28658	47	2016-06-08 22:58:48.455276	2766
28659	47	2016-06-08 22:58:48.512542	2768
28660	47	2016-06-08 22:58:48.604891	2764
28661	42	2016-06-08 23:23:10.165004	2764
28662	42	2016-06-08 23:23:10.172357	2766
28663	42	2016-06-08 23:23:10.178443	2768
28664	43	2016-06-08 23:23:10.184792	2769
28665	43	2016-06-08 23:23:10.190683	2767
28666	43	2016-06-08 23:23:10.19695	2765
28667	48	2016-06-08 23:23:10.205299	2766
28668	48	2016-06-08 23:23:10.211895	2768
28669	48	2016-06-08 23:23:10.218183	2764
28670	47	2016-06-08 23:23:10.224688	2766
28671	47	2016-06-08 23:23:10.230776	2768
28672	47	2016-06-08 23:23:10.237188	2764
28673	42	2016-06-08 23:24:30.654766	2764
28674	42	2016-06-08 23:24:30.675264	2766
28675	42	2016-06-08 23:24:30.68666	2768
28676	43	2016-06-08 23:24:30.700552	2769
28677	43	2016-06-08 23:24:30.718726	2767
28678	43	2016-06-08 23:24:30.732394	2765
28679	48	2016-06-08 23:24:30.748222	2766
28680	48	2016-06-08 23:24:30.756293	2768
28681	48	2016-06-08 23:24:30.780205	2764
28682	47	2016-06-08 23:24:30.804807	2766
28683	47	2016-06-08 23:24:30.821683	2768
28684	47	2016-06-08 23:24:30.838738	2764
28685	40	2016-06-08 23:25:19.682008	47638
28686	41	2016-06-08 23:27:05.282147	2770
28687	42	2016-06-08 23:27:05.289836	2764
28688	42	2016-06-08 23:27:05.295656	2766
28689	43	2016-06-08 23:27:05.301895	2767
28690	43	2016-06-08 23:27:05.309048	2765
28691	40	2016-06-08 23:27:05.315839	47638
28692	49	2016-06-08 23:27:05.322159	47638
28693	48	2016-06-08 23:27:05.328347	2766
28694	48	2016-06-08 23:27:05.334318	2768
28695	48	2016-06-08 23:27:05.341163	2764
28696	47	2016-06-08 23:27:05.347418	2766
28697	47	2016-06-08 23:27:05.353773	2768
28698	47	2016-06-08 23:27:05.359634	2764
28699	42	2016-06-08 23:28:08.38909	2764
28700	42	2016-06-08 23:28:08.395301	2766
28701	43	2016-06-08 23:28:08.401461	2767
28702	43	2016-06-08 23:28:08.407658	2765
28703	40	2016-06-08 23:28:08.414858	47638
28704	49	2016-06-08 23:28:08.423543	47638
28705	48	2016-06-08 23:28:08.430746	2766
28706	48	2016-06-08 23:28:08.437495	2768
28707	48	2016-06-08 23:28:08.44454	2764
28708	50	2016-06-08 23:28:08.451008	47638
28709	47	2016-06-08 23:28:08.457738	2766
28710	47	2016-06-08 23:28:08.465057	2768
28711	47	2016-06-08 23:28:08.472165	2764
28712	42	2016-06-08 23:29:18.858867	2764
28713	42	2016-06-08 23:29:18.865641	2766
28714	43	2016-06-08 23:29:18.879893	2767
28715	43	2016-06-08 23:29:18.894035	2765
28716	40	2016-06-08 23:29:18.909515	47638
28717	49	2016-06-08 23:29:18.916633	47638
28718	48	2016-06-08 23:29:18.929148	2766
28719	48	2016-06-08 23:29:18.963285	2768
28720	48	2016-06-08 23:29:18.973117	2764
28721	50	2016-06-08 23:29:18.985074	47638
28722	47	2016-06-08 23:29:18.992526	2766
28723	47	2016-06-08 23:29:18.998966	2768
28724	47	2016-06-08 23:29:19.004725	2764
28725	49	2016-06-09 00:13:15.933562	47638
28726	48	2016-06-09 00:13:15.940103	2766
28727	48	2016-06-09 00:13:15.946	2768
28728	48	2016-06-09 00:13:15.951359	2764
28729	50	2016-06-09 00:13:15.955881	47638
28730	47	2016-06-09 00:13:15.961864	2766
28731	47	2016-06-09 00:13:15.967342	2768
28732	47	2016-06-09 00:13:15.972353	2764
28733	49	2016-06-09 00:14:40.341013	47638
28734	48	2016-06-09 00:14:40.40832	2766
28735	48	2016-06-09 00:14:40.414302	2768
28736	48	2016-06-09 00:14:40.419681	2764
28737	50	2016-06-09 00:14:40.425659	47638
28738	47	2016-06-09 00:14:40.431654	2766
28739	47	2016-06-09 00:14:40.436835	2768
28740	47	2016-06-09 00:14:40.443377	2764
28741	49	2016-06-09 00:16:08.294612	47638
28742	48	2016-06-09 00:16:08.321183	2766
28743	48	2016-06-09 00:16:08.32905	2768
28744	48	2016-06-09 00:16:08.339629	2764
28745	50	2016-06-09 00:16:08.347556	47638
28746	47	2016-06-09 00:16:08.361337	2766
28747	47	2016-06-09 00:16:08.369029	2768
28748	47	2016-06-09 00:16:08.376208	2764
28749	42	2016-06-09 00:16:41.282098	2781
28750	43	2016-06-09 00:16:41.288524	2782
28751	49	2016-06-09 00:19:26.448681	47638
28752	48	2016-06-09 00:19:26.454552	2766
28753	48	2016-06-09 00:19:26.459693	2768
28754	48	2016-06-09 00:19:26.464867	2764
28755	50	2016-06-09 00:19:26.471383	47638
28756	47	2016-06-09 00:19:26.476574	2781
28757	47	2016-06-09 00:19:26.481973	2766
28758	47	2016-06-09 00:19:26.487089	2768
28759	47	2016-06-09 00:19:26.491851	2764
28760	49	2016-06-09 00:20:55.633418	47638
28761	48	2016-06-09 00:20:55.643075	2781
28762	48	2016-06-09 00:20:55.649786	2766
28763	48	2016-06-09 00:20:55.656141	2768
28764	48	2016-06-09 00:20:55.662351	2764
28765	50	2016-06-09 00:20:55.667155	47638
28766	47	2016-06-09 00:20:55.673994	2781
28767	47	2016-06-09 00:20:55.680617	2766
28768	47	2016-06-09 00:20:55.687149	2768
28769	47	2016-06-09 00:20:55.693479	2764
28770	43	2016-06-09 00:21:29.497832	2795
28771	40	2016-06-09 00:21:36.382407	47661
28772	49	2016-06-09 00:28:58.863909	47638
28773	49	2016-06-09 00:28:58.868733	47661
28774	48	2016-06-09 00:28:58.875426	2781
28775	48	2016-06-09 00:28:58.881195	2766
28776	48	2016-06-09 00:28:58.886608	2768
28777	48	2016-06-09 00:28:58.892661	2764
28778	50	2016-06-09 00:28:58.89781	47638
28779	47	2016-06-09 00:28:58.903892	2781
28780	47	2016-06-09 00:28:58.910188	2766
28781	47	2016-06-09 00:28:58.915599	2768
28782	47	2016-06-09 00:28:58.92134	2764
28783	49	2016-06-09 00:30:25.670731	47638
28784	49	2016-06-09 00:30:25.675285	47661
28785	48	2016-06-09 00:30:25.685287	2781
28786	48	2016-06-09 00:30:25.69251	2766
28787	48	2016-06-09 00:30:25.699248	2768
28788	48	2016-06-09 00:30:25.706224	2764
28789	50	2016-06-09 00:30:25.711073	47638
28790	50	2016-06-09 00:30:25.715442	47661
28791	47	2016-06-09 00:30:25.722399	2781
28792	47	2016-06-09 00:30:25.729185	2766
28793	47	2016-06-09 00:30:25.735887	2768
28794	47	2016-06-09 00:30:25.742902	2764
28795	43	2016-06-09 00:30:39.818854	2800
28796	40	2016-06-09 00:31:05.742989	47665
28797	41	2016-06-09 00:45:46.06566	2801
28798	40	2016-06-09 00:45:46.074247	47665
28799	49	2016-06-09 00:45:46.079565	47638
28800	49	2016-06-09 00:45:46.084031	47661
28801	49	2016-06-09 00:45:46.089038	47665
28802	48	2016-06-09 00:45:46.095741	2781
28803	48	2016-06-09 00:45:46.102392	2766
28804	48	2016-06-09 00:45:46.109264	2768
28805	48	2016-06-09 00:45:46.115803	2764
28806	50	2016-06-09 00:45:46.120581	47638
28807	50	2016-06-09 00:45:46.125208	47661
28808	47	2016-06-09 00:45:46.132167	2781
28809	47	2016-06-09 00:45:46.138974	2766
28810	47	2016-06-09 00:45:46.146211	2768
28811	47	2016-06-09 00:45:46.153232	2764
28812	40	2016-06-09 00:47:06.019766	47665
28813	49	2016-06-09 00:47:06.025119	47638
28814	49	2016-06-09 00:47:06.029566	47661
28815	49	2016-06-09 00:47:06.034403	47665
28816	48	2016-06-09 00:47:06.042629	2781
28817	48	2016-06-09 00:47:06.049376	2766
28818	48	2016-06-09 00:47:06.056205	2768
28819	48	2016-06-09 00:47:06.062791	2764
28820	50	2016-06-09 00:47:06.067728	47638
28821	50	2016-06-09 00:47:06.072567	47661
28822	50	2016-06-09 00:47:06.077767	47665
28823	47	2016-06-09 00:47:06.084449	2781
28824	47	2016-06-09 00:47:06.090798	2766
28825	47	2016-06-09 00:47:06.097757	2768
28826	47	2016-06-09 00:47:06.104394	2764
28827	40	2016-06-09 00:48:21.179408	47665
28828	49	2016-06-09 00:48:21.18583	47638
28829	49	2016-06-09 00:48:21.190677	47661
28830	49	2016-06-09 00:48:21.195554	47665
28831	48	2016-06-09 00:48:21.203283	2781
28832	48	2016-06-09 00:48:21.209982	2766
28833	48	2016-06-09 00:48:21.217304	2768
28834	48	2016-06-09 00:48:21.22414	2764
28835	50	2016-06-09 00:48:21.228963	47638
28836	50	2016-06-09 00:48:21.234635	47661
28837	50	2016-06-09 00:48:21.240385	47665
28838	47	2016-06-09 00:48:21.247101	2781
28839	47	2016-06-09 00:48:21.253977	2766
28840	47	2016-06-09 00:48:21.260702	2768
28841	47	2016-06-09 00:48:21.267746	2764
28842	40	2016-06-09 00:49:55.666724	47665
28843	49	2016-06-09 00:49:55.679529	47638
28844	49	2016-06-09 00:49:55.687631	47661
28845	49	2016-06-09 00:49:55.698831	47665
28846	48	2016-06-09 00:49:55.707271	2781
28847	48	2016-06-09 00:49:55.729632	2766
28848	48	2016-06-09 00:49:55.736031	2768
28849	48	2016-06-09 00:49:55.754397	2764
28850	50	2016-06-09 00:49:55.760917	47638
28851	50	2016-06-09 00:49:55.781782	47661
28852	50	2016-06-09 00:49:55.786873	47665
28853	47	2016-06-09 00:49:55.798703	2781
28854	47	2016-06-09 00:49:55.808298	2766
28855	47	2016-06-09 00:49:55.826335	2768
28856	47	2016-06-09 00:49:55.832856	2764
28857	40	2016-06-09 00:51:10.096193	47665
28858	49	2016-06-09 00:51:10.103129	47638
28859	49	2016-06-09 00:51:10.109247	47661
28860	49	2016-06-09 00:51:10.117754	47665
28861	48	2016-06-09 00:51:10.128766	2781
28862	48	2016-06-09 00:51:10.140723	2766
28863	48	2016-06-09 00:51:10.150413	2768
28864	48	2016-06-09 00:51:10.164786	2764
28865	50	2016-06-09 00:51:10.172972	47638
28866	50	2016-06-09 00:51:10.179311	47661
28867	50	2016-06-09 00:51:10.187758	47665
28868	47	2016-06-09 00:51:10.196519	2781
28869	47	2016-06-09 00:51:10.204941	2766
28870	47	2016-06-09 00:51:10.212662	2768
28871	47	2016-06-09 00:51:10.222735	2764
28872	40	2016-06-09 10:29:47.71827	47665
28873	49	2016-06-09 10:29:47.723595	47638
28874	49	2016-06-09 10:29:47.727745	47661
28875	49	2016-06-09 10:29:47.733794	47665
28876	48	2016-06-09 10:29:47.757512	2781
28877	48	2016-06-09 10:29:47.771323	2766
28878	48	2016-06-09 10:29:47.781756	2768
28879	48	2016-06-09 10:29:47.791091	2764
28880	50	2016-06-09 10:29:47.795934	47638
28881	50	2016-06-09 10:29:47.800316	47661
28882	50	2016-06-09 10:29:47.808437	47665
28883	47	2016-06-09 10:29:47.815737	2781
28884	47	2016-06-09 10:29:47.824392	2766
28885	47	2016-06-09 10:29:47.831306	2768
28886	47	2016-06-09 10:29:47.839698	2764
28887	40	2016-06-11 22:57:43.732933	47665
28888	49	2016-06-11 22:57:43.845019	47638
28889	49	2016-06-11 22:57:43.889579	47661
28890	49	2016-06-11 22:57:43.919495	47665
28891	48	2016-06-11 22:57:43.989581	2781
28892	48	2016-06-11 22:57:44.004313	2766
28893	48	2016-06-11 22:57:44.015321	2768
28894	48	2016-06-11 22:57:44.038758	2764
28895	50	2016-06-11 22:57:44.04695	47638
28896	50	2016-06-11 22:57:44.06757	47661
28897	50	2016-06-11 22:57:44.098452	47665
28898	47	2016-06-11 22:57:44.113982	2781
28899	47	2016-06-11 22:57:44.18984	2766
28900	47	2016-06-11 22:57:44.214429	2768
28901	47	2016-06-11 22:57:44.233654	2764
28902	40	2016-06-11 22:58:51.230291	47665
28903	49	2016-06-11 22:58:51.235489	47638
28904	49	2016-06-11 22:58:51.239804	47661
28905	49	2016-06-11 22:58:51.245023	47665
28906	48	2016-06-11 22:58:51.252708	2781
28907	48	2016-06-11 22:58:51.259999	2766
28908	48	2016-06-11 22:58:51.267139	2768
28909	48	2016-06-11 22:58:51.274384	2764
28910	50	2016-06-11 22:58:51.279528	47638
28911	50	2016-06-11 22:58:51.284899	47661
28912	50	2016-06-11 22:58:51.29077	47665
28913	47	2016-06-11 22:58:51.297685	2781
28914	47	2016-06-11 22:58:51.304686	2766
28915	47	2016-06-11 22:58:51.311667	2768
28916	47	2016-06-11 22:58:51.319109	2764
28917	40	2016-06-11 23:00:06.754223	47665
28918	49	2016-06-11 23:00:06.759352	47638
28919	49	2016-06-11 23:00:06.763698	47661
28920	49	2016-06-11 23:00:06.768981	47665
28921	48	2016-06-11 23:00:06.777432	2781
28922	48	2016-06-11 23:00:06.785595	2766
28923	48	2016-06-11 23:00:06.793888	2768
28924	48	2016-06-11 23:00:06.801935	2764
28925	50	2016-06-11 23:00:06.806628	47638
28926	50	2016-06-11 23:00:06.8111	47661
28927	50	2016-06-11 23:00:06.816793	47665
28928	47	2016-06-11 23:00:06.824921	2781
28929	47	2016-06-11 23:00:06.833098	2766
28930	47	2016-06-11 23:00:06.841027	2768
28931	47	2016-06-11 23:00:06.848837	2764
28932	42	2016-06-11 23:02:04.911035	2810
28933	43	2016-06-11 23:02:04.919062	2811
28934	40	2016-06-11 23:02:04.926715	47665
28935	49	2016-06-11 23:02:04.932495	47638
28936	49	2016-06-11 23:02:04.937528	47661
28937	49	2016-06-11 23:02:04.943695	47665
28938	48	2016-06-11 23:02:04.953492	2781
28939	48	2016-06-11 23:02:04.962591	2766
28940	48	2016-06-11 23:02:04.972067	2768
28941	48	2016-06-11 23:02:04.981638	2764
28942	50	2016-06-11 23:02:04.98729	47638
28943	50	2016-06-11 23:02:04.99256	47661
28944	50	2016-06-11 23:02:04.999042	47665
28945	47	2016-06-11 23:02:05.008262	2781
28946	47	2016-06-11 23:02:05.019589	2766
28947	47	2016-06-11 23:02:05.029715	2768
28948	47	2016-06-11 23:02:05.039318	2764
28949	42	2016-06-11 23:04:38.964349	2810
28950	43	2016-06-11 23:04:38.970769	2811
28951	40	2016-06-11 23:04:38.977224	47665
28952	49	2016-06-11 23:04:38.98203	47638
28953	49	2016-06-11 23:04:38.986228	47661
28954	49	2016-06-11 23:04:38.991368	47665
28955	48	2016-06-11 23:04:39.000226	2781
28956	48	2016-06-11 23:04:39.008181	2766
28957	48	2016-06-11 23:04:39.01607	2768
28958	48	2016-06-11 23:04:39.025965	2764
28959	50	2016-06-11 23:04:39.030936	47638
28960	50	2016-06-11 23:04:39.035689	47661
28961	50	2016-06-11 23:04:39.041326	47665
28962	47	2016-06-11 23:04:39.049586	2781
28963	47	2016-06-11 23:04:39.057454	2766
28964	47	2016-06-11 23:04:39.065285	2768
28965	47	2016-06-11 23:04:39.07318	2764
28966	47	2016-06-11 23:04:39.078988	2810
28967	42	2016-06-11 23:05:43.983424	2810
28968	43	2016-06-11 23:05:43.99009	2811
28969	40	2016-06-11 23:05:43.996667	47665
28970	49	2016-06-11 23:05:44.001591	47638
28971	49	2016-06-11 23:05:44.006171	47661
28972	49	2016-06-11 23:05:44.011653	47665
28973	48	2016-06-11 23:05:44.020202	2781
28974	48	2016-06-11 23:05:44.028344	2766
28975	48	2016-06-11 23:05:44.036345	2768
28976	48	2016-06-11 23:05:44.046415	2764
28977	48	2016-06-11 23:05:44.053256	2810
28978	50	2016-06-11 23:05:44.058578	47638
28979	50	2016-06-11 23:05:44.063339	47661
28980	50	2016-06-11 23:05:44.069276	47665
28981	47	2016-06-11 23:05:44.078914	2766
28982	47	2016-06-11 23:05:44.087365	2768
28983	47	2016-06-11 23:05:44.095955	2764
28984	47	2016-06-11 23:05:44.102173	2810
28985	47	2016-06-11 23:05:44.112829	2781
28986	42	2016-06-11 23:06:48.351669	2810
28987	43	2016-06-11 23:06:48.359215	2811
28988	40	2016-06-11 23:06:48.366901	47665
28989	49	2016-06-11 23:06:48.372539	47638
28990	49	2016-06-11 23:06:48.377493	47661
28991	49	2016-06-11 23:06:48.383512	47665
28992	48	2016-06-11 23:06:48.393279	2766
28993	48	2016-06-11 23:06:48.401898	2768
28994	48	2016-06-11 23:06:48.411855	2764
28995	48	2016-06-11 23:06:48.418532	2810
28996	48	2016-06-11 23:06:48.428838	2781
28997	50	2016-06-11 23:06:48.434724	47638
28998	50	2016-06-11 23:06:48.439938	47661
28999	50	2016-06-11 23:06:48.446523	47665
29000	47	2016-06-11 23:06:48.456084	2766
29001	47	2016-06-11 23:06:48.465248	2768
29002	47	2016-06-11 23:06:48.476453	2764
29003	47	2016-06-11 23:06:48.485096	2810
29004	47	2016-06-11 23:06:48.497264	2781
29005	42	2016-06-11 23:08:16.809336	2810
29006	43	2016-06-11 23:08:16.817201	2811
29007	40	2016-06-11 23:08:16.824977	47665
29008	49	2016-06-11 23:08:16.830784	47638
29009	49	2016-06-11 23:08:16.835572	47661
29010	49	2016-06-11 23:08:16.841814	47665
29011	48	2016-06-11 23:08:16.851809	2766
29012	48	2016-06-11 23:08:16.86282	2768
29013	48	2016-06-11 23:08:16.872461	2764
29014	48	2016-06-11 23:08:16.879845	2810
29015	48	2016-06-11 23:08:16.889711	2781
29016	50	2016-06-11 23:08:16.895358	47638
29017	50	2016-06-11 23:08:16.900663	47661
29018	50	2016-06-11 23:08:16.907364	47665
29019	47	2016-06-11 23:08:16.916753	2766
29020	47	2016-06-11 23:08:16.925868	2768
29021	47	2016-06-11 23:08:16.935024	2764
29022	47	2016-06-11 23:08:16.941511	2810
29023	47	2016-06-11 23:08:16.950368	2781
29024	42	2016-06-11 23:20:59.721148	2810
29025	43	2016-06-11 23:20:59.791639	2811
29026	40	2016-06-11 23:20:59.870668	47665
29027	49	2016-06-11 23:20:59.889107	47638
29028	49	2016-06-11 23:20:59.903855	47661
29029	49	2016-06-11 23:20:59.917501	47665
29030	48	2016-06-11 23:20:59.939299	2766
29031	48	2016-06-11 23:20:59.961947	2768
29032	48	2016-06-11 23:20:59.985949	2764
29033	48	2016-06-11 23:20:59.999379	2810
29034	48	2016-06-11 23:21:00.015352	2781
29035	50	2016-06-11 23:21:00.026866	47638
29036	50	2016-06-11 23:21:00.040843	47661
29037	50	2016-06-11 23:21:00.054512	47665
29038	47	2016-06-11 23:21:00.066448	2766
29039	47	2016-06-11 23:21:00.080701	2768
29040	47	2016-06-11 23:21:00.094167	2764
29041	47	2016-06-11 23:21:00.107723	2810
29042	47	2016-06-11 23:21:00.124719	2781
29043	42	2016-06-11 23:23:13.423007	2810
29044	43	2016-06-11 23:23:13.430113	2811
29045	40	2016-06-11 23:23:13.437014	47665
29046	49	2016-06-11 23:23:13.442174	47638
29047	49	2016-06-11 23:23:13.446803	47661
29048	49	2016-06-11 23:23:13.453591	47665
29049	48	2016-06-11 23:23:13.462328	2766
29050	48	2016-06-11 23:23:13.470375	2768
29051	48	2016-06-11 23:23:13.478551	2764
29052	48	2016-06-11 23:23:13.485409	2810
29053	48	2016-06-11 23:23:13.493417	2781
29054	50	2016-06-11 23:23:13.498382	47638
29055	50	2016-06-11 23:23:13.503016	47661
29056	50	2016-06-11 23:23:13.508684	47665
29057	47	2016-06-11 23:23:13.517696	2766
29058	47	2016-06-11 23:23:13.525767	2768
29059	47	2016-06-11 23:23:13.534263	2764
29060	47	2016-06-11 23:23:13.540189	2810
29061	47	2016-06-11 23:23:13.548609	2781
29062	42	2016-06-11 23:24:34.093673	2810
29063	43	2016-06-11 23:24:34.101253	2811
29064	40	2016-06-11 23:24:34.108433	47665
29065	49	2016-06-11 23:24:34.113975	47638
29066	49	2016-06-11 23:24:34.118928	47661
29067	49	2016-06-11 23:24:34.125651	47665
29068	48	2016-06-11 23:24:34.165448	2766
29069	48	2016-06-11 23:24:34.17502	2768
29070	48	2016-06-11 23:24:34.184229	2764
29071	48	2016-06-11 23:24:34.191167	2810
29072	48	2016-06-11 23:24:34.200615	2781
29073	50	2016-06-11 23:24:34.207242	47638
29074	50	2016-06-11 23:24:34.212872	47661
29075	50	2016-06-11 23:24:34.21951	47665
29076	47	2016-06-11 23:24:34.23042	2766
29077	47	2016-06-11 23:24:34.240667	2768
29078	47	2016-06-11 23:24:34.249656	2764
29079	47	2016-06-11 23:24:34.25652	2810
29080	47	2016-06-11 23:24:34.265659	2781
29081	42	2016-06-11 23:25:46.773657	2810
29082	43	2016-06-11 23:25:46.781581	2811
29083	40	2016-06-11 23:25:46.790657	47665
29084	49	2016-06-11 23:25:46.796575	47638
29085	49	2016-06-11 23:25:46.801612	47661
29086	49	2016-06-11 23:25:46.808426	47665
29087	48	2016-06-11 23:25:46.818424	2766
29088	48	2016-06-11 23:25:46.827587	2768
29089	48	2016-06-11 23:25:46.83681	2764
29090	48	2016-06-11 23:25:46.844933	2810
29091	48	2016-06-11 23:25:46.854723	2781
29092	50	2016-06-11 23:25:46.860806	47638
29093	50	2016-06-11 23:25:46.866345	47661
29094	50	2016-06-11 23:25:46.873131	47665
29095	47	2016-06-11 23:25:46.882656	2766
29096	47	2016-06-11 23:25:46.892621	2768
29097	47	2016-06-11 23:25:46.90168	2764
29098	47	2016-06-11 23:25:46.910479	2810
29099	47	2016-06-11 23:25:46.919657	2781
29100	42	2016-06-11 23:27:04.484807	2810
29101	43	2016-06-11 23:27:04.506359	2811
29102	40	2016-06-11 23:27:04.513041	47665
29103	49	2016-06-11 23:27:04.518802	47638
29104	49	2016-06-11 23:27:04.52446	47661
29105	49	2016-06-11 23:27:04.529849	47665
29106	48	2016-06-11 23:27:04.539014	2766
29107	48	2016-06-11 23:27:04.546951	2768
29108	48	2016-06-11 23:27:04.555174	2764
29109	48	2016-06-11 23:27:04.561471	2810
29110	48	2016-06-11 23:27:04.570213	2781
29111	50	2016-06-11 23:27:04.574954	47638
29112	50	2016-06-11 23:27:04.579741	47661
29113	50	2016-06-11 23:27:04.585297	47665
29114	47	2016-06-11 23:27:04.59361	2766
29115	47	2016-06-11 23:27:04.601465	2768
29116	47	2016-06-11 23:27:04.609474	2764
29117	47	2016-06-11 23:27:04.615141	2810
29118	47	2016-06-11 23:27:04.623138	2781
29119	42	2016-06-11 23:28:38.734534	2810
29120	43	2016-06-11 23:28:38.742472	2811
29121	40	2016-06-11 23:28:38.75003	47665
29122	49	2016-06-11 23:28:38.755763	47638
29123	49	2016-06-11 23:28:38.760732	47661
29124	49	2016-06-11 23:28:38.767038	47665
29125	48	2016-06-11 23:28:38.777065	2766
29126	48	2016-06-11 23:28:38.786401	2768
29127	48	2016-06-11 23:28:38.795458	2764
29128	48	2016-06-11 23:28:38.802702	2810
29129	48	2016-06-11 23:28:38.81197	2781
29130	50	2016-06-11 23:28:38.817502	47638
29131	50	2016-06-11 23:28:38.823687	47661
29132	50	2016-06-11 23:28:38.830075	47665
29133	47	2016-06-11 23:28:38.839295	2766
29134	47	2016-06-11 23:28:38.850851	2768
29135	47	2016-06-11 23:28:38.859565	2764
29136	47	2016-06-11 23:28:38.866142	2810
29137	47	2016-06-11 23:28:38.875209	2781
29138	42	2016-06-11 23:40:56.643338	2810
29139	43	2016-06-11 23:40:56.651166	2811
29140	40	2016-06-11 23:40:56.667427	47665
29141	49	2016-06-11 23:40:56.672963	47638
29142	49	2016-06-11 23:40:56.677363	47661
29143	49	2016-06-11 23:40:56.682981	47665
29144	48	2016-06-11 23:40:56.708464	2766
29145	48	2016-06-11 23:40:56.716995	2768
29146	48	2016-06-11 23:40:56.725039	2764
29147	48	2016-06-11 23:40:56.731491	2810
29148	48	2016-06-11 23:40:56.73981	2781
29149	50	2016-06-11 23:40:56.744917	47638
29150	50	2016-06-11 23:40:56.749648	47661
29151	50	2016-06-11 23:40:56.755679	47665
29152	47	2016-06-11 23:40:56.764414	2766
29153	47	2016-06-11 23:40:56.773106	2768
29154	47	2016-06-11 23:40:56.781978	2764
29155	47	2016-06-11 23:40:56.788139	2810
29156	47	2016-06-11 23:40:56.797049	2781
29157	42	2016-06-12 00:18:07.159691	2810
29158	43	2016-06-12 00:18:07.182646	2811
29159	40	2016-06-12 00:18:07.229684	47665
29160	49	2016-06-12 00:18:07.24634	47638
29161	49	2016-06-12 00:18:07.252329	47661
29162	49	2016-06-12 00:18:07.268794	47665
29163	48	2016-06-12 00:18:07.280559	2766
29164	48	2016-06-12 00:18:07.288817	2768
29165	48	2016-06-12 00:18:07.306358	2764
29166	48	2016-06-12 00:18:07.317018	2810
29167	48	2016-06-12 00:18:07.326904	2781
29168	50	2016-06-12 00:18:07.335533	47638
29169	50	2016-06-12 00:18:07.349278	47661
29170	50	2016-06-12 00:18:07.355383	47665
29171	47	2016-06-12 00:18:07.372702	2766
29172	47	2016-06-12 00:18:07.381617	2768
29173	47	2016-06-12 00:18:07.391652	2764
29174	47	2016-06-12 00:18:07.398423	2810
29175	47	2016-06-12 00:18:07.416872	2781
29176	42	2016-06-12 00:19:38.800173	2810
29177	43	2016-06-12 00:19:38.80846	2811
29178	40	2016-06-12 00:19:38.816231	47665
29179	49	2016-06-12 00:19:38.822347	47638
29180	49	2016-06-12 00:19:38.827507	47661
29181	49	2016-06-12 00:19:38.834109	47665
29182	48	2016-06-12 00:19:38.844608	2766
29183	48	2016-06-12 00:19:38.854766	2768
29184	48	2016-06-12 00:19:38.865122	2764
29185	48	2016-06-12 00:19:38.872135	2810
29186	48	2016-06-12 00:19:38.882127	2781
29187	50	2016-06-12 00:19:38.887848	47638
29188	50	2016-06-12 00:19:38.893382	47661
29189	50	2016-06-12 00:19:38.899927	47665
29190	47	2016-06-12 00:19:38.910454	2766
29191	47	2016-06-12 00:19:38.920307	2768
29192	47	2016-06-12 00:19:38.930521	2764
29193	47	2016-06-12 00:19:38.937713	2810
29194	47	2016-06-12 00:19:38.948969	2781
29195	42	2016-06-12 00:20:00.967086	2812
29196	42	2016-06-12 00:21:43.558833	2810
29197	42	2016-06-12 00:21:43.565219	2812
29198	43	2016-06-12 00:21:43.571596	2811
29199	40	2016-06-12 00:21:43.591089	47665
29200	49	2016-06-12 00:21:43.597398	47638
29201	49	2016-06-12 00:21:43.602096	47661
29202	49	2016-06-12 00:21:43.607785	47665
29203	48	2016-06-12 00:21:43.617736	2766
29204	48	2016-06-12 00:21:43.626521	2768
29205	48	2016-06-12 00:21:43.635426	2764
29206	48	2016-06-12 00:21:43.641498	2810
29207	48	2016-06-12 00:21:43.650584	2781
29208	50	2016-06-12 00:21:43.655529	47638
29209	50	2016-06-12 00:21:43.660346	47661
29210	50	2016-06-12 00:21:43.666236	47665
29211	47	2016-06-12 00:21:43.675234	2766
29212	47	2016-06-12 00:21:43.684156	2768
29213	47	2016-06-12 00:21:43.690452	2812
29214	47	2016-06-12 00:21:43.699397	2764
29215	47	2016-06-12 00:21:43.705393	2810
29216	47	2016-06-12 00:21:43.714055	2781
29217	42	2016-06-12 00:23:08.182728	2810
29218	42	2016-06-12 00:23:08.189505	2812
29219	43	2016-06-12 00:23:08.196485	2811
29220	40	2016-06-12 00:23:08.203693	47665
29221	49	2016-06-12 00:23:08.208993	47638
29222	49	2016-06-12 00:23:08.214514	47661
29223	49	2016-06-12 00:23:08.220735	47665
29224	48	2016-06-12 00:23:08.231222	2766
29225	48	2016-06-12 00:23:08.240247	2768
29226	48	2016-06-12 00:23:08.246954	2812
29227	48	2016-06-12 00:23:08.256774	2764
29228	48	2016-06-12 00:23:08.263906	2810
29229	48	2016-06-12 00:23:08.273796	2781
29230	50	2016-06-12 00:23:08.280276	47638
29231	50	2016-06-12 00:23:08.285751	47661
29232	50	2016-06-12 00:23:08.29191	47665
29233	47	2016-06-12 00:23:08.302579	2766
29234	47	2016-06-12 00:23:08.312575	2768
29235	47	2016-06-12 00:23:08.320177	2812
29236	47	2016-06-12 00:23:08.32965	2764
29237	47	2016-06-12 00:23:08.336226	2810
29238	47	2016-06-12 00:23:08.346222	2781
29239	42	2016-06-12 00:25:08.077836	2810
29240	42	2016-06-12 00:25:08.08421	2812
29241	43	2016-06-12 00:25:08.090224	2811
29242	40	2016-06-12 00:25:08.099026	47665
29243	49	2016-06-12 00:25:08.104704	47638
29244	49	2016-06-12 00:25:08.109172	47661
29245	49	2016-06-12 00:25:08.115332	47665
29246	48	2016-06-12 00:25:08.124557	2766
29247	48	2016-06-12 00:25:08.13325	2768
29248	48	2016-06-12 00:25:08.139365	2812
29249	48	2016-06-12 00:25:08.148587	2764
29250	48	2016-06-12 00:25:08.154827	2810
29251	48	2016-06-12 00:25:08.163727	2781
29252	50	2016-06-12 00:25:08.168717	47638
29253	50	2016-06-12 00:25:08.173452	47661
29254	50	2016-06-12 00:25:08.179342	47665
29255	47	2016-06-12 00:25:08.188748	2766
29256	47	2016-06-12 00:25:08.197835	2768
29257	47	2016-06-12 00:25:08.204002	2812
29258	47	2016-06-12 00:25:08.213286	2764
29259	47	2016-06-12 00:25:08.219275	2810
29260	47	2016-06-12 00:25:08.22885	2781
29261	42	2016-06-12 00:26:46.448361	2810
29262	42	2016-06-12 00:26:46.455169	2812
29263	43	2016-06-12 00:26:46.461522	2811
29264	40	2016-06-12 00:26:46.467913	47665
29265	49	2016-06-12 00:26:46.473021	47638
29266	49	2016-06-12 00:26:46.477878	47661
29267	49	2016-06-12 00:26:46.483798	47665
29268	48	2016-06-12 00:26:46.493293	2766
29269	48	2016-06-12 00:26:46.502783	2768
29270	48	2016-06-12 00:26:46.509763	2812
29271	48	2016-06-12 00:26:46.518829	2764
29272	48	2016-06-12 00:26:46.525114	2810
29273	48	2016-06-12 00:26:46.534049	2781
29274	50	2016-06-12 00:26:46.539196	47638
29275	50	2016-06-12 00:26:46.544566	47661
29276	50	2016-06-12 00:26:46.550653	47665
29277	47	2016-06-12 00:26:46.560014	2766
29278	47	2016-06-12 00:26:46.568987	2768
29279	47	2016-06-12 00:26:46.574987	2812
29280	47	2016-06-12 00:26:46.583932	2764
29281	47	2016-06-12 00:26:46.58992	2810
29282	47	2016-06-12 00:26:46.599216	2781
29283	42	2016-06-12 00:27:58.695125	2810
29284	42	2016-06-12 00:27:58.703655	2812
29285	43	2016-06-12 00:27:58.710985	2811
29286	40	2016-06-12 00:27:58.718561	47665
29287	49	2016-06-12 00:27:58.724605	47638
29288	49	2016-06-12 00:27:58.729954	47661
29289	49	2016-06-12 00:27:58.736407	47665
29290	48	2016-06-12 00:27:58.747602	2766
29291	48	2016-06-12 00:27:58.757821	2768
29292	48	2016-06-12 00:27:58.765058	2812
29293	48	2016-06-12 00:27:58.775276	2764
29294	48	2016-06-12 00:27:58.782646	2810
29295	48	2016-06-12 00:27:58.792808	2781
29296	50	2016-06-12 00:27:58.798769	47638
29297	50	2016-06-12 00:27:58.804539	47661
29298	50	2016-06-12 00:27:58.811392	47665
29299	47	2016-06-12 00:27:58.822767	2766
29300	47	2016-06-12 00:27:58.833563	2768
29301	47	2016-06-12 00:27:58.841548	2812
29302	47	2016-06-12 00:27:58.851582	2764
29303	47	2016-06-12 00:27:58.858433	2810
29304	47	2016-06-12 00:27:58.868846	2781
29305	42	2016-06-12 00:30:45.932791	2810
29306	42	2016-06-12 00:30:45.939213	2812
29307	43	2016-06-12 00:30:45.945641	2811
29308	40	2016-06-12 00:30:45.952228	47665
29309	49	2016-06-12 00:30:45.957345	47638
29310	49	2016-06-12 00:30:45.961772	47661
29311	49	2016-06-12 00:30:45.967336	47665
29312	48	2016-06-12 00:30:45.977024	2766
29313	48	2016-06-12 00:30:45.986292	2768
29314	48	2016-06-12 00:30:45.992577	2812
29315	48	2016-06-12 00:30:46.001318	2764
29316	48	2016-06-12 00:30:46.007956	2810
29317	48	2016-06-12 00:30:46.017538	2781
29318	50	2016-06-12 00:30:46.022519	47638
29319	50	2016-06-12 00:30:46.028356	47661
29320	50	2016-06-12 00:30:46.035319	47665
29321	47	2016-06-12 00:30:46.046516	2766
29322	47	2016-06-12 00:30:46.056327	2768
29323	47	2016-06-12 00:30:46.062463	2812
29324	47	2016-06-12 00:30:46.07261	2764
29325	47	2016-06-12 00:30:46.079053	2810
29326	47	2016-06-12 00:30:46.088955	2781
29327	42	2016-06-12 00:31:52.958835	2810
29328	42	2016-06-12 00:31:52.965509	2812
29329	43	2016-06-12 00:31:52.971974	2811
29330	40	2016-06-12 00:31:52.978681	47665
29331	49	2016-06-12 00:31:52.983883	47638
29332	49	2016-06-12 00:31:52.988519	47661
29333	49	2016-06-12 00:31:52.994081	47665
29334	48	2016-06-12 00:31:53.003516	2766
29335	48	2016-06-12 00:31:53.012351	2768
29336	48	2016-06-12 00:31:53.019112	2812
29337	48	2016-06-12 00:31:53.028278	2764
29338	48	2016-06-12 00:31:53.034839	2810
29339	48	2016-06-12 00:31:53.043593	2781
29340	50	2016-06-12 00:31:53.048817	47638
29341	50	2016-06-12 00:31:53.05367	47661
29342	50	2016-06-12 00:31:53.059587	47665
29343	47	2016-06-12 00:31:53.068832	2766
29344	47	2016-06-12 00:31:53.077943	2768
29345	47	2016-06-12 00:31:53.084272	2812
29346	47	2016-06-12 00:31:53.098123	2764
29347	47	2016-06-12 00:31:53.104736	2810
29348	47	2016-06-12 00:31:53.113805	2781
29349	42	2016-06-12 00:33:00.615833	2810
29350	42	2016-06-12 00:33:00.62228	2812
29351	43	2016-06-12 00:33:00.628616	2811
29352	40	2016-06-12 00:33:00.635324	47665
29353	49	2016-06-12 00:33:00.640393	47638
29354	49	2016-06-12 00:33:00.645375	47661
29355	49	2016-06-12 00:33:00.650845	47665
29356	48	2016-06-12 00:33:00.660074	2766
29357	48	2016-06-12 00:33:00.668929	2768
29358	48	2016-06-12 00:33:00.675306	2812
29359	48	2016-06-12 00:33:00.684122	2764
29360	48	2016-06-12 00:33:00.690281	2810
29361	48	2016-06-12 00:33:00.699223	2781
29362	50	2016-06-12 00:33:00.704365	47638
29363	50	2016-06-12 00:33:00.708867	47661
29364	50	2016-06-12 00:33:00.714744	47665
29365	47	2016-06-12 00:33:00.724042	2766
29366	47	2016-06-12 00:33:00.732994	2768
29367	47	2016-06-12 00:33:00.739045	2812
29368	47	2016-06-12 00:33:00.747695	2764
29369	47	2016-06-12 00:33:00.75378	2810
29370	47	2016-06-12 00:33:00.76228	2781
29371	42	2016-06-12 00:38:07.347501	2810
29372	42	2016-06-12 00:38:07.353976	2812
29373	43	2016-06-12 00:38:07.360638	2811
29374	40	2016-06-12 00:38:07.367137	47665
29375	49	2016-06-12 00:38:07.372599	47638
29376	49	2016-06-12 00:38:07.377261	47661
29377	49	2016-06-12 00:38:07.38282	47665
29378	48	2016-06-12 00:38:07.393447	2766
29379	48	2016-06-12 00:38:07.403071	2768
29380	48	2016-06-12 00:38:07.409988	2812
29381	48	2016-06-12 00:38:07.418983	2764
29382	48	2016-06-12 00:38:07.425441	2810
29383	48	2016-06-12 00:38:07.434657	2781
29384	50	2016-06-12 00:38:07.439966	47638
29385	50	2016-06-12 00:38:07.444653	47661
29386	50	2016-06-12 00:38:07.450595	47665
29387	47	2016-06-12 00:38:07.46001	2766
29388	47	2016-06-12 00:38:07.469085	2768
29389	47	2016-06-12 00:38:07.475412	2812
29390	47	2016-06-12 00:38:07.484782	2764
29391	47	2016-06-12 00:38:07.490807	2810
29392	47	2016-06-12 00:38:07.499762	2781
29393	42	2016-06-12 00:41:29.398706	2810
29394	42	2016-06-12 00:41:29.404928	2812
29395	43	2016-06-12 00:41:29.412052	2811
29396	40	2016-06-12 00:41:29.418332	47665
29397	49	2016-06-12 00:41:29.423788	47638
29398	49	2016-06-12 00:41:29.42841	47661
29399	49	2016-06-12 00:41:29.434134	47665
29400	48	2016-06-12 00:41:29.443952	2766
29401	48	2016-06-12 00:41:29.452837	2768
29402	48	2016-06-12 00:41:29.459351	2812
29403	48	2016-06-12 00:41:29.468608	2764
29404	48	2016-06-12 00:41:29.474808	2810
29405	48	2016-06-12 00:41:29.484452	2781
29406	50	2016-06-12 00:41:29.489626	47638
29407	50	2016-06-12 00:41:29.494649	47661
29408	50	2016-06-12 00:41:29.500607	47665
29409	47	2016-06-12 00:41:29.509849	2766
29410	47	2016-06-12 00:41:29.518808	2768
29411	47	2016-06-12 00:41:29.525244	2812
29412	47	2016-06-12 00:41:29.534068	2764
29413	47	2016-06-12 00:41:29.540015	2810
29414	47	2016-06-12 00:41:29.549267	2781
29415	42	2016-06-12 00:44:23.766787	2810
29416	42	2016-06-12 00:44:23.773136	2812
29417	43	2016-06-12 00:44:23.779923	2811
29418	40	2016-06-12 00:44:23.786591	47665
29419	49	2016-06-12 00:44:23.792056	47638
29420	49	2016-06-12 00:44:23.796684	47661
29421	49	2016-06-12 00:44:23.802456	47665
29422	48	2016-06-12 00:44:23.813423	2766
29423	48	2016-06-12 00:44:23.822833	2768
29424	48	2016-06-12 00:44:23.82919	2812
29425	48	2016-06-12 00:44:23.83802	2764
29426	48	2016-06-12 00:44:23.844272	2810
29427	48	2016-06-12 00:44:23.852914	2781
29428	50	2016-06-12 00:44:23.858073	47638
29429	50	2016-06-12 00:44:23.862871	47661
29430	50	2016-06-12 00:44:23.868871	47665
29431	47	2016-06-12 00:44:23.878125	2766
29432	47	2016-06-12 00:44:23.886886	2768
29433	47	2016-06-12 00:44:23.892947	2812
29434	47	2016-06-12 00:44:23.901811	2764
29435	47	2016-06-12 00:44:23.908075	2810
29436	47	2016-06-12 00:44:23.916844	2781
29437	42	2016-06-12 00:45:27.632648	2810
29438	42	2016-06-12 00:45:27.642728	2812
29439	43	2016-06-12 00:45:27.658375	2811
29440	40	2016-06-12 00:45:27.669469	47665
29441	49	2016-06-12 00:45:27.683464	47638
29442	49	2016-06-12 00:45:27.691274	47661
29443	49	2016-06-12 00:45:27.70119	47665
29444	48	2016-06-12 00:45:27.722036	2766
29445	48	2016-06-12 00:45:27.732516	2768
29446	48	2016-06-12 00:45:27.743029	2812
29447	48	2016-06-12 00:45:27.754799	2764
29448	48	2016-06-12 00:45:27.763003	2810
29449	48	2016-06-12 00:45:27.780248	2781
29450	50	2016-06-12 00:45:27.795643	47638
29451	50	2016-06-12 00:45:27.814919	47661
29452	50	2016-06-12 00:45:27.83544	47665
29453	47	2016-06-12 00:45:27.845625	2766
29454	47	2016-06-12 00:45:27.865382	2768
29455	47	2016-06-12 00:45:27.879435	2812
29456	47	2016-06-12 00:45:27.896624	2764
29457	47	2016-06-12 00:45:27.902795	2810
29458	47	2016-06-12 00:45:27.919457	2781
29459	42	2016-06-12 00:52:34.372913	2810
29460	42	2016-06-12 00:52:34.379222	2812
29461	43	2016-06-12 00:52:34.385949	2811
29462	40	2016-06-12 00:52:34.392527	47665
29463	49	2016-06-12 00:52:34.398189	47638
29464	49	2016-06-12 00:52:34.402858	47661
29465	49	2016-06-12 00:52:34.408464	47665
29466	48	2016-06-12 00:52:34.418188	2766
29467	48	2016-06-12 00:52:34.427586	2768
29468	48	2016-06-12 00:52:34.433953	2812
29469	48	2016-06-12 00:52:34.442998	2764
29470	48	2016-06-12 00:52:34.449342	2810
29471	48	2016-06-12 00:52:34.458265	2781
29472	50	2016-06-12 00:52:34.464198	47638
29473	50	2016-06-12 00:52:34.469201	47661
29474	50	2016-06-12 00:52:34.475186	47665
29475	47	2016-06-12 00:52:34.484927	2766
29476	47	2016-06-12 00:52:34.494014	2768
29477	47	2016-06-12 00:52:34.500741	2812
29478	47	2016-06-12 00:52:34.510006	2764
29479	47	2016-06-12 00:52:34.517025	2810
29480	47	2016-06-12 00:52:34.526248	2781
29481	42	2016-06-12 00:53:43.594132	2810
29482	42	2016-06-12 00:53:43.602577	2812
29483	43	2016-06-12 00:53:43.608732	2811
29484	40	2016-06-12 00:53:43.615915	47665
29485	49	2016-06-12 00:53:43.621395	47638
29486	49	2016-06-12 00:53:43.62594	47661
29487	49	2016-06-12 00:53:43.633264	47665
29488	48	2016-06-12 00:53:43.643097	2766
29489	48	2016-06-12 00:53:43.652704	2768
29490	48	2016-06-12 00:53:43.658768	2812
29491	48	2016-06-12 00:53:43.667874	2764
29492	48	2016-06-12 00:53:43.674137	2810
29493	48	2016-06-12 00:53:43.683519	2781
29494	50	2016-06-12 00:53:43.688704	47638
29495	50	2016-06-12 00:53:43.694323	47661
29496	50	2016-06-12 00:53:43.70056	47665
29497	47	2016-06-12 00:53:43.709811	2766
29498	47	2016-06-12 00:53:43.718862	2768
29499	47	2016-06-12 00:53:43.72491	2812
29500	47	2016-06-12 00:53:43.734051	2764
29501	47	2016-06-12 00:53:43.740126	2810
29502	47	2016-06-12 00:53:43.749117	2781
\.


--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_notificacoes_id_seq', 29502, true);


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
6086	13	android	47664	2016-06-09 00:29:13.384061	1	2797
6087	174	enunciado	47664	2016-06-09 00:29:13.384731	1	2797
6088	1	job desc	47664	2016-06-09 00:29:13.38515	1	2797
6089	186	consultoria1@email.com	47664	2016-06-09 00:29:13.38556	1	2797
6090	11	android 1 	47665	2016-06-09 00:29:30.147904	273	2798
6091	2	gii	47665	2016-06-09 00:29:30.148706	273	2798
6092	166	mazza	47665	2016-06-09 00:29:30.149107	273	2798
6093	182	1,2	47665	2016-06-09 00:29:30.149713	273	2798
6094	12	3	47665	2016-06-09 00:29:30.150139	273	2798
6095	4	jr	47666	2016-06-09 00:30:39.710219	274	2799
6096	10	2799	47666	2016-06-09 00:30:39.711115	274	2799
6097	180	pl	47667	2016-06-09 00:31:05.594353	288	2800
6098	181	novo parecer...	47667	2016-06-09 00:31:05.595305	288	2800
6099	172	arquivei... teste do fluxo	47665	2016-06-09 00:45:57.53375	286	2802
6100	170	volta pro roteamento	47665	2016-06-09 00:46:40.526528	285	2803
6101	5	paffi	47665	2016-06-09 00:47:10.696503	275	2804
6102	6	ja entrevistei e gostei	47665	2016-06-09 00:47:23.539892	276	2805
6103	7	blz, pode contratar	47665	2016-06-09 00:47:40.432484	277	2806
6104	169	desistiu, ja se alocou	47665	2016-06-09 00:47:58.215822	283	2807
6105	170	volta pra ativa....	47665	2016-06-09 00:51:30.567733	285	2808
6106	172	cuzao, foi pro saco	47665	2016-06-09 00:51:54.603687	286	2809
6107	11	silencio	47668	2016-06-11 22:59:32.207169	273	2798
6108	2	k	47668	2016-06-11 22:59:32.263936	273	2798
6109	166	j	47668	2016-06-11 22:59:32.264713	273	2798
6110	182	2	47668	2016-06-11 22:59:32.26513	273	2798
6111	12	2	47668	2016-06-11 22:59:32.265657	273	2798
6112	11	winter games	47671	2016-06-12 00:18:40.852801	273	2798
6113	2	k	47671	2016-06-12 00:18:40.853608	273	2798
6114	166	n	47671	2016-06-12 00:18:40.854011	273	2798
6115	182	4	47671	2016-06-12 00:18:40.85444	273	2798
6116	12	4	47671	2016-06-12 00:18:40.854873	273	2798
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 6116, true);


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
2797	47664	1	2016-06-09 00:29:13.310087	2016-06-09 00:29:13.310087	\N
2798	47664	2	2016-06-09 00:29:13.351619	\N	\N
2799	47666	3	2016-06-09 00:29:30.151424	2016-06-09 00:30:39.711692	6
2800	47667	287	2016-06-09 00:29:30.197467	2016-06-09 00:31:05.596124	6
2801	47665	4	2016-06-09 00:31:05.606121	2016-06-09 00:45:57.529896	\N
2802	47665	280	2016-06-09 00:45:57.49394	2016-06-09 00:46:40.523031	\N
2803	47665	4	2016-06-09 00:46:40.486595	2016-06-09 00:47:10.692671	\N
2804	47665	5	2016-06-09 00:47:10.656107	2016-06-09 00:47:23.535869	\N
2805	47665	6	2016-06-09 00:47:23.501881	2016-06-09 00:47:40.428456	\N
2806	47665	8	2016-06-09 00:47:40.390403	2016-06-09 00:47:58.209357	\N
2807	47665	280	2016-06-09 00:47:58.174134	2016-06-09 00:51:30.562088	\N
2809	47665	280	2016-06-09 00:51:54.560575	\N	\N
2808	47665	4	2016-06-09 00:51:30.522936	2016-06-09 00:51:54.597992	\N
2810	47669	3	2016-06-11 22:59:32.267999	\N	5
2811	47670	287	2016-06-11 22:59:32.320263	\N	5
2812	47672	3	2016-06-12 00:18:40.856231	\N	\N
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 2812, true);


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

