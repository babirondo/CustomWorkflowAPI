--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.3

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
47701	47700	3	2016-06-27 17:04:31.036561	1	Em Andamento	\N
47702	47700	3	2016-06-27 17:04:31.086701	1	Em Andamento	\N
47703	\N	1	2016-06-27 17:08:06.22667	1	Em Andamento	\N
47704	\N	1	2016-06-27 17:10:57.402566	1	Em Andamento	\N
9	8	3	2016-06-28 20:04:35.8495	1	Em Andamento	\N
47705	\N	1	2016-06-27 17:12:43.393303	1	Em Andamento	\N
47707	47706	3	2016-06-27 17:14:31.063313	1	Em Andamento	\N
47708	47706	3	2016-06-27 17:14:31.113486	1	Em Andamento	\N
47710	47709	3	2016-06-27 17:18:59.643099	1	Em Andamento	\N
47711	47709	3	2016-06-27 17:18:59.691502	1	Em Andamento	\N
47713	47712	3	2016-06-27 17:21:09.48169	1	Em Andamento	\N
47714	47712	3	2016-06-27 17:21:09.538136	1	Em Andamento	\N
47716	47715	3	2016-06-27 17:22:19.660522	1	Em Andamento	\N
47717	47715	3	2016-06-27 17:22:19.726673	1	Em Andamento	\N
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
47727	47699	2	2016-06-27 18:45:35.552097	1	Em Andamento	\N
47743	47742	2	2016-06-27 20:45:52.473406	1	Em Andamento	\N
47721	47699	2	2016-06-27 18:08:50.343885	1	Em Andamento	\N
47737	47736	3	2016-06-27 20:30:57.784904	1	Em Andamento	\N
47738	47736	3	2016-06-27 20:30:57.834242	1	Em Andamento	\N
47740	47739	3	2016-06-27 20:34:37.580884	1	Em Andamento	\N
47741	47739	3	2016-06-27 20:34:37.633004	1	Em Andamento	\N
47718	47704	2	2016-06-27 18:07:58.489949	1	Em Andamento	\N
47742	\N	1	2016-06-27 20:43:34.005704	1	Em Andamento	\N
47744	47743	3	2016-06-27 20:45:52.476742	1	Em Andamento	\N
47745	47743	3	2016-06-27 20:45:52.53625	1	Em Andamento	\N
8	47699	2	2016-06-28 20:04:35.845558	1	Em Andamento	\N
47739	47699	2	2016-06-27 20:34:37.577505	1	Em Andamento	\N
47746	\N	1	2016-06-27 21:05:04.894812	1	Em Andamento	\N
47736	47699	2	2016-06-27 20:30:57.781409	1	Em Andamento	\N
47715	47699	2	2016-06-27 17:22:19.656892	1	Em Andamento	\N
47747	\N	1	2016-06-27 21:09:07.956364	1	Em Andamento	\N
47712	47699	2	2016-06-27 17:21:09.478192	1	Em Andamento	\N
5	\N	1	2016-06-27 21:13:14.427923	1	Em Andamento	\N
47700	47699	2	2016-06-27 17:04:31.032956	1	Em Andamento	\N
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
41	Tempo no posto Roteamento	8	workflow_tramitacao wt	24	wt.inicio	wt.id	4	wt.fim is null and wt.idworkflowposto = 4	\N
46	Tempo no Posto Negociar com COnsultoria	9	workflow_tramitacao wt	24	wt.inicio	wt.id	8	wt.fim is null and wt.idworkflowposto = 8	\N
45	Tempo no Posto Entrevistados	10	workflow_tramitacao wt	24	wt.inicio	wt.id	6	wt.fim is null and wt.idworkflowposto = 6	\N
44	Tempo no Posto Entrevista Presencial	11	workflow_tramitacao wt	24	wt.inicio	wt.id	5	wt.fim is null and wt.idworkflowposto = 5	\N
42	Tempo no Posto Primeira Avaliação	12	workflow_tramitacao wt	24	wt.inicio	wt.id	3	wt.fim is null and wt.idworkflowposto = 3	\N
43	Tempo no Posto Segunda Avaliação	12	workflow_tramitacao wt	24	wt.inicio	wt.id	287	wt.fim is null and wt.idworkflowposto = 287	\N
39	Tempo no Posto Onboarding	13	workflow_tramitacao wt	24	wt.inicio	wt.id	7	wt.fim is null and wt.idworkflowposto = 7	\N
40	Tempo máximo de Candidatura	14	processos p	24	p.inicio	p.id		p.status IN (null,   'Em Andamento') and p.idtipoprocesso = 2	\N
49	Escalonamento, nível 1, Tempo máximo de candidatura	17	sla_notificacoes sn 	24	sn.datanotificacao	sn.chave	\N	sn.idsla = 40	40
48	Escalonamento, nível 2, posto Primeira Avaliação	16	sla_notificacoes sn	24	sn.datanotificacao	sn.chave	\N	sn.idsla = 47	47
50	Escalonamento nível 2, tempo máximo de processo do candidato	18	sla_notificacoes sn	24	sn.datanotificacao	sn.chave	\N	sn.idsla = 49	49
47	Escalonamento, nível 1, posto Primeira Avaliação	15	sla_notificacoes sn	24	sn.datanotificacao	sn.chave	\N	sn.idsla = 42	42
\.


--
-- Name: sla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_id_seq', 50, true);


--
-- Data for Name: sla_notificacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sla_notificacoes (id, idsla, datanotificacao, chave) FROM stdin;
38040	41	2016-07-12 17:58:54.244333	2858
38041	41	2016-07-12 17:58:54.463433	2865
38042	41	2016-07-12 17:58:54.490477	2866
38043	41	2016-07-12 17:58:54.516856	2896
38044	45	2016-07-12 17:58:54.544219	2891
38045	44	2016-07-12 17:58:54.570746	2895
38046	42	2016-07-12 17:58:54.596678	2855
38047	43	2016-07-12 17:58:54.62299	2848
38048	43	2016-07-12 17:58:54.6488	2835
38049	43	2016-07-12 17:58:54.67462	2875
38050	43	2016-07-12 17:58:54.736787	2893
38051	43	2016-07-12 17:58:54.784695	2856
38052	43	2016-07-12 17:58:54.810582	2873
38053	43	2016-07-12 17:58:54.853502	2850
38054	40	2016-07-12 17:58:54.961992	47706
38055	40	2016-07-12 17:58:55.020108	47733
38056	40	2016-07-12 17:58:55.076098	47730
38057	40	2016-07-12 17:58:55.143443	47709
38058	40	2016-07-12 17:58:55.241062	47727
38059	40	2016-07-12 17:58:55.357597	47721
38060	40	2016-07-12 17:58:55.389704	47718
38061	40	2016-07-12 17:58:55.422514	47743
38062	40	2016-07-12 18:02:40.961442	8
38063	40	2016-07-12 18:02:54.467859	47739
38064	40	2016-07-12 18:03:02.380583	47736
38065	40	2016-07-12 18:03:09.117759	47715
38066	40	2016-07-12 18:03:15.718356	47712
38067	40	2016-07-12 18:03:22.185484	47700
\.


--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_notificacoes_id_seq', 38067, true);


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
6373	10	Utilizou a linguagem Ruby On Rails para desenvolver o teste. Todas as telas e fluxos foram desenvolvidos, porém alguns fluxos um pouco complexos e com erros.\r\n\r\nCritérios de avaliação:\r\n\r\nCustomização do front-end: utilizou o Twitter Bootstrap e não teve uma customização fina para as telas propostas.\r\nDependência do framework: todos os controllers, models e views foram desenvolvidos utilizando o Scaffold do Rails. Alguns models não teriam a necessidade de serem utilizados, mas como foram auto-gerados para ter a tela referente ao fluxo, criou-se alguns models a mais.\r\nPadrões de projeto: nenhum padrão de projeto foi utilizado.\r\nOrganização: Seguiu o modelo do RoR, o que já deixa o projeto bem organizado.\r\nOrganização das camadas da App: as regras de negócio e consultar ao banco de dados foram inteiramente escritas no controller ou no model.\r\n\r\nAvaliação: \r\nO nível do candidato se aplicaria em um Full-stack Junior Ruby on Rails.\r\n	47719	2016-07-06 13:14:49.38093	274	2851
6375	181	já avaliado	10	2016-07-12 18:02:40.183519	288	2893
6376	180	já avaliado	47741	2016-07-12 18:02:53.749059	288	2875
6377	181	já avaliado	47741	2016-07-12 18:02:53.749935	288	2875
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
6365	4	Junior	47740	2016-06-30 20:12:35.731385	274	2874
6366	10	Código sem estrutura definida, Async Task para conexões, código em português, layout sem usabilidade, CRUD incompleto. (Reprovado)	47740	2016-06-30 20:12:35.768211	274	2874
6367	4	Junior	47701	2016-06-30 20:12:56.370104	274	2834
6368	10	Código sem estrutura definida, falta de resposta ao usuário, uso de componentes antigos, camadas de layout desnecessárias. (Reprovado)	47701	2016-06-30 20:12:56.371067	274	2834
6369	180	Pleno	47720	2016-07-06 11:50:23.158522	288	2852
6370	181	A Organização do projeto seguiu os padrão do Ruby On Rails, o candidato usou as rotas como API, mostrou conhecimentos como front-end com rails.\r\nO codigo que o candidato está bem enxuto e limpo, mostrou organização e soube seguir boas praticas, mas não teve nada que demostrasse que o candidato pudesse ser classificado como Senior. Também não demostrou nada que fizesse ser classificado como Junior, pois ele mostrou que tem conhecimento de boas praticas e soube usar on Ruby on Rails + Heroku para demostrar sua solução.\r\n\r\nEntão, o candidato está classificado como Pleno baseado nas informações na solução dele.	47720	2016-07-06 11:50:23.180431	288	2852
6371	5	Luciano	47743	2016-07-06 11:51:17.673792	275	2895
6372	4	Junior	47719	2016-07-06 13:14:49.347739	274	2851
6374	180	já avaliado	10	2016-07-12 18:02:40.110679	288	2893
6378	180	já avaliado	47738	2016-07-12 18:03:01.540223	288	2873
6379	181	já avaliado	47738	2016-07-12 18:03:01.541134	288	2873
6380	180	já avaliado	47717	2016-07-12 18:03:08.421695	288	2850
6381	181	já avaliado	47717	2016-07-12 18:03:08.422686	288	2850
6382	180	já avaliado	47714	2016-07-12 18:03:14.859567	288	2848
6383	181	já avaliado	47714	2016-07-12 18:03:14.868134	288	2848
6384	180	já avaliado	47702	2016-07-12 18:03:21.746546	288	2835
6385	181	já avaliado	47702	2016-07-12 18:03:21.747461	288	2835
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 6385, true);


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
2836	47703	1	2016-06-27 17:08:06.227947	2016-06-27 17:08:06.227947	\N
2837	47703	2	2016-06-27 17:08:06.271266	\N	\N
2838	47704	1	2016-06-27 17:10:57.404213	2016-06-27 17:10:57.404213	\N
2839	47704	2	2016-06-27 17:10:57.450557	\N	\N
2840	47705	1	2016-06-27 17:12:43.394476	2016-06-27 17:12:43.394476	\N
2842	47705	293	2016-06-27 17:12:56.820129	\N	\N
2841	47705	2	2016-06-27 17:12:43.438093	2016-06-27 17:12:56.857892	\N
2891	47706	6	2016-06-28 15:51:15.802712	\N	\N
2869	47706	5	2016-06-27 20:08:14.85715	2016-06-28 15:51:15.840903	\N
2843	47707	3	2016-06-27 17:14:31.064021	2016-06-27 18:40:16.733914	3
2844	47708	287	2016-06-27 17:14:31.114387	2016-06-27 18:40:28.202468	7
2845	47710	3	2016-06-27 17:18:59.64379	2016-06-27 18:42:37.438518	3
2846	47711	287	2016-06-27 17:18:59.692146	2016-06-27 18:42:50.781773	7
2858	47709	4	2016-06-27 18:42:50.792781	\N	\N
2879	47745	287	2016-06-27 20:45:52.536906	2016-06-29 20:08:07.337296	21
2878	47744	3	2016-06-27 20:45:52.477445	2016-06-29 20:10:52.089313	24
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
2856	47726	287	2016-06-27 18:10:43.897837	\N	\N
2874	47740	3	2016-06-27 20:34:37.58152	2016-06-30 20:12:35.785011	14
2834	47701	3	2016-06-27 17:04:31.037476	2016-06-30 20:12:56.371881	14
2852	47720	287	2016-06-27 18:07:59.316955	2016-07-06 11:50:23.202373	16
2895	47743	5	2016-07-06 11:51:17.579221	\N	\N
2894	47743	4	2016-06-29 20:10:52.100162	2016-07-06 11:51:17.667916	\N
2851	47719	3	2016-06-27 18:07:59.069978	2016-07-06 13:14:49.425416	15
2896	47718	4	2016-07-06 13:14:49.441688	\N	\N
2855	47725	3	2016-06-27 18:10:43.848603	\N	\N
2893	10	287	2016-06-28 20:04:35.899005	2016-07-12 18:02:40.211741	14
2897	8	4	2016-07-12 18:02:40.262632	\N	\N
2875	47741	287	2016-06-27 20:34:37.633961	2016-07-12 18:02:53.750795	14
2898	47739	4	2016-07-12 18:02:53.76198	\N	\N
2873	47738	287	2016-06-27 20:30:57.834924	2016-07-12 18:03:01.542073	14
2899	47736	4	2016-07-12 18:03:01.554433	\N	\N
2850	47717	287	2016-06-27 17:22:19.727394	2016-07-12 18:03:08.423511	14
2900	47715	4	2016-07-12 18:03:08.435885	\N	\N
2848	47714	287	2016-06-27 17:21:09.538857	2016-07-12 18:03:14.868875	14
2901	47712	4	2016-07-12 18:03:14.893217	\N	\N
2835	47702	287	2016-06-27 17:04:31.087461	2016-07-12 18:03:21.748291	14
2902	47700	4	2016-07-12 18:03:21.763475	\N	\N
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 2902, true);


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

