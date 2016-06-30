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
-- Name: customworkflow_prod; Type: DATABASE; Schema: -; Owner: bsiquei
--

CREATE DATABASE customworkflow_prod WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'pt_BR.UTF-8' LC_CTYPE = 'pt_BR.UTF-8';


ALTER DATABASE customworkflow_prod OWNER TO bsiquei;

\connect customworkflow_prod

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
7	Rails
8	Sidekiq
9	HTML5
10	CSS
11	Javascript
12	SQL
13	Angular
14	Django
15	APIs REST
16	SCRUM
20	Magento
21	Rabbit MQ
22	Hazelcast
\.


--
-- Name: tecnologias_id_seq; Type: SEQUENCE SET; Schema: configuracoes; Owner: postgres
--

SELECT pg_catalog.setval('tecnologias_id_seq', 22, true);


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
3	273	cv	\N	\N	file	\N	\N	\N	\N
183	292	Motivo do Encerramento da Vaga	1	\N	textarea	90	10	\N	\N
184	294	Novos Destinatários	\N	\N	textarea	90	2	Separar os emails por ",". Exemplo: usuario@email.com, usuario2@email.com	\N
186	1	Destinatários	1	\N	textarea	90	2	Separar os emails por ",". Exemplo: usuario@email.com, usuario2@email.com	consultoria1@email.com, consultoria2@eail.com
182	273	Tecnologias que domina	1	\N	list	\N	\N	\N	{configuracoes.tecnologias}
2	273	github	1	\N	\N	\N	\N	\N	\N
166	273	Consultoria	1	\N	\N	\N	\N	\N	\N
12	273	Tecnologia que o candidato fez o teste	1	\N	list	\N	\N	\N	{configuracoes.tecnologias}
188	1	Gestor Demandante	1	\N	text	\N	\N	\N	\N
187	1	Skills Técnicas mandatórias	1	\N	list	\N	\N	\N	{configuracoes.tecnologias}
189	1	Proposta inicial de produto-destino	1	\N	text	\N	\N	\N	\N
\.


--
-- Name: postos_campo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_id_seq', 189, true);


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
85	2	187	\N	\N
86	2	188	\N	\N
87	2	189	\N	\N
88	4	187	\N	\N
89	5	181	\N	\N
90	4	12	\N	\N
\.


--
-- Name: postos_campo_lista_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_lista_id_seq', 90, true);


--
-- Data for Name: processos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY processos (id, idpai, idtipoprocesso, inicio, idworkflow, status, regra_finalizacao) FROM stdin;
47706	47699	2	2016-06-27 17:14:31.059742	1	Em Andamento	\N
47699	\N	1	2016-06-27 17:04:10.624185	1	Em Andamento	\N
47700	47699	2	2016-06-27 17:04:31.032956	1	\N	\N
47701	47700	3	2016-06-27 17:04:31.036561	1	Em Andamento	\N
47702	47700	3	2016-06-27 17:04:31.086701	1	Em Andamento	\N
8	47699	2	2016-06-28 20:04:35.845558	1	\N	\N
47703	\N	1	2016-06-27 17:08:06.22667	1	Em Andamento	\N
47704	\N	1	2016-06-27 17:10:57.402566	1	Em Andamento	\N
9	8	3	2016-06-28 20:04:35.8495	1	Em Andamento	\N
47705	\N	1	2016-06-27 17:12:43.393303	1	Em Andamento	\N
47707	47706	3	2016-06-27 17:14:31.063313	1	Em Andamento	\N
47708	47706	3	2016-06-27 17:14:31.113486	1	Em Andamento	\N
47710	47709	3	2016-06-27 17:18:59.643099	1	Em Andamento	\N
47711	47709	3	2016-06-27 17:18:59.691502	1	Em Andamento	\N
47712	47699	2	2016-06-27 17:21:09.478192	1	\N	\N
47713	47712	3	2016-06-27 17:21:09.48169	1	Em Andamento	\N
47714	47712	3	2016-06-27 17:21:09.538136	1	Em Andamento	\N
47715	47699	2	2016-06-27 17:22:19.656892	1	\N	\N
47716	47715	3	2016-06-27 17:22:19.660522	1	Em Andamento	\N
47717	47715	3	2016-06-27 17:22:19.726673	1	Em Andamento	\N
47718	47704	2	2016-06-27 18:07:58.489949	1	\N	\N
47719	47718	3	2016-06-27 18:07:59.000783	1	Em Andamento	\N
47720	47718	3	2016-06-27 18:07:59.255415	1	Em Andamento	\N
47722	47721	3	2016-06-27 18:08:50.347338	1	Em Andamento	\N
47723	47721	3	2016-06-27 18:08:50.397383	1	Em Andamento	\N
47724	47704	2	2016-06-27 18:10:43.844855	1	\N	\N
47725	47724	3	2016-06-27 18:10:43.847926	1	Em Andamento	\N
47726	47724	3	2016-06-27 18:10:43.897212	1	Em Andamento	\N
10	8	3	2016-06-28 20:04:35.898121	1	Em Andamento	\N
47709	47699	2	2016-06-27 17:18:59.639364	1	Em Andamento	\N
47728	47727	3	2016-06-27 18:45:35.555589	1	Em Andamento	\N
47729	47727	3	2016-06-27 18:45:35.602164	1	Em Andamento	\N
47731	47730	3	2016-06-27 18:46:15.609733	1	Em Andamento	\N
47732	47730	3	2016-06-27 18:46:15.656327	1	Em Andamento	\N
47734	47733	3	2016-06-27 18:48:31.006516	1	Em Andamento	\N
47735	47733	3	2016-06-27 18:48:31.055021	1	Em Andamento	\N
47733	47699	2	2016-06-27 18:48:31.003093	1	Em Andamento	\N
47730	47699	2	2016-06-27 18:46:15.60645	1	Em Andamento	\N
47743	47742	2	2016-06-27 20:45:52.473406	1	Em Andamento	\N
47727	47699	2	2016-06-27 18:45:35.552097	1	Em Andamento	\N
47721	47699	2	2016-06-27 18:08:50.343885	1	Em Andamento	\N
47736	47699	2	2016-06-27 20:30:57.781409	1	\N	\N
47737	47736	3	2016-06-27 20:30:57.784904	1	Em Andamento	\N
47738	47736	3	2016-06-27 20:30:57.834242	1	Em Andamento	\N
47739	47699	2	2016-06-27 20:34:37.577505	1	\N	\N
47740	47739	3	2016-06-27 20:34:37.580884	1	Em Andamento	\N
47741	47739	3	2016-06-27 20:34:37.633004	1	Em Andamento	\N
47742	\N	1	2016-06-27 20:43:34.005704	1	Em Andamento	\N
47744	47743	3	2016-06-27 20:45:52.476742	1	Em Andamento	\N
47745	47743	3	2016-06-27 20:45:52.53625	1	Em Andamento	\N
47746	\N	1	2016-06-27 21:05:04.894812	1	Em Andamento	\N
47747	\N	1	2016-06-27 21:09:07.956364	1	Em Andamento	\N
5	\N	1	2016-06-27 21:13:14.427923	1	Em Andamento	\N
6	\N	1	2016-06-28 00:05:36.209146	1	Em Andamento	\N
7	6	4	2016-06-28 00:06:02.436363	1	Em Andamento	\N
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 10, true);


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
29935	42	2016-06-27 17:06:57.554614	2834
29936	43	2016-06-27 17:06:57.561354	2835
29937	42	2016-06-27 17:08:06.453496	2834
29938	43	2016-06-27 17:08:06.465707	2835
29939	47	2016-06-27 17:08:06.475425	2834
29940	42	2016-06-27 17:10:28.895965	2834
29941	43	2016-06-27 17:10:28.90327	2835
29942	48	2016-06-27 17:10:28.913259	2834
29943	47	2016-06-27 17:10:28.919975	2834
29944	42	2016-06-27 17:12:09.198991	2834
29945	43	2016-06-27 17:12:09.205711	2835
29946	48	2016-06-27 17:12:09.214001	2834
29947	47	2016-06-27 17:12:09.220803	2834
29948	42	2016-06-27 17:13:41.603556	2834
29949	43	2016-06-27 17:13:41.610265	2835
29950	48	2016-06-27 17:13:41.618121	2834
29951	47	2016-06-27 17:13:41.624503	2834
29952	42	2016-06-27 17:18:20.86314	2834
29953	42	2016-06-27 17:18:20.870148	2843
29954	43	2016-06-27 17:18:20.876427	2835
29955	43	2016-06-27 17:18:20.882119	2844
29956	48	2016-06-27 17:18:20.890626	2834
29957	47	2016-06-27 17:18:20.896938	2834
29958	42	2016-06-27 17:19:31.309278	2834
29959	42	2016-06-27 17:19:31.315675	2843
29960	43	2016-06-27 17:19:31.322372	2835
29961	43	2016-06-27 17:19:31.32867	2844
29962	48	2016-06-27 17:19:31.337019	2834
29963	47	2016-06-27 17:19:31.344633	2834
29964	47	2016-06-27 17:19:31.351111	2843
29965	42	2016-06-27 17:21:09.971168	2834
29966	42	2016-06-27 17:21:09.984082	2843
29967	42	2016-06-27 17:21:09.990638	2845
29968	43	2016-06-27 17:21:09.996932	2844
29969	43	2016-06-27 17:21:10.002655	2846
29970	43	2016-06-27 17:21:10.008436	2835
29971	48	2016-06-27 17:21:10.017083	2834
29972	48	2016-06-27 17:21:10.023084	2843
29973	47	2016-06-27 17:21:10.029714	2834
29974	47	2016-06-27 17:21:10.035493	2843
29975	42	2016-06-27 17:22:19.876196	2847
29976	42	2016-06-27 17:22:19.882952	2834
29977	42	2016-06-27 17:22:19.889103	2843
29978	42	2016-06-27 17:22:19.895052	2845
29979	43	2016-06-27 17:22:19.902048	2848
29980	43	2016-06-27 17:22:19.908287	2835
29981	43	2016-06-27 17:22:19.914442	2844
29982	43	2016-06-27 17:22:19.921765	2846
29983	48	2016-06-27 17:22:19.930045	2834
29984	48	2016-06-27 17:22:19.937151	2843
29985	47	2016-06-27 17:22:19.94355	2834
29986	47	2016-06-27 17:22:19.949287	2843
29987	47	2016-06-27 17:22:19.955231	2845
29988	42	2016-06-27 17:28:37.762571	2849
29989	42	2016-06-27 17:28:37.769577	2834
29990	42	2016-06-27 17:28:37.775891	2843
29991	42	2016-06-27 17:28:37.782178	2845
29992	42	2016-06-27 17:28:37.788484	2847
29993	43	2016-06-27 17:28:37.794454	2848
29994	43	2016-06-27 17:28:37.800651	2835
29995	43	2016-06-27 17:28:37.807963	2850
29996	43	2016-06-27 17:28:37.814383	2844
29997	43	2016-06-27 17:28:37.821129	2846
29998	48	2016-06-27 17:28:37.829265	2834
29999	48	2016-06-27 17:28:37.835936	2843
30000	48	2016-06-27 17:28:37.841943	2845
30001	47	2016-06-27 17:28:37.848224	2843
30002	47	2016-06-27 17:28:37.854918	2845
30003	47	2016-06-27 17:28:37.860903	2834
30004	47	2016-06-27 17:28:37.867381	2847
30005	42	2016-06-27 17:35:37.483888	2849
30006	42	2016-06-27 17:35:37.490227	2834
30007	42	2016-06-27 17:35:37.497212	2843
30008	42	2016-06-27 17:35:37.503289	2845
30009	42	2016-06-27 17:35:37.509453	2847
30010	43	2016-06-27 17:35:37.51559	2848
30011	43	2016-06-27 17:35:37.521521	2835
30012	43	2016-06-27 17:35:37.527217	2850
30013	43	2016-06-27 17:35:37.533258	2844
30014	43	2016-06-27 17:35:37.539649	2846
30015	48	2016-06-27 17:35:37.547658	2834
30016	48	2016-06-27 17:35:37.553953	2847
30017	48	2016-06-27 17:35:37.56042	2843
30018	48	2016-06-27 17:35:37.566511	2845
30019	47	2016-06-27 17:35:37.573341	2843
30020	47	2016-06-27 17:35:37.579211	2845
30021	47	2016-06-27 17:35:37.585507	2849
30022	47	2016-06-27 17:35:37.593341	2834
30023	47	2016-06-27 17:35:37.599419	2847
30024	42	2016-06-27 17:36:45.809735	2849
30025	42	2016-06-27 17:36:45.815944	2834
30026	42	2016-06-27 17:36:45.822063	2843
30027	42	2016-06-27 17:36:45.82899	2845
30028	42	2016-06-27 17:36:45.835132	2847
30029	43	2016-06-27 17:36:45.841635	2848
30030	43	2016-06-27 17:36:45.848159	2835
30031	43	2016-06-27 17:36:45.853816	2850
30032	43	2016-06-27 17:36:45.860158	2844
30033	43	2016-06-27 17:36:45.865946	2846
30034	48	2016-06-27 17:36:45.873784	2843
30035	48	2016-06-27 17:36:45.880201	2845
30036	48	2016-06-27 17:36:45.88635	2849
30037	48	2016-06-27 17:36:45.893015	2834
30038	48	2016-06-27 17:36:45.900285	2847
30039	47	2016-06-27 17:36:45.907062	2843
30040	47	2016-06-27 17:36:45.913456	2845
30041	47	2016-06-27 17:36:45.920221	2849
30042	47	2016-06-27 17:36:45.926459	2834
30043	47	2016-06-27 17:36:45.933032	2847
30044	42	2016-06-27 17:37:53.478943	2849
30045	42	2016-06-27 17:37:53.488939	2834
30046	42	2016-06-27 17:37:53.497132	2843
30047	42	2016-06-27 17:37:53.504258	2845
30048	42	2016-06-27 17:37:53.51028	2847
30049	43	2016-06-27 17:37:53.518351	2848
30050	43	2016-06-27 17:37:53.524212	2835
30051	43	2016-06-27 17:37:53.530765	2850
30052	43	2016-06-27 17:37:53.53832	2844
30053	43	2016-06-27 17:37:53.544119	2846
30054	48	2016-06-27 17:37:53.55403	2843
30055	48	2016-06-27 17:37:53.56056	2845
30056	48	2016-06-27 17:37:53.567912	2849
30057	48	2016-06-27 17:37:53.574123	2834
30058	48	2016-06-27 17:37:53.581357	2847
30059	47	2016-06-27 17:37:53.588294	2843
30060	47	2016-06-27 17:37:53.594481	2845
30061	47	2016-06-27 17:37:53.601727	2849
30062	47	2016-06-27 17:37:53.607671	2834
30063	47	2016-06-27 17:37:53.615241	2847
30064	42	2016-06-27 17:40:20.830364	2849
30065	42	2016-06-27 17:40:20.836699	2834
30066	42	2016-06-27 17:40:20.843195	2843
30067	42	2016-06-27 17:40:20.850684	2845
30068	42	2016-06-27 17:40:20.857712	2847
30069	43	2016-06-27 17:40:20.864733	2848
30070	43	2016-06-27 17:40:20.870522	2835
30071	43	2016-06-27 17:40:20.876577	2850
30072	43	2016-06-27 17:40:20.882962	2844
30073	43	2016-06-27 17:40:20.888736	2846
30074	48	2016-06-27 17:40:20.897435	2843
30075	48	2016-06-27 17:40:20.90377	2845
30076	48	2016-06-27 17:40:20.909998	2849
30077	48	2016-06-27 17:40:20.916677	2834
30078	48	2016-06-27 17:40:20.923062	2847
30079	47	2016-06-27 17:40:20.930255	2843
30080	47	2016-06-27 17:40:20.936842	2845
30081	47	2016-06-27 17:40:20.94291	2849
30082	47	2016-06-27 17:40:20.948989	2834
30083	47	2016-06-27 17:40:20.956034	2847
30084	42	2016-06-27 17:41:31.239373	2849
30085	42	2016-06-27 17:41:31.24583	2834
30086	42	2016-06-27 17:41:31.251887	2843
30087	42	2016-06-27 17:41:31.257637	2845
30088	42	2016-06-27 17:41:31.26458	2847
30089	43	2016-06-27 17:41:31.270498	2848
30090	43	2016-06-27 17:41:31.276289	2835
30091	43	2016-06-27 17:41:31.282532	2850
30092	43	2016-06-27 17:41:31.288233	2844
30093	43	2016-06-27 17:41:31.295294	2846
30094	48	2016-06-27 17:41:31.307664	2843
30095	48	2016-06-27 17:41:31.314998	2845
30096	48	2016-06-27 17:41:31.321337	2849
30097	48	2016-06-27 17:41:31.327607	2834
30098	48	2016-06-27 17:41:31.333641	2847
30099	47	2016-06-27 17:41:31.339978	2843
30100	47	2016-06-27 17:41:31.346361	2845
30101	47	2016-06-27 17:41:31.352518	2849
30102	47	2016-06-27 17:41:31.358366	2834
30103	47	2016-06-27 17:41:31.364698	2847
30104	42	2016-06-27 17:43:58.50343	2849
30105	42	2016-06-27 17:43:58.512799	2834
30106	42	2016-06-27 17:43:58.519043	2843
30107	42	2016-06-27 17:43:58.524964	2845
30108	42	2016-06-27 17:43:58.531605	2847
30109	43	2016-06-27 17:43:58.538951	2848
30110	43	2016-06-27 17:43:58.545192	2835
30111	43	2016-06-27 17:43:58.550974	2850
30112	43	2016-06-27 17:43:58.558428	2844
30113	43	2016-06-27 17:43:58.564359	2846
30114	48	2016-06-27 17:43:58.572729	2843
30115	48	2016-06-27 17:43:58.579271	2845
30116	48	2016-06-27 17:43:58.585303	2849
30117	48	2016-06-27 17:43:58.591316	2834
30118	48	2016-06-27 17:43:58.598898	2847
30119	47	2016-06-27 17:43:58.605503	2843
30120	47	2016-06-27 17:43:58.61237	2845
30121	47	2016-06-27 17:43:58.618356	2849
30122	47	2016-06-27 17:43:58.624386	2834
30123	47	2016-06-27 17:43:58.631507	2847
30124	42	2016-06-27 17:48:30.696554	2849
30125	42	2016-06-27 17:48:30.704011	2834
30126	42	2016-06-27 17:48:30.710117	2843
30127	42	2016-06-27 17:48:30.716053	2845
30128	42	2016-06-27 17:48:30.722611	2847
30129	43	2016-06-27 17:48:30.72905	2848
30130	43	2016-06-27 17:48:30.735288	2835
30131	43	2016-06-27 17:48:30.741393	2850
30132	43	2016-06-27 17:48:30.747882	2844
30133	43	2016-06-27 17:48:30.753957	2846
30134	48	2016-06-27 17:48:30.762253	2843
30135	48	2016-06-27 17:48:30.768385	2845
30136	48	2016-06-27 17:48:30.774719	2849
30137	48	2016-06-27 17:48:30.780958	2834
30138	48	2016-06-27 17:48:30.786999	2847
30139	47	2016-06-27 17:48:30.794405	2843
30140	47	2016-06-27 17:48:30.800578	2845
30141	47	2016-06-27 17:48:30.806326	2849
30142	47	2016-06-27 17:48:30.81225	2834
30143	47	2016-06-27 17:48:30.818502	2847
30144	42	2016-06-27 17:49:53.006852	2849
30145	42	2016-06-27 17:49:53.02331	2834
30146	42	2016-06-27 17:49:53.036019	2843
30147	42	2016-06-27 17:49:53.043082	2845
30148	42	2016-06-27 17:49:53.056084	2847
30149	43	2016-06-27 17:49:53.073706	2848
30150	43	2016-06-27 17:49:53.088438	2835
30151	43	2016-06-27 17:49:53.09813	2850
30152	43	2016-06-27 17:49:53.110433	2844
30153	43	2016-06-27 17:49:53.120432	2846
30154	48	2016-06-27 17:49:53.130551	2843
30155	48	2016-06-27 17:49:53.151887	2845
30156	48	2016-06-27 17:49:53.164356	2849
30157	48	2016-06-27 17:49:53.171288	2834
30158	48	2016-06-27 17:49:53.18524	2847
30159	47	2016-06-27 17:49:53.204533	2843
30160	47	2016-06-27 17:49:53.218829	2845
30161	47	2016-06-27 17:49:53.240631	2849
30162	47	2016-06-27 17:49:53.262301	2834
30163	47	2016-06-27 17:49:53.277418	2847
30164	42	2016-06-27 17:53:03.74534	2849
30165	42	2016-06-27 17:53:03.752251	2834
30166	42	2016-06-27 17:53:03.759939	2843
30167	42	2016-06-27 17:53:03.768059	2845
30168	42	2016-06-27 17:53:03.77724	2847
30169	43	2016-06-27 17:53:03.785647	2848
30170	43	2016-06-27 17:53:03.792021	2835
30171	43	2016-06-27 17:53:03.79969	2850
30172	43	2016-06-27 17:53:03.808125	2844
30173	43	2016-06-27 17:53:03.815573	2846
30174	48	2016-06-27 17:53:03.824177	2843
30175	48	2016-06-27 17:53:03.831295	2845
30176	48	2016-06-27 17:53:03.837992	2849
30177	48	2016-06-27 17:53:03.844223	2834
30178	48	2016-06-27 17:53:03.850401	2847
30179	47	2016-06-27 17:53:03.85823	2843
30180	47	2016-06-27 17:53:03.864421	2845
30181	47	2016-06-27 17:53:03.871281	2849
30182	47	2016-06-27 17:53:03.877149	2834
30183	47	2016-06-27 17:53:03.883833	2847
30184	42	2016-06-27 17:55:39.746079	2849
30185	42	2016-06-27 17:55:39.752435	2834
30186	42	2016-06-27 17:55:39.758837	2843
30187	42	2016-06-27 17:55:39.764443	2845
30188	42	2016-06-27 17:55:39.772058	2847
30189	43	2016-06-27 17:55:39.779469	2848
30190	43	2016-06-27 17:55:39.78605	2835
30191	43	2016-06-27 17:55:39.791852	2850
30192	43	2016-06-27 17:55:39.797687	2844
30193	43	2016-06-27 17:55:39.803999	2846
30194	48	2016-06-27 17:55:39.812168	2843
30195	48	2016-06-27 17:55:39.818194	2845
30196	48	2016-06-27 17:55:39.824021	2849
30197	48	2016-06-27 17:55:39.830615	2834
30198	48	2016-06-27 17:55:39.836867	2847
30199	47	2016-06-27 17:55:39.843501	2843
30200	47	2016-06-27 17:55:39.849877	2845
30201	47	2016-06-27 17:55:39.856496	2849
30202	47	2016-06-27 17:55:39.86257	2834
30203	47	2016-06-27 17:55:39.869183	2847
30204	42	2016-06-27 17:57:40.963855	2849
30205	42	2016-06-27 17:57:40.970276	2834
30206	42	2016-06-27 17:57:40.976379	2843
30207	42	2016-06-27 17:57:40.982916	2845
30208	42	2016-06-27 17:57:40.989147	2847
30209	43	2016-06-27 17:57:40.995852	2848
30210	43	2016-06-27 17:57:41.001811	2835
30211	43	2016-06-27 17:57:41.007806	2850
30212	43	2016-06-27 17:57:41.014117	2844
30213	43	2016-06-27 17:57:41.020004	2846
30214	48	2016-06-27 17:57:41.028057	2843
30215	48	2016-06-27 17:57:41.034251	2845
30216	48	2016-06-27 17:57:41.04036	2849
30217	48	2016-06-27 17:57:41.047202	2834
30218	48	2016-06-27 17:57:41.06888	2847
30219	47	2016-06-27 17:57:41.090551	2843
30220	47	2016-06-27 17:57:41.096779	2845
30221	47	2016-06-27 17:57:41.102792	2849
30222	47	2016-06-27 17:57:41.108798	2834
30223	47	2016-06-27 17:57:41.115162	2847
30224	42	2016-06-27 17:59:52.341198	2849
30225	42	2016-06-27 17:59:52.371221	2834
30226	42	2016-06-27 17:59:52.380821	2843
30227	42	2016-06-27 17:59:52.386987	2845
30228	42	2016-06-27 17:59:52.392948	2847
30229	43	2016-06-27 17:59:52.399242	2848
30230	43	2016-06-27 17:59:52.405066	2835
30231	43	2016-06-27 17:59:52.410667	2850
30232	43	2016-06-27 17:59:52.416558	2844
30233	43	2016-06-27 17:59:52.423343	2846
30234	48	2016-06-27 17:59:52.431562	2843
30235	48	2016-06-27 17:59:52.437594	2845
30236	48	2016-06-27 17:59:52.443849	2849
30237	48	2016-06-27 17:59:52.45009	2834
30238	48	2016-06-27 17:59:52.456495	2847
30239	47	2016-06-27 17:59:52.465429	2843
30240	47	2016-06-27 17:59:52.472324	2845
30241	47	2016-06-27 17:59:52.479327	2849
30242	47	2016-06-27 17:59:52.486075	2834
30243	47	2016-06-27 17:59:52.493065	2847
30244	42	2016-06-27 18:03:18.680594	2849
30245	42	2016-06-27 18:03:18.686957	2834
30246	42	2016-06-27 18:03:18.692928	2843
30247	42	2016-06-27 18:03:18.698738	2845
30248	42	2016-06-27 18:03:18.705201	2847
30249	43	2016-06-27 18:03:18.711781	2848
30250	43	2016-06-27 18:03:18.723208	2835
30251	43	2016-06-27 18:03:18.729505	2850
30252	43	2016-06-27 18:03:18.735288	2844
30253	43	2016-06-27 18:03:18.741662	2846
30254	48	2016-06-27 18:03:18.74988	2843
30255	48	2016-06-27 18:03:18.756098	2845
30256	48	2016-06-27 18:03:18.762621	2849
30257	48	2016-06-27 18:03:18.768983	2834
30258	48	2016-06-27 18:03:18.775333	2847
30259	47	2016-06-27 18:03:18.781749	2843
30260	47	2016-06-27 18:03:18.788289	2845
30261	47	2016-06-27 18:03:18.794534	2849
30262	47	2016-06-27 18:03:18.800663	2834
30263	47	2016-06-27 18:03:18.807038	2847
30264	42	2016-06-27 18:04:42.909739	2849
30265	42	2016-06-27 18:04:42.916084	2834
30266	42	2016-06-27 18:04:42.922226	2843
30267	42	2016-06-27 18:04:42.928534	2845
30268	42	2016-06-27 18:04:42.934807	2847
30269	43	2016-06-27 18:04:42.941285	2848
30270	43	2016-06-27 18:04:42.94759	2835
30271	43	2016-06-27 18:04:42.953522	2850
30272	43	2016-06-27 18:04:42.959708	2844
30273	43	2016-06-27 18:04:42.966297	2846
30274	48	2016-06-27 18:04:42.97609	2843
30275	48	2016-06-27 18:04:42.983382	2845
30276	48	2016-06-27 18:04:42.990287	2849
30277	48	2016-06-27 18:04:42.996745	2834
30278	48	2016-06-27 18:04:43.003315	2847
30279	47	2016-06-27 18:04:43.010494	2843
30280	47	2016-06-27 18:04:43.016517	2845
30281	47	2016-06-27 18:04:43.022761	2849
30282	47	2016-06-27 18:04:43.02908	2834
30283	47	2016-06-27 18:04:43.035226	2847
30284	42	2016-06-27 18:07:59.672272	2849
30285	42	2016-06-27 18:07:59.795137	2834
30286	42	2016-06-27 18:07:59.847783	2843
30287	42	2016-06-27 18:07:59.934861	2845
30288	42	2016-06-27 18:08:00.009838	2847
30289	43	2016-06-27 18:08:00.064054	2848
30290	43	2016-06-27 18:08:00.142563	2835
30291	43	2016-06-27 18:08:00.197646	2850
30292	43	2016-06-27 18:08:00.220793	2844
30293	43	2016-06-27 18:08:00.320222	2846
30294	48	2016-06-27 18:08:00.354461	2843
30295	48	2016-06-27 18:08:00.417085	2845
30296	48	2016-06-27 18:08:00.499811	2849
30297	48	2016-06-27 18:08:00.57888	2834
30298	48	2016-06-27 18:08:00.681528	2847
30299	47	2016-06-27 18:08:00.728599	2843
30300	47	2016-06-27 18:08:00.769448	2845
30301	47	2016-06-27 18:08:00.82549	2849
30302	47	2016-06-27 18:08:00.855698	2834
30303	47	2016-06-27 18:08:00.904626	2847
30304	42	2016-06-27 18:09:11.912278	2849
30305	42	2016-06-27 18:09:11.920126	2834
30306	42	2016-06-27 18:09:11.92761	2843
30307	42	2016-06-27 18:09:11.935456	2845
30308	42	2016-06-27 18:09:11.942918	2851
30309	42	2016-06-27 18:09:11.949991	2847
30310	43	2016-06-27 18:09:11.957562	2848
30311	43	2016-06-27 18:09:11.964374	2835
30312	43	2016-06-27 18:09:11.971577	2850
30313	43	2016-06-27 18:09:11.977775	2844
30314	43	2016-06-27 18:09:11.984664	2846
30315	43	2016-06-27 18:09:11.99202	2852
30316	48	2016-06-27 18:09:12.002556	2843
30317	48	2016-06-27 18:09:12.009914	2845
30318	48	2016-06-27 18:09:12.017429	2849
30319	48	2016-06-27 18:09:12.024922	2834
30320	48	2016-06-27 18:09:12.032394	2847
30321	47	2016-06-27 18:09:12.040455	2843
30322	47	2016-06-27 18:09:12.050359	2845
30323	47	2016-06-27 18:09:12.060105	2849
30324	47	2016-06-27 18:09:12.068248	2834
30325	47	2016-06-27 18:09:12.091593	2847
30326	42	2016-06-27 18:10:44.051384	2853
30327	42	2016-06-27 18:10:44.058476	2849
30328	42	2016-06-27 18:10:44.064329	2834
30329	42	2016-06-27 18:10:44.070878	2845
30330	42	2016-06-27 18:10:44.077176	2851
30331	42	2016-06-27 18:10:44.083414	2847
30332	42	2016-06-27 18:10:44.089751	2843
30333	43	2016-06-27 18:10:44.096412	2848
30334	43	2016-06-27 18:10:44.103146	2835
30335	43	2016-06-27 18:10:44.109268	2844
30336	43	2016-06-27 18:10:44.115119	2846
30337	43	2016-06-27 18:10:44.121707	2852
30338	43	2016-06-27 18:10:44.127743	2854
30339	43	2016-06-27 18:10:44.134335	2850
30340	48	2016-06-27 18:10:44.14348	2843
30341	48	2016-06-27 18:10:44.150045	2845
30342	48	2016-06-27 18:10:44.157249	2849
30343	48	2016-06-27 18:10:44.16358	2834
30344	48	2016-06-27 18:10:44.171416	2847
30345	47	2016-06-27 18:10:44.178264	2849
30346	47	2016-06-27 18:10:44.184998	2851
30347	47	2016-06-27 18:10:44.191621	2834
30348	47	2016-06-27 18:10:44.198225	2847
30349	47	2016-06-27 18:10:44.205196	2843
30350	47	2016-06-27 18:10:44.211823	2845
30351	42	2016-06-27 18:18:18.692604	2853
30352	42	2016-06-27 18:18:18.699584	2849
30353	42	2016-06-27 18:18:18.706035	2834
30354	42	2016-06-27 18:18:18.712063	2845
30355	42	2016-06-27 18:18:18.718165	2855
30356	42	2016-06-27 18:18:18.7248	2847
30357	42	2016-06-27 18:18:18.730775	2843
30358	42	2016-06-27 18:18:18.736757	2851
30359	43	2016-06-27 18:18:18.743213	2848
30360	43	2016-06-27 18:18:18.749284	2835
30361	43	2016-06-27 18:18:18.755428	2844
30362	43	2016-06-27 18:18:18.761246	2846
30363	43	2016-06-27 18:18:18.767278	2852
30364	43	2016-06-27 18:18:18.773274	2856
30365	43	2016-06-27 18:18:18.779048	2854
30366	43	2016-06-27 18:18:18.785001	2850
30367	48	2016-06-27 18:18:18.793375	2849
30368	48	2016-06-27 18:18:18.800387	2851
30369	48	2016-06-27 18:18:18.806781	2834
30370	48	2016-06-27 18:18:18.813194	2847
30371	48	2016-06-27 18:18:18.820563	2843
30372	48	2016-06-27 18:18:18.82699	2845
30373	47	2016-06-27 18:18:18.833916	2849
30374	47	2016-06-27 18:18:18.841157	2851
30375	47	2016-06-27 18:18:18.847922	2853
30376	47	2016-06-27 18:18:18.855458	2834
30377	47	2016-06-27 18:18:18.861873	2847
30378	47	2016-06-27 18:18:18.867906	2843
30379	47	2016-06-27 18:18:18.874964	2845
30380	42	2016-06-27 18:20:18.994099	2853
30381	42	2016-06-27 18:20:19.001798	2849
30382	42	2016-06-27 18:20:19.009326	2834
30383	42	2016-06-27 18:20:19.016192	2845
30384	42	2016-06-27 18:20:19.02251	2855
30385	42	2016-06-27 18:20:19.028324	2847
30386	42	2016-06-27 18:20:19.034736	2843
30387	42	2016-06-27 18:20:19.040798	2851
30388	43	2016-06-27 18:20:19.04782	2848
30389	43	2016-06-27 18:20:19.053744	2835
30390	43	2016-06-27 18:20:19.059941	2844
30391	43	2016-06-27 18:20:19.066617	2846
30392	43	2016-06-27 18:20:19.072567	2852
30393	43	2016-06-27 18:20:19.079137	2856
30394	43	2016-06-27 18:20:19.085462	2854
30395	43	2016-06-27 18:20:19.091834	2850
30396	48	2016-06-27 18:20:19.100855	2849
30397	48	2016-06-27 18:20:19.107727	2851
30398	48	2016-06-27 18:20:19.114083	2853
30399	48	2016-06-27 18:20:19.121226	2834
30400	48	2016-06-27 18:20:19.128615	2847
30401	48	2016-06-27 18:20:19.135915	2843
30402	48	2016-06-27 18:20:19.142833	2845
30403	47	2016-06-27 18:20:19.150343	2849
30404	47	2016-06-27 18:20:19.157692	2851
30405	47	2016-06-27 18:20:19.164248	2853
30406	47	2016-06-27 18:20:19.170643	2834
30407	47	2016-06-27 18:20:19.17742	2847
30408	47	2016-06-27 18:20:19.184195	2843
30409	47	2016-06-27 18:20:19.190888	2845
30410	47	2016-06-27 18:20:19.197604	2855
30411	42	2016-06-27 18:22:20.368561	2853
30412	42	2016-06-27 18:22:20.378613	2849
30413	42	2016-06-27 18:22:20.38932	2834
30414	42	2016-06-27 18:22:20.396099	2845
30415	42	2016-06-27 18:22:20.413398	2855
30416	42	2016-06-27 18:22:20.429808	2847
30417	42	2016-06-27 18:22:20.445468	2843
30418	42	2016-06-27 18:22:20.456315	2851
30419	43	2016-06-27 18:22:20.463858	2848
30420	43	2016-06-27 18:22:20.477374	2835
30421	43	2016-06-27 18:22:20.493092	2844
30422	43	2016-06-27 18:22:20.510975	2846
30423	43	2016-06-27 18:22:20.530171	2852
30424	43	2016-06-27 18:22:20.539777	2856
30425	43	2016-06-27 18:22:20.551089	2854
30426	43	2016-06-27 18:22:20.562509	2850
30427	48	2016-06-27 18:22:20.575084	2849
30428	48	2016-06-27 18:22:20.593658	2851
30429	48	2016-06-27 18:22:20.606255	2853
30430	48	2016-06-27 18:22:20.614756	2834
30431	48	2016-06-27 18:22:20.626473	2847
30432	48	2016-06-27 18:22:20.641583	2843
30433	48	2016-06-27 18:22:20.669237	2845
30434	48	2016-06-27 18:22:20.691902	2855
30435	47	2016-06-27 18:22:20.706252	2849
30436	47	2016-06-27 18:22:20.718945	2851
30437	47	2016-06-27 18:22:20.737886	2853
30438	47	2016-06-27 18:22:20.759629	2834
30439	47	2016-06-27 18:22:20.77406	2847
30440	47	2016-06-27 18:22:20.784129	2843
30441	47	2016-06-27 18:22:20.801579	2845
30442	47	2016-06-27 18:22:20.822618	2855
30443	42	2016-06-27 18:39:54.748325	2853
30444	42	2016-06-27 18:39:54.755187	2849
30445	42	2016-06-27 18:39:54.761191	2834
30446	42	2016-06-27 18:39:54.767265	2845
30447	42	2016-06-27 18:39:54.773779	2855
30448	42	2016-06-27 18:39:54.780107	2847
30449	42	2016-06-27 18:39:54.785957	2843
30450	42	2016-06-27 18:39:54.791817	2851
30451	43	2016-06-27 18:39:54.797888	2848
30452	43	2016-06-27 18:39:54.803853	2835
30453	43	2016-06-27 18:39:54.8099	2844
30454	43	2016-06-27 18:39:54.815586	2846
30455	43	2016-06-27 18:39:54.821637	2852
30456	43	2016-06-27 18:39:54.827447	2856
30457	43	2016-06-27 18:39:54.833227	2854
30458	43	2016-06-27 18:39:54.839765	2850
30459	48	2016-06-27 18:39:54.848713	2849
30460	48	2016-06-27 18:39:54.855058	2851
30461	48	2016-06-27 18:39:54.861224	2853
30462	48	2016-06-27 18:39:54.867386	2834
30463	48	2016-06-27 18:39:54.873831	2847
30464	48	2016-06-27 18:39:54.880031	2843
30465	48	2016-06-27 18:39:54.886723	2845
30466	48	2016-06-27 18:39:54.893771	2855
30467	47	2016-06-27 18:39:54.900442	2849
30468	47	2016-06-27 18:39:54.906845	2851
30469	47	2016-06-27 18:39:54.912947	2853
30470	47	2016-06-27 18:39:54.919411	2834
30471	47	2016-06-27 18:39:54.925682	2847
30472	47	2016-06-27 18:39:54.933161	2843
30473	47	2016-06-27 18:39:54.939392	2845
30474	47	2016-06-27 18:39:54.945816	2855
30475	40	2016-06-27 18:40:28.469358	47706
30476	41	2016-06-27 18:41:53.176234	2857
30477	42	2016-06-27 18:41:53.183798	2853
30478	42	2016-06-27 18:41:53.190061	2849
30479	42	2016-06-27 18:41:53.196708	2834
30480	42	2016-06-27 18:41:53.203256	2845
30481	42	2016-06-27 18:41:53.209949	2855
30482	42	2016-06-27 18:41:53.217032	2851
30483	42	2016-06-27 18:41:53.223365	2847
30484	43	2016-06-27 18:41:53.231226	2848
30485	43	2016-06-27 18:41:53.23752	2835
30486	43	2016-06-27 18:41:53.243231	2846
30487	43	2016-06-27 18:41:53.249194	2852
30488	43	2016-06-27 18:41:53.255425	2856
30489	43	2016-06-27 18:41:53.261188	2854
30490	43	2016-06-27 18:41:53.267027	2850
30491	40	2016-06-27 18:41:53.273887	47706
30492	49	2016-06-27 18:41:53.280218	47706
30493	48	2016-06-27 18:41:53.287053	2849
30494	48	2016-06-27 18:41:53.293498	2851
30495	48	2016-06-27 18:41:53.299629	2853
30496	48	2016-06-27 18:41:53.305901	2834
30497	48	2016-06-27 18:41:53.312861	2847
30498	48	2016-06-27 18:41:53.319768	2843
30499	48	2016-06-27 18:41:53.326154	2845
30500	48	2016-06-27 18:41:53.332474	2855
30501	47	2016-06-27 18:41:53.33935	2849
30502	47	2016-06-27 18:41:53.345603	2851
30503	47	2016-06-27 18:41:53.351822	2853
30504	47	2016-06-27 18:41:53.358084	2834
30505	47	2016-06-27 18:41:53.364251	2847
30506	47	2016-06-27 18:41:53.370009	2843
30507	47	2016-06-27 18:41:53.376275	2845
30508	47	2016-06-27 18:41:53.382664	2855
30509	40	2016-06-27 18:42:51.021395	47709
30510	41	2016-06-27 18:42:54.155765	2857
30511	42	2016-06-27 18:42:54.162924	2853
30512	42	2016-06-27 18:42:54.168781	2849
30513	42	2016-06-27 18:42:54.174709	2834
30514	42	2016-06-27 18:42:54.180933	2855
30515	42	2016-06-27 18:42:54.186947	2851
30516	42	2016-06-27 18:42:54.193208	2847
30517	43	2016-06-27 18:42:54.200255	2848
30518	43	2016-06-27 18:42:54.206757	2835
30519	43	2016-06-27 18:42:54.212818	2850
30520	43	2016-06-27 18:42:54.219227	2852
30521	43	2016-06-27 18:42:54.225578	2856
30522	43	2016-06-27 18:42:54.231937	2854
30523	40	2016-06-27 18:42:54.239388	47706
30524	49	2016-06-27 18:42:54.251022	47706
30525	48	2016-06-27 18:42:54.257674	2849
30526	48	2016-06-27 18:42:54.265719	2851
30527	48	2016-06-27 18:42:54.272312	2853
30528	48	2016-06-27 18:42:54.27864	2834
30529	48	2016-06-27 18:42:54.285247	2847
30530	48	2016-06-27 18:42:54.291243	2843
30531	48	2016-06-27 18:42:54.297453	2845
30532	48	2016-06-27 18:42:54.304121	2855
30533	50	2016-06-27 18:42:54.310424	47706
30534	47	2016-06-27 18:42:54.317269	2849
30535	47	2016-06-27 18:42:54.323496	2851
30536	47	2016-06-27 18:42:54.329736	2853
30537	47	2016-06-27 18:42:54.336548	2834
30538	47	2016-06-27 18:42:54.343018	2847
30539	47	2016-06-27 18:42:54.349182	2843
30540	47	2016-06-27 18:42:54.355261	2845
30541	47	2016-06-27 18:42:54.361616	2855
30542	41	2016-06-27 18:44:46.273209	2857
30543	41	2016-06-27 18:44:46.280318	2858
30544	42	2016-06-27 18:44:46.287171	2853
30545	42	2016-06-27 18:44:46.293122	2849
30546	42	2016-06-27 18:44:46.299014	2834
30547	42	2016-06-27 18:44:46.304941	2855
30548	42	2016-06-27 18:44:46.311664	2851
30549	42	2016-06-27 18:44:46.318229	2847
30550	43	2016-06-27 18:44:46.325974	2848
30551	43	2016-06-27 18:44:46.333225	2835
30552	43	2016-06-27 18:44:46.339439	2850
30553	43	2016-06-27 18:44:46.345587	2852
30554	43	2016-06-27 18:44:46.35201	2856
30555	43	2016-06-27 18:44:46.358893	2854
30556	40	2016-06-27 18:44:46.366399	47706
30557	40	2016-06-27 18:44:46.372022	47709
30558	49	2016-06-27 18:44:46.37872	47706
30559	49	2016-06-27 18:44:46.384684	47709
30560	48	2016-06-27 18:44:46.391656	2849
30561	48	2016-06-27 18:44:46.398927	2851
30562	48	2016-06-27 18:44:46.405549	2853
30563	48	2016-06-27 18:44:46.4124	2834
30564	48	2016-06-27 18:44:46.419302	2847
30565	48	2016-06-27 18:44:46.425422	2843
30566	48	2016-06-27 18:44:46.431529	2845
30567	48	2016-06-27 18:44:46.43858	2855
30568	50	2016-06-27 18:44:46.445137	47706
30569	47	2016-06-27 18:44:46.452119	2849
30570	47	2016-06-27 18:44:46.458501	2851
30571	47	2016-06-27 18:44:46.464462	2853
30572	47	2016-06-27 18:44:46.471248	2834
30573	47	2016-06-27 18:44:46.477787	2847
30574	47	2016-06-27 18:44:46.484074	2843
30575	47	2016-06-27 18:44:46.489877	2845
30576	47	2016-06-27 18:44:46.496121	2855
30577	41	2016-06-27 18:46:15.808549	2857
30578	41	2016-06-27 18:46:15.816345	2858
30579	42	2016-06-27 18:46:15.823605	2853
30580	42	2016-06-27 18:46:15.830406	2849
30581	42	2016-06-27 18:46:15.836885	2834
30582	42	2016-06-27 18:46:15.843556	2855
30583	42	2016-06-27 18:46:15.850594	2851
30584	42	2016-06-27 18:46:15.856856	2847
30585	43	2016-06-27 18:46:15.863625	2848
30586	43	2016-06-27 18:46:15.86998	2835
30587	43	2016-06-27 18:46:15.876039	2850
30588	43	2016-06-27 18:46:15.882913	2852
30589	43	2016-06-27 18:46:15.889099	2856
30590	43	2016-06-27 18:46:15.894993	2854
30591	40	2016-06-27 18:46:15.90229	47706
30592	40	2016-06-27 18:46:15.907881	47709
30593	49	2016-06-27 18:46:15.914869	47706
30594	49	2016-06-27 18:46:15.920701	47709
30595	48	2016-06-27 18:46:15.928131	2849
30596	48	2016-06-27 18:46:15.935583	2851
30597	48	2016-06-27 18:46:15.942349	2853
30598	48	2016-06-27 18:46:15.949084	2834
30599	48	2016-06-27 18:46:15.955526	2847
30600	48	2016-06-27 18:46:15.961578	2843
30601	48	2016-06-27 18:46:15.9679	2845
30602	48	2016-06-27 18:46:15.97448	2855
30603	50	2016-06-27 18:46:15.981207	47709
30604	50	2016-06-27 18:46:15.987264	47706
30605	47	2016-06-27 18:46:15.994967	2849
30606	47	2016-06-27 18:46:16.002036	2851
30607	47	2016-06-27 18:46:16.008339	2853
30608	47	2016-06-27 18:46:16.015071	2834
30609	47	2016-06-27 18:46:16.02178	2847
30610	47	2016-06-27 18:46:16.028032	2843
30611	47	2016-06-27 18:46:16.034376	2845
30612	47	2016-06-27 18:46:16.040557	2855
30613	42	2016-06-27 18:46:42.068945	2859
30614	43	2016-06-27 18:46:42.092869	2860
30615	41	2016-06-27 18:48:06.163485	2857
30616	41	2016-06-27 18:48:06.17094	2858
30617	42	2016-06-27 18:48:06.177934	2853
30618	42	2016-06-27 18:48:06.18479	2849
30619	42	2016-06-27 18:48:06.191221	2834
30620	42	2016-06-27 18:48:06.197681	2855
30621	42	2016-06-27 18:48:06.20396	2847
30622	42	2016-06-27 18:48:06.210214	2859
30623	42	2016-06-27 18:48:06.216183	2861
30624	42	2016-06-27 18:48:06.222711	2851
30625	43	2016-06-27 18:48:06.229039	2848
30626	43	2016-06-27 18:48:06.235103	2835
30627	43	2016-06-27 18:48:06.241538	2852
30628	43	2016-06-27 18:48:06.247796	2856
30629	43	2016-06-27 18:48:06.253852	2854
30630	43	2016-06-27 18:48:06.260276	2850
30631	43	2016-06-27 18:48:06.266292	2860
30632	43	2016-06-27 18:48:06.273065	2862
30633	40	2016-06-27 18:48:06.280006	47706
30634	40	2016-06-27 18:48:06.285535	47709
30635	49	2016-06-27 18:48:06.29299	47706
30636	49	2016-06-27 18:48:06.298675	47709
30637	48	2016-06-27 18:48:06.306114	2849
30638	48	2016-06-27 18:48:06.312549	2851
30639	48	2016-06-27 18:48:06.319176	2853
30640	48	2016-06-27 18:48:06.328066	2834
30641	48	2016-06-27 18:48:06.33469	2847
30642	48	2016-06-27 18:48:06.340959	2843
30643	48	2016-06-27 18:48:06.346927	2845
30644	48	2016-06-27 18:48:06.353211	2855
30645	50	2016-06-27 18:48:06.360153	47706
30646	50	2016-06-27 18:48:06.366049	47709
30647	47	2016-06-27 18:48:06.372992	2849
30648	47	2016-06-27 18:48:06.379327	2851
30649	47	2016-06-27 18:48:06.385848	2853
30650	47	2016-06-27 18:48:06.392736	2834
30651	47	2016-06-27 18:48:06.399596	2847
30652	47	2016-06-27 18:48:06.40667	2859
30653	47	2016-06-27 18:48:06.41262	2843
30654	47	2016-06-27 18:48:06.419215	2845
30655	47	2016-06-27 18:48:06.425865	2855
30656	41	2016-06-27 18:49:20.416139	2857
30657	41	2016-06-27 18:49:20.426547	2858
30658	42	2016-06-27 18:49:20.434685	2853
30659	42	2016-06-27 18:49:20.441584	2849
30660	42	2016-06-27 18:49:20.448186	2834
30661	42	2016-06-27 18:49:20.454523	2855
30662	42	2016-06-27 18:49:20.461429	2847
30663	42	2016-06-27 18:49:20.468226	2859
30664	42	2016-06-27 18:49:20.474709	2861
30665	42	2016-06-27 18:49:20.481247	2851
30666	43	2016-06-27 18:49:20.48775	2848
30667	43	2016-06-27 18:49:20.494227	2835
30668	43	2016-06-27 18:49:20.501248	2852
30669	43	2016-06-27 18:49:20.507561	2856
30670	43	2016-06-27 18:49:20.514086	2854
30671	43	2016-06-27 18:49:20.520462	2850
30672	43	2016-06-27 18:49:20.527996	2860
30673	43	2016-06-27 18:49:20.534674	2862
30674	40	2016-06-27 18:49:20.542079	47706
30675	40	2016-06-27 18:49:20.548206	47709
30676	49	2016-06-27 18:49:20.555349	47706
30677	49	2016-06-27 18:49:20.561915	47709
30678	48	2016-06-27 18:49:20.57001	2849
30679	48	2016-06-27 18:49:20.578655	2851
30680	48	2016-06-27 18:49:20.585346	2853
30681	48	2016-06-27 18:49:20.592585	2834
30682	48	2016-06-27 18:49:20.599481	2847
30683	48	2016-06-27 18:49:20.606165	2859
30684	48	2016-06-27 18:49:20.61266	2843
30685	48	2016-06-27 18:49:20.619268	2845
30686	48	2016-06-27 18:49:20.62579	2855
30687	50	2016-06-27 18:49:20.632257	47706
30688	50	2016-06-27 18:49:20.638325	47709
30689	47	2016-06-27 18:49:20.645403	2851
30690	47	2016-06-27 18:49:20.652027	2853
30691	47	2016-06-27 18:49:20.658356	2834
30692	47	2016-06-27 18:49:20.665418	2847
30693	47	2016-06-27 18:49:20.6716	2859
30694	47	2016-06-27 18:49:20.678281	2843
30695	47	2016-06-27 18:49:20.685517	2845
30696	47	2016-06-27 18:49:20.692681	2855
30697	47	2016-06-27 18:49:20.699602	2861
30698	47	2016-06-27 18:49:20.70633	2849
30699	42	2016-06-27 18:49:39.067408	2863
30700	43	2016-06-27 18:49:39.146751	2864
30701	41	2016-06-27 19:24:35.397143	2857
30702	41	2016-06-27 19:24:35.403848	2858
30703	42	2016-06-27 19:24:35.411159	2853
30704	42	2016-06-27 19:24:35.417394	2849
30705	42	2016-06-27 19:24:35.423677	2834
30706	42	2016-06-27 19:24:35.429991	2855
30707	42	2016-06-27 19:24:35.436094	2847
30708	42	2016-06-27 19:24:35.442027	2859
30709	42	2016-06-27 19:24:35.44818	2861
30710	42	2016-06-27 19:24:35.455334	2851
30711	43	2016-06-27 19:24:35.461942	2848
30712	43	2016-06-27 19:24:35.467917	2835
30713	43	2016-06-27 19:24:35.473983	2852
30714	43	2016-06-27 19:24:35.480039	2856
30715	43	2016-06-27 19:24:35.486236	2854
30716	43	2016-06-27 19:24:35.492208	2864
30717	43	2016-06-27 19:24:35.498303	2850
30718	43	2016-06-27 19:24:35.504189	2860
30719	43	2016-06-27 19:24:35.509959	2862
30720	40	2016-06-27 19:24:35.531686	47706
30721	40	2016-06-27 19:24:35.537832	47709
30722	49	2016-06-27 19:24:35.544725	47706
30723	49	2016-06-27 19:24:35.550461	47709
30724	48	2016-06-27 19:24:35.557152	2851
30725	48	2016-06-27 19:24:35.563591	2853
30726	48	2016-06-27 19:24:35.570527	2834
30727	48	2016-06-27 19:24:35.577744	2847
30728	48	2016-06-27 19:24:35.584079	2859
30729	48	2016-06-27 19:24:35.589989	2843
30730	48	2016-06-27 19:24:35.596516	2845
30731	48	2016-06-27 19:24:35.60299	2855
30732	48	2016-06-27 19:24:35.609258	2861
30733	48	2016-06-27 19:24:35.61579	2849
30734	50	2016-06-27 19:24:35.622243	47706
30735	50	2016-06-27 19:24:35.628456	47709
30736	47	2016-06-27 19:24:35.635653	2851
30737	47	2016-06-27 19:24:35.641848	2853
30738	47	2016-06-27 19:24:35.648159	2834
30739	47	2016-06-27 19:24:35.65469	2847
30740	47	2016-06-27 19:24:35.661062	2859
30741	47	2016-06-27 19:24:35.66694	2863
30742	47	2016-06-27 19:24:35.672836	2843
30743	47	2016-06-27 19:24:35.67877	2845
30744	47	2016-06-27 19:24:35.685307	2855
30745	47	2016-06-27 19:24:35.691606	2861
30746	47	2016-06-27 19:24:35.698007	2849
30747	40	2016-06-27 19:25:09.128242	47733
30748	41	2016-06-27 19:25:45.241184	2857
30749	41	2016-06-27 19:25:45.249167	2858
30750	42	2016-06-27 19:25:45.256561	2853
30751	42	2016-06-27 19:25:45.262799	2849
30752	42	2016-06-27 19:25:45.269237	2834
30753	42	2016-06-27 19:25:45.275759	2855
30754	42	2016-06-27 19:25:45.282592	2851
30755	42	2016-06-27 19:25:45.289023	2847
30756	42	2016-06-27 19:25:45.295281	2859
30757	43	2016-06-27 19:25:45.302369	2848
30758	43	2016-06-27 19:25:45.3087	2835
30759	43	2016-06-27 19:25:45.315147	2852
30760	43	2016-06-27 19:25:45.321567	2856
30761	43	2016-06-27 19:25:45.328178	2854
30762	43	2016-06-27 19:25:45.334271	2850
30763	43	2016-06-27 19:25:45.340734	2860
30764	43	2016-06-27 19:25:45.347441	2862
30765	40	2016-06-27 19:25:45.354784	47706
30766	40	2016-06-27 19:25:45.365979	47709
30767	49	2016-06-27 19:25:45.372764	47706
30768	49	2016-06-27 19:25:45.378861	47709
30769	48	2016-06-27 19:25:45.386348	2851
30770	48	2016-06-27 19:25:45.393032	2834
30771	48	2016-06-27 19:25:45.400347	2847
30772	48	2016-06-27 19:25:45.406946	2859
30773	48	2016-06-27 19:25:45.413278	2863
30774	48	2016-06-27 19:25:45.419691	2843
30775	48	2016-06-27 19:25:45.425864	2845
30776	48	2016-06-27 19:25:45.432763	2855
30777	48	2016-06-27 19:25:45.438984	2861
30778	48	2016-06-27 19:25:45.445908	2849
30779	48	2016-06-27 19:25:45.452643	2853
30780	50	2016-06-27 19:25:45.458936	47706
30781	50	2016-06-27 19:25:45.465735	47709
30782	47	2016-06-27 19:25:45.472727	2851
30783	47	2016-06-27 19:25:45.479207	2834
30784	47	2016-06-27 19:25:45.485664	2847
30785	47	2016-06-27 19:25:45.492194	2859
30786	47	2016-06-27 19:25:45.498277	2863
30787	47	2016-06-27 19:25:45.50509	2843
30788	47	2016-06-27 19:25:45.51155	2845
30789	47	2016-06-27 19:25:45.517956	2855
30790	47	2016-06-27 19:25:45.524447	2861
30791	47	2016-06-27 19:25:45.531288	2849
30792	47	2016-06-27 19:25:45.539034	2853
30793	40	2016-06-27 19:26:01.777032	47730
30794	41	2016-06-27 19:26:09.930556	2865
30795	40	2016-06-27 19:26:10.032156	47733
30796	49	2016-06-27 19:26:10.055055	47733
30797	40	2016-06-27 19:26:36.268922	47727
30798	41	2016-06-27 19:28:10.058876	2857
30799	41	2016-06-27 19:28:10.065753	2858
30800	41	2016-06-27 19:28:10.072621	2865
30801	41	2016-06-27 19:28:10.079172	2866
30802	41	2016-06-27 19:28:10.086383	2867
30803	42	2016-06-27 19:28:10.093721	2853
30804	42	2016-06-27 19:28:10.101263	2849
30805	42	2016-06-27 19:28:10.108299	2834
30806	42	2016-06-27 19:28:10.114767	2855
30807	42	2016-06-27 19:28:10.122161	2851
30808	42	2016-06-27 19:28:10.128564	2847
30809	43	2016-06-27 19:28:10.135245	2848
30810	43	2016-06-27 19:28:10.142175	2835
30811	43	2016-06-27 19:28:10.14849	2850
30812	43	2016-06-27 19:28:10.155628	2852
30813	43	2016-06-27 19:28:10.161648	2856
30814	43	2016-06-27 19:28:10.16794	2854
30815	40	2016-06-27 19:28:10.182842	47706
30816	40	2016-06-27 19:28:10.189047	47733
30817	40	2016-06-27 19:28:10.194685	47730
30818	40	2016-06-27 19:28:10.200551	47709
30819	40	2016-06-27 19:28:10.20675	47727
30820	49	2016-06-27 19:28:10.213591	47706
30821	49	2016-06-27 19:28:10.219174	47733
30822	49	2016-06-27 19:28:10.225671	47727
30823	49	2016-06-27 19:28:10.231542	47709
30824	49	2016-06-27 19:28:10.23816	47730
30825	48	2016-06-27 19:28:10.245368	2851
30826	48	2016-06-27 19:28:10.251992	2834
30827	48	2016-06-27 19:28:10.259543	2847
30828	48	2016-06-27 19:28:10.265739	2859
30829	48	2016-06-27 19:28:10.272632	2863
30830	48	2016-06-27 19:28:10.278898	2843
30831	48	2016-06-27 19:28:10.285028	2845
30832	48	2016-06-27 19:28:10.292376	2855
30833	48	2016-06-27 19:28:10.298555	2861
30834	48	2016-06-27 19:28:10.305173	2849
30835	48	2016-06-27 19:28:10.311576	2853
30836	50	2016-06-27 19:28:10.317794	47706
30837	50	2016-06-27 19:28:10.323759	47733
30838	50	2016-06-27 19:28:10.329587	47709
30839	47	2016-06-27 19:28:10.336835	2851
30840	47	2016-06-27 19:28:10.344194	2834
30841	47	2016-06-27 19:28:10.351122	2847
30842	47	2016-06-27 19:28:10.357063	2859
30843	47	2016-06-27 19:28:10.36288	2863
30844	47	2016-06-27 19:28:10.368999	2843
30845	47	2016-06-27 19:28:10.374951	2845
30846	47	2016-06-27 19:28:10.381468	2855
30847	47	2016-06-27 19:28:10.387517	2861
30848	47	2016-06-27 19:28:10.394026	2849
30849	47	2016-06-27 19:28:10.400431	2853
30850	41	2016-06-27 19:29:48.952561	2857
30851	41	2016-06-27 19:29:48.959653	2858
30852	41	2016-06-27 19:29:48.966691	2865
30853	41	2016-06-27 19:29:48.973303	2866
30854	41	2016-06-27 19:29:48.979701	2867
30855	42	2016-06-27 19:29:48.986567	2853
30856	42	2016-06-27 19:29:48.992768	2849
30857	42	2016-06-27 19:29:48.999371	2834
30858	42	2016-06-27 19:29:49.005676	2855
30859	42	2016-06-27 19:29:49.011603	2851
30860	42	2016-06-27 19:29:49.017601	2847
30861	43	2016-06-27 19:29:49.024199	2848
30862	43	2016-06-27 19:29:49.030541	2835
30863	43	2016-06-27 19:29:49.036505	2850
30864	43	2016-06-27 19:29:49.043018	2852
30865	43	2016-06-27 19:29:49.049286	2856
30866	43	2016-06-27 19:29:49.055319	2854
30867	40	2016-06-27 19:29:49.06865	47706
30868	40	2016-06-27 19:29:49.07447	47733
30869	40	2016-06-27 19:29:49.07981	47730
30870	40	2016-06-27 19:29:49.085435	47709
30871	40	2016-06-27 19:29:49.090825	47727
30872	49	2016-06-27 19:29:49.097831	47706
30873	49	2016-06-27 19:29:49.103748	47727
30874	49	2016-06-27 19:29:49.109767	47709
30875	49	2016-06-27 19:29:49.115491	47730
30876	49	2016-06-27 19:29:49.121603	47733
30877	48	2016-06-27 19:29:49.128715	2851
30878	48	2016-06-27 19:29:49.135315	2834
30879	48	2016-06-27 19:29:49.142622	2847
30880	48	2016-06-27 19:29:49.148924	2859
30881	48	2016-06-27 19:29:49.154891	2863
30882	48	2016-06-27 19:29:49.162055	2843
30883	48	2016-06-27 19:29:49.168482	2845
30884	48	2016-06-27 19:29:49.175745	2855
30885	48	2016-06-27 19:29:49.18198	2861
30886	48	2016-06-27 19:29:49.188659	2849
30887	48	2016-06-27 19:29:49.196188	2853
30888	50	2016-06-27 19:29:49.203208	47706
30889	50	2016-06-27 19:29:49.210712	47733
30890	50	2016-06-27 19:29:49.217	47727
30891	50	2016-06-27 19:29:49.223309	47709
30892	50	2016-06-27 19:29:49.229627	47730
30893	47	2016-06-27 19:29:49.23665	2851
30894	47	2016-06-27 19:29:49.243933	2834
30895	47	2016-06-27 19:29:49.250762	2847
30896	47	2016-06-27 19:29:49.256644	2859
30897	47	2016-06-27 19:29:49.262987	2863
30898	47	2016-06-27 19:29:49.269323	2843
30899	47	2016-06-27 19:29:49.276656	2845
30900	47	2016-06-27 19:29:49.283542	2855
30901	47	2016-06-27 19:29:49.289794	2861
30902	47	2016-06-27 19:29:49.297123	2849
30903	47	2016-06-27 19:29:49.303733	2853
30904	41	2016-06-27 19:37:06.561835	2857
30905	41	2016-06-27 19:37:06.569962	2858
30906	41	2016-06-27 19:37:06.576471	2865
30907	41	2016-06-27 19:37:06.582957	2866
30908	41	2016-06-27 19:37:06.589661	2867
30909	42	2016-06-27 19:37:06.59657	2853
30910	42	2016-06-27 19:37:06.602719	2849
30911	42	2016-06-27 19:37:06.608772	2834
30912	42	2016-06-27 19:37:06.614932	2855
30913	42	2016-06-27 19:37:06.621511	2851
30914	42	2016-06-27 19:37:06.627817	2847
30915	43	2016-06-27 19:37:06.634259	2848
30916	43	2016-06-27 19:37:06.640634	2835
30917	43	2016-06-27 19:37:06.646552	2850
30918	43	2016-06-27 19:37:06.65279	2852
30919	43	2016-06-27 19:37:06.659063	2856
30920	43	2016-06-27 19:37:06.66529	2854
30921	40	2016-06-27 19:37:06.680763	47706
30922	40	2016-06-27 19:37:06.686426	47733
30923	40	2016-06-27 19:37:06.692125	47730
30924	40	2016-06-27 19:37:06.697862	47709
30925	40	2016-06-27 19:37:06.703915	47727
30926	49	2016-06-27 19:37:06.710638	47706
30927	49	2016-06-27 19:37:06.716473	47727
30928	49	2016-06-27 19:37:06.722843	47709
30929	49	2016-06-27 19:37:06.729124	47730
30930	49	2016-06-27 19:37:06.734922	47733
30931	48	2016-06-27 19:37:06.742085	2851
30932	48	2016-06-27 19:37:06.748975	2834
30933	48	2016-06-27 19:37:06.755748	2847
30934	48	2016-06-27 19:37:06.761952	2859
30935	48	2016-06-27 19:37:06.767809	2863
30936	48	2016-06-27 19:37:06.775358	2843
30937	48	2016-06-27 19:37:06.781869	2845
30938	48	2016-06-27 19:37:06.788524	2855
30939	48	2016-06-27 19:37:06.794637	2861
30940	48	2016-06-27 19:37:06.801312	2849
30941	48	2016-06-27 19:37:06.808238	2853
30942	50	2016-06-27 19:37:06.815529	47706
30943	50	2016-06-27 19:37:06.822729	47727
30944	50	2016-06-27 19:37:06.829691	47709
30945	50	2016-06-27 19:37:06.836639	47730
30946	50	2016-06-27 19:37:06.843505	47733
30947	47	2016-06-27 19:37:06.851615	2851
30948	47	2016-06-27 19:37:06.859162	2834
30949	47	2016-06-27 19:37:06.866785	2847
30950	47	2016-06-27 19:37:06.873716	2859
30951	47	2016-06-27 19:37:06.880105	2863
30952	47	2016-06-27 19:37:06.886177	2843
30953	47	2016-06-27 19:37:06.893212	2845
30954	47	2016-06-27 19:37:06.900618	2855
30955	47	2016-06-27 19:37:06.907216	2861
30956	47	2016-06-27 19:37:06.914295	2849
30957	47	2016-06-27 19:37:06.921584	2853
30958	41	2016-06-27 19:38:32.048168	2857
30959	41	2016-06-27 19:38:32.055706	2858
30960	41	2016-06-27 19:38:32.062517	2865
30961	41	2016-06-27 19:38:32.069443	2866
30962	42	2016-06-27 19:38:32.076806	2853
30963	42	2016-06-27 19:38:32.083138	2849
30964	42	2016-06-27 19:38:32.089934	2834
30965	42	2016-06-27 19:38:32.096564	2855
30966	42	2016-06-27 19:38:32.102682	2851
30967	42	2016-06-27 19:38:32.109247	2847
30968	43	2016-06-27 19:38:32.115804	2848
30969	43	2016-06-27 19:38:32.121845	2835
30970	43	2016-06-27 19:38:32.128213	2850
30971	43	2016-06-27 19:38:32.134339	2852
30972	43	2016-06-27 19:38:32.140406	2856
30973	43	2016-06-27 19:38:32.146449	2854
30974	40	2016-06-27 19:38:32.153751	47706
30975	40	2016-06-27 19:38:32.159706	47733
30976	40	2016-06-27 19:38:32.165362	47730
30977	40	2016-06-27 19:38:32.171309	47709
30978	40	2016-06-27 19:38:32.176916	47727
30979	49	2016-06-27 19:38:32.184211	47706
30980	49	2016-06-27 19:38:32.191718	47727
30981	49	2016-06-27 19:38:32.197763	47709
30982	49	2016-06-27 19:38:32.204027	47730
30983	49	2016-06-27 19:38:32.210056	47733
30984	48	2016-06-27 19:38:32.217835	2851
30985	48	2016-06-27 19:38:32.225602	2834
30986	48	2016-06-27 19:38:32.232737	2847
30987	48	2016-06-27 19:38:32.239463	2859
30988	48	2016-06-27 19:38:32.245484	2863
30989	48	2016-06-27 19:38:32.251999	2843
30990	48	2016-06-27 19:38:32.258932	2845
30991	48	2016-06-27 19:38:32.266286	2855
30992	48	2016-06-27 19:38:32.272672	2861
30993	48	2016-06-27 19:38:32.279645	2849
30994	48	2016-06-27 19:38:32.28628	2853
30995	50	2016-06-27 19:38:32.293268	47706
30996	50	2016-06-27 19:38:32.299994	47727
30997	50	2016-06-27 19:38:32.30703	47709
30998	50	2016-06-27 19:38:32.313317	47730
30999	50	2016-06-27 19:38:32.319389	47733
31000	47	2016-06-27 19:38:32.326762	2851
31001	47	2016-06-27 19:38:32.333378	2834
31002	47	2016-06-27 19:38:32.34054	2847
31003	47	2016-06-27 19:38:32.346593	2859
31004	47	2016-06-27 19:38:32.352785	2863
31005	47	2016-06-27 19:38:32.359191	2843
31006	47	2016-06-27 19:38:32.368142	2845
31007	47	2016-06-27 19:38:32.377336	2855
31008	47	2016-06-27 19:38:32.38372	2861
31009	47	2016-06-27 19:38:32.390392	2849
31010	47	2016-06-27 19:38:32.396965	2853
31011	41	2016-06-27 19:49:58.783962	2857
31012	41	2016-06-27 19:49:58.791018	2858
31013	41	2016-06-27 19:49:58.797895	2865
31014	41	2016-06-27 19:49:58.804853	2866
31015	42	2016-06-27 19:49:58.812168	2853
31016	42	2016-06-27 19:49:58.818742	2849
31017	42	2016-06-27 19:49:58.824798	2834
31018	42	2016-06-27 19:49:58.831744	2855
31019	42	2016-06-27 19:49:58.838965	2851
31020	42	2016-06-27 19:49:58.845546	2847
31021	43	2016-06-27 19:49:58.852245	2848
31022	43	2016-06-27 19:49:58.858392	2835
31023	43	2016-06-27 19:49:58.864689	2850
31024	43	2016-06-27 19:49:58.871191	2852
31025	43	2016-06-27 19:49:58.877225	2856
31026	43	2016-06-27 19:49:58.883186	2854
31027	40	2016-06-27 19:49:58.890852	47706
31028	40	2016-06-27 19:49:58.896416	47733
31029	40	2016-06-27 19:49:58.902174	47730
31030	40	2016-06-27 19:49:58.907713	47709
31031	40	2016-06-27 19:49:58.913147	47727
31032	49	2016-06-27 19:49:58.920274	47706
31033	49	2016-06-27 19:49:58.926532	47727
31034	49	2016-06-27 19:49:58.932383	47709
31035	49	2016-06-27 19:49:58.938808	47730
31036	49	2016-06-27 19:49:58.944738	47733
31037	48	2016-06-27 19:49:58.952054	2851
31038	48	2016-06-27 19:49:58.959218	2834
31039	48	2016-06-27 19:49:58.965952	2847
31040	48	2016-06-27 19:49:58.972253	2859
31041	48	2016-06-27 19:49:58.978193	2863
31042	48	2016-06-27 19:49:58.984677	2843
31043	48	2016-06-27 19:49:58.991009	2845
31044	48	2016-06-27 19:49:58.997619	2855
31045	48	2016-06-27 19:49:59.003932	2861
31046	48	2016-06-27 19:49:59.01044	2849
31047	48	2016-06-27 19:49:59.017571	2853
31048	50	2016-06-27 19:49:59.024838	47706
31049	50	2016-06-27 19:49:59.030785	47727
31050	50	2016-06-27 19:49:59.037421	47709
31051	50	2016-06-27 19:49:59.044204	47730
31052	50	2016-06-27 19:49:59.050181	47733
31053	47	2016-06-27 19:49:59.057421	2851
31054	47	2016-06-27 19:49:59.065077	2834
31055	47	2016-06-27 19:49:59.072209	2847
31056	47	2016-06-27 19:49:59.07844	2859
31057	47	2016-06-27 19:49:59.0845	2863
31058	47	2016-06-27 19:49:59.091375	2843
31059	47	2016-06-27 19:49:59.09769	2845
31060	47	2016-06-27 19:49:59.104656	2855
31061	47	2016-06-27 19:49:59.110774	2861
31062	47	2016-06-27 19:49:59.117717	2849
31063	47	2016-06-27 19:49:59.124487	2853
31064	41	2016-06-27 19:55:29.04144	2857
31065	41	2016-06-27 19:55:29.048885	2858
31066	41	2016-06-27 19:55:29.056606	2865
31067	41	2016-06-27 19:55:29.063525	2866
31068	42	2016-06-27 19:55:29.071238	2853
31069	42	2016-06-27 19:55:29.07823	2849
31070	42	2016-06-27 19:55:29.084491	2834
31071	42	2016-06-27 19:55:29.091043	2855
31072	42	2016-06-27 19:55:29.09982	2851
31073	42	2016-06-27 19:55:29.106453	2847
31074	43	2016-06-27 19:55:29.112923	2848
31075	43	2016-06-27 19:55:29.119677	2835
31076	43	2016-06-27 19:55:29.126078	2850
31077	43	2016-06-27 19:55:29.132441	2852
31078	43	2016-06-27 19:55:29.13936	2856
31079	43	2016-06-27 19:55:29.145609	2854
31080	40	2016-06-27 19:55:29.153489	47706
31081	40	2016-06-27 19:55:29.159529	47733
31082	40	2016-06-27 19:55:29.165513	47730
31083	40	2016-06-27 19:55:29.171804	47709
31084	40	2016-06-27 19:55:29.178026	47727
31085	49	2016-06-27 19:55:29.185623	47706
31086	49	2016-06-27 19:55:29.192098	47727
31087	49	2016-06-27 19:55:29.198658	47709
31088	49	2016-06-27 19:55:29.205798	47730
31089	49	2016-06-27 19:55:29.21192	47733
31090	48	2016-06-27 19:55:29.219753	2851
31091	48	2016-06-27 19:55:29.226623	2834
31092	48	2016-06-27 19:55:29.235319	2847
31093	48	2016-06-27 19:55:29.242278	2859
31094	48	2016-06-27 19:55:29.249579	2863
31095	48	2016-06-27 19:55:29.255943	2843
31096	48	2016-06-27 19:55:29.26223	2845
31097	48	2016-06-27 19:55:29.269415	2855
31098	48	2016-06-27 19:55:29.275681	2861
31099	48	2016-06-27 19:55:29.282368	2849
31100	48	2016-06-27 19:55:29.289185	2853
31101	50	2016-06-27 19:55:29.296575	47706
31102	50	2016-06-27 19:55:29.30298	47727
31103	50	2016-06-27 19:55:29.309286	47709
31104	50	2016-06-27 19:55:29.315376	47730
31105	50	2016-06-27 19:55:29.321434	47733
31106	47	2016-06-27 19:55:29.328876	2851
31107	47	2016-06-27 19:55:29.335598	2834
31108	47	2016-06-27 19:55:29.3425	2847
31109	47	2016-06-27 19:55:29.348497	2859
31110	47	2016-06-27 19:55:29.354921	2863
31111	47	2016-06-27 19:55:29.361179	2843
31112	47	2016-06-27 19:55:29.367487	2845
31113	47	2016-06-27 19:55:29.373973	2855
31114	47	2016-06-27 19:55:29.379757	2861
31115	47	2016-06-27 19:55:29.386695	2849
31116	47	2016-06-27 19:55:29.420941	2853
31117	41	2016-06-27 19:57:20.79223	2857
31118	41	2016-06-27 19:57:20.808113	2858
31119	41	2016-06-27 19:57:20.82546	2865
31120	41	2016-06-27 19:57:20.841058	2866
31121	42	2016-06-27 19:57:20.850916	2853
31122	42	2016-06-27 19:57:20.860348	2849
31123	42	2016-06-27 19:57:20.871525	2834
31124	42	2016-06-27 19:57:20.878286	2855
31125	42	2016-06-27 19:57:20.902479	2851
31126	42	2016-06-27 19:57:20.915767	2847
31127	43	2016-06-27 19:57:20.923322	2848
31128	43	2016-06-27 19:57:20.93597	2835
31129	43	2016-06-27 19:57:20.955255	2850
31130	43	2016-06-27 19:57:20.977427	2852
31131	43	2016-06-27 19:57:20.993814	2856
31132	43	2016-06-27 19:57:21.014613	2854
31133	40	2016-06-27 19:57:21.022071	47706
31134	40	2016-06-27 19:57:21.035442	47733
31135	40	2016-06-27 19:57:21.048108	47730
31136	40	2016-06-27 19:57:21.064132	47709
31137	40	2016-06-27 19:57:21.08612	47727
31138	49	2016-06-27 19:57:21.098944	47706
31139	49	2016-06-27 19:57:21.1059	47727
31140	49	2016-06-27 19:57:21.118979	47709
31141	49	2016-06-27 19:57:21.126594	47730
31142	49	2016-06-27 19:57:21.147704	47733
31143	48	2016-06-27 19:57:21.166973	2851
31144	48	2016-06-27 19:57:21.176991	2834
31145	48	2016-06-27 19:57:21.195712	2847
31146	48	2016-06-27 19:57:21.202016	2859
31147	48	2016-06-27 19:57:21.214859	2863
31148	48	2016-06-27 19:57:21.221583	2843
31149	48	2016-06-27 19:57:21.233331	2845
31150	48	2016-06-27 19:57:21.244414	2855
31151	48	2016-06-27 19:57:21.250671	2861
31152	48	2016-06-27 19:57:21.263676	2849
31153	48	2016-06-27 19:57:21.273166	2853
31154	50	2016-06-27 19:57:21.280287	47706
31155	50	2016-06-27 19:57:21.28712	47727
31156	50	2016-06-27 19:57:21.293973	47709
31157	50	2016-06-27 19:57:21.300276	47730
31158	50	2016-06-27 19:57:21.306602	47733
31159	47	2016-06-27 19:57:21.313993	2851
31160	47	2016-06-27 19:57:21.320603	2834
31161	47	2016-06-27 19:57:21.329037	2847
31162	47	2016-06-27 19:57:21.336105	2859
31163	47	2016-06-27 19:57:21.342569	2863
31164	47	2016-06-27 19:57:21.348779	2843
31165	47	2016-06-27 19:57:21.35504	2845
31166	47	2016-06-27 19:57:21.362036	2855
31167	47	2016-06-27 19:57:21.368124	2861
31168	47	2016-06-27 19:57:21.37654	2849
31169	47	2016-06-27 19:57:21.383334	2853
31170	41	2016-06-27 20:07:56.608913	2857
31171	41	2016-06-27 20:07:56.646136	2858
31172	41	2016-06-27 20:07:56.654931	2865
31173	41	2016-06-27 20:07:56.664237	2866
31174	42	2016-06-27 20:07:56.672713	2853
31175	42	2016-06-27 20:07:56.680254	2849
31176	42	2016-06-27 20:07:56.687914	2834
31177	42	2016-06-27 20:07:56.69613	2855
31178	42	2016-06-27 20:07:56.704273	2851
31179	42	2016-06-27 20:07:56.712436	2847
31180	43	2016-06-27 20:07:56.720047	2848
31181	43	2016-06-27 20:07:56.727131	2835
31182	43	2016-06-27 20:07:56.735006	2850
31183	43	2016-06-27 20:07:56.757871	2852
31184	43	2016-06-27 20:07:56.781889	2856
31185	43	2016-06-27 20:07:56.861325	2854
31186	40	2016-06-27 20:07:56.950075	47706
31187	40	2016-06-27 20:07:56.982223	47733
31188	40	2016-06-27 20:07:57.008913	47730
31189	40	2016-06-27 20:07:57.073249	47709
31190	40	2016-06-27 20:07:57.079983	47727
31191	49	2016-06-27 20:07:57.088244	47706
31192	49	2016-06-27 20:07:57.110124	47727
31193	49	2016-06-27 20:07:57.117152	47709
31194	49	2016-06-27 20:07:57.124206	47730
31195	49	2016-06-27 20:07:57.131173	47733
31196	48	2016-06-27 20:07:57.140304	2851
31197	48	2016-06-27 20:07:57.148132	2834
31198	48	2016-06-27 20:07:57.156003	2847
31199	48	2016-06-27 20:07:57.162766	2859
31200	48	2016-06-27 20:07:57.170066	2863
31201	48	2016-06-27 20:07:57.177126	2843
31202	48	2016-06-27 20:07:57.184038	2845
31203	48	2016-06-27 20:07:57.192296	2855
31204	48	2016-06-27 20:07:57.199187	2861
31205	48	2016-06-27 20:07:57.206908	2849
31206	48	2016-06-27 20:07:57.215191	2853
31207	50	2016-06-27 20:07:57.225209	47706
31208	50	2016-06-27 20:07:57.232813	47727
31209	50	2016-06-27 20:07:57.240196	47709
31210	50	2016-06-27 20:07:57.247941	47730
31211	50	2016-06-27 20:07:57.255325	47733
31212	47	2016-06-27 20:07:57.265088	2851
31213	47	2016-06-27 20:07:57.274844	2834
31214	47	2016-06-27 20:07:57.284717	2847
31215	47	2016-06-27 20:07:57.291896	2859
31216	47	2016-06-27 20:07:57.299037	2863
31217	47	2016-06-27 20:07:57.30603	2843
31218	47	2016-06-27 20:07:57.313477	2845
31219	47	2016-06-27 20:07:57.321608	2855
31220	47	2016-06-27 20:07:57.328866	2861
31221	47	2016-06-27 20:07:57.336388	2849
31222	47	2016-06-27 20:07:57.344385	2853
31223	41	2016-06-27 20:09:00.7342	2858
31224	41	2016-06-27 20:09:00.742479	2865
31225	41	2016-06-27 20:09:00.749765	2866
31226	42	2016-06-27 20:09:00.757343	2853
31227	42	2016-06-27 20:09:00.764096	2849
31228	42	2016-06-27 20:09:00.770787	2834
31229	42	2016-06-27 20:09:00.777454	2855
31230	42	2016-06-27 20:09:00.783936	2851
31231	42	2016-06-27 20:09:00.790405	2847
31232	43	2016-06-27 20:09:00.797229	2848
31233	43	2016-06-27 20:09:00.803142	2835
31234	43	2016-06-27 20:09:00.809794	2850
31235	43	2016-06-27 20:09:00.816128	2852
31236	43	2016-06-27 20:09:00.8227	2856
31237	43	2016-06-27 20:09:00.829331	2854
31238	40	2016-06-27 20:09:00.837143	47733
31239	40	2016-06-27 20:09:00.843106	47730
31240	40	2016-06-27 20:09:00.849404	47706
31241	40	2016-06-27 20:09:00.855197	47709
31242	40	2016-06-27 20:09:00.86154	47727
31243	49	2016-06-27 20:09:00.869331	47706
31244	49	2016-06-27 20:09:00.876053	47727
31245	49	2016-06-27 20:09:00.884032	47709
31246	49	2016-06-27 20:09:00.89118	47730
31247	49	2016-06-27 20:09:00.899233	47733
31248	48	2016-06-27 20:09:00.906809	2851
31249	48	2016-06-27 20:09:00.914574	2834
31250	48	2016-06-27 20:09:00.921516	2847
31251	48	2016-06-27 20:09:00.928638	2859
31252	48	2016-06-27 20:09:00.934747	2863
31253	48	2016-06-27 20:09:00.941301	2843
31254	48	2016-06-27 20:09:00.948024	2845
31255	48	2016-06-27 20:09:00.954876	2855
31256	48	2016-06-27 20:09:00.961667	2861
31257	48	2016-06-27 20:09:00.968631	2849
31258	48	2016-06-27 20:09:00.975533	2853
31259	50	2016-06-27 20:09:00.983091	47706
31260	50	2016-06-27 20:09:00.989518	47727
31261	50	2016-06-27 20:09:00.996892	47709
31262	50	2016-06-27 20:09:01.003866	47730
31263	50	2016-06-27 20:09:01.010305	47733
31264	47	2016-06-27 20:09:01.018402	2851
31265	47	2016-06-27 20:09:01.025073	2834
31266	47	2016-06-27 20:09:01.032347	2847
31267	47	2016-06-27 20:09:01.038406	2859
31268	47	2016-06-27 20:09:01.044658	2863
31269	47	2016-06-27 20:09:01.051332	2843
31270	47	2016-06-27 20:09:01.057396	2845
31271	47	2016-06-27 20:09:01.064629	2855
31272	47	2016-06-27 20:09:01.070966	2861
31273	47	2016-06-27 20:09:01.077929	2849
31274	47	2016-06-27 20:09:01.084882	2853
31275	44	2016-06-27 20:09:44.226777	2869
31276	41	2016-06-27 20:10:01.203424	2858
31277	41	2016-06-27 20:10:01.211085	2865
31278	41	2016-06-27 20:10:01.218387	2866
31279	42	2016-06-27 20:10:01.232204	2853
31280	42	2016-06-27 20:10:01.238345	2849
31281	42	2016-06-27 20:10:01.245114	2834
31282	42	2016-06-27 20:10:01.251881	2855
31283	42	2016-06-27 20:10:01.258171	2851
31284	42	2016-06-27 20:10:01.264832	2847
31285	43	2016-06-27 20:10:01.271697	2848
31286	43	2016-06-27 20:10:01.277786	2835
31287	43	2016-06-27 20:10:01.284076	2850
31288	43	2016-06-27 20:10:01.290434	2852
31289	43	2016-06-27 20:10:01.2968	2856
31290	43	2016-06-27 20:10:01.30282	2854
31291	40	2016-06-27 20:10:01.309958	47733
31292	40	2016-06-27 20:10:01.315771	47730
31293	40	2016-06-27 20:10:01.32196	47706
31294	40	2016-06-27 20:10:01.327812	47709
31295	40	2016-06-27 20:10:01.333799	47727
31296	49	2016-06-27 20:10:01.341517	47706
31297	49	2016-06-27 20:10:01.348213	47727
31298	49	2016-06-27 20:10:01.354152	47709
31299	49	2016-06-27 20:10:01.360254	47730
31300	49	2016-06-27 20:10:01.36677	47733
31301	48	2016-06-27 20:10:01.374385	2851
31302	48	2016-06-27 20:10:01.382952	2834
31303	48	2016-06-27 20:10:01.390414	2847
31304	48	2016-06-27 20:10:01.396794	2859
31305	48	2016-06-27 20:10:01.403445	2863
31306	48	2016-06-27 20:10:01.409782	2843
31307	48	2016-06-27 20:10:01.416912	2845
31308	48	2016-06-27 20:10:01.424339	2855
31309	48	2016-06-27 20:10:01.430628	2861
31310	48	2016-06-27 20:10:01.437822	2849
31311	48	2016-06-27 20:10:01.444756	2853
31312	50	2016-06-27 20:10:01.452873	47706
31313	50	2016-06-27 20:10:01.459626	47727
31314	50	2016-06-27 20:10:01.466438	47709
31315	50	2016-06-27 20:10:01.473843	47730
31316	50	2016-06-27 20:10:01.481079	47733
31317	47	2016-06-27 20:10:01.488777	2851
31318	47	2016-06-27 20:10:01.495742	2834
31319	47	2016-06-27 20:10:01.503114	2847
31320	47	2016-06-27 20:10:01.509404	2859
31321	47	2016-06-27 20:10:01.515712	2863
31322	47	2016-06-27 20:10:01.522306	2843
31323	47	2016-06-27 20:10:01.528687	2845
31324	47	2016-06-27 20:10:01.535469	2855
31325	47	2016-06-27 20:10:01.542154	2861
31326	47	2016-06-27 20:10:01.549324	2849
31327	47	2016-06-27 20:10:01.55665	2853
31328	41	2016-06-27 20:11:56.303035	2858
31329	41	2016-06-27 20:11:56.314227	2865
31330	41	2016-06-27 20:11:56.322118	2866
31331	44	2016-06-27 20:11:56.332094	2869
31332	42	2016-06-27 20:11:56.339283	2853
31333	42	2016-06-27 20:11:56.347005	2849
31334	42	2016-06-27 20:11:56.353618	2834
31335	42	2016-06-27 20:11:56.361364	2855
31336	42	2016-06-27 20:11:56.368064	2851
31337	42	2016-06-27 20:11:56.375846	2847
31338	43	2016-06-27 20:11:56.382917	2848
31339	43	2016-06-27 20:11:56.389279	2835
31340	43	2016-06-27 20:11:56.396847	2850
31341	43	2016-06-27 20:11:56.403457	2852
31342	43	2016-06-27 20:11:56.41133	2856
31343	43	2016-06-27 20:11:56.417998	2854
31344	40	2016-06-27 20:11:56.426961	47733
31345	40	2016-06-27 20:11:56.433204	47730
31346	40	2016-06-27 20:11:56.439183	47706
31347	40	2016-06-27 20:11:56.446428	47709
31348	40	2016-06-27 20:11:56.452406	47727
31349	49	2016-06-27 20:11:56.461053	47706
31350	49	2016-06-27 20:11:56.467507	47727
31351	49	2016-06-27 20:11:56.474267	47709
31352	49	2016-06-27 20:11:56.481484	47730
31353	49	2016-06-27 20:11:56.487901	47733
31354	48	2016-06-27 20:11:56.497376	2851
31355	48	2016-06-27 20:11:56.505112	2834
31356	48	2016-06-27 20:11:56.516024	2847
31357	48	2016-06-27 20:11:56.522723	2859
31358	48	2016-06-27 20:11:56.529767	2863
31359	48	2016-06-27 20:11:56.536132	2843
31360	48	2016-06-27 20:11:56.54376	2845
31361	48	2016-06-27 20:11:56.55082	2855
31362	48	2016-06-27 20:11:56.557118	2861
31363	48	2016-06-27 20:11:56.565181	2849
31364	48	2016-06-27 20:11:56.572413	2853
31365	50	2016-06-27 20:11:56.581233	47706
31366	50	2016-06-27 20:11:56.587698	47727
31367	50	2016-06-27 20:11:56.595806	47709
31368	50	2016-06-27 20:11:56.602311	47730
31369	50	2016-06-27 20:11:56.610444	47733
31370	47	2016-06-27 20:11:56.617859	2851
31371	47	2016-06-27 20:11:56.625673	2834
31372	47	2016-06-27 20:11:56.633147	2847
31373	47	2016-06-27 20:11:56.639663	2859
31374	47	2016-06-27 20:11:56.647249	2863
31375	47	2016-06-27 20:11:56.653533	2843
31376	47	2016-06-27 20:11:56.661461	2845
31377	47	2016-06-27 20:11:56.668975	2855
31378	47	2016-06-27 20:11:56.675539	2861
31379	47	2016-06-27 20:11:56.682512	2849
31380	47	2016-06-27 20:11:56.689299	2853
31381	41	2016-06-27 20:27:22.41965	2858
31382	41	2016-06-27 20:27:22.427119	2865
31383	41	2016-06-27 20:27:22.434669	2866
31384	44	2016-06-27 20:27:22.443042	2869
31385	42	2016-06-27 20:27:22.450903	2853
31386	42	2016-06-27 20:27:22.457829	2849
31387	42	2016-06-27 20:27:22.464278	2834
31388	42	2016-06-27 20:27:22.470541	2855
31389	42	2016-06-27 20:27:22.476791	2851
31390	42	2016-06-27 20:27:22.483156	2847
31391	43	2016-06-27 20:27:22.489826	2848
31392	43	2016-06-27 20:27:22.496063	2835
31393	43	2016-06-27 20:27:22.502266	2850
31394	43	2016-06-27 20:27:22.508728	2852
31395	43	2016-06-27 20:27:22.515072	2856
31396	43	2016-06-27 20:27:22.521344	2854
31397	40	2016-06-27 20:27:22.528982	47733
31398	40	2016-06-27 20:27:22.534643	47730
31399	40	2016-06-27 20:27:22.540499	47706
31400	40	2016-06-27 20:27:22.545974	47709
31401	40	2016-06-27 20:27:22.55229	47727
31402	49	2016-06-27 20:27:22.559556	47706
31403	49	2016-06-27 20:27:22.565696	47727
31404	49	2016-06-27 20:27:22.571753	47709
31405	49	2016-06-27 20:27:22.579522	47730
31406	49	2016-06-27 20:27:22.586081	47733
31407	48	2016-06-27 20:27:22.593278	2851
31408	48	2016-06-27 20:27:22.600199	2834
31409	48	2016-06-27 20:27:22.608746	2847
31410	48	2016-06-27 20:27:22.614893	2859
31411	48	2016-06-27 20:27:22.620952	2863
31412	48	2016-06-27 20:27:22.627116	2843
31413	48	2016-06-27 20:27:22.633558	2845
31414	48	2016-06-27 20:27:22.641718	2855
31415	48	2016-06-27 20:27:22.648062	2861
31416	48	2016-06-27 20:27:22.655136	2849
31417	48	2016-06-27 20:27:22.661751	2853
31418	50	2016-06-27 20:27:22.669619	47706
31419	50	2016-06-27 20:27:22.676341	47727
31420	50	2016-06-27 20:27:22.682687	47709
31421	50	2016-06-27 20:27:22.689129	47730
31422	50	2016-06-27 20:27:22.695454	47733
31423	47	2016-06-27 20:27:22.703073	2851
31424	47	2016-06-27 20:27:22.709773	2834
31425	47	2016-06-27 20:27:22.716399	2847
31426	47	2016-06-27 20:27:22.722609	2859
31427	47	2016-06-27 20:27:22.728679	2863
31428	47	2016-06-27 20:27:22.735083	2843
31429	47	2016-06-27 20:27:22.741177	2845
31430	47	2016-06-27 20:27:22.747774	2855
31431	47	2016-06-27 20:27:22.753995	2861
31432	47	2016-06-27 20:27:22.760757	2849
31433	47	2016-06-27 20:27:22.767228	2853
31434	41	2016-06-27 20:28:37.177491	2858
31435	41	2016-06-27 20:28:37.185527	2865
31436	41	2016-06-27 20:28:37.193109	2866
31437	44	2016-06-27 20:28:37.202346	2869
31438	42	2016-06-27 20:28:37.212079	2853
31439	42	2016-06-27 20:28:37.22092	2849
31440	42	2016-06-27 20:28:37.229591	2834
31441	42	2016-06-27 20:28:37.236687	2855
31442	42	2016-06-27 20:28:37.243834	2851
31443	42	2016-06-27 20:28:37.250901	2847
31444	43	2016-06-27 20:28:37.257658	2848
31445	43	2016-06-27 20:28:37.265674	2835
31446	43	2016-06-27 20:28:37.272453	2850
31447	43	2016-06-27 20:28:37.280483	2852
31448	43	2016-06-27 20:28:37.287473	2856
31449	43	2016-06-27 20:28:37.295007	2854
31450	40	2016-06-27 20:28:37.303096	47733
31451	40	2016-06-27 20:28:37.310858	47730
31452	40	2016-06-27 20:28:37.319817	47706
31453	40	2016-06-27 20:28:37.326937	47709
31454	40	2016-06-27 20:28:37.334427	47727
31455	49	2016-06-27 20:28:37.343248	47706
31456	49	2016-06-27 20:28:37.351781	47727
31457	49	2016-06-27 20:28:37.359227	47709
31458	49	2016-06-27 20:28:37.367116	47730
31459	49	2016-06-27 20:28:37.374413	47733
31460	48	2016-06-27 20:28:37.385747	2851
31461	48	2016-06-27 20:28:37.393742	2834
31462	48	2016-06-27 20:28:37.402757	2847
31463	48	2016-06-27 20:28:37.410255	2859
31464	48	2016-06-27 20:28:37.417765	2863
31465	48	2016-06-27 20:28:37.425639	2843
31466	48	2016-06-27 20:28:37.432686	2845
31467	48	2016-06-27 20:28:37.439677	2855
31468	48	2016-06-27 20:28:37.446502	2861
31469	48	2016-06-27 20:28:37.454121	2849
31470	48	2016-06-27 20:28:37.461741	2853
31471	50	2016-06-27 20:28:37.469284	47706
31472	50	2016-06-27 20:28:37.47621	47727
31473	50	2016-06-27 20:28:37.484527	47709
31474	50	2016-06-27 20:28:37.491178	47730
31475	50	2016-06-27 20:28:37.498663	47733
31476	47	2016-06-27 20:28:37.506558	2851
31477	47	2016-06-27 20:28:37.515885	2834
31478	47	2016-06-27 20:28:37.523846	2847
31479	47	2016-06-27 20:28:37.531221	2859
31480	47	2016-06-27 20:28:37.537907	2863
31481	47	2016-06-27 20:28:37.544433	2843
31482	47	2016-06-27 20:28:37.551571	2845
31483	47	2016-06-27 20:28:37.558701	2855
31484	47	2016-06-27 20:28:37.565411	2861
31485	47	2016-06-27 20:28:37.572952	2849
31486	47	2016-06-27 20:28:37.580157	2853
31487	40	2016-06-27 20:29:22.279873	47721
31488	41	2016-06-27 20:29:38.580691	2858
31489	41	2016-06-27 20:29:38.688136	2865
31490	41	2016-06-27 20:29:38.747113	2866
31491	44	2016-06-27 20:29:38.755118	2869
31492	42	2016-06-27 20:29:38.761963	2849
31493	42	2016-06-27 20:29:38.768228	2834
31494	42	2016-06-27 20:29:38.775231	2855
31495	42	2016-06-27 20:29:38.781804	2851
31496	42	2016-06-27 20:29:38.788149	2847
31497	43	2016-06-27 20:29:38.794763	2848
31498	43	2016-06-27 20:29:38.801123	2835
31499	43	2016-06-27 20:29:38.80744	2850
31500	43	2016-06-27 20:29:38.814022	2852
31501	43	2016-06-27 20:29:38.820354	2856
31502	40	2016-06-27 20:29:38.828305	47733
31503	40	2016-06-27 20:29:38.834439	47730
31504	40	2016-06-27 20:29:38.840683	47706
31505	40	2016-06-27 20:29:38.846975	47709
31506	40	2016-06-27 20:29:38.853475	47727
31507	49	2016-06-27 20:29:38.867313	47706
31508	49	2016-06-27 20:29:38.874012	47727
31509	49	2016-06-27 20:29:38.880817	47709
31510	49	2016-06-27 20:29:38.887526	47730
31511	49	2016-06-27 20:29:38.894015	47733
31512	48	2016-06-27 20:29:38.902344	2851
31513	48	2016-06-27 20:29:38.909721	2834
31514	48	2016-06-27 20:29:38.917437	2847
31515	48	2016-06-27 20:29:38.923728	2859
31516	48	2016-06-27 20:29:38.930122	2863
31517	48	2016-06-27 20:29:38.936665	2843
31518	48	2016-06-27 20:29:38.942951	2845
31519	48	2016-06-27 20:29:38.950454	2855
31520	48	2016-06-27 20:29:38.95725	2861
31521	48	2016-06-27 20:29:38.964634	2849
31522	48	2016-06-27 20:29:38.971949	2853
31523	50	2016-06-27 20:29:38.979457	47706
31524	50	2016-06-27 20:29:38.986299	47727
31525	50	2016-06-27 20:29:38.993238	47709
31526	50	2016-06-27 20:29:39.000093	47730
31527	50	2016-06-27 20:29:39.007284	47733
31528	47	2016-06-27 20:29:39.015107	2851
31529	47	2016-06-27 20:29:39.022773	2834
31530	47	2016-06-27 20:29:39.030317	2847
31531	47	2016-06-27 20:29:39.038328	2859
31532	47	2016-06-27 20:29:39.045057	2863
31533	47	2016-06-27 20:29:39.051638	2843
31534	47	2016-06-27 20:29:39.059408	2845
31535	47	2016-06-27 20:29:39.066514	2855
31536	47	2016-06-27 20:29:39.073273	2861
31537	47	2016-06-27 20:29:39.080151	2849
31538	47	2016-06-27 20:29:39.086242	2853
31539	40	2016-06-27 20:30:22.696973	47721
31540	49	2016-06-27 20:30:22.728902	47721
31541	41	2016-06-27 20:30:58.001845	2858
31542	41	2016-06-27 20:30:58.010294	2865
31543	41	2016-06-27 20:30:58.017575	2866
31544	44	2016-06-27 20:30:58.02619	2869
31545	42	2016-06-27 20:30:58.032895	2849
31546	42	2016-06-27 20:30:58.039013	2834
31547	42	2016-06-27 20:30:58.045935	2855
31548	42	2016-06-27 20:30:58.052772	2851
31549	42	2016-06-27 20:30:58.059655	2847
31550	43	2016-06-27 20:30:58.066642	2848
31551	43	2016-06-27 20:30:58.073219	2835
31552	43	2016-06-27 20:30:58.079714	2850
31553	43	2016-06-27 20:30:58.087621	2852
31554	43	2016-06-27 20:30:58.094582	2856
31555	40	2016-06-27 20:30:58.101806	47733
31556	40	2016-06-27 20:30:58.108664	47730
31557	40	2016-06-27 20:30:58.114681	47706
31558	40	2016-06-27 20:30:58.120561	47709
31559	40	2016-06-27 20:30:58.127003	47727
31560	49	2016-06-27 20:30:58.140955	47706
31561	49	2016-06-27 20:30:58.148491	47727
31562	49	2016-06-27 20:30:58.155048	47730
31563	49	2016-06-27 20:30:58.167621	47733
31564	49	2016-06-27 20:30:58.174023	47709
31565	48	2016-06-27 20:30:58.18194	2851
31566	48	2016-06-27 20:30:58.189232	2834
31567	48	2016-06-27 20:30:58.196353	2847
31568	48	2016-06-27 20:30:58.20296	2859
31569	48	2016-06-27 20:30:58.209074	2863
31570	48	2016-06-27 20:30:58.216652	2843
31571	48	2016-06-27 20:30:58.223278	2845
31572	48	2016-06-27 20:30:58.230986	2855
31573	48	2016-06-27 20:30:58.237652	2861
31574	48	2016-06-27 20:30:58.245644	2849
31575	48	2016-06-27 20:30:58.252057	2853
31576	50	2016-06-27 20:30:58.25971	47706
31577	50	2016-06-27 20:30:58.266738	47727
31578	50	2016-06-27 20:30:58.273525	47709
31579	50	2016-06-27 20:30:58.280753	47730
31580	50	2016-06-27 20:30:58.287464	47733
31581	47	2016-06-27 20:30:58.295645	2851
31582	47	2016-06-27 20:30:58.302676	2834
31583	47	2016-06-27 20:30:58.31026	2847
31584	47	2016-06-27 20:30:58.31669	2859
31585	47	2016-06-27 20:30:58.322961	2863
31586	47	2016-06-27 20:30:58.329383	2843
31587	47	2016-06-27 20:30:58.336236	2845
31588	47	2016-06-27 20:30:58.344525	2855
31589	47	2016-06-27 20:30:58.351719	2861
31590	47	2016-06-27 20:30:58.359236	2849
31591	47	2016-06-27 20:30:58.365693	2853
31592	40	2016-06-27 20:31:55.559036	47721
31593	49	2016-06-27 20:31:55.58717	47721
31594	50	2016-06-27 20:31:55.712261	47721
31595	41	2016-06-27 20:32:15.52844	2858
31596	41	2016-06-27 20:32:15.536808	2865
31597	41	2016-06-27 20:32:15.544182	2866
31598	44	2016-06-27 20:32:15.553405	2869
31599	42	2016-06-27 20:32:15.560183	2849
31600	42	2016-06-27 20:32:15.5666	2834
31601	42	2016-06-27 20:32:15.573399	2855
31602	42	2016-06-27 20:32:15.579864	2851
31603	42	2016-06-27 20:32:15.586516	2872
31604	42	2016-06-27 20:32:15.59294	2847
31605	43	2016-06-27 20:32:15.599661	2848
31606	43	2016-06-27 20:32:15.606648	2835
31607	43	2016-06-27 20:32:15.612918	2850
31608	43	2016-06-27 20:32:15.619586	2852
31609	43	2016-06-27 20:32:15.625933	2856
31610	43	2016-06-27 20:32:15.633195	2873
31611	40	2016-06-27 20:32:15.641422	47733
31612	40	2016-06-27 20:32:15.647749	47730
31613	40	2016-06-27 20:32:15.654315	47706
31614	40	2016-06-27 20:32:15.660987	47709
31615	40	2016-06-27 20:32:15.666967	47727
31616	49	2016-06-27 20:32:15.681819	47706
31617	49	2016-06-27 20:32:15.689796	47727
31618	49	2016-06-27 20:32:15.696251	47730
31619	49	2016-06-27 20:32:15.708822	47733
31620	49	2016-06-27 20:32:15.715181	47709
31621	48	2016-06-27 20:32:15.723178	2851
31622	48	2016-06-27 20:32:15.730201	2834
31623	48	2016-06-27 20:32:15.737273	2847
31624	48	2016-06-27 20:32:15.743631	2859
31625	48	2016-06-27 20:32:15.749985	2863
31626	48	2016-06-27 20:32:15.756712	2843
31627	48	2016-06-27 20:32:15.762949	2845
31628	48	2016-06-27 20:32:15.770119	2855
31629	48	2016-06-27 20:32:15.776279	2861
31630	48	2016-06-27 20:32:15.783562	2849
31631	48	2016-06-27 20:32:15.790592	2853
31632	50	2016-06-27 20:32:15.797912	47706
31633	50	2016-06-27 20:32:15.804539	47727
31634	50	2016-06-27 20:32:15.811336	47730
31635	50	2016-06-27 20:32:15.823697	47733
31636	50	2016-06-27 20:32:15.830174	47709
31637	47	2016-06-27 20:32:15.837949	2851
31638	47	2016-06-27 20:32:15.845069	2834
31639	47	2016-06-27 20:32:15.852311	2847
31640	47	2016-06-27 20:32:15.859518	2859
31641	47	2016-06-27 20:32:15.866768	2863
31642	47	2016-06-27 20:32:15.873799	2843
31643	47	2016-06-27 20:32:15.880686	2845
31644	47	2016-06-27 20:32:15.887739	2855
31645	47	2016-06-27 20:32:15.894202	2861
31646	47	2016-06-27 20:32:15.901748	2849
31647	47	2016-06-27 20:32:15.908361	2853
31648	41	2016-06-27 20:34:17.992519	2858
31649	41	2016-06-27 20:34:18.000184	2865
31650	41	2016-06-27 20:34:18.007673	2866
31651	44	2016-06-27 20:34:18.015791	2869
31652	42	2016-06-27 20:34:18.022769	2849
31653	42	2016-06-27 20:34:18.030609	2834
31654	42	2016-06-27 20:34:18.037354	2855
31655	42	2016-06-27 20:34:18.044144	2851
31656	42	2016-06-27 20:34:18.050806	2872
31657	42	2016-06-27 20:34:18.057241	2847
31658	43	2016-06-27 20:34:18.064506	2848
31659	43	2016-06-27 20:34:18.070956	2835
31660	43	2016-06-27 20:34:18.077879	2850
31661	43	2016-06-27 20:34:18.084452	2852
31662	43	2016-06-27 20:34:18.090786	2856
31663	43	2016-06-27 20:34:18.097348	2873
31664	40	2016-06-27 20:34:18.104916	47733
31665	40	2016-06-27 20:34:18.111174	47730
31666	40	2016-06-27 20:34:18.117043	47706
31667	40	2016-06-27 20:34:18.122771	47709
31668	40	2016-06-27 20:34:18.129266	47727
31669	40	2016-06-27 20:34:18.135798	47721
31670	49	2016-06-27 20:34:18.143723	47706
31671	49	2016-06-27 20:34:18.150165	47727
31672	49	2016-06-27 20:34:18.156616	47730
31673	49	2016-06-27 20:34:18.163381	47721
31674	49	2016-06-27 20:34:18.169889	47733
31675	49	2016-06-27 20:34:18.176872	47709
31676	48	2016-06-27 20:34:18.185296	2851
31677	48	2016-06-27 20:34:18.192961	2834
31678	48	2016-06-27 20:34:18.200785	2847
31679	48	2016-06-27 20:34:18.208138	2859
31680	48	2016-06-27 20:34:18.215066	2863
31681	48	2016-06-27 20:34:18.221728	2843
31682	48	2016-06-27 20:34:18.228405	2845
31683	48	2016-06-27 20:34:18.235796	2855
31684	48	2016-06-27 20:34:18.242565	2861
31685	48	2016-06-27 20:34:18.250192	2849
31686	48	2016-06-27 20:34:18.256525	2853
31687	50	2016-06-27 20:34:18.26417	47706
31688	50	2016-06-27 20:34:18.271041	47727
31689	50	2016-06-27 20:34:18.277958	47730
31690	50	2016-06-27 20:34:18.284894	47721
31691	50	2016-06-27 20:34:18.291648	47733
31692	50	2016-06-27 20:34:18.298889	47709
31693	47	2016-06-27 20:34:18.308153	2851
31694	47	2016-06-27 20:34:18.314712	2859
31695	47	2016-06-27 20:34:18.321071	2863
31696	47	2016-06-27 20:34:18.331491	2843
31697	47	2016-06-27 20:34:18.339952	2845
31698	47	2016-06-27 20:34:18.346969	2855
31699	47	2016-06-27 20:34:18.354438	2872
31700	47	2016-06-27 20:34:18.36069	2861
31701	47	2016-06-27 20:34:18.367859	2849
31702	47	2016-06-27 20:34:18.374132	2853
31703	47	2016-06-27 20:34:18.381001	2834
31704	47	2016-06-27 20:34:18.387937	2847
31705	41	2016-06-27 20:41:59.380024	2858
31706	41	2016-06-27 20:41:59.387787	2865
31707	41	2016-06-27 20:41:59.394844	2866
31708	44	2016-06-27 20:41:59.40258	2869
31709	42	2016-06-27 20:41:59.409237	2849
31710	42	2016-06-27 20:41:59.41547	2834
31711	42	2016-06-27 20:41:59.422332	2855
31712	42	2016-06-27 20:41:59.428756	2851
31713	42	2016-06-27 20:41:59.434962	2872
31714	42	2016-06-27 20:41:59.441107	2874
31715	42	2016-06-27 20:41:59.447332	2847
31716	43	2016-06-27 20:41:59.454354	2848
31717	43	2016-06-27 20:41:59.460687	2835
31718	43	2016-06-27 20:41:59.467058	2852
31719	43	2016-06-27 20:41:59.473142	2875
31720	43	2016-06-27 20:41:59.47972	2856
31721	43	2016-06-27 20:41:59.486537	2873
31722	43	2016-06-27 20:41:59.492815	2850
31723	40	2016-06-27 20:41:59.500563	47733
31724	40	2016-06-27 20:41:59.5067	47730
31725	40	2016-06-27 20:41:59.512641	47706
31726	40	2016-06-27 20:41:59.518505	47709
31727	40	2016-06-27 20:41:59.524378	47727
31728	40	2016-06-27 20:41:59.530313	47721
31729	49	2016-06-27 20:41:59.538341	47706
31730	49	2016-06-27 20:41:59.545177	47727
31731	49	2016-06-27 20:41:59.554677	47730
31732	49	2016-06-27 20:41:59.563148	47721
31733	49	2016-06-27 20:41:59.57002	47733
31734	49	2016-06-27 20:41:59.576513	47709
31735	48	2016-06-27 20:41:59.585721	2851
31736	48	2016-06-27 20:41:59.592011	2859
31737	48	2016-06-27 20:41:59.598186	2863
31738	48	2016-06-27 20:41:59.604767	2843
31739	48	2016-06-27 20:41:59.611526	2845
31740	48	2016-06-27 20:41:59.619085	2855
31741	48	2016-06-27 20:41:59.625742	2872
31742	48	2016-06-27 20:41:59.631995	2861
31743	48	2016-06-27 20:41:59.639132	2849
31744	48	2016-06-27 20:41:59.645405	2853
31745	48	2016-06-27 20:41:59.652725	2834
31746	48	2016-06-27 20:41:59.659898	2847
31747	50	2016-06-27 20:41:59.667593	47706
31748	50	2016-06-27 20:41:59.674194	47727
31749	50	2016-06-27 20:41:59.68096	47730
31750	50	2016-06-27 20:41:59.687906	47721
31751	50	2016-06-27 20:41:59.694241	47733
31752	50	2016-06-27 20:41:59.700903	47709
31753	47	2016-06-27 20:41:59.709105	2851
31754	47	2016-06-27 20:41:59.715578	2859
31755	47	2016-06-27 20:41:59.72233	2863
31756	47	2016-06-27 20:41:59.728918	2843
31757	47	2016-06-27 20:41:59.735498	2845
31758	47	2016-06-27 20:41:59.743938	2855
31759	47	2016-06-27 20:41:59.751079	2872
31760	47	2016-06-27 20:41:59.757715	2861
31761	47	2016-06-27 20:41:59.764807	2849
31762	47	2016-06-27 20:41:59.771219	2853
31763	47	2016-06-27 20:41:59.778643	2834
31764	47	2016-06-27 20:41:59.786362	2847
31765	41	2016-06-27 20:43:25.482464	2858
31766	41	2016-06-27 20:43:25.491239	2865
31767	41	2016-06-27 20:43:25.498783	2866
31768	44	2016-06-27 20:43:25.506717	2869
31769	42	2016-06-27 20:43:25.513411	2849
31770	42	2016-06-27 20:43:25.519561	2834
31771	42	2016-06-27 20:43:25.526152	2855
31772	42	2016-06-27 20:43:25.532901	2851
31773	42	2016-06-27 20:43:25.539094	2872
31774	42	2016-06-27 20:43:25.545772	2874
31775	42	2016-06-27 20:43:25.552098	2847
31776	43	2016-06-27 20:43:25.558654	2848
31777	43	2016-06-27 20:43:25.564873	2835
31778	43	2016-06-27 20:43:25.571062	2852
31779	43	2016-06-27 20:43:25.577693	2875
31780	43	2016-06-27 20:43:25.583908	2856
31781	43	2016-06-27 20:43:25.590157	2873
31782	43	2016-06-27 20:43:25.59617	2850
31783	40	2016-06-27 20:43:25.603297	47733
31784	40	2016-06-27 20:43:25.609376	47730
31785	40	2016-06-27 20:43:25.616105	47706
31786	40	2016-06-27 20:43:25.622204	47709
31787	40	2016-06-27 20:43:25.628663	47727
31788	40	2016-06-27 20:43:25.634829	47721
31789	49	2016-06-27 20:43:25.643135	47706
31790	49	2016-06-27 20:43:25.649688	47727
31791	49	2016-06-27 20:43:25.656569	47730
31792	49	2016-06-27 20:43:25.663206	47721
31793	49	2016-06-27 20:43:25.669558	47733
31794	49	2016-06-27 20:43:25.676573	47709
31795	48	2016-06-27 20:43:25.684264	2851
31796	48	2016-06-27 20:43:25.690649	2859
31797	48	2016-06-27 20:43:25.697803	2863
31798	48	2016-06-27 20:43:25.704291	2843
31799	48	2016-06-27 20:43:25.711181	2845
31800	48	2016-06-27 20:43:25.718119	2855
31801	48	2016-06-27 20:43:25.725623	2872
31802	48	2016-06-27 20:43:25.73177	2861
31803	48	2016-06-27 20:43:25.739218	2849
31804	48	2016-06-27 20:43:25.745648	2853
31805	48	2016-06-27 20:43:25.752762	2834
31806	48	2016-06-27 20:43:25.760577	2847
31807	50	2016-06-27 20:43:25.768355	47706
31808	50	2016-06-27 20:43:25.77598	47727
31809	50	2016-06-27 20:43:25.78445	47730
31810	50	2016-06-27 20:43:25.79357	47721
31811	50	2016-06-27 20:43:25.801641	47733
31812	50	2016-06-27 20:43:25.808285	47709
31813	47	2016-06-27 20:43:25.816256	2851
31814	47	2016-06-27 20:43:25.823016	2859
31815	47	2016-06-27 20:43:25.829639	2843
31816	47	2016-06-27 20:43:25.836076	2845
31817	47	2016-06-27 20:43:25.843153	2855
31818	47	2016-06-27 20:43:25.850368	2872
31819	47	2016-06-27 20:43:25.85682	2861
31820	47	2016-06-27 20:43:25.88408	2849
31821	47	2016-06-27 20:43:25.890586	2853
31822	47	2016-06-27 20:43:25.898074	2834
31823	47	2016-06-27 20:43:25.905414	2847
31824	47	2016-06-27 20:43:25.913046	2874
31825	47	2016-06-27 20:43:25.919746	2863
31826	41	2016-06-27 20:45:52.702074	2858
31827	41	2016-06-27 20:45:52.709469	2865
31828	41	2016-06-27 20:45:52.717412	2866
31829	44	2016-06-27 20:45:52.725066	2869
31830	42	2016-06-27 20:45:52.73216	2849
31831	42	2016-06-27 20:45:52.738577	2834
31832	42	2016-06-27 20:45:52.74512	2855
31833	42	2016-06-27 20:45:52.752022	2851
31834	42	2016-06-27 20:45:52.758446	2872
31835	42	2016-06-27 20:45:52.765235	2874
31836	42	2016-06-27 20:45:52.771773	2847
31837	43	2016-06-27 20:45:52.778785	2848
31838	43	2016-06-27 20:45:52.785545	2835
31839	43	2016-06-27 20:45:52.792163	2852
31840	43	2016-06-27 20:45:52.79965	2875
31841	43	2016-06-27 20:45:52.806566	2856
31842	43	2016-06-27 20:45:52.813718	2873
31843	43	2016-06-27 20:45:52.820245	2850
31844	40	2016-06-27 20:45:52.828262	47733
31845	40	2016-06-27 20:45:52.834764	47730
31846	40	2016-06-27 20:45:52.840635	47706
31847	40	2016-06-27 20:45:52.847204	47709
31848	40	2016-06-27 20:45:52.856408	47727
31849	40	2016-06-27 20:45:52.864603	47721
31850	49	2016-06-27 20:45:52.872382	47706
31851	49	2016-06-27 20:45:52.879093	47727
31852	49	2016-06-27 20:45:52.886185	47730
31853	49	2016-06-27 20:45:52.892758	47721
31854	49	2016-06-27 20:45:52.899954	47733
31855	49	2016-06-27 20:45:52.906752	47709
31856	48	2016-06-27 20:45:52.915576	2851
31857	48	2016-06-27 20:45:52.923781	2859
31858	48	2016-06-27 20:45:52.930984	2843
31859	48	2016-06-27 20:45:52.937621	2845
31860	48	2016-06-27 20:45:52.945419	2855
31861	48	2016-06-27 20:45:52.953103	2872
31862	48	2016-06-27 20:45:52.959334	2861
31863	48	2016-06-27 20:45:52.967073	2849
31864	48	2016-06-27 20:45:52.973901	2853
31865	48	2016-06-27 20:45:52.981502	2834
31866	48	2016-06-27 20:45:52.988786	2847
31867	48	2016-06-27 20:45:52.996155	2874
31868	48	2016-06-27 20:45:53.002801	2863
31869	50	2016-06-27 20:45:53.010325	47706
31870	50	2016-06-27 20:45:53.017564	47727
31871	50	2016-06-27 20:45:53.024069	47730
31872	50	2016-06-27 20:45:53.030711	47721
31873	50	2016-06-27 20:45:53.03733	47733
31874	50	2016-06-27 20:45:53.044033	47709
31875	47	2016-06-27 20:45:53.051673	2851
31876	47	2016-06-27 20:45:53.057812	2859
31877	47	2016-06-27 20:45:53.064126	2843
31878	47	2016-06-27 20:45:53.070737	2845
31879	47	2016-06-27 20:45:53.077671	2855
31880	47	2016-06-27 20:45:53.084356	2872
31881	47	2016-06-27 20:45:53.090687	2861
31882	47	2016-06-27 20:45:53.097611	2849
31883	47	2016-06-27 20:45:53.104547	2853
31884	47	2016-06-27 20:45:53.111533	2834
31885	47	2016-06-27 20:45:53.11886	2847
31886	47	2016-06-27 20:45:53.125854	2874
31887	47	2016-06-27 20:45:53.13246	2863
31888	41	2016-06-27 20:54:37.233991	2858
31889	41	2016-06-27 20:54:37.242838	2865
31890	41	2016-06-27 20:54:37.251215	2866
31891	44	2016-06-27 20:54:37.259984	2869
31892	42	2016-06-27 20:54:37.268313	2849
31893	42	2016-06-27 20:54:37.276835	2834
31894	42	2016-06-27 20:54:37.284826	2855
31895	42	2016-06-27 20:54:37.292127	2874
31896	42	2016-06-27 20:54:37.300378	2878
31897	42	2016-06-27 20:54:37.307686	2847
31898	42	2016-06-27 20:54:37.316107	2851
31899	42	2016-06-27 20:54:37.323344	2872
31900	43	2016-06-27 20:54:37.331739	2848
31901	43	2016-06-27 20:54:37.33888	2835
31902	43	2016-06-27 20:54:37.346655	2852
31903	43	2016-06-27 20:54:37.356212	2856
31904	43	2016-06-27 20:54:37.363977	2873
31905	43	2016-06-27 20:54:37.371588	2879
31906	43	2016-06-27 20:54:37.379374	2850
31907	43	2016-06-27 20:54:37.386588	2875
31908	40	2016-06-27 20:54:37.400671	47733
31909	40	2016-06-27 20:54:37.406741	47730
31910	40	2016-06-27 20:54:37.413401	47706
31911	40	2016-06-27 20:54:37.419574	47709
31912	40	2016-06-27 20:54:37.425418	47727
31913	40	2016-06-27 20:54:37.431918	47721
31914	49	2016-06-27 20:54:37.439615	47706
31915	49	2016-06-27 20:54:37.446649	47727
31916	49	2016-06-27 20:54:37.453802	47730
31917	49	2016-06-27 20:54:37.460535	47721
31918	49	2016-06-27 20:54:37.467518	47733
31919	49	2016-06-27 20:54:37.473757	47709
31920	48	2016-06-27 20:54:37.481806	2851
31921	48	2016-06-27 20:54:37.488041	2859
31922	48	2016-06-27 20:54:37.495516	2843
31923	48	2016-06-27 20:54:37.503081	2845
31924	48	2016-06-27 20:54:37.510082	2855
31925	48	2016-06-27 20:54:37.518572	2872
31926	48	2016-06-27 20:54:37.52499	2861
31927	48	2016-06-27 20:54:37.533287	2849
31928	48	2016-06-27 20:54:37.539558	2853
31929	48	2016-06-27 20:54:37.547479	2834
31930	48	2016-06-27 20:54:37.554695	2847
31931	48	2016-06-27 20:54:37.561786	2874
31932	48	2016-06-27 20:54:37.568361	2863
31933	50	2016-06-27 20:54:37.575477	47706
31934	50	2016-06-27 20:54:37.582542	47727
31935	50	2016-06-27 20:54:37.589389	47730
31936	50	2016-06-27 20:54:37.599302	47721
31937	50	2016-06-27 20:54:37.605887	47733
31938	50	2016-06-27 20:54:37.612969	47709
31939	47	2016-06-27 20:54:37.620843	2851
31940	47	2016-06-27 20:54:37.627298	2859
31941	47	2016-06-27 20:54:37.633894	2843
31942	47	2016-06-27 20:54:37.640373	2845
31943	47	2016-06-27 20:54:37.647835	2855
31944	47	2016-06-27 20:54:37.65444	2872
31945	47	2016-06-27 20:54:37.660975	2861
31946	47	2016-06-27 20:54:37.669452	2849
31947	47	2016-06-27 20:54:37.675667	2853
31948	47	2016-06-27 20:54:37.683422	2834
31949	47	2016-06-27 20:54:37.690539	2847
31950	47	2016-06-27 20:54:37.697814	2874
31951	47	2016-06-27 20:54:37.704061	2863
31952	41	2016-06-27 21:01:02.177603	2858
31953	41	2016-06-27 21:01:02.185277	2865
31954	41	2016-06-27 21:01:02.193316	2866
31955	44	2016-06-27 21:01:02.201303	2869
31956	42	2016-06-27 21:01:02.207841	2849
31957	42	2016-06-27 21:01:02.215112	2834
31958	42	2016-06-27 21:01:02.221706	2855
31959	42	2016-06-27 21:01:02.228114	2874
31960	42	2016-06-27 21:01:02.235127	2878
31961	42	2016-06-27 21:01:02.241958	2847
31962	42	2016-06-27 21:01:02.251719	2851
31963	42	2016-06-27 21:01:02.258243	2872
31964	43	2016-06-27 21:01:02.265655	2848
31965	43	2016-06-27 21:01:02.272032	2835
31966	43	2016-06-27 21:01:02.278991	2852
31967	43	2016-06-27 21:01:02.285874	2856
31968	43	2016-06-27 21:01:02.292219	2873
31969	43	2016-06-27 21:01:02.299264	2879
31970	43	2016-06-27 21:01:02.305832	2850
31971	43	2016-06-27 21:01:02.312626	2875
31972	40	2016-06-27 21:01:02.322109	47733
31973	40	2016-06-27 21:01:02.328122	47730
31974	40	2016-06-27 21:01:02.33506	47706
31975	40	2016-06-27 21:01:02.341171	47709
31976	40	2016-06-27 21:01:02.346864	47727
31977	40	2016-06-27 21:01:02.354113	47721
31978	49	2016-06-27 21:01:02.362112	47706
31979	49	2016-06-27 21:01:02.369695	47727
31980	49	2016-06-27 21:01:02.376339	47730
31981	49	2016-06-27 21:01:02.383232	47721
31982	49	2016-06-27 21:01:02.389633	47733
31983	49	2016-06-27 21:01:02.396025	47709
31984	48	2016-06-27 21:01:02.404593	2851
31985	48	2016-06-27 21:01:02.411079	2859
31986	48	2016-06-27 21:01:02.419089	2843
31987	48	2016-06-27 21:01:02.425791	2845
31988	48	2016-06-27 21:01:02.433835	2855
31989	48	2016-06-27 21:01:02.440894	2872
31990	48	2016-06-27 21:01:02.447283	2861
31991	48	2016-06-27 21:01:02.455444	2849
31992	48	2016-06-27 21:01:02.477723	2853
31993	48	2016-06-27 21:01:02.500209	2834
31994	48	2016-06-27 21:01:02.507538	2847
31995	48	2016-06-27 21:01:02.514736	2874
31996	48	2016-06-27 21:01:02.521389	2863
31997	50	2016-06-27 21:01:02.528709	47706
31998	50	2016-06-27 21:01:02.536182	47727
31999	50	2016-06-27 21:01:02.542812	47730
32000	50	2016-06-27 21:01:02.54978	47721
32001	50	2016-06-27 21:01:02.556793	47733
32002	50	2016-06-27 21:01:02.563269	47709
32003	47	2016-06-27 21:01:02.571566	2851
32004	47	2016-06-27 21:01:02.577864	2859
32005	47	2016-06-27 21:01:02.584902	2843
32006	47	2016-06-27 21:01:02.592901	2855
32007	47	2016-06-27 21:01:02.603464	2872
32008	47	2016-06-27 21:01:02.61069	2861
32009	47	2016-06-27 21:01:02.618326	2849
32010	47	2016-06-27 21:01:02.624657	2853
32011	47	2016-06-27 21:01:02.632234	2878
32012	47	2016-06-27 21:01:02.639449	2834
32013	47	2016-06-27 21:01:02.64649	2847
32014	47	2016-06-27 21:01:02.653835	2874
32015	47	2016-06-27 21:01:02.660702	2863
32016	47	2016-06-27 21:01:02.667837	2845
32017	41	2016-06-27 21:04:16.601717	2858
32018	41	2016-06-27 21:04:16.609508	2865
32019	41	2016-06-27 21:04:16.616616	2866
32020	44	2016-06-27 21:04:16.625626	2869
32021	42	2016-06-27 21:04:16.632198	2849
32022	42	2016-06-27 21:04:16.639756	2834
32023	42	2016-06-27 21:04:16.645993	2855
32024	42	2016-06-27 21:04:16.653682	2874
32025	42	2016-06-27 21:04:16.66058	2878
32026	42	2016-06-27 21:04:16.66768	2847
32027	42	2016-06-27 21:04:16.674374	2851
32028	42	2016-06-27 21:04:16.680548	2872
32029	43	2016-06-27 21:04:16.688116	2848
32030	43	2016-06-27 21:04:16.694612	2835
32031	43	2016-06-27 21:04:16.701666	2852
32032	43	2016-06-27 21:04:16.708372	2856
32033	43	2016-06-27 21:04:16.714682	2873
32034	43	2016-06-27 21:04:16.722522	2879
32035	43	2016-06-27 21:04:16.729097	2850
32036	43	2016-06-27 21:04:16.736389	2875
32037	40	2016-06-27 21:04:16.745881	47733
32038	40	2016-06-27 21:04:16.752902	47730
32039	40	2016-06-27 21:04:16.759892	47706
32040	40	2016-06-27 21:04:16.766044	47709
32041	40	2016-06-27 21:04:16.774436	47727
32042	40	2016-06-27 21:04:16.780764	47721
32043	49	2016-06-27 21:04:16.791074	47706
32044	49	2016-06-27 21:04:16.797824	47727
32045	49	2016-06-27 21:04:16.805809	47730
32046	49	2016-06-27 21:04:16.812559	47721
32047	49	2016-06-27 21:04:16.820334	47733
32048	49	2016-06-27 21:04:16.827229	47709
32049	48	2016-06-27 21:04:16.835753	2851
32050	48	2016-06-27 21:04:16.842734	2859
32051	48	2016-06-27 21:04:16.850669	2843
32052	48	2016-06-27 21:04:16.861071	2855
32053	48	2016-06-27 21:04:16.868641	2872
32054	48	2016-06-27 21:04:16.875543	2861
32055	48	2016-06-27 21:04:16.882697	2849
32056	48	2016-06-27 21:04:16.891096	2853
32057	48	2016-06-27 21:04:16.898196	2878
32058	48	2016-06-27 21:04:16.906301	2834
32059	48	2016-06-27 21:04:16.913432	2847
32060	48	2016-06-27 21:04:16.921345	2874
32061	48	2016-06-27 21:04:16.928683	2863
32062	48	2016-06-27 21:04:16.935447	2845
32063	50	2016-06-27 21:04:16.94333	47706
32064	50	2016-06-27 21:04:16.950623	47727
32065	50	2016-06-27 21:04:16.957461	47730
32066	50	2016-06-27 21:04:16.964069	47721
32067	50	2016-06-27 21:04:16.971154	47733
32068	50	2016-06-27 21:04:16.977964	47709
32069	47	2016-06-27 21:04:16.986211	2851
32070	47	2016-06-27 21:04:16.992495	2859
32071	47	2016-06-27 21:04:16.999102	2843
32072	47	2016-06-27 21:04:17.006303	2855
32073	47	2016-06-27 21:04:17.013183	2872
32074	47	2016-06-27 21:04:17.020178	2861
32075	47	2016-06-27 21:04:17.027063	2849
32076	47	2016-06-27 21:04:17.033514	2853
32077	47	2016-06-27 21:04:17.040628	2878
32078	47	2016-06-27 21:04:17.047624	2834
32079	47	2016-06-27 21:04:17.056478	2847
32080	47	2016-06-27 21:04:17.063175	2874
32081	47	2016-06-27 21:04:17.070214	2863
32082	47	2016-06-27 21:04:17.077571	2845
32083	41	2016-06-27 21:05:56.116594	2858
32084	41	2016-06-27 21:05:56.12444	2865
32085	41	2016-06-27 21:05:56.13252	2866
32086	44	2016-06-27 21:05:56.141276	2869
32087	42	2016-06-27 21:05:56.148794	2849
32088	42	2016-06-27 21:05:56.155469	2834
32089	42	2016-06-27 21:05:56.161806	2855
32090	42	2016-06-27 21:05:56.168704	2874
32091	42	2016-06-27 21:05:56.175138	2878
32092	42	2016-06-27 21:05:56.182582	2847
32093	42	2016-06-27 21:05:56.189344	2851
32094	42	2016-06-27 21:05:56.195753	2872
32095	43	2016-06-27 21:05:56.203291	2848
32096	43	2016-06-27 21:05:56.209833	2835
32097	43	2016-06-27 21:05:56.216627	2852
32098	43	2016-06-27 21:05:56.22299	2856
32099	43	2016-06-27 21:05:56.22938	2873
32100	43	2016-06-27 21:05:56.236617	2879
32101	43	2016-06-27 21:05:56.243317	2850
32102	43	2016-06-27 21:05:56.249917	2875
32103	40	2016-06-27 21:05:56.257242	47733
32104	40	2016-06-27 21:05:56.263693	47730
32105	40	2016-06-27 21:05:56.270311	47706
32106	40	2016-06-27 21:05:56.276312	47709
32107	40	2016-06-27 21:05:56.283023	47727
32108	40	2016-06-27 21:05:56.289058	47721
32109	49	2016-06-27 21:05:56.297168	47706
32110	49	2016-06-27 21:05:56.303854	47727
32111	49	2016-06-27 21:05:56.310264	47730
32112	49	2016-06-27 21:05:56.318905	47721
32113	49	2016-06-27 21:05:56.325505	47733
32114	49	2016-06-27 21:05:56.332698	47709
32115	48	2016-06-27 21:05:56.340541	2851
32116	48	2016-06-27 21:05:56.347229	2859
32117	48	2016-06-27 21:05:56.354465	2843
32118	48	2016-06-27 21:05:56.363259	2855
32119	48	2016-06-27 21:05:56.370527	2872
32120	48	2016-06-27 21:05:56.376919	2861
32121	48	2016-06-27 21:05:56.384284	2849
32122	48	2016-06-27 21:05:56.391174	2853
32123	48	2016-06-27 21:05:56.398295	2878
32124	48	2016-06-27 21:05:56.405359	2834
32125	48	2016-06-27 21:05:56.412603	2847
32126	48	2016-06-27 21:05:56.41953	2874
32127	48	2016-06-27 21:05:56.425932	2863
32128	48	2016-06-27 21:05:56.432591	2845
32129	50	2016-06-27 21:05:56.440568	47706
32130	50	2016-06-27 21:05:56.44849	47727
32131	50	2016-06-27 21:05:56.455382	47730
32132	50	2016-06-27 21:05:56.461985	47721
32133	50	2016-06-27 21:05:56.468668	47733
32134	50	2016-06-27 21:05:56.475996	47709
32135	47	2016-06-27 21:05:56.484196	2851
32136	47	2016-06-27 21:05:56.49094	2859
32137	47	2016-06-27 21:05:56.497646	2843
32138	47	2016-06-27 21:05:56.505009	2855
32139	47	2016-06-27 21:05:56.512043	2872
32140	47	2016-06-27 21:05:56.518406	2861
32141	47	2016-06-27 21:05:56.525597	2849
32142	47	2016-06-27 21:05:56.531959	2853
32143	47	2016-06-27 21:05:56.539001	2878
32144	47	2016-06-27 21:05:56.546376	2834
32145	47	2016-06-27 21:05:56.553663	2847
32146	47	2016-06-27 21:05:56.560888	2874
32147	47	2016-06-27 21:05:56.567715	2863
32148	47	2016-06-27 21:05:56.574696	2845
32149	41	2016-06-27 21:07:34.619558	2858
32150	41	2016-06-27 21:07:34.627286	2865
32151	41	2016-06-27 21:07:34.635096	2866
32152	44	2016-06-27 21:07:34.643824	2869
32153	42	2016-06-27 21:07:34.652357	2849
32154	42	2016-06-27 21:07:34.659436	2834
32155	42	2016-06-27 21:07:34.666226	2855
32156	42	2016-06-27 21:07:34.673081	2874
32157	42	2016-06-27 21:07:34.679747	2878
32158	42	2016-06-27 21:07:34.688811	2847
32159	42	2016-06-27 21:07:34.695856	2851
32160	42	2016-06-27 21:07:34.702395	2872
32161	43	2016-06-27 21:07:34.709753	2848
32162	43	2016-06-27 21:07:34.716495	2835
32163	43	2016-06-27 21:07:34.723921	2852
32164	43	2016-06-27 21:07:34.730859	2856
32165	43	2016-06-27 21:07:34.738051	2873
32166	43	2016-06-27 21:07:34.745297	2879
32167	43	2016-06-27 21:07:34.752259	2850
32168	43	2016-06-27 21:07:34.759292	2875
32169	40	2016-06-27 21:07:34.767049	47733
32170	40	2016-06-27 21:07:34.774177	47730
32171	40	2016-06-27 21:07:34.780809	47706
32172	40	2016-06-27 21:07:34.787383	47709
32173	40	2016-06-27 21:07:34.794391	47727
32174	40	2016-06-27 21:07:34.801073	47721
32175	49	2016-06-27 21:07:34.809154	47706
32176	49	2016-06-27 21:07:34.816059	47727
32177	49	2016-06-27 21:07:34.823002	47730
32178	49	2016-06-27 21:07:34.829446	47721
32179	49	2016-06-27 21:07:34.835812	47733
32180	49	2016-06-27 21:07:34.843572	47709
32181	48	2016-06-27 21:07:34.852295	2851
32182	48	2016-06-27 21:07:34.859125	2859
32183	48	2016-06-27 21:07:34.866129	2843
32184	48	2016-06-27 21:07:34.874121	2855
32185	48	2016-06-27 21:07:34.881302	2872
32186	48	2016-06-27 21:07:34.887683	2861
32187	48	2016-06-27 21:07:34.895321	2849
32188	48	2016-06-27 21:07:34.902206	2853
32189	48	2016-06-27 21:07:34.909652	2878
32190	48	2016-06-27 21:07:34.917542	2834
32191	48	2016-06-27 21:07:34.925477	2847
32192	48	2016-06-27 21:07:34.93269	2874
32193	48	2016-06-27 21:07:34.939469	2863
32194	48	2016-06-27 21:07:34.946067	2845
32195	50	2016-06-27 21:07:34.953522	47706
32196	50	2016-06-27 21:07:34.961043	47727
32197	50	2016-06-27 21:07:34.968056	47730
32198	50	2016-06-27 21:07:34.975298	47721
32199	50	2016-06-27 21:07:34.982126	47733
32200	50	2016-06-27 21:07:34.989278	47709
32201	47	2016-06-27 21:07:34.997477	2851
32202	47	2016-06-27 21:07:35.003959	2859
32203	47	2016-06-27 21:07:35.01135	2843
32204	47	2016-06-27 21:07:35.018287	2855
32205	47	2016-06-27 21:07:35.025467	2872
32206	47	2016-06-27 21:07:35.032233	2861
32207	47	2016-06-27 21:07:35.039787	2849
32208	47	2016-06-27 21:07:35.047343	2853
32209	47	2016-06-27 21:07:35.055401	2878
32210	47	2016-06-27 21:07:35.063063	2834
32211	47	2016-06-27 21:07:35.070371	2847
32212	47	2016-06-27 21:07:35.076955	2874
32213	47	2016-06-27 21:07:35.083896	2863
32214	47	2016-06-27 21:07:35.090441	2845
32215	41	2016-06-27 21:09:08.205415	2858
32216	41	2016-06-27 21:09:08.215698	2865
32217	41	2016-06-27 21:09:08.225651	2866
32218	44	2016-06-27 21:09:08.237579	2869
32219	42	2016-06-27 21:09:08.249667	2849
32220	42	2016-06-27 21:09:08.257686	2834
32221	42	2016-06-27 21:09:08.266039	2855
32222	42	2016-06-27 21:09:08.27352	2874
32223	42	2016-06-27 21:09:08.282208	2878
32224	42	2016-06-27 21:09:08.290301	2847
32225	42	2016-06-27 21:09:08.297246	2851
32226	42	2016-06-27 21:09:08.303632	2872
32227	43	2016-06-27 21:09:08.312173	2848
32228	43	2016-06-27 21:09:08.319271	2835
32229	43	2016-06-27 21:09:08.327291	2852
32230	43	2016-06-27 21:09:08.33432	2856
32231	43	2016-06-27 21:09:08.341248	2873
32232	43	2016-06-27 21:09:08.348798	2879
32233	43	2016-06-27 21:09:08.35546	2850
32234	43	2016-06-27 21:09:08.362618	2875
32235	40	2016-06-27 21:09:08.370357	47733
32236	40	2016-06-27 21:09:08.377957	47730
32237	40	2016-06-27 21:09:08.385956	47706
32238	40	2016-06-27 21:09:08.393156	47709
32239	40	2016-06-27 21:09:08.39987	47727
32240	40	2016-06-27 21:09:08.405994	47721
32241	49	2016-06-27 21:09:08.417604	47706
32242	49	2016-06-27 21:09:08.426676	47727
32243	49	2016-06-27 21:09:08.435728	47730
32244	49	2016-06-27 21:09:08.445295	47721
32245	49	2016-06-27 21:09:08.453956	47733
32246	49	2016-06-27 21:09:08.46172	47709
32247	48	2016-06-27 21:09:08.481082	2851
32248	48	2016-06-27 21:09:08.491005	2859
32249	48	2016-06-27 21:09:08.500256	2843
32250	48	2016-06-27 21:09:08.513236	2855
32251	48	2016-06-27 21:09:08.523614	2872
32252	48	2016-06-27 21:09:08.532333	2861
32253	48	2016-06-27 21:09:08.543023	2849
32254	48	2016-06-27 21:09:08.555517	2853
32255	48	2016-06-27 21:09:08.570052	2878
32256	48	2016-06-27 21:09:08.582739	2834
32257	48	2016-06-27 21:09:08.59476	2847
32258	48	2016-06-27 21:09:08.604189	2874
32259	48	2016-06-27 21:09:08.612368	2863
32260	48	2016-06-27 21:09:08.631491	2845
32261	50	2016-06-27 21:09:08.639697	47706
32262	50	2016-06-27 21:09:08.648122	47727
32263	50	2016-06-27 21:09:08.657936	47730
32264	50	2016-06-27 21:09:08.670851	47721
32265	50	2016-06-27 21:09:08.681225	47733
32266	50	2016-06-27 21:09:08.689413	47709
32267	47	2016-06-27 21:09:08.700251	2851
32268	47	2016-06-27 21:09:08.710369	2859
32269	47	2016-06-27 21:09:08.718384	2843
32270	47	2016-06-27 21:09:08.733479	2855
32271	47	2016-06-27 21:09:08.747449	2872
32272	47	2016-06-27 21:09:08.758332	2861
32273	47	2016-06-27 21:09:08.767552	2849
32274	47	2016-06-27 21:09:09.042206	2853
32275	47	2016-06-27 21:09:09.082451	2878
32276	47	2016-06-27 21:09:09.098537	2834
32277	47	2016-06-27 21:09:09.114606	2847
32278	47	2016-06-27 21:09:09.127706	2874
32279	47	2016-06-27 21:09:09.13505	2863
32280	47	2016-06-27 21:09:09.144672	2845
32281	41	2016-06-27 21:12:27.358768	2858
32282	41	2016-06-27 21:12:27.367662	2865
32283	41	2016-06-27 21:12:27.375379	2866
32284	44	2016-06-27 21:12:27.3832	2869
32285	42	2016-06-27 21:12:27.390627	2849
32286	42	2016-06-27 21:12:27.397346	2834
32287	42	2016-06-27 21:12:27.406833	2855
32288	42	2016-06-27 21:12:27.413343	2874
32289	42	2016-06-27 21:12:27.421247	2878
32290	42	2016-06-27 21:12:27.428099	2847
32291	42	2016-06-27 21:12:27.435882	2851
32292	42	2016-06-27 21:12:27.443083	2872
32293	43	2016-06-27 21:12:27.450515	2848
32294	43	2016-06-27 21:12:27.457266	2835
32295	43	2016-06-27 21:12:27.464056	2852
32296	43	2016-06-27 21:12:27.470595	2856
32297	43	2016-06-27 21:12:27.477325	2873
32298	43	2016-06-27 21:12:27.484479	2879
32299	43	2016-06-27 21:12:27.491148	2850
32300	43	2016-06-27 21:12:27.497891	2875
32301	40	2016-06-27 21:12:27.505704	47733
32302	40	2016-06-27 21:12:27.512139	47730
32303	40	2016-06-27 21:12:27.518477	47706
32304	40	2016-06-27 21:12:27.52458	47709
32305	40	2016-06-27 21:12:27.53075	47727
32306	40	2016-06-27 21:12:27.536955	47721
32307	49	2016-06-27 21:12:27.545311	47706
32308	49	2016-06-27 21:12:27.552112	47727
32309	49	2016-06-27 21:12:27.559136	47730
32310	49	2016-06-27 21:12:27.565908	47721
32311	49	2016-06-27 21:12:27.573779	47733
32312	49	2016-06-27 21:12:27.58103	47709
32313	48	2016-06-27 21:12:27.589147	2851
32314	48	2016-06-27 21:12:27.596067	2859
32315	48	2016-06-27 21:12:27.603144	2843
32316	48	2016-06-27 21:12:27.610786	2855
32317	48	2016-06-27 21:12:27.6185	2872
32318	48	2016-06-27 21:12:27.625396	2861
32319	48	2016-06-27 21:12:27.633209	2849
32320	48	2016-06-27 21:12:27.640192	2853
32321	48	2016-06-27 21:12:27.648204	2878
32322	48	2016-06-27 21:12:27.655558	2834
32323	48	2016-06-27 21:12:27.663353	2847
32324	48	2016-06-27 21:12:27.670695	2874
32325	48	2016-06-27 21:12:27.677623	2863
32326	48	2016-06-27 21:12:27.685515	2845
32327	50	2016-06-27 21:12:27.694254	47706
32328	50	2016-06-27 21:12:27.701983	47727
32329	50	2016-06-27 21:12:27.709637	47730
32330	50	2016-06-27 21:12:27.717001	47721
32331	50	2016-06-27 21:12:27.723864	47733
32332	50	2016-06-27 21:12:27.731113	47709
32333	47	2016-06-27 21:12:27.739072	2851
32334	47	2016-06-27 21:12:27.746024	2859
32335	47	2016-06-27 21:12:27.752887	2843
32336	47	2016-06-27 21:12:27.760275	2855
32337	47	2016-06-27 21:12:27.767205	2872
32338	47	2016-06-27 21:12:27.774022	2861
32339	47	2016-06-27 21:12:27.782436	2849
32340	47	2016-06-27 21:12:27.788869	2853
32341	47	2016-06-27 21:12:27.796327	2878
32342	47	2016-06-27 21:12:27.803558	2834
32343	47	2016-06-27 21:12:27.81116	2847
32344	47	2016-06-27 21:12:27.81948	2874
32345	47	2016-06-27 21:12:27.826951	2863
32346	47	2016-06-27 21:12:27.83411	2845
32347	41	2016-06-27 21:13:56.148603	2858
32348	41	2016-06-27 21:13:56.156239	2865
32349	41	2016-06-27 21:13:56.164399	2866
32350	44	2016-06-27 21:13:56.172271	2869
32351	42	2016-06-27 21:13:56.180388	2849
32352	42	2016-06-27 21:13:56.187578	2834
32353	42	2016-06-27 21:13:56.194152	2855
32354	42	2016-06-27 21:13:56.200519	2874
32355	42	2016-06-27 21:13:56.206933	2878
32356	42	2016-06-27 21:13:56.213535	2847
32357	42	2016-06-27 21:13:56.220124	2851
32358	42	2016-06-27 21:13:56.226708	2872
32359	43	2016-06-27 21:13:56.233715	2848
32360	43	2016-06-27 21:13:56.240049	2835
32361	43	2016-06-27 21:13:56.246722	2852
32362	43	2016-06-27 21:13:56.253231	2856
32363	43	2016-06-27 21:13:56.259857	2873
32364	43	2016-06-27 21:13:56.266554	2879
32365	43	2016-06-27 21:13:56.272897	2850
32366	43	2016-06-27 21:13:56.279926	2875
32367	40	2016-06-27 21:13:56.287639	47733
32368	40	2016-06-27 21:13:56.293687	47730
32369	40	2016-06-27 21:13:56.29954	47706
32370	40	2016-06-27 21:13:56.30519	47709
32371	40	2016-06-27 21:13:56.31182	47727
32372	40	2016-06-27 21:13:56.318023	47721
32373	49	2016-06-27 21:13:56.326045	47706
32374	49	2016-06-27 21:13:56.332863	47727
32375	49	2016-06-27 21:13:56.34007	47730
32376	49	2016-06-27 21:13:56.347069	47721
32377	49	2016-06-27 21:13:56.354078	47733
32378	49	2016-06-27 21:13:56.360704	47709
32379	48	2016-06-27 21:13:56.369227	2851
32380	48	2016-06-27 21:13:56.376192	2859
32381	48	2016-06-27 21:13:56.383082	2843
32382	48	2016-06-27 21:13:56.390831	2855
32383	48	2016-06-27 21:13:56.398029	2872
32384	48	2016-06-27 21:13:56.405394	2861
32385	48	2016-06-27 21:13:56.414255	2849
32386	48	2016-06-27 21:13:56.421733	2853
32387	48	2016-06-27 21:13:56.429161	2878
32388	48	2016-06-27 21:13:56.437279	2834
32389	48	2016-06-27 21:13:56.44513	2847
32390	48	2016-06-27 21:13:56.45273	2874
32391	48	2016-06-27 21:13:56.459288	2863
32392	48	2016-06-27 21:13:56.466336	2845
32393	50	2016-06-27 21:13:56.47466	47706
32394	50	2016-06-27 21:13:56.48172	47727
32395	50	2016-06-27 21:13:56.489422	47730
32396	50	2016-06-27 21:13:56.496454	47721
32397	50	2016-06-27 21:13:56.503483	47733
32398	50	2016-06-27 21:13:56.510349	47709
32399	47	2016-06-27 21:13:56.518069	2851
32400	47	2016-06-27 21:13:56.525175	2859
32401	47	2016-06-27 21:13:56.531698	2843
32402	47	2016-06-27 21:13:56.539245	2855
32403	47	2016-06-27 21:13:56.546264	2872
32404	47	2016-06-27 21:13:56.553081	2861
32405	47	2016-06-27 21:13:56.560086	2849
32406	47	2016-06-27 21:13:56.566691	2853
32407	47	2016-06-27 21:13:56.574725	2878
32408	47	2016-06-27 21:13:56.581941	2834
32409	47	2016-06-27 21:13:56.589289	2847
32410	47	2016-06-27 21:13:56.596156	2874
32411	47	2016-06-27 21:13:56.602851	2863
32412	47	2016-06-27 21:13:56.609363	2845
32413	41	2016-06-27 21:22:42.823314	2858
32414	41	2016-06-27 21:22:42.831302	2865
32415	41	2016-06-27 21:22:42.840786	2866
32416	44	2016-06-27 21:22:42.849672	2869
32417	42	2016-06-27 21:22:42.857353	2849
32418	42	2016-06-27 21:22:42.863768	2834
32419	42	2016-06-27 21:22:42.870744	2855
32420	42	2016-06-27 21:22:42.877305	2874
32421	42	2016-06-27 21:22:42.883751	2878
32422	42	2016-06-27 21:22:42.891012	2847
32423	42	2016-06-27 21:22:42.89855	2851
32424	42	2016-06-27 21:22:42.905167	2872
32425	43	2016-06-27 21:22:42.911975	2848
32426	43	2016-06-27 21:22:42.918411	2835
32427	43	2016-06-27 21:22:42.924867	2852
32428	43	2016-06-27 21:22:42.931522	2856
32429	43	2016-06-27 21:22:42.93787	2873
32430	43	2016-06-27 21:22:42.944383	2879
32431	43	2016-06-27 21:22:42.950946	2850
32432	43	2016-06-27 21:22:42.958221	2875
32433	40	2016-06-27 21:22:42.966671	47733
32434	40	2016-06-27 21:22:42.973072	47730
32435	40	2016-06-27 21:22:42.979603	47706
32436	40	2016-06-27 21:22:42.986224	47709
32437	40	2016-06-27 21:22:42.992536	47727
32438	40	2016-06-27 21:22:42.998427	47721
32439	49	2016-06-27 21:22:43.007095	47706
32440	49	2016-06-27 21:22:43.014172	47727
32441	49	2016-06-27 21:22:43.021428	47730
32442	49	2016-06-27 21:22:43.028234	47721
32443	49	2016-06-27 21:22:43.035278	47733
32444	49	2016-06-27 21:22:43.043001	47709
32445	48	2016-06-27 21:22:43.054632	2851
32446	48	2016-06-27 21:22:43.061925	2859
32447	48	2016-06-27 21:22:43.069289	2843
32448	48	2016-06-27 21:22:43.077981	2855
32449	48	2016-06-27 21:22:43.086198	2872
32450	48	2016-06-27 21:22:43.092973	2861
32451	48	2016-06-27 21:22:43.100451	2849
32452	48	2016-06-27 21:22:43.107064	2853
32453	48	2016-06-27 21:22:43.114476	2878
32454	48	2016-06-27 21:22:43.122074	2834
32455	48	2016-06-27 21:22:43.129741	2847
32456	48	2016-06-27 21:22:43.13705	2874
32457	48	2016-06-27 21:22:43.144166	2863
32458	48	2016-06-27 21:22:43.151339	2845
32459	50	2016-06-27 21:22:43.161035	47706
32460	50	2016-06-27 21:22:43.169252	47727
32461	50	2016-06-27 21:22:43.177599	47730
32462	50	2016-06-27 21:22:43.184651	47721
32463	50	2016-06-27 21:22:43.191252	47733
32464	50	2016-06-27 21:22:43.199573	47709
32465	47	2016-06-27 21:22:43.208622	2851
32466	47	2016-06-27 21:22:43.231193	2859
32467	47	2016-06-27 21:22:43.23788	2843
32468	47	2016-06-27 21:22:43.244973	2855
32469	47	2016-06-27 21:22:43.252059	2872
32470	47	2016-06-27 21:22:43.258382	2861
32471	47	2016-06-27 21:22:43.265902	2849
32472	47	2016-06-27 21:22:43.272659	2853
32473	47	2016-06-27 21:22:43.279708	2878
32474	47	2016-06-27 21:22:43.287354	2834
32475	47	2016-06-27 21:22:43.294721	2847
32476	47	2016-06-27 21:22:43.301885	2874
32477	47	2016-06-27 21:22:43.308382	2863
32478	47	2016-06-27 21:22:43.315327	2845
32479	41	2016-06-27 21:23:51.199937	2858
32480	41	2016-06-27 21:23:51.208848	2865
32481	41	2016-06-27 21:23:51.217524	2866
32482	44	2016-06-27 21:23:51.227179	2869
32483	42	2016-06-27 21:23:51.233941	2849
32484	42	2016-06-27 21:23:51.240501	2834
32485	42	2016-06-27 21:23:51.247123	2855
32486	42	2016-06-27 21:23:51.254654	2874
32487	42	2016-06-27 21:23:51.261534	2878
32488	42	2016-06-27 21:23:51.26811	2847
32489	42	2016-06-27 21:23:51.275029	2851
32490	42	2016-06-27 21:23:51.281294	2872
32491	43	2016-06-27 21:23:51.2882	2848
32492	43	2016-06-27 21:23:51.294582	2835
32493	43	2016-06-27 21:23:51.301658	2852
32494	43	2016-06-27 21:23:51.308241	2856
32495	43	2016-06-27 21:23:51.314421	2873
32496	43	2016-06-27 21:23:51.321206	2879
32497	43	2016-06-27 21:23:51.327545	2850
32498	43	2016-06-27 21:23:51.334367	2875
32499	40	2016-06-27 21:23:51.342426	47733
32500	40	2016-06-27 21:23:51.348569	47730
32501	40	2016-06-27 21:23:51.354824	47706
32502	40	2016-06-27 21:23:51.360758	47709
32503	40	2016-06-27 21:23:51.366884	47727
32504	40	2016-06-27 21:23:51.373073	47721
32505	49	2016-06-27 21:23:51.381327	47706
32506	49	2016-06-27 21:23:51.388637	47727
32507	49	2016-06-27 21:23:51.395341	47730
32508	49	2016-06-27 21:23:51.402746	47721
32509	49	2016-06-27 21:23:51.409392	47733
32510	49	2016-06-27 21:23:51.416687	47709
32511	48	2016-06-27 21:23:51.425352	2851
32512	48	2016-06-27 21:23:51.432265	2859
32513	48	2016-06-27 21:23:51.438965	2843
32514	48	2016-06-27 21:23:51.446509	2855
32515	48	2016-06-27 21:23:51.454517	2872
32516	48	2016-06-27 21:23:51.461176	2861
32517	48	2016-06-27 21:23:51.469203	2849
32518	48	2016-06-27 21:23:51.475874	2853
32519	48	2016-06-27 21:23:51.484158	2878
32520	48	2016-06-27 21:23:51.492023	2834
32521	48	2016-06-27 21:23:51.499345	2847
32522	48	2016-06-27 21:23:51.507196	2874
32523	48	2016-06-27 21:23:51.514006	2863
32524	48	2016-06-27 21:23:51.521795	2845
32525	50	2016-06-27 21:23:51.530529	47706
32526	50	2016-06-27 21:23:51.539334	47727
32527	50	2016-06-27 21:23:51.547506	47730
32528	50	2016-06-27 21:23:51.555393	47721
32529	50	2016-06-27 21:23:51.563093	47733
32530	50	2016-06-27 21:23:51.571125	47709
32531	47	2016-06-27 21:23:51.579266	2851
32532	47	2016-06-27 21:23:51.586434	2859
32533	47	2016-06-27 21:23:51.593782	2843
32534	47	2016-06-27 21:23:51.601616	2855
32535	47	2016-06-27 21:23:51.609038	2872
32536	47	2016-06-27 21:23:51.61554	2861
32537	47	2016-06-27 21:23:51.622841	2849
32538	47	2016-06-27 21:23:51.629887	2853
32539	47	2016-06-27 21:23:51.638149	2878
32540	47	2016-06-27 21:23:51.645977	2834
32541	47	2016-06-27 21:23:51.653215	2847
32542	47	2016-06-27 21:23:51.660677	2874
32543	47	2016-06-27 21:23:51.667625	2863
32544	47	2016-06-27 21:23:51.674651	2845
32545	41	2016-06-27 21:26:37.819505	2858
32546	41	2016-06-27 21:26:37.827281	2865
32547	41	2016-06-27 21:26:37.835198	2866
32548	44	2016-06-27 21:26:37.843503	2869
32549	42	2016-06-27 21:26:37.850856	2849
32550	42	2016-06-27 21:26:37.857668	2834
32551	42	2016-06-27 21:26:37.864762	2855
32552	42	2016-06-27 21:26:37.871885	2874
32553	42	2016-06-27 21:26:37.880575	2878
32554	42	2016-06-27 21:26:37.887917	2847
32555	42	2016-06-27 21:26:37.895899	2851
32556	42	2016-06-27 21:26:37.902521	2872
32557	43	2016-06-27 21:26:37.909743	2848
32558	43	2016-06-27 21:26:37.916731	2835
32559	43	2016-06-27 21:26:37.923432	2852
32560	43	2016-06-27 21:26:37.93175	2856
32561	43	2016-06-27 21:26:37.938376	2873
32562	43	2016-06-27 21:26:37.945462	2879
32563	43	2016-06-27 21:26:37.952234	2850
32564	43	2016-06-27 21:26:37.95904	2875
32565	40	2016-06-27 21:26:37.98469	47733
32566	40	2016-06-27 21:26:37.991121	47730
32567	40	2016-06-27 21:26:37.997571	47706
32568	40	2016-06-27 21:26:38.003774	47709
32569	40	2016-06-27 21:26:38.009983	47727
32570	40	2016-06-27 21:26:38.016915	47721
32571	49	2016-06-27 21:26:38.025352	47706
32572	49	2016-06-27 21:26:38.032209	47727
32573	49	2016-06-27 21:26:38.039583	47730
32574	49	2016-06-27 21:26:38.046797	47721
32575	49	2016-06-27 21:26:38.053757	47733
32576	49	2016-06-27 21:26:38.060483	47709
32577	48	2016-06-27 21:26:38.068932	2851
32578	48	2016-06-27 21:26:38.076187	2859
32579	48	2016-06-27 21:26:38.082825	2843
32580	48	2016-06-27 21:26:38.091692	2855
32581	48	2016-06-27 21:26:38.099049	2872
32582	48	2016-06-27 21:26:38.105541	2861
32583	48	2016-06-27 21:26:38.113329	2849
32584	48	2016-06-27 21:26:38.120176	2853
32585	48	2016-06-27 21:26:38.127536	2878
32586	48	2016-06-27 21:26:38.137724	2834
32587	48	2016-06-27 21:26:38.145677	2847
32588	48	2016-06-27 21:26:38.153065	2874
32589	48	2016-06-27 21:26:38.1599	2863
32590	48	2016-06-27 21:26:38.166963	2845
32591	50	2016-06-27 21:26:38.174791	47706
32592	50	2016-06-27 21:26:38.18204	47727
32593	50	2016-06-27 21:26:38.189441	47730
32594	50	2016-06-27 21:26:38.196419	47721
32595	50	2016-06-27 21:26:38.204585	47733
32596	50	2016-06-27 21:26:38.211993	47709
32597	47	2016-06-27 21:26:38.220133	2851
32598	47	2016-06-27 21:26:38.227381	2859
32599	47	2016-06-27 21:26:38.234103	2843
32600	47	2016-06-27 21:26:38.241645	2855
32601	47	2016-06-27 21:26:38.248967	2872
32602	47	2016-06-27 21:26:38.256126	2861
32603	47	2016-06-27 21:26:38.263642	2849
32604	47	2016-06-27 21:26:38.270835	2853
32605	47	2016-06-27 21:26:38.278146	2878
32606	47	2016-06-27 21:26:38.286064	2834
32607	47	2016-06-27 21:26:38.294431	2847
32608	47	2016-06-27 21:26:38.302254	2874
32609	47	2016-06-27 21:26:38.309048	2863
32610	47	2016-06-27 21:26:38.316216	2845
32611	41	2016-06-28 00:01:36.196437	2858
32612	41	2016-06-28 00:01:36.204301	2865
32613	41	2016-06-28 00:01:36.214567	2866
32614	44	2016-06-28 00:01:36.238104	2869
32615	42	2016-06-28 00:01:36.245754	2849
32616	42	2016-06-28 00:01:36.252569	2834
32617	42	2016-06-28 00:01:36.259129	2855
32618	42	2016-06-28 00:01:36.265863	2874
32619	42	2016-06-28 00:01:36.272635	2878
32620	42	2016-06-28 00:01:36.280159	2847
32621	42	2016-06-28 00:01:36.28699	2851
32622	42	2016-06-28 00:01:36.293562	2872
32623	43	2016-06-28 00:01:36.30075	2848
32624	43	2016-06-28 00:01:36.30747	2835
32625	43	2016-06-28 00:01:36.314892	2852
32626	43	2016-06-28 00:01:36.321714	2856
32627	43	2016-06-28 00:01:36.328182	2873
32628	43	2016-06-28 00:01:36.334882	2879
32629	43	2016-06-28 00:01:36.341517	2850
32630	43	2016-06-28 00:01:36.348476	2875
32631	40	2016-06-28 00:01:36.355903	47733
32632	40	2016-06-28 00:01:36.362127	47730
32633	40	2016-06-28 00:01:36.368526	47706
32634	40	2016-06-28 00:01:36.374571	47709
32635	40	2016-06-28 00:01:36.381164	47727
32636	40	2016-06-28 00:01:36.387315	47721
32637	49	2016-06-28 00:01:36.397624	47706
32638	49	2016-06-28 00:01:36.404765	47727
32639	49	2016-06-28 00:01:36.411513	47730
32640	49	2016-06-28 00:01:36.418401	47721
32641	49	2016-06-28 00:01:36.42523	47733
32642	49	2016-06-28 00:01:36.432508	47709
32643	48	2016-06-28 00:01:36.44098	2851
32644	48	2016-06-28 00:01:36.447717	2859
32645	48	2016-06-28 00:01:36.455716	2843
32646	48	2016-06-28 00:01:36.463718	2855
32647	48	2016-06-28 00:01:36.471138	2872
32648	48	2016-06-28 00:01:36.47781	2861
32649	48	2016-06-28 00:01:36.485669	2849
32650	48	2016-06-28 00:01:36.492499	2853
32651	48	2016-06-28 00:01:36.500402	2878
32652	48	2016-06-28 00:01:36.50797	2834
32653	48	2016-06-28 00:01:36.515544	2847
32654	48	2016-06-28 00:01:36.522895	2874
32655	48	2016-06-28 00:01:36.530007	2863
32656	48	2016-06-28 00:01:36.53738	2845
32657	50	2016-06-28 00:01:36.545478	47706
32658	50	2016-06-28 00:01:36.552792	47727
32659	50	2016-06-28 00:01:36.560121	47730
32660	50	2016-06-28 00:01:36.570707	47721
32661	50	2016-06-28 00:01:36.57834	47733
32662	50	2016-06-28 00:01:36.585472	47709
32663	47	2016-06-28 00:01:36.594364	2851
32664	47	2016-06-28 00:01:36.601289	2859
32665	47	2016-06-28 00:01:36.608207	2843
32666	47	2016-06-28 00:01:36.616037	2855
32667	47	2016-06-28 00:01:36.623312	2872
32668	47	2016-06-28 00:01:36.629962	2861
32669	47	2016-06-28 00:01:36.637451	2849
32670	47	2016-06-28 00:01:36.644208	2853
32671	47	2016-06-28 00:01:36.652097	2878
32672	47	2016-06-28 00:01:36.660225	2834
32673	47	2016-06-28 00:01:36.668118	2847
32674	47	2016-06-28 00:01:36.675334	2874
32675	47	2016-06-28 00:01:36.682521	2863
32676	47	2016-06-28 00:01:36.689417	2845
32677	41	2016-06-28 00:04:23.759785	2858
32678	41	2016-06-28 00:04:23.767896	2865
32679	41	2016-06-28 00:04:23.775372	2866
32680	44	2016-06-28 00:04:23.784175	2869
32681	42	2016-06-28 00:04:23.791197	2849
32682	42	2016-06-28 00:04:23.798909	2834
32683	42	2016-06-28 00:04:23.805626	2855
32684	42	2016-06-28 00:04:23.81217	2874
32685	42	2016-06-28 00:04:23.81923	2878
32686	42	2016-06-28 00:04:23.826095	2847
32687	42	2016-06-28 00:04:23.83275	2851
32688	42	2016-06-28 00:04:23.840806	2872
32689	43	2016-06-28 00:04:23.848241	2848
32690	43	2016-06-28 00:04:23.855938	2835
32691	43	2016-06-28 00:04:23.864506	2852
32692	43	2016-06-28 00:04:23.874294	2856
32693	43	2016-06-28 00:04:23.882175	2873
32694	43	2016-06-28 00:04:23.889413	2879
32695	43	2016-06-28 00:04:23.896358	2850
32696	43	2016-06-28 00:04:23.902926	2875
32697	40	2016-06-28 00:04:23.937926	47733
32698	40	2016-06-28 00:04:23.945639	47730
32699	40	2016-06-28 00:04:23.955181	47706
32700	40	2016-06-28 00:04:23.963176	47709
32701	40	2016-06-28 00:04:23.971814	47727
32702	40	2016-06-28 00:04:23.978009	47721
32703	49	2016-06-28 00:04:23.986834	47706
32704	49	2016-06-28 00:04:23.993735	47727
32705	49	2016-06-28 00:04:24.001541	47730
32706	49	2016-06-28 00:04:24.008289	47721
32707	49	2016-06-28 00:04:24.015099	47733
32708	49	2016-06-28 00:04:24.021681	47709
32709	48	2016-06-28 00:04:24.030319	2851
32710	48	2016-06-28 00:04:24.03731	2859
32711	48	2016-06-28 00:04:24.044026	2843
32712	48	2016-06-28 00:04:24.052658	2855
32713	48	2016-06-28 00:04:24.060852	2872
32714	48	2016-06-28 00:04:24.0686	2861
32715	48	2016-06-28 00:04:24.076914	2849
32716	48	2016-06-28 00:04:24.084231	2853
32717	48	2016-06-28 00:04:24.091811	2878
32718	48	2016-06-28 00:04:24.099276	2834
32719	48	2016-06-28 00:04:24.106791	2847
32720	48	2016-06-28 00:04:24.114171	2874
32721	48	2016-06-28 00:04:24.120838	2863
32722	48	2016-06-28 00:04:24.127545	2845
32723	50	2016-06-28 00:04:24.136065	47706
32724	50	2016-06-28 00:04:24.143422	47727
32725	50	2016-06-28 00:04:24.150929	47730
32726	50	2016-06-28 00:04:24.158032	47721
32727	50	2016-06-28 00:04:24.165101	47733
32728	50	2016-06-28 00:04:24.172193	47709
32729	47	2016-06-28 00:04:24.181163	2851
32730	47	2016-06-28 00:04:24.188167	2859
32731	47	2016-06-28 00:04:24.194902	2843
32732	47	2016-06-28 00:04:24.202312	2855
32733	47	2016-06-28 00:04:24.209648	2872
32734	47	2016-06-28 00:04:24.216943	2861
32735	47	2016-06-28 00:04:24.224523	2849
32736	47	2016-06-28 00:04:24.231884	2853
32737	47	2016-06-28 00:04:24.240533	2878
32738	47	2016-06-28 00:04:24.248199	2834
32739	47	2016-06-28 00:04:24.255912	2847
32740	47	2016-06-28 00:04:24.263733	2874
32741	47	2016-06-28 00:04:24.270705	2863
32742	47	2016-06-28 00:04:24.278509	2845
32743	41	2016-06-28 00:05:36.545704	2858
32744	41	2016-06-28 00:05:36.560185	2865
32745	41	2016-06-28 00:05:36.573421	2866
32746	44	2016-06-28 00:05:36.587286	2869
32747	42	2016-06-28 00:05:36.599536	2849
32748	42	2016-06-28 00:05:36.611364	2834
32749	42	2016-06-28 00:05:36.622988	2855
32750	42	2016-06-28 00:05:36.634205	2874
32751	42	2016-06-28 00:05:36.644649	2878
32752	42	2016-06-28 00:05:36.673686	2847
32753	42	2016-06-28 00:05:36.688779	2851
32754	42	2016-06-28 00:05:36.700566	2872
32755	43	2016-06-28 00:05:36.711575	2848
32756	43	2016-06-28 00:05:36.721711	2835
32757	43	2016-06-28 00:05:36.731591	2852
32758	43	2016-06-28 00:05:36.741701	2856
32759	43	2016-06-28 00:05:36.75078	2873
32760	43	2016-06-28 00:05:36.760967	2879
32761	43	2016-06-28 00:05:36.770948	2850
32762	43	2016-06-28 00:05:36.805356	2875
32763	40	2016-06-28 00:05:36.818106	47733
32764	40	2016-06-28 00:05:36.949537	47730
32765	40	2016-06-28 00:05:37.026849	47706
32766	40	2016-06-28 00:05:37.14565	47709
32767	40	2016-06-28 00:05:37.188505	47727
32768	40	2016-06-28 00:05:37.238832	47721
32769	49	2016-06-28 00:05:37.309383	47706
32770	49	2016-06-28 00:05:37.350743	47727
32771	49	2016-06-28 00:05:37.360725	47730
32772	49	2016-06-28 00:05:37.370306	47721
32773	49	2016-06-28 00:05:37.380017	47733
32774	49	2016-06-28 00:05:37.389936	47709
32775	48	2016-06-28 00:05:37.401821	2851
32776	48	2016-06-28 00:05:37.410745	2859
32777	48	2016-06-28 00:05:37.420643	2843
32778	48	2016-06-28 00:05:37.430815	2855
32779	48	2016-06-28 00:05:37.44127	2872
32780	48	2016-06-28 00:05:37.450465	2861
32781	48	2016-06-28 00:05:37.461129	2849
32782	48	2016-06-28 00:05:37.469696	2853
32783	48	2016-06-28 00:05:37.479129	2878
32784	48	2016-06-28 00:05:37.48923	2834
32785	48	2016-06-28 00:05:37.498769	2847
32786	48	2016-06-28 00:05:37.508592	2874
32787	48	2016-06-28 00:05:37.517271	2863
32788	48	2016-06-28 00:05:37.526208	2845
32789	50	2016-06-28 00:05:37.536001	47706
32790	50	2016-06-28 00:05:37.545322	47727
32791	50	2016-06-28 00:05:37.554206	47730
32792	50	2016-06-28 00:05:37.563119	47721
32793	50	2016-06-28 00:05:37.572297	47733
32794	50	2016-06-28 00:05:37.581111	47709
32795	47	2016-06-28 00:05:37.59126	2851
32796	47	2016-06-28 00:05:37.599523	2859
32797	47	2016-06-28 00:05:37.608709	2843
32798	47	2016-06-28 00:05:37.618029	2855
32799	47	2016-06-28 00:05:37.626715	2872
32800	47	2016-06-28 00:05:37.633521	2861
32801	47	2016-06-28 00:05:37.641207	2849
32802	47	2016-06-28 00:05:37.64804	2853
32803	47	2016-06-28 00:05:37.655145	2878
32804	47	2016-06-28 00:05:37.662671	2834
32805	47	2016-06-28 00:05:37.670018	2847
32806	47	2016-06-28 00:05:37.677165	2874
32807	47	2016-06-28 00:05:37.686443	2863
32808	47	2016-06-28 00:05:37.693619	2845
32809	41	2016-06-28 00:07:33.419302	2858
32810	41	2016-06-28 00:07:33.428423	2865
32811	41	2016-06-28 00:07:33.436842	2866
32812	44	2016-06-28 00:07:33.445825	2869
32813	42	2016-06-28 00:07:33.452952	2849
32814	42	2016-06-28 00:07:33.460246	2834
32815	42	2016-06-28 00:07:33.467496	2855
32816	42	2016-06-28 00:07:33.474367	2874
32817	42	2016-06-28 00:07:33.48197	2878
32818	42	2016-06-28 00:07:33.488868	2847
32819	42	2016-06-28 00:07:33.496362	2851
32820	42	2016-06-28 00:07:33.503307	2872
32821	43	2016-06-28 00:07:33.510845	2848
32822	43	2016-06-28 00:07:33.517741	2835
32823	43	2016-06-28 00:07:33.524995	2852
32824	43	2016-06-28 00:07:33.532429	2856
32825	43	2016-06-28 00:07:33.53917	2873
32826	43	2016-06-28 00:07:33.546389	2879
32827	43	2016-06-28 00:07:33.553326	2850
32828	43	2016-06-28 00:07:33.560336	2875
32829	40	2016-06-28 00:07:33.568696	47733
32830	40	2016-06-28 00:07:33.575959	47730
32831	40	2016-06-28 00:07:33.583198	47706
32832	40	2016-06-28 00:07:33.589638	47709
32833	40	2016-06-28 00:07:33.596576	47727
32834	40	2016-06-28 00:07:33.603051	47721
32835	49	2016-06-28 00:07:33.61178	47706
32836	49	2016-06-28 00:07:33.61961	47727
32837	49	2016-06-28 00:07:33.626787	47730
32838	49	2016-06-28 00:07:33.634283	47721
32839	49	2016-06-28 00:07:33.641216	47733
32840	49	2016-06-28 00:07:33.648764	47709
32841	48	2016-06-28 00:07:33.657985	2851
32842	48	2016-06-28 00:07:33.664991	2859
32843	48	2016-06-28 00:07:33.672642	2843
32844	48	2016-06-28 00:07:33.680775	2855
32845	48	2016-06-28 00:07:33.688729	2872
32846	48	2016-06-28 00:07:33.695646	2861
32847	48	2016-06-28 00:07:33.703611	2849
32848	48	2016-06-28 00:07:33.71122	2853
32849	48	2016-06-28 00:07:33.719183	2878
32850	48	2016-06-28 00:07:33.727216	2834
32851	48	2016-06-28 00:07:33.735653	2847
32852	48	2016-06-28 00:07:33.743239	2874
32853	48	2016-06-28 00:07:33.750681	2863
32854	48	2016-06-28 00:07:33.757953	2845
32855	50	2016-06-28 00:07:33.766779	47706
32856	50	2016-06-28 00:07:33.776121	47727
32857	50	2016-06-28 00:07:33.784209	47730
32858	50	2016-06-28 00:07:33.792609	47721
32859	50	2016-06-28 00:07:33.800514	47733
32860	50	2016-06-28 00:07:33.808457	47709
32861	47	2016-06-28 00:07:33.817197	2851
32862	47	2016-06-28 00:07:33.824647	2859
32863	47	2016-06-28 00:07:33.832243	2843
32864	47	2016-06-28 00:07:33.840406	2855
32865	47	2016-06-28 00:07:33.848024	2872
32866	47	2016-06-28 00:07:33.85508	2861
32867	47	2016-06-28 00:07:33.863255	2849
32868	47	2016-06-28 00:07:33.870631	2853
32869	47	2016-06-28 00:07:33.878885	2878
32870	47	2016-06-28 00:07:33.886759	2834
32871	47	2016-06-28 00:07:33.894952	2847
32872	47	2016-06-28 00:07:33.903127	2874
32873	47	2016-06-28 00:07:33.910614	2863
32874	47	2016-06-28 00:07:33.918129	2845
32875	41	2016-06-28 00:08:36.476343	2858
32876	41	2016-06-28 00:08:36.484367	2865
32877	41	2016-06-28 00:08:36.491807	2866
32878	44	2016-06-28 00:08:36.500082	2869
32879	42	2016-06-28 00:08:36.506837	2849
32880	42	2016-06-28 00:08:36.514261	2834
32881	42	2016-06-28 00:08:36.520931	2855
32882	42	2016-06-28 00:08:36.5284	2874
32883	42	2016-06-28 00:08:36.535172	2878
32884	42	2016-06-28 00:08:36.541933	2847
32885	42	2016-06-28 00:08:36.54837	2851
32886	42	2016-06-28 00:08:36.555125	2872
32887	43	2016-06-28 00:08:36.562988	2848
32888	43	2016-06-28 00:08:36.569572	2835
32889	43	2016-06-28 00:08:36.57926	2852
32890	43	2016-06-28 00:08:36.586786	2856
32891	43	2016-06-28 00:08:36.593252	2873
32892	43	2016-06-28 00:08:36.600331	2879
32893	43	2016-06-28 00:08:36.607136	2850
32894	43	2016-06-28 00:08:36.61463	2875
32895	40	2016-06-28 00:08:36.622915	47733
32896	40	2016-06-28 00:08:36.629513	47730
32897	40	2016-06-28 00:08:36.635942	47706
32898	40	2016-06-28 00:08:36.64266	47709
32899	40	2016-06-28 00:08:36.649463	47727
32900	40	2016-06-28 00:08:36.65643	47721
32901	49	2016-06-28 00:08:36.665152	47706
32902	49	2016-06-28 00:08:36.672592	47727
32903	49	2016-06-28 00:08:36.679982	47730
32904	49	2016-06-28 00:08:36.687357	47721
32905	49	2016-06-28 00:08:36.694774	47733
32906	49	2016-06-28 00:08:36.702062	47709
32907	48	2016-06-28 00:08:36.711431	2851
32908	48	2016-06-28 00:08:36.718524	2859
32909	48	2016-06-28 00:08:36.726169	2843
32910	48	2016-06-28 00:08:36.733994	2855
32911	48	2016-06-28 00:08:36.742048	2872
32912	48	2016-06-28 00:08:36.749461	2861
32913	48	2016-06-28 00:08:36.758335	2849
32914	48	2016-06-28 00:08:36.765812	2853
32915	48	2016-06-28 00:08:36.773797	2878
32916	48	2016-06-28 00:08:36.782118	2834
32917	48	2016-06-28 00:08:36.79091	2847
32918	48	2016-06-28 00:08:36.798746	2874
32919	48	2016-06-28 00:08:36.806201	2863
32920	48	2016-06-28 00:08:36.813685	2845
32921	50	2016-06-28 00:08:36.821836	47706
32922	50	2016-06-28 00:08:36.829071	47727
32923	50	2016-06-28 00:08:36.836485	47730
32924	50	2016-06-28 00:08:36.843679	47721
32925	50	2016-06-28 00:08:36.850729	47733
32926	50	2016-06-28 00:08:36.858258	47709
32927	47	2016-06-28 00:08:36.866676	2851
32928	47	2016-06-28 00:08:36.873363	2859
32929	47	2016-06-28 00:08:36.880143	2843
32930	47	2016-06-28 00:08:36.887417	2855
32931	47	2016-06-28 00:08:36.894885	2872
32932	47	2016-06-28 00:08:36.901718	2861
32933	47	2016-06-28 00:08:36.909097	2849
32934	47	2016-06-28 00:08:36.915993	2853
32935	47	2016-06-28 00:08:36.923179	2878
32936	47	2016-06-28 00:08:36.930795	2834
32937	47	2016-06-28 00:08:36.938139	2847
32938	47	2016-06-28 00:08:36.94555	2874
32939	47	2016-06-28 00:08:36.952253	2863
32940	47	2016-06-28 00:08:36.959428	2845
32941	41	2016-06-28 00:11:36.435883	2858
32942	41	2016-06-28 00:11:36.460558	2865
32943	41	2016-06-28 00:11:36.468863	2866
32944	44	2016-06-28 00:11:36.47682	2869
32945	42	2016-06-28 00:11:36.484044	2849
32946	42	2016-06-28 00:11:36.49047	2834
32947	42	2016-06-28 00:11:36.496994	2855
32948	42	2016-06-28 00:11:36.503357	2874
32949	42	2016-06-28 00:11:36.510125	2878
32950	42	2016-06-28 00:11:36.516817	2847
32951	42	2016-06-28 00:11:36.523636	2851
32952	42	2016-06-28 00:11:36.530299	2872
32953	43	2016-06-28 00:11:36.537174	2848
32954	43	2016-06-28 00:11:36.543982	2835
32955	43	2016-06-28 00:11:36.571762	2852
32956	43	2016-06-28 00:11:36.57948	2856
32957	43	2016-06-28 00:11:36.586573	2873
32958	43	2016-06-28 00:11:36.593347	2879
32959	43	2016-06-28 00:11:36.600246	2850
32960	43	2016-06-28 00:11:36.606769	2875
32961	40	2016-06-28 00:11:36.61451	47733
32962	40	2016-06-28 00:11:36.620852	47730
32963	40	2016-06-28 00:11:36.627097	47706
32964	40	2016-06-28 00:11:36.633397	47709
32965	40	2016-06-28 00:11:36.639484	47727
32966	40	2016-06-28 00:11:36.645653	47721
32967	49	2016-06-28 00:11:36.654365	47706
32968	49	2016-06-28 00:11:36.661306	47727
32969	49	2016-06-28 00:11:36.668261	47730
32970	49	2016-06-28 00:11:36.674916	47721
32971	49	2016-06-28 00:11:36.681764	47733
32972	49	2016-06-28 00:11:36.688637	47709
32973	48	2016-06-28 00:11:36.697214	2851
32974	48	2016-06-28 00:11:36.704269	2859
32975	48	2016-06-28 00:11:36.711412	2843
32976	48	2016-06-28 00:11:36.718842	2855
32977	48	2016-06-28 00:11:36.726336	2872
32978	48	2016-06-28 00:11:36.733383	2861
32979	48	2016-06-28 00:11:36.740842	2849
32980	48	2016-06-28 00:11:36.747742	2853
32981	48	2016-06-28 00:11:36.755841	2878
32982	48	2016-06-28 00:11:36.787592	2834
32983	48	2016-06-28 00:11:36.795814	2847
32984	48	2016-06-28 00:11:36.803789	2874
32985	48	2016-06-28 00:11:36.810674	2863
32986	48	2016-06-28 00:11:36.817663	2845
32987	50	2016-06-28 00:11:36.825688	47706
32988	50	2016-06-28 00:11:36.832758	47727
32989	50	2016-06-28 00:11:36.839784	47730
32990	50	2016-06-28 00:11:36.846956	47721
32991	50	2016-06-28 00:11:36.854436	47733
32992	50	2016-06-28 00:11:36.861481	47709
32993	47	2016-06-28 00:11:36.869947	2851
32994	47	2016-06-28 00:11:36.87679	2859
32995	47	2016-06-28 00:11:36.88374	2843
32996	47	2016-06-28 00:11:36.891129	2855
32997	47	2016-06-28 00:11:36.898319	2872
32998	47	2016-06-28 00:11:36.904965	2861
32999	47	2016-06-28 00:11:36.912222	2849
33000	47	2016-06-28 00:11:36.919279	2853
33001	47	2016-06-28 00:11:36.926579	2878
33002	47	2016-06-28 00:11:36.934106	2834
33003	47	2016-06-28 00:11:36.941866	2847
33004	47	2016-06-28 00:11:36.949422	2874
33005	47	2016-06-28 00:11:36.956537	2863
33006	47	2016-06-28 00:11:36.963565	2845
33007	41	2016-06-28 00:12:55.048595	2858
33008	41	2016-06-28 00:12:55.056058	2865
33009	41	2016-06-28 00:12:55.06356	2866
33010	44	2016-06-28 00:12:55.071572	2869
33011	42	2016-06-28 00:12:55.079153	2849
33012	42	2016-06-28 00:12:55.08583	2834
33013	42	2016-06-28 00:12:55.092289	2855
33014	42	2016-06-28 00:12:55.099186	2874
33015	42	2016-06-28 00:12:55.105769	2878
33016	42	2016-06-28 00:12:55.112321	2847
33017	42	2016-06-28 00:12:55.119186	2851
33018	42	2016-06-28 00:12:55.126597	2872
33019	43	2016-06-28 00:12:55.134545	2848
33020	43	2016-06-28 00:12:55.140983	2835
33021	43	2016-06-28 00:12:55.147857	2852
33022	43	2016-06-28 00:12:55.154565	2856
33023	43	2016-06-28 00:12:55.160899	2873
33024	43	2016-06-28 00:12:55.167497	2879
33025	43	2016-06-28 00:12:55.173864	2850
33026	43	2016-06-28 00:12:55.180541	2875
33027	40	2016-06-28 00:12:55.188448	47733
33028	40	2016-06-28 00:12:55.194546	47730
33029	40	2016-06-28 00:12:55.200942	47706
33030	40	2016-06-28 00:12:55.206986	47709
33031	40	2016-06-28 00:12:55.212996	47727
33032	40	2016-06-28 00:12:55.218965	47721
33033	49	2016-06-28 00:12:55.227239	47706
33034	49	2016-06-28 00:12:55.235012	47727
33035	49	2016-06-28 00:12:55.242797	47730
33036	49	2016-06-28 00:12:55.250044	47721
33037	49	2016-06-28 00:12:55.256784	47733
33038	49	2016-06-28 00:12:55.264042	47709
33039	48	2016-06-28 00:12:55.272398	2851
33040	48	2016-06-28 00:12:55.279323	2859
33041	48	2016-06-28 00:12:55.286221	2843
33042	48	2016-06-28 00:12:55.293826	2855
33043	48	2016-06-28 00:12:55.301612	2872
33044	48	2016-06-28 00:12:55.308405	2861
33045	48	2016-06-28 00:12:55.316253	2849
33046	48	2016-06-28 00:12:55.323699	2853
33047	48	2016-06-28 00:12:55.331911	2878
33048	48	2016-06-28 00:12:55.34036	2834
33049	48	2016-06-28 00:12:55.348679	2847
33050	48	2016-06-28 00:12:55.35697	2874
33051	48	2016-06-28 00:12:55.364004	2863
33052	48	2016-06-28 00:12:55.370951	2845
33053	50	2016-06-28 00:12:55.380183	47706
33054	50	2016-06-28 00:12:55.387809	47727
33055	50	2016-06-28 00:12:55.395924	47730
33056	50	2016-06-28 00:12:55.403712	47721
33057	50	2016-06-28 00:12:55.411807	47733
33058	50	2016-06-28 00:12:55.419466	47709
33059	47	2016-06-28 00:12:55.428792	2851
33060	47	2016-06-28 00:12:55.43642	2859
33061	47	2016-06-28 00:12:55.443845	2843
33062	47	2016-06-28 00:12:55.451702	2855
33063	47	2016-06-28 00:12:55.459716	2872
33064	47	2016-06-28 00:12:55.466829	2861
33065	47	2016-06-28 00:12:55.474883	2849
33066	47	2016-06-28 00:12:55.482031	2853
33067	47	2016-06-28 00:12:55.490006	2878
33068	47	2016-06-28 00:12:55.497777	2834
33069	47	2016-06-28 00:12:55.505973	2847
33070	47	2016-06-28 00:12:55.513456	2874
33071	47	2016-06-28 00:12:55.520224	2863
33072	47	2016-06-28 00:12:55.527898	2845
33073	41	2016-06-28 00:16:54.440183	2858
33074	41	2016-06-28 00:16:54.448121	2865
33075	41	2016-06-28 00:16:54.45551	2866
33076	44	2016-06-28 00:16:54.464122	2869
33077	42	2016-06-28 00:16:54.471056	2849
33078	42	2016-06-28 00:16:54.477778	2834
33079	42	2016-06-28 00:16:54.484788	2855
33080	42	2016-06-28 00:16:54.491666	2874
33081	42	2016-06-28 00:16:54.498582	2878
33082	42	2016-06-28 00:16:54.505178	2847
33083	42	2016-06-28 00:16:54.511684	2851
33084	42	2016-06-28 00:16:54.51844	2872
33085	43	2016-06-28 00:16:54.525295	2848
33086	43	2016-06-28 00:16:54.532074	2835
33087	43	2016-06-28 00:16:54.538636	2852
33088	43	2016-06-28 00:16:54.545657	2856
33089	43	2016-06-28 00:16:54.552202	2873
33090	43	2016-06-28 00:16:54.558865	2879
33091	43	2016-06-28 00:16:54.56531	2850
33092	43	2016-06-28 00:16:54.571918	2875
33093	40	2016-06-28 00:16:54.579896	47733
33094	40	2016-06-28 00:16:54.586272	47730
33095	40	2016-06-28 00:16:54.592446	47706
33096	40	2016-06-28 00:16:54.598524	47709
33097	40	2016-06-28 00:16:54.604722	47727
33098	40	2016-06-28 00:16:54.635926	47721
33099	49	2016-06-28 00:16:54.645742	47706
33100	49	2016-06-28 00:16:54.662127	47727
33101	49	2016-06-28 00:16:54.705006	47730
33102	49	2016-06-28 00:16:54.73837	47721
33103	49	2016-06-28 00:16:54.761287	47733
33104	49	2016-06-28 00:16:54.768314	47709
33105	48	2016-06-28 00:16:54.779596	2851
33106	48	2016-06-28 00:16:54.787635	2859
33107	48	2016-06-28 00:16:54.795223	2843
33108	48	2016-06-28 00:16:54.802891	2855
33109	48	2016-06-28 00:16:54.810451	2872
33110	48	2016-06-28 00:16:54.817348	2861
33111	48	2016-06-28 00:16:54.824614	2849
33112	48	2016-06-28 00:16:54.831939	2853
33113	48	2016-06-28 00:16:54.839824	2878
33114	48	2016-06-28 00:16:54.847712	2834
33115	48	2016-06-28 00:16:54.855356	2847
33116	48	2016-06-28 00:16:54.862962	2874
33117	48	2016-06-28 00:16:54.869953	2863
33118	48	2016-06-28 00:16:54.877311	2845
33119	50	2016-06-28 00:16:54.88798	47706
33120	50	2016-06-28 00:16:54.897081	47727
33121	50	2016-06-28 00:16:54.906123	47730
33122	50	2016-06-28 00:16:54.914648	47721
33123	50	2016-06-28 00:16:54.92231	47733
33124	50	2016-06-28 00:16:54.930537	47709
33125	47	2016-06-28 00:16:54.939285	2851
33126	47	2016-06-28 00:16:54.946643	2859
33127	47	2016-06-28 00:16:54.953503	2843
33128	47	2016-06-28 00:16:54.961059	2855
33129	47	2016-06-28 00:16:54.968366	2872
33130	47	2016-06-28 00:16:54.975249	2861
33131	47	2016-06-28 00:16:54.98399	2849
33132	47	2016-06-28 00:16:54.991418	2853
33133	47	2016-06-28 00:16:54.99913	2878
33134	47	2016-06-28 00:16:55.007307	2834
33135	47	2016-06-28 00:16:55.015452	2847
33136	47	2016-06-28 00:16:55.024786	2874
33137	47	2016-06-28 00:16:55.033437	2863
33138	47	2016-06-28 00:16:55.043136	2845
33139	41	2016-06-28 00:18:41.159476	2858
33140	41	2016-06-28 00:18:41.167484	2865
33141	41	2016-06-28 00:18:41.175228	2866
33142	44	2016-06-28 00:18:41.183614	2869
33143	42	2016-06-28 00:18:41.190769	2849
33144	42	2016-06-28 00:18:41.197431	2834
33145	42	2016-06-28 00:18:41.204075	2855
33146	42	2016-06-28 00:18:41.210616	2874
33147	42	2016-06-28 00:18:41.218383	2878
33148	42	2016-06-28 00:18:41.225278	2847
33149	42	2016-06-28 00:18:41.232401	2851
33150	42	2016-06-28 00:18:41.238992	2872
33151	43	2016-06-28 00:18:41.245975	2848
33152	43	2016-06-28 00:18:41.252528	2835
33153	43	2016-06-28 00:18:41.259447	2852
33154	43	2016-06-28 00:18:41.265948	2856
33155	43	2016-06-28 00:18:41.272296	2873
33156	43	2016-06-28 00:18:41.279029	2879
33157	43	2016-06-28 00:18:41.285536	2850
33158	43	2016-06-28 00:18:41.292114	2875
33159	40	2016-06-28 00:18:41.299891	47733
33160	40	2016-06-28 00:18:41.306349	47730
33161	40	2016-06-28 00:18:41.312463	47706
33162	40	2016-06-28 00:18:41.319185	47709
33163	40	2016-06-28 00:18:41.325841	47727
33164	40	2016-06-28 00:18:41.332063	47721
33165	49	2016-06-28 00:18:41.340678	47706
33166	49	2016-06-28 00:18:41.348117	47727
33167	49	2016-06-28 00:18:41.355669	47730
33168	49	2016-06-28 00:18:41.362929	47721
33169	49	2016-06-28 00:18:41.370501	47733
33170	49	2016-06-28 00:18:41.378107	47709
33171	48	2016-06-28 00:18:41.387162	2851
33172	48	2016-06-28 00:18:41.39446	2859
33173	48	2016-06-28 00:18:41.402176	2843
33174	48	2016-06-28 00:18:41.410876	2855
33175	48	2016-06-28 00:18:41.418719	2872
33176	48	2016-06-28 00:18:41.426367	2861
33177	48	2016-06-28 00:18:41.434293	2849
33178	48	2016-06-28 00:18:41.442032	2853
33179	48	2016-06-28 00:18:41.45036	2878
33180	48	2016-06-28 00:18:41.459362	2834
33181	48	2016-06-28 00:18:41.467471	2847
33182	48	2016-06-28 00:18:41.475951	2874
33183	48	2016-06-28 00:18:41.483022	2863
33184	48	2016-06-28 00:18:41.490591	2845
33185	50	2016-06-28 00:18:41.499498	47706
33186	50	2016-06-28 00:18:41.507305	47727
33187	50	2016-06-28 00:18:41.514898	47730
33188	50	2016-06-28 00:18:41.522908	47721
33189	50	2016-06-28 00:18:41.530728	47733
33190	50	2016-06-28 00:18:41.538452	47709
33191	47	2016-06-28 00:18:41.547645	2851
33192	47	2016-06-28 00:18:41.554671	2859
33193	47	2016-06-28 00:18:41.562663	2843
33194	47	2016-06-28 00:18:41.570227	2855
33195	47	2016-06-28 00:18:41.57831	2872
33196	47	2016-06-28 00:18:41.585444	2861
33197	47	2016-06-28 00:18:41.593857	2849
33198	47	2016-06-28 00:18:41.600993	2853
33199	47	2016-06-28 00:18:41.608512	2878
33200	47	2016-06-28 00:18:41.616179	2834
33201	47	2016-06-28 00:18:41.624045	2847
33202	47	2016-06-28 00:18:41.631206	2874
33203	47	2016-06-28 00:18:41.638287	2863
33204	47	2016-06-28 00:18:41.645261	2845
33205	41	2016-06-28 00:20:47.665465	2858
33206	41	2016-06-28 00:20:47.673194	2865
33207	41	2016-06-28 00:20:47.680427	2866
33208	44	2016-06-28 00:20:47.688851	2869
33209	42	2016-06-28 00:20:47.696065	2849
33210	42	2016-06-28 00:20:47.702719	2834
33211	42	2016-06-28 00:20:47.709145	2855
33212	42	2016-06-28 00:20:47.715716	2874
33213	42	2016-06-28 00:20:47.722546	2878
33214	42	2016-06-28 00:20:47.729364	2847
33215	42	2016-06-28 00:20:47.73676	2851
33216	42	2016-06-28 00:20:47.744058	2872
33217	43	2016-06-28 00:20:47.751063	2848
33218	43	2016-06-28 00:20:47.758259	2835
33219	43	2016-06-28 00:20:47.764999	2852
33220	43	2016-06-28 00:20:47.772599	2856
33221	43	2016-06-28 00:20:47.779386	2873
33222	43	2016-06-28 00:20:47.786229	2879
33223	43	2016-06-28 00:20:47.793425	2850
33224	43	2016-06-28 00:20:47.80013	2875
33225	40	2016-06-28 00:20:47.808038	47733
33226	40	2016-06-28 00:20:47.814644	47730
33227	40	2016-06-28 00:20:47.821086	47706
33228	40	2016-06-28 00:20:47.827765	47709
33229	40	2016-06-28 00:20:47.834167	47727
33230	40	2016-06-28 00:20:47.840966	47721
33231	49	2016-06-28 00:20:47.849733	47706
33232	49	2016-06-28 00:20:47.8572	47727
33233	49	2016-06-28 00:20:47.864711	47730
33234	49	2016-06-28 00:20:47.871718	47721
33235	49	2016-06-28 00:20:47.878951	47733
33236	49	2016-06-28 00:20:47.886154	47709
33237	48	2016-06-28 00:20:47.895326	2851
33238	48	2016-06-28 00:20:47.902359	2859
33239	48	2016-06-28 00:20:47.909811	2843
33240	48	2016-06-28 00:20:47.919033	2855
33241	48	2016-06-28 00:20:47.926637	2872
33242	48	2016-06-28 00:20:47.934975	2861
33243	48	2016-06-28 00:20:47.943491	2849
33244	48	2016-06-28 00:20:47.950611	2853
33245	48	2016-06-28 00:20:47.958532	2878
33246	48	2016-06-28 00:20:47.966211	2834
33247	48	2016-06-28 00:20:47.974238	2847
33248	48	2016-06-28 00:20:47.981703	2874
33249	48	2016-06-28 00:20:47.988864	2863
33250	48	2016-06-28 00:20:47.995839	2845
33251	50	2016-06-28 00:20:48.004266	47706
33252	50	2016-06-28 00:20:48.011676	47727
33253	50	2016-06-28 00:20:48.01883	47730
33254	50	2016-06-28 00:20:48.026536	47721
33255	50	2016-06-28 00:20:48.03458	47733
33256	50	2016-06-28 00:20:48.057584	47709
33257	47	2016-06-28 00:20:48.066132	2851
33258	47	2016-06-28 00:20:48.072997	2859
33259	47	2016-06-28 00:20:48.079953	2843
33260	47	2016-06-28 00:20:48.087946	2855
33261	47	2016-06-28 00:20:48.095991	2872
33262	47	2016-06-28 00:20:48.102997	2861
33263	47	2016-06-28 00:20:48.111121	2849
33264	47	2016-06-28 00:20:48.118101	2853
33265	47	2016-06-28 00:20:48.125562	2878
33266	47	2016-06-28 00:20:48.133245	2834
33267	47	2016-06-28 00:20:48.141252	2847
33268	47	2016-06-28 00:20:48.149195	2874
33269	47	2016-06-28 00:20:48.156565	2863
33270	47	2016-06-28 00:20:48.164016	2845
33271	41	2016-06-28 00:30:33.512686	2858
33272	41	2016-06-28 00:30:33.520569	2865
33273	41	2016-06-28 00:30:33.528323	2866
33274	44	2016-06-28 00:30:33.536628	2869
33275	42	2016-06-28 00:30:33.543802	2849
33276	42	2016-06-28 00:30:33.55106	2834
33277	42	2016-06-28 00:30:33.557788	2855
33278	42	2016-06-28 00:30:33.565025	2874
33279	42	2016-06-28 00:30:33.571863	2878
33280	42	2016-06-28 00:30:33.578589	2847
33281	42	2016-06-28 00:30:33.585291	2851
33282	42	2016-06-28 00:30:33.591843	2872
33283	43	2016-06-28 00:30:33.599374	2848
33284	43	2016-06-28 00:30:33.605898	2835
33285	43	2016-06-28 00:30:33.613055	2852
33286	43	2016-06-28 00:30:33.61966	2856
33287	43	2016-06-28 00:30:33.626287	2873
33288	43	2016-06-28 00:30:33.633133	2879
33289	43	2016-06-28 00:30:33.63971	2850
33290	43	2016-06-28 00:30:33.646158	2875
33291	40	2016-06-28 00:30:33.653797	47733
33292	40	2016-06-28 00:30:33.660483	47730
33293	40	2016-06-28 00:30:33.66694	47706
33294	40	2016-06-28 00:30:33.673007	47709
33295	40	2016-06-28 00:30:33.679699	47727
33296	40	2016-06-28 00:30:33.685914	47721
33297	49	2016-06-28 00:30:33.69423	47706
33298	49	2016-06-28 00:30:33.701421	47727
33299	49	2016-06-28 00:30:33.708338	47730
33300	49	2016-06-28 00:30:33.7158	47721
33301	49	2016-06-28 00:30:33.722777	47733
33302	49	2016-06-28 00:30:33.729894	47709
33303	48	2016-06-28 00:30:33.738515	2851
33304	48	2016-06-28 00:30:33.745426	2859
33305	48	2016-06-28 00:30:33.752411	2843
33306	48	2016-06-28 00:30:33.760587	2855
33307	48	2016-06-28 00:30:33.768408	2872
33308	48	2016-06-28 00:30:33.775541	2861
33309	48	2016-06-28 00:30:33.783415	2849
33310	48	2016-06-28 00:30:33.790341	2853
33311	48	2016-06-28 00:30:33.797843	2878
33312	48	2016-06-28 00:30:33.805547	2834
33313	48	2016-06-28 00:30:33.813496	2847
33314	48	2016-06-28 00:30:33.820954	2874
33315	48	2016-06-28 00:30:33.827996	2863
33316	48	2016-06-28 00:30:33.8351	2845
33317	50	2016-06-28 00:30:33.843111	47706
33318	50	2016-06-28 00:30:33.850555	47727
33319	50	2016-06-28 00:30:33.857807	47730
33320	50	2016-06-28 00:30:33.865434	47721
33321	50	2016-06-28 00:30:33.87283	47733
33322	50	2016-06-28 00:30:33.879992	47709
33323	47	2016-06-28 00:30:33.888501	2851
33324	47	2016-06-28 00:30:33.895403	2859
33325	47	2016-06-28 00:30:33.902362	2843
33326	47	2016-06-28 00:30:33.909905	2855
33327	47	2016-06-28 00:30:33.917217	2872
33328	47	2016-06-28 00:30:33.925456	2861
33329	47	2016-06-28 00:30:33.933299	2849
33330	47	2016-06-28 00:30:33.940107	2853
33331	47	2016-06-28 00:30:33.947397	2878
33332	47	2016-06-28 00:30:33.954809	2834
33333	47	2016-06-28 00:30:33.962651	2847
33334	47	2016-06-28 00:30:33.970091	2874
33335	47	2016-06-28 00:30:33.977328	2863
33336	47	2016-06-28 00:30:33.984312	2845
33337	41	2016-06-28 00:33:57.96666	2858
33338	41	2016-06-28 00:33:57.974765	2865
33339	41	2016-06-28 00:33:57.982322	2866
33340	44	2016-06-28 00:33:57.990379	2869
33341	42	2016-06-28 00:33:57.997559	2849
33342	42	2016-06-28 00:33:58.004391	2834
33343	42	2016-06-28 00:33:58.011428	2855
33344	42	2016-06-28 00:33:58.017993	2874
33345	42	2016-06-28 00:33:58.024703	2878
33346	42	2016-06-28 00:33:58.031469	2847
33347	42	2016-06-28 00:33:58.03838	2851
33348	42	2016-06-28 00:33:58.045449	2872
33349	43	2016-06-28 00:33:58.053195	2848
33350	43	2016-06-28 00:33:58.06038	2835
33351	43	2016-06-28 00:33:58.067356	2852
33352	43	2016-06-28 00:33:58.073993	2856
33353	43	2016-06-28 00:33:58.080385	2873
33354	43	2016-06-28 00:33:58.087354	2879
33355	43	2016-06-28 00:33:58.095	2850
33356	43	2016-06-28 00:33:58.10159	2875
33357	40	2016-06-28 00:33:58.109426	47733
33358	40	2016-06-28 00:33:58.11584	47730
33359	40	2016-06-28 00:33:58.122028	47706
33360	40	2016-06-28 00:33:58.128621	47709
33361	40	2016-06-28 00:33:58.135209	47727
33362	40	2016-06-28 00:33:58.162374	47721
33363	49	2016-06-28 00:33:58.179358	47706
33364	49	2016-06-28 00:33:58.207562	47727
33365	49	2016-06-28 00:33:58.220349	47730
33366	49	2016-06-28 00:33:58.233024	47721
33367	49	2016-06-28 00:33:58.248905	47733
33368	49	2016-06-28 00:33:58.2662	47709
33369	48	2016-06-28 00:33:58.295362	2851
33370	48	2016-06-28 00:33:58.303253	2859
33371	48	2016-06-28 00:33:58.32066	2843
33372	48	2016-06-28 00:33:58.339951	2855
33373	48	2016-06-28 00:33:58.362432	2872
33374	48	2016-06-28 00:33:58.375158	2861
33375	48	2016-06-28 00:33:58.385326	2849
33376	48	2016-06-28 00:33:58.395068	2853
33377	48	2016-06-28 00:33:58.413778	2878
33378	48	2016-06-28 00:33:58.454144	2834
33379	48	2016-06-28 00:33:58.470936	2847
33380	48	2016-06-28 00:33:58.494984	2874
33381	48	2016-06-28 00:33:58.507295	2863
33382	48	2016-06-28 00:33:58.527366	2845
33383	50	2016-06-28 00:33:58.548234	47706
33384	50	2016-06-28 00:33:58.557691	47727
33385	50	2016-06-28 00:33:58.579304	47730
33386	50	2016-06-28 00:33:58.596109	47721
33387	50	2016-06-28 00:33:58.612413	47733
33388	50	2016-06-28 00:33:58.629098	47709
33389	47	2016-06-28 00:33:58.649169	2851
33390	47	2016-06-28 00:33:58.658804	2859
33391	47	2016-06-28 00:33:58.681383	2843
33392	47	2016-06-28 00:33:58.696116	2855
33393	47	2016-06-28 00:33:58.716078	2872
33394	47	2016-06-28 00:33:58.740079	2861
33395	47	2016-06-28 00:33:58.75648	2849
33396	47	2016-06-28 00:33:58.771918	2853
33397	47	2016-06-28 00:33:58.792632	2878
33398	47	2016-06-28 00:33:58.802394	2834
33399	47	2016-06-28 00:33:58.816948	2847
33400	47	2016-06-28 00:33:58.835389	2874
33401	47	2016-06-28 00:33:58.845542	2863
33402	47	2016-06-28 00:33:58.863329	2845
33403	41	2016-06-28 00:35:16.970127	2858
33404	41	2016-06-28 00:35:16.978018	2865
33405	41	2016-06-28 00:35:16.985866	2866
33406	44	2016-06-28 00:35:16.994019	2869
33407	42	2016-06-28 00:35:17.000999	2849
33408	42	2016-06-28 00:35:17.00791	2855
33409	42	2016-06-28 00:35:17.014666	2834
33410	42	2016-06-28 00:35:17.021583	2878
33411	42	2016-06-28 00:35:17.028228	2874
33412	42	2016-06-28 00:35:17.036325	2847
33413	42	2016-06-28 00:35:17.043159	2851
33414	42	2016-06-28 00:35:17.049921	2872
33415	43	2016-06-28 00:35:17.057671	2848
33416	43	2016-06-28 00:35:17.064384	2835
33417	43	2016-06-28 00:35:17.071234	2852
33418	43	2016-06-28 00:35:17.078024	2856
33419	43	2016-06-28 00:35:17.084633	2879
33420	43	2016-06-28 00:35:17.092118	2873
33421	43	2016-06-28 00:35:17.098711	2850
33422	43	2016-06-28 00:35:17.10537	2875
33423	40	2016-06-28 00:35:17.113517	47733
33424	40	2016-06-28 00:35:17.120373	47730
33425	40	2016-06-28 00:35:17.126811	47706
33426	40	2016-06-28 00:35:17.133	47709
33427	40	2016-06-28 00:35:17.139782	47727
33428	40	2016-06-28 00:35:17.146239	47721
33429	49	2016-06-28 00:35:17.155892	47706
33430	49	2016-06-28 00:35:17.164032	47727
33431	49	2016-06-28 00:35:17.171793	47730
33432	49	2016-06-28 00:35:17.178908	47721
33433	49	2016-06-28 00:35:17.18655	47733
33434	49	2016-06-28 00:35:17.193967	47709
33435	48	2016-06-28 00:35:17.203125	2851
33436	48	2016-06-28 00:35:17.210455	2859
33437	48	2016-06-28 00:35:17.217421	2843
33438	48	2016-06-28 00:35:17.225709	2855
33439	48	2016-06-28 00:35:17.233308	2872
33440	48	2016-06-28 00:35:17.240713	2861
33441	48	2016-06-28 00:35:17.248545	2849
33442	48	2016-06-28 00:35:17.256623	2853
33443	48	2016-06-28 00:35:17.265817	2878
33444	48	2016-06-28 00:35:17.274106	2834
33445	48	2016-06-28 00:35:17.281871	2847
33446	48	2016-06-28 00:35:17.289522	2874
33447	48	2016-06-28 00:35:17.296377	2863
33448	48	2016-06-28 00:35:17.303755	2845
33449	50	2016-06-28 00:35:17.312522	47706
33450	50	2016-06-28 00:35:17.320482	47727
33451	50	2016-06-28 00:35:17.328344	47730
33452	50	2016-06-28 00:35:17.336065	47721
33453	50	2016-06-28 00:35:17.343829	47733
33454	50	2016-06-28 00:35:17.351729	47709
33455	47	2016-06-28 00:35:17.361173	2851
33456	47	2016-06-28 00:35:17.368631	2859
33457	47	2016-06-28 00:35:17.376095	2843
33458	47	2016-06-28 00:35:17.384624	2855
33459	47	2016-06-28 00:35:17.392611	2872
33460	47	2016-06-28 00:35:17.400108	2861
33461	47	2016-06-28 00:35:17.407996	2849
33462	47	2016-06-28 00:35:17.415747	2853
33463	47	2016-06-28 00:35:17.423856	2878
33464	47	2016-06-28 00:35:17.43218	2834
33465	47	2016-06-28 00:35:17.44012	2847
33466	47	2016-06-28 00:35:17.448377	2874
33467	47	2016-06-28 00:35:17.455944	2863
33468	47	2016-06-28 00:35:17.463603	2845
33469	41	2016-06-28 00:36:50.699187	2858
33470	41	2016-06-28 00:36:50.707082	2865
33471	41	2016-06-28 00:36:50.718247	2866
33472	44	2016-06-28 00:36:50.726073	2869
33473	42	2016-06-28 00:36:50.733801	2849
33474	42	2016-06-28 00:36:50.740486	2855
33475	42	2016-06-28 00:36:50.747224	2834
33476	42	2016-06-28 00:36:50.754826	2878
33477	42	2016-06-28 00:36:50.761581	2874
33478	42	2016-06-28 00:36:50.768474	2847
33479	42	2016-06-28 00:36:50.775182	2851
33480	42	2016-06-28 00:36:50.783183	2872
33481	43	2016-06-28 00:36:50.790327	2848
33482	43	2016-06-28 00:36:50.797187	2835
33483	43	2016-06-28 00:36:50.804154	2852
33484	43	2016-06-28 00:36:50.810883	2856
33485	43	2016-06-28 00:36:50.817505	2879
33486	43	2016-06-28 00:36:50.824087	2873
33487	43	2016-06-28 00:36:50.831097	2850
33488	43	2016-06-28 00:36:50.837696	2875
33489	40	2016-06-28 00:36:50.845562	47733
33490	40	2016-06-28 00:36:50.852137	47730
33491	40	2016-06-28 00:36:50.858826	47706
33492	40	2016-06-28 00:36:50.8656	47709
33493	40	2016-06-28 00:36:50.871962	47727
33494	40	2016-06-28 00:36:50.878147	47721
33495	49	2016-06-28 00:36:50.886612	47706
33496	49	2016-06-28 00:36:50.893739	47727
33497	49	2016-06-28 00:36:50.901241	47730
33498	49	2016-06-28 00:36:50.908332	47721
33499	49	2016-06-28 00:36:50.917168	47733
33500	49	2016-06-28 00:36:50.924793	47709
33501	48	2016-06-28 00:36:50.93397	2851
33502	48	2016-06-28 00:36:50.941731	2859
33503	48	2016-06-28 00:36:50.949493	2843
33504	48	2016-06-28 00:36:50.958129	2855
33505	48	2016-06-28 00:36:50.966447	2872
33506	48	2016-06-28 00:36:50.974095	2861
33507	48	2016-06-28 00:36:50.982408	2849
33508	48	2016-06-28 00:36:50.990719	2853
33509	48	2016-06-28 00:36:50.998756	2878
33510	48	2016-06-28 00:36:51.007188	2834
33511	48	2016-06-28 00:36:51.016506	2847
33512	48	2016-06-28 00:36:51.025023	2874
33513	48	2016-06-28 00:36:51.033047	2863
33514	48	2016-06-28 00:36:51.040636	2845
33515	50	2016-06-28 00:36:51.049451	47706
33516	50	2016-06-28 00:36:51.057528	47727
33517	50	2016-06-28 00:36:51.065469	47730
33518	50	2016-06-28 00:36:51.073699	47721
33519	50	2016-06-28 00:36:51.081538	47733
33520	50	2016-06-28 00:36:51.090114	47709
33521	47	2016-06-28 00:36:51.099213	2851
33522	47	2016-06-28 00:36:51.106694	2859
33523	47	2016-06-28 00:36:51.114162	2843
33524	47	2016-06-28 00:36:51.122473	2855
33525	47	2016-06-28 00:36:51.130685	2872
33526	47	2016-06-28 00:36:51.138015	2861
33527	47	2016-06-28 00:36:51.146581	2849
33528	47	2016-06-28 00:36:51.153987	2853
33529	47	2016-06-28 00:36:51.161976	2878
33530	47	2016-06-28 00:36:51.169884	2834
33531	47	2016-06-28 00:36:51.178281	2847
33532	47	2016-06-28 00:36:51.185922	2874
33533	47	2016-06-28 00:36:51.193635	2863
33534	47	2016-06-28 00:36:51.201563	2845
33535	41	2016-06-28 00:39:30.653159	2858
33536	41	2016-06-28 00:39:30.661176	2865
33537	41	2016-06-28 00:39:30.6689	2866
33538	44	2016-06-28 00:39:30.676979	2869
33539	42	2016-06-28 00:39:30.684431	2849
33540	42	2016-06-28 00:39:30.691509	2855
33541	42	2016-06-28 00:39:30.698284	2834
33542	42	2016-06-28 00:39:30.705174	2878
33543	42	2016-06-28 00:39:30.71183	2874
33544	42	2016-06-28 00:39:30.71909	2847
33545	42	2016-06-28 00:39:30.725853	2851
33546	42	2016-06-28 00:39:30.732699	2872
33547	43	2016-06-28 00:39:30.740261	2848
33548	43	2016-06-28 00:39:30.747437	2835
33549	43	2016-06-28 00:39:30.754031	2852
33550	43	2016-06-28 00:39:30.760638	2856
33551	43	2016-06-28 00:39:30.767541	2879
33552	43	2016-06-28 00:39:30.77416	2873
33553	43	2016-06-28 00:39:30.780673	2850
33554	43	2016-06-28 00:39:30.787116	2875
33555	40	2016-06-28 00:39:30.794828	47733
33556	40	2016-06-28 00:39:30.801764	47730
33557	40	2016-06-28 00:39:30.808479	47706
33558	40	2016-06-28 00:39:30.814799	47709
33559	40	2016-06-28 00:39:30.821755	47727
33560	40	2016-06-28 00:39:30.828148	47721
33561	49	2016-06-28 00:39:30.837315	47706
33562	49	2016-06-28 00:39:30.844879	47727
33563	49	2016-06-28 00:39:30.853596	47730
33564	49	2016-06-28 00:39:30.862171	47721
33565	49	2016-06-28 00:39:30.87009	47733
33566	49	2016-06-28 00:39:30.877475	47709
33567	48	2016-06-28 00:39:30.887972	2851
33568	48	2016-06-28 00:39:30.895391	2859
33569	48	2016-06-28 00:39:30.903375	2843
33570	48	2016-06-28 00:39:30.911497	2855
33571	48	2016-06-28 00:39:30.919545	2872
33572	48	2016-06-28 00:39:30.926797	2861
33573	48	2016-06-28 00:39:30.935044	2849
33574	48	2016-06-28 00:39:30.942052	2853
33575	48	2016-06-28 00:39:30.950074	2878
33576	48	2016-06-28 00:39:30.958558	2834
33577	48	2016-06-28 00:39:30.966619	2847
33578	48	2016-06-28 00:39:30.974699	2874
33579	48	2016-06-28 00:39:30.982307	2863
33580	48	2016-06-28 00:39:30.98985	2845
33581	50	2016-06-28 00:39:30.99849	47706
33582	50	2016-06-28 00:39:31.006487	47727
33583	50	2016-06-28 00:39:31.014418	47730
33584	50	2016-06-28 00:39:31.022291	47721
33585	50	2016-06-28 00:39:31.031525	47733
33586	50	2016-06-28 00:39:31.055509	47709
33587	47	2016-06-28 00:39:31.065	2851
33588	47	2016-06-28 00:39:31.072258	2859
33589	47	2016-06-28 00:39:31.079986	2843
33590	47	2016-06-28 00:39:31.088575	2855
33591	47	2016-06-28 00:39:31.09707	2872
33592	47	2016-06-28 00:39:31.104373	2861
33593	47	2016-06-28 00:39:31.112729	2849
33594	47	2016-06-28 00:39:31.120152	2853
33595	47	2016-06-28 00:39:31.128135	2878
33596	47	2016-06-28 00:39:31.136699	2834
33597	47	2016-06-28 00:39:31.144889	2847
33598	47	2016-06-28 00:39:31.15264	2874
33599	47	2016-06-28 00:39:31.160278	2863
33600	47	2016-06-28 00:39:31.167942	2845
33601	41	2016-06-28 00:41:39.101533	2858
33602	41	2016-06-28 00:41:39.109803	2865
33603	41	2016-06-28 00:41:39.117935	2866
33604	44	2016-06-28 00:41:39.127039	2869
33605	42	2016-06-28 00:41:39.134438	2849
33606	42	2016-06-28 00:41:39.141162	2855
33607	42	2016-06-28 00:41:39.148501	2834
33608	42	2016-06-28 00:41:39.155474	2878
33609	42	2016-06-28 00:41:39.162084	2874
33610	42	2016-06-28 00:41:39.168797	2847
33611	42	2016-06-28 00:41:39.175731	2851
33612	42	2016-06-28 00:41:39.182436	2872
33613	43	2016-06-28 00:41:39.189256	2848
33614	43	2016-06-28 00:41:39.196105	2835
33615	43	2016-06-28 00:41:39.202915	2852
33616	43	2016-06-28 00:41:39.210365	2856
33617	43	2016-06-28 00:41:39.217041	2879
33618	43	2016-06-28 00:41:39.22375	2873
33619	43	2016-06-28 00:41:39.230329	2850
33620	43	2016-06-28 00:41:39.236954	2875
33621	40	2016-06-28 00:41:39.245685	47733
33622	40	2016-06-28 00:41:39.253433	47730
33623	40	2016-06-28 00:41:39.260478	47706
33624	40	2016-06-28 00:41:39.267598	47709
33625	40	2016-06-28 00:41:39.274297	47727
33626	40	2016-06-28 00:41:39.281333	47721
33627	49	2016-06-28 00:41:39.290403	47706
33628	49	2016-06-28 00:41:39.29856	47727
33629	49	2016-06-28 00:41:39.306334	47730
33630	49	2016-06-28 00:41:39.314077	47721
33631	49	2016-06-28 00:41:39.321585	47733
33632	49	2016-06-28 00:41:39.329184	47709
33633	48	2016-06-28 00:41:39.338814	2851
33634	48	2016-06-28 00:41:39.34631	2859
33635	48	2016-06-28 00:41:39.354645	2843
33636	48	2016-06-28 00:41:39.364664	2855
33637	48	2016-06-28 00:41:39.372937	2872
33638	48	2016-06-28 00:41:39.380271	2861
33639	48	2016-06-28 00:41:39.388624	2849
33640	48	2016-06-28 00:41:39.396338	2853
33641	48	2016-06-28 00:41:39.404754	2878
33642	48	2016-06-28 00:41:39.413479	2834
33643	48	2016-06-28 00:41:39.423302	2847
33644	48	2016-06-28 00:41:39.431284	2874
33645	48	2016-06-28 00:41:39.439293	2863
33646	48	2016-06-28 00:41:39.447639	2845
33647	50	2016-06-28 00:41:39.456922	47706
33648	50	2016-06-28 00:41:39.465484	47727
33649	50	2016-06-28 00:41:39.473867	47730
33650	50	2016-06-28 00:41:39.482441	47721
33651	50	2016-06-28 00:41:39.49071	47733
33652	50	2016-06-28 00:41:39.499326	47709
33653	47	2016-06-28 00:41:39.508703	2851
33654	47	2016-06-28 00:41:39.516967	2859
33655	47	2016-06-28 00:41:39.524346	2843
33656	47	2016-06-28 00:41:39.533319	2855
33657	47	2016-06-28 00:41:39.540683	2872
33658	47	2016-06-28 00:41:39.54866	2861
33659	47	2016-06-28 00:41:39.557293	2849
33660	47	2016-06-28 00:41:39.565312	2853
33661	47	2016-06-28 00:41:39.572889	2878
33662	47	2016-06-28 00:41:39.580702	2834
33663	47	2016-06-28 00:41:39.58835	2847
33664	47	2016-06-28 00:41:39.596154	2874
33665	47	2016-06-28 00:41:39.603159	2863
33666	47	2016-06-28 00:41:39.610319	2845
33667	41	2016-06-28 00:43:20.085658	2858
33668	41	2016-06-28 00:43:20.0935	2865
33669	41	2016-06-28 00:43:20.100909	2866
33670	44	2016-06-28 00:43:20.109101	2869
33671	42	2016-06-28 00:43:20.115956	2849
33672	42	2016-06-28 00:43:20.122751	2855
33673	42	2016-06-28 00:43:20.129298	2834
33674	42	2016-06-28 00:43:20.135948	2878
33675	42	2016-06-28 00:43:20.142398	2874
33676	42	2016-06-28 00:43:20.148906	2847
33677	42	2016-06-28 00:43:20.156484	2851
33678	42	2016-06-28 00:43:20.163821	2872
33679	43	2016-06-28 00:43:20.171507	2848
33680	43	2016-06-28 00:43:20.178395	2835
33681	43	2016-06-28 00:43:20.185348	2852
33682	43	2016-06-28 00:43:20.192657	2856
33683	43	2016-06-28 00:43:20.199388	2879
33684	43	2016-06-28 00:43:20.206082	2873
33685	43	2016-06-28 00:43:20.21269	2850
33686	43	2016-06-28 00:43:20.219238	2875
33687	40	2016-06-28 00:43:20.227278	47733
33688	40	2016-06-28 00:43:20.233666	47730
33689	40	2016-06-28 00:43:20.240634	47706
33690	40	2016-06-28 00:43:20.247115	47709
33691	40	2016-06-28 00:43:20.254952	47727
33692	40	2016-06-28 00:43:20.261996	47721
33693	49	2016-06-28 00:43:20.271434	47706
33694	49	2016-06-28 00:43:20.279344	47727
33695	49	2016-06-28 00:43:20.287045	47730
33696	49	2016-06-28 00:43:20.294775	47721
33697	49	2016-06-28 00:43:20.302363	47733
33698	49	2016-06-28 00:43:20.310615	47709
33699	48	2016-06-28 00:43:20.319742	2851
33700	48	2016-06-28 00:43:20.327684	2859
33701	48	2016-06-28 00:43:20.33506	2843
33702	48	2016-06-28 00:43:20.34358	2855
33703	48	2016-06-28 00:43:20.351627	2872
33704	48	2016-06-28 00:43:20.35893	2861
33705	48	2016-06-28 00:43:20.36724	2849
33706	48	2016-06-28 00:43:20.374912	2853
33707	48	2016-06-28 00:43:20.383675	2878
33708	48	2016-06-28 00:43:20.392483	2834
33709	48	2016-06-28 00:43:20.401038	2847
33710	48	2016-06-28 00:43:20.408813	2874
33711	48	2016-06-28 00:43:20.415826	2863
33712	48	2016-06-28 00:43:20.423084	2845
33713	50	2016-06-28 00:43:20.431992	47706
33714	50	2016-06-28 00:43:20.439645	47727
33715	50	2016-06-28 00:43:20.447391	47730
33716	50	2016-06-28 00:43:20.455289	47721
33717	50	2016-06-28 00:43:20.462757	47733
33718	50	2016-06-28 00:43:20.470597	47709
33719	47	2016-06-28 00:43:20.479651	2851
33720	47	2016-06-28 00:43:20.487299	2859
33721	47	2016-06-28 00:43:20.494343	2843
33722	47	2016-06-28 00:43:20.502208	2855
33723	47	2016-06-28 00:43:20.509703	2872
33724	47	2016-06-28 00:43:20.516621	2861
33725	47	2016-06-28 00:43:20.524592	2849
33726	47	2016-06-28 00:43:20.531854	2853
33727	47	2016-06-28 00:43:20.539522	2878
33728	47	2016-06-28 00:43:20.547636	2834
33729	47	2016-06-28 00:43:20.556729	2847
33730	47	2016-06-28 00:43:20.564532	2874
33731	47	2016-06-28 00:43:20.571963	2863
33732	47	2016-06-28 00:43:20.578976	2845
33733	41	2016-06-28 00:45:29.554165	2858
33734	41	2016-06-28 00:45:29.562389	2865
33735	41	2016-06-28 00:45:29.570058	2866
33736	44	2016-06-28 00:45:29.578324	2869
33737	42	2016-06-28 00:45:29.585314	2849
33738	42	2016-06-28 00:45:29.591899	2855
33739	42	2016-06-28 00:45:29.598683	2834
33740	42	2016-06-28 00:45:29.605543	2878
33741	42	2016-06-28 00:45:29.612046	2874
33742	42	2016-06-28 00:45:29.618995	2847
33743	42	2016-06-28 00:45:29.626271	2851
33744	42	2016-06-28 00:45:29.63474	2872
33745	43	2016-06-28 00:45:29.64187	2848
33746	43	2016-06-28 00:45:29.648869	2835
33747	43	2016-06-28 00:45:29.655512	2852
33748	43	2016-06-28 00:45:29.662247	2856
33749	43	2016-06-28 00:45:29.668967	2879
33750	43	2016-06-28 00:45:29.675837	2873
33751	43	2016-06-28 00:45:29.682783	2850
33752	43	2016-06-28 00:45:29.689309	2875
33753	40	2016-06-28 00:45:29.697255	47733
33754	40	2016-06-28 00:45:29.703799	47730
33755	40	2016-06-28 00:45:29.710193	47706
33756	40	2016-06-28 00:45:29.716509	47709
33757	40	2016-06-28 00:45:29.72292	47727
33758	40	2016-06-28 00:45:29.729415	47721
33759	49	2016-06-28 00:45:29.738729	47706
33760	49	2016-06-28 00:45:29.74625	47727
33761	49	2016-06-28 00:45:29.754067	47730
33762	49	2016-06-28 00:45:29.761258	47721
33763	49	2016-06-28 00:45:29.768808	47733
33764	49	2016-06-28 00:45:29.776098	47709
33765	48	2016-06-28 00:45:29.785636	2851
33766	48	2016-06-28 00:45:29.792764	2859
33767	48	2016-06-28 00:45:29.801575	2843
33768	48	2016-06-28 00:45:29.809477	2855
33769	48	2016-06-28 00:45:29.817756	2872
33770	48	2016-06-28 00:45:29.824739	2861
33771	48	2016-06-28 00:45:29.833348	2849
33772	48	2016-06-28 00:45:29.840693	2853
33773	48	2016-06-28 00:45:29.848934	2878
33774	48	2016-06-28 00:45:29.856862	2834
33775	48	2016-06-28 00:45:29.864758	2847
33776	48	2016-06-28 00:45:29.872781	2874
33777	48	2016-06-28 00:45:29.879902	2863
33778	48	2016-06-28 00:45:29.887509	2845
33779	50	2016-06-28 00:45:29.896414	47706
33780	50	2016-06-28 00:45:29.904528	47727
33781	50	2016-06-28 00:45:29.912841	47730
33782	50	2016-06-28 00:45:29.920649	47721
33783	50	2016-06-28 00:45:29.928962	47733
33784	50	2016-06-28 00:45:29.937496	47709
33785	47	2016-06-28 00:45:29.946772	2851
33786	47	2016-06-28 00:45:29.955526	2859
33787	47	2016-06-28 00:45:29.963385	2843
33788	47	2016-06-28 00:45:29.971435	2855
33789	47	2016-06-28 00:45:29.979758	2872
33790	47	2016-06-28 00:45:29.987162	2861
33791	47	2016-06-28 00:45:29.995947	2849
33792	47	2016-06-28 00:45:30.003466	2853
33793	47	2016-06-28 00:45:30.011788	2878
33794	47	2016-06-28 00:45:30.019819	2834
33795	47	2016-06-28 00:45:30.029085	2847
33796	47	2016-06-28 00:45:30.053194	2874
33797	47	2016-06-28 00:45:30.060523	2863
33798	47	2016-06-28 00:45:30.068072	2845
33799	41	2016-06-28 00:46:44.916667	2858
33800	41	2016-06-28 00:46:44.924449	2865
33801	41	2016-06-28 00:46:44.932008	2866
33802	44	2016-06-28 00:46:44.940283	2869
33803	42	2016-06-28 00:46:44.94861	2849
33804	42	2016-06-28 00:46:44.957541	2855
33805	42	2016-06-28 00:46:44.964148	2834
33806	42	2016-06-28 00:46:44.971557	2878
33807	42	2016-06-28 00:46:44.978211	2874
33808	42	2016-06-28 00:46:44.985186	2847
33809	42	2016-06-28 00:46:44.991827	2851
33810	42	2016-06-28 00:46:44.998501	2872
33811	43	2016-06-28 00:46:45.005912	2848
33812	43	2016-06-28 00:46:45.012611	2835
33813	43	2016-06-28 00:46:45.019905	2852
33814	43	2016-06-28 00:46:45.026692	2856
33815	43	2016-06-28 00:46:45.033469	2879
33816	43	2016-06-28 00:46:45.040199	2873
33817	43	2016-06-28 00:46:45.047205	2850
33818	43	2016-06-28 00:46:45.054292	2875
33819	40	2016-06-28 00:46:45.061941	47733
33820	40	2016-06-28 00:46:45.068303	47730
33821	40	2016-06-28 00:46:45.074838	47706
33822	40	2016-06-28 00:46:45.081196	47709
33823	40	2016-06-28 00:46:45.087765	47727
33824	40	2016-06-28 00:46:45.093913	47721
33825	49	2016-06-28 00:46:45.102765	47706
33826	49	2016-06-28 00:46:45.110094	47727
33827	49	2016-06-28 00:46:45.117304	47730
33828	49	2016-06-28 00:46:45.12465	47721
33829	49	2016-06-28 00:46:45.132802	47733
33830	49	2016-06-28 00:46:45.139886	47709
33831	48	2016-06-28 00:46:45.149131	2851
33832	48	2016-06-28 00:46:45.174545	2859
33833	48	2016-06-28 00:46:45.182564	2843
33834	48	2016-06-28 00:46:45.190663	2855
33835	48	2016-06-28 00:46:45.198144	2872
33836	48	2016-06-28 00:46:45.205413	2861
33837	48	2016-06-28 00:46:45.213285	2849
33838	48	2016-06-28 00:46:45.220382	2853
33839	48	2016-06-28 00:46:45.228054	2878
33840	48	2016-06-28 00:46:45.236039	2834
33841	48	2016-06-28 00:46:45.243701	2847
33842	48	2016-06-28 00:46:45.251374	2874
33843	48	2016-06-28 00:46:45.258416	2863
33844	48	2016-06-28 00:46:45.265538	2845
33845	50	2016-06-28 00:46:45.274074	47706
33846	50	2016-06-28 00:46:45.281569	47727
33847	50	2016-06-28 00:46:45.289256	47730
33848	50	2016-06-28 00:46:45.296517	47721
33849	50	2016-06-28 00:46:45.304	47733
33850	50	2016-06-28 00:46:45.311631	47709
33851	47	2016-06-28 00:46:45.320504	2851
33852	47	2016-06-28 00:46:45.327411	2859
33853	47	2016-06-28 00:46:45.334701	2843
33854	47	2016-06-28 00:46:45.342369	2855
33855	47	2016-06-28 00:46:45.350919	2872
33856	47	2016-06-28 00:46:45.358678	2861
33857	47	2016-06-28 00:46:45.366507	2849
33858	47	2016-06-28 00:46:45.373692	2853
33859	47	2016-06-28 00:46:45.381231	2878
33860	47	2016-06-28 00:46:45.389259	2834
33861	47	2016-06-28 00:46:45.397184	2847
33862	47	2016-06-28 00:46:45.405136	2874
33863	47	2016-06-28 00:46:45.412322	2863
33864	47	2016-06-28 00:46:45.419475	2845
33865	41	2016-06-28 00:47:46.803756	2858
33866	41	2016-06-28 00:47:46.811891	2865
33867	41	2016-06-28 00:47:46.820322	2866
33868	44	2016-06-28 00:47:46.828862	2869
33869	42	2016-06-28 00:47:46.836059	2849
33870	42	2016-06-28 00:47:46.844241	2855
33871	42	2016-06-28 00:47:46.852415	2834
33872	42	2016-06-28 00:47:46.859614	2878
33873	42	2016-06-28 00:47:46.866641	2874
33874	42	2016-06-28 00:47:46.873776	2847
33875	42	2016-06-28 00:47:46.88086	2851
33876	42	2016-06-28 00:47:46.888063	2872
33877	43	2016-06-28 00:47:46.895547	2848
33878	43	2016-06-28 00:47:46.902588	2835
33879	43	2016-06-28 00:47:46.909742	2852
33880	43	2016-06-28 00:47:46.917456	2856
33881	43	2016-06-28 00:47:46.925018	2879
33882	43	2016-06-28 00:47:46.932316	2873
33883	43	2016-06-28 00:47:46.939467	2850
33884	43	2016-06-28 00:47:46.946741	2875
33885	40	2016-06-28 00:47:46.95524	47733
33886	40	2016-06-28 00:47:46.961963	47730
33887	40	2016-06-28 00:47:46.969261	47706
33888	40	2016-06-28 00:47:46.976275	47709
33889	40	2016-06-28 00:47:46.983446	47727
33890	40	2016-06-28 00:47:46.990195	47721
33891	49	2016-06-28 00:47:46.99983	47706
33892	49	2016-06-28 00:47:47.007745	47727
33893	49	2016-06-28 00:47:47.015697	47730
33894	49	2016-06-28 00:47:47.024716	47721
33895	49	2016-06-28 00:47:47.033249	47733
33896	49	2016-06-28 00:47:47.04115	47709
33897	48	2016-06-28 00:47:47.050849	2851
33898	48	2016-06-28 00:47:47.058336	2859
33899	48	2016-06-28 00:47:47.066065	2843
33900	48	2016-06-28 00:47:47.075129	2855
33901	48	2016-06-28 00:47:47.083512	2872
33902	48	2016-06-28 00:47:47.091105	2861
33903	48	2016-06-28 00:47:47.099495	2849
33904	48	2016-06-28 00:47:47.107149	2853
33905	48	2016-06-28 00:47:47.115868	2878
33906	48	2016-06-28 00:47:47.124346	2834
33907	48	2016-06-28 00:47:47.133009	2847
33908	48	2016-06-28 00:47:47.141132	2874
33909	48	2016-06-28 00:47:47.148899	2863
33910	48	2016-06-28 00:47:47.156678	2845
33911	50	2016-06-28 00:47:47.165779	47706
33912	50	2016-06-28 00:47:47.173274	47727
33913	50	2016-06-28 00:47:47.181078	47730
33914	50	2016-06-28 00:47:47.189443	47721
33915	50	2016-06-28 00:47:47.196865	47733
33916	50	2016-06-28 00:47:47.204854	47709
33917	47	2016-06-28 00:47:47.213524	2851
33918	47	2016-06-28 00:47:47.220836	2859
33919	47	2016-06-28 00:47:47.228323	2843
33920	47	2016-06-28 00:47:47.236591	2855
33921	47	2016-06-28 00:47:47.245932	2872
33922	47	2016-06-28 00:47:47.253432	2861
33923	47	2016-06-28 00:47:47.261669	2849
33924	47	2016-06-28 00:47:47.26977	2853
33925	47	2016-06-28 00:47:47.277975	2878
33926	47	2016-06-28 00:47:47.286799	2834
33927	47	2016-06-28 00:47:47.29475	2847
33928	47	2016-06-28 00:47:47.303987	2874
33929	47	2016-06-28 00:47:47.31153	2863
33930	47	2016-06-28 00:47:47.318987	2845
33931	41	2016-06-28 00:51:13.266395	2858
33932	41	2016-06-28 00:51:13.281233	2865
33933	41	2016-06-28 00:51:13.299744	2866
33934	44	2016-06-28 00:51:13.312227	2869
33935	42	2016-06-28 00:51:13.322322	2849
33936	42	2016-06-28 00:51:13.339918	2855
33937	42	2016-06-28 00:51:13.380909	2834
33938	42	2016-06-28 00:51:13.406534	2878
33939	42	2016-06-28 00:51:13.423343	2874
33940	42	2016-06-28 00:51:13.442796	2847
33941	42	2016-06-28 00:51:13.461791	2851
33942	42	2016-06-28 00:51:13.48853	2872
33943	43	2016-06-28 00:51:13.513576	2848
33944	43	2016-06-28 00:51:13.520432	2835
33945	43	2016-06-28 00:51:13.527434	2852
33946	43	2016-06-28 00:51:13.534582	2856
33947	43	2016-06-28 00:51:13.541666	2879
33948	43	2016-06-28 00:51:13.549031	2873
33949	43	2016-06-28 00:51:13.555762	2850
33950	43	2016-06-28 00:51:13.56252	2875
33951	40	2016-06-28 00:51:13.570346	47733
33952	40	2016-06-28 00:51:13.577185	47730
33953	40	2016-06-28 00:51:13.584609	47706
33954	40	2016-06-28 00:51:13.59088	47709
33955	40	2016-06-28 00:51:13.597262	47727
33956	40	2016-06-28 00:51:13.603759	47721
33957	49	2016-06-28 00:51:13.612607	47706
33958	49	2016-06-28 00:51:13.620579	47727
33959	49	2016-06-28 00:51:13.628165	47730
33960	49	2016-06-28 00:51:13.635476	47721
33961	49	2016-06-28 00:51:13.643101	47733
33962	49	2016-06-28 00:51:13.650951	47709
33963	48	2016-06-28 00:51:13.660442	2851
33964	48	2016-06-28 00:51:13.668101	2859
33965	48	2016-06-28 00:51:13.67556	2843
33966	48	2016-06-28 00:51:13.684246	2855
33967	48	2016-06-28 00:51:13.692551	2872
33968	48	2016-06-28 00:51:13.700248	2861
33969	48	2016-06-28 00:51:13.708505	2849
33970	48	2016-06-28 00:51:13.71686	2853
33971	48	2016-06-28 00:51:13.725203	2878
33972	48	2016-06-28 00:51:13.734505	2834
33973	48	2016-06-28 00:51:13.743144	2847
33974	48	2016-06-28 00:51:13.751808	2874
33975	48	2016-06-28 00:51:13.759045	2863
33976	48	2016-06-28 00:51:13.767206	2845
33977	50	2016-06-28 00:51:13.776267	47706
33978	50	2016-06-28 00:51:13.784382	47727
33979	50	2016-06-28 00:51:13.792282	47730
33980	50	2016-06-28 00:51:13.800417	47721
33981	50	2016-06-28 00:51:13.808624	47733
33982	50	2016-06-28 00:51:13.816876	47709
33983	47	2016-06-28 00:51:13.826285	2851
33984	47	2016-06-28 00:51:13.834171	2859
33985	47	2016-06-28 00:51:13.84175	2843
33986	47	2016-06-28 00:51:13.850562	2855
33987	47	2016-06-28 00:51:13.858722	2872
33988	47	2016-06-28 00:51:13.866497	2861
33989	47	2016-06-28 00:51:13.874707	2849
33990	47	2016-06-28 00:51:13.88235	2853
33991	47	2016-06-28 00:51:13.890425	2878
33992	47	2016-06-28 00:51:13.901393	2834
33993	47	2016-06-28 00:51:13.90962	2847
33994	47	2016-06-28 00:51:13.918027	2874
33995	47	2016-06-28 00:51:13.925584	2863
33996	47	2016-06-28 00:51:13.933413	2845
33997	41	2016-06-28 00:52:16.848286	2858
33998	41	2016-06-28 00:52:16.856193	2865
33999	41	2016-06-28 00:52:16.863782	2866
34000	44	2016-06-28 00:52:16.872023	2869
34001	42	2016-06-28 00:52:16.878861	2849
34002	42	2016-06-28 00:52:16.885614	2855
34003	42	2016-06-28 00:52:16.892457	2834
34004	42	2016-06-28 00:52:16.899208	2878
34005	42	2016-06-28 00:52:16.905661	2874
34006	42	2016-06-28 00:52:16.912346	2847
34007	42	2016-06-28 00:52:16.919029	2851
34008	42	2016-06-28 00:52:16.925628	2872
34009	43	2016-06-28 00:52:16.932878	2848
34010	43	2016-06-28 00:52:16.940119	2835
34011	43	2016-06-28 00:52:16.948292	2852
34012	43	2016-06-28 00:52:16.955081	2856
34013	43	2016-06-28 00:52:16.961861	2879
34014	43	2016-06-28 00:52:16.968357	2873
34015	43	2016-06-28 00:52:16.974843	2850
34016	43	2016-06-28 00:52:16.981841	2875
34017	40	2016-06-28 00:52:16.989567	47733
34018	40	2016-06-28 00:52:16.996293	47730
34019	40	2016-06-28 00:52:17.002674	47706
34020	40	2016-06-28 00:52:17.008813	47709
34021	40	2016-06-28 00:52:17.015911	47727
34022	40	2016-06-28 00:52:17.022348	47721
34023	49	2016-06-28 00:52:17.032105	47706
34024	49	2016-06-28 00:52:17.039552	47727
34025	49	2016-06-28 00:52:17.047609	47730
34026	49	2016-06-28 00:52:17.055394	47721
34027	49	2016-06-28 00:52:17.062911	47733
34028	49	2016-06-28 00:52:17.070745	47709
34029	48	2016-06-28 00:52:17.080738	2851
34030	48	2016-06-28 00:52:17.087998	2859
34031	48	2016-06-28 00:52:17.095314	2843
34032	48	2016-06-28 00:52:17.103278	2855
34033	48	2016-06-28 00:52:17.110887	2872
34034	48	2016-06-28 00:52:17.117899	2861
34035	48	2016-06-28 00:52:17.125706	2849
34036	48	2016-06-28 00:52:17.133562	2853
34037	48	2016-06-28 00:52:17.141406	2878
34038	48	2016-06-28 00:52:17.149255	2834
34039	48	2016-06-28 00:52:17.157178	2847
34040	48	2016-06-28 00:52:17.16516	2874
34041	48	2016-06-28 00:52:17.172257	2863
34042	48	2016-06-28 00:52:17.17955	2845
34043	50	2016-06-28 00:52:17.188078	47706
34044	50	2016-06-28 00:52:17.195834	47727
34045	50	2016-06-28 00:52:17.203499	47730
34046	50	2016-06-28 00:52:17.210818	47721
34047	50	2016-06-28 00:52:17.21833	47733
34048	50	2016-06-28 00:52:17.225852	47709
34049	47	2016-06-28 00:52:17.234539	2851
34050	47	2016-06-28 00:52:17.241999	2859
34051	47	2016-06-28 00:52:17.250333	2843
34052	47	2016-06-28 00:52:17.258094	2855
34053	47	2016-06-28 00:52:17.265725	2872
34054	47	2016-06-28 00:52:17.27273	2861
34055	47	2016-06-28 00:52:17.280547	2849
34056	47	2016-06-28 00:52:17.287558	2853
34057	47	2016-06-28 00:52:17.295298	2878
34058	47	2016-06-28 00:52:17.302998	2834
34059	47	2016-06-28 00:52:17.310486	2847
34060	47	2016-06-28 00:52:17.318088	2874
34061	47	2016-06-28 00:52:17.325532	2863
34062	47	2016-06-28 00:52:17.332675	2845
34063	41	2016-06-28 00:53:19.275615	2858
34064	41	2016-06-28 00:53:19.283694	2865
34065	41	2016-06-28 00:53:19.29148	2866
34066	44	2016-06-28 00:53:19.299978	2869
34067	42	2016-06-28 00:53:19.307097	2849
34068	42	2016-06-28 00:53:19.31393	2855
34069	42	2016-06-28 00:53:19.320734	2834
34070	42	2016-06-28 00:53:19.327218	2878
34071	42	2016-06-28 00:53:19.334042	2874
34072	42	2016-06-28 00:53:19.340926	2847
34073	42	2016-06-28 00:53:19.348459	2851
34074	42	2016-06-28 00:53:19.355565	2872
34075	43	2016-06-28 00:53:19.362554	2848
34076	43	2016-06-28 00:53:19.369727	2835
34077	43	2016-06-28 00:53:19.376387	2852
34078	43	2016-06-28 00:53:19.383768	2856
34079	43	2016-06-28 00:53:19.390665	2879
34080	43	2016-06-28 00:53:19.397557	2873
34081	43	2016-06-28 00:53:19.404175	2850
34082	43	2016-06-28 00:53:19.410859	2875
34083	40	2016-06-28 00:53:19.41847	47733
34084	40	2016-06-28 00:53:19.425086	47730
34085	40	2016-06-28 00:53:19.431612	47706
34086	40	2016-06-28 00:53:19.438031	47709
34087	40	2016-06-28 00:53:19.44477	47727
34088	40	2016-06-28 00:53:19.450892	47721
34089	49	2016-06-28 00:53:19.459562	47706
34090	49	2016-06-28 00:53:19.466996	47727
34091	49	2016-06-28 00:53:19.474605	47730
34092	49	2016-06-28 00:53:19.481947	47721
34093	49	2016-06-28 00:53:19.489009	47733
34094	49	2016-06-28 00:53:19.496254	47709
34095	48	2016-06-28 00:53:19.505923	2851
34096	48	2016-06-28 00:53:19.513134	2859
34097	48	2016-06-28 00:53:19.520154	2843
34098	48	2016-06-28 00:53:19.527922	2855
34099	48	2016-06-28 00:53:19.535793	2872
34100	48	2016-06-28 00:53:19.543004	2861
34101	48	2016-06-28 00:53:19.551306	2849
34102	48	2016-06-28 00:53:19.558379	2853
34103	48	2016-06-28 00:53:19.566106	2878
34104	48	2016-06-28 00:53:19.574073	2834
34105	48	2016-06-28 00:53:19.582478	2847
34106	48	2016-06-28 00:53:19.590133	2874
34107	48	2016-06-28 00:53:19.597277	2863
34108	48	2016-06-28 00:53:19.604346	2845
34109	50	2016-06-28 00:53:19.612885	47706
34110	50	2016-06-28 00:53:19.620445	47727
34111	50	2016-06-28 00:53:19.62846	47730
34112	50	2016-06-28 00:53:19.635916	47721
34113	50	2016-06-28 00:53:19.643529	47733
34114	50	2016-06-28 00:53:19.651499	47709
34115	47	2016-06-28 00:53:19.66038	2851
34116	47	2016-06-28 00:53:19.667415	2859
34117	47	2016-06-28 00:53:19.674533	2843
34118	47	2016-06-28 00:53:19.68273	2855
34119	47	2016-06-28 00:53:19.690595	2872
34120	47	2016-06-28 00:53:19.697931	2861
34121	47	2016-06-28 00:53:19.705624	2849
34122	47	2016-06-28 00:53:19.712896	2853
34123	47	2016-06-28 00:53:19.720442	2878
34124	47	2016-06-28 00:53:19.728218	2834
34125	47	2016-06-28 00:53:19.73664	2847
34126	47	2016-06-28 00:53:19.744581	2874
34127	47	2016-06-28 00:53:19.751952	2863
34128	47	2016-06-28 00:53:19.75962	2845
34129	41	2016-06-28 00:54:41.997626	2858
34130	41	2016-06-28 00:54:42.008657	2865
34131	41	2016-06-28 00:54:42.016296	2866
34132	44	2016-06-28 00:54:42.024644	2869
34133	42	2016-06-28 00:54:42.0315	2849
34134	42	2016-06-28 00:54:42.038695	2855
34135	42	2016-06-28 00:54:42.045375	2834
34136	42	2016-06-28 00:54:42.0518	2878
34137	42	2016-06-28 00:54:42.058927	2874
34138	42	2016-06-28 00:54:42.066271	2847
34139	42	2016-06-28 00:54:42.073421	2851
34140	42	2016-06-28 00:54:42.080795	2872
34141	43	2016-06-28 00:54:42.088874	2848
34142	43	2016-06-28 00:54:42.095586	2835
34143	43	2016-06-28 00:54:42.102712	2852
34144	43	2016-06-28 00:54:42.109472	2856
34145	43	2016-06-28 00:54:42.116326	2879
34146	43	2016-06-28 00:54:42.123326	2873
34147	43	2016-06-28 00:54:42.129885	2850
34148	43	2016-06-28 00:54:42.136578	2875
34149	40	2016-06-28 00:54:42.145177	47733
34150	40	2016-06-28 00:54:42.151918	47730
34151	40	2016-06-28 00:54:42.158298	47706
34152	40	2016-06-28 00:54:42.164609	47709
34153	40	2016-06-28 00:54:42.17108	47727
34154	40	2016-06-28 00:54:42.177222	47721
34155	49	2016-06-28 00:54:42.186152	47706
34156	49	2016-06-28 00:54:42.193537	47727
34157	49	2016-06-28 00:54:42.20085	47730
34158	49	2016-06-28 00:54:42.208047	47721
34159	49	2016-06-28 00:54:42.21524	47733
34160	49	2016-06-28 00:54:42.222652	47709
34161	48	2016-06-28 00:54:42.232186	2851
34162	48	2016-06-28 00:54:42.239227	2859
34163	48	2016-06-28 00:54:42.246472	2843
34164	48	2016-06-28 00:54:42.254963	2855
34165	48	2016-06-28 00:54:42.263042	2872
34166	48	2016-06-28 00:54:42.270404	2861
34167	48	2016-06-28 00:54:42.278586	2849
34168	48	2016-06-28 00:54:42.285745	2853
34169	48	2016-06-28 00:54:42.293465	2878
34170	48	2016-06-28 00:54:42.301742	2834
34171	48	2016-06-28 00:54:42.309788	2847
34172	48	2016-06-28 00:54:42.317585	2874
34173	48	2016-06-28 00:54:42.324454	2863
34174	48	2016-06-28 00:54:42.331568	2845
34175	50	2016-06-28 00:54:42.341402	47706
34176	50	2016-06-28 00:54:42.349265	47727
34177	50	2016-06-28 00:54:42.356852	47730
34178	50	2016-06-28 00:54:42.364307	47721
34179	50	2016-06-28 00:54:42.372015	47733
34180	50	2016-06-28 00:54:42.379588	47709
34181	47	2016-06-28 00:54:42.388608	2851
34182	47	2016-06-28 00:54:42.395703	2859
34183	47	2016-06-28 00:54:42.403415	2843
34184	47	2016-06-28 00:54:42.411983	2855
34185	47	2016-06-28 00:54:42.419671	2872
34186	47	2016-06-28 00:54:42.42722	2861
34187	47	2016-06-28 00:54:42.43537	2849
34188	47	2016-06-28 00:54:42.442704	2853
34189	47	2016-06-28 00:54:42.450636	2878
34190	47	2016-06-28 00:54:42.458474	2834
34191	47	2016-06-28 00:54:42.466243	2847
34192	47	2016-06-28 00:54:42.473959	2874
34193	47	2016-06-28 00:54:42.48113	2863
34194	47	2016-06-28 00:54:42.48856	2845
34195	41	2016-06-28 00:57:42.692027	2858
34196	41	2016-06-28 00:57:42.699982	2865
34197	41	2016-06-28 00:57:42.707559	2866
34198	44	2016-06-28 00:57:42.715891	2869
34199	42	2016-06-28 00:57:42.723186	2849
34200	42	2016-06-28 00:57:42.730959	2855
34201	42	2016-06-28 00:57:42.737682	2834
34202	42	2016-06-28 00:57:42.74438	2878
34203	42	2016-06-28 00:57:42.750805	2874
34204	42	2016-06-28 00:57:42.757953	2847
34205	42	2016-06-28 00:57:42.764506	2851
34206	42	2016-06-28 00:57:42.770954	2872
34207	43	2016-06-28 00:57:42.778174	2848
34208	43	2016-06-28 00:57:42.784943	2835
34209	43	2016-06-28 00:57:42.791834	2852
34210	43	2016-06-28 00:57:42.798511	2856
34211	43	2016-06-28 00:57:42.805385	2879
34212	43	2016-06-28 00:57:42.812299	2873
34213	43	2016-06-28 00:57:42.818959	2850
34214	43	2016-06-28 00:57:42.825683	2875
34215	40	2016-06-28 00:57:42.834717	47733
34216	40	2016-06-28 00:57:42.841641	47730
34217	40	2016-06-28 00:57:42.847908	47706
34218	40	2016-06-28 00:57:42.85427	47709
34219	40	2016-06-28 00:57:42.86054	47727
34220	40	2016-06-28 00:57:42.86673	47721
34221	49	2016-06-28 00:57:42.875986	47706
34222	49	2016-06-28 00:57:42.883213	47727
34223	49	2016-06-28 00:57:42.890885	47730
34224	49	2016-06-28 00:57:42.907436	47721
34225	49	2016-06-28 00:57:42.925858	47733
34226	49	2016-06-28 00:57:42.942546	47709
34227	48	2016-06-28 00:57:42.959632	2851
34228	48	2016-06-28 00:57:42.975043	2859
34229	48	2016-06-28 00:57:42.990213	2843
34230	48	2016-06-28 00:57:43.01885	2855
34231	48	2016-06-28 00:57:43.028808	2872
34232	48	2016-06-28 00:57:43.042837	2861
34233	48	2016-06-28 00:57:43.053073	2849
34234	48	2016-06-28 00:57:43.06172	2853
34235	48	2016-06-28 00:57:43.077548	2878
34236	48	2016-06-28 00:57:43.08798	2834
34237	48	2016-06-28 00:57:43.098176	2847
34238	48	2016-06-28 00:57:43.112774	2874
34239	48	2016-06-28 00:57:43.120383	2863
34240	48	2016-06-28 00:57:43.137997	2845
34241	50	2016-06-28 00:57:43.164647	47706
34242	50	2016-06-28 00:57:43.177804	47727
34243	50	2016-06-28 00:57:43.18558	47730
34244	50	2016-06-28 00:57:43.207175	47721
34245	50	2016-06-28 00:57:43.229681	47733
34246	50	2016-06-28 00:57:43.248113	47709
34247	47	2016-06-28 00:57:43.265652	2851
34248	47	2016-06-28 00:57:43.280487	2859
34249	47	2016-06-28 00:57:43.29761	2843
34250	47	2016-06-28 00:57:43.316885	2855
34251	47	2016-06-28 00:57:43.32768	2872
34252	47	2016-06-28 00:57:43.346071	2861
34253	47	2016-06-28 00:57:43.362513	2849
34254	47	2016-06-28 00:57:43.375568	2853
34255	47	2016-06-28 00:57:43.383421	2878
34256	47	2016-06-28 00:57:43.39565	2834
34257	47	2016-06-28 00:57:43.412927	2847
34258	47	2016-06-28 00:57:43.4276	2874
34259	47	2016-06-28 00:57:43.437955	2863
34260	47	2016-06-28 00:57:43.448262	2845
34261	41	2016-06-28 01:04:27.599352	2858
34262	41	2016-06-28 01:04:27.607897	2865
34263	41	2016-06-28 01:04:27.625857	2866
34264	44	2016-06-28 01:04:27.637381	2869
34265	42	2016-06-28 01:04:27.651549	2849
34266	42	2016-06-28 01:04:27.662505	2855
34267	42	2016-06-28 01:04:27.67803	2834
34268	42	2016-06-28 01:04:27.687978	2878
34269	42	2016-06-28 01:04:27.695914	2874
34270	42	2016-06-28 01:04:27.705471	2847
34271	42	2016-06-28 01:04:27.728973	2851
34272	42	2016-06-28 01:04:27.740432	2872
34273	43	2016-06-28 01:04:27.758226	2848
34274	43	2016-06-28 01:04:27.768323	2835
34275	43	2016-06-28 01:04:27.779519	2852
34276	43	2016-06-28 01:04:27.799833	2856
34277	43	2016-06-28 01:04:27.814106	2879
34278	43	2016-06-28 01:04:27.830913	2873
34279	43	2016-06-28 01:04:27.841031	2850
34280	43	2016-06-28 01:04:27.858029	2875
34281	40	2016-06-28 01:04:27.895913	47733
34282	40	2016-06-28 01:04:27.903027	47730
34283	40	2016-06-28 01:04:27.919818	47706
34284	40	2016-06-28 01:04:27.939387	47709
34285	40	2016-06-28 01:04:27.956448	47727
34286	40	2016-06-28 01:04:27.97112	47721
34287	49	2016-06-28 01:04:27.990143	47706
34288	49	2016-06-28 01:04:27.998091	47727
34289	49	2016-06-28 01:04:28.006065	47730
34290	49	2016-06-28 01:04:28.014242	47721
34291	49	2016-06-28 01:04:28.022076	47733
34292	49	2016-06-28 01:04:28.030633	47709
34293	48	2016-06-28 01:04:28.040064	2851
34294	48	2016-06-28 01:04:28.047786	2859
34295	48	2016-06-28 01:04:28.055765	2843
34296	48	2016-06-28 01:04:28.064707	2855
34297	48	2016-06-28 01:04:28.073224	2872
34298	48	2016-06-28 01:04:28.095674	2861
34299	48	2016-06-28 01:04:28.135587	2849
34300	48	2016-06-28 01:04:28.155678	2853
34301	48	2016-06-28 01:04:28.177291	2878
34302	48	2016-06-28 01:04:28.188917	2834
34303	48	2016-06-28 01:04:28.201528	2847
34304	48	2016-06-28 01:04:28.217348	2874
34305	48	2016-06-28 01:04:28.233464	2863
34306	48	2016-06-28 01:04:28.261578	2845
34307	50	2016-06-28 01:04:28.272306	47706
34308	50	2016-06-28 01:04:28.295495	47727
34309	50	2016-06-28 01:04:28.311185	47730
34310	50	2016-06-28 01:04:28.328169	47721
34311	50	2016-06-28 01:04:28.344092	47733
34312	50	2016-06-28 01:04:28.364247	47709
34313	47	2016-06-28 01:04:28.37796	2851
34314	47	2016-06-28 01:04:28.385722	2859
34315	47	2016-06-28 01:04:28.396604	2843
34316	47	2016-06-28 01:04:28.411371	2855
34317	47	2016-06-28 01:04:28.419157	2872
34318	47	2016-06-28 01:04:28.436677	2861
34319	47	2016-06-28 01:04:28.46318	2849
34320	47	2016-06-28 01:04:28.481436	2853
34321	47	2016-06-28 01:04:28.490338	2878
34322	47	2016-06-28 01:04:28.51769	2834
34323	47	2016-06-28 01:04:28.53997	2847
34324	47	2016-06-28 01:04:28.560148	2874
34325	47	2016-06-28 01:04:28.57586	2863
34326	47	2016-06-28 01:04:28.583516	2845
34327	41	2016-06-28 01:05:45.613115	2858
34328	41	2016-06-28 01:05:45.620758	2865
34329	41	2016-06-28 01:05:45.628549	2866
34330	44	2016-06-28 01:05:45.636765	2869
34331	42	2016-06-28 01:05:45.643901	2849
34332	42	2016-06-28 01:05:45.651377	2855
34333	42	2016-06-28 01:05:45.658376	2834
34334	42	2016-06-28 01:05:45.664922	2878
34335	42	2016-06-28 01:05:45.67187	2874
34336	42	2016-06-28 01:05:45.679092	2847
34337	42	2016-06-28 01:05:45.686261	2851
34338	42	2016-06-28 01:05:45.693023	2872
34339	43	2016-06-28 01:05:45.699821	2848
34340	43	2016-06-28 01:05:45.706748	2835
34341	43	2016-06-28 01:05:45.713521	2852
34342	43	2016-06-28 01:05:45.72098	2856
34343	43	2016-06-28 01:05:45.729232	2879
34344	43	2016-06-28 01:05:45.736651	2873
34345	43	2016-06-28 01:05:45.744002	2850
34346	43	2016-06-28 01:05:45.751378	2875
34347	40	2016-06-28 01:05:45.760378	47733
34348	40	2016-06-28 01:05:45.767529	47730
34349	40	2016-06-28 01:05:45.774749	47706
34350	40	2016-06-28 01:05:45.781491	47709
34351	40	2016-06-28 01:05:45.788493	47727
34352	40	2016-06-28 01:05:45.79518	47721
34353	49	2016-06-28 01:05:45.804818	47706
34354	49	2016-06-28 01:05:45.812607	47727
34355	49	2016-06-28 01:05:45.821156	47730
34356	49	2016-06-28 01:05:45.828634	47721
34357	49	2016-06-28 01:05:45.836564	47733
34358	49	2016-06-28 01:05:45.844339	47709
34359	48	2016-06-28 01:05:45.854654	2851
34360	48	2016-06-28 01:05:45.862704	2859
34361	48	2016-06-28 01:05:45.870922	2843
34362	48	2016-06-28 01:05:45.881335	2855
34363	48	2016-06-28 01:05:45.890014	2872
34364	48	2016-06-28 01:05:45.897847	2861
34365	48	2016-06-28 01:05:45.907369	2849
34366	48	2016-06-28 01:05:45.915317	2853
34367	48	2016-06-28 01:05:45.924252	2878
34368	48	2016-06-28 01:05:45.932365	2834
34369	48	2016-06-28 01:05:45.940683	2847
34370	48	2016-06-28 01:05:45.948521	2874
34371	48	2016-06-28 01:05:45.955749	2863
34372	48	2016-06-28 01:05:45.963119	2845
34373	50	2016-06-28 01:05:45.97161	47706
34374	50	2016-06-28 01:05:45.979382	47727
34375	50	2016-06-28 01:05:45.987233	47730
34376	50	2016-06-28 01:05:45.994896	47721
34377	50	2016-06-28 01:05:46.002575	47733
34378	50	2016-06-28 01:05:46.010099	47709
34379	47	2016-06-28 01:05:46.018918	2851
34380	47	2016-06-28 01:05:46.026318	2859
34381	47	2016-06-28 01:05:46.033479	2843
34382	47	2016-06-28 01:05:46.041573	2855
34383	47	2016-06-28 01:05:46.049522	2872
34384	47	2016-06-28 01:05:46.057817	2861
34385	47	2016-06-28 01:05:46.06578	2849
34386	47	2016-06-28 01:05:46.073274	2853
34387	47	2016-06-28 01:05:46.08134	2878
34388	47	2016-06-28 01:05:46.089919	2834
34389	47	2016-06-28 01:05:46.098422	2847
34390	47	2016-06-28 01:05:46.107484	2874
34391	47	2016-06-28 01:05:46.114987	2863
34392	47	2016-06-28 01:05:46.123105	2845
34393	41	2016-06-28 01:06:57.32275	2858
34394	41	2016-06-28 01:06:57.331225	2865
34395	41	2016-06-28 01:06:57.339162	2866
34396	44	2016-06-28 01:06:57.347251	2869
34397	42	2016-06-28 01:06:57.354941	2849
34398	42	2016-06-28 01:06:57.36211	2855
34399	42	2016-06-28 01:06:57.369033	2834
34400	42	2016-06-28 01:06:57.376245	2878
34401	42	2016-06-28 01:06:57.382963	2874
34402	42	2016-06-28 01:06:57.389624	2847
34403	42	2016-06-28 01:06:57.39635	2851
34404	42	2016-06-28 01:06:57.403329	2872
34405	43	2016-06-28 01:06:57.411101	2848
34406	43	2016-06-28 01:06:57.417756	2835
34407	43	2016-06-28 01:06:57.42433	2852
34408	43	2016-06-28 01:06:57.432359	2856
34409	43	2016-06-28 01:06:57.439761	2879
34410	43	2016-06-28 01:06:57.446593	2873
34411	43	2016-06-28 01:06:57.453183	2850
34412	43	2016-06-28 01:06:57.459951	2875
34413	40	2016-06-28 01:06:57.46792	47733
34414	40	2016-06-28 01:06:57.474487	47730
34415	40	2016-06-28 01:06:57.481545	47706
34416	40	2016-06-28 01:06:57.488159	47709
34417	40	2016-06-28 01:06:57.494548	47727
34418	40	2016-06-28 01:06:57.501546	47721
34419	49	2016-06-28 01:06:57.510937	47706
34420	49	2016-06-28 01:06:57.518828	47727
34421	49	2016-06-28 01:06:57.526879	47730
34422	49	2016-06-28 01:06:57.534794	47721
34423	49	2016-06-28 01:06:57.542776	47733
34424	49	2016-06-28 01:06:57.55045	47709
34425	48	2016-06-28 01:06:57.56075	2851
34426	48	2016-06-28 01:06:57.568653	2859
34427	48	2016-06-28 01:06:57.576635	2843
34428	48	2016-06-28 01:06:57.585123	2855
34429	48	2016-06-28 01:06:57.594277	2872
34430	48	2016-06-28 01:06:57.601892	2861
34431	48	2016-06-28 01:06:57.610551	2849
34432	48	2016-06-28 01:06:57.618031	2853
34433	48	2016-06-28 01:06:57.627322	2878
34434	48	2016-06-28 01:06:57.635791	2834
34435	48	2016-06-28 01:06:57.64451	2847
34436	48	2016-06-28 01:06:57.652941	2874
34437	48	2016-06-28 01:06:57.660935	2863
34438	48	2016-06-28 01:06:57.669534	2845
34439	50	2016-06-28 01:06:57.679029	47706
34440	50	2016-06-28 01:06:57.686968	47727
34441	50	2016-06-28 01:06:57.69504	47730
34442	50	2016-06-28 01:06:57.702762	47721
34443	50	2016-06-28 01:06:57.711362	47733
34444	50	2016-06-28 01:06:57.719803	47709
34445	47	2016-06-28 01:06:57.729899	2851
34446	47	2016-06-28 01:06:57.737422	2859
34447	47	2016-06-28 01:06:57.744638	2843
34448	47	2016-06-28 01:06:57.752701	2855
34449	47	2016-06-28 01:06:57.760254	2872
34450	47	2016-06-28 01:06:57.767525	2861
34451	47	2016-06-28 01:06:57.775532	2849
34452	47	2016-06-28 01:06:57.783158	2853
34453	47	2016-06-28 01:06:57.790755	2878
34454	47	2016-06-28 01:06:57.798532	2834
34455	47	2016-06-28 01:06:57.807128	2847
34456	47	2016-06-28 01:06:57.814786	2874
34457	47	2016-06-28 01:06:57.821982	2863
34458	47	2016-06-28 01:06:57.829854	2845
34459	41	2016-06-28 01:10:46.936504	2858
34460	41	2016-06-28 01:10:46.962203	2865
34461	41	2016-06-28 01:10:46.970884	2866
34462	44	2016-06-28 01:10:46.979556	2869
34463	42	2016-06-28 01:10:46.98663	2849
34464	42	2016-06-28 01:10:46.994127	2855
34465	42	2016-06-28 01:10:47.000897	2834
34466	42	2016-06-28 01:10:47.007758	2878
34467	42	2016-06-28 01:10:47.014326	2874
34468	42	2016-06-28 01:10:47.020975	2847
34469	42	2016-06-28 01:10:47.027882	2851
34470	42	2016-06-28 01:10:47.034715	2872
34471	43	2016-06-28 01:10:47.041971	2848
34472	43	2016-06-28 01:10:47.049185	2835
34473	43	2016-06-28 01:10:47.055973	2852
34474	43	2016-06-28 01:10:47.062612	2856
34475	43	2016-06-28 01:10:47.069464	2879
34476	43	2016-06-28 01:10:47.076648	2873
34477	43	2016-06-28 01:10:47.083444	2850
34478	43	2016-06-28 01:10:47.090156	2875
34479	40	2016-06-28 01:10:47.098085	47733
34480	40	2016-06-28 01:10:47.104452	47730
34481	40	2016-06-28 01:10:47.111389	47706
34482	40	2016-06-28 01:10:47.11778	47709
34483	40	2016-06-28 01:10:47.124259	47727
34484	40	2016-06-28 01:10:47.130972	47721
34485	49	2016-06-28 01:10:47.140474	47706
34486	49	2016-06-28 01:10:47.148098	47727
34487	49	2016-06-28 01:10:47.156169	47730
34488	49	2016-06-28 01:10:47.163679	47721
34489	49	2016-06-28 01:10:47.17209	47733
34490	49	2016-06-28 01:10:47.180076	47709
34491	48	2016-06-28 01:10:47.190336	2851
34492	48	2016-06-28 01:10:47.197921	2859
34493	48	2016-06-28 01:10:47.206147	2843
34494	48	2016-06-28 01:10:47.214743	2855
34495	48	2016-06-28 01:10:47.223918	2872
34496	48	2016-06-28 01:10:47.231721	2861
34497	48	2016-06-28 01:10:47.24045	2849
34498	48	2016-06-28 01:10:47.248279	2853
34499	48	2016-06-28 01:10:47.257026	2878
34500	48	2016-06-28 01:10:47.265766	2834
34501	48	2016-06-28 01:10:47.274816	2847
34502	48	2016-06-28 01:10:47.282911	2874
34503	48	2016-06-28 01:10:47.291333	2863
34504	48	2016-06-28 01:10:47.298907	2845
34505	50	2016-06-28 01:10:47.307866	47706
34506	50	2016-06-28 01:10:47.315932	47727
34507	50	2016-06-28 01:10:47.324322	47730
34508	50	2016-06-28 01:10:47.333287	47721
34509	50	2016-06-28 01:10:47.342216	47733
34510	50	2016-06-28 01:10:47.349965	47709
34511	47	2016-06-28 01:10:47.358718	2851
34512	47	2016-06-28 01:10:47.366079	2859
34513	47	2016-06-28 01:10:47.373301	2843
34514	47	2016-06-28 01:10:47.381112	2855
34515	47	2016-06-28 01:10:47.389111	2872
34516	47	2016-06-28 01:10:47.396213	2861
34517	47	2016-06-28 01:10:47.403941	2849
34518	47	2016-06-28 01:10:47.411381	2853
34519	47	2016-06-28 01:10:47.419282	2878
34520	47	2016-06-28 01:10:47.42744	2834
34521	47	2016-06-28 01:10:47.435272	2847
34522	47	2016-06-28 01:10:47.443161	2874
34523	47	2016-06-28 01:10:47.45041	2863
34524	47	2016-06-28 01:10:47.457516	2845
34525	41	2016-06-28 01:28:15.718723	2858
34526	41	2016-06-28 01:28:15.726608	2865
34527	41	2016-06-28 01:28:15.734324	2866
34528	44	2016-06-28 01:28:15.742736	2869
34529	42	2016-06-28 01:28:15.751129	2849
34530	42	2016-06-28 01:28:15.758214	2855
34531	42	2016-06-28 01:28:15.7649	2834
34532	42	2016-06-28 01:28:15.771996	2878
34533	42	2016-06-28 01:28:15.778538	2874
34534	42	2016-06-28 01:28:15.785578	2847
34535	42	2016-06-28 01:28:15.79267	2851
34536	42	2016-06-28 01:28:15.799604	2872
34537	43	2016-06-28 01:28:15.807386	2848
34538	43	2016-06-28 01:28:15.814714	2835
34539	43	2016-06-28 01:28:15.821364	2852
34540	43	2016-06-28 01:28:15.828065	2856
34541	43	2016-06-28 01:28:15.834908	2879
34542	43	2016-06-28 01:28:15.841462	2873
34543	43	2016-06-28 01:28:15.847995	2850
34544	43	2016-06-28 01:28:15.854762	2875
34545	40	2016-06-28 01:28:15.862717	47733
34546	40	2016-06-28 01:28:15.869743	47730
34547	40	2016-06-28 01:28:15.876323	47706
34548	40	2016-06-28 01:28:15.882689	47709
34549	40	2016-06-28 01:28:15.889772	47727
34550	40	2016-06-28 01:28:15.896219	47721
34551	49	2016-06-28 01:28:15.905896	47706
34552	49	2016-06-28 01:28:15.913334	47727
34553	49	2016-06-28 01:28:15.921057	47730
34554	49	2016-06-28 01:28:15.929	47721
34555	49	2016-06-28 01:28:15.938064	47733
34556	49	2016-06-28 01:28:15.945724	47709
34557	48	2016-06-28 01:28:15.955458	2851
34558	48	2016-06-28 01:28:15.962853	2859
34559	48	2016-06-28 01:28:15.971008	2843
34560	48	2016-06-28 01:28:15.979166	2855
34561	48	2016-06-28 01:28:15.987496	2872
34562	48	2016-06-28 01:28:15.995161	2861
34563	48	2016-06-28 01:28:16.004838	2849
34564	48	2016-06-28 01:28:16.017795	2853
34565	48	2016-06-28 01:28:16.041123	2878
34566	48	2016-06-28 01:28:16.049314	2834
34567	48	2016-06-28 01:28:16.05733	2847
34568	48	2016-06-28 01:28:16.065747	2874
34569	48	2016-06-28 01:28:16.073242	2863
34570	48	2016-06-28 01:28:16.08046	2845
34571	50	2016-06-28 01:28:16.089326	47706
34572	50	2016-06-28 01:28:16.097493	47727
34573	50	2016-06-28 01:28:16.105734	47730
34574	50	2016-06-28 01:28:16.114	47721
34575	50	2016-06-28 01:28:16.121896	47733
34576	50	2016-06-28 01:28:16.129624	47709
34577	47	2016-06-28 01:28:16.139511	2851
34578	47	2016-06-28 01:28:16.146823	2859
34579	47	2016-06-28 01:28:16.155143	2843
34580	47	2016-06-28 01:28:16.163451	2855
34581	47	2016-06-28 01:28:16.171928	2872
34582	47	2016-06-28 01:28:16.179672	2861
34583	47	2016-06-28 01:28:16.1883	2849
34584	47	2016-06-28 01:28:16.195986	2853
34585	47	2016-06-28 01:28:16.20507	2878
34586	47	2016-06-28 01:28:16.213343	2834
34587	47	2016-06-28 01:28:16.222026	2847
34588	47	2016-06-28 01:28:16.230097	2874
34589	47	2016-06-28 01:28:16.238265	2863
34590	47	2016-06-28 01:28:16.245964	2845
34591	41	2016-06-28 15:50:12.87567	2858
34592	41	2016-06-28 15:50:12.884269	2865
34593	41	2016-06-28 15:50:12.89328	2866
34594	44	2016-06-28 15:50:12.902191	2869
34595	42	2016-06-28 15:50:12.90966	2849
34596	42	2016-06-28 15:50:12.9169	2855
34597	42	2016-06-28 15:50:12.924185	2834
34598	42	2016-06-28 15:50:12.93116	2878
34599	42	2016-06-28 15:50:12.938464	2874
34600	42	2016-06-28 15:50:12.945252	2847
34601	42	2016-06-28 15:50:12.952006	2851
34602	42	2016-06-28 15:50:12.960014	2872
34603	43	2016-06-28 15:50:12.967422	2848
34604	43	2016-06-28 15:50:12.974675	2835
34605	43	2016-06-28 15:50:12.981961	2852
34606	43	2016-06-28 15:50:12.989062	2856
34607	43	2016-06-28 15:50:12.996763	2879
34608	43	2016-06-28 15:50:13.00358	2873
34609	43	2016-06-28 15:50:13.011447	2850
34610	43	2016-06-28 15:50:13.018469	2875
34611	40	2016-06-28 15:50:13.052288	47733
34612	40	2016-06-28 15:50:13.060558	47730
34613	40	2016-06-28 15:50:13.067505	47706
34614	40	2016-06-28 15:50:13.074901	47709
34615	40	2016-06-28 15:50:13.102434	47727
34616	40	2016-06-28 15:50:13.10999	47721
34617	49	2016-06-28 15:50:13.119103	47706
34618	49	2016-06-28 15:50:13.126738	47727
34619	49	2016-06-28 15:50:13.134912	47730
34620	49	2016-06-28 15:50:13.165722	47721
34621	49	2016-06-28 15:50:13.182285	47733
34622	49	2016-06-28 15:50:13.206774	47709
34623	48	2016-06-28 15:50:13.233749	2851
34624	48	2016-06-28 15:50:13.252565	2859
34625	48	2016-06-28 15:50:13.264406	2843
34626	48	2016-06-28 15:50:13.283977	2855
34627	48	2016-06-28 15:50:13.313985	2872
34628	48	2016-06-28 15:50:13.335194	2861
34629	48	2016-06-28 15:50:13.36118	2849
34630	48	2016-06-28 15:50:13.374579	2853
34631	48	2016-06-28 15:50:13.391002	2878
34632	48	2016-06-28 15:50:13.400269	2834
34633	48	2016-06-28 15:50:13.413069	2847
34634	48	2016-06-28 15:50:13.428333	2874
34635	48	2016-06-28 15:50:13.438438	2863
34636	48	2016-06-28 15:50:13.458082	2845
34637	50	2016-06-28 15:50:13.48096	47706
34638	50	2016-06-28 15:50:13.490164	47727
34639	50	2016-06-28 15:50:13.500116	47730
34640	50	2016-06-28 15:50:13.52329	47721
34641	50	2016-06-28 15:50:13.544629	47733
34642	50	2016-06-28 15:50:13.565442	47709
34643	47	2016-06-28 15:50:13.583682	2851
34644	47	2016-06-28 15:50:13.59277	2859
34645	47	2016-06-28 15:50:13.633501	2843
34646	47	2016-06-28 15:50:13.649186	2855
34647	47	2016-06-28 15:50:13.671186	2872
34648	47	2016-06-28 15:50:13.679502	2861
34649	47	2016-06-28 15:50:13.697619	2849
34650	47	2016-06-28 15:50:13.712076	2853
34651	47	2016-06-28 15:50:13.72366	2878
34652	47	2016-06-28 15:50:13.750393	2834
34653	47	2016-06-28 15:50:13.768728	2847
34654	47	2016-06-28 15:50:13.787159	2874
34655	47	2016-06-28 15:50:13.800015	2863
34656	47	2016-06-28 15:50:13.814738	2845
34657	41	2016-06-28 15:51:15.947233	2858
34658	41	2016-06-28 15:51:15.955439	2865
34659	41	2016-06-28 15:51:15.96276	2866
34660	42	2016-06-28 15:51:15.970147	2849
34661	42	2016-06-28 15:51:15.976905	2855
34662	42	2016-06-28 15:51:15.983892	2834
34663	42	2016-06-28 15:51:15.990514	2878
34664	42	2016-06-28 15:51:15.997056	2874
34665	42	2016-06-28 15:51:16.003666	2847
34666	42	2016-06-28 15:51:16.010253	2851
34667	42	2016-06-28 15:51:16.016911	2872
34668	43	2016-06-28 15:51:16.024348	2848
34669	43	2016-06-28 15:51:16.03091	2835
34670	43	2016-06-28 15:51:16.037631	2852
34671	43	2016-06-28 15:51:16.044399	2856
34672	43	2016-06-28 15:51:16.050849	2879
34673	43	2016-06-28 15:51:16.057432	2873
34674	43	2016-06-28 15:51:16.06431	2850
34675	43	2016-06-28 15:51:16.070833	2875
34676	40	2016-06-28 15:51:16.07895	47706
34677	40	2016-06-28 15:51:16.085983	47733
34678	40	2016-06-28 15:51:16.092333	47730
34679	40	2016-06-28 15:51:16.099414	47709
34680	40	2016-06-28 15:51:16.105703	47727
34681	40	2016-06-28 15:51:16.112262	47721
34682	49	2016-06-28 15:51:16.12195	47706
34683	49	2016-06-28 15:51:16.129401	47727
34684	49	2016-06-28 15:51:16.136638	47730
34685	49	2016-06-28 15:51:16.144321	47721
34686	49	2016-06-28 15:51:16.152469	47733
34687	49	2016-06-28 15:51:16.159697	47709
34688	48	2016-06-28 15:51:16.169682	2851
34689	48	2016-06-28 15:51:16.177643	2859
34690	48	2016-06-28 15:51:16.184922	2843
34691	48	2016-06-28 15:51:16.193505	2855
34692	48	2016-06-28 15:51:16.201287	2872
34693	48	2016-06-28 15:51:16.209223	2861
34694	48	2016-06-28 15:51:16.217372	2849
34695	48	2016-06-28 15:51:16.224613	2853
34696	48	2016-06-28 15:51:16.232342	2878
34697	48	2016-06-28 15:51:16.240149	2834
34698	48	2016-06-28 15:51:16.248484	2847
34699	48	2016-06-28 15:51:16.256223	2874
34700	48	2016-06-28 15:51:16.263484	2863
34701	48	2016-06-28 15:51:16.272005	2845
34702	50	2016-06-28 15:51:16.283923	47706
34703	50	2016-06-28 15:51:16.293372	47727
34704	50	2016-06-28 15:51:16.301178	47730
34705	50	2016-06-28 15:51:16.309103	47721
34706	50	2016-06-28 15:51:16.317026	47733
34707	50	2016-06-28 15:51:16.325067	47709
34708	47	2016-06-28 15:51:16.334272	2851
34709	47	2016-06-28 15:51:16.341971	2859
34710	47	2016-06-28 15:51:16.349611	2843
34711	47	2016-06-28 15:51:16.358034	2855
34712	47	2016-06-28 15:51:16.36595	2872
34713	47	2016-06-28 15:51:16.373593	2861
34714	47	2016-06-28 15:51:16.381328	2849
34715	47	2016-06-28 15:51:16.389009	2853
34716	47	2016-06-28 15:51:16.396553	2878
34717	47	2016-06-28 15:51:16.404889	2834
34718	47	2016-06-28 15:51:16.412689	2847
34719	47	2016-06-28 15:51:16.421896	2874
34720	47	2016-06-28 15:51:16.429273	2863
34721	47	2016-06-28 15:51:16.436685	2845
34722	41	2016-06-28 20:04:03.981633	2858
34723	41	2016-06-28 20:04:04.023648	2865
34724	41	2016-06-28 20:04:04.031404	2866
34725	45	2016-06-28 20:04:04.039448	2891
34726	42	2016-06-28 20:04:04.046398	2849
34727	42	2016-06-28 20:04:04.053583	2855
34728	42	2016-06-28 20:04:04.060461	2834
34729	42	2016-06-28 20:04:04.067125	2878
34730	42	2016-06-28 20:04:04.376835	2874
34731	42	2016-06-28 20:04:04.385191	2847
34732	42	2016-06-28 20:04:04.392522	2851
34733	42	2016-06-28 20:04:04.399082	2872
34734	43	2016-06-28 20:04:04.405795	2848
34735	43	2016-06-28 20:04:04.412889	2835
34736	43	2016-06-28 20:04:04.42038	2852
34737	43	2016-06-28 20:04:04.427272	2856
34738	43	2016-06-28 20:04:04.449657	2879
34739	43	2016-06-28 20:04:04.475639	2873
34740	43	2016-06-28 20:04:04.482725	2850
34741	43	2016-06-28 20:04:04.490047	2875
34742	40	2016-06-28 20:04:04.578246	47706
34743	40	2016-06-28 20:04:04.585544	47733
34744	40	2016-06-28 20:04:04.592334	47730
34745	40	2016-06-28 20:04:04.599587	47709
34746	40	2016-06-28 20:04:04.606112	47727
34747	40	2016-06-28 20:04:04.612459	47721
34748	49	2016-06-28 20:04:04.62149	47706
34749	49	2016-06-28 20:04:04.628921	47727
34750	49	2016-06-28 20:04:04.636208	47730
34751	49	2016-06-28 20:04:04.643443	47721
34752	49	2016-06-28 20:04:04.650601	47733
34753	49	2016-06-28 20:04:04.658094	47709
34754	48	2016-06-28 20:04:04.667367	2851
34755	48	2016-06-28 20:04:04.674543	2859
34756	48	2016-06-28 20:04:04.682252	2843
34757	48	2016-06-28 20:04:04.690446	2855
34758	48	2016-06-28 20:04:04.698684	2872
34759	48	2016-06-28 20:04:04.705898	2861
34760	48	2016-06-28 20:04:04.714167	2849
34761	48	2016-06-28 20:04:04.723156	2853
34762	48	2016-06-28 20:04:04.731001	2878
34763	48	2016-06-28 20:04:04.739238	2834
34764	48	2016-06-28 20:04:04.747608	2847
34765	48	2016-06-28 20:04:04.755109	2874
34766	48	2016-06-28 20:04:04.762142	2863
34767	48	2016-06-28 20:04:04.769189	2845
34768	50	2016-06-28 20:04:04.778186	47706
34769	50	2016-06-28 20:04:04.78571	47727
34770	50	2016-06-28 20:04:04.793219	47730
34771	50	2016-06-28 20:04:04.800691	47721
34772	50	2016-06-28 20:04:04.808272	47733
34773	50	2016-06-28 20:04:04.815781	47709
34774	47	2016-06-28 20:04:04.824709	2851
34775	47	2016-06-28 20:04:04.832061	2859
34776	47	2016-06-28 20:04:04.839434	2843
34777	47	2016-06-28 20:04:04.847282	2855
34778	47	2016-06-28 20:04:04.854693	2872
34779	47	2016-06-28 20:04:04.861692	2861
34780	47	2016-06-28 20:04:04.870006	2849
34781	47	2016-06-28 20:04:04.877716	2853
34782	47	2016-06-28 20:04:04.885904	2878
34783	47	2016-06-28 20:04:04.908563	2834
34784	47	2016-06-28 20:04:04.935881	2847
34785	47	2016-06-28 20:04:04.963034	2874
34786	47	2016-06-28 20:04:04.987303	2863
34787	47	2016-06-28 20:04:04.99488	2845
34788	41	2016-06-29 13:23:40.6418	2858
34789	41	2016-06-29 13:23:40.709719	2865
34790	41	2016-06-29 13:23:40.718817	2866
34791	45	2016-06-29 13:23:40.72666	2891
34792	42	2016-06-29 13:23:40.733527	2892
34793	42	2016-06-29 13:23:40.74026	2849
34794	42	2016-06-29 13:23:40.746839	2855
34795	42	2016-06-29 13:23:40.754104	2834
34796	42	2016-06-29 13:23:40.760708	2878
34797	42	2016-06-29 13:23:40.766912	2874
34798	42	2016-06-29 13:23:40.773528	2847
34799	42	2016-06-29 13:23:40.779979	2851
34800	42	2016-06-29 13:23:40.786708	2872
34801	43	2016-06-29 13:23:40.793551	2848
34802	43	2016-06-29 13:23:40.800154	2835
34803	43	2016-06-29 13:23:40.806923	2852
34804	43	2016-06-29 13:23:40.813293	2856
34805	43	2016-06-29 13:23:40.819975	2893
34806	43	2016-06-29 13:23:40.826509	2879
34807	43	2016-06-29 13:23:40.83287	2873
34808	43	2016-06-29 13:23:40.839436	2850
34809	43	2016-06-29 13:23:40.845905	2875
34810	40	2016-06-29 13:23:40.853816	47706
34811	40	2016-06-29 13:23:40.860188	47733
34812	40	2016-06-29 13:23:40.866301	47730
34813	40	2016-06-29 13:23:40.872691	47709
34814	40	2016-06-29 13:23:40.878874	47727
34815	40	2016-06-29 13:23:40.885047	47721
34816	49	2016-06-29 13:23:40.915628	47706
34817	49	2016-06-29 13:23:40.92402	47727
34818	49	2016-06-29 13:23:40.931509	47730
34819	49	2016-06-29 13:23:40.939123	47721
34820	49	2016-06-29 13:23:40.946379	47733
34821	49	2016-06-29 13:23:40.953627	47709
34822	48	2016-06-29 13:23:40.962708	2851
34823	48	2016-06-29 13:23:40.970178	2859
34824	48	2016-06-29 13:23:40.97725	2843
34825	48	2016-06-29 13:23:40.985275	2855
34826	48	2016-06-29 13:23:40.993017	2872
34827	48	2016-06-29 13:23:41.000269	2861
34828	48	2016-06-29 13:23:41.008232	2849
34829	48	2016-06-29 13:23:41.015504	2853
34830	48	2016-06-29 13:23:41.023746	2878
34831	48	2016-06-29 13:23:41.031683	2834
34832	48	2016-06-29 13:23:41.039907	2847
34833	48	2016-06-29 13:23:41.047978	2874
34834	48	2016-06-29 13:23:41.055412	2863
34835	48	2016-06-29 13:23:41.062566	2845
34836	50	2016-06-29 13:23:41.071527	47706
34837	50	2016-06-29 13:23:41.079026	47727
34838	50	2016-06-29 13:23:41.086738	47730
34839	50	2016-06-29 13:23:41.094207	47721
34840	50	2016-06-29 13:23:41.101704	47733
34841	50	2016-06-29 13:23:41.109219	47709
34842	47	2016-06-29 13:23:41.118045	2851
34843	47	2016-06-29 13:23:41.125355	2859
34844	47	2016-06-29 13:23:41.132395	2843
34845	47	2016-06-29 13:23:41.140315	2855
34846	47	2016-06-29 13:23:41.14812	2872
34847	47	2016-06-29 13:23:41.155367	2861
34848	47	2016-06-29 13:23:41.162946	2849
34849	47	2016-06-29 13:23:41.170501	2853
34850	47	2016-06-29 13:23:41.178046	2878
34851	47	2016-06-29 13:23:41.18578	2834
34852	47	2016-06-29 13:23:41.193465	2847
34853	47	2016-06-29 13:23:41.201032	2874
34854	47	2016-06-29 13:23:41.208064	2863
34855	47	2016-06-29 13:23:41.215223	2845
34856	41	2016-06-29 13:25:46.723745	2858
34857	41	2016-06-29 13:25:46.732003	2865
34858	41	2016-06-29 13:25:46.740273	2866
34859	45	2016-06-29 13:25:46.74833	2891
34860	42	2016-06-29 13:25:46.756341	2892
34861	42	2016-06-29 13:25:46.763297	2849
34862	42	2016-06-29 13:25:46.770471	2855
34863	42	2016-06-29 13:25:46.777227	2834
34864	42	2016-06-29 13:25:46.784211	2878
34865	42	2016-06-29 13:25:46.791206	2874
34866	42	2016-06-29 13:25:46.797971	2847
34867	42	2016-06-29 13:25:46.805697	2851
34868	42	2016-06-29 13:25:46.812515	2872
34869	43	2016-06-29 13:25:46.821329	2848
34870	43	2016-06-29 13:25:46.828627	2835
34871	43	2016-06-29 13:25:46.836159	2852
34872	43	2016-06-29 13:25:46.843152	2856
34873	43	2016-06-29 13:25:46.849942	2893
34874	43	2016-06-29 13:25:46.857435	2879
34875	43	2016-06-29 13:25:46.864022	2873
34876	43	2016-06-29 13:25:46.87216	2850
34877	43	2016-06-29 13:25:46.879078	2875
34878	40	2016-06-29 13:25:46.898694	47706
34879	40	2016-06-29 13:25:46.905784	47733
34880	40	2016-06-29 13:25:46.912151	47730
34881	40	2016-06-29 13:25:46.918965	47709
34882	40	2016-06-29 13:25:46.925544	47727
34883	40	2016-06-29 13:25:46.932677	47721
34884	49	2016-06-29 13:25:46.944064	47706
34885	49	2016-06-29 13:25:46.951758	47727
34886	49	2016-06-29 13:25:46.95991	47730
34887	49	2016-06-29 13:25:46.967467	47721
34888	49	2016-06-29 13:25:46.975513	47733
34889	49	2016-06-29 13:25:46.983359	47709
34890	48	2016-06-29 13:25:46.993519	2851
34891	48	2016-06-29 13:25:47.000976	2859
34892	48	2016-06-29 13:25:47.008967	2843
34893	48	2016-06-29 13:25:47.017053	2855
34894	48	2016-06-29 13:25:47.025894	2872
34895	48	2016-06-29 13:25:47.033409	2861
34896	48	2016-06-29 13:25:47.042357	2849
34897	48	2016-06-29 13:25:47.049861	2853
34898	48	2016-06-29 13:25:47.058577	2878
34899	48	2016-06-29 13:25:47.06708	2834
34900	48	2016-06-29 13:25:47.075679	2847
34901	48	2016-06-29 13:25:47.083467	2874
34902	48	2016-06-29 13:25:47.090993	2863
34903	48	2016-06-29 13:25:47.098319	2845
34904	50	2016-06-29 13:25:47.107281	47706
34905	50	2016-06-29 13:25:47.114976	47727
34906	50	2016-06-29 13:25:47.123122	47730
34907	50	2016-06-29 13:25:47.130622	47721
34908	50	2016-06-29 13:25:47.138368	47733
34909	50	2016-06-29 13:25:47.146056	47709
34910	47	2016-06-29 13:25:47.155841	2851
34911	47	2016-06-29 13:25:47.163532	2859
34912	47	2016-06-29 13:25:47.173936	2843
34913	47	2016-06-29 13:25:47.190237	2855
34914	47	2016-06-29 13:25:47.203139	2872
34915	47	2016-06-29 13:25:47.211682	2861
34916	47	2016-06-29 13:25:47.220054	2849
34917	47	2016-06-29 13:25:47.227432	2853
34918	47	2016-06-29 13:25:47.235538	2878
34919	47	2016-06-29 13:25:47.243425	2834
34920	47	2016-06-29 13:25:47.251139	2847
34921	47	2016-06-29 13:25:47.258598	2874
34922	47	2016-06-29 13:25:47.265948	2863
34923	47	2016-06-29 13:25:47.273417	2845
34924	47	2016-06-29 13:25:47.281298	2892
34925	41	2016-06-29 16:23:34.77273	2858
34926	41	2016-06-29 16:23:35.172568	2865
34927	41	2016-06-29 16:23:35.311309	2866
34928	45	2016-06-29 16:23:35.470888	2891
34929	42	2016-06-29 16:23:35.620159	2892
34930	42	2016-06-29 16:23:35.993586	2849
34931	42	2016-06-29 16:23:36.184442	2855
34932	42	2016-06-29 16:23:36.485002	2834
34933	42	2016-06-29 16:23:36.713157	2878
34934	42	2016-06-29 16:23:37.015949	2874
34935	42	2016-06-29 16:23:37.242119	2847
34936	42	2016-06-29 16:23:37.370137	2851
34937	42	2016-06-29 16:23:37.598684	2872
34938	43	2016-06-29 16:23:37.99301	2848
34939	43	2016-06-29 16:23:38.178098	2835
34940	43	2016-06-29 16:23:38.229672	2852
34941	43	2016-06-29 16:23:38.442117	2856
34942	43	2016-06-29 16:23:38.506486	2893
34943	43	2016-06-29 16:23:38.710241	2879
34944	43	2016-06-29 16:23:38.879723	2873
34945	43	2016-06-29 16:23:38.97314	2850
34946	43	2016-06-29 16:23:39.113101	2875
34947	40	2016-06-29 16:23:39.43621	47706
34948	40	2016-06-29 16:23:39.559194	47733
34949	40	2016-06-29 16:23:39.74155	47730
34950	40	2016-06-29 16:23:39.894333	47709
34951	40	2016-06-29 16:23:40.04716	47727
34952	40	2016-06-29 16:23:40.144689	47721
34953	49	2016-06-29 16:23:40.471164	47706
34954	49	2016-06-29 16:23:40.546528	47727
34955	49	2016-06-29 16:23:40.716292	47730
34956	49	2016-06-29 16:23:40.889022	47721
34957	49	2016-06-29 16:23:41.240512	47733
34958	49	2016-06-29 16:23:41.420429	47709
34959	48	2016-06-29 16:23:41.567872	2851
34960	48	2016-06-29 16:23:41.825115	2859
34961	48	2016-06-29 16:23:41.990704	2843
34962	48	2016-06-29 16:23:42.134142	2855
34963	48	2016-06-29 16:23:42.213543	2872
34964	48	2016-06-29 16:23:42.253964	2861
34965	48	2016-06-29 16:23:42.341381	2849
34966	48	2016-06-29 16:23:42.495441	2853
34967	48	2016-06-29 16:23:42.657411	2878
34968	48	2016-06-29 16:23:42.703043	2834
34969	48	2016-06-29 16:23:42.783388	2847
34970	48	2016-06-29 16:23:42.820269	2874
34971	48	2016-06-29 16:23:43.066499	2863
34972	48	2016-06-29 16:23:43.163627	2845
34973	48	2016-06-29 16:23:43.222398	2892
34974	50	2016-06-29 16:23:43.325307	47706
34975	50	2016-06-29 16:23:43.651987	47727
34976	50	2016-06-29 16:23:43.964319	47730
34977	50	2016-06-29 16:23:44.373976	47721
34978	50	2016-06-29 16:23:44.420454	47733
34979	50	2016-06-29 16:23:44.603348	47709
34980	47	2016-06-29 16:23:44.836801	2851
34981	47	2016-06-29 16:23:44.898136	2859
34982	47	2016-06-29 16:23:45.108192	2843
34983	47	2016-06-29 16:23:45.236355	2855
34984	47	2016-06-29 16:23:45.371888	2872
34985	47	2016-06-29 16:23:45.512374	2861
34986	47	2016-06-29 16:23:45.618432	2849
34987	47	2016-06-29 16:23:45.893613	2853
34988	47	2016-06-29 16:23:46.105633	2878
34989	47	2016-06-29 16:23:46.367909	2834
34990	47	2016-06-29 16:23:46.474395	2847
34991	47	2016-06-29 16:23:46.803045	2874
34992	47	2016-06-29 16:23:47.006443	2863
34993	47	2016-06-29 16:23:47.106908	2845
34994	47	2016-06-29 16:23:47.2679	2892
34995	41	2016-06-29 16:24:35.48676	2858
34996	41	2016-06-29 16:24:35.528779	2865
34997	41	2016-06-29 16:24:35.539809	2866
34998	45	2016-06-29 16:24:35.551027	2891
34999	42	2016-06-29 16:24:43.034018	2892
35000	42	2016-06-29 16:24:43.198947	2849
35001	42	2016-06-29 16:24:43.248932	2855
35002	42	2016-06-29 16:24:43.263875	2834
35003	42	2016-06-29 16:24:43.29155	2878
35004	42	2016-06-29 16:24:43.309028	2874
35005	42	2016-06-29 16:24:43.338482	2847
35006	42	2016-06-29 16:24:43.349001	2851
35007	42	2016-06-29 16:24:43.360861	2872
35008	43	2016-06-29 16:24:43.416381	2848
35009	43	2016-06-29 16:24:43.426712	2835
35010	43	2016-06-29 16:24:43.434988	2852
35011	43	2016-06-29 16:24:43.455027	2856
35012	43	2016-06-29 16:24:43.480568	2893
35013	43	2016-06-29 16:24:43.489692	2879
35014	43	2016-06-29 16:24:43.496876	2873
35015	43	2016-06-29 16:24:43.508974	2850
35016	43	2016-06-29 16:24:43.522694	2875
35017	40	2016-06-29 16:24:43.539386	47706
35018	40	2016-06-29 16:24:43.561513	47733
35019	40	2016-06-29 16:24:43.569852	47730
35020	40	2016-06-29 16:24:43.576971	47709
35021	40	2016-06-29 16:24:43.584512	47727
35022	40	2016-06-29 16:24:43.591799	47721
35023	49	2016-06-29 16:24:43.602839	47706
35024	49	2016-06-29 16:24:43.612811	47727
35025	49	2016-06-29 16:24:43.621892	47730
35026	49	2016-06-29 16:24:43.63085	47721
35027	49	2016-06-29 16:24:43.640987	47733
35028	49	2016-06-29 16:24:43.648957	47709
35029	48	2016-06-29 16:24:43.675343	2851
35030	48	2016-06-29 16:24:43.683158	2859
35031	48	2016-06-29 16:24:43.695589	2843
35032	48	2016-06-29 16:24:43.705823	2855
35033	48	2016-06-29 16:24:43.716262	2872
35034	48	2016-06-29 16:24:43.725274	2861
35035	48	2016-06-29 16:24:43.735022	2849
35036	48	2016-06-29 16:24:43.744176	2853
35037	48	2016-06-29 16:24:43.753819	2878
35038	48	2016-06-29 16:24:43.78372	2834
35039	48	2016-06-29 16:24:43.794235	2847
35040	48	2016-06-29 16:24:43.805619	2874
35041	48	2016-06-29 16:24:43.815377	2863
35042	48	2016-06-29 16:24:43.823858	2845
35043	48	2016-06-29 16:24:43.834357	2892
35044	50	2016-06-29 16:24:43.862897	47706
35045	50	2016-06-29 16:24:43.902266	47727
35046	50	2016-06-29 16:25:18.718829	47730
35047	50	2016-06-29 16:25:18.7839	47721
35048	50	2016-06-29 16:25:18.792767	47733
35049	50	2016-06-29 16:25:18.802146	47709
35050	47	2016-06-29 16:25:18.812409	2851
35051	47	2016-06-29 16:25:18.820728	2859
35052	47	2016-06-29 16:25:18.829432	2843
35053	47	2016-06-29 16:25:18.838641	2855
35054	47	2016-06-29 16:25:18.848039	2872
35055	47	2016-06-29 16:25:18.856298	2861
35056	47	2016-06-29 16:25:18.866263	2849
35057	47	2016-06-29 16:25:18.874516	2853
35058	47	2016-06-29 16:25:18.884131	2878
35059	47	2016-06-29 16:25:18.893102	2834
35060	47	2016-06-29 16:25:18.903175	2847
35061	47	2016-06-29 16:25:18.912353	2874
35062	47	2016-06-29 16:25:18.92061	2863
35063	47	2016-06-29 16:25:18.92903	2845
35064	47	2016-06-29 16:25:18.937731	2892
35065	41	2016-06-29 16:25:44.260337	2858
35066	41	2016-06-29 16:25:44.36361	2865
35067	41	2016-06-29 16:25:44.451541	2866
35068	45	2016-06-29 16:25:44.478161	2891
35069	42	2016-06-29 16:25:44.509702	2892
35070	42	2016-06-29 16:25:44.533957	2849
35071	42	2016-06-29 16:25:44.728835	2855
35072	42	2016-06-29 16:25:44.788206	2834
35073	42	2016-06-29 16:25:44.856483	2878
35074	42	2016-06-29 16:25:45.171102	2874
35075	42	2016-06-29 16:25:45.232063	2847
35076	42	2016-06-29 16:25:45.270208	2851
35077	42	2016-06-29 16:25:45.279953	2872
35078	43	2016-06-29 16:25:45.332636	2848
35079	43	2016-06-29 16:25:45.451235	2835
35080	43	2016-06-29 16:25:45.672385	2852
35081	43	2016-06-29 16:25:45.713508	2856
35082	43	2016-06-29 16:25:45.739409	2893
35083	43	2016-06-29 16:25:45.770337	2879
35084	43	2016-06-29 16:25:45.812939	2873
35085	43	2016-06-29 16:25:45.933017	2850
35086	43	2016-06-29 16:25:46.096627	2875
35087	40	2016-06-29 16:25:46.121452	47706
35088	40	2016-06-29 16:25:46.166144	47733
35089	40	2016-06-29 16:25:46.22982	47730
35090	40	2016-06-29 16:25:46.307294	47709
35091	40	2016-06-29 16:25:46.335041	47727
35092	40	2016-06-29 16:25:46.403029	47721
35093	49	2016-06-29 16:25:46.50972	47706
35094	49	2016-06-29 16:25:46.641194	47727
35095	49	2016-06-29 16:25:46.668787	47730
35096	49	2016-06-29 16:25:46.879342	47721
35097	49	2016-06-29 16:25:46.94421	47733
35098	49	2016-06-29 16:25:47.028722	47709
35099	48	2016-06-29 16:25:47.185407	2851
35100	48	2016-06-29 16:25:47.243975	2859
35101	48	2016-06-29 16:25:47.27579	2843
35102	48	2016-06-29 16:25:47.310684	2855
35103	48	2016-06-29 16:25:47.347331	2872
35104	48	2016-06-29 16:25:47.361212	2861
35105	48	2016-06-29 16:25:47.37441	2849
35106	48	2016-06-29 16:25:47.388281	2853
35107	48	2016-06-29 16:25:47.414633	2878
35108	48	2016-06-29 16:25:47.427558	2834
35109	48	2016-06-29 16:25:47.495586	2847
35110	48	2016-06-29 16:25:47.508795	2874
35111	48	2016-06-29 16:25:47.516798	2863
35112	48	2016-06-29 16:25:47.526112	2845
35113	48	2016-06-29 16:25:47.534859	2892
35114	50	2016-06-29 16:25:47.544667	47706
35115	50	2016-06-29 16:25:47.553532	47727
35116	41	2016-06-29 16:27:20.494349	2858
35117	41	2016-06-29 16:27:20.502216	2865
35118	41	2016-06-29 16:27:20.509507	2866
35119	45	2016-06-29 16:27:20.517059	2891
35120	42	2016-06-29 16:27:20.523956	2892
35121	42	2016-06-29 16:27:20.530544	2849
35122	42	2016-06-29 16:27:20.537022	2855
35123	42	2016-06-29 16:27:20.54473	2834
35124	42	2016-06-29 16:27:20.551289	2878
35125	42	2016-06-29 16:27:20.558042	2874
35126	42	2016-06-29 16:27:20.564594	2847
35127	42	2016-06-29 16:27:20.570991	2851
35128	42	2016-06-29 16:27:20.577449	2872
35129	43	2016-06-29 16:27:20.584165	2848
35130	43	2016-06-29 16:27:20.590656	2835
35131	43	2016-06-29 16:27:20.597294	2852
35132	43	2016-06-29 16:27:20.603721	2856
35133	43	2016-06-29 16:27:20.610363	2893
35134	43	2016-06-29 16:27:20.616859	2879
35135	43	2016-06-29 16:27:20.623361	2873
35136	43	2016-06-29 16:27:20.630197	2850
35137	43	2016-06-29 16:27:20.636839	2875
35138	40	2016-06-29 16:27:20.644816	47706
35139	40	2016-06-29 16:27:20.651091	47733
35140	40	2016-06-29 16:27:20.657377	47730
35141	40	2016-06-29 16:27:20.663458	47709
35142	40	2016-06-29 16:27:20.67017	47727
35143	40	2016-06-29 16:27:20.676626	47721
35144	49	2016-06-29 16:27:20.685679	47706
35145	49	2016-06-29 16:27:20.693445	47727
35146	49	2016-06-29 16:27:20.700854	47730
35147	49	2016-06-29 16:27:20.708175	47721
35148	49	2016-06-29 16:27:20.715453	47733
35149	49	2016-06-29 16:27:20.722829	47709
35150	48	2016-06-29 16:27:20.732215	2851
35151	48	2016-06-29 16:27:20.739574	2859
35152	48	2016-06-29 16:27:20.747281	2843
35153	48	2016-06-29 16:27:20.755252	2855
35154	48	2016-06-29 16:27:20.763157	2872
35155	48	2016-06-29 16:27:20.770349	2861
35156	48	2016-06-29 16:27:20.778668	2849
35157	48	2016-06-29 16:27:20.786104	2853
35158	48	2016-06-29 16:27:20.79396	2878
35159	48	2016-06-29 16:27:20.802182	2834
35160	48	2016-06-29 16:27:20.810583	2847
35161	48	2016-06-29 16:27:20.818427	2874
35162	48	2016-06-29 16:27:20.825934	2863
35163	48	2016-06-29 16:27:20.83351	2845
35164	48	2016-06-29 16:27:20.841678	2892
35165	50	2016-06-29 16:27:20.850857	47706
35166	50	2016-06-29 16:27:20.859191	47727
35167	50	2016-06-29 16:27:20.867107	47730
35168	50	2016-06-29 16:27:20.875106	47721
35169	50	2016-06-29 16:27:20.882781	47733
35170	50	2016-06-29 16:27:20.890915	47709
35171	47	2016-06-29 16:27:20.900185	2851
35172	47	2016-06-29 16:27:20.907937	2859
35173	47	2016-06-29 16:27:20.915939	2843
35174	47	2016-06-29 16:27:20.924681	2855
35175	47	2016-06-29 16:27:20.932585	2872
35176	47	2016-06-29 16:27:20.940074	2861
35177	47	2016-06-29 16:27:20.948602	2849
35178	47	2016-06-29 16:27:20.956131	2853
35179	47	2016-06-29 16:27:20.964286	2878
35180	47	2016-06-29 16:27:20.972329	2834
35181	47	2016-06-29 16:27:20.981506	2847
35182	47	2016-06-29 16:27:20.990141	2874
35183	47	2016-06-29 16:27:20.997703	2863
35184	47	2016-06-29 16:27:21.005241	2845
35185	47	2016-06-29 16:27:21.01352	2892
35186	41	2016-06-29 16:28:20.899395	2858
35187	41	2016-06-29 16:28:20.907364	2865
35188	41	2016-06-29 16:28:20.915049	2866
35189	45	2016-06-29 16:28:20.922557	2891
35190	42	2016-06-29 16:28:20.929652	2892
35191	42	2016-06-29 16:28:20.936684	2849
35192	42	2016-06-29 16:28:20.943685	2855
35193	42	2016-06-29 16:28:20.950921	2834
35194	42	2016-06-29 16:28:20.957677	2878
35195	42	2016-06-29 16:28:20.964641	2874
35196	42	2016-06-29 16:28:20.971481	2847
35197	42	2016-06-29 16:28:20.978318	2851
35198	42	2016-06-29 16:28:20.985612	2872
35199	43	2016-06-29 16:28:20.992784	2848
35200	43	2016-06-29 16:28:21.000363	2835
35201	43	2016-06-29 16:28:21.008642	2852
35202	43	2016-06-29 16:28:21.01645	2856
35203	43	2016-06-29 16:28:21.023269	2893
35204	43	2016-06-29 16:28:21.029934	2879
35205	43	2016-06-29 16:28:21.037049	2873
35206	43	2016-06-29 16:28:21.043944	2850
35207	43	2016-06-29 16:28:21.051001	2875
35208	40	2016-06-29 16:28:21.058792	47706
35209	40	2016-06-29 16:28:21.065311	47733
35210	40	2016-06-29 16:28:21.071938	47730
35211	40	2016-06-29 16:28:21.078416	47709
35212	40	2016-06-29 16:28:21.085298	47727
35213	40	2016-06-29 16:28:21.091793	47721
35214	49	2016-06-29 16:28:21.101426	47706
35215	49	2016-06-29 16:28:21.109133	47727
35216	49	2016-06-29 16:28:21.116811	47730
35217	49	2016-06-29 16:28:21.124351	47721
35218	49	2016-06-29 16:28:21.13203	47733
35219	49	2016-06-29 16:28:21.139511	47709
35220	48	2016-06-29 16:28:21.149648	2851
35221	48	2016-06-29 16:28:21.158016	2859
35222	48	2016-06-29 16:28:21.166296	2843
35223	48	2016-06-29 16:28:21.174608	2855
35224	48	2016-06-29 16:28:21.182593	2872
35225	48	2016-06-29 16:28:21.190125	2861
35226	48	2016-06-29 16:28:21.198683	2849
35227	48	2016-06-29 16:28:21.206515	2853
35228	48	2016-06-29 16:28:21.214665	2878
35229	48	2016-06-29 16:28:21.223211	2834
35230	48	2016-06-29 16:28:21.232179	2847
35231	48	2016-06-29 16:28:21.240537	2874
35232	48	2016-06-29 16:28:21.248058	2863
35233	48	2016-06-29 16:28:21.256076	2845
35234	48	2016-06-29 16:28:21.263951	2892
35235	50	2016-06-29 16:28:21.27312	47706
35236	50	2016-06-29 16:28:21.281137	47727
35237	50	2016-06-29 16:28:21.289263	47730
35238	50	2016-06-29 16:28:21.297244	47721
35239	50	2016-06-29 16:28:21.305321	47733
35240	50	2016-06-29 16:28:21.313129	47709
35241	47	2016-06-29 16:28:21.322721	2851
35242	47	2016-06-29 16:28:21.330243	2859
35243	47	2016-06-29 16:28:21.338115	2843
35244	47	2016-06-29 16:28:21.34628	2855
35245	47	2016-06-29 16:28:21.35479	2872
35246	47	2016-06-29 16:28:21.362523	2861
35247	47	2016-06-29 16:28:21.370809	2849
35248	47	2016-06-29 16:28:21.378316	2853
35249	47	2016-06-29 16:28:21.386771	2878
35250	47	2016-06-29 16:28:21.394995	2834
35251	47	2016-06-29 16:28:21.403488	2847
35252	47	2016-06-29 16:28:21.41152	2874
35253	47	2016-06-29 16:28:21.418892	2863
35254	47	2016-06-29 16:28:21.426556	2845
35255	47	2016-06-29 16:28:21.434241	2892
35256	41	2016-06-29 16:32:53.330094	2858
35257	41	2016-06-29 16:32:53.338188	2865
35258	41	2016-06-29 16:32:53.345984	2866
35259	45	2016-06-29 16:32:53.354184	2891
35260	42	2016-06-29 16:32:53.361756	2892
35261	42	2016-06-29 16:32:53.368565	2849
35262	42	2016-06-29 16:32:53.37528	2855
35263	42	2016-06-29 16:32:53.382574	2834
35264	42	2016-06-29 16:32:53.389708	2878
35265	42	2016-06-29 16:32:53.396564	2874
35266	42	2016-06-29 16:32:53.403581	2847
35267	42	2016-06-29 16:32:53.41085	2851
35268	42	2016-06-29 16:32:53.417919	2872
35269	43	2016-06-29 16:32:53.425612	2848
35270	43	2016-06-29 16:32:53.432992	2835
35271	43	2016-06-29 16:32:53.440071	2852
35272	43	2016-06-29 16:32:53.446993	2856
35273	43	2016-06-29 16:32:53.455084	2893
35274	43	2016-06-29 16:32:53.462839	2879
35275	43	2016-06-29 16:32:53.470383	2873
35276	43	2016-06-29 16:32:53.477127	2850
35277	43	2016-06-29 16:32:53.484276	2875
35278	40	2016-06-29 16:32:53.492751	47706
35279	40	2016-06-29 16:32:53.500011	47733
35280	40	2016-06-29 16:32:53.506853	47730
35281	40	2016-06-29 16:32:53.513332	47709
35282	40	2016-06-29 16:32:53.52113	47727
35283	40	2016-06-29 16:32:53.528141	47721
35284	49	2016-06-29 16:32:53.538008	47706
35285	49	2016-06-29 16:32:53.546024	47727
35286	49	2016-06-29 16:32:53.554464	47730
35287	49	2016-06-29 16:32:53.562441	47721
35288	49	2016-06-29 16:32:53.570737	47733
35289	49	2016-06-29 16:32:53.578638	47709
35290	48	2016-06-29 16:32:53.588953	2851
35291	48	2016-06-29 16:32:53.596403	2859
35292	48	2016-06-29 16:32:53.604533	2843
35293	48	2016-06-29 16:32:53.613264	2855
35294	48	2016-06-29 16:32:53.621953	2872
35295	48	2016-06-29 16:32:53.629626	2861
35296	48	2016-06-29 16:32:53.638397	2849
35297	48	2016-06-29 16:32:53.646301	2853
35298	48	2016-06-29 16:32:53.655277	2878
35299	48	2016-06-29 16:32:53.663804	2834
35300	48	2016-06-29 16:32:53.672297	2847
35301	48	2016-06-29 16:32:53.680475	2874
35302	48	2016-06-29 16:32:53.68813	2863
35303	48	2016-06-29 16:32:53.69617	2845
35304	48	2016-06-29 16:32:53.704236	2892
35305	50	2016-06-29 16:32:53.713458	47706
35306	50	2016-06-29 16:32:53.721508	47727
35307	50	2016-06-29 16:32:53.729411	47730
35308	50	2016-06-29 16:32:53.737616	47721
35309	50	2016-06-29 16:32:53.745352	47733
35310	50	2016-06-29 16:32:53.753472	47709
35311	47	2016-06-29 16:32:53.762526	2851
35312	47	2016-06-29 16:32:53.769943	2859
35313	47	2016-06-29 16:32:53.77761	2843
35314	47	2016-06-29 16:32:53.786095	2855
35315	47	2016-06-29 16:32:53.79393	2872
35316	47	2016-06-29 16:32:53.801254	2861
35317	47	2016-06-29 16:32:53.809369	2849
35318	47	2016-06-29 16:32:53.816795	2853
35319	47	2016-06-29 16:32:53.824783	2878
35320	47	2016-06-29 16:32:53.832977	2834
35321	47	2016-06-29 16:32:53.841056	2847
35322	47	2016-06-29 16:32:53.848726	2874
35323	47	2016-06-29 16:32:53.856322	2863
35324	47	2016-06-29 16:32:53.86402	2845
35325	47	2016-06-29 16:32:53.871726	2892
35326	41	2016-06-29 16:33:55.137661	2858
35327	41	2016-06-29 16:33:55.145871	2865
35328	41	2016-06-29 16:33:55.153375	2866
35329	45	2016-06-29 16:33:55.161438	2891
35330	42	2016-06-29 16:33:55.169285	2892
35331	42	2016-06-29 16:33:55.176058	2849
35332	42	2016-06-29 16:33:55.182891	2855
35333	42	2016-06-29 16:33:55.189426	2834
35334	42	2016-06-29 16:33:55.1964	2878
35335	42	2016-06-29 16:33:55.203305	2874
35336	42	2016-06-29 16:33:55.210526	2847
35337	42	2016-06-29 16:33:55.217462	2851
35338	42	2016-06-29 16:33:55.223915	2872
35339	43	2016-06-29 16:33:55.230656	2848
35340	43	2016-06-29 16:33:55.237089	2835
35341	43	2016-06-29 16:33:55.243979	2852
35342	43	2016-06-29 16:33:55.250688	2856
35343	43	2016-06-29 16:33:55.257209	2893
35344	43	2016-06-29 16:33:55.263848	2879
35345	43	2016-06-29 16:33:55.270296	2873
35346	43	2016-06-29 16:33:55.277112	2850
35347	43	2016-06-29 16:33:55.284133	2875
35348	40	2016-06-29 16:33:55.292032	47706
35349	40	2016-06-29 16:33:55.298449	47733
35350	40	2016-06-29 16:33:55.304738	47730
35351	40	2016-06-29 16:33:55.311483	47709
35352	40	2016-06-29 16:33:55.317808	47727
35353	40	2016-06-29 16:33:55.324087	47721
35354	49	2016-06-29 16:33:55.33323	47706
35355	49	2016-06-29 16:33:55.340852	47727
35356	49	2016-06-29 16:33:55.348393	47730
35357	49	2016-06-29 16:33:55.355816	47721
35358	49	2016-06-29 16:33:55.363149	47733
35359	49	2016-06-29 16:33:55.370623	47709
35360	48	2016-06-29 16:33:55.380031	2851
35361	48	2016-06-29 16:33:55.387498	2859
35362	48	2016-06-29 16:33:55.395382	2843
35363	48	2016-06-29 16:33:55.403321	2855
35364	48	2016-06-29 16:33:55.41124	2872
35365	48	2016-06-29 16:33:55.418667	2861
35366	48	2016-06-29 16:33:55.427273	2849
35367	48	2016-06-29 16:33:55.434816	2853
35368	48	2016-06-29 16:33:55.442673	2878
35369	48	2016-06-29 16:33:55.450829	2834
35370	48	2016-06-29 16:33:55.4598	2847
35371	48	2016-06-29 16:33:55.467818	2874
35372	48	2016-06-29 16:33:55.47496	2863
35373	48	2016-06-29 16:33:55.482364	2845
35374	48	2016-06-29 16:33:55.490167	2892
35375	50	2016-06-29 16:33:55.499272	47706
35376	50	2016-06-29 16:33:55.507389	47727
35377	50	2016-06-29 16:33:55.515132	47730
35378	50	2016-06-29 16:33:55.522711	47721
35379	50	2016-06-29 16:33:55.530155	47733
35380	50	2016-06-29 16:33:55.53783	47709
35381	47	2016-06-29 16:33:55.546894	2851
35382	47	2016-06-29 16:33:55.554273	2859
35383	47	2016-06-29 16:33:55.561617	2843
35384	47	2016-06-29 16:33:55.569521	2855
35385	47	2016-06-29 16:33:55.577674	2872
35386	47	2016-06-29 16:33:55.584921	2861
35387	47	2016-06-29 16:33:55.592944	2849
35388	47	2016-06-29 16:33:55.600359	2853
35389	47	2016-06-29 16:33:55.608227	2878
35390	47	2016-06-29 16:33:55.616234	2834
35391	47	2016-06-29 16:33:55.624381	2847
35392	47	2016-06-29 16:33:55.632033	2874
35393	47	2016-06-29 16:33:55.63933	2863
35394	47	2016-06-29 16:33:55.64667	2845
35395	47	2016-06-29 16:33:55.65419	2892
35396	41	2016-06-29 16:35:06.473804	2858
35397	41	2016-06-29 16:35:06.482247	2865
35398	41	2016-06-29 16:35:06.490157	2866
35399	45	2016-06-29 16:35:06.498232	2891
35400	42	2016-06-29 16:35:06.50583	2892
35401	42	2016-06-29 16:35:06.513062	2849
35402	42	2016-06-29 16:35:06.520317	2855
35403	42	2016-06-29 16:35:06.527472	2834
35404	42	2016-06-29 16:35:06.534421	2878
35405	42	2016-06-29 16:35:06.541559	2874
35406	42	2016-06-29 16:35:06.54844	2847
35407	42	2016-06-29 16:35:06.55534	2851
35408	42	2016-06-29 16:35:06.561929	2872
35409	43	2016-06-29 16:35:06.569226	2848
35410	43	2016-06-29 16:35:06.575731	2835
35411	43	2016-06-29 16:35:06.582282	2852
35412	43	2016-06-29 16:35:06.589119	2856
35413	43	2016-06-29 16:35:06.595722	2893
35414	43	2016-06-29 16:35:06.602457	2879
35415	43	2016-06-29 16:35:06.609011	2873
35416	43	2016-06-29 16:35:06.615545	2850
35417	43	2016-06-29 16:35:06.622168	2875
35418	40	2016-06-29 16:35:06.630166	47706
35419	40	2016-06-29 16:35:06.636314	47733
35420	40	2016-06-29 16:35:06.642559	47730
35421	40	2016-06-29 16:35:06.648671	47709
35422	40	2016-06-29 16:35:06.655175	47727
35423	40	2016-06-29 16:35:06.661525	47721
35424	49	2016-06-29 16:35:06.671311	47706
35425	49	2016-06-29 16:35:06.679315	47727
35426	49	2016-06-29 16:35:06.687419	47730
35427	49	2016-06-29 16:35:06.695615	47721
35428	49	2016-06-29 16:35:06.703457	47733
35429	49	2016-06-29 16:35:06.712084	47709
35430	48	2016-06-29 16:35:06.72207	2851
35431	48	2016-06-29 16:35:06.729991	2859
35432	48	2016-06-29 16:35:06.738494	2843
35433	48	2016-06-29 16:35:06.747355	2855
35434	48	2016-06-29 16:35:06.75577	2872
35435	48	2016-06-29 16:35:06.76354	2861
35436	48	2016-06-29 16:35:06.772346	2849
35437	48	2016-06-29 16:35:06.780241	2853
35438	48	2016-06-29 16:35:06.789035	2878
35439	48	2016-06-29 16:35:06.797984	2834
35440	48	2016-06-29 16:35:06.806857	2847
35441	48	2016-06-29 16:35:06.814772	2874
35442	48	2016-06-29 16:35:06.822678	2863
35443	48	2016-06-29 16:35:06.830302	2845
35444	48	2016-06-29 16:35:06.838313	2892
35445	50	2016-06-29 16:35:06.847441	47706
35446	50	2016-06-29 16:35:06.855687	47727
35447	50	2016-06-29 16:35:06.863571	47730
35448	50	2016-06-29 16:35:06.871321	47721
35449	50	2016-06-29 16:35:06.878933	47733
35450	50	2016-06-29 16:35:06.88647	47709
35451	47	2016-06-29 16:35:06.895421	2851
35452	47	2016-06-29 16:35:06.90291	2859
35453	47	2016-06-29 16:35:06.910241	2843
35454	47	2016-06-29 16:35:06.918244	2855
35455	47	2016-06-29 16:35:06.926047	2872
35456	47	2016-06-29 16:35:06.933283	2861
35457	47	2016-06-29 16:35:06.94117	2849
35458	47	2016-06-29 16:35:06.948468	2853
35459	47	2016-06-29 16:35:06.95662	2878
35460	47	2016-06-29 16:35:06.964453	2834
35461	47	2016-06-29 16:35:06.97231	2847
35462	47	2016-06-29 16:35:06.979959	2874
35463	47	2016-06-29 16:35:06.987311	2863
35464	47	2016-06-29 16:35:06.994619	2845
35465	47	2016-06-29 16:35:07.002131	2892
35466	41	2016-06-29 16:38:20.549167	2858
35467	41	2016-06-29 16:38:20.556902	2865
35468	41	2016-06-29 16:38:20.564336	2866
35469	45	2016-06-29 16:38:20.572085	2891
35470	42	2016-06-29 16:38:20.579083	2892
35471	42	2016-06-29 16:38:20.585996	2849
35472	42	2016-06-29 16:38:20.592743	2855
35473	42	2016-06-29 16:38:20.599372	2834
35474	42	2016-06-29 16:38:20.60601	2878
35475	42	2016-06-29 16:38:20.612642	2874
35476	42	2016-06-29 16:38:20.619475	2847
35477	42	2016-06-29 16:38:20.626466	2851
35478	42	2016-06-29 16:38:20.634054	2872
35479	43	2016-06-29 16:38:20.640995	2848
35480	43	2016-06-29 16:38:20.648011	2835
35481	43	2016-06-29 16:38:20.655247	2852
35482	43	2016-06-29 16:38:20.661853	2856
35483	43	2016-06-29 16:38:20.668644	2893
35484	43	2016-06-29 16:38:20.675649	2879
35485	43	2016-06-29 16:38:20.682462	2873
35486	43	2016-06-29 16:38:20.689085	2850
35487	43	2016-06-29 16:38:20.695653	2875
35488	40	2016-06-29 16:38:20.704119	47706
35489	40	2016-06-29 16:38:20.71037	47733
35490	40	2016-06-29 16:38:20.717075	47730
35491	40	2016-06-29 16:38:20.723593	47709
35492	40	2016-06-29 16:38:20.730386	47727
35493	40	2016-06-29 16:38:20.737374	47721
35494	49	2016-06-29 16:38:20.747531	47706
35495	49	2016-06-29 16:38:20.755549	47727
35496	49	2016-06-29 16:38:20.763536	47730
35497	49	2016-06-29 16:38:20.771243	47721
35498	49	2016-06-29 16:38:20.778871	47733
35499	49	2016-06-29 16:38:20.786724	47709
35500	48	2016-06-29 16:38:20.796718	2851
35501	48	2016-06-29 16:38:20.804358	2859
35502	48	2016-06-29 16:38:20.811806	2843
35503	48	2016-06-29 16:38:20.81985	2855
35504	48	2016-06-29 16:38:20.827682	2872
35505	48	2016-06-29 16:38:20.835129	2861
35506	48	2016-06-29 16:38:20.843864	2849
35507	48	2016-06-29 16:38:20.852058	2853
35508	48	2016-06-29 16:38:20.860543	2878
35509	48	2016-06-29 16:38:20.869308	2834
35510	48	2016-06-29 16:38:20.877706	2847
35511	48	2016-06-29 16:38:20.886189	2874
35512	48	2016-06-29 16:38:20.893873	2863
35513	48	2016-06-29 16:38:20.902025	2845
35514	48	2016-06-29 16:38:20.910626	2892
35515	50	2016-06-29 16:38:20.920419	47706
35516	50	2016-06-29 16:38:20.930923	47727
35517	50	2016-06-29 16:38:20.941042	47730
35518	50	2016-06-29 16:38:20.949564	47721
35519	50	2016-06-29 16:38:20.957482	47733
35520	50	2016-06-29 16:38:20.966126	47709
35521	47	2016-06-29 16:38:20.976117	2851
35522	47	2016-06-29 16:38:20.983748	2859
35523	47	2016-06-29 16:38:20.991421	2843
35524	47	2016-06-29 16:38:20.999992	2855
35525	47	2016-06-29 16:38:21.007954	2872
35526	47	2016-06-29 16:38:21.015622	2861
35527	47	2016-06-29 16:38:21.023756	2849
35528	47	2016-06-29 16:38:21.03216	2853
35529	47	2016-06-29 16:38:21.040304	2878
35530	47	2016-06-29 16:38:21.048641	2834
35531	47	2016-06-29 16:38:21.056778	2847
35532	47	2016-06-29 16:38:21.065287	2874
35533	47	2016-06-29 16:38:21.072908	2863
35534	47	2016-06-29 16:38:21.080795	2845
35535	47	2016-06-29 16:38:21.088741	2892
35536	41	2016-06-29 16:40:53.368718	2858
35537	41	2016-06-29 16:40:53.376701	2865
35538	41	2016-06-29 16:40:53.384216	2866
35539	45	2016-06-29 16:40:53.392152	2891
35540	42	2016-06-29 16:40:53.399146	2892
35541	42	2016-06-29 16:40:53.406141	2849
35542	42	2016-06-29 16:40:53.412768	2855
35543	42	2016-06-29 16:40:53.419388	2834
35544	42	2016-06-29 16:40:53.426004	2878
35545	42	2016-06-29 16:40:53.432568	2874
35546	42	2016-06-29 16:40:53.439447	2847
35547	42	2016-06-29 16:40:53.445964	2851
35548	42	2016-06-29 16:40:53.453308	2872
35549	43	2016-06-29 16:40:53.460338	2848
35550	43	2016-06-29 16:40:53.467523	2835
35551	43	2016-06-29 16:40:53.474314	2852
35552	43	2016-06-29 16:40:53.480815	2856
35553	43	2016-06-29 16:40:53.488896	2893
35554	43	2016-06-29 16:40:53.495793	2879
35555	43	2016-06-29 16:40:53.502429	2873
35556	43	2016-06-29 16:40:53.509174	2850
35557	43	2016-06-29 16:40:53.515731	2875
35558	40	2016-06-29 16:40:53.523755	47706
35559	40	2016-06-29 16:40:53.529894	47733
35560	40	2016-06-29 16:40:53.536287	47730
35561	40	2016-06-29 16:40:53.542446	47709
35562	40	2016-06-29 16:40:53.548991	47727
35563	40	2016-06-29 16:40:53.555687	47721
35564	49	2016-06-29 16:40:53.564985	47706
35565	49	2016-06-29 16:40:53.573074	47727
35566	49	2016-06-29 16:40:53.580613	47730
35567	49	2016-06-29 16:40:53.588586	47721
35568	49	2016-06-29 16:40:53.596271	47733
35569	49	2016-06-29 16:40:53.604344	47709
35570	48	2016-06-29 16:40:53.614562	2851
35571	48	2016-06-29 16:40:53.622441	2859
35572	48	2016-06-29 16:40:53.630413	2843
35573	48	2016-06-29 16:40:53.639229	2855
35574	48	2016-06-29 16:40:53.64723	2872
35575	48	2016-06-29 16:40:53.654637	2861
35576	48	2016-06-29 16:40:53.662834	2849
35577	48	2016-06-29 16:40:53.670634	2853
35578	48	2016-06-29 16:40:53.678972	2878
35579	48	2016-06-29 16:40:53.68768	2834
35580	48	2016-06-29 16:40:53.695824	2847
35581	48	2016-06-29 16:40:53.703918	2874
35582	48	2016-06-29 16:40:53.711448	2863
35583	48	2016-06-29 16:40:53.718819	2845
35584	48	2016-06-29 16:40:53.726465	2892
35585	50	2016-06-29 16:40:53.736273	47706
35586	50	2016-06-29 16:40:53.744213	47727
35587	50	2016-06-29 16:40:53.75207	47730
35588	50	2016-06-29 16:40:53.759718	47721
35589	50	2016-06-29 16:40:53.7676	47733
35590	50	2016-06-29 16:40:53.775314	47709
35591	47	2016-06-29 16:40:53.784682	2851
35592	47	2016-06-29 16:40:53.792413	2859
35593	47	2016-06-29 16:40:53.799884	2843
35594	47	2016-06-29 16:40:53.808021	2855
35595	47	2016-06-29 16:40:53.815846	2872
35596	47	2016-06-29 16:40:53.823251	2861
35597	47	2016-06-29 16:40:53.831119	2849
35598	47	2016-06-29 16:40:53.838473	2853
35599	47	2016-06-29 16:40:53.846273	2878
35600	47	2016-06-29 16:40:53.854653	2834
35601	47	2016-06-29 16:40:53.862653	2847
35602	47	2016-06-29 16:40:53.87046	2874
35603	47	2016-06-29 16:40:53.877757	2863
35604	47	2016-06-29 16:40:53.885382	2845
35605	47	2016-06-29 16:40:53.893454	2892
35606	41	2016-06-29 20:07:33.189899	2858
35607	41	2016-06-29 20:07:33.197859	2865
35608	41	2016-06-29 20:07:33.205239	2866
35609	45	2016-06-29 20:07:33.21359	2891
35610	42	2016-06-29 20:07:33.220508	2892
35611	42	2016-06-29 20:07:33.227078	2849
35612	42	2016-06-29 20:07:33.233946	2855
35613	42	2016-06-29 20:07:33.240962	2834
35614	42	2016-06-29 20:07:33.247616	2878
35615	42	2016-06-29 20:07:33.254294	2874
35616	42	2016-06-29 20:07:33.26104	2847
35617	42	2016-06-29 20:07:33.267865	2851
35618	42	2016-06-29 20:07:33.274643	2872
35619	43	2016-06-29 20:07:33.28309	2848
35620	43	2016-06-29 20:07:33.292227	2835
35621	43	2016-06-29 20:07:33.299082	2852
35622	43	2016-06-29 20:07:33.305699	2856
35623	43	2016-06-29 20:07:33.312372	2893
35624	43	2016-06-29 20:07:33.318919	2879
35625	43	2016-06-29 20:07:33.326319	2873
35626	43	2016-06-29 20:07:33.333127	2850
35627	43	2016-06-29 20:07:33.340306	2875
35628	40	2016-06-29 20:07:33.384955	47706
35629	40	2016-06-29 20:07:33.393943	47733
35630	40	2016-06-29 20:07:33.400872	47730
35631	40	2016-06-29 20:07:33.407592	47709
35632	40	2016-06-29 20:07:33.414075	47727
35633	40	2016-06-29 20:07:33.420309	47721
35634	49	2016-06-29 20:07:33.430075	47706
35635	49	2016-06-29 20:07:33.437921	47727
35636	49	2016-06-29 20:07:33.446175	47730
35637	49	2016-06-29 20:07:33.453741	47721
35638	49	2016-06-29 20:07:33.461384	47733
35639	49	2016-06-29 20:07:33.469126	47709
35640	48	2016-06-29 20:07:33.479375	2851
35641	48	2016-06-29 20:07:33.486845	2859
35642	48	2016-06-29 20:07:33.494437	2843
35643	48	2016-06-29 20:07:33.502856	2855
35644	48	2016-06-29 20:07:33.511042	2872
35645	48	2016-06-29 20:07:33.518425	2861
35646	48	2016-06-29 20:07:33.526504	2849
35647	48	2016-06-29 20:07:33.534222	2853
35648	48	2016-06-29 20:07:33.542618	2878
35649	48	2016-06-29 20:07:33.550861	2834
35650	48	2016-06-29 20:07:33.558899	2847
35651	48	2016-06-29 20:07:33.566815	2874
35652	48	2016-06-29 20:07:33.574476	2863
35653	48	2016-06-29 20:07:33.582535	2845
35654	48	2016-06-29 20:07:33.590874	2892
35655	50	2016-06-29 20:07:33.599803	47706
35656	50	2016-06-29 20:07:33.60756	47727
35657	50	2016-06-29 20:07:33.615632	47730
35658	50	2016-06-29 20:07:33.623863	47721
35659	50	2016-06-29 20:07:33.632104	47733
35660	50	2016-06-29 20:07:33.639864	47709
35661	47	2016-06-29 20:07:33.649192	2851
35662	47	2016-06-29 20:07:33.65665	2859
35663	47	2016-06-29 20:07:33.664277	2843
35664	47	2016-06-29 20:07:33.672489	2855
35665	47	2016-06-29 20:07:33.680378	2872
35666	47	2016-06-29 20:07:33.687836	2861
35667	47	2016-06-29 20:07:33.69598	2849
35668	47	2016-06-29 20:07:33.7035	2853
35669	47	2016-06-29 20:07:33.711235	2878
35670	47	2016-06-29 20:07:33.719189	2834
35671	47	2016-06-29 20:07:33.727336	2847
35672	47	2016-06-29 20:07:33.7354	2874
35673	47	2016-06-29 20:07:33.742988	2863
35674	47	2016-06-29 20:07:33.75052	2845
35675	47	2016-06-29 20:07:33.758091	2892
35676	41	2016-06-29 20:09:48.068838	2858
35677	41	2016-06-29 20:09:48.078985	2865
35678	41	2016-06-29 20:09:48.088954	2866
35679	45	2016-06-29 20:09:48.096869	2891
35680	42	2016-06-29 20:09:48.104398	2892
35681	42	2016-06-29 20:09:48.111197	2849
35682	42	2016-06-29 20:09:48.117938	2855
35683	42	2016-06-29 20:09:48.12455	2834
35684	42	2016-06-29 20:09:48.131217	2878
35685	42	2016-06-29 20:09:48.137976	2874
35686	42	2016-06-29 20:09:48.144748	2847
35687	42	2016-06-29 20:09:48.151566	2851
35688	42	2016-06-29 20:09:48.158331	2872
35689	43	2016-06-29 20:09:48.165053	2848
35690	43	2016-06-29 20:09:48.171636	2835
35691	43	2016-06-29 20:09:48.178101	2852
35692	43	2016-06-29 20:09:48.184843	2856
35693	43	2016-06-29 20:09:48.191402	2893
35694	43	2016-06-29 20:09:48.198245	2873
35695	43	2016-06-29 20:09:48.204971	2850
35696	43	2016-06-29 20:09:48.21172	2875
35697	40	2016-06-29 20:09:48.220023	47706
35698	40	2016-06-29 20:09:48.226417	47733
35699	40	2016-06-29 20:09:48.23281	47730
35700	40	2016-06-29 20:09:48.24	47709
35701	40	2016-06-29 20:09:48.246616	47727
35702	40	2016-06-29 20:09:48.253603	47721
35703	49	2016-06-29 20:09:48.263057	47706
35704	49	2016-06-29 20:09:48.270738	47727
35705	49	2016-06-29 20:09:48.278205	47730
35706	49	2016-06-29 20:09:48.28599	47721
35707	49	2016-06-29 20:09:48.293448	47733
35708	49	2016-06-29 20:09:48.301249	47709
35709	48	2016-06-29 20:09:48.310974	2851
35710	48	2016-06-29 20:09:48.318341	2859
35711	48	2016-06-29 20:09:48.325957	2843
35712	48	2016-06-29 20:09:48.334356	2855
35713	48	2016-06-29 20:09:48.342365	2872
35714	48	2016-06-29 20:09:48.34993	2861
35715	48	2016-06-29 20:09:48.358163	2849
35716	48	2016-06-29 20:09:48.365761	2853
35717	48	2016-06-29 20:09:48.373883	2878
35718	48	2016-06-29 20:09:48.381931	2834
35719	48	2016-06-29 20:09:48.390022	2847
35720	48	2016-06-29 20:09:48.398466	2874
35721	48	2016-06-29 20:09:48.406358	2863
35722	48	2016-06-29 20:09:48.414301	2845
35723	48	2016-06-29 20:09:48.422074	2892
35724	50	2016-06-29 20:09:48.431296	47706
35725	50	2016-06-29 20:09:48.439261	47727
35726	50	2016-06-29 20:09:48.447358	47730
35727	50	2016-06-29 20:09:48.45525	47721
35728	50	2016-06-29 20:09:48.463001	47733
35729	50	2016-06-29 20:09:48.470693	47709
35730	47	2016-06-29 20:09:48.480244	2851
35731	47	2016-06-29 20:09:48.487768	2859
35732	47	2016-06-29 20:09:48.495367	2843
35733	47	2016-06-29 20:09:48.503759	2855
35734	47	2016-06-29 20:09:48.511913	2872
35735	47	2016-06-29 20:09:48.519671	2861
35736	47	2016-06-29 20:09:48.52801	2849
35737	47	2016-06-29 20:09:48.535772	2853
35738	47	2016-06-29 20:09:48.54412	2878
35739	47	2016-06-29 20:09:48.552687	2834
35740	47	2016-06-29 20:09:48.560922	2847
35741	47	2016-06-29 20:09:48.569276	2874
35742	47	2016-06-29 20:09:48.576673	2863
35743	47	2016-06-29 20:09:48.584189	2845
35744	47	2016-06-29 20:09:48.592364	2892
35745	41	2016-06-29 20:10:52.27643	2858
35746	41	2016-06-29 20:10:52.284909	2865
35747	41	2016-06-29 20:10:52.292809	2866
35748	45	2016-06-29 20:10:52.30075	2891
35749	42	2016-06-29 20:10:52.308119	2892
35750	42	2016-06-29 20:10:52.315184	2849
35751	42	2016-06-29 20:10:52.322029	2855
35752	42	2016-06-29 20:10:52.329682	2834
35753	42	2016-06-29 20:10:52.336445	2874
35754	42	2016-06-29 20:10:52.34436	2847
35755	42	2016-06-29 20:10:52.351107	2851
35756	42	2016-06-29 20:10:52.357849	2872
35757	43	2016-06-29 20:10:52.364946	2848
35758	43	2016-06-29 20:10:52.371864	2835
35759	43	2016-06-29 20:10:52.378489	2852
35760	43	2016-06-29 20:10:52.385082	2856
35761	43	2016-06-29 20:10:52.391877	2893
35762	43	2016-06-29 20:10:52.398613	2873
35763	43	2016-06-29 20:10:52.405424	2850
35764	43	2016-06-29 20:10:52.412017	2875
35765	40	2016-06-29 20:10:52.419583	47706
35766	40	2016-06-29 20:10:52.42598	47733
35767	40	2016-06-29 20:10:52.432399	47730
35768	40	2016-06-29 20:10:52.438698	47709
35769	40	2016-06-29 20:10:52.44504	47727
35770	40	2016-06-29 20:10:52.451346	47743
35771	40	2016-06-29 20:10:52.458372	47721
35772	49	2016-06-29 20:10:52.468385	47706
35773	49	2016-06-29 20:10:52.476157	47727
35774	49	2016-06-29 20:10:52.48394	47730
35775	49	2016-06-29 20:10:52.492454	47721
35776	49	2016-06-29 20:10:52.5012	47733
35777	49	2016-06-29 20:10:52.510532	47709
35778	48	2016-06-29 20:10:52.521789	2851
35779	48	2016-06-29 20:10:52.530132	2859
35780	48	2016-06-29 20:10:52.53814	2843
35781	48	2016-06-29 20:10:52.546684	2855
35782	48	2016-06-29 20:10:52.556129	2872
35783	48	2016-06-29 20:10:52.563889	2861
35784	48	2016-06-29 20:10:52.573541	2849
35785	48	2016-06-29 20:10:52.582091	2853
35786	48	2016-06-29 20:10:52.590916	2878
35787	48	2016-06-29 20:10:52.600666	2834
35788	48	2016-06-29 20:10:52.609505	2847
35789	48	2016-06-29 20:10:52.61925	2874
35790	48	2016-06-29 20:10:52.626995	2863
35791	48	2016-06-29 20:10:52.636869	2845
35792	48	2016-06-29 20:10:52.645058	2892
35793	50	2016-06-29 20:10:52.655292	47706
35794	50	2016-06-29 20:10:52.665967	47727
35795	50	2016-06-29 20:10:52.674216	47730
35796	50	2016-06-29 20:10:52.683159	47721
35797	50	2016-06-29 20:10:52.69142	47733
35798	50	2016-06-29 20:10:52.700592	47709
35799	47	2016-06-29 20:10:52.71029	2851
35800	47	2016-06-29 20:10:52.719133	2859
35801	47	2016-06-29 20:10:52.727036	2843
35802	47	2016-06-29 20:10:52.736944	2855
35803	47	2016-06-29 20:10:52.745092	2872
35804	47	2016-06-29 20:10:52.753741	2861
35805	47	2016-06-29 20:10:52.762996	2849
35806	47	2016-06-29 20:10:52.771593	2853
35807	47	2016-06-29 20:10:52.779376	2878
35808	47	2016-06-29 20:10:52.788826	2834
35809	47	2016-06-29 20:10:52.797869	2847
35810	47	2016-06-29 20:10:52.806405	2874
35811	47	2016-06-29 20:10:52.814535	2863
35812	47	2016-06-29 20:10:52.822723	2845
35813	47	2016-06-29 20:10:52.831097	2892
35814	41	2016-06-29 23:23:07.45421	2894
35815	41	2016-06-29 23:23:07.513767	2858
35816	41	2016-06-29 23:23:07.525956	2865
35817	41	2016-06-29 23:23:07.538448	2866
35818	45	2016-06-29 23:23:07.56137	2891
35819	42	2016-06-29 23:23:07.574893	2892
35820	42	2016-06-29 23:23:07.586778	2849
35821	42	2016-06-29 23:23:07.598814	2855
35822	42	2016-06-29 23:23:07.609315	2834
35823	42	2016-06-29 23:23:07.619895	2874
35824	42	2016-06-29 23:23:07.630136	2847
35825	42	2016-06-29 23:23:07.640301	2851
35826	42	2016-06-29 23:23:07.650618	2872
35827	43	2016-06-29 23:23:07.660721	2848
35828	43	2016-06-29 23:23:07.671258	2835
35829	43	2016-06-29 23:23:07.68207	2852
35830	43	2016-06-29 23:23:07.708262	2856
35831	43	2016-06-29 23:23:07.719274	2893
35832	43	2016-06-29 23:23:07.730948	2873
35833	43	2016-06-29 23:23:07.740335	2850
35834	43	2016-06-29 23:23:07.748016	2875
35835	40	2016-06-29 23:23:07.799207	47706
35836	40	2016-06-29 23:23:07.807189	47733
35837	40	2016-06-29 23:23:07.817308	47730
35838	40	2016-06-29 23:23:07.825712	47709
35839	40	2016-06-29 23:23:07.834331	47727
35840	40	2016-06-29 23:23:07.844653	47743
35841	40	2016-06-29 23:23:07.853752	47721
35842	49	2016-06-29 23:23:07.868532	47706
35843	49	2016-06-29 23:23:07.882242	47727
35844	49	2016-06-29 23:23:07.893388	47730
35845	49	2016-06-29 23:23:07.901288	47721
35846	49	2016-06-29 23:23:07.910952	47743
35847	49	2016-06-29 23:23:07.921693	47733
35848	49	2016-06-29 23:23:07.933138	47709
35849	48	2016-06-29 23:23:07.947748	2851
35850	48	2016-06-29 23:23:07.958691	2859
35851	48	2016-06-29 23:23:07.966542	2843
35852	48	2016-06-29 23:23:07.978917	2855
35853	48	2016-06-29 23:23:07.989359	2872
35854	48	2016-06-29 23:23:07.996968	2861
35855	48	2016-06-29 23:23:08.008165	2849
35856	48	2016-06-29 23:23:08.019812	2853
35857	48	2016-06-29 23:23:08.031714	2878
35858	48	2016-06-29 23:23:08.043813	2834
35859	48	2016-06-29 23:23:08.053211	2847
35860	48	2016-06-29 23:23:08.063519	2874
35861	48	2016-06-29 23:23:08.073796	2863
35862	48	2016-06-29 23:23:08.085396	2845
35863	48	2016-06-29 23:23:08.097252	2892
35864	50	2016-06-29 23:23:08.108274	47706
35865	50	2016-06-29 23:23:08.120018	47727
35866	50	2016-06-29 23:23:08.128577	47730
35867	50	2016-06-29 23:23:08.137303	47721
35868	50	2016-06-29 23:23:08.145656	47733
35869	50	2016-06-29 23:23:08.156169	47709
35870	47	2016-06-29 23:23:08.170652	2851
35871	47	2016-06-29 23:23:08.182199	2859
35872	47	2016-06-29 23:23:08.189914	2843
35873	47	2016-06-29 23:23:08.201097	2855
35874	47	2016-06-29 23:23:08.209851	2872
35875	47	2016-06-29 23:23:08.217525	2861
35876	47	2016-06-29 23:23:08.225958	2849
35877	47	2016-06-29 23:23:08.237956	2853
35878	47	2016-06-29 23:23:08.250851	2878
35879	47	2016-06-29 23:23:08.261607	2834
35880	47	2016-06-29 23:23:08.271546	2847
35881	47	2016-06-29 23:23:08.282222	2874
35882	47	2016-06-29 23:23:08.292052	2863
35883	47	2016-06-29 23:23:08.302876	2845
35884	47	2016-06-29 23:23:08.315606	2892
35885	41	2016-06-29 23:25:16.361266	2894
35886	41	2016-06-29 23:25:16.37171	2858
35887	41	2016-06-29 23:25:16.379613	2865
35888	41	2016-06-29 23:25:16.39142	2866
35889	45	2016-06-29 23:25:16.404105	2891
35890	42	2016-06-29 23:25:16.416762	2892
35891	42	2016-06-29 23:25:16.427695	2849
35892	42	2016-06-29 23:25:16.434867	2855
35893	42	2016-06-29 23:25:16.444916	2834
35894	42	2016-06-29 23:25:16.453588	2874
35895	42	2016-06-29 23:25:16.463744	2847
35896	42	2016-06-29 23:25:16.473921	2851
35897	42	2016-06-29 23:25:16.480752	2872
35898	43	2016-06-29 23:25:16.494643	2848
35899	43	2016-06-29 23:25:16.503234	2835
35900	43	2016-06-29 23:25:16.511272	2852
35901	43	2016-06-29 23:25:16.519215	2856
35902	43	2016-06-29 23:25:16.527137	2893
35903	43	2016-06-29 23:25:16.535345	2873
35904	43	2016-06-29 23:25:16.54288	2850
35905	43	2016-06-29 23:25:16.549979	2875
35906	40	2016-06-29 23:25:16.559714	47706
35907	40	2016-06-29 23:25:16.570143	47733
35908	40	2016-06-29 23:25:16.579547	47730
35909	40	2016-06-29 23:25:16.590165	47709
35910	40	2016-06-29 23:25:16.599092	47727
35911	40	2016-06-29 23:25:16.609179	47743
35912	40	2016-06-29 23:25:16.617887	47721
35913	49	2016-06-29 23:25:16.629602	47706
35914	49	2016-06-29 23:25:16.640488	47727
35915	49	2016-06-29 23:25:16.671488	47730
35916	49	2016-06-29 23:25:16.682164	47721
35917	49	2016-06-29 23:25:16.690322	47743
35918	49	2016-06-29 23:25:16.701969	47733
35919	49	2016-06-29 23:25:16.71346	47709
35920	48	2016-06-29 23:25:16.726703	2851
35921	48	2016-06-29 23:25:16.736591	2859
35922	48	2016-06-29 23:25:16.746975	2843
35923	48	2016-06-29 23:25:16.763683	2855
35924	48	2016-06-29 23:25:16.774544	2872
35925	48	2016-06-29 23:25:16.786242	2861
35926	48	2016-06-29 23:25:16.800066	2849
35927	48	2016-06-29 23:25:16.8117	2853
35928	48	2016-06-29 23:25:16.822542	2878
35929	48	2016-06-29 23:25:16.833794	2834
35930	48	2016-06-29 23:25:16.850621	2847
35931	48	2016-06-29 23:25:16.860279	2874
35932	48	2016-06-29 23:25:16.87231	2863
35933	48	2016-06-29 23:25:16.88232	2845
35934	48	2016-06-29 23:25:16.891389	2892
35935	50	2016-06-29 23:25:16.903677	47706
35936	50	2016-06-29 23:25:16.918234	47727
35937	50	2016-06-29 23:25:16.929554	47730
35938	50	2016-06-29 23:25:16.941616	47721
35939	50	2016-06-29 23:25:16.957364	47743
35940	50	2016-06-29 23:25:16.969238	47733
35941	50	2016-06-29 23:25:16.981632	47709
35942	47	2016-06-29 23:25:16.994545	2851
35943	47	2016-06-29 23:25:17.00795	2859
35944	47	2016-06-29 23:25:17.020396	2843
35945	47	2016-06-29 23:25:17.032752	2855
35946	47	2016-06-29 23:25:17.046363	2872
35947	47	2016-06-29 23:25:17.057786	2861
35948	47	2016-06-29 23:25:17.071083	2849
35949	47	2016-06-29 23:25:17.082027	2853
35950	47	2016-06-29 23:25:17.095654	2878
35951	47	2016-06-29 23:25:17.108627	2834
35952	47	2016-06-29 23:25:17.121381	2847
35953	47	2016-06-29 23:25:17.134603	2874
35954	47	2016-06-29 23:25:17.147161	2863
35955	47	2016-06-29 23:25:17.159028	2845
35956	47	2016-06-29 23:25:17.170482	2892
35957	41	2016-06-29 23:26:16.520616	2894
35958	41	2016-06-29 23:26:16.53343	2858
35959	41	2016-06-29 23:26:16.545165	2865
35960	41	2016-06-29 23:26:16.557995	2866
35961	45	2016-06-29 23:26:16.57277	2891
35962	42	2016-06-29 23:26:16.584429	2849
35963	42	2016-06-29 23:26:16.594918	2855
35964	42	2016-06-29 23:26:16.605115	2834
35965	42	2016-06-29 23:26:16.615744	2851
35966	42	2016-06-29 23:26:16.626499	2874
35967	42	2016-06-29 23:26:16.636274	2847
35968	43	2016-06-29 23:26:16.647373	2848
35969	43	2016-06-29 23:26:16.658277	2835
35970	43	2016-06-29 23:26:16.669298	2852
35971	43	2016-06-29 23:26:16.680274	2856
35972	43	2016-06-29 23:26:16.691151	2893
35973	43	2016-06-29 23:26:16.703124	2873
35974	43	2016-06-29 23:26:16.715393	2850
35975	43	2016-06-29 23:26:16.726221	2875
35976	40	2016-06-29 23:26:16.738402	47706
35977	40	2016-06-29 23:26:16.748547	47733
35978	40	2016-06-29 23:26:16.759402	47730
35979	40	2016-06-29 23:26:16.770022	47709
35980	40	2016-06-29 23:26:16.78135	47727
35981	40	2016-06-29 23:26:16.791739	47743
35982	40	2016-06-29 23:26:16.802455	47721
35983	49	2016-06-29 23:26:16.817761	47706
35984	49	2016-06-29 23:26:16.83211	47727
35985	49	2016-06-29 23:26:16.844604	47730
35986	49	2016-06-29 23:26:16.857957	47721
35987	49	2016-06-29 23:26:16.870144	47743
35988	49	2016-06-29 23:26:16.881264	47733
35989	49	2016-06-29 23:26:16.894516	47709
35990	48	2016-06-29 23:26:16.910335	2851
35991	48	2016-06-29 23:26:16.92377	2859
35992	48	2016-06-29 23:26:16.93581	2843
35993	48	2016-06-29 23:26:16.949124	2855
35994	48	2016-06-29 23:26:16.960651	2872
35995	48	2016-06-29 23:26:16.972219	2861
35996	48	2016-06-29 23:26:16.986218	2849
35997	48	2016-06-29 23:26:16.997959	2853
35998	48	2016-06-29 23:26:17.010506	2878
35999	48	2016-06-29 23:26:17.024403	2834
36000	48	2016-06-29 23:26:17.038001	2847
36001	48	2016-06-29 23:26:17.050912	2874
36002	48	2016-06-29 23:26:17.064646	2863
36003	48	2016-06-29 23:26:17.073043	2845
36004	48	2016-06-29 23:26:17.085211	2892
36005	50	2016-06-29 23:26:17.096399	47706
36006	50	2016-06-29 23:26:17.108105	47727
36007	50	2016-06-29 23:26:17.118946	47730
36008	50	2016-06-29 23:26:17.13085	47721
36009	50	2016-06-29 23:26:17.139453	47743
36010	50	2016-06-29 23:26:17.147426	47733
36011	50	2016-06-29 23:26:17.160125	47709
36012	47	2016-06-29 23:26:17.175622	2851
36013	47	2016-06-29 23:26:17.186723	2859
36014	47	2016-06-29 23:26:17.196052	2843
36015	47	2016-06-29 23:26:17.206924	2855
36016	47	2016-06-29 23:26:17.217318	2872
36017	47	2016-06-29 23:26:17.229701	2861
36018	47	2016-06-29 23:26:17.23828	2849
36019	47	2016-06-29 23:26:17.2468	2853
36020	47	2016-06-29 23:26:17.256831	2878
36021	47	2016-06-29 23:26:17.270136	2834
36022	47	2016-06-29 23:26:17.28577	2847
36023	47	2016-06-29 23:26:17.295614	2874
36024	47	2016-06-29 23:26:17.304101	2863
36025	47	2016-06-29 23:26:17.317309	2845
36026	47	2016-06-29 23:26:17.325014	2892
36027	41	2016-06-29 23:27:17.805755	2894
36028	41	2016-06-29 23:27:17.82062	2858
36029	41	2016-06-29 23:27:17.832982	2865
36030	41	2016-06-29 23:27:17.845849	2866
36031	45	2016-06-29 23:27:17.861076	2891
36032	42	2016-06-29 23:27:17.876439	2855
36033	42	2016-06-29 23:27:17.88841	2834
36034	42	2016-06-29 23:27:17.89898	2851
36035	42	2016-06-29 23:27:17.910346	2874
36036	43	2016-06-29 23:27:17.921326	2848
36037	43	2016-06-29 23:27:17.932277	2835
36038	43	2016-06-29 23:27:17.943731	2852
36039	43	2016-06-29 23:27:17.954555	2856
36040	43	2016-06-29 23:27:17.965504	2893
36041	43	2016-06-29 23:27:17.977544	2873
36042	43	2016-06-29 23:27:17.990433	2850
36043	43	2016-06-29 23:27:18.001887	2875
36044	40	2016-06-29 23:27:18.015441	47706
36045	40	2016-06-29 23:27:18.026267	47733
36046	40	2016-06-29 23:27:18.036599	47730
36047	40	2016-06-29 23:27:18.047267	47709
36048	40	2016-06-29 23:27:18.057853	47727
36049	40	2016-06-29 23:27:18.068778	47743
36050	40	2016-06-29 23:27:18.079345	47721
36051	49	2016-06-29 23:27:18.093916	47706
36052	49	2016-06-29 23:27:18.107404	47727
36053	49	2016-06-29 23:27:18.11941	47730
36054	49	2016-06-29 23:27:18.131496	47721
36055	49	2016-06-29 23:27:18.142847	47743
36056	49	2016-06-29 23:27:18.154667	47733
36057	49	2016-06-29 23:27:18.16795	47709
36058	48	2016-06-29 23:27:18.183753	2851
36059	48	2016-06-29 23:27:18.196475	2859
36060	48	2016-06-29 23:27:18.209214	2843
36061	48	2016-06-29 23:27:18.223237	2855
36062	48	2016-06-29 23:27:18.2343	2872
36063	48	2016-06-29 23:27:18.246156	2861
36064	48	2016-06-29 23:27:18.258563	2849
36065	48	2016-06-29 23:27:18.270801	2853
36066	48	2016-06-29 23:27:18.284468	2878
36067	48	2016-06-29 23:27:18.298468	2834
36068	48	2016-06-29 23:27:18.30967	2847
36069	48	2016-06-29 23:27:18.322731	2874
36070	48	2016-06-29 23:27:18.334793	2863
36071	48	2016-06-29 23:27:18.34736	2845
36072	48	2016-06-29 23:27:18.358335	2892
36073	50	2016-06-29 23:27:18.373513	47706
36074	50	2016-06-29 23:27:18.386253	47727
36075	50	2016-06-29 23:27:18.398412	47730
36076	50	2016-06-29 23:27:18.412377	47721
36077	50	2016-06-29 23:27:18.424148	47743
36078	50	2016-06-29 23:27:18.438227	47733
36079	50	2016-06-29 23:27:18.451446	47709
36080	47	2016-06-29 23:27:18.467572	2851
36081	47	2016-06-29 23:27:18.479767	2859
36082	47	2016-06-29 23:27:18.491989	2843
36083	47	2016-06-29 23:27:18.504641	2855
36084	47	2016-06-29 23:27:18.515485	2872
36085	47	2016-06-29 23:27:18.52666	2861
36086	47	2016-06-29 23:27:18.538771	2849
36087	47	2016-06-29 23:27:18.549505	2853
36088	47	2016-06-29 23:27:18.559847	2878
36089	47	2016-06-29 23:27:18.570278	2834
36090	47	2016-06-29 23:27:18.57961	2847
36091	47	2016-06-29 23:27:18.588032	2874
36092	47	2016-06-29 23:27:18.596339	2863
36093	47	2016-06-29 23:27:18.605414	2845
36094	47	2016-06-29 23:27:18.614626	2892
36095	41	2016-06-29 23:28:54.795375	2894
36096	41	2016-06-29 23:28:54.805021	2858
36097	41	2016-06-29 23:28:54.812866	2865
36098	41	2016-06-29 23:28:54.823571	2866
36099	45	2016-06-29 23:28:54.837114	2891
36100	42	2016-06-29 23:28:54.847616	2855
36101	42	2016-06-29 23:28:54.855796	2834
36102	42	2016-06-29 23:28:54.864792	2851
36103	42	2016-06-29 23:28:54.873639	2874
36104	43	2016-06-29 23:28:54.882887	2848
36105	43	2016-06-29 23:28:54.891605	2835
36106	43	2016-06-29 23:28:54.900423	2852
36107	43	2016-06-29 23:28:54.909678	2856
36108	43	2016-06-29 23:28:54.919765	2893
36109	43	2016-06-29 23:28:54.927324	2873
36110	43	2016-06-29 23:28:54.935587	2850
36111	43	2016-06-29 23:28:54.94396	2875
36112	40	2016-06-29 23:28:54.952748	47706
36113	40	2016-06-29 23:28:54.960127	47733
36114	40	2016-06-29 23:28:54.968495	47730
36115	40	2016-06-29 23:28:54.978064	47709
36116	40	2016-06-29 23:28:54.987459	47727
36117	40	2016-06-29 23:28:54.994306	47743
36118	40	2016-06-29 23:28:55.001381	47721
36119	49	2016-06-29 23:28:55.011427	47706
36120	49	2016-06-29 23:28:55.024274	47727
36121	49	2016-06-29 23:28:55.036017	47730
36122	49	2016-06-29 23:28:55.049249	47721
36123	49	2016-06-29 23:28:55.059172	47743
36124	49	2016-06-29 23:28:55.069827	47733
36125	49	2016-06-29 23:28:55.079809	47709
36126	48	2016-06-29 23:28:55.096134	2851
36127	48	2016-06-29 23:28:55.10609	2859
36128	48	2016-06-29 23:28:55.116321	2843
36129	48	2016-06-29 23:28:55.129451	2855
36130	48	2016-06-29 23:28:55.137219	2872
36131	48	2016-06-29 23:28:55.14804	2861
36132	48	2016-06-29 23:28:55.15853	2849
36133	48	2016-06-29 23:28:55.168557	2853
36134	48	2016-06-29 23:28:55.178763	2878
36135	48	2016-06-29 23:28:55.189743	2834
36136	48	2016-06-29 23:28:55.199346	2847
36137	48	2016-06-29 23:28:55.213093	2874
36138	48	2016-06-29 23:28:55.222243	2863
36139	48	2016-06-29 23:28:55.234854	2845
36140	48	2016-06-29 23:28:55.247903	2892
36141	50	2016-06-29 23:28:55.259147	47706
36142	50	2016-06-29 23:28:55.271777	47727
36143	50	2016-06-29 23:28:55.281474	47730
36144	50	2016-06-29 23:28:55.2925	47721
36145	50	2016-06-29 23:28:55.303053	47743
36146	50	2016-06-29 23:28:55.315985	47733
36147	50	2016-06-29 23:28:55.328368	47709
36148	47	2016-06-29 23:28:55.340208	2851
36149	47	2016-06-29 23:28:55.348657	2859
36150	47	2016-06-29 23:28:55.358205	2843
36151	47	2016-06-29 23:28:55.37048	2855
36152	47	2016-06-29 23:28:55.379315	2872
36153	47	2016-06-29 23:28:55.387113	2861
36154	47	2016-06-29 23:28:55.398232	2849
36155	47	2016-06-29 23:28:55.407406	2853
36156	47	2016-06-29 23:28:55.420624	2878
36157	47	2016-06-29 23:28:55.431141	2834
36158	47	2016-06-29 23:28:55.439283	2847
36159	47	2016-06-29 23:28:55.450362	2874
36160	47	2016-06-29 23:28:55.461356	2863
36161	47	2016-06-29 23:28:55.472572	2845
36162	47	2016-06-29 23:28:55.4821	2892
36163	41	2016-06-29 23:30:08.713549	2894
36164	41	2016-06-29 23:30:08.72649	2858
36165	41	2016-06-29 23:30:08.739365	2865
36166	41	2016-06-29 23:30:08.753126	2866
36167	45	2016-06-29 23:30:08.766901	2891
36168	42	2016-06-29 23:30:08.781675	2855
36169	42	2016-06-29 23:30:08.791296	2834
36170	42	2016-06-29 23:30:08.801456	2851
36171	42	2016-06-29 23:30:08.812163	2874
36172	43	2016-06-29 23:30:08.82189	2848
36173	43	2016-06-29 23:30:08.831389	2835
36174	43	2016-06-29 23:30:08.840787	2852
36175	43	2016-06-29 23:30:08.852834	2856
36176	43	2016-06-29 23:30:08.863066	2893
36177	43	2016-06-29 23:30:08.873034	2873
36178	43	2016-06-29 23:30:08.884818	2850
36179	43	2016-06-29 23:30:08.89467	2875
36180	40	2016-06-29 23:30:08.905952	47706
36181	40	2016-06-29 23:30:08.915877	47733
36182	40	2016-06-29 23:30:08.926478	47730
36183	40	2016-06-29 23:30:08.936646	47709
36184	40	2016-06-29 23:30:08.947567	47727
36185	40	2016-06-29 23:30:08.957574	47743
36186	40	2016-06-29 23:30:08.967171	47721
36187	49	2016-06-29 23:30:08.982265	47706
36188	49	2016-06-29 23:30:08.996037	47727
36189	49	2016-06-29 23:30:09.008601	47730
36190	49	2016-06-29 23:30:09.020722	47721
36191	49	2016-06-29 23:30:09.033226	47743
36192	49	2016-06-29 23:30:09.045072	47733
36193	49	2016-06-29 23:30:09.058097	47709
36194	48	2016-06-29 23:30:09.074286	2851
36195	48	2016-06-29 23:30:09.087205	2859
36196	48	2016-06-29 23:30:09.099531	2843
36197	48	2016-06-29 23:30:09.11291	2855
36198	48	2016-06-29 23:30:09.124292	2872
36199	48	2016-06-29 23:30:09.137418	2861
36200	48	2016-06-29 23:30:09.149941	2849
36201	48	2016-06-29 23:30:09.161759	2853
36202	48	2016-06-29 23:30:09.172545	2878
36203	48	2016-06-29 23:30:09.185987	2834
36204	48	2016-06-29 23:30:09.198668	2847
36205	48	2016-06-29 23:30:09.212447	2874
36206	48	2016-06-29 23:30:09.224651	2863
36207	48	2016-06-29 23:30:09.241603	2845
36208	48	2016-06-29 23:30:09.253269	2892
36209	50	2016-06-29 23:30:09.26768	47706
36210	50	2016-06-29 23:30:09.280057	47727
36211	50	2016-06-29 23:30:09.292135	47730
36212	50	2016-06-29 23:30:09.305581	47721
36213	50	2016-06-29 23:30:09.321669	47743
36214	50	2016-06-29 23:30:09.338254	47733
36215	50	2016-06-29 23:30:09.351761	47709
36216	47	2016-06-29 23:30:09.367539	2851
36217	47	2016-06-29 23:30:09.379771	2859
36218	47	2016-06-29 23:30:09.391894	2843
36219	47	2016-06-29 23:30:09.404286	2855
36220	47	2016-06-29 23:30:09.416538	2872
36221	47	2016-06-29 23:30:09.4295	2861
36222	47	2016-06-29 23:30:09.443022	2849
36223	47	2016-06-29 23:30:09.454159	2853
36224	47	2016-06-29 23:30:09.467085	2878
36225	47	2016-06-29 23:30:09.480883	2834
36226	47	2016-06-29 23:30:09.492397	2847
36227	47	2016-06-29 23:30:09.505147	2874
36228	47	2016-06-29 23:30:09.515078	2863
36229	47	2016-06-29 23:30:09.52517	2845
36230	47	2016-06-29 23:30:09.532429	2892
36231	41	2016-06-29 23:31:17.748034	2894
36232	41	2016-06-29 23:31:17.757901	2858
36233	41	2016-06-29 23:31:17.766648	2865
36234	41	2016-06-29 23:31:17.777184	2866
36235	45	2016-06-29 23:31:17.786866	2891
36236	42	2016-06-29 23:31:17.7988	2855
36237	42	2016-06-29 23:31:17.80831	2834
36238	42	2016-06-29 23:31:17.820956	2851
36239	42	2016-06-29 23:31:17.830712	2874
36240	43	2016-06-29 23:31:17.839051	2848
36241	43	2016-06-29 23:31:17.84929	2835
36242	43	2016-06-29 23:31:17.858699	2852
36243	43	2016-06-29 23:31:17.869402	2856
36244	43	2016-06-29 23:31:17.880082	2893
36245	43	2016-06-29 23:31:17.887188	2873
36246	43	2016-06-29 23:31:17.894498	2850
36247	43	2016-06-29 23:31:17.902394	2875
36248	40	2016-06-29 23:31:17.912654	47706
36249	40	2016-06-29 23:31:17.919259	47733
36250	40	2016-06-29 23:31:17.92723	47730
36251	40	2016-06-29 23:31:17.934369	47709
36252	40	2016-06-29 23:31:17.941111	47727
36253	40	2016-06-29 23:31:17.94768	47743
36254	40	2016-06-29 23:31:17.956737	47721
36255	49	2016-06-29 23:31:17.969232	47706
36256	49	2016-06-29 23:31:17.978504	47727
36257	49	2016-06-29 23:31:17.992242	47730
36258	49	2016-06-29 23:31:18.003544	47721
36259	49	2016-06-29 23:31:18.011234	47743
36260	49	2016-06-29 23:31:18.021644	47733
36261	49	2016-06-29 23:31:18.029622	47709
36262	48	2016-06-29 23:31:18.04329	2851
36263	48	2016-06-29 23:31:18.051123	2859
36264	48	2016-06-29 23:31:18.064348	2843
36265	48	2016-06-29 23:31:18.074173	2855
36266	48	2016-06-29 23:31:18.081913	2872
36267	48	2016-06-29 23:31:18.095897	2861
36268	48	2016-06-29 23:31:18.104304	2849
36269	48	2016-06-29 23:31:18.116792	2853
36270	48	2016-06-29 23:31:18.127382	2878
36271	48	2016-06-29 23:31:18.136067	2834
36272	48	2016-06-29 23:31:18.145607	2847
36273	48	2016-06-29 23:31:18.157381	2874
36274	48	2016-06-29 23:31:18.167464	2863
36275	48	2016-06-29 23:31:18.178545	2845
36276	48	2016-06-29 23:31:18.188154	2892
36277	50	2016-06-29 23:31:18.200581	47706
36278	50	2016-06-29 23:31:18.211347	47727
36279	50	2016-06-29 23:31:18.224996	47730
36280	50	2016-06-29 23:31:18.238831	47721
36281	50	2016-06-29 23:31:18.250932	47743
36282	50	2016-06-29 23:31:18.263546	47733
36283	50	2016-06-29 23:31:18.2763	47709
36284	47	2016-06-29 23:31:18.292654	2851
36285	47	2016-06-29 23:31:18.304831	2859
36286	47	2016-06-29 23:31:18.314372	2843
36287	47	2016-06-29 23:31:18.328936	2855
36288	47	2016-06-29 23:31:18.341383	2872
36289	47	2016-06-29 23:31:18.350289	2861
36290	47	2016-06-29 23:31:18.364135	2849
36291	47	2016-06-29 23:31:18.376502	2853
36292	47	2016-06-29 23:31:18.385572	2878
36293	47	2016-06-29 23:31:18.39606	2834
36294	47	2016-06-29 23:31:18.409652	2847
36295	47	2016-06-29 23:31:18.419218	2874
36296	47	2016-06-29 23:31:18.428826	2863
36297	47	2016-06-29 23:31:18.441887	2845
36298	47	2016-06-29 23:31:18.451333	2892
36299	41	2016-06-29 23:51:09.674392	2894
36300	41	2016-06-29 23:51:09.684314	2858
36301	41	2016-06-29 23:51:09.698944	2865
36302	41	2016-06-29 23:51:09.708817	2866
36303	45	2016-06-29 23:51:09.720892	2891
36304	42	2016-06-29 23:51:09.729098	2855
36305	42	2016-06-29 23:51:09.739748	2834
36306	42	2016-06-29 23:51:09.748503	2851
36307	42	2016-06-29 23:51:09.758541	2874
36308	43	2016-06-29 23:51:09.769115	2848
36309	43	2016-06-29 23:51:09.778074	2835
36310	43	2016-06-29 23:51:09.787778	2852
36311	43	2016-06-29 23:51:09.79683	2856
36312	43	2016-06-29 23:51:09.80628	2893
36313	43	2016-06-29 23:51:09.815326	2873
36314	43	2016-06-29 23:51:09.826161	2850
36315	43	2016-06-29 23:51:09.836503	2875
36316	40	2016-06-29 23:51:09.848007	47706
36317	40	2016-06-29 23:51:09.857493	47733
36318	40	2016-06-29 23:51:09.867293	47730
36319	40	2016-06-29 23:51:09.875188	47709
36320	40	2016-06-29 23:51:09.884645	47727
36321	40	2016-06-29 23:51:09.892528	47743
36322	40	2016-06-29 23:51:09.900362	47721
36323	49	2016-06-29 23:51:09.916112	47706
36324	49	2016-06-29 23:51:09.938769	47727
36325	49	2016-06-29 23:51:09.952788	47730
36326	49	2016-06-29 23:51:09.962623	47721
36327	49	2016-06-29 23:51:09.971724	47743
36328	49	2016-06-29 23:51:09.980513	47733
36329	49	2016-06-29 23:51:09.988972	47709
36330	48	2016-06-29 23:51:09.999113	2851
36331	48	2016-06-29 23:51:10.008964	2859
36332	48	2016-06-29 23:51:10.022904	2843
36333	48	2016-06-29 23:51:10.035206	2855
36334	48	2016-06-29 23:51:10.043532	2872
36335	48	2016-06-29 23:51:10.055935	2861
36336	48	2016-06-29 23:51:10.065908	2849
36337	48	2016-06-29 23:51:10.074136	2853
36338	48	2016-06-29 23:51:10.083676	2878
36339	48	2016-06-29 23:51:10.095938	2834
36340	48	2016-06-29 23:51:10.104054	2847
36341	48	2016-06-29 23:51:10.113903	2874
36342	48	2016-06-29 23:51:10.124477	2863
36343	48	2016-06-29 23:51:10.13878	2845
36344	48	2016-06-29 23:51:10.15463	2892
36345	50	2016-06-29 23:51:10.16739	47706
36346	50	2016-06-29 23:51:10.17742	47727
36347	50	2016-06-29 23:51:10.186772	47730
36348	50	2016-06-29 23:51:10.199542	47721
36349	50	2016-06-29 23:51:10.210992	47743
36350	50	2016-06-29 23:51:10.219237	47733
36351	50	2016-06-29 23:51:10.227382	47709
36352	47	2016-06-29 23:51:10.244694	2851
36353	47	2016-06-29 23:51:10.255545	2859
36354	47	2016-06-29 23:51:10.264472	2843
36355	47	2016-06-29 23:51:10.27541	2855
36356	47	2016-06-29 23:51:10.286203	2872
36357	47	2016-06-29 23:51:10.29538	2861
36358	47	2016-06-29 23:51:10.307549	2849
36359	47	2016-06-29 23:51:10.315968	2853
36360	47	2016-06-29 23:51:10.32726	2878
36361	47	2016-06-29 23:51:10.338207	2834
36362	47	2016-06-29 23:51:10.349298	2847
36363	47	2016-06-29 23:51:10.360055	2874
36364	47	2016-06-29 23:51:10.371613	2863
36365	47	2016-06-29 23:51:10.384253	2845
36366	47	2016-06-29 23:51:10.392787	2892
36367	41	2016-06-30 00:13:14.235315	2894
36368	41	2016-06-30 00:13:14.252956	2858
36369	41	2016-06-30 00:13:14.263956	2865
36370	41	2016-06-30 00:13:14.286073	2866
36371	45	2016-06-30 00:13:14.308589	2891
36372	42	2016-06-30 00:13:14.332522	2855
36373	42	2016-06-30 00:13:14.368562	2834
36374	42	2016-06-30 00:13:14.398481	2851
36375	42	2016-06-30 00:13:14.426855	2874
36376	43	2016-06-30 00:13:14.469688	2848
36377	43	2016-06-30 00:13:14.481702	2835
36378	43	2016-06-30 00:13:14.506547	2852
36379	43	2016-06-30 00:13:14.528812	2856
36380	43	2016-06-30 00:13:14.536047	2893
36381	43	2016-06-30 00:13:14.543929	2873
36382	43	2016-06-30 00:13:14.553975	2850
36383	43	2016-06-30 00:13:14.571581	2875
36384	40	2016-06-30 00:13:14.608271	47706
36385	40	2016-06-30 00:13:14.655921	47733
36386	40	2016-06-30 00:13:14.696113	47730
36387	40	2016-06-30 00:13:14.721058	47709
36388	40	2016-06-30 00:13:14.75981	47727
36389	40	2016-06-30 00:13:14.804364	47743
36390	40	2016-06-30 00:13:14.830079	47721
36391	49	2016-06-30 00:13:14.862077	47706
36392	49	2016-06-30 00:13:14.898677	47727
36393	49	2016-06-30 00:13:14.927073	47730
36394	49	2016-06-30 00:13:14.948116	47721
36395	49	2016-06-30 00:13:14.984916	47743
36396	49	2016-06-30 00:13:15.008277	47733
36397	49	2016-06-30 00:13:15.01616	47709
36398	48	2016-06-30 00:13:15.026439	2851
36399	48	2016-06-30 00:13:15.034369	2859
36400	48	2016-06-30 00:13:15.042088	2843
36401	48	2016-06-30 00:13:15.050671	2855
36402	48	2016-06-30 00:13:15.059766	2872
36403	48	2016-06-30 00:13:15.083865	2861
36404	48	2016-06-30 00:13:15.091604	2849
36405	48	2016-06-30 00:13:15.099582	2853
36406	48	2016-06-30 00:13:15.107447	2878
36407	48	2016-06-30 00:13:15.115945	2834
36408	48	2016-06-30 00:13:15.124041	2847
36409	48	2016-06-30 00:13:15.132834	2874
36410	48	2016-06-30 00:13:15.140591	2863
36411	48	2016-06-30 00:13:15.149045	2845
36412	48	2016-06-30 00:13:15.156673	2892
36413	50	2016-06-30 00:13:15.166276	47706
36414	50	2016-06-30 00:13:15.17422	47727
36415	50	2016-06-30 00:13:15.182438	47730
36416	50	2016-06-30 00:13:15.190253	47721
36417	50	2016-06-30 00:13:15.198033	47743
36418	50	2016-06-30 00:13:15.206039	47733
36419	50	2016-06-30 00:13:15.214902	47709
36420	47	2016-06-30 00:13:15.225111	2851
36421	47	2016-06-30 00:13:15.234381	2859
36422	47	2016-06-30 00:13:15.242009	2843
36423	47	2016-06-30 00:13:15.250603	2855
36424	47	2016-06-30 00:13:15.258217	2872
36425	47	2016-06-30 00:13:15.265823	2861
36426	47	2016-06-30 00:13:15.273648	2849
36427	47	2016-06-30 00:13:15.281484	2853
36428	47	2016-06-30 00:13:15.288981	2878
36429	47	2016-06-30 00:13:15.297482	2834
36430	47	2016-06-30 00:13:15.305442	2847
36431	47	2016-06-30 00:13:15.313914	2874
36432	47	2016-06-30 00:13:15.321749	2863
36433	47	2016-06-30 00:13:15.329836	2845
36434	47	2016-06-30 00:13:15.33763	2892
36435	41	2016-06-30 00:16:34.598173	2894
36436	41	2016-06-30 00:16:34.60698	2858
36437	41	2016-06-30 00:16:34.615176	2865
36438	41	2016-06-30 00:16:34.624153	2866
36439	45	2016-06-30 00:16:34.632934	2891
36440	42	2016-06-30 00:16:34.640727	2855
36441	42	2016-06-30 00:16:34.647893	2834
36442	42	2016-06-30 00:16:34.656366	2851
36443	42	2016-06-30 00:16:34.664246	2874
36444	43	2016-06-30 00:16:34.672537	2848
36445	43	2016-06-30 00:16:34.679991	2835
36446	43	2016-06-30 00:16:34.687734	2852
36447	43	2016-06-30 00:16:34.694818	2856
36448	43	2016-06-30 00:16:34.701979	2893
36449	43	2016-06-30 00:16:34.709457	2873
36450	43	2016-06-30 00:16:34.716197	2850
36451	43	2016-06-30 00:16:34.723378	2875
36452	40	2016-06-30 00:16:34.758364	47706
36453	40	2016-06-30 00:16:34.766038	47733
36454	40	2016-06-30 00:16:34.773448	47730
36455	40	2016-06-30 00:16:34.780253	47709
36456	40	2016-06-30 00:16:34.786986	47727
36457	40	2016-06-30 00:16:34.793497	47743
36458	40	2016-06-30 00:16:34.800547	47721
36459	49	2016-06-30 00:16:34.811109	47706
36460	49	2016-06-30 00:16:34.819262	47727
36461	49	2016-06-30 00:16:34.827438	47730
36462	49	2016-06-30 00:16:34.835554	47721
36463	49	2016-06-30 00:16:34.843408	47743
36464	49	2016-06-30 00:16:34.851433	47733
36465	49	2016-06-30 00:16:34.859403	47709
36466	48	2016-06-30 00:16:34.869729	2851
36467	48	2016-06-30 00:16:34.877792	2859
36468	48	2016-06-30 00:16:34.8865	2843
36469	48	2016-06-30 00:16:34.895272	2855
36470	48	2016-06-30 00:16:34.903608	2872
36471	48	2016-06-30 00:16:34.91153	2861
36472	48	2016-06-30 00:16:34.919938	2849
36473	48	2016-06-30 00:16:34.92788	2853
36474	48	2016-06-30 00:16:34.936075	2878
36475	48	2016-06-30 00:16:34.945889	2834
36476	48	2016-06-30 00:16:34.953973	2847
36477	48	2016-06-30 00:16:34.962538	2874
36478	48	2016-06-30 00:16:34.970321	2863
36479	48	2016-06-30 00:16:34.979766	2845
36480	48	2016-06-30 00:16:34.988287	2892
36481	50	2016-06-30 00:16:34.997863	47706
36482	50	2016-06-30 00:16:35.006428	47727
36483	50	2016-06-30 00:16:35.014456	47730
36484	50	2016-06-30 00:16:35.023379	47721
36485	50	2016-06-30 00:16:35.031343	47743
36486	50	2016-06-30 00:16:35.039402	47733
36487	50	2016-06-30 00:16:35.047688	47709
36488	47	2016-06-30 00:16:35.05806	2851
36489	47	2016-06-30 00:16:35.06612	2859
36490	47	2016-06-30 00:16:35.074469	2843
36491	47	2016-06-30 00:16:35.083335	2855
36492	47	2016-06-30 00:16:35.091657	2872
36493	47	2016-06-30 00:16:35.099757	2861
36494	47	2016-06-30 00:16:35.107951	2849
36495	47	2016-06-30 00:16:35.115808	2853
36496	47	2016-06-30 00:16:35.123836	2878
36497	47	2016-06-30 00:16:35.132399	2834
36498	47	2016-06-30 00:16:35.141429	2847
36499	47	2016-06-30 00:16:35.150164	2874
36500	47	2016-06-30 00:16:35.158093	2863
36501	47	2016-06-30 00:16:35.166522	2845
36502	47	2016-06-30 00:16:35.174514	2892
36503	41	2016-06-30 00:21:04.761896	2894
36504	41	2016-06-30 00:21:04.770648	2858
36505	41	2016-06-30 00:21:04.779293	2865
36506	41	2016-06-30 00:21:04.787283	2866
36507	45	2016-06-30 00:21:04.815077	2891
36508	42	2016-06-30 00:21:04.823082	2855
36509	42	2016-06-30 00:21:04.830497	2834
36510	42	2016-06-30 00:21:04.837483	2851
36511	42	2016-06-30 00:21:04.844974	2874
36512	43	2016-06-30 00:21:04.853226	2848
36513	43	2016-06-30 00:21:04.862512	2835
36514	43	2016-06-30 00:21:04.869991	2852
36515	43	2016-06-30 00:21:04.878892	2856
36516	43	2016-06-30 00:21:04.8866	2893
36517	43	2016-06-30 00:21:04.894261	2873
36518	43	2016-06-30 00:21:04.901673	2850
36519	43	2016-06-30 00:21:04.909976	2875
36520	40	2016-06-30 00:21:04.918545	47706
36521	40	2016-06-30 00:21:04.925917	47733
36522	40	2016-06-30 00:21:04.932954	47730
36523	40	2016-06-30 00:21:04.940185	47709
36524	40	2016-06-30 00:21:04.948444	47727
36525	40	2016-06-30 00:21:04.95566	47743
36526	40	2016-06-30 00:21:04.963136	47721
36527	49	2016-06-30 00:21:04.973593	47706
36528	49	2016-06-30 00:21:04.982176	47727
36529	49	2016-06-30 00:21:04.990662	47730
36530	49	2016-06-30 00:21:04.998944	47721
36531	49	2016-06-30 00:21:05.007303	47743
36532	49	2016-06-30 00:21:05.015372	47733
36533	49	2016-06-30 00:21:05.024302	47709
36534	48	2016-06-30 00:21:05.035972	2851
36535	48	2016-06-30 00:21:05.045402	2859
36536	48	2016-06-30 00:21:05.056473	2843
36537	48	2016-06-30 00:21:05.067202	2855
36538	48	2016-06-30 00:21:05.075569	2872
36539	48	2016-06-30 00:21:05.084281	2861
36540	48	2016-06-30 00:21:05.092925	2849
36541	48	2016-06-30 00:21:05.101481	2853
36542	48	2016-06-30 00:21:05.109952	2878
36543	48	2016-06-30 00:21:05.119443	2834
36544	48	2016-06-30 00:21:05.128008	2847
36545	48	2016-06-30 00:21:05.136843	2874
36546	48	2016-06-30 00:21:05.145396	2863
36547	48	2016-06-30 00:21:05.154384	2845
36548	48	2016-06-30 00:21:05.163525	2892
36549	50	2016-06-30 00:21:05.173316	47706
36550	50	2016-06-30 00:21:05.182566	47727
36551	50	2016-06-30 00:21:05.19106	47730
36552	50	2016-06-30 00:21:05.199995	47721
36553	50	2016-06-30 00:21:05.208583	47743
36554	50	2016-06-30 00:21:05.217608	47733
36555	50	2016-06-30 00:21:05.226364	47709
36556	47	2016-06-30 00:21:05.241433	2851
36557	47	2016-06-30 00:21:05.249479	2859
36558	47	2016-06-30 00:21:05.257872	2843
36559	47	2016-06-30 00:21:05.266757	2855
36560	47	2016-06-30 00:21:05.275066	2872
36561	47	2016-06-30 00:21:05.28322	2861
36562	47	2016-06-30 00:21:05.291641	2849
36563	47	2016-06-30 00:21:05.299971	2853
36564	47	2016-06-30 00:21:05.30861	2878
36565	47	2016-06-30 00:21:05.318054	2834
36566	47	2016-06-30 00:21:05.3265	2847
36567	47	2016-06-30 00:21:05.335849	2874
36568	47	2016-06-30 00:21:05.344229	2863
36569	47	2016-06-30 00:21:05.353519	2845
36570	47	2016-06-30 00:21:05.361962	2892
\.


--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_notificacoes_id_seq', 36570, true);


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
90	4	2
91	4	3
92	4	5
93	4	85
97	14	2
98	16	2
99	15	2
100	21	2
101	22	85
102	22	5
103	22	2
104	22	3
105	23	2
106	24	2
\.


--
-- Name: usuario_atores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuario_atores_id_seq', 106, true);


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarios (id, email, nome, senha, login, admin) FROM stdin;
14	\N	Bruno Silva	teste123	bruno.silva	\N
15	\N	Gabriel Prado	teste123	gabriel.prado	\N
16	\N	Luciano Neucamp	teste123	luciano.neucamp	\N
17	\N	Daniele Blanco	teste123	daniele.blanco	\N
4	babirondo@gmail.com	Bruno Siqueira	teste123	bruno.siqueira	1
21	\N	Danilo Trindade	teste123	danilo.trindade	\N
22	\N	Daniel Doro	teste123	daniel.doro	1
23	\N	Vitor Mendes	teste123	vitor.mendes	\N
24	\N	Adelar Junior	teste123	adelar.junior	\N
\.


--
-- Data for Name: usuarios_avaliadores_tecnologias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarios_avaliadores_tecnologias (id, idusuario, idtecnologia) FROM stdin;
44	14	1
45	15	5
46	16	9
47	16	10
48	16	11
49	16	13
50	15	2
51	15	5
52	15	6
53	15	7
54	15	11
56	21	3
57	23	2
58	23	6
59	24	3
\.


--
-- Name: usuarios_avaliadores_tecnologias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuarios_avaliadores_tecnologias_id_seq', 59, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuarios_id_seq', 24, true);


--
-- Data for Name: workflow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow (id, workflow, posto_inicial, posto_final, penultimo_posto) FROM stdin;
1	Recrutamento e Seleção	1	280	7
\.


--
-- Data for Name: workflow_dados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_dados (id, idpostocampo, valor, idprocesso, registro, idposto, idworkflowtramitacao) FROM stdin;
6189	13	Android	47699	2016-06-27 17:04:10.70208	1	2832
6190	174	3) Teste Técnico\r\n\r\nCrie um aplicativo android para organizar a agenda de compromissos do seu usuário.\r\n\r\nEsta agenda deve:\r\n\r\n  *   Ter um sistema de autenticação para identificar o usuário.\r\n  *   Incluir novo compromisso.\r\n  *   Alterar compromisso.\r\n  *   Excluir um compromisso.\r\n  *   Buscar um compromisso.\r\n  *   Criar um alerta de um compromisso iminente. A antecedência deste alerta deve ser configurada pelo usuário.\r\n\r\nExigências:\r\n\r\n  *   Toda a comunicação deste app deve ocorrer ocorrer via webservices.\r\n  *   Todo o projeto deve ser submetido no github ou outro similar que use GIT.\r\n  *   Não se esqueça de justificar as suas escolhas (de tecnologia, layout, etc...) no arquivo README que deve acompanhar sua solução. Além de nos informar como proceder para fazer o build do APK.\r\n\r\nOutras informações\r\n\r\n  *   Documentação e testes serão avaliados também =)\r\n  *   A criação dos webservices e a tecnologia utilizadas ficam a critério do candidato.\r\n  *   O layout também fica a critério do candidato.\r\n	47699	2016-06-27 17:04:10.70284	1	2832
6191	1	1) Título da Vaga\r\nDesenvolvedor Android\r\n\r\n2) Perfil da Vaga\r\nVocê será responsável por entregar soluções inovadoras para ajudar os usuários do Walmart.com que utilizam dispositivos móveis. As soluções devem ser escaláveis para suportar milhões de clientes no Brasil e no mundo. Além de auxiliar na evolução do produto e resolver problemas que afetam o cliente durante toda a sua jornada: em busca de sortimento/catálogo de produtos, pagamento e acompanhamento de duas compras. Sempre integrado a outros times para desenvolver as melhores soluções e ferramentas para atender às necessidades de nossos usuários.\r\n\r\nConhecimentos e Experiência Profissional\r\n\r\n  *   Domínio da plataforma Java e frameworks de desenvolvimento de sistemas Web (back end)\r\n  *   Experiência no uso de tecnologias baseadas em Android,  Android SDK  e Android studio.\r\n  *   Conhecimento de estruturas com Apis Google.\r\n  *   Experiência de desenvolvimento de sistemas em ambientes distribuídos, escaláveis e de alta disponibilidade.\r\n  *   Sólidos conhecimentos em aplicações que atuam tanto como produtores quanto clientes de serviços RESTful\r\n  *   Familiaridade com NodeJS será um diferencial\r\n  *   Conhecimento de automação de testes: unitários, funcionais ou testes de integração\r\n  *   Experiência em controle de versionamento com Git (desejável)\r\n  *   Vivência com um ou mais métodos ágeis de desenvolvimento: XP (principalmente as práticas de pair programming e TDD), Scrum e Kanban\r\n  *   Inglês em nível avançado para leitura e escrita e intermediário para conversação\r\n\r\nPrincipais responsabilidades\r\n\r\n  *   Criar protótipos, executar testes, debugging, manutenção e updates nos sistemas da plataforma\r\n  *   Conceber, construir e entregar soluções enxutas, escaláveis, seguras e de fácil manutenção\r\n  *   Colaborar com outros engenheiros e gerentes de produto para impulsionar a evolução da plataforma de e-commerce do Walmart.com, criando aplicações que sigam as melhores práticas de desenvolvimento\r\n  *   Escrever e revisar documentação técnica, incluindo design/UX, desenvolvimento e código-fonte\r\n  *   Analisar, revisar e modificar software para aumentar a eficiência operacional de nossos sistemas\r\n\r\nEducação\r\n\r\n  *   Bacharelado em Ciência da Computação, Análise de Sistemas ou qualquer campo técnico relacionado (ou experiência prática equivalente)\r\n\r\nCompetências\r\n\r\n  *   Capacidade de criar soluções técnicas enxutas, inteligentes, seguras e escaláveis\r\n  *   Paixão por ouvir o cliente e trabalhar por sua satisfação\r\n  *   Paixão por inovação e espírito empreendedor\r\n  *   Perfil colaborativo, de escuta ativa, capaz de entender e traduzir casos de uso em software em produção\r\n  *   Auto-didatismo	47699	2016-06-27 17:04:10.703283	1	2832
6192	186	todas as consultorias	47699	2016-06-27 17:04:10.703897	1	2832
6193	188	Sal	47699	2016-06-27 17:04:10.704282	1	2832
6194	187	1	47699	2016-06-27 17:04:10.704685	1	2832
6195	11	Gustavo Vieira	47700	2016-06-27 17:04:31.033775	273	2833
6196	182	1	47700	2016-06-27 17:04:31.034633	273	2833
6197	2	 https://drive.google.com/a/avenuecode.com/file/d/0B-dYXZ2cOfG1NnpRbXBfTUxVQWs/view?usp=sharing	47700	2016-06-27 17:04:31.035058	273	2833
6198	166	Avenue Code	47700	2016-06-27 17:04:31.035515	273	2833
6199	12	1	47700	2016-06-27 17:04:31.035919	273	2833
6200	13	Full Stack	47703	2016-06-27 17:08:06.306577	1	2836
6201	174	O Walmart possui um site bastante conhecido pela sua rapidez, qualidade do design e experiência com o usuário. Para isso resolvemos propor que você crie parte dessa experiência como teste para a vaga de Full-Stack Developer. O fluxo e os requisitos a serem desenvolvidos estão descritos a seguir:\r\n\r\n\r\nPara desenvolver esse fluxo, algumas telas devem ser criadas:\r\n- Cadastro de Produto.\r\n- Listagem dos Produto (Carrinho).\r\n- Conclusão de Compra (Checkout).\r\nRequisitos mínimos para a aplicação:\r\n- Usuário pode criar mais de um produto com o Nome e Valor como requisitos mínimos.\r\n- Aplicação deve exibir todos os produtos cadastrados e permitir que o usuário altere a quantidade de cada produto que deseja comprar na tela de Carrinho.\r\n- A compra mínima (soma de todos os valores e quantidades do produtos) deve ser de 200 reais, impossibilitando a ida para a tela de Conclusão de Compra no caso de valores menores.\r\n- Caso a compra total for maior que 400 reais, deve ser aplicado alguns dos descontos:\r\n     - Se maior que 500 reais, desconto de 5% no valor total da compra.\r\n     - Se maior que 600 reais, desconto de 10% no valor total da compra.\r\n     - Se maior que 700 reais, desconto de 15% no valor total da compra.\r\n- Caso seja entre 200 e 400 reais, não aplicar nenhum desconto.\r\n- Após os cálculos, exibir na tela de Conclusão de Compra o valor final da compra e o desconto obtido.\r\nIremos analisar os seguintes detalhes:\r\nCapacidade de resolver o problema da forma mais simples, utilizando o mínimo de código possível.\r\nManipulação correta dos valores e cálculos de desconto.\r\nOrganização da regra de negócio de uma forma coesa para as duas seguintes partes do problema:\r\nCálculo do somatório de produtos.\r\nCálculo do valor de desconto.\r\nCapacidade de reprodução do layout, estilos e design sugerido nas telas do Carrinho e Checkout. \r\nCriação da tela de cadastro nos padrões das outras duas telas.\r\nDetalhes do projeto:\r\n- Todo o projeto deve ser submetido no github ou outro similar que use GIT.\r\n- Não se esqueça de justificar as suas escolhas (de tecnologia, layout, etc...) no arquivo README que deve acompanhar sua solução. Além de nos informar como proceder para testarmos sua aplicação.\r\n\r\nOutras informações:\r\n- Documentação e testes serão avaliados também.\r\n- A utilização de ferramentas de geração de CRUD e helpers serão analisadas com critérios.\r\n- Junto ao teste deve conter como guia duas ilustrações (design) das telas de Carrinho e Checkout que gostaríamos que se baseasse para desenvolver as telas da aplicação. Seguir o mais fiel possível.\r\n\r\n\r\n \r\nDesign das Telas\r\n \r\n \r\nTela de Carrinho de Compras\r\n\r\nTela de Conclusão de Compras\r\n\r\n 	47703	2016-06-27 17:08:06.307356	1	2836
6202	1	1) Título da Vaga\r\nDesenvolvedor\r\n\r\n2) Requisitos da Vaga\r\nRuby ; Rails ; Sidekiq ; HTML5 ; CSS ; Javascript ; SQL\r\nDiferenciais:   Chef ; Jenkins ; Vagrant ; Oracle ; SASS ; jQuery	47703	2016-06-27 17:08:06.307943	1	2836
6203	186	todas as consultorias	47703	2016-06-27 17:08:06.308324	1	2836
6204	188	Bauer	47703	2016-06-27 17:08:06.308736	1	2836
6205	187	6,7,8,9,10,11,12	47703	2016-06-27 17:08:06.30915	1	2836
6206	13	Full Stack	47704	2016-06-27 17:10:57.484745	1	2838
6207	174	 O Walmart possui um site bastante conhecido pela sua rapidez, qualidade do design e experiência com o usuário. Para isso resolvemos propor que você crie parte dessa experiência como teste para a vaga de Full-Stack Developer. O fluxo e os requisitos a serem desenvolvidos estão descritos a seguir:\r\n\r\n\r\nPara desenvolver esse fluxo, algumas telas devem ser criadas:\r\n- Cadastro de Produto.\r\n- Listagem dos Produto (Carrinho).\r\n- Conclusão de Compra (Checkout).\r\nRequisitos mínimos para a aplicação:\r\n- Usuário pode criar mais de um produto com o Nome e Valor como requisitos mínimos.\r\n- Aplicação deve exibir todos os produtos cadastrados e permitir que o usuário altere a quantidade de cada produto que deseja comprar na tela de Carrinho.\r\n- A compra mínima (soma de todos os valores e quantidades do produtos) deve ser de 200 reais, impossibilitando a ida para a tela de Conclusão de Compra no caso de valores menores.\r\n- Caso a compra total for maior que 400 reais, deve ser aplicado alguns dos descontos:\r\n     - Se maior que 500 reais, desconto de 5% no valor total da compra.\r\n     - Se maior que 600 reais, desconto de 10% no valor total da compra.\r\n     - Se maior que 700 reais, desconto de 15% no valor total da compra.\r\n- Caso seja entre 200 e 400 reais, não aplicar nenhum desconto.\r\n- Após os cálculos, exibir na tela de Conclusão de Compra o valor final da compra e o desconto obtido.\r\nIremos analisar os seguintes detalhes:\r\nCapacidade de resolver o problema da forma mais simples, utilizando o mínimo de código possível.\r\nManipulação correta dos valores e cálculos de desconto.\r\nOrganização da regra de negócio de uma forma coesa para as duas seguintes partes do problema:\r\nCálculo do somatório de produtos.\r\nCálculo do valor de desconto.\r\nCapacidade de reprodução do layout, estilos e design sugerido nas telas do Carrinho e Checkout. \r\nCriação da tela de cadastro nos padrões das outras duas telas.\r\nDetalhes do projeto:\r\n- Todo o projeto deve ser submetido no github ou outro similar que use GIT.\r\n- Não se esqueça de justificar as suas escolhas (de tecnologia, layout, etc...) no arquivo README que deve acompanhar sua solução. Além de nos informar como proceder para testarmos sua aplicação.\r\n\r\nOutras informações:\r\n- Documentação e testes serão avaliados também.\r\n- A utilização de ferramentas de geração de CRUD e helpers serão analisadas com critérios.\r\n- Junto ao teste deve conter como guia duas ilustrações (design) das telas de Carrinho e Checkout que gostaríamos que se baseasse para desenvolver as telas da aplicação. Seguir o mais fiel possível.\r\n\r\n\r\n \r\nDesign das Telas\r\n \r\n \r\nTela de Carrinho de Compras\r\n\r\nTela de Conclusão de Compras\r\n 	47704	2016-06-27 17:10:57.48555	1	2838
6208	1	1) Título da Vaga\r\nDesenvolvedor\r\n\r\n2) Requisitos da Vaga\r\nAngular ; Node.js ; Python ; Django ; HTML5 ; CSS3 ; Javascript ; APIs Rest ; SQL ; Processamento assíncrono de requisições \r\nDiferenciais:\r\nRabbit MQ ; Docker ; Jenkins ; EcmaScript6 ; Testes com mocha ; synon, should, etc. ; Promises (Q) ; Frameworks: Express e Loopback\r\n	47704	2016-06-27 17:10:57.486328	1	2838
6209	186	todas as consultorias	47704	2016-06-27 17:10:57.48673	1	2838
6210	188	Bauer	47704	2016-06-27 17:10:57.487108	1	2838
6211	187	4,5,13,14,15	47704	2016-06-27 17:10:57.487897	1	2838
6212	13	Scrum Master	47705	2016-06-27 17:12:43.471909	1	2840
6213	174	\r\nhttps://docs.google.com/forms/d/1i-0AJ39RsfB_R3ml1R5yCAvsBQNxlsPMV_owzlVXihg/viewform	47705	2016-06-27 17:12:43.472725	1	2840
6214	1	Atenção:\r\nPor favor, não considerar nenhuma das pessoas abaixo para esta posição:\r\n\r\nCarlos Eduardo Pires Uva\r\nHector Monteiro\r\nMikio Ishibashi\r\nJhonas Reis\r\nGeraldo Lima\r\nDaniel Damasceno\r\nKauê da Silva Coelho\r\nStephany Faria de Moraes\r\nAndré Pinho\r\nFelipe Pontes\r\nWanderlei Barroso\r\nMarcos Kitamura\r\nRafael Madureira\r\nThiago Medeiro\r\nAdriano Sarrascene\r\nRicardo Luiz\r\nCaio Maioral\r\nMelissa Itimura\r\nEduardo Freitas\r\nFernando Stoiano\r\nDaniel Vilasboas\r\nGustavo Scaramelli de Lima\r\nRogério Sampaio\r\nDouglas Melo\r\nDenise Silva\r\nErick Fabricio Cellani\r\nSacha Ferreira\r\nThiago Freitas\r\nFilipe Guedini\r\nRodrigo Audine\r\nDiego Cesar\r\nLuis Fernando Fogaça\r\nRodrigo Andrade\r\nRosângela Fragallo\r\nBruna Milare\r\nKarina Greco\r\n\r\n1) Título da Vaga\r\nScrum Master\r\n\r\n2) Requisitos da Vaga\r\nExperiência como Scrum Master de no mínimo 4 anos;\r\nExperiência em sistemas de missão crítica de alta disponibilidade;\r\nProfundo conhecimentos de Metodologias Ágeis - SCRUM;\r\n	47705	2016-06-27 17:12:43.473206	1	2840
6215	186	todas as consultorias	47705	2016-06-27 17:12:43.473574	1	2840
6216	188	Bruno	47705	2016-06-27 17:12:43.473925	1	2840
6217	187	16	47705	2016-06-27 17:12:43.474343	1	2840
6218	183	Descontinuidade da Vaga	47705	2016-06-27 17:12:56.86218	292	2842
6219	11	Bruno Rossetto	47706	2016-06-27 17:14:31.060535	273	2833
6220	182	1,2,3,4,9,10,11,12,15	47706	2016-06-27 17:14:31.061365	273	2833
6221	2	https://github.com/haptico/agenda.git	47706	2016-06-27 17:14:31.06182	273	2833
6222	166	indicacao	47706	2016-06-27 17:14:31.062239	273	2833
6223	12	1	47706	2016-06-27 17:14:31.062671	273	2833
6224	11	Victor Oliveira	47709	2016-06-27 17:18:59.640415	273	2833
6225	182	1	47709	2016-06-27 17:18:59.641178	273	2833
6226	2	https://github.com/victor-machado/Agenda.git https://github.com/victor-machado/agenda-services.git	47709	2016-06-27 17:18:59.641623	273	2833
6227	166	Verotthi	47709	2016-06-27 17:18:59.642056	273	2833
6228	12	1	47709	2016-06-27 17:18:59.64248	273	2833
6229	11	Felipe Novaes	47712	2016-06-27 17:21:09.478989	273	2833
6230	182	1,5	47712	2016-06-27 17:21:09.479857	273	2833
6231	2	https://bitbucket.org/kamikazebr/raabbit - Android app https://bitbucket.org/kamikazebr/raabbitserver - Nodejs server	47712	2016-06-27 17:21:09.480262	273	2833
6232	166	O2B	47712	2016-06-27 17:21:09.480679	273	2833
6233	12	1,5	47712	2016-06-27 17:21:09.481076	273	2833
6234	11	Diego Cezimbra	47715	2016-06-27 17:22:19.657741	273	2833
6235	182	1	47715	2016-06-27 17:22:19.658452	273	2833
6236	2	https://bitbucket.org/dicezimbra/projetodesafio-fcamara	47715	2016-06-27 17:22:19.65887	273	2833
6237	166	Fcamara	47715	2016-06-27 17:22:19.659284	273	2833
6238	12	1	47715	2016-06-27 17:22:19.659637	273	2833
6239	11	Luiz Junqueira	47718	2016-06-27 18:07:58.625107	273	2839
6240	182	2,4,6	47718	2016-06-27 18:07:58.678305	273	2839
6241	2	https://github.com/junqueira/shopapp e https://shopeng.herokuapp.com/	47718	2016-06-27 18:07:58.755818	273	2839
6242	166	mazza	47718	2016-06-27 18:07:58.778196	273	2839
6243	12	6	47718	2016-06-27 18:07:58.915935	273	2839
6244	11	George Freire	47721	2016-06-27 18:08:50.344689	273	2833
6245	182	1	47721	2016-06-27 18:08:50.345544	273	2833
6246	2	https://github.com/GeorgeSouzaFreire/AgendaCompromisso	47721	2016-06-27 18:08:50.345945	273	2833
6247	166	O2b	47721	2016-06-27 18:08:50.346362	273	2833
6248	12	1	47721	2016-06-27 18:08:50.346745	273	2833
6249	11	Felipe Almeida	47724	2016-06-27 18:10:43.845625	273	2839
6250	182	3,4,11,14	47724	2016-06-27 18:10:43.846177	273	2839
6251	2	 https://github.com/frontfelipe/walmart-cart-teste	47724	2016-06-27 18:10:43.846551	273	2839
6252	166	mazza	47724	2016-06-27 18:10:43.846954	273	2839
6253	12	4	47724	2016-06-27 18:10:43.847356	273	2839
6254	4	Bom Jr	47707	2016-06-27 18:40:16.731898	274	2843
6255	10	Classes geradas automaticamente / Código duplicado / Falta de estrutura definida / ListView / Design bem feito / Serviço rodando externo 	47707	2016-06-27 18:40:16.73297	274	2843
6256	180	Bom Jr	47708	2016-06-27 18:40:28.200657	288	2844
6257	181	Classes geradas automaticamente / Código duplicado / Falta de estrutura definida / ListView / Design bem feito / Serviço rodando externo 	47708	2016-06-27 18:40:28.201729	288	2844
6258	4	Jr	47710	2016-06-27 18:42:37.436613	274	2845
6259	10	Me parece um bom programador, mas sem muito conhecimento de específico de android.	47710	2016-06-27 18:42:37.437624	274	2845
6260	180	Jr	47711	2016-06-27 18:42:50.779895	288	2846
6261	181	Me parece um bom programador, mas sem muito conhecimento de específico de android.	47711	2016-06-27 18:42:50.780824	288	2846
6262	11	Deiwson Pinheiro dos Santos	47727	2016-06-27 18:45:35.552928	273	2833
6263	182	1,2	47727	2016-06-27 18:45:35.553716	273	2833
6264	2	Links do teste: ü  https://1drv.ms/u/s!AjrLj_yqmHgWiGduErvErzeFK7RA ü  link download  arquivo ü  https://koreaBit@bitbucket.org/tiware/testewalmart.git ü  https://koreaBit@bitbucket.org/nbportalweb/walmartserver.git	47727	2016-06-27 18:45:35.554139	273	2833
6265	166	mazza	47727	2016-06-27 18:45:35.554559	273	2833
6266	12	1	47727	2016-06-27 18:45:35.554997	273	2833
6267	11	Alex Zacarias Soares	47730	2016-06-27 18:46:15.607227	273	2833
6268	182	1,2,3	47730	2016-06-27 18:46:15.608043	273	2833
6269	2	 ü  https://bitbucket.org/asoares99/agendacompromissowalmart	47730	2016-06-27 18:46:15.608434	273	2833
6270	166	mazza	47730	2016-06-27 18:46:15.608791	273	2833
6271	12	1	47730	2016-06-27 18:46:15.609179	273	2833
6272	11	José Cavalcanti	47733	2016-06-27 18:48:31.003879	273	2833
6273	182	1	47733	2016-06-27 18:48:31.004715	273	2833
6274	2	 git@github.com:moraisholanda/heroes.git 	47733	2016-06-27 18:48:31.005133	273	2833
6275	166	ginga	47733	2016-06-27 18:48:31.005537	273	2833
6276	12	1	47733	2016-06-27 18:48:31.005939	273	2833
6278	10	Gostei	47734	2016-06-27 19:24:35.25675	274	2863
6280	181	Gostei	47735	2016-06-27 19:25:08.854278	288	2864
6282	10	Código melhor organizado / Algumas coisas antigas que podem melhorar / Porém ainda não consegui rodar o serviço 	47731	2016-06-27 19:25:45.121836	274	2861
6284	181	Código melhor organizado / Algumas coisas antigas que podem melhorar / Porém ainda não consegui rodar o serviço 	47732	2016-06-27 19:26:01.506197	288	2862
6285	4	reprovado	47728	2016-06-27 19:26:26.007933	274	2859
6286	10	Login esta mockado / Código sem estrutura definida / Layout confuso e mal feito / Botões que não funcionam	47728	2016-06-27 19:26:26.008757	274	2859
6287	180	reprovado	47729	2016-06-27 19:26:35.992478	288	2860
6288	181	Login esta mockado / Código sem estrutura definida / Layout confuso e mal feito / Botões que não funcionam	47729	2016-06-27 19:26:35.993338	288	2860
6289	172	Candidato Reprovado porque seu teste nem ao mesmo rodava.	47727	2016-06-27 19:37:21.442636	286	2868
6277	4	Pleno	47734	2016-06-27 19:24:35.255696	274	2863
6279	180	Pleno	47735	2016-06-27 19:25:08.853357	288	2864
6281	4	Pleno	47731	2016-06-27 19:25:45.120997	274	2861
6283	180	Pleno	47732	2016-06-27 19:26:01.505223	288	2862
6290	5	Bruno	47706	2016-06-27 20:08:14.902956	275	2869
6291	4	criado errado	47722	2016-06-27 20:29:14.484261	274	2853
6292	10	criado errado	47722	2016-06-27 20:29:14.485199	274	2853
6293	180	criado errado	47723	2016-06-27 20:29:21.991083	288	2854
6294	181	criado errado	47723	2016-06-27 20:29:21.992046	288	2854
6295	172	foi criado errado - desconsiderar	47721	2016-06-27 20:29:38.456749	286	2871
6296	11	George Luiz de Souza Freire	47736	2016-06-27 20:30:57.78229	273	2833
6297	182	1	47736	2016-06-27 20:30:57.783069	273	2833
6298	2	https://github.com/GeorgeSouzaFreire/AgendaCompromisso	47736	2016-06-27 20:30:57.783482	273	2833
6299	166	O2B	47736	2016-06-27 20:30:57.783891	273	2833
6300	12	1	47736	2016-06-27 20:30:57.784276	273	2833
6301	11	Juliano Versolato	47739	2016-06-27 20:34:37.578322	273	2833
6302	182	1	47739	2016-06-27 20:34:37.57909	273	2833
6303	2	https://github.com/jversolato/Compromissos	47739	2016-06-27 20:34:37.57948	273	2833
6304	166	mazza	47739	2016-06-27 20:34:37.579894	273	2833
6305	12	1	47739	2016-06-27 20:34:37.580265	273	2833
6306	13	Magento (PHP)	47742	2016-06-27 20:43:34.086668	1	2876
6307	174	Nenhum teste específico	47742	2016-06-27 20:43:34.087468	1	2876
6308	1	N/A	47742	2016-06-27 20:43:34.087872	1	2876
6309	186	fcamara	47742	2016-06-27 20:43:34.088265	1	2876
6310	188	Doro	47742	2016-06-27 20:43:34.088687	1	2876
6311	187	3,20	47742	2016-06-27 20:43:34.08905	1	2876
6312	11	Julio Reis	47743	2016-06-27 20:45:52.474223	273	2877
6313	182	1,2,3,20	47743	2016-06-27 20:45:52.474993	273	2877
6314	2	não aplica	47743	2016-06-27 20:45:52.475389	273	2877
6315	166	Fcamara	47743	2016-06-27 20:45:52.475762	273	2877
6316	12	3,20	47743	2016-06-27 20:45:52.47618	273	2877
6317	13	Backend Java	47746	2016-06-27 21:05:04.974158	1	2880
6318	174	Entregando mercadorias\r\nO Walmart está desenvolvendo um novo sistema de logística e sua ajuda é muito importante neste momento. Sua tarefa será desenvolver o novo sistema de entregas visando sempre o menor custo. Para popular sua base de dados o sistema precisa expor um Webservices que aceite o formato de malha logística (exemplo abaixo), nesta mesma requisição o requisitante deverá informar um nome para este mapa. É importante que os mapas sejam persistidos para evitar que a cada novo deploy todas as informações desapareçam. O formato de malha logística é bastante simples, cada linha mostra uma rota: ponto de origem, ponto de destino e distância entre os pontos em quilômetros, separados por espaços:\r\nFormato de Malha Logística\r\nA B 10\r\nB D 15\r\nA C 20\r\nC D 30\r\nB E 50\r\nD E 30\r\n \r\nCom os mapas carregados o requisitante irá procurar o menor valor de entrega e seu caminho, para isso ele passará o mapa, nome do ponto de origem, nome do ponto de destino, autonomia do caminhão (km/l) e o valor do litro do combustivel, agora sua tarefa é criar este Webservices. Um exemplo de entrada seria, mapa SP, origem A, destino D, autonomia 10, valor do litro 2,50; a resposta seria a rota A B D com custo de 6,25.\r\nConsiderações\r\nVoce está livre para definir a melhor arquitetura e tecnologias para solucionar este desafio, mas não se esqueça de contar sua motivação no arquivo README que deve acompanhar sua solução, junto com os detalhes de como executar seu programa. Documentação e testes serão avaliados também =) Lembre-se de que iremos executar seu código com malhas bem mais complexas que o exemplo acima, por isso é importante pensar em requisitos não funcionais também!\r\n\r\nTambém gostaríamos de acompanhar o desenvolvimento da sua aplicação através do código fonte. Por isso, solicitamos a criação de um repositório que seja compartilhado com a gente. Para o desenvolvimento desse sistema, nós solicitamos que você utilize a sua (ou as suas) linguagem de programação principal. Pode ser Java, JavaScript ou Ruby.\r\n\r\nNós solicitamos que você trabalhe no desenvolvimento desse sistema sozinho e não divulgue a solução desse problema pela internet. O prazo máximo para entrega é dia de 5 dias.\r\n\r\nBom desafio!	47746	2016-06-27 21:05:04.97488	1	2880
6319	1	Conceitos sólidos sobre orientação a objeto, tdd, bdd, com diferencial para event sourcing e cqrs	47746	2016-06-27 21:05:04.975449	1	2880
6320	186	todas as consultorias	47746	2016-06-27 21:05:04.975868	1	2880
6321	188	Bruno	47746	2016-06-27 21:05:04.976281	1	2880
6322	187	2,6,21,22	47746	2016-06-27 21:05:04.976657	1	2880
6323	183	finalizando para cadastrar de novo	47746	2016-06-27 21:07:43.073771	292	2882
6324	13	Backend Java	47747	2016-06-27 21:09:08.037414	1	2883
6325	174	Entregando mercadorias\r\nO Walmart está desenvolvendo um novo sistema de logística e sua ajuda é muito importante neste momento. Sua tarefa será desenvolver o novo sistema de entregas visando sempre o menor custo. Para popular sua base de dados o sistema precisa expor um Webservices que aceite o formato de malha logística (exemplo abaixo), nesta mesma requisição o requisitante deverá informar um nome para este mapa. É importante que os mapas sejam persistidos para evitar que a cada novo deploy todas as informações desapareçam. O formato de malha logística é bastante simples, cada linha mostra uma rota: ponto de origem, ponto de destino e distância entre os pontos em quilômetros, separados por espaços:\r\nFormato de Malha Logística\r\nA B 10\r\nB D 15\r\nA C 20\r\nC D 30\r\nB E 50\r\nD E 30\r\n \r\nCom os mapas carregados o requisitante irá procurar o menor valor de entrega e seu caminho, para isso ele passará o mapa, nome do ponto de origem, nome do ponto de destino, autonomia do caminhão (km/l) e o valor do litro do combustivel, agora sua tarefa é criar este Webservices. Um exemplo de entrada seria, mapa SP, origem A, destino D, autonomia 10, valor do litro 2,50; a resposta seria a rota A B D com custo de 6,25.\r\nConsiderações\r\nVoce está livre para definir a melhor arquitetura e tecnologias para solucionar este desafio, mas não se esqueça de contar sua motivação no arquivo README que deve acompanhar sua solução, junto com os detalhes de como executar seu programa. Documentação e testes serão avaliados também =) Lembre-se de que iremos executar seu código com malhas bem mais complexas que o exemplo acima, por isso é importante pensar em requisitos não funcionais também!\r\n\r\nTambém gostaríamos de acompanhar o desenvolvimento da sua aplicação através do código fonte. Por isso, solicitamos a criação de um repositório que seja compartilhado com a gente. Para o desenvolvimento desse sistema, nós solicitamos que você utilize a sua (ou as suas) linguagem de programação principal. Pode ser Java, JavaScript ou Ruby.\r\n\r\nNós solicitamos que você trabalhe no desenvolvimento desse sistema sozinho e não divulgue a solução desse problema pela internet. O prazo máximo para entrega é dia de 5 dias.\r\n\r\nBom desafio!	47747	2016-06-27 21:09:08.038216	1	2883
6326	1	\r\nConceitos sólidos sobre orientação a objeto, tdd, bdd, com diferencial para event sourcing e cqrs\r\n\r\nNo geral, java, ruby básico, rabbit mq, hazelcast. conhecimentos em google guice, apache camel são diferenciais	47747	2016-06-27 21:09:08.038818	1	2883
6327	186	todas as consultorias	47747	2016-06-27 21:09:08.039208	1	2883
6328	188	Bruno	47747	2016-06-27 21:09:08.039594	1	2883
6329	187	2,6,21,22	47747	2016-06-27 21:09:08.040008	1	2883
6330	189	Payments	47747	2016-06-27 21:09:08.040411	1	2883
6331	183	finalizando para criar de novo	47747	2016-06-27 21:09:37.771591	292	2885
6332	13	Backend Java	5	2016-06-27 21:13:14.509645	1	2886
6333	174	Entregando mercadorias\r\nO Walmart está desenvolvendo um novo sistema de logística e sua ajuda é muito importante neste momento. Sua tarefa será desenvolver o novo sistema de entregas visando sempre o menor custo. Para popular sua base de dados o sistema precisa expor um Webservices que aceite o formato de malha logística (exemplo abaixo), nesta mesma requisição o requisitante deverá informar um nome para este mapa. É importante que os mapas sejam persistidos para evitar que a cada novo deploy todas as informações desapareçam. O formato de malha logística é bastante simples, cada linha mostra uma rota: ponto de origem, ponto de destino e distância entre os pontos em quilômetros, separados por espaços:\r\nFormato de Malha Logística\r\nA B 10\r\nB D 15\r\nA C 20\r\nC D 30\r\nB E 50\r\nD E 30\r\n \r\nCom os mapas carregados o requisitante irá procurar o menor valor de entrega e seu caminho, para isso ele passará o mapa, nome do ponto de origem, nome do ponto de destino, autonomia do caminhão (km/l) e o valor do litro do combustivel, agora sua tarefa é criar este Webservices. Um exemplo de entrada seria, mapa SP, origem A, destino D, autonomia 10, valor do litro 2,50; a resposta seria a rota A B D com custo de 6,25.\r\nConsiderações\r\nVoce está livre para definir a melhor arquitetura e tecnologias para solucionar este desafio, mas não se esqueça de contar sua motivação no arquivo README que deve acompanhar sua solução, junto com os detalhes de como executar seu programa. Documentação e testes serão avaliados também =) Lembre-se de que iremos executar seu código com malhas bem mais complexas que o exemplo acima, por isso é importante pensar em requisitos não funcionais também!\r\n\r\nTambém gostaríamos de acompanhar o desenvolvimento da sua aplicação através do código fonte. Por isso, solicitamos a criação de um repositório que seja compartilhado com a gente. Para o desenvolvimento desse sistema, nós solicitamos que você utilize a sua (ou as suas) linguagem de programação principal. Pode ser Java, JavaScript ou Ruby.\r\n\r\nNós solicitamos que você trabalhe no desenvolvimento desse sistema sozinho e não divulgue a solução desse problema pela internet. O prazo máximo para entrega é dia de 5 dias.\r\n\r\nBom desafio!	5	2016-06-27 21:13:14.51043	1	2886
6334	1	No geral, java, ruby básico, rabbit mq, hazelcast. conhecimentos em google guice, apache camel são diferenciais\r\n\r\nConceitos sólidos sobre orientação a objeto, tdd, bdd, com diferencial para event sourcing e cqrs	5	2016-06-27 21:13:14.51108	1	2886
6335	186	todas as consultorias	5	2016-06-27 21:13:14.511491	1	2886
6336	188	Bruno	5	2016-06-27 21:13:14.511835	1	2886
6337	187	2,6	5	2016-06-27 21:13:14.512243	1	2886
6338	189	Payments	5	2016-06-27 21:13:14.512603	1	2886
6339	13	Frontend	6	2016-06-28 00:05:36.325986	1	2888
6340	174	Pedidos do cliente\r\nVocê deve criar um projeto que deverá conter três páginas: uma página com listagem de pedidos do cliente (por exemplo: TV, Celular, etc...), que deverá conter o nome, descrição e imagem; outra página que deverá conter a listagem de endereços de entrega; e, por último, uma página que contenha o perfil do cliente.\r\nConsiderações\r\nVocê está livre para criar a melhor arquitetura para esse projeto. É possível utilizar ferramentas como o Grunt.js, Sass, LESS, AngularJS, Backbone.js, mas lembre-se de justificar o uso das tecnologias empregadas no arquivo README.md, que deve acompanhar sua aplicação.\r\nNós solicitamos que você trabalhe no desenvolvimento desse sistema sozinho e não divulgue a solução desse problema pela internet. Por isso, solicitamos a criação de um repositório que seja compartilhado com a gente. \r\nDocumentação, testes e criatividade serão avaliados e o prazo máximo de entrega é de uma semana.\r\nQualquer dúvida entre em contato.\r\n\r\nDivirta-se e boa sorte!\r\n	6	2016-06-28 00:05:36.326885	1	2888
6341	1	Conhecimento de desenvolvimento frontend	6	2016-06-28 00:05:36.327866	1	2888
6342	186	avulso	6	2016-06-28 00:05:36.328537	1	2888
6343	188	geral	6	2016-06-28 00:05:36.329121	1	2888
6344	187	5,6,7,9,10,11,13	6	2016-06-28 00:05:36.329723	1	2888
6345	189	geral	6	2016-06-28 00:05:36.330239	1	2888
6346	184	Alcides Queiroz <alcidesqueiroz@gmail.com>	7	2016-06-28 00:06:02.478603	294	2890
6347	6	O time entende que teria que dedicar mais tempo para equalizar o conhecimento técnico,  uma vez que ele não tem muita vivência com linguagens orientada objeto e design patterns. Gostaríamos de avaliar outros candidatos, para ver se é melhor dedicar esse tempo com as questões técnicas  ou com outros pontos de outros candidatos.	47706	2016-06-28 15:51:15.846768	276	2891
6348	11	Lucas Caramelo	8	2016-06-28 20:04:35.846321	273	2833
6349	182	1	8	2016-06-28 20:04:35.847519	273	2833
6350	2	https://github.com/caramelool/SpiderMan	8	2016-06-28 20:04:35.847965	273	2833
6351	166	ginga	8	2016-06-28 20:04:35.848363	273	2833
6352	12	1	8	2016-06-28 20:04:35.848841	273	2833
6353	180	Sênior	47745	2016-06-29 20:08:07.279214	288	2879
6354	181	\r\nLevei em conta a documentação, estrutura do projeto, organização do código e approach utilizados para localizar a melhor rota. \r\nNa minha visão o candidato está de Pleno para Sênior. Mais para Sênior do que Pleno.	47745	2016-06-29 20:08:07.320197	288	2879
6355	4	-	47744	2016-06-29 20:10:52.087608	274	2878
6356	10	Pela análise do código não vejo nenhum grande problema neste desenvolvedor.\r\nO que eu reparei é que ele poderia ter feito testes unitários e passado o analisador de códigos do PHP, o PHPCS, com isso ele teria um código melhor, mas tirando isso, acredito que ele se encaixa na vaga da forma como foi proposto.	47744	2016-06-29 20:10:52.088506	274	2878
6357	4	pleno	9	2016-06-29 23:25:41.277946	274	2892
6358	10	Gostei	9	2016-06-29 23:25:41.279279	274	2892
6359	4	Jr	47737	2016-06-29 23:26:16.350063	274	2872
6360	10	Código sem estrutura definida, Async Task para conexões, código em português, código repetido, agenda do usuário pode ser acessado por qualquer usuário.  (Reprovado)	47737	2016-06-29 23:26:16.351185	274	2872
6361	4	Junior	47716	2016-06-29 23:26:40.476674	274	2849
6362	10	Não consegui rodar o backend. Avaliando apenas o código: Classes criadas por outra pessoa, código sem estrutura definida, métodos com muitas funções, conexão feita com uma classe de terceiro cheia de código sem antigo e sem ser utilizado, Async Task.  (reprovado)	47716	2016-06-29 23:26:40.477933	274	2849
6363	4	Jr para Pleno	47713	2016-06-29 23:27:17.641603	274	2847
6364	10	Não consegui rodar o backend. Avaliando apenas o código:  Código sem estrutura, métodos gigantes que tratam de tudo, de resto parece ok, porém conversei com um pessoal da ginga que já trabalhou com ele, ele foi demitido por alguma doidera, mas ninguém se lembra qual foi.	47713	2016-06-29 23:27:17.642703	274	2847
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 6364, true);


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
2832	47699	1	2016-06-27 17:04:10.625617	2016-06-27 17:04:10.625617	\N
2833	47699	2	2016-06-27 17:04:10.667499	\N	\N
2856	47726	287	2016-06-27 18:10:43.897837	\N	16
2852	47720	287	2016-06-27 18:07:59.316955	\N	16
2836	47703	1	2016-06-27 17:08:06.227947	2016-06-27 17:08:06.227947	\N
2837	47703	2	2016-06-27 17:08:06.271266	\N	\N
2838	47704	1	2016-06-27 17:10:57.404213	2016-06-27 17:10:57.404213	\N
2839	47704	2	2016-06-27 17:10:57.450557	\N	\N
2840	47705	1	2016-06-27 17:12:43.394476	2016-06-27 17:12:43.394476	\N
2842	47705	293	2016-06-27 17:12:56.820129	\N	\N
2841	47705	2	2016-06-27 17:12:43.438093	2016-06-27 17:12:56.857892	\N
2855	47725	3	2016-06-27 18:10:43.848603	\N	15
2851	47719	3	2016-06-27 18:07:59.069978	\N	15
2891	47706	6	2016-06-28 15:51:15.802712	\N	\N
2869	47706	5	2016-06-27 20:08:14.85715	2016-06-28 15:51:15.840903	\N
2893	10	287	2016-06-28 20:04:35.899005	\N	14
2843	47707	3	2016-06-27 17:14:31.064021	2016-06-27 18:40:16.733914	3
2844	47708	287	2016-06-27 17:14:31.114387	2016-06-27 18:40:28.202468	7
2845	47710	3	2016-06-27 17:18:59.64379	2016-06-27 18:42:37.438518	3
2846	47711	287	2016-06-27 17:18:59.692146	2016-06-27 18:42:50.781773	7
2858	47709	4	2016-06-27 18:42:50.792781	\N	\N
2879	47745	287	2016-06-27 20:45:52.536906	2016-06-29 20:08:07.337296	21
2878	47744	3	2016-06-27 20:45:52.477445	2016-06-29 20:10:52.089313	24
2894	47743	4	2016-06-29 20:10:52.100162	\N	\N
2892	9	3	2016-06-28 20:04:35.85023	2016-06-29 23:25:41.280065	14
2863	47734	3	2016-06-27 18:48:31.007303	2016-06-27 19:24:35.257632	7
2864	47735	287	2016-06-27 18:48:31.055672	2016-06-27 19:25:08.855241	7
2865	47733	4	2016-06-27 19:25:08.866083	\N	\N
2861	47731	3	2016-06-27 18:46:15.610383	2016-06-27 19:25:45.122762	3
2862	47732	287	2016-06-27 18:46:15.656993	2016-06-27 19:26:01.506638	3
2866	47730	4	2016-06-27 19:26:01.518063	\N	\N
2859	47728	3	2016-06-27 18:45:35.556249	2016-06-27 19:26:26.009664	7
2860	47729	287	2016-06-27 18:45:35.6028	2016-06-27 19:26:35.994319	7
2868	47727	280	2016-06-27 19:37:21.398845	\N	\N
2867	47727	4	2016-06-27 19:26:36.005355	2016-06-27 19:37:21.437258	\N
2857	47706	4	2016-06-27 18:40:28.214086	2016-06-27 20:08:14.897244	\N
2853	47722	3	2016-06-27 18:08:50.348014	2016-06-27 20:29:14.485916	3
2854	47723	287	2016-06-27 18:08:50.398164	2016-06-27 20:29:21.992924	7
2871	47721	280	2016-06-27 20:29:38.41297	\N	\N
2870	47721	4	2016-06-27 20:29:22.003998	2016-06-27 20:29:38.451114	\N
2872	47737	3	2016-06-27 20:30:57.785617	2016-06-29 23:26:16.352084	14
2849	47716	3	2016-06-27 17:22:19.66128	2016-06-29 23:26:40.478824	14
2847	47713	3	2016-06-27 17:21:09.482483	2016-06-29 23:27:17.643692	14
2876	47742	1	2016-06-27 20:43:34.007037	2016-06-27 20:43:34.007037	\N
2877	47742	2	2016-06-27 20:43:34.05267	\N	\N
2880	47746	1	2016-06-27 21:05:04.8961	2016-06-27 21:05:04.8961	\N
2882	47746	293	2016-06-27 21:07:43.013733	\N	\N
2881	47746	2	2016-06-27 21:05:04.940667	2016-06-27 21:07:43.068891	\N
2883	47747	1	2016-06-27 21:09:07.957934	2016-06-27 21:09:07.957934	\N
2885	47747	293	2016-06-27 21:09:37.727512	\N	\N
2884	47747	2	2016-06-27 21:09:08.003066	2016-06-27 21:09:37.766482	\N
2886	5	1	2016-06-27 21:13:14.429259	2016-06-27 21:13:14.429259	\N
2887	5	2	2016-06-27 21:13:14.47444	\N	\N
2888	6	1	2016-06-28 00:05:36.210686	2016-06-28 00:05:36.210686	\N
2889	6	2	2016-06-28 00:05:36.274001	\N	\N
2890	7	295	2016-06-28 00:06:02.440543	\N	\N
2874	47740	3	2016-06-27 20:34:37.58152	\N	14
2834	47701	3	2016-06-27 17:04:31.037476	\N	14
2875	47741	287	2016-06-27 20:34:37.633961	\N	14
2873	47738	287	2016-06-27 20:30:57.834924	\N	14
2850	47717	287	2016-06-27 17:22:19.727394	\N	14
2848	47714	287	2016-06-27 17:21:09.538857	\N	14
2835	47702	287	2016-06-27 17:04:31.087461	\N	14
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 2894, true);


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

