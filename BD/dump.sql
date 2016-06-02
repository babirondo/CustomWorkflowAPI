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
47598	47597	4	2016-06-02 00:43:56.12558	1	Em Andamento	\N
47600	47599	3	2016-06-02 00:44:17.160837	1	Em Andamento	\N
47601	47599	3	2016-06-02 00:44:17.195865	1	Em Andamento	\N
47603	47602	3	2016-06-02 00:44:40.244287	1	Em Andamento	\N
47604	47602	3	2016-06-02 00:44:40.281218	1	Em Andamento	\N
47599	47597	2	2016-06-02 00:44:17.156125	1	Em Andamento	\N
47602	47597	2	2016-06-02 00:44:40.24079	1	Em Andamento	\N
47605	47597	4	2016-06-02 18:25:59.372044	1	Em Andamento	\N
47607	47597	4	2016-06-02 18:40:44.257562	1	Em Andamento	\N
47608	47597	4	2016-06-02 18:41:08.213478	1	Em Andamento	\N
47609	47597	4	2016-06-02 18:42:13.584664	1	Em Andamento	\N
47610	47597	4	2016-06-02 18:46:47.268916	1	Em Andamento	\N
47611	47597	4	2016-06-02 18:47:30.847989	1	Em Andamento	\N
47612	47597	4	2016-06-02 18:48:12.360985	1	Em Andamento	\N
47613	47597	4	2016-06-02 18:48:34.821629	1	Em Andamento	\N
47614	47597	4	2016-06-02 18:49:45.658742	1	Em Andamento	\N
47615	47597	4	2016-06-02 18:51:48.796044	1	Em Andamento	\N
47616	47597	4	2016-06-02 18:53:01.997532	1	Em Andamento	\N
47617	47597	4	2016-06-02 18:53:20.74486	1	Em Andamento	\N
47618	47597	4	2016-06-02 18:54:19.239262	1	Em Andamento	\N
47621	47619	4	2016-06-02 18:56:03.489729	1	Em Andamento	\N
47619	\N	1	2016-06-02 18:55:28.599085	1	Em Andamento	\N
47606	\N	1	2016-06-02 18:39:25.203589	1	Em Andamento	\N
47620	\N	1	2016-06-02 18:55:51.322971	1	Em Andamento	\N
47597	\N	1	2016-06-02 00:43:47.698637	1	Em Andamento	\N
47623	47622	4	2016-06-02 19:02:39.624666	1	Em Andamento	\N
47622	\N	1	2016-06-02 19:02:28.249562	1	Em Andamento	\N
47624	\N	1	2016-06-02 19:06:11.32508	1	Em Andamento	\N
47625	47624	2	2016-06-02 19:55:26.604302	1	\N	\N
47626	47625	3	2016-06-02 19:55:26.623929	1	Em Andamento	\N
47627	47625	3	2016-06-02 19:55:26.697087	1	Em Andamento	\N
47628	47624	2	2016-06-02 20:10:17.748385	1	\N	\N
47629	47628	3	2016-06-02 20:10:17.751437	1	Em Andamento	\N
47630	47628	3	2016-06-02 20:10:17.799957	1	Em Andamento	\N
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 47630, true);


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
28204	42	2016-06-02 00:45:21.809252	2714
28205	43	2016-06-02 00:45:21.825402	2715
28206	43	2016-06-02 00:45:40.887218	2717
28207	40	2016-06-02 00:45:52.936407	47602
28208	40	2016-06-02 00:46:28.436043	47599
28209	47	2016-06-02 00:46:28.476649	2714
28210	41	2016-06-02 00:46:53.095521	2718
28211	40	2016-06-02 00:46:53.135475	47602
28212	49	2016-06-02 00:46:53.152134	47602
28213	40	2016-06-02 00:47:29.560697	47599
28214	49	2016-06-02 00:47:29.599548	47599
28215	48	2016-06-02 00:47:29.646418	2714
28216	47	2016-06-02 00:47:29.670059	2714
28217	41	2016-06-02 18:22:53.161025	2721
28218	41	2016-06-02 18:22:53.205321	2723
28219	40	2016-06-02 18:22:53.213031	47599
28220	40	2016-06-02 18:22:53.217286	47602
28221	49	2016-06-02 18:22:53.223397	47599
28222	49	2016-06-02 18:22:53.228595	47602
28223	48	2016-06-02 18:22:53.234057	2714
28224	50	2016-06-02 18:22:53.239923	47599
28225	50	2016-06-02 18:22:53.245597	47602
28226	47	2016-06-02 18:22:53.251101	2714
28227	41	2016-06-02 18:23:57.706591	2721
28228	41	2016-06-02 18:23:57.712801	2723
28229	40	2016-06-02 18:23:57.74014	47599
28230	40	2016-06-02 18:23:57.745182	47602
28231	49	2016-06-02 18:23:57.750614	47599
28232	49	2016-06-02 18:23:57.755985	47602
28233	48	2016-06-02 18:23:57.762077	2714
28234	50	2016-06-02 18:23:57.767261	47599
28235	50	2016-06-02 18:23:57.772411	47602
28236	47	2016-06-02 18:23:57.778557	2714
28237	41	2016-06-02 18:25:59.753884	2721
28238	41	2016-06-02 18:25:59.760617	2723
28239	40	2016-06-02 18:25:59.782382	47599
28240	40	2016-06-02 18:25:59.78717	47602
28241	49	2016-06-02 18:25:59.792963	47599
28242	49	2016-06-02 18:25:59.798068	47602
28243	48	2016-06-02 18:25:59.804343	2714
28244	50	2016-06-02 18:25:59.8101	47599
28245	50	2016-06-02 18:25:59.815623	47602
28246	47	2016-06-02 18:25:59.821859	2714
28247	41	2016-06-02 18:27:40.380279	2721
28248	41	2016-06-02 18:27:40.385595	2723
28249	40	2016-06-02 18:27:40.411844	47599
28250	40	2016-06-02 18:27:40.416229	47602
28251	49	2016-06-02 18:27:40.421493	47599
28252	49	2016-06-02 18:27:40.42616	47602
28253	48	2016-06-02 18:27:40.431816	2714
28254	50	2016-06-02 18:27:40.436583	47599
28255	50	2016-06-02 18:27:40.441391	47602
28256	47	2016-06-02 18:27:40.447164	2714
28257	41	2016-06-02 18:28:41.674323	2721
28258	41	2016-06-02 18:28:41.6809	2723
28259	40	2016-06-02 18:28:41.687944	47599
28260	40	2016-06-02 18:28:41.693302	47602
28261	49	2016-06-02 18:28:41.698612	47599
28262	49	2016-06-02 18:28:41.703077	47602
28263	48	2016-06-02 18:28:41.709131	2714
28264	50	2016-06-02 18:28:41.714559	47599
28265	50	2016-06-02 18:28:41.719245	47602
28266	47	2016-06-02 18:28:41.725202	2714
28267	41	2016-06-02 18:35:47.827438	2721
28268	41	2016-06-02 18:35:47.861082	2723
28269	40	2016-06-02 18:35:47.914842	47599
28270	40	2016-06-02 18:35:47.919425	47602
28271	49	2016-06-02 18:35:47.92457	47599
28272	49	2016-06-02 18:35:47.929092	47602
28273	48	2016-06-02 18:35:47.934981	2714
28274	50	2016-06-02 18:35:47.940263	47599
28275	50	2016-06-02 18:35:47.945119	47602
28276	47	2016-06-02 18:35:47.951016	2714
28277	41	2016-06-02 18:36:48.794915	2721
28278	41	2016-06-02 18:36:48.800974	2723
28279	40	2016-06-02 18:36:48.807968	47599
28280	40	2016-06-02 18:36:48.812364	47602
28281	49	2016-06-02 18:36:48.817746	47599
28282	49	2016-06-02 18:36:48.822549	47602
28283	48	2016-06-02 18:36:48.828953	2714
28284	50	2016-06-02 18:36:48.8346	47599
28285	50	2016-06-02 18:36:48.839454	47602
28286	47	2016-06-02 18:36:48.845269	2714
28287	41	2016-06-02 18:39:25.384151	2721
28288	41	2016-06-02 18:39:25.389801	2723
28289	40	2016-06-02 18:39:25.397608	47599
28290	40	2016-06-02 18:39:25.402439	47602
28291	49	2016-06-02 18:39:25.407903	47599
28292	49	2016-06-02 18:39:25.413215	47602
28293	48	2016-06-02 18:39:25.419074	2714
28294	50	2016-06-02 18:39:25.424729	47599
28295	50	2016-06-02 18:39:25.430092	47602
28296	47	2016-06-02 18:39:25.435878	2714
28297	41	2016-06-02 18:40:44.37575	2721
28298	41	2016-06-02 18:40:44.381475	2723
28299	40	2016-06-02 18:40:44.388109	47599
28300	40	2016-06-02 18:40:44.392877	47602
28301	49	2016-06-02 18:40:44.398107	47599
28302	49	2016-06-02 18:40:44.402729	47602
28303	48	2016-06-02 18:40:44.408508	2714
28304	50	2016-06-02 18:40:44.413685	47599
28305	50	2016-06-02 18:40:44.41853	47602
28306	47	2016-06-02 18:40:44.424439	2714
28307	41	2016-06-02 18:42:11.302331	2721
28308	41	2016-06-02 18:42:11.308147	2723
28309	40	2016-06-02 18:42:11.332267	47599
28310	40	2016-06-02 18:42:11.337326	47602
28311	49	2016-06-02 18:42:11.342882	47599
28312	49	2016-06-02 18:42:11.347977	47602
28313	48	2016-06-02 18:42:11.35437	2714
28314	50	2016-06-02 18:42:11.359858	47599
28315	50	2016-06-02 18:42:11.365113	47602
28316	47	2016-06-02 18:42:11.371249	2714
28317	41	2016-06-02 18:46:43.286116	2721
28318	41	2016-06-02 18:46:43.291857	2723
28319	40	2016-06-02 18:46:43.308082	47599
28320	40	2016-06-02 18:46:43.31241	47602
28321	49	2016-06-02 18:46:43.318454	47599
28322	49	2016-06-02 18:46:43.323232	47602
28323	48	2016-06-02 18:46:43.329259	2714
28324	50	2016-06-02 18:46:43.334624	47599
28325	50	2016-06-02 18:46:43.339723	47602
28326	47	2016-06-02 18:46:43.345677	2714
28327	41	2016-06-02 18:48:12.482064	2721
28328	41	2016-06-02 18:48:12.50327	2723
28329	40	2016-06-02 18:48:12.510371	47599
28330	40	2016-06-02 18:48:12.514905	47602
28331	49	2016-06-02 18:48:12.520268	47599
28332	49	2016-06-02 18:48:12.524927	47602
28333	48	2016-06-02 18:48:12.530513	2714
28334	50	2016-06-02 18:48:12.535692	47599
28335	50	2016-06-02 18:48:12.540724	47602
28336	47	2016-06-02 18:48:12.546226	2714
28337	41	2016-06-02 18:52:54.980176	2721
28338	41	2016-06-02 18:52:54.987082	2723
28339	40	2016-06-02 18:52:55.01311	47599
28340	40	2016-06-02 18:52:55.019255	47602
28341	49	2016-06-02 18:52:55.025229	47599
28342	49	2016-06-02 18:52:55.030031	47602
28343	48	2016-06-02 18:52:55.036357	2714
28344	50	2016-06-02 18:52:55.04209	47599
28345	50	2016-06-02 18:52:55.046922	47602
28346	47	2016-06-02 18:52:55.052852	2714
28347	41	2016-06-02 18:54:19.391627	2721
28348	41	2016-06-02 18:54:19.39838	2723
28349	40	2016-06-02 18:54:19.406976	47599
28350	40	2016-06-02 18:54:19.411958	47602
28351	49	2016-06-02 18:54:19.418209	47599
28352	49	2016-06-02 18:54:19.423924	47602
28353	48	2016-06-02 18:54:19.430853	2714
28354	50	2016-06-02 18:54:19.439282	47599
28355	50	2016-06-02 18:54:19.447725	47602
28356	47	2016-06-02 18:54:19.456374	2714
28357	41	2016-06-02 18:55:28.756497	2721
28358	41	2016-06-02 18:55:28.762117	2723
28359	40	2016-06-02 18:55:28.769193	47599
28360	40	2016-06-02 18:55:28.773677	47602
28361	49	2016-06-02 18:55:28.778838	47599
28362	49	2016-06-02 18:55:28.794297	47602
28363	48	2016-06-02 18:55:28.800019	2714
28364	50	2016-06-02 18:55:28.805285	47599
28365	50	2016-06-02 18:55:28.810128	47602
28366	47	2016-06-02 18:55:28.818207	2714
28367	41	2016-06-02 18:57:21.176235	2721
28368	41	2016-06-02 18:57:21.21178	2723
28369	40	2016-06-02 18:57:21.244063	47599
28370	40	2016-06-02 18:57:21.248768	47602
28371	49	2016-06-02 18:57:21.254349	47599
28372	49	2016-06-02 18:57:21.258887	47602
28373	48	2016-06-02 18:57:21.264776	2714
28374	50	2016-06-02 18:57:21.269951	47599
28375	50	2016-06-02 18:57:21.274914	47602
28376	47	2016-06-02 18:57:21.280924	2714
28377	41	2016-06-02 19:00:03.954331	2721
28378	41	2016-06-02 19:00:03.96044	2723
28379	40	2016-06-02 19:00:03.967377	47599
28380	40	2016-06-02 19:00:03.972862	47602
28381	49	2016-06-02 19:00:03.978676	47599
28382	49	2016-06-02 19:00:03.983363	47602
28383	48	2016-06-02 19:00:03.989681	2714
28384	50	2016-06-02 19:00:03.995098	47599
28385	50	2016-06-02 19:00:03.99978	47602
28386	47	2016-06-02 19:00:04.005652	2714
28387	41	2016-06-02 19:01:22.200468	2721
28388	41	2016-06-02 19:01:22.206376	2723
28389	40	2016-06-02 19:01:22.213536	47599
28390	40	2016-06-02 19:01:22.218171	47602
28391	49	2016-06-02 19:01:22.224137	47599
28392	49	2016-06-02 19:01:22.229036	47602
28393	48	2016-06-02 19:01:22.234721	2714
28394	50	2016-06-02 19:01:22.240023	47599
28395	50	2016-06-02 19:01:22.244966	47602
28396	47	2016-06-02 19:01:22.250941	2714
28397	41	2016-06-02 19:02:28.407918	2721
28398	41	2016-06-02 19:02:28.413696	2723
28399	40	2016-06-02 19:02:28.421173	47599
28400	40	2016-06-02 19:02:28.425938	47602
28401	49	2016-06-02 19:02:28.431573	47599
28402	49	2016-06-02 19:02:28.436323	47602
28403	48	2016-06-02 19:02:28.443007	2714
28404	50	2016-06-02 19:02:28.448839	47599
28405	50	2016-06-02 19:02:28.453791	47602
28406	47	2016-06-02 19:02:28.461052	2714
28407	41	2016-06-02 19:05:00.149575	2721
28408	41	2016-06-02 19:05:00.155877	2723
28409	40	2016-06-02 19:05:00.211643	47599
28410	40	2016-06-02 19:05:00.216294	47602
28411	49	2016-06-02 19:05:00.221764	47599
28412	49	2016-06-02 19:05:00.226955	47602
28413	48	2016-06-02 19:05:00.232633	2714
28414	50	2016-06-02 19:05:00.237889	47599
28415	50	2016-06-02 19:05:00.243137	47602
28416	47	2016-06-02 19:05:00.248983	2714
28417	41	2016-06-02 19:06:00.67467	2721
28418	41	2016-06-02 19:06:00.694356	2723
28419	40	2016-06-02 19:06:00.709669	47599
28420	40	2016-06-02 19:06:00.725057	47602
28421	49	2016-06-02 19:06:00.759829	47599
28422	49	2016-06-02 19:06:00.784929	47602
28423	48	2016-06-02 19:06:00.805695	2714
28424	50	2016-06-02 19:06:00.899912	47599
28425	50	2016-06-02 19:06:00.929385	47602
28426	47	2016-06-02 19:06:00.943824	2714
28427	41	2016-06-02 19:15:00.999185	2721
28428	41	2016-06-02 19:15:01.005501	2723
28429	40	2016-06-02 19:15:01.02318	47599
28430	40	2016-06-02 19:15:01.028175	47602
28431	49	2016-06-02 19:15:01.035071	47599
28432	49	2016-06-02 19:15:01.040357	47602
28433	48	2016-06-02 19:15:01.04608	2714
28434	50	2016-06-02 19:15:01.051235	47599
28435	50	2016-06-02 19:15:01.056477	47602
28436	47	2016-06-02 19:15:01.06226	2714
28437	41	2016-06-02 19:17:45.95422	2721
28438	41	2016-06-02 19:17:45.960221	2723
28439	40	2016-06-02 19:17:45.967558	47599
28440	40	2016-06-02 19:17:45.972409	47602
28441	49	2016-06-02 19:17:45.978179	47599
28442	49	2016-06-02 19:17:45.984557	47602
28443	48	2016-06-02 19:17:45.990873	2714
28444	50	2016-06-02 19:17:45.996639	47599
28445	50	2016-06-02 19:17:46.001907	47602
28446	47	2016-06-02 19:17:46.007894	2714
28447	41	2016-06-02 19:18:52.715835	2721
28448	41	2016-06-02 19:18:52.722264	2723
28449	40	2016-06-02 19:18:52.729449	47599
28450	40	2016-06-02 19:18:52.733835	47602
28451	49	2016-06-02 19:18:52.739582	47599
28452	49	2016-06-02 19:18:52.744335	47602
28453	48	2016-06-02 19:18:52.750411	2714
28454	50	2016-06-02 19:18:52.756076	47599
28455	50	2016-06-02 19:18:52.760783	47602
28456	47	2016-06-02 19:18:52.766554	2714
28457	41	2016-06-02 19:28:22.526636	2721
28458	41	2016-06-02 19:28:22.533443	2723
28459	40	2016-06-02 19:28:22.540341	47599
28460	40	2016-06-02 19:28:22.544838	47602
28461	49	2016-06-02 19:28:22.551369	47599
28462	49	2016-06-02 19:28:22.556949	47602
28463	48	2016-06-02 19:28:22.562929	2714
28464	50	2016-06-02 19:28:22.56805	47599
28465	50	2016-06-02 19:28:22.573123	47602
28466	47	2016-06-02 19:28:22.579121	2714
28467	41	2016-06-02 19:30:52.345632	2721
28468	41	2016-06-02 19:30:52.351296	2723
28469	40	2016-06-02 19:30:52.358321	47599
28470	40	2016-06-02 19:30:52.363098	47602
28471	49	2016-06-02 19:30:52.368371	47599
28472	49	2016-06-02 19:30:52.373595	47602
28473	48	2016-06-02 19:30:52.379253	2714
28474	50	2016-06-02 19:30:52.384383	47599
28475	50	2016-06-02 19:30:52.389754	47602
28476	47	2016-06-02 19:30:52.395382	2714
28477	41	2016-06-02 19:45:10.608362	2721
28478	41	2016-06-02 19:45:10.614328	2723
28479	40	2016-06-02 19:45:10.634047	47599
28480	40	2016-06-02 19:45:10.639979	47602
28481	49	2016-06-02 19:45:10.645971	47599
28482	49	2016-06-02 19:45:10.650758	47602
28483	48	2016-06-02 19:45:10.656667	2714
28484	50	2016-06-02 19:45:10.662456	47599
28485	50	2016-06-02 19:45:10.667292	47602
28486	47	2016-06-02 19:45:10.673098	2714
28487	41	2016-06-02 19:48:45.442993	2721
28488	41	2016-06-02 19:48:45.449565	2723
28489	40	2016-06-02 19:48:45.47211	47599
28490	40	2016-06-02 19:48:45.476962	47602
28491	49	2016-06-02 19:48:45.483199	47599
28492	49	2016-06-02 19:48:45.488462	47602
28493	48	2016-06-02 19:48:45.495236	2714
28494	50	2016-06-02 19:48:45.50105	47599
28495	50	2016-06-02 19:48:45.506019	47602
28496	47	2016-06-02 19:48:45.512199	2714
28497	41	2016-06-02 19:51:39.198185	2721
28498	41	2016-06-02 19:51:39.204237	2723
28499	40	2016-06-02 19:51:39.211143	47599
28500	40	2016-06-02 19:51:39.215897	47602
28501	49	2016-06-02 19:51:39.22199	47599
28502	49	2016-06-02 19:51:39.227057	47602
28503	48	2016-06-02 19:51:39.232921	2714
28504	50	2016-06-02 19:51:39.238764	47599
28505	50	2016-06-02 19:51:39.243976	47602
28506	47	2016-06-02 19:51:39.249835	2714
28507	41	2016-06-02 19:53:44.112862	2721
28508	41	2016-06-02 19:53:44.118582	2723
28509	40	2016-06-02 19:53:44.127622	47599
28510	40	2016-06-02 19:53:44.132297	47602
28511	49	2016-06-02 19:53:44.138141	47599
28512	49	2016-06-02 19:53:44.142859	47602
28513	48	2016-06-02 19:53:44.148624	2714
28514	50	2016-06-02 19:53:44.153952	47599
28515	50	2016-06-02 19:53:44.159616	47602
28516	47	2016-06-02 19:53:44.165777	2714
28517	41	2016-06-02 19:55:26.884605	2721
28518	41	2016-06-02 19:55:26.890932	2723
28519	40	2016-06-02 19:55:26.89827	47599
28520	40	2016-06-02 19:55:26.902845	47602
28521	49	2016-06-02 19:55:26.90882	47599
28522	49	2016-06-02 19:55:26.913947	47602
28523	48	2016-06-02 19:55:26.919784	2714
28524	50	2016-06-02 19:55:26.925867	47599
28525	50	2016-06-02 19:55:26.931107	47602
28526	47	2016-06-02 19:55:26.936737	2714
28527	41	2016-06-02 19:57:41.130789	2721
28528	41	2016-06-02 19:57:41.136755	2723
28529	42	2016-06-02 19:57:41.143339	2758
28530	43	2016-06-02 19:57:41.148752	2759
28531	40	2016-06-02 19:57:41.154615	47599
28532	40	2016-06-02 19:57:41.159245	47602
28533	49	2016-06-02 19:57:41.166008	47599
28534	49	2016-06-02 19:57:41.171002	47602
28535	48	2016-06-02 19:57:41.178751	2714
28536	50	2016-06-02 19:57:41.184267	47599
28537	50	2016-06-02 19:57:41.189507	47602
28538	47	2016-06-02 19:57:41.195687	2714
28539	41	2016-06-02 19:58:58.919355	2721
28540	41	2016-06-02 19:58:58.928161	2723
28541	42	2016-06-02 19:58:58.935019	2758
28542	43	2016-06-02 19:58:58.941099	2759
28543	40	2016-06-02 19:58:58.946999	47599
28544	40	2016-06-02 19:58:58.951593	47602
28545	49	2016-06-02 19:58:58.976449	47599
28546	49	2016-06-02 19:58:58.981251	47602
28547	48	2016-06-02 19:58:58.987157	2714
28548	50	2016-06-02 19:58:58.99293	47599
28549	50	2016-06-02 19:58:58.997823	47602
28550	47	2016-06-02 19:58:59.004081	2758
28551	47	2016-06-02 19:58:59.009867	2714
28552	41	2016-06-02 20:00:38.915565	2721
28553	41	2016-06-02 20:00:38.922487	2723
28554	42	2016-06-02 20:00:38.928762	2758
28555	43	2016-06-02 20:00:38.934409	2759
28556	40	2016-06-02 20:00:38.940629	47599
28557	40	2016-06-02 20:00:38.945817	47602
28558	49	2016-06-02 20:00:38.951771	47599
28559	49	2016-06-02 20:00:38.957138	47602
28560	48	2016-06-02 20:00:38.964679	2714
28561	48	2016-06-02 20:00:38.971124	2758
28562	50	2016-06-02 20:00:38.976368	47599
28563	50	2016-06-02 20:00:38.982746	47602
28564	47	2016-06-02 20:00:38.988747	2714
28565	47	2016-06-02 20:00:38.994325	2758
28566	41	2016-06-02 20:02:31.644479	2721
28567	41	2016-06-02 20:02:31.650515	2723
28568	42	2016-06-02 20:02:31.65694	2758
28569	43	2016-06-02 20:02:31.662704	2759
28570	40	2016-06-02 20:02:31.668863	47599
28571	40	2016-06-02 20:02:31.673505	47602
28572	49	2016-06-02 20:02:31.679915	47599
28573	49	2016-06-02 20:02:31.685123	47602
28574	48	2016-06-02 20:02:31.691134	2714
28575	48	2016-06-02 20:02:31.696708	2758
28576	50	2016-06-02 20:02:31.702537	47599
28577	50	2016-06-02 20:02:31.707562	47602
28578	47	2016-06-02 20:02:31.713489	2714
28579	47	2016-06-02 20:02:31.719235	2758
28580	41	2016-06-02 20:03:32.548634	2721
28581	41	2016-06-02 20:03:32.555634	2723
28582	42	2016-06-02 20:03:32.56272	2758
28583	43	2016-06-02 20:03:32.568574	2759
28584	40	2016-06-02 20:03:32.575605	47599
28585	40	2016-06-02 20:03:32.580421	47602
28586	49	2016-06-02 20:03:32.58716	47599
28587	49	2016-06-02 20:03:32.592125	47602
28588	48	2016-06-02 20:03:32.598577	2714
28589	48	2016-06-02 20:03:32.604854	2758
28590	50	2016-06-02 20:03:32.610507	47599
28591	50	2016-06-02 20:03:32.616199	47602
28592	47	2016-06-02 20:03:32.623054	2714
28593	47	2016-06-02 20:03:32.629131	2758
28594	41	2016-06-02 20:05:02.845009	2721
28595	41	2016-06-02 20:05:02.909322	2723
28596	42	2016-06-02 20:05:02.93265	2758
28597	43	2016-06-02 20:05:02.954139	2759
28598	40	2016-06-02 20:05:03.026246	47599
28599	40	2016-06-02 20:05:03.051358	47602
28600	49	2016-06-02 20:05:03.07257	47599
28601	49	2016-06-02 20:05:03.093894	47602
28602	48	2016-06-02 20:05:03.11722	2714
28603	48	2016-06-02 20:05:03.140913	2758
28604	50	2016-06-02 20:05:03.163225	47599
28605	50	2016-06-02 20:05:03.201493	47602
28606	47	2016-06-02 20:05:03.223082	2714
28607	47	2016-06-02 20:05:03.267627	2758
28608	41	2016-06-02 20:10:07.020479	2721
28609	41	2016-06-02 20:10:07.04472	2723
28610	42	2016-06-02 20:10:07.0525	2758
28611	43	2016-06-02 20:10:07.058913	2759
28612	40	2016-06-02 20:10:07.115727	47599
28613	40	2016-06-02 20:10:07.120703	47602
28614	49	2016-06-02 20:10:07.132461	47599
28615	49	2016-06-02 20:10:07.138363	47602
28616	48	2016-06-02 20:10:07.162531	2714
28617	48	2016-06-02 20:10:07.168808	2758
28618	50	2016-06-02 20:10:07.17497	47599
28619	50	2016-06-02 20:10:07.180775	47602
28620	47	2016-06-02 20:10:07.187287	2714
28621	47	2016-06-02 20:10:07.193115	2758
\.


--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_notificacoes_id_seq', 28621, true);


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
5929	13	fletwood mac	47597	2016-06-02 00:43:47.700091	1
5930	174	k	47597	2016-06-02 00:43:47.700614	1
5931	1	k	47597	2016-06-02 00:43:47.701164	1
5932	184	biglove@	47598	2016-06-02 00:43:56.127312	294
5933	11	hits	47599	2016-06-02 00:44:17.158227	273
5934	2	k	47599	2016-06-02 00:44:17.158904	273
5935	166	k	47599	2016-06-02 00:44:17.15934	273
5936	182	k	47599	2016-06-02 00:44:17.159788	273
5937	12	k	47599	2016-06-02 00:44:17.160177	273
5938	11	the knack	47602	2016-06-02 00:44:40.241698	273
5939	2	k	47602	2016-06-02 00:44:40.242497	273
5940	166	k	47602	2016-06-02 00:44:40.242862	273
5941	182	k	47602	2016-06-02 00:44:40.243264	273
5942	12	k	47602	2016-06-02 00:44:40.243664	273
5943	4	pl	47603	2016-06-02 00:45:21.525354	274
5944	10	lll	47603	2016-06-02 00:45:21.527392	274
5945	4	espec	47600	2016-06-02 00:45:28.573545	274
5946	10	 mm	47600	2016-06-02 00:45:28.576756	274
5947	180	jr	47604	2016-06-02 00:45:52.480801	288
5948	181	sharona	47604	2016-06-02 00:45:52.482883	288
5949	180	pl	47601	2016-06-02 00:46:28.004826	288
5950	181	top hits	47601	2016-06-02 00:46:28.007471	288
5951	172	my hsarona	47599	2016-06-02 00:46:57.730763	286
5952	170	billboard	47599	2016-06-02 00:47:10.501803	285
5953	5	siqueira	47602	2016-06-02 00:47:21.571597	275
5954	167	quero nao	47602	2016-06-02 00:47:32.397899	281
5955	184	KIO@	47605	2016-06-02 18:25:59.451638	294
5956	13	ewq	47606	2016-06-02 18:39:25.204487	1
5957	174	ewqewqeqw	47606	2016-06-02 18:39:25.205053	1
5958	1	dddd	47606	2016-06-02 18:39:25.205466	1
5959	186	consultoria1@email.com, consultoria2@eail.com	47606	2016-06-02 18:39:25.205867	1
5960	184	dsadasd	47607	2016-06-02 18:40:44.2583	294
5961	184	d2d2d2d@@@@	47608	2016-06-02 18:41:08.226552	294
5962	184	gt	47609	2016-06-02 18:42:13.598391	294
5963	184	dd	47610	2016-06-02 18:46:47.269739	294
5964	184	bruno@bruno, rod@rod	47611	2016-06-02 18:47:30.848823	294
5965	184	bruno@bruno, rod@rod	47612	2016-06-02 18:48:12.361811	294
5966	184	bruno@bruno, rod@rod	47613	2016-06-02 18:48:34.822498	294
5967	184	bruno@bruno, rod@rod	47614	2016-06-02 18:49:45.659544	294
5968	184	bruno@bruno, rod@rod	47615	2016-06-02 18:51:48.796852	294
5969	184	bruno@bruno, rod@rodd	47616	2016-06-02 18:53:01.998439	294
5970	184	bruno@bruno, rod@rodd	47617	2016-06-02 18:53:20.745678	294
5971	184	bruno@bruno, rod@rodd	47618	2016-06-02 18:54:19.240169	294
5972	13	nova vaga muktli consutloria	47619	2016-06-02 18:55:28.600117	1
5973	174	mk	47619	2016-06-02 18:55:28.600946	1
5974	1	m	47619	2016-06-02 18:55:28.601381	1
5975	186	consultoria1@email.com, consultoria2@eail.com	47619	2016-06-02 18:55:28.601851	1
5976	13	nova vaga muktli consutloria	47620	2016-06-02 18:55:51.324161	1
5977	174	mk	47620	2016-06-02 18:55:51.324709	1
5978	1	m	47620	2016-06-02 18:55:51.32509	1
5979	186	consultoria1@email.com, consultoria2@eail.com	47620	2016-06-02 18:55:51.325527	1
5980	184	d2d2d2	47621	2016-06-02 18:56:03.509685	294
5981	183	por motivos de reorganizacao interna, gostaríamos de suspender este processo seletivo.	47619	2016-06-02 18:57:43.03275	292
5982	183	por motivos de reorganizacao interna, gostaríamos de suspender este processo seletivo.	47619	2016-06-02 18:58:19.955242	292
5983	183	ccdscds	47606	2016-06-02 19:00:16.215681	292
5984	183	por motivos de reorganizacao interna, gostaríamos de suspender este processo seletivo.	47619	2016-06-02 19:00:21.106091	292
5985	183	por motivos de reorganizacao interna, gostaríamos de suspender este processo seletivo.	47619	2016-06-02 19:01:14.17152	292
5986	183	ccdscds	47606	2016-06-02 19:01:22.07218	292
5987	183	encerreii...	47620	2016-06-02 19:01:54.964105	292
5988	183	encerreii ahuauahuauhauh	47597	2016-06-02 19:02:06.151826	292
5989	13	Android	47622	2016-06-02 19:02:28.250437	1
5990	174	android....	47622	2016-06-02 19:02:28.251301	1
5991	1	lalallalalal	47622	2016-06-02 19:02:28.25171	1
5992	186	mazzatech, ginga, verx	47622	2016-06-02 19:02:28.252144	1
5993	184	bruno@siqueira, marcos@arthur	47623	2016-06-02 19:02:39.625483	294
5994	183	deu ruim....	47622	2016-06-02 19:02:46.939034	292
5995	13	android	47624	2016-06-02 19:06:11.32673	1
5996	174	c++	47624	2016-06-02 19:06:11.340115	1
5997	1	-s90k	47624	2016-06-02 19:06:11.340664	1
5998	186	consultoria1@email.com, consultoria2@eail.com	47624	2016-06-02 19:06:11.341117	1
5999	11	1	47625	2016-06-02 19:55:26.621625	273
6000	2		47625	2016-06-02 19:55:26.622419	273
6001	166		47625	2016-06-02 19:55:26.622882	273
6002	182	Array	47625	2016-06-02 19:55:26.623271	273
6003	11	xxxx	47628	2016-06-02 20:10:17.749158	273
6004	2	github	47628	2016-06-02 20:10:17.749702	273
6005	166	connnssss	47628	2016-06-02 20:10:17.750068	273
6006	182	Array	47628	2016-06-02 20:10:17.750459	273
6007	12	Array	47628	2016-06-02 20:10:17.750846	273
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 6007, true);


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
2711	47597	1	2016-06-02 00:43:47.701917	2016-06-02 00:43:47.701917	\N
2713	47598	295	2016-06-02 00:43:56.128136	\N	\N
2716	47603	3	2016-06-02 00:44:40.244947	2016-06-02 00:45:21.528286	3
2714	47600	3	2016-06-02 00:44:17.161556	2016-06-02 00:45:28.578829	3
2717	47604	287	2016-06-02 00:44:40.281841	2016-06-02 00:45:52.484437	7
2715	47601	287	2016-06-02 00:44:17.196616	2016-06-02 00:46:28.008674	7
2719	47599	4	2016-06-02 00:46:28.041637	2016-06-02 00:46:57.810839	\N
2721	47599	4	2016-06-02 00:47:10.504402	\N	\N
2720	47599	280	2016-06-02 00:46:57.733668	2016-06-02 00:47:10.587911	\N
2718	47602	4	2016-06-02 00:45:52.510276	2016-06-02 00:47:21.655012	\N
2723	47602	4	2016-06-02 00:47:32.400418	\N	\N
2722	47602	5	2016-06-02 00:47:21.574189	2016-06-02 00:47:32.478629	\N
2724	47605	295	2016-06-02 18:25:59.465672	\N	\N
2725	47606	1	2016-06-02 18:39:25.206565	2016-06-02 18:39:25.206565	\N
2727	47607	295	2016-06-02 18:40:44.259414	\N	\N
2728	47608	295	2016-06-02 18:41:08.227649	\N	\N
2729	47609	295	2016-06-02 18:42:13.599439	\N	\N
2730	47610	295	2016-06-02 18:46:47.270579	\N	\N
2731	47611	295	2016-06-02 18:47:30.849867	\N	\N
2732	47612	295	2016-06-02 18:48:12.362871	\N	\N
2733	47613	295	2016-06-02 18:48:34.823662	\N	\N
2734	47614	295	2016-06-02 18:49:45.660581	\N	\N
2735	47615	295	2016-06-02 18:51:48.797591	\N	\N
2736	47616	295	2016-06-02 18:53:01.999523	\N	\N
2737	47617	295	2016-06-02 18:53:20.746468	\N	\N
2738	47618	295	2016-06-02 18:54:19.24102	\N	\N
2739	47619	1	2016-06-02 18:55:28.602678	2016-06-02 18:55:28.602678	\N
2741	47620	1	2016-06-02 18:55:51.326473	2016-06-02 18:55:51.326473	\N
2743	47621	295	2016-06-02 18:56:03.51097	\N	\N
2744	47619	293	2016-06-02 18:57:43.033994	\N	\N
2745	47619	293	2016-06-02 18:58:19.956499	\N	\N
2746	47606	293	2016-06-02 19:00:16.216758	\N	\N
2747	47619	293	2016-06-02 19:00:21.107156	\N	\N
2748	47619	293	2016-06-02 19:01:14.172742	\N	\N
2740	47619	2	2016-06-02 18:55:28.640379	2016-06-02 19:01:14.204012	\N
2749	47606	293	2016-06-02 19:01:22.073463	\N	\N
2726	47606	2	2016-06-02 18:39:25.247404	2016-06-02 19:01:22.107289	\N
2750	47620	293	2016-06-02 19:01:54.965694	\N	\N
2742	47620	2	2016-06-02 18:55:51.374291	2016-06-02 19:01:54.998518	\N
2751	47597	293	2016-06-02 19:02:06.203226	\N	\N
2712	47597	2	2016-06-02 00:43:47.740424	2016-06-02 19:02:06.252631	\N
2752	47622	1	2016-06-02 19:02:28.252857	2016-06-02 19:02:28.252857	\N
2754	47623	295	2016-06-02 19:02:39.626721	\N	\N
2755	47622	293	2016-06-02 19:02:46.940301	\N	\N
2753	47622	2	2016-06-02 19:02:28.292732	2016-06-02 19:02:46.973121	\N
2756	47624	1	2016-06-02 19:06:11.363429	2016-06-02 19:06:11.363429	\N
2757	47624	2	2016-06-02 19:06:11.404568	\N	\N
2758	47626	3	2016-06-02 19:55:26.624655	\N	3
2759	47627	287	2016-06-02 19:55:26.712364	\N	7
2760	47629	3	2016-06-02 20:10:17.752086	\N	7
2761	47630	287	2016-06-02 20:10:17.800753	\N	6
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 2761, true);


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

