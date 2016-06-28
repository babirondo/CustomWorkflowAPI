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
\.


--
-- Name: tecnologias_id_seq; Type: SEQUENCE SET; Schema: configuracoes; Owner: postgres
--

SELECT pg_catalog.setval('tecnologias_id_seq', 19, true);


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
\.


--
-- Name: postos_campo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_id_seq', 188, true);


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
\.


--
-- Name: postos_campo_lista_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_lista_id_seq', 85, true);


--
-- Data for Name: processos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY processos (id, idpai, idtipoprocesso, inicio, idworkflow, status, regra_finalizacao) FROM stdin;
47699	\N	1	2016-06-27 17:04:10.624185	1	Em Andamento	\N
47700	47699	2	2016-06-27 17:04:31.032956	1	\N	\N
47701	47700	3	2016-06-27 17:04:31.036561	1	Em Andamento	\N
47702	47700	3	2016-06-27 17:04:31.086701	1	Em Andamento	\N
47703	\N	1	2016-06-27 17:08:06.22667	1	Em Andamento	\N
47704	\N	1	2016-06-27 17:10:57.402566	1	Em Andamento	\N
47705	\N	1	2016-06-27 17:12:43.393303	1	Em Andamento	\N
47706	47699	2	2016-06-27 17:14:31.059742	1	\N	\N
47707	47706	3	2016-06-27 17:14:31.063313	1	Em Andamento	\N
47708	47706	3	2016-06-27 17:14:31.113486	1	Em Andamento	\N
47709	47699	2	2016-06-27 17:18:59.639364	1	\N	\N
47710	47709	3	2016-06-27 17:18:59.643099	1	Em Andamento	\N
47711	47709	3	2016-06-27 17:18:59.691502	1	Em Andamento	\N
47713	47712	3	2016-06-27 17:21:09.48169	1	Em Andamento	\N
47714	47712	3	2016-06-27 17:21:09.538136	1	Em Andamento	\N
47715	47699	2	2016-06-27 17:22:19.656892	1	\N	\N
47716	47715	3	2016-06-27 17:22:19.660522	1	Em Andamento	\N
47717	47715	3	2016-06-27 17:22:19.726673	1	Em Andamento	\N
47718	47704	2	2016-06-27 18:07:58.489949	1	\N	\N
47719	47718	3	2016-06-27 18:07:59.000783	1	Em Andamento	\N
47720	47718	3	2016-06-27 18:07:59.255415	1	Em Andamento	\N
47721	47699	2	2016-06-27 18:08:50.343885	1	\N	\N
47722	47721	3	2016-06-27 18:08:50.347338	1	Em Andamento	\N
47723	47721	3	2016-06-27 18:08:50.397383	1	Em Andamento	\N
47724	47704	2	2016-06-27 18:10:43.844855	1	\N	\N
47725	47724	3	2016-06-27 18:10:43.847926	1	Em Andamento	\N
47726	47724	3	2016-06-27 18:10:43.897212	1	Em Andamento	\N
47712	47699	2	2016-06-27 17:21:09.478192	1	Em Andamento	\N
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 47726, true);


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
30351	42	2016-06-27 18:21:07.007384	2853
30352	42	2016-06-27 18:21:07.013823	2849
30353	42	2016-06-27 18:21:07.019947	2834
30354	42	2016-06-27 18:21:07.026263	2845
30355	42	2016-06-27 18:21:07.032264	2855
30356	42	2016-06-27 18:21:07.038827	2847
30357	42	2016-06-27 18:21:07.04493	2843
30358	42	2016-06-27 18:21:07.051123	2851
30359	43	2016-06-27 18:21:07.057296	2848
30360	43	2016-06-27 18:21:07.06311	2835
30361	43	2016-06-27 18:21:07.069253	2844
30362	43	2016-06-27 18:21:07.075539	2846
30363	43	2016-06-27 18:21:07.081691	2852
30364	43	2016-06-27 18:21:07.087961	2856
30365	43	2016-06-27 18:21:07.094023	2854
30366	43	2016-06-27 18:21:07.099785	2850
30367	48	2016-06-27 18:21:07.108443	2849
30368	48	2016-06-27 18:21:07.114602	2851
30369	48	2016-06-27 18:21:07.12131	2834
30370	48	2016-06-27 18:21:07.127966	2847
30371	48	2016-06-27 18:21:07.134723	2843
30372	48	2016-06-27 18:21:07.141063	2845
30373	47	2016-06-27 18:21:07.14773	2849
30374	47	2016-06-27 18:21:07.153668	2851
30375	47	2016-06-27 18:21:07.159642	2853
30376	47	2016-06-27 18:21:07.165702	2834
30377	47	2016-06-27 18:21:07.172351	2847
30378	47	2016-06-27 18:21:07.178617	2843
30379	47	2016-06-27 18:21:07.185013	2845
30380	42	2016-06-27 19:39:57.576206	2853
30381	42	2016-06-27 19:39:57.704407	2849
30382	42	2016-06-27 19:39:57.730359	2834
30383	42	2016-06-27 19:39:57.768357	2845
30384	42	2016-06-27 19:39:57.777745	2855
30385	42	2016-06-27 19:39:57.787075	2847
30386	42	2016-06-27 19:39:57.795654	2843
30387	42	2016-06-27 19:39:57.804831	2851
30388	43	2016-06-27 19:39:57.812779	2848
30389	43	2016-06-27 19:39:57.827609	2835
30390	43	2016-06-27 19:39:57.836265	2844
30391	43	2016-06-27 19:39:57.843348	2846
30392	43	2016-06-27 19:39:57.852488	2852
30393	43	2016-06-27 19:39:57.861421	2856
30394	43	2016-06-27 19:39:57.875307	2854
30395	43	2016-06-27 19:39:57.884913	2850
30396	48	2016-06-27 19:39:57.896041	2849
30397	48	2016-06-27 19:39:57.905937	2851
30398	48	2016-06-27 19:39:57.950147	2853
30399	48	2016-06-27 19:39:57.957902	2834
30400	48	2016-06-27 19:39:57.980581	2847
30401	48	2016-06-27 19:39:58.005433	2843
30402	48	2016-06-27 19:39:58.035697	2845
30403	47	2016-06-27 19:39:58.043287	2849
30404	47	2016-06-27 19:39:58.052848	2851
30405	47	2016-06-27 19:39:58.09344	2853
30406	47	2016-06-27 19:39:58.100701	2834
30407	47	2016-06-27 19:39:58.130285	2847
30408	47	2016-06-27 19:39:58.168934	2843
30409	47	2016-06-27 19:39:58.191789	2845
30410	47	2016-06-27 19:39:58.210603	2855
30411	40	2016-06-27 19:40:25.853715	47712
30412	41	2016-06-27 19:54:57.040478	2857
30413	42	2016-06-27 19:54:57.048606	2853
30414	42	2016-06-27 19:54:57.055091	2849
30415	42	2016-06-27 19:54:57.062732	2834
30416	42	2016-06-27 19:54:57.068778	2845
30417	42	2016-06-27 19:54:57.075354	2855
30418	42	2016-06-27 19:54:57.081478	2851
30419	42	2016-06-27 19:54:57.087574	2843
30420	43	2016-06-27 19:54:57.094258	2835
30421	43	2016-06-27 19:54:57.100731	2844
30422	43	2016-06-27 19:54:57.107295	2846
30423	43	2016-06-27 19:54:57.114141	2852
30424	43	2016-06-27 19:54:57.120389	2856
30425	43	2016-06-27 19:54:57.128017	2854
30426	43	2016-06-27 19:54:57.134313	2850
30427	40	2016-06-27 19:54:57.141529	47712
30428	49	2016-06-27 19:54:57.14856	47712
30429	48	2016-06-27 19:54:57.155653	2849
30430	48	2016-06-27 19:54:57.162029	2851
30431	48	2016-06-27 19:54:57.168413	2853
30432	48	2016-06-27 19:54:57.175035	2834
30433	48	2016-06-27 19:54:57.181319	2847
30434	48	2016-06-27 19:54:57.188558	2843
30435	48	2016-06-27 19:54:57.19542	2845
30436	48	2016-06-27 19:54:57.202796	2855
30437	47	2016-06-27 19:54:57.211036	2849
30438	47	2016-06-27 19:54:57.218148	2851
30439	47	2016-06-27 19:54:57.224515	2853
30440	47	2016-06-27 19:54:57.231651	2834
30441	47	2016-06-27 19:54:57.23847	2847
30442	47	2016-06-27 19:54:57.245188	2843
30443	47	2016-06-27 19:54:57.251973	2845
30444	47	2016-06-27 19:54:57.258392	2855
30445	41	2016-06-27 19:56:17.42534	2857
30446	42	2016-06-27 19:56:17.434587	2853
30447	42	2016-06-27 19:56:17.441373	2849
30448	42	2016-06-27 19:56:17.447862	2834
30449	42	2016-06-27 19:56:17.454285	2845
30450	42	2016-06-27 19:56:17.461112	2855
30451	42	2016-06-27 19:56:17.467161	2851
30452	42	2016-06-27 19:56:17.474312	2843
30453	43	2016-06-27 19:56:17.48085	2835
30454	43	2016-06-27 19:56:17.487174	2844
30455	43	2016-06-27 19:56:17.493849	2846
30456	43	2016-06-27 19:56:17.500443	2852
30457	43	2016-06-27 19:56:17.507622	2856
30458	43	2016-06-27 19:56:17.513919	2854
30459	43	2016-06-27 19:56:17.519864	2850
30460	40	2016-06-27 19:56:17.527662	47712
30461	49	2016-06-27 19:56:17.534333	47712
30462	48	2016-06-27 19:56:17.543242	2849
30463	48	2016-06-27 19:56:17.550051	2851
30464	48	2016-06-27 19:56:17.557499	2853
30465	48	2016-06-27 19:56:17.56412	2834
30466	48	2016-06-27 19:56:17.57	2847
30467	48	2016-06-27 19:56:17.577441	2843
30468	48	2016-06-27 19:56:17.584219	2845
30469	48	2016-06-27 19:56:17.591572	2855
30470	50	2016-06-27 19:56:17.598112	47712
30471	47	2016-06-27 19:56:17.604839	2849
30472	47	2016-06-27 19:56:17.612117	2851
30473	47	2016-06-27 19:56:17.618451	2853
30474	47	2016-06-27 19:56:17.62582	2834
30475	47	2016-06-27 19:56:17.631838	2847
30476	47	2016-06-27 19:56:17.638878	2843
30477	47	2016-06-27 19:56:17.645787	2845
30478	47	2016-06-27 19:56:17.65216	2855
30479	41	2016-06-27 21:28:22.297038	2857
30480	42	2016-06-27 21:28:22.38267	2853
30481	42	2016-06-27 21:28:22.391944	2849
30482	42	2016-06-27 21:28:22.406095	2834
30483	42	2016-06-27 21:28:22.415445	2845
30484	42	2016-06-27 21:28:22.43261	2855
30485	42	2016-06-27 21:28:22.447309	2851
30486	42	2016-06-27 21:28:22.468145	2843
30487	43	2016-06-27 21:28:22.49357	2835
30488	43	2016-06-27 21:28:22.509516	2844
30489	43	2016-06-27 21:28:22.550891	2846
30490	43	2016-06-27 21:28:22.581489	2852
30491	43	2016-06-27 21:28:22.611755	2856
30492	43	2016-06-27 21:28:22.642327	2854
30493	43	2016-06-27 21:28:22.673068	2850
30494	40	2016-06-27 21:28:22.704328	47712
30495	49	2016-06-27 21:28:22.733931	47712
30496	48	2016-06-27 21:28:22.766319	2849
30497	48	2016-06-27 21:28:22.795566	2851
30498	48	2016-06-27 21:28:22.82588	2853
30499	48	2016-06-27 21:28:22.855999	2834
30500	48	2016-06-27 21:28:22.887017	2847
30501	48	2016-06-27 21:28:22.908691	2843
30502	48	2016-06-27 21:28:22.925332	2845
30503	48	2016-06-27 21:28:22.936334	2855
30504	50	2016-06-27 21:28:22.954285	47712
30505	47	2016-06-27 21:28:22.962511	2849
30506	47	2016-06-27 21:28:22.974871	2851
30507	47	2016-06-27 21:28:22.981567	2853
30508	47	2016-06-27 21:28:22.991117	2834
30509	47	2016-06-27 21:28:23.004067	2847
30510	47	2016-06-27 21:28:23.012164	2843
30511	47	2016-06-27 21:28:23.024902	2845
30512	47	2016-06-27 21:28:23.031713	2855
30513	41	2016-06-28 00:01:29.364562	2857
30514	42	2016-06-28 00:01:29.416829	2853
30515	42	2016-06-28 00:01:29.425601	2849
30516	42	2016-06-28 00:01:29.435097	2834
30517	42	2016-06-28 00:01:29.444137	2845
30518	42	2016-06-28 00:01:29.452852	2855
30519	42	2016-06-28 00:01:29.459688	2851
30520	42	2016-06-28 00:01:29.469643	2843
30521	43	2016-06-28 00:01:29.477903	2835
30522	43	2016-06-28 00:01:29.485876	2844
30523	43	2016-06-28 00:01:29.492906	2846
30524	43	2016-06-28 00:01:29.501647	2852
30525	43	2016-06-28 00:01:29.508093	2856
30526	43	2016-06-28 00:01:29.516226	2854
30527	43	2016-06-28 00:01:29.523013	2850
30528	40	2016-06-28 00:01:29.533185	47712
30529	49	2016-06-28 00:01:29.543033	47712
30530	48	2016-06-28 00:01:29.559029	2849
30531	48	2016-06-28 00:01:29.585761	2851
30532	48	2016-06-28 00:01:29.599625	2853
30533	48	2016-06-28 00:01:29.624393	2834
30534	48	2016-06-28 00:01:29.679858	2847
30535	48	2016-06-28 00:01:29.726761	2843
30536	48	2016-06-28 00:01:29.75948	2845
30537	48	2016-06-28 00:01:29.818483	2855
30538	50	2016-06-28 00:01:29.872842	47712
30539	47	2016-06-28 00:01:29.897186	2849
30540	47	2016-06-28 00:01:29.909964	2851
30541	47	2016-06-28 00:01:29.933546	2853
30542	47	2016-06-28 00:01:29.953944	2834
30543	47	2016-06-28 00:01:29.966457	2847
30544	47	2016-06-28 00:01:29.975765	2843
30545	47	2016-06-28 00:01:29.990468	2845
30546	47	2016-06-28 00:01:30.006599	2855
30547	41	2016-06-28 00:17:54.489456	2857
30548	42	2016-06-28 00:17:54.497069	2853
30549	42	2016-06-28 00:17:54.503334	2849
30550	42	2016-06-28 00:17:54.509751	2834
30551	42	2016-06-28 00:17:54.51577	2845
30552	42	2016-06-28 00:17:54.522314	2855
30553	42	2016-06-28 00:17:54.529158	2851
30554	42	2016-06-28 00:17:54.535579	2843
30555	43	2016-06-28 00:17:54.541875	2835
30556	43	2016-06-28 00:17:54.548149	2844
30557	43	2016-06-28 00:17:54.555013	2846
30558	43	2016-06-28 00:17:54.561019	2852
30559	43	2016-06-28 00:17:54.567325	2856
30560	43	2016-06-28 00:17:54.574108	2854
30561	43	2016-06-28 00:17:54.580379	2850
30562	40	2016-06-28 00:17:54.588481	47712
30563	49	2016-06-28 00:17:54.595343	47712
30564	48	2016-06-28 00:17:54.602639	2849
30565	48	2016-06-28 00:17:54.609228	2851
30566	48	2016-06-28 00:17:54.61573	2853
30567	48	2016-06-28 00:17:54.622497	2834
30568	48	2016-06-28 00:17:54.62861	2847
30569	48	2016-06-28 00:17:54.635415	2843
30570	48	2016-06-28 00:17:54.642176	2845
30571	48	2016-06-28 00:17:54.648998	2855
30572	50	2016-06-28 00:17:54.655822	47712
30573	47	2016-06-28 00:17:54.662827	2849
30574	47	2016-06-28 00:17:54.670025	2851
30575	47	2016-06-28 00:17:54.676821	2853
30576	47	2016-06-28 00:17:54.683471	2834
30577	47	2016-06-28 00:17:54.689684	2847
30578	47	2016-06-28 00:17:54.696471	2843
30579	47	2016-06-28 00:17:54.703173	2845
30580	47	2016-06-28 00:17:54.709688	2855
30581	41	2016-06-28 00:19:38.169997	2857
30582	42	2016-06-28 00:19:38.177928	2853
30583	42	2016-06-28 00:19:38.184078	2849
30584	42	2016-06-28 00:19:38.192523	2834
30585	42	2016-06-28 00:19:38.217214	2845
30586	42	2016-06-28 00:19:38.242121	2855
30587	42	2016-06-28 00:19:38.250147	2851
30588	42	2016-06-28 00:19:38.256796	2843
30589	43	2016-06-28 00:19:38.26344	2835
30590	43	2016-06-28 00:19:38.269611	2844
30591	43	2016-06-28 00:19:38.275657	2846
30592	43	2016-06-28 00:19:38.281947	2852
30593	43	2016-06-28 00:19:38.288729	2856
30594	43	2016-06-28 00:19:38.295364	2854
30595	43	2016-06-28 00:19:38.301516	2850
30596	40	2016-06-28 00:19:38.308969	47712
30597	49	2016-06-28 00:19:38.315994	47712
30598	48	2016-06-28 00:19:38.325108	2849
30599	48	2016-06-28 00:19:38.332354	2851
30600	48	2016-06-28 00:19:38.340017	2853
30601	48	2016-06-28 00:19:38.34736	2834
30602	48	2016-06-28 00:19:38.354313	2847
30603	48	2016-06-28 00:19:38.361914	2843
30604	48	2016-06-28 00:19:38.371027	2845
30605	48	2016-06-28 00:19:38.380834	2855
30606	50	2016-06-28 00:19:38.391426	47712
30607	47	2016-06-28 00:19:38.398758	2849
30608	47	2016-06-28 00:19:38.406397	2851
30609	47	2016-06-28 00:19:38.413082	2853
30610	47	2016-06-28 00:19:38.420291	2834
30611	47	2016-06-28 00:19:38.426638	2847
30612	47	2016-06-28 00:19:38.433592	2843
30613	47	2016-06-28 00:19:38.441228	2845
30614	47	2016-06-28 00:19:38.448056	2855
30615	41	2016-06-28 00:20:39.25753	2857
30616	42	2016-06-28 00:20:39.265043	2853
30617	42	2016-06-28 00:20:39.270974	2849
30618	42	2016-06-28 00:20:39.277353	2845
30619	42	2016-06-28 00:20:39.284089	2855
30620	42	2016-06-28 00:20:39.290536	2834
30621	42	2016-06-28 00:20:39.297117	2851
30622	42	2016-06-28 00:20:39.303272	2843
30623	43	2016-06-28 00:20:39.309786	2835
30624	43	2016-06-28 00:20:39.316014	2844
30625	43	2016-06-28 00:20:39.322123	2846
30626	43	2016-06-28 00:20:39.32878	2852
30627	43	2016-06-28 00:20:39.334876	2856
30628	43	2016-06-28 00:20:39.341127	2854
30629	43	2016-06-28 00:20:39.347346	2850
30630	40	2016-06-28 00:20:39.354821	47712
30631	49	2016-06-28 00:20:39.36207	47712
30632	48	2016-06-28 00:20:39.369087	2849
30633	48	2016-06-28 00:20:39.37574	2851
30634	48	2016-06-28 00:20:39.382585	2853
30635	48	2016-06-28 00:20:39.390527	2834
30636	48	2016-06-28 00:20:39.396866	2847
30637	48	2016-06-28 00:20:39.403562	2843
30638	48	2016-06-28 00:20:39.410787	2845
30639	48	2016-06-28 00:20:39.417686	2855
30640	50	2016-06-28 00:20:39.424357	47712
30641	47	2016-06-28 00:20:39.431172	2849
30642	47	2016-06-28 00:20:39.437943	2851
30643	47	2016-06-28 00:20:39.444854	2853
30644	47	2016-06-28 00:20:39.451436	2834
30645	47	2016-06-28 00:20:39.457549	2847
30646	47	2016-06-28 00:20:39.464197	2843
30647	47	2016-06-28 00:20:39.470863	2845
30648	47	2016-06-28 00:20:39.478033	2855
\.


--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_notificacoes_id_seq', 30648, true);


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
6254	4	asdasd	47713	2016-06-27 19:40:16.065126	274	2847
6255	10	dsda	47713	2016-06-27 19:40:16.066135	274	2847
6256	180	dsa	47714	2016-06-27 19:40:25.594351	288	2848
6257	181	dasdsa	47714	2016-06-27 19:40:25.595179	288	2848
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 6257, true);


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
2835	47702	287	2016-06-27 17:04:31.087461	\N	3
2836	47703	1	2016-06-27 17:08:06.227947	2016-06-27 17:08:06.227947	\N
2837	47703	2	2016-06-27 17:08:06.271266	\N	\N
2838	47704	1	2016-06-27 17:10:57.404213	2016-06-27 17:10:57.404213	\N
2839	47704	2	2016-06-27 17:10:57.450557	\N	\N
2840	47705	1	2016-06-27 17:12:43.394476	2016-06-27 17:12:43.394476	\N
2842	47705	293	2016-06-27 17:12:56.820129	\N	\N
2841	47705	2	2016-06-27 17:12:43.438093	2016-06-27 17:12:56.857892	\N
2843	47707	3	2016-06-27 17:14:31.064021	\N	3
2844	47708	287	2016-06-27 17:14:31.114387	\N	7
2845	47710	3	2016-06-27 17:18:59.64379	\N	3
2846	47711	287	2016-06-27 17:18:59.692146	\N	7
2849	47716	3	2016-06-27 17:22:19.66128	\N	3
2850	47717	287	2016-06-27 17:22:19.727394	\N	3
2853	47722	3	2016-06-27 18:08:50.348014	\N	3
2854	47723	287	2016-06-27 18:08:50.398164	\N	7
2856	47726	287	2016-06-27 18:10:43.897837	\N	7
2847	47713	3	2016-06-27 17:21:09.482483	2016-06-27 19:40:16.067084	\N
2848	47714	287	2016-06-27 17:21:09.538857	2016-06-27 19:40:25.596064	\N
2857	47712	4	2016-06-27 19:40:25.607796	\N	\N
2855	47725	3	2016-06-27 18:10:43.848603	\N	\N
2834	47701	3	2016-06-27 17:04:31.037476	\N	\N
2851	47719	3	2016-06-27 18:07:59.069978	\N	\N
2852	47720	287	2016-06-27 18:07:59.316955	\N	\N
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 2857, true);


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

