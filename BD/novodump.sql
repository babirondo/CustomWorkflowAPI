--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--
create database customworkflow;
\c customworkflow;
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
-- Name: sla; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
    where_tabela character varying
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
-- Name: sla_notificacoes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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

ALTER TABLE ONLY sla ALTER COLUMN id SET DEFAULT nextval('sla_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sla_notificacoes ALTER COLUMN id SET DEFAULT nextval('sla_notificacoes_id_seq'::regclass);


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
8	devcontrat@walmart.com	devcontrat@walmart.com	[Processo de Contratação] SLA Vencido, Posto Roteamento	Olá,\n\nO SLA do posto foi vencido e solicitamos que o roteamento dos candidatos aprovados seja logo realizado.
9	devcontrat@walmart.com	{Gestor Interessado}	[Processo de Contratação] SLA Vencido, Negociação com Consultoria	\nOlá {Gestor Interessado},\nGostaríamos de informar que o SLA de Negociação com a COnusltoria do candidato {nome} referente ao processo seletivo {idprocesso} encontra-se vencido.\n\nFavor agilizar.\n\nAbs,\nBruno\n
10	devcontrat@walmart.com	{Gestor Interessado}	[Processo de Contratação] SLA Vencido, Negociação com Consultoria	\nOlá {Gestor Interessado},\nGostaríamos de informar que o SLA de revisão dos candidatos entrevistados, especificamento o candidato {nome} referente ao processo seletivo {idprocesso} encontra-se vencido.\n\nFavor agilizar.\n\nAbs,\nBruno\n
11	devcontrat@walmart.com	{Gestor Interessado}	[Processo de Contratação] SLA Vencido, Negociação com Consultoria	\nOlá {Gestor Interessado},\nGostaríamos de informar que o SLA de Entrevista, especificamente do candidato {nome} referente ao processo seletivo {idprocesso} encontra-se vencido.\n\nFavor agilizar.\n\nAbs,\nBruno
12	devcontrat@walmart.com	{usuario_associado}	[Processo de Contratação] Avaliação do Teste	\nOlá {Gestor usuario_associado},\nGostaríamos de informar que o SLA de Avaliação do Teste Técnico, especificamente do candidato {nome} referente ao processo seletivo {idprocesso} encontra-se vencido.\n\nGentileza, verificar ASAP.\n\nAbs,\nBruno
13	devcontrat@walmart.com	{Gestor Interessado}	[Processo de Contratação] SLA de Onboarding vencido	\nOlá {Gestor Interessado},\nGostaríamos de informar que o SLA de Onboarding do novo membro {nome} encontra-se vencido.\n\nGentileza, agilizar. \n\nAbs,\nBruno
14	devcontrat@walmart.com	{Gestor Seleção}	[Processo de Contratação] SLA do processo de seleção vencido	\nOlá {Gestor Seleção},\nGostaríamos de informar que o candidato {nome} encontra-se no processo de seleção além do máximo considerado.\n\nGentileza, verificar. \n\nAbs,\nBruno
\.


--
-- Name: notificacoes_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('notificacoes_email_id_seq', 14, true);


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
47199	\N	1	2016-05-21 17:19:53.707	1	Em Andamento	\N
47200	47199	2	2016-05-21 17:20:08.607	1	\N	\N
47201	47200	3	2016-05-21 17:20:08.612	1	Em Andamento	\N
47202	47200	3	2016-05-21 17:20:08.92	1	Em Andamento	\N
47204	47203	3	2016-05-21 17:21:07.403	1	Em Andamento	\N
47205	47203	3	2016-05-21 17:21:07.709	1	Em Andamento	\N
47203	47199	2	2016-05-21 17:21:07.399	1	Em Andamento	\N
47207	47206	3	2016-05-22 01:33:05.342	1	Em Andamento	\N
47208	47206	3	2016-05-22 01:33:05.64	1	Em Andamento	\N
47206	47199	2	2016-05-22 01:33:05.339	1	Em Andamento	\N
47210	47209	3	2016-05-22 01:34:37.854	1	Em Andamento	\N
47211	47209	3	2016-05-22 01:34:38.159	1	Em Andamento	\N
47209	47199	2	2016-05-22 01:34:37.846	1	Em Andamento	\N
47213	47212	3	2016-05-22 01:36:50.56	1	Em Andamento	\N
47214	47212	3	2016-05-22 01:36:50.878	1	Em Andamento	\N
47216	47215	3	2016-05-22 01:37:03.846	1	Em Andamento	\N
47217	47215	3	2016-05-22 01:37:04.146	1	Em Andamento	\N
47212	47199	2	2016-05-22 01:36:50.555	1	Em Andamento	\N
47215	47199	2	2016-05-22 01:37:03.841	1	Em Andamento	\N
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 47217, true);


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
-- Data for Name: sla; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sla (id, nomeregra, idnotificacao, tabela, sla_emhorascorridas, campo_calculado, campo_localizador, valor_localizador, where_tabela) FROM stdin;
41	Tempo no posto Roteamento	8	workflow_tramitacao wt	1	wt.inicio	wt.id	4	wt.fim is null and wt.idworkflowposto = 4
46	Tempo no Posto Negociar com COnsultoria	9	workflow_tramitacao wt	1	wt.inicio	wt.id	8	wt.fim is null and wt.idworkflowposto = 8
45	Tempo no Posto Entrevistados	10	workflow_tramitacao wt	1	wt.inicio	wt.id	6	wt.fim is null and wt.idworkflowposto = 6
44	Tempo no Posto Entrevista Presencial	11	workflow_tramitacao wt	1	wt.inicio	wt.id	5	wt.fim is null and wt.idworkflowposto = 5
42	Tempo no Posto Primeira Avaliação	12	workflow_tramitacao wt	1	wt.inicio	wt.id	3	wt.fim is null and wt.idworkflowposto = 3
43	Tempo no Posto Segunda Avaliação	12	workflow_tramitacao wt	1	wt.inicio	wt.id	287	wt.fim is null and wt.idworkflowposto = 287
39	Tempo no Posto Onboarding	13	workflow_tramitacao wt	1	wt.inicio	wt.id	7	wt.fim is null and wt.idworkflowposto = 7
40	Tempo máximo de Candidatura	14	processos p	1	p.inicio	p.id		p.status IN (null,   'Em Andamento') and p.idtipoprocesso = 2
\.


--
-- Name: sla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_id_seq', 46, true);


--
-- Data for Name: sla_notificacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sla_notificacoes (id, idsla, datanotificacao, chave) FROM stdin;
378	40	2016-05-21 17:22:48.742	47203
379	40	2016-05-21 17:24:26.721	47203
380	41	2016-05-21 17:24:26.728	2378
381	42	2016-05-21 17:24:26.73	2374
382	43	2016-05-21 17:24:26.732	2375
383	40	2016-05-22 00:32:11.979	47203
384	41	2016-05-22 00:32:11.987	2378
385	42	2016-05-22 00:32:11.989	2374
386	43	2016-05-22 00:32:11.991	2375
387	41	2016-05-22 00:47:46.602	2378
388	42	2016-05-22 00:47:46.614	2374
389	43	2016-05-22 00:47:46.615	2375
390	40	2016-05-22 00:47:46.618	47203
391	41	2016-05-22 01:10:10.592	2378
392	42	2016-05-22 01:10:10.604	2374
393	43	2016-05-22 01:10:10.61	2375
394	40	2016-05-22 01:10:10.618	47203
395	41	2016-05-22 01:11:32.366	2378
396	42	2016-05-22 01:11:32.379	2374
397	43	2016-05-22 01:11:32.385	2375
398	40	2016-05-22 01:11:32.391	47203
399	41	2016-05-22 01:12:36.258	2378
400	42	2016-05-22 01:12:36.274	2374
401	43	2016-05-22 01:12:36.287	2375
402	40	2016-05-22 01:12:36.3	47203
403	41	2016-05-22 01:13:51.848	2378
404	42	2016-05-22 01:13:51.864	2374
405	43	2016-05-22 01:13:51.877	2375
406	40	2016-05-22 01:13:51.889	47203
407	41	2016-05-22 01:17:36.907	2378
408	42	2016-05-22 01:17:36.926	2374
409	43	2016-05-22 01:17:36.94	2375
410	40	2016-05-22 01:17:36.954	47203
411	41	2016-05-22 01:19:23.751	2378
412	42	2016-05-22 01:19:23.765	2374
413	43	2016-05-22 01:19:23.778	2375
414	40	2016-05-22 01:19:23.79	47203
415	41	2016-05-22 01:20:52.038	2378
416	42	2016-05-22 01:20:52.057	2374
417	43	2016-05-22 01:20:52.069	2375
418	40	2016-05-22 01:20:52.086	47203
419	41	2016-05-22 01:23:07.209	2378
420	42	2016-05-22 01:23:07.224	2374
421	43	2016-05-22 01:23:07.237	2375
422	40	2016-05-22 01:23:07.25	47203
423	41	2016-05-22 01:24:10.515	2378
424	42	2016-05-22 01:24:10.534	2374
425	43	2016-05-22 01:24:10.547	2375
426	40	2016-05-22 01:24:10.563	47203
427	41	2016-05-22 01:25:18.978	2378
428	42	2016-05-22 01:25:18.997	2374
429	43	2016-05-22 01:25:19.009	2375
430	40	2016-05-22 01:25:19.023	47203
431	41	2016-05-22 01:26:37.942	2378
432	42	2016-05-22 01:26:37.958	2374
433	43	2016-05-22 01:26:37.969	2375
434	40	2016-05-22 01:26:37.983	47203
435	41	2016-05-22 01:29:38.388	2378
436	42	2016-05-22 01:29:38.403	2374
437	43	2016-05-22 01:29:38.415	2375
438	40	2016-05-22 01:29:38.428	47203
439	41	2016-05-22 01:31:54.711	2378
440	42	2016-05-22 01:31:54.73	2374
441	43	2016-05-22 01:31:54.742	2375
442	40	2016-05-22 01:31:54.753	47203
443	41	2016-05-22 01:33:06.633	2378
444	42	2016-05-22 01:33:06.651	2374
445	43	2016-05-22 01:33:06.663	2375
446	40	2016-05-22 01:33:06.679	47203
447	40	2016-05-22 01:34:05.919	47206
448	41	2016-05-22 01:34:09.154	2378
449	42	2016-05-22 01:34:09.173	2374
450	43	2016-05-22 01:34:09.189	2375
451	40	2016-05-22 01:34:09.206	47203
452	44	2016-05-22 01:35:07.547	2382
453	40	2016-05-22 01:35:07.596	47206
454	41	2016-05-22 01:35:10.234	2378
455	42	2016-05-22 01:35:10.271	2374
456	43	2016-05-22 01:35:10.288	2375
457	40	2016-05-22 01:35:10.305	47203
458	40	2016-05-22 01:35:38.391	47209
459	41	2016-05-22 01:36:14.301	2378
460	44	2016-05-22 01:36:14.316	2382
461	42	2016-05-22 01:36:14.328	2374
462	43	2016-05-22 01:36:14.341	2375
463	40	2016-05-22 01:36:14.353	47203
464	40	2016-05-22 01:36:14.363	47206
465	40	2016-05-22 01:36:38.781	47209
466	41	2016-05-22 01:37:18.304	2378
467	44	2016-05-22 01:37:18.321	2382
468	42	2016-05-22 01:37:18.334	2374
469	43	2016-05-22 01:37:18.346	2375
470	40	2016-05-22 01:37:18.358	47203
471	40	2016-05-22 01:37:18.369	47206
472	39	2016-05-22 01:37:23.83	2389
473	40	2016-05-22 01:37:43.399	47209
474	43	2016-05-22 01:37:52.921	2391
475	43	2016-05-22 01:38:08.687	2393
476	41	2016-05-22 01:38:20.698	2378
477	44	2016-05-22 01:38:20.714	2382
478	42	2016-05-22 01:38:20.729	2374
479	43	2016-05-22 01:38:20.746	2375
480	40	2016-05-22 01:38:20.81	47203
481	40	2016-05-22 01:38:20.824	47206
482	39	2016-05-22 01:38:32.11	2389
483	40	2016-05-22 01:38:45.134	47209
484	40	2016-05-22 01:38:45.145	47212
485	40	2016-05-22 01:39:04.13	47215
486	41	2016-05-22 01:39:22.889	2378
487	44	2016-05-22 01:39:22.907	2382
488	42	2016-05-22 01:39:22.92	2374
489	43	2016-05-22 01:39:22.932	2375
490	40	2016-05-22 01:39:22.958	47203
491	40	2016-05-22 01:39:22.971	47206
492	39	2016-05-22 01:39:33.003	2389
493	40	2016-05-22 01:39:46.062	47209
494	40	2016-05-22 01:39:46.083	47212
495	40	2016-05-22 01:40:08.245	47215
496	41	2016-05-22 01:40:23.186	2378
497	44	2016-05-22 01:40:23.205	2382
498	42	2016-05-22 01:40:23.217	2374
499	43	2016-05-22 01:40:23.229	2375
500	40	2016-05-22 01:40:23.254	47203
501	40	2016-05-22 01:40:23.263	47206
502	41	2016-05-22 01:42:42.75	2378
503	46	2016-05-22 01:42:42.764	2398
504	45	2016-05-22 01:42:42.775	2400
505	44	2016-05-22 01:42:42.787	2382
506	42	2016-05-22 01:42:42.799	2374
507	43	2016-05-22 01:42:42.811	2375
508	39	2016-05-22 01:42:42.823	2389
509	40	2016-05-22 01:42:42.834	47203
510	40	2016-05-22 01:42:42.844	47206
511	40	2016-05-22 01:42:42.854	47209
512	40	2016-05-22 01:42:42.863	47212
513	40	2016-05-22 01:42:42.872	47215
514	41	2016-05-22 01:45:49.605	2378
515	46	2016-05-22 01:45:49.622	2398
516	45	2016-05-22 01:45:49.634	2400
517	44	2016-05-22 01:45:49.646	2382
518	42	2016-05-22 01:45:49.658	2374
519	43	2016-05-22 01:45:49.67	2375
520	39	2016-05-22 01:45:49.683	2389
521	40	2016-05-22 01:45:49.694	47203
522	40	2016-05-22 01:45:49.704	47206
523	40	2016-05-22 01:45:49.713	47209
524	40	2016-05-22 01:45:49.722	47212
525	40	2016-05-22 01:45:49.732	47215
526	41	2016-05-22 01:47:46.968	2378
527	46	2016-05-22 01:47:46.994	2398
528	45	2016-05-22 01:47:47.011	2400
529	44	2016-05-22 01:47:47.029	2382
530	42	2016-05-22 01:47:47.044	2374
531	43	2016-05-22 01:47:47.06	2375
532	39	2016-05-22 01:47:47.073	2389
533	40	2016-05-22 01:47:47.086	47203
534	40	2016-05-22 01:47:47.097	47206
535	40	2016-05-22 01:47:47.111	47209
536	40	2016-05-22 01:47:47.123	47212
537	40	2016-05-22 01:47:47.135	47215
538	41	2016-05-22 01:50:47.5	2378
539	46	2016-05-22 01:50:47.518	2398
540	45	2016-05-22 01:50:47.53	2400
541	44	2016-05-22 01:50:47.542	2382
542	42	2016-05-22 01:50:47.554	2374
543	43	2016-05-22 01:50:47.567	2375
544	39	2016-05-22 01:50:47.579	2389
545	40	2016-05-22 01:50:47.591	47203
546	40	2016-05-22 01:50:47.6	47206
547	40	2016-05-22 01:50:47.61	47209
548	40	2016-05-22 01:50:47.62	47212
549	40	2016-05-22 01:50:47.63	47215
\.


--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_notificacoes_id_seq', 549, true);


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
5152	13	Gestão de Desenvolvimento	47199	2016-05-21 17:19:53.714	1
5153	174	enunciando de gestao	47199	2016-05-21 17:19:53.714	1
5154	1	5 anos em gestao de pessoas e desenvolvimento	47199	2016-05-21 17:19:53.715	1
5155	11	Bruno Siqueira	47200	2016-05-21 17:20:08.61	273
5156	12	php	47200	2016-05-21 17:20:08.61	273
5157	2	hub	47200	2016-05-21 17:20:08.611	273
5158	166	associado	47200	2016-05-21 17:20:08.611	273
5159	11	Olivetti	47203	2016-05-21 17:21:07.401	273
5160	12	tecnologia	47203	2016-05-21 17:21:07.402	273
5161	2	github	47203	2016-05-21 17:21:07.402	273
5162	166	consultoria	47203	2016-05-21 17:21:07.403	273
5163	4	Sr	47204	2016-05-21 17:22:08.161	274
5164	10	parece do dev	47204	2016-05-21 17:22:08.167	274
5165	180	pl	47205	2016-05-21 17:22:48.024	288
5166	181	parecer dev2	47205	2016-05-21 17:22:48.027	288
5167	11	candidato entrevista presencial	47206	2016-05-22 01:33:05.34	273
5168	12	tecnologia	47206	2016-05-22 01:33:05.341	273
5169	2	github	47206	2016-05-22 01:33:05.341	273
5170	166	consultoria	47206	2016-05-22 01:33:05.341	273
5171	180	sr	47208	2016-05-22 01:33:32.379	288
5172	181	sss	47208	2016-05-22 01:33:32.382	288
5173	4	jr	47207	2016-05-22 01:33:43.722	274
5174	10	xxxx	47207	2016-05-22 01:33:43.728	274
5175	5	Paffi	47206	2016-05-22 01:34:04.892	275
5176	11	candidato onboarding	47209	2016-05-22 01:34:37.852	273
5177	12	tec	47209	2016-05-22 01:34:37.853	273
5178	2	git	47209	2016-05-22 01:34:37.853	273
5179	166	cons	47209	2016-05-22 01:34:37.853	273
5180	4	go	47210	2016-05-22 01:35:06.847	274
5181	10	o	47210	2016-05-22 01:35:06.849	274
5182	180	xxxx	47211	2016-05-22 01:35:32.062	288
5183	181	xsxax	47211	2016-05-22 01:35:32.069	288
5184	172	xxxxcc	47209	2016-05-22 01:35:49.656	286
5185	171	tsttt	47209	2016-05-22 01:35:58.271	284
5186	177	email@email.com	47209	2016-05-22 01:36:13.317	279
5187	9	kksksmz	47209	2016-05-22 01:36:13.321	279
5188	171	ddd	47209	2016-05-22 01:36:22.92	284
5189	11	negociar c consultoria	47212	2016-05-22 01:36:50.558	273
5190	12		47212	2016-05-22 01:36:50.559	273
5191	2		47212	2016-05-22 01:36:50.559	273
5192	166		47212	2016-05-22 01:36:50.559	273
5193	11	entrevistadooo ccc	47215	2016-05-22 01:37:03.844	273
5194	12		47215	2016-05-22 01:37:03.844	273
5195	2		47215	2016-05-22 01:37:03.845	273
5196	166		47215	2016-05-22 01:37:03.845	273
5197	4	xx	47213	2016-05-22 01:37:33.037	274
5198	10	xxx	47213	2016-05-22 01:37:33.042	274
5199	4	dsadas	47216	2016-05-22 01:37:56.054	274
5200	10	dada	47216	2016-05-22 01:37:56.061	274
5201	180	DSada	47214	2016-05-22 01:38:44.32	288
5202	181	sdsa	47214	2016-05-22 01:38:44.323	288
5203	180	ccc	47217	2016-05-22 01:39:03.319	288
5204	181	ccc	47217	2016-05-22 01:39:03.325	288
5205	5	gest-inter	47212	2016-05-22 01:39:31.952	275
5206	6	cxcx	47212	2016-05-22 01:39:45	276
5207	7	cdcsc	47212	2016-05-22 01:39:54.696	277
5208	5	paffiiii	47215	2016-05-22 01:40:07.137	275
5209	6	xsaxsaa	47215	2016-05-22 01:40:20.603	276
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 5209, true);


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

COPY workflow_tramitacao (id, idprocesso, idworkflowposto, inicio, fim, id_usuario_associado) FROM stdin;
2372	47199	1	2016-05-21 17:19:53.716	2016-05-21 17:19:53.716	\N
2373	47199	2	2016-05-21 17:19:53.741	\N	\N
2374	47201	3	2016-05-21 17:20:08.613	\N	3
2375	47202	287	2016-05-21 17:20:08.922	\N	3
2376	47204	3	2016-05-21 17:21:07.405	2016-05-21 17:22:08.168	6
2377	47205	287	2016-05-21 17:21:07.711	2016-05-21 17:22:48.028	5
2378	47203	4	2016-05-21 17:22:48.045	\N	\N
2380	47208	287	2016-05-22 01:33:05.641	2016-05-22 01:33:32.382	3
2379	47207	3	2016-05-22 01:33:05.344	2016-05-22 01:33:43.729	3
2382	47206	5	2016-05-22 01:34:04.898	\N	\N
2381	47206	4	2016-05-22 01:33:43.745	2016-05-22 01:34:04.914	\N
2383	47210	3	2016-05-22 01:34:37.856	2016-05-22 01:35:06.85	5
2384	47211	287	2016-05-22 01:34:38.161	2016-05-22 01:35:32.07	3
2385	47209	4	2016-05-22 01:35:32.087	2016-05-22 01:35:49.672	\N
2386	47209	280	2016-05-22 01:35:49.66	2016-05-22 01:35:58.287	\N
2387	47209	7	2016-05-22 01:35:58.275	2016-05-22 01:36:13.336	\N
2389	47209	7	2016-05-22 01:36:22.926	\N	\N
2388	47209	280	2016-05-22 01:36:13.323	2016-05-22 01:36:22.938	\N
2390	47213	3	2016-05-22 01:36:50.562	2016-05-22 01:37:33.043	7
2392	47216	3	2016-05-22 01:37:03.847	2016-05-22 01:37:56.062	5
2391	47214	287	2016-05-22 01:36:50.879	2016-05-22 01:38:44.323	6
2393	47217	287	2016-05-22 01:37:04.148	2016-05-22 01:39:03.326	3
2394	47212	4	2016-05-22 01:38:44.339	2016-05-22 01:39:31.975	\N
2396	47212	5	2016-05-22 01:39:31.959	2016-05-22 01:39:45.016	\N
2398	47212	8	2016-05-22 01:39:54.7	\N	\N
2397	47212	6	2016-05-22 01:39:45.004	2016-05-22 01:39:54.716	\N
2395	47215	4	2016-05-22 01:39:03.341	2016-05-22 01:40:07.163	\N
2400	47215	6	2016-05-22 01:40:20.61	\N	\N
2399	47215	5	2016-05-22 01:40:07.144	2016-05-22 01:40:20.622	\N
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 2400, true);


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

