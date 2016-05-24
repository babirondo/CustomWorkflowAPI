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
    p_bisavo.id AS bisavo
   FROM (((processos p
     LEFT JOIN processos p_filhos ON ((p_filhos.idpai = p.id)))
     LEFT JOIN processos p_avo ON ((p_avo.id = p.idpai)))
     LEFT JOIN processos p_bisavo ON ((p_bisavo.id = p_avo.idpai)));


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
-- Name: tecnologias; Type: TABLE; Schema: public; Owner: postgres
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
15	devcontrat@walmart.com	{usuario_associado}	[Processo de Contratação] SLA Vencido da Avalição do candidato {nome}	Olá {usuario_associado},\nGostaríamos de solicitar que você avaliasse o candidato {nome} o mais rapido possível. O SLA padrão desta atividade já foi rompido.
16	devcontrat@walmart.com	diretorzao...	[Processo de Contratação] Escalonamento: Posto de Primeira avaliação	Olá {diretor},\nGostaríamos de pedir sua ajuda, o teste do candidato {nome} continua no mesmo posto a {temponoposto} dias e já foi escalado para {usuarioassociado}.
17	devcontrar@walmart.com	gerente	[Processo de Contratação] Escalonamento, candidato {nome} atingiu tempo máximo no processo	Olá {Gestor Seleção}, O candidato {nome} do processo {idprocesso} atingiu o tempo máximo no processo.
18	devcontrat@walmart.com	diretor	[Processo de Contratação] Escalonamento, nível 2, candidato {nome} a muito tmepo no processo.	Olá {diretor},\nGostaríamos de pedir sua ajuda, o candidato {nome} continua no processo a {temponoposto} dias e já foi escalado para {usuarioassociado}. Precisamos encerrar sua vida no processo.
\.


--
-- Name: notificacoes_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('notificacoes_email_id_seq', 18, true);


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

COPY sla (id, nomeregra, idnotificacao, tabela, sla_emhorascorridas, campo_calculado, campo_localizador, valor_localizador, where_tabela, idpai) FROM stdin;
41	Tempo no posto Roteamento	8	workflow_tramitacao wt	1	wt.inicio	wt.id	4	wt.fim is null and wt.idworkflowposto = 4	\N
46	Tempo no Posto Negociar com COnsultoria	9	workflow_tramitacao wt	1	wt.inicio	wt.id	8	wt.fim is null and wt.idworkflowposto = 8	\N
45	Tempo no Posto Entrevistados	10	workflow_tramitacao wt	1	wt.inicio	wt.id	6	wt.fim is null and wt.idworkflowposto = 6	\N
44	Tempo no Posto Entrevista Presencial	11	workflow_tramitacao wt	1	wt.inicio	wt.id	5	wt.fim is null and wt.idworkflowposto = 5	\N
42	Tempo no Posto Primeira Avaliação	12	workflow_tramitacao wt	1	wt.inicio	wt.id	3	wt.fim is null and wt.idworkflowposto = 3	\N
43	Tempo no Posto Segunda Avaliação	12	workflow_tramitacao wt	1	wt.inicio	wt.id	287	wt.fim is null and wt.idworkflowposto = 287	\N
39	Tempo no Posto Onboarding	13	workflow_tramitacao wt	1	wt.inicio	wt.id	7	wt.fim is null and wt.idworkflowposto = 7	\N
40	Tempo máximo de Candidatura	14	processos p	1	p.inicio	p.id		p.status IN (null,   'Em Andamento') and p.idtipoprocesso = 2	\N
48	Escalonamento, nível 2, posto Primeira Avaliação	16	sla_notificacoes sn	1	sn.datanotificacao	sn.chave	\N	\N	47
47	Escalonamento, nível 1, posto Primeira Avaliação	15	sla_notificacoes sn	1	sn.datanotificacao	sn.chave	\N	\N	42
49	Escalonamento, nível 1, Tempo máximo de candidatura	17	sla_notificacoes sn 	1	sn.datanotificacao	sn.chave	\N	\N	40
50	Escalonamento nível 2, tempo máximo de processo do candidato	18	sla_notificacoes sn	1	sn.datanotificacao	sn.chave	\N	\N	49
\.


--
-- Name: sla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_id_seq', 50, true);


--
-- Data for Name: sla_notificacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sla_notificacoes (id, idsla, datanotificacao, chave) FROM stdin;
669	41	2016-05-24 01:06:03.232602	2378
670	46	2016-05-24 01:06:03.23829	2398
671	45	2016-05-24 01:06:03.243916	2400
672	44	2016-05-24 01:06:03.248843	2382
673	42	2016-05-24 01:06:03.253843	2374
674	43	2016-05-24 01:06:03.259885	2375
675	39	2016-05-24 01:06:03.26713	2389
676	40	2016-05-24 01:06:03.276599	47203
677	40	2016-05-24 01:06:03.285536	47206
678	40	2016-05-24 01:06:03.310442	47209
679	40	2016-05-24 01:06:03.320363	47212
680	40	2016-05-24 01:06:03.325868	47215
681	41	2016-05-24 01:07:05.261718	2378
682	46	2016-05-24 01:07:05.266853	2398
683	45	2016-05-24 01:07:05.273766	2400
684	44	2016-05-24 01:07:05.278534	2382
685	42	2016-05-24 01:07:05.283253	2374
686	43	2016-05-24 01:07:05.288045	2375
687	39	2016-05-24 01:07:05.293614	2389
688	40	2016-05-24 01:07:05.300884	47203
689	40	2016-05-24 01:07:05.307238	47206
690	40	2016-05-24 01:07:05.317273	47209
691	40	2016-05-24 01:07:05.323982	47212
692	40	2016-05-24 01:07:05.33236	47215
693	41	2016-05-24 01:08:06.677791	2378
694	46	2016-05-24 01:08:06.683283	2398
695	45	2016-05-24 01:08:06.688315	2400
696	44	2016-05-24 01:08:06.693311	2382
697	42	2016-05-24 01:08:06.698394	2374
698	43	2016-05-24 01:08:06.703553	2375
699	39	2016-05-24 01:08:06.708459	2389
700	40	2016-05-24 01:08:06.716527	47203
701	40	2016-05-24 01:08:06.72394	47206
702	40	2016-05-24 01:08:06.733338	47209
703	40	2016-05-24 01:08:06.753518	47212
704	40	2016-05-24 01:08:06.758848	47215
705	48	2016-05-24 01:08:06.767007	2374
706	47	2016-05-24 01:08:06.776539	2374
707	41	2016-05-24 01:12:37.370994	2378
708	46	2016-05-24 01:12:37.376315	2398
709	45	2016-05-24 01:12:37.381551	2400
710	44	2016-05-24 01:12:37.386688	2382
711	42	2016-05-24 01:12:37.391475	2374
712	43	2016-05-24 01:12:37.396453	2375
713	39	2016-05-24 01:12:37.402155	2389
714	40	2016-05-24 01:12:37.41039	47203
715	40	2016-05-24 01:12:37.416043	47206
716	40	2016-05-24 01:12:37.4264	47209
717	40	2016-05-24 01:12:37.433752	47212
718	40	2016-05-24 01:12:37.442293	47215
719	48	2016-05-24 01:12:37.449266	2374
720	47	2016-05-24 01:12:37.455663	2374
721	41	2016-05-24 01:21:17.602067	2378
722	46	2016-05-24 01:21:17.609028	2398
723	45	2016-05-24 01:21:17.615991	2400
724	44	2016-05-24 01:21:17.622778	2382
725	42	2016-05-24 01:21:17.629003	2374
726	43	2016-05-24 01:21:17.640961	2375
727	39	2016-05-24 01:21:17.655193	2389
728	40	2016-05-24 01:21:17.677081	47203
729	40	2016-05-24 01:21:17.696705	47206
730	40	2016-05-24 01:21:17.70179	47209
731	40	2016-05-24 01:21:17.706117	47212
732	40	2016-05-24 01:21:17.710425	47215
733	41	2016-05-24 01:31:50.01347	2378
734	46	2016-05-24 01:31:50.020063	2398
735	45	2016-05-24 01:31:50.026623	2400
736	44	2016-05-24 01:31:50.033097	2382
737	42	2016-05-24 01:31:50.039087	2374
738	43	2016-05-24 01:31:50.048078	2375
739	39	2016-05-24 01:31:50.0613	2389
740	40	2016-05-24 01:31:50.083443	47203
741	40	2016-05-24 01:31:50.102719	47206
742	40	2016-05-24 01:31:50.107543	47209
743	40	2016-05-24 01:31:50.111886	47212
744	40	2016-05-24 01:31:50.116561	47215
745	48	2016-05-24 01:31:50.122631	2374
746	47	2016-05-24 01:31:50.128068	2374
747	41	2016-05-24 01:33:05.006174	2378
748	46	2016-05-24 01:33:05.012974	2398
749	45	2016-05-24 01:33:05.019282	2400
750	44	2016-05-24 01:33:05.025724	2382
751	42	2016-05-24 01:33:05.032185	2374
752	43	2016-05-24 01:33:05.041363	2375
753	39	2016-05-24 01:33:05.055233	2389
754	40	2016-05-24 01:33:05.065687	47203
755	40	2016-05-24 01:33:05.072203	47206
756	40	2016-05-24 01:33:05.076911	47209
757	40	2016-05-24 01:33:05.082106	47212
758	40	2016-05-24 01:33:05.086855	47215
759	48	2016-05-24 01:33:05.095425	2374
760	47	2016-05-24 01:33:05.102919	2374
761	41	2016-05-24 01:37:15.859608	2378
762	46	2016-05-24 01:37:15.866495	2398
763	45	2016-05-24 01:37:15.873073	2400
764	44	2016-05-24 01:37:15.879161	2382
765	42	2016-05-24 01:37:15.886995	2374
766	43	2016-05-24 01:37:15.896637	2375
767	39	2016-05-24 01:37:15.909807	2389
768	40	2016-05-24 01:37:15.931415	47203
769	40	2016-05-24 01:37:15.953386	47209
770	40	2016-05-24 01:37:15.957876	47212
771	40	2016-05-24 01:37:15.962214	47215
772	40	2016-05-24 01:37:15.967665	47206
773	48	2016-05-24 01:37:15.97361	2382
774	48	2016-05-24 01:37:15.979067	47212
775	48	2016-05-24 01:37:15.984427	2389
776	48	2016-05-24 01:37:15.989833	47206
777	48	2016-05-24 01:37:15.995022	2375
778	48	2016-05-24 01:37:16.001136	2378
779	48	2016-05-24 01:37:16.00667	2374
780	48	2016-05-24 01:37:16.012035	47203
781	48	2016-05-24 01:37:16.01734	47215
782	48	2016-05-24 01:37:16.023098	2398
783	48	2016-05-24 01:37:16.028398	2400
784	48	2016-05-24 01:37:16.034503	47209
785	47	2016-05-24 01:37:16.043119	2382
786	47	2016-05-24 01:37:16.054501	47212
787	47	2016-05-24 01:37:16.059628	2389
788	47	2016-05-24 01:37:16.065694	47206
789	47	2016-05-24 01:37:16.071487	2375
790	47	2016-05-24 01:37:16.076427	2378
791	47	2016-05-24 01:37:16.083622	2374
792	47	2016-05-24 01:37:16.093752	47203
793	47	2016-05-24 01:37:16.102729	47215
794	47	2016-05-24 01:37:16.11226	2398
795	47	2016-05-24 01:37:16.127655	2400
796	47	2016-05-24 01:37:16.135089	47209
797	41	2016-05-24 01:38:27.517736	2378
798	46	2016-05-24 01:38:27.524393	2398
799	45	2016-05-24 01:38:27.531572	2400
800	44	2016-05-24 01:38:27.537999	2382
801	42	2016-05-24 01:38:27.54418	2374
802	43	2016-05-24 01:38:27.553103	2375
803	39	2016-05-24 01:38:27.563568	2389
804	40	2016-05-24 01:38:27.574132	47203
805	40	2016-05-24 01:38:27.581041	47209
806	40	2016-05-24 01:38:27.586115	47212
807	40	2016-05-24 01:38:27.590732	47215
808	40	2016-05-24 01:38:27.596055	47206
809	48	2016-05-24 01:38:27.602254	2382
810	48	2016-05-24 01:38:27.610187	47212
811	48	2016-05-24 01:38:27.616318	2389
812	48	2016-05-24 01:38:27.621465	47206
813	48	2016-05-24 01:38:27.627399	2375
814	48	2016-05-24 01:38:27.633492	2378
815	48	2016-05-24 01:38:27.63886	2374
816	48	2016-05-24 01:38:27.645207	47203
817	48	2016-05-24 01:38:27.650598	47215
818	48	2016-05-24 01:38:27.656049	2398
819	48	2016-05-24 01:38:27.66154	2400
820	48	2016-05-24 01:38:27.666931	47209
821	47	2016-05-24 01:38:27.672957	2382
822	47	2016-05-24 01:38:27.679474	47212
823	47	2016-05-24 01:38:27.684493	2389
824	47	2016-05-24 01:38:27.689549	47206
825	47	2016-05-24 01:38:27.69529	2375
826	47	2016-05-24 01:38:27.700495	2378
827	47	2016-05-24 01:38:27.707018	2374
828	47	2016-05-24 01:38:27.715141	47203
829	47	2016-05-24 01:38:27.724294	47215
830	47	2016-05-24 01:38:27.731904	2398
831	47	2016-05-24 01:38:27.736799	2400
832	47	2016-05-24 01:38:27.741872	47209
833	48	2016-05-24 01:40:12.252563	2382
834	48	2016-05-24 01:40:12.260197	47212
835	48	2016-05-24 01:40:12.267013	2389
836	48	2016-05-24 01:40:12.27333	47206
837	48	2016-05-24 01:40:12.282644	2375
838	48	2016-05-24 01:40:12.29625	2378
839	48	2016-05-24 01:40:12.306634	2374
840	48	2016-05-24 01:40:12.316116	47203
841	48	2016-05-24 01:40:12.32647	47215
842	48	2016-05-24 01:40:12.333397	2398
843	48	2016-05-24 01:40:12.340249	2400
844	48	2016-05-24 01:40:12.347343	47209
845	47	2016-05-24 01:40:12.354763	2382
846	47	2016-05-24 01:40:12.361612	47212
847	47	2016-05-24 01:40:12.368349	2389
848	47	2016-05-24 01:40:12.37527	47206
849	47	2016-05-24 01:40:12.382624	2375
850	47	2016-05-24 01:40:12.38964	2378
851	47	2016-05-24 01:40:12.397477	2374
852	47	2016-05-24 01:40:12.405199	47203
853	47	2016-05-24 01:40:12.413607	47215
854	47	2016-05-24 01:40:12.424851	2398
855	47	2016-05-24 01:40:12.433004	2400
856	47	2016-05-24 01:40:12.440463	47209
857	48	2016-05-24 01:43:36.337197	47215
858	47	2016-05-24 01:43:36.347525	47215
859	48	2016-05-24 01:44:48.160501	47215
860	47	2016-05-24 01:44:48.16758	47215
861	49	2016-05-24 01:45:09.489114	47215
862	48	2016-05-24 01:45:58.264537	47215
863	47	2016-05-24 01:45:58.273975	47215
864	49	2016-05-24 01:46:30.512001	47215
865	48	2016-05-24 01:47:30.614351	47215
866	47	2016-05-24 01:47:30.621853	47215
867	49	2016-05-24 01:47:30.628687	47215
868	48	2016-05-24 01:48:50.962397	47215
869	47	2016-05-24 01:48:50.969607	47215
870	49	2016-05-24 01:49:13.774297	47215
871	48	2016-05-24 01:52:03.509566	47215
872	47	2016-05-24 01:52:03.516568	47215
873	49	2016-05-24 01:52:03.521435	47215
874	50	2016-05-24 01:52:51.527945	47215
\.


--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_notificacoes_id_seq', 874, true);


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

