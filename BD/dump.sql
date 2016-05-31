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
1	rodrigues@simonsen.br	rodrigues@simonsen.br	[Walmart.com] Abertura de Vaga - Processo Seletivo #{idprocesso}	Olá,\nComunicamos de abertura de nova vaga, Processo Seletivo #{idprocesso}.\n\nJob Description: {1}\nTipo de Vaga: {13}\n\t\t\nLembramos que: \n1 - Os candidatos que atenderem as exigências da vaga deverão executar o teste abaixo, em caráter eliminatório.\nhttp://www. github.com. aihua/ teste blabla\n\t\t\n2 - Toda a comunicação a respeito de um candidato deve preservar o número do Processo Seletivo.\n\n3 - Somente serão considerados os candidatos com teste concluído e data de resposta de no máximo um mês a partir deste email.\n\t\t\nAtenciosamente, \nEquipe de Contratação de Desenvolvedores\ndevcontrat@walmart.com
4	devcontrat@walmart.com	{5}	[Processo de Contratacão] Entrevista Candidato: {11}	{5},\n\nFavor entrevista o candidato {11} o mais rapido possivel, caso ele nao se encaixe no perfil que voce deseja outro gestor poderia considera-lo\n\n\nAtenciosamente,\nEquipe de Contratacão de Desenvolvedores 
16	devcontrat@walmart.com	diretor@walmart	[Processo de Contratação] Escalonamento: Posto de Primeira avaliação	Olá,\nGostaríamos de pedir sua ajuda, o teste do candidato {11} continua no mesmo posto desde {entradanoposto} e já foi escalado para {usuarioassociado}.
12	devcontrat@walmart.com	{usuarioassociado}	[Processo de Contratação] Avaliação do Teste	\nOlá {usuarioassociado},\nGostaríamos de informar que o SLA de Avaliação do Teste Técnico, especificamente do candidato {11} referente ao processo seletivo {idprocesso} encontra-se vencido.\n\nGentileza, verificar ASAP.\n\nAbs,\nBruno
18	devcontrat@walmart.com	diretor@walmart	[Processo de Contratação] Escalonamento, nível 2, candidato {11} a muito tmepo no processo.	Olá,\nGostaríamos de pedir sua ajuda, o candidato {11} está no processo desde {inicioprocesso} e já foi escalado para {gestorselecao}. Precisamos encerrar sua vida no processo.
3	devcontrat@walmart.com	{atoresdoposto}	[Processo de Contratação] Candidato pronto para Roteamento - {12}:{4}	Gestores, \nExiste um novo candidato pronto para ser entrevistado.\n\nProcesso Seletivo: {idprocesso}\nNome do Candidato: {11}\n\nAtenciosamente, \nEquipe de Contratação de Desenvolvedores\ndevcontrat@walmart.com\n
8	devcontrat@walmart.com	devcontrat@walmart.com	[Processo de Contratação] SLA Vencido, Posto Roteamento	Olá,\n\nO SLA do posto foi vencido e solicitamos que o roteamento dos candidatos aprovados seja logo realizado.
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
179	287	Parecer da Classificação dos Devs	1	\N	textarea	90	10
180	288	senioridade	\N	\N	\N	\N	\N
181	288	Parecer da Classificação dos Devs	1	\N	textarea	90	10
3	273	cv	\N	\N	file	\N	\N
182	273	Tecnologias que domina	1	\N	textarea	45	4
12	273	Tecnologia que o candidato fez o teste	\N	\N	\N	\N	\N
\.


--
-- Name: postos_campo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_id_seq', 182, true);


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
\.


--
-- Name: postos_campo_lista_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_lista_id_seq', 81, true);


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
47213	47212	3	2016-05-22 01:36:50.56	1	Em Andamento	\N
47214	47212	3	2016-05-22 01:36:50.878	1	Em Andamento	\N
47216	47215	3	2016-05-22 01:37:03.846	1	Em Andamento	\N
47217	47215	3	2016-05-22 01:37:04.146	1	Em Andamento	\N
47212	47199	2	2016-05-22 01:36:50.555	1	Em Andamento	\N
47215	47199	2	2016-05-22 01:37:03.841	1	Em Andamento	\N
47209	47199	2	2016-05-22 01:34:37.846	1	Em Andamento	\N
47258	47199	2	2016-05-25 01:11:07.341471	1	\N	\N
47218	\N	1	2016-05-25 00:41:20.733692	1	Em Andamento	\N
47219	\N	1	2016-05-25 00:41:30.923312	1	Em Andamento	\N
47259	47258	3	2016-05-25 01:11:07.344358	1	Em Andamento	\N
47220	\N	1	2016-05-25 00:43:08.570953	1	Em Andamento	\N
47221	\N	1	2016-05-25 00:43:55.154186	1	Em Andamento	\N
47260	47258	3	2016-05-25 01:11:07.383247	1	Em Andamento	\N
47222	\N	1	2016-05-25 00:44:37.893519	1	Em Andamento	\N
47261	47199	2	2016-05-25 01:15:30.732204	1	\N	\N
47223	\N	1	2016-05-25 00:44:50.522505	1	Em Andamento	\N
47224	\N	1	2016-05-25 00:45:13.663201	1	Em Andamento	\N
47262	47261	3	2016-05-25 01:15:30.734797	1	Em Andamento	\N
47225	\N	1	2016-05-25 00:45:19.933338	1	Em Andamento	\N
47226	\N	1	2016-05-25 00:45:27.240196	1	Em Andamento	\N
47263	47261	3	2016-05-25 01:15:30.774092	1	Em Andamento	\N
47227	\N	1	2016-05-25 00:47:04.268255	1	Em Andamento	\N
47264	47199	2	2016-05-25 01:15:51.22205	1	\N	\N
47228	\N	1	2016-05-25 00:48:11.273879	1	Em Andamento	\N
47229	\N	1	2016-05-25 00:48:38.393957	1	Em Andamento	\N
47265	47264	3	2016-05-25 01:15:51.224873	1	Em Andamento	\N
47230	\N	1	2016-05-25 00:51:26.717438	1	Em Andamento	\N
47231	\N	1	2016-05-25 00:51:35.502453	1	Em Andamento	\N
47266	47264	3	2016-05-25 01:15:51.254124	1	Em Andamento	\N
47232	\N	1	2016-05-25 00:53:39.375019	1	Em Andamento	\N
47267	47199	2	2016-05-25 01:15:59.427635	1	\N	\N
47233	\N	1	2016-05-25 00:53:43.246241	1	Em Andamento	\N
47234	\N	1	2016-05-25 00:54:20.204296	1	Em Andamento	\N
47268	47267	3	2016-05-25 01:15:59.43039	1	Em Andamento	\N
47235	\N	1	2016-05-25 00:54:56.300501	1	Em Andamento	\N
47236	\N	1	2016-05-25 00:55:32.534316	1	Em Andamento	\N
47237	47199	2	2016-05-25 00:55:55.202837	1	\N	\N
47238	47237	3	2016-05-25 00:55:55.205901	1	Em Andamento	\N
47239	47237	3	2016-05-25 00:55:55.239888	1	Em Andamento	\N
47240	47199	2	2016-05-25 00:56:48.28596	1	\N	\N
47241	47240	3	2016-05-25 00:56:48.343583	1	Em Andamento	\N
47242	47240	3	2016-05-25 00:56:48.37795	1	Em Andamento	\N
47243	47199	2	2016-05-25 00:57:35.334159	1	\N	\N
47244	47243	3	2016-05-25 00:57:35.33739	1	Em Andamento	\N
47245	47243	3	2016-05-25 00:57:35.370707	1	Em Andamento	\N
47269	47267	3	2016-05-25 01:15:59.454994	1	Em Andamento	\N
47246	\N	1	2016-05-25 00:58:49.958754	1	Em Andamento	\N
47247	47199	2	2016-05-25 00:58:52.280698	1	\N	\N
47248	47247	3	2016-05-25 00:58:52.283555	1	Em Andamento	\N
47249	47247	3	2016-05-25 00:58:52.322754	1	Em Andamento	\N
47250	47199	2	2016-05-25 01:05:06.597706	1	\N	\N
47251	47250	3	2016-05-25 01:05:06.600874	1	Em Andamento	\N
47252	47250	3	2016-05-25 01:05:06.634912	1	Em Andamento	\N
47253	47199	2	2016-05-25 01:05:20.19021	1	\N	\N
47254	47253	3	2016-05-25 01:05:20.193439	1	Em Andamento	\N
47255	47253	3	2016-05-25 01:05:20.229701	1	Em Andamento	\N
47257	47256	3	2016-05-25 01:06:26.338265	1	\N	\N
47270	47199	2	2016-05-25 01:18:11.424579	1	\N	\N
47271	47270	3	2016-05-25 01:18:11.431828	1	Em Andamento	\N
47272	47270	3	2016-05-25 01:18:11.465351	1	Em Andamento	\N
47273	47199	2	2016-05-25 01:18:14.193948	1	\N	\N
47274	47273	3	2016-05-25 01:18:14.197011	1	Em Andamento	\N
47275	47273	3	2016-05-25 01:18:14.231705	1	Em Andamento	\N
47276	47199	2	2016-05-25 01:18:29.124242	1	\N	\N
47277	47276	3	2016-05-25 01:18:29.12757	1	\N	\N
47278	47199	2	2016-05-25 01:18:33.67886	1	\N	\N
47279	47278	3	2016-05-25 01:18:33.681574	1	\N	\N
47280	47199	2	2016-05-25 01:22:07.23126	1	\N	\N
47281	47280	3	2016-05-25 01:22:07.234354	1	\N	\N
47282	47199	2	2016-05-25 01:22:29.136307	1	\N	\N
47283	47282	3	2016-05-25 01:22:29.139696	1	Em Andamento	\N
47284	47282	3	2016-05-25 01:22:29.173403	1	Em Andamento	\N
47285	47199	2	2016-05-25 01:22:55.865355	1	\N	\N
47286	47285	3	2016-05-25 01:22:55.868448	1	Em Andamento	\N
47287	47285	3	2016-05-25 01:22:55.907248	1	Em Andamento	\N
47288	47199	2	2016-05-25 01:28:41.889756	1	\N	\N
47289	47288	3	2016-05-25 01:28:41.892861	1	\N	\N
47290	47199	2	2016-05-25 01:28:53.560411	1	\N	\N
47291	47290	3	2016-05-25 01:28:53.563624	1	\N	\N
47292	47199	2	2016-05-25 01:30:54.586453	1	\N	\N
47293	47292	3	2016-05-25 01:30:54.589722	1	Em Andamento	\N
47294	47292	3	2016-05-25 01:30:54.623857	1	Em Andamento	\N
47295	47199	2	2016-05-25 01:31:01.549502	1	\N	\N
47296	47295	3	2016-05-25 01:31:01.552596	1	Em Andamento	\N
47297	47295	3	2016-05-25 01:31:01.586052	1	Em Andamento	\N
47298	47199	2	2016-05-25 01:31:04.310486	1	\N	\N
47299	47298	3	2016-05-25 01:31:04.313351	1	Em Andamento	\N
47300	47298	3	2016-05-25 01:31:04.346457	1	Em Andamento	\N
47301	47199	2	2016-05-25 01:31:22.431421	1	\N	\N
47302	47301	3	2016-05-25 01:31:22.451821	1	Em Andamento	\N
47303	47301	3	2016-05-25 01:31:22.491741	1	Em Andamento	\N
47304	47199	2	2016-05-25 01:31:25.516112	1	\N	\N
47305	47304	3	2016-05-25 01:31:25.531305	1	Em Andamento	\N
47306	47304	3	2016-05-25 01:31:25.568324	1	Em Andamento	\N
47307	47199	2	2016-05-25 01:32:02.17033	1	\N	\N
47308	47307	3	2016-05-25 01:32:02.173028	1	Em Andamento	\N
47309	47307	3	2016-05-25 01:32:02.207904	1	Em Andamento	\N
47310	47199	2	2016-05-25 01:32:56.430495	1	\N	\N
47256	47199	2	2016-05-25 01:06:26.330941	1	Em Andamento	\N
47311	47310	3	2016-05-25 01:32:56.433274	1	Em Andamento	\N
47312	47310	3	2016-05-25 01:32:56.468786	1	Em Andamento	\N
47313	47199	2	2016-05-25 01:33:16.23734	1	\N	\N
47314	47313	3	2016-05-25 01:33:16.24066	1	Em Andamento	\N
47315	47313	3	2016-05-25 01:33:16.275508	1	Em Andamento	\N
47316	47199	2	2016-05-25 01:33:28.038526	1	\N	\N
47317	47316	3	2016-05-25 01:33:28.041736	1	Em Andamento	\N
47318	47316	3	2016-05-25 01:33:28.077888	1	Em Andamento	\N
47319	47199	2	2016-05-25 01:34:30.101133	1	\N	\N
47320	47319	3	2016-05-25 01:34:30.104477	1	Em Andamento	\N
47321	47319	3	2016-05-25 01:34:30.137912	1	Em Andamento	\N
47322	47199	2	2016-05-25 01:35:09.998035	1	\N	\N
47323	47322	3	2016-05-25 01:35:10.000752	1	Em Andamento	\N
47324	47322	3	2016-05-25 01:35:10.033809	1	Em Andamento	\N
47325	47199	2	2016-05-25 01:38:40.989364	1	\N	\N
47326	47325	3	2016-05-25 01:38:40.992265	1	Em Andamento	\N
47327	47325	3	2016-05-25 01:38:41.031143	1	Em Andamento	\N
47328	47199	2	2016-05-25 01:38:49.653239	1	\N	\N
47329	47328	3	2016-05-25 01:38:49.656451	1	Em Andamento	\N
47330	47328	3	2016-05-25 01:38:49.690952	1	Em Andamento	\N
47331	47199	2	2016-05-25 01:41:11.994702	1	\N	\N
47332	47331	3	2016-05-25 01:41:11.997433	1	Em Andamento	\N
47333	47331	3	2016-05-25 01:41:12.032955	1	Em Andamento	\N
47334	47199	2	2016-05-25 01:41:22.150369	1	\N	\N
47335	47334	3	2016-05-25 01:41:22.153348	1	Em Andamento	\N
47336	47334	3	2016-05-25 01:41:22.187446	1	Em Andamento	\N
47337	47199	2	2016-05-25 01:41:25.430829	1	\N	\N
47338	47337	3	2016-05-25 01:41:25.434177	1	Em Andamento	\N
47339	47337	3	2016-05-25 01:41:25.469418	1	Em Andamento	\N
47341	47340	3	2016-05-25 01:48:11.403972	1	Em Andamento	\N
47342	47340	3	2016-05-25 01:48:11.438354	1	Em Andamento	\N
47340	47199	2	2016-05-25 01:48:11.40089	1	Em Andamento	\N
47344	47343	3	2016-05-30 22:13:10.013844	1	Em Andamento	\N
47345	47343	3	2016-05-30 22:13:10.080994	1	Em Andamento	\N
47343	47199	2	2016-05-30 22:13:09.987544	1	Em Andamento	\N
47346	\N	1	2016-05-30 23:28:33.524587	1	Em Andamento	\N
47348	47347	3	2016-05-30 23:29:10.838435	1	Em Andamento	\N
47349	47347	3	2016-05-30 23:29:10.870625	1	Em Andamento	\N
47351	47350	3	2016-05-30 23:36:29.148183	1	Em Andamento	\N
47352	47350	3	2016-05-30 23:36:29.180774	1	Em Andamento	\N
47347	47346	2	2016-05-30 23:29:10.83515	1	Em Andamento	\N
47350	47346	2	2016-05-30 23:36:29.144721	1	Em Andamento	\N
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 47352, true);


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
2133	41	2016-05-25 00:30:51.62802	2378
2134	46	2016-05-25 00:30:51.633479	2398
2135	45	2016-05-25 00:30:51.638809	2400
2136	44	2016-05-25 00:30:51.644552	2382
2137	42	2016-05-25 00:30:51.649728	2374
2138	43	2016-05-25 00:30:51.656717	2375
2139	40	2016-05-25 00:30:51.664994	47203
2140	40	2016-05-25 00:30:51.673077	47212
2141	40	2016-05-25 00:30:51.682578	47215
2142	40	2016-05-25 00:30:51.68916	47209
2143	40	2016-05-25 00:30:51.700625	47206
2144	41	2016-05-25 00:31:56.447833	2378
2145	46	2016-05-25 00:31:56.453652	2398
2146	45	2016-05-25 00:31:56.458691	2400
2147	44	2016-05-25 00:31:56.463957	2382
2148	42	2016-05-25 00:31:56.468924	2374
2149	43	2016-05-25 00:31:56.476349	2375
2150	40	2016-05-25 00:31:56.484283	47203
2151	40	2016-05-25 00:31:56.494505	47212
2152	40	2016-05-25 00:31:56.501883	47215
2153	40	2016-05-25 00:31:56.51032	47209
2154	40	2016-05-25 00:31:56.515006	47206
2155	49	2016-05-25 00:31:56.524774	47209
2156	49	2016-05-25 00:31:56.529523	47203
2157	49	2016-05-25 00:31:56.536598	47212
2158	49	2016-05-25 00:31:56.543163	47215
2159	49	2016-05-25 00:31:56.548042	47206
2160	47	2016-05-25 00:31:56.554801	2374
2161	41	2016-05-25 00:33:10.339384	2378
2162	46	2016-05-25 00:33:10.346853	2398
2163	45	2016-05-25 00:33:10.352406	2400
2164	44	2016-05-25 00:33:10.357363	2382
2165	42	2016-05-25 00:33:10.363927	2374
2166	43	2016-05-25 00:33:10.369952	2375
2167	40	2016-05-25 00:33:10.377213	47203
2168	40	2016-05-25 00:33:10.385526	47212
2169	40	2016-05-25 00:33:10.39709	47215
2170	40	2016-05-25 00:33:10.403056	47209
2171	40	2016-05-25 00:33:10.409529	47206
2172	49	2016-05-25 00:33:10.420164	47209
2173	49	2016-05-25 00:33:10.425873	47203
2174	49	2016-05-25 00:33:10.431075	47212
2175	49	2016-05-25 00:33:10.435865	47215
2176	49	2016-05-25 00:33:10.440467	47206
2177	48	2016-05-25 00:33:10.447476	2374
2178	50	2016-05-25 00:33:10.453012	47209
2179	50	2016-05-25 00:33:10.458171	47203
2180	50	2016-05-25 00:33:10.464159	47212
2181	50	2016-05-25 00:33:10.469506	47215
2182	50	2016-05-25 00:33:10.474554	47206
2183	47	2016-05-25 00:33:10.483846	2374
2184	41	2016-05-25 00:34:29.803977	2378
2185	46	2016-05-25 00:34:29.809743	2398
2186	45	2016-05-25 00:34:29.815009	2400
2187	44	2016-05-25 00:34:29.820729	2382
2188	42	2016-05-25 00:34:29.82617	2374
2189	43	2016-05-25 00:34:29.832465	2375
2190	40	2016-05-25 00:34:29.839141	47203
2191	40	2016-05-25 00:34:29.845971	47212
2192	40	2016-05-25 00:34:29.857751	47215
2193	40	2016-05-25 00:34:29.865094	47209
2194	40	2016-05-25 00:34:29.870608	47206
2195	49	2016-05-25 00:34:29.87646	47209
2196	49	2016-05-25 00:34:29.881493	47203
2197	49	2016-05-25 00:34:29.887148	47212
2198	49	2016-05-25 00:34:29.894333	47215
2199	49	2016-05-25 00:34:29.898757	47206
2200	48	2016-05-25 00:34:29.905247	2374
2201	50	2016-05-25 00:34:29.910701	47209
2202	50	2016-05-25 00:34:29.915835	47203
2203	50	2016-05-25 00:34:29.921988	47212
2204	50	2016-05-25 00:34:29.928512	47215
2205	50	2016-05-25 00:34:29.93441	47206
2206	47	2016-05-25 00:34:29.941223	2374
2207	41	2016-05-25 00:37:08.386773	2378
2208	46	2016-05-25 00:37:08.392878	2398
2209	45	2016-05-25 00:37:08.399354	2400
2210	44	2016-05-25 00:37:08.404377	2382
2211	42	2016-05-25 00:37:08.412265	2374
2212	43	2016-05-25 00:37:08.41934	2375
2213	40	2016-05-25 00:37:08.431959	47203
2214	40	2016-05-25 00:37:08.438622	47212
2215	40	2016-05-25 00:37:08.446285	47215
2216	40	2016-05-25 00:37:08.451796	47209
2217	40	2016-05-25 00:37:08.457558	47206
2218	49	2016-05-25 00:37:08.465743	47209
2219	49	2016-05-25 00:37:08.471566	47203
2220	49	2016-05-25 00:37:08.48019	47212
2221	49	2016-05-25 00:37:08.48589	47215
2222	49	2016-05-25 00:37:08.49044	47206
2223	48	2016-05-25 00:37:08.497661	2374
2224	50	2016-05-25 00:37:08.504572	47209
2225	50	2016-05-25 00:37:08.525913	47203
2226	50	2016-05-25 00:37:08.546879	47212
2227	50	2016-05-25 00:37:08.552719	47215
2228	50	2016-05-25 00:37:08.558093	47206
2229	47	2016-05-25 00:37:08.564446	2374
2230	41	2016-05-25 00:38:12.46236	2378
2231	46	2016-05-25 00:38:12.46777	2398
2232	45	2016-05-25 00:38:12.473544	2400
2233	44	2016-05-25 00:38:12.478754	2382
2234	42	2016-05-25 00:38:12.483644	2374
2235	43	2016-05-25 00:38:12.488816	2375
2236	40	2016-05-25 00:38:12.494238	47203
2237	40	2016-05-25 00:38:12.49864	47212
2238	40	2016-05-25 00:38:12.502679	47215
2239	40	2016-05-25 00:38:12.507205	47209
2240	40	2016-05-25 00:38:12.511287	47206
2241	49	2016-05-25 00:38:12.516262	47209
2242	49	2016-05-25 00:38:12.520517	47203
2243	49	2016-05-25 00:38:12.525696	47212
2244	49	2016-05-25 00:38:12.530263	47215
2245	49	2016-05-25 00:38:12.534466	47206
2246	48	2016-05-25 00:38:12.543856	2374
2247	50	2016-05-25 00:38:12.551126	47209
2248	50	2016-05-25 00:38:12.561822	47203
2249	50	2016-05-25 00:38:12.576779	47212
2250	50	2016-05-25 00:38:12.597626	47215
2251	50	2016-05-25 00:38:12.618181	47206
2252	47	2016-05-25 00:38:12.64139	2374
2253	41	2016-05-25 00:39:22.462491	2378
2254	46	2016-05-25 00:39:22.483055	2398
2255	45	2016-05-25 00:39:22.490608	2400
2256	44	2016-05-25 00:39:22.496255	2382
2257	42	2016-05-25 00:39:22.50193	2374
2258	43	2016-05-25 00:39:22.507875	2375
2259	40	2016-05-25 00:39:22.514029	47203
2260	40	2016-05-25 00:39:22.518703	47212
2261	40	2016-05-25 00:39:22.524041	47215
2262	40	2016-05-25 00:39:22.529176	47209
2263	40	2016-05-25 00:39:22.53366	47206
2264	49	2016-05-25 00:39:22.540555	47209
2265	49	2016-05-25 00:39:22.545991	47203
2266	49	2016-05-25 00:39:22.550974	47212
2267	49	2016-05-25 00:39:22.55753	47215
2268	49	2016-05-25 00:39:22.578938	47206
2269	48	2016-05-25 00:39:22.600397	2374
2270	50	2016-05-25 00:39:22.606533	47209
2271	50	2016-05-25 00:39:22.611503	47203
2272	50	2016-05-25 00:39:22.616871	47212
2273	50	2016-05-25 00:39:22.622157	47215
2274	50	2016-05-25 00:39:22.627337	47206
2275	47	2016-05-25 00:39:22.634713	2374
2276	41	2016-05-25 00:41:10.3801	2378
2277	46	2016-05-25 00:41:10.385988	2398
2278	45	2016-05-25 00:41:10.391588	2400
2279	44	2016-05-25 00:41:10.396935	2382
2280	42	2016-05-25 00:41:10.402181	2374
2281	43	2016-05-25 00:41:10.407268	2375
2282	40	2016-05-25 00:41:10.412661	47203
2283	40	2016-05-25 00:41:10.416991	47212
2284	40	2016-05-25 00:41:10.421045	47215
2285	40	2016-05-25 00:41:10.425658	47209
2286	40	2016-05-25 00:41:10.429751	47206
2287	49	2016-05-25 00:41:10.435147	47209
2288	49	2016-05-25 00:41:10.439285	47203
2289	49	2016-05-25 00:41:10.443706	47212
2290	49	2016-05-25 00:41:10.449127	47215
2291	49	2016-05-25 00:41:10.454236	47206
2292	48	2016-05-25 00:41:10.460189	2374
2293	50	2016-05-25 00:41:10.465572	47209
2294	50	2016-05-25 00:41:10.470979	47203
2295	50	2016-05-25 00:41:10.476045	47212
2296	50	2016-05-25 00:41:10.480811	47215
2297	50	2016-05-25 00:41:10.486096	47206
2298	47	2016-05-25 00:41:10.491877	2374
2299	41	2016-05-25 00:44:50.632306	2378
2300	46	2016-05-25 00:44:50.638279	2398
2301	45	2016-05-25 00:44:50.644051	2400
2302	44	2016-05-25 00:44:50.649064	2382
2303	42	2016-05-25 00:44:50.654089	2374
2304	43	2016-05-25 00:44:50.659387	2375
2305	40	2016-05-25 00:44:50.664892	47203
2306	40	2016-05-25 00:44:50.669283	47212
2307	40	2016-05-25 00:44:50.673402	47215
2308	40	2016-05-25 00:44:50.67735	47209
2309	40	2016-05-25 00:44:50.681211	47206
2310	49	2016-05-25 00:44:50.686279	47209
2311	49	2016-05-25 00:44:50.691024	47203
2312	49	2016-05-25 00:44:50.695352	47212
2313	49	2016-05-25 00:44:50.699684	47215
2314	49	2016-05-25 00:44:50.703889	47206
2315	48	2016-05-25 00:44:50.709561	2374
2316	50	2016-05-25 00:44:50.714962	47209
2317	50	2016-05-25 00:44:50.719518	47203
2318	50	2016-05-25 00:44:50.726137	47212
2319	50	2016-05-25 00:44:50.731914	47215
2320	50	2016-05-25 00:44:50.736632	47206
2321	47	2016-05-25 00:44:50.743191	2374
2322	41	2016-05-25 00:47:04.381949	2378
2323	46	2016-05-25 00:47:04.388331	2398
2324	45	2016-05-25 00:47:04.393565	2400
2325	44	2016-05-25 00:47:04.398549	2382
2326	42	2016-05-25 00:47:04.403768	2374
2327	43	2016-05-25 00:47:04.409013	2375
2328	40	2016-05-25 00:47:04.414852	47203
2329	40	2016-05-25 00:47:04.41924	47212
2330	40	2016-05-25 00:47:04.423773	47215
2331	40	2016-05-25 00:47:04.427955	47209
2332	40	2016-05-25 00:47:04.432609	47206
2333	49	2016-05-25 00:47:04.437989	47209
2334	49	2016-05-25 00:47:04.44221	47203
2335	49	2016-05-25 00:47:04.446527	47212
2336	49	2016-05-25 00:47:04.450808	47215
2337	49	2016-05-25 00:47:04.456961	47206
2338	48	2016-05-25 00:47:04.463047	2374
2339	50	2016-05-25 00:47:04.46804	47209
2340	50	2016-05-25 00:47:04.473279	47203
2341	50	2016-05-25 00:47:04.477995	47212
2342	50	2016-05-25 00:47:04.482211	47215
2343	50	2016-05-25 00:47:04.486914	47206
2344	47	2016-05-25 00:47:04.49235	2374
2345	41	2016-05-25 00:48:11.389449	2378
2346	46	2016-05-25 00:48:11.395882	2398
2347	45	2016-05-25 00:48:11.401576	2400
2348	44	2016-05-25 00:48:11.406815	2382
2349	42	2016-05-25 00:48:11.412914	2374
2350	43	2016-05-25 00:48:11.417928	2375
2351	40	2016-05-25 00:48:11.423244	47203
2352	40	2016-05-25 00:48:11.427897	47212
2353	40	2016-05-25 00:48:11.431997	47215
2354	40	2016-05-25 00:48:11.436452	47209
2355	40	2016-05-25 00:48:11.44042	47206
2356	49	2016-05-25 00:48:11.446746	47209
2357	49	2016-05-25 00:48:11.451967	47203
2358	49	2016-05-25 00:48:11.456378	47212
2359	49	2016-05-25 00:48:11.461377	47215
2360	49	2016-05-25 00:48:11.465699	47206
2361	48	2016-05-25 00:48:11.471298	2374
2362	50	2016-05-25 00:48:11.476455	47209
2363	50	2016-05-25 00:48:11.481781	47203
2364	50	2016-05-25 00:48:11.486412	47212
2365	50	2016-05-25 00:48:11.490698	47215
2366	50	2016-05-25 00:48:11.496153	47206
2367	47	2016-05-25 00:48:11.501743	2374
2368	41	2016-05-25 00:51:26.828854	2378
2369	46	2016-05-25 00:51:26.834655	2398
2370	45	2016-05-25 00:51:26.839895	2400
2371	44	2016-05-25 00:51:26.845386	2382
2372	42	2016-05-25 00:51:26.85048	2374
2373	43	2016-05-25 00:51:26.855745	2375
2374	40	2016-05-25 00:51:26.861123	47203
2375	40	2016-05-25 00:51:26.86515	47212
2376	40	2016-05-25 00:51:26.869065	47215
2377	40	2016-05-25 00:51:26.873159	47209
2378	40	2016-05-25 00:51:26.877393	47206
2379	49	2016-05-25 00:51:26.882536	47209
2380	49	2016-05-25 00:51:26.886777	47203
2381	49	2016-05-25 00:51:26.891169	47212
2382	49	2016-05-25 00:51:26.895551	47215
2383	49	2016-05-25 00:51:26.899925	47206
2384	48	2016-05-25 00:51:26.905539	2374
2385	50	2016-05-25 00:51:26.910429	47209
2386	50	2016-05-25 00:51:26.915927	47203
2387	50	2016-05-25 00:51:26.920517	47212
2388	50	2016-05-25 00:51:26.924905	47215
2389	50	2016-05-25 00:51:26.929647	47206
2390	47	2016-05-25 00:51:26.934924	2374
2391	41	2016-05-25 00:53:39.504285	2378
2392	46	2016-05-25 00:53:39.525586	2398
2393	45	2016-05-25 00:53:39.531869	2400
2394	44	2016-05-25 00:53:39.537591	2382
2395	42	2016-05-25 00:53:39.543454	2374
2396	43	2016-05-25 00:53:39.549163	2375
2397	40	2016-05-25 00:53:39.554633	47203
2398	40	2016-05-25 00:53:39.558889	47212
2399	40	2016-05-25 00:53:39.563865	47215
2400	40	2016-05-25 00:53:39.568342	47209
2401	40	2016-05-25 00:53:39.572395	47206
2402	49	2016-05-25 00:53:39.577824	47209
2403	49	2016-05-25 00:53:39.582548	47203
2404	49	2016-05-25 00:53:39.586764	47212
2405	49	2016-05-25 00:53:39.590963	47215
2406	49	2016-05-25 00:53:39.595387	47206
2407	48	2016-05-25 00:53:39.602437	2374
2408	50	2016-05-25 00:53:39.607887	47209
2409	50	2016-05-25 00:53:39.613642	47203
2410	50	2016-05-25 00:53:39.619603	47212
2411	50	2016-05-25 00:53:39.624879	47215
2412	50	2016-05-25 00:53:39.630042	47206
2413	47	2016-05-25 00:53:39.635548	2374
2414	41	2016-05-25 00:54:56.408617	2378
2415	46	2016-05-25 00:54:56.414871	2398
2416	45	2016-05-25 00:54:56.42026	2400
2417	44	2016-05-25 00:54:56.425694	2382
2418	42	2016-05-25 00:54:56.431128	2374
2419	43	2016-05-25 00:54:56.436831	2375
2420	40	2016-05-25 00:54:56.4423	47203
2421	40	2016-05-25 00:54:56.446945	47212
2422	40	2016-05-25 00:54:56.451289	47215
2423	40	2016-05-25 00:54:56.460663	47209
2424	40	2016-05-25 00:54:56.466222	47206
2425	49	2016-05-25 00:54:56.471727	47209
2426	49	2016-05-25 00:54:56.476207	47203
2427	49	2016-05-25 00:54:56.48121	47212
2428	49	2016-05-25 00:54:56.485561	47215
2429	49	2016-05-25 00:54:56.489755	47206
2430	48	2016-05-25 00:54:56.495901	2374
2431	50	2016-05-25 00:54:56.501326	47209
2432	50	2016-05-25 00:54:56.505662	47203
2433	50	2016-05-25 00:54:56.510039	47212
2434	50	2016-05-25 00:54:56.51568	47215
2435	50	2016-05-25 00:54:56.520204	47206
2436	47	2016-05-25 00:54:56.525798	2374
2437	41	2016-05-25 00:56:48.520112	2378
2438	46	2016-05-25 00:56:48.526326	2398
2439	45	2016-05-25 00:56:48.533068	2400
2440	44	2016-05-25 00:56:48.539925	2382
2441	42	2016-05-25 00:56:48.545851	2374
2442	43	2016-05-25 00:56:48.551735	2375
2443	40	2016-05-25 00:56:48.557672	47203
2444	40	2016-05-25 00:56:48.562517	47212
2445	40	2016-05-25 00:56:48.567461	47215
2446	40	2016-05-25 00:56:48.572428	47209
2447	40	2016-05-25 00:56:48.577035	47206
2448	49	2016-05-25 00:56:48.583216	47209
2449	49	2016-05-25 00:56:48.588323	47203
2450	49	2016-05-25 00:56:48.593445	47212
2451	49	2016-05-25 00:56:48.598753	47215
2452	49	2016-05-25 00:56:48.603615	47206
2453	48	2016-05-25 00:56:48.615368	2374
2454	50	2016-05-25 00:56:48.632034	47209
2455	50	2016-05-25 00:56:48.638637	47203
2456	50	2016-05-25 00:56:48.644381	47212
2457	50	2016-05-25 00:56:48.650331	47215
2458	50	2016-05-25 00:56:48.655788	47206
2459	47	2016-05-25 00:56:48.662656	2374
2460	42	2016-05-25 00:57:35.535586	2440
2461	43	2016-05-25 00:57:35.546665	2441
2462	41	2016-05-25 00:59:30.756346	2378
2463	46	2016-05-25 00:59:30.762502	2398
2464	45	2016-05-25 00:59:30.768917	2400
2465	44	2016-05-25 00:59:30.774381	2382
2466	42	2016-05-25 00:59:30.780838	2374
2467	42	2016-05-25 00:59:30.785583	2440
2468	42	2016-05-25 00:59:30.790389	2442
2469	42	2016-05-25 00:59:30.795231	2444
2470	43	2016-05-25 00:59:30.800339	2443
2471	43	2016-05-25 00:59:30.805369	2445
2472	43	2016-05-25 00:59:30.810692	2375
2473	43	2016-05-25 00:59:30.815728	2441
2474	40	2016-05-25 00:59:30.821429	47203
2475	40	2016-05-25 00:59:30.825716	47212
2476	40	2016-05-25 00:59:30.830038	47215
2477	40	2016-05-25 00:59:30.834706	47209
2478	40	2016-05-25 00:59:30.854855	47206
2479	49	2016-05-25 00:59:30.875614	47209
2480	49	2016-05-25 00:59:30.880566	47203
2481	49	2016-05-25 00:59:30.885062	47212
2482	49	2016-05-25 00:59:30.889701	47215
2483	49	2016-05-25 00:59:30.895257	47206
2484	48	2016-05-25 00:59:30.901492	2374
2485	50	2016-05-25 00:59:30.906475	47209
2486	50	2016-05-25 00:59:30.911362	47203
2487	50	2016-05-25 00:59:30.916096	47212
2488	50	2016-05-25 00:59:30.920823	47215
2489	50	2016-05-25 00:59:30.925675	47206
2490	47	2016-05-25 00:59:30.931247	2440
2491	47	2016-05-25 00:59:30.936222	2374
2492	41	2016-05-25 01:04:57.544529	2378
2493	46	2016-05-25 01:04:57.550726	2398
2494	45	2016-05-25 01:04:57.556071	2400
2495	44	2016-05-25 01:04:57.561196	2382
2496	42	2016-05-25 01:04:57.566563	2374
2497	42	2016-05-25 01:04:57.571178	2440
2498	42	2016-05-25 01:04:57.575719	2442
2499	42	2016-05-25 01:04:57.580317	2448
2500	42	2016-05-25 01:04:57.585409	2444
2501	43	2016-05-25 01:04:57.590376	2443
2502	43	2016-05-25 01:04:57.595146	2449
2503	43	2016-05-25 01:04:57.600889	2445
2504	43	2016-05-25 01:04:57.605871	2375
2505	43	2016-05-25 01:04:57.611015	2441
2506	40	2016-05-25 01:04:57.616967	47203
2507	40	2016-05-25 01:04:57.62141	47212
2508	40	2016-05-25 01:04:57.625705	47215
2509	40	2016-05-25 01:04:57.63036	47209
2510	40	2016-05-25 01:04:57.634665	47206
2511	49	2016-05-25 01:04:57.640021	47209
2512	49	2016-05-25 01:04:57.644481	47203
2513	49	2016-05-25 01:04:57.649064	47212
2514	49	2016-05-25 01:04:57.653962	47215
2515	49	2016-05-25 01:04:57.658179	47206
2516	48	2016-05-25 01:04:57.663756	2374
2517	48	2016-05-25 01:04:57.66919	2440
2518	50	2016-05-25 01:04:57.674398	47209
2519	50	2016-05-25 01:04:57.679092	47203
2520	50	2016-05-25 01:04:57.684348	47212
2521	50	2016-05-25 01:04:57.690054	47215
2522	50	2016-05-25 01:04:57.694996	47206
2523	47	2016-05-25 01:04:57.701099	2444
2524	47	2016-05-25 01:04:57.707381	2440
2525	47	2016-05-25 01:04:57.7135	2374
2526	47	2016-05-25 01:04:57.718813	2442
2527	41	2016-05-25 01:15:51.369257	2378
2528	46	2016-05-25 01:15:51.37543	2398
2529	45	2016-05-25 01:15:51.380689	2400
2530	44	2016-05-25 01:15:51.386076	2382
2531	42	2016-05-25 01:15:51.391132	2444
2532	42	2016-05-25 01:15:51.396111	2448
2533	42	2016-05-25 01:15:51.401035	2450
2534	42	2016-05-25 01:15:51.405732	2452
2535	42	2016-05-25 01:15:51.41067	2455
2536	42	2016-05-25 01:15:51.415623	2454
2537	42	2016-05-25 01:15:51.420462	2374
2538	42	2016-05-25 01:15:51.42543	2440
2539	42	2016-05-25 01:15:51.430142	2442
2540	43	2016-05-25 01:15:51.435065	2443
2541	43	2016-05-25 01:15:51.439881	2449
2542	43	2016-05-25 01:15:51.445586	2375
2543	43	2016-05-25 01:15:51.450418	2445
2544	43	2016-05-25 01:15:51.455102	2453
2545	43	2016-05-25 01:15:51.459861	2441
2546	43	2016-05-25 01:15:51.464605	2456
2547	43	2016-05-25 01:15:51.469767	2451
2548	40	2016-05-25 01:15:51.475857	47203
2549	40	2016-05-25 01:15:51.480704	47212
2550	40	2016-05-25 01:15:51.484805	47215
2551	40	2016-05-25 01:15:51.488921	47209
2552	40	2016-05-25 01:15:51.493319	47206
2553	49	2016-05-25 01:15:51.49889	47209
2554	49	2016-05-25 01:15:51.503273	47203
2555	49	2016-05-25 01:15:51.508491	47212
2556	49	2016-05-25 01:15:51.513206	47215
2557	49	2016-05-25 01:15:51.517922	47206
2558	48	2016-05-25 01:15:51.523381	2444
2559	48	2016-05-25 01:15:51.529075	2440
2560	48	2016-05-25 01:15:51.534231	2374
2561	48	2016-05-25 01:15:51.539413	2442
2562	50	2016-05-25 01:15:51.544799	47209
2563	50	2016-05-25 01:15:51.549356	47203
2564	50	2016-05-25 01:15:51.554009	47212
2565	50	2016-05-25 01:15:51.55949	47215
2566	50	2016-05-25 01:15:51.564222	47206
2567	47	2016-05-25 01:15:51.569378	2440
2568	47	2016-05-25 01:15:51.574328	2374
2569	47	2016-05-25 01:15:51.579439	2442
2570	47	2016-05-25 01:15:51.584977	2444
2571	47	2016-05-25 01:15:51.590082	2448
2572	41	2016-05-25 01:18:14.373481	2378
2573	46	2016-05-25 01:18:14.380466	2398
2574	45	2016-05-25 01:18:14.387162	2400
2575	44	2016-05-25 01:18:14.393489	2382
2576	42	2016-05-25 01:18:14.399437	2461
2577	42	2016-05-25 01:18:14.405584	2444
2578	42	2016-05-25 01:18:14.410902	2448
2579	42	2016-05-25 01:18:14.416683	2450
2580	42	2016-05-25 01:18:14.422503	2452
2581	42	2016-05-25 01:18:14.428027	2455
2582	42	2016-05-25 01:18:14.433566	2454
2583	42	2016-05-25 01:18:14.439419	2374
2584	42	2016-05-25 01:18:14.445099	2440
2585	42	2016-05-25 01:18:14.450842	2442
2586	42	2016-05-25 01:18:14.456725	2457
2587	42	2016-05-25 01:18:14.465355	2459
2588	43	2016-05-25 01:18:14.474643	2462
2589	43	2016-05-25 01:18:14.483194	2460
2590	43	2016-05-25 01:18:14.491736	2445
2591	43	2016-05-25 01:18:14.498293	2453
2592	43	2016-05-25 01:18:14.504617	2441
2593	43	2016-05-25 01:18:14.511092	2456
2594	43	2016-05-25 01:18:14.516203	2451
2595	43	2016-05-25 01:18:14.521778	2443
2596	43	2016-05-25 01:18:14.526872	2449
2597	43	2016-05-25 01:18:14.5319	2375
2598	43	2016-05-25 01:18:14.537189	2458
2599	40	2016-05-25 01:18:14.542567	47203
2600	40	2016-05-25 01:18:14.546956	47212
2601	40	2016-05-25 01:18:14.551938	47215
2602	40	2016-05-25 01:18:14.557318	47209
2603	40	2016-05-25 01:18:14.56177	47206
2604	49	2016-05-25 01:18:14.567541	47209
2605	49	2016-05-25 01:18:14.572828	47203
2606	49	2016-05-25 01:18:14.577331	47212
2607	49	2016-05-25 01:18:14.581688	47215
2608	49	2016-05-25 01:18:14.586519	47206
2609	48	2016-05-25 01:18:14.592037	2444
2610	48	2016-05-25 01:18:14.597109	2448
2611	48	2016-05-25 01:18:14.602488	2440
2612	48	2016-05-25 01:18:14.607788	2374
2613	48	2016-05-25 01:18:14.61296	2442
2614	50	2016-05-25 01:18:14.618766	47209
2615	50	2016-05-25 01:18:14.62351	47203
2616	50	2016-05-25 01:18:14.628259	47212
2617	50	2016-05-25 01:18:14.633118	47215
2618	50	2016-05-25 01:18:14.637906	47206
2619	47	2016-05-25 01:18:14.643195	2442
2620	47	2016-05-25 01:18:14.648217	2455
2621	47	2016-05-25 01:18:14.653619	2454
2622	47	2016-05-25 01:18:14.65867	2444
2623	47	2016-05-25 01:18:14.663912	2448
2624	47	2016-05-25 01:18:14.670027	2440
2625	47	2016-05-25 01:18:14.67556	2452
2626	47	2016-05-25 01:18:14.68076	2374
2627	47	2016-05-25 01:18:14.686211	2450
2628	41	2016-05-25 01:28:21.026238	2378
2629	46	2016-05-25 01:28:21.034678	2398
2630	45	2016-05-25 01:28:21.041697	2400
2631	44	2016-05-25 01:28:21.049014	2382
2632	42	2016-05-25 01:28:21.055557	2461
2633	42	2016-05-25 01:28:21.063393	2469
2634	42	2016-05-25 01:28:21.070537	2444
2635	42	2016-05-25 01:28:21.07652	2470
2636	42	2016-05-25 01:28:21.083172	2450
2637	42	2016-05-25 01:28:21.089285	2452
2638	42	2016-05-25 01:28:21.095267	2455
2639	42	2016-05-25 01:28:21.102111	2472
2640	42	2016-05-25 01:28:21.107798	2454
2641	42	2016-05-25 01:28:21.113729	2374
2642	42	2016-05-25 01:28:21.120598	2440
2643	42	2016-05-25 01:28:21.126951	2442
2644	42	2016-05-25 01:28:21.133052	2468
2645	42	2016-05-25 01:28:21.138332	2457
2646	42	2016-05-25 01:28:21.143607	2459
2647	42	2016-05-25 01:28:21.148561	2463
2648	42	2016-05-25 01:28:21.154423	2448
2649	42	2016-05-25 01:28:21.159855	2465
2650	42	2016-05-25 01:28:21.165026	2467
2651	43	2016-05-25 01:28:21.170906	2462
2652	43	2016-05-25 01:28:21.176069	2464
2653	43	2016-05-25 01:28:21.181022	2466
2654	43	2016-05-25 01:28:21.185976	2460
2655	43	2016-05-25 01:28:21.191652	2473
2656	43	2016-05-25 01:28:21.197127	2445
2657	43	2016-05-25 01:28:21.201996	2453
2658	43	2016-05-25 01:28:21.206948	2451
2659	43	2016-05-25 01:28:21.211896	2443
2660	43	2016-05-25 01:28:21.216579	2449
2661	43	2016-05-25 01:28:21.221453	2375
2662	43	2016-05-25 01:28:21.226458	2458
2663	43	2016-05-25 01:28:21.231268	2471
2664	43	2016-05-25 01:28:21.237908	2441
2665	43	2016-05-25 01:28:21.243655	2456
2666	40	2016-05-25 01:28:21.250391	47203
2667	40	2016-05-25 01:28:21.255418	47212
2668	40	2016-05-25 01:28:21.260669	47215
2669	40	2016-05-25 01:28:21.265422	47209
2670	40	2016-05-25 01:28:21.270022	47206
2671	49	2016-05-25 01:28:21.276993	47209
2672	49	2016-05-25 01:28:21.281874	47203
2673	49	2016-05-25 01:28:21.28653	47212
2674	49	2016-05-25 01:28:21.291307	47215
2675	49	2016-05-25 01:28:21.296169	47206
2676	48	2016-05-25 01:28:21.301827	2450
2677	48	2016-05-25 01:28:21.307299	2442
2678	48	2016-05-25 01:28:21.312562	2455
2679	48	2016-05-25 01:28:21.317761	2454
2680	48	2016-05-25 01:28:21.323132	2444
2681	48	2016-05-25 01:28:21.328453	2448
2682	48	2016-05-25 01:28:21.334188	2440
2683	48	2016-05-25 01:28:21.341926	2452
2684	48	2016-05-25 01:28:21.347646	2374
2685	50	2016-05-25 01:28:21.353221	47209
2686	50	2016-05-25 01:28:21.358094	47203
2687	50	2016-05-25 01:28:21.363083	47212
2688	50	2016-05-25 01:28:21.367964	47215
2689	50	2016-05-25 01:28:21.373024	47206
2690	47	2016-05-25 01:28:21.378887	2457
2691	47	2016-05-25 01:28:21.384144	2442
2692	47	2016-05-25 01:28:21.389166	2444
2693	47	2016-05-25 01:28:21.394655	2448
2694	47	2016-05-25 01:28:21.399629	2459
2695	47	2016-05-25 01:28:21.406154	2440
2696	47	2016-05-25 01:28:21.411466	2452
2697	47	2016-05-25 01:28:21.419742	2374
2698	47	2016-05-25 01:28:21.426069	2450
2699	47	2016-05-25 01:28:21.431882	2461
2700	47	2016-05-25 01:28:21.437971	2455
2701	47	2016-05-25 01:28:21.443417	2454
2702	41	2016-05-25 01:31:01.706152	2378
2703	46	2016-05-25 01:31:01.713492	2398
2704	45	2016-05-25 01:31:01.734784	2400
2705	44	2016-05-25 01:31:01.755289	2382
2706	42	2016-05-25 01:31:01.760464	2461
2707	42	2016-05-25 01:31:01.765554	2469
2708	42	2016-05-25 01:31:01.770347	2444
2709	42	2016-05-25 01:31:01.775242	2474
2710	42	2016-05-25 01:31:01.780428	2450
2711	42	2016-05-25 01:31:01.785086	2452
2712	42	2016-05-25 01:31:01.78989	2455
2713	42	2016-05-25 01:31:01.794937	2472
2714	42	2016-05-25 01:31:01.799698	2454
2715	42	2016-05-25 01:31:01.80445	2374
2716	42	2016-05-25 01:31:01.809595	2440
2717	42	2016-05-25 01:31:01.814433	2442
2718	42	2016-05-25 01:31:01.819627	2468
2719	42	2016-05-25 01:31:01.824413	2457
2720	42	2016-05-25 01:31:01.829635	2475
2721	42	2016-05-25 01:31:01.834439	2459
2722	42	2016-05-25 01:31:01.839335	2463
2723	42	2016-05-25 01:31:01.844477	2448
2724	42	2016-05-25 01:31:01.84974	2465
2725	42	2016-05-25 01:31:01.8548	2467
2726	42	2016-05-25 01:31:01.86001	2470
2727	43	2016-05-25 01:31:01.865868	2462
2728	43	2016-05-25 01:31:01.870712	2464
2729	43	2016-05-25 01:31:01.875748	2466
2730	43	2016-05-25 01:31:01.880414	2460
2731	43	2016-05-25 01:31:01.885308	2473
2732	43	2016-05-25 01:31:01.890144	2445
2733	43	2016-05-25 01:31:01.89551	2453
2734	43	2016-05-25 01:31:01.900406	2451
2735	43	2016-05-25 01:31:01.905147	2443
2736	43	2016-05-25 01:31:01.910505	2449
2737	43	2016-05-25 01:31:01.915422	2375
2738	43	2016-05-25 01:31:01.920195	2458
2739	43	2016-05-25 01:31:01.925194	2471
2740	43	2016-05-25 01:31:01.930682	2441
2741	43	2016-05-25 01:31:01.935626	2456
2742	40	2016-05-25 01:31:01.941281	47203
2743	40	2016-05-25 01:31:01.946254	47212
2744	40	2016-05-25 01:31:01.95128	47215
2745	40	2016-05-25 01:31:01.956749	47209
2746	40	2016-05-25 01:31:01.961594	47206
2747	49	2016-05-25 01:31:01.967274	47209
2748	49	2016-05-25 01:31:01.971915	47203
2749	49	2016-05-25 01:31:01.977475	47212
2750	49	2016-05-25 01:31:01.982033	47215
2751	49	2016-05-25 01:31:01.987299	47206
2752	48	2016-05-25 01:31:01.993526	2457
2753	48	2016-05-25 01:31:01.998838	2442
2754	48	2016-05-25 01:31:02.00412	2444
2755	48	2016-05-25 01:31:02.009897	2448
2756	48	2016-05-25 01:31:02.015255	2459
2757	48	2016-05-25 01:31:02.020501	2440
2758	48	2016-05-25 01:31:02.026234	2452
2759	48	2016-05-25 01:31:02.032027	2374
2760	48	2016-05-25 01:31:02.037303	2450
2761	48	2016-05-25 01:31:02.043107	2461
2762	48	2016-05-25 01:31:02.048965	2455
2763	48	2016-05-25 01:31:02.054275	2454
2764	50	2016-05-25 01:31:02.060315	47209
2765	50	2016-05-25 01:31:02.065361	47203
2766	50	2016-05-25 01:31:02.070254	47212
2767	50	2016-05-25 01:31:02.075445	47215
2768	50	2016-05-25 01:31:02.080563	47206
2769	47	2016-05-25 01:31:02.086184	2457
2770	47	2016-05-25 01:31:02.091615	2442
2771	47	2016-05-25 01:31:02.09742	2463
2772	47	2016-05-25 01:31:02.102731	2444
2773	47	2016-05-25 01:31:02.108289	2448
2774	47	2016-05-25 01:31:02.113746	2440
2775	47	2016-05-25 01:31:02.118831	2452
2776	47	2016-05-25 01:31:02.124157	2374
2777	47	2016-05-25 01:31:02.129474	2468
2778	47	2016-05-25 01:31:02.134796	2450
2779	47	2016-05-25 01:31:02.139984	2470
2780	47	2016-05-25 01:31:02.145612	2461
2781	47	2016-05-25 01:31:02.150814	2455
2782	47	2016-05-25 01:31:02.155951	2454
2783	47	2016-05-25 01:31:02.161427	2465
2784	47	2016-05-25 01:31:02.166436	2459
2785	47	2016-05-25 01:31:02.171558	2472
2786	47	2016-05-25 01:31:02.176963	2467
2787	47	2016-05-25 01:31:02.182199	2469
2788	41	2016-05-25 01:32:02.346811	2378
2789	46	2016-05-25 01:32:02.354074	2398
2790	45	2016-05-25 01:32:02.360652	2400
2791	44	2016-05-25 01:32:02.367105	2382
2792	42	2016-05-25 01:32:02.373017	2461
2793	42	2016-05-25 01:32:02.378947	2469
2794	42	2016-05-25 01:32:02.384935	2444
2795	42	2016-05-25 01:32:02.390624	2474
2796	42	2016-05-25 01:32:02.398047	2450
2797	42	2016-05-25 01:32:02.403833	2452
2798	42	2016-05-25 01:32:02.409671	2455
2799	42	2016-05-25 01:32:02.416017	2472
2800	42	2016-05-25 01:32:02.421951	2454
2801	42	2016-05-25 01:32:02.42811	2374
2802	42	2016-05-25 01:32:02.434125	2440
2803	42	2016-05-25 01:32:02.441807	2442
2804	42	2016-05-25 01:32:02.450313	2468
2805	42	2016-05-25 01:32:02.459051	2478
2806	42	2016-05-25 01:32:02.469153	2457
2807	42	2016-05-25 01:32:02.477129	2475
2808	42	2016-05-25 01:32:02.484095	2459
2809	42	2016-05-25 01:32:02.489692	2463
2810	42	2016-05-25 01:32:02.495139	2476
2811	42	2016-05-25 01:32:02.501631	2448
2812	42	2016-05-25 01:32:02.506989	2465
2813	42	2016-05-25 01:32:02.511935	2467
2814	42	2016-05-25 01:32:02.51763	2470
2815	43	2016-05-25 01:32:02.523501	2462
2816	43	2016-05-25 01:32:02.530417	2464
2817	43	2016-05-25 01:32:02.535807	2466
2818	43	2016-05-25 01:32:02.540542	2460
2819	43	2016-05-25 01:32:02.545562	2473
2820	43	2016-05-25 01:32:02.550879	2477
2821	43	2016-05-25 01:32:02.555851	2445
2822	43	2016-05-25 01:32:02.56071	2453
2823	43	2016-05-25 01:32:02.566213	2443
2824	43	2016-05-25 01:32:02.571071	2449
2825	43	2016-05-25 01:32:02.575997	2375
2826	43	2016-05-25 01:32:02.581008	2458
2827	43	2016-05-25 01:32:02.585914	2479
2828	43	2016-05-25 01:32:02.590706	2471
2829	43	2016-05-25 01:32:02.595559	2441
2830	43	2016-05-25 01:32:02.600934	2456
2831	43	2016-05-25 01:32:02.605939	2451
2832	40	2016-05-25 01:32:02.611587	47203
2833	40	2016-05-25 01:32:02.616176	47212
2834	40	2016-05-25 01:32:02.620628	47206
2835	40	2016-05-25 01:32:02.624711	47215
2836	40	2016-05-25 01:32:02.628782	47209
2837	49	2016-05-25 01:32:02.634611	47209
2838	49	2016-05-25 01:32:02.639223	47203
2839	49	2016-05-25 01:32:02.643697	47212
2840	49	2016-05-25 01:32:02.649442	47215
2841	49	2016-05-25 01:32:02.654409	47206
2842	48	2016-05-25 01:32:02.660131	2457
2843	48	2016-05-25 01:32:02.665933	2442
2844	48	2016-05-25 01:32:02.671292	2463
2845	48	2016-05-25 01:32:02.677371	2444
2846	48	2016-05-25 01:32:02.682899	2448
2847	48	2016-05-25 01:32:02.688306	2440
2848	48	2016-05-25 01:32:02.693529	2452
2849	48	2016-05-25 01:32:02.699113	2374
2850	48	2016-05-25 01:32:02.704623	2468
2851	48	2016-05-25 01:32:02.709986	2450
2852	48	2016-05-25 01:32:02.71551	2470
2853	48	2016-05-25 01:32:02.720687	2461
2854	48	2016-05-25 01:32:02.726086	2455
2855	48	2016-05-25 01:32:02.731557	2454
2856	48	2016-05-25 01:32:02.736745	2465
2857	48	2016-05-25 01:32:02.742058	2459
2858	48	2016-05-25 01:32:02.747617	2472
2859	48	2016-05-25 01:32:02.752857	2467
2860	48	2016-05-25 01:32:02.758261	2469
2861	50	2016-05-25 01:32:02.763603	47209
2862	50	2016-05-25 01:32:02.768572	47203
2863	50	2016-05-25 01:32:02.774152	47212
2864	50	2016-05-25 01:32:02.795589	47215
2865	50	2016-05-25 01:32:02.815829	47206
2866	47	2016-05-25 01:32:02.821594	2457
2867	47	2016-05-25 01:32:02.827092	2463
2868	47	2016-05-25 01:32:02.833734	2444
2869	47	2016-05-25 01:32:02.839704	2440
2870	47	2016-05-25 01:32:02.845517	2452
2871	47	2016-05-25 01:32:02.852314	2374
2872	47	2016-05-25 01:32:02.858604	2468
2873	47	2016-05-25 01:32:02.864726	2475
2874	47	2016-05-25 01:32:02.870359	2450
2875	47	2016-05-25 01:32:02.875885	2470
2876	47	2016-05-25 01:32:02.881636	2461
2877	47	2016-05-25 01:32:02.887319	2455
2878	47	2016-05-25 01:32:02.892636	2454
2879	47	2016-05-25 01:32:02.89811	2465
2880	47	2016-05-25 01:32:02.903276	2459
2881	47	2016-05-25 01:32:02.908401	2472
2882	47	2016-05-25 01:32:02.913679	2467
2883	47	2016-05-25 01:32:02.918897	2469
2884	47	2016-05-25 01:32:02.924031	2442
2885	47	2016-05-25 01:32:02.92933	2474
2886	47	2016-05-25 01:32:02.934661	2448
2887	41	2016-05-25 01:38:41.149616	2378
2888	46	2016-05-25 01:38:41.156041	2398
2889	45	2016-05-25 01:38:41.161511	2400
2890	44	2016-05-25 01:38:41.167421	2382
2891	42	2016-05-25 01:38:41.172904	2461
2892	42	2016-05-25 01:38:41.177834	2469
2893	42	2016-05-25 01:38:41.183244	2444
2894	42	2016-05-25 01:38:41.189394	2474
2895	42	2016-05-25 01:38:41.195101	2492
2896	42	2016-05-25 01:38:41.200407	2486
2897	42	2016-05-25 01:38:41.205438	2450
2898	42	2016-05-25 01:38:41.210303	2452
2899	42	2016-05-25 01:38:41.215954	2455
2900	42	2016-05-25 01:38:41.220874	2482
2901	42	2016-05-25 01:38:41.225844	2488
2902	42	2016-05-25 01:38:41.230877	2472
2903	42	2016-05-25 01:38:41.236269	2374
2904	42	2016-05-25 01:38:41.241438	2442
2905	42	2016-05-25 01:38:41.246458	2496
2906	42	2016-05-25 01:38:41.252393	2467
2907	42	2016-05-25 01:38:41.257317	2490
2908	42	2016-05-25 01:38:41.262399	2494
2909	42	2016-05-25 01:38:41.26782	2470
2910	42	2016-05-25 01:38:41.272663	2484
2911	42	2016-05-25 01:38:41.277631	2454
2912	42	2016-05-25 01:38:41.282694	2440
2913	42	2016-05-25 01:38:41.287929	2468
2914	42	2016-05-25 01:38:41.292805	2478
2915	42	2016-05-25 01:38:41.298074	2480
2916	42	2016-05-25 01:38:41.302983	2457
2917	42	2016-05-25 01:38:41.308001	2475
2918	42	2016-05-25 01:38:41.31293	2459
2919	42	2016-05-25 01:38:41.318066	2463
2920	42	2016-05-25 01:38:41.323011	2476
2921	42	2016-05-25 01:38:41.328015	2448
2922	42	2016-05-25 01:38:41.333255	2465
2923	43	2016-05-25 01:38:41.338612	2462
2924	43	2016-05-25 01:38:41.343457	2466
2925	43	2016-05-25 01:38:41.348578	2489
2926	43	2016-05-25 01:38:41.353461	2477
2927	43	2016-05-25 01:38:41.358313	2481
2928	43	2016-05-25 01:38:41.363874	2453
2929	43	2016-05-25 01:38:41.369314	2491
2930	43	2016-05-25 01:38:41.374291	2483
2931	43	2016-05-25 01:38:41.379411	2443
2932	43	2016-05-25 01:38:41.385633	2375
2933	43	2016-05-25 01:38:41.390682	2458
2934	43	2016-05-25 01:38:41.395569	2479
2935	43	2016-05-25 01:38:41.400962	2471
2936	43	2016-05-25 01:38:41.405929	2487
2937	43	2016-05-25 01:38:41.410905	2441
2938	43	2016-05-25 01:38:41.416402	2456
2939	43	2016-05-25 01:38:41.421516	2451
2940	43	2016-05-25 01:38:41.426457	2464
2941	43	2016-05-25 01:38:41.431666	2497
2942	43	2016-05-25 01:38:41.437135	2460
2943	43	2016-05-25 01:38:41.444074	2493
2944	43	2016-05-25 01:38:41.451836	2473
2945	43	2016-05-25 01:38:41.47304	2445
2946	43	2016-05-25 01:38:41.478941	2485
2947	43	2016-05-25 01:38:41.484471	2495
2948	43	2016-05-25 01:38:41.489791	2449
2949	40	2016-05-25 01:38:41.4958	47212
2950	40	2016-05-25 01:38:41.500968	47206
2951	40	2016-05-25 01:38:41.505717	47215
2952	40	2016-05-25 01:38:41.510322	47209
2953	40	2016-05-25 01:38:41.515129	47203
2954	49	2016-05-25 01:38:41.521163	47209
2955	49	2016-05-25 01:38:41.525981	47203
2956	49	2016-05-25 01:38:41.530948	47212
2957	49	2016-05-25 01:38:41.536128	47215
2958	49	2016-05-25 01:38:41.541241	47206
2959	48	2016-05-25 01:38:41.548238	2457
2960	48	2016-05-25 01:38:41.555453	2463
2961	48	2016-05-25 01:38:41.561064	2444
2962	48	2016-05-25 01:38:41.567291	2440
2963	48	2016-05-25 01:38:41.572877	2452
2964	48	2016-05-25 01:38:41.578481	2374
2965	48	2016-05-25 01:38:41.585126	2468
2966	48	2016-05-25 01:38:41.590753	2475
2967	48	2016-05-25 01:38:41.59643	2450
2968	48	2016-05-25 01:38:41.602031	2470
2969	48	2016-05-25 01:38:41.607537	2461
2970	48	2016-05-25 01:38:41.613124	2455
2971	48	2016-05-25 01:38:41.618941	2454
2972	48	2016-05-25 01:38:41.624406	2465
2973	48	2016-05-25 01:38:41.630253	2459
2974	48	2016-05-25 01:38:41.636273	2472
2975	48	2016-05-25 01:38:41.642051	2467
2976	48	2016-05-25 01:38:41.647949	2469
2977	48	2016-05-25 01:38:41.654158	2442
2978	48	2016-05-25 01:38:41.659804	2474
2979	48	2016-05-25 01:38:41.666626	2448
2980	50	2016-05-25 01:38:41.672307	47209
2981	50	2016-05-25 01:38:41.677354	47203
2982	50	2016-05-25 01:38:41.682684	47212
2983	50	2016-05-25 01:38:41.687848	47215
2984	50	2016-05-25 01:38:41.692744	47206
2985	47	2016-05-25 01:38:41.698725	2457
2986	47	2016-05-25 01:38:41.703994	2463
2987	47	2016-05-25 01:38:41.709268	2444
2988	47	2016-05-25 01:38:41.714973	2374
2989	47	2016-05-25 01:38:41.720414	2475
2990	47	2016-05-25 01:38:41.725783	2450
2991	47	2016-05-25 01:38:41.731329	2470
2992	47	2016-05-25 01:38:41.73671	2461
2993	47	2016-05-25 01:38:41.741992	2455
2994	47	2016-05-25 01:38:41.747787	2454
2995	47	2016-05-25 01:38:41.75316	2465
2996	47	2016-05-25 01:38:41.758402	2478
2997	47	2016-05-25 01:38:41.763815	2459
2998	47	2016-05-25 01:38:41.76916	2472
2999	47	2016-05-25 01:38:41.774487	2467
3000	47	2016-05-25 01:38:41.780009	2469
3001	47	2016-05-25 01:38:41.78588	2442
3002	47	2016-05-25 01:38:41.791258	2474
3003	47	2016-05-25 01:38:41.796747	2476
3004	47	2016-05-25 01:38:41.802712	2448
3005	47	2016-05-25 01:38:41.809398	2440
3006	47	2016-05-25 01:38:41.815532	2452
3007	47	2016-05-25 01:38:41.821235	2468
3008	41	2016-05-25 01:41:25.644484	2378
3009	46	2016-05-25 01:41:25.651273	2398
3010	45	2016-05-25 01:41:25.658534	2400
3011	44	2016-05-25 01:41:25.666202	2382
3012	42	2016-05-25 01:41:25.672273	2444
3013	42	2016-05-25 01:41:25.678353	2474
3014	42	2016-05-25 01:41:25.685441	2492
3015	42	2016-05-25 01:41:25.691917	2486
3016	42	2016-05-25 01:41:25.697659	2450
3017	42	2016-05-25 01:41:25.703635	2452
3018	42	2016-05-25 01:41:25.710207	2455
3019	42	2016-05-25 01:41:25.716975	2482
3020	42	2016-05-25 01:41:25.72494	2488
3021	42	2016-05-25 01:41:25.73242	2472
3022	42	2016-05-25 01:41:25.739756	2500
3023	42	2016-05-25 01:41:25.748941	2374
3024	42	2016-05-25 01:41:25.755951	2442
3025	42	2016-05-25 01:41:25.761044	2496
3026	42	2016-05-25 01:41:25.766043	2467
3027	42	2016-05-25 01:41:25.771239	2490
3028	42	2016-05-25 01:41:25.777696	2494
3029	42	2016-05-25 01:41:25.783128	2470
3030	42	2016-05-25 01:41:25.788143	2498
3031	42	2016-05-25 01:41:25.793279	2484
3032	42	2016-05-25 01:41:25.798283	2454
3033	42	2016-05-25 01:41:25.803236	2440
3034	42	2016-05-25 01:41:25.808545	2468
3035	42	2016-05-25 01:41:25.813449	2478
3036	42	2016-05-25 01:41:25.818359	2480
3037	42	2016-05-25 01:41:25.823631	2457
3038	42	2016-05-25 01:41:25.828875	2475
3039	42	2016-05-25 01:41:25.834	2459
3040	42	2016-05-25 01:41:25.839091	2463
3041	42	2016-05-25 01:41:25.845009	2476
3042	42	2016-05-25 01:41:25.850567	2448
3043	42	2016-05-25 01:41:25.855924	2465
3044	42	2016-05-25 01:41:25.860928	2461
3045	42	2016-05-25 01:41:25.865853	2469
3046	43	2016-05-25 01:41:25.871006	2462
3047	43	2016-05-25 01:41:25.876262	2466
3048	43	2016-05-25 01:41:25.88102	2489
3049	43	2016-05-25 01:41:25.886067	2477
3050	43	2016-05-25 01:41:25.891396	2481
3051	43	2016-05-25 01:41:25.896432	2453
3052	43	2016-05-25 01:41:25.901728	2491
3053	43	2016-05-25 01:41:25.906703	2483
3054	43	2016-05-25 01:41:25.911864	2443
3055	43	2016-05-25 01:41:25.916669	2501
3056	43	2016-05-25 01:41:25.921715	2375
3057	43	2016-05-25 01:41:25.927163	2458
3058	43	2016-05-25 01:41:25.93207	2499
3059	43	2016-05-25 01:41:25.936763	2471
3060	43	2016-05-25 01:41:25.941939	2487
3061	43	2016-05-25 01:41:25.946871	2441
3062	43	2016-05-25 01:41:25.951637	2456
3063	43	2016-05-25 01:41:25.956847	2451
3064	43	2016-05-25 01:41:25.961865	2464
3065	43	2016-05-25 01:41:25.966691	2497
3066	43	2016-05-25 01:41:25.972277	2460
3067	43	2016-05-25 01:41:25.977805	2493
3068	43	2016-05-25 01:41:25.982724	2473
3069	43	2016-05-25 01:41:25.987731	2445
3070	43	2016-05-25 01:41:25.992846	2485
3071	43	2016-05-25 01:41:25.998999	2495
3072	43	2016-05-25 01:41:26.00482	2449
3073	43	2016-05-25 01:41:26.010024	2479
3074	40	2016-05-25 01:41:26.015874	47212
3075	40	2016-05-25 01:41:26.020209	47206
3076	40	2016-05-25 01:41:26.025145	47215
3077	40	2016-05-25 01:41:26.029689	47209
3078	40	2016-05-25 01:41:26.034322	47203
3079	49	2016-05-25 01:41:26.040345	47209
3080	49	2016-05-25 01:41:26.045549	47203
3081	49	2016-05-25 01:41:26.050412	47212
3082	49	2016-05-25 01:41:26.05539	47215
3083	49	2016-05-25 01:41:26.060262	47206
3084	48	2016-05-25 01:41:26.065968	2457
3085	48	2016-05-25 01:41:26.071354	2463
3086	48	2016-05-25 01:41:26.077084	2444
3087	48	2016-05-25 01:41:26.082506	2374
3088	48	2016-05-25 01:41:26.087952	2475
3089	48	2016-05-25 01:41:26.093457	2450
3090	48	2016-05-25 01:41:26.098869	2470
3091	48	2016-05-25 01:41:26.104322	2461
3092	48	2016-05-25 01:41:26.110106	2455
3093	48	2016-05-25 01:41:26.115839	2454
3094	48	2016-05-25 01:41:26.121422	2465
3095	48	2016-05-25 01:41:26.127272	2478
3096	48	2016-05-25 01:41:26.132719	2459
3097	48	2016-05-25 01:41:26.1382	2472
3098	48	2016-05-25 01:41:26.14398	2467
3099	48	2016-05-25 01:41:26.149243	2469
3100	48	2016-05-25 01:41:26.15467	2442
3101	48	2016-05-25 01:41:26.160466	2474
3102	48	2016-05-25 01:41:26.165972	2476
3103	48	2016-05-25 01:41:26.171359	2448
3104	48	2016-05-25 01:41:26.176797	2440
3105	48	2016-05-25 01:41:26.182238	2452
3106	48	2016-05-25 01:41:26.187631	2468
3107	50	2016-05-25 01:41:26.193881	47209
3108	50	2016-05-25 01:41:26.200028	47203
3109	50	2016-05-25 01:41:26.205349	47212
3110	50	2016-05-25 01:41:26.210835	47215
3111	50	2016-05-25 01:41:26.215768	47206
3112	47	2016-05-25 01:41:26.221442	2482
3113	47	2016-05-25 01:41:26.227195	2463
3114	47	2016-05-25 01:41:26.232609	2444
3115	47	2016-05-25 01:41:26.238204	2496
3116	47	2016-05-25 01:41:26.245164	2374
3117	47	2016-05-25 01:41:26.25167	2475
3118	47	2016-05-25 01:41:26.257306	2480
3119	47	2016-05-25 01:41:26.262652	2454
3120	47	2016-05-25 01:41:26.267772	2465
3121	47	2016-05-25 01:41:26.273149	2459
3122	47	2016-05-25 01:41:26.278753	2472
3123	47	2016-05-25 01:41:26.28396	2467
3124	47	2016-05-25 01:41:26.28949	2469
3125	47	2016-05-25 01:41:26.294721	2442
3126	47	2016-05-25 01:41:26.299912	2474
3127	47	2016-05-25 01:41:26.305529	2486
3128	47	2016-05-25 01:41:26.310964	2476
3129	47	2016-05-25 01:41:26.316299	2492
3130	47	2016-05-25 01:41:26.321584	2448
3131	47	2016-05-25 01:41:26.327003	2490
3132	47	2016-05-25 01:41:26.3326	2440
3133	47	2016-05-25 01:41:26.354727	2452
3134	47	2016-05-25 01:41:26.37489	2468
3135	47	2016-05-25 01:41:26.380008	2450
3136	47	2016-05-25 01:41:26.385299	2470
3137	47	2016-05-25 01:41:26.390495	2461
3138	47	2016-05-25 01:41:26.395911	2455
3139	47	2016-05-25 01:41:26.40124	2478
3140	47	2016-05-25 01:41:26.406716	2488
3141	47	2016-05-25 01:41:26.411782	2494
3142	47	2016-05-25 01:41:26.416913	2484
3143	47	2016-05-25 01:41:26.42245	2457
3144	40	2016-05-25 01:42:03.763548	47256
3145	41	2016-05-25 01:42:29.756435	2378
3146	46	2016-05-25 01:42:29.762495	2398
3147	45	2016-05-25 01:42:29.76803	2400
3148	44	2016-05-25 01:42:29.773963	2382
3149	42	2016-05-25 01:42:29.779255	2444
3150	42	2016-05-25 01:42:29.784141	2486
3151	42	2016-05-25 01:42:29.789153	2450
3152	42	2016-05-25 01:42:29.794009	2452
3153	42	2016-05-25 01:42:29.799046	2455
3154	42	2016-05-25 01:42:29.804193	2482
3155	42	2016-05-25 01:42:29.809247	2488
3156	42	2016-05-25 01:42:29.814102	2472
3157	42	2016-05-25 01:42:29.819364	2500
3158	42	2016-05-25 01:42:29.824385	2374
3159	42	2016-05-25 01:42:29.829183	2442
3160	42	2016-05-25 01:42:29.834711	2496
3161	42	2016-05-25 01:42:29.840876	2467
3162	42	2016-05-25 01:42:29.845823	2490
3163	42	2016-05-25 01:42:29.85091	2504
3164	42	2016-05-25 01:42:29.856204	2494
3165	42	2016-05-25 01:42:29.861262	2470
3166	42	2016-05-25 01:42:29.866035	2498
3167	42	2016-05-25 01:42:29.87165	2484
3168	42	2016-05-25 01:42:29.876638	2506
3169	42	2016-05-25 01:42:29.881606	2440
3170	42	2016-05-25 01:42:29.886747	2468
3171	42	2016-05-25 01:42:29.891765	2478
3172	42	2016-05-25 01:42:29.897011	2480
3173	42	2016-05-25 01:42:29.901887	2457
3174	42	2016-05-25 01:42:29.907028	2475
3175	42	2016-05-25 01:42:29.911979	2502
3176	42	2016-05-25 01:42:29.916806	2459
3177	42	2016-05-25 01:42:29.922043	2463
3178	42	2016-05-25 01:42:29.927077	2476
3179	42	2016-05-25 01:42:29.931893	2448
3180	42	2016-05-25 01:42:29.936907	2465
3181	42	2016-05-25 01:42:29.941821	2461
3182	42	2016-05-25 01:42:29.946824	2469
3183	42	2016-05-25 01:42:29.951827	2474
3184	42	2016-05-25 01:42:29.956986	2492
3185	43	2016-05-25 01:42:29.962831	2462
3186	43	2016-05-25 01:42:29.968969	2466
3187	43	2016-05-25 01:42:29.975693	2489
3188	43	2016-05-25 01:42:29.980753	2477
3189	43	2016-05-25 01:42:29.986266	2481
3190	43	2016-05-25 01:42:29.991732	2453
3191	43	2016-05-25 01:42:29.996744	2491
3192	43	2016-05-25 01:42:30.001689	2483
3193	43	2016-05-25 01:42:30.006752	2443
3194	43	2016-05-25 01:42:30.011605	2501
3195	43	2016-05-25 01:42:30.016797	2375
3196	43	2016-05-25 01:42:30.02193	2458
3197	43	2016-05-25 01:42:30.026931	2499
3198	43	2016-05-25 01:42:30.032128	2471
3199	43	2016-05-25 01:42:30.037463	2487
3200	43	2016-05-25 01:42:30.042968	2441
3201	43	2016-05-25 01:42:30.047923	2451
3202	43	2016-05-25 01:42:30.053055	2507
3203	43	2016-05-25 01:42:30.058217	2464
3204	43	2016-05-25 01:42:30.063237	2497
3205	43	2016-05-25 01:42:30.068307	2460
3206	43	2016-05-25 01:42:30.073847	2493
3207	43	2016-05-25 01:42:30.078722	2473
3208	43	2016-05-25 01:42:30.08362	2445
3209	43	2016-05-25 01:42:30.089146	2485
3210	43	2016-05-25 01:42:30.094146	2495
3211	43	2016-05-25 01:42:30.099221	2449
3212	43	2016-05-25 01:42:30.104263	2505
3213	43	2016-05-25 01:42:30.109218	2479
3214	43	2016-05-25 01:42:30.114127	2456
3215	43	2016-05-25 01:42:30.119281	2503
3216	40	2016-05-25 01:42:30.125363	47212
3217	40	2016-05-25 01:42:30.129947	47206
3218	40	2016-05-25 01:42:30.134266	47215
3219	40	2016-05-25 01:42:30.139059	47209
3220	40	2016-05-25 01:42:30.147407	47203
3221	49	2016-05-25 01:42:30.153735	47209
3222	49	2016-05-25 01:42:30.158514	47203
3223	49	2016-05-25 01:42:30.163103	47212
3224	49	2016-05-25 01:42:30.167789	47215
3225	49	2016-05-25 01:42:30.172745	47206
3226	48	2016-05-25 01:42:30.178664	2482
3227	48	2016-05-25 01:42:30.184084	2463
3228	48	2016-05-25 01:42:30.190005	2444
3229	48	2016-05-25 01:42:30.195344	2496
3230	48	2016-05-25 01:42:30.20093	2374
3231	48	2016-05-25 01:42:30.206498	2475
3232	48	2016-05-25 01:42:30.211857	2480
3233	48	2016-05-25 01:42:30.217556	2454
3234	48	2016-05-25 01:42:30.22357	2465
3235	48	2016-05-25 01:42:30.229708	2459
3236	48	2016-05-25 01:42:30.235799	2472
3237	48	2016-05-25 01:42:30.243067	2467
3238	48	2016-05-25 01:42:30.24971	2469
3239	48	2016-05-25 01:42:30.25589	2442
3240	48	2016-05-25 01:42:30.262945	2474
3241	48	2016-05-25 01:42:30.268761	2486
3242	48	2016-05-25 01:42:30.2746	2476
3243	48	2016-05-25 01:42:30.281314	2492
3244	48	2016-05-25 01:42:30.288002	2448
3245	48	2016-05-25 01:42:30.295748	2490
3246	48	2016-05-25 01:42:30.302126	2440
3247	48	2016-05-25 01:42:30.308267	2452
3248	48	2016-05-25 01:42:30.315052	2468
3249	48	2016-05-25 01:42:30.32181	2450
3250	48	2016-05-25 01:42:30.329576	2470
3251	48	2016-05-25 01:42:30.336181	2461
3252	48	2016-05-25 01:42:30.342528	2455
3253	48	2016-05-25 01:42:30.349292	2478
3254	48	2016-05-25 01:42:30.355226	2488
3255	48	2016-05-25 01:42:30.360971	2494
3256	48	2016-05-25 01:42:30.367474	2484
3257	48	2016-05-25 01:42:30.373507	2457
3258	50	2016-05-25 01:42:30.380317	47209
3259	50	2016-05-25 01:42:30.385964	47203
3260	50	2016-05-25 01:42:30.391388	47212
3261	50	2016-05-25 01:42:30.398904	47215
3262	50	2016-05-25 01:42:30.419962	47206
3263	47	2016-05-25 01:42:30.426155	2482
3264	47	2016-05-25 01:42:30.432613	2463
3265	47	2016-05-25 01:42:30.439823	2444
3266	47	2016-05-25 01:42:30.445515	2496
3267	47	2016-05-25 01:42:30.451594	2500
3268	47	2016-05-25 01:42:30.457261	2374
3269	47	2016-05-25 01:42:30.462843	2475
3270	47	2016-05-25 01:42:30.46951	2498
3271	47	2016-05-25 01:42:30.475852	2480
3272	47	2016-05-25 01:42:30.482053	2454
3273	47	2016-05-25 01:42:30.487952	2465
3274	47	2016-05-25 01:42:30.493332	2459
3275	47	2016-05-25 01:42:30.498406	2472
3276	47	2016-05-25 01:42:30.505265	2467
3277	47	2016-05-25 01:42:30.510903	2469
3278	47	2016-05-25 01:42:30.516174	2442
3279	47	2016-05-25 01:42:30.521786	2474
3280	47	2016-05-25 01:42:30.527117	2486
3281	47	2016-05-25 01:42:30.532295	2476
3282	47	2016-05-25 01:42:30.538279	2492
3283	47	2016-05-25 01:42:30.543959	2448
3284	47	2016-05-25 01:42:30.550227	2490
3285	47	2016-05-25 01:42:30.556528	2440
3286	47	2016-05-25 01:42:30.562423	2452
3287	47	2016-05-25 01:42:30.56874	2468
3288	47	2016-05-25 01:42:30.574637	2450
3289	47	2016-05-25 01:42:30.579903	2470
3290	47	2016-05-25 01:42:30.58665	2461
3291	47	2016-05-25 01:42:30.591974	2455
3292	47	2016-05-25 01:42:30.59739	2478
3293	47	2016-05-25 01:42:30.603476	2488
3294	47	2016-05-25 01:42:30.610949	2494
3295	47	2016-05-25 01:42:30.632715	2484
3296	47	2016-05-25 01:42:30.63941	2457
3297	41	2016-05-25 01:43:06.394098	2508
3298	40	2016-05-25 01:43:06.767568	47256
3299	49	2016-05-25 01:43:06.782327	47256
3300	41	2016-05-25 01:43:40.475446	2378
3301	46	2016-05-25 01:43:40.497964	2398
3302	45	2016-05-25 01:43:40.505685	2400
3303	44	2016-05-25 01:43:40.51197	2382
3304	42	2016-05-25 01:43:40.517764	2444
3305	42	2016-05-25 01:43:40.523591	2486
3306	42	2016-05-25 01:43:40.530247	2450
3307	42	2016-05-25 01:43:40.535647	2452
3308	42	2016-05-25 01:43:40.540666	2455
3309	42	2016-05-25 01:43:40.545783	2482
3310	42	2016-05-25 01:43:40.550863	2488
3311	42	2016-05-25 01:43:40.556656	2472
3312	42	2016-05-25 01:43:40.561592	2500
3313	42	2016-05-25 01:43:40.566441	2374
3314	42	2016-05-25 01:43:40.573194	2442
3315	42	2016-05-25 01:43:40.579801	2496
3316	42	2016-05-25 01:43:40.585489	2467
3317	42	2016-05-25 01:43:40.590957	2490
3318	42	2016-05-25 01:43:40.596659	2504
3319	42	2016-05-25 01:43:40.601957	2494
3320	42	2016-05-25 01:43:40.607572	2470
3321	42	2016-05-25 01:43:40.612676	2498
3322	42	2016-05-25 01:43:40.617846	2484
3323	42	2016-05-25 01:43:40.623708	2506
3324	42	2016-05-25 01:43:40.629402	2440
3325	42	2016-05-25 01:43:40.635922	2468
3326	42	2016-05-25 01:43:40.642023	2478
3327	42	2016-05-25 01:43:40.64747	2480
3328	42	2016-05-25 01:43:40.654612	2457
3329	42	2016-05-25 01:43:40.66365	2475
3330	42	2016-05-25 01:43:40.669949	2502
3331	42	2016-05-25 01:43:40.677275	2459
3332	42	2016-05-25 01:43:40.682315	2463
3333	42	2016-05-25 01:43:40.689912	2476
3334	42	2016-05-25 01:43:40.696326	2448
3335	42	2016-05-25 01:43:40.702008	2465
3336	42	2016-05-25 01:43:40.709457	2461
3337	42	2016-05-25 01:43:40.714592	2469
3338	42	2016-05-25 01:43:40.722411	2474
3339	42	2016-05-25 01:43:40.728598	2492
3340	43	2016-05-25 01:43:40.734664	2462
3341	43	2016-05-25 01:43:40.74211	2466
3342	43	2016-05-25 01:43:40.747532	2489
3343	43	2016-05-25 01:43:40.754405	2477
3344	43	2016-05-25 01:43:40.760982	2481
3345	43	2016-05-25 01:43:40.766494	2453
3346	43	2016-05-25 01:43:40.774558	2491
3347	43	2016-05-25 01:43:40.779998	2483
3348	43	2016-05-25 01:43:40.786554	2443
3349	43	2016-05-25 01:43:40.793922	2501
3350	43	2016-05-25 01:43:40.799447	2375
3351	43	2016-05-25 01:43:40.807223	2458
3352	43	2016-05-25 01:43:40.81322	2499
3353	43	2016-05-25 01:43:40.819341	2471
3354	43	2016-05-25 01:43:40.827998	2487
3355	43	2016-05-25 01:43:40.834196	2441
3356	43	2016-05-25 01:43:40.841683	2451
3357	43	2016-05-25 01:43:40.84738	2507
3358	43	2016-05-25 01:43:40.853505	2464
3359	43	2016-05-25 01:43:40.860238	2497
3360	43	2016-05-25 01:43:40.865582	2460
3361	43	2016-05-25 01:43:40.872446	2493
3362	43	2016-05-25 01:43:40.87968	2473
3363	43	2016-05-25 01:43:40.885439	2445
3364	43	2016-05-25 01:43:40.892089	2485
3365	43	2016-05-25 01:43:40.897364	2495
3366	43	2016-05-25 01:43:40.90363	2449
3367	43	2016-05-25 01:43:40.909975	2505
3368	43	2016-05-25 01:43:40.915099	2479
3369	43	2016-05-25 01:43:40.921251	2456
3370	43	2016-05-25 01:43:40.927081	2503
3371	40	2016-05-25 01:43:40.933147	47212
3372	40	2016-05-25 01:43:40.938251	47206
3373	40	2016-05-25 01:43:40.943347	47215
3374	40	2016-05-25 01:43:40.94788	47209
3375	40	2016-05-25 01:43:40.957521	47203
3376	49	2016-05-25 01:43:40.963459	47209
3377	49	2016-05-25 01:43:40.97483	47203
3378	49	2016-05-25 01:43:40.97986	47212
3379	49	2016-05-25 01:43:40.985016	47215
3380	49	2016-05-25 01:43:40.990562	47206
3381	48	2016-05-25 01:43:40.996621	2482
3382	48	2016-05-25 01:43:41.002543	2463
3383	48	2016-05-25 01:43:41.009122	2444
3384	48	2016-05-25 01:43:41.0148	2496
3385	48	2016-05-25 01:43:41.020656	2500
3386	48	2016-05-25 01:43:41.027003	2374
3387	48	2016-05-25 01:43:41.034117	2475
3388	48	2016-05-25 01:43:41.041226	2498
3389	48	2016-05-25 01:43:41.047157	2480
3390	48	2016-05-25 01:43:41.052983	2454
3391	48	2016-05-25 01:43:41.059361	2465
3392	48	2016-05-25 01:43:41.065285	2459
3393	48	2016-05-25 01:43:41.071369	2472
3394	48	2016-05-25 01:43:41.077812	2467
3395	48	2016-05-25 01:43:41.083613	2469
3396	48	2016-05-25 01:43:41.089654	2442
3397	48	2016-05-25 01:43:41.1112	2474
3398	48	2016-05-25 01:43:41.131816	2486
3399	48	2016-05-25 01:43:41.138217	2476
3400	48	2016-05-25 01:43:41.144373	2492
3401	48	2016-05-25 01:43:41.150606	2448
3402	48	2016-05-25 01:43:41.156274	2490
3403	48	2016-05-25 01:43:41.162158	2440
3404	48	2016-05-25 01:43:41.169092	2452
3405	48	2016-05-25 01:43:41.175243	2468
3406	48	2016-05-25 01:43:41.181149	2450
3407	48	2016-05-25 01:43:41.187818	2470
3408	48	2016-05-25 01:43:41.193596	2461
3409	48	2016-05-25 01:43:41.200902	2455
3410	48	2016-05-25 01:43:41.208269	2478
3411	48	2016-05-25 01:43:41.214248	2488
3412	48	2016-05-25 01:43:41.221304	2494
3413	48	2016-05-25 01:43:41.226849	2484
3414	48	2016-05-25 01:43:41.234198	2457
3415	50	2016-05-25 01:43:41.241073	47209
3416	50	2016-05-25 01:43:41.246331	47203
3417	50	2016-05-25 01:43:41.252639	47212
3418	50	2016-05-25 01:43:41.257782	47215
3419	50	2016-05-25 01:43:41.263003	47206
3420	47	2016-05-25 01:43:41.269907	2500
3421	47	2016-05-25 01:43:41.27538	2374
3422	47	2016-05-25 01:43:41.281435	2475
3423	47	2016-05-25 01:43:41.288252	2498
3424	47	2016-05-25 01:43:41.293883	2480
3425	47	2016-05-25 01:43:41.299513	2454
3426	47	2016-05-25 01:43:41.30579	2465
3427	47	2016-05-25 01:43:41.311451	2459
3428	47	2016-05-25 01:43:41.317384	2472
3429	47	2016-05-25 01:43:41.323111	2467
3430	47	2016-05-25 01:43:41.328696	2504
3431	47	2016-05-25 01:43:41.335669	2469
3432	47	2016-05-25 01:43:41.341382	2442
3433	47	2016-05-25 01:43:41.346963	2474
3434	47	2016-05-25 01:43:41.353468	2486
3435	47	2016-05-25 01:43:41.359143	2476
3436	47	2016-05-25 01:43:41.364798	2492
3437	47	2016-05-25 01:43:41.371056	2448
3438	47	2016-05-25 01:43:41.376766	2490
3439	47	2016-05-25 01:43:41.382452	2440
3440	47	2016-05-25 01:43:41.388997	2452
3441	47	2016-05-25 01:43:41.394478	2468
3442	47	2016-05-25 01:43:41.40025	2450
3443	47	2016-05-25 01:43:41.406481	2470
3444	47	2016-05-25 01:43:41.41169	2506
3445	47	2016-05-25 01:43:41.418165	2461
3446	47	2016-05-25 01:43:41.424016	2502
3447	47	2016-05-25 01:43:41.429913	2455
3448	47	2016-05-25 01:43:41.437094	2478
3449	47	2016-05-25 01:43:41.442557	2488
3450	47	2016-05-25 01:43:41.447777	2494
3451	47	2016-05-25 01:43:41.453433	2484
3452	47	2016-05-25 01:43:41.458937	2457
3453	47	2016-05-25 01:43:41.464243	2482
3454	47	2016-05-25 01:43:41.470718	2463
3455	47	2016-05-25 01:43:41.476225	2444
3456	47	2016-05-25 01:43:41.48143	2496
3457	40	2016-05-25 01:44:15.332612	47256
3458	49	2016-05-25 01:44:15.347699	47256
3459	50	2016-05-25 01:44:15.565145	47256
3460	41	2016-05-25 01:44:58.383784	2378
3461	46	2016-05-25 01:44:58.390517	2398
3462	45	2016-05-25 01:44:58.396413	2400
3463	44	2016-05-25 01:44:58.402282	2382
3464	42	2016-05-25 01:44:58.407783	2444
3465	42	2016-05-25 01:44:58.412655	2486
3466	42	2016-05-25 01:44:58.418415	2450
3467	42	2016-05-25 01:44:58.424201	2452
3468	42	2016-05-25 01:44:58.429949	2455
3469	42	2016-05-25 01:44:58.436271	2482
3470	42	2016-05-25 01:44:58.44166	2488
3471	42	2016-05-25 01:44:58.446824	2472
3472	42	2016-05-25 01:44:58.452549	2500
3473	42	2016-05-25 01:44:58.457988	2374
3474	42	2016-05-25 01:44:58.463014	2442
3475	42	2016-05-25 01:44:58.469865	2496
3476	42	2016-05-25 01:44:58.476637	2467
3477	42	2016-05-25 01:44:58.481794	2490
3478	42	2016-05-25 01:44:58.487346	2504
3479	42	2016-05-25 01:44:58.492558	2494
3480	42	2016-05-25 01:44:58.498	2470
3481	42	2016-05-25 01:44:58.503487	2498
3482	42	2016-05-25 01:44:58.508616	2484
3483	42	2016-05-25 01:44:58.513552	2506
3484	42	2016-05-25 01:44:58.519027	2440
3485	42	2016-05-25 01:44:58.524159	2468
3486	42	2016-05-25 01:44:58.529136	2478
3487	42	2016-05-25 01:44:58.534367	2480
3488	42	2016-05-25 01:44:58.539673	2457
3489	42	2016-05-25 01:44:58.544808	2475
3490	42	2016-05-25 01:44:58.550198	2502
3491	42	2016-05-25 01:44:58.555496	2459
3492	42	2016-05-25 01:44:58.560552	2463
3493	42	2016-05-25 01:44:58.565626	2476
3494	42	2016-05-25 01:44:58.570957	2448
3495	42	2016-05-25 01:44:58.576374	2465
3496	42	2016-05-25 01:44:58.581342	2461
3497	42	2016-05-25 01:44:58.587259	2469
3498	42	2016-05-25 01:44:58.592619	2474
3499	42	2016-05-25 01:44:58.598041	2492
3500	43	2016-05-25 01:44:58.603583	2462
3501	43	2016-05-25 01:44:58.609135	2466
3502	43	2016-05-25 01:44:58.614286	2489
3503	43	2016-05-25 01:44:58.619756	2477
3504	43	2016-05-25 01:44:58.624602	2481
3505	43	2016-05-25 01:44:58.630242	2453
3506	43	2016-05-25 01:44:58.636705	2491
3507	43	2016-05-25 01:44:58.642335	2483
3508	43	2016-05-25 01:44:58.647577	2443
3509	43	2016-05-25 01:44:58.653353	2501
3510	43	2016-05-25 01:44:58.659121	2375
3511	43	2016-05-25 01:44:58.664744	2458
3512	43	2016-05-25 01:44:58.670485	2499
3513	43	2016-05-25 01:44:58.676636	2471
3514	43	2016-05-25 01:44:58.681934	2487
3515	43	2016-05-25 01:44:58.688046	2441
3516	43	2016-05-25 01:44:58.693205	2451
3517	43	2016-05-25 01:44:58.69879	2507
3518	43	2016-05-25 01:44:58.704111	2464
3519	43	2016-05-25 01:44:58.709141	2497
3520	43	2016-05-25 01:44:58.714434	2460
3521	43	2016-05-25 01:44:58.721221	2493
3522	43	2016-05-25 01:44:58.727168	2473
3523	43	2016-05-25 01:44:58.732412	2445
3524	43	2016-05-25 01:44:58.738468	2485
3525	43	2016-05-25 01:44:58.743685	2495
3526	43	2016-05-25 01:44:58.749351	2449
3527	43	2016-05-25 01:44:58.754845	2505
3528	43	2016-05-25 01:44:58.760382	2479
3529	43	2016-05-25 01:44:58.766605	2456
3530	43	2016-05-25 01:44:58.772147	2503
3531	40	2016-05-25 01:44:58.778183	47212
3532	40	2016-05-25 01:44:58.783065	47206
3533	40	2016-05-25 01:44:58.789028	47215
3534	40	2016-05-25 01:44:58.794822	47209
3535	40	2016-05-25 01:44:58.803989	47203
3536	49	2016-05-25 01:44:58.810274	47209
3537	49	2016-05-25 01:44:58.820584	47203
3538	49	2016-05-25 01:44:58.825568	47212
3539	49	2016-05-25 01:44:58.830826	47215
3540	49	2016-05-25 01:44:58.836589	47206
3541	48	2016-05-25 01:44:58.842939	2500
3542	48	2016-05-25 01:44:58.848843	2374
3543	48	2016-05-25 01:44:58.855105	2475
3544	48	2016-05-25 01:44:58.860801	2498
3545	48	2016-05-25 01:44:58.866732	2480
3546	48	2016-05-25 01:44:58.872297	2454
3547	48	2016-05-25 01:44:58.878079	2465
3548	48	2016-05-25 01:44:58.884039	2459
3549	48	2016-05-25 01:44:58.889762	2472
3550	48	2016-05-25 01:44:58.895638	2467
3551	48	2016-05-25 01:44:58.901362	2504
3552	48	2016-05-25 01:44:58.907126	2469
3553	48	2016-05-25 01:44:58.913086	2442
3554	48	2016-05-25 01:44:58.919289	2474
3555	48	2016-05-25 01:44:58.925322	2486
3556	48	2016-05-25 01:44:58.931057	2476
3557	48	2016-05-25 01:44:58.937181	2492
3558	48	2016-05-25 01:44:58.94388	2448
3559	48	2016-05-25 01:44:58.950097	2490
3560	48	2016-05-25 01:44:58.955868	2440
3561	48	2016-05-25 01:44:58.961438	2452
3562	48	2016-05-25 01:44:58.968181	2468
3563	48	2016-05-25 01:44:58.974216	2450
3564	48	2016-05-25 01:44:58.980162	2470
3565	48	2016-05-25 01:44:58.98613	2506
3566	48	2016-05-25 01:44:58.99196	2461
3567	48	2016-05-25 01:44:58.999367	2502
3568	48	2016-05-25 01:44:59.005313	2455
3569	48	2016-05-25 01:44:59.011574	2478
3570	48	2016-05-25 01:44:59.01793	2488
3571	48	2016-05-25 01:44:59.023824	2494
3572	48	2016-05-25 01:44:59.031229	2484
3573	48	2016-05-25 01:44:59.038385	2457
3574	48	2016-05-25 01:44:59.044364	2482
3575	48	2016-05-25 01:44:59.051652	2463
3576	48	2016-05-25 01:44:59.057334	2444
3577	48	2016-05-25 01:44:59.064233	2496
3578	50	2016-05-25 01:44:59.070734	47209
3579	50	2016-05-25 01:44:59.081793	47203
3580	50	2016-05-25 01:44:59.087509	47212
3581	50	2016-05-25 01:44:59.09302	47215
3582	50	2016-05-25 01:44:59.099648	47206
3583	47	2016-05-25 01:44:59.107469	2500
3584	47	2016-05-25 01:44:59.114317	2374
3585	47	2016-05-25 01:44:59.120398	2475
3586	47	2016-05-25 01:44:59.126285	2498
3587	47	2016-05-25 01:44:59.133	2480
3588	47	2016-05-25 01:44:59.139095	2454
3589	47	2016-05-25 01:44:59.144599	2465
3590	47	2016-05-25 01:44:59.151585	2459
3591	47	2016-05-25 01:44:59.157345	2472
3592	47	2016-05-25 01:44:59.163602	2467
3593	47	2016-05-25 01:44:59.169848	2504
3594	47	2016-05-25 01:44:59.191821	2469
3595	47	2016-05-25 01:44:59.212694	2442
3596	47	2016-05-25 01:44:59.21966	2474
3597	47	2016-05-25 01:44:59.225242	2486
3598	47	2016-05-25 01:44:59.23237	2476
3599	47	2016-05-25 01:44:59.239073	2492
3600	47	2016-05-25 01:44:59.244783	2448
3601	47	2016-05-25 01:44:59.251445	2490
3602	47	2016-05-25 01:44:59.256916	2440
3603	47	2016-05-25 01:44:59.262818	2452
3604	47	2016-05-25 01:44:59.269667	2468
3605	47	2016-05-25 01:44:59.275491	2450
3606	47	2016-05-25 01:44:59.281496	2470
3607	47	2016-05-25 01:44:59.287874	2506
3608	47	2016-05-25 01:44:59.293793	2461
3609	47	2016-05-25 01:44:59.300105	2502
3610	47	2016-05-25 01:44:59.30588	2455
3611	47	2016-05-25 01:44:59.311372	2478
3612	47	2016-05-25 01:44:59.317054	2488
3613	47	2016-05-25 01:44:59.322487	2494
3614	47	2016-05-25 01:44:59.327856	2484
3615	47	2016-05-25 01:44:59.333499	2457
3616	47	2016-05-25 01:44:59.338831	2482
3617	47	2016-05-25 01:44:59.344211	2463
3618	47	2016-05-25 01:44:59.350014	2444
3619	47	2016-05-25 01:44:59.355596	2496
3620	40	2016-05-25 01:45:23.689256	47256
3621	49	2016-05-25 01:45:23.704708	47256
3622	50	2016-05-25 01:45:23.949777	47256
3623	41	2016-05-25 01:47:45.272636	2378
3624	46	2016-05-25 01:47:45.279534	2398
3625	45	2016-05-25 01:47:45.286636	2400
3626	44	2016-05-25 01:47:45.293372	2382
3627	42	2016-05-25 01:47:45.299761	2444
3628	42	2016-05-25 01:47:45.305973	2486
3629	42	2016-05-25 01:47:45.311829	2450
3630	42	2016-05-25 01:47:45.317739	2452
3631	42	2016-05-25 01:47:45.324066	2455
3632	42	2016-05-25 01:47:45.329908	2482
3633	42	2016-05-25 01:47:45.336007	2488
3634	42	2016-05-25 01:47:45.346877	2472
3635	42	2016-05-25 01:47:45.353065	2500
3636	42	2016-05-25 01:47:45.358212	2374
3637	42	2016-05-25 01:47:45.363445	2442
3638	42	2016-05-25 01:47:45.3685	2496
3639	42	2016-05-25 01:47:45.373992	2467
3640	42	2016-05-25 01:47:45.379134	2490
3641	42	2016-05-25 01:47:45.384118	2504
3642	42	2016-05-25 01:47:45.389479	2494
3643	42	2016-05-25 01:47:45.394582	2470
3644	42	2016-05-25 01:47:45.399625	2498
3645	42	2016-05-25 01:47:45.404962	2484
3646	42	2016-05-25 01:47:45.409894	2506
3647	42	2016-05-25 01:47:45.414777	2440
3648	42	2016-05-25 01:47:45.42013	2468
3649	42	2016-05-25 01:47:45.42601	2478
3650	42	2016-05-25 01:47:45.431933	2480
3651	42	2016-05-25 01:47:45.43768	2457
3652	42	2016-05-25 01:47:45.444252	2475
3653	42	2016-05-25 01:47:45.449343	2502
3654	42	2016-05-25 01:47:45.454727	2459
3655	42	2016-05-25 01:47:45.459712	2463
3656	42	2016-05-25 01:47:45.465864	2476
3657	42	2016-05-25 01:47:45.471337	2448
3658	42	2016-05-25 01:47:45.476582	2465
3659	42	2016-05-25 01:47:45.482905	2461
3660	42	2016-05-25 01:47:45.48847	2469
3661	42	2016-05-25 01:47:45.494279	2474
3662	42	2016-05-25 01:47:45.499452	2492
3663	43	2016-05-25 01:47:45.506344	2462
3664	43	2016-05-25 01:47:45.511975	2466
3665	43	2016-05-25 01:47:45.517147	2489
3666	43	2016-05-25 01:47:45.523943	2477
3667	43	2016-05-25 01:47:45.529364	2481
3668	43	2016-05-25 01:47:45.534748	2453
3669	43	2016-05-25 01:47:45.541568	2491
3670	43	2016-05-25 01:47:45.547035	2483
3671	43	2016-05-25 01:47:45.553927	2443
3672	43	2016-05-25 01:47:45.559724	2501
3673	43	2016-05-25 01:47:45.565088	2375
3674	43	2016-05-25 01:47:45.571677	2458
3675	43	2016-05-25 01:47:45.57735	2499
3676	43	2016-05-25 01:47:45.582953	2471
3677	43	2016-05-25 01:47:45.589695	2487
3678	43	2016-05-25 01:47:45.595467	2441
3679	43	2016-05-25 01:47:45.601018	2451
3680	43	2016-05-25 01:47:45.607216	2507
3681	43	2016-05-25 01:47:45.612501	2464
3682	43	2016-05-25 01:47:45.617827	2497
3683	43	2016-05-25 01:47:45.624599	2460
3684	43	2016-05-25 01:47:45.630193	2493
3685	43	2016-05-25 01:47:45.636213	2473
3686	43	2016-05-25 01:47:45.643047	2445
3687	43	2016-05-25 01:47:45.649305	2485
3688	43	2016-05-25 01:47:45.655678	2495
3689	43	2016-05-25 01:47:45.661165	2449
3690	43	2016-05-25 01:47:45.666909	2505
3691	43	2016-05-25 01:47:45.673451	2479
3692	43	2016-05-25 01:47:45.678796	2456
3693	43	2016-05-25 01:47:45.684376	2503
3694	40	2016-05-25 01:47:45.691321	47212
3695	40	2016-05-25 01:47:45.696348	47206
3696	40	2016-05-25 01:47:45.700939	47215
3697	40	2016-05-25 01:47:45.707466	47209
3698	40	2016-05-25 01:47:45.728202	47256
3699	40	2016-05-25 01:47:45.748296	47203
3700	49	2016-05-25 01:47:45.754966	47209
3701	49	2016-05-25 01:47:45.760662	47256
3702	49	2016-05-25 01:47:45.765761	47203
3703	49	2016-05-25 01:47:45.771585	47212
3704	49	2016-05-25 01:47:45.777814	47215
3705	49	2016-05-25 01:47:45.78304	47206
3706	48	2016-05-25 01:47:45.79014	2500
3707	48	2016-05-25 01:47:45.79635	2374
3708	48	2016-05-25 01:47:45.802791	2475
3709	48	2016-05-25 01:47:45.809576	2498
3710	48	2016-05-25 01:47:45.815609	2480
3711	48	2016-05-25 01:47:45.821861	2454
3712	48	2016-05-25 01:47:45.829077	2465
3713	48	2016-05-25 01:47:45.835732	2459
3714	48	2016-05-25 01:47:45.842688	2472
3715	48	2016-05-25 01:47:45.848485	2467
3716	48	2016-05-25 01:47:45.85461	2504
3717	48	2016-05-25 01:47:45.86071	2469
3718	48	2016-05-25 01:47:45.866596	2442
3719	48	2016-05-25 01:47:45.872491	2474
3720	48	2016-05-25 01:47:45.878014	2486
3721	48	2016-05-25 01:47:45.883866	2476
3722	48	2016-05-25 01:47:45.889801	2492
3723	48	2016-05-25 01:47:45.895578	2448
3724	48	2016-05-25 01:47:45.90138	2490
3725	48	2016-05-25 01:47:45.907164	2440
3726	48	2016-05-25 01:47:45.912778	2452
3727	48	2016-05-25 01:47:45.918847	2468
3728	48	2016-05-25 01:47:45.924683	2450
3729	48	2016-05-25 01:47:45.930324	2470
3730	48	2016-05-25 01:47:45.936036	2506
3731	48	2016-05-25 01:47:45.941643	2461
3732	48	2016-05-25 01:47:45.947107	2502
3733	48	2016-05-25 01:47:45.953202	2455
3734	48	2016-05-25 01:47:45.958908	2478
3735	48	2016-05-25 01:47:45.965571	2488
3736	48	2016-05-25 01:47:45.97142	2494
3737	48	2016-05-25 01:47:45.97713	2484
3738	48	2016-05-25 01:47:45.982726	2457
3739	48	2016-05-25 01:47:45.988808	2482
3740	48	2016-05-25 01:47:45.994607	2463
3741	48	2016-05-25 01:47:46.000457	2444
3742	48	2016-05-25 01:47:46.006365	2496
3743	50	2016-05-25 01:47:46.013058	47209
3744	50	2016-05-25 01:47:46.018955	47256
3745	50	2016-05-25 01:47:46.024763	47203
3746	50	2016-05-25 01:47:46.029997	47212
3747	50	2016-05-25 01:47:46.035992	47215
3748	50	2016-05-25 01:47:46.041796	47206
3749	47	2016-05-25 01:47:46.047754	2500
3750	47	2016-05-25 01:47:46.053492	2374
3751	47	2016-05-25 01:47:46.059032	2475
3752	47	2016-05-25 01:47:46.06438	2498
3753	47	2016-05-25 01:47:46.070455	2480
3754	47	2016-05-25 01:47:46.076195	2454
3755	47	2016-05-25 01:47:46.081714	2465
3756	47	2016-05-25 01:47:46.087394	2459
3757	47	2016-05-25 01:47:46.092827	2472
3758	47	2016-05-25 01:47:46.098311	2467
3759	47	2016-05-25 01:47:46.104125	2504
3760	47	2016-05-25 01:47:46.109769	2469
3761	47	2016-05-25 01:47:46.115194	2442
3762	47	2016-05-25 01:47:46.120917	2474
3763	47	2016-05-25 01:47:46.12638	2486
3764	47	2016-05-25 01:47:46.13197	2476
3765	47	2016-05-25 01:47:46.138175	2492
3766	47	2016-05-25 01:47:46.144128	2448
3767	47	2016-05-25 01:47:46.149735	2490
3768	47	2016-05-25 01:47:46.155989	2440
3769	47	2016-05-25 01:47:46.162761	2452
3770	47	2016-05-25 01:47:46.170539	2468
3771	47	2016-05-25 01:47:46.176673	2450
3772	47	2016-05-25 01:47:46.182206	2470
3773	47	2016-05-25 01:47:46.189355	2506
3774	47	2016-05-25 01:47:46.195198	2461
3775	47	2016-05-25 01:47:46.201448	2502
3776	47	2016-05-25 01:47:46.208035	2455
3777	47	2016-05-25 01:47:46.21362	2478
3778	47	2016-05-25 01:47:46.220553	2488
3779	47	2016-05-25 01:47:46.226892	2494
3780	47	2016-05-25 01:47:46.232852	2484
3781	47	2016-05-25 01:47:46.240471	2457
3782	47	2016-05-25 01:47:46.245955	2482
3783	47	2016-05-25 01:47:46.252574	2463
3784	47	2016-05-25 01:47:46.258886	2444
3785	47	2016-05-25 01:47:46.264865	2496
3786	41	2016-05-25 01:48:47.330388	2378
3787	46	2016-05-25 01:48:47.338493	2398
3788	45	2016-05-25 01:48:47.345367	2400
3789	44	2016-05-25 01:48:47.351584	2382
3790	42	2016-05-25 01:48:47.358121	2444
3791	42	2016-05-25 01:48:47.364164	2486
3792	42	2016-05-25 01:48:47.370123	2450
3793	42	2016-05-25 01:48:47.376624	2452
3794	42	2016-05-25 01:48:47.382353	2455
3795	42	2016-05-25 01:48:47.387303	2482
3796	42	2016-05-25 01:48:47.393915	2488
3797	42	2016-05-25 01:48:47.399524	2472
3798	42	2016-05-25 01:48:47.405194	2500
3799	42	2016-05-25 01:48:47.411271	2374
3800	42	2016-05-25 01:48:47.416924	2442
3801	42	2016-05-25 01:48:47.423609	2496
3802	42	2016-05-25 01:48:47.433054	2467
3803	42	2016-05-25 01:48:47.438998	2490
3804	42	2016-05-25 01:48:47.446325	2504
3805	42	2016-05-25 01:48:47.451792	2494
3806	42	2016-05-25 01:48:47.45797	2470
3807	42	2016-05-25 01:48:47.465217	2498
3808	42	2016-05-25 01:48:47.470633	2484
3809	42	2016-05-25 01:48:47.475661	2506
3810	42	2016-05-25 01:48:47.481965	2440
3811	42	2016-05-25 01:48:47.487507	2468
3812	42	2016-05-25 01:48:47.493603	2478
3813	42	2016-05-25 01:48:47.499155	2480
3814	42	2016-05-25 01:48:47.504743	2457
3815	42	2016-05-25 01:48:47.510672	2475
3816	42	2016-05-25 01:48:47.516289	2502
3817	42	2016-05-25 01:48:47.522269	2459
3818	42	2016-05-25 01:48:47.528454	2463
3819	42	2016-05-25 01:48:47.533719	2476
3820	42	2016-05-25 01:48:47.539262	2448
3821	42	2016-05-25 01:48:47.545749	2465
3822	42	2016-05-25 01:48:47.551028	2461
3823	42	2016-05-25 01:48:47.556963	2469
3824	42	2016-05-25 01:48:47.5625	2474
3825	42	2016-05-25 01:48:47.567635	2492
3826	43	2016-05-25 01:48:47.573413	2462
3827	43	2016-05-25 01:48:47.578909	2466
3828	43	2016-05-25 01:48:47.584049	2489
3829	43	2016-05-25 01:48:47.589874	2477
3830	43	2016-05-25 01:48:47.594983	2481
3831	43	2016-05-25 01:48:47.600192	2453
3832	43	2016-05-25 01:48:47.605814	2491
3833	43	2016-05-25 01:48:47.611267	2483
3834	43	2016-05-25 01:48:47.616496	2443
3835	43	2016-05-25 01:48:47.621945	2501
3836	43	2016-05-25 01:48:47.628373	2375
3837	43	2016-05-25 01:48:47.633788	2458
3838	43	2016-05-25 01:48:47.639177	2499
3839	43	2016-05-25 01:48:47.644858	2471
3840	43	2016-05-25 01:48:47.650377	2487
3841	43	2016-05-25 01:48:47.656011	2441
3842	43	2016-05-25 01:48:47.661575	2451
3843	43	2016-05-25 01:48:47.666799	2507
3844	43	2016-05-25 01:48:47.672372	2464
3845	43	2016-05-25 01:48:47.677918	2497
3846	43	2016-05-25 01:48:47.68349	2460
3847	43	2016-05-25 01:48:47.690065	2493
3848	43	2016-05-25 01:48:47.696553	2473
3849	43	2016-05-25 01:48:47.701744	2445
3850	43	2016-05-25 01:48:47.707455	2485
3851	43	2016-05-25 01:48:47.712674	2495
3852	43	2016-05-25 01:48:47.717904	2449
3853	43	2016-05-25 01:48:47.723213	2505
3854	43	2016-05-25 01:48:47.728088	2479
3855	43	2016-05-25 01:48:47.733275	2456
3856	43	2016-05-25 01:48:47.73895	2503
3857	40	2016-05-25 01:48:47.745578	47212
3858	40	2016-05-25 01:48:47.750236	47206
3859	40	2016-05-25 01:48:47.755019	47215
3860	40	2016-05-25 01:48:47.760162	47209
3861	40	2016-05-25 01:48:47.76477	47256
3862	40	2016-05-25 01:48:47.769083	47203
3863	49	2016-05-25 01:48:47.775183	47209
3864	49	2016-05-25 01:48:47.780035	47256
3865	49	2016-05-25 01:48:47.785004	47203
3866	49	2016-05-25 01:48:47.790304	47212
3867	49	2016-05-25 01:48:47.795277	47215
3868	49	2016-05-25 01:48:47.800276	47206
3869	48	2016-05-25 01:48:47.806754	2500
3870	48	2016-05-25 01:48:47.812598	2374
3871	48	2016-05-25 01:48:47.818159	2475
3872	48	2016-05-25 01:48:47.824497	2498
3873	48	2016-05-25 01:48:47.830184	2480
3874	48	2016-05-25 01:48:47.835627	2454
3875	48	2016-05-25 01:48:47.842404	2465
3876	48	2016-05-25 01:48:47.848176	2459
3877	48	2016-05-25 01:48:47.854155	2472
3878	48	2016-05-25 01:48:47.860175	2467
3879	48	2016-05-25 01:48:47.865934	2504
3880	48	2016-05-25 01:48:47.87168	2469
3881	48	2016-05-25 01:48:47.877656	2442
3882	48	2016-05-25 01:48:47.88346	2474
3883	48	2016-05-25 01:48:47.889692	2486
3884	48	2016-05-25 01:48:47.895549	2476
3885	48	2016-05-25 01:48:47.901224	2492
3886	48	2016-05-25 01:48:47.907329	2448
3887	48	2016-05-25 01:48:47.913154	2490
3888	48	2016-05-25 01:48:47.91875	2440
3889	48	2016-05-25 01:48:47.924831	2452
3890	48	2016-05-25 01:48:47.930655	2468
3891	48	2016-05-25 01:48:47.936484	2450
3892	48	2016-05-25 01:48:47.942476	2470
3893	48	2016-05-25 01:48:47.948138	2506
3894	48	2016-05-25 01:48:47.954764	2461
3895	48	2016-05-25 01:48:47.962375	2502
3896	48	2016-05-25 01:48:47.968357	2455
3897	48	2016-05-25 01:48:47.975113	2478
3898	48	2016-05-25 01:48:47.980734	2488
3899	48	2016-05-25 01:48:47.987162	2494
3900	48	2016-05-25 01:48:47.993536	2484
3901	48	2016-05-25 01:48:47.999254	2457
3902	48	2016-05-25 01:48:48.005727	2482
3903	48	2016-05-25 01:48:48.011804	2463
3904	48	2016-05-25 01:48:48.017811	2444
3905	48	2016-05-25 01:48:48.024382	2496
3906	50	2016-05-25 01:48:48.030351	47209
3907	50	2016-05-25 01:48:48.037088	47256
3908	50	2016-05-25 01:48:48.046191	47203
3909	50	2016-05-25 01:48:48.055052	47212
3910	50	2016-05-25 01:48:48.061818	47215
3911	50	2016-05-25 01:48:48.069325	47206
3912	47	2016-05-25 01:48:48.080507	2500
3913	47	2016-05-25 01:48:48.095208	2374
3914	47	2016-05-25 01:48:48.107362	2475
3915	47	2016-05-25 01:48:48.117085	2498
3916	47	2016-05-25 01:48:48.131072	2480
3917	47	2016-05-25 01:48:48.263548	2454
3918	47	2016-05-25 01:48:48.332364	2465
3919	47	2016-05-25 01:48:48.356575	2459
3920	47	2016-05-25 01:48:48.364148	2472
3921	47	2016-05-25 01:48:48.375349	2467
3922	47	2016-05-25 01:48:48.382704	2504
3923	47	2016-05-25 01:48:48.394135	2469
3924	47	2016-05-25 01:48:48.400983	2442
3925	47	2016-05-25 01:48:48.412747	2474
3926	47	2016-05-25 01:48:48.423325	2486
3927	47	2016-05-25 01:48:48.431435	2476
3928	47	2016-05-25 01:48:48.441917	2492
3929	47	2016-05-25 01:48:48.449388	2448
3930	47	2016-05-25 01:48:48.460432	2490
3931	47	2016-05-25 01:48:48.472789	2440
3932	47	2016-05-25 01:48:48.480157	2452
3933	47	2016-05-25 01:48:48.491855	2468
3934	47	2016-05-25 01:48:48.500219	2450
3935	47	2016-05-25 01:48:48.510491	2470
3936	47	2016-05-25 01:48:48.51726	2506
3937	47	2016-05-25 01:48:48.527054	2461
3938	47	2016-05-25 01:48:48.533745	2502
3939	47	2016-05-25 01:48:48.543218	2455
3940	47	2016-05-25 01:48:48.551286	2478
3941	47	2016-05-25 01:48:48.561406	2488
3942	47	2016-05-25 01:48:48.568582	2494
3943	47	2016-05-25 01:48:48.576927	2484
3944	47	2016-05-25 01:48:48.584284	2457
3945	47	2016-05-25 01:48:48.591516	2482
3946	47	2016-05-25 01:48:48.59831	2463
3947	47	2016-05-25 01:48:48.606928	2444
3948	47	2016-05-25 01:48:48.614352	2496
3949	42	2016-05-25 01:49:13.490904	2514
3950	40	2016-05-25 01:49:37.064652	47340
3951	41	2016-05-25 01:49:49.882724	2378
3952	46	2016-05-25 01:49:49.892114	2398
3953	45	2016-05-25 01:49:49.899778	2400
3954	44	2016-05-25 01:49:49.90657	2382
3955	42	2016-05-25 01:49:49.913158	2444
3956	42	2016-05-25 01:49:49.920148	2486
3957	42	2016-05-25 01:49:49.926477	2450
3958	42	2016-05-25 01:49:49.932086	2452
3959	42	2016-05-25 01:49:49.937124	2455
3960	42	2016-05-25 01:49:49.94268	2482
3961	42	2016-05-25 01:49:49.94767	2488
3962	42	2016-05-25 01:49:49.952815	2472
3963	42	2016-05-25 01:49:49.958346	2500
3964	42	2016-05-25 01:49:49.964288	2374
3965	42	2016-05-25 01:49:49.969417	2442
3966	42	2016-05-25 01:49:49.974559	2496
3967	42	2016-05-25 01:49:49.979548	2467
3968	42	2016-05-25 01:49:49.984699	2490
3969	42	2016-05-25 01:49:49.990228	2504
3970	42	2016-05-25 01:49:49.995493	2494
3971	42	2016-05-25 01:49:50.000639	2470
3972	42	2016-05-25 01:49:50.005826	2498
3973	42	2016-05-25 01:49:50.011065	2484
3974	42	2016-05-25 01:49:50.016201	2506
3975	42	2016-05-25 01:49:50.021782	2440
3976	42	2016-05-25 01:49:50.027781	2468
3977	42	2016-05-25 01:49:50.03296	2478
3978	42	2016-05-25 01:49:50.038046	2480
3979	42	2016-05-25 01:49:50.043548	2457
3980	42	2016-05-25 01:49:50.048736	2475
3981	42	2016-05-25 01:49:50.053925	2502
3982	42	2016-05-25 01:49:50.059568	2459
3983	42	2016-05-25 01:49:50.064822	2463
3984	42	2016-05-25 01:49:50.069876	2476
3985	42	2016-05-25 01:49:50.075416	2448
3986	42	2016-05-25 01:49:50.080599	2465
3987	42	2016-05-25 01:49:50.085757	2461
3988	42	2016-05-25 01:49:50.091083	2469
3989	42	2016-05-25 01:49:50.096261	2474
3990	42	2016-05-25 01:49:50.101207	2492
3991	43	2016-05-25 01:49:50.107091	2462
3992	43	2016-05-25 01:49:50.112504	2466
3993	43	2016-05-25 01:49:50.117599	2489
3994	43	2016-05-25 01:49:50.122837	2477
3995	43	2016-05-25 01:49:50.127869	2481
3996	43	2016-05-25 01:49:50.132872	2453
3997	43	2016-05-25 01:49:50.137875	2491
3998	43	2016-05-25 01:49:50.143509	2483
3999	43	2016-05-25 01:49:50.148568	2443
4000	43	2016-05-25 01:49:50.15364	2501
4001	43	2016-05-25 01:49:50.159005	2375
4002	43	2016-05-25 01:49:50.165594	2458
4003	43	2016-05-25 01:49:50.170946	2499
4004	43	2016-05-25 01:49:50.176652	2471
4005	43	2016-05-25 01:49:50.181772	2487
4006	43	2016-05-25 01:49:50.186987	2441
4007	43	2016-05-25 01:49:50.192611	2451
4008	43	2016-05-25 01:49:50.197769	2507
4009	43	2016-05-25 01:49:50.2028	2464
4010	43	2016-05-25 01:49:50.208219	2497
4011	43	2016-05-25 01:49:50.213458	2460
4012	43	2016-05-25 01:49:50.218603	2493
4013	43	2016-05-25 01:49:50.224815	2473
4014	43	2016-05-25 01:49:50.230085	2445
4015	43	2016-05-25 01:49:50.235143	2485
4016	43	2016-05-25 01:49:50.240516	2495
4017	43	2016-05-25 01:49:50.245838	2449
4018	43	2016-05-25 01:49:50.251077	2505
4019	43	2016-05-25 01:49:50.256636	2479
4020	43	2016-05-25 01:49:50.26178	2456
4021	43	2016-05-25 01:49:50.267194	2503
4022	40	2016-05-25 01:49:50.273229	47212
4023	40	2016-05-25 01:49:50.277685	47206
4024	40	2016-05-25 01:49:50.282065	47215
4025	40	2016-05-25 01:49:50.286633	47209
4026	40	2016-05-25 01:49:50.291329	47256
4027	40	2016-05-25 01:49:50.300377	47203
4028	49	2016-05-25 01:49:50.306562	47209
4029	49	2016-05-25 01:49:50.311409	47256
4030	49	2016-05-25 01:49:50.316437	47203
4031	49	2016-05-25 01:49:50.32166	47212
4032	49	2016-05-25 01:49:50.326958	47215
4033	49	2016-05-25 01:49:50.33215	47206
4034	48	2016-05-25 01:49:50.338623	2500
4035	48	2016-05-25 01:49:50.344574	2374
4036	48	2016-05-25 01:49:50.350442	2475
4037	48	2016-05-25 01:49:50.35647	2498
4038	48	2016-05-25 01:49:50.362719	2480
4039	48	2016-05-25 01:49:50.36817	2454
4040	48	2016-05-25 01:49:50.37414	2465
4041	48	2016-05-25 01:49:50.379954	2459
4042	48	2016-05-25 01:49:50.385814	2472
4043	48	2016-05-25 01:49:50.391879	2467
4044	48	2016-05-25 01:49:50.397538	2504
4045	48	2016-05-25 01:49:50.403166	2469
4046	48	2016-05-25 01:49:50.409534	2442
4047	48	2016-05-25 01:49:50.415237	2474
4048	48	2016-05-25 01:49:50.421476	2486
4049	48	2016-05-25 01:49:50.427771	2476
4050	48	2016-05-25 01:49:50.434994	2492
4051	48	2016-05-25 01:49:50.443019	2448
4052	48	2016-05-25 01:49:50.448903	2490
4053	48	2016-05-25 01:49:50.454812	2440
4054	48	2016-05-25 01:49:50.461694	2452
4055	48	2016-05-25 01:49:50.46759	2468
4056	48	2016-05-25 01:49:50.475231	2450
4057	48	2016-05-25 01:49:50.482275	2470
4058	48	2016-05-25 01:49:50.48846	2506
4059	48	2016-05-25 01:49:50.494779	2461
4060	48	2016-05-25 01:49:50.500653	2502
4061	48	2016-05-25 01:49:50.507054	2455
4062	48	2016-05-25 01:49:50.513557	2478
4063	48	2016-05-25 01:49:50.519141	2488
4064	48	2016-05-25 01:49:50.525151	2494
4065	48	2016-05-25 01:49:50.530884	2484
4066	48	2016-05-25 01:49:50.536564	2457
4067	48	2016-05-25 01:49:50.542934	2482
4068	48	2016-05-25 01:49:50.548969	2463
4069	48	2016-05-25 01:49:50.555056	2444
4070	48	2016-05-25 01:49:50.561022	2496
4071	50	2016-05-25 01:49:50.566985	47209
4072	50	2016-05-25 01:49:50.572264	47256
4073	50	2016-05-25 01:49:50.577354	47203
4074	50	2016-05-25 01:49:50.582668	47212
4075	50	2016-05-25 01:49:50.588356	47215
4076	50	2016-05-25 01:49:50.593731	47206
4077	47	2016-05-25 01:49:50.600299	2500
4078	47	2016-05-25 01:49:50.606168	2374
4079	47	2016-05-25 01:49:50.611871	2475
4080	47	2016-05-25 01:49:50.617404	2498
4081	47	2016-05-25 01:49:50.623886	2480
4082	47	2016-05-25 01:49:50.629608	2454
4083	47	2016-05-25 01:49:50.635136	2465
4084	47	2016-05-25 01:49:50.643882	2459
4085	47	2016-05-25 01:49:50.651687	2472
4086	47	2016-05-25 01:49:50.659529	2467
4087	47	2016-05-25 01:49:50.665184	2504
4088	47	2016-05-25 01:49:50.670837	2469
4089	47	2016-05-25 01:49:50.676913	2442
4090	47	2016-05-25 01:49:50.682479	2474
4091	47	2016-05-25 01:49:50.688053	2486
4092	47	2016-05-25 01:49:50.693806	2476
4093	47	2016-05-25 01:49:50.701167	2492
4094	47	2016-05-25 01:49:50.707177	2448
4095	47	2016-05-25 01:49:50.712795	2490
4096	47	2016-05-25 01:49:50.718348	2440
4097	47	2016-05-25 01:49:50.724514	2452
4098	47	2016-05-25 01:49:50.72999	2468
4099	47	2016-05-25 01:49:50.735433	2450
4100	47	2016-05-25 01:49:50.741384	2470
4101	47	2016-05-25 01:49:50.746939	2506
4102	47	2016-05-25 01:49:50.752469	2461
4103	47	2016-05-25 01:49:50.757878	2502
4104	47	2016-05-25 01:49:50.763454	2455
4105	47	2016-05-25 01:49:50.768739	2478
4106	47	2016-05-25 01:49:50.774648	2488
4107	47	2016-05-25 01:49:50.780236	2494
4108	47	2016-05-25 01:49:50.785628	2484
4109	47	2016-05-25 01:49:50.791364	2457
4110	47	2016-05-25 01:49:50.796848	2482
4111	47	2016-05-25 01:49:50.80238	2463
4112	47	2016-05-25 01:49:50.808253	2444
4113	47	2016-05-25 01:49:50.813753	2496
4114	47	2016-05-25 01:50:32.090442	2514
4115	41	2016-05-25 01:54:33.662377	2518
4116	41	2016-05-25 01:54:33.704298	2519
4117	41	2016-05-25 01:54:33.725482	2378
4118	41	2016-05-25 01:54:33.757626	2516
4119	41	2016-05-25 01:54:33.789652	2517
4120	41	2016-05-25 01:54:33.823512	2520
4121	46	2016-05-25 01:54:33.845391	2398
4122	45	2016-05-25 01:54:33.866396	2400
4123	44	2016-05-25 01:54:33.892518	2382
4124	42	2016-05-25 01:54:33.915991	2444
4125	42	2016-05-25 01:54:33.937531	2486
4126	42	2016-05-25 01:54:33.961339	2450
4127	42	2016-05-25 01:54:33.986036	2452
4128	42	2016-05-25 01:54:34.007824	2455
4129	42	2016-05-25 01:54:34.026594	2482
4130	42	2016-05-25 01:54:34.043774	2488
4131	42	2016-05-25 01:54:34.05963	2472
4132	42	2016-05-25 01:54:34.078698	2500
4133	42	2016-05-25 01:54:34.097791	2374
4134	42	2016-05-25 01:54:34.127788	2442
4135	42	2016-05-25 01:54:34.143056	2496
4136	42	2016-05-25 01:54:34.15856	2467
4137	42	2016-05-25 01:54:34.173652	2490
4138	42	2016-05-25 01:54:34.189193	2504
4139	42	2016-05-25 01:54:34.204485	2494
4140	42	2016-05-25 01:54:34.220966	2470
4141	42	2016-05-25 01:54:34.237231	2498
4142	42	2016-05-25 01:54:34.25339	2484
4143	42	2016-05-25 01:54:34.271069	2506
4144	42	2016-05-25 01:54:34.289556	2440
4145	42	2016-05-25 01:54:34.306149	2468
4146	42	2016-05-25 01:54:34.323593	2478
4147	42	2016-05-25 01:54:34.341773	2480
4148	42	2016-05-25 01:54:34.357379	2457
4149	42	2016-05-25 01:54:34.373358	2475
4150	42	2016-05-25 01:54:34.388757	2502
4151	42	2016-05-25 01:54:34.404265	2459
4152	42	2016-05-25 01:54:34.420636	2463
4153	42	2016-05-25 01:54:34.43838	2476
4154	42	2016-05-25 01:54:34.456169	2448
4155	42	2016-05-25 01:54:34.474803	2465
4156	42	2016-05-25 01:54:34.491437	2461
4157	42	2016-05-25 01:54:34.507147	2469
4158	42	2016-05-25 01:54:34.522742	2474
4159	42	2016-05-25 01:54:34.537269	2492
4160	43	2016-05-25 01:54:34.554031	2462
4161	43	2016-05-25 01:54:34.569804	2466
4162	43	2016-05-25 01:54:34.58484	2489
4163	43	2016-05-25 01:54:34.600696	2477
4164	43	2016-05-25 01:54:34.615705	2481
4165	43	2016-05-25 01:54:34.631008	2453
4166	43	2016-05-25 01:54:34.649885	2491
4167	43	2016-05-25 01:54:34.668228	2483
4168	43	2016-05-25 01:54:34.683642	2443
4169	43	2016-05-25 01:54:34.699036	2501
4170	43	2016-05-25 01:54:34.71479	2375
4171	43	2016-05-25 01:54:34.730466	2458
4172	43	2016-05-25 01:54:34.745465	2499
4173	43	2016-05-25 01:54:34.760532	2471
4174	43	2016-05-25 01:54:34.774964	2487
4175	43	2016-05-25 01:54:34.790067	2441
4176	43	2016-05-25 01:54:34.805111	2451
4177	43	2016-05-25 01:54:34.820864	2507
4178	43	2016-05-25 01:54:34.839792	2464
4179	43	2016-05-25 01:54:34.85701	2497
4180	43	2016-05-25 01:54:34.873019	2460
4181	43	2016-05-25 01:54:34.888265	2493
4182	43	2016-05-25 01:54:34.904163	2473
4183	43	2016-05-25 01:54:34.919862	2445
4184	43	2016-05-25 01:54:34.93565	2485
4185	43	2016-05-25 01:54:34.950652	2495
4186	43	2016-05-25 01:54:34.968399	2449
4187	43	2016-05-25 01:54:34.985885	2505
4188	43	2016-05-25 01:54:35.002315	2479
4189	43	2016-05-25 01:54:35.018539	2456
4190	43	2016-05-25 01:54:35.038547	2503
4191	40	2016-05-25 01:54:35.057327	47212
4192	40	2016-05-25 01:54:35.070918	47206
4193	40	2016-05-25 01:54:35.084701	47215
4194	40	2016-05-25 01:54:35.098662	47209
4195	40	2016-05-25 01:54:35.111842	47256
4196	40	2016-05-25 01:54:35.131068	47340
4197	40	2016-05-25 01:54:35.143938	47203
4198	49	2016-05-25 01:54:35.16279	47209
4199	49	2016-05-25 01:54:35.17691	47256
4200	49	2016-05-25 01:54:35.191915	47212
4201	49	2016-05-25 01:54:35.206741	47206
4202	49	2016-05-25 01:54:35.232664	47340
4203	49	2016-05-25 01:54:35.248588	47203
4204	49	2016-05-25 01:54:35.263525	47215
4205	48	2016-05-25 01:54:35.282223	2500
4206	48	2016-05-25 01:54:35.300491	2374
4207	48	2016-05-25 01:54:35.31834	2475
4208	48	2016-05-25 01:54:35.338797	2498
4209	48	2016-05-25 01:54:35.356562	2480
4210	48	2016-05-25 01:54:35.37393	2454
4211	48	2016-05-25 01:54:35.391382	2465
4212	48	2016-05-25 01:54:35.412268	2459
4213	48	2016-05-25 01:54:35.437806	2472
4214	48	2016-05-25 01:54:35.457949	2467
4215	48	2016-05-25 01:54:35.475441	2504
4216	48	2016-05-25 01:54:35.492721	2469
4217	48	2016-05-25 01:54:35.510773	2442
4218	48	2016-05-25 01:54:35.527943	2474
4219	48	2016-05-25 01:54:35.545704	2486
4220	48	2016-05-25 01:54:35.564881	2476
4221	48	2016-05-25 01:54:35.582081	2492
4222	48	2016-05-25 01:54:35.601918	2448
4223	48	2016-05-25 01:54:35.621785	2490
4224	48	2016-05-25 01:54:35.644539	2440
4225	48	2016-05-25 01:54:35.662394	2452
4226	48	2016-05-25 01:54:35.680501	2468
4227	48	2016-05-25 01:54:35.697596	2450
4228	48	2016-05-25 01:54:35.715306	2470
4229	48	2016-05-25 01:54:35.750592	2506
4230	48	2016-05-25 01:54:35.791738	2461
4231	48	2016-05-25 01:54:35.826742	2502
4232	48	2016-05-25 01:54:35.853878	2455
4233	48	2016-05-25 01:54:35.879622	2478
4234	48	2016-05-25 01:54:35.898126	2488
4235	48	2016-05-25 01:54:35.927343	2494
4236	48	2016-05-25 01:54:35.984353	2484
4237	48	2016-05-25 01:54:36.014408	2514
4238	48	2016-05-25 01:54:36.036829	2457
4239	48	2016-05-25 01:54:36.056987	2482
4240	48	2016-05-25 01:54:36.078552	2463
4241	48	2016-05-25 01:54:36.098032	2444
4242	48	2016-05-25 01:54:36.117296	2496
4243	50	2016-05-25 01:54:36.138331	47209
4244	50	2016-05-25 01:54:36.15488	47256
4245	50	2016-05-25 01:54:36.17788	47203
4246	50	2016-05-25 01:54:36.197283	47212
4247	50	2016-05-25 01:54:36.21555	47215
4248	50	2016-05-25 01:54:36.235938	47206
4249	47	2016-05-25 01:54:36.257456	2500
4250	47	2016-05-25 01:54:36.278915	2374
4251	47	2016-05-25 01:54:36.303108	2475
4252	47	2016-05-25 01:54:36.326307	2498
4253	47	2016-05-25 01:54:36.358641	2480
4254	47	2016-05-25 01:54:36.384687	2454
4255	47	2016-05-25 01:54:36.403453	2465
4256	47	2016-05-25 01:54:36.422051	2459
4257	47	2016-05-25 01:54:36.441448	2472
4258	47	2016-05-25 01:54:36.460099	2467
4259	47	2016-05-25 01:54:36.476701	2504
4260	47	2016-05-25 01:54:36.493777	2469
4261	47	2016-05-25 01:54:36.510648	2442
4262	47	2016-05-25 01:54:36.528348	2474
4263	47	2016-05-25 01:54:36.547204	2486
4264	47	2016-05-25 01:54:36.56697	2476
4265	47	2016-05-25 01:54:36.587729	2492
4266	47	2016-05-25 01:54:36.608163	2448
4267	47	2016-05-25 01:54:36.62699	2490
4268	47	2016-05-25 01:54:36.646802	2440
4269	47	2016-05-25 01:54:36.663307	2452
4270	47	2016-05-25 01:54:36.680686	2468
4271	47	2016-05-25 01:54:36.697792	2450
4272	47	2016-05-25 01:54:36.71476	2470
4273	47	2016-05-25 01:54:36.73182	2506
4274	47	2016-05-25 01:54:36.750343	2461
4275	47	2016-05-25 01:54:36.769635	2502
4276	47	2016-05-25 01:54:36.786501	2455
4277	47	2016-05-25 01:54:36.803734	2478
4278	47	2016-05-25 01:54:36.820678	2488
4279	47	2016-05-25 01:54:36.838636	2494
4280	47	2016-05-25 01:54:36.855078	2484
4281	47	2016-05-25 01:54:36.871994	2514
4282	47	2016-05-25 01:54:36.89084	2457
4283	47	2016-05-25 01:54:36.908587	2482
4284	47	2016-05-25 01:54:36.928203	2463
4285	47	2016-05-25 01:54:36.948837	2444
4286	47	2016-05-25 01:54:36.97038	2496
4287	41	2016-05-25 01:59:07.841148	2518
4288	41	2016-05-25 01:59:07.862471	2378
4289	41	2016-05-25 01:59:07.89657	2517
4290	41	2016-05-25 01:59:07.930983	2522
4291	41	2016-05-25 01:59:07.970217	2520
4292	41	2016-05-25 01:59:08.005251	2521
4293	41	2016-05-25 01:59:08.041567	2523
4294	41	2016-05-25 01:59:08.086846	2516
4295	41	2016-05-25 01:59:08.134224	2519
4296	46	2016-05-25 01:59:08.164397	2398
4297	45	2016-05-25 01:59:08.183774	2400
4298	44	2016-05-25 01:59:08.201801	2382
4299	42	2016-05-25 01:59:08.219442	2444
4300	42	2016-05-25 01:59:08.236795	2486
4301	42	2016-05-25 01:59:08.253473	2450
4302	42	2016-05-25 01:59:08.269076	2452
4303	42	2016-05-25 01:59:08.284467	2455
4304	42	2016-05-25 01:59:08.300486	2482
4305	42	2016-05-25 01:59:08.31619	2488
4306	42	2016-05-25 01:59:08.331233	2472
4307	42	2016-05-25 01:59:08.346734	2500
4308	42	2016-05-25 01:59:08.36234	2374
4309	42	2016-05-25 01:59:08.376858	2442
4310	42	2016-05-25 01:59:08.392878	2496
4311	42	2016-05-25 01:59:08.410567	2467
4312	42	2016-05-25 01:59:08.427217	2490
4313	42	2016-05-25 01:59:08.445253	2504
4314	42	2016-05-25 01:59:08.463035	2494
4315	42	2016-05-25 01:59:08.479409	2470
4316	42	2016-05-25 01:59:08.495086	2498
4317	42	2016-05-25 01:59:08.510424	2484
4318	42	2016-05-25 01:59:08.527912	2506
4319	42	2016-05-25 01:59:08.565339	2440
4320	42	2016-05-25 01:59:08.601524	2468
4321	42	2016-05-25 01:59:08.618664	2478
4322	42	2016-05-25 01:59:08.636567	2480
4323	42	2016-05-25 01:59:08.652296	2457
4324	42	2016-05-25 01:59:08.667992	2475
4325	42	2016-05-25 01:59:08.683265	2502
4326	42	2016-05-25 01:59:08.698138	2459
4327	42	2016-05-25 01:59:08.713516	2463
4328	42	2016-05-25 01:59:08.729132	2476
4329	42	2016-05-25 01:59:08.744528	2448
4330	42	2016-05-25 01:59:08.760605	2465
4331	42	2016-05-25 01:59:08.776139	2461
4332	42	2016-05-25 01:59:08.791319	2469
4333	42	2016-05-25 01:59:08.807252	2474
4334	42	2016-05-25 01:59:08.823448	2492
4335	43	2016-05-25 01:59:08.84175	2462
4336	43	2016-05-25 01:59:08.857139	2466
4337	43	2016-05-25 01:59:08.872587	2489
4338	43	2016-05-25 01:59:08.888198	2477
4339	43	2016-05-25 01:59:08.90359	2481
4340	43	2016-05-25 01:59:08.91901	2453
4341	43	2016-05-25 01:59:08.934301	2491
4342	43	2016-05-25 01:59:08.950652	2483
4343	43	2016-05-25 01:59:08.967251	2443
4344	43	2016-05-25 01:59:08.985762	2501
4345	43	2016-05-25 01:59:09.00132	2375
4346	43	2016-05-25 01:59:09.017477	2458
4347	43	2016-05-25 01:59:09.034452	2499
4348	43	2016-05-25 01:59:09.049394	2471
4349	43	2016-05-25 01:59:09.064698	2487
4350	43	2016-05-25 01:59:09.079843	2441
4351	43	2016-05-25 01:59:09.095923	2451
4352	43	2016-05-25 01:59:09.112273	2507
4353	43	2016-05-25 01:59:09.131822	2464
4354	43	2016-05-25 01:59:09.152456	2497
4355	43	2016-05-25 01:59:09.168878	2460
4356	43	2016-05-25 01:59:09.185681	2493
4357	43	2016-05-25 01:59:09.201255	2473
4358	43	2016-05-25 01:59:09.218929	2445
4359	43	2016-05-25 01:59:09.235355	2485
4360	43	2016-05-25 01:59:09.251061	2495
4361	43	2016-05-25 01:59:09.266685	2449
4362	43	2016-05-25 01:59:09.281795	2505
4363	43	2016-05-25 01:59:09.297274	2479
4364	43	2016-05-25 01:59:09.312002	2456
4365	43	2016-05-25 01:59:09.328364	2503
4366	40	2016-05-25 01:59:09.346464	47212
4367	40	2016-05-25 01:59:09.360585	47206
4368	40	2016-05-25 01:59:09.374237	47215
4369	40	2016-05-25 01:59:09.387787	47209
4370	40	2016-05-25 01:59:09.401405	47256
4371	40	2016-05-25 01:59:09.424238	47340
4372	40	2016-05-25 01:59:09.439735	47203
4373	49	2016-05-25 01:59:09.463195	47209
4374	49	2016-05-25 01:59:09.494642	47256
4375	49	2016-05-25 01:59:09.509969	47212
4376	49	2016-05-25 01:59:09.525493	47206
4377	49	2016-05-25 01:59:09.552767	47340
4378	49	2016-05-25 01:59:09.568627	47203
4379	49	2016-05-25 01:59:09.586597	47215
4380	48	2016-05-25 01:59:09.606434	2500
4381	48	2016-05-25 01:59:09.625476	2374
4382	48	2016-05-25 01:59:09.647823	2475
4383	48	2016-05-25 01:59:09.66884	2498
4384	48	2016-05-25 01:59:09.68703	2480
4385	48	2016-05-25 01:59:09.704329	2454
4386	48	2016-05-25 01:59:09.721458	2465
4387	48	2016-05-25 01:59:09.739183	2459
4388	48	2016-05-25 01:59:09.756997	2472
4389	48	2016-05-25 01:59:09.775017	2467
4390	48	2016-05-25 01:59:09.792721	2504
4391	48	2016-05-25 01:59:09.811862	2469
4392	48	2016-05-25 01:59:09.831164	2442
4393	48	2016-05-25 01:59:09.848999	2474
4394	48	2016-05-25 01:59:09.866502	2486
4395	48	2016-05-25 01:59:09.884418	2476
4396	48	2016-05-25 01:59:09.901778	2492
4397	48	2016-05-25 01:59:09.919379	2448
4398	48	2016-05-25 01:59:09.937167	2490
4399	48	2016-05-25 01:59:09.960205	2440
4400	48	2016-05-25 01:59:09.977922	2452
4401	48	2016-05-25 01:59:09.996094	2468
4402	48	2016-05-25 01:59:10.014683	2450
4403	48	2016-05-25 01:59:10.034104	2470
4404	48	2016-05-25 01:59:10.05155	2506
4405	48	2016-05-25 01:59:10.069555	2461
4406	48	2016-05-25 01:59:10.087029	2502
4407	48	2016-05-25 01:59:10.105331	2455
4408	48	2016-05-25 01:59:10.123175	2478
4409	48	2016-05-25 01:59:10.141604	2488
4410	48	2016-05-25 01:59:10.162511	2494
4411	48	2016-05-25 01:59:10.181945	2484
4412	48	2016-05-25 01:59:10.202125	2514
4413	48	2016-05-25 01:59:10.221202	2457
4414	48	2016-05-25 01:59:10.240943	2482
4415	48	2016-05-25 01:59:10.258651	2463
4416	48	2016-05-25 01:59:10.275869	2444
4417	48	2016-05-25 01:59:10.293387	2496
4418	50	2016-05-25 01:59:10.311375	47209
4419	50	2016-05-25 01:59:10.327665	47256
4420	50	2016-05-25 01:59:10.344199	47212
4421	50	2016-05-25 01:59:10.360743	47206
4422	50	2016-05-25 01:59:10.383398	47340
4423	50	2016-05-25 01:59:10.400366	47203
4424	50	2016-05-25 01:59:10.418426	47215
4425	47	2016-05-25 01:59:10.439139	2500
4426	47	2016-05-25 01:59:10.458127	2374
4427	47	2016-05-25 01:59:10.475751	2475
4428	47	2016-05-25 01:59:10.492872	2498
4429	47	2016-05-25 01:59:10.510356	2480
4430	47	2016-05-25 01:59:10.527318	2454
4431	47	2016-05-25 01:59:10.544771	2465
4432	47	2016-05-25 01:59:10.56216	2459
4433	47	2016-05-25 01:59:10.579262	2472
4434	47	2016-05-25 01:59:10.596699	2467
4435	47	2016-05-25 01:59:10.614757	2504
4436	47	2016-05-25 01:59:10.632842	2469
4437	47	2016-05-25 01:59:10.651	2442
4438	47	2016-05-25 01:59:10.66839	2474
4439	47	2016-05-25 01:59:10.684963	2486
4440	47	2016-05-25 01:59:10.703996	2476
4441	47	2016-05-25 01:59:10.724437	2492
4442	47	2016-05-25 01:59:10.744378	2448
4443	47	2016-05-25 01:59:10.761902	2490
4444	47	2016-05-25 01:59:10.780588	2440
4445	47	2016-05-25 01:59:10.798294	2452
4446	47	2016-05-25 01:59:10.817921	2468
4447	47	2016-05-25 01:59:10.837755	2450
4448	47	2016-05-25 01:59:10.854875	2470
4449	47	2016-05-25 01:59:10.87194	2506
4450	47	2016-05-25 01:59:10.888887	2461
4451	47	2016-05-25 01:59:10.90558	2502
4452	47	2016-05-25 01:59:10.922521	2455
4453	47	2016-05-25 01:59:10.939643	2478
4454	47	2016-05-25 01:59:10.958753	2488
4455	47	2016-05-25 01:59:10.97519	2494
4456	47	2016-05-25 01:59:10.992271	2484
4457	47	2016-05-25 01:59:11.009773	2514
4458	47	2016-05-25 01:59:11.030569	2457
4459	47	2016-05-25 01:59:11.047975	2482
4460	47	2016-05-25 01:59:11.064472	2463
4461	47	2016-05-25 01:59:11.082248	2444
4462	47	2016-05-25 01:59:11.099489	2496
4463	41	2016-05-25 02:01:44.828517	2518
4464	41	2016-05-25 02:01:44.848827	2378
4465	41	2016-05-25 02:01:44.887325	2517
4466	41	2016-05-25 02:01:44.924975	2522
4467	41	2016-05-25 02:01:44.965409	2520
4468	41	2016-05-25 02:01:45.001924	2521
4469	41	2016-05-25 02:01:45.051456	2523
4470	41	2016-05-25 02:01:45.106868	2516
4471	41	2016-05-25 02:01:45.161268	2519
4472	41	2016-05-25 02:01:45.194055	2524
4473	46	2016-05-25 02:01:45.211675	2398
4474	45	2016-05-25 02:01:45.230407	2400
4475	44	2016-05-25 02:01:45.248134	2382
4476	42	2016-05-25 02:01:45.26484	2444
4477	42	2016-05-25 02:01:45.280764	2486
4478	42	2016-05-25 02:01:45.296332	2450
4479	42	2016-05-25 02:01:45.31186	2452
4480	42	2016-05-25 02:01:45.327258	2455
4481	42	2016-05-25 02:01:45.343071	2482
4482	42	2016-05-25 02:01:45.358181	2488
4483	42	2016-05-25 02:01:45.373804	2472
4484	42	2016-05-25 02:01:45.389499	2500
4485	42	2016-05-25 02:01:45.404853	2374
4486	42	2016-05-25 02:01:45.421457	2442
4487	42	2016-05-25 02:01:45.438339	2496
4488	42	2016-05-25 02:01:45.4562	2467
4489	42	2016-05-25 02:01:45.471545	2490
4490	42	2016-05-25 02:01:45.48687	2504
4491	42	2016-05-25 02:01:45.502279	2494
4492	42	2016-05-25 02:01:45.517324	2470
4493	42	2016-05-25 02:01:45.534945	2498
4494	42	2016-05-25 02:01:45.55093	2484
4495	42	2016-05-25 02:01:45.565953	2506
4496	42	2016-05-25 02:01:45.585501	2440
4497	42	2016-05-25 02:01:45.604257	2468
4498	42	2016-05-25 02:01:45.623047	2478
4499	42	2016-05-25 02:01:45.641866	2480
4500	42	2016-05-25 02:01:45.657995	2457
4501	42	2016-05-25 02:01:45.673918	2475
4502	42	2016-05-25 02:01:45.689793	2502
4503	42	2016-05-25 02:01:45.705156	2459
4504	42	2016-05-25 02:01:45.720857	2463
4505	42	2016-05-25 02:01:45.73661	2476
4506	42	2016-05-25 02:01:45.751616	2448
4507	42	2016-05-25 02:01:45.767247	2465
4508	42	2016-05-25 02:01:45.782633	2461
4509	42	2016-05-25 02:01:45.797958	2469
4510	42	2016-05-25 02:01:45.818559	2474
4511	42	2016-05-25 02:01:45.839183	2492
4512	43	2016-05-25 02:01:45.855881	2462
4513	43	2016-05-25 02:01:45.871785	2466
4514	43	2016-05-25 02:01:45.88725	2489
4515	43	2016-05-25 02:01:45.902088	2477
4516	43	2016-05-25 02:01:45.917203	2481
4517	43	2016-05-25 02:01:45.932265	2453
4518	43	2016-05-25 02:01:45.950262	2491
4519	43	2016-05-25 02:01:45.966183	2483
4520	43	2016-05-25 02:01:45.982027	2443
4521	43	2016-05-25 02:01:45.997278	2501
4522	43	2016-05-25 02:01:46.013632	2375
4523	43	2016-05-25 02:01:46.030711	2458
4524	43	2016-05-25 02:01:46.046286	2499
4525	43	2016-05-25 02:01:46.061647	2471
4526	43	2016-05-25 02:01:46.07657	2487
4527	43	2016-05-25 02:01:46.092641	2441
4528	43	2016-05-25 02:01:46.111537	2451
4529	43	2016-05-25 02:01:46.128936	2507
4530	43	2016-05-25 02:01:46.147182	2464
4531	43	2016-05-25 02:01:46.163135	2497
4532	43	2016-05-25 02:01:46.178943	2460
4533	43	2016-05-25 02:01:46.194468	2493
4534	43	2016-05-25 02:01:46.210446	2473
4535	43	2016-05-25 02:01:46.227292	2445
4536	43	2016-05-25 02:01:46.24415	2485
4537	43	2016-05-25 02:01:46.259657	2495
4538	43	2016-05-25 02:01:46.275227	2449
4539	43	2016-05-25 02:01:46.2903	2505
4540	43	2016-05-25 02:01:46.305766	2479
4541	43	2016-05-25 02:01:46.321625	2456
4542	43	2016-05-25 02:01:46.336626	2503
4543	40	2016-05-25 02:01:46.355134	47212
4544	40	2016-05-25 02:01:46.369348	47206
4545	40	2016-05-25 02:01:46.382891	47215
4546	40	2016-05-25 02:01:46.397588	47209
4547	40	2016-05-25 02:01:46.412542	47256
4548	40	2016-05-25 02:01:46.436794	47340
4549	40	2016-05-25 02:01:46.452791	47203
4550	49	2016-05-25 02:01:46.472149	47209
4551	49	2016-05-25 02:01:46.487452	47256
4552	49	2016-05-25 02:01:46.503153	47212
4553	49	2016-05-25 02:01:46.518135	47206
4554	49	2016-05-25 02:01:46.542301	47340
4555	49	2016-05-25 02:01:46.557781	47203
4556	49	2016-05-25 02:01:46.573543	47215
4557	48	2016-05-25 02:01:46.593063	2500
4558	48	2016-05-25 02:01:46.617244	2374
4559	48	2016-05-25 02:01:46.642193	2475
4560	48	2016-05-25 02:01:46.66221	2498
4561	48	2016-05-25 02:01:46.680147	2480
4562	48	2016-05-25 02:01:46.697633	2454
4563	48	2016-05-25 02:01:46.717082	2465
4564	48	2016-05-25 02:01:46.738549	2459
4565	48	2016-05-25 02:01:46.763556	2472
4566	48	2016-05-25 02:01:46.791346	2467
4567	48	2016-05-25 02:01:46.828369	2504
4568	48	2016-05-25 02:01:46.849437	2469
4569	48	2016-05-25 02:01:46.871268	2442
4570	48	2016-05-25 02:01:46.893017	2474
4571	48	2016-05-25 02:01:46.914513	2486
4572	48	2016-05-25 02:01:46.93506	2476
4573	48	2016-05-25 02:01:46.95649	2492
4574	48	2016-05-25 02:01:46.97368	2448
4575	48	2016-05-25 02:01:46.990913	2490
4576	48	2016-05-25 02:01:47.009025	2440
4577	48	2016-05-25 02:01:47.027451	2452
4578	48	2016-05-25 02:01:47.045278	2468
4579	48	2016-05-25 02:01:47.063168	2450
4580	48	2016-05-25 02:01:47.082588	2470
4581	48	2016-05-25 02:01:47.103621	2506
4582	48	2016-05-25 02:01:47.125365	2461
4583	48	2016-05-25 02:01:47.148159	2502
4584	48	2016-05-25 02:01:47.170886	2455
4585	48	2016-05-25 02:01:47.196806	2478
4586	48	2016-05-25 02:01:47.219842	2488
4587	48	2016-05-25 02:01:47.241336	2494
4588	48	2016-05-25 02:01:47.26322	2484
4589	48	2016-05-25 02:01:47.283145	2514
4590	48	2016-05-25 02:01:47.303854	2457
4591	48	2016-05-25 02:01:47.323582	2482
4592	48	2016-05-25 02:01:47.344435	2463
4593	48	2016-05-25 02:01:47.366652	2444
4594	48	2016-05-25 02:01:47.386629	2496
4595	50	2016-05-25 02:01:47.40875	47209
4596	50	2016-05-25 02:01:47.429566	47256
4597	50	2016-05-25 02:01:47.450611	47212
4598	50	2016-05-25 02:01:47.470451	47206
4599	50	2016-05-25 02:01:47.500043	47340
4600	50	2016-05-25 02:01:47.518997	47203
4601	50	2016-05-25 02:01:47.539402	47215
4602	47	2016-05-25 02:01:47.564972	2500
4603	47	2016-05-25 02:01:47.583775	2374
4604	47	2016-05-25 02:01:47.608227	2475
4605	47	2016-05-25 02:01:47.638927	2498
4606	47	2016-05-25 02:01:47.658875	2480
4607	47	2016-05-25 02:01:47.67666	2454
4608	47	2016-05-25 02:01:47.694331	2465
4609	47	2016-05-25 02:01:47.714692	2459
4610	47	2016-05-25 02:01:47.733669	2472
4611	47	2016-05-25 02:01:47.752708	2467
4612	47	2016-05-25 02:01:47.77023	2504
4613	47	2016-05-25 02:01:47.79245	2469
4614	47	2016-05-25 02:01:47.8321	2442
4615	47	2016-05-25 02:01:47.85326	2474
4616	47	2016-05-25 02:01:47.873862	2486
4617	47	2016-05-25 02:01:47.893805	2476
4618	47	2016-05-25 02:01:47.910523	2492
4619	47	2016-05-25 02:01:47.927516	2448
4620	47	2016-05-25 02:01:47.962067	2490
4621	47	2016-05-25 02:01:47.98291	2440
4622	47	2016-05-25 02:01:48.000655	2452
4623	47	2016-05-25 02:01:48.022228	2468
4624	47	2016-05-25 02:01:48.04075	2450
4625	47	2016-05-25 02:01:48.071996	2470
4626	47	2016-05-25 02:01:48.096787	2506
4627	47	2016-05-25 02:01:48.116771	2461
4628	47	2016-05-25 02:01:48.136365	2502
4629	47	2016-05-25 02:01:48.157044	2455
4630	47	2016-05-25 02:01:48.281918	2478
4631	47	2016-05-25 02:01:48.334913	2488
4632	47	2016-05-25 02:01:48.356745	2494
4633	47	2016-05-25 02:01:48.3784	2484
4634	47	2016-05-25 02:01:48.399999	2514
4635	47	2016-05-25 02:01:48.432507	2457
4636	47	2016-05-25 02:01:48.454588	2482
4637	47	2016-05-25 02:01:48.473951	2463
4638	47	2016-05-25 02:01:48.495965	2444
4639	47	2016-05-25 02:01:48.516529	2496
4640	41	2016-05-30 10:23:07.264517	2518
4641	41	2016-05-30 10:23:07.296168	2378
4642	41	2016-05-30 10:23:07.306508	2517
4643	41	2016-05-30 10:23:07.316819	2522
4644	41	2016-05-30 10:23:07.327138	2520
4645	41	2016-05-30 10:23:07.337034	2521
4646	41	2016-05-30 10:23:07.347196	2523
4647	41	2016-05-30 10:23:07.357109	2525
4648	41	2016-05-30 10:23:07.367217	2516
4649	41	2016-05-30 10:23:07.37744	2519
4650	41	2016-05-30 10:23:07.387349	2524
4651	46	2016-05-30 10:23:07.393131	2398
4652	45	2016-05-30 10:23:07.398822	2400
4653	44	2016-05-30 10:23:07.404756	2382
4654	42	2016-05-30 10:23:07.410484	2444
4655	42	2016-05-30 10:23:07.415676	2486
4656	42	2016-05-30 10:23:07.420923	2450
4657	42	2016-05-30 10:23:07.4262	2452
4658	42	2016-05-30 10:23:07.431753	2455
4659	42	2016-05-30 10:23:07.437026	2482
4660	42	2016-05-30 10:23:07.443524	2488
4661	42	2016-05-30 10:23:07.449132	2472
4662	42	2016-05-30 10:23:07.454281	2500
4663	42	2016-05-30 10:23:07.459265	2374
4664	42	2016-05-30 10:23:07.464566	2442
4665	42	2016-05-30 10:23:07.46976	2496
4666	42	2016-05-30 10:23:07.777121	2467
4667	42	2016-05-30 10:23:07.782362	2490
4668	42	2016-05-30 10:23:07.787479	2504
4669	42	2016-05-30 10:23:07.792599	2494
4670	42	2016-05-30 10:23:07.797761	2470
4671	42	2016-05-30 10:23:07.802796	2498
4672	42	2016-05-30 10:23:07.807834	2484
4673	42	2016-05-30 10:23:07.812943	2506
4674	42	2016-05-30 10:23:07.818162	2440
4675	42	2016-05-30 10:23:07.823315	2468
4676	42	2016-05-30 10:23:07.828471	2478
4677	42	2016-05-30 10:23:07.833516	2480
4678	42	2016-05-30 10:23:07.838563	2457
4679	42	2016-05-30 10:23:07.843823	2475
4680	42	2016-05-30 10:23:07.851658	2502
4681	42	2016-05-30 10:23:07.876495	2459
4682	42	2016-05-30 10:23:07.896574	2463
4683	42	2016-05-30 10:23:07.902044	2476
4684	42	2016-05-30 10:23:07.907782	2448
4685	42	2016-05-30 10:23:07.913575	2465
4686	42	2016-05-30 10:23:07.919185	2461
4687	42	2016-05-30 10:23:07.924802	2469
4688	42	2016-05-30 10:23:07.930541	2474
4689	42	2016-05-30 10:23:07.936104	2492
4690	43	2016-05-30 10:23:07.94219	2462
4691	43	2016-05-30 10:23:07.947987	2466
4692	43	2016-05-30 10:23:07.953619	2489
4693	43	2016-05-30 10:23:07.959541	2477
4694	43	2016-05-30 10:23:07.965289	2481
4695	43	2016-05-30 10:23:07.970675	2453
4696	43	2016-05-30 10:23:07.976476	2491
4697	43	2016-05-30 10:23:07.98194	2483
4698	43	2016-05-30 10:23:07.987911	2443
4699	43	2016-05-30 10:23:07.994153	2501
4700	43	2016-05-30 10:23:08.000514	2375
4701	43	2016-05-30 10:23:08.006393	2458
4702	43	2016-05-30 10:23:08.013908	2499
4703	43	2016-05-30 10:23:08.021528	2471
4704	43	2016-05-30 10:23:08.03087	2487
4705	43	2016-05-30 10:23:08.036648	2441
4706	43	2016-05-30 10:23:08.04273	2451
4707	43	2016-05-30 10:23:08.048519	2507
4708	43	2016-05-30 10:23:08.054254	2464
4709	43	2016-05-30 10:23:08.060258	2497
4710	43	2016-05-30 10:23:08.066007	2460
4711	43	2016-05-30 10:23:08.071764	2493
4712	43	2016-05-30 10:23:08.078026	2473
4713	43	2016-05-30 10:23:08.084672	2445
4714	43	2016-05-30 10:23:08.090588	2485
4715	43	2016-05-30 10:23:08.096815	2495
4716	43	2016-05-30 10:23:08.102507	2449
4717	43	2016-05-30 10:23:08.110281	2505
4718	43	2016-05-30 10:23:08.11687	2479
4719	43	2016-05-30 10:23:08.123294	2456
4720	43	2016-05-30 10:23:08.131919	2503
4721	40	2016-05-30 10:23:08.16374	47212
4722	40	2016-05-30 10:23:08.169203	47206
4723	40	2016-05-30 10:23:08.174746	47215
4724	40	2016-05-30 10:23:08.180294	47209
4725	40	2016-05-30 10:23:08.188561	47256
4726	40	2016-05-30 10:23:08.213203	47340
4727	40	2016-05-30 10:23:08.233272	47203
4728	49	2016-05-30 10:23:08.240705	47209
4729	49	2016-05-30 10:23:08.248025	47256
4730	49	2016-05-30 10:23:08.256759	47212
4731	49	2016-05-30 10:23:08.27165	47206
4732	49	2016-05-30 10:23:08.296212	47340
4733	49	2016-05-30 10:23:08.303402	47203
4734	49	2016-05-30 10:23:08.310194	47215
4735	48	2016-05-30 10:23:08.316852	2500
4736	48	2016-05-30 10:23:08.322894	2374
4737	48	2016-05-30 10:23:08.329418	2475
4738	48	2016-05-30 10:23:08.335905	2498
4739	48	2016-05-30 10:23:08.34311	2480
4740	48	2016-05-30 10:23:08.349642	2454
4741	48	2016-05-30 10:23:08.355766	2465
4742	48	2016-05-30 10:23:08.36321	2459
4743	48	2016-05-30 10:23:08.369235	2472
4744	48	2016-05-30 10:23:08.37606	2467
4745	48	2016-05-30 10:23:08.383212	2504
4746	48	2016-05-30 10:23:08.390216	2469
4747	48	2016-05-30 10:23:08.396556	2442
4748	48	2016-05-30 10:23:08.404052	2474
4749	48	2016-05-30 10:23:08.412122	2486
4750	48	2016-05-30 10:23:08.419065	2476
4751	48	2016-05-30 10:23:08.42588	2492
4752	48	2016-05-30 10:23:08.432208	2448
4753	48	2016-05-30 10:23:08.438129	2490
4754	48	2016-05-30 10:23:08.444562	2440
4755	48	2016-05-30 10:23:08.458973	2452
4756	48	2016-05-30 10:23:08.481889	2468
4757	48	2016-05-30 10:23:08.49242	2450
4758	48	2016-05-30 10:23:08.515726	2470
4759	48	2016-05-30 10:23:08.525015	2506
4760	48	2016-05-30 10:23:08.531829	2461
4761	48	2016-05-30 10:23:08.5387	2502
4762	48	2016-05-30 10:23:08.545531	2455
4763	48	2016-05-30 10:23:08.552498	2478
4764	48	2016-05-30 10:23:08.563787	2488
4765	48	2016-05-30 10:23:08.585376	2494
4766	48	2016-05-30 10:23:08.607551	2484
4767	48	2016-05-30 10:23:08.613983	2514
4768	48	2016-05-30 10:23:08.620785	2457
4769	48	2016-05-30 10:23:08.627719	2482
4770	48	2016-05-30 10:23:08.634425	2463
4771	48	2016-05-30 10:23:08.641841	2444
4772	48	2016-05-30 10:23:08.648549	2496
4773	50	2016-05-30 10:23:08.655678	47209
4774	50	2016-05-30 10:23:08.661673	47256
4775	50	2016-05-30 10:23:08.668003	47212
4776	50	2016-05-30 10:23:08.674645	47206
4777	50	2016-05-30 10:23:08.68404	47340
4778	50	2016-05-30 10:23:08.690942	47203
4779	50	2016-05-30 10:23:08.697413	47215
4780	47	2016-05-30 10:23:08.704537	2500
4781	47	2016-05-30 10:23:08.711639	2374
4782	47	2016-05-30 10:23:08.718399	2475
4783	47	2016-05-30 10:23:08.72577	2498
4784	47	2016-05-30 10:23:08.732228	2480
4785	47	2016-05-30 10:23:08.738553	2454
4786	47	2016-05-30 10:23:08.745278	2465
4787	47	2016-05-30 10:23:08.751901	2459
4788	47	2016-05-30 10:23:08.759303	2472
4789	47	2016-05-30 10:23:08.766425	2467
4790	47	2016-05-30 10:23:08.773477	2504
4791	47	2016-05-30 10:23:08.780627	2469
4792	47	2016-05-30 10:23:08.787248	2442
4793	47	2016-05-30 10:23:08.794465	2474
4794	47	2016-05-30 10:23:08.801153	2486
4795	47	2016-05-30 10:23:08.807707	2476
4796	47	2016-05-30 10:23:08.814202	2492
4797	47	2016-05-30 10:23:08.820601	2448
4798	47	2016-05-30 10:23:08.827404	2490
4799	47	2016-05-30 10:23:08.834106	2440
4800	47	2016-05-30 10:23:08.841144	2452
4801	47	2016-05-30 10:23:08.874289	2468
4802	47	2016-05-30 10:23:08.896818	2450
4803	47	2016-05-30 10:23:08.91957	2470
4804	47	2016-05-30 10:23:08.940873	2506
4805	47	2016-05-30 10:23:08.947545	2461
4806	47	2016-05-30 10:23:08.954224	2502
4807	47	2016-05-30 10:23:08.963607	2455
4808	47	2016-05-30 10:23:08.970773	2478
4809	47	2016-05-30 10:23:08.97761	2488
4810	47	2016-05-30 10:23:08.984164	2494
4811	47	2016-05-30 10:23:08.991178	2484
4812	47	2016-05-30 10:23:08.998387	2514
4813	47	2016-05-30 10:23:09.005384	2457
4814	47	2016-05-30 10:23:09.012355	2482
4815	47	2016-05-30 10:23:09.018916	2463
4816	47	2016-05-30 10:23:09.027266	2444
4817	47	2016-05-30 10:23:09.034318	2496
4818	41	2016-05-30 10:25:06.649046	2518
4819	41	2016-05-30 10:25:06.655389	2378
4820	41	2016-05-30 10:25:06.666119	2517
4821	41	2016-05-30 10:25:06.676884	2522
4822	41	2016-05-30 10:25:06.68802	2520
4823	41	2016-05-30 10:25:06.698894	2521
4824	41	2016-05-30 10:25:06.708771	2523
4825	41	2016-05-30 10:25:06.718799	2525
4826	41	2016-05-30 10:25:06.729156	2516
4827	41	2016-05-30 10:25:06.739299	2519
4828	41	2016-05-30 10:25:06.749427	2524
4829	46	2016-05-30 10:25:06.755358	2398
4830	45	2016-05-30 10:25:06.761311	2400
4831	44	2016-05-30 10:25:06.767407	2382
4832	42	2016-05-30 10:25:06.772996	2444
4833	42	2016-05-30 10:25:06.778338	2486
4834	42	2016-05-30 10:25:06.783975	2450
4835	42	2016-05-30 10:25:06.789723	2452
4836	42	2016-05-30 10:25:06.795438	2455
4837	42	2016-05-30 10:25:06.800864	2482
4838	42	2016-05-30 10:25:06.806535	2488
4839	42	2016-05-30 10:25:06.812187	2472
4840	42	2016-05-30 10:25:06.817437	2500
4841	42	2016-05-30 10:25:06.822734	2374
4842	42	2016-05-30 10:25:06.828559	2442
4843	42	2016-05-30 10:25:06.833884	2496
4844	42	2016-05-30 10:25:06.839776	2467
4845	42	2016-05-30 10:25:06.846061	2490
4846	42	2016-05-30 10:25:06.851992	2504
4847	42	2016-05-30 10:25:06.85818	2494
4848	42	2016-05-30 10:25:06.863893	2470
4849	42	2016-05-30 10:25:06.869593	2498
4850	42	2016-05-30 10:25:06.875318	2484
4851	42	2016-05-30 10:25:06.880908	2506
4852	42	2016-05-30 10:25:06.88614	2440
4853	42	2016-05-30 10:25:06.891836	2468
4854	42	2016-05-30 10:25:06.897361	2478
4855	42	2016-05-30 10:25:06.902697	2480
4856	42	2016-05-30 10:25:06.908191	2457
4857	42	2016-05-30 10:25:06.913764	2475
4858	42	2016-05-30 10:25:06.918826	2502
4859	42	2016-05-30 10:25:06.924106	2459
4860	42	2016-05-30 10:25:06.929894	2463
4861	42	2016-05-30 10:25:06.935058	2476
4862	42	2016-05-30 10:25:06.940531	2448
4863	42	2016-05-30 10:25:06.946393	2465
4864	42	2016-05-30 10:25:06.951934	2461
4865	42	2016-05-30 10:25:06.957151	2469
4866	42	2016-05-30 10:25:06.963063	2474
4867	42	2016-05-30 10:25:06.968159	2492
4868	43	2016-05-30 10:25:06.973957	2462
4869	43	2016-05-30 10:25:06.979656	2466
4870	43	2016-05-30 10:25:06.984886	2489
4871	43	2016-05-30 10:25:06.990027	2477
4872	43	2016-05-30 10:25:06.996153	2481
4873	43	2016-05-30 10:25:07.001376	2453
4874	43	2016-05-30 10:25:07.006594	2491
4875	43	2016-05-30 10:25:07.012083	2483
4876	43	2016-05-30 10:25:07.017446	2443
4877	43	2016-05-30 10:25:07.022941	2501
4878	43	2016-05-30 10:25:07.028861	2375
4879	43	2016-05-30 10:25:07.034058	2458
4880	43	2016-05-30 10:25:07.039357	2499
4881	43	2016-05-30 10:25:07.045274	2471
4882	43	2016-05-30 10:25:07.050838	2487
4883	43	2016-05-30 10:25:07.056169	2441
4884	43	2016-05-30 10:25:07.061933	2451
4885	43	2016-05-30 10:25:07.067296	2507
4886	43	2016-05-30 10:25:07.072746	2464
4887	43	2016-05-30 10:25:07.078324	2497
4888	43	2016-05-30 10:25:07.083527	2460
4889	43	2016-05-30 10:25:07.089297	2493
4890	43	2016-05-30 10:25:07.094854	2473
4891	43	2016-05-30 10:25:07.100474	2445
4892	43	2016-05-30 10:25:07.105829	2485
4893	43	2016-05-30 10:25:07.111013	2495
4894	43	2016-05-30 10:25:07.116171	2449
4895	43	2016-05-30 10:25:07.121226	2505
4896	43	2016-05-30 10:25:07.126854	2479
4897	43	2016-05-30 10:25:07.132213	2456
4898	43	2016-05-30 10:25:07.137401	2503
4899	40	2016-05-30 10:25:07.144038	47212
4900	40	2016-05-30 10:25:07.14902	47206
4901	40	2016-05-30 10:25:07.153862	47215
4902	40	2016-05-30 10:25:07.158836	47209
4903	40	2016-05-30 10:25:07.163522	47256
4904	40	2016-05-30 10:25:07.171828	47340
4905	40	2016-05-30 10:25:07.192068	47203
4906	49	2016-05-30 10:25:07.214948	47209
4907	49	2016-05-30 10:25:07.235898	47256
4908	49	2016-05-30 10:25:07.258175	47212
4909	49	2016-05-30 10:25:07.265238	47206
4910	49	2016-05-30 10:25:07.274643	47340
4911	49	2016-05-30 10:25:07.281836	47203
4912	49	2016-05-30 10:25:07.287748	47215
4913	48	2016-05-30 10:25:07.294575	2500
4914	48	2016-05-30 10:25:07.301108	2374
4915	48	2016-05-30 10:25:07.307059	2475
4916	48	2016-05-30 10:25:07.313038	2498
4917	48	2016-05-30 10:25:07.319106	2480
4918	48	2016-05-30 10:25:07.325144	2454
4919	48	2016-05-30 10:25:07.33139	2465
4920	48	2016-05-30 10:25:07.337221	2459
4921	48	2016-05-30 10:25:07.343151	2472
4922	48	2016-05-30 10:25:07.349251	2467
4923	48	2016-05-30 10:25:07.355572	2504
4924	48	2016-05-30 10:25:07.362186	2469
4925	48	2016-05-30 10:25:07.368159	2442
4926	48	2016-05-30 10:25:07.374282	2474
4927	48	2016-05-30 10:25:07.380253	2486
4928	48	2016-05-30 10:25:07.386114	2476
4929	48	2016-05-30 10:25:07.392198	2492
4930	48	2016-05-30 10:25:07.398355	2448
4931	48	2016-05-30 10:25:07.404417	2490
4932	48	2016-05-30 10:25:07.410378	2440
4933	48	2016-05-30 10:25:07.416504	2452
4934	48	2016-05-30 10:25:07.422513	2468
4935	48	2016-05-30 10:25:07.428613	2450
4936	48	2016-05-30 10:25:07.434624	2470
4937	48	2016-05-30 10:25:07.440867	2506
4938	48	2016-05-30 10:25:07.447203	2461
4939	48	2016-05-30 10:25:07.453072	2502
4940	48	2016-05-30 10:25:07.459493	2455
4941	48	2016-05-30 10:25:07.465401	2478
4942	48	2016-05-30 10:25:07.471414	2488
4943	48	2016-05-30 10:25:07.477723	2494
4944	48	2016-05-30 10:25:07.483779	2484
4945	48	2016-05-30 10:25:07.490183	2514
4946	48	2016-05-30 10:25:07.496243	2457
4947	48	2016-05-30 10:25:07.502199	2482
4948	48	2016-05-30 10:25:07.508473	2463
4949	48	2016-05-30 10:25:07.514773	2444
4950	48	2016-05-30 10:25:07.520895	2496
4951	50	2016-05-30 10:25:07.527337	47209
4952	50	2016-05-30 10:25:07.53303	47256
4953	50	2016-05-30 10:25:07.53859	47212
4954	50	2016-05-30 10:25:07.54461	47206
4955	50	2016-05-30 10:25:07.553161	47340
4956	50	2016-05-30 10:25:07.559279	47203
4957	50	2016-05-30 10:25:07.565118	47215
4958	47	2016-05-30 10:25:07.571724	2500
4959	47	2016-05-30 10:25:07.578014	2374
4960	47	2016-05-30 10:25:07.583843	2475
4961	47	2016-05-30 10:25:07.589732	2498
4962	47	2016-05-30 10:25:07.59631	2480
4963	47	2016-05-30 10:25:07.602249	2454
4964	47	2016-05-30 10:25:07.60817	2465
4965	47	2016-05-30 10:25:07.613796	2459
4966	47	2016-05-30 10:25:07.619606	2472
4967	47	2016-05-30 10:25:07.627121	2467
4968	47	2016-05-30 10:25:07.634157	2504
4969	47	2016-05-30 10:25:07.641457	2469
4970	47	2016-05-30 10:25:07.647792	2442
4971	47	2016-05-30 10:25:07.653958	2474
4972	47	2016-05-30 10:25:07.659971	2486
4973	47	2016-05-30 10:25:07.665931	2476
4974	47	2016-05-30 10:25:07.671672	2492
4975	47	2016-05-30 10:25:07.67786	2448
4976	47	2016-05-30 10:25:07.683839	2490
4977	47	2016-05-30 10:25:07.689916	2440
4978	47	2016-05-30 10:25:07.696818	2452
4979	47	2016-05-30 10:25:07.703103	2468
4980	47	2016-05-30 10:25:07.70919	2450
4981	47	2016-05-30 10:25:07.71521	2470
4982	47	2016-05-30 10:25:07.72089	2506
4983	47	2016-05-30 10:25:07.727029	2461
4984	47	2016-05-30 10:25:07.732897	2502
4985	47	2016-05-30 10:25:07.738853	2455
4986	47	2016-05-30 10:25:07.744888	2478
4987	47	2016-05-30 10:25:07.750928	2488
4988	47	2016-05-30 10:25:07.756645	2494
4989	47	2016-05-30 10:25:07.76267	2484
4990	47	2016-05-30 10:25:07.768552	2514
4991	47	2016-05-30 10:25:07.774253	2457
4992	47	2016-05-30 10:25:07.780252	2482
4993	47	2016-05-30 10:25:07.786306	2463
4994	47	2016-05-30 10:25:07.792192	2444
4995	47	2016-05-30 10:25:07.798067	2496
4996	41	2016-05-30 13:21:59.176488	2518
4997	41	2016-05-30 13:21:59.206715	2378
4998	41	2016-05-30 13:21:59.217095	2517
4999	41	2016-05-30 13:21:59.22938	2522
5000	41	2016-05-30 13:21:59.240289	2520
5001	41	2016-05-30 13:21:59.251108	2521
5002	41	2016-05-30 13:21:59.262742	2523
5003	41	2016-05-30 13:21:59.27384	2525
5004	41	2016-05-30 13:21:59.285647	2516
5005	41	2016-05-30 13:21:59.301035	2519
5006	41	2016-05-30 13:21:59.32815	2524
5007	46	2016-05-30 13:21:59.334314	2398
5008	45	2016-05-30 13:21:59.341164	2400
5009	44	2016-05-30 13:21:59.34701	2382
5010	42	2016-05-30 13:21:59.352554	2444
5011	42	2016-05-30 13:21:59.358892	2486
5012	42	2016-05-30 13:21:59.365641	2450
5013	42	2016-05-30 13:21:59.371065	2452
5014	42	2016-05-30 13:21:59.376925	2455
5015	42	2016-05-30 13:21:59.382368	2482
5016	42	2016-05-30 13:21:59.38771	2488
5017	42	2016-05-30 13:21:59.393995	2472
5018	42	2016-05-30 13:21:59.399238	2500
5019	42	2016-05-30 13:21:59.404829	2374
5020	42	2016-05-30 13:21:59.410409	2442
5021	42	2016-05-30 13:21:59.416184	2496
5022	42	2016-05-30 13:21:59.422274	2467
5023	42	2016-05-30 13:21:59.428333	2490
5024	42	2016-05-30 13:21:59.433506	2504
5025	42	2016-05-30 13:21:59.4396	2494
5026	42	2016-05-30 13:21:59.445536	2470
5027	42	2016-05-30 13:21:59.451016	2498
5028	42	2016-05-30 13:21:59.457314	2484
5029	42	2016-05-30 13:21:59.462738	2506
5030	42	2016-05-30 13:21:59.468578	2440
5031	42	2016-05-30 13:21:59.475198	2468
5032	42	2016-05-30 13:21:59.480799	2478
5033	42	2016-05-30 13:21:59.486196	2480
5034	42	2016-05-30 13:21:59.49216	2457
5035	42	2016-05-30 13:21:59.497653	2475
5036	42	2016-05-30 13:21:59.503053	2502
5037	42	2016-05-30 13:21:59.509331	2459
5038	42	2016-05-30 13:21:59.529915	2463
5039	42	2016-05-30 13:21:59.535133	2476
5040	42	2016-05-30 13:21:59.541911	2448
5041	42	2016-05-30 13:21:59.549452	2465
5042	42	2016-05-30 13:21:59.55887	2461
5043	42	2016-05-30 13:21:59.568751	2469
5044	42	2016-05-30 13:21:59.57706	2474
5045	42	2016-05-30 13:21:59.584007	2492
5046	43	2016-05-30 13:21:59.589968	2462
5047	43	2016-05-30 13:21:59.5954	2466
5048	43	2016-05-30 13:21:59.600384	2489
5049	43	2016-05-30 13:21:59.606021	2477
5050	43	2016-05-30 13:21:59.611473	2481
5051	43	2016-05-30 13:21:59.616721	2453
5052	43	2016-05-30 13:21:59.622051	2491
5053	43	2016-05-30 13:21:59.627477	2483
5054	43	2016-05-30 13:21:59.632915	2443
5055	43	2016-05-30 13:21:59.638415	2501
5056	43	2016-05-30 13:21:59.644039	2375
5057	43	2016-05-30 13:21:59.650265	2458
5058	43	2016-05-30 13:21:59.656354	2499
5059	43	2016-05-30 13:21:59.661705	2471
5060	43	2016-05-30 13:21:59.667119	2487
5061	43	2016-05-30 13:21:59.672667	2441
5062	43	2016-05-30 13:21:59.677814	2451
5063	43	2016-05-30 13:21:59.683734	2507
5064	43	2016-05-30 13:21:59.689092	2464
5065	43	2016-05-30 13:21:59.694839	2497
5066	43	2016-05-30 13:21:59.700437	2460
5067	43	2016-05-30 13:21:59.705843	2493
5068	43	2016-05-30 13:21:59.710917	2473
5069	43	2016-05-30 13:21:59.716198	2445
5070	43	2016-05-30 13:21:59.72168	2485
5071	43	2016-05-30 13:21:59.727033	2495
5072	43	2016-05-30 13:21:59.732397	2449
5073	43	2016-05-30 13:21:59.73798	2505
5074	43	2016-05-30 13:21:59.743055	2479
5075	43	2016-05-30 13:21:59.748413	2456
5076	43	2016-05-30 13:21:59.754228	2503
5077	40	2016-05-30 13:21:59.760482	47212
5078	40	2016-05-30 13:21:59.765343	47206
5079	40	2016-05-30 13:21:59.770736	47215
5080	40	2016-05-30 13:21:59.77596	47209
5081	40	2016-05-30 13:21:59.781062	47256
5082	40	2016-05-30 13:21:59.790008	47340
5083	40	2016-05-30 13:21:59.796219	47203
5084	49	2016-05-30 13:21:59.80324	47209
5085	49	2016-05-30 13:21:59.80886	47256
5086	49	2016-05-30 13:21:59.814521	47212
5087	49	2016-05-30 13:21:59.820578	47206
5088	49	2016-05-30 13:21:59.829392	47340
5089	49	2016-05-30 13:21:59.834889	47203
5090	49	2016-05-30 13:21:59.840836	47215
5091	48	2016-05-30 13:21:59.848175	2500
5092	48	2016-05-30 13:21:59.854669	2374
5093	48	2016-05-30 13:21:59.860986	2475
5094	48	2016-05-30 13:21:59.867341	2498
5095	48	2016-05-30 13:21:59.873962	2480
5096	48	2016-05-30 13:21:59.879768	2454
5097	48	2016-05-30 13:21:59.88636	2465
5098	48	2016-05-30 13:21:59.893067	2459
5099	48	2016-05-30 13:21:59.899448	2472
5100	48	2016-05-30 13:21:59.905947	2467
5101	48	2016-05-30 13:21:59.912052	2504
5102	48	2016-05-30 13:21:59.918582	2469
5103	48	2016-05-30 13:21:59.924796	2442
5104	48	2016-05-30 13:21:59.930633	2474
5105	48	2016-05-30 13:21:59.936963	2486
5106	48	2016-05-30 13:21:59.943562	2476
5107	48	2016-05-30 13:21:59.949571	2492
5108	48	2016-05-30 13:21:59.956344	2448
5109	48	2016-05-30 13:21:59.962244	2490
5110	48	2016-05-30 13:21:59.96871	2440
5111	48	2016-05-30 13:21:59.975316	2452
5112	48	2016-05-30 13:21:59.981448	2468
5113	48	2016-05-30 13:21:59.987782	2450
5114	48	2016-05-30 13:21:59.994396	2470
5115	48	2016-05-30 13:22:00.001125	2506
5116	48	2016-05-30 13:22:00.008063	2461
5117	48	2016-05-30 13:22:00.014284	2502
5118	48	2016-05-30 13:22:00.020962	2455
5119	48	2016-05-30 13:22:00.028313	2478
5120	48	2016-05-30 13:22:00.034338	2488
5121	48	2016-05-30 13:22:00.04077	2494
5122	48	2016-05-30 13:22:00.046948	2484
5123	48	2016-05-30 13:22:00.053125	2514
5124	48	2016-05-30 13:22:00.059788	2457
5125	48	2016-05-30 13:22:00.065788	2482
5126	48	2016-05-30 13:22:00.072934	2463
5127	48	2016-05-30 13:22:00.079074	2444
5128	48	2016-05-30 13:22:00.085505	2496
5129	50	2016-05-30 13:22:00.092922	47209
5130	50	2016-05-30 13:22:00.098906	47256
5131	50	2016-05-30 13:22:00.105423	47212
5132	50	2016-05-30 13:22:00.111065	47206
5133	50	2016-05-30 13:22:00.120188	47340
5134	50	2016-05-30 13:22:00.126043	47203
5135	50	2016-05-30 13:22:00.131623	47215
5136	47	2016-05-30 13:22:00.138411	2500
5137	47	2016-05-30 13:22:00.144747	2374
5138	47	2016-05-30 13:22:00.150558	2475
5139	47	2016-05-30 13:22:00.156603	2498
5140	47	2016-05-30 13:22:00.162509	2480
5141	47	2016-05-30 13:22:00.168735	2454
5142	47	2016-05-30 13:22:00.175032	2465
5143	47	2016-05-30 13:22:00.180811	2459
5144	47	2016-05-30 13:22:00.186651	2472
5145	47	2016-05-30 13:22:00.1927	2467
5146	47	2016-05-30 13:22:00.198725	2504
5147	47	2016-05-30 13:22:00.205015	2469
5148	47	2016-05-30 13:22:00.211283	2442
5149	47	2016-05-30 13:22:00.217884	2474
5150	47	2016-05-30 13:22:00.226252	2486
5151	47	2016-05-30 13:22:00.232066	2476
5152	47	2016-05-30 13:22:00.239144	2492
5153	47	2016-05-30 13:22:00.245567	2448
5154	47	2016-05-30 13:22:00.251892	2490
5155	47	2016-05-30 13:22:00.258468	2440
5156	47	2016-05-30 13:22:00.264162	2452
5157	47	2016-05-30 13:22:00.270947	2468
5158	47	2016-05-30 13:22:00.277256	2450
5159	47	2016-05-30 13:22:00.283139	2470
5160	47	2016-05-30 13:22:00.290393	2506
5161	47	2016-05-30 13:22:00.296788	2461
5162	47	2016-05-30 13:22:00.303247	2502
5163	47	2016-05-30 13:22:00.309271	2455
5164	47	2016-05-30 13:22:00.315182	2478
5165	47	2016-05-30 13:22:00.322956	2488
5166	47	2016-05-30 13:22:00.329667	2494
5167	47	2016-05-30 13:22:00.336121	2484
5168	47	2016-05-30 13:22:00.342586	2514
5169	47	2016-05-30 13:22:00.348793	2457
5170	47	2016-05-30 13:22:00.355492	2482
5171	47	2016-05-30 13:22:00.361517	2463
5172	47	2016-05-30 13:22:00.367265	2444
5173	47	2016-05-30 13:22:00.374018	2496
5174	41	2016-05-30 14:32:19.586164	2518
5175	41	2016-05-30 14:32:19.617231	2378
5176	41	2016-05-30 14:32:19.627657	2517
5177	41	2016-05-30 14:32:19.638134	2522
5178	41	2016-05-30 14:32:19.648359	2520
5179	41	2016-05-30 14:32:19.65871	2521
5180	41	2016-05-30 14:32:19.668695	2523
5181	41	2016-05-30 14:32:19.678601	2525
5182	41	2016-05-30 14:32:19.689034	2516
5183	41	2016-05-30 14:32:19.699352	2519
5184	41	2016-05-30 14:32:19.710344	2524
5185	46	2016-05-30 14:32:19.716178	2398
5186	45	2016-05-30 14:32:19.723804	2400
5187	44	2016-05-30 14:32:19.746181	2382
5188	42	2016-05-30 14:32:19.767026	2444
5189	42	2016-05-30 14:32:19.772809	2486
5190	42	2016-05-30 14:32:19.778237	2450
5191	42	2016-05-30 14:32:19.78379	2452
5192	42	2016-05-30 14:32:19.789107	2455
5193	42	2016-05-30 14:32:19.795239	2482
5194	42	2016-05-30 14:32:19.800898	2488
5195	42	2016-05-30 14:32:19.806628	2472
5196	42	2016-05-30 14:32:19.812471	2500
5197	42	2016-05-30 14:32:19.817873	2374
5198	42	2016-05-30 14:32:19.82412	2442
5199	42	2016-05-30 14:32:19.830053	2496
5200	42	2016-05-30 14:32:19.835343	2467
5201	42	2016-05-30 14:32:19.841034	2490
5202	42	2016-05-30 14:32:19.84698	2504
5203	42	2016-05-30 14:32:19.852571	2494
5204	42	2016-05-30 14:32:19.858139	2470
5205	42	2016-05-30 14:32:19.864283	2498
5206	42	2016-05-30 14:32:19.869515	2484
5207	42	2016-05-30 14:32:19.875328	2506
5208	42	2016-05-30 14:32:19.88134	2440
5209	42	2016-05-30 14:32:19.886975	2468
5210	42	2016-05-30 14:32:19.892529	2478
5211	42	2016-05-30 14:32:19.898414	2480
5212	42	2016-05-30 14:32:19.904076	2457
5213	42	2016-05-30 14:32:19.909891	2475
5214	42	2016-05-30 14:32:19.915664	2502
5215	42	2016-05-30 14:32:19.921265	2459
5216	42	2016-05-30 14:32:19.926821	2463
5217	42	2016-05-30 14:32:19.932747	2476
5218	42	2016-05-30 14:32:19.938035	2448
5219	42	2016-05-30 14:32:19.943528	2465
5220	42	2016-05-30 14:32:19.94946	2461
5221	42	2016-05-30 14:32:19.955335	2469
5222	42	2016-05-30 14:32:19.96103	2474
5223	42	2016-05-30 14:32:19.969718	2492
5224	43	2016-05-30 14:32:19.97641	2462
5225	43	2016-05-30 14:32:19.982325	2466
5226	43	2016-05-30 14:32:19.987807	2489
5227	43	2016-05-30 14:32:19.993518	2477
5228	43	2016-05-30 14:32:19.999426	2481
5229	43	2016-05-30 14:32:20.004774	2453
5230	43	2016-05-30 14:32:20.01052	2491
5231	43	2016-05-30 14:32:20.016679	2483
5232	43	2016-05-30 14:32:20.022279	2443
5233	43	2016-05-30 14:32:20.027674	2501
5234	43	2016-05-30 14:32:20.033209	2375
5235	43	2016-05-30 14:32:20.038684	2458
5236	43	2016-05-30 14:32:20.04393	2499
5237	43	2016-05-30 14:32:20.049131	2471
5238	43	2016-05-30 14:32:20.054595	2487
5239	43	2016-05-30 14:32:20.060159	2441
5240	43	2016-05-30 14:32:20.065512	2451
5241	43	2016-05-30 14:32:20.07088	2507
5242	43	2016-05-30 14:32:20.076511	2464
5243	43	2016-05-30 14:32:20.081857	2497
5244	43	2016-05-30 14:32:20.0874	2460
5245	43	2016-05-30 14:32:20.092894	2493
5246	43	2016-05-30 14:32:20.0981	2473
5247	43	2016-05-30 14:32:20.103429	2445
5248	43	2016-05-30 14:32:20.108893	2485
5249	43	2016-05-30 14:32:20.114286	2495
5250	43	2016-05-30 14:32:20.11952	2449
5251	43	2016-05-30 14:32:20.125491	2505
5252	43	2016-05-30 14:32:20.130885	2479
5253	43	2016-05-30 14:32:20.136119	2456
5254	43	2016-05-30 14:32:20.141662	2503
5255	40	2016-05-30 14:32:20.148131	47212
5256	40	2016-05-30 14:32:20.153104	47206
5257	40	2016-05-30 14:32:20.158108	47215
5258	40	2016-05-30 14:32:20.163673	47209
5259	40	2016-05-30 14:32:20.168337	47256
5260	40	2016-05-30 14:32:20.176372	47340
5261	40	2016-05-30 14:32:20.181388	47203
5262	49	2016-05-30 14:32:20.188333	47209
5263	49	2016-05-30 14:32:20.194082	47256
5264	49	2016-05-30 14:32:20.199538	47212
5265	49	2016-05-30 14:32:20.205343	47206
5266	49	2016-05-30 14:32:20.214077	47340
5267	49	2016-05-30 14:32:20.219607	47203
5268	49	2016-05-30 14:32:20.225632	47215
5269	48	2016-05-30 14:32:20.232797	2500
5270	48	2016-05-30 14:32:20.2395	2374
5271	48	2016-05-30 14:32:20.247685	2475
5272	48	2016-05-30 14:32:20.253905	2498
5273	48	2016-05-30 14:32:20.260635	2480
5274	48	2016-05-30 14:32:20.266674	2454
5275	48	2016-05-30 14:32:20.273878	2465
5276	48	2016-05-30 14:32:20.280173	2459
5277	48	2016-05-30 14:32:20.286	2472
5278	48	2016-05-30 14:32:20.292813	2467
5279	48	2016-05-30 14:32:20.298836	2504
5280	48	2016-05-30 14:32:20.305034	2469
5281	48	2016-05-30 14:32:20.311914	2442
5282	48	2016-05-30 14:32:20.317997	2474
5283	48	2016-05-30 14:32:20.323966	2486
5284	48	2016-05-30 14:32:20.330597	2476
5285	48	2016-05-30 14:32:20.336718	2492
5286	48	2016-05-30 14:32:20.343414	2448
5287	48	2016-05-30 14:32:20.349646	2490
5288	48	2016-05-30 14:32:20.355665	2440
5289	48	2016-05-30 14:32:20.362283	2452
5290	48	2016-05-30 14:32:20.368584	2468
5291	48	2016-05-30 14:32:20.375206	2450
5292	48	2016-05-30 14:32:20.381266	2470
5293	48	2016-05-30 14:32:20.387197	2506
5294	48	2016-05-30 14:32:20.393658	2461
5295	48	2016-05-30 14:32:20.400114	2502
5296	48	2016-05-30 14:32:20.406842	2455
5297	48	2016-05-30 14:32:20.413214	2478
5298	48	2016-05-30 14:32:20.419593	2488
5299	48	2016-05-30 14:32:20.426388	2494
5300	48	2016-05-30 14:32:20.432649	2484
5301	48	2016-05-30 14:32:20.438977	2514
5302	48	2016-05-30 14:32:20.445333	2457
5303	48	2016-05-30 14:32:20.451498	2482
5304	48	2016-05-30 14:32:20.457794	2463
5305	48	2016-05-30 14:32:20.46398	2444
5306	48	2016-05-30 14:32:20.47022	2496
5307	50	2016-05-30 14:32:20.47684	47209
5308	50	2016-05-30 14:32:20.482386	47256
5309	50	2016-05-30 14:32:20.488332	47212
5310	50	2016-05-30 14:32:20.494164	47206
5311	50	2016-05-30 14:32:20.502644	47340
5312	50	2016-05-30 14:32:20.508353	47203
5313	50	2016-05-30 14:32:20.514447	47215
5314	47	2016-05-30 14:32:20.521144	2500
5315	47	2016-05-30 14:32:20.527049	2374
5316	47	2016-05-30 14:32:20.533423	2475
5317	47	2016-05-30 14:32:20.539348	2498
5318	47	2016-05-30 14:32:20.545183	2480
5319	47	2016-05-30 14:32:20.551354	2454
5320	47	2016-05-30 14:32:20.55743	2465
5321	47	2016-05-30 14:32:20.563665	2459
5322	47	2016-05-30 14:32:20.569643	2472
5323	47	2016-05-30 14:32:20.575847	2467
5324	47	2016-05-30 14:32:20.581629	2504
5325	47	2016-05-30 14:32:20.587718	2469
5326	47	2016-05-30 14:32:20.593678	2442
5327	47	2016-05-30 14:32:20.599972	2474
5328	47	2016-05-30 14:32:20.606245	2486
5329	47	2016-05-30 14:32:20.612473	2476
5330	47	2016-05-30 14:32:20.618463	2492
5331	47	2016-05-30 14:32:20.625185	2448
5332	47	2016-05-30 14:32:20.631251	2490
5333	47	2016-05-30 14:32:20.637308	2440
5334	47	2016-05-30 14:32:20.644185	2452
5335	47	2016-05-30 14:32:20.650456	2468
5336	47	2016-05-30 14:32:20.656793	2450
5337	47	2016-05-30 14:32:20.663691	2470
5338	47	2016-05-30 14:32:20.671341	2506
5339	47	2016-05-30 14:32:20.67854	2461
5340	47	2016-05-30 14:32:20.684935	2502
5341	47	2016-05-30 14:32:20.692099	2455
5342	47	2016-05-30 14:32:20.699424	2478
5343	47	2016-05-30 14:32:20.706455	2488
5344	47	2016-05-30 14:32:20.727359	2494
5345	47	2016-05-30 14:32:20.743211	2484
5346	47	2016-05-30 14:32:21.064	2514
5347	47	2016-05-30 14:32:21.076219	2457
5348	47	2016-05-30 14:32:21.165825	2482
5349	47	2016-05-30 14:32:21.187539	2463
5350	47	2016-05-30 14:32:21.207295	2444
5351	47	2016-05-30 14:32:21.269696	2496
5352	41	2016-05-30 14:34:13.222608	2518
5353	41	2016-05-30 14:34:13.229481	2378
5354	41	2016-05-30 14:34:13.2405	2517
5355	41	2016-05-30 14:34:13.250669	2522
5356	41	2016-05-30 14:34:13.261514	2520
5357	41	2016-05-30 14:34:13.272187	2521
5358	41	2016-05-30 14:34:13.282617	2523
5359	41	2016-05-30 14:34:13.293313	2525
5360	41	2016-05-30 14:34:13.304045	2516
5361	41	2016-05-30 14:34:13.31431	2519
5362	41	2016-05-30 14:34:13.324937	2524
5363	46	2016-05-30 14:34:13.331229	2398
5364	45	2016-05-30 14:34:13.33741	2400
5365	44	2016-05-30 14:34:13.344196	2382
5366	42	2016-05-30 14:34:13.351449	2444
5367	42	2016-05-30 14:34:13.373078	2486
5368	42	2016-05-30 14:34:13.378656	2450
5369	42	2016-05-30 14:34:13.384108	2452
5370	42	2016-05-30 14:34:13.390152	2455
5371	42	2016-05-30 14:34:13.395464	2482
5372	42	2016-05-30 14:34:13.400925	2488
5373	42	2016-05-30 14:34:13.406681	2472
5374	42	2016-05-30 14:34:13.412302	2500
5375	42	2016-05-30 14:34:13.418059	2374
5376	42	2016-05-30 14:34:13.42404	2442
5377	42	2016-05-30 14:34:13.429415	2496
5378	42	2016-05-30 14:34:13.434799	2467
5379	42	2016-05-30 14:34:13.440962	2490
5380	42	2016-05-30 14:34:13.447147	2504
5381	42	2016-05-30 14:34:13.452807	2494
5382	42	2016-05-30 14:34:13.459029	2470
5383	42	2016-05-30 14:34:13.464892	2498
5384	42	2016-05-30 14:34:13.470379	2484
5385	42	2016-05-30 14:34:13.47669	2506
5386	42	2016-05-30 14:34:13.482802	2440
5387	42	2016-05-30 14:34:13.488375	2468
5388	42	2016-05-30 14:34:13.494822	2478
5389	42	2016-05-30 14:34:13.500528	2480
5390	42	2016-05-30 14:34:13.506017	2457
5391	42	2016-05-30 14:34:13.511484	2475
5392	42	2016-05-30 14:34:13.516866	2502
5393	42	2016-05-30 14:34:13.522426	2459
5394	42	2016-05-30 14:34:13.528373	2463
5395	42	2016-05-30 14:34:13.534551	2476
5396	42	2016-05-30 14:34:13.540155	2448
5397	42	2016-05-30 14:34:13.545453	2465
5398	42	2016-05-30 14:34:13.550867	2461
5399	42	2016-05-30 14:34:13.556604	2469
5400	42	2016-05-30 14:34:13.562321	2474
5401	42	2016-05-30 14:34:13.567705	2492
5402	43	2016-05-30 14:34:13.573594	2462
5403	43	2016-05-30 14:34:13.578994	2466
5404	43	2016-05-30 14:34:13.584204	2489
5405	43	2016-05-30 14:34:13.58997	2477
5406	43	2016-05-30 14:34:13.595367	2481
5407	43	2016-05-30 14:34:13.600959	2453
5408	43	2016-05-30 14:34:13.606197	2491
5409	43	2016-05-30 14:34:13.611963	2483
5410	43	2016-05-30 14:34:13.617464	2443
5411	43	2016-05-30 14:34:13.622686	2501
5412	43	2016-05-30 14:34:13.628198	2375
5413	43	2016-05-30 14:34:13.634093	2458
5414	43	2016-05-30 14:34:13.639428	2499
5415	43	2016-05-30 14:34:13.644867	2471
5416	43	2016-05-30 14:34:13.650507	2487
5417	43	2016-05-30 14:34:13.656147	2441
5418	43	2016-05-30 14:34:13.661589	2451
5419	43	2016-05-30 14:34:13.667234	2507
5420	43	2016-05-30 14:34:13.672809	2464
5421	43	2016-05-30 14:34:13.678519	2497
5422	43	2016-05-30 14:34:13.684273	2460
5423	43	2016-05-30 14:34:13.689522	2493
5424	43	2016-05-30 14:34:13.6951	2473
5425	43	2016-05-30 14:34:13.701223	2445
5426	43	2016-05-30 14:34:13.707372	2485
5427	43	2016-05-30 14:34:13.712946	2495
5428	43	2016-05-30 14:34:13.718838	2449
5429	43	2016-05-30 14:34:13.725032	2505
5430	43	2016-05-30 14:34:13.730777	2479
5431	43	2016-05-30 14:34:13.736286	2456
5432	43	2016-05-30 14:34:13.741742	2503
5433	40	2016-05-30 14:34:13.748986	47212
5434	40	2016-05-30 14:34:13.753752	47206
5435	40	2016-05-30 14:34:13.75859	47215
5436	40	2016-05-30 14:34:13.763869	47209
5437	40	2016-05-30 14:34:13.768768	47256
5438	40	2016-05-30 14:34:13.776615	47340
5439	40	2016-05-30 14:34:13.78227	47203
5440	49	2016-05-30 14:34:13.78918	47209
5441	49	2016-05-30 14:34:13.794667	47256
5442	49	2016-05-30 14:34:13.800812	47212
5443	49	2016-05-30 14:34:13.806642	47206
5444	49	2016-05-30 14:34:13.815824	47340
5445	49	2016-05-30 14:34:13.821573	47203
5446	49	2016-05-30 14:34:13.827487	47215
5447	48	2016-05-30 14:34:13.83518	2500
5448	48	2016-05-30 14:34:13.841393	2374
5449	48	2016-05-30 14:34:13.848289	2475
5450	48	2016-05-30 14:34:13.854476	2498
5451	48	2016-05-30 14:34:13.860918	2480
5452	48	2016-05-30 14:34:13.867946	2454
5453	48	2016-05-30 14:34:13.874133	2465
5454	48	2016-05-30 14:34:13.881904	2459
5455	48	2016-05-30 14:34:13.888401	2472
5456	48	2016-05-30 14:34:13.894915	2467
5457	48	2016-05-30 14:34:13.901645	2504
5458	48	2016-05-30 14:34:13.908253	2469
5459	48	2016-05-30 14:34:13.915074	2442
5460	48	2016-05-30 14:34:13.921536	2474
5461	48	2016-05-30 14:34:13.927677	2486
5462	48	2016-05-30 14:34:13.934277	2476
5463	48	2016-05-30 14:34:13.940284	2492
5464	48	2016-05-30 14:34:13.946633	2448
5465	48	2016-05-30 14:34:13.953074	2490
5466	48	2016-05-30 14:34:13.960109	2440
5467	48	2016-05-30 14:34:13.966948	2452
5468	48	2016-05-30 14:34:13.973601	2468
5469	48	2016-05-30 14:34:13.979868	2450
5470	48	2016-05-30 14:34:13.986748	2470
5471	48	2016-05-30 14:34:13.99288	2506
5472	48	2016-05-30 14:34:13.999149	2461
5473	48	2016-05-30 14:34:14.00536	2502
5474	48	2016-05-30 14:34:14.012081	2455
5475	48	2016-05-30 14:34:14.018367	2478
5476	48	2016-05-30 14:34:14.024295	2488
5477	48	2016-05-30 14:34:14.030604	2494
5478	48	2016-05-30 14:34:14.037256	2484
5479	48	2016-05-30 14:34:14.043024	2514
5480	48	2016-05-30 14:34:14.049265	2457
5481	48	2016-05-30 14:34:14.055233	2482
5482	48	2016-05-30 14:34:14.061672	2463
5483	48	2016-05-30 14:34:14.068141	2444
5484	48	2016-05-30 14:34:14.074252	2496
5485	50	2016-05-30 14:34:14.081035	47209
5486	50	2016-05-30 14:34:14.0866	47256
5487	50	2016-05-30 14:34:14.09232	47212
5488	50	2016-05-30 14:34:14.097992	47206
5489	50	2016-05-30 14:34:14.106623	47340
5490	50	2016-05-30 14:34:14.112434	47203
5491	50	2016-05-30 14:34:14.118192	47215
5492	47	2016-05-30 14:34:14.124994	2500
5493	47	2016-05-30 14:34:14.131466	2374
5494	47	2016-05-30 14:34:14.137677	2475
5495	47	2016-05-30 14:34:14.143621	2498
5496	47	2016-05-30 14:34:14.149551	2480
5497	47	2016-05-30 14:34:14.155556	2454
5498	47	2016-05-30 14:34:14.162193	2465
5499	47	2016-05-30 14:34:14.16814	2459
5500	47	2016-05-30 14:34:14.174007	2472
5501	47	2016-05-30 14:34:14.18036	2467
5502	47	2016-05-30 14:34:14.18658	2504
5503	47	2016-05-30 14:34:14.193109	2469
5504	47	2016-05-30 14:34:14.199133	2442
5505	47	2016-05-30 14:34:14.206049	2474
5506	47	2016-05-30 14:34:14.212326	2486
5507	47	2016-05-30 14:34:14.218413	2476
5508	47	2016-05-30 14:34:14.22474	2492
5509	47	2016-05-30 14:34:14.230723	2448
5510	47	2016-05-30 14:34:14.237418	2490
5511	47	2016-05-30 14:34:14.243383	2440
5512	47	2016-05-30 14:34:14.249642	2452
5513	47	2016-05-30 14:34:14.256944	2468
5514	47	2016-05-30 14:34:14.262855	2450
5515	47	2016-05-30 14:34:14.269186	2470
5516	47	2016-05-30 14:34:14.275821	2506
5517	47	2016-05-30 14:34:14.281865	2461
5518	47	2016-05-30 14:34:14.28833	2502
5519	47	2016-05-30 14:34:14.294407	2455
5520	47	2016-05-30 14:34:14.300754	2478
5521	47	2016-05-30 14:34:14.307825	2488
5522	47	2016-05-30 14:34:14.313997	2494
5523	47	2016-05-30 14:34:14.320084	2484
5524	47	2016-05-30 14:34:14.326429	2514
5525	47	2016-05-30 14:34:14.332476	2457
5526	47	2016-05-30 14:34:14.339005	2482
5527	47	2016-05-30 14:34:14.344913	2463
5528	47	2016-05-30 14:34:14.351336	2444
5529	47	2016-05-30 14:34:14.358063	2496
5530	41	2016-05-30 14:38:06.631162	2518
5531	41	2016-05-30 14:38:06.636937	2378
5532	41	2016-05-30 14:38:06.647223	2517
5533	41	2016-05-30 14:38:06.657753	2522
5534	41	2016-05-30 14:38:06.667613	2520
5535	41	2016-05-30 14:38:06.677844	2521
5536	41	2016-05-30 14:38:06.687685	2523
5537	41	2016-05-30 14:38:06.697703	2525
5538	41	2016-05-30 14:38:06.708281	2516
5539	41	2016-05-30 14:38:06.718656	2519
5540	41	2016-05-30 14:38:06.728747	2524
5541	46	2016-05-30 14:38:06.734856	2398
5542	45	2016-05-30 14:38:06.740906	2400
5543	44	2016-05-30 14:38:06.746672	2382
5544	42	2016-05-30 14:38:06.752158	2444
5545	42	2016-05-30 14:38:06.757408	2486
5546	42	2016-05-30 14:38:06.762528	2450
5547	42	2016-05-30 14:38:06.767868	2452
5548	42	2016-05-30 14:38:06.773073	2455
5549	42	2016-05-30 14:38:06.778328	2482
5550	42	2016-05-30 14:38:06.783723	2488
5551	42	2016-05-30 14:38:06.789045	2472
5552	42	2016-05-30 14:38:06.794575	2500
5553	42	2016-05-30 14:38:06.800196	2374
5554	42	2016-05-30 14:38:06.805869	2442
5555	42	2016-05-30 14:38:06.811461	2496
5556	42	2016-05-30 14:38:06.817032	2467
5557	42	2016-05-30 14:38:06.822769	2490
5558	42	2016-05-30 14:38:06.828614	2504
5559	42	2016-05-30 14:38:06.834248	2494
5560	42	2016-05-30 14:38:06.839679	2470
5561	42	2016-05-30 14:38:06.845569	2498
5562	42	2016-05-30 14:38:06.851425	2484
5563	42	2016-05-30 14:38:06.85743	2506
5564	42	2016-05-30 14:38:06.864002	2440
5565	42	2016-05-30 14:38:06.869737	2468
5566	42	2016-05-30 14:38:06.876788	2478
5567	42	2016-05-30 14:38:06.882417	2480
5568	42	2016-05-30 14:38:06.887737	2457
5569	42	2016-05-30 14:38:06.893509	2475
5570	42	2016-05-30 14:38:06.899582	2502
5571	42	2016-05-30 14:38:06.905139	2459
5572	42	2016-05-30 14:38:06.911014	2463
5573	42	2016-05-30 14:38:06.916944	2476
5574	42	2016-05-30 14:38:06.922712	2448
5575	42	2016-05-30 14:38:06.928106	2465
5576	42	2016-05-30 14:38:06.933988	2461
5577	42	2016-05-30 14:38:06.939613	2469
5578	42	2016-05-30 14:38:06.94531	2474
5579	42	2016-05-30 14:38:06.951117	2492
5580	43	2016-05-30 14:38:06.957216	2462
5581	43	2016-05-30 14:38:06.962768	2466
5582	43	2016-05-30 14:38:06.968181	2489
5583	43	2016-05-30 14:38:06.973709	2477
5584	43	2016-05-30 14:38:06.979085	2481
5585	43	2016-05-30 14:38:06.98484	2453
5586	43	2016-05-30 14:38:06.990223	2491
5587	43	2016-05-30 14:38:06.995367	2483
5588	43	2016-05-30 14:38:07.000675	2443
5589	43	2016-05-30 14:38:07.006398	2501
5590	43	2016-05-30 14:38:07.011722	2375
5591	43	2016-05-30 14:38:07.017348	2458
5592	43	2016-05-30 14:38:07.022552	2499
5593	43	2016-05-30 14:38:07.027849	2471
5594	43	2016-05-30 14:38:07.033433	2487
5595	43	2016-05-30 14:38:07.038936	2441
5596	43	2016-05-30 14:38:07.044698	2451
5597	43	2016-05-30 14:38:07.049906	2507
5598	43	2016-05-30 14:38:07.055366	2464
5599	43	2016-05-30 14:38:07.060724	2497
5600	43	2016-05-30 14:38:07.066219	2460
5601	43	2016-05-30 14:38:07.072087	2493
5602	43	2016-05-30 14:38:07.077576	2473
5603	43	2016-05-30 14:38:07.082827	2445
5604	43	2016-05-30 14:38:07.087934	2485
5605	43	2016-05-30 14:38:07.093333	2495
5606	43	2016-05-30 14:38:07.098704	2449
5607	43	2016-05-30 14:38:07.104091	2505
5608	43	2016-05-30 14:38:07.10961	2479
5609	43	2016-05-30 14:38:07.11562	2456
5610	43	2016-05-30 14:38:07.1209	2503
5611	40	2016-05-30 14:38:07.137577	47212
5612	40	2016-05-30 14:38:07.142645	47206
5613	40	2016-05-30 14:38:07.147444	47215
5614	40	2016-05-30 14:38:07.152979	47209
5615	40	2016-05-30 14:38:07.157983	47256
5616	40	2016-05-30 14:38:07.165716	47340
5617	40	2016-05-30 14:38:07.170448	47203
5618	49	2016-05-30 14:38:07.177383	47209
5619	49	2016-05-30 14:38:07.182477	47256
5620	49	2016-05-30 14:38:07.188372	47212
5621	49	2016-05-30 14:38:07.193819	47206
5622	49	2016-05-30 14:38:07.202179	47340
5623	49	2016-05-30 14:38:07.207687	47203
5624	49	2016-05-30 14:38:07.213378	47215
5625	48	2016-05-30 14:38:07.220589	2500
5626	48	2016-05-30 14:38:07.226985	2374
5627	48	2016-05-30 14:38:07.233248	2475
5628	48	2016-05-30 14:38:07.239537	2498
5629	48	2016-05-30 14:38:07.245814	2480
5630	48	2016-05-30 14:38:07.252333	2454
5631	48	2016-05-30 14:38:07.25862	2465
5632	48	2016-05-30 14:38:07.264789	2459
5633	48	2016-05-30 14:38:07.287271	2472
5634	48	2016-05-30 14:38:07.29358	2467
5635	48	2016-05-30 14:38:07.299612	2504
5636	48	2016-05-30 14:38:07.306057	2469
5637	48	2016-05-30 14:38:07.312808	2442
5638	48	2016-05-30 14:38:07.319458	2474
5639	48	2016-05-30 14:38:07.325579	2486
5640	48	2016-05-30 14:38:07.332875	2476
5641	48	2016-05-30 14:38:07.35491	2492
5642	48	2016-05-30 14:38:07.375862	2448
5643	48	2016-05-30 14:38:07.382078	2490
5644	48	2016-05-30 14:38:07.388327	2440
5645	48	2016-05-30 14:38:07.394597	2452
5646	48	2016-05-30 14:38:07.401015	2468
5647	48	2016-05-30 14:38:07.407352	2450
5648	48	2016-05-30 14:38:07.414389	2470
5649	48	2016-05-30 14:38:07.420671	2506
5650	48	2016-05-30 14:38:07.426731	2461
5651	48	2016-05-30 14:38:07.433331	2502
5652	48	2016-05-30 14:38:07.439659	2455
5653	48	2016-05-30 14:38:07.445854	2478
5654	48	2016-05-30 14:38:07.452206	2488
5655	48	2016-05-30 14:38:07.458657	2494
5656	48	2016-05-30 14:38:07.465057	2484
5657	48	2016-05-30 14:38:07.470883	2514
5658	48	2016-05-30 14:38:07.477173	2457
5659	48	2016-05-30 14:38:07.483639	2482
5660	48	2016-05-30 14:38:07.489902	2463
5661	48	2016-05-30 14:38:07.496296	2444
5662	48	2016-05-30 14:38:07.502556	2496
5663	50	2016-05-30 14:38:07.509014	47209
5664	50	2016-05-30 14:38:07.514716	47256
5665	50	2016-05-30 14:38:07.520655	47212
5666	50	2016-05-30 14:38:07.526227	47206
5667	50	2016-05-30 14:38:07.534952	47340
5668	50	2016-05-30 14:38:07.540624	47203
5669	50	2016-05-30 14:38:07.546307	47215
5670	47	2016-05-30 14:38:07.553657	2500
5671	47	2016-05-30 14:38:07.559762	2374
5672	47	2016-05-30 14:38:07.565917	2475
5673	47	2016-05-30 14:38:07.571953	2498
5674	47	2016-05-30 14:38:07.577868	2480
5675	47	2016-05-30 14:38:07.583981	2454
5676	47	2016-05-30 14:38:07.590137	2465
5677	47	2016-05-30 14:38:07.596096	2459
5678	47	2016-05-30 14:38:07.602019	2472
5679	47	2016-05-30 14:38:07.608392	2467
5680	47	2016-05-30 14:38:07.614621	2504
5681	47	2016-05-30 14:38:07.620881	2469
5682	47	2016-05-30 14:38:07.626789	2442
5683	47	2016-05-30 14:38:07.633146	2474
5684	47	2016-05-30 14:38:07.639161	2486
5685	47	2016-05-30 14:38:07.645015	2476
5686	47	2016-05-30 14:38:07.650904	2492
5687	47	2016-05-30 14:38:07.656974	2448
5688	47	2016-05-30 14:38:07.662905	2490
5689	47	2016-05-30 14:38:07.668857	2440
5690	47	2016-05-30 14:38:07.674828	2452
5691	47	2016-05-30 14:38:07.680876	2468
5692	47	2016-05-30 14:38:07.686875	2450
5693	47	2016-05-30 14:38:07.692897	2470
5694	47	2016-05-30 14:38:07.698936	2506
5695	47	2016-05-30 14:38:07.705165	2461
5696	47	2016-05-30 14:38:07.711132	2502
5697	47	2016-05-30 14:38:07.717062	2455
5698	47	2016-05-30 14:38:07.723263	2478
5699	47	2016-05-30 14:38:07.729124	2488
5700	47	2016-05-30 14:38:07.735287	2494
5701	47	2016-05-30 14:38:07.741217	2484
5702	47	2016-05-30 14:38:07.747042	2514
5703	47	2016-05-30 14:38:07.753288	2457
5704	47	2016-05-30 14:38:07.759334	2482
5705	47	2016-05-30 14:38:07.765425	2463
5706	47	2016-05-30 14:38:07.771477	2444
5707	47	2016-05-30 14:38:07.777372	2496
5708	41	2016-05-30 21:56:33.638342	2518
5709	41	2016-05-30 21:56:33.672354	2378
5710	41	2016-05-30 21:56:33.683889	2517
5711	41	2016-05-30 21:56:33.69416	2522
5712	41	2016-05-30 21:56:33.703958	2520
5713	41	2016-05-30 21:56:33.714102	2521
5714	41	2016-05-30 21:56:33.724351	2523
5715	41	2016-05-30 21:56:33.734109	2525
5716	41	2016-05-30 21:56:33.744026	2516
5717	41	2016-05-30 21:56:33.755123	2519
5718	41	2016-05-30 21:56:33.781163	2524
5719	46	2016-05-30 21:56:33.801804	2398
5720	45	2016-05-30 21:56:33.807848	2400
5721	44	2016-05-30 21:56:33.813571	2382
5722	42	2016-05-30 21:56:33.81927	2444
5723	42	2016-05-30 21:56:33.82492	2486
5724	42	2016-05-30 21:56:33.830423	2450
5725	42	2016-05-30 21:56:33.83574	2452
5726	42	2016-05-30 21:56:33.841558	2455
5727	42	2016-05-30 21:56:33.846805	2482
5728	42	2016-05-30 21:56:33.852142	2488
5729	42	2016-05-30 21:56:33.857423	2472
5730	42	2016-05-30 21:56:33.863028	2500
5731	42	2016-05-30 21:56:33.868392	2374
5732	42	2016-05-30 21:56:33.874145	2442
5733	42	2016-05-30 21:56:33.88003	2496
5734	42	2016-05-30 21:56:33.885637	2467
5735	42	2016-05-30 21:56:33.891158	2490
5736	42	2016-05-30 21:56:33.896975	2504
5737	42	2016-05-30 21:56:33.90224	2494
5738	42	2016-05-30 21:56:33.907798	2470
5739	42	2016-05-30 21:56:33.912994	2498
5740	42	2016-05-30 21:56:33.918198	2484
5741	42	2016-05-30 21:56:33.923698	2506
5742	42	2016-05-30 21:56:33.928955	2440
5743	42	2016-05-30 21:56:33.934544	2468
5744	42	2016-05-30 21:56:33.939922	2478
5745	42	2016-05-30 21:56:33.945547	2480
5746	42	2016-05-30 21:56:33.950847	2457
5747	42	2016-05-30 21:56:33.956602	2475
5748	42	2016-05-30 21:56:33.961854	2502
5749	42	2016-05-30 21:56:33.967044	2459
5750	42	2016-05-30 21:56:33.972344	2463
5751	42	2016-05-30 21:56:33.977639	2476
5752	42	2016-05-30 21:56:33.983021	2448
5753	42	2016-05-30 21:56:33.98852	2465
5754	42	2016-05-30 21:56:33.993835	2461
5755	42	2016-05-30 21:56:33.999223	2469
5756	42	2016-05-30 21:56:34.004627	2474
5757	42	2016-05-30 21:56:34.01031	2492
5758	43	2016-05-30 21:56:34.01596	2462
5759	43	2016-05-30 21:56:34.021465	2466
5760	43	2016-05-30 21:56:34.026791	2489
5761	43	2016-05-30 21:56:34.032163	2477
5762	43	2016-05-30 21:56:34.03746	2481
5763	43	2016-05-30 21:56:34.042725	2453
5764	43	2016-05-30 21:56:34.048058	2491
5765	43	2016-05-30 21:56:34.053323	2483
5766	43	2016-05-30 21:56:34.058949	2443
5767	43	2016-05-30 21:56:34.064147	2501
5768	43	2016-05-30 21:56:34.06939	2375
5769	43	2016-05-30 21:56:34.07468	2458
5770	43	2016-05-30 21:56:34.079951	2499
5771	43	2016-05-30 21:56:34.085669	2471
5772	43	2016-05-30 21:56:34.091494	2487
5773	43	2016-05-30 21:56:34.097028	2441
5774	43	2016-05-30 21:56:34.102146	2451
5775	43	2016-05-30 21:56:34.1076	2507
5776	43	2016-05-30 21:56:34.112894	2464
5777	43	2016-05-30 21:56:34.118015	2497
5778	43	2016-05-30 21:56:34.123534	2460
5779	43	2016-05-30 21:56:34.12881	2493
5780	43	2016-05-30 21:56:34.134134	2473
5781	43	2016-05-30 21:56:34.139622	2445
5782	43	2016-05-30 21:56:34.144975	2485
5783	43	2016-05-30 21:56:34.150301	2495
5784	43	2016-05-30 21:56:34.155633	2449
5785	43	2016-05-30 21:56:34.161044	2505
5786	43	2016-05-30 21:56:34.166425	2479
5787	43	2016-05-30 21:56:34.172113	2456
5788	43	2016-05-30 21:56:34.17734	2503
5789	40	2016-05-30 21:56:34.184154	47212
5790	40	2016-05-30 21:56:34.189062	47206
5791	40	2016-05-30 21:56:34.194196	47215
5792	40	2016-05-30 21:56:34.199202	47209
5793	40	2016-05-30 21:56:34.204225	47256
5794	40	2016-05-30 21:56:34.21178	47340
5795	40	2016-05-30 21:56:34.216503	47203
5796	49	2016-05-30 21:56:34.223246	47209
5797	49	2016-05-30 21:56:34.228759	47256
5798	49	2016-05-30 21:56:34.234416	47212
5799	49	2016-05-30 21:56:34.240178	47206
5800	49	2016-05-30 21:56:34.248461	47340
5801	49	2016-05-30 21:56:34.254136	47203
5802	49	2016-05-30 21:56:34.259875	47215
5803	48	2016-05-30 21:56:34.266999	2500
5804	48	2016-05-30 21:56:34.273691	2374
5805	48	2016-05-30 21:56:34.280032	2475
5806	48	2016-05-30 21:56:34.286479	2498
5807	48	2016-05-30 21:56:34.292956	2480
5808	48	2016-05-30 21:56:34.298946	2454
5809	48	2016-05-30 21:56:34.305358	2465
5810	48	2016-05-30 21:56:34.311708	2459
5811	48	2016-05-30 21:56:34.317884	2472
5812	48	2016-05-30 21:56:34.324436	2467
5813	48	2016-05-30 21:56:34.330635	2504
5814	48	2016-05-30 21:56:34.336954	2469
5815	48	2016-05-30 21:56:34.343273	2442
5816	48	2016-05-30 21:56:34.349474	2474
5817	48	2016-05-30 21:56:34.355802	2486
5818	48	2016-05-30 21:56:34.362028	2476
5819	48	2016-05-30 21:56:34.368171	2492
5820	48	2016-05-30 21:56:34.374386	2448
5821	48	2016-05-30 21:56:34.380708	2490
5822	48	2016-05-30 21:56:34.387512	2440
5823	48	2016-05-30 21:56:34.393796	2452
5824	48	2016-05-30 21:56:34.400063	2468
5825	48	2016-05-30 21:56:34.406538	2450
5826	48	2016-05-30 21:56:34.412745	2470
5827	48	2016-05-30 21:56:34.418997	2506
5828	48	2016-05-30 21:56:34.425411	2461
5829	48	2016-05-30 21:56:34.431583	2502
5830	48	2016-05-30 21:56:34.438132	2455
5831	48	2016-05-30 21:56:34.444317	2478
5832	48	2016-05-30 21:56:34.450662	2488
5833	48	2016-05-30 21:56:34.45699	2494
5834	48	2016-05-30 21:56:34.46392	2484
5835	48	2016-05-30 21:56:34.469881	2514
5836	48	2016-05-30 21:56:34.476073	2457
5837	48	2016-05-30 21:56:34.48244	2482
5838	48	2016-05-30 21:56:34.488819	2463
5839	48	2016-05-30 21:56:34.495392	2444
5840	48	2016-05-30 21:56:34.501564	2496
5841	50	2016-05-30 21:56:34.508491	47209
5842	50	2016-05-30 21:56:34.514162	47256
5843	50	2016-05-30 21:56:34.520187	47212
5844	50	2016-05-30 21:56:34.526044	47206
5845	50	2016-05-30 21:56:34.534396	47340
5846	50	2016-05-30 21:56:34.540558	47203
5847	50	2016-05-30 21:56:34.546542	47215
5848	47	2016-05-30 21:56:34.555102	2500
5849	47	2016-05-30 21:56:34.578546	2374
5850	47	2016-05-30 21:56:34.584729	2475
5851	47	2016-05-30 21:56:34.591072	2498
5852	47	2016-05-30 21:56:34.605512	2480
5853	47	2016-05-30 21:56:34.629716	2454
5854	47	2016-05-30 21:56:34.647609	2465
5855	47	2016-05-30 21:56:34.658819	2459
5856	47	2016-05-30 21:56:34.677592	2472
5857	47	2016-05-30 21:56:34.687402	2467
5858	47	2016-05-30 21:56:34.715571	2504
5859	47	2016-05-30 21:56:34.723122	2469
5860	47	2016-05-30 21:56:34.732111	2442
5861	47	2016-05-30 21:56:34.756216	2474
5862	47	2016-05-30 21:56:34.776389	2486
5863	47	2016-05-30 21:56:34.783223	2476
5864	47	2016-05-30 21:56:34.804448	2492
5865	47	2016-05-30 21:56:34.827486	2448
5866	47	2016-05-30 21:56:34.835133	2490
5867	47	2016-05-30 21:56:34.849301	2440
5868	47	2016-05-30 21:56:34.866014	2452
5869	47	2016-05-30 21:56:34.884947	2468
5870	47	2016-05-30 21:56:34.900387	2450
5871	47	2016-05-30 21:56:34.925319	2470
5872	47	2016-05-30 21:56:34.944295	2506
5873	47	2016-05-30 21:56:34.955104	2461
5874	47	2016-05-30 21:56:34.96645	2502
5875	47	2016-05-30 21:56:34.985874	2455
5876	47	2016-05-30 21:56:34.992313	2478
5877	47	2016-05-30 21:56:35.009697	2488
5878	47	2016-05-30 21:56:35.026009	2494
5879	47	2016-05-30 21:56:35.03283	2484
5880	47	2016-05-30 21:56:35.073774	2514
5881	47	2016-05-30 21:56:35.097442	2457
5882	47	2016-05-30 21:56:35.109128	2482
5883	47	2016-05-30 21:56:35.130592	2463
5884	47	2016-05-30 21:56:35.148615	2444
5885	47	2016-05-30 21:56:35.165437	2496
5886	41	2016-05-30 22:00:04.5127	2518
5887	41	2016-05-30 22:00:04.518682	2378
5888	41	2016-05-30 22:00:04.528668	2517
5889	41	2016-05-30 22:00:04.539023	2522
5890	41	2016-05-30 22:00:04.549199	2520
5891	41	2016-05-30 22:00:04.559211	2521
5892	41	2016-05-30 22:00:04.569244	2523
5893	41	2016-05-30 22:00:04.579342	2525
5894	41	2016-05-30 22:00:04.589319	2516
5895	41	2016-05-30 22:00:04.599139	2519
5896	41	2016-05-30 22:00:04.60923	2524
5897	46	2016-05-30 22:00:04.615221	2398
5898	45	2016-05-30 22:00:04.621259	2400
5899	44	2016-05-30 22:00:04.627006	2382
5900	42	2016-05-30 22:00:04.632897	2444
5901	42	2016-05-30 22:00:04.638356	2486
5902	42	2016-05-30 22:00:04.643988	2450
5903	42	2016-05-30 22:00:04.649285	2452
5904	42	2016-05-30 22:00:04.654597	2455
5905	42	2016-05-30 22:00:04.659849	2482
5906	42	2016-05-30 22:00:04.665103	2488
5907	42	2016-05-30 22:00:04.670286	2472
5908	42	2016-05-30 22:00:04.675494	2500
5909	42	2016-05-30 22:00:04.680794	2374
5910	42	2016-05-30 22:00:04.686319	2442
5911	42	2016-05-30 22:00:04.691691	2496
5912	42	2016-05-30 22:00:04.697114	2467
5913	42	2016-05-30 22:00:04.702507	2490
5914	42	2016-05-30 22:00:04.707894	2504
5915	42	2016-05-30 22:00:04.71328	2494
5916	42	2016-05-30 22:00:04.718537	2470
5917	42	2016-05-30 22:00:04.724035	2498
5918	42	2016-05-30 22:00:04.729399	2484
5919	42	2016-05-30 22:00:04.734753	2506
5920	42	2016-05-30 22:00:04.739983	2440
5921	42	2016-05-30 22:00:04.745307	2468
5922	42	2016-05-30 22:00:04.750636	2478
5923	42	2016-05-30 22:00:04.756194	2480
5924	42	2016-05-30 22:00:04.761458	2457
5925	42	2016-05-30 22:00:04.766812	2475
5926	42	2016-05-30 22:00:04.772401	2502
5927	42	2016-05-30 22:00:04.777697	2459
5928	42	2016-05-30 22:00:04.783067	2463
5929	42	2016-05-30 22:00:04.788384	2476
5930	42	2016-05-30 22:00:04.793632	2448
5931	42	2016-05-30 22:00:04.798899	2465
5932	42	2016-05-30 22:00:04.804234	2461
5933	42	2016-05-30 22:00:04.80947	2469
5934	42	2016-05-30 22:00:04.814859	2474
5935	42	2016-05-30 22:00:04.820076	2492
5936	43	2016-05-30 22:00:04.825653	2462
5937	43	2016-05-30 22:00:04.830967	2466
5938	43	2016-05-30 22:00:04.837103	2489
5939	43	2016-05-30 22:00:04.842692	2477
5940	43	2016-05-30 22:00:04.848126	2481
5941	43	2016-05-30 22:00:04.853408	2453
5942	43	2016-05-30 22:00:04.858747	2491
5943	43	2016-05-30 22:00:04.864077	2483
5944	43	2016-05-30 22:00:04.869568	2443
5945	43	2016-05-30 22:00:04.874968	2501
5946	43	2016-05-30 22:00:04.880382	2375
5947	43	2016-05-30 22:00:04.886204	2458
5948	43	2016-05-30 22:00:04.891747	2499
5949	43	2016-05-30 22:00:04.897062	2471
5950	43	2016-05-30 22:00:04.902505	2487
5951	43	2016-05-30 22:00:04.907758	2441
5952	43	2016-05-30 22:00:04.913146	2451
5953	43	2016-05-30 22:00:04.918581	2507
5954	43	2016-05-30 22:00:04.923872	2464
5955	43	2016-05-30 22:00:04.929229	2497
5956	43	2016-05-30 22:00:04.934647	2460
5957	43	2016-05-30 22:00:04.940162	2493
5958	43	2016-05-30 22:00:04.945432	2473
5959	43	2016-05-30 22:00:04.950732	2445
5960	43	2016-05-30 22:00:04.956213	2485
5961	43	2016-05-30 22:00:04.961485	2495
5962	43	2016-05-30 22:00:04.96671	2449
5963	43	2016-05-30 22:00:04.971965	2505
5964	43	2016-05-30 22:00:04.977336	2479
5965	43	2016-05-30 22:00:04.982708	2456
5966	43	2016-05-30 22:00:04.988123	2503
5967	40	2016-05-30 22:00:04.994754	47212
5968	40	2016-05-30 22:00:04.999679	47206
5969	40	2016-05-30 22:00:05.00469	47215
5970	40	2016-05-30 22:00:05.009769	47209
5971	40	2016-05-30 22:00:05.01453	47256
5972	40	2016-05-30 22:00:05.022604	47340
5973	40	2016-05-30 22:00:05.02756	47203
5974	49	2016-05-30 22:00:05.034832	47209
5975	49	2016-05-30 22:00:05.040297	47256
5976	49	2016-05-30 22:00:05.046019	47212
5977	49	2016-05-30 22:00:05.051631	47206
5978	49	2016-05-30 22:00:05.060161	47340
5979	49	2016-05-30 22:00:05.066001	47203
5980	49	2016-05-30 22:00:05.071978	47215
5981	48	2016-05-30 22:00:05.079307	2500
5982	48	2016-05-30 22:00:05.08665	2374
5983	48	2016-05-30 22:00:05.093059	2475
5984	48	2016-05-30 22:00:05.099505	2498
5985	48	2016-05-30 22:00:05.106082	2480
5986	48	2016-05-30 22:00:05.112247	2454
5987	48	2016-05-30 22:00:05.118574	2465
5988	48	2016-05-30 22:00:05.124858	2459
5989	48	2016-05-30 22:00:05.131149	2472
5990	48	2016-05-30 22:00:05.137594	2467
5991	48	2016-05-30 22:00:05.144016	2504
5992	48	2016-05-30 22:00:05.150288	2469
5993	48	2016-05-30 22:00:05.156634	2442
5994	48	2016-05-30 22:00:05.162828	2474
5995	48	2016-05-30 22:00:05.169324	2486
5996	48	2016-05-30 22:00:05.175785	2476
5997	48	2016-05-30 22:00:05.182188	2492
5998	48	2016-05-30 22:00:05.188378	2448
5999	48	2016-05-30 22:00:05.194657	2490
6000	48	2016-05-30 22:00:05.200931	2440
6001	48	2016-05-30 22:00:05.207358	2452
6002	48	2016-05-30 22:00:05.213735	2468
6003	48	2016-05-30 22:00:05.220304	2450
6004	48	2016-05-30 22:00:05.226636	2470
6005	48	2016-05-30 22:00:05.232931	2506
6006	48	2016-05-30 22:00:05.239295	2461
6007	48	2016-05-30 22:00:05.245479	2502
6008	48	2016-05-30 22:00:05.252006	2455
6009	48	2016-05-30 22:00:05.258295	2478
6010	48	2016-05-30 22:00:05.264761	2488
6011	48	2016-05-30 22:00:05.271135	2494
6012	48	2016-05-30 22:00:05.277456	2484
6013	48	2016-05-30 22:00:05.283469	2514
6014	48	2016-05-30 22:00:05.289767	2457
6015	48	2016-05-30 22:00:05.296707	2482
6016	48	2016-05-30 22:00:05.303042	2463
6017	48	2016-05-30 22:00:05.309951	2444
6018	48	2016-05-30 22:00:05.31617	2496
6019	50	2016-05-30 22:00:05.323045	47209
6020	50	2016-05-30 22:00:05.328823	47256
6021	50	2016-05-30 22:00:05.334787	47212
6022	50	2016-05-30 22:00:05.340686	47206
6023	50	2016-05-30 22:00:05.349142	47340
6024	50	2016-05-30 22:00:05.355419	47203
6025	50	2016-05-30 22:00:05.361288	47215
6026	47	2016-05-30 22:00:05.36866	2500
6027	47	2016-05-30 22:00:05.375028	2374
6028	47	2016-05-30 22:00:05.381138	2475
6029	47	2016-05-30 22:00:05.3874	2498
6030	47	2016-05-30 22:00:05.393589	2480
6031	47	2016-05-30 22:00:05.399674	2454
6032	47	2016-05-30 22:00:05.40589	2465
6033	47	2016-05-30 22:00:05.411926	2459
6034	47	2016-05-30 22:00:05.418275	2472
6035	47	2016-05-30 22:00:05.424563	2467
6036	47	2016-05-30 22:00:05.43063	2504
6037	47	2016-05-30 22:00:05.436867	2469
6038	47	2016-05-30 22:00:05.443258	2442
6039	47	2016-05-30 22:00:05.449411	2474
6040	47	2016-05-30 22:00:05.455427	2486
6041	47	2016-05-30 22:00:05.46149	2476
6042	47	2016-05-30 22:00:05.46761	2492
6043	47	2016-05-30 22:00:05.473783	2448
6044	47	2016-05-30 22:00:05.479978	2490
6045	47	2016-05-30 22:00:05.486066	2440
6046	47	2016-05-30 22:00:05.49208	2452
6047	47	2016-05-30 22:00:05.498327	2468
6048	47	2016-05-30 22:00:05.504631	2450
6049	47	2016-05-30 22:00:05.510729	2470
6050	47	2016-05-30 22:00:05.516804	2506
6051	47	2016-05-30 22:00:05.522891	2461
6052	47	2016-05-30 22:00:05.528975	2502
6053	47	2016-05-30 22:00:05.535098	2455
6054	47	2016-05-30 22:00:05.541233	2478
6055	47	2016-05-30 22:00:05.547204	2488
6056	47	2016-05-30 22:00:05.553579	2494
6057	47	2016-05-30 22:00:05.559652	2484
6058	47	2016-05-30 22:00:05.565784	2514
6059	47	2016-05-30 22:00:05.571932	2457
6060	47	2016-05-30 22:00:05.578369	2482
6061	47	2016-05-30 22:00:05.584978	2463
6062	47	2016-05-30 22:00:05.591108	2444
6063	47	2016-05-30 22:00:05.597305	2496
6064	41	2016-05-30 22:08:40.867826	2518
6065	41	2016-05-30 22:08:40.873886	2378
6066	41	2016-05-30 22:08:40.884048	2517
6067	41	2016-05-30 22:08:40.894391	2522
6068	41	2016-05-30 22:08:40.904449	2520
6069	41	2016-05-30 22:08:40.91433	2521
6070	41	2016-05-30 22:08:40.924695	2523
6071	41	2016-05-30 22:08:40.934913	2525
6072	41	2016-05-30 22:08:40.945226	2516
6073	41	2016-05-30 22:08:40.95544	2519
6074	41	2016-05-30 22:08:40.965415	2524
6075	46	2016-05-30 22:08:40.971763	2398
6076	45	2016-05-30 22:08:40.977788	2400
6077	44	2016-05-30 22:08:40.98477	2382
6078	42	2016-05-30 22:08:40.990775	2444
6079	42	2016-05-30 22:08:40.996404	2486
6080	42	2016-05-30 22:08:41.002118	2450
6081	42	2016-05-30 22:08:41.007942	2452
6082	42	2016-05-30 22:08:41.01355	2455
6083	42	2016-05-30 22:08:41.019025	2482
6084	42	2016-05-30 22:08:41.024391	2488
6085	42	2016-05-30 22:08:41.030013	2472
6086	42	2016-05-30 22:08:41.035574	2500
6087	42	2016-05-30 22:08:41.040921	2374
6088	42	2016-05-30 22:08:41.046479	2442
6089	42	2016-05-30 22:08:41.052806	2496
6090	42	2016-05-30 22:08:41.058277	2467
6091	42	2016-05-30 22:08:41.064473	2490
6092	42	2016-05-30 22:08:41.070725	2504
6093	42	2016-05-30 22:08:41.076359	2494
6094	42	2016-05-30 22:08:41.082093	2470
6095	42	2016-05-30 22:08:41.088414	2498
6096	42	2016-05-30 22:08:41.094192	2484
6097	42	2016-05-30 22:08:41.100381	2506
6098	42	2016-05-30 22:08:41.105783	2440
6099	42	2016-05-30 22:08:41.111559	2468
6100	42	2016-05-30 22:08:41.117645	2478
6101	42	2016-05-30 22:08:41.123916	2480
6102	42	2016-05-30 22:08:41.129272	2457
6103	42	2016-05-30 22:08:41.135042	2475
6104	42	2016-05-30 22:08:41.140585	2502
6105	42	2016-05-30 22:08:41.145791	2459
6106	42	2016-05-30 22:08:41.151057	2463
6107	42	2016-05-30 22:08:41.156607	2476
6108	42	2016-05-30 22:08:41.161994	2448
6109	42	2016-05-30 22:08:41.167231	2465
6110	42	2016-05-30 22:08:41.172603	2461
6111	42	2016-05-30 22:08:41.178109	2469
6112	42	2016-05-30 22:08:41.183853	2474
6113	42	2016-05-30 22:08:41.189348	2492
6114	43	2016-05-30 22:08:41.195317	2462
6115	43	2016-05-30 22:08:41.200563	2466
6116	43	2016-05-30 22:08:41.205799	2489
6117	43	2016-05-30 22:08:41.211125	2477
6118	43	2016-05-30 22:08:41.216368	2481
6119	43	2016-05-30 22:08:41.221886	2453
6120	43	2016-05-30 22:08:41.227342	2491
6121	43	2016-05-30 22:08:41.232894	2483
6122	43	2016-05-30 22:08:41.238126	2443
6123	43	2016-05-30 22:08:41.243828	2501
6124	43	2016-05-30 22:08:41.249232	2375
6125	43	2016-05-30 22:08:41.254862	2458
6126	43	2016-05-30 22:08:41.260288	2499
6127	43	2016-05-30 22:08:41.265569	2471
6128	43	2016-05-30 22:08:41.271013	2487
6129	43	2016-05-30 22:08:41.276791	2441
6130	43	2016-05-30 22:08:41.282229	2451
6131	43	2016-05-30 22:08:41.287404	2507
6132	43	2016-05-30 22:08:41.292748	2464
6133	43	2016-05-30 22:08:41.298107	2497
6134	43	2016-05-30 22:08:41.303522	2460
6135	43	2016-05-30 22:08:41.308888	2493
6136	43	2016-05-30 22:08:41.314245	2473
6137	43	2016-05-30 22:08:41.319916	2445
6138	43	2016-05-30 22:08:41.325684	2485
6139	43	2016-05-30 22:08:41.330928	2495
6140	43	2016-05-30 22:08:41.336381	2449
6141	43	2016-05-30 22:08:41.342438	2505
6142	43	2016-05-30 22:08:41.348113	2479
6143	43	2016-05-30 22:08:41.353506	2456
6144	43	2016-05-30 22:08:41.35953	2503
6145	40	2016-05-30 22:08:41.366219	47212
6146	40	2016-05-30 22:08:41.371439	47206
6147	40	2016-05-30 22:08:41.37693	47215
6148	40	2016-05-30 22:08:41.382303	47209
6149	40	2016-05-30 22:08:41.387344	47256
6150	40	2016-05-30 22:08:41.395948	47340
6151	40	2016-05-30 22:08:41.400831	47203
6152	49	2016-05-30 22:08:41.408432	47209
6153	49	2016-05-30 22:08:41.414202	47256
6154	49	2016-05-30 22:08:41.420067	47212
6155	49	2016-05-30 22:08:41.426267	47206
6156	49	2016-05-30 22:08:41.434933	47340
6157	49	2016-05-30 22:08:41.441	47203
6158	49	2016-05-30 22:08:41.447213	47215
6159	48	2016-05-30 22:08:41.454812	2500
6160	48	2016-05-30 22:08:41.461825	2374
6161	48	2016-05-30 22:08:41.468458	2475
6162	48	2016-05-30 22:08:41.475235	2498
6163	48	2016-05-30 22:08:41.48164	2480
6164	48	2016-05-30 22:08:41.488161	2454
6165	48	2016-05-30 22:08:41.49506	2465
6166	48	2016-05-30 22:08:41.501638	2459
6167	48	2016-05-30 22:08:41.5085	2472
6168	48	2016-05-30 22:08:41.514995	2467
6169	48	2016-05-30 22:08:41.521395	2504
6170	48	2016-05-30 22:08:41.528366	2469
6171	48	2016-05-30 22:08:41.534644	2442
6172	48	2016-05-30 22:08:41.541353	2474
6173	48	2016-05-30 22:08:41.54773	2486
6174	48	2016-05-30 22:08:41.55399	2476
6175	48	2016-05-30 22:08:41.560397	2492
6176	48	2016-05-30 22:08:41.566695	2448
6177	48	2016-05-30 22:08:41.573139	2490
6178	48	2016-05-30 22:08:41.579567	2440
6179	48	2016-05-30 22:08:41.586002	2452
6180	48	2016-05-30 22:08:41.592542	2468
6181	48	2016-05-30 22:08:41.598837	2450
6182	48	2016-05-30 22:08:41.6055	2470
6183	48	2016-05-30 22:08:41.611928	2506
6184	48	2016-05-30 22:08:41.618421	2461
6185	48	2016-05-30 22:08:41.624738	2502
6186	48	2016-05-30 22:08:41.631115	2455
6187	48	2016-05-30 22:08:41.637591	2478
6188	48	2016-05-30 22:08:41.64391	2488
6189	48	2016-05-30 22:08:41.650278	2494
6190	48	2016-05-30 22:08:41.656748	2484
6191	48	2016-05-30 22:08:41.662773	2514
6192	48	2016-05-30 22:08:41.669658	2457
6193	48	2016-05-30 22:08:41.676076	2482
6194	48	2016-05-30 22:08:41.682308	2463
6195	48	2016-05-30 22:08:41.689009	2444
6196	48	2016-05-30 22:08:41.695478	2496
6197	50	2016-05-30 22:08:41.702277	47209
6198	50	2016-05-30 22:08:41.707977	47256
6199	50	2016-05-30 22:08:41.713901	47212
6200	50	2016-05-30 22:08:41.720001	47206
6201	50	2016-05-30 22:08:41.728848	47340
6202	50	2016-05-30 22:08:41.734927	47203
6203	50	2016-05-30 22:08:41.741161	47215
6204	47	2016-05-30 22:08:41.749338	2500
6205	47	2016-05-30 22:08:41.755627	2374
6206	47	2016-05-30 22:08:41.761957	2475
6207	47	2016-05-30 22:08:41.768394	2498
6208	47	2016-05-30 22:08:41.790327	2480
6209	47	2016-05-30 22:08:41.81235	2454
6210	47	2016-05-30 22:08:41.818496	2465
6211	47	2016-05-30 22:08:41.824902	2459
6212	47	2016-05-30 22:08:41.831057	2472
6213	47	2016-05-30 22:08:41.837227	2467
6214	47	2016-05-30 22:08:41.843349	2504
6215	47	2016-05-30 22:08:41.849635	2469
6216	47	2016-05-30 22:08:41.855977	2442
6217	47	2016-05-30 22:08:41.862324	2474
6218	47	2016-05-30 22:08:41.86845	2486
6219	47	2016-05-30 22:08:41.874781	2476
6220	47	2016-05-30 22:08:41.881001	2492
6221	47	2016-05-30 22:08:41.88696	2448
6222	47	2016-05-30 22:08:41.893189	2490
6223	47	2016-05-30 22:08:41.899382	2440
6224	47	2016-05-30 22:08:41.905641	2452
6225	47	2016-05-30 22:08:41.911792	2468
6226	47	2016-05-30 22:08:41.917994	2450
6227	47	2016-05-30 22:08:41.924084	2470
6228	47	2016-05-30 22:08:41.930161	2506
6229	47	2016-05-30 22:08:41.936425	2461
6230	47	2016-05-30 22:08:41.942519	2502
6231	47	2016-05-30 22:08:41.948611	2455
6232	47	2016-05-30 22:08:41.954761	2478
6233	47	2016-05-30 22:08:41.960872	2488
6234	47	2016-05-30 22:08:41.966841	2494
6235	47	2016-05-30 22:08:41.973305	2484
6236	47	2016-05-30 22:08:41.979376	2514
6237	47	2016-05-30 22:08:41.985709	2457
6238	47	2016-05-30 22:08:41.99221	2482
6239	47	2016-05-30 22:08:41.998294	2463
6240	47	2016-05-30 22:08:42.004424	2444
6241	47	2016-05-30 22:08:42.010468	2496
6242	41	2016-05-30 22:10:34.405117	2518
6243	41	2016-05-30 22:10:34.411526	2378
6244	41	2016-05-30 22:10:34.421788	2517
6245	41	2016-05-30 22:10:34.431966	2522
6246	41	2016-05-30 22:10:34.442067	2520
6247	41	2016-05-30 22:10:34.452446	2521
6248	41	2016-05-30 22:10:34.462534	2523
6249	41	2016-05-30 22:10:34.472728	2525
6250	41	2016-05-30 22:10:34.482837	2516
6251	41	2016-05-30 22:10:34.493052	2519
6252	41	2016-05-30 22:10:34.503061	2524
6253	46	2016-05-30 22:10:34.509523	2398
6254	45	2016-05-30 22:10:34.515418	2400
6255	44	2016-05-30 22:10:34.52134	2382
6256	42	2016-05-30 22:10:34.526969	2444
6257	42	2016-05-30 22:10:34.532678	2486
6258	42	2016-05-30 22:10:34.538597	2450
6259	42	2016-05-30 22:10:34.543966	2452
6260	42	2016-05-30 22:10:34.549215	2455
6261	42	2016-05-30 22:10:34.5546	2482
6262	42	2016-05-30 22:10:34.559837	2488
6263	42	2016-05-30 22:10:34.5653	2472
6264	42	2016-05-30 22:10:34.571468	2500
6265	42	2016-05-30 22:10:34.577275	2374
6266	42	2016-05-30 22:10:34.582613	2442
6267	42	2016-05-30 22:10:34.588644	2496
6268	42	2016-05-30 22:10:34.594278	2467
6269	42	2016-05-30 22:10:34.599737	2490
6270	42	2016-05-30 22:10:34.605795	2504
6271	42	2016-05-30 22:10:34.611455	2494
6272	42	2016-05-30 22:10:34.617135	2470
6273	42	2016-05-30 22:10:34.62292	2498
6274	42	2016-05-30 22:10:34.628661	2484
6275	42	2016-05-30 22:10:34.634334	2506
6276	42	2016-05-30 22:10:34.639915	2440
6277	42	2016-05-30 22:10:34.645699	2468
6278	42	2016-05-30 22:10:34.651418	2478
6279	42	2016-05-30 22:10:34.657577	2480
6280	42	2016-05-30 22:10:34.663052	2457
6281	42	2016-05-30 22:10:34.669017	2475
6282	42	2016-05-30 22:10:34.674979	2502
6283	42	2016-05-30 22:10:34.68076	2459
6284	42	2016-05-30 22:10:34.686597	2463
6285	42	2016-05-30 22:10:34.692307	2476
6286	42	2016-05-30 22:10:34.697984	2448
6287	42	2016-05-30 22:10:34.703928	2465
6288	42	2016-05-30 22:10:34.709729	2461
6289	42	2016-05-30 22:10:34.7152	2469
6290	42	2016-05-30 22:10:34.720958	2474
6291	42	2016-05-30 22:10:34.726406	2492
6292	43	2016-05-30 22:10:34.732186	2462
6293	43	2016-05-30 22:10:34.737471	2466
6294	43	2016-05-30 22:10:34.742855	2489
6295	43	2016-05-30 22:10:34.748789	2477
6296	43	2016-05-30 22:10:34.754794	2481
6297	43	2016-05-30 22:10:34.760181	2453
6298	43	2016-05-30 22:10:34.765445	2491
6299	43	2016-05-30 22:10:34.77095	2483
6300	43	2016-05-30 22:10:34.776296	2443
6301	43	2016-05-30 22:10:34.781625	2501
6302	43	2016-05-30 22:10:34.786787	2375
6303	43	2016-05-30 22:10:34.79208	2458
6304	43	2016-05-30 22:10:34.797395	2499
6305	43	2016-05-30 22:10:34.802821	2471
6306	43	2016-05-30 22:10:34.808235	2487
6307	43	2016-05-30 22:10:34.8139	2441
6308	43	2016-05-30 22:10:34.819526	2451
6309	43	2016-05-30 22:10:34.825015	2507
6310	43	2016-05-30 22:10:34.830489	2464
6311	43	2016-05-30 22:10:34.835836	2497
6312	43	2016-05-30 22:10:34.841424	2460
6313	43	2016-05-30 22:10:34.847096	2493
6314	43	2016-05-30 22:10:34.852715	2473
6315	43	2016-05-30 22:10:34.858534	2445
6316	43	2016-05-30 22:10:34.86393	2485
6317	43	2016-05-30 22:10:34.869636	2495
6318	43	2016-05-30 22:10:34.875604	2449
6319	43	2016-05-30 22:10:34.881216	2505
6320	43	2016-05-30 22:10:34.887094	2479
6321	43	2016-05-30 22:10:34.892613	2456
6322	43	2016-05-30 22:10:34.898199	2503
6323	40	2016-05-30 22:10:34.905268	47212
6324	40	2016-05-30 22:10:34.91047	47206
6325	40	2016-05-30 22:10:34.915523	47215
6326	40	2016-05-30 22:10:34.92134	47209
6327	40	2016-05-30 22:10:34.926652	47256
6328	40	2016-05-30 22:10:34.950982	47340
6329	40	2016-05-30 22:10:34.956974	47203
6330	49	2016-05-30 22:10:34.964647	47209
6331	49	2016-05-30 22:10:34.971152	47256
6332	49	2016-05-30 22:10:34.977236	47212
6333	49	2016-05-30 22:10:34.983167	47206
6334	49	2016-05-30 22:10:34.992064	47340
6335	49	2016-05-30 22:10:34.998229	47203
6336	49	2016-05-30 22:10:35.004428	47215
6337	48	2016-05-30 22:10:35.012368	2500
6338	48	2016-05-30 22:10:35.020285	2374
6339	48	2016-05-30 22:10:35.027363	2475
6340	48	2016-05-30 22:10:35.034379	2498
6341	48	2016-05-30 22:10:35.041242	2480
6342	48	2016-05-30 22:10:35.047575	2454
6343	48	2016-05-30 22:10:35.054591	2465
6344	48	2016-05-30 22:10:35.061286	2459
6345	48	2016-05-30 22:10:35.068971	2472
6346	48	2016-05-30 22:10:35.075843	2467
6347	48	2016-05-30 22:10:35.082579	2504
6348	48	2016-05-30 22:10:35.089872	2469
6349	48	2016-05-30 22:10:35.09766	2442
6350	48	2016-05-30 22:10:35.10493	2474
6351	48	2016-05-30 22:10:35.111235	2486
6352	48	2016-05-30 22:10:35.121744	2476
6353	48	2016-05-30 22:10:35.143673	2492
6354	48	2016-05-30 22:10:35.150723	2448
6355	48	2016-05-30 22:10:35.157315	2490
6356	48	2016-05-30 22:10:35.1637	2440
6357	48	2016-05-30 22:10:35.170588	2452
6358	48	2016-05-30 22:10:35.177241	2468
6359	48	2016-05-30 22:10:35.183614	2450
6360	48	2016-05-30 22:10:35.190124	2470
6361	48	2016-05-30 22:10:35.196615	2506
6362	48	2016-05-30 22:10:35.203346	2461
6363	48	2016-05-30 22:10:35.209793	2502
6364	48	2016-05-30 22:10:35.216181	2455
6365	48	2016-05-30 22:10:35.22309	2478
6366	48	2016-05-30 22:10:35.229529	2488
6367	48	2016-05-30 22:10:35.236172	2494
6368	48	2016-05-30 22:10:35.242585	2484
6369	48	2016-05-30 22:10:35.249489	2514
6370	48	2016-05-30 22:10:35.256096	2457
6371	48	2016-05-30 22:10:35.262384	2482
6372	48	2016-05-30 22:10:35.268901	2463
6373	48	2016-05-30 22:10:35.276159	2444
6374	48	2016-05-30 22:10:35.282703	2496
6375	50	2016-05-30 22:10:35.290345	47209
6376	50	2016-05-30 22:10:35.296393	47256
6377	50	2016-05-30 22:10:35.302693	47212
6378	50	2016-05-30 22:10:35.309234	47206
6379	50	2016-05-30 22:10:35.318885	47340
6380	50	2016-05-30 22:10:35.325624	47203
6381	50	2016-05-30 22:10:35.332026	47215
6382	47	2016-05-30 22:10:35.339985	2500
6383	47	2016-05-30 22:10:35.346746	2374
6384	47	2016-05-30 22:10:35.353955	2475
6385	47	2016-05-30 22:10:35.360758	2498
6386	47	2016-05-30 22:10:35.367076	2480
6387	47	2016-05-30 22:10:35.374076	2454
6388	47	2016-05-30 22:10:35.380495	2465
6389	47	2016-05-30 22:10:35.387404	2459
6390	47	2016-05-30 22:10:35.393892	2472
6391	47	2016-05-30 22:10:35.400434	2467
6392	47	2016-05-30 22:10:35.406912	2504
6393	47	2016-05-30 22:10:35.413071	2469
6394	47	2016-05-30 22:10:35.420567	2442
6395	47	2016-05-30 22:10:35.427026	2474
6396	47	2016-05-30 22:10:35.434203	2486
6397	47	2016-05-30 22:10:35.441491	2476
6398	47	2016-05-30 22:10:35.448589	2492
6399	47	2016-05-30 22:10:35.455767	2448
6400	47	2016-05-30 22:10:35.462394	2490
6401	47	2016-05-30 22:10:35.469245	2440
6402	47	2016-05-30 22:10:35.475909	2452
6403	47	2016-05-30 22:10:35.482313	2468
6404	47	2016-05-30 22:10:35.488794	2450
6405	47	2016-05-30 22:10:35.49594	2470
6406	47	2016-05-30 22:10:35.502484	2506
6407	47	2016-05-30 22:10:35.510324	2461
6408	47	2016-05-30 22:10:35.517346	2502
6409	47	2016-05-30 22:10:35.523867	2455
6410	47	2016-05-30 22:10:35.530359	2478
6411	47	2016-05-30 22:10:35.537002	2488
6412	47	2016-05-30 22:10:35.54314	2494
6413	47	2016-05-30 22:10:35.551622	2484
6414	47	2016-05-30 22:10:35.563438	2514
6415	47	2016-05-30 22:10:35.577494	2457
6416	47	2016-05-30 22:10:35.588486	2482
6417	47	2016-05-30 22:10:35.598058	2463
6418	47	2016-05-30 22:10:35.608099	2444
6419	47	2016-05-30 22:10:35.617079	2496
6420	41	2016-05-30 22:12:18.951919	2518
6421	41	2016-05-30 22:12:18.958221	2378
6422	41	2016-05-30 22:12:18.968753	2517
6423	41	2016-05-30 22:12:18.979108	2522
6424	41	2016-05-30 22:12:18.989175	2520
6425	41	2016-05-30 22:12:18.999258	2521
6426	41	2016-05-30 22:12:19.011225	2523
6427	41	2016-05-30 22:12:19.022991	2525
6428	41	2016-05-30 22:12:19.033594	2516
6429	41	2016-05-30 22:12:19.043718	2519
6430	41	2016-05-30 22:12:19.053592	2524
6431	46	2016-05-30 22:12:19.059359	2398
6432	45	2016-05-30 22:12:19.065901	2400
6433	44	2016-05-30 22:12:19.072543	2382
6434	42	2016-05-30 22:12:19.093537	2444
6435	42	2016-05-30 22:12:19.11677	2486
6436	42	2016-05-30 22:12:19.122835	2450
6437	42	2016-05-30 22:12:19.128486	2452
6438	42	2016-05-30 22:12:19.133906	2455
6439	42	2016-05-30 22:12:19.139417	2482
6440	42	2016-05-30 22:12:19.144777	2488
6441	42	2016-05-30 22:12:19.150039	2472
6442	42	2016-05-30 22:12:19.155629	2500
6443	42	2016-05-30 22:12:19.160944	2374
6444	42	2016-05-30 22:12:19.166215	2442
6445	42	2016-05-30 22:12:19.171617	2496
6446	42	2016-05-30 22:12:19.177151	2467
6447	42	2016-05-30 22:12:19.182527	2490
6448	42	2016-05-30 22:12:19.187947	2504
6449	42	2016-05-30 22:12:19.193356	2494
6450	42	2016-05-30 22:12:19.198696	2470
6451	42	2016-05-30 22:12:19.204138	2498
6452	42	2016-05-30 22:12:19.209535	2484
6453	42	2016-05-30 22:12:19.215013	2506
6454	42	2016-05-30 22:12:19.220425	2440
6455	42	2016-05-30 22:12:19.226135	2468
6456	42	2016-05-30 22:12:19.23167	2478
6457	42	2016-05-30 22:12:19.237262	2480
6458	42	2016-05-30 22:12:19.24274	2457
6459	42	2016-05-30 22:12:19.248295	2475
6460	42	2016-05-30 22:12:19.253719	2502
6461	42	2016-05-30 22:12:19.25903	2459
6462	42	2016-05-30 22:12:19.264332	2463
6463	42	2016-05-30 22:12:19.269801	2476
6464	42	2016-05-30 22:12:19.27582	2448
6465	42	2016-05-30 22:12:19.281255	2465
6466	42	2016-05-30 22:12:19.28677	2461
6467	42	2016-05-30 22:12:19.292662	2469
6468	42	2016-05-30 22:12:19.298227	2474
6469	42	2016-05-30 22:12:19.30374	2492
6470	43	2016-05-30 22:12:19.309469	2462
6471	43	2016-05-30 22:12:19.314799	2466
6472	43	2016-05-30 22:12:19.320225	2489
6473	43	2016-05-30 22:12:19.325705	2477
6474	43	2016-05-30 22:12:19.331154	2481
6475	43	2016-05-30 22:12:19.336501	2453
6476	43	2016-05-30 22:12:19.342001	2491
6477	43	2016-05-30 22:12:19.347406	2483
6478	43	2016-05-30 22:12:19.35281	2443
6479	43	2016-05-30 22:12:19.358063	2501
6480	43	2016-05-30 22:12:19.363403	2375
6481	43	2016-05-30 22:12:19.368827	2458
6482	43	2016-05-30 22:12:19.374343	2499
6483	43	2016-05-30 22:12:19.379753	2471
6484	43	2016-05-30 22:12:19.385097	2487
6485	43	2016-05-30 22:12:19.390819	2441
6486	43	2016-05-30 22:12:19.396276	2451
6487	43	2016-05-30 22:12:19.401498	2507
6488	43	2016-05-30 22:12:19.406892	2464
6489	43	2016-05-30 22:12:19.412252	2497
6490	43	2016-05-30 22:12:19.417721	2460
6491	43	2016-05-30 22:12:19.423586	2493
6492	43	2016-05-30 22:12:19.429057	2473
6493	43	2016-05-30 22:12:19.434677	2445
6494	43	2016-05-30 22:12:19.440034	2485
6495	43	2016-05-30 22:12:19.445671	2495
6496	43	2016-05-30 22:12:19.45093	2449
6497	43	2016-05-30 22:12:19.456558	2505
6498	43	2016-05-30 22:12:19.461946	2479
6499	43	2016-05-30 22:12:19.467445	2456
6500	43	2016-05-30 22:12:19.472808	2503
6501	40	2016-05-30 22:12:19.479264	47212
6502	40	2016-05-30 22:12:19.484164	47206
6503	40	2016-05-30 22:12:19.489397	47215
6504	40	2016-05-30 22:12:19.494359	47209
6505	40	2016-05-30 22:12:19.499083	47256
6506	40	2016-05-30 22:12:19.506867	47340
6507	40	2016-05-30 22:12:19.511853	47203
6508	49	2016-05-30 22:12:19.519271	47209
6509	49	2016-05-30 22:12:19.524929	47256
6510	49	2016-05-30 22:12:19.530678	47212
6511	49	2016-05-30 22:12:19.536491	47206
6512	49	2016-05-30 22:12:19.545244	47340
6513	49	2016-05-30 22:12:19.55101	47203
6514	49	2016-05-30 22:12:19.556901	47215
6515	48	2016-05-30 22:12:19.564455	2500
6516	48	2016-05-30 22:12:19.571029	2374
6517	48	2016-05-30 22:12:19.577527	2475
6518	48	2016-05-30 22:12:19.583895	2498
6519	48	2016-05-30 22:12:19.590251	2480
6520	48	2016-05-30 22:12:19.596501	2454
6521	48	2016-05-30 22:12:19.60314	2465
6522	48	2016-05-30 22:12:19.609696	2459
6523	48	2016-05-30 22:12:19.616059	2472
6524	48	2016-05-30 22:12:19.622756	2467
6525	48	2016-05-30 22:12:19.629111	2504
6526	48	2016-05-30 22:12:19.635712	2469
6527	48	2016-05-30 22:12:19.642213	2442
6528	48	2016-05-30 22:12:19.648587	2474
6529	48	2016-05-30 22:12:19.65492	2486
6530	48	2016-05-30 22:12:19.661466	2476
6531	48	2016-05-30 22:12:19.668111	2492
6532	48	2016-05-30 22:12:19.674597	2448
6533	48	2016-05-30 22:12:19.680836	2490
6534	48	2016-05-30 22:12:19.68759	2440
6535	48	2016-05-30 22:12:19.694175	2452
6536	48	2016-05-30 22:12:19.700574	2468
6537	48	2016-05-30 22:12:19.707133	2450
6538	48	2016-05-30 22:12:19.713636	2470
6539	48	2016-05-30 22:12:19.720417	2506
6540	48	2016-05-30 22:12:19.726819	2461
6541	48	2016-05-30 22:12:19.733231	2502
6542	48	2016-05-30 22:12:19.739595	2455
6543	48	2016-05-30 22:12:19.746133	2478
6544	48	2016-05-30 22:12:19.752642	2488
6545	48	2016-05-30 22:12:19.759234	2494
6546	48	2016-05-30 22:12:19.765649	2484
6547	48	2016-05-30 22:12:19.772005	2514
6548	48	2016-05-30 22:12:19.778326	2457
6549	48	2016-05-30 22:12:19.784678	2482
6550	48	2016-05-30 22:12:19.791318	2463
6551	48	2016-05-30 22:12:19.798169	2444
6552	48	2016-05-30 22:12:19.805039	2496
6553	50	2016-05-30 22:12:19.812004	47209
6554	50	2016-05-30 22:12:19.82086	47256
6555	50	2016-05-30 22:12:19.827987	47212
6556	50	2016-05-30 22:12:19.83442	47206
6557	50	2016-05-30 22:12:19.842923	47340
6558	50	2016-05-30 22:12:19.848979	47203
6559	50	2016-05-30 22:12:19.8552	47215
6560	47	2016-05-30 22:12:19.862519	2500
6561	47	2016-05-30 22:12:19.869104	2374
6562	47	2016-05-30 22:12:19.87555	2475
6563	47	2016-05-30 22:12:19.881868	2498
6564	47	2016-05-30 22:12:19.888185	2480
6565	47	2016-05-30 22:12:19.894461	2454
6566	47	2016-05-30 22:12:19.902704	2465
6567	47	2016-05-30 22:12:19.911302	2459
6568	47	2016-05-30 22:12:19.919093	2472
6569	47	2016-05-30 22:12:19.926063	2467
6570	47	2016-05-30 22:12:19.932696	2504
6571	47	2016-05-30 22:12:19.939115	2469
6572	47	2016-05-30 22:12:19.945382	2442
6573	47	2016-05-30 22:12:19.95172	2474
6574	47	2016-05-30 22:12:19.95787	2486
6575	47	2016-05-30 22:12:19.964059	2476
6576	47	2016-05-30 22:12:19.970212	2492
6577	47	2016-05-30 22:12:19.976825	2448
6578	47	2016-05-30 22:12:19.983259	2490
6579	47	2016-05-30 22:12:19.989636	2440
6580	47	2016-05-30 22:12:19.995807	2452
6581	47	2016-05-30 22:12:20.002198	2468
6582	47	2016-05-30 22:12:20.008534	2450
6583	47	2016-05-30 22:12:20.014743	2470
6584	47	2016-05-30 22:12:20.021182	2506
6585	47	2016-05-30 22:12:20.027535	2461
6586	47	2016-05-30 22:12:20.033663	2502
6587	47	2016-05-30 22:12:20.039887	2455
6588	47	2016-05-30 22:12:20.046176	2478
6589	47	2016-05-30 22:12:20.052399	2488
6590	47	2016-05-30 22:12:20.058569	2494
6591	47	2016-05-30 22:12:20.065263	2484
6592	47	2016-05-30 22:12:20.071418	2514
6593	47	2016-05-30 22:12:20.077655	2457
6594	47	2016-05-30 22:12:20.083821	2482
6595	47	2016-05-30 22:12:20.09021	2463
6596	47	2016-05-30 22:12:20.096596	2444
6597	47	2016-05-30 22:12:20.102751	2496
6598	41	2016-05-30 22:13:22.926269	2518
6599	41	2016-05-30 22:13:22.93243	2378
6600	41	2016-05-30 22:13:22.942697	2517
6601	41	2016-05-30 22:13:22.953565	2522
6602	41	2016-05-30 22:13:22.963698	2520
6603	41	2016-05-30 22:13:22.973978	2521
6604	41	2016-05-30 22:13:22.98419	2523
6605	41	2016-05-30 22:13:22.994839	2525
6606	41	2016-05-30 22:13:23.005541	2516
6607	41	2016-05-30 22:13:23.015682	2519
6608	41	2016-05-30 22:13:23.025746	2524
6609	46	2016-05-30 22:13:23.0318	2398
6610	45	2016-05-30 22:13:23.037725	2400
6611	44	2016-05-30 22:13:23.043466	2382
6612	42	2016-05-30 22:13:23.04929	2444
6613	42	2016-05-30 22:13:23.054712	2486
6614	42	2016-05-30 22:13:23.060075	2450
6615	42	2016-05-30 22:13:23.065915	2452
6616	42	2016-05-30 22:13:23.071589	2455
6617	42	2016-05-30 22:13:23.076991	2482
6618	42	2016-05-30 22:13:23.082286	2488
6619	42	2016-05-30 22:13:23.087698	2472
6620	42	2016-05-30 22:13:23.093045	2500
6621	42	2016-05-30 22:13:23.098375	2374
6622	42	2016-05-30 22:13:23.103889	2442
6623	42	2016-05-30 22:13:23.109112	2496
6624	42	2016-05-30 22:13:23.114691	2467
6625	42	2016-05-30 22:13:23.120107	2490
6626	42	2016-05-30 22:13:23.125591	2504
6627	42	2016-05-30 22:13:23.130952	2494
6628	42	2016-05-30 22:13:23.136499	2470
6629	42	2016-05-30 22:13:23.141817	2498
6630	42	2016-05-30 22:13:23.147364	2484
6631	42	2016-05-30 22:13:23.152995	2506
6632	42	2016-05-30 22:13:23.158335	2440
6633	42	2016-05-30 22:13:23.163804	2468
6634	42	2016-05-30 22:13:23.16914	2478
6635	42	2016-05-30 22:13:23.174467	2480
6636	42	2016-05-30 22:13:23.179704	2457
6637	42	2016-05-30 22:13:23.185429	2475
6638	42	2016-05-30 22:13:23.190919	2502
6639	42	2016-05-30 22:13:23.196226	2459
6640	42	2016-05-30 22:13:23.201607	2463
6641	42	2016-05-30 22:13:23.207211	2476
6642	42	2016-05-30 22:13:23.212904	2448
6643	42	2016-05-30 22:13:23.218554	2465
6644	42	2016-05-30 22:13:23.224223	2461
6645	42	2016-05-30 22:13:23.229653	2469
6646	42	2016-05-30 22:13:23.235138	2474
6647	42	2016-05-30 22:13:23.240442	2492
6648	43	2016-05-30 22:13:23.246437	2462
6649	43	2016-05-30 22:13:23.252157	2466
6650	43	2016-05-30 22:13:23.257839	2489
6651	43	2016-05-30 22:13:23.263125	2477
6652	43	2016-05-30 22:13:23.26862	2481
6653	43	2016-05-30 22:13:23.274334	2453
6654	43	2016-05-30 22:13:23.28012	2491
6655	43	2016-05-30 22:13:23.286242	2483
6656	43	2016-05-30 22:13:23.292143	2443
6657	43	2016-05-30 22:13:23.297802	2501
6658	43	2016-05-30 22:13:23.303962	2375
6659	43	2016-05-30 22:13:23.309526	2458
6660	43	2016-05-30 22:13:23.315274	2499
6661	43	2016-05-30 22:13:23.321284	2471
6662	43	2016-05-30 22:13:23.327007	2487
6663	43	2016-05-30 22:13:23.332819	2441
6664	43	2016-05-30 22:13:23.338873	2451
6665	43	2016-05-30 22:13:23.344464	2507
6666	43	2016-05-30 22:13:23.350149	2464
6667	43	2016-05-30 22:13:23.355904	2497
6668	43	2016-05-30 22:13:23.361375	2460
6669	43	2016-05-30 22:13:23.367092	2493
6670	43	2016-05-30 22:13:23.373137	2473
6671	43	2016-05-30 22:13:23.378488	2445
6672	43	2016-05-30 22:13:23.384749	2485
6673	43	2016-05-30 22:13:23.390474	2495
6674	43	2016-05-30 22:13:23.396158	2449
6675	43	2016-05-30 22:13:23.402403	2505
6676	43	2016-05-30 22:13:23.408237	2479
6677	43	2016-05-30 22:13:23.413928	2456
6678	43	2016-05-30 22:13:23.420089	2503
6679	40	2016-05-30 22:13:23.426662	47212
6680	40	2016-05-30 22:13:23.431946	47206
6681	40	2016-05-30 22:13:23.437599	47215
6682	40	2016-05-30 22:13:23.442771	47209
6683	40	2016-05-30 22:13:23.447886	47256
6684	40	2016-05-30 22:13:23.456474	47340
6685	40	2016-05-30 22:13:23.461942	47203
6686	49	2016-05-30 22:13:23.469573	47209
6687	49	2016-05-30 22:13:23.475689	47256
6688	49	2016-05-30 22:13:23.481756	47212
6689	49	2016-05-30 22:13:23.487531	47206
6690	49	2016-05-30 22:13:23.496238	47340
6691	49	2016-05-30 22:13:23.502427	47203
6692	49	2016-05-30 22:13:23.508488	47215
6693	48	2016-05-30 22:13:23.516043	2500
6694	48	2016-05-30 22:13:23.522804	2374
6695	48	2016-05-30 22:13:23.529472	2475
6696	48	2016-05-30 22:13:23.535879	2498
6697	48	2016-05-30 22:13:23.542355	2480
6698	48	2016-05-30 22:13:23.5486	2454
6699	48	2016-05-30 22:13:23.555453	2465
6700	48	2016-05-30 22:13:23.562349	2459
6701	48	2016-05-30 22:13:23.570283	2472
6702	48	2016-05-30 22:13:23.578075	2467
6703	48	2016-05-30 22:13:23.58504	2504
6704	48	2016-05-30 22:13:23.591848	2469
6705	48	2016-05-30 22:13:23.599449	2442
6706	48	2016-05-30 22:13:23.606636	2474
6707	48	2016-05-30 22:13:23.781808	2486
6708	48	2016-05-30 22:13:23.82551	2476
6709	48	2016-05-30 22:13:23.83333	2492
6710	48	2016-05-30 22:13:23.840114	2448
6711	48	2016-05-30 22:13:23.846529	2490
6712	48	2016-05-30 22:13:23.853196	2440
6713	48	2016-05-30 22:13:23.85965	2452
6714	48	2016-05-30 22:13:23.86624	2468
6715	48	2016-05-30 22:13:23.872975	2450
6716	48	2016-05-30 22:13:23.879762	2470
6717	48	2016-05-30 22:13:23.886424	2506
6718	48	2016-05-30 22:13:23.89287	2461
6719	48	2016-05-30 22:13:23.899282	2502
6720	48	2016-05-30 22:13:23.906169	2455
6721	48	2016-05-30 22:13:23.912697	2478
6722	48	2016-05-30 22:13:23.919561	2488
6723	48	2016-05-30 22:13:23.927163	2494
6724	48	2016-05-30 22:13:23.933811	2484
6725	48	2016-05-30 22:13:23.940007	2514
6726	48	2016-05-30 22:13:23.946556	2457
6727	48	2016-05-30 22:13:23.953057	2482
6728	48	2016-05-30 22:13:23.959481	2463
6729	48	2016-05-30 22:13:23.966146	2444
6730	48	2016-05-30 22:13:23.972693	2496
6731	50	2016-05-30 22:13:23.979814	47209
6732	50	2016-05-30 22:13:23.985732	47256
6733	50	2016-05-30 22:13:23.991719	47212
6734	50	2016-05-30 22:13:23.997714	47206
6735	50	2016-05-30 22:13:24.006696	47340
6736	50	2016-05-30 22:13:24.012879	47203
6737	50	2016-05-30 22:13:24.019152	47215
6738	47	2016-05-30 22:13:24.026717	2500
6739	47	2016-05-30 22:13:24.033172	2374
6740	47	2016-05-30 22:13:24.039707	2475
6741	47	2016-05-30 22:13:24.046186	2498
6742	47	2016-05-30 22:13:24.052504	2480
6743	47	2016-05-30 22:13:24.058609	2454
6744	47	2016-05-30 22:13:24.065525	2465
6745	47	2016-05-30 22:13:24.072094	2459
6746	47	2016-05-30 22:13:24.078199	2472
6747	47	2016-05-30 22:13:24.084771	2467
6748	47	2016-05-30 22:13:24.090945	2504
6749	47	2016-05-30 22:13:24.097212	2469
6750	47	2016-05-30 22:13:24.103432	2442
6751	47	2016-05-30 22:13:24.109839	2474
6752	47	2016-05-30 22:13:24.11624	2486
6753	47	2016-05-30 22:13:24.12251	2476
6754	47	2016-05-30 22:13:24.128802	2492
6755	47	2016-05-30 22:13:24.135023	2448
6756	47	2016-05-30 22:13:24.141391	2490
6757	47	2016-05-30 22:13:24.147719	2440
6758	47	2016-05-30 22:13:24.154272	2452
6759	47	2016-05-30 22:13:24.160676	2468
6760	47	2016-05-30 22:13:24.167161	2450
6761	47	2016-05-30 22:13:24.173412	2470
6762	47	2016-05-30 22:13:24.179873	2506
6763	47	2016-05-30 22:13:24.186596	2461
6764	47	2016-05-30 22:13:24.192903	2502
6765	47	2016-05-30 22:13:24.19937	2455
6766	47	2016-05-30 22:13:24.205874	2478
6767	47	2016-05-30 22:13:24.212692	2488
6768	47	2016-05-30 22:13:24.2198	2494
6769	47	2016-05-30 22:13:24.226491	2484
6770	47	2016-05-30 22:13:24.233117	2514
6771	47	2016-05-30 22:13:24.239807	2457
6772	47	2016-05-30 22:13:24.246328	2482
6773	47	2016-05-30 22:13:24.253198	2463
6774	47	2016-05-30 22:13:24.25986	2444
6775	47	2016-05-30 22:13:24.266656	2496
6776	40	2016-05-30 22:14:16.927067	47343
6777	41	2016-05-30 22:14:23.850893	2518
6778	41	2016-05-30 22:14:23.954513	2378
6779	41	2016-05-30 22:14:23.97724	2517
6780	41	2016-05-30 22:14:23.99944	2522
6781	41	2016-05-30 22:14:24.017623	2520
6782	41	2016-05-30 22:14:24.039458	2521
6783	41	2016-05-30 22:14:24.052066	2523
6784	41	2016-05-30 22:14:24.065793	2525
6785	41	2016-05-30 22:14:24.07779	2516
6786	41	2016-05-30 22:14:24.10958	2519
6787	41	2016-05-30 22:14:24.179954	2524
6788	46	2016-05-30 22:14:24.323933	2398
6789	45	2016-05-30 22:14:24.446957	2400
6790	44	2016-05-30 22:14:24.561009	2382
6791	42	2016-05-30 22:14:24.651421	2444
6792	42	2016-05-30 22:14:24.726483	2486
6793	42	2016-05-30 22:14:24.813092	2450
6794	42	2016-05-30 22:14:24.92968	2452
6795	42	2016-05-30 22:14:24.99854	2455
6796	42	2016-05-30 22:14:25.124086	2482
6797	42	2016-05-30 22:14:25.136845	2488
6798	42	2016-05-30 22:14:25.145687	2472
6799	42	2016-05-30 22:14:25.158829	2500
6800	42	2016-05-30 22:14:25.165481	2374
6801	42	2016-05-30 22:14:25.178245	2442
6802	42	2016-05-30 22:14:25.185928	2496
6803	42	2016-05-30 22:14:25.192575	2467
6804	42	2016-05-30 22:14:25.199313	2490
6805	42	2016-05-30 22:14:25.206887	2504
6806	42	2016-05-30 22:14:25.213304	2494
6807	42	2016-05-30 22:14:25.221035	2470
6808	42	2016-05-30 22:14:25.375119	2498
6809	42	2016-05-30 22:14:25.507649	2484
6810	42	2016-05-30 22:14:25.519389	2506
6811	42	2016-05-30 22:14:25.608173	2440
6812	42	2016-05-30 22:14:25.669936	2468
6813	42	2016-05-30 22:14:25.759937	2478
6814	42	2016-05-30 22:14:25.772517	2480
6815	42	2016-05-30 22:14:25.779314	2457
6816	42	2016-05-30 22:14:25.79786	2475
6817	42	2016-05-30 22:14:25.833192	2502
6818	42	2016-05-30 22:14:25.84624	2459
6819	42	2016-05-30 22:14:25.852617	2463
6820	42	2016-05-30 22:14:25.858457	2476
6821	42	2016-05-30 22:14:25.864158	2448
6822	42	2016-05-30 22:14:25.872128	2465
6823	42	2016-05-30 22:14:25.881369	2461
6824	42	2016-05-30 22:14:25.887439	2469
6825	42	2016-05-30 22:14:25.915116	2474
6826	42	2016-05-30 22:14:25.960786	2492
6827	43	2016-05-30 22:14:25.988279	2462
6828	43	2016-05-30 22:14:26.228593	2466
6829	43	2016-05-30 22:14:26.310406	2489
6830	43	2016-05-30 22:14:26.38599	2477
6831	43	2016-05-30 22:14:26.547433	2481
6832	43	2016-05-30 22:14:26.611662	2453
6833	43	2016-05-30 22:14:26.709454	2491
6834	43	2016-05-30 22:14:26.84143	2483
6835	43	2016-05-30 22:14:27.018547	2443
6836	43	2016-05-30 22:14:27.070444	2501
6837	43	2016-05-30 22:14:27.220397	2375
6838	43	2016-05-30 22:14:27.294054	2458
6839	43	2016-05-30 22:14:27.430945	2499
6840	43	2016-05-30 22:14:27.549909	2471
6841	43	2016-05-30 22:14:27.626587	2487
6842	43	2016-05-30 22:14:27.686613	2441
6843	43	2016-05-30 22:14:27.767958	2451
6844	43	2016-05-30 22:14:27.862833	2507
6845	43	2016-05-30 22:14:27.935121	2464
6846	43	2016-05-30 22:14:28.035292	2497
6847	43	2016-05-30 22:14:28.163683	2460
6848	43	2016-05-30 22:14:28.283079	2493
6849	43	2016-05-30 22:14:28.432097	2473
6850	43	2016-05-30 22:14:28.534379	2445
6851	43	2016-05-30 22:14:28.626509	2485
6852	43	2016-05-30 22:14:28.713699	2495
6853	43	2016-05-30 22:14:28.80801	2449
6854	43	2016-05-30 22:14:28.971769	2505
6855	43	2016-05-30 22:14:29.115173	2479
6856	43	2016-05-30 22:14:29.380181	2456
6857	43	2016-05-30 22:14:29.581517	2503
6858	40	2016-05-30 22:14:29.629547	47212
6859	40	2016-05-30 22:14:29.644661	47206
6860	40	2016-05-30 22:14:29.808552	47215
6861	40	2016-05-30 22:14:30.004115	47209
6862	40	2016-05-30 22:14:30.148077	47256
6863	40	2016-05-30 22:14:30.255816	47340
6864	40	2016-05-30 22:14:30.379914	47203
6865	49	2016-05-30 22:14:30.434601	47209
6866	49	2016-05-30 22:14:30.50731	47256
6867	49	2016-05-30 22:14:30.664116	47212
6868	49	2016-05-30 22:14:30.768319	47206
6869	49	2016-05-30 22:14:30.820096	47340
6870	49	2016-05-30 22:14:30.911371	47203
6871	49	2016-05-30 22:14:31.047157	47215
6872	48	2016-05-30 22:14:31.113477	2500
6873	48	2016-05-30 22:14:31.219449	2374
6874	48	2016-05-30 22:14:31.425802	2475
6875	48	2016-05-30 22:14:31.554986	2498
6876	48	2016-05-30 22:14:31.582805	2480
6877	48	2016-05-30 22:14:31.70636	2454
6878	48	2016-05-30 22:14:31.799172	2465
6879	48	2016-05-30 22:14:31.844217	2459
6880	48	2016-05-30 22:14:31.852175	2472
6881	48	2016-05-30 22:14:31.863633	2467
6882	48	2016-05-30 22:14:31.877271	2504
6883	48	2016-05-30 22:14:31.984372	2469
6884	48	2016-05-30 22:14:32.064586	2442
6885	48	2016-05-30 22:14:32.094302	2474
6886	48	2016-05-30 22:14:32.104568	2486
6887	48	2016-05-30 22:14:32.117828	2476
6888	48	2016-05-30 22:14:32.193977	2492
6889	48	2016-05-30 22:14:32.276761	2448
6890	48	2016-05-30 22:14:32.375841	2490
6891	48	2016-05-30 22:14:32.483428	2440
6892	48	2016-05-30 22:14:32.524017	2452
6893	48	2016-05-30 22:14:32.653295	2468
6894	48	2016-05-30 22:14:32.677773	2450
6895	48	2016-05-30 22:14:32.694045	2470
6896	48	2016-05-30 22:14:32.704228	2506
6897	48	2016-05-30 22:14:32.772088	2461
6898	48	2016-05-30 22:14:32.79308	2502
6899	48	2016-05-30 22:14:32.810224	2455
6900	48	2016-05-30 22:14:32.818606	2478
6901	48	2016-05-30 22:14:32.844335	2488
6902	48	2016-05-30 22:14:32.877755	2494
6903	48	2016-05-30 22:14:32.916377	2484
6904	48	2016-05-30 22:14:32.925298	2514
6905	48	2016-05-30 22:14:32.935527	2457
6906	48	2016-05-30 22:14:32.94698	2482
6907	48	2016-05-30 22:14:32.961023	2463
6908	48	2016-05-30 22:14:32.968535	2444
6909	48	2016-05-30 22:14:32.975529	2496
6910	50	2016-05-30 22:14:32.982696	47209
6911	50	2016-05-30 22:14:32.988913	47256
6912	50	2016-05-30 22:14:32.995083	47212
6913	50	2016-05-30 22:14:33.00157	47206
6914	50	2016-05-30 22:14:33.010675	47340
6915	50	2016-05-30 22:14:33.016907	47203
6916	50	2016-05-30 22:14:33.023713	47215
6917	47	2016-05-30 22:14:33.033383	2500
6918	47	2016-05-30 22:14:33.040385	2374
6919	47	2016-05-30 22:14:33.046917	2475
6920	47	2016-05-30 22:14:33.053447	2498
6921	47	2016-05-30 22:14:33.059689	2480
6922	47	2016-05-30 22:14:33.066555	2454
6923	47	2016-05-30 22:14:33.073156	2465
6924	47	2016-05-30 22:14:33.080056	2459
6925	47	2016-05-30 22:14:33.086504	2472
6926	47	2016-05-30 22:14:33.092955	2467
6927	47	2016-05-30 22:14:33.100419	2504
6928	47	2016-05-30 22:14:33.109047	2469
6929	47	2016-05-30 22:14:33.115417	2442
6930	47	2016-05-30 22:14:33.122753	2474
6931	47	2016-05-30 22:14:33.128974	2486
6932	47	2016-05-30 22:14:33.135836	2476
6933	47	2016-05-30 22:14:33.142212	2492
6934	47	2016-05-30 22:14:33.149401	2448
6935	47	2016-05-30 22:14:33.174109	2490
6936	47	2016-05-30 22:14:33.181462	2440
6937	47	2016-05-30 22:14:33.188505	2452
6938	47	2016-05-30 22:14:33.196907	2468
6939	47	2016-05-30 22:14:33.204394	2450
6940	47	2016-05-30 22:14:33.210959	2470
6941	47	2016-05-30 22:14:33.217581	2506
6942	47	2016-05-30 22:14:33.224165	2461
6943	47	2016-05-30 22:14:33.230673	2502
6944	47	2016-05-30 22:14:33.237012	2455
6945	47	2016-05-30 22:14:33.2434	2478
6946	47	2016-05-30 22:14:33.249667	2488
6947	47	2016-05-30 22:14:33.256427	2494
6948	47	2016-05-30 22:14:33.263602	2484
6949	47	2016-05-30 22:14:33.288163	2514
6950	47	2016-05-30 22:14:33.29653	2457
6951	47	2016-05-30 22:14:33.305623	2482
6952	47	2016-05-30 22:14:33.312192	2463
6953	47	2016-05-30 22:14:33.318857	2444
6954	47	2016-05-30 22:14:33.325639	2496
6955	41	2016-05-30 22:17:06.048427	2518
6956	41	2016-05-30 22:17:06.054529	2378
6957	41	2016-05-30 22:17:06.065922	2517
6958	41	2016-05-30 22:17:06.076361	2522
6959	41	2016-05-30 22:17:06.086401	2520
6960	41	2016-05-30 22:17:06.096445	2521
6961	41	2016-05-30 22:17:06.106471	2523
6962	41	2016-05-30 22:17:06.116651	2525
6963	41	2016-05-30 22:17:06.122067	2528
6964	41	2016-05-30 22:17:06.132315	2516
6965	41	2016-05-30 22:17:06.142614	2519
6966	41	2016-05-30 22:17:06.15309	2524
6967	46	2016-05-30 22:17:06.159199	2398
6968	45	2016-05-30 22:17:06.165281	2400
6969	44	2016-05-30 22:17:06.1714	2382
6970	42	2016-05-30 22:17:06.177094	2444
6971	42	2016-05-30 22:17:06.182822	2486
6972	42	2016-05-30 22:17:06.188451	2450
6973	42	2016-05-30 22:17:06.193947	2452
6974	42	2016-05-30 22:17:06.199308	2455
6975	42	2016-05-30 22:17:06.204723	2482
6976	42	2016-05-30 22:17:06.210232	2488
6977	42	2016-05-30 22:17:06.215608	2472
6978	42	2016-05-30 22:17:06.221224	2500
6979	42	2016-05-30 22:17:06.226701	2374
6980	42	2016-05-30 22:17:06.23197	2442
6981	42	2016-05-30 22:17:06.237313	2496
6982	42	2016-05-30 22:17:06.242867	2467
6983	42	2016-05-30 22:17:06.24832	2490
6984	42	2016-05-30 22:17:06.253668	2504
6985	42	2016-05-30 22:17:06.259496	2494
6986	42	2016-05-30 22:17:06.265005	2470
6987	42	2016-05-30 22:17:06.270748	2498
6988	42	2016-05-30 22:17:06.276396	2484
6989	42	2016-05-30 22:17:06.281926	2506
6990	42	2016-05-30 22:17:06.287859	2440
6991	42	2016-05-30 22:17:06.294023	2468
6992	42	2016-05-30 22:17:06.299586	2478
6993	42	2016-05-30 22:17:06.305187	2480
6994	42	2016-05-30 22:17:06.311235	2457
6995	42	2016-05-30 22:17:06.317138	2475
6996	42	2016-05-30 22:17:06.322805	2502
6997	42	2016-05-30 22:17:06.3288	2459
6998	42	2016-05-30 22:17:06.334738	2463
6999	42	2016-05-30 22:17:06.340684	2476
7000	42	2016-05-30 22:17:06.346368	2448
7001	42	2016-05-30 22:17:06.352177	2465
7002	42	2016-05-30 22:17:06.358264	2461
7003	42	2016-05-30 22:17:06.363928	2469
7004	42	2016-05-30 22:17:06.370045	2474
7005	42	2016-05-30 22:17:06.376538	2492
7006	43	2016-05-30 22:17:06.382492	2462
7007	43	2016-05-30 22:17:06.388534	2466
7008	43	2016-05-30 22:17:06.394213	2489
7009	43	2016-05-30 22:17:06.399953	2477
7010	43	2016-05-30 22:17:06.405612	2481
7011	43	2016-05-30 22:17:06.411219	2453
7012	43	2016-05-30 22:17:06.417094	2491
7013	43	2016-05-30 22:17:06.422947	2483
7014	43	2016-05-30 22:17:06.429044	2443
7015	43	2016-05-30 22:17:06.434396	2501
7016	43	2016-05-30 22:17:06.440874	2375
7017	43	2016-05-30 22:17:06.447407	2458
7018	43	2016-05-30 22:17:06.453154	2499
7019	43	2016-05-30 22:17:06.459286	2471
7020	43	2016-05-30 22:17:06.465017	2487
7021	43	2016-05-30 22:17:06.471468	2441
7022	43	2016-05-30 22:17:06.477779	2451
7023	43	2016-05-30 22:17:06.48364	2507
7024	43	2016-05-30 22:17:06.489723	2464
7025	43	2016-05-30 22:17:06.495523	2497
7026	43	2016-05-30 22:17:06.501702	2460
7027	43	2016-05-30 22:17:06.507351	2493
7028	43	2016-05-30 22:17:06.51294	2473
7029	43	2016-05-30 22:17:06.518631	2445
7030	43	2016-05-30 22:17:06.524305	2485
7031	43	2016-05-30 22:17:06.529875	2495
7032	43	2016-05-30 22:17:06.535762	2449
7033	43	2016-05-30 22:17:06.541298	2505
7034	43	2016-05-30 22:17:06.547013	2479
7035	43	2016-05-30 22:17:06.552547	2456
7036	43	2016-05-30 22:17:06.558175	2503
7037	40	2016-05-30 22:17:06.564655	47212
7038	40	2016-05-30 22:17:06.56978	47206
7039	40	2016-05-30 22:17:06.574662	47215
7040	40	2016-05-30 22:17:06.579835	47209
7041	40	2016-05-30 22:17:06.584653	47256
7042	40	2016-05-30 22:17:06.592524	47340
7043	40	2016-05-30 22:17:06.597457	47203
7044	40	2016-05-30 22:17:06.60262	47343
7045	49	2016-05-30 22:17:06.610614	47209
7046	49	2016-05-30 22:17:06.616474	47256
7047	49	2016-05-30 22:17:06.622148	47343
7048	49	2016-05-30 22:17:06.628162	47212
7049	49	2016-05-30 22:17:06.634014	47206
7050	49	2016-05-30 22:17:06.642769	47340
7051	49	2016-05-30 22:17:06.648679	47203
7052	49	2016-05-30 22:17:06.654542	47215
7053	48	2016-05-30 22:17:06.662656	2500
7054	48	2016-05-30 22:17:06.669672	2374
7055	48	2016-05-30 22:17:06.676397	2475
7056	48	2016-05-30 22:17:06.682921	2498
7057	48	2016-05-30 22:17:06.689553	2480
7058	48	2016-05-30 22:17:06.695861	2454
7059	48	2016-05-30 22:17:06.703117	2465
7060	48	2016-05-30 22:17:06.71003	2459
7061	48	2016-05-30 22:17:06.716743	2472
7062	48	2016-05-30 22:17:06.723777	2467
7063	48	2016-05-30 22:17:06.730538	2504
7064	48	2016-05-30 22:17:06.737773	2469
7065	48	2016-05-30 22:17:06.744714	2442
7066	48	2016-05-30 22:17:06.751664	2474
7067	48	2016-05-30 22:17:06.758829	2486
7068	48	2016-05-30 22:17:06.765722	2476
7069	48	2016-05-30 22:17:06.77285	2492
7070	48	2016-05-30 22:17:06.779515	2448
7071	48	2016-05-30 22:17:06.786428	2490
7072	48	2016-05-30 22:17:06.793272	2440
7073	48	2016-05-30 22:17:06.800409	2452
7074	48	2016-05-30 22:17:06.807656	2468
7075	48	2016-05-30 22:17:06.815217	2450
7076	48	2016-05-30 22:17:06.822431	2470
7077	48	2016-05-30 22:17:06.829207	2506
7078	48	2016-05-30 22:17:06.836003	2461
7079	48	2016-05-30 22:17:06.842911	2502
7080	48	2016-05-30 22:17:06.849742	2455
7081	48	2016-05-30 22:17:06.857088	2478
7082	48	2016-05-30 22:17:06.864517	2488
7083	48	2016-05-30 22:17:06.871983	2494
7084	48	2016-05-30 22:17:06.87889	2484
7085	48	2016-05-30 22:17:06.885821	2514
7086	48	2016-05-30 22:17:06.893051	2457
7087	48	2016-05-30 22:17:06.89972	2482
7088	48	2016-05-30 22:17:06.907244	2463
7089	48	2016-05-30 22:17:06.914215	2444
7090	48	2016-05-30 22:17:06.921545	2496
7091	50	2016-05-30 22:17:06.928992	47209
7092	50	2016-05-30 22:17:06.935567	47256
7093	50	2016-05-30 22:17:06.942315	47212
7094	50	2016-05-30 22:17:06.948515	47206
7095	50	2016-05-30 22:17:06.958377	47340
7096	50	2016-05-30 22:17:06.964772	47203
7097	50	2016-05-30 22:17:06.971198	47215
7098	47	2016-05-30 22:17:06.979069	2500
7099	47	2016-05-30 22:17:06.986114	2374
7100	47	2016-05-30 22:17:06.993013	2475
7101	47	2016-05-30 22:17:06.999565	2498
7102	47	2016-05-30 22:17:07.006471	2480
7103	47	2016-05-30 22:17:07.012896	2454
7104	47	2016-05-30 22:17:07.019504	2465
7105	47	2016-05-30 22:17:07.026394	2459
7106	47	2016-05-30 22:17:07.033454	2472
7107	47	2016-05-30 22:17:07.04011	2467
7108	47	2016-05-30 22:17:07.047729	2504
7109	47	2016-05-30 22:17:07.055423	2469
7110	47	2016-05-30 22:17:07.062946	2442
7111	47	2016-05-30 22:17:07.069921	2474
7112	47	2016-05-30 22:17:07.076255	2486
7113	47	2016-05-30 22:17:07.082875	2476
7114	47	2016-05-30 22:17:07.089866	2492
7115	47	2016-05-30 22:17:07.096281	2448
7116	47	2016-05-30 22:17:07.102855	2490
7117	47	2016-05-30 22:17:07.109491	2440
7118	47	2016-05-30 22:17:07.115872	2452
7119	47	2016-05-30 22:17:07.122844	2468
7120	47	2016-05-30 22:17:07.129652	2450
7121	47	2016-05-30 22:17:07.136387	2470
7122	47	2016-05-30 22:17:07.14365	2506
7123	47	2016-05-30 22:17:07.152325	2461
7124	47	2016-05-30 22:17:07.16767	2502
7125	47	2016-05-30 22:17:07.180685	2455
7126	47	2016-05-30 22:17:07.192499	2478
7127	47	2016-05-30 22:17:07.202098	2488
7128	47	2016-05-30 22:17:07.211563	2494
7129	47	2016-05-30 22:17:07.221279	2484
7130	47	2016-05-30 22:17:07.2314	2514
7131	47	2016-05-30 22:17:07.240255	2457
7132	47	2016-05-30 22:17:07.248563	2482
7133	47	2016-05-30 22:17:07.258569	2463
7134	47	2016-05-30 22:17:07.26552	2444
7135	47	2016-05-30 22:17:07.27354	2496
7136	41	2016-05-30 22:19:52.130716	2518
7137	41	2016-05-30 22:19:52.137224	2378
7138	41	2016-05-30 22:19:52.147505	2517
7139	41	2016-05-30 22:19:52.157928	2522
7140	41	2016-05-30 22:19:52.168862	2520
7141	41	2016-05-30 22:19:52.178981	2521
7142	41	2016-05-30 22:19:52.189095	2523
7143	41	2016-05-30 22:19:52.199641	2525
7144	41	2016-05-30 22:19:52.205123	2528
7145	41	2016-05-30 22:19:52.215522	2516
7146	41	2016-05-30 22:19:52.225918	2519
7147	41	2016-05-30 22:19:52.236041	2524
7148	46	2016-05-30 22:19:52.242702	2398
7149	45	2016-05-30 22:19:52.248921	2400
7150	44	2016-05-30 22:19:52.254946	2382
7151	42	2016-05-30 22:19:52.261197	2444
7152	42	2016-05-30 22:19:52.266691	2486
7153	42	2016-05-30 22:19:52.27228	2450
7154	42	2016-05-30 22:19:52.278413	2452
7155	42	2016-05-30 22:19:52.284091	2455
7156	42	2016-05-30 22:19:52.289603	2482
7157	42	2016-05-30 22:19:52.295639	2488
7158	42	2016-05-30 22:19:52.301565	2472
7159	42	2016-05-30 22:19:52.307312	2500
7160	42	2016-05-30 22:19:52.313594	2374
7161	42	2016-05-30 22:19:52.319329	2442
7162	42	2016-05-30 22:19:52.325373	2496
7163	42	2016-05-30 22:19:52.331303	2467
7164	42	2016-05-30 22:19:52.33685	2490
7165	42	2016-05-30 22:19:52.342825	2504
7166	42	2016-05-30 22:19:52.349021	2494
7167	42	2016-05-30 22:19:52.354571	2470
7168	42	2016-05-30 22:19:52.360551	2498
7169	42	2016-05-30 22:19:52.366278	2484
7170	42	2016-05-30 22:19:52.372125	2506
7171	42	2016-05-30 22:19:52.378095	2440
7172	42	2016-05-30 22:19:52.384078	2468
7173	42	2016-05-30 22:19:52.389839	2478
7174	42	2016-05-30 22:19:52.396282	2480
7175	42	2016-05-30 22:19:52.401775	2457
7176	42	2016-05-30 22:19:52.407752	2475
7177	42	2016-05-30 22:19:52.414215	2502
7178	42	2016-05-30 22:19:52.420047	2459
7179	42	2016-05-30 22:19:52.42583	2463
7180	42	2016-05-30 22:19:52.43203	2476
7181	42	2016-05-30 22:19:52.437891	2448
7182	42	2016-05-30 22:19:52.44392	2465
7183	42	2016-05-30 22:19:52.449367	2461
7184	42	2016-05-30 22:19:52.455582	2469
7185	42	2016-05-30 22:19:52.462081	2474
7186	42	2016-05-30 22:19:52.467713	2492
7187	43	2016-05-30 22:19:52.473432	2462
7188	43	2016-05-30 22:19:52.479415	2466
7189	43	2016-05-30 22:19:52.485189	2489
7190	43	2016-05-30 22:19:52.490894	2477
7191	43	2016-05-30 22:19:52.497045	2481
7192	43	2016-05-30 22:19:52.503158	2453
7193	43	2016-05-30 22:19:52.509291	2491
7194	43	2016-05-30 22:19:52.515359	2483
7195	43	2016-05-30 22:19:52.520842	2443
7196	43	2016-05-30 22:19:52.526988	2501
7197	43	2016-05-30 22:19:52.532939	2375
7198	43	2016-05-30 22:19:52.538821	2458
7199	43	2016-05-30 22:19:52.544719	2499
7200	43	2016-05-30 22:19:52.550564	2471
7201	43	2016-05-30 22:19:52.556496	2487
7202	43	2016-05-30 22:19:52.56226	2441
7203	43	2016-05-30 22:19:52.568055	2451
7204	43	2016-05-30 22:19:52.574047	2507
7205	43	2016-05-30 22:19:52.580108	2464
7206	43	2016-05-30 22:19:52.585665	2497
7207	43	2016-05-30 22:19:52.591468	2460
7208	43	2016-05-30 22:19:52.597229	2493
7209	43	2016-05-30 22:19:52.603153	2473
7210	43	2016-05-30 22:19:52.609167	2445
7211	43	2016-05-30 22:19:52.614819	2485
7212	43	2016-05-30 22:19:52.621599	2495
7213	43	2016-05-30 22:19:52.627147	2449
7214	43	2016-05-30 22:19:52.632786	2505
7215	43	2016-05-30 22:19:52.640194	2479
7216	43	2016-05-30 22:19:52.646173	2456
7217	43	2016-05-30 22:19:52.651678	2503
7218	40	2016-05-30 22:19:52.658544	47212
7219	40	2016-05-30 22:19:52.663677	47206
7220	40	2016-05-30 22:19:52.66862	47215
7221	40	2016-05-30 22:19:52.673701	47209
7222	40	2016-05-30 22:19:52.678527	47256
7223	40	2016-05-30 22:19:52.686343	47340
7224	40	2016-05-30 22:19:52.691338	47203
7225	40	2016-05-30 22:19:52.696356	47343
7226	49	2016-05-30 22:19:52.704133	47209
7227	49	2016-05-30 22:19:52.709921	47256
7228	49	2016-05-30 22:19:52.715876	47343
7229	49	2016-05-30 22:19:52.722021	47212
7230	49	2016-05-30 22:19:52.728408	47206
7231	49	2016-05-30 22:19:52.753205	47340
7232	49	2016-05-30 22:19:52.775183	47203
7233	49	2016-05-30 22:19:52.781	47215
7234	48	2016-05-30 22:19:52.788972	2500
7235	48	2016-05-30 22:19:52.79596	2374
7236	48	2016-05-30 22:19:52.802683	2475
7237	48	2016-05-30 22:19:52.809395	2498
7238	48	2016-05-30 22:19:52.816167	2480
7239	48	2016-05-30 22:19:52.822711	2454
7240	48	2016-05-30 22:19:52.829341	2465
7241	48	2016-05-30 22:19:52.836137	2459
7242	48	2016-05-30 22:19:52.842897	2472
7243	48	2016-05-30 22:19:52.849759	2467
7244	48	2016-05-30 22:19:52.856528	2504
7245	48	2016-05-30 22:19:52.86347	2469
7246	48	2016-05-30 22:19:52.870155	2442
7247	48	2016-05-30 22:19:52.876997	2474
7248	48	2016-05-30 22:19:52.883715	2486
7249	48	2016-05-30 22:19:52.891692	2476
7250	48	2016-05-30 22:19:52.898417	2492
7251	48	2016-05-30 22:19:52.908635	2448
7252	48	2016-05-30 22:19:52.915981	2490
7253	48	2016-05-30 22:19:52.922999	2440
7254	48	2016-05-30 22:19:52.92961	2452
7255	48	2016-05-30 22:19:52.936397	2468
7256	48	2016-05-30 22:19:52.943162	2450
7257	48	2016-05-30 22:19:52.950237	2470
7258	48	2016-05-30 22:19:52.956999	2506
7259	48	2016-05-30 22:19:52.963628	2461
7260	48	2016-05-30 22:19:52.970231	2502
7261	48	2016-05-30 22:19:52.977016	2455
7262	48	2016-05-30 22:19:52.983678	2478
7263	48	2016-05-30 22:19:52.990512	2488
7264	48	2016-05-30 22:19:52.997152	2494
7265	48	2016-05-30 22:19:53.004003	2484
7266	48	2016-05-30 22:19:53.010531	2514
7267	48	2016-05-30 22:19:53.017204	2457
7268	48	2016-05-30 22:19:53.024161	2482
7269	48	2016-05-30 22:19:53.03092	2463
7270	48	2016-05-30 22:19:53.037767	2444
7271	48	2016-05-30 22:19:53.044412	2496
7272	50	2016-05-30 22:19:53.051604	47209
7273	50	2016-05-30 22:19:53.058551	47256
7274	50	2016-05-30 22:19:53.064429	47343
7275	50	2016-05-30 22:19:53.070711	47212
7276	50	2016-05-30 22:19:53.076898	47206
7277	50	2016-05-30 22:19:53.085721	47340
7278	50	2016-05-30 22:19:53.092062	47203
7279	50	2016-05-30 22:19:53.098398	47215
7280	47	2016-05-30 22:19:53.106279	2500
7281	47	2016-05-30 22:19:53.112963	2374
7282	47	2016-05-30 22:19:53.119636	2475
7283	47	2016-05-30 22:19:53.126273	2498
7284	47	2016-05-30 22:19:53.13286	2480
7285	47	2016-05-30 22:19:53.139385	2454
7286	47	2016-05-30 22:19:53.145911	2465
7287	47	2016-05-30 22:19:53.152287	2459
7288	47	2016-05-30 22:19:53.158872	2472
7289	47	2016-05-30 22:19:53.165508	2467
7290	47	2016-05-30 22:19:53.172153	2504
7291	47	2016-05-30 22:19:53.178681	2469
7292	47	2016-05-30 22:19:53.185213	2442
7293	47	2016-05-30 22:19:53.191905	2474
7294	47	2016-05-30 22:19:53.198341	2486
7295	47	2016-05-30 22:19:53.20492	2476
7296	47	2016-05-30 22:19:53.21145	2492
7297	47	2016-05-30 22:19:53.218061	2448
7298	47	2016-05-30 22:19:53.224761	2490
7299	47	2016-05-30 22:19:53.231319	2440
7300	47	2016-05-30 22:19:53.237759	2452
7301	47	2016-05-30 22:19:53.244272	2468
7302	47	2016-05-30 22:19:53.250724	2450
7303	47	2016-05-30 22:19:53.257544	2470
7304	47	2016-05-30 22:19:53.26398	2506
7305	47	2016-05-30 22:19:53.270522	2461
7306	47	2016-05-30 22:19:53.277112	2502
7307	47	2016-05-30 22:19:53.28345	2455
7308	47	2016-05-30 22:19:53.290047	2478
7309	47	2016-05-30 22:19:53.296528	2488
7310	47	2016-05-30 22:19:53.302921	2494
7311	47	2016-05-30 22:19:53.309475	2484
7312	47	2016-05-30 22:19:53.315933	2514
7313	47	2016-05-30 22:19:53.322539	2457
7314	47	2016-05-30 22:19:53.329046	2482
7315	47	2016-05-30 22:19:53.335539	2463
7316	47	2016-05-30 22:19:53.342162	2444
7317	47	2016-05-30 22:19:53.348593	2496
7318	41	2016-05-30 22:20:54.940336	2518
7319	41	2016-05-30 22:20:54.947565	2378
7320	41	2016-05-30 22:20:54.958694	2517
7321	41	2016-05-30 22:20:54.970068	2522
7322	41	2016-05-30 22:20:54.983534	2520
7323	41	2016-05-30 22:20:54.995985	2521
7324	41	2016-05-30 22:20:55.009703	2523
7325	41	2016-05-30 22:20:55.02326	2525
7326	41	2016-05-30 22:20:55.029325	2528
7327	41	2016-05-30 22:20:55.039788	2516
7328	41	2016-05-30 22:20:55.051964	2519
7329	41	2016-05-30 22:20:55.062342	2524
7330	46	2016-05-30 22:20:55.068393	2398
7331	45	2016-05-30 22:20:55.074407	2400
7332	44	2016-05-30 22:20:55.080969	2382
7333	42	2016-05-30 22:20:55.087022	2444
7334	42	2016-05-30 22:20:55.092659	2486
7335	42	2016-05-30 22:20:55.098292	2450
7336	42	2016-05-30 22:20:55.103666	2452
7337	42	2016-05-30 22:20:55.109541	2455
7338	42	2016-05-30 22:20:55.115247	2482
7339	42	2016-05-30 22:20:55.120863	2488
7340	42	2016-05-30 22:20:55.126871	2472
7341	42	2016-05-30 22:20:55.13237	2500
7342	42	2016-05-30 22:20:55.138629	2374
7343	42	2016-05-30 22:20:55.145055	2442
7344	42	2016-05-30 22:20:55.151092	2496
7345	42	2016-05-30 22:20:55.157004	2467
7346	42	2016-05-30 22:20:55.163222	2490
7347	42	2016-05-30 22:20:55.169249	2504
7348	42	2016-05-30 22:20:55.175065	2494
7349	42	2016-05-30 22:20:55.181649	2470
7350	42	2016-05-30 22:20:55.18737	2498
7351	42	2016-05-30 22:20:55.193371	2484
7352	42	2016-05-30 22:20:55.199559	2506
7353	42	2016-05-30 22:20:55.20564	2440
7354	42	2016-05-30 22:20:55.21179	2468
7355	42	2016-05-30 22:20:55.217649	2478
7356	42	2016-05-30 22:20:55.223334	2480
7357	42	2016-05-30 22:20:55.230019	2457
7358	42	2016-05-30 22:20:55.235776	2475
7359	42	2016-05-30 22:20:55.241501	2502
7360	42	2016-05-30 22:20:55.248249	2459
7361	42	2016-05-30 22:20:55.254272	2463
7362	42	2016-05-30 22:20:55.260085	2476
7363	42	2016-05-30 22:20:55.266223	2448
7364	42	2016-05-30 22:20:55.27211	2465
7365	42	2016-05-30 22:20:55.27818	2461
7366	42	2016-05-30 22:20:55.284455	2469
7367	42	2016-05-30 22:20:55.290179	2474
7368	42	2016-05-30 22:20:55.296734	2492
7369	43	2016-05-30 22:20:55.302883	2462
7370	43	2016-05-30 22:20:55.308813	2466
7371	43	2016-05-30 22:20:55.315118	2489
7372	43	2016-05-30 22:20:55.32084	2477
7373	43	2016-05-30 22:20:55.326672	2481
7374	43	2016-05-30 22:20:55.332713	2453
7375	43	2016-05-30 22:20:55.338302	2491
7376	43	2016-05-30 22:20:55.344125	2483
7377	43	2016-05-30 22:20:55.350288	2443
7378	43	2016-05-30 22:20:55.355701	2501
7379	43	2016-05-30 22:20:55.361999	2375
7380	43	2016-05-30 22:20:55.367785	2458
7381	43	2016-05-30 22:20:55.373365	2499
7382	43	2016-05-30 22:20:55.380173	2471
7383	43	2016-05-30 22:20:55.385973	2487
7384	43	2016-05-30 22:20:55.391485	2441
7385	43	2016-05-30 22:20:55.396904	2451
7386	43	2016-05-30 22:20:55.402387	2507
7387	43	2016-05-30 22:20:55.407978	2464
7388	43	2016-05-30 22:20:55.413643	2497
7389	43	2016-05-30 22:20:55.419212	2460
7390	43	2016-05-30 22:20:55.42462	2493
7391	43	2016-05-30 22:20:55.430047	2473
7392	43	2016-05-30 22:20:55.435554	2445
7393	43	2016-05-30 22:20:55.440984	2485
7394	43	2016-05-30 22:20:55.446524	2495
7395	43	2016-05-30 22:20:55.452078	2449
7396	43	2016-05-30 22:20:55.457699	2505
7397	43	2016-05-30 22:20:55.463657	2479
7398	43	2016-05-30 22:20:55.469187	2456
7399	43	2016-05-30 22:20:55.474723	2503
7400	40	2016-05-30 22:20:55.481272	47212
7401	40	2016-05-30 22:20:55.486334	47206
7402	40	2016-05-30 22:20:55.49153	47215
7403	40	2016-05-30 22:20:55.496766	47209
7404	40	2016-05-30 22:20:55.501596	47256
7405	40	2016-05-30 22:20:55.509848	47340
7406	40	2016-05-30 22:20:55.514874	47203
7407	40	2016-05-30 22:20:55.52005	47343
7408	49	2016-05-30 22:20:55.527754	47209
7409	49	2016-05-30 22:20:55.533522	47256
7410	49	2016-05-30 22:20:55.53946	47343
7411	49	2016-05-30 22:20:55.545663	47212
7412	49	2016-05-30 22:20:55.551669	47206
7413	49	2016-05-30 22:20:55.560424	47340
7414	49	2016-05-30 22:20:55.566651	47203
7415	49	2016-05-30 22:20:55.572642	47215
7416	48	2016-05-30 22:20:55.58085	2500
7417	48	2016-05-30 22:20:55.587654	2374
7418	48	2016-05-30 22:20:55.59482	2475
7419	48	2016-05-30 22:20:55.602144	2498
7420	48	2016-05-30 22:20:55.609376	2480
7421	48	2016-05-30 22:20:55.616245	2454
7422	48	2016-05-30 22:20:55.623533	2465
7423	48	2016-05-30 22:20:55.631493	2459
7424	48	2016-05-30 22:20:55.638501	2472
7425	48	2016-05-30 22:20:55.645457	2467
7426	48	2016-05-30 22:20:55.652438	2504
7427	48	2016-05-30 22:20:55.6596	2469
7428	48	2016-05-30 22:20:55.666823	2442
7429	48	2016-05-30 22:20:55.673851	2474
7430	48	2016-05-30 22:20:55.680928	2486
7431	48	2016-05-30 22:20:55.68803	2476
7432	48	2016-05-30 22:20:55.694971	2492
7433	48	2016-05-30 22:20:55.702422	2448
7434	48	2016-05-30 22:20:55.709327	2490
7435	48	2016-05-30 22:20:55.716425	2440
7436	48	2016-05-30 22:20:55.723478	2452
7437	48	2016-05-30 22:20:55.73034	2468
7438	48	2016-05-30 22:20:55.737546	2450
7439	48	2016-05-30 22:20:55.744624	2470
7440	48	2016-05-30 22:20:55.751778	2506
7441	48	2016-05-30 22:20:55.758529	2461
7442	48	2016-05-30 22:20:55.76549	2502
7443	48	2016-05-30 22:20:55.772414	2455
7444	48	2016-05-30 22:20:55.77935	2478
7445	48	2016-05-30 22:20:55.786187	2488
7446	48	2016-05-30 22:20:55.793327	2494
7447	48	2016-05-30 22:20:55.800004	2484
7448	48	2016-05-30 22:20:55.806532	2514
7449	48	2016-05-30 22:20:55.813323	2457
7450	48	2016-05-30 22:20:55.820361	2482
7451	48	2016-05-30 22:20:55.84263	2463
7452	48	2016-05-30 22:20:55.863906	2444
7453	48	2016-05-30 22:20:55.870498	2496
7454	50	2016-05-30 22:20:55.877781	47209
7455	50	2016-05-30 22:20:55.88398	47256
7456	50	2016-05-30 22:20:55.889926	47343
7457	50	2016-05-30 22:20:55.896607	47212
7458	50	2016-05-30 22:20:55.902882	47206
7459	50	2016-05-30 22:20:55.912525	47340
7460	50	2016-05-30 22:20:55.919027	47203
7461	50	2016-05-30 22:20:55.925865	47215
7462	47	2016-05-30 22:20:55.933843	2500
7463	47	2016-05-30 22:20:55.941024	2374
7464	47	2016-05-30 22:20:55.947831	2475
7465	47	2016-05-30 22:20:55.954758	2498
7466	47	2016-05-30 22:20:55.961662	2480
7467	47	2016-05-30 22:20:55.968506	2454
7468	47	2016-05-30 22:20:55.975568	2465
7469	47	2016-05-30 22:20:55.982036	2459
7470	47	2016-05-30 22:20:55.989145	2472
7471	47	2016-05-30 22:20:55.996119	2467
7472	47	2016-05-30 22:20:56.003014	2504
7473	47	2016-05-30 22:20:56.010383	2469
7474	47	2016-05-30 22:20:56.017516	2442
7475	47	2016-05-30 22:20:56.025051	2474
7476	47	2016-05-30 22:20:56.03165	2486
7477	47	2016-05-30 22:20:56.038749	2476
7478	47	2016-05-30 22:20:56.045496	2492
7479	47	2016-05-30 22:20:56.053257	2448
7480	47	2016-05-30 22:20:56.060182	2490
7481	47	2016-05-30 22:20:56.067032	2440
7482	47	2016-05-30 22:20:56.07413	2452
7483	47	2016-05-30 22:20:56.081111	2468
7484	47	2016-05-30 22:20:56.088621	2450
7485	47	2016-05-30 22:20:56.09544	2470
7486	47	2016-05-30 22:20:56.101966	2506
7487	47	2016-05-30 22:20:56.109416	2461
7488	47	2016-05-30 22:20:56.116034	2502
7489	47	2016-05-30 22:20:56.122834	2455
7490	47	2016-05-30 22:20:56.130376	2478
7491	47	2016-05-30 22:20:56.137122	2488
7492	47	2016-05-30 22:20:56.144467	2494
7493	47	2016-05-30 22:20:56.151193	2484
7494	47	2016-05-30 22:20:56.157882	2514
7495	47	2016-05-30 22:20:56.164495	2457
7496	47	2016-05-30 22:20:56.171725	2482
7497	47	2016-05-30 22:20:56.178601	2463
7498	47	2016-05-30 22:20:56.185671	2444
7499	47	2016-05-30 22:20:56.192645	2496
7500	41	2016-05-30 22:22:18.550153	2518
7501	41	2016-05-30 22:22:18.556795	2378
7502	41	2016-05-30 22:22:18.567592	2517
7503	41	2016-05-30 22:22:18.577928	2522
7504	41	2016-05-30 22:22:18.588208	2520
7505	41	2016-05-30 22:22:18.59909	2521
7506	41	2016-05-30 22:22:18.609619	2523
7507	41	2016-05-30 22:22:18.619655	2525
7508	41	2016-05-30 22:22:18.625183	2528
7509	41	2016-05-30 22:22:18.635736	2516
7510	41	2016-05-30 22:22:18.646003	2519
7511	41	2016-05-30 22:22:18.65619	2524
7512	46	2016-05-30 22:22:18.662333	2398
7513	45	2016-05-30 22:22:18.668323	2400
7514	44	2016-05-30 22:22:18.674223	2382
7515	42	2016-05-30 22:22:18.680063	2444
7516	42	2016-05-30 22:22:18.685492	2486
7517	42	2016-05-30 22:22:18.690991	2450
7518	42	2016-05-30 22:22:18.696578	2452
7519	42	2016-05-30 22:22:18.701959	2455
7520	42	2016-05-30 22:22:18.707457	2482
7521	42	2016-05-30 22:22:18.713082	2488
7522	42	2016-05-30 22:22:18.718534	2472
7523	42	2016-05-30 22:22:18.723846	2500
7524	42	2016-05-30 22:22:18.729363	2374
7525	42	2016-05-30 22:22:18.734819	2442
7526	42	2016-05-30 22:22:18.740227	2496
7527	42	2016-05-30 22:22:18.745984	2467
7528	42	2016-05-30 22:22:18.751497	2490
7529	42	2016-05-30 22:22:18.757153	2504
7530	42	2016-05-30 22:22:18.762732	2494
7531	42	2016-05-30 22:22:18.768292	2470
7532	42	2016-05-30 22:22:18.773709	2498
7533	42	2016-05-30 22:22:18.779309	2484
7534	42	2016-05-30 22:22:18.784769	2506
7535	42	2016-05-30 22:22:18.790279	2440
7536	42	2016-05-30 22:22:18.795896	2468
7537	42	2016-05-30 22:22:18.801457	2478
7538	42	2016-05-30 22:22:18.806899	2480
7539	42	2016-05-30 22:22:18.812643	2457
7540	42	2016-05-30 22:22:18.818264	2475
7541	42	2016-05-30 22:22:18.823589	2502
7542	42	2016-05-30 22:22:18.829272	2459
7543	42	2016-05-30 22:22:18.83468	2463
7544	42	2016-05-30 22:22:18.840343	2476
7545	42	2016-05-30 22:22:18.846043	2448
7546	42	2016-05-30 22:22:18.851528	2465
7547	42	2016-05-30 22:22:18.857291	2461
7548	42	2016-05-30 22:22:18.863082	2469
7549	42	2016-05-30 22:22:18.868716	2474
7550	42	2016-05-30 22:22:18.874245	2492
7551	43	2016-05-30 22:22:18.880174	2462
7552	43	2016-05-30 22:22:18.885704	2466
7553	43	2016-05-30 22:22:18.89157	2489
7554	43	2016-05-30 22:22:18.897182	2477
7555	43	2016-05-30 22:22:18.902688	2481
7556	43	2016-05-30 22:22:18.908158	2453
7557	43	2016-05-30 22:22:18.914275	2491
7558	43	2016-05-30 22:22:18.919936	2483
7559	43	2016-05-30 22:22:18.925514	2443
7560	43	2016-05-30 22:22:18.931584	2501
7561	43	2016-05-30 22:22:18.953398	2375
7562	43	2016-05-30 22:22:18.976478	2458
7563	43	2016-05-30 22:22:18.982973	2499
7564	43	2016-05-30 22:22:18.988725	2471
7565	43	2016-05-30 22:22:18.994512	2487
7566	43	2016-05-30 22:22:19.000257	2441
7567	43	2016-05-30 22:22:19.005938	2451
7568	43	2016-05-30 22:22:19.01189	2507
7569	43	2016-05-30 22:22:19.017558	2464
7570	43	2016-05-30 22:22:19.023065	2497
7571	43	2016-05-30 22:22:19.029162	2460
7572	43	2016-05-30 22:22:19.035087	2493
7573	43	2016-05-30 22:22:19.040757	2473
7574	43	2016-05-30 22:22:19.046628	2445
7575	43	2016-05-30 22:22:19.052816	2485
7576	43	2016-05-30 22:22:19.058593	2495
7577	43	2016-05-30 22:22:19.06446	2449
7578	43	2016-05-30 22:22:19.069999	2505
7579	43	2016-05-30 22:22:19.075444	2479
7580	43	2016-05-30 22:22:19.08103	2456
7581	43	2016-05-30 22:22:19.086558	2503
7582	40	2016-05-30 22:22:19.093277	47212
7583	40	2016-05-30 22:22:19.098203	47206
7584	40	2016-05-30 22:22:19.103432	47215
7585	40	2016-05-30 22:22:19.10845	47209
7586	40	2016-05-30 22:22:19.113767	47256
7587	40	2016-05-30 22:22:19.121368	47340
7588	40	2016-05-30 22:22:19.126456	47203
7589	40	2016-05-30 22:22:19.131257	47343
7590	49	2016-05-30 22:22:19.13855	47209
7591	49	2016-05-30 22:22:19.144549	47256
7592	49	2016-05-30 22:22:19.150345	47343
7593	49	2016-05-30 22:22:19.156473	47212
7594	49	2016-05-30 22:22:19.162558	47206
7595	49	2016-05-30 22:22:19.171161	47340
7596	49	2016-05-30 22:22:19.17715	47203
7597	49	2016-05-30 22:22:19.183332	47215
7598	48	2016-05-30 22:22:19.191401	2500
7599	48	2016-05-30 22:22:19.198233	2374
7600	48	2016-05-30 22:22:19.205033	2475
7601	48	2016-05-30 22:22:19.211742	2498
7602	48	2016-05-30 22:22:19.218375	2480
7603	48	2016-05-30 22:22:19.224992	2454
7604	48	2016-05-30 22:22:19.23189	2465
7605	48	2016-05-30 22:22:19.23864	2459
7606	48	2016-05-30 22:22:19.245381	2472
7607	48	2016-05-30 22:22:19.252219	2467
7608	48	2016-05-30 22:22:19.25905	2504
7609	48	2016-05-30 22:22:19.266162	2469
7610	48	2016-05-30 22:22:19.27309	2442
7611	48	2016-05-30 22:22:19.27994	2474
7612	48	2016-05-30 22:22:19.286556	2486
7613	48	2016-05-30 22:22:19.293483	2476
7614	48	2016-05-30 22:22:19.300315	2492
7615	48	2016-05-30 22:22:19.306933	2448
7616	48	2016-05-30 22:22:19.313707	2490
7617	48	2016-05-30 22:22:19.32048	2440
7618	48	2016-05-30 22:22:19.327365	2452
7619	48	2016-05-30 22:22:19.334112	2468
7620	48	2016-05-30 22:22:19.340916	2450
7621	48	2016-05-30 22:22:19.347901	2470
7622	48	2016-05-30 22:22:19.354764	2506
7623	48	2016-05-30 22:22:19.361913	2461
7624	48	2016-05-30 22:22:19.369187	2502
7625	48	2016-05-30 22:22:19.377224	2455
7626	48	2016-05-30 22:22:19.400073	2478
7627	48	2016-05-30 22:22:19.593317	2488
7628	48	2016-05-30 22:22:19.600834	2494
7629	48	2016-05-30 22:22:19.60786	2484
7630	48	2016-05-30 22:22:19.614419	2514
7631	48	2016-05-30 22:22:19.621005	2457
7632	48	2016-05-30 22:22:19.627894	2482
7633	48	2016-05-30 22:22:19.634676	2463
7634	48	2016-05-30 22:22:19.64147	2444
7635	48	2016-05-30 22:22:19.648461	2496
7636	50	2016-05-30 22:22:19.655859	47209
7637	50	2016-05-30 22:22:19.661937	47256
7638	50	2016-05-30 22:22:19.667862	47343
7639	50	2016-05-30 22:22:19.674278	47212
7640	50	2016-05-30 22:22:19.680671	47206
7641	50	2016-05-30 22:22:19.689464	47340
7642	50	2016-05-30 22:22:19.695751	47203
7643	50	2016-05-30 22:22:19.702093	47215
7644	47	2016-05-30 22:22:19.710117	2500
7645	47	2016-05-30 22:22:19.716706	2374
7646	47	2016-05-30 22:22:19.723481	2475
7647	47	2016-05-30 22:22:19.729954	2498
7648	47	2016-05-30 22:22:19.736508	2480
7649	47	2016-05-30 22:22:19.743302	2454
7650	47	2016-05-30 22:22:19.749793	2465
7651	47	2016-05-30 22:22:19.756306	2459
7652	47	2016-05-30 22:22:19.762916	2472
7653	47	2016-05-30 22:22:19.769606	2467
7654	47	2016-05-30 22:22:19.776201	2504
7655	47	2016-05-30 22:22:19.782912	2469
7656	47	2016-05-30 22:22:19.789504	2442
7657	47	2016-05-30 22:22:19.796155	2474
7658	47	2016-05-30 22:22:19.802766	2486
7659	47	2016-05-30 22:22:19.809344	2476
7660	47	2016-05-30 22:22:19.815985	2492
7661	47	2016-05-30 22:22:19.822605	2448
7662	47	2016-05-30 22:22:19.829317	2490
7663	47	2016-05-30 22:22:19.835813	2440
7664	47	2016-05-30 22:22:19.842288	2452
7665	47	2016-05-30 22:22:19.849028	2468
7666	47	2016-05-30 22:22:19.855696	2450
7667	47	2016-05-30 22:22:19.862783	2470
7668	47	2016-05-30 22:22:19.86939	2506
7669	47	2016-05-30 22:22:19.875978	2461
7670	47	2016-05-30 22:22:19.882509	2502
7671	47	2016-05-30 22:22:19.889096	2455
7672	47	2016-05-30 22:22:19.895734	2478
7673	47	2016-05-30 22:22:19.902262	2488
7674	47	2016-05-30 22:22:19.909039	2494
7675	47	2016-05-30 22:22:19.915626	2484
7676	47	2016-05-30 22:22:19.92219	2514
7677	47	2016-05-30 22:22:19.928994	2457
7678	47	2016-05-30 22:22:19.93588	2482
7679	47	2016-05-30 22:22:19.961132	2463
7680	47	2016-05-30 22:22:19.96862	2444
7681	47	2016-05-30 22:22:19.975685	2496
7682	41	2016-05-30 22:23:35.445522	2518
7683	41	2016-05-30 22:23:35.452187	2378
7684	41	2016-05-30 22:23:35.462623	2517
7685	41	2016-05-30 22:23:35.4729	2522
7686	41	2016-05-30 22:23:35.483315	2520
7687	41	2016-05-30 22:23:35.493466	2521
7688	41	2016-05-30 22:23:35.503819	2523
7689	41	2016-05-30 22:23:35.514122	2525
7690	41	2016-05-30 22:23:35.519847	2528
7691	41	2016-05-30 22:23:35.530202	2516
7692	41	2016-05-30 22:23:35.540563	2519
7693	41	2016-05-30 22:23:35.550563	2524
7694	46	2016-05-30 22:23:35.5567	2398
7695	45	2016-05-30 22:23:35.562733	2400
7696	44	2016-05-30 22:23:35.56893	2382
7697	42	2016-05-30 22:23:35.574726	2444
7698	42	2016-05-30 22:23:35.580808	2486
7699	42	2016-05-30 22:23:35.586336	2450
7700	42	2016-05-30 22:23:35.591861	2452
7701	42	2016-05-30 22:23:35.597832	2455
7702	42	2016-05-30 22:23:35.603321	2482
7703	42	2016-05-30 22:23:35.609424	2488
7704	42	2016-05-30 22:23:35.614956	2472
7705	42	2016-05-30 22:23:35.620518	2500
7706	42	2016-05-30 22:23:35.625856	2374
7707	42	2016-05-30 22:23:35.631328	2442
7708	42	2016-05-30 22:23:35.636946	2496
7709	42	2016-05-30 22:23:35.642563	2467
7710	42	2016-05-30 22:23:35.648336	2490
7711	42	2016-05-30 22:23:35.653913	2504
7712	42	2016-05-30 22:23:35.659441	2494
7713	42	2016-05-30 22:23:35.664896	2470
7714	42	2016-05-30 22:23:35.670396	2498
7715	42	2016-05-30 22:23:35.675752	2484
7716	42	2016-05-30 22:23:35.681372	2506
7717	42	2016-05-30 22:23:35.686821	2440
7718	42	2016-05-30 22:23:35.692404	2468
7719	42	2016-05-30 22:23:35.697871	2478
7720	42	2016-05-30 22:23:35.703334	2480
7721	42	2016-05-30 22:23:35.708817	2457
7722	42	2016-05-30 22:23:35.714725	2475
7723	42	2016-05-30 22:23:35.720226	2502
7724	42	2016-05-30 22:23:35.725647	2459
7725	42	2016-05-30 22:23:35.731172	2463
7726	42	2016-05-30 22:23:35.73664	2476
7727	42	2016-05-30 22:23:35.742155	2448
7728	42	2016-05-30 22:23:35.747868	2465
7729	42	2016-05-30 22:23:35.753444	2461
7730	42	2016-05-30 22:23:35.758965	2469
7731	42	2016-05-30 22:23:35.764848	2474
7732	42	2016-05-30 22:23:35.770647	2492
7733	43	2016-05-30 22:23:35.776466	2462
7734	43	2016-05-30 22:23:35.782316	2466
7735	43	2016-05-30 22:23:35.787967	2489
7736	43	2016-05-30 22:23:35.793454	2477
7737	43	2016-05-30 22:23:35.799085	2481
7738	43	2016-05-30 22:23:35.804729	2453
7739	43	2016-05-30 22:23:35.810407	2491
7740	43	2016-05-30 22:23:35.816069	2483
7741	43	2016-05-30 22:23:35.821554	2443
7742	43	2016-05-30 22:23:35.827163	2501
7743	43	2016-05-30 22:23:35.83293	2375
7744	43	2016-05-30 22:23:35.838633	2458
7745	43	2016-05-30 22:23:35.844254	2499
7746	43	2016-05-30 22:23:35.849943	2471
7747	43	2016-05-30 22:23:35.855727	2487
7748	43	2016-05-30 22:23:35.861412	2441
7749	43	2016-05-30 22:23:35.867228	2451
7750	43	2016-05-30 22:23:35.872723	2507
7751	43	2016-05-30 22:23:35.878355	2464
7752	43	2016-05-30 22:23:35.883889	2497
7753	43	2016-05-30 22:23:35.889347	2460
7754	43	2016-05-30 22:23:35.894852	2493
7755	43	2016-05-30 22:23:35.900453	2473
7756	43	2016-05-30 22:23:35.90584	2445
7757	43	2016-05-30 22:23:35.911891	2485
7758	43	2016-05-30 22:23:35.917299	2495
7759	43	2016-05-30 22:23:35.92269	2449
7760	43	2016-05-30 22:23:35.928442	2505
7761	43	2016-05-30 22:23:35.933928	2479
7762	43	2016-05-30 22:23:35.939415	2456
7763	43	2016-05-30 22:23:35.945179	2503
7764	40	2016-05-30 22:23:35.951696	47212
7765	40	2016-05-30 22:23:35.956637	47206
7766	40	2016-05-30 22:23:35.96165	47215
7767	40	2016-05-30 22:23:35.966818	47209
7768	40	2016-05-30 22:23:35.971742	47256
7769	40	2016-05-30 22:23:35.979837	47340
7770	40	2016-05-30 22:23:35.985197	47203
7771	40	2016-05-30 22:23:35.990207	47343
7772	49	2016-05-30 22:23:35.997932	47209
7773	49	2016-05-30 22:23:36.003713	47256
7774	49	2016-05-30 22:23:36.00983	47343
7775	49	2016-05-30 22:23:36.016015	47212
7776	49	2016-05-30 22:23:36.022186	47206
7777	49	2016-05-30 22:23:36.030974	47340
7778	49	2016-05-30 22:23:36.03772	47203
7779	49	2016-05-30 22:23:36.05976	47215
7780	48	2016-05-30 22:23:36.067829	2500
7781	48	2016-05-30 22:23:36.074971	2374
7782	48	2016-05-30 22:23:36.081819	2475
7783	48	2016-05-30 22:23:36.088568	2498
7784	48	2016-05-30 22:23:36.095385	2480
7785	48	2016-05-30 22:23:36.101932	2454
7786	48	2016-05-30 22:23:36.108682	2465
7787	48	2016-05-30 22:23:36.115405	2459
7788	48	2016-05-30 22:23:36.122203	2472
7789	48	2016-05-30 22:23:36.129188	2467
7790	48	2016-05-30 22:23:36.136021	2504
7791	48	2016-05-30 22:23:36.143131	2469
7792	48	2016-05-30 22:23:36.150045	2442
7793	48	2016-05-30 22:23:36.156978	2474
7794	48	2016-05-30 22:23:36.163964	2486
7795	48	2016-05-30 22:23:36.170815	2476
7796	48	2016-05-30 22:23:36.177703	2492
7797	48	2016-05-30 22:23:36.184342	2448
7798	48	2016-05-30 22:23:36.191021	2490
7799	48	2016-05-30 22:23:36.198003	2440
7800	48	2016-05-30 22:23:36.204712	2452
7801	48	2016-05-30 22:23:36.21183	2468
7802	48	2016-05-30 22:23:36.218725	2450
7803	48	2016-05-30 22:23:36.225457	2470
7804	48	2016-05-30 22:23:36.232252	2506
7805	48	2016-05-30 22:23:36.23926	2461
7806	48	2016-05-30 22:23:36.246486	2502
7807	48	2016-05-30 22:23:36.253259	2455
7808	48	2016-05-30 22:23:36.259918	2478
7809	48	2016-05-30 22:23:36.26674	2488
7810	48	2016-05-30 22:23:36.273416	2494
7811	48	2016-05-30 22:23:36.280263	2484
7812	48	2016-05-30 22:23:36.286819	2514
7813	48	2016-05-30 22:23:36.293705	2457
7814	48	2016-05-30 22:23:36.300535	2482
7815	48	2016-05-30 22:23:36.307381	2463
7816	48	2016-05-30 22:23:36.314349	2444
7817	48	2016-05-30 22:23:36.321276	2496
7818	50	2016-05-30 22:23:36.328797	47209
7819	50	2016-05-30 22:23:36.334945	47256
7820	50	2016-05-30 22:23:36.340957	47343
7821	50	2016-05-30 22:23:36.347634	47212
7822	50	2016-05-30 22:23:36.354082	47206
7823	50	2016-05-30 22:23:36.363326	47340
7824	50	2016-05-30 22:23:36.369499	47203
7825	50	2016-05-30 22:23:36.375876	47215
7826	47	2016-05-30 22:23:36.384234	2500
7827	47	2016-05-30 22:23:36.390942	2374
7828	47	2016-05-30 22:23:36.397809	2475
7829	47	2016-05-30 22:23:36.404285	2498
7830	47	2016-05-30 22:23:36.410956	2480
7831	47	2016-05-30 22:23:36.417529	2454
7832	47	2016-05-30 22:23:36.424156	2465
7833	47	2016-05-30 22:23:36.431401	2459
7834	47	2016-05-30 22:23:36.437976	2472
7835	47	2016-05-30 22:23:36.444686	2467
7836	47	2016-05-30 22:23:36.451076	2504
7837	47	2016-05-30 22:23:36.45799	2469
7838	47	2016-05-30 22:23:36.464777	2442
7839	47	2016-05-30 22:23:36.471502	2474
7840	47	2016-05-30 22:23:36.478197	2486
7841	47	2016-05-30 22:23:36.484725	2476
7842	47	2016-05-30 22:23:36.491121	2492
7843	47	2016-05-30 22:23:36.497736	2448
7844	47	2016-05-30 22:23:36.504272	2490
7845	47	2016-05-30 22:23:36.511164	2440
7846	47	2016-05-30 22:23:36.51775	2452
7847	47	2016-05-30 22:23:36.524367	2468
7848	47	2016-05-30 22:23:36.531022	2450
7849	47	2016-05-30 22:23:36.537699	2470
7850	47	2016-05-30 22:23:36.544186	2506
7851	47	2016-05-30 22:23:36.550877	2461
7852	47	2016-05-30 22:23:36.557427	2502
7853	47	2016-05-30 22:23:36.563939	2455
7854	47	2016-05-30 22:23:36.570611	2478
7855	47	2016-05-30 22:23:36.57758	2488
7856	47	2016-05-30 22:23:36.584065	2494
7857	47	2016-05-30 22:23:36.590564	2484
7858	47	2016-05-30 22:23:36.597086	2514
7859	47	2016-05-30 22:23:36.603567	2457
7860	47	2016-05-30 22:23:36.610247	2482
7861	47	2016-05-30 22:23:36.616838	2463
7862	47	2016-05-30 22:23:36.623763	2444
7863	47	2016-05-30 22:23:36.630449	2496
7864	41	2016-05-30 22:24:53.941771	2518
7865	41	2016-05-30 22:24:53.948123	2378
7866	41	2016-05-30 22:24:53.958497	2517
7867	41	2016-05-30 22:24:53.968564	2522
7868	41	2016-05-30 22:24:53.979537	2520
7869	41	2016-05-30 22:24:53.989781	2521
7870	41	2016-05-30 22:24:54.000222	2523
7871	41	2016-05-30 22:24:54.010564	2525
7872	41	2016-05-30 22:24:54.016132	2528
7873	41	2016-05-30 22:24:54.026198	2516
7874	41	2016-05-30 22:24:54.036561	2519
7875	41	2016-05-30 22:24:54.047156	2524
7876	46	2016-05-30 22:24:54.053383	2398
7877	45	2016-05-30 22:24:54.059645	2400
7878	44	2016-05-30 22:24:54.066057	2382
7879	42	2016-05-30 22:24:54.07208	2444
7880	42	2016-05-30 22:24:54.077967	2486
7881	42	2016-05-30 22:24:54.08374	2450
7882	42	2016-05-30 22:24:54.089815	2452
7883	42	2016-05-30 22:24:54.09567	2455
7884	42	2016-05-30 22:24:54.101298	2482
7885	42	2016-05-30 22:24:54.107042	2488
7886	42	2016-05-30 22:24:54.112742	2472
7887	42	2016-05-30 22:24:54.118583	2500
7888	42	2016-05-30 22:24:54.124338	2374
7889	42	2016-05-30 22:24:54.130058	2442
7890	42	2016-05-30 22:24:54.135659	2496
7891	42	2016-05-30 22:24:54.141656	2467
7892	42	2016-05-30 22:24:54.147323	2490
7893	42	2016-05-30 22:24:54.153145	2504
7894	42	2016-05-30 22:24:54.158749	2494
7895	42	2016-05-30 22:24:54.164353	2470
7896	42	2016-05-30 22:24:54.169888	2498
7897	42	2016-05-30 22:24:54.175428	2484
7898	42	2016-05-30 22:24:54.18116	2506
7899	42	2016-05-30 22:24:54.186743	2440
7900	42	2016-05-30 22:24:54.192841	2468
7901	42	2016-05-30 22:24:54.198326	2478
7902	42	2016-05-30 22:24:54.203966	2480
7903	42	2016-05-30 22:24:54.209638	2457
7904	42	2016-05-30 22:24:54.215304	2475
7905	42	2016-05-30 22:24:54.22085	2502
7906	42	2016-05-30 22:24:54.226508	2459
7907	42	2016-05-30 22:24:54.23217	2463
7908	42	2016-05-30 22:24:54.237724	2476
7909	42	2016-05-30 22:24:54.243291	2448
7910	42	2016-05-30 22:24:54.249201	2465
7911	42	2016-05-30 22:24:54.254664	2461
7912	42	2016-05-30 22:24:54.260245	2469
7913	42	2016-05-30 22:24:54.266004	2474
7914	42	2016-05-30 22:24:54.271561	2492
7915	43	2016-05-30 22:24:54.277661	2462
7916	43	2016-05-30 22:24:54.283125	2466
7917	43	2016-05-30 22:24:54.288528	2489
7918	43	2016-05-30 22:24:54.294244	2477
7919	43	2016-05-30 22:24:54.29974	2481
7920	43	2016-05-30 22:24:54.305466	2453
7921	43	2016-05-30 22:24:54.311048	2491
7922	43	2016-05-30 22:24:54.316647	2483
7923	43	2016-05-30 22:24:54.322249	2443
7924	43	2016-05-30 22:24:54.327961	2501
7925	43	2016-05-30 22:24:54.333519	2375
7926	43	2016-05-30 22:24:54.339075	2458
7927	43	2016-05-30 22:24:54.344613	2499
7928	43	2016-05-30 22:24:54.35032	2471
7929	43	2016-05-30 22:24:54.355801	2487
7930	43	2016-05-30 22:24:54.361415	2441
7931	43	2016-05-30 22:24:54.366956	2451
7932	43	2016-05-30 22:24:54.372387	2507
7933	43	2016-05-30 22:24:54.378408	2464
7934	43	2016-05-30 22:24:54.383917	2497
7935	43	2016-05-30 22:24:54.389455	2460
7936	43	2016-05-30 22:24:54.395263	2493
7937	43	2016-05-30 22:24:54.400963	2473
7938	43	2016-05-30 22:24:54.406482	2445
7939	43	2016-05-30 22:24:54.411997	2485
7940	43	2016-05-30 22:24:54.417524	2495
7941	43	2016-05-30 22:24:54.423443	2449
7942	43	2016-05-30 22:24:54.429696	2505
7943	43	2016-05-30 22:24:54.435198	2479
7944	43	2016-05-30 22:24:54.440944	2456
7945	43	2016-05-30 22:24:54.446488	2503
7946	40	2016-05-30 22:24:54.45317	47212
7947	40	2016-05-30 22:24:54.45839	47206
7948	40	2016-05-30 22:24:54.463332	47215
7949	40	2016-05-30 22:24:54.46842	47209
7950	40	2016-05-30 22:24:54.473509	47256
7951	40	2016-05-30 22:24:54.481347	47340
7952	40	2016-05-30 22:24:54.486535	47203
7953	40	2016-05-30 22:24:54.491638	47343
7954	49	2016-05-30 22:24:54.499547	47209
7955	49	2016-05-30 22:24:54.505474	47256
7956	49	2016-05-30 22:24:54.511417	47343
7957	49	2016-05-30 22:24:54.517681	47212
7958	49	2016-05-30 22:24:54.523783	47206
7959	49	2016-05-30 22:24:54.53244	47340
7960	49	2016-05-30 22:24:54.538726	47203
7961	49	2016-05-30 22:24:54.54498	47215
7962	48	2016-05-30 22:24:54.553288	2500
7963	48	2016-05-30 22:24:54.560211	2374
7964	48	2016-05-30 22:24:54.567097	2475
7965	48	2016-05-30 22:24:54.573947	2498
7966	48	2016-05-30 22:24:54.580795	2480
7967	48	2016-05-30 22:24:54.587468	2454
7968	48	2016-05-30 22:24:54.594636	2465
7969	48	2016-05-30 22:24:54.601414	2459
7970	48	2016-05-30 22:24:54.608249	2472
7971	48	2016-05-30 22:24:54.615224	2467
7972	48	2016-05-30 22:24:54.622007	2504
7973	48	2016-05-30 22:24:54.628916	2469
7974	48	2016-05-30 22:24:54.63571	2442
7975	48	2016-05-30 22:24:54.642581	2474
7976	48	2016-05-30 22:24:54.64929	2486
7977	48	2016-05-30 22:24:54.656034	2476
7978	48	2016-05-30 22:24:54.662796	2492
7979	48	2016-05-30 22:24:54.669746	2448
7980	48	2016-05-30 22:24:54.676438	2490
7981	48	2016-05-30 22:24:54.6832	2440
7982	48	2016-05-30 22:24:54.690262	2452
7983	48	2016-05-30 22:24:54.697151	2468
7984	48	2016-05-30 22:24:54.704033	2450
7985	48	2016-05-30 22:24:54.710848	2470
7986	48	2016-05-30 22:24:54.717663	2506
7987	48	2016-05-30 22:24:54.724749	2461
7988	48	2016-05-30 22:24:54.731548	2502
7989	48	2016-05-30 22:24:54.738501	2455
7990	48	2016-05-30 22:24:54.745417	2478
7991	48	2016-05-30 22:24:54.752341	2488
7992	48	2016-05-30 22:24:54.759317	2494
7993	48	2016-05-30 22:24:54.766232	2484
7994	48	2016-05-30 22:24:54.772996	2514
7995	48	2016-05-30 22:24:54.779797	2457
7996	48	2016-05-30 22:24:54.786515	2482
7997	48	2016-05-30 22:24:54.793529	2463
7998	48	2016-05-30 22:24:54.800605	2444
7999	48	2016-05-30 22:24:54.807549	2496
8000	50	2016-05-30 22:24:54.815114	47209
8001	50	2016-05-30 22:24:54.821239	47256
8002	50	2016-05-30 22:24:54.827533	47343
8003	50	2016-05-30 22:24:54.83381	47212
8004	50	2016-05-30 22:24:54.840216	47206
8005	50	2016-05-30 22:24:54.849412	47340
8006	50	2016-05-30 22:24:54.856007	47203
8007	50	2016-05-30 22:24:54.862403	47215
8008	47	2016-05-30 22:24:54.870623	2500
8009	47	2016-05-30 22:24:54.877359	2374
8010	47	2016-05-30 22:24:54.884017	2475
8011	47	2016-05-30 22:24:54.890769	2498
8012	47	2016-05-30 22:24:54.897392	2480
8013	47	2016-05-30 22:24:54.9039	2454
8014	47	2016-05-30 22:24:54.910906	2465
8015	47	2016-05-30 22:24:54.917682	2459
8016	47	2016-05-30 22:24:54.924508	2472
8017	47	2016-05-30 22:24:54.931086	2467
8018	47	2016-05-30 22:24:54.937756	2504
8019	47	2016-05-30 22:24:54.944366	2469
8020	47	2016-05-30 22:24:54.951532	2442
8021	47	2016-05-30 22:24:54.95843	2474
8022	47	2016-05-30 22:24:54.965197	2486
8023	47	2016-05-30 22:24:54.972077	2476
8024	47	2016-05-30 22:24:54.978602	2492
8025	47	2016-05-30 22:24:54.98533	2448
8026	47	2016-05-30 22:24:54.992179	2490
8027	47	2016-05-30 22:24:54.9989	2440
8028	47	2016-05-30 22:24:55.005534	2452
8029	47	2016-05-30 22:24:55.012404	2468
8030	47	2016-05-30 22:24:55.019166	2450
8031	47	2016-05-30 22:24:55.025874	2470
8032	47	2016-05-30 22:24:55.03255	2506
8033	47	2016-05-30 22:24:55.039433	2461
8034	47	2016-05-30 22:24:55.046594	2502
8035	47	2016-05-30 22:24:55.054956	2455
8036	47	2016-05-30 22:24:55.063051	2478
8037	47	2016-05-30 22:24:55.069878	2488
8038	47	2016-05-30 22:24:55.076704	2494
8039	47	2016-05-30 22:24:55.083311	2484
8040	47	2016-05-30 22:24:55.089975	2514
8041	47	2016-05-30 22:24:55.096861	2457
8042	47	2016-05-30 22:24:55.103575	2482
8043	47	2016-05-30 22:24:55.110405	2463
8044	47	2016-05-30 22:24:55.117155	2444
8045	47	2016-05-30 22:24:55.123866	2496
8046	41	2016-05-30 22:30:34.165945	2518
8047	41	2016-05-30 22:30:34.172476	2378
8048	41	2016-05-30 22:30:34.183106	2517
8049	41	2016-05-30 22:30:34.193182	2522
8050	41	2016-05-30 22:30:34.203488	2520
8051	41	2016-05-30 22:30:34.213908	2521
8052	41	2016-05-30 22:30:34.224113	2523
8053	41	2016-05-30 22:30:34.234619	2525
8054	41	2016-05-30 22:30:34.240155	2528
8055	41	2016-05-30 22:30:34.25028	2516
8056	41	2016-05-30 22:30:34.260552	2519
8057	41	2016-05-30 22:30:34.271034	2524
8058	46	2016-05-30 22:30:34.277413	2398
8059	45	2016-05-30 22:30:34.283469	2400
8060	44	2016-05-30 22:30:34.289506	2382
8061	42	2016-05-30 22:30:34.295258	2444
8062	42	2016-05-30 22:30:34.300743	2486
8063	42	2016-05-30 22:30:34.306334	2450
8064	42	2016-05-30 22:30:34.311983	2452
8065	42	2016-05-30 22:30:34.317654	2455
8066	42	2016-05-30 22:30:34.323897	2482
8067	42	2016-05-30 22:30:34.329467	2488
8068	42	2016-05-30 22:30:34.335094	2472
8069	42	2016-05-30 22:30:34.340761	2500
8070	42	2016-05-30 22:30:34.346734	2374
8071	42	2016-05-30 22:30:34.352543	2442
8072	42	2016-05-30 22:30:34.358075	2496
8073	42	2016-05-30 22:30:34.363651	2467
8074	42	2016-05-30 22:30:34.369716	2490
8075	42	2016-05-30 22:30:34.375524	2504
8076	42	2016-05-30 22:30:34.381651	2494
8077	42	2016-05-30 22:30:34.387692	2470
8078	42	2016-05-30 22:30:34.393549	2498
8079	42	2016-05-30 22:30:34.399346	2484
8080	42	2016-05-30 22:30:34.405229	2506
8081	42	2016-05-30 22:30:34.411313	2440
8082	42	2016-05-30 22:30:34.417513	2468
8083	42	2016-05-30 22:30:34.423514	2478
8084	42	2016-05-30 22:30:34.42932	2480
8085	42	2016-05-30 22:30:34.435683	2457
8086	42	2016-05-30 22:30:34.441672	2475
8087	42	2016-05-30 22:30:34.447379	2502
8088	42	2016-05-30 22:30:34.453244	2459
8089	42	2016-05-30 22:30:34.459215	2463
8090	42	2016-05-30 22:30:34.465095	2476
8091	42	2016-05-30 22:30:34.47129	2448
8092	42	2016-05-30 22:30:34.477041	2465
8093	42	2016-05-30 22:30:34.482943	2461
8094	42	2016-05-30 22:30:34.489237	2469
8095	42	2016-05-30 22:30:34.495633	2474
8096	42	2016-05-30 22:30:34.501226	2492
8097	43	2016-05-30 22:30:34.507369	2462
8098	43	2016-05-30 22:30:34.513251	2466
8099	43	2016-05-30 22:30:34.519022	2489
8100	43	2016-05-30 22:30:34.524825	2477
8101	43	2016-05-30 22:30:34.530805	2481
8102	43	2016-05-30 22:30:34.537036	2453
8103	43	2016-05-30 22:30:34.542945	2491
8104	43	2016-05-30 22:30:34.548676	2483
8105	43	2016-05-30 22:30:34.554325	2443
8106	43	2016-05-30 22:30:34.559947	2501
8107	43	2016-05-30 22:30:34.56546	2375
8108	43	2016-05-30 22:30:34.570791	2458
8109	43	2016-05-30 22:30:34.576499	2499
8110	43	2016-05-30 22:30:34.582002	2471
8111	43	2016-05-30 22:30:34.587616	2487
8112	43	2016-05-30 22:30:34.593231	2441
8113	43	2016-05-30 22:30:34.598784	2451
8114	43	2016-05-30 22:30:34.604256	2507
8115	43	2016-05-30 22:30:34.610049	2464
8116	43	2016-05-30 22:30:34.615674	2497
8117	43	2016-05-30 22:30:34.621293	2460
8118	43	2016-05-30 22:30:34.62684	2493
8119	43	2016-05-30 22:30:34.632404	2473
8120	43	2016-05-30 22:30:34.638104	2445
8121	43	2016-05-30 22:30:34.64381	2485
8122	43	2016-05-30 22:30:34.649694	2495
8123	43	2016-05-30 22:30:34.655329	2449
8124	43	2016-05-30 22:30:34.661166	2505
8125	43	2016-05-30 22:30:34.683859	2479
8126	43	2016-05-30 22:30:34.706436	2456
8127	43	2016-05-30 22:30:34.71291	2503
8128	40	2016-05-30 22:30:34.719895	47212
8129	40	2016-05-30 22:30:34.725022	47206
8130	40	2016-05-30 22:30:34.730305	47215
8131	40	2016-05-30 22:30:34.735409	47209
8132	40	2016-05-30 22:30:34.740429	47256
8133	40	2016-05-30 22:30:34.748286	47340
8134	40	2016-05-30 22:30:34.75325	47203
8135	40	2016-05-30 22:30:34.758403	47343
8136	49	2016-05-30 22:30:34.766373	47209
8137	49	2016-05-30 22:30:34.772409	47256
8138	49	2016-05-30 22:30:34.778337	47343
8139	49	2016-05-30 22:30:34.784606	47212
8140	49	2016-05-30 22:30:34.790711	47206
8141	49	2016-05-30 22:30:34.799667	47340
8142	49	2016-05-30 22:30:34.80593	47203
8143	49	2016-05-30 22:30:34.812246	47215
8144	48	2016-05-30 22:30:34.820556	2500
8145	48	2016-05-30 22:30:34.827558	2374
8146	48	2016-05-30 22:30:34.834419	2475
8147	48	2016-05-30 22:30:34.841094	2498
8148	48	2016-05-30 22:30:34.847935	2480
8149	48	2016-05-30 22:30:34.854475	2454
8150	48	2016-05-30 22:30:34.861645	2465
8151	48	2016-05-30 22:30:34.868585	2459
8152	48	2016-05-30 22:30:34.876232	2472
8153	48	2016-05-30 22:30:34.899454	2467
8154	48	2016-05-30 22:30:34.906378	2504
8155	48	2016-05-30 22:30:34.913611	2469
8156	48	2016-05-30 22:30:34.920346	2442
8157	48	2016-05-30 22:30:34.928414	2474
8158	48	2016-05-30 22:30:34.935221	2486
8159	48	2016-05-30 22:30:34.942065	2476
8160	48	2016-05-30 22:30:34.949088	2492
8161	48	2016-05-30 22:30:34.955916	2448
8162	48	2016-05-30 22:30:34.96297	2490
8163	48	2016-05-30 22:30:34.969906	2440
8164	48	2016-05-30 22:30:34.976826	2452
8165	48	2016-05-30 22:30:34.984051	2468
8166	48	2016-05-30 22:30:34.990942	2450
8167	48	2016-05-30 22:30:34.997994	2470
8168	48	2016-05-30 22:30:35.005145	2506
8169	48	2016-05-30 22:30:35.012213	2461
8170	48	2016-05-30 22:30:35.018971	2502
8171	48	2016-05-30 22:30:35.025919	2455
8172	48	2016-05-30 22:30:35.03267	2478
8173	48	2016-05-30 22:30:35.039596	2488
8174	48	2016-05-30 22:30:35.046605	2494
8175	48	2016-05-30 22:30:35.053306	2484
8176	48	2016-05-30 22:30:35.060115	2514
8177	48	2016-05-30 22:30:35.06744	2457
8178	48	2016-05-30 22:30:35.074405	2482
8179	48	2016-05-30 22:30:35.081603	2463
8180	48	2016-05-30 22:30:35.088509	2444
8181	48	2016-05-30 22:30:35.095442	2496
8182	50	2016-05-30 22:30:35.103385	47209
8183	50	2016-05-30 22:30:35.109905	47256
8184	50	2016-05-30 22:30:35.116135	47343
8185	50	2016-05-30 22:30:35.122782	47212
8186	50	2016-05-30 22:30:35.130572	47206
8187	50	2016-05-30 22:30:35.140024	47340
8188	50	2016-05-30 22:30:35.147002	47203
8189	50	2016-05-30 22:30:35.153918	47215
8190	47	2016-05-30 22:30:35.162406	2500
8191	47	2016-05-30 22:30:35.169661	2374
8192	47	2016-05-30 22:30:35.176716	2475
8193	47	2016-05-30 22:30:35.183833	2498
8194	47	2016-05-30 22:30:35.190883	2480
8195	47	2016-05-30 22:30:35.198049	2454
8196	47	2016-05-30 22:30:35.20521	2465
8197	47	2016-05-30 22:30:35.212195	2459
8198	47	2016-05-30 22:30:35.21939	2472
8199	47	2016-05-30 22:30:35.226474	2467
8200	47	2016-05-30 22:30:35.233814	2504
8201	47	2016-05-30 22:30:35.240772	2469
8202	47	2016-05-30 22:30:35.248268	2442
8203	47	2016-05-30 22:30:35.255199	2474
8204	47	2016-05-30 22:30:35.262187	2486
8205	47	2016-05-30 22:30:35.269548	2476
8206	47	2016-05-30 22:30:35.276878	2492
8207	47	2016-05-30 22:30:35.284086	2448
8208	47	2016-05-30 22:30:35.291163	2490
8209	47	2016-05-30 22:30:35.298087	2440
8210	47	2016-05-30 22:30:35.305189	2452
8211	47	2016-05-30 22:30:35.31214	2468
8212	47	2016-05-30 22:30:35.319587	2450
8213	47	2016-05-30 22:30:35.326878	2470
8214	47	2016-05-30 22:30:35.333992	2506
8215	47	2016-05-30 22:30:35.340998	2461
8216	47	2016-05-30 22:30:35.347756	2502
8217	47	2016-05-30 22:30:35.354364	2455
8218	47	2016-05-30 22:30:35.361239	2478
8219	47	2016-05-30 22:30:35.367985	2488
8220	47	2016-05-30 22:30:35.374871	2494
8221	47	2016-05-30 22:30:35.381626	2484
8222	47	2016-05-30 22:30:35.388218	2514
8223	47	2016-05-30 22:30:35.395413	2457
8224	47	2016-05-30 22:30:35.402191	2482
8225	47	2016-05-30 22:30:35.409083	2463
8226	47	2016-05-30 22:30:35.415786	2444
8227	47	2016-05-30 22:30:35.4225	2496
8228	41	2016-05-30 22:32:23.420281	2518
8229	41	2016-05-30 22:32:23.427218	2378
8230	41	2016-05-30 22:32:23.43747	2517
8231	41	2016-05-30 22:32:23.447791	2522
8232	41	2016-05-30 22:32:23.458247	2520
8233	41	2016-05-30 22:32:23.468744	2521
8234	41	2016-05-30 22:32:23.479214	2523
8235	41	2016-05-30 22:32:23.490099	2525
8236	41	2016-05-30 22:32:23.495768	2528
8237	41	2016-05-30 22:32:23.506931	2516
8238	41	2016-05-30 22:32:23.517667	2519
8239	41	2016-05-30 22:32:23.528585	2524
8240	46	2016-05-30 22:32:23.535174	2398
8241	45	2016-05-30 22:32:23.541444	2400
8242	44	2016-05-30 22:32:23.547443	2382
8243	42	2016-05-30 22:32:23.55363	2444
8244	42	2016-05-30 22:32:23.559373	2486
8245	42	2016-05-30 22:32:23.565035	2450
8246	42	2016-05-30 22:32:23.57141	2452
8247	42	2016-05-30 22:32:23.577238	2455
8248	42	2016-05-30 22:32:23.582859	2482
8249	42	2016-05-30 22:32:23.588692	2488
8250	42	2016-05-30 22:32:23.59427	2472
8251	42	2016-05-30 22:32:23.600033	2500
8252	42	2016-05-30 22:32:23.605948	2374
8253	42	2016-05-30 22:32:23.611607	2442
8254	42	2016-05-30 22:32:23.617262	2496
8255	42	2016-05-30 22:32:23.623353	2467
8256	42	2016-05-30 22:32:23.629044	2490
8257	42	2016-05-30 22:32:23.635173	2504
8258	42	2016-05-30 22:32:23.641053	2494
8259	42	2016-05-30 22:32:23.646677	2470
8260	42	2016-05-30 22:32:23.652901	2498
8261	42	2016-05-30 22:32:23.658871	2484
8262	42	2016-05-30 22:32:23.664752	2506
8263	42	2016-05-30 22:32:23.670921	2440
8264	42	2016-05-30 22:32:23.677036	2468
8265	42	2016-05-30 22:32:23.682787	2478
8266	42	2016-05-30 22:32:23.68876	2480
8267	42	2016-05-30 22:32:23.69435	2457
8268	42	2016-05-30 22:32:23.700359	2475
8269	42	2016-05-30 22:32:23.706196	2502
8270	42	2016-05-30 22:32:23.711997	2459
8271	42	2016-05-30 22:32:23.717939	2463
8272	42	2016-05-30 22:32:23.723801	2476
8273	42	2016-05-30 22:32:23.72941	2448
8274	42	2016-05-30 22:32:23.735186	2465
8275	42	2016-05-30 22:32:23.741268	2461
8276	42	2016-05-30 22:32:23.74701	2469
8277	42	2016-05-30 22:32:23.752771	2474
8278	42	2016-05-30 22:32:23.758758	2492
8279	43	2016-05-30 22:32:23.764669	2462
8280	43	2016-05-30 22:32:23.770333	2466
8281	43	2016-05-30 22:32:23.776485	2489
8282	43	2016-05-30 22:32:23.782276	2477
8283	43	2016-05-30 22:32:23.788727	2481
8284	43	2016-05-30 22:32:23.794581	2453
8285	43	2016-05-30 22:32:23.800464	2491
8286	43	2016-05-30 22:32:23.806259	2483
8287	43	2016-05-30 22:32:23.812317	2443
8288	43	2016-05-30 22:32:23.834057	2501
8289	43	2016-05-30 22:32:23.854933	2375
8290	43	2016-05-30 22:32:23.8615	2458
8291	43	2016-05-30 22:32:23.867455	2499
8292	43	2016-05-30 22:32:23.873393	2471
8293	43	2016-05-30 22:32:23.879769	2487
8294	43	2016-05-30 22:32:23.886084	2441
8295	43	2016-05-30 22:32:23.892154	2451
8296	43	2016-05-30 22:32:23.89793	2507
8297	43	2016-05-30 22:32:23.903971	2464
8298	43	2016-05-30 22:32:23.909846	2497
8299	43	2016-05-30 22:32:23.915556	2460
8300	43	2016-05-30 22:32:23.921836	2493
8301	43	2016-05-30 22:32:23.928421	2473
8302	43	2016-05-30 22:32:23.934167	2445
8303	43	2016-05-30 22:32:23.939871	2485
8304	43	2016-05-30 22:32:23.945712	2495
8305	43	2016-05-30 22:32:23.951409	2449
8306	43	2016-05-30 22:32:23.95709	2505
8307	43	2016-05-30 22:32:23.963038	2479
8308	43	2016-05-30 22:32:23.968828	2456
8309	43	2016-05-30 22:32:23.97469	2503
8310	40	2016-05-30 22:32:23.981481	47212
8311	40	2016-05-30 22:32:23.986903	47206
8312	40	2016-05-30 22:32:23.992357	47215
8313	40	2016-05-30 22:32:23.997556	47209
8314	40	2016-05-30 22:32:24.002711	47256
8315	40	2016-05-30 22:32:24.010965	47340
8316	40	2016-05-30 22:32:24.01624	47203
8317	40	2016-05-30 22:32:24.021549	47343
8318	49	2016-05-30 22:32:24.029552	47209
8319	49	2016-05-30 22:32:24.035679	47256
8320	49	2016-05-30 22:32:24.041861	47343
8321	49	2016-05-30 22:32:24.048412	47212
8322	49	2016-05-30 22:32:24.05478	47206
8323	49	2016-05-30 22:32:24.064062	47340
8324	49	2016-05-30 22:32:24.070366	47203
8325	49	2016-05-30 22:32:24.077093	47215
8326	48	2016-05-30 22:32:24.085511	2500
8327	48	2016-05-30 22:32:24.092456	2374
8328	48	2016-05-30 22:32:24.099682	2475
8329	48	2016-05-30 22:32:24.106594	2498
8330	48	2016-05-30 22:32:24.113446	2480
8331	48	2016-05-30 22:32:24.12081	2454
8332	48	2016-05-30 22:32:24.12806	2465
8333	48	2016-05-30 22:32:24.135245	2459
8334	48	2016-05-30 22:32:24.14224	2472
8335	48	2016-05-30 22:32:24.149163	2467
8336	48	2016-05-30 22:32:24.156163	2504
8337	48	2016-05-30 22:32:24.16304	2469
8338	48	2016-05-30 22:32:24.170136	2442
8339	48	2016-05-30 22:32:24.177018	2474
8340	48	2016-05-30 22:32:24.18389	2486
8341	48	2016-05-30 22:32:24.191053	2476
8342	48	2016-05-30 22:32:24.197904	2492
8343	48	2016-05-30 22:32:24.204824	2448
8344	48	2016-05-30 22:32:24.211726	2490
8345	48	2016-05-30 22:32:24.218578	2440
8346	48	2016-05-30 22:32:24.225555	2452
8347	48	2016-05-30 22:32:24.232784	2468
8348	48	2016-05-30 22:32:24.239797	2450
8349	48	2016-05-30 22:32:24.24686	2470
8350	48	2016-05-30 22:32:24.253896	2506
8351	48	2016-05-30 22:32:24.260937	2461
8352	48	2016-05-30 22:32:24.267965	2502
8353	48	2016-05-30 22:32:24.275038	2455
8354	48	2016-05-30 22:32:24.282235	2478
8355	48	2016-05-30 22:32:24.289099	2488
8356	48	2016-05-30 22:32:24.295857	2494
8357	48	2016-05-30 22:32:24.303204	2484
8358	48	2016-05-30 22:32:24.309865	2514
8359	48	2016-05-30 22:32:24.317228	2457
8360	48	2016-05-30 22:32:24.324225	2482
8361	48	2016-05-30 22:32:24.331345	2463
8362	48	2016-05-30 22:32:24.338354	2444
8363	48	2016-05-30 22:32:24.345211	2496
8364	50	2016-05-30 22:32:24.353122	47209
8365	50	2016-05-30 22:32:24.3596	47256
8366	50	2016-05-30 22:32:24.365873	47343
8367	50	2016-05-30 22:32:24.372281	47212
8368	50	2016-05-30 22:32:24.379013	47206
8369	50	2016-05-30 22:32:24.388442	47340
8370	50	2016-05-30 22:32:24.394968	47203
8371	50	2016-05-30 22:32:24.401619	47215
8372	47	2016-05-30 22:32:24.409703	2500
8373	47	2016-05-30 22:32:24.416611	2374
8374	47	2016-05-30 22:32:24.42356	2475
8375	47	2016-05-30 22:32:24.430225	2498
8376	47	2016-05-30 22:32:24.437054	2480
8377	47	2016-05-30 22:32:24.44383	2454
8378	47	2016-05-30 22:32:24.450491	2465
8379	47	2016-05-30 22:32:24.457214	2459
8380	47	2016-05-30 22:32:24.463995	2472
8381	47	2016-05-30 22:32:24.47088	2467
8382	47	2016-05-30 22:32:24.477613	2504
8383	47	2016-05-30 22:32:24.484471	2469
8384	47	2016-05-30 22:32:24.491113	2442
8385	47	2016-05-30 22:32:24.497966	2474
8386	47	2016-05-30 22:32:24.505222	2486
8387	47	2016-05-30 22:32:24.511838	2476
8388	47	2016-05-30 22:32:24.518472	2492
8389	47	2016-05-30 22:32:24.525385	2448
8390	47	2016-05-30 22:32:24.53239	2490
8391	47	2016-05-30 22:32:24.539208	2440
8392	47	2016-05-30 22:32:24.545972	2452
8393	47	2016-05-30 22:32:24.552745	2468
8394	47	2016-05-30 22:32:24.5594	2450
8395	47	2016-05-30 22:32:24.566213	2470
8396	47	2016-05-30 22:32:24.572979	2506
8397	47	2016-05-30 22:32:24.580016	2461
8398	47	2016-05-30 22:32:24.586693	2502
8399	47	2016-05-30 22:32:24.593523	2455
8400	47	2016-05-30 22:32:24.600271	2478
8401	47	2016-05-30 22:32:24.606955	2488
8402	47	2016-05-30 22:32:24.614374	2494
8403	47	2016-05-30 22:32:24.621354	2484
8404	47	2016-05-30 22:32:24.627981	2514
8405	47	2016-05-30 22:32:24.634807	2457
8406	47	2016-05-30 22:32:24.641454	2482
8407	47	2016-05-30 22:32:24.64849	2463
8408	47	2016-05-30 22:32:24.65552	2444
8409	47	2016-05-30 22:32:24.662242	2496
8410	41	2016-05-30 22:34:38.114373	2518
8411	41	2016-05-30 22:34:38.120861	2378
8412	41	2016-05-30 22:34:38.131378	2517
8413	41	2016-05-30 22:34:38.141526	2522
8414	41	2016-05-30 22:34:38.152074	2520
8415	41	2016-05-30 22:34:38.163249	2521
8416	41	2016-05-30 22:34:38.173505	2523
8417	41	2016-05-30 22:34:38.183607	2525
8418	41	2016-05-30 22:34:38.189098	2528
8419	41	2016-05-30 22:34:38.199138	2516
8420	41	2016-05-30 22:34:38.209414	2519
8421	41	2016-05-30 22:34:38.219545	2524
8422	46	2016-05-30 22:34:38.225785	2398
8423	45	2016-05-30 22:34:38.232609	2400
8424	44	2016-05-30 22:34:38.238676	2382
8425	42	2016-05-30 22:34:38.244573	2444
8426	42	2016-05-30 22:34:38.250252	2486
8427	42	2016-05-30 22:34:38.255888	2450
8428	42	2016-05-30 22:34:38.261488	2452
8429	42	2016-05-30 22:34:38.267411	2455
8430	42	2016-05-30 22:34:38.273034	2482
8431	42	2016-05-30 22:34:38.278805	2488
8432	42	2016-05-30 22:34:38.284607	2472
8433	42	2016-05-30 22:34:38.290063	2500
8434	42	2016-05-30 22:34:38.295545	2374
8435	42	2016-05-30 22:34:38.300956	2442
8436	42	2016-05-30 22:34:38.306466	2496
8437	42	2016-05-30 22:34:38.312202	2467
8438	42	2016-05-30 22:34:38.31848	2490
8439	42	2016-05-30 22:34:38.323982	2504
8440	42	2016-05-30 22:34:38.329585	2494
8441	42	2016-05-30 22:34:38.335202	2470
8442	42	2016-05-30 22:34:38.340869	2498
8443	42	2016-05-30 22:34:38.346565	2484
8444	42	2016-05-30 22:34:38.352093	2506
8445	42	2016-05-30 22:34:38.357557	2440
8446	42	2016-05-30 22:34:38.363151	2468
8447	42	2016-05-30 22:34:38.3688	2478
8448	42	2016-05-30 22:34:38.374544	2480
8449	42	2016-05-30 22:34:38.380704	2457
8450	42	2016-05-30 22:34:38.386513	2475
8451	42	2016-05-30 22:34:38.391993	2502
8452	42	2016-05-30 22:34:38.397585	2459
8453	42	2016-05-30 22:34:38.403119	2463
8454	42	2016-05-30 22:34:38.40878	2476
8455	42	2016-05-30 22:34:38.41454	2448
8456	42	2016-05-30 22:34:38.42032	2465
8457	42	2016-05-30 22:34:38.425928	2461
8458	42	2016-05-30 22:34:38.431593	2469
8459	42	2016-05-30 22:34:38.437242	2474
8460	42	2016-05-30 22:34:38.442805	2492
8461	43	2016-05-30 22:34:38.448724	2462
8462	43	2016-05-30 22:34:38.454242	2466
8463	43	2016-05-30 22:34:38.459968	2489
8464	43	2016-05-30 22:34:38.466134	2477
8465	43	2016-05-30 22:34:38.471904	2481
8466	43	2016-05-30 22:34:38.477511	2453
8467	43	2016-05-30 22:34:38.483597	2491
8468	43	2016-05-30 22:34:38.489265	2483
8469	43	2016-05-30 22:34:38.49496	2443
8470	43	2016-05-30 22:34:38.500964	2501
8471	43	2016-05-30 22:34:38.506524	2375
8472	43	2016-05-30 22:34:38.512394	2458
8473	43	2016-05-30 22:34:38.518012	2499
8474	43	2016-05-30 22:34:38.523537	2471
8475	43	2016-05-30 22:34:38.529145	2487
8476	43	2016-05-30 22:34:38.534963	2441
8477	43	2016-05-30 22:34:38.540649	2451
8478	43	2016-05-30 22:34:38.546513	2507
8479	43	2016-05-30 22:34:38.552214	2464
8480	43	2016-05-30 22:34:38.55797	2497
8481	43	2016-05-30 22:34:38.563901	2460
8482	43	2016-05-30 22:34:38.569699	2493
8483	43	2016-05-30 22:34:38.57542	2473
8484	43	2016-05-30 22:34:38.581365	2445
8485	43	2016-05-30 22:34:38.587204	2485
8486	43	2016-05-30 22:34:38.592782	2495
8487	43	2016-05-30 22:34:38.599016	2449
8488	43	2016-05-30 22:34:38.604832	2505
8489	43	2016-05-30 22:34:38.610596	2479
8490	43	2016-05-30 22:34:38.616684	2456
8491	43	2016-05-30 22:34:38.622678	2503
8492	40	2016-05-30 22:34:38.62955	47212
8493	40	2016-05-30 22:34:38.634696	47206
8494	40	2016-05-30 22:34:38.639946	47215
8495	40	2016-05-30 22:34:38.646065	47209
8496	40	2016-05-30 22:34:38.65106	47256
8497	40	2016-05-30 22:34:38.65921	47340
8498	40	2016-05-30 22:34:38.664345	47203
8499	40	2016-05-30 22:34:38.669568	47343
8500	49	2016-05-30 22:34:38.677661	47209
8501	49	2016-05-30 22:34:38.683937	47256
8502	49	2016-05-30 22:34:38.690102	47343
8503	49	2016-05-30 22:34:38.696767	47212
8504	49	2016-05-30 22:34:38.703308	47206
8505	49	2016-05-30 22:34:38.712477	47340
8506	49	2016-05-30 22:34:38.718971	47203
8507	49	2016-05-30 22:34:38.725247	47215
8508	48	2016-05-30 22:34:38.733812	2500
8509	48	2016-05-30 22:34:38.74089	2374
8510	48	2016-05-30 22:34:38.748025	2475
8511	48	2016-05-30 22:34:38.755045	2498
8512	48	2016-05-30 22:34:38.762053	2480
8513	48	2016-05-30 22:34:38.769117	2454
8514	48	2016-05-30 22:34:38.775988	2465
8515	48	2016-05-30 22:34:38.782767	2459
8516	48	2016-05-30 22:34:38.789704	2472
8517	48	2016-05-30 22:34:38.796762	2467
8518	48	2016-05-30 22:34:38.803932	2504
8519	48	2016-05-30 22:34:38.810805	2469
8520	48	2016-05-30 22:34:38.817812	2442
8521	48	2016-05-30 22:34:38.825197	2474
8522	48	2016-05-30 22:34:38.832459	2486
8523	48	2016-05-30 22:34:38.839492	2476
8524	48	2016-05-30 22:34:38.846649	2492
8525	48	2016-05-30 22:34:38.853676	2448
8526	48	2016-05-30 22:34:38.860962	2490
8527	48	2016-05-30 22:34:38.868321	2440
8528	48	2016-05-30 22:34:38.875578	2452
8529	48	2016-05-30 22:34:38.882912	2468
8530	48	2016-05-30 22:34:38.889999	2450
8531	48	2016-05-30 22:34:38.897453	2470
8532	48	2016-05-30 22:34:38.904484	2506
8533	48	2016-05-30 22:34:38.911687	2461
8534	48	2016-05-30 22:34:38.918738	2502
8535	48	2016-05-30 22:34:38.925903	2455
8536	48	2016-05-30 22:34:38.932974	2478
8537	48	2016-05-30 22:34:38.939855	2488
8538	48	2016-05-30 22:34:38.947459	2494
8539	48	2016-05-30 22:34:38.954413	2484
8540	48	2016-05-30 22:34:38.961479	2514
8541	48	2016-05-30 22:34:38.968632	2457
8542	48	2016-05-30 22:34:38.975489	2482
8543	48	2016-05-30 22:34:38.982628	2463
8544	48	2016-05-30 22:34:38.989478	2444
8545	48	2016-05-30 22:34:38.996864	2496
8546	50	2016-05-30 22:34:39.004586	47209
8547	50	2016-05-30 22:34:39.010986	47256
8548	50	2016-05-30 22:34:39.017699	47343
8549	50	2016-05-30 22:34:39.024486	47212
8550	50	2016-05-30 22:34:39.031088	47206
8551	50	2016-05-30 22:34:39.040261	47340
8552	50	2016-05-30 22:34:39.046845	47203
8553	50	2016-05-30 22:34:39.05347	47215
8554	47	2016-05-30 22:34:39.061946	2500
8555	47	2016-05-30 22:34:39.068737	2374
8556	47	2016-05-30 22:34:39.075411	2475
8557	47	2016-05-30 22:34:39.082484	2498
8558	47	2016-05-30 22:34:39.089304	2480
8559	47	2016-05-30 22:34:39.096182	2454
8560	47	2016-05-30 22:34:39.102982	2465
8561	47	2016-05-30 22:34:39.110238	2459
8562	47	2016-05-30 22:34:39.117073	2472
8563	47	2016-05-30 22:34:39.124277	2467
8564	47	2016-05-30 22:34:39.131345	2504
8565	47	2016-05-30 22:34:39.138299	2469
8566	47	2016-05-30 22:34:39.145279	2442
8567	47	2016-05-30 22:34:39.15239	2474
8568	47	2016-05-30 22:34:39.159297	2486
8569	47	2016-05-30 22:34:39.166898	2476
8570	47	2016-05-30 22:34:39.173509	2492
8571	47	2016-05-30 22:34:39.18082	2448
8572	47	2016-05-30 22:34:39.187704	2490
8573	47	2016-05-30 22:34:39.194675	2440
8574	47	2016-05-30 22:34:39.201872	2452
8575	47	2016-05-30 22:34:39.208803	2468
8576	47	2016-05-30 22:34:39.216209	2450
8577	47	2016-05-30 22:34:39.223169	2470
8578	47	2016-05-30 22:34:39.229964	2506
8579	47	2016-05-30 22:34:39.237157	2461
8580	47	2016-05-30 22:34:39.243958	2502
8581	47	2016-05-30 22:34:39.251119	2455
8582	47	2016-05-30 22:34:39.258412	2478
8583	47	2016-05-30 22:34:39.265772	2488
8584	47	2016-05-30 22:34:39.272604	2494
8585	47	2016-05-30 22:34:39.279527	2484
8586	47	2016-05-30 22:34:39.286567	2514
8587	47	2016-05-30 22:34:39.293427	2457
8588	47	2016-05-30 22:34:39.300603	2482
8589	47	2016-05-30 22:34:39.307511	2463
8590	47	2016-05-30 22:34:39.31439	2444
8591	47	2016-05-30 22:34:39.321931	2496
8592	41	2016-05-30 22:40:39.140048	2518
8593	41	2016-05-30 22:40:39.14638	2378
8594	41	2016-05-30 22:40:39.157343	2517
8595	41	2016-05-30 22:40:39.167867	2522
8596	41	2016-05-30 22:40:39.178245	2520
8597	41	2016-05-30 22:40:39.189066	2521
8598	41	2016-05-30 22:40:39.199268	2523
8599	41	2016-05-30 22:40:39.209318	2525
8600	41	2016-05-30 22:40:39.215127	2528
8601	41	2016-05-30 22:40:39.225666	2516
8602	41	2016-05-30 22:40:39.235819	2519
8603	41	2016-05-30 22:40:39.246047	2524
8604	46	2016-05-30 22:40:39.252339	2398
8605	45	2016-05-30 22:40:39.258576	2400
8606	44	2016-05-30 22:40:39.264798	2382
8607	42	2016-05-30 22:40:39.270757	2444
8608	42	2016-05-30 22:40:39.276409	2486
8609	42	2016-05-30 22:40:39.282096	2450
8610	42	2016-05-30 22:40:39.288001	2452
8611	42	2016-05-30 22:40:39.293905	2455
8612	42	2016-05-30 22:40:39.299499	2482
8613	42	2016-05-30 22:40:39.305844	2488
8614	42	2016-05-30 22:40:39.311712	2472
8615	42	2016-05-30 22:40:39.317647	2500
8616	42	2016-05-30 22:40:39.323354	2374
8617	42	2016-05-30 22:40:39.328847	2442
8618	42	2016-05-30 22:40:39.334304	2496
8619	42	2016-05-30 22:40:39.339999	2467
8620	42	2016-05-30 22:40:39.345545	2490
8621	42	2016-05-30 22:40:39.35121	2504
8622	42	2016-05-30 22:40:39.356941	2494
8623	42	2016-05-30 22:40:39.362564	2470
8624	42	2016-05-30 22:40:39.368248	2498
8625	42	2016-05-30 22:40:39.374049	2484
8626	42	2016-05-30 22:40:39.379756	2506
8627	42	2016-05-30 22:40:39.385362	2440
8628	42	2016-05-30 22:40:39.390975	2468
8629	42	2016-05-30 22:40:39.396667	2478
8630	42	2016-05-30 22:40:39.402181	2480
8631	42	2016-05-30 22:40:39.408057	2457
8632	42	2016-05-30 22:40:39.413662	2475
8633	42	2016-05-30 22:40:39.419208	2502
8634	42	2016-05-30 22:40:39.42464	2459
8635	42	2016-05-30 22:40:39.429959	2463
8636	42	2016-05-30 22:40:39.435667	2476
8637	42	2016-05-30 22:40:39.441389	2448
8638	42	2016-05-30 22:40:39.447002	2465
8639	42	2016-05-30 22:40:39.452593	2461
8640	42	2016-05-30 22:40:39.458429	2469
8641	42	2016-05-30 22:40:39.464123	2474
8642	42	2016-05-30 22:40:39.469783	2492
8643	43	2016-05-30 22:40:39.475749	2462
8644	43	2016-05-30 22:40:39.481336	2466
8645	43	2016-05-30 22:40:39.48733	2489
8646	43	2016-05-30 22:40:39.49298	2477
8647	43	2016-05-30 22:40:39.498548	2481
8648	43	2016-05-30 22:40:39.50437	2453
8649	43	2016-05-30 22:40:39.510515	2491
8650	43	2016-05-30 22:40:39.516276	2483
8651	43	2016-05-30 22:40:39.521947	2443
8652	43	2016-05-30 22:40:39.527489	2501
8653	43	2016-05-30 22:40:39.533283	2375
8654	43	2016-05-30 22:40:39.539138	2458
8655	43	2016-05-30 22:40:39.544856	2499
8656	43	2016-05-30 22:40:39.550622	2471
8657	43	2016-05-30 22:40:39.556665	2487
8658	43	2016-05-30 22:40:39.562368	2441
8659	43	2016-05-30 22:40:39.568301	2451
8660	43	2016-05-30 22:40:39.574104	2507
8661	43	2016-05-30 22:40:39.579881	2464
8662	43	2016-05-30 22:40:39.585622	2497
8663	43	2016-05-30 22:40:39.591528	2460
8664	43	2016-05-30 22:40:39.597243	2493
8665	43	2016-05-30 22:40:39.602887	2473
8666	43	2016-05-30 22:40:39.608775	2445
8667	43	2016-05-30 22:40:39.614686	2485
8668	43	2016-05-30 22:40:39.62053	2495
8669	43	2016-05-30 22:40:39.626452	2449
8670	43	2016-05-30 22:40:39.632065	2505
8671	43	2016-05-30 22:40:39.638412	2479
8672	43	2016-05-30 22:40:39.644208	2456
8673	43	2016-05-30 22:40:39.649873	2503
8674	40	2016-05-30 22:40:39.657089	47212
8675	40	2016-05-30 22:40:39.662227	47206
8676	40	2016-05-30 22:40:39.667344	47215
8677	40	2016-05-30 22:40:39.673211	47209
8678	40	2016-05-30 22:40:39.67841	47256
8679	40	2016-05-30 22:40:39.686502	47340
8680	40	2016-05-30 22:40:39.691573	47203
8681	40	2016-05-30 22:40:39.696752	47343
8682	49	2016-05-30 22:40:39.705104	47209
8683	49	2016-05-30 22:40:39.71163	47256
8684	49	2016-05-30 22:40:39.717734	47343
8685	49	2016-05-30 22:40:39.724088	47212
8686	49	2016-05-30 22:40:39.730343	47206
8687	49	2016-05-30 22:40:39.739614	47340
8688	49	2016-05-30 22:40:39.746002	47203
8689	49	2016-05-30 22:40:39.752229	47215
8690	48	2016-05-30 22:40:39.760705	2500
8691	48	2016-05-30 22:40:39.767837	2374
8692	48	2016-05-30 22:40:39.775116	2475
8693	48	2016-05-30 22:40:39.78217	2498
8694	48	2016-05-30 22:40:39.789419	2480
8695	48	2016-05-30 22:40:39.796511	2454
8696	48	2016-05-30 22:40:39.803879	2465
8697	48	2016-05-30 22:40:39.810929	2459
8698	48	2016-05-30 22:40:39.817892	2472
8699	48	2016-05-30 22:40:39.825058	2467
8700	48	2016-05-30 22:40:39.832165	2504
8701	48	2016-05-30 22:40:39.839507	2469
8702	48	2016-05-30 22:40:39.846704	2442
8703	48	2016-05-30 22:40:39.853745	2474
8704	48	2016-05-30 22:40:39.860914	2486
8705	48	2016-05-30 22:40:39.868585	2476
8706	48	2016-05-30 22:40:39.875921	2492
8707	48	2016-05-30 22:40:39.882858	2448
8708	48	2016-05-30 22:40:39.890056	2490
8709	48	2016-05-30 22:40:39.897025	2440
8710	48	2016-05-30 22:40:39.904635	2452
8711	48	2016-05-30 22:40:39.911687	2468
8712	48	2016-05-30 22:40:39.919085	2450
8713	48	2016-05-30 22:40:39.926105	2470
8714	48	2016-05-30 22:40:39.933196	2506
8715	48	2016-05-30 22:40:39.940393	2461
8716	48	2016-05-30 22:40:39.947633	2502
8717	48	2016-05-30 22:40:39.954522	2455
8718	48	2016-05-30 22:40:39.961799	2478
8719	48	2016-05-30 22:40:39.969316	2488
8720	48	2016-05-30 22:40:39.978914	2494
8721	48	2016-05-30 22:40:39.987868	2484
8722	48	2016-05-30 22:40:39.994738	2514
8723	48	2016-05-30 22:40:40.001853	2457
8724	48	2016-05-30 22:40:40.009059	2482
8725	48	2016-05-30 22:40:40.016059	2463
8726	48	2016-05-30 22:40:40.02302	2444
8727	48	2016-05-30 22:40:40.030237	2496
8728	50	2016-05-30 22:40:40.038188	47209
8729	50	2016-05-30 22:40:40.044652	47256
8730	50	2016-05-30 22:40:40.050858	47343
8731	50	2016-05-30 22:40:40.057192	47212
8732	50	2016-05-30 22:40:40.063654	47206
8733	50	2016-05-30 22:40:40.072931	47340
8734	50	2016-05-30 22:40:40.079561	47203
8735	50	2016-05-30 22:40:40.086182	47215
8736	47	2016-05-30 22:40:40.094578	2500
8737	47	2016-05-30 22:40:40.101472	2374
8738	47	2016-05-30 22:40:40.108212	2475
8739	47	2016-05-30 22:40:40.115417	2498
8740	47	2016-05-30 22:40:40.122328	2480
8741	47	2016-05-30 22:40:40.129222	2454
8742	47	2016-05-30 22:40:40.13614	2465
8743	47	2016-05-30 22:40:40.142909	2459
8744	47	2016-05-30 22:40:40.14962	2472
8745	47	2016-05-30 22:40:40.156601	2467
8746	47	2016-05-30 22:40:40.163511	2504
8747	47	2016-05-30 22:40:40.170465	2469
8748	47	2016-05-30 22:40:40.177384	2442
8749	47	2016-05-30 22:40:40.184457	2474
8750	47	2016-05-30 22:40:40.191546	2486
8751	47	2016-05-30 22:40:40.198271	2476
8752	47	2016-05-30 22:40:40.205104	2492
8753	47	2016-05-30 22:40:40.212036	2448
8754	47	2016-05-30 22:40:40.219126	2490
8755	47	2016-05-30 22:40:40.226036	2440
8756	47	2016-05-30 22:40:40.232683	2452
8757	47	2016-05-30 22:40:40.239839	2468
8758	47	2016-05-30 22:40:40.246655	2450
8759	47	2016-05-30 22:40:40.253558	2470
8760	47	2016-05-30 22:40:40.260266	2506
8761	47	2016-05-30 22:40:40.26734	2461
8762	47	2016-05-30 22:40:40.274348	2502
8763	47	2016-05-30 22:40:40.281141	2455
8764	47	2016-05-30 22:40:40.288092	2478
8765	47	2016-05-30 22:40:40.294819	2488
8766	47	2016-05-30 22:40:40.301765	2494
8767	47	2016-05-30 22:40:40.309471	2484
8768	47	2016-05-30 22:40:40.316487	2514
8769	47	2016-05-30 22:40:40.323148	2457
8770	47	2016-05-30 22:40:40.330711	2482
8771	47	2016-05-30 22:40:40.337962	2463
8772	47	2016-05-30 22:40:40.344828	2444
8773	47	2016-05-30 22:40:40.351735	2496
8774	41	2016-05-30 22:44:07.162664	2518
8775	41	2016-05-30 22:44:07.169452	2378
8776	41	2016-05-30 22:44:07.181161	2517
8777	41	2016-05-30 22:44:07.192563	2522
8778	41	2016-05-30 22:44:07.203494	2520
8779	41	2016-05-30 22:44:07.214823	2521
8780	41	2016-05-30 22:44:07.225851	2523
8781	41	2016-05-30 22:44:07.236713	2525
8782	41	2016-05-30 22:44:07.243233	2528
8783	41	2016-05-30 22:44:07.254319	2516
8784	41	2016-05-30 22:44:07.265825	2519
8785	41	2016-05-30 22:44:07.276758	2524
8786	46	2016-05-30 22:44:07.283446	2398
8787	45	2016-05-30 22:44:07.290212	2400
8788	44	2016-05-30 22:44:07.296903	2382
8789	42	2016-05-30 22:44:07.304706	2444
8790	42	2016-05-30 22:44:07.310894	2486
8791	42	2016-05-30 22:44:07.316942	2450
8792	42	2016-05-30 22:44:07.322994	2452
8793	42	2016-05-30 22:44:07.329492	2455
8794	42	2016-05-30 22:44:07.335424	2482
8795	42	2016-05-30 22:44:07.341473	2488
8796	42	2016-05-30 22:44:07.347428	2472
8797	42	2016-05-30 22:44:07.353514	2500
8798	42	2016-05-30 22:44:07.360086	2374
8799	42	2016-05-30 22:44:07.366536	2442
8800	42	2016-05-30 22:44:07.372852	2496
8801	42	2016-05-30 22:44:07.379183	2467
8802	42	2016-05-30 22:44:07.385654	2490
8803	42	2016-05-30 22:44:07.392152	2504
8804	42	2016-05-30 22:44:07.39837	2494
8805	42	2016-05-30 22:44:07.404598	2470
8806	42	2016-05-30 22:44:07.411453	2498
8807	42	2016-05-30 22:44:07.417455	2484
8808	42	2016-05-30 22:44:07.423535	2506
8809	42	2016-05-30 22:44:07.429601	2440
8810	42	2016-05-30 22:44:07.43583	2468
8811	42	2016-05-30 22:44:07.442383	2478
8812	42	2016-05-30 22:44:07.448582	2480
8813	42	2016-05-30 22:44:07.454794	2457
8814	42	2016-05-30 22:44:07.460955	2475
8815	42	2016-05-30 22:44:07.467119	2502
8816	42	2016-05-30 22:44:07.473426	2459
8817	42	2016-05-30 22:44:07.479472	2463
8818	42	2016-05-30 22:44:07.485203	2476
8819	42	2016-05-30 22:44:07.490836	2448
8820	42	2016-05-30 22:44:07.49641	2465
8821	42	2016-05-30 22:44:07.502524	2461
8822	42	2016-05-30 22:44:07.508452	2469
8823	42	2016-05-30 22:44:07.51464	2474
8824	42	2016-05-30 22:44:07.520525	2492
8825	43	2016-05-30 22:44:07.526522	2462
8826	43	2016-05-30 22:44:07.532103	2466
8827	43	2016-05-30 22:44:07.537637	2489
8828	43	2016-05-30 22:44:07.543459	2477
8829	43	2016-05-30 22:44:07.549727	2481
8830	43	2016-05-30 22:44:07.555615	2453
8831	43	2016-05-30 22:44:07.561435	2491
8832	43	2016-05-30 22:44:07.567087	2483
8833	43	2016-05-30 22:44:07.5727	2443
8834	43	2016-05-30 22:44:07.57838	2501
8835	43	2016-05-30 22:44:07.584475	2375
8836	43	2016-05-30 22:44:07.590055	2458
8837	43	2016-05-30 22:44:07.596037	2499
8838	43	2016-05-30 22:44:07.601787	2471
8839	43	2016-05-30 22:44:07.607291	2487
8840	43	2016-05-30 22:44:07.613322	2441
8841	43	2016-05-30 22:44:07.619251	2451
8842	43	2016-05-30 22:44:07.625016	2507
8843	43	2016-05-30 22:44:07.630945	2464
8844	43	2016-05-30 22:44:07.636711	2497
8845	43	2016-05-30 22:44:07.642744	2460
8846	43	2016-05-30 22:44:07.648677	2493
8847	43	2016-05-30 22:44:07.654336	2473
8848	43	2016-05-30 22:44:07.660408	2445
8849	43	2016-05-30 22:44:07.6662	2485
8850	43	2016-05-30 22:44:07.671803	2495
8851	43	2016-05-30 22:44:07.677855	2449
8852	43	2016-05-30 22:44:07.683568	2505
8853	43	2016-05-30 22:44:07.689354	2479
8854	43	2016-05-30 22:44:07.6952	2456
8855	43	2016-05-30 22:44:07.700914	2503
8856	40	2016-05-30 22:44:07.70765	47212
8857	40	2016-05-30 22:44:07.712859	47206
8858	40	2016-05-30 22:44:07.718337	47215
8859	40	2016-05-30 22:44:07.723639	47209
8860	40	2016-05-30 22:44:07.729026	47256
8861	40	2016-05-30 22:44:07.736764	47340
8862	40	2016-05-30 22:44:07.742135	47203
8863	40	2016-05-30 22:44:07.747352	47343
8864	49	2016-05-30 22:44:07.755733	47209
8865	49	2016-05-30 22:44:07.761997	47256
8866	49	2016-05-30 22:44:07.768174	47343
8867	49	2016-05-30 22:44:07.774637	47212
8868	49	2016-05-30 22:44:07.780944	47206
8869	49	2016-05-30 22:44:07.789809	47340
8870	49	2016-05-30 22:44:07.796095	47203
8871	49	2016-05-30 22:44:07.802911	47215
8872	48	2016-05-30 22:44:07.827032	2500
8873	48	2016-05-30 22:44:07.834197	2374
8874	48	2016-05-30 22:44:07.841501	2475
8875	48	2016-05-30 22:44:07.848846	2498
8876	48	2016-05-30 22:44:07.855867	2480
8877	48	2016-05-30 22:44:07.862854	2454
8878	48	2016-05-30 22:44:07.869829	2465
8879	48	2016-05-30 22:44:07.876864	2459
8880	48	2016-05-30 22:44:07.883782	2472
8881	48	2016-05-30 22:44:07.890826	2467
8882	48	2016-05-30 22:44:07.897763	2504
8883	48	2016-05-30 22:44:07.904929	2469
8884	48	2016-05-30 22:44:07.911817	2442
8885	48	2016-05-30 22:44:07.919116	2474
8886	48	2016-05-30 22:44:07.926221	2486
8887	48	2016-05-30 22:44:07.933269	2476
8888	48	2016-05-30 22:44:07.940426	2492
8889	48	2016-05-30 22:44:07.947553	2448
8890	48	2016-05-30 22:44:07.954662	2490
8891	48	2016-05-30 22:44:07.962043	2440
8892	48	2016-05-30 22:44:07.969245	2452
8893	48	2016-05-30 22:44:07.976338	2468
8894	48	2016-05-30 22:44:07.983425	2450
8895	48	2016-05-30 22:44:07.99113	2470
8896	48	2016-05-30 22:44:07.998183	2506
8897	48	2016-05-30 22:44:08.005334	2461
8898	48	2016-05-30 22:44:08.01243	2502
8899	48	2016-05-30 22:44:08.019378	2455
8900	48	2016-05-30 22:44:08.026663	2478
8901	48	2016-05-30 22:44:08.03384	2488
8902	48	2016-05-30 22:44:08.040979	2494
8903	48	2016-05-30 22:44:08.048101	2484
8904	48	2016-05-30 22:44:08.054951	2514
8905	48	2016-05-30 22:44:08.062033	2457
8906	48	2016-05-30 22:44:08.069204	2482
8907	48	2016-05-30 22:44:08.076398	2463
8908	48	2016-05-30 22:44:08.08347	2444
8909	48	2016-05-30 22:44:08.091267	2496
8910	50	2016-05-30 22:44:08.099433	47209
8911	50	2016-05-30 22:44:08.105881	47256
8912	50	2016-05-30 22:44:08.112667	47343
8913	50	2016-05-30 22:44:08.119318	47212
8914	50	2016-05-30 22:44:08.125922	47206
8915	50	2016-05-30 22:44:08.135232	47340
8916	50	2016-05-30 22:44:08.142376	47203
8917	50	2016-05-30 22:44:08.148955	47215
8918	47	2016-05-30 22:44:08.157565	2500
8919	47	2016-05-30 22:44:08.164507	2374
8920	47	2016-05-30 22:44:08.171511	2475
8921	47	2016-05-30 22:44:08.178454	2498
8922	47	2016-05-30 22:44:08.185594	2480
8923	47	2016-05-30 22:44:08.192682	2454
8924	47	2016-05-30 22:44:08.199606	2465
8925	47	2016-05-30 22:44:08.206515	2459
8926	47	2016-05-30 22:44:08.213267	2472
8927	47	2016-05-30 22:44:08.220409	2467
8928	47	2016-05-30 22:44:08.227417	2504
8929	47	2016-05-30 22:44:08.234389	2469
8930	47	2016-05-30 22:44:08.241324	2442
8931	47	2016-05-30 22:44:08.248184	2474
8932	47	2016-05-30 22:44:08.255092	2486
8933	47	2016-05-30 22:44:08.262002	2476
8934	47	2016-05-30 22:44:08.268838	2492
8935	47	2016-05-30 22:44:08.275814	2448
8936	47	2016-05-30 22:44:08.282785	2490
8937	47	2016-05-30 22:44:08.290067	2440
8938	47	2016-05-30 22:44:08.296999	2452
8939	47	2016-05-30 22:44:08.30473	2468
8940	47	2016-05-30 22:44:08.311702	2450
8941	47	2016-05-30 22:44:08.318498	2470
8942	47	2016-05-30 22:44:08.325408	2506
8943	47	2016-05-30 22:44:08.33234	2461
8944	47	2016-05-30 22:44:08.3391	2502
8945	47	2016-05-30 22:44:08.346374	2455
8946	47	2016-05-30 22:44:08.353286	2478
8947	47	2016-05-30 22:44:08.360005	2488
8948	47	2016-05-30 22:44:08.366806	2494
8949	47	2016-05-30 22:44:08.373658	2484
8950	47	2016-05-30 22:44:08.380539	2514
8951	47	2016-05-30 22:44:08.387627	2457
8952	47	2016-05-30 22:44:08.394461	2482
8953	47	2016-05-30 22:44:08.401752	2463
8954	47	2016-05-30 22:44:08.408836	2444
8955	47	2016-05-30 22:44:08.415712	2496
8956	41	2016-05-30 22:45:31.745341	2518
8957	41	2016-05-30 22:45:31.75235	2378
8958	41	2016-05-30 22:45:31.763652	2517
8959	41	2016-05-30 22:45:31.775042	2522
8960	41	2016-05-30 22:45:31.786182	2520
8961	41	2016-05-30 22:45:31.797226	2521
8962	41	2016-05-30 22:45:31.808625	2523
8963	41	2016-05-30 22:45:31.819618	2525
8964	41	2016-05-30 22:45:31.825752	2528
8965	41	2016-05-30 22:45:31.836808	2516
8966	41	2016-05-30 22:45:31.848635	2519
8967	41	2016-05-30 22:45:31.86031	2524
8968	46	2016-05-30 22:45:31.86686	2398
8969	45	2016-05-30 22:45:31.873676	2400
8970	44	2016-05-30 22:45:31.880287	2382
8971	42	2016-05-30 22:45:31.88688	2444
8972	42	2016-05-30 22:45:31.893413	2486
8973	42	2016-05-30 22:45:31.899781	2450
8974	42	2016-05-30 22:45:31.906124	2452
8975	42	2016-05-30 22:45:31.912366	2455
8976	42	2016-05-30 22:45:31.918672	2482
8977	42	2016-05-30 22:45:31.925224	2488
8978	42	2016-05-30 22:45:31.931796	2472
8979	42	2016-05-30 22:45:31.937895	2500
8980	42	2016-05-30 22:45:31.944024	2374
8981	42	2016-05-30 22:45:31.950653	2442
8982	42	2016-05-30 22:45:31.957351	2496
8983	42	2016-05-30 22:45:31.964193	2467
8984	42	2016-05-30 22:45:31.970382	2490
8985	42	2016-05-30 22:45:31.976437	2504
8986	42	2016-05-30 22:45:31.983033	2494
8987	42	2016-05-30 22:45:31.989591	2470
8988	42	2016-05-30 22:45:31.996008	2498
8989	42	2016-05-30 22:45:32.002255	2484
8990	42	2016-05-30 22:45:32.008932	2506
8991	42	2016-05-30 22:45:32.014808	2440
8992	42	2016-05-30 22:45:32.021064	2468
8993	42	2016-05-30 22:45:32.027164	2478
8994	42	2016-05-30 22:45:32.033216	2480
8995	42	2016-05-30 22:45:32.03997	2457
8996	42	2016-05-30 22:45:32.046165	2475
8997	42	2016-05-30 22:45:32.052277	2502
8998	42	2016-05-30 22:45:32.058388	2459
8999	42	2016-05-30 22:45:32.064381	2463
9000	42	2016-05-30 22:45:32.071495	2476
9001	42	2016-05-30 22:45:32.07906	2448
9002	42	2016-05-30 22:45:32.085229	2465
9003	42	2016-05-30 22:45:32.092946	2461
9004	42	2016-05-30 22:45:32.099162	2469
9005	42	2016-05-30 22:45:32.105263	2474
9006	42	2016-05-30 22:45:32.111808	2492
9007	43	2016-05-30 22:45:32.11829	2462
9008	43	2016-05-30 22:45:32.124432	2466
9009	43	2016-05-30 22:45:32.130611	2489
9010	43	2016-05-30 22:45:32.136633	2477
9011	43	2016-05-30 22:45:32.142822	2481
9012	43	2016-05-30 22:45:32.149194	2453
9013	43	2016-05-30 22:45:32.154939	2491
9014	43	2016-05-30 22:45:32.160801	2483
9015	43	2016-05-30 22:45:32.166543	2443
9016	43	2016-05-30 22:45:32.172188	2501
9017	43	2016-05-30 22:45:32.178172	2375
9018	43	2016-05-30 22:45:32.183983	2458
9019	43	2016-05-30 22:45:32.189662	2499
9020	43	2016-05-30 22:45:32.195512	2471
9021	43	2016-05-30 22:45:32.201305	2487
9022	43	2016-05-30 22:45:32.207127	2441
9023	43	2016-05-30 22:45:32.212988	2451
9024	43	2016-05-30 22:45:32.218739	2507
9025	43	2016-05-30 22:45:32.224763	2464
9026	43	2016-05-30 22:45:32.230544	2497
9027	43	2016-05-30 22:45:32.236217	2460
9028	43	2016-05-30 22:45:32.242265	2493
9029	43	2016-05-30 22:45:32.248086	2473
9030	43	2016-05-30 22:45:32.253682	2445
9031	43	2016-05-30 22:45:32.25954	2485
9032	43	2016-05-30 22:45:32.265268	2495
9033	43	2016-05-30 22:45:32.27086	2449
9034	43	2016-05-30 22:45:32.276568	2505
9035	43	2016-05-30 22:45:32.282374	2479
9036	43	2016-05-30 22:45:32.288018	2456
9037	43	2016-05-30 22:45:32.294303	2503
9038	40	2016-05-30 22:45:32.301401	47212
9039	40	2016-05-30 22:45:32.306633	47206
9040	40	2016-05-30 22:45:32.311948	47215
9041	40	2016-05-30 22:45:32.317145	47209
9042	40	2016-05-30 22:45:32.322317	47256
9043	40	2016-05-30 22:45:32.330182	47340
9044	40	2016-05-30 22:45:32.335393	47203
9045	40	2016-05-30 22:45:32.340394	47343
9046	49	2016-05-30 22:45:32.348506	47209
9047	49	2016-05-30 22:45:32.354733	47256
9048	49	2016-05-30 22:45:32.360906	47343
9049	49	2016-05-30 22:45:32.367401	47212
9050	49	2016-05-30 22:45:32.373845	47206
9051	49	2016-05-30 22:45:32.382757	47340
9052	49	2016-05-30 22:45:32.389192	47203
9053	49	2016-05-30 22:45:32.395605	47215
9054	48	2016-05-30 22:45:32.404246	2500
9055	48	2016-05-30 22:45:32.411584	2374
9056	48	2016-05-30 22:45:32.418584	2475
9057	48	2016-05-30 22:45:32.425718	2498
9058	48	2016-05-30 22:45:32.432864	2480
9059	48	2016-05-30 22:45:32.440552	2454
9060	48	2016-05-30 22:45:32.447708	2465
9061	48	2016-05-30 22:45:32.45489	2459
9062	48	2016-05-30 22:45:32.461992	2472
9063	48	2016-05-30 22:45:32.469068	2467
9064	48	2016-05-30 22:45:32.476378	2504
9065	48	2016-05-30 22:45:32.483559	2469
9066	48	2016-05-30 22:45:32.490709	2442
9067	48	2016-05-30 22:45:32.497976	2474
9068	48	2016-05-30 22:45:32.505177	2486
9069	48	2016-05-30 22:45:32.512365	2476
9070	48	2016-05-30 22:45:32.519484	2492
9071	48	2016-05-30 22:45:32.526729	2448
9072	48	2016-05-30 22:45:32.533827	2490
9073	48	2016-05-30 22:45:32.540861	2440
9074	48	2016-05-30 22:45:32.548462	2452
9075	48	2016-05-30 22:45:32.555702	2468
9076	48	2016-05-30 22:45:32.562963	2450
9077	48	2016-05-30 22:45:32.570251	2470
9078	48	2016-05-30 22:45:32.577342	2506
9079	48	2016-05-30 22:45:32.584555	2461
9080	48	2016-05-30 22:45:32.59174	2502
9081	48	2016-05-30 22:45:32.598912	2455
9082	48	2016-05-30 22:45:32.606039	2478
9083	48	2016-05-30 22:45:32.613189	2488
9084	48	2016-05-30 22:45:32.620451	2494
9085	48	2016-05-30 22:45:32.627593	2484
9086	48	2016-05-30 22:45:32.634998	2514
9087	48	2016-05-30 22:45:32.642763	2457
9088	48	2016-05-30 22:45:32.650072	2482
9089	48	2016-05-30 22:45:32.657219	2463
9090	48	2016-05-30 22:45:32.664611	2444
9091	48	2016-05-30 22:45:32.671752	2496
9092	50	2016-05-30 22:45:32.679941	47209
9093	50	2016-05-30 22:45:32.686407	47256
9094	50	2016-05-30 22:45:32.692872	47343
9095	50	2016-05-30 22:45:32.699579	47212
9096	50	2016-05-30 22:45:32.706721	47206
9097	50	2016-05-30 22:45:32.716313	47340
9098	50	2016-05-30 22:45:32.722946	47203
9099	50	2016-05-30 22:45:32.729623	47215
9100	47	2016-05-30 22:45:32.738182	2500
9101	47	2016-05-30 22:45:32.74532	2374
9102	47	2016-05-30 22:45:32.75233	2475
9103	47	2016-05-30 22:45:32.75943	2498
9104	47	2016-05-30 22:45:32.766478	2480
9105	47	2016-05-30 22:45:32.773501	2454
9106	47	2016-05-30 22:45:32.780481	2465
9107	47	2016-05-30 22:45:32.787412	2459
9108	47	2016-05-30 22:45:32.794361	2472
9109	47	2016-05-30 22:45:32.801422	2467
9110	47	2016-05-30 22:45:32.808499	2504
9111	47	2016-05-30 22:45:32.815567	2469
9112	47	2016-05-30 22:45:32.82263	2442
9113	47	2016-05-30 22:45:32.829758	2474
9114	47	2016-05-30 22:45:32.836624	2486
9115	47	2016-05-30 22:45:32.843483	2476
9116	47	2016-05-30 22:45:32.85035	2492
9117	47	2016-05-30 22:45:32.857389	2448
9118	47	2016-05-30 22:45:32.864569	2490
9119	47	2016-05-30 22:45:32.871661	2440
9120	47	2016-05-30 22:45:32.878593	2452
9121	47	2016-05-30 22:45:32.885656	2468
9122	47	2016-05-30 22:45:32.892546	2450
9123	47	2016-05-30 22:45:32.899612	2470
9124	47	2016-05-30 22:45:32.906524	2506
9125	47	2016-05-30 22:45:32.913519	2461
9126	47	2016-05-30 22:45:32.9208	2502
9127	47	2016-05-30 22:45:32.946834	2455
9128	47	2016-05-30 22:45:32.954973	2478
9129	47	2016-05-30 22:45:32.962494	2488
9130	47	2016-05-30 22:45:32.96949	2494
9131	47	2016-05-30 22:45:32.976619	2484
9132	47	2016-05-30 22:45:32.983563	2514
9133	47	2016-05-30 22:45:32.990492	2457
9134	47	2016-05-30 22:45:32.997375	2482
9135	47	2016-05-30 22:45:33.00425	2463
9136	47	2016-05-30 22:45:33.011358	2444
9137	47	2016-05-30 22:45:33.018393	2496
9138	41	2016-05-30 22:46:32.465143	2518
9139	41	2016-05-30 22:46:32.471554	2378
9140	41	2016-05-30 22:46:32.482653	2517
9141	41	2016-05-30 22:46:32.49281	2522
9142	41	2016-05-30 22:46:32.503321	2520
9143	41	2016-05-30 22:46:32.514003	2521
9144	41	2016-05-30 22:46:32.524239	2523
9145	41	2016-05-30 22:46:32.534766	2525
9146	41	2016-05-30 22:46:32.540441	2528
9147	41	2016-05-30 22:46:32.550635	2516
9148	41	2016-05-30 22:46:32.560745	2519
9149	41	2016-05-30 22:46:32.571297	2524
9150	46	2016-05-30 22:46:32.577582	2398
9151	45	2016-05-30 22:46:32.583594	2400
9152	44	2016-05-30 22:46:32.589837	2382
9153	42	2016-05-30 22:46:32.595854	2444
9154	42	2016-05-30 22:46:32.602052	2486
9155	42	2016-05-30 22:46:32.607749	2450
9156	42	2016-05-30 22:46:32.613805	2452
9157	42	2016-05-30 22:46:32.619957	2455
9158	42	2016-05-30 22:46:32.625841	2482
9159	42	2016-05-30 22:46:32.632333	2488
9160	42	2016-05-30 22:46:32.63801	2472
9161	42	2016-05-30 22:46:32.643888	2500
9162	42	2016-05-30 22:46:32.649727	2374
9163	42	2016-05-30 22:46:32.655494	2442
9164	42	2016-05-30 22:46:32.661111	2496
9165	42	2016-05-30 22:46:32.667071	2467
9166	42	2016-05-30 22:46:32.672699	2490
9167	42	2016-05-30 22:46:32.678886	2504
9168	42	2016-05-30 22:46:32.684668	2494
9169	42	2016-05-30 22:46:32.690795	2470
9170	42	2016-05-30 22:46:32.696432	2498
9171	42	2016-05-30 22:46:32.701998	2484
9172	42	2016-05-30 22:46:32.707655	2506
9173	42	2016-05-30 22:46:32.713452	2440
9174	42	2016-05-30 22:46:32.719396	2468
9175	42	2016-05-30 22:46:32.725036	2478
9176	42	2016-05-30 22:46:32.730895	2480
9177	42	2016-05-30 22:46:32.736588	2457
9178	42	2016-05-30 22:46:32.742299	2475
9179	42	2016-05-30 22:46:32.74797	2502
9180	42	2016-05-30 22:46:32.753708	2459
9181	42	2016-05-30 22:46:32.759397	2463
9182	42	2016-05-30 22:46:32.765296	2476
9183	42	2016-05-30 22:46:32.771738	2448
9184	42	2016-05-30 22:46:32.777395	2465
9185	42	2016-05-30 22:46:32.783556	2461
9186	42	2016-05-30 22:46:32.789452	2469
9187	42	2016-05-30 22:46:32.795259	2474
9188	42	2016-05-30 22:46:32.801201	2492
9189	43	2016-05-30 22:46:32.807287	2462
9190	43	2016-05-30 22:46:32.812966	2466
9191	43	2016-05-30 22:46:32.818985	2489
9192	43	2016-05-30 22:46:32.824542	2477
9193	43	2016-05-30 22:46:32.830442	2481
9194	43	2016-05-30 22:46:32.836004	2453
9195	43	2016-05-30 22:46:32.841686	2491
9196	43	2016-05-30 22:46:32.847845	2483
9197	43	2016-05-30 22:46:32.854068	2443
9198	43	2016-05-30 22:46:32.859726	2501
9199	43	2016-05-30 22:46:32.865801	2375
9200	43	2016-05-30 22:46:32.871662	2458
9201	43	2016-05-30 22:46:32.877411	2499
9202	43	2016-05-30 22:46:32.883498	2471
9203	43	2016-05-30 22:46:32.889343	2487
9204	43	2016-05-30 22:46:32.895077	2441
9205	43	2016-05-30 22:46:32.901003	2451
9206	43	2016-05-30 22:46:32.906971	2507
9207	43	2016-05-30 22:46:32.912893	2464
9208	43	2016-05-30 22:46:32.918697	2497
9209	43	2016-05-30 22:46:32.924814	2460
9210	43	2016-05-30 22:46:32.93083	2493
9211	43	2016-05-30 22:46:32.936635	2473
9212	43	2016-05-30 22:46:32.942464	2445
9213	43	2016-05-30 22:46:32.948717	2485
9214	43	2016-05-30 22:46:32.95456	2495
9215	43	2016-05-30 22:46:32.960254	2449
9216	43	2016-05-30 22:46:32.966151	2505
9217	43	2016-05-30 22:46:32.971931	2479
9218	43	2016-05-30 22:46:32.978023	2456
9219	43	2016-05-30 22:46:32.985006	2503
9220	40	2016-05-30 22:46:32.992696	47212
9221	40	2016-05-30 22:46:33.000056	47206
9222	40	2016-05-30 22:46:33.008572	47215
9223	40	2016-05-30 22:46:33.030287	47209
9224	40	2016-05-30 22:46:33.035641	47256
9225	40	2016-05-30 22:46:33.044176	47340
9226	40	2016-05-30 22:46:33.0499	47203
9227	40	2016-05-30 22:46:33.055412	47343
9228	49	2016-05-30 22:46:33.064026	47209
9229	49	2016-05-30 22:46:33.070595	47256
9230	49	2016-05-30 22:46:33.077022	47343
9231	49	2016-05-30 22:46:33.08394	47212
9232	49	2016-05-30 22:46:33.090608	47206
9233	49	2016-05-30 22:46:33.100002	47340
9234	49	2016-05-30 22:46:33.107691	47203
9235	49	2016-05-30 22:46:33.115048	47215
9236	48	2016-05-30 22:46:33.124365	2500
9237	48	2016-05-30 22:46:33.132232	2374
9238	48	2016-05-30 22:46:33.139935	2475
9239	48	2016-05-30 22:46:33.147674	2498
9240	48	2016-05-30 22:46:33.155598	2480
9241	48	2016-05-30 22:46:33.163108	2454
9242	48	2016-05-30 22:46:33.170757	2465
9243	48	2016-05-30 22:46:33.178544	2459
9244	48	2016-05-30 22:46:33.186266	2472
9245	48	2016-05-30 22:46:33.193957	2467
9246	48	2016-05-30 22:46:33.202122	2504
9247	48	2016-05-30 22:46:33.20976	2469
9248	48	2016-05-30 22:46:33.217404	2442
9249	48	2016-05-30 22:46:33.225212	2474
9250	48	2016-05-30 22:46:33.23463	2486
9251	48	2016-05-30 22:46:33.24268	2476
9252	48	2016-05-30 22:46:33.250267	2492
9253	48	2016-05-30 22:46:33.257857	2448
9254	48	2016-05-30 22:46:33.265956	2490
9255	48	2016-05-30 22:46:33.273678	2440
9256	48	2016-05-30 22:46:33.281181	2452
9257	48	2016-05-30 22:46:33.288819	2468
9258	48	2016-05-30 22:46:33.297041	2450
9259	48	2016-05-30 22:46:33.305366	2470
9260	48	2016-05-30 22:46:33.313821	2506
9261	48	2016-05-30 22:46:33.321613	2461
9262	48	2016-05-30 22:46:33.32919	2502
9263	48	2016-05-30 22:46:33.336988	2455
9264	48	2016-05-30 22:46:33.344917	2478
9265	48	2016-05-30 22:46:33.352432	2488
9266	48	2016-05-30 22:46:33.35997	2494
9267	48	2016-05-30 22:46:33.367651	2484
9268	48	2016-05-30 22:46:33.374722	2514
9269	48	2016-05-30 22:46:33.382322	2457
9270	48	2016-05-30 22:46:33.389813	2482
9271	48	2016-05-30 22:46:33.397439	2463
9272	48	2016-05-30 22:46:33.405845	2444
9273	48	2016-05-30 22:46:33.413384	2496
9274	50	2016-05-30 22:46:33.421275	47209
9275	50	2016-05-30 22:46:33.427689	47256
9276	50	2016-05-30 22:46:33.434201	47343
9277	50	2016-05-30 22:46:33.441536	47212
9278	50	2016-05-30 22:46:33.448614	47206
9279	50	2016-05-30 22:46:33.458141	47340
9280	50	2016-05-30 22:46:33.46504	47203
9281	50	2016-05-30 22:46:33.471657	47215
9282	47	2016-05-30 22:46:33.480496	2500
9283	47	2016-05-30 22:46:33.487936	2374
9284	47	2016-05-30 22:46:33.494973	2475
9285	47	2016-05-30 22:46:33.501982	2498
9286	47	2016-05-30 22:46:33.50884	2480
9287	47	2016-05-30 22:46:33.515777	2454
9288	47	2016-05-30 22:46:33.522735	2465
9289	47	2016-05-30 22:46:33.529936	2459
9290	47	2016-05-30 22:46:33.536829	2472
9291	47	2016-05-30 22:46:33.543944	2467
9292	47	2016-05-30 22:46:33.550978	2504
9293	47	2016-05-30 22:46:33.558957	2469
9294	47	2016-05-30 22:46:33.565941	2442
9295	47	2016-05-30 22:46:33.573049	2474
9296	47	2016-05-30 22:46:33.580345	2486
9297	47	2016-05-30 22:46:33.587412	2476
9298	47	2016-05-30 22:46:33.594349	2492
9299	47	2016-05-30 22:46:33.601317	2448
9300	47	2016-05-30 22:46:33.60838	2490
9301	47	2016-05-30 22:46:33.615369	2440
9302	47	2016-05-30 22:46:33.622348	2452
9303	47	2016-05-30 22:46:33.629338	2468
9304	47	2016-05-30 22:46:33.636195	2450
9305	47	2016-05-30 22:46:33.643394	2470
9306	47	2016-05-30 22:46:33.650376	2506
9307	47	2016-05-30 22:46:33.657415	2461
9308	47	2016-05-30 22:46:33.664326	2502
9309	47	2016-05-30 22:46:33.671483	2455
9310	47	2016-05-30 22:46:33.678628	2478
9311	47	2016-05-30 22:46:33.685548	2488
9312	47	2016-05-30 22:46:33.693015	2494
9313	47	2016-05-30 22:46:33.700092	2484
9314	47	2016-05-30 22:46:33.70713	2514
9315	47	2016-05-30 22:46:33.714212	2457
9316	47	2016-05-30 22:46:33.7213	2482
9317	47	2016-05-30 22:46:33.728475	2463
9318	47	2016-05-30 22:46:33.73548	2444
9319	47	2016-05-30 22:46:33.743241	2496
9320	41	2016-05-30 22:47:46.958883	2518
9321	41	2016-05-30 22:47:46.966084	2378
9322	41	2016-05-30 22:47:46.978152	2517
9323	41	2016-05-30 22:47:46.98978	2522
9324	41	2016-05-30 22:47:47.001384	2520
9325	41	2016-05-30 22:47:47.012687	2521
9326	41	2016-05-30 22:47:47.02738	2523
9327	41	2016-05-30 22:47:47.044869	2525
9328	41	2016-05-30 22:47:47.05381	2528
9329	41	2016-05-30 22:47:47.065175	2516
9330	41	2016-05-30 22:47:47.076441	2519
9331	41	2016-05-30 22:47:47.087958	2524
9332	46	2016-05-30 22:47:47.094672	2398
9333	45	2016-05-30 22:47:47.102867	2400
9334	44	2016-05-30 22:47:47.109858	2382
9335	42	2016-05-30 22:47:47.116481	2444
9336	42	2016-05-30 22:47:47.122915	2486
9337	42	2016-05-30 22:47:47.129165	2450
9338	42	2016-05-30 22:47:47.135308	2452
9339	42	2016-05-30 22:47:47.141368	2455
9340	42	2016-05-30 22:47:47.147546	2482
9341	42	2016-05-30 22:47:47.154284	2488
9342	42	2016-05-30 22:47:47.160245	2472
9343	42	2016-05-30 22:47:47.166004	2500
9344	42	2016-05-30 22:47:47.171716	2374
9345	42	2016-05-30 22:47:47.177429	2442
9346	42	2016-05-30 22:47:47.183169	2496
9347	42	2016-05-30 22:47:47.189021	2467
9348	42	2016-05-30 22:47:47.194871	2490
9349	42	2016-05-30 22:47:47.200732	2504
9350	42	2016-05-30 22:47:47.206568	2494
9351	42	2016-05-30 22:47:47.212323	2470
9352	42	2016-05-30 22:47:47.218407	2498
9353	42	2016-05-30 22:47:47.22412	2484
9354	42	2016-05-30 22:47:47.229807	2506
9355	42	2016-05-30 22:47:47.235597	2440
9356	42	2016-05-30 22:47:47.241634	2468
9357	42	2016-05-30 22:47:47.247271	2478
9358	42	2016-05-30 22:47:47.252946	2480
9359	42	2016-05-30 22:47:47.258777	2457
9360	42	2016-05-30 22:47:47.264638	2475
9361	42	2016-05-30 22:47:47.270506	2502
9362	42	2016-05-30 22:47:47.276309	2459
9363	42	2016-05-30 22:47:47.281968	2463
9364	42	2016-05-30 22:47:47.287778	2476
9365	42	2016-05-30 22:47:47.293511	2448
9366	42	2016-05-30 22:47:47.299899	2465
9367	42	2016-05-30 22:47:47.305849	2461
9368	42	2016-05-30 22:47:47.311627	2469
9369	42	2016-05-30 22:47:47.317683	2474
9370	42	2016-05-30 22:47:47.323614	2492
9371	43	2016-05-30 22:47:47.329563	2462
9372	43	2016-05-30 22:47:47.335221	2466
9373	43	2016-05-30 22:47:47.340844	2489
9374	43	2016-05-30 22:47:47.346548	2477
9375	43	2016-05-30 22:47:47.352363	2481
9376	43	2016-05-30 22:47:47.358266	2453
9377	43	2016-05-30 22:47:47.363994	2491
9378	43	2016-05-30 22:47:47.369832	2483
9379	43	2016-05-30 22:47:47.375451	2443
9380	43	2016-05-30 22:47:47.381209	2501
9381	43	2016-05-30 22:47:47.387007	2375
9382	43	2016-05-30 22:47:47.392666	2458
9383	43	2016-05-30 22:47:47.398359	2499
9384	43	2016-05-30 22:47:47.404316	2471
9385	43	2016-05-30 22:47:47.410012	2487
9386	43	2016-05-30 22:47:47.415654	2441
9387	43	2016-05-30 22:47:47.421598	2451
9388	43	2016-05-30 22:47:47.427427	2507
9389	43	2016-05-30 22:47:47.433289	2464
9390	43	2016-05-30 22:47:47.438966	2497
9391	43	2016-05-30 22:47:47.44474	2460
9392	43	2016-05-30 22:47:47.450483	2493
9393	43	2016-05-30 22:47:47.456236	2473
9394	43	2016-05-30 22:47:47.461955	2445
9395	43	2016-05-30 22:47:47.46802	2485
9396	43	2016-05-30 22:47:47.473904	2495
9397	43	2016-05-30 22:47:47.479658	2449
9398	43	2016-05-30 22:47:47.485371	2505
9399	43	2016-05-30 22:47:47.49101	2479
9400	43	2016-05-30 22:47:47.496894	2456
9401	43	2016-05-30 22:47:47.502668	2503
9402	40	2016-05-30 22:47:47.509523	47212
9403	40	2016-05-30 22:47:47.514817	47206
9404	40	2016-05-30 22:47:47.520055	47215
9405	40	2016-05-30 22:47:47.525541	47209
9406	40	2016-05-30 22:47:47.530646	47256
9407	40	2016-05-30 22:47:47.538706	47340
9408	40	2016-05-30 22:47:47.543665	47203
9409	40	2016-05-30 22:47:47.548879	47343
9410	49	2016-05-30 22:47:47.557591	47209
9411	49	2016-05-30 22:47:47.563795	47256
9412	49	2016-05-30 22:47:47.570099	47343
9413	49	2016-05-30 22:47:47.576696	47212
9414	49	2016-05-30 22:47:47.583175	47206
9415	49	2016-05-30 22:47:47.591852	47340
9416	49	2016-05-30 22:47:47.598425	47203
9417	49	2016-05-30 22:47:47.604939	47215
9418	48	2016-05-30 22:47:47.613636	2500
9419	48	2016-05-30 22:47:47.621196	2374
9420	48	2016-05-30 22:47:47.628812	2475
9421	48	2016-05-30 22:47:47.63611	2498
9422	48	2016-05-30 22:47:47.643483	2480
9423	48	2016-05-30 22:47:47.650589	2454
9424	48	2016-05-30 22:47:47.657725	2465
9425	48	2016-05-30 22:47:47.664875	2459
9426	48	2016-05-30 22:47:47.672222	2472
9427	48	2016-05-30 22:47:47.6799	2467
9428	48	2016-05-30 22:47:47.687537	2504
9429	48	2016-05-30 22:47:47.695112	2469
9430	48	2016-05-30 22:47:47.70224	2442
9431	48	2016-05-30 22:47:47.709597	2474
9432	48	2016-05-30 22:47:47.716792	2486
9433	48	2016-05-30 22:47:47.724046	2476
9434	48	2016-05-30 22:47:47.731163	2492
9435	48	2016-05-30 22:47:47.738362	2448
9436	48	2016-05-30 22:47:47.745426	2490
9437	48	2016-05-30 22:47:47.75276	2440
9438	48	2016-05-30 22:47:47.76006	2452
9439	48	2016-05-30 22:47:47.767399	2468
9440	48	2016-05-30 22:47:47.774671	2450
9441	48	2016-05-30 22:47:47.781845	2470
9442	48	2016-05-30 22:47:47.78917	2506
9443	48	2016-05-30 22:47:47.796478	2461
9444	48	2016-05-30 22:47:47.803748	2502
9445	48	2016-05-30 22:47:47.810983	2455
9446	48	2016-05-30 22:47:47.818398	2478
9447	48	2016-05-30 22:47:47.825583	2488
9448	48	2016-05-30 22:47:47.832762	2494
9449	48	2016-05-30 22:47:47.84006	2484
9450	48	2016-05-30 22:47:47.847595	2514
9451	48	2016-05-30 22:47:47.854862	2457
9452	48	2016-05-30 22:47:47.86199	2482
9453	48	2016-05-30 22:47:47.869152	2463
9454	48	2016-05-30 22:47:47.876337	2444
9455	48	2016-05-30 22:47:47.883618	2496
9456	50	2016-05-30 22:47:47.891362	47209
9457	50	2016-05-30 22:47:47.897818	47256
9458	50	2016-05-30 22:47:47.905504	47343
9459	50	2016-05-30 22:47:47.912152	47212
9460	50	2016-05-30 22:47:47.919153	47206
9461	50	2016-05-30 22:47:47.928659	47340
9462	50	2016-05-30 22:47:47.935558	47203
9463	50	2016-05-30 22:47:47.942241	47215
9464	47	2016-05-30 22:47:47.951439	2500
9465	47	2016-05-30 22:47:47.958586	2374
9466	47	2016-05-30 22:47:47.96566	2475
9467	47	2016-05-30 22:47:47.972495	2498
9468	47	2016-05-30 22:47:47.97941	2480
9469	47	2016-05-30 22:47:47.986505	2454
9470	47	2016-05-30 22:47:47.993475	2465
9471	47	2016-05-30 22:47:48.000484	2459
9472	47	2016-05-30 22:47:48.007496	2472
9473	47	2016-05-30 22:47:48.014746	2467
9474	47	2016-05-30 22:47:48.021802	2504
9475	47	2016-05-30 22:47:48.028894	2469
9476	47	2016-05-30 22:47:48.035956	2442
9477	47	2016-05-30 22:47:48.043166	2474
9478	47	2016-05-30 22:47:48.050267	2486
9479	47	2016-05-30 22:47:48.057094	2476
9480	47	2016-05-30 22:47:48.064209	2492
9481	47	2016-05-30 22:47:48.071876	2448
9482	47	2016-05-30 22:47:48.078913	2490
9483	47	2016-05-30 22:47:48.085889	2440
9484	47	2016-05-30 22:47:48.092877	2452
9485	47	2016-05-30 22:47:48.10052	2468
9486	47	2016-05-30 22:47:48.107891	2450
9487	47	2016-05-30 22:47:48.115846	2470
9488	47	2016-05-30 22:47:48.122913	2506
9489	47	2016-05-30 22:47:48.130052	2461
9490	47	2016-05-30 22:47:48.13719	2502
9491	47	2016-05-30 22:47:48.144148	2455
9492	47	2016-05-30 22:47:48.151519	2478
9493	47	2016-05-30 22:47:48.158601	2488
9494	47	2016-05-30 22:47:48.165848	2494
9495	47	2016-05-30 22:47:48.173104	2484
9496	47	2016-05-30 22:47:48.179853	2514
9497	47	2016-05-30 22:47:48.186807	2457
9498	47	2016-05-30 22:47:48.193951	2482
9499	47	2016-05-30 22:47:48.201381	2463
9500	47	2016-05-30 22:47:48.208872	2444
9501	47	2016-05-30 22:47:48.216187	2496
9502	41	2016-05-30 22:49:37.000016	2518
9503	41	2016-05-30 22:49:37.006806	2378
9504	41	2016-05-30 22:49:37.01719	2517
9505	41	2016-05-30 22:49:37.028064	2522
9506	41	2016-05-30 22:49:37.038601	2520
9507	41	2016-05-30 22:49:37.048997	2521
9508	41	2016-05-30 22:49:37.059229	2523
9509	41	2016-05-30 22:49:37.069218	2525
9510	41	2016-05-30 22:49:37.075072	2528
9511	41	2016-05-30 22:49:37.085416	2516
9512	41	2016-05-30 22:49:37.096344	2519
9513	41	2016-05-30 22:49:37.107038	2524
9514	46	2016-05-30 22:49:37.113299	2398
9515	45	2016-05-30 22:49:37.1197	2400
9516	44	2016-05-30 22:49:37.125971	2382
9517	42	2016-05-30 22:49:37.131945	2444
9518	42	2016-05-30 22:49:37.138296	2486
9519	42	2016-05-30 22:49:37.144318	2450
9520	42	2016-05-30 22:49:37.150261	2452
9521	42	2016-05-30 22:49:37.156103	2455
9522	42	2016-05-30 22:49:37.161685	2482
9523	42	2016-05-30 22:49:37.167564	2488
9524	42	2016-05-30 22:49:37.173442	2472
9525	42	2016-05-30 22:49:37.179233	2500
9526	42	2016-05-30 22:49:37.184915	2374
9527	42	2016-05-30 22:49:37.190642	2442
9528	42	2016-05-30 22:49:37.19628	2496
9529	42	2016-05-30 22:49:37.202049	2467
9530	42	2016-05-30 22:49:37.207898	2490
9531	42	2016-05-30 22:49:37.21372	2504
9532	42	2016-05-30 22:49:37.219633	2494
9533	42	2016-05-30 22:49:37.225441	2470
9534	42	2016-05-30 22:49:37.231194	2498
9535	42	2016-05-30 22:49:37.237386	2484
9536	42	2016-05-30 22:49:37.243643	2506
9537	42	2016-05-30 22:49:37.24945	2440
9538	42	2016-05-30 22:49:37.255592	2468
9539	42	2016-05-30 22:49:37.261474	2478
9540	42	2016-05-30 22:49:37.267284	2480
9541	42	2016-05-30 22:49:37.273268	2457
9542	42	2016-05-30 22:49:37.279056	2475
9543	42	2016-05-30 22:49:37.284944	2502
9544	42	2016-05-30 22:49:37.29144	2459
9545	42	2016-05-30 22:49:37.298057	2463
9546	42	2016-05-30 22:49:37.304078	2476
9547	42	2016-05-30 22:49:37.310002	2448
9548	42	2016-05-30 22:49:37.315973	2465
9549	42	2016-05-30 22:49:37.322195	2461
9550	42	2016-05-30 22:49:37.328386	2469
9551	42	2016-05-30 22:49:37.334186	2474
9552	42	2016-05-30 22:49:37.340157	2492
9553	43	2016-05-30 22:49:37.346281	2462
9554	43	2016-05-30 22:49:37.352015	2466
9555	43	2016-05-30 22:49:37.358348	2489
9556	43	2016-05-30 22:49:37.364164	2477
9557	43	2016-05-30 22:49:37.369812	2481
9558	43	2016-05-30 22:49:37.375531	2453
9559	43	2016-05-30 22:49:37.381186	2491
9560	43	2016-05-30 22:49:37.386845	2483
9561	43	2016-05-30 22:49:37.392663	2443
9562	43	2016-05-30 22:49:37.398409	2501
9563	43	2016-05-30 22:49:37.404127	2375
9564	43	2016-05-30 22:49:37.40994	2458
9565	43	2016-05-30 22:49:37.415758	2499
9566	43	2016-05-30 22:49:37.421468	2471
9567	43	2016-05-30 22:49:37.427044	2487
9568	43	2016-05-30 22:49:37.43309	2441
9569	43	2016-05-30 22:49:37.438686	2451
9570	43	2016-05-30 22:49:37.444411	2507
9571	43	2016-05-30 22:49:37.450276	2464
9572	43	2016-05-30 22:49:37.456068	2497
9573	43	2016-05-30 22:49:37.46169	2460
9574	43	2016-05-30 22:49:37.46753	2493
9575	43	2016-05-30 22:49:37.473312	2473
9576	43	2016-05-30 22:49:37.479149	2445
9577	43	2016-05-30 22:49:37.484903	2485
9578	43	2016-05-30 22:49:37.490745	2495
9579	43	2016-05-30 22:49:37.496325	2449
9580	43	2016-05-30 22:49:37.502106	2505
9581	43	2016-05-30 22:49:37.507864	2479
9582	43	2016-05-30 22:49:37.513683	2456
9583	43	2016-05-30 22:49:37.519367	2503
9584	40	2016-05-30 22:49:37.526313	47212
9585	40	2016-05-30 22:49:37.531434	47206
9586	40	2016-05-30 22:49:37.536687	47215
9587	40	2016-05-30 22:49:37.542319	47209
9588	40	2016-05-30 22:49:37.547556	47256
9589	40	2016-05-30 22:49:37.555952	47340
9590	40	2016-05-30 22:49:37.561153	47203
9591	40	2016-05-30 22:49:37.566224	47343
9592	49	2016-05-30 22:49:37.574484	47209
9593	49	2016-05-30 22:49:37.580915	47256
9594	49	2016-05-30 22:49:37.587099	47343
9595	49	2016-05-30 22:49:37.593936	47212
9596	49	2016-05-30 22:49:37.600881	47206
9597	49	2016-05-30 22:49:37.610105	47340
9598	49	2016-05-30 22:49:37.617272	47203
9599	49	2016-05-30 22:49:37.62417	47215
9600	48	2016-05-30 22:49:37.633337	2500
9601	48	2016-05-30 22:49:37.6408	2374
9602	48	2016-05-30 22:49:37.648413	2475
9603	48	2016-05-30 22:49:37.655713	2498
9604	48	2016-05-30 22:49:37.663191	2480
9605	48	2016-05-30 22:49:37.670296	2454
9606	48	2016-05-30 22:49:37.677611	2465
9607	48	2016-05-30 22:49:37.68478	2459
9608	48	2016-05-30 22:49:37.692458	2472
9609	48	2016-05-30 22:49:37.699741	2467
9610	48	2016-05-30 22:49:37.706987	2504
9611	48	2016-05-30 22:49:37.714225	2469
9612	48	2016-05-30 22:49:37.721451	2442
9613	48	2016-05-30 22:49:37.728789	2474
9614	48	2016-05-30 22:49:37.736168	2486
9615	48	2016-05-30 22:49:37.743561	2476
9616	48	2016-05-30 22:49:37.750838	2492
9617	48	2016-05-30 22:49:37.758065	2448
9618	48	2016-05-30 22:49:37.765384	2490
9619	48	2016-05-30 22:49:37.77326	2440
9620	48	2016-05-30 22:49:37.780406	2452
9621	48	2016-05-30 22:49:37.787637	2468
9622	48	2016-05-30 22:49:37.795454	2450
9623	48	2016-05-30 22:49:37.802799	2470
9624	48	2016-05-30 22:49:37.810201	2506
9625	48	2016-05-30 22:49:37.817601	2461
9626	48	2016-05-30 22:49:37.825098	2502
9627	48	2016-05-30 22:49:37.832289	2455
9628	48	2016-05-30 22:49:37.839761	2478
9629	48	2016-05-30 22:49:37.846952	2488
9630	48	2016-05-30 22:49:37.854209	2494
9631	48	2016-05-30 22:49:37.861651	2484
9632	48	2016-05-30 22:49:37.868599	2514
9633	48	2016-05-30 22:49:37.875848	2457
9634	48	2016-05-30 22:49:37.883046	2482
9635	48	2016-05-30 22:49:37.890574	2463
9636	48	2016-05-30 22:49:37.897882	2444
9637	48	2016-05-30 22:49:37.905183	2496
9638	50	2016-05-30 22:49:37.913123	47209
9639	50	2016-05-30 22:49:37.919667	47256
9640	50	2016-05-30 22:49:37.926179	47343
9641	50	2016-05-30 22:49:37.932864	47212
9642	50	2016-05-30 22:49:37.939662	47206
9643	50	2016-05-30 22:49:37.949039	47340
9644	50	2016-05-30 22:49:37.956007	47203
9645	50	2016-05-30 22:49:37.962914	47215
9646	47	2016-05-30 22:49:37.971665	2500
9647	47	2016-05-30 22:49:37.978746	2374
9648	47	2016-05-30 22:49:37.985893	2475
9649	47	2016-05-30 22:49:37.993013	2498
9650	47	2016-05-30 22:49:37.999936	2480
9651	47	2016-05-30 22:49:38.006947	2454
9652	47	2016-05-30 22:49:38.014044	2465
9653	47	2016-05-30 22:49:38.021058	2459
9654	47	2016-05-30 22:49:38.028201	2472
9655	47	2016-05-30 22:49:38.03563	2467
9656	47	2016-05-30 22:49:38.042861	2504
9657	47	2016-05-30 22:49:38.050106	2469
9658	47	2016-05-30 22:49:38.05746	2442
9659	47	2016-05-30 22:49:38.064635	2474
9660	47	2016-05-30 22:49:38.07204	2486
9661	47	2016-05-30 22:49:38.079109	2476
9662	47	2016-05-30 22:49:38.086186	2492
9663	47	2016-05-30 22:49:38.093215	2448
9664	47	2016-05-30 22:49:38.100534	2490
9665	47	2016-05-30 22:49:38.107726	2440
9666	47	2016-05-30 22:49:38.11474	2452
9667	47	2016-05-30 22:49:38.122009	2468
9668	47	2016-05-30 22:49:38.128962	2450
9669	47	2016-05-30 22:49:38.135944	2470
9670	47	2016-05-30 22:49:38.143022	2506
9671	47	2016-05-30 22:49:38.15015	2461
9672	47	2016-05-30 22:49:38.157509	2502
9673	47	2016-05-30 22:49:38.16455	2455
9674	47	2016-05-30 22:49:38.171614	2478
9675	47	2016-05-30 22:49:38.178583	2488
9676	47	2016-05-30 22:49:38.185755	2494
9677	47	2016-05-30 22:49:38.192817	2484
9678	47	2016-05-30 22:49:38.199692	2514
9679	47	2016-05-30 22:49:38.206798	2457
9680	47	2016-05-30 22:49:38.213841	2482
9681	47	2016-05-30 22:49:38.221001	2463
9682	47	2016-05-30 22:49:38.228092	2444
9683	47	2016-05-30 22:49:38.235141	2496
9684	41	2016-05-30 23:00:01.497613	2518
9685	41	2016-05-30 23:00:01.505004	2378
9686	41	2016-05-30 23:00:01.517772	2517
9687	41	2016-05-30 23:00:01.53151	2522
9688	41	2016-05-30 23:00:01.547556	2520
9689	41	2016-05-30 23:00:01.561917	2521
9690	41	2016-05-30 23:00:01.576109	2523
9691	41	2016-05-30 23:00:01.589178	2525
9692	41	2016-05-30 23:00:01.596092	2528
9693	41	2016-05-30 23:00:01.610006	2516
9694	41	2016-05-30 23:00:01.622563	2519
9695	41	2016-05-30 23:00:01.634436	2524
9696	46	2016-05-30 23:00:01.643218	2398
9697	45	2016-05-30 23:00:01.649974	2400
9698	44	2016-05-30 23:00:01.656979	2382
9699	42	2016-05-30 23:00:01.664148	2444
9700	42	2016-05-30 23:00:01.670486	2486
9701	42	2016-05-30 23:00:01.678008	2450
9702	42	2016-05-30 23:00:01.685512	2452
9703	42	2016-05-30 23:00:01.695323	2455
9704	42	2016-05-30 23:00:01.704358	2482
9705	42	2016-05-30 23:00:01.711528	2488
9706	42	2016-05-30 23:00:01.717625	2472
9707	42	2016-05-30 23:00:01.724063	2500
9708	42	2016-05-30 23:00:01.729962	2374
9709	42	2016-05-30 23:00:01.736265	2442
9710	42	2016-05-30 23:00:01.743861	2496
9711	42	2016-05-30 23:00:01.750025	2467
9712	42	2016-05-30 23:00:01.756402	2490
9713	42	2016-05-30 23:00:01.762819	2504
9714	42	2016-05-30 23:00:01.768743	2494
9715	42	2016-05-30 23:00:01.775301	2470
9716	42	2016-05-30 23:00:01.78125	2498
9717	42	2016-05-30 23:00:01.787546	2484
9718	42	2016-05-30 23:00:01.794024	2506
9719	42	2016-05-30 23:00:01.801105	2440
9720	42	2016-05-30 23:00:01.807901	2468
9721	42	2016-05-30 23:00:01.813805	2478
9722	42	2016-05-30 23:00:01.819743	2480
9723	42	2016-05-30 23:00:01.826096	2457
9724	42	2016-05-30 23:00:01.832193	2475
9725	42	2016-05-30 23:00:01.838263	2502
9726	42	2016-05-30 23:00:01.844611	2459
9727	42	2016-05-30 23:00:01.850409	2463
9728	42	2016-05-30 23:00:01.85678	2476
9729	42	2016-05-30 23:00:01.862684	2448
9730	42	2016-05-30 23:00:01.868594	2465
9731	42	2016-05-30 23:00:01.875165	2461
9732	42	2016-05-30 23:00:01.881177	2469
9733	42	2016-05-30 23:00:01.887223	2474
9734	42	2016-05-30 23:00:01.893454	2492
9735	43	2016-05-30 23:00:01.899755	2462
9736	43	2016-05-30 23:00:01.906038	2466
9737	43	2016-05-30 23:00:01.912305	2489
9738	43	2016-05-30 23:00:01.918173	2477
9739	43	2016-05-30 23:00:01.92519	2481
9740	43	2016-05-30 23:00:01.931041	2453
9741	43	2016-05-30 23:00:01.936985	2491
9742	43	2016-05-30 23:00:01.943301	2483
9743	43	2016-05-30 23:00:01.94904	2443
9744	43	2016-05-30 23:00:01.955229	2501
9745	43	2016-05-30 23:00:01.961495	2375
9746	43	2016-05-30 23:00:01.967304	2458
9747	43	2016-05-30 23:00:01.973982	2499
9748	43	2016-05-30 23:00:01.979834	2471
9749	43	2016-05-30 23:00:01.985818	2487
9750	43	2016-05-30 23:00:01.992423	2441
9751	43	2016-05-30 23:00:01.998771	2451
9752	43	2016-05-30 23:00:02.006483	2507
9753	43	2016-05-30 23:00:02.012935	2464
9754	43	2016-05-30 23:00:02.019139	2497
9755	43	2016-05-30 23:00:02.026669	2460
9756	43	2016-05-30 23:00:02.032989	2493
9757	43	2016-05-30 23:00:02.039361	2473
9758	43	2016-05-30 23:00:02.04938	2445
9759	43	2016-05-30 23:00:02.056777	2485
9760	43	2016-05-30 23:00:02.063049	2495
9761	43	2016-05-30 23:00:02.069521	2449
9762	43	2016-05-30 23:00:02.077541	2505
9763	43	2016-05-30 23:00:02.085333	2479
9764	43	2016-05-30 23:00:02.092795	2456
9765	43	2016-05-30 23:00:02.099164	2503
9766	40	2016-05-30 23:00:02.107939	47212
9767	40	2016-05-30 23:00:02.114475	47206
9768	40	2016-05-30 23:00:02.140916	47215
9769	40	2016-05-30 23:00:02.148793	47209
9770	40	2016-05-30 23:00:02.156161	47256
9771	40	2016-05-30 23:00:02.16572	47340
9772	40	2016-05-30 23:00:02.174252	47203
9773	40	2016-05-30 23:00:02.180278	47343
9774	49	2016-05-30 23:00:02.191262	47209
9775	49	2016-05-30 23:00:02.1983	47256
9776	49	2016-05-30 23:00:02.207274	47343
9777	49	2016-05-30 23:00:02.214406	47212
9778	49	2016-05-30 23:00:02.22249	47206
9779	49	2016-05-30 23:00:02.232904	47340
9780	49	2016-05-30 23:00:02.24101	47203
9781	49	2016-05-30 23:00:02.248053	47215
9782	48	2016-05-30 23:00:02.258906	2500
9783	48	2016-05-30 23:00:02.267029	2374
9784	48	2016-05-30 23:00:02.278046	2475
9785	48	2016-05-30 23:00:02.287893	2498
9786	48	2016-05-30 23:00:02.296314	2480
9787	48	2016-05-30 23:00:02.304025	2454
9788	48	2016-05-30 23:00:02.313292	2465
9789	48	2016-05-30 23:00:02.321186	2459
9790	48	2016-05-30 23:00:02.329049	2472
9791	48	2016-05-30 23:00:02.337804	2467
9792	48	2016-05-30 23:00:02.345765	2504
9793	48	2016-05-30 23:00:02.353843	2469
9794	48	2016-05-30 23:00:02.361619	2442
9795	48	2016-05-30 23:00:02.369569	2474
9796	48	2016-05-30 23:00:02.377286	2486
9797	48	2016-05-30 23:00:02.385261	2476
9798	48	2016-05-30 23:00:02.393078	2492
9799	48	2016-05-30 23:00:02.401329	2448
9800	48	2016-05-30 23:00:02.409111	2490
9801	48	2016-05-30 23:00:02.418558	2440
9802	48	2016-05-30 23:00:02.426311	2452
9803	48	2016-05-30 23:00:02.434127	2468
9804	48	2016-05-30 23:00:02.44187	2450
9805	48	2016-05-30 23:00:02.4499	2470
9806	48	2016-05-30 23:00:02.458028	2506
9807	48	2016-05-30 23:00:02.466096	2461
9808	48	2016-05-30 23:00:02.474097	2502
9809	48	2016-05-30 23:00:02.482176	2455
9810	48	2016-05-30 23:00:02.490701	2478
9811	48	2016-05-30 23:00:02.498692	2488
9812	48	2016-05-30 23:00:02.506392	2494
9813	48	2016-05-30 23:00:02.514287	2484
9814	48	2016-05-30 23:00:02.522364	2514
9815	48	2016-05-30 23:00:02.530331	2457
9816	48	2016-05-30 23:00:02.538318	2482
9817	48	2016-05-30 23:00:02.547306	2463
9818	48	2016-05-30 23:00:02.555269	2444
9819	48	2016-05-30 23:00:02.563031	2496
9820	50	2016-05-30 23:00:02.572237	47209
9821	50	2016-05-30 23:00:02.579205	47256
9822	50	2016-05-30 23:00:02.58574	47343
9823	50	2016-05-30 23:00:02.592618	47212
9824	50	2016-05-30 23:00:02.599469	47206
9825	50	2016-05-30 23:00:02.609286	47340
9826	50	2016-05-30 23:00:02.617401	47203
9827	50	2016-05-30 23:00:02.624404	47215
9828	47	2016-05-30 23:00:02.633464	2500
9829	47	2016-05-30 23:00:02.640831	2374
9830	47	2016-05-30 23:00:02.648	2475
9831	47	2016-05-30 23:00:02.655651	2498
9832	47	2016-05-30 23:00:02.663252	2480
9833	47	2016-05-30 23:00:02.670733	2454
9834	47	2016-05-30 23:00:02.677966	2465
9835	47	2016-05-30 23:00:02.685175	2459
9836	47	2016-05-30 23:00:02.692454	2472
9837	47	2016-05-30 23:00:02.699699	2467
9838	47	2016-05-30 23:00:02.70731	2504
9839	47	2016-05-30 23:00:02.714479	2469
9840	47	2016-05-30 23:00:02.721665	2442
9841	47	2016-05-30 23:00:02.728898	2474
9842	47	2016-05-30 23:00:02.736072	2486
9843	47	2016-05-30 23:00:02.743224	2476
9844	47	2016-05-30 23:00:02.750341	2492
9845	47	2016-05-30 23:00:02.757515	2448
9846	47	2016-05-30 23:00:02.764612	2490
9847	47	2016-05-30 23:00:02.771878	2440
9848	47	2016-05-30 23:00:02.779069	2452
9849	47	2016-05-30 23:00:02.786476	2468
9850	47	2016-05-30 23:00:02.793663	2450
9851	47	2016-05-30 23:00:02.800939	2470
9852	47	2016-05-30 23:00:02.808096	2506
9853	47	2016-05-30 23:00:02.815138	2461
9854	47	2016-05-30 23:00:02.822662	2502
9855	47	2016-05-30 23:00:02.829922	2455
9856	47	2016-05-30 23:00:02.837142	2478
9857	47	2016-05-30 23:00:02.844097	2488
9858	47	2016-05-30 23:00:02.851814	2494
9859	47	2016-05-30 23:00:02.858742	2484
9860	47	2016-05-30 23:00:02.865703	2514
9861	47	2016-05-30 23:00:02.872993	2457
9862	47	2016-05-30 23:00:02.880041	2482
9863	47	2016-05-30 23:00:02.887208	2463
9864	47	2016-05-30 23:00:02.894221	2444
9865	47	2016-05-30 23:00:02.901505	2496
9866	41	2016-05-30 23:19:09.123789	2518
9867	41	2016-05-30 23:19:09.130162	2378
9868	41	2016-05-30 23:19:09.14143	2517
9869	41	2016-05-30 23:19:09.153153	2522
9870	41	2016-05-30 23:19:09.164547	2520
9871	41	2016-05-30 23:19:09.175886	2521
9872	41	2016-05-30 23:19:09.186898	2523
9873	41	2016-05-30 23:19:09.197724	2525
9874	41	2016-05-30 23:19:09.204237	2528
9875	41	2016-05-30 23:19:09.214926	2516
9876	41	2016-05-30 23:19:09.226488	2519
9877	41	2016-05-30 23:19:09.237212	2524
9878	46	2016-05-30 23:19:09.243532	2398
9879	45	2016-05-30 23:19:09.25054	2400
9880	44	2016-05-30 23:19:09.256858	2382
9881	42	2016-05-30 23:19:09.263059	2444
9882	42	2016-05-30 23:19:09.268995	2486
9883	42	2016-05-30 23:19:09.27493	2450
9884	42	2016-05-30 23:19:09.280594	2452
9885	42	2016-05-30 23:19:09.286254	2455
9886	42	2016-05-30 23:19:09.291947	2482
9887	42	2016-05-30 23:19:09.297587	2488
9888	42	2016-05-30 23:19:09.303641	2472
9889	42	2016-05-30 23:19:09.30931	2500
9890	42	2016-05-30 23:19:09.31521	2374
9891	42	2016-05-30 23:19:09.321011	2442
9892	42	2016-05-30 23:19:09.326816	2496
9893	42	2016-05-30 23:19:09.332856	2467
9894	42	2016-05-30 23:19:09.338831	2490
9895	42	2016-05-30 23:19:09.344668	2504
9896	42	2016-05-30 23:19:09.350497	2494
9897	42	2016-05-30 23:19:09.356605	2470
9898	42	2016-05-30 23:19:09.362535	2498
9899	42	2016-05-30 23:19:09.368372	2484
9900	42	2016-05-30 23:19:09.374199	2506
9901	42	2016-05-30 23:19:09.380134	2440
9902	42	2016-05-30 23:19:09.386142	2468
9903	42	2016-05-30 23:19:09.392236	2478
9904	42	2016-05-30 23:19:09.39806	2480
9905	42	2016-05-30 23:19:09.404029	2457
9906	42	2016-05-30 23:19:09.409891	2475
9907	42	2016-05-30 23:19:09.41569	2502
9908	42	2016-05-30 23:19:09.421815	2459
9909	42	2016-05-30 23:19:09.427702	2463
9910	42	2016-05-30 23:19:09.43357	2476
9911	42	2016-05-30 23:19:09.439573	2448
9912	42	2016-05-30 23:19:09.44538	2465
9913	42	2016-05-30 23:19:09.451248	2461
9914	42	2016-05-30 23:19:09.457265	2469
9915	42	2016-05-30 23:19:09.463188	2474
9916	42	2016-05-30 23:19:09.469055	2492
9917	43	2016-05-30 23:19:09.475294	2462
9918	43	2016-05-30 23:19:09.481	2466
9919	43	2016-05-30 23:19:09.487183	2489
9920	43	2016-05-30 23:19:09.493182	2477
9921	43	2016-05-30 23:19:09.498912	2481
9922	43	2016-05-30 23:19:09.504682	2453
9923	43	2016-05-30 23:19:09.510479	2491
9924	43	2016-05-30 23:19:09.51629	2483
9925	43	2016-05-30 23:19:09.522229	2443
9926	43	2016-05-30 23:19:09.52796	2501
9927	43	2016-05-30 23:19:09.533809	2375
9928	43	2016-05-30 23:19:09.539831	2458
9929	43	2016-05-30 23:19:09.54562	2499
9930	43	2016-05-30 23:19:09.551375	2471
9931	43	2016-05-30 23:19:09.557092	2487
9932	43	2016-05-30 23:19:09.563001	2441
9933	43	2016-05-30 23:19:09.568745	2451
9934	43	2016-05-30 23:19:09.574558	2507
9935	43	2016-05-30 23:19:09.580465	2464
9936	43	2016-05-30 23:19:09.586205	2497
9937	43	2016-05-30 23:19:09.592009	2460
9938	43	2016-05-30 23:19:09.59771	2493
9939	43	2016-05-30 23:19:09.604333	2473
9940	43	2016-05-30 23:19:09.610343	2445
9941	43	2016-05-30 23:19:09.616136	2485
9942	43	2016-05-30 23:19:09.622006	2495
9943	43	2016-05-30 23:19:09.627808	2449
9944	43	2016-05-30 23:19:09.63377	2505
9945	43	2016-05-30 23:19:09.639757	2479
9946	43	2016-05-30 23:19:09.645603	2456
9947	43	2016-05-30 23:19:09.651564	2503
9948	40	2016-05-30 23:19:09.658604	47212
9949	40	2016-05-30 23:19:09.664148	47206
9950	40	2016-05-30 23:19:09.669745	47215
9951	40	2016-05-30 23:19:09.675402	47209
9952	40	2016-05-30 23:19:09.680883	47256
9953	40	2016-05-30 23:19:09.689597	47340
9954	40	2016-05-30 23:19:09.694844	47203
9955	40	2016-05-30 23:19:09.70065	47343
9956	49	2016-05-30 23:19:09.70943	47209
9957	49	2016-05-30 23:19:09.716463	47256
9958	49	2016-05-30 23:19:09.723132	47343
9959	49	2016-05-30 23:19:09.729892	47212
9960	49	2016-05-30 23:19:09.737073	47206
9961	49	2016-05-30 23:19:09.74722	47340
9962	49	2016-05-30 23:19:09.754359	47203
9963	49	2016-05-30 23:19:09.761138	47215
9964	48	2016-05-30 23:19:09.770464	2500
9965	48	2016-05-30 23:19:09.77807	2374
9966	48	2016-05-30 23:19:09.786132	2475
9967	48	2016-05-30 23:19:09.793639	2498
9968	48	2016-05-30 23:19:09.801492	2480
9969	48	2016-05-30 23:19:09.808933	2454
9970	48	2016-05-30 23:19:09.816714	2465
9971	48	2016-05-30 23:19:09.824515	2459
9972	48	2016-05-30 23:19:09.831943	2472
9973	48	2016-05-30 23:19:09.839742	2467
9974	48	2016-05-30 23:19:09.847275	2504
9975	48	2016-05-30 23:19:09.854683	2469
9976	48	2016-05-30 23:19:09.862238	2442
9977	48	2016-05-30 23:19:09.870415	2474
9978	48	2016-05-30 23:19:09.878014	2486
9979	48	2016-05-30 23:19:09.885343	2476
9980	48	2016-05-30 23:19:09.892807	2492
9981	48	2016-05-30 23:19:09.900445	2448
9982	48	2016-05-30 23:19:09.908007	2490
9983	48	2016-05-30 23:19:09.915627	2440
9984	48	2016-05-30 23:19:09.923276	2452
9985	48	2016-05-30 23:19:09.931147	2468
9986	48	2016-05-30 23:19:09.939179	2450
9987	48	2016-05-30 23:19:09.946928	2470
9988	48	2016-05-30 23:19:09.954537	2506
9989	48	2016-05-30 23:19:09.962019	2461
9990	48	2016-05-30 23:19:09.970273	2502
9991	48	2016-05-30 23:19:09.978056	2455
9992	48	2016-05-30 23:19:09.9857	2478
9993	48	2016-05-30 23:19:09.993251	2488
9994	48	2016-05-30 23:19:10.001015	2494
9995	48	2016-05-30 23:19:10.008694	2484
9996	48	2016-05-30 23:19:10.016054	2514
9997	48	2016-05-30 23:19:10.023568	2457
9998	48	2016-05-30 23:19:10.031049	2482
9999	48	2016-05-30 23:19:10.038546	2463
10000	48	2016-05-30 23:19:10.045965	2444
10001	48	2016-05-30 23:19:10.053453	2496
10002	50	2016-05-30 23:19:10.062228	47209
10003	50	2016-05-30 23:19:10.069083	47256
10004	50	2016-05-30 23:19:10.075847	47343
10005	50	2016-05-30 23:19:10.083538	47212
10006	50	2016-05-30 23:19:10.090695	47206
10007	50	2016-05-30 23:19:10.10018	47340
10008	50	2016-05-30 23:19:10.107162	47203
10009	50	2016-05-30 23:19:10.114327	47215
10010	47	2016-05-30 23:19:10.12355	2500
10011	47	2016-05-30 23:19:10.130889	2374
10012	47	2016-05-30 23:19:10.138322	2475
10013	47	2016-05-30 23:19:10.145424	2498
10014	47	2016-05-30 23:19:10.152717	2480
10015	47	2016-05-30 23:19:10.159931	2454
10016	47	2016-05-30 23:19:10.167164	2465
10017	47	2016-05-30 23:19:10.174438	2459
10018	47	2016-05-30 23:19:10.181507	2472
10019	47	2016-05-30 23:19:10.188752	2467
10020	47	2016-05-30 23:19:10.195897	2504
10021	47	2016-05-30 23:19:10.203315	2469
10022	47	2016-05-30 23:19:10.210573	2442
10023	47	2016-05-30 23:19:10.217877	2474
10024	47	2016-05-30 23:19:10.225201	2486
10025	47	2016-05-30 23:19:10.232452	2476
10026	47	2016-05-30 23:19:10.240037	2492
10027	47	2016-05-30 23:19:10.247288	2448
10028	47	2016-05-30 23:19:10.255073	2490
10029	47	2016-05-30 23:19:10.262361	2440
10030	47	2016-05-30 23:19:10.269814	2452
10031	47	2016-05-30 23:19:10.277288	2468
10032	47	2016-05-30 23:19:10.284648	2450
10033	47	2016-05-30 23:19:10.29193	2470
10034	47	2016-05-30 23:19:10.299206	2506
10035	47	2016-05-30 23:19:10.306478	2461
10036	47	2016-05-30 23:19:10.313987	2502
10037	47	2016-05-30 23:19:10.321539	2455
10038	47	2016-05-30 23:19:10.328847	2478
10039	47	2016-05-30 23:19:10.33606	2488
10040	47	2016-05-30 23:19:10.343268	2494
10041	47	2016-05-30 23:19:10.350499	2484
10042	47	2016-05-30 23:19:10.357491	2514
10043	47	2016-05-30 23:19:10.364786	2457
10044	47	2016-05-30 23:19:10.371979	2482
10045	47	2016-05-30 23:19:10.379152	2463
10046	47	2016-05-30 23:19:10.386631	2444
10047	47	2016-05-30 23:19:10.39402	2496
10048	41	2016-05-30 23:28:15.704942	2518
10049	41	2016-05-30 23:28:15.71163	2378
10050	41	2016-05-30 23:28:15.722254	2517
10051	41	2016-05-30 23:28:15.732561	2522
10052	41	2016-05-30 23:28:15.742992	2520
10053	41	2016-05-30 23:28:15.753531	2521
10054	41	2016-05-30 23:28:15.763881	2523
10055	41	2016-05-30 23:28:15.773918	2525
10056	41	2016-05-30 23:28:15.779998	2528
10057	41	2016-05-30 23:28:15.790623	2516
10058	41	2016-05-30 23:28:15.800998	2519
10059	41	2016-05-30 23:28:15.811476	2524
10060	46	2016-05-30 23:28:15.818123	2398
10061	45	2016-05-30 23:28:15.824438	2400
10062	44	2016-05-30 23:28:15.830771	2382
10063	42	2016-05-30 23:28:15.837238	2444
10064	42	2016-05-30 23:28:15.843273	2486
10065	42	2016-05-30 23:28:15.84919	2450
10066	42	2016-05-30 23:28:15.855308	2452
10067	42	2016-05-30 23:28:15.861234	2455
10068	42	2016-05-30 23:28:15.867218	2482
10069	42	2016-05-30 23:28:15.873136	2488
10070	42	2016-05-30 23:28:15.879122	2472
10071	42	2016-05-30 23:28:15.885243	2500
10072	42	2016-05-30 23:28:15.890981	2374
10073	42	2016-05-30 23:28:15.896834	2442
10074	42	2016-05-30 23:28:15.903354	2496
10075	42	2016-05-30 23:28:15.909343	2467
10076	42	2016-05-30 23:28:15.915079	2490
10077	42	2016-05-30 23:28:15.921534	2504
10078	42	2016-05-30 23:28:15.927416	2494
10079	42	2016-05-30 23:28:15.933312	2470
10080	42	2016-05-30 23:28:15.939274	2498
10081	42	2016-05-30 23:28:15.945227	2484
10082	42	2016-05-30 23:28:15.951656	2506
10083	42	2016-05-30 23:28:15.957611	2440
10084	42	2016-05-30 23:28:15.96363	2468
10085	42	2016-05-30 23:28:15.969557	2478
10086	42	2016-05-30 23:28:15.975959	2480
10087	42	2016-05-30 23:28:15.981965	2457
10088	42	2016-05-30 23:28:15.988642	2475
10089	42	2016-05-30 23:28:15.99465	2502
10090	42	2016-05-30 23:28:16.00061	2459
10091	42	2016-05-30 23:28:16.006523	2463
10092	42	2016-05-30 23:28:16.012875	2476
10093	42	2016-05-30 23:28:16.019549	2448
10094	42	2016-05-30 23:28:16.025394	2465
10095	42	2016-05-30 23:28:16.031599	2461
10096	42	2016-05-30 23:28:16.0377	2469
10097	42	2016-05-30 23:28:16.044079	2474
10098	42	2016-05-30 23:28:16.050535	2492
10099	43	2016-05-30 23:28:16.056712	2462
10100	43	2016-05-30 23:28:16.063028	2466
10101	43	2016-05-30 23:28:16.069102	2489
10102	43	2016-05-30 23:28:16.075061	2477
10103	43	2016-05-30 23:28:16.081334	2481
10104	43	2016-05-30 23:28:16.087577	2453
10105	43	2016-05-30 23:28:16.093687	2491
10106	43	2016-05-30 23:28:16.100342	2483
10107	43	2016-05-30 23:28:16.106219	2443
10108	43	2016-05-30 23:28:16.112055	2501
10109	43	2016-05-30 23:28:16.117824	2375
10110	43	2016-05-30 23:28:16.123653	2458
10111	43	2016-05-30 23:28:16.129481	2499
10112	43	2016-05-30 23:28:16.135357	2471
10113	43	2016-05-30 23:28:16.141254	2487
10114	43	2016-05-30 23:28:16.147458	2441
10115	43	2016-05-30 23:28:16.153366	2451
10116	43	2016-05-30 23:28:16.159276	2507
10117	43	2016-05-30 23:28:16.165345	2464
10118	43	2016-05-30 23:28:16.171399	2497
10119	43	2016-05-30 23:28:16.17724	2460
10120	43	2016-05-30 23:28:16.183177	2493
10121	43	2016-05-30 23:28:16.189214	2473
10122	43	2016-05-30 23:28:16.195179	2445
10123	43	2016-05-30 23:28:16.201147	2485
10124	43	2016-05-30 23:28:16.206976	2495
10125	43	2016-05-30 23:28:16.21275	2449
10126	43	2016-05-30 23:28:16.218771	2505
10127	43	2016-05-30 23:28:16.224578	2479
10128	43	2016-05-30 23:28:16.230411	2456
10129	43	2016-05-30 23:28:16.237117	2503
10130	40	2016-05-30 23:28:16.244168	47212
10131	40	2016-05-30 23:28:16.249647	47206
10132	40	2016-05-30 23:28:16.255097	47215
10133	40	2016-05-30 23:28:16.260716	47209
10134	40	2016-05-30 23:28:16.266091	47256
10135	40	2016-05-30 23:28:16.275485	47340
10136	40	2016-05-30 23:28:16.280858	47203
10137	40	2016-05-30 23:28:16.28693	47343
10138	49	2016-05-30 23:28:16.295489	47209
10139	49	2016-05-30 23:28:16.302461	47256
10140	49	2016-05-30 23:28:16.309076	47343
10141	49	2016-05-30 23:28:16.31626	47212
10142	49	2016-05-30 23:28:16.323098	47206
10143	49	2016-05-30 23:28:16.334034	47340
10144	49	2016-05-30 23:28:16.340849	47203
10145	49	2016-05-30 23:28:16.347633	47215
10146	48	2016-05-30 23:28:16.357435	2500
10147	48	2016-05-30 23:28:16.365204	2374
10148	48	2016-05-30 23:28:16.372813	2475
10149	48	2016-05-30 23:28:16.380597	2498
10150	48	2016-05-30 23:28:16.388498	2480
10151	48	2016-05-30 23:28:16.395702	2454
10152	48	2016-05-30 23:28:16.403754	2465
10153	48	2016-05-30 23:28:16.411384	2459
10154	48	2016-05-30 23:28:16.419232	2472
10155	48	2016-05-30 23:28:16.427066	2467
10156	48	2016-05-30 23:28:16.434915	2504
10157	48	2016-05-30 23:28:16.442415	2469
10158	48	2016-05-30 23:28:16.450156	2442
10159	48	2016-05-30 23:28:16.457788	2474
10160	48	2016-05-30 23:28:16.46525	2486
10161	48	2016-05-30 23:28:16.473119	2476
10162	48	2016-05-30 23:28:16.480578	2492
10163	48	2016-05-30 23:28:16.488414	2448
10164	48	2016-05-30 23:28:16.496103	2490
10165	48	2016-05-30 23:28:16.503767	2440
10166	48	2016-05-30 23:28:16.511638	2452
10167	48	2016-05-30 23:28:16.519806	2468
10168	48	2016-05-30 23:28:16.543125	2450
10169	48	2016-05-30 23:28:16.551305	2470
10170	48	2016-05-30 23:28:16.559081	2506
10171	48	2016-05-30 23:28:16.567089	2461
10172	48	2016-05-30 23:28:16.574818	2502
10173	48	2016-05-30 23:28:16.58285	2455
10174	48	2016-05-30 23:28:16.590634	2478
10175	48	2016-05-30 23:28:16.598363	2488
10176	48	2016-05-30 23:28:16.606012	2494
10177	48	2016-05-30 23:28:16.61356	2484
10178	48	2016-05-30 23:28:16.621	2514
10179	48	2016-05-30 23:28:16.628551	2457
10180	48	2016-05-30 23:28:16.636001	2482
10181	48	2016-05-30 23:28:16.643608	2463
10182	48	2016-05-30 23:28:16.651091	2444
10183	48	2016-05-30 23:28:16.658559	2496
10184	50	2016-05-30 23:28:16.66686	47209
10185	50	2016-05-30 23:28:16.673636	47256
10186	50	2016-05-30 23:28:16.680342	47343
10187	50	2016-05-30 23:28:16.687468	47212
10188	50	2016-05-30 23:28:16.694318	47206
10189	50	2016-05-30 23:28:16.705173	47340
10190	50	2016-05-30 23:28:16.71217	47203
10191	50	2016-05-30 23:28:16.719308	47215
10192	47	2016-05-30 23:28:16.728593	2500
10193	47	2016-05-30 23:28:16.736119	2374
10194	47	2016-05-30 23:28:16.743828	2475
10195	47	2016-05-30 23:28:16.7518	2498
10196	47	2016-05-30 23:28:16.759641	2480
10197	47	2016-05-30 23:28:16.76761	2454
10198	47	2016-05-30 23:28:16.775348	2465
10199	47	2016-05-30 23:28:16.782958	2459
10200	47	2016-05-30 23:28:16.791019	2472
10201	47	2016-05-30 23:28:16.799282	2467
10202	47	2016-05-30 23:28:16.807135	2504
10203	47	2016-05-30 23:28:16.814885	2469
10204	47	2016-05-30 23:28:16.822853	2442
10205	47	2016-05-30 23:28:16.830479	2474
10206	47	2016-05-30 23:28:16.838825	2486
10207	47	2016-05-30 23:28:16.846352	2476
10208	47	2016-05-30 23:28:16.85382	2492
10209	47	2016-05-30 23:28:16.861447	2448
10210	47	2016-05-30 23:28:16.869643	2490
10211	47	2016-05-30 23:28:16.877205	2440
10212	47	2016-05-30 23:28:16.884786	2452
10213	47	2016-05-30 23:28:16.892269	2468
10214	47	2016-05-30 23:28:16.899719	2450
10215	47	2016-05-30 23:28:16.907374	2470
10216	47	2016-05-30 23:28:16.914817	2506
10217	47	2016-05-30 23:28:16.922149	2461
10218	47	2016-05-30 23:28:16.929227	2502
10219	47	2016-05-30 23:28:16.936612	2455
10220	47	2016-05-30 23:28:16.943852	2478
10221	47	2016-05-30 23:28:16.95211	2488
10222	47	2016-05-30 23:28:16.960013	2494
10223	47	2016-05-30 23:28:16.967718	2484
10224	47	2016-05-30 23:28:16.975221	2514
10225	47	2016-05-30 23:28:16.983508	2457
10226	47	2016-05-30 23:28:16.991299	2482
10227	47	2016-05-30 23:28:16.999018	2463
10228	47	2016-05-30 23:28:17.00673	2444
10229	47	2016-05-30 23:28:17.014965	2496
10230	41	2016-05-30 23:30:52.469642	2518
10231	41	2016-05-30 23:30:52.476093	2378
10232	41	2016-05-30 23:30:52.486803	2517
10233	41	2016-05-30 23:30:52.497364	2522
10234	41	2016-05-30 23:30:52.507537	2520
10235	41	2016-05-30 23:30:52.517797	2521
10236	41	2016-05-30 23:30:52.528181	2523
10237	41	2016-05-30 23:30:52.538818	2525
10238	41	2016-05-30 23:30:52.545107	2528
10239	41	2016-05-30 23:30:52.555534	2516
10240	41	2016-05-30 23:30:52.565948	2519
10241	41	2016-05-30 23:30:52.576486	2524
10242	46	2016-05-30 23:30:52.583139	2398
10243	45	2016-05-30 23:30:52.589679	2400
10244	44	2016-05-30 23:30:52.596304	2382
10245	42	2016-05-30 23:30:52.602793	2444
10246	42	2016-05-30 23:30:52.608587	2486
10247	42	2016-05-30 23:30:52.615698	2450
10248	42	2016-05-30 23:30:52.621642	2452
10249	42	2016-05-30 23:30:52.627523	2455
10250	42	2016-05-30 23:30:52.633463	2482
10251	42	2016-05-30 23:30:52.639467	2488
10252	42	2016-05-30 23:30:52.645461	2472
10253	42	2016-05-30 23:30:52.651361	2500
10254	42	2016-05-30 23:30:52.657326	2374
10255	42	2016-05-30 23:30:52.663101	2442
10256	42	2016-05-30 23:30:52.668936	2496
10257	42	2016-05-30 23:30:52.675164	2467
10258	42	2016-05-30 23:30:52.681135	2490
10259	42	2016-05-30 23:30:52.687528	2504
10260	42	2016-05-30 23:30:52.694068	2494
10261	42	2016-05-30 23:30:52.699883	2531
10262	42	2016-05-30 23:30:52.705661	2470
10263	42	2016-05-30 23:30:52.711602	2498
10264	42	2016-05-30 23:30:52.717459	2484
10265	42	2016-05-30 23:30:52.723719	2506
10266	42	2016-05-30 23:30:52.730059	2440
10267	42	2016-05-30 23:30:52.737813	2468
10268	42	2016-05-30 23:30:52.760788	2478
10269	42	2016-05-30 23:30:52.782677	2480
10270	42	2016-05-30 23:30:52.880206	2457
10271	42	2016-05-30 23:30:52.940769	2475
10272	42	2016-05-30 23:30:52.948038	2502
10273	42	2016-05-30 23:30:52.955758	2459
10274	42	2016-05-30 23:30:52.961954	2463
10275	42	2016-05-30 23:30:52.968263	2476
10276	42	2016-05-30 23:30:52.974364	2448
10277	42	2016-05-30 23:30:52.980606	2465
10278	42	2016-05-30 23:30:52.986883	2461
10279	42	2016-05-30 23:30:52.993156	2469
10280	42	2016-05-30 23:30:52.999285	2474
10281	42	2016-05-30 23:30:53.005509	2492
10282	43	2016-05-30 23:30:53.011829	2462
10283	43	2016-05-30 23:30:53.017854	2466
10284	43	2016-05-30 23:30:53.023913	2489
10285	43	2016-05-30 23:30:53.030251	2477
10286	43	2016-05-30 23:30:53.03669	2481
10287	43	2016-05-30 23:30:53.043057	2453
10288	43	2016-05-30 23:30:53.049272	2491
10289	43	2016-05-30 23:30:53.055491	2483
10290	43	2016-05-30 23:30:53.061613	2443
10291	43	2016-05-30 23:30:53.067893	2501
10292	43	2016-05-30 23:30:53.073942	2375
10293	43	2016-05-30 23:30:53.079842	2458
10294	43	2016-05-30 23:30:53.086319	2499
10295	43	2016-05-30 23:30:53.092467	2471
10296	43	2016-05-30 23:30:53.09864	2487
10297	43	2016-05-30 23:30:53.104515	2441
10298	43	2016-05-30 23:30:53.110451	2507
10299	43	2016-05-30 23:30:53.11734	2464
10300	43	2016-05-30 23:30:53.123313	2497
10301	43	2016-05-30 23:30:53.129319	2460
10302	43	2016-05-30 23:30:53.13561	2493
10303	43	2016-05-30 23:30:53.141667	2473
10304	43	2016-05-30 23:30:53.147642	2445
10305	43	2016-05-30 23:30:53.153926	2485
10306	43	2016-05-30 23:30:53.160082	2495
10307	43	2016-05-30 23:30:53.16631	2449
10308	43	2016-05-30 23:30:53.172291	2505
10309	43	2016-05-30 23:30:53.178675	2479
10310	43	2016-05-30 23:30:53.185579	2532
10311	43	2016-05-30 23:30:53.191909	2456
10312	43	2016-05-30 23:30:53.198111	2503
10313	43	2016-05-30 23:30:53.203923	2451
10314	40	2016-05-30 23:30:53.211215	47212
10315	40	2016-05-30 23:30:53.216559	47206
10316	40	2016-05-30 23:30:53.221979	47215
10317	40	2016-05-30 23:30:53.227438	47209
10318	40	2016-05-30 23:30:53.233229	47256
10319	40	2016-05-30 23:30:53.243197	47340
10320	40	2016-05-30 23:30:53.24861	47203
10321	40	2016-05-30 23:30:53.253971	47343
10322	49	2016-05-30 23:30:53.262911	47209
10323	49	2016-05-30 23:30:53.269643	47256
10324	49	2016-05-30 23:30:53.276471	47343
10325	49	2016-05-30 23:30:53.283736	47212
10326	49	2016-05-30 23:30:53.290653	47206
10327	49	2016-05-30 23:30:53.301417	47340
10328	49	2016-05-30 23:30:53.308447	47203
10329	49	2016-05-30 23:30:53.315175	47215
10330	48	2016-05-30 23:30:53.325233	2500
10331	48	2016-05-30 23:30:53.33296	2374
10332	48	2016-05-30 23:30:53.340743	2475
10333	48	2016-05-30 23:30:53.34823	2498
10334	48	2016-05-30 23:30:53.355851	2480
10335	48	2016-05-30 23:30:53.363469	2454
10336	48	2016-05-30 23:30:53.371008	2465
10337	48	2016-05-30 23:30:53.378944	2459
10338	48	2016-05-30 23:30:53.386514	2472
10339	48	2016-05-30 23:30:53.39458	2467
10340	48	2016-05-30 23:30:53.402315	2504
10341	48	2016-05-30 23:30:53.409777	2469
10342	48	2016-05-30 23:30:53.417428	2442
10343	48	2016-05-30 23:30:53.425128	2474
10344	48	2016-05-30 23:30:53.432772	2486
10345	48	2016-05-30 23:30:53.44018	2476
10346	48	2016-05-30 23:30:53.447619	2492
10347	48	2016-05-30 23:30:53.455304	2448
10348	48	2016-05-30 23:30:53.463031	2490
10349	48	2016-05-30 23:30:53.470684	2440
10350	48	2016-05-30 23:30:53.478389	2452
10351	48	2016-05-30 23:30:53.485911	2468
10352	48	2016-05-30 23:30:53.493632	2450
10353	48	2016-05-30 23:30:53.501117	2470
10354	48	2016-05-30 23:30:53.508662	2506
10355	48	2016-05-30 23:30:53.516362	2461
10356	48	2016-05-30 23:30:53.523772	2502
10357	48	2016-05-30 23:30:53.531363	2455
10358	48	2016-05-30 23:30:53.539014	2478
10359	48	2016-05-30 23:30:53.546691	2488
10360	48	2016-05-30 23:30:53.55421	2494
10361	48	2016-05-30 23:30:53.562217	2484
10362	48	2016-05-30 23:30:53.569541	2514
10363	48	2016-05-30 23:30:53.577378	2457
10364	48	2016-05-30 23:30:53.584712	2482
10365	48	2016-05-30 23:30:53.592496	2463
10366	48	2016-05-30 23:30:53.599959	2444
10367	48	2016-05-30 23:30:53.607658	2496
10368	50	2016-05-30 23:30:53.616351	47209
10369	50	2016-05-30 23:30:53.623285	47256
10370	50	2016-05-30 23:30:53.630144	47343
10371	50	2016-05-30 23:30:53.637143	47212
10372	50	2016-05-30 23:30:53.644191	47206
10373	50	2016-05-30 23:30:53.655298	47340
10374	50	2016-05-30 23:30:53.662324	47203
10375	50	2016-05-30 23:30:53.669313	47215
10376	47	2016-05-30 23:30:53.678399	2500
10377	47	2016-05-30 23:30:53.685889	2374
10378	47	2016-05-30 23:30:53.693407	2475
10379	47	2016-05-30 23:30:53.700586	2498
10380	47	2016-05-30 23:30:53.70797	2480
10381	47	2016-05-30 23:30:53.715219	2454
10382	47	2016-05-30 23:30:53.722933	2465
10383	47	2016-05-30 23:30:53.730367	2459
10384	47	2016-05-30 23:30:53.737889	2472
10385	47	2016-05-30 23:30:53.745309	2467
10386	47	2016-05-30 23:30:53.752652	2504
10387	47	2016-05-30 23:30:53.760441	2469
10388	47	2016-05-30 23:30:53.767856	2442
10389	47	2016-05-30 23:30:53.775478	2474
10390	47	2016-05-30 23:30:53.783384	2486
10391	47	2016-05-30 23:30:53.790804	2476
10392	47	2016-05-30 23:30:53.798105	2492
10393	47	2016-05-30 23:30:53.805403	2448
10394	47	2016-05-30 23:30:53.812969	2490
10395	47	2016-05-30 23:30:53.820296	2440
10396	47	2016-05-30 23:30:53.827642	2452
10397	47	2016-05-30 23:30:53.835215	2468
10398	47	2016-05-30 23:30:53.84266	2450
10399	47	2016-05-30 23:30:53.849857	2470
10400	47	2016-05-30 23:30:53.857314	2506
10401	47	2016-05-30 23:30:53.864756	2461
10402	47	2016-05-30 23:30:53.871973	2502
10403	47	2016-05-30 23:30:53.879421	2455
10404	47	2016-05-30 23:30:53.886635	2478
10405	47	2016-05-30 23:30:53.894144	2488
10406	47	2016-05-30 23:30:53.901515	2494
10407	47	2016-05-30 23:30:53.909004	2484
10408	47	2016-05-30 23:30:53.916609	2514
10409	47	2016-05-30 23:30:53.924159	2457
10410	47	2016-05-30 23:30:53.93143	2482
10411	47	2016-05-30 23:30:53.938803	2463
10412	47	2016-05-30 23:30:53.946397	2444
10413	47	2016-05-30 23:30:53.953765	2496
10414	41	2016-05-30 23:31:59.222545	2518
10415	41	2016-05-30 23:31:59.232603	2378
10416	41	2016-05-30 23:31:59.248074	2517
10417	41	2016-05-30 23:31:59.264419	2522
10418	41	2016-05-30 23:31:59.280605	2520
10419	41	2016-05-30 23:31:59.298949	2521
10420	41	2016-05-30 23:31:59.314622	2523
10421	41	2016-05-30 23:31:59.328034	2525
10422	41	2016-05-30 23:31:59.335415	2528
10423	41	2016-05-30 23:31:59.347028	2516
10424	41	2016-05-30 23:31:59.358963	2519
10425	41	2016-05-30 23:31:59.370975	2524
10426	46	2016-05-30 23:31:59.378657	2398
10427	45	2016-05-30 23:31:59.387536	2400
10428	44	2016-05-30 23:31:59.394895	2382
10429	42	2016-05-30 23:31:59.402626	2444
10430	42	2016-05-30 23:31:59.409623	2486
10431	42	2016-05-30 23:31:59.415708	2450
10432	42	2016-05-30 23:31:59.423381	2452
10433	42	2016-05-30 23:31:59.429821	2455
10434	42	2016-05-30 23:31:59.437091	2482
10435	42	2016-05-30 23:31:59.444185	2488
10436	42	2016-05-30 23:31:59.450603	2472
10437	42	2016-05-30 23:31:59.45753	2500
10438	42	2016-05-30 23:31:59.463652	2374
10439	42	2016-05-30 23:31:59.470676	2442
10440	42	2016-05-30 23:31:59.476829	2496
10441	42	2016-05-30 23:31:59.482956	2467
10442	42	2016-05-30 23:31:59.489662	2490
10443	42	2016-05-30 23:31:59.495532	2504
10444	42	2016-05-30 23:31:59.501831	2494
10445	42	2016-05-30 23:31:59.507732	2531
10446	42	2016-05-30 23:31:59.513531	2470
10447	42	2016-05-30 23:31:59.520021	2498
10448	42	2016-05-30 23:31:59.526722	2484
10449	42	2016-05-30 23:31:59.533205	2506
10450	42	2016-05-30 23:31:59.540784	2440
10451	42	2016-05-30 23:31:59.547223	2468
10452	42	2016-05-30 23:31:59.553672	2478
10453	42	2016-05-30 23:31:59.560532	2480
10454	42	2016-05-30 23:31:59.566539	2457
10455	42	2016-05-30 23:31:59.573126	2475
10456	42	2016-05-30 23:31:59.579423	2502
10457	42	2016-05-30 23:31:59.585748	2459
10458	42	2016-05-30 23:31:59.592182	2463
10459	42	2016-05-30 23:31:59.598178	2476
10460	42	2016-05-30 23:31:59.604468	2448
10461	42	2016-05-30 23:31:59.610937	2465
10462	42	2016-05-30 23:31:59.617404	2461
10463	42	2016-05-30 23:31:59.623642	2469
10464	42	2016-05-30 23:31:59.630173	2474
10465	42	2016-05-30 23:31:59.636588	2492
10466	43	2016-05-30 23:31:59.643134	2462
10467	43	2016-05-30 23:31:59.649263	2466
10468	43	2016-05-30 23:31:59.655684	2489
10469	43	2016-05-30 23:31:59.66175	2477
10470	43	2016-05-30 23:31:59.668022	2481
10471	43	2016-05-30 23:31:59.674034	2453
10472	43	2016-05-30 23:31:59.679957	2491
10473	43	2016-05-30 23:31:59.687409	2483
10474	43	2016-05-30 23:31:59.693801	2443
10475	43	2016-05-30 23:31:59.699968	2501
10476	43	2016-05-30 23:31:59.706892	2375
10477	43	2016-05-30 23:31:59.712854	2458
10478	43	2016-05-30 23:31:59.719381	2499
10479	43	2016-05-30 23:31:59.725439	2471
10480	43	2016-05-30 23:31:59.731652	2487
10481	43	2016-05-30 23:31:59.738319	2441
10482	43	2016-05-30 23:31:59.744641	2451
10483	43	2016-05-30 23:31:59.750656	2507
10484	43	2016-05-30 23:31:59.757002	2464
10485	43	2016-05-30 23:31:59.762988	2497
10486	43	2016-05-30 23:31:59.76927	2460
10487	43	2016-05-30 23:31:59.775577	2493
10488	43	2016-05-30 23:31:59.781569	2473
10489	43	2016-05-30 23:31:59.787691	2445
10490	43	2016-05-30 23:31:59.79402	2485
10491	43	2016-05-30 23:31:59.800607	2495
10492	43	2016-05-30 23:31:59.806525	2449
10493	43	2016-05-30 23:31:59.812564	2505
10494	43	2016-05-30 23:31:59.819389	2479
10495	43	2016-05-30 23:31:59.825528	2456
10496	43	2016-05-30 23:31:59.831398	2503
10497	40	2016-05-30 23:31:59.839244	47212
10498	40	2016-05-30 23:31:59.844759	47206
10499	40	2016-05-30 23:31:59.850106	47215
10500	40	2016-05-30 23:31:59.857423	47209
10501	40	2016-05-30 23:31:59.863186	47256
10502	40	2016-05-30 23:31:59.874188	47340
10503	40	2016-05-30 23:31:59.879575	47203
10504	40	2016-05-30 23:31:59.885835	47343
10505	49	2016-05-30 23:31:59.894785	47209
10506	49	2016-05-30 23:31:59.9021	47256
10507	49	2016-05-30 23:31:59.908896	47343
10508	49	2016-05-30 23:31:59.915945	47212
10509	49	2016-05-30 23:31:59.923528	47206
10510	49	2016-05-30 23:31:59.934917	47340
10511	49	2016-05-30 23:31:59.941967	47203
10512	49	2016-05-30 23:31:59.948866	47215
10513	48	2016-05-30 23:31:59.959486	2500
10514	48	2016-05-30 23:31:59.967701	2374
10515	48	2016-05-30 23:31:59.975622	2475
10516	48	2016-05-30 23:31:59.983767	2498
10517	48	2016-05-30 23:31:59.991516	2480
10518	48	2016-05-30 23:31:59.998975	2454
10519	48	2016-05-30 23:32:00.008225	2465
10520	48	2016-05-30 23:32:00.016498	2459
10521	48	2016-05-30 23:32:00.026336	2472
10522	48	2016-05-30 23:32:00.034704	2467
10523	48	2016-05-30 23:32:00.042994	2504
10524	48	2016-05-30 23:32:00.050708	2469
10525	48	2016-05-30 23:32:00.058639	2442
10526	48	2016-05-30 23:32:00.067327	2474
10527	48	2016-05-30 23:32:00.075486	2486
10528	48	2016-05-30 23:32:00.083454	2476
10529	48	2016-05-30 23:32:00.091115	2492
10530	48	2016-05-30 23:32:00.098879	2448
10531	48	2016-05-30 23:32:00.106553	2490
10532	48	2016-05-30 23:32:00.114028	2440
10533	48	2016-05-30 23:32:00.12204	2452
10534	48	2016-05-30 23:32:00.129897	2468
10535	48	2016-05-30 23:32:00.138147	2450
10536	48	2016-05-30 23:32:00.146046	2470
10537	48	2016-05-30 23:32:00.154109	2506
10538	48	2016-05-30 23:32:00.162293	2461
10539	48	2016-05-30 23:32:00.170624	2502
10540	48	2016-05-30 23:32:00.178959	2455
10541	48	2016-05-30 23:32:00.188379	2478
10542	48	2016-05-30 23:32:00.196115	2488
10543	48	2016-05-30 23:32:00.204253	2494
10544	48	2016-05-30 23:32:00.212181	2484
10545	48	2016-05-30 23:32:00.220412	2514
10546	48	2016-05-30 23:32:00.228311	2457
10547	48	2016-05-30 23:32:00.237139	2482
10548	48	2016-05-30 23:32:00.244833	2463
10549	48	2016-05-30 23:32:00.253296	2444
10550	48	2016-05-30 23:32:00.260907	2496
10551	50	2016-05-30 23:32:00.270308	47209
10552	50	2016-05-30 23:32:00.277405	47256
10553	50	2016-05-30 23:32:00.285807	47343
10554	50	2016-05-30 23:32:00.295115	47212
10555	50	2016-05-30 23:32:00.304038	47206
10556	50	2016-05-30 23:32:00.315362	47340
10557	50	2016-05-30 23:32:00.323884	47203
10558	50	2016-05-30 23:32:00.331167	47215
10559	47	2016-05-30 23:32:00.341722	2500
10560	47	2016-05-30 23:32:00.349105	2374
10561	47	2016-05-30 23:32:00.356833	2475
10562	47	2016-05-30 23:32:00.36607	2498
10563	47	2016-05-30 23:32:00.373694	2480
10564	47	2016-05-30 23:32:00.3813	2454
10565	47	2016-05-30 23:32:00.389913	2465
10566	47	2016-05-30 23:32:00.397843	2459
10567	47	2016-05-30 23:32:00.406697	2472
10568	47	2016-05-30 23:32:00.41433	2467
10569	47	2016-05-30 23:32:00.42231	2504
10570	47	2016-05-30 23:32:00.429767	2469
10571	47	2016-05-30 23:32:00.437748	2442
10572	47	2016-05-30 23:32:00.445387	2474
10573	47	2016-05-30 23:32:00.453094	2486
10574	47	2016-05-30 23:32:00.46046	2476
10575	47	2016-05-30 23:32:00.468577	2492
10576	47	2016-05-30 23:32:00.4763	2448
10577	47	2016-05-30 23:32:00.48505	2490
10578	47	2016-05-30 23:32:00.492958	2440
10579	47	2016-05-30 23:32:00.500911	2452
10580	47	2016-05-30 23:32:00.509016	2468
10581	47	2016-05-30 23:32:00.517312	2450
10582	47	2016-05-30 23:32:00.524988	2470
10583	47	2016-05-30 23:32:00.533024	2506
10584	47	2016-05-30 23:32:00.540464	2461
10585	47	2016-05-30 23:32:00.547657	2502
10586	47	2016-05-30 23:32:00.555352	2455
10587	47	2016-05-30 23:32:00.562709	2478
10588	47	2016-05-30 23:32:00.570278	2488
10589	47	2016-05-30 23:32:00.577597	2494
10590	47	2016-05-30 23:32:00.58582	2484
10591	47	2016-05-30 23:32:00.593132	2514
10592	47	2016-05-30 23:32:00.600566	2531
10593	47	2016-05-30 23:32:00.60816	2457
10594	47	2016-05-30 23:32:00.616218	2482
10595	47	2016-05-30 23:32:00.623784	2463
10596	47	2016-05-30 23:32:00.631457	2444
10597	47	2016-05-30 23:32:00.638962	2496
10598	40	2016-05-30 23:32:22.979776	47347
10599	41	2016-05-30 23:33:00.400993	2518
10600	41	2016-05-30 23:33:00.407488	2378
10601	41	2016-05-30 23:33:00.41833	2517
10602	41	2016-05-30 23:33:00.429283	2522
10603	41	2016-05-30 23:33:00.439997	2520
10604	41	2016-05-30 23:33:00.450423	2521
10605	41	2016-05-30 23:33:00.461303	2523
10606	41	2016-05-30 23:33:00.471794	2525
10607	41	2016-05-30 23:33:00.477983	2528
10608	41	2016-05-30 23:33:00.488438	2516
10609	41	2016-05-30 23:33:00.498821	2519
10610	41	2016-05-30 23:33:00.509376	2524
10611	46	2016-05-30 23:33:00.515795	2398
10612	45	2016-05-30 23:33:00.522385	2400
10613	44	2016-05-30 23:33:00.528595	2382
10614	42	2016-05-30 23:33:00.534854	2444
10615	42	2016-05-30 23:33:00.540993	2486
10616	42	2016-05-30 23:33:00.547087	2450
10617	42	2016-05-30 23:33:00.553131	2452
10618	42	2016-05-30 23:33:00.559132	2455
10619	42	2016-05-30 23:33:00.565172	2482
10620	42	2016-05-30 23:33:00.571484	2488
10621	42	2016-05-30 23:33:00.577535	2472
10622	42	2016-05-30 23:33:00.583351	2500
10623	42	2016-05-30 23:33:00.589226	2374
10624	42	2016-05-30 23:33:00.595147	2442
10625	42	2016-05-30 23:33:00.601626	2496
10626	42	2016-05-30 23:33:00.607675	2467
10627	42	2016-05-30 23:33:00.613794	2490
10628	42	2016-05-30 23:33:00.619725	2504
10629	42	2016-05-30 23:33:00.625708	2494
10630	42	2016-05-30 23:33:00.631838	2470
10631	42	2016-05-30 23:33:00.637865	2498
10632	42	2016-05-30 23:33:00.643921	2484
10633	42	2016-05-30 23:33:00.649893	2506
10634	42	2016-05-30 23:33:00.656106	2440
10635	42	2016-05-30 23:33:00.662116	2468
10636	42	2016-05-30 23:33:00.668086	2478
10637	42	2016-05-30 23:33:00.673968	2480
10638	42	2016-05-30 23:33:00.679972	2457
10639	42	2016-05-30 23:33:00.686135	2475
10640	42	2016-05-30 23:33:00.692391	2502
10641	42	2016-05-30 23:33:00.698491	2459
10642	42	2016-05-30 23:33:00.704477	2463
10643	42	2016-05-30 23:33:00.710538	2476
10644	42	2016-05-30 23:33:00.716535	2448
10645	42	2016-05-30 23:33:00.723351	2465
10646	42	2016-05-30 23:33:00.72969	2461
10647	42	2016-05-30 23:33:00.73671	2469
10648	42	2016-05-30 23:33:00.742663	2474
10649	42	2016-05-30 23:33:00.748842	2492
10650	43	2016-05-30 23:33:00.755331	2462
10651	43	2016-05-30 23:33:00.761859	2466
10652	43	2016-05-30 23:33:00.768068	2489
10653	43	2016-05-30 23:33:00.774095	2477
10654	43	2016-05-30 23:33:00.780337	2481
10655	43	2016-05-30 23:33:00.786293	2453
10656	43	2016-05-30 23:33:00.792459	2491
10657	43	2016-05-30 23:33:00.798253	2483
10658	43	2016-05-30 23:33:00.804463	2443
10659	43	2016-05-30 23:33:00.810395	2501
10660	43	2016-05-30 23:33:00.816482	2375
10661	43	2016-05-30 23:33:00.823165	2458
10662	43	2016-05-30 23:33:00.829309	2499
10663	43	2016-05-30 23:33:00.835415	2471
10664	43	2016-05-30 23:33:00.841938	2487
10665	43	2016-05-30 23:33:00.847937	2441
10666	43	2016-05-30 23:33:00.853927	2451
10667	43	2016-05-30 23:33:00.860146	2507
10668	43	2016-05-30 23:33:00.86629	2464
10669	43	2016-05-30 23:33:00.872556	2497
10670	43	2016-05-30 23:33:00.878717	2460
10671	43	2016-05-30 23:33:00.884742	2493
10672	43	2016-05-30 23:33:00.89109	2473
10673	43	2016-05-30 23:33:00.896907	2445
10674	43	2016-05-30 23:33:00.902792	2485
10675	43	2016-05-30 23:33:00.909103	2495
10676	43	2016-05-30 23:33:00.915012	2449
10677	43	2016-05-30 23:33:00.921058	2505
10678	43	2016-05-30 23:33:00.926967	2479
10679	43	2016-05-30 23:33:00.932993	2456
10680	43	2016-05-30 23:33:00.93919	2503
10681	40	2016-05-30 23:33:00.94607	47212
10682	40	2016-05-30 23:33:00.951461	47206
10683	40	2016-05-30 23:33:00.956976	47215
10684	40	2016-05-30 23:33:00.962525	47209
10685	40	2016-05-30 23:33:00.967885	47256
10686	40	2016-05-30 23:33:00.982442	47340
10687	40	2016-05-30 23:33:00.987916	47203
10688	40	2016-05-30 23:33:00.993414	47343
10689	49	2016-05-30 23:33:01.002498	47209
10690	49	2016-05-30 23:33:01.010107	47256
10691	49	2016-05-30 23:33:01.016938	47343
10692	49	2016-05-30 23:33:01.024237	47212
10693	49	2016-05-30 23:33:01.031456	47206
10694	49	2016-05-30 23:33:01.042787	47340
10695	49	2016-05-30 23:33:01.049583	47203
10696	49	2016-05-30 23:33:01.056435	47215
10697	48	2016-05-30 23:33:01.066093	2500
10698	48	2016-05-30 23:33:01.073852	2374
10699	48	2016-05-30 23:33:01.081474	2475
10700	48	2016-05-30 23:33:01.089318	2498
10701	48	2016-05-30 23:33:01.096885	2480
10702	48	2016-05-30 23:33:01.104431	2454
10703	48	2016-05-30 23:33:01.112087	2465
10704	48	2016-05-30 23:33:01.119758	2459
10705	48	2016-05-30 23:33:01.127397	2472
10706	48	2016-05-30 23:33:01.135052	2467
10707	48	2016-05-30 23:33:01.142999	2504
10708	48	2016-05-30 23:33:01.150633	2469
10709	48	2016-05-30 23:33:01.15829	2442
10710	48	2016-05-30 23:33:01.165977	2474
10711	48	2016-05-30 23:33:01.173808	2486
10712	48	2016-05-30 23:33:01.181468	2476
10713	48	2016-05-30 23:33:01.189222	2492
10714	48	2016-05-30 23:33:01.196802	2448
10715	48	2016-05-30 23:33:01.204481	2490
10716	48	2016-05-30 23:33:01.212467	2440
10717	48	2016-05-30 23:33:01.220345	2452
10718	48	2016-05-30 23:33:01.228035	2468
10719	48	2016-05-30 23:33:01.236148	2450
10720	48	2016-05-30 23:33:01.243794	2470
10721	48	2016-05-30 23:33:01.251566	2506
10722	48	2016-05-30 23:33:01.259523	2461
10723	48	2016-05-30 23:33:01.267148	2502
10724	48	2016-05-30 23:33:01.275008	2455
10725	48	2016-05-30 23:33:01.282768	2478
10726	48	2016-05-30 23:33:01.290797	2488
10727	48	2016-05-30 23:33:01.29897	2494
10728	48	2016-05-30 23:33:01.30657	2484
10729	48	2016-05-30 23:33:01.313979	2514
10730	48	2016-05-30 23:33:01.321396	2531
10731	48	2016-05-30 23:33:01.329167	2457
10732	48	2016-05-30 23:33:01.337002	2482
10733	48	2016-05-30 23:33:01.344804	2463
10734	48	2016-05-30 23:33:01.35241	2444
10735	48	2016-05-30 23:33:01.360355	2496
10736	50	2016-05-30 23:33:01.368958	47209
10737	50	2016-05-30 23:33:01.375767	47256
10738	50	2016-05-30 23:33:01.382732	47343
10739	50	2016-05-30 23:33:01.389966	47212
10740	50	2016-05-30 23:33:01.397062	47206
10741	50	2016-05-30 23:33:01.408143	47340
10742	50	2016-05-30 23:33:01.41575	47203
10743	50	2016-05-30 23:33:01.422828	47215
10744	47	2016-05-30 23:33:01.432172	2500
10745	47	2016-05-30 23:33:01.439854	2374
10746	47	2016-05-30 23:33:01.447398	2475
10747	47	2016-05-30 23:33:01.454823	2498
10748	47	2016-05-30 23:33:01.46212	2480
10749	47	2016-05-30 23:33:01.469455	2454
10750	47	2016-05-30 23:33:01.476861	2465
10751	47	2016-05-30 23:33:01.484314	2459
10752	47	2016-05-30 23:33:01.491849	2472
10753	47	2016-05-30 23:33:01.49941	2467
10754	47	2016-05-30 23:33:01.507036	2504
10755	47	2016-05-30 23:33:01.514532	2469
10756	47	2016-05-30 23:33:01.5221	2442
10757	47	2016-05-30 23:33:01.52957	2474
10758	47	2016-05-30 23:33:01.537179	2486
10759	47	2016-05-30 23:33:01.544603	2476
10760	47	2016-05-30 23:33:01.551947	2492
10761	47	2016-05-30 23:33:01.55947	2448
10762	47	2016-05-30 23:33:01.566786	2490
10763	47	2016-05-30 23:33:01.574463	2440
10764	47	2016-05-30 23:33:01.582702	2452
10765	47	2016-05-30 23:33:01.590423	2468
10766	47	2016-05-30 23:33:01.597926	2450
10767	47	2016-05-30 23:33:01.605405	2470
10768	47	2016-05-30 23:33:01.612808	2506
10769	47	2016-05-30 23:33:01.620439	2461
10770	47	2016-05-30 23:33:01.627701	2502
10771	47	2016-05-30 23:33:01.635488	2455
10772	47	2016-05-30 23:33:01.642832	2478
10773	47	2016-05-30 23:33:01.650196	2488
10774	47	2016-05-30 23:33:01.657893	2494
10775	47	2016-05-30 23:33:01.665369	2484
10776	47	2016-05-30 23:33:01.672746	2514
10777	47	2016-05-30 23:33:01.679927	2531
10778	47	2016-05-30 23:33:01.687517	2457
10779	47	2016-05-30 23:33:01.694951	2482
10780	47	2016-05-30 23:33:01.702514	2463
10781	47	2016-05-30 23:33:01.710003	2444
10782	47	2016-05-30 23:33:01.717391	2496
10783	41	2016-05-30 23:34:22.531291	2518
10784	41	2016-05-30 23:34:22.537964	2378
10785	41	2016-05-30 23:34:22.548505	2517
10786	41	2016-05-30 23:34:22.558959	2520
10787	41	2016-05-30 23:34:22.569848	2521
10788	41	2016-05-30 23:34:22.581049	2523
10789	41	2016-05-30 23:34:22.591497	2525
10790	41	2016-05-30 23:34:22.59789	2528
10791	41	2016-05-30 23:34:22.604042	2533
10792	41	2016-05-30 23:34:22.614571	2516
10793	41	2016-05-30 23:34:22.624951	2519
10794	41	2016-05-30 23:34:22.635578	2524
10795	41	2016-05-30 23:34:22.646245	2522
10796	46	2016-05-30 23:34:22.652869	2398
10797	45	2016-05-30 23:34:22.659168	2400
10798	44	2016-05-30 23:34:22.665556	2382
10799	42	2016-05-30 23:34:22.671893	2444
10800	42	2016-05-30 23:34:22.678141	2486
10801	42	2016-05-30 23:34:22.684111	2450
10802	42	2016-05-30 23:34:22.690123	2452
10803	42	2016-05-30 23:34:22.696002	2455
10804	42	2016-05-30 23:34:22.701846	2482
10805	42	2016-05-30 23:34:22.707726	2488
10806	42	2016-05-30 23:34:22.713859	2472
10807	42	2016-05-30 23:34:22.720256	2500
10808	42	2016-05-30 23:34:22.743762	2374
10809	42	2016-05-30 23:34:22.751499	2442
10810	42	2016-05-30 23:34:22.759908	2496
10811	42	2016-05-30 23:34:22.767138	2467
10812	42	2016-05-30 23:34:22.773556	2490
10813	42	2016-05-30 23:34:22.780377	2504
10814	42	2016-05-30 23:34:22.786964	2494
10815	42	2016-05-30 23:34:22.793676	2470
10816	42	2016-05-30 23:34:22.872555	2498
10817	42	2016-05-30 23:34:22.890908	2484
10818	42	2016-05-30 23:34:22.897527	2506
10819	42	2016-05-30 23:34:22.904268	2440
10820	42	2016-05-30 23:34:23.121491	2468
10821	42	2016-05-30 23:34:23.198953	2478
10822	42	2016-05-30 23:34:23.207684	2480
10823	42	2016-05-30 23:34:23.213988	2457
10824	42	2016-05-30 23:34:23.22015	2475
10825	42	2016-05-30 23:34:23.227142	2502
10826	42	2016-05-30 23:34:23.233213	2459
10827	42	2016-05-30 23:34:23.23917	2463
10828	42	2016-05-30 23:34:23.24551	2476
10829	42	2016-05-30 23:34:23.251574	2448
10830	42	2016-05-30 23:34:23.257515	2465
10831	42	2016-05-30 23:34:23.263394	2461
10832	42	2016-05-30 23:34:23.269553	2469
10833	42	2016-05-30 23:34:23.275847	2474
10834	42	2016-05-30 23:34:23.282028	2492
10835	43	2016-05-30 23:34:23.288632	2462
10836	43	2016-05-30 23:34:23.294575	2466
10837	43	2016-05-30 23:34:23.300965	2489
10838	43	2016-05-30 23:34:23.307202	2477
10839	43	2016-05-30 23:34:23.313203	2481
10840	43	2016-05-30 23:34:23.319191	2453
10841	43	2016-05-30 23:34:23.325267	2491
10842	43	2016-05-30 23:34:23.331332	2483
10843	43	2016-05-30 23:34:23.337698	2443
10844	43	2016-05-30 23:34:23.343602	2501
10845	43	2016-05-30 23:34:23.349628	2375
10846	43	2016-05-30 23:34:23.355957	2458
10847	43	2016-05-30 23:34:23.362005	2499
10848	43	2016-05-30 23:34:23.368014	2471
10849	43	2016-05-30 23:34:23.374029	2487
10850	43	2016-05-30 23:34:23.380032	2441
10851	43	2016-05-30 23:34:23.385966	2451
10852	43	2016-05-30 23:34:23.392075	2507
10853	43	2016-05-30 23:34:23.398112	2464
10854	43	2016-05-30 23:34:23.404034	2497
10855	43	2016-05-30 23:34:23.410157	2460
10856	43	2016-05-30 23:34:23.416091	2493
10857	43	2016-05-30 23:34:23.422108	2473
10858	43	2016-05-30 23:34:23.428263	2445
10859	43	2016-05-30 23:34:23.434341	2485
10860	43	2016-05-30 23:34:23.440575	2495
10861	43	2016-05-30 23:34:23.446633	2449
10862	43	2016-05-30 23:34:23.45276	2505
10863	43	2016-05-30 23:34:23.458743	2479
10864	43	2016-05-30 23:34:23.464816	2456
10865	43	2016-05-30 23:34:23.47072	2503
10866	40	2016-05-30 23:34:23.477651	47212
10867	40	2016-05-30 23:34:23.483201	47206
10868	40	2016-05-30 23:34:23.488702	47215
10869	40	2016-05-30 23:34:23.49421	47209
10870	40	2016-05-30 23:34:23.499473	47256
10871	40	2016-05-30 23:34:23.504776	47347
10872	40	2016-05-30 23:34:23.514285	47340
10873	40	2016-05-30 23:34:23.519883	47203
10874	40	2016-05-30 23:34:23.525478	47343
10875	49	2016-05-30 23:34:23.534024	47347
10876	49	2016-05-30 23:34:23.540967	47343
10877	49	2016-05-30 23:34:23.548015	47212
10878	49	2016-05-30 23:34:23.554743	47206
10879	49	2016-05-30 23:34:23.565931	47340
10880	49	2016-05-30 23:34:23.572855	47203
10881	49	2016-05-30 23:34:23.579939	47215
10882	49	2016-05-30 23:34:23.586995	47209
10883	49	2016-05-30 23:34:23.5938	47256
10884	48	2016-05-30 23:34:23.603591	2500
10885	48	2016-05-30 23:34:23.612175	2374
10886	48	2016-05-30 23:34:23.620059	2475
10887	48	2016-05-30 23:34:23.627693	2498
10888	48	2016-05-30 23:34:23.635233	2480
10889	48	2016-05-30 23:34:23.642827	2454
10890	48	2016-05-30 23:34:23.65055	2465
10891	48	2016-05-30 23:34:23.658086	2459
10892	48	2016-05-30 23:34:23.665709	2472
10893	48	2016-05-30 23:34:23.673463	2467
10894	48	2016-05-30 23:34:23.681453	2504
10895	48	2016-05-30 23:34:23.68922	2469
10896	48	2016-05-30 23:34:23.697089	2442
10897	48	2016-05-30 23:34:23.70473	2474
10898	48	2016-05-30 23:34:23.712251	2486
10899	48	2016-05-30 23:34:23.71999	2476
10900	48	2016-05-30 23:34:23.727906	2492
10901	48	2016-05-30 23:34:23.735608	2448
10902	48	2016-05-30 23:34:23.743302	2490
10903	48	2016-05-30 23:34:23.751059	2440
10904	48	2016-05-30 23:34:23.75918	2452
10905	48	2016-05-30 23:34:23.766776	2468
10906	48	2016-05-30 23:34:23.774499	2450
10907	48	2016-05-30 23:34:23.782175	2470
10908	48	2016-05-30 23:34:23.789674	2506
10909	48	2016-05-30 23:34:23.79784	2461
10910	48	2016-05-30 23:34:23.805443	2502
10911	48	2016-05-30 23:34:23.813206	2455
10912	48	2016-05-30 23:34:23.82079	2478
10913	48	2016-05-30 23:34:23.828532	2488
10914	48	2016-05-30 23:34:23.836163	2494
10915	48	2016-05-30 23:34:23.844254	2484
10916	48	2016-05-30 23:34:23.851725	2514
10917	48	2016-05-30 23:34:23.858841	2531
10918	48	2016-05-30 23:34:23.866932	2457
10919	48	2016-05-30 23:34:23.874702	2482
10920	48	2016-05-30 23:34:23.882364	2463
10921	48	2016-05-30 23:34:23.890444	2444
10922	48	2016-05-30 23:34:23.898308	2496
10923	50	2016-05-30 23:34:23.907247	47209
10924	50	2016-05-30 23:34:23.914232	47256
10925	50	2016-05-30 23:34:23.921154	47343
10926	50	2016-05-30 23:34:23.928442	47212
10927	50	2016-05-30 23:34:23.935863	47206
10928	50	2016-05-30 23:34:23.947321	47340
10929	50	2016-05-30 23:34:23.954483	47203
10930	50	2016-05-30 23:34:23.961568	47215
10931	47	2016-05-30 23:34:23.971189	2500
10932	47	2016-05-30 23:34:23.978684	2374
10933	47	2016-05-30 23:34:23.986407	2475
10934	47	2016-05-30 23:34:23.993758	2498
10935	47	2016-05-30 23:34:24.001265	2480
10936	47	2016-05-30 23:34:24.008873	2454
10937	47	2016-05-30 23:34:24.016372	2465
10938	47	2016-05-30 23:34:24.024048	2459
10939	47	2016-05-30 23:34:24.031772	2472
10940	47	2016-05-30 23:34:24.039425	2467
10941	47	2016-05-30 23:34:24.046934	2504
10942	47	2016-05-30 23:34:24.054639	2469
10943	47	2016-05-30 23:34:24.062195	2442
10944	47	2016-05-30 23:34:24.070146	2474
10945	47	2016-05-30 23:34:24.077724	2486
10946	47	2016-05-30 23:34:24.085405	2476
10947	47	2016-05-30 23:34:24.092996	2492
10948	47	2016-05-30 23:34:24.100398	2448
10949	47	2016-05-30 23:34:24.108072	2490
10950	47	2016-05-30 23:34:24.115715	2440
10951	47	2016-05-30 23:34:24.12336	2452
10952	47	2016-05-30 23:34:24.130989	2468
10953	47	2016-05-30 23:34:24.138507	2450
10954	47	2016-05-30 23:34:24.145961	2470
10955	47	2016-05-30 23:34:24.15341	2506
10956	47	2016-05-30 23:34:24.161031	2461
10957	47	2016-05-30 23:34:24.168549	2502
10958	47	2016-05-30 23:34:24.176157	2455
10959	47	2016-05-30 23:34:24.183542	2478
10960	47	2016-05-30 23:34:24.191012	2488
10961	47	2016-05-30 23:34:24.19847	2494
10962	47	2016-05-30 23:34:24.206027	2484
10963	47	2016-05-30 23:34:24.213694	2514
10964	47	2016-05-30 23:34:24.221339	2531
10965	47	2016-05-30 23:34:24.229572	2457
10966	47	2016-05-30 23:34:24.237196	2482
10967	47	2016-05-30 23:34:24.244781	2463
10968	47	2016-05-30 23:34:24.252405	2444
10969	47	2016-05-30 23:34:24.260015	2496
10970	41	2016-05-30 23:35:33.919522	2518
10971	41	2016-05-30 23:35:33.926598	2378
10972	41	2016-05-30 23:35:33.937654	2517
10973	41	2016-05-30 23:35:33.948352	2520
10974	41	2016-05-30 23:35:33.959297	2521
10975	41	2016-05-30 23:35:33.97026	2523
10976	41	2016-05-30 23:35:33.980885	2525
10977	41	2016-05-30 23:35:33.987394	2528
10978	41	2016-05-30 23:35:33.993359	2533
10979	41	2016-05-30 23:35:34.004399	2516
10980	41	2016-05-30 23:35:34.015347	2519
10981	41	2016-05-30 23:35:34.026357	2524
10982	41	2016-05-30 23:35:34.037418	2522
10983	46	2016-05-30 23:35:34.044317	2398
10984	45	2016-05-30 23:35:34.050733	2400
10985	44	2016-05-30 23:35:34.057515	2382
10986	42	2016-05-30 23:35:34.063931	2444
10987	42	2016-05-30 23:35:34.070719	2486
10988	42	2016-05-30 23:35:34.07705	2450
10989	42	2016-05-30 23:35:34.082952	2452
10990	42	2016-05-30 23:35:34.089531	2455
10991	42	2016-05-30 23:35:34.095604	2482
10992	42	2016-05-30 23:35:34.101537	2488
10993	42	2016-05-30 23:35:34.107844	2472
10994	42	2016-05-30 23:35:34.113848	2500
10995	42	2016-05-30 23:35:34.120327	2374
10996	42	2016-05-30 23:35:34.142158	2442
10997	42	2016-05-30 23:35:34.163571	2496
10998	42	2016-05-30 23:35:34.169962	2467
10999	42	2016-05-30 23:35:34.176541	2490
11000	42	2016-05-30 23:35:34.182541	2504
11001	42	2016-05-30 23:35:34.188495	2494
11002	42	2016-05-30 23:35:34.194851	2470
11003	42	2016-05-30 23:35:34.201056	2498
11004	42	2016-05-30 23:35:34.207372	2484
11005	42	2016-05-30 23:35:34.213542	2506
11006	42	2016-05-30 23:35:34.21951	2440
11007	42	2016-05-30 23:35:34.22676	2468
11008	42	2016-05-30 23:35:34.232887	2478
11009	42	2016-05-30 23:35:34.239039	2480
11010	42	2016-05-30 23:35:34.245465	2457
11011	42	2016-05-30 23:35:34.251706	2475
11012	42	2016-05-30 23:35:34.258506	2502
11013	42	2016-05-30 23:35:34.2647	2459
11014	42	2016-05-30 23:35:34.270839	2463
11015	42	2016-05-30 23:35:34.277392	2476
11016	42	2016-05-30 23:35:34.283438	2448
11017	42	2016-05-30 23:35:34.28943	2465
11018	42	2016-05-30 23:35:34.295839	2461
11019	42	2016-05-30 23:35:34.301838	2469
11020	42	2016-05-30 23:35:34.308315	2474
11021	42	2016-05-30 23:35:34.314454	2492
11022	43	2016-05-30 23:35:34.320732	2462
11023	43	2016-05-30 23:35:34.326687	2466
11024	43	2016-05-30 23:35:34.33294	2489
11025	43	2016-05-30 23:35:34.338928	2477
11026	43	2016-05-30 23:35:34.345062	2481
11027	43	2016-05-30 23:35:34.35118	2453
11028	43	2016-05-30 23:35:34.357094	2491
11029	43	2016-05-30 23:35:34.363386	2483
11030	43	2016-05-30 23:35:34.369356	2443
11031	43	2016-05-30 23:35:34.375358	2501
11032	43	2016-05-30 23:35:34.38205	2375
11033	43	2016-05-30 23:35:34.388463	2458
11034	43	2016-05-30 23:35:34.394715	2499
11035	43	2016-05-30 23:35:34.400653	2471
11036	43	2016-05-30 23:35:34.406831	2487
11037	43	2016-05-30 23:35:34.412709	2441
11038	43	2016-05-30 23:35:34.418714	2451
11039	43	2016-05-30 23:35:34.424758	2507
11040	43	2016-05-30 23:35:34.430656	2464
11041	43	2016-05-30 23:35:34.436702	2497
11042	43	2016-05-30 23:35:34.443059	2460
11043	43	2016-05-30 23:35:34.449176	2493
11044	43	2016-05-30 23:35:34.455114	2473
11045	43	2016-05-30 23:35:34.461037	2445
11046	43	2016-05-30 23:35:34.46701	2485
11047	43	2016-05-30 23:35:34.472807	2495
11048	43	2016-05-30 23:35:34.478891	2449
11049	43	2016-05-30 23:35:34.4849	2505
11050	43	2016-05-30 23:35:34.491011	2479
11051	43	2016-05-30 23:35:34.496984	2456
11052	43	2016-05-30 23:35:34.503047	2503
11053	40	2016-05-30 23:35:34.510102	47212
11054	40	2016-05-30 23:35:34.515421	47206
11055	40	2016-05-30 23:35:34.520908	47215
11056	40	2016-05-30 23:35:34.526655	47209
11057	40	2016-05-30 23:35:34.532231	47256
11058	40	2016-05-30 23:35:34.537768	47347
11059	40	2016-05-30 23:35:34.547347	47340
11060	40	2016-05-30 23:35:34.552872	47203
11061	40	2016-05-30 23:35:34.55845	47343
11062	49	2016-05-30 23:35:34.567057	47347
11063	49	2016-05-30 23:35:34.573694	47343
11064	49	2016-05-30 23:35:34.581179	47212
11065	49	2016-05-30 23:35:34.588197	47206
11066	49	2016-05-30 23:35:34.599129	47340
11067	49	2016-05-30 23:35:34.606323	47203
11068	49	2016-05-30 23:35:34.613576	47215
11069	49	2016-05-30 23:35:34.620688	47209
11070	49	2016-05-30 23:35:34.627517	47256
11071	48	2016-05-30 23:35:34.637239	2500
11072	48	2016-05-30 23:35:34.645156	2374
11073	48	2016-05-30 23:35:34.652853	2475
11074	48	2016-05-30 23:35:34.660558	2498
11075	48	2016-05-30 23:35:34.668403	2480
11076	48	2016-05-30 23:35:34.676078	2454
11077	48	2016-05-30 23:35:34.683782	2465
11078	48	2016-05-30 23:35:34.692549	2459
11079	48	2016-05-30 23:35:34.700397	2472
11080	48	2016-05-30 23:35:34.708235	2467
11081	48	2016-05-30 23:35:34.715928	2504
11082	48	2016-05-30 23:35:34.723727	2469
11083	48	2016-05-30 23:35:34.731648	2442
11084	48	2016-05-30 23:35:34.739687	2474
11085	48	2016-05-30 23:35:34.74734	2486
11086	48	2016-05-30 23:35:34.755398	2476
11087	48	2016-05-30 23:35:34.763079	2492
11088	48	2016-05-30 23:35:34.770947	2448
11089	48	2016-05-30 23:35:34.778901	2490
11090	48	2016-05-30 23:35:34.786748	2440
11091	48	2016-05-30 23:35:34.79473	2452
11092	48	2016-05-30 23:35:34.802547	2468
11093	48	2016-05-30 23:35:34.810163	2450
11094	48	2016-05-30 23:35:34.818035	2470
11095	48	2016-05-30 23:35:34.826264	2506
11096	48	2016-05-30 23:35:34.833989	2461
11097	48	2016-05-30 23:35:34.842074	2502
11098	48	2016-05-30 23:35:34.850008	2455
11099	48	2016-05-30 23:35:34.857854	2478
11100	48	2016-05-30 23:35:34.865579	2488
11101	48	2016-05-30 23:35:34.873897	2494
11102	48	2016-05-30 23:35:34.881665	2484
11103	48	2016-05-30 23:35:34.889299	2514
11104	48	2016-05-30 23:35:34.896533	2531
11105	48	2016-05-30 23:35:34.90437	2457
11106	48	2016-05-30 23:35:34.912451	2482
11107	48	2016-05-30 23:35:34.920154	2463
11108	48	2016-05-30 23:35:34.928007	2444
11109	48	2016-05-30 23:35:34.935715	2496
11110	50	2016-05-30 23:35:34.94411	47347
11111	50	2016-05-30 23:35:34.950959	47343
11112	50	2016-05-30 23:35:34.958181	47212
11113	50	2016-05-30 23:35:34.96539	47206
11114	50	2016-05-30 23:35:34.976637	47340
11115	50	2016-05-30 23:35:34.984126	47203
11116	50	2016-05-30 23:35:34.99145	47215
11117	50	2016-05-30 23:35:34.998986	47209
11118	50	2016-05-30 23:35:35.006081	47256
11119	47	2016-05-30 23:35:35.015422	2500
11120	47	2016-05-30 23:35:35.023059	2374
11121	47	2016-05-30 23:35:35.030907	2475
11122	47	2016-05-30 23:35:35.039163	2498
11123	47	2016-05-30 23:35:35.046735	2480
11124	47	2016-05-30 23:35:35.054404	2454
11125	47	2016-05-30 23:35:35.061918	2465
11126	47	2016-05-30 23:35:35.069622	2459
11127	47	2016-05-30 23:35:35.077166	2472
11128	47	2016-05-30 23:35:35.084753	2467
11129	47	2016-05-30 23:35:35.092619	2504
11130	47	2016-05-30 23:35:35.100121	2469
11131	47	2016-05-30 23:35:35.107734	2442
11132	47	2016-05-30 23:35:35.115348	2474
11133	47	2016-05-30 23:35:35.123517	2486
11134	47	2016-05-30 23:35:35.146513	2476
11135	47	2016-05-30 23:35:35.169849	2492
11136	47	2016-05-30 23:35:35.177619	2448
11137	47	2016-05-30 23:35:35.185167	2490
11138	47	2016-05-30 23:35:35.192718	2440
11139	47	2016-05-30 23:35:35.20019	2452
11140	47	2016-05-30 23:35:35.208111	2468
11141	47	2016-05-30 23:35:35.215621	2450
11142	47	2016-05-30 23:35:35.223235	2470
11143	47	2016-05-30 23:35:35.23135	2506
11144	47	2016-05-30 23:35:35.239252	2461
11145	47	2016-05-30 23:35:35.247217	2502
11146	47	2016-05-30 23:35:35.254864	2455
11147	47	2016-05-30 23:35:35.262264	2478
11148	47	2016-05-30 23:35:35.269914	2488
11149	47	2016-05-30 23:35:35.277498	2494
11150	47	2016-05-30 23:35:35.285411	2484
11151	47	2016-05-30 23:35:35.292988	2514
11152	47	2016-05-30 23:35:35.300725	2531
11153	47	2016-05-30 23:35:35.308519	2457
11154	47	2016-05-30 23:35:35.316278	2482
11155	47	2016-05-30 23:35:35.323922	2463
11156	47	2016-05-30 23:35:35.331961	2444
11157	47	2016-05-30 23:35:35.33956	2496
11158	41	2016-05-30 23:36:37.370065	2518
11159	41	2016-05-30 23:36:37.3798	2378
11160	41	2016-05-30 23:36:37.391171	2517
11161	41	2016-05-30 23:36:37.402143	2520
11162	41	2016-05-30 23:36:37.416275	2521
11163	41	2016-05-30 23:36:37.427774	2523
11164	41	2016-05-30 23:36:37.438755	2525
11165	41	2016-05-30 23:36:37.445152	2528
11166	41	2016-05-30 23:36:37.451137	2533
11167	41	2016-05-30 23:36:37.462425	2516
11168	41	2016-05-30 23:36:37.473575	2519
11169	41	2016-05-30 23:36:37.484187	2524
11170	41	2016-05-30 23:36:37.495129	2522
11171	46	2016-05-30 23:36:37.501831	2398
11172	45	2016-05-30 23:36:37.508804	2400
11173	44	2016-05-30 23:36:37.515188	2382
11174	42	2016-05-30 23:36:37.52169	2444
11175	42	2016-05-30 23:36:37.528399	2486
11176	42	2016-05-30 23:36:37.53446	2450
11177	42	2016-05-30 23:36:37.540882	2452
11178	42	2016-05-30 23:36:37.547013	2455
11179	42	2016-05-30 23:36:37.553536	2482
11180	42	2016-05-30 23:36:37.560261	2488
11181	42	2016-05-30 23:36:37.566556	2472
11182	42	2016-05-30 23:36:37.572804	2500
11183	42	2016-05-30 23:36:37.579526	2374
11184	42	2016-05-30 23:36:37.585639	2442
11185	42	2016-05-30 23:36:37.592626	2496
11186	42	2016-05-30 23:36:37.59899	2467
11187	42	2016-05-30 23:36:37.605583	2490
11188	42	2016-05-30 23:36:37.611933	2504
11189	42	2016-05-30 23:36:37.618096	2494
11190	42	2016-05-30 23:36:37.62456	2470
11191	42	2016-05-30 23:36:37.63092	2498
11192	42	2016-05-30 23:36:37.637027	2484
11193	42	2016-05-30 23:36:37.64376	2506
11194	42	2016-05-30 23:36:37.650127	2440
11195	42	2016-05-30 23:36:37.656721	2468
11196	42	2016-05-30 23:36:37.663375	2478
11197	42	2016-05-30 23:36:37.669489	2480
11198	42	2016-05-30 23:36:37.676094	2457
11199	42	2016-05-30 23:36:37.682453	2475
11200	42	2016-05-30 23:36:37.688703	2502
11201	42	2016-05-30 23:36:37.695276	2459
11202	42	2016-05-30 23:36:37.701303	2463
11203	42	2016-05-30 23:36:37.707623	2476
11204	42	2016-05-30 23:36:37.714037	2448
11205	42	2016-05-30 23:36:37.719982	2465
11206	42	2016-05-30 23:36:37.726571	2461
11207	42	2016-05-30 23:36:37.732804	2469
11208	42	2016-05-30 23:36:37.739049	2474
11209	42	2016-05-30 23:36:37.745054	2492
11210	43	2016-05-30 23:36:37.751334	2462
11211	43	2016-05-30 23:36:37.757514	2466
11212	43	2016-05-30 23:36:37.763599	2489
11213	43	2016-05-30 23:36:37.769745	2477
11214	43	2016-05-30 23:36:37.776698	2481
11215	43	2016-05-30 23:36:37.782821	2453
11216	43	2016-05-30 23:36:37.789165	2491
11217	43	2016-05-30 23:36:37.795431	2483
11218	43	2016-05-30 23:36:37.801304	2443
11219	43	2016-05-30 23:36:37.807467	2501
11220	43	2016-05-30 23:36:37.813431	2375
11221	43	2016-05-30 23:36:37.819679	2458
11222	43	2016-05-30 23:36:37.825998	2499
11223	43	2016-05-30 23:36:37.831826	2471
11224	43	2016-05-30 23:36:37.837988	2487
11225	43	2016-05-30 23:36:37.844216	2441
11226	43	2016-05-30 23:36:37.850249	2451
11227	43	2016-05-30 23:36:37.856308	2507
11228	43	2016-05-30 23:36:37.862377	2464
11229	43	2016-05-30 23:36:37.86839	2497
11230	43	2016-05-30 23:36:37.874471	2460
11231	43	2016-05-30 23:36:37.880563	2493
11232	43	2016-05-30 23:36:37.886679	2473
11233	43	2016-05-30 23:36:37.892751	2445
11234	43	2016-05-30 23:36:37.898725	2485
11235	43	2016-05-30 23:36:37.904892	2495
11236	43	2016-05-30 23:36:37.911533	2449
11237	43	2016-05-30 23:36:37.917643	2505
11238	43	2016-05-30 23:36:37.923702	2479
11239	43	2016-05-30 23:36:37.93024	2456
11240	43	2016-05-30 23:36:37.936391	2503
11241	40	2016-05-30 23:36:37.94342	47212
11242	40	2016-05-30 23:36:37.948907	47206
11243	40	2016-05-30 23:36:37.954304	47215
11244	40	2016-05-30 23:36:37.959807	47209
11245	40	2016-05-30 23:36:37.965307	47256
11246	40	2016-05-30 23:36:37.970963	47347
11247	40	2016-05-30 23:36:37.982111	47340
11248	40	2016-05-30 23:36:37.988377	47203
11249	40	2016-05-30 23:36:37.994834	47343
11250	49	2016-05-30 23:36:38.004783	47347
11251	49	2016-05-30 23:36:38.012153	47343
11252	49	2016-05-30 23:36:38.019624	47212
11253	49	2016-05-30 23:36:38.027901	47206
11254	49	2016-05-30 23:36:38.04048	47340
11255	49	2016-05-30 23:36:38.048011	47203
11256	49	2016-05-30 23:36:38.056149	47215
11257	49	2016-05-30 23:36:38.063555	47209
11258	49	2016-05-30 23:36:38.070405	47256
11259	48	2016-05-30 23:36:38.081129	2500
11260	48	2016-05-30 23:36:38.089584	2374
11261	48	2016-05-30 23:36:38.097572	2475
11262	48	2016-05-30 23:36:38.105547	2498
11263	48	2016-05-30 23:36:38.113451	2480
11264	48	2016-05-30 23:36:38.121307	2454
11265	48	2016-05-30 23:36:38.129198	2465
11266	48	2016-05-30 23:36:38.136937	2459
11267	48	2016-05-30 23:36:38.144815	2472
11268	48	2016-05-30 23:36:38.152592	2467
11269	48	2016-05-30 23:36:38.1604	2504
11270	48	2016-05-30 23:36:38.168385	2469
11271	48	2016-05-30 23:36:38.176352	2442
11272	48	2016-05-30 23:36:38.183993	2474
11273	48	2016-05-30 23:36:38.191958	2486
11274	48	2016-05-30 23:36:38.199682	2476
11275	48	2016-05-30 23:36:38.207525	2492
11276	48	2016-05-30 23:36:38.21536	2448
11277	48	2016-05-30 23:36:38.223987	2490
11278	48	2016-05-30 23:36:38.231967	2440
11279	48	2016-05-30 23:36:38.239822	2452
11280	48	2016-05-30 23:36:38.247437	2468
11281	48	2016-05-30 23:36:38.255936	2450
11282	48	2016-05-30 23:36:38.263747	2470
11283	48	2016-05-30 23:36:38.272136	2506
11284	48	2016-05-30 23:36:38.280244	2461
11285	48	2016-05-30 23:36:38.288205	2502
11286	48	2016-05-30 23:36:38.296249	2455
11287	48	2016-05-30 23:36:38.305187	2478
11288	48	2016-05-30 23:36:38.331902	2488
11289	48	2016-05-30 23:36:38.340951	2494
11290	48	2016-05-30 23:36:38.349018	2484
11291	48	2016-05-30 23:36:38.356624	2514
11292	48	2016-05-30 23:36:38.36452	2531
11293	48	2016-05-30 23:36:38.372432	2457
11294	48	2016-05-30 23:36:38.380255	2482
11295	48	2016-05-30 23:36:38.38834	2463
11296	48	2016-05-30 23:36:38.396297	2444
11297	48	2016-05-30 23:36:38.405027	2496
11298	50	2016-05-30 23:36:38.413612	47347
11299	50	2016-05-30 23:36:38.421179	47343
11300	50	2016-05-30 23:36:38.428612	47212
11301	50	2016-05-30 23:36:38.435865	47206
11302	50	2016-05-30 23:36:38.446876	47340
11303	50	2016-05-30 23:36:38.454183	47203
11304	50	2016-05-30 23:36:38.461659	47215
11305	50	2016-05-30 23:36:38.469246	47209
11306	50	2016-05-30 23:36:38.47617	47256
11307	47	2016-05-30 23:36:38.486092	2500
11308	47	2016-05-30 23:36:38.493965	2374
11309	47	2016-05-30 23:36:38.501792	2475
11310	47	2016-05-30 23:36:38.50948	2498
11311	47	2016-05-30 23:36:38.516935	2480
11312	47	2016-05-30 23:36:38.524535	2454
11313	47	2016-05-30 23:36:38.532274	2465
11314	47	2016-05-30 23:36:38.539857	2459
11315	47	2016-05-30 23:36:38.547418	2472
11316	47	2016-05-30 23:36:38.555695	2467
11317	47	2016-05-30 23:36:38.563326	2504
11318	47	2016-05-30 23:36:38.571392	2469
11319	47	2016-05-30 23:36:38.578906	2442
11320	47	2016-05-30 23:36:38.586616	2474
11321	47	2016-05-30 23:36:38.594203	2486
11322	47	2016-05-30 23:36:38.602273	2476
11323	47	2016-05-30 23:36:38.610222	2492
11324	47	2016-05-30 23:36:38.618062	2448
11325	47	2016-05-30 23:36:38.625742	2490
11326	47	2016-05-30 23:36:38.63341	2440
11327	47	2016-05-30 23:36:38.641088	2452
11328	47	2016-05-30 23:36:38.648882	2468
11329	47	2016-05-30 23:36:38.656351	2450
11330	47	2016-05-30 23:36:38.663996	2470
11331	47	2016-05-30 23:36:38.67159	2506
11332	47	2016-05-30 23:36:38.679144	2461
11333	47	2016-05-30 23:36:38.686726	2502
11334	47	2016-05-30 23:36:38.694219	2455
11335	47	2016-05-30 23:36:38.701793	2478
11336	47	2016-05-30 23:36:38.709397	2488
11337	47	2016-05-30 23:36:38.716968	2494
11338	47	2016-05-30 23:36:38.724775	2484
11339	47	2016-05-30 23:36:38.732212	2514
11340	47	2016-05-30 23:36:38.739571	2531
11341	47	2016-05-30 23:36:38.747086	2457
11342	47	2016-05-30 23:36:38.754827	2482
11343	47	2016-05-30 23:36:38.76238	2463
11344	47	2016-05-30 23:36:38.770017	2444
11345	47	2016-05-30 23:36:38.777761	2496
11346	42	2016-05-30 23:37:31.215266	2534
11347	41	2016-05-30 23:37:41.358971	2518
11348	41	2016-05-30 23:37:41.371125	2378
11349	41	2016-05-30 23:37:41.384792	2517
11350	41	2016-05-30 23:37:41.397441	2520
11351	41	2016-05-30 23:37:41.410112	2521
11352	41	2016-05-30 23:37:41.421543	2523
11353	41	2016-05-30 23:37:41.43279	2525
11354	41	2016-05-30 23:37:41.439054	2528
11355	41	2016-05-30 23:37:41.445177	2533
11356	41	2016-05-30 23:37:41.456213	2516
11357	41	2016-05-30 23:37:41.466952	2519
11358	41	2016-05-30 23:37:41.477626	2524
11359	41	2016-05-30 23:37:41.488616	2522
11360	46	2016-05-30 23:37:41.495908	2398
11361	45	2016-05-30 23:37:41.50424	2400
11362	44	2016-05-30 23:37:41.512429	2382
11363	42	2016-05-30 23:37:41.518978	2444
11364	42	2016-05-30 23:37:41.525091	2486
11365	42	2016-05-30 23:37:41.531209	2450
11366	42	2016-05-30 23:37:41.537331	2452
11367	42	2016-05-30 23:37:41.543964	2455
11368	42	2016-05-30 23:37:41.549914	2482
11369	42	2016-05-30 23:37:41.556357	2488
11370	42	2016-05-30 23:37:41.562789	2472
11371	42	2016-05-30 23:37:41.568943	2500
11372	42	2016-05-30 23:37:41.575119	2374
11373	42	2016-05-30 23:37:41.58167	2442
11374	42	2016-05-30 23:37:41.587963	2496
11375	42	2016-05-30 23:37:41.594034	2467
11376	42	2016-05-30 23:37:41.600719	2490
11377	42	2016-05-30 23:37:41.607286	2504
11378	42	2016-05-30 23:37:41.613355	2494
11379	42	2016-05-30 23:37:41.619766	2470
11380	42	2016-05-30 23:37:41.625983	2498
11381	42	2016-05-30 23:37:41.632925	2484
11382	42	2016-05-30 23:37:41.639758	2506
11383	42	2016-05-30 23:37:41.647721	2440
11384	42	2016-05-30 23:37:41.655241	2468
11385	42	2016-05-30 23:37:41.661393	2478
11386	42	2016-05-30 23:37:41.667307	2480
11387	42	2016-05-30 23:37:41.673359	2457
11388	42	2016-05-30 23:37:41.679394	2475
11389	42	2016-05-30 23:37:41.685347	2502
11390	42	2016-05-30 23:37:41.69161	2459
11391	42	2016-05-30 23:37:41.697536	2463
11392	42	2016-05-30 23:37:41.703811	2476
11393	42	2016-05-30 23:37:41.709842	2448
11394	42	2016-05-30 23:37:41.716002	2465
11395	42	2016-05-30 23:37:41.722312	2461
11396	42	2016-05-30 23:37:41.728602	2469
11397	42	2016-05-30 23:37:41.734856	2474
11398	42	2016-05-30 23:37:41.740835	2492
11399	43	2016-05-30 23:37:41.747392	2462
11400	43	2016-05-30 23:37:41.753873	2466
11401	43	2016-05-30 23:37:41.760351	2489
11402	43	2016-05-30 23:37:41.766669	2477
11403	43	2016-05-30 23:37:41.773916	2481
11404	43	2016-05-30 23:37:41.780943	2453
11405	43	2016-05-30 23:37:41.788428	2491
11406	43	2016-05-30 23:37:41.796048	2483
11407	43	2016-05-30 23:37:41.802246	2443
11408	43	2016-05-30 23:37:41.808666	2501
11409	43	2016-05-30 23:37:41.81469	2375
11410	43	2016-05-30 23:37:41.820827	2458
11411	43	2016-05-30 23:37:41.827276	2499
11412	43	2016-05-30 23:37:41.8333	2471
11413	43	2016-05-30 23:37:41.839508	2487
11414	43	2016-05-30 23:37:41.845728	2441
11415	43	2016-05-30 23:37:41.851755	2451
11416	43	2016-05-30 23:37:41.858152	2507
11417	43	2016-05-30 23:37:41.864301	2464
11418	43	2016-05-30 23:37:41.870485	2497
11419	43	2016-05-30 23:37:41.877155	2460
11420	43	2016-05-30 23:37:41.88313	2493
11421	43	2016-05-30 23:37:41.889189	2473
11422	43	2016-05-30 23:37:41.895623	2445
11423	43	2016-05-30 23:37:41.901744	2485
11424	43	2016-05-30 23:37:41.908413	2495
11425	43	2016-05-30 23:37:41.915007	2449
11426	43	2016-05-30 23:37:41.922528	2505
11427	43	2016-05-30 23:37:41.930167	2479
11428	43	2016-05-30 23:37:41.937149	2456
11429	43	2016-05-30 23:37:41.943929	2503
11430	40	2016-05-30 23:37:41.951152	47212
11431	40	2016-05-30 23:37:41.956868	47206
11432	40	2016-05-30 23:37:41.962813	47215
11433	40	2016-05-30 23:37:41.968497	47209
11434	40	2016-05-30 23:37:41.973961	47256
11435	40	2016-05-30 23:37:41.979761	47347
11436	40	2016-05-30 23:37:41.989811	47340
11437	40	2016-05-30 23:37:41.995742	47203
11438	40	2016-05-30 23:37:42.001396	47350
11439	40	2016-05-30 23:37:42.006958	47343
11440	49	2016-05-30 23:37:42.016117	47347
11441	49	2016-05-30 23:37:42.023197	47343
11442	49	2016-05-30 23:37:42.030919	47212
11443	49	2016-05-30 23:37:42.03794	47206
11444	49	2016-05-30 23:37:42.049957	47340
11445	49	2016-05-30 23:37:42.058287	47203
11446	49	2016-05-30 23:37:42.067513	47215
11447	49	2016-05-30 23:37:42.075907	47209
11448	49	2016-05-30 23:37:42.083025	47256
11449	48	2016-05-30 23:37:42.092945	2500
11450	48	2016-05-30 23:37:42.101338	2374
11451	48	2016-05-30 23:37:42.109575	2475
11452	48	2016-05-30 23:37:42.117793	2498
11453	48	2016-05-30 23:37:42.125775	2480
11454	48	2016-05-30 23:37:42.133377	2454
11455	48	2016-05-30 23:37:42.141361	2465
11456	48	2016-05-30 23:37:42.149132	2459
11457	48	2016-05-30 23:37:42.156911	2472
11458	48	2016-05-30 23:37:42.164971	2467
11459	48	2016-05-30 23:37:42.172988	2504
11460	48	2016-05-30 23:37:42.18127	2469
11461	48	2016-05-30 23:37:42.189896	2442
11462	48	2016-05-30 23:37:42.199036	2474
11463	48	2016-05-30 23:37:42.208819	2486
11464	48	2016-05-30 23:37:42.217778	2476
11465	48	2016-05-30 23:37:42.226375	2492
11466	48	2016-05-30 23:37:42.234157	2448
11467	48	2016-05-30 23:37:42.241991	2490
11468	48	2016-05-30 23:37:42.250055	2440
11469	48	2016-05-30 23:37:42.258203	2452
11470	48	2016-05-30 23:37:42.266056	2468
11471	48	2016-05-30 23:37:42.273981	2450
11472	48	2016-05-30 23:37:42.282082	2470
11473	48	2016-05-30 23:37:42.28997	2506
11474	48	2016-05-30 23:37:42.298295	2461
11475	48	2016-05-30 23:37:42.322554	2502
11476	48	2016-05-30 23:37:42.331832	2455
11477	48	2016-05-30 23:37:42.341986	2478
11478	48	2016-05-30 23:37:42.351916	2488
11479	48	2016-05-30 23:37:42.359828	2494
11480	48	2016-05-30 23:37:42.368278	2484
11481	48	2016-05-30 23:37:42.376097	2514
11482	48	2016-05-30 23:37:42.384101	2531
11483	48	2016-05-30 23:37:42.392693	2457
11484	48	2016-05-30 23:37:42.400725	2482
11485	48	2016-05-30 23:37:42.408838	2463
11486	48	2016-05-30 23:37:42.417291	2444
11487	48	2016-05-30 23:37:42.425315	2496
11488	50	2016-05-30 23:37:42.433661	47347
11489	50	2016-05-30 23:37:42.441127	47343
11490	50	2016-05-30 23:37:42.449395	47212
11491	50	2016-05-30 23:37:42.456998	47206
11492	50	2016-05-30 23:37:42.469435	47340
11493	50	2016-05-30 23:37:42.477865	47203
11494	50	2016-05-30 23:37:42.486666	47215
11495	50	2016-05-30 23:37:42.494858	47209
11496	50	2016-05-30 23:37:42.502405	47256
11497	47	2016-05-30 23:37:42.512139	2500
11498	47	2016-05-30 23:37:42.520288	2374
11499	47	2016-05-30 23:37:42.528215	2475
11500	47	2016-05-30 23:37:42.536257	2498
11501	47	2016-05-30 23:37:42.544057	2480
11502	47	2016-05-30 23:37:42.552195	2454
11503	47	2016-05-30 23:37:42.560358	2465
11504	47	2016-05-30 23:37:42.568258	2459
11505	47	2016-05-30 23:37:42.576323	2472
11506	47	2016-05-30 23:37:42.584216	2467
11507	47	2016-05-30 23:37:42.59238	2504
11508	47	2016-05-30 23:37:42.600131	2469
11509	47	2016-05-30 23:37:42.608099	2442
11510	47	2016-05-30 23:37:42.628937	2474
11511	47	2016-05-30 23:37:42.637488	2486
11512	47	2016-05-30 23:37:42.648778	2476
11513	47	2016-05-30 23:37:42.660338	2492
11514	47	2016-05-30 23:37:42.695145	2448
11515	47	2016-05-30 23:37:42.720167	2490
11516	47	2016-05-30 23:37:42.728873	2440
11517	47	2016-05-30 23:37:42.73666	2452
11518	47	2016-05-30 23:37:42.744387	2468
11519	47	2016-05-30 23:37:42.752007	2450
11520	47	2016-05-30 23:37:42.759535	2470
11521	47	2016-05-30 23:37:42.767228	2506
11522	47	2016-05-30 23:37:42.775178	2461
11523	47	2016-05-30 23:37:42.783263	2502
11524	47	2016-05-30 23:37:42.791016	2455
11525	47	2016-05-30 23:37:42.799365	2478
11526	47	2016-05-30 23:37:42.807149	2488
11527	47	2016-05-30 23:37:42.815412	2494
11528	47	2016-05-30 23:37:42.823398	2484
11529	47	2016-05-30 23:37:42.832967	2514
11530	47	2016-05-30 23:37:42.841443	2531
11531	47	2016-05-30 23:37:42.869124	2457
11532	47	2016-05-30 23:37:42.901444	2482
11533	47	2016-05-30 23:37:42.925037	2463
11534	47	2016-05-30 23:37:42.932989	2444
11535	47	2016-05-30 23:37:42.940772	2496
11536	47	2016-05-30 23:38:36.143721	2534
11537	41	2016-05-30 23:38:45.291989	2518
11538	41	2016-05-30 23:38:45.29876	2378
11539	41	2016-05-30 23:38:45.309373	2517
11540	41	2016-05-30 23:38:45.320351	2522
11541	41	2016-05-30 23:38:45.331218	2520
11542	41	2016-05-30 23:38:45.341838	2521
11543	41	2016-05-30 23:38:45.352982	2523
11544	41	2016-05-30 23:38:45.36377	2525
11545	41	2016-05-30 23:38:45.370084	2528
11546	41	2016-05-30 23:38:45.381452	2516
11547	41	2016-05-30 23:38:45.407631	2519
11548	41	2016-05-30 23:38:45.419023	2524
11549	46	2016-05-30 23:38:45.425769	2398
11550	45	2016-05-30 23:38:45.432703	2400
11551	44	2016-05-30 23:38:45.439345	2382
11552	42	2016-05-30 23:38:45.445654	2444
11553	42	2016-05-30 23:38:45.452742	2486
11554	42	2016-05-30 23:38:45.459375	2450
11555	42	2016-05-30 23:38:45.465725	2452
11556	42	2016-05-30 23:38:45.472035	2455
11557	42	2016-05-30 23:38:45.478218	2482
11558	42	2016-05-30 23:38:45.484717	2488
11559	42	2016-05-30 23:38:45.490746	2472
11560	42	2016-05-30 23:38:45.496931	2500
11561	42	2016-05-30 23:38:45.503533	2374
11562	42	2016-05-30 23:38:45.509804	2442
11563	42	2016-05-30 23:38:45.516609	2496
11564	42	2016-05-30 23:38:45.523095	2467
11565	42	2016-05-30 23:38:45.529225	2490
11566	42	2016-05-30 23:38:45.535724	2504
11567	42	2016-05-30 23:38:45.542	2494
11568	42	2016-05-30 23:38:45.548489	2470
11569	42	2016-05-30 23:38:45.555567	2498
11570	42	2016-05-30 23:38:45.561748	2484
11571	42	2016-05-30 23:38:45.56816	2506
11572	42	2016-05-30 23:38:45.575068	2440
11573	42	2016-05-30 23:38:45.581259	2468
11574	42	2016-05-30 23:38:45.587889	2478
11575	42	2016-05-30 23:38:45.593922	2480
11576	42	2016-05-30 23:38:45.600618	2457
11577	42	2016-05-30 23:38:45.606923	2475
11578	42	2016-05-30 23:38:45.613171	2502
11579	42	2016-05-30 23:38:45.619711	2459
11580	42	2016-05-30 23:38:45.625941	2463
11581	42	2016-05-30 23:38:45.632156	2476
11582	42	2016-05-30 23:38:45.638355	2448
11583	42	2016-05-30 23:38:45.644685	2465
11584	42	2016-05-30 23:38:45.650791	2461
11585	42	2016-05-30 23:38:45.657145	2469
11586	42	2016-05-30 23:38:45.663598	2474
11587	42	2016-05-30 23:38:45.670122	2492
11588	43	2016-05-30 23:38:45.676787	2462
11589	43	2016-05-30 23:38:45.68291	2466
11590	43	2016-05-30 23:38:45.689499	2489
11591	43	2016-05-30 23:38:45.695685	2477
11592	43	2016-05-30 23:38:45.70223	2481
11593	43	2016-05-30 23:38:45.708693	2453
11594	43	2016-05-30 23:38:45.714949	2491
11595	43	2016-05-30 23:38:45.721572	2483
11596	43	2016-05-30 23:38:45.728005	2443
11597	43	2016-05-30 23:38:45.734345	2501
11598	43	2016-05-30 23:38:45.740766	2375
11599	43	2016-05-30 23:38:45.746867	2458
11600	43	2016-05-30 23:38:45.7529	2499
11601	43	2016-05-30 23:38:45.759169	2471
11602	43	2016-05-30 23:38:45.76532	2487
11603	43	2016-05-30 23:38:45.772456	2441
11604	43	2016-05-30 23:38:45.778736	2451
11605	43	2016-05-30 23:38:45.784775	2507
11606	43	2016-05-30 23:38:45.790859	2464
11607	43	2016-05-30 23:38:45.796858	2497
11608	43	2016-05-30 23:38:45.803478	2460
11609	43	2016-05-30 23:38:45.809528	2493
11610	43	2016-05-30 23:38:45.815427	2473
11611	43	2016-05-30 23:38:45.82132	2445
11612	43	2016-05-30 23:38:45.827429	2485
11613	43	2016-05-30 23:38:45.833728	2495
11614	43	2016-05-30 23:38:45.840077	2449
11615	43	2016-05-30 23:38:45.84611	2505
11616	43	2016-05-30 23:38:45.852949	2479
11617	43	2016-05-30 23:38:45.859267	2456
11618	43	2016-05-30 23:38:45.865326	2503
11619	40	2016-05-30 23:38:45.872791	47212
11620	40	2016-05-30 23:38:45.878454	47206
11621	40	2016-05-30 23:38:45.884286	47215
11622	40	2016-05-30 23:38:45.890187	47209
11623	40	2016-05-30 23:38:45.89576	47256
11624	40	2016-05-30 23:38:45.901355	47347
11625	40	2016-05-30 23:38:45.911218	47340
11626	40	2016-05-30 23:38:45.916907	47203
11627	40	2016-05-30 23:38:45.923074	47350
11628	40	2016-05-30 23:38:45.928555	47343
11629	49	2016-05-30 23:38:45.937916	47347
11630	49	2016-05-30 23:38:45.94488	47343
11631	49	2016-05-30 23:38:45.952614	47212
11632	49	2016-05-30 23:38:45.959882	47206
11633	49	2016-05-30 23:38:45.967503	47350
11634	49	2016-05-30 23:38:45.979295	47340
11635	49	2016-05-30 23:38:45.986775	47203
11636	49	2016-05-30 23:38:45.994144	47215
11637	49	2016-05-30 23:38:46.001813	47209
11638	49	2016-05-30 23:38:46.009003	47256
11639	48	2016-05-30 23:38:46.019851	2500
11640	48	2016-05-30 23:38:46.028341	2374
11641	48	2016-05-30 23:38:46.036753	2475
11642	48	2016-05-30 23:38:46.044996	2498
11643	48	2016-05-30 23:38:46.05355	2480
11644	48	2016-05-30 23:38:46.061507	2454
11645	48	2016-05-30 23:38:46.069752	2465
11646	48	2016-05-30 23:38:46.078025	2459
11647	48	2016-05-30 23:38:46.086081	2472
11648	48	2016-05-30 23:38:46.094599	2467
11649	48	2016-05-30 23:38:46.102857	2504
11650	48	2016-05-30 23:38:46.111221	2469
11651	48	2016-05-30 23:38:46.119288	2442
11652	48	2016-05-30 23:38:46.127837	2474
11653	48	2016-05-30 23:38:46.136089	2486
11654	48	2016-05-30 23:38:46.144758	2476
11655	48	2016-05-30 23:38:46.15356	2492
11656	48	2016-05-30 23:38:46.161862	2448
11657	48	2016-05-30 23:38:46.169826	2490
11658	48	2016-05-30 23:38:46.178237	2440
11659	48	2016-05-30 23:38:46.186548	2452
11660	48	2016-05-30 23:38:46.194945	2468
11661	48	2016-05-30 23:38:46.20309	2450
11662	48	2016-05-30 23:38:46.211588	2470
11663	48	2016-05-30 23:38:46.220618	2506
11664	48	2016-05-30 23:38:46.229133	2461
11665	48	2016-05-30 23:38:46.237276	2502
11666	48	2016-05-30 23:38:46.245883	2455
11667	48	2016-05-30 23:38:46.254619	2478
11668	48	2016-05-30 23:38:46.262955	2488
11669	48	2016-05-30 23:38:46.270984	2494
11670	48	2016-05-30 23:38:46.27952	2484
11671	48	2016-05-30 23:38:46.287512	2514
11672	48	2016-05-30 23:38:46.295184	2531
11673	48	2016-05-30 23:38:46.30359	2457
11674	48	2016-05-30 23:38:46.311555	2482
11675	48	2016-05-30 23:38:46.320128	2463
11676	48	2016-05-30 23:38:46.327948	2444
11677	48	2016-05-30 23:38:46.340202	2496
11678	50	2016-05-30 23:38:46.349505	47347
11679	50	2016-05-30 23:38:46.357185	47343
11680	50	2016-05-30 23:38:46.365136	47212
11681	50	2016-05-30 23:38:46.372887	47206
11682	50	2016-05-30 23:38:46.384714	47340
11683	50	2016-05-30 23:38:46.392305	47203
11684	50	2016-05-30 23:38:46.399845	47215
11685	50	2016-05-30 23:38:46.407385	47209
11686	50	2016-05-30 23:38:46.414613	47256
11687	47	2016-05-30 23:38:46.424684	2500
11688	47	2016-05-30 23:38:46.432723	2374
11689	47	2016-05-30 23:38:46.440653	2475
11690	47	2016-05-30 23:38:46.453587	2498
11691	47	2016-05-30 23:38:46.462871	2480
11692	47	2016-05-30 23:38:46.478318	2454
11693	47	2016-05-30 23:38:46.486268	2465
11694	47	2016-05-30 23:38:46.494189	2459
11695	47	2016-05-30 23:38:46.502148	2472
11696	47	2016-05-30 23:38:46.509817	2467
11697	47	2016-05-30 23:38:46.517633	2504
11698	47	2016-05-30 23:38:46.525332	2469
11699	47	2016-05-30 23:38:46.533048	2442
11700	47	2016-05-30 23:38:46.541614	2474
11701	47	2016-05-30 23:38:46.549623	2486
11702	47	2016-05-30 23:38:46.55729	2476
11703	47	2016-05-30 23:38:46.565277	2492
11704	47	2016-05-30 23:38:46.573022	2448
11705	47	2016-05-30 23:38:46.580753	2490
11706	47	2016-05-30 23:38:46.589141	2440
11707	47	2016-05-30 23:38:46.596866	2452
11708	47	2016-05-30 23:38:46.604983	2468
11709	47	2016-05-30 23:38:46.61271	2450
11710	47	2016-05-30 23:38:46.620917	2470
11711	47	2016-05-30 23:38:46.628761	2506
11712	47	2016-05-30 23:38:46.636622	2461
11713	47	2016-05-30 23:38:46.644437	2502
11714	47	2016-05-30 23:38:46.652342	2455
11715	47	2016-05-30 23:38:46.659991	2478
11716	47	2016-05-30 23:38:46.667981	2488
11717	47	2016-05-30 23:38:46.675849	2494
11718	47	2016-05-30 23:38:46.683758	2484
11719	47	2016-05-30 23:38:46.691361	2514
11720	47	2016-05-30 23:38:46.698931	2531
11721	47	2016-05-30 23:38:46.706884	2457
11722	47	2016-05-30 23:38:46.714673	2482
11723	47	2016-05-30 23:38:46.722639	2463
11724	47	2016-05-30 23:38:46.730565	2444
11725	47	2016-05-30 23:38:46.738489	2496
11726	48	2016-05-30 23:39:39.487227	2534
11727	47	2016-05-30 23:39:39.859066	2534
11728	41	2016-05-30 23:39:48.658151	2518
11729	41	2016-05-30 23:39:48.665134	2378
11730	41	2016-05-30 23:39:48.675857	2517
11731	41	2016-05-30 23:39:48.686365	2522
11732	41	2016-05-30 23:39:48.697231	2520
11733	41	2016-05-30 23:39:48.708046	2521
11734	41	2016-05-30 23:39:48.718824	2523
11735	41	2016-05-30 23:39:48.729404	2525
11736	41	2016-05-30 23:39:48.735587	2528
11737	41	2016-05-30 23:39:48.746244	2516
11738	41	2016-05-30 23:39:48.757294	2519
11739	41	2016-05-30 23:39:48.76822	2524
11740	46	2016-05-30 23:39:48.774882	2398
11741	45	2016-05-30 23:39:48.781562	2400
11742	44	2016-05-30 23:39:48.787997	2382
11743	42	2016-05-30 23:39:48.794447	2444
11744	42	2016-05-30 23:39:48.800765	2486
11745	42	2016-05-30 23:39:48.807013	2450
11746	42	2016-05-30 23:39:48.81325	2452
11747	42	2016-05-30 23:39:48.819777	2455
11748	42	2016-05-30 23:39:48.825975	2482
11749	42	2016-05-30 23:39:48.83249	2488
11750	42	2016-05-30 23:39:48.838973	2472
11751	42	2016-05-30 23:39:48.845178	2500
11752	42	2016-05-30 23:39:48.851642	2374
11753	42	2016-05-30 23:39:48.857895	2442
11754	42	2016-05-30 23:39:48.863912	2496
11755	42	2016-05-30 23:39:48.87046	2467
11756	42	2016-05-30 23:39:48.876812	2490
11757	42	2016-05-30 23:39:48.882972	2504
11758	42	2016-05-30 23:39:48.889417	2494
11759	42	2016-05-30 23:39:48.895434	2470
11760	42	2016-05-30 23:39:48.902457	2498
11761	42	2016-05-30 23:39:48.908466	2484
11762	42	2016-05-30 23:39:48.914557	2506
11763	42	2016-05-30 23:39:48.921287	2440
11764	42	2016-05-30 23:39:48.927411	2468
11765	42	2016-05-30 23:39:48.933432	2478
11766	42	2016-05-30 23:39:48.939729	2480
11767	42	2016-05-30 23:39:48.945863	2457
11768	42	2016-05-30 23:39:48.952762	2475
11769	42	2016-05-30 23:39:48.95885	2502
11770	42	2016-05-30 23:39:48.965017	2459
11771	42	2016-05-30 23:39:48.971496	2463
11772	42	2016-05-30 23:39:48.977755	2476
11773	42	2016-05-30 23:39:48.984489	2448
11774	42	2016-05-30 23:39:48.991079	2465
11775	42	2016-05-30 23:39:48.997143	2461
11776	42	2016-05-30 23:39:49.003634	2469
11777	42	2016-05-30 23:39:49.009805	2474
11778	42	2016-05-30 23:39:49.015925	2492
11779	43	2016-05-30 23:39:49.022638	2462
11780	43	2016-05-30 23:39:49.029006	2466
11781	43	2016-05-30 23:39:49.035629	2489
11782	43	2016-05-30 23:39:49.041769	2477
11783	43	2016-05-30 23:39:49.047793	2481
11784	43	2016-05-30 23:39:49.054057	2453
11785	43	2016-05-30 23:39:49.06007	2491
11786	43	2016-05-30 23:39:49.066216	2483
11787	43	2016-05-30 23:39:49.072324	2443
11788	43	2016-05-30 23:39:49.078303	2501
11789	43	2016-05-30 23:39:49.084322	2375
11790	43	2016-05-30 23:39:49.090416	2458
11791	43	2016-05-30 23:39:49.096428	2499
11792	43	2016-05-30 23:39:49.10271	2471
11793	43	2016-05-30 23:39:49.108767	2487
11794	43	2016-05-30 23:39:49.114881	2441
11795	43	2016-05-30 23:39:49.120927	2451
11796	43	2016-05-30 23:39:49.127035	2507
11797	43	2016-05-30 23:39:49.13335	2464
11798	43	2016-05-30 23:39:49.139581	2497
11799	43	2016-05-30 23:39:49.145524	2460
11800	43	2016-05-30 23:39:49.151546	2493
11801	43	2016-05-30 23:39:49.157735	2473
11802	43	2016-05-30 23:39:49.163774	2445
11803	43	2016-05-30 23:39:49.169945	2485
11804	43	2016-05-30 23:39:49.176071	2495
11805	43	2016-05-30 23:39:49.182076	2449
11806	43	2016-05-30 23:39:49.18817	2505
11807	43	2016-05-30 23:39:49.194206	2479
11808	43	2016-05-30 23:39:49.200508	2456
11809	43	2016-05-30 23:39:49.206392	2503
11810	40	2016-05-30 23:39:49.21351	47212
11811	40	2016-05-30 23:39:49.219883	47206
11812	40	2016-05-30 23:39:49.22553	47215
11813	40	2016-05-30 23:39:49.231361	47209
11814	40	2016-05-30 23:39:49.237169	47256
11815	40	2016-05-30 23:39:49.24306	47347
11816	40	2016-05-30 23:39:49.253132	47340
11817	40	2016-05-30 23:39:49.258607	47203
11818	40	2016-05-30 23:39:49.264249	47350
11819	40	2016-05-30 23:39:49.269991	47343
11820	49	2016-05-30 23:39:49.278957	47347
11821	49	2016-05-30 23:39:49.286488	47343
11822	49	2016-05-30 23:39:49.293649	47212
11823	49	2016-05-30 23:39:49.301237	47206
11824	49	2016-05-30 23:39:49.308061	47350
11825	49	2016-05-30 23:39:49.319579	47340
11826	49	2016-05-30 23:39:49.326763	47203
11827	49	2016-05-30 23:39:49.333895	47215
11828	49	2016-05-30 23:39:49.34149	47209
11829	49	2016-05-30 23:39:49.348426	47256
11830	48	2016-05-30 23:39:49.359061	2500
11831	48	2016-05-30 23:39:49.367154	2374
11832	48	2016-05-30 23:39:49.375361	2475
11833	48	2016-05-30 23:39:49.383485	2498
11834	48	2016-05-30 23:39:49.391714	2480
11835	48	2016-05-30 23:39:49.407088	2454
11836	48	2016-05-30 23:39:49.415127	2465
11837	48	2016-05-30 23:39:49.423673	2459
11838	48	2016-05-30 23:39:49.43174	2472
11839	48	2016-05-30 23:39:49.440181	2467
11840	48	2016-05-30 23:39:49.448735	2504
11841	48	2016-05-30 23:39:49.457613	2469
11842	48	2016-05-30 23:39:49.481425	2442
11843	48	2016-05-30 23:39:49.489969	2474
11844	48	2016-05-30 23:39:49.498676	2486
11845	48	2016-05-30 23:39:49.506908	2476
11846	48	2016-05-30 23:39:49.514809	2492
11847	48	2016-05-30 23:39:49.522642	2448
11848	48	2016-05-30 23:39:49.531058	2490
11849	48	2016-05-30 23:39:49.539102	2440
11850	48	2016-05-30 23:39:49.547352	2452
11851	48	2016-05-30 23:39:49.555543	2468
11852	48	2016-05-30 23:39:49.563482	2450
11853	48	2016-05-30 23:39:49.571557	2470
11854	48	2016-05-30 23:39:49.57964	2506
11855	48	2016-05-30 23:39:49.58779	2461
11856	48	2016-05-30 23:39:49.596097	2502
11857	48	2016-05-30 23:39:49.60437	2455
11858	48	2016-05-30 23:39:49.612789	2478
11859	48	2016-05-30 23:39:49.620852	2488
11860	48	2016-05-30 23:39:49.629295	2494
11861	48	2016-05-30 23:39:49.637669	2484
11862	48	2016-05-30 23:39:49.645891	2514
11863	48	2016-05-30 23:39:49.653631	2531
11864	48	2016-05-30 23:39:49.661522	2457
11865	48	2016-05-30 23:39:49.669541	2482
11866	48	2016-05-30 23:39:49.67796	2463
11867	48	2016-05-30 23:39:49.68625	2444
11868	48	2016-05-30 23:39:49.694356	2496
11869	50	2016-05-30 23:39:49.703009	47347
11870	50	2016-05-30 23:39:49.710549	47343
11871	50	2016-05-30 23:39:49.717973	47212
11872	50	2016-05-30 23:39:49.725603	47206
11873	50	2016-05-30 23:39:49.732996	47350
11874	50	2016-05-30 23:39:49.744552	47340
11875	50	2016-05-30 23:39:49.752168	47203
11876	50	2016-05-30 23:39:49.759636	47215
11877	50	2016-05-30 23:39:49.767464	47209
11878	50	2016-05-30 23:39:49.775068	47256
11879	47	2016-05-30 23:39:49.785232	2500
11880	47	2016-05-30 23:39:49.793613	2374
11881	47	2016-05-30 23:39:49.801627	2475
11882	47	2016-05-30 23:39:49.809346	2498
11883	47	2016-05-30 23:39:49.816994	2480
11884	47	2016-05-30 23:39:49.831985	2454
11885	47	2016-05-30 23:39:49.840143	2465
11886	47	2016-05-30 23:39:49.848039	2459
11887	47	2016-05-30 23:39:49.856089	2472
11888	47	2016-05-30 23:39:49.864057	2467
11889	47	2016-05-30 23:39:49.872174	2504
11890	47	2016-05-30 23:39:49.880222	2469
11891	47	2016-05-30 23:39:49.888284	2442
11892	47	2016-05-30 23:39:49.896319	2474
11893	47	2016-05-30 23:39:49.904057	2486
11894	47	2016-05-30 23:39:49.912405	2476
11895	47	2016-05-30 23:39:49.920165	2492
11896	47	2016-05-30 23:39:49.927983	2448
11897	47	2016-05-30 23:39:49.935774	2490
11898	47	2016-05-30 23:39:49.943822	2440
11899	47	2016-05-30 23:39:49.951664	2452
11900	47	2016-05-30 23:39:49.959617	2468
11901	47	2016-05-30 23:39:49.967355	2450
11902	47	2016-05-30 23:39:49.975276	2470
11903	47	2016-05-30 23:39:49.983119	2506
11904	47	2016-05-30 23:39:49.990934	2461
11905	47	2016-05-30 23:39:49.998747	2502
11906	47	2016-05-30 23:39:50.006465	2455
11907	47	2016-05-30 23:39:50.014235	2478
11908	47	2016-05-30 23:39:50.021911	2488
11909	47	2016-05-30 23:39:50.029881	2494
11910	47	2016-05-30 23:39:50.037936	2484
11911	47	2016-05-30 23:39:50.045606	2514
11912	47	2016-05-30 23:39:50.05325	2531
11913	47	2016-05-30 23:39:50.06106	2457
11914	47	2016-05-30 23:39:50.06883	2482
11915	47	2016-05-30 23:39:50.07652	2463
11916	47	2016-05-30 23:39:50.084432	2444
11917	47	2016-05-30 23:39:50.092372	2496
11918	41	2016-05-30 23:48:20.988168	2518
11919	41	2016-05-30 23:48:20.994703	2543
11920	41	2016-05-30 23:48:21.001141	2378
11921	41	2016-05-30 23:48:21.01298	2517
11922	41	2016-05-30 23:48:21.02476	2520
11923	41	2016-05-30 23:48:21.036051	2521
11924	41	2016-05-30 23:48:21.047393	2523
11925	41	2016-05-30 23:48:21.058128	2525
11926	41	2016-05-30 23:48:21.064832	2528
11927	41	2016-05-30 23:48:21.075437	2516
11928	41	2016-05-30 23:48:21.086408	2519
11929	41	2016-05-30 23:48:21.097645	2524
11930	41	2016-05-30 23:48:21.108646	2522
11931	46	2016-05-30 23:48:21.116089	2398
11932	46	2016-05-30 23:48:21.12228	2542
11933	45	2016-05-30 23:48:21.129427	2400
11934	44	2016-05-30 23:48:21.136182	2382
11935	42	2016-05-30 23:48:21.142758	2444
11936	42	2016-05-30 23:48:21.149572	2486
11937	42	2016-05-30 23:48:21.155746	2450
11938	42	2016-05-30 23:48:21.162311	2452
11939	42	2016-05-30 23:48:21.168431	2455
11940	42	2016-05-30 23:48:21.174582	2482
11941	42	2016-05-30 23:48:21.181297	2488
11942	42	2016-05-30 23:48:21.188504	2472
11943	42	2016-05-30 23:48:21.19529	2500
11944	42	2016-05-30 23:48:21.201561	2374
11945	42	2016-05-30 23:48:21.208593	2442
11946	42	2016-05-30 23:48:21.215424	2496
11947	42	2016-05-30 23:48:21.221844	2467
11948	42	2016-05-30 23:48:21.228244	2490
11949	42	2016-05-30 23:48:21.234452	2504
11950	42	2016-05-30 23:48:21.240486	2494
11951	42	2016-05-30 23:48:21.247046	2470
11952	42	2016-05-30 23:48:21.253197	2498
11953	42	2016-05-30 23:48:21.259445	2484
11954	42	2016-05-30 23:48:21.265522	2506
11955	42	2016-05-30 23:48:21.271782	2440
11956	42	2016-05-30 23:48:21.278121	2468
11957	42	2016-05-30 23:48:21.285629	2478
11958	42	2016-05-30 23:48:21.292009	2480
11959	42	2016-05-30 23:48:21.298597	2457
11960	42	2016-05-30 23:48:21.305125	2475
11961	42	2016-05-30 23:48:21.311688	2502
11962	42	2016-05-30 23:48:21.318553	2459
11963	42	2016-05-30 23:48:21.324731	2463
11964	42	2016-05-30 23:48:21.331384	2476
11965	42	2016-05-30 23:48:21.337794	2448
11966	42	2016-05-30 23:48:21.343925	2465
11967	42	2016-05-30 23:48:21.350129	2461
11968	42	2016-05-30 23:48:21.356402	2469
11969	42	2016-05-30 23:48:21.362797	2474
11970	42	2016-05-30 23:48:21.368993	2492
11971	43	2016-05-30 23:48:21.375395	2462
11972	43	2016-05-30 23:48:21.381541	2466
11973	43	2016-05-30 23:48:21.387637	2489
11974	43	2016-05-30 23:48:21.393707	2477
11975	43	2016-05-30 23:48:21.400091	2481
11976	43	2016-05-30 23:48:21.40618	2453
11977	43	2016-05-30 23:48:21.412308	2491
11978	43	2016-05-30 23:48:21.418356	2483
11979	43	2016-05-30 23:48:21.42459	2443
11980	43	2016-05-30 23:48:21.430815	2501
11981	43	2016-05-30 23:48:21.436838	2375
11982	43	2016-05-30 23:48:21.443145	2458
11983	43	2016-05-30 23:48:21.449251	2499
11984	43	2016-05-30 23:48:21.455412	2471
11985	43	2016-05-30 23:48:21.461512	2487
11986	43	2016-05-30 23:48:21.468078	2441
11987	43	2016-05-30 23:48:21.474205	2451
11988	43	2016-05-30 23:48:21.480463	2507
11989	43	2016-05-30 23:48:21.486865	2464
11990	43	2016-05-30 23:48:21.494395	2497
11991	43	2016-05-30 23:48:21.500664	2460
11992	43	2016-05-30 23:48:21.506917	2493
11993	43	2016-05-30 23:48:21.513438	2473
11994	43	2016-05-30 23:48:21.519592	2445
11995	43	2016-05-30 23:48:21.525792	2485
11996	43	2016-05-30 23:48:21.532192	2495
11997	43	2016-05-30 23:48:21.53905	2449
11998	43	2016-05-30 23:48:21.54543	2505
11999	43	2016-05-30 23:48:21.551808	2479
12000	43	2016-05-30 23:48:21.557929	2456
12001	43	2016-05-30 23:48:21.563958	2503
12002	40	2016-05-30 23:48:21.571754	47212
12003	40	2016-05-30 23:48:21.577353	47206
12004	40	2016-05-30 23:48:21.583201	47215
12005	40	2016-05-30 23:48:21.589274	47209
12006	40	2016-05-30 23:48:21.594859	47256
12007	40	2016-05-30 23:48:21.60061	47347
12008	40	2016-05-30 23:48:21.61144	47340
12009	40	2016-05-30 23:48:21.617218	47203
12010	40	2016-05-30 23:48:21.622747	47350
12011	40	2016-05-30 23:48:21.629159	47343
12012	49	2016-05-30 23:48:21.638169	47347
12013	49	2016-05-30 23:48:21.645474	47343
12014	49	2016-05-30 23:48:21.652529	47212
12015	49	2016-05-30 23:48:21.659897	47206
12016	49	2016-05-30 23:48:21.666991	47350
12017	49	2016-05-30 23:48:21.677971	47340
12018	49	2016-05-30 23:48:21.68514	47203
12019	49	2016-05-30 23:48:21.692296	47215
12020	49	2016-05-30 23:48:21.69979	47209
12021	49	2016-05-30 23:48:21.706713	47256
12022	48	2016-05-30 23:48:21.717103	2500
12023	48	2016-05-30 23:48:21.7252	2374
12024	48	2016-05-30 23:48:21.733136	2475
12025	48	2016-05-30 23:48:21.741119	2498
12026	48	2016-05-30 23:48:21.749195	2480
12027	48	2016-05-30 23:48:21.756878	2534
12028	48	2016-05-30 23:48:21.764874	2454
12029	48	2016-05-30 23:48:21.772987	2465
12030	48	2016-05-30 23:48:21.781584	2459
12031	48	2016-05-30 23:48:21.789562	2472
12032	48	2016-05-30 23:48:21.799213	2467
12033	48	2016-05-30 23:48:21.807684	2504
12034	48	2016-05-30 23:48:21.816098	2469
12035	48	2016-05-30 23:48:21.824131	2442
12036	48	2016-05-30 23:48:21.832269	2474
12037	48	2016-05-30 23:48:21.840252	2486
12038	48	2016-05-30 23:48:21.848835	2476
12039	48	2016-05-30 23:48:21.857243	2492
12040	48	2016-05-30 23:48:21.865277	2448
12041	48	2016-05-30 23:48:21.873109	2490
12042	48	2016-05-30 23:48:21.881526	2440
12043	48	2016-05-30 23:48:21.889529	2452
12044	48	2016-05-30 23:48:21.897908	2468
12045	48	2016-05-30 23:48:21.905989	2450
12046	48	2016-05-30 23:48:21.914206	2470
12047	48	2016-05-30 23:48:21.922292	2506
12048	48	2016-05-30 23:48:21.93046	2461
12049	48	2016-05-30 23:48:21.938477	2502
12050	48	2016-05-30 23:48:21.946455	2455
12051	48	2016-05-30 23:48:21.954643	2478
12052	48	2016-05-30 23:48:21.962783	2488
12053	48	2016-05-30 23:48:21.970789	2494
12054	48	2016-05-30 23:48:21.978884	2484
12055	48	2016-05-30 23:48:21.986674	2514
12056	48	2016-05-30 23:48:21.994369	2531
12057	48	2016-05-30 23:48:22.00252	2457
12058	48	2016-05-30 23:48:22.010826	2482
12059	48	2016-05-30 23:48:22.018902	2463
12060	48	2016-05-30 23:48:22.026889	2444
12061	48	2016-05-30 23:48:22.035042	2496
12062	50	2016-05-30 23:48:22.043652	47347
12063	50	2016-05-30 23:48:22.050951	47343
12064	50	2016-05-30 23:48:22.05868	47212
12065	50	2016-05-30 23:48:22.066397	47206
12066	50	2016-05-30 23:48:22.073732	47350
12067	50	2016-05-30 23:48:22.085004	47340
12068	50	2016-05-30 23:48:22.092475	47203
12069	50	2016-05-30 23:48:22.100781	47215
12070	50	2016-05-30 23:48:22.109404	47209
12071	50	2016-05-30 23:48:22.116925	47256
12072	47	2016-05-30 23:48:22.127071	2500
12073	47	2016-05-30 23:48:22.135011	2374
12074	47	2016-05-30 23:48:22.14286	2475
12075	47	2016-05-30 23:48:22.151022	2498
12076	47	2016-05-30 23:48:22.158923	2480
12077	47	2016-05-30 23:48:22.166582	2534
12078	47	2016-05-30 23:48:22.174311	2454
12079	47	2016-05-30 23:48:22.182327	2465
12080	47	2016-05-30 23:48:22.190147	2459
12081	47	2016-05-30 23:48:22.197953	2472
12082	47	2016-05-30 23:48:22.206547	2467
12083	47	2016-05-30 23:48:22.214547	2504
12084	47	2016-05-30 23:48:22.222414	2469
12085	47	2016-05-30 23:48:22.230491	2442
12086	47	2016-05-30 23:48:22.238499	2474
12087	47	2016-05-30 23:48:22.247511	2486
12088	47	2016-05-30 23:48:22.255765	2476
12089	47	2016-05-30 23:48:22.263852	2492
12090	47	2016-05-30 23:48:22.27185	2448
12091	47	2016-05-30 23:48:22.279594	2490
12092	47	2016-05-30 23:48:22.28881	2440
12093	47	2016-05-30 23:48:22.296989	2452
12094	47	2016-05-30 23:48:22.305074	2468
12095	47	2016-05-30 23:48:22.313276	2450
12096	47	2016-05-30 23:48:22.321388	2470
12097	47	2016-05-30 23:48:22.329213	2506
12098	47	2016-05-30 23:48:22.336963	2461
12099	47	2016-05-30 23:48:22.344869	2502
12100	47	2016-05-30 23:48:22.352942	2455
12101	47	2016-05-30 23:48:22.361048	2478
12102	47	2016-05-30 23:48:22.368788	2488
12103	47	2016-05-30 23:48:22.376575	2494
12104	47	2016-05-30 23:48:22.384483	2484
12105	47	2016-05-30 23:48:22.39215	2514
12106	47	2016-05-30 23:48:22.399757	2531
12107	47	2016-05-30 23:48:22.407927	2457
12108	47	2016-05-30 23:48:22.416933	2482
12109	47	2016-05-30 23:48:22.424742	2463
12110	47	2016-05-30 23:48:22.432718	2444
12111	47	2016-05-30 23:48:22.440792	2496
12112	41	2016-05-30 23:49:23.737973	2518
12113	41	2016-05-30 23:49:23.745023	2543
12114	41	2016-05-30 23:49:23.755893	2378
12115	41	2016-05-30 23:49:23.766675	2517
12116	41	2016-05-30 23:49:23.777441	2520
12117	41	2016-05-30 23:49:23.788588	2521
12118	41	2016-05-30 23:49:23.800148	2523
12119	41	2016-05-30 23:49:23.810804	2525
12120	41	2016-05-30 23:49:23.817743	2528
12121	41	2016-05-30 23:49:23.828268	2516
12122	41	2016-05-30 23:49:23.839964	2519
12123	41	2016-05-30 23:49:23.850596	2524
12124	41	2016-05-30 23:49:23.861296	2522
12125	46	2016-05-30 23:49:23.86832	2398
12126	46	2016-05-30 23:49:23.874585	2542
12127	45	2016-05-30 23:49:23.881305	2400
12128	44	2016-05-30 23:49:23.887943	2382
12129	42	2016-05-30 23:49:23.894271	2444
12130	42	2016-05-30 23:49:23.900771	2486
12131	42	2016-05-30 23:49:23.906927	2450
12132	42	2016-05-30 23:49:23.913097	2452
12133	42	2016-05-30 23:49:23.919153	2455
12134	42	2016-05-30 23:49:23.925262	2482
12135	42	2016-05-30 23:49:23.931586	2488
12136	42	2016-05-30 23:49:23.937807	2472
12137	42	2016-05-30 23:49:23.94386	2500
12138	42	2016-05-30 23:49:23.94996	2374
12139	42	2016-05-30 23:49:23.956198	2442
12140	42	2016-05-30 23:49:23.962454	2496
12141	42	2016-05-30 23:49:23.968733	2467
12142	42	2016-05-30 23:49:23.974944	2490
12143	42	2016-05-30 23:49:23.981178	2504
12144	42	2016-05-30 23:49:23.987344	2494
12145	42	2016-05-30 23:49:23.993379	2470
12146	42	2016-05-30 23:49:23.999782	2498
12147	42	2016-05-30 23:49:24.006212	2484
12148	42	2016-05-30 23:49:24.01294	2506
12149	42	2016-05-30 23:49:24.019128	2440
12150	42	2016-05-30 23:49:24.025328	2468
12151	42	2016-05-30 23:49:24.03143	2478
12152	42	2016-05-30 23:49:24.03766	2480
12153	42	2016-05-30 23:49:24.043826	2457
12154	42	2016-05-30 23:49:24.050627	2475
12155	42	2016-05-30 23:49:24.057858	2502
12156	42	2016-05-30 23:49:24.064841	2459
12157	42	2016-05-30 23:49:24.071269	2463
12158	42	2016-05-30 23:49:24.077621	2476
12159	42	2016-05-30 23:49:24.084348	2448
12160	42	2016-05-30 23:49:24.090554	2465
12161	42	2016-05-30 23:49:24.096733	2461
12162	42	2016-05-30 23:49:24.102966	2469
12163	42	2016-05-30 23:49:24.10915	2474
12164	42	2016-05-30 23:49:24.115231	2492
12165	43	2016-05-30 23:49:24.121963	2462
12166	43	2016-05-30 23:49:24.128138	2466
12167	43	2016-05-30 23:49:24.134191	2489
12168	43	2016-05-30 23:49:24.140468	2477
12169	43	2016-05-30 23:49:24.14678	2481
12170	43	2016-05-30 23:49:24.153163	2453
12171	43	2016-05-30 23:49:24.159393	2491
12172	43	2016-05-30 23:49:24.166155	2483
12173	43	2016-05-30 23:49:24.172211	2443
12174	43	2016-05-30 23:49:24.178554	2501
12175	43	2016-05-30 23:49:24.185065	2375
12176	43	2016-05-30 23:49:24.191181	2458
12177	43	2016-05-30 23:49:24.197875	2499
12178	43	2016-05-30 23:49:24.204758	2471
12179	43	2016-05-30 23:49:24.210973	2487
12180	43	2016-05-30 23:49:24.217672	2441
12181	43	2016-05-30 23:49:24.22403	2451
12182	43	2016-05-30 23:49:24.230602	2507
12183	43	2016-05-30 23:49:24.236986	2464
12184	43	2016-05-30 23:49:24.243601	2497
12185	43	2016-05-30 23:49:24.266182	2460
12186	43	2016-05-30 23:49:24.290402	2493
12187	43	2016-05-30 23:49:24.298163	2473
12188	43	2016-05-30 23:49:24.304525	2445
12189	43	2016-05-30 23:49:24.311278	2485
12190	43	2016-05-30 23:49:24.318593	2495
12191	43	2016-05-30 23:49:24.324836	2449
12192	43	2016-05-30 23:49:24.331502	2505
12193	43	2016-05-30 23:49:24.337686	2479
12194	43	2016-05-30 23:49:24.344181	2456
12195	43	2016-05-30 23:49:24.351679	2503
12196	40	2016-05-30 23:49:24.358865	47212
12197	40	2016-05-30 23:49:24.365011	47206
12198	40	2016-05-30 23:49:24.370501	47215
12199	40	2016-05-30 23:49:24.376139	47209
12200	40	2016-05-30 23:49:24.382063	47256
12201	40	2016-05-30 23:49:24.387701	47347
12202	40	2016-05-30 23:49:24.397454	47340
12203	40	2016-05-30 23:49:24.403098	47203
12204	40	2016-05-30 23:49:24.408742	47350
12205	40	2016-05-30 23:49:24.414417	47343
12206	49	2016-05-30 23:49:24.423453	47347
12207	49	2016-05-30 23:49:24.430692	47343
12208	49	2016-05-30 23:49:24.438016	47212
12209	49	2016-05-30 23:49:24.445279	47206
12210	49	2016-05-30 23:49:24.452325	47350
12211	49	2016-05-30 23:49:24.463581	47340
12212	49	2016-05-30 23:49:24.47088	47203
12213	49	2016-05-30 23:49:24.478162	47215
12214	49	2016-05-30 23:49:24.485383	47209
12215	49	2016-05-30 23:49:24.492468	47256
12216	48	2016-05-30 23:49:24.502858	2500
12217	48	2016-05-30 23:49:24.511142	2374
12218	48	2016-05-30 23:49:24.519163	2475
12219	48	2016-05-30 23:49:24.527235	2498
12220	48	2016-05-30 23:49:24.535292	2480
12221	48	2016-05-30 23:49:24.543041	2534
12222	48	2016-05-30 23:49:24.551041	2454
12223	48	2016-05-30 23:49:24.559616	2465
12224	48	2016-05-30 23:49:24.569059	2459
12225	48	2016-05-30 23:49:24.577272	2472
12226	48	2016-05-30 23:49:24.585834	2467
12227	48	2016-05-30 23:49:24.593983	2504
12228	48	2016-05-30 23:49:24.602119	2469
12229	48	2016-05-30 23:49:24.610972	2442
12230	48	2016-05-30 23:49:24.619116	2474
12231	48	2016-05-30 23:49:24.627252	2486
12232	48	2016-05-30 23:49:24.635309	2476
12233	48	2016-05-30 23:49:24.643472	2492
12234	48	2016-05-30 23:49:24.651831	2448
12235	48	2016-05-30 23:49:24.659955	2490
12236	48	2016-05-30 23:49:24.668237	2440
12237	48	2016-05-30 23:49:24.676349	2452
12238	48	2016-05-30 23:49:24.684679	2468
12239	48	2016-05-30 23:49:24.692845	2450
12240	48	2016-05-30 23:49:24.701018	2470
12241	48	2016-05-30 23:49:24.708988	2506
12242	48	2016-05-30 23:49:24.717155	2461
12243	48	2016-05-30 23:49:24.725536	2502
12244	48	2016-05-30 23:49:24.733718	2455
12245	48	2016-05-30 23:49:24.741761	2478
12246	48	2016-05-30 23:49:24.750055	2488
12247	48	2016-05-30 23:49:24.758424	2494
12248	48	2016-05-30 23:49:24.766566	2484
12249	48	2016-05-30 23:49:24.774263	2514
12250	48	2016-05-30 23:49:24.781889	2531
12251	48	2016-05-30 23:49:24.789975	2457
12252	48	2016-05-30 23:49:24.798244	2482
12253	48	2016-05-30 23:49:24.806246	2463
12254	48	2016-05-30 23:49:24.814408	2444
12255	48	2016-05-30 23:49:24.82374	2496
12256	50	2016-05-30 23:49:24.832995	47347
12257	50	2016-05-30 23:49:24.84171	47343
12258	50	2016-05-30 23:49:24.849459	47212
12259	50	2016-05-30 23:49:24.857004	47206
12260	50	2016-05-30 23:49:24.864649	47350
12261	50	2016-05-30 23:49:24.876186	47340
12262	50	2016-05-30 23:49:24.88353	47203
12263	50	2016-05-30 23:49:24.890933	47215
12264	50	2016-05-30 23:49:24.898902	47209
12265	50	2016-05-30 23:49:24.906488	47256
12266	47	2016-05-30 23:49:24.91663	2500
12267	47	2016-05-30 23:49:24.925108	2374
12268	47	2016-05-30 23:49:24.933151	2475
12269	47	2016-05-30 23:49:24.941066	2498
12270	47	2016-05-30 23:49:24.949158	2480
12271	47	2016-05-30 23:49:24.956727	2534
12272	47	2016-05-30 23:49:24.964584	2454
12273	47	2016-05-30 23:49:24.97237	2465
12274	47	2016-05-30 23:49:24.980611	2459
12275	47	2016-05-30 23:49:24.988562	2472
12276	47	2016-05-30 23:49:24.996509	2467
12277	47	2016-05-30 23:49:25.00429	2504
12278	47	2016-05-30 23:49:25.012686	2469
12279	47	2016-05-30 23:49:25.020595	2442
12280	47	2016-05-30 23:49:25.028969	2474
12281	47	2016-05-30 23:49:25.03713	2486
12282	47	2016-05-30 23:49:25.045261	2476
12283	47	2016-05-30 23:49:25.052989	2492
12284	47	2016-05-30 23:49:25.06129	2448
12285	47	2016-05-30 23:49:25.069324	2490
12286	47	2016-05-30 23:49:25.078913	2440
12287	47	2016-05-30 23:49:25.086877	2452
12288	47	2016-05-30 23:49:25.095324	2468
12289	47	2016-05-30 23:49:25.103331	2450
12290	47	2016-05-30 23:49:25.111366	2470
12291	47	2016-05-30 23:49:25.119261	2506
12292	47	2016-05-30 23:49:25.127381	2461
12293	47	2016-05-30 23:49:25.13519	2502
12294	47	2016-05-30 23:49:25.143208	2455
12295	47	2016-05-30 23:49:25.150882	2478
12296	47	2016-05-30 23:49:25.158751	2488
12297	47	2016-05-30 23:49:25.166592	2494
12298	47	2016-05-30 23:49:25.174299	2484
12299	47	2016-05-30 23:49:25.182196	2514
12300	47	2016-05-30 23:49:25.189956	2531
12301	47	2016-05-30 23:49:25.197871	2457
12302	47	2016-05-30 23:49:25.206285	2482
12303	47	2016-05-30 23:49:25.214326	2463
12304	47	2016-05-30 23:49:25.22217	2444
12305	47	2016-05-30 23:49:25.230244	2496
12306	41	2016-05-30 23:53:02.372534	2518
12307	41	2016-05-30 23:53:02.379407	2543
12308	41	2016-05-30 23:53:02.385892	2378
12309	41	2016-05-30 23:53:02.396712	2517
12310	41	2016-05-30 23:53:02.407934	2520
12311	41	2016-05-30 23:53:02.418789	2521
12312	41	2016-05-30 23:53:02.429457	2523
12313	41	2016-05-30 23:53:02.439827	2525
12314	41	2016-05-30 23:53:02.446387	2528
12315	41	2016-05-30 23:53:02.457287	2516
12316	41	2016-05-30 23:53:02.467924	2519
12317	41	2016-05-30 23:53:02.478767	2524
12318	41	2016-05-30 23:53:02.489496	2522
12319	46	2016-05-30 23:53:02.49646	2398
12320	46	2016-05-30 23:53:02.502718	2542
12321	45	2016-05-30 23:53:02.509427	2400
12322	44	2016-05-30 23:53:02.515889	2382
12323	42	2016-05-30 23:53:02.522393	2444
12324	42	2016-05-30 23:53:02.529278	2486
12325	42	2016-05-30 23:53:02.535484	2450
12326	42	2016-05-30 23:53:02.541869	2452
12327	42	2016-05-30 23:53:02.548043	2455
12328	42	2016-05-30 23:53:02.554148	2482
12329	42	2016-05-30 23:53:02.560518	2488
12330	42	2016-05-30 23:53:02.566675	2472
12331	42	2016-05-30 23:53:02.572821	2500
12332	42	2016-05-30 23:53:02.579907	2374
12333	42	2016-05-30 23:53:02.586176	2442
12334	42	2016-05-30 23:53:02.592631	2496
12335	42	2016-05-30 23:53:02.600197	2467
12336	42	2016-05-30 23:53:02.606655	2490
12337	42	2016-05-30 23:53:02.613317	2504
12338	42	2016-05-30 23:53:02.619564	2494
12339	42	2016-05-30 23:53:02.625932	2470
12340	42	2016-05-30 23:53:02.632273	2498
12341	42	2016-05-30 23:53:02.63844	2484
12342	42	2016-05-30 23:53:02.644567	2506
12343	42	2016-05-30 23:53:02.651008	2440
12344	42	2016-05-30 23:53:02.657814	2468
12345	42	2016-05-30 23:53:02.664017	2478
12346	42	2016-05-30 23:53:02.670158	2480
12347	42	2016-05-30 23:53:02.676366	2457
12348	42	2016-05-30 23:53:02.682659	2475
12349	42	2016-05-30 23:53:02.690462	2502
12350	42	2016-05-30 23:53:02.696587	2459
12351	42	2016-05-30 23:53:02.703327	2463
12352	42	2016-05-30 23:53:02.710439	2476
12353	42	2016-05-30 23:53:02.716792	2448
12354	42	2016-05-30 23:53:02.722947	2465
12355	42	2016-05-30 23:53:02.729105	2461
12356	42	2016-05-30 23:53:02.735364	2469
12357	42	2016-05-30 23:53:02.741665	2474
12358	42	2016-05-30 23:53:02.747828	2492
12359	43	2016-05-30 23:53:02.754645	2462
12360	43	2016-05-30 23:53:02.760886	2466
12361	43	2016-05-30 23:53:02.766806	2489
12362	43	2016-05-30 23:53:02.772823	2477
12363	43	2016-05-30 23:53:02.779101	2481
12364	43	2016-05-30 23:53:02.785914	2453
12365	43	2016-05-30 23:53:02.792212	2491
12366	43	2016-05-30 23:53:02.798355	2483
12367	43	2016-05-30 23:53:02.804665	2443
12368	43	2016-05-30 23:53:02.811209	2501
12369	43	2016-05-30 23:53:02.817853	2375
12370	43	2016-05-30 23:53:02.824135	2458
12371	43	2016-05-30 23:53:02.830616	2499
12372	43	2016-05-30 23:53:02.837155	2471
12373	43	2016-05-30 23:53:02.843749	2487
12374	43	2016-05-30 23:53:02.850483	2441
12375	43	2016-05-30 23:53:02.856817	2451
12376	43	2016-05-30 23:53:02.863452	2507
12377	43	2016-05-30 23:53:02.869726	2464
12378	43	2016-05-30 23:53:02.876275	2497
12379	43	2016-05-30 23:53:02.882648	2460
12380	43	2016-05-30 23:53:02.888764	2493
12381	43	2016-05-30 23:53:02.895417	2473
12382	43	2016-05-30 23:53:02.901863	2445
12383	43	2016-05-30 23:53:02.908216	2485
12384	43	2016-05-30 23:53:02.914249	2495
12385	43	2016-05-30 23:53:02.920299	2449
12386	43	2016-05-30 23:53:02.926786	2505
12387	43	2016-05-30 23:53:02.932971	2479
12388	43	2016-05-30 23:53:02.939357	2456
12389	43	2016-05-30 23:53:02.94575	2503
12390	40	2016-05-30 23:53:02.953264	47212
12391	40	2016-05-30 23:53:02.958965	47206
12392	40	2016-05-30 23:53:02.964598	47215
12393	40	2016-05-30 23:53:02.970367	47209
12394	40	2016-05-30 23:53:02.976238	47256
12395	40	2016-05-30 23:53:02.981855	47347
12396	40	2016-05-30 23:53:02.9915	47340
12397	40	2016-05-30 23:53:02.997254	47203
12398	40	2016-05-30 23:53:03.003211	47350
12399	40	2016-05-30 23:53:03.009148	47343
12400	49	2016-05-30 23:53:03.018226	47347
12401	49	2016-05-30 23:53:03.025576	47343
12402	49	2016-05-30 23:53:03.033024	47212
12403	49	2016-05-30 23:53:03.040537	47206
12404	49	2016-05-30 23:53:03.047585	47350
12405	49	2016-05-30 23:53:03.059131	47340
12406	49	2016-05-30 23:53:03.066795	47203
12407	49	2016-05-30 23:53:03.074287	47215
12408	49	2016-05-30 23:53:03.081832	47209
12409	49	2016-05-30 23:53:03.089443	47256
12410	48	2016-05-30 23:53:03.099735	2500
12411	48	2016-05-30 23:53:03.10835	2374
12412	48	2016-05-30 23:53:03.11805	2475
12413	48	2016-05-30 23:53:03.126351	2498
12414	48	2016-05-30 23:53:03.134417	2480
12415	48	2016-05-30 23:53:03.142404	2534
12416	48	2016-05-30 23:53:03.150815	2454
12417	48	2016-05-30 23:53:03.159062	2465
12418	48	2016-05-30 23:53:03.16723	2459
12419	48	2016-05-30 23:53:03.175608	2472
12420	48	2016-05-30 23:53:03.183799	2467
12421	48	2016-05-30 23:53:03.191984	2504
12422	48	2016-05-30 23:53:03.200985	2469
12423	48	2016-05-30 23:53:03.209507	2442
12424	48	2016-05-30 23:53:03.217803	2474
12425	48	2016-05-30 23:53:03.226107	2486
12426	48	2016-05-30 23:53:03.234087	2476
12427	48	2016-05-30 23:53:03.242329	2492
12428	48	2016-05-30 23:53:03.250522	2448
12429	48	2016-05-30 23:53:03.259076	2490
12430	48	2016-05-30 23:53:03.267487	2440
12431	48	2016-05-30 23:53:03.275905	2452
12432	48	2016-05-30 23:53:03.284213	2468
12433	48	2016-05-30 23:53:03.292402	2450
12434	48	2016-05-30 23:53:03.300698	2470
12435	48	2016-05-30 23:53:03.308783	2506
12436	48	2016-05-30 23:53:03.316962	2461
12437	48	2016-05-30 23:53:03.325025	2502
12438	48	2016-05-30 23:53:03.333411	2455
12439	48	2016-05-30 23:53:03.34171	2478
12440	48	2016-05-30 23:53:03.349908	2488
12441	48	2016-05-30 23:53:03.358236	2494
12442	48	2016-05-30 23:53:03.366292	2484
12443	48	2016-05-30 23:53:03.374357	2514
12444	48	2016-05-30 23:53:03.382237	2531
12445	48	2016-05-30 23:53:03.390629	2457
12446	48	2016-05-30 23:53:03.398595	2482
12447	48	2016-05-30 23:53:03.406762	2463
12448	48	2016-05-30 23:53:03.414774	2444
12449	48	2016-05-30 23:53:03.423093	2496
12450	50	2016-05-30 23:53:03.431932	47347
12451	50	2016-05-30 23:53:03.439199	47343
12452	50	2016-05-30 23:53:03.446857	47212
12453	50	2016-05-30 23:53:03.454416	47206
12454	50	2016-05-30 23:53:03.461657	47350
12455	50	2016-05-30 23:53:03.473272	47340
12456	50	2016-05-30 23:53:03.480754	47203
12457	50	2016-05-30 23:53:03.488389	47215
12458	50	2016-05-30 23:53:03.496093	47209
12459	50	2016-05-30 23:53:03.503336	47256
12460	47	2016-05-30 23:53:03.513369	2500
12461	47	2016-05-30 23:53:03.521393	2374
12462	47	2016-05-30 23:53:03.529672	2475
12463	47	2016-05-30 23:53:03.537793	2498
12464	47	2016-05-30 23:53:03.561255	2480
12465	47	2016-05-30 23:53:03.584315	2534
12466	47	2016-05-30 23:53:03.592526	2454
12467	47	2016-05-30 23:53:03.601918	2465
12468	47	2016-05-30 23:53:03.61021	2459
12469	47	2016-05-30 23:53:03.618189	2472
12470	47	2016-05-30 23:53:03.626474	2467
12471	47	2016-05-30 23:53:03.634194	2504
12472	47	2016-05-30 23:53:03.642325	2469
12473	47	2016-05-30 23:53:03.650535	2442
12474	47	2016-05-30 23:53:03.658727	2474
12475	47	2016-05-30 23:53:03.666712	2486
12476	47	2016-05-30 23:53:03.674726	2476
12477	47	2016-05-30 23:53:03.682904	2492
12478	47	2016-05-30 23:53:03.691104	2448
12479	47	2016-05-30 23:53:03.699249	2490
12480	47	2016-05-30 23:53:03.707384	2440
12481	47	2016-05-30 23:53:03.715299	2452
12482	47	2016-05-30 23:53:03.723504	2468
12483	47	2016-05-30 23:53:03.731426	2450
12484	47	2016-05-30 23:53:03.739339	2470
12485	47	2016-05-30 23:53:03.74726	2506
12486	47	2016-05-30 23:53:03.755264	2461
12487	47	2016-05-30 23:53:03.763673	2502
12488	47	2016-05-30 23:53:03.771837	2455
12489	47	2016-05-30 23:53:03.779863	2478
12490	47	2016-05-30 23:53:03.787644	2488
12491	47	2016-05-30 23:53:03.795736	2494
12492	47	2016-05-30 23:53:03.803805	2484
12493	47	2016-05-30 23:53:03.811638	2514
12494	47	2016-05-30 23:53:03.819225	2531
12495	47	2016-05-30 23:53:03.827306	2457
12496	47	2016-05-30 23:53:03.835374	2482
12497	47	2016-05-30 23:53:03.843288	2463
12498	47	2016-05-30 23:53:03.851404	2444
12499	47	2016-05-30 23:53:03.859731	2496
12500	41	2016-05-30 23:54:02.569428	2518
12501	41	2016-05-30 23:54:02.576388	2543
12502	41	2016-05-30 23:54:02.583371	2378
12503	41	2016-05-30 23:54:02.595076	2517
12504	41	2016-05-30 23:54:02.606535	2520
12505	41	2016-05-30 23:54:02.617575	2521
12506	41	2016-05-30 23:54:02.628411	2523
12507	41	2016-05-30 23:54:02.639468	2525
12508	41	2016-05-30 23:54:02.645602	2528
12509	41	2016-05-30 23:54:02.656793	2516
12510	41	2016-05-30 23:54:02.66895	2519
12511	41	2016-05-30 23:54:02.679955	2524
12512	41	2016-05-30 23:54:02.690783	2522
12513	46	2016-05-30 23:54:02.697651	2398
12514	46	2016-05-30 23:54:02.704056	2542
12515	45	2016-05-30 23:54:02.710789	2400
12516	44	2016-05-30 23:54:02.71742	2382
12517	42	2016-05-30 23:54:02.723717	2444
12518	42	2016-05-30 23:54:02.729875	2486
12519	42	2016-05-30 23:54:02.736379	2450
12520	42	2016-05-30 23:54:02.742497	2452
12521	42	2016-05-30 23:54:02.748689	2455
12522	42	2016-05-30 23:54:02.755196	2482
12523	42	2016-05-30 23:54:02.761473	2488
12524	42	2016-05-30 23:54:02.767707	2472
12525	42	2016-05-30 23:54:02.773926	2500
12526	42	2016-05-30 23:54:02.780239	2374
12527	42	2016-05-30 23:54:02.786536	2442
12528	42	2016-05-30 23:54:02.792643	2496
12529	42	2016-05-30 23:54:02.799191	2467
12530	42	2016-05-30 23:54:02.805364	2490
12531	42	2016-05-30 23:54:02.81154	2504
12532	42	2016-05-30 23:54:02.81859	2494
12533	42	2016-05-30 23:54:02.8247	2470
12534	42	2016-05-30 23:54:02.830927	2498
12535	42	2016-05-30 23:54:02.837077	2484
12536	42	2016-05-30 23:54:02.843203	2506
12537	42	2016-05-30 23:54:02.849617	2440
12538	42	2016-05-30 23:54:02.856067	2468
12539	42	2016-05-30 23:54:02.86234	2478
12540	42	2016-05-30 23:54:02.868594	2480
12541	42	2016-05-30 23:54:02.875234	2457
12542	42	2016-05-30 23:54:02.882768	2475
12543	42	2016-05-30 23:54:02.889929	2502
12544	42	2016-05-30 23:54:02.898846	2459
12545	42	2016-05-30 23:54:02.90637	2463
12546	42	2016-05-30 23:54:02.912887	2476
12547	42	2016-05-30 23:54:02.920577	2448
12548	42	2016-05-30 23:54:02.927258	2465
12549	42	2016-05-30 23:54:02.934069	2461
12550	42	2016-05-30 23:54:02.941015	2469
12551	42	2016-05-30 23:54:02.947772	2474
12552	42	2016-05-30 23:54:02.954514	2492
12553	43	2016-05-30 23:54:02.961495	2462
12554	43	2016-05-30 23:54:02.968682	2466
12555	43	2016-05-30 23:54:02.97526	2489
12556	43	2016-05-30 23:54:02.981973	2477
12557	43	2016-05-30 23:54:02.989164	2481
12558	43	2016-05-30 23:54:02.995815	2453
12559	43	2016-05-30 23:54:03.004674	2491
12560	43	2016-05-30 23:54:03.012524	2483
12561	43	2016-05-30 23:54:03.020313	2443
12562	43	2016-05-30 23:54:03.028986	2501
12563	43	2016-05-30 23:54:03.036687	2375
12564	43	2016-05-30 23:54:03.043685	2458
12565	43	2016-05-30 23:54:03.053157	2499
12566	43	2016-05-30 23:54:03.061035	2471
12567	43	2016-05-30 23:54:03.068869	2487
12568	43	2016-05-30 23:54:03.075761	2441
12569	43	2016-05-30 23:54:03.082932	2451
12570	43	2016-05-30 23:54:03.08983	2507
12571	43	2016-05-30 23:54:03.097003	2464
12572	43	2016-05-30 23:54:03.103705	2497
12573	43	2016-05-30 23:54:03.110469	2460
12574	43	2016-05-30 23:54:03.11829	2493
12575	43	2016-05-30 23:54:03.124901	2473
12576	43	2016-05-30 23:54:03.131623	2445
12577	43	2016-05-30 23:54:03.138295	2485
12578	43	2016-05-30 23:54:03.14506	2495
12579	43	2016-05-30 23:54:03.152002	2449
12580	43	2016-05-30 23:54:03.158651	2505
12581	43	2016-05-30 23:54:03.165155	2479
12582	43	2016-05-30 23:54:03.171783	2456
12583	43	2016-05-30 23:54:03.178415	2503
12584	40	2016-05-30 23:54:03.186218	47212
12585	40	2016-05-30 23:54:03.192079	47206
12586	40	2016-05-30 23:54:03.198812	47215
12587	40	2016-05-30 23:54:03.205288	47209
12588	40	2016-05-30 23:54:03.211237	47256
12589	40	2016-05-30 23:54:03.217817	47347
12590	40	2016-05-30 23:54:03.228465	47340
12591	40	2016-05-30 23:54:03.234904	47203
12592	40	2016-05-30 23:54:03.240816	47350
12593	40	2016-05-30 23:54:03.247259	47343
12594	49	2016-05-30 23:54:03.256968	47347
12595	49	2016-05-30 23:54:03.264979	47343
12596	49	2016-05-30 23:54:03.272582	47212
12597	49	2016-05-30 23:54:03.280365	47206
12598	49	2016-05-30 23:54:03.28831	47350
12599	49	2016-05-30 23:54:03.300835	47340
12600	49	2016-05-30 23:54:03.308475	47203
12601	49	2016-05-30 23:54:03.316955	47215
12602	49	2016-05-30 23:54:03.324573	47209
12603	49	2016-05-30 23:54:03.331869	47256
12604	48	2016-05-30 23:54:03.342346	2500
12605	48	2016-05-30 23:54:03.350651	2374
12606	48	2016-05-30 23:54:03.358985	2475
12607	48	2016-05-30 23:54:03.367571	2498
12608	48	2016-05-30 23:54:03.375919	2480
12609	48	2016-05-30 23:54:03.38397	2534
12610	48	2016-05-30 23:54:03.391743	2454
12611	48	2016-05-30 23:54:03.400035	2465
12612	48	2016-05-30 23:54:03.408224	2459
12613	48	2016-05-30 23:54:03.416468	2472
12614	48	2016-05-30 23:54:03.424734	2467
12615	48	2016-05-30 23:54:03.432963	2504
12616	48	2016-05-30 23:54:03.441138	2469
12617	48	2016-05-30 23:54:03.449485	2442
12618	48	2016-05-30 23:54:03.459025	2474
12619	48	2016-05-30 23:54:03.467391	2486
12620	48	2016-05-30 23:54:03.475546	2476
12621	48	2016-05-30 23:54:03.484193	2492
12622	48	2016-05-30 23:54:03.492524	2448
12623	48	2016-05-30 23:54:03.501108	2490
12624	48	2016-05-30 23:54:03.509597	2440
12625	48	2016-05-30 23:54:03.517992	2452
12626	48	2016-05-30 23:54:03.528713	2468
12627	48	2016-05-30 23:54:03.552612	2450
12628	48	2016-05-30 23:54:03.560823	2470
12629	48	2016-05-30 23:54:03.569297	2506
12630	48	2016-05-30 23:54:03.577325	2461
12631	48	2016-05-30 23:54:03.585366	2502
12632	48	2016-05-30 23:54:03.593503	2455
12633	48	2016-05-30 23:54:03.601984	2478
12634	48	2016-05-30 23:54:03.610017	2488
12635	48	2016-05-30 23:54:03.618703	2494
12636	48	2016-05-30 23:54:03.642193	2484
12637	48	2016-05-30 23:54:03.666847	2514
12638	48	2016-05-30 23:54:03.674663	2531
12639	48	2016-05-30 23:54:03.683874	2457
12640	48	2016-05-30 23:54:03.692013	2482
12641	48	2016-05-30 23:54:03.700894	2463
12642	48	2016-05-30 23:54:03.709117	2444
12643	48	2016-05-30 23:54:03.717509	2496
12644	50	2016-05-30 23:54:03.72627	47347
12645	50	2016-05-30 23:54:03.73354	47343
12646	50	2016-05-30 23:54:03.741047	47212
12647	50	2016-05-30 23:54:03.748643	47206
12648	50	2016-05-30 23:54:03.755915	47350
12649	50	2016-05-30 23:54:03.767399	47340
12650	50	2016-05-30 23:54:03.774965	47203
12651	50	2016-05-30 23:54:03.782643	47215
12652	50	2016-05-30 23:54:03.790345	47209
12653	50	2016-05-30 23:54:03.797792	47256
12654	47	2016-05-30 23:54:03.808139	2500
12655	47	2016-05-30 23:54:03.81626	2374
12656	47	2016-05-30 23:54:03.824432	2475
12657	47	2016-05-30 23:54:03.832637	2498
12658	47	2016-05-30 23:54:03.84058	2480
12659	47	2016-05-30 23:54:03.848485	2534
12660	47	2016-05-30 23:54:03.856501	2454
12661	47	2016-05-30 23:54:03.864527	2465
12662	47	2016-05-30 23:54:03.872375	2459
12663	47	2016-05-30 23:54:03.880391	2472
12664	47	2016-05-30 23:54:03.889942	2467
12665	47	2016-05-30 23:54:03.898263	2504
12666	47	2016-05-30 23:54:03.906546	2469
12667	47	2016-05-30 23:54:03.914783	2442
12668	47	2016-05-30 23:54:03.923187	2474
12669	47	2016-05-30 23:54:03.931108	2486
12670	47	2016-05-30 23:54:03.939262	2476
12671	47	2016-05-30 23:54:03.9472	2492
12672	47	2016-05-30 23:54:03.955092	2448
12673	47	2016-05-30 23:54:03.963292	2490
12674	47	2016-05-30 23:54:03.971359	2440
12675	47	2016-05-30 23:54:03.979325	2452
12676	47	2016-05-30 23:54:03.987481	2468
12677	47	2016-05-30 23:54:03.99686	2450
12678	47	2016-05-30 23:54:04.021088	2470
12679	47	2016-05-30 23:54:04.044711	2506
12680	47	2016-05-30 23:54:04.052989	2461
12681	47	2016-05-30 23:54:04.087363	2502
12682	47	2016-05-30 23:54:04.10144	2455
12683	47	2016-05-30 23:54:04.126052	2478
12684	47	2016-05-30 23:54:04.142155	2488
12685	47	2016-05-30 23:54:04.16568	2494
12686	47	2016-05-30 23:54:04.182823	2484
12687	47	2016-05-30 23:54:04.191531	2514
12688	47	2016-05-30 23:54:04.201	2531
12689	47	2016-05-30 23:54:04.209552	2457
12690	47	2016-05-30 23:54:04.218394	2482
12691	47	2016-05-30 23:54:04.226742	2463
12692	47	2016-05-30 23:54:04.242571	2444
12693	47	2016-05-30 23:54:04.255989	2496
12694	41	2016-05-30 23:55:10.069895	2518
12695	41	2016-05-30 23:55:10.07724	2543
12696	41	2016-05-30 23:55:10.083949	2378
12697	41	2016-05-30 23:55:10.095014	2517
12698	41	2016-05-30 23:55:10.106378	2520
12699	41	2016-05-30 23:55:10.117451	2521
12700	41	2016-05-30 23:55:10.128363	2523
12701	41	2016-05-30 23:55:10.139311	2525
12702	41	2016-05-30 23:55:10.145596	2528
12703	41	2016-05-30 23:55:10.156413	2516
12704	41	2016-05-30 23:55:10.167189	2519
12705	41	2016-05-30 23:55:10.178502	2524
12706	41	2016-05-30 23:55:10.189698	2522
12707	46	2016-05-30 23:55:10.197479	2398
12708	46	2016-05-30 23:55:10.203961	2542
12709	45	2016-05-30 23:55:10.210701	2400
12710	44	2016-05-30 23:55:10.217726	2382
12711	42	2016-05-30 23:55:10.224695	2444
12712	42	2016-05-30 23:55:10.230915	2486
12713	42	2016-05-30 23:55:10.237188	2450
12714	42	2016-05-30 23:55:10.243459	2452
12715	42	2016-05-30 23:55:10.249704	2455
12716	42	2016-05-30 23:55:10.256779	2482
12717	42	2016-05-30 23:55:10.264206	2488
12718	42	2016-05-30 23:55:10.270654	2472
12719	42	2016-05-30 23:55:10.277402	2500
12720	42	2016-05-30 23:55:10.283513	2374
12721	42	2016-05-30 23:55:10.290145	2442
12722	42	2016-05-30 23:55:10.296421	2496
12723	42	2016-05-30 23:55:10.302602	2467
12724	42	2016-05-30 23:55:10.309176	2490
12725	42	2016-05-30 23:55:10.315593	2504
12726	42	2016-05-30 23:55:10.322248	2494
12727	42	2016-05-30 23:55:10.328558	2470
12728	42	2016-05-30 23:55:10.3347	2498
12729	42	2016-05-30 23:55:10.34159	2484
12730	42	2016-05-30 23:55:10.347825	2506
12731	42	2016-05-30 23:55:10.354109	2440
12732	42	2016-05-30 23:55:10.360941	2468
12733	42	2016-05-30 23:55:10.367224	2478
12734	42	2016-05-30 23:55:10.373439	2480
12735	42	2016-05-30 23:55:10.379607	2457
12736	42	2016-05-30 23:55:10.385975	2475
12737	42	2016-05-30 23:55:10.392174	2502
12738	42	2016-05-30 23:55:10.398398	2459
12739	42	2016-05-30 23:55:10.405486	2463
12740	42	2016-05-30 23:55:10.411835	2476
12741	42	2016-05-30 23:55:10.418044	2448
12742	42	2016-05-30 23:55:10.424301	2465
12743	42	2016-05-30 23:55:10.430542	2461
12744	42	2016-05-30 23:55:10.436862	2469
12745	42	2016-05-30 23:55:10.443194	2474
12746	42	2016-05-30 23:55:10.449741	2492
12747	43	2016-05-30 23:55:10.456465	2462
12748	43	2016-05-30 23:55:10.462578	2466
12749	43	2016-05-30 23:55:10.46866	2489
12750	43	2016-05-30 23:55:10.475246	2477
12751	43	2016-05-30 23:55:10.481509	2481
12752	43	2016-05-30 23:55:10.487884	2453
12753	43	2016-05-30 23:55:10.494017	2491
12754	43	2016-05-30 23:55:10.500481	2483
12755	43	2016-05-30 23:55:10.507241	2443
12756	43	2016-05-30 23:55:10.513682	2501
12757	43	2016-05-30 23:55:10.519896	2375
12758	43	2016-05-30 23:55:10.526425	2458
12759	43	2016-05-30 23:55:10.532801	2499
12760	43	2016-05-30 23:55:10.53935	2471
12761	43	2016-05-30 23:55:10.545818	2487
12762	43	2016-05-30 23:55:10.552176	2441
12763	43	2016-05-30 23:55:10.558851	2451
12764	43	2016-05-30 23:55:10.565264	2507
12765	43	2016-05-30 23:55:10.571905	2464
12766	43	2016-05-30 23:55:10.578277	2497
12767	43	2016-05-30 23:55:10.584387	2460
12768	43	2016-05-30 23:55:10.5911	2493
12769	43	2016-05-30 23:55:10.597679	2473
12770	43	2016-05-30 23:55:10.604066	2445
12771	43	2016-05-30 23:55:10.610385	2485
12772	43	2016-05-30 23:55:10.616743	2495
12773	43	2016-05-30 23:55:10.623345	2449
12774	43	2016-05-30 23:55:10.629593	2505
12775	43	2016-05-30 23:55:10.635788	2479
12776	43	2016-05-30 23:55:10.641911	2456
12777	43	2016-05-30 23:55:10.648224	2503
12778	40	2016-05-30 23:55:10.655682	47212
12779	40	2016-05-30 23:55:10.661376	47206
12780	40	2016-05-30 23:55:10.666983	47215
12781	40	2016-05-30 23:55:10.672863	47209
12782	40	2016-05-30 23:55:10.67836	47256
12783	40	2016-05-30 23:55:10.684017	47347
12784	40	2016-05-30 23:55:10.69506	47340
12785	40	2016-05-30 23:55:10.700973	47203
12786	40	2016-05-30 23:55:10.722667	47350
12787	40	2016-05-30 23:55:10.743842	47343
12788	49	2016-05-30 23:55:10.753285	47347
12789	49	2016-05-30 23:55:10.760758	47343
12790	49	2016-05-30 23:55:10.767996	47212
12791	49	2016-05-30 23:55:10.77564	47206
12792	49	2016-05-30 23:55:10.782736	47350
12793	49	2016-05-30 23:55:10.7942	47340
12794	49	2016-05-30 23:55:10.801793	47203
12795	49	2016-05-30 23:55:10.809369	47215
12796	49	2016-05-30 23:55:10.816885	47209
12797	49	2016-05-30 23:55:10.824379	47256
12798	48	2016-05-30 23:55:10.83513	2500
12799	48	2016-05-30 23:55:10.843357	2374
12800	48	2016-05-30 23:55:10.851811	2475
12801	48	2016-05-30 23:55:10.860138	2498
12802	48	2016-05-30 23:55:10.868439	2480
12803	48	2016-05-30 23:55:10.876285	2534
12804	48	2016-05-30 23:55:10.884639	2454
12805	48	2016-05-30 23:55:10.89302	2465
12806	48	2016-05-30 23:55:10.901354	2459
12807	48	2016-05-30 23:55:10.909837	2472
12808	48	2016-05-30 23:55:10.918144	2467
12809	48	2016-05-30 23:55:10.926481	2504
12810	48	2016-05-30 23:55:10.934852	2469
12811	48	2016-05-30 23:55:10.943011	2442
12812	48	2016-05-30 23:55:10.951961	2474
12813	48	2016-05-30 23:55:10.960258	2486
12814	48	2016-05-30 23:55:10.96837	2476
12815	48	2016-05-30 23:55:10.976719	2492
12816	48	2016-05-30 23:55:10.985059	2448
12817	48	2016-05-30 23:55:10.993255	2490
12818	48	2016-05-30 23:55:11.001906	2440
12819	48	2016-05-30 23:55:11.010131	2452
12820	48	2016-05-30 23:55:11.01843	2468
12821	48	2016-05-30 23:55:11.026661	2450
12822	48	2016-05-30 23:55:11.034957	2470
12823	48	2016-05-30 23:55:11.045621	2506
12824	48	2016-05-30 23:55:11.054255	2461
12825	48	2016-05-30 23:55:11.062409	2502
12826	48	2016-05-30 23:55:11.07103	2455
12827	48	2016-05-30 23:55:11.079138	2478
12828	48	2016-05-30 23:55:11.087451	2488
12829	48	2016-05-30 23:55:11.095998	2494
12830	48	2016-05-30 23:55:11.104334	2484
12831	48	2016-05-30 23:55:11.112215	2514
12832	48	2016-05-30 23:55:11.120719	2531
12833	48	2016-05-30 23:55:11.129747	2457
12834	48	2016-05-30 23:55:11.138357	2482
12835	48	2016-05-30 23:55:11.146668	2463
12836	48	2016-05-30 23:55:11.155157	2444
12837	48	2016-05-30 23:55:11.163389	2496
12838	50	2016-05-30 23:55:11.172678	47347
12839	50	2016-05-30 23:55:11.179986	47343
12840	50	2016-05-30 23:55:11.187768	47212
12841	50	2016-05-30 23:55:11.195777	47206
12842	50	2016-05-30 23:55:11.203229	47350
12843	50	2016-05-30 23:55:11.214853	47340
12844	50	2016-05-30 23:55:11.222565	47203
12845	50	2016-05-30 23:55:11.230284	47215
12846	50	2016-05-30 23:55:11.238214	47209
12847	50	2016-05-30 23:55:11.245777	47256
12848	47	2016-05-30 23:55:11.256279	2500
12849	47	2016-05-30 23:55:11.264306	2374
12850	47	2016-05-30 23:55:11.272647	2475
12851	47	2016-05-30 23:55:11.280688	2498
12852	47	2016-05-30 23:55:11.288759	2480
12853	47	2016-05-30 23:55:11.296796	2534
12854	47	2016-05-30 23:55:11.304903	2454
12855	47	2016-05-30 23:55:11.31289	2465
12856	47	2016-05-30 23:55:11.320855	2459
12857	47	2016-05-30 23:55:11.32935	2472
12858	47	2016-05-30 23:55:11.337669	2467
12859	47	2016-05-30 23:55:11.345696	2504
12860	47	2016-05-30 23:55:11.353997	2469
12861	47	2016-05-30 23:55:11.362625	2442
12862	47	2016-05-30 23:55:11.370764	2474
12863	47	2016-05-30 23:55:11.37866	2486
12864	47	2016-05-30 23:55:11.38685	2476
12865	47	2016-05-30 23:55:11.394831	2492
12866	47	2016-05-30 23:55:11.40341	2448
12867	47	2016-05-30 23:55:11.411638	2490
12868	47	2016-05-30 23:55:11.42031	2440
12869	47	2016-05-30 23:55:11.428711	2452
12870	47	2016-05-30 23:55:11.43728	2468
12871	47	2016-05-30 23:55:11.445311	2450
12872	47	2016-05-30 23:55:11.454295	2470
12873	47	2016-05-30 23:55:11.462341	2506
12874	47	2016-05-30 23:55:11.470621	2461
12875	47	2016-05-30 23:55:11.478683	2502
12876	47	2016-05-30 23:55:11.487227	2455
12877	47	2016-05-30 23:55:11.495509	2478
12878	47	2016-05-30 23:55:11.503803	2488
12879	47	2016-05-30 23:55:11.511675	2494
12880	47	2016-05-30 23:55:11.519883	2484
12881	47	2016-05-30 23:55:11.528195	2514
12882	47	2016-05-30 23:55:11.536334	2531
12883	47	2016-05-30 23:55:11.544404	2457
12884	47	2016-05-30 23:55:11.554048	2482
12885	47	2016-05-30 23:55:11.562773	2463
12886	47	2016-05-30 23:55:11.571488	2444
12887	47	2016-05-30 23:55:11.579972	2496
12888	41	2016-05-31 00:02:26.113872	2518
12889	41	2016-05-31 00:02:26.155094	2543
12890	41	2016-05-31 00:02:26.162049	2378
12891	41	2016-05-31 00:02:26.17329	2517
12892	41	2016-05-31 00:02:26.184818	2520
12893	41	2016-05-31 00:02:26.195759	2521
12894	41	2016-05-31 00:02:26.208242	2523
12895	41	2016-05-31 00:02:26.219441	2525
12896	41	2016-05-31 00:02:26.225724	2528
12897	41	2016-05-31 00:02:26.237128	2516
12898	41	2016-05-31 00:02:26.247999	2519
12899	41	2016-05-31 00:02:26.258518	2524
12900	41	2016-05-31 00:02:26.269428	2522
12901	46	2016-05-31 00:02:26.276275	2398
12902	46	2016-05-31 00:02:26.282996	2542
12903	45	2016-05-31 00:02:26.289821	2400
12904	44	2016-05-31 00:02:26.297316	2382
12905	42	2016-05-31 00:02:26.30414	2444
12906	42	2016-05-31 00:02:26.310611	2486
12907	42	2016-05-31 00:02:26.316997	2450
12908	42	2016-05-31 00:02:26.323173	2452
12909	42	2016-05-31 00:02:26.329331	2455
12910	42	2016-05-31 00:02:26.335991	2482
12911	42	2016-05-31 00:02:26.342174	2488
12912	42	2016-05-31 00:02:26.34943	2472
12913	42	2016-05-31 00:02:26.355782	2500
12914	42	2016-05-31 00:02:26.361926	2374
12915	42	2016-05-31 00:02:26.368473	2442
12916	42	2016-05-31 00:02:26.374735	2496
12917	42	2016-05-31 00:02:26.381207	2467
12918	42	2016-05-31 00:02:26.387726	2490
12919	42	2016-05-31 00:02:26.393786	2504
12920	42	2016-05-31 00:02:26.400112	2494
12921	42	2016-05-31 00:02:26.406382	2470
12922	42	2016-05-31 00:02:26.412577	2498
12923	42	2016-05-31 00:02:26.419178	2484
12924	42	2016-05-31 00:02:26.425663	2506
12925	42	2016-05-31 00:02:26.432105	2440
12926	42	2016-05-31 00:02:26.438718	2468
12927	42	2016-05-31 00:02:26.445205	2478
12928	42	2016-05-31 00:02:26.45185	2480
12929	42	2016-05-31 00:02:26.458271	2457
12930	42	2016-05-31 00:02:26.4649	2475
12931	42	2016-05-31 00:02:26.471137	2502
12932	42	2016-05-31 00:02:26.477346	2459
12933	42	2016-05-31 00:02:26.483813	2463
12934	42	2016-05-31 00:02:26.505808	2476
12935	42	2016-05-31 00:02:26.513528	2448
12936	42	2016-05-31 00:02:26.52018	2465
12937	42	2016-05-31 00:02:26.528331	2461
12938	42	2016-05-31 00:02:26.535199	2469
12939	42	2016-05-31 00:02:26.541648	2474
12940	42	2016-05-31 00:02:26.548306	2492
12941	43	2016-05-31 00:02:26.555123	2462
12942	43	2016-05-31 00:02:26.561425	2466
12943	43	2016-05-31 00:02:26.568566	2489
12944	43	2016-05-31 00:02:26.574719	2477
12945	43	2016-05-31 00:02:26.581375	2481
12946	43	2016-05-31 00:02:26.587522	2453
12947	43	2016-05-31 00:02:26.59398	2491
12948	43	2016-05-31 00:02:26.600407	2483
12949	43	2016-05-31 00:02:26.606657	2443
12950	43	2016-05-31 00:02:26.613063	2501
12951	43	2016-05-31 00:02:26.619189	2375
12952	43	2016-05-31 00:02:26.625537	2458
12953	43	2016-05-31 00:02:26.631738	2499
12954	43	2016-05-31 00:02:26.638193	2471
12955	43	2016-05-31 00:02:26.64473	2487
12956	43	2016-05-31 00:02:26.651061	2441
12957	43	2016-05-31 00:02:26.657317	2451
12958	43	2016-05-31 00:02:26.66368	2507
12959	43	2016-05-31 00:02:26.669812	2464
12960	43	2016-05-31 00:02:26.676077	2497
12961	43	2016-05-31 00:02:26.6825	2460
12962	43	2016-05-31 00:02:26.688886	2493
12963	43	2016-05-31 00:02:26.695241	2473
12964	43	2016-05-31 00:02:26.701544	2445
12965	43	2016-05-31 00:02:26.707976	2485
12966	43	2016-05-31 00:02:26.714216	2495
12967	43	2016-05-31 00:02:26.720698	2449
12968	43	2016-05-31 00:02:26.727001	2505
12969	43	2016-05-31 00:02:26.73338	2479
12970	43	2016-05-31 00:02:26.740029	2456
12971	43	2016-05-31 00:02:26.746411	2503
12972	40	2016-05-31 00:02:26.784824	47212
12973	40	2016-05-31 00:02:26.791531	47206
12974	40	2016-05-31 00:02:26.79794	47215
12975	40	2016-05-31 00:02:26.804265	47209
12976	40	2016-05-31 00:02:26.810139	47256
12977	40	2016-05-31 00:02:26.815871	47347
12978	40	2016-05-31 00:02:26.825756	47340
12979	40	2016-05-31 00:02:26.83159	47203
12980	40	2016-05-31 00:02:26.837437	47350
12981	40	2016-05-31 00:02:26.843247	47343
12982	49	2016-05-31 00:02:26.852771	47347
12983	49	2016-05-31 00:02:26.860189	47343
12984	49	2016-05-31 00:02:26.867987	47212
12985	49	2016-05-31 00:02:26.875653	47206
12986	49	2016-05-31 00:02:26.88347	47350
12987	49	2016-05-31 00:02:26.895027	47340
12988	49	2016-05-31 00:02:26.903723	47203
12989	49	2016-05-31 00:02:26.911775	47215
12990	49	2016-05-31 00:02:26.919249	47209
12991	49	2016-05-31 00:02:26.926715	47256
12992	48	2016-05-31 00:02:26.937803	2500
12993	48	2016-05-31 00:02:26.946343	2374
12994	48	2016-05-31 00:02:26.955044	2475
12995	48	2016-05-31 00:02:26.963451	2498
12996	48	2016-05-31 00:02:26.971796	2480
12997	48	2016-05-31 00:02:26.979488	2534
12998	48	2016-05-31 00:02:26.987733	2454
12999	48	2016-05-31 00:02:26.996308	2465
13000	48	2016-05-31 00:02:27.005397	2459
13001	48	2016-05-31 00:02:27.013805	2472
13002	48	2016-05-31 00:02:27.022502	2467
13003	48	2016-05-31 00:02:27.030895	2504
13004	48	2016-05-31 00:02:27.04009	2469
13005	48	2016-05-31 00:02:27.048723	2442
13006	48	2016-05-31 00:02:27.05747	2474
13007	48	2016-05-31 00:02:27.065837	2486
13008	48	2016-05-31 00:02:27.074903	2476
13009	48	2016-05-31 00:02:27.083479	2492
13010	48	2016-05-31 00:02:27.092096	2448
13011	48	2016-05-31 00:02:27.100688	2490
13012	48	2016-05-31 00:02:27.109053	2440
13013	48	2016-05-31 00:02:27.118351	2452
13014	48	2016-05-31 00:02:27.126934	2468
13015	48	2016-05-31 00:02:27.135149	2450
13016	48	2016-05-31 00:02:27.14331	2470
13017	48	2016-05-31 00:02:27.151635	2506
13018	48	2016-05-31 00:02:27.160196	2461
13019	48	2016-05-31 00:02:27.168526	2502
13020	48	2016-05-31 00:02:27.177562	2455
13021	48	2016-05-31 00:02:27.203369	2478
13022	48	2016-05-31 00:02:27.212132	2488
13023	48	2016-05-31 00:02:27.22079	2494
13024	48	2016-05-31 00:02:27.229033	2484
13025	48	2016-05-31 00:02:27.237247	2514
13026	48	2016-05-31 00:02:27.245242	2531
13027	48	2016-05-31 00:02:27.253672	2457
13028	48	2016-05-31 00:02:27.262632	2482
13029	48	2016-05-31 00:02:27.270982	2463
13030	48	2016-05-31 00:02:27.279367	2444
13031	48	2016-05-31 00:02:27.289124	2496
13032	50	2016-05-31 00:02:27.299274	47347
13033	50	2016-05-31 00:02:27.306791	47343
13034	50	2016-05-31 00:02:27.314756	47212
13035	50	2016-05-31 00:02:27.322672	47206
13036	50	2016-05-31 00:02:27.330242	47350
13037	50	2016-05-31 00:02:27.3418	47340
13038	50	2016-05-31 00:02:27.349769	47203
13039	50	2016-05-31 00:02:27.357505	47215
13040	50	2016-05-31 00:02:27.365346	47209
13041	50	2016-05-31 00:02:27.372833	47256
13042	47	2016-05-31 00:02:27.383316	2500
13043	47	2016-05-31 00:02:27.391499	2374
13044	47	2016-05-31 00:02:27.399691	2475
13045	47	2016-05-31 00:02:27.407801	2498
13046	47	2016-05-31 00:02:27.41615	2480
13047	47	2016-05-31 00:02:27.42392	2534
13048	47	2016-05-31 00:02:27.431948	2454
13049	47	2016-05-31 00:02:27.440183	2465
13050	47	2016-05-31 00:02:27.448322	2459
13051	47	2016-05-31 00:02:27.456577	2472
13052	47	2016-05-31 00:02:27.464922	2467
13053	47	2016-05-31 00:02:27.473202	2504
13054	47	2016-05-31 00:02:27.481409	2469
13055	47	2016-05-31 00:02:27.489524	2442
13056	47	2016-05-31 00:02:27.498061	2474
13057	47	2016-05-31 00:02:27.506791	2486
13058	47	2016-05-31 00:02:27.515204	2476
13059	47	2016-05-31 00:02:27.523312	2492
13060	47	2016-05-31 00:02:27.531456	2448
13061	47	2016-05-31 00:02:27.539939	2490
13062	47	2016-05-31 00:02:27.548272	2440
13063	47	2016-05-31 00:02:27.556493	2452
13064	47	2016-05-31 00:02:27.564751	2468
13065	47	2016-05-31 00:02:27.574009	2450
13066	47	2016-05-31 00:02:27.58257	2470
13067	47	2016-05-31 00:02:27.590797	2506
13068	47	2016-05-31 00:02:27.599107	2461
13069	47	2016-05-31 00:02:27.607157	2502
13070	47	2016-05-31 00:02:27.615588	2455
13071	47	2016-05-31 00:02:27.623698	2478
13072	47	2016-05-31 00:02:27.63181	2488
13073	47	2016-05-31 00:02:27.640044	2494
13074	47	2016-05-31 00:02:27.648509	2484
13075	47	2016-05-31 00:02:27.656464	2514
13076	47	2016-05-31 00:02:27.665566	2531
13077	47	2016-05-31 00:02:27.673856	2457
13078	47	2016-05-31 00:02:27.682236	2482
13079	47	2016-05-31 00:02:27.690138	2463
13080	47	2016-05-31 00:02:27.698822	2444
13081	47	2016-05-31 00:02:27.707081	2496
13082	41	2016-05-31 00:07:45.47011	2518
13083	41	2016-05-31 00:07:45.51121	2543
13084	41	2016-05-31 00:07:45.519345	2378
13085	41	2016-05-31 00:07:45.531796	2517
13086	41	2016-05-31 00:07:45.543458	2520
13087	41	2016-05-31 00:07:45.554169	2521
13088	41	2016-05-31 00:07:45.565465	2523
13089	41	2016-05-31 00:07:45.577017	2525
13090	41	2016-05-31 00:07:45.583197	2528
13091	41	2016-05-31 00:07:45.594645	2516
13092	41	2016-05-31 00:07:45.60565	2519
13093	41	2016-05-31 00:07:45.616643	2524
13094	41	2016-05-31 00:07:45.631148	2522
13095	46	2016-05-31 00:07:45.638706	2398
13096	46	2016-05-31 00:07:45.64555	2542
13097	45	2016-05-31 00:07:45.652016	2400
13098	44	2016-05-31 00:07:45.659902	2382
13099	42	2016-05-31 00:07:45.666597	2444
13100	42	2016-05-31 00:07:45.673171	2486
13101	42	2016-05-31 00:07:45.67983	2450
13102	42	2016-05-31 00:07:45.686051	2452
13103	42	2016-05-31 00:07:45.692721	2455
13104	42	2016-05-31 00:07:45.698916	2482
13105	42	2016-05-31 00:07:45.705318	2488
13106	42	2016-05-31 00:07:45.712113	2472
13107	42	2016-05-31 00:07:45.718429	2500
13108	42	2016-05-31 00:07:45.725264	2374
13109	42	2016-05-31 00:07:45.731598	2442
13110	42	2016-05-31 00:07:45.737983	2496
13111	42	2016-05-31 00:07:45.745199	2467
13112	42	2016-05-31 00:07:45.751409	2490
13113	42	2016-05-31 00:07:45.758178	2504
13114	42	2016-05-31 00:07:45.764381	2494
13115	42	2016-05-31 00:07:45.770657	2470
13116	42	2016-05-31 00:07:45.777193	2498
13117	42	2016-05-31 00:07:45.783587	2484
13118	42	2016-05-31 00:07:45.790293	2506
13119	42	2016-05-31 00:07:45.796657	2440
13120	42	2016-05-31 00:07:45.803154	2468
13121	42	2016-05-31 00:07:45.810435	2478
13122	42	2016-05-31 00:07:45.824841	2480
13123	42	2016-05-31 00:07:45.831166	2457
13124	42	2016-05-31 00:07:45.8379	2475
13125	42	2016-05-31 00:07:45.844543	2502
13126	42	2016-05-31 00:07:45.850906	2459
13127	42	2016-05-31 00:07:45.857644	2463
13128	42	2016-05-31 00:07:45.863798	2476
13129	42	2016-05-31 00:07:45.870139	2448
13130	42	2016-05-31 00:07:45.876721	2465
13131	42	2016-05-31 00:07:45.883061	2461
13132	42	2016-05-31 00:07:45.88988	2469
13133	42	2016-05-31 00:07:45.896252	2474
13134	42	2016-05-31 00:07:45.902553	2492
13135	43	2016-05-31 00:07:45.909629	2462
13136	43	2016-05-31 00:07:45.915837	2466
13137	43	2016-05-31 00:07:45.922556	2489
13138	43	2016-05-31 00:07:45.928994	2477
13139	43	2016-05-31 00:07:45.935189	2481
13140	43	2016-05-31 00:07:45.942016	2453
13141	43	2016-05-31 00:07:45.94841	2491
13142	43	2016-05-31 00:07:45.954791	2483
13143	43	2016-05-31 00:07:45.96123	2443
13144	43	2016-05-31 00:07:45.967526	2501
13145	43	2016-05-31 00:07:45.973768	2375
13146	43	2016-05-31 00:07:45.98005	2458
13147	43	2016-05-31 00:07:45.987239	2499
13148	43	2016-05-31 00:07:45.993563	2471
13149	43	2016-05-31 00:07:45.999873	2487
13150	43	2016-05-31 00:07:46.006247	2441
13151	43	2016-05-31 00:07:46.012601	2451
13152	43	2016-05-31 00:07:46.023732	2507
13153	43	2016-05-31 00:07:46.030656	2464
13154	43	2016-05-31 00:07:46.037079	2497
13155	43	2016-05-31 00:07:46.043462	2460
13156	43	2016-05-31 00:07:46.049624	2493
13157	43	2016-05-31 00:07:46.05612	2473
13158	43	2016-05-31 00:07:46.062371	2445
13159	43	2016-05-31 00:07:46.068634	2485
13160	43	2016-05-31 00:07:46.074796	2495
13161	43	2016-05-31 00:07:46.08102	2449
13162	43	2016-05-31 00:07:46.087172	2505
13163	43	2016-05-31 00:07:46.093467	2479
13164	43	2016-05-31 00:07:46.099673	2456
13165	43	2016-05-31 00:07:46.105851	2503
13166	40	2016-05-31 00:07:46.130159	47212
13167	40	2016-05-31 00:07:46.135976	47206
13168	40	2016-05-31 00:07:46.142055	47215
13169	40	2016-05-31 00:07:46.147842	47209
13170	40	2016-05-31 00:07:46.153423	47256
13171	40	2016-05-31 00:07:46.159153	47347
13172	40	2016-05-31 00:07:46.168924	47340
13173	40	2016-05-31 00:07:46.175298	47203
13174	40	2016-05-31 00:07:46.181095	47350
13175	40	2016-05-31 00:07:46.186899	47343
13176	49	2016-05-31 00:07:46.196715	47347
13177	49	2016-05-31 00:07:46.204196	47343
13178	49	2016-05-31 00:07:46.211784	47212
13179	49	2016-05-31 00:07:46.219427	47206
13180	49	2016-05-31 00:07:46.226886	47350
13181	49	2016-05-31 00:07:46.238298	47340
13182	49	2016-05-31 00:07:46.246032	47203
13183	49	2016-05-31 00:07:46.253709	47215
13184	49	2016-05-31 00:07:46.26132	47209
13185	49	2016-05-31 00:07:46.26863	47256
13186	48	2016-05-31 00:07:46.279264	2500
13187	48	2016-05-31 00:07:46.287906	2374
13188	48	2016-05-31 00:07:46.296387	2475
13189	48	2016-05-31 00:07:46.304892	2498
13190	48	2016-05-31 00:07:46.313006	2480
13191	48	2016-05-31 00:07:46.32098	2534
13192	48	2016-05-31 00:07:46.329081	2454
13193	48	2016-05-31 00:07:46.337769	2465
13194	48	2016-05-31 00:07:46.346503	2459
13195	48	2016-05-31 00:07:46.35489	2472
13196	48	2016-05-31 00:07:46.364118	2467
13197	48	2016-05-31 00:07:46.372596	2504
13198	48	2016-05-31 00:07:46.381117	2469
13199	48	2016-05-31 00:07:46.389618	2442
13200	48	2016-05-31 00:07:46.398142	2474
13201	48	2016-05-31 00:07:46.406724	2486
13202	48	2016-05-31 00:07:46.416862	2476
13203	48	2016-05-31 00:07:46.425731	2492
13204	48	2016-05-31 00:07:46.434149	2448
13205	48	2016-05-31 00:07:46.442759	2490
13206	48	2016-05-31 00:07:46.451191	2440
13207	48	2016-05-31 00:07:46.459906	2452
13208	48	2016-05-31 00:07:46.468368	2468
13209	48	2016-05-31 00:07:46.47689	2450
13210	48	2016-05-31 00:07:46.485709	2470
13211	48	2016-05-31 00:07:46.49437	2506
13212	48	2016-05-31 00:07:46.502919	2461
13213	48	2016-05-31 00:07:46.511673	2502
13214	48	2016-05-31 00:07:46.521445	2455
13215	48	2016-05-31 00:07:46.529901	2478
13216	48	2016-05-31 00:07:46.538415	2488
13217	48	2016-05-31 00:07:46.546731	2494
13218	48	2016-05-31 00:07:46.555323	2484
13219	48	2016-05-31 00:07:46.563501	2514
13220	48	2016-05-31 00:07:46.571393	2531
13221	48	2016-05-31 00:07:46.579691	2457
13222	48	2016-05-31 00:07:46.588119	2482
13223	48	2016-05-31 00:07:46.596539	2463
13224	48	2016-05-31 00:07:46.604824	2444
13225	48	2016-05-31 00:07:46.613437	2496
13226	50	2016-05-31 00:07:46.647502	47347
13227	50	2016-05-31 00:07:46.655053	47343
13228	50	2016-05-31 00:07:46.663789	47212
13229	50	2016-05-31 00:07:46.671685	47206
13230	50	2016-05-31 00:07:46.67926	47350
13231	50	2016-05-31 00:07:46.69088	47340
13232	50	2016-05-31 00:07:46.698544	47203
13233	50	2016-05-31 00:07:46.706429	47215
13234	50	2016-05-31 00:07:46.714268	47209
13235	50	2016-05-31 00:07:46.721708	47256
13236	47	2016-05-31 00:07:46.732879	2500
13237	47	2016-05-31 00:07:46.741468	2374
13238	47	2016-05-31 00:07:46.749695	2475
13239	47	2016-05-31 00:07:46.757798	2498
13240	47	2016-05-31 00:07:46.765956	2480
13241	47	2016-05-31 00:07:46.774017	2534
13242	47	2016-05-31 00:07:46.782117	2454
13243	47	2016-05-31 00:07:46.790138	2465
13244	47	2016-05-31 00:07:46.798561	2459
13245	47	2016-05-31 00:07:46.808428	2472
13246	47	2016-05-31 00:07:46.816981	2467
13247	47	2016-05-31 00:07:46.82561	2504
13248	47	2016-05-31 00:07:46.834288	2469
13249	47	2016-05-31 00:07:46.842591	2442
13250	47	2016-05-31 00:07:46.851037	2474
13251	47	2016-05-31 00:07:46.859209	2486
13252	47	2016-05-31 00:07:46.867451	2476
13253	47	2016-05-31 00:07:46.875458	2492
13254	47	2016-05-31 00:07:46.883445	2448
13255	47	2016-05-31 00:07:46.892262	2490
13256	47	2016-05-31 00:07:46.900827	2440
13257	47	2016-05-31 00:07:46.909393	2452
13258	47	2016-05-31 00:07:46.918524	2468
13259	47	2016-05-31 00:07:46.927225	2450
13260	47	2016-05-31 00:07:46.935803	2470
13261	47	2016-05-31 00:07:46.944307	2506
13262	47	2016-05-31 00:07:46.95314	2461
13263	47	2016-05-31 00:07:46.961678	2502
13264	47	2016-05-31 00:07:46.970348	2455
13265	47	2016-05-31 00:07:46.978874	2478
13266	47	2016-05-31 00:07:46.989904	2488
13267	47	2016-05-31 00:07:46.998698	2494
13268	47	2016-05-31 00:07:47.007948	2484
13269	47	2016-05-31 00:07:47.01649	2514
13270	47	2016-05-31 00:07:47.024402	2531
13271	47	2016-05-31 00:07:47.032524	2457
13272	47	2016-05-31 00:07:47.040761	2482
13273	47	2016-05-31 00:07:47.048973	2463
13274	47	2016-05-31 00:07:47.056921	2444
13275	47	2016-05-31 00:07:47.065451	2496
\.


--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_notificacoes_id_seq', 13275, true);


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
5210	177	ss@swq	47209	2016-05-24 23:25:15.970579	279
5211	9	ssss	47209	2016-05-24 23:25:15.997316	279
5212	13	nova vaga lll	47218	2016-05-25 00:41:20.734691	1
5213	174	enunciadp	47218	2016-05-25 00:41:20.735409	1
5214	1	 job description	47218	2016-05-25 00:41:20.735811	1
5215	13	nova vaga lll	47219	2016-05-25 00:41:30.924185	1
5216	174	enunciadp	47219	2016-05-25 00:41:30.924939	1
5217	1	 job description	47219	2016-05-25 00:41:30.92541	1
5218	13	nova vaga lll	47220	2016-05-25 00:43:08.571793	1
5219	174	enunciadp	47220	2016-05-25 00:43:08.572236	1
5220	1	 job description	47220	2016-05-25 00:43:08.572679	1
5221	13	nova vaga lll	47221	2016-05-25 00:43:55.240436	1
5222	174	enunciadp	47221	2016-05-25 00:43:55.309855	1
5223	1	 job description	47221	2016-05-25 00:43:55.356623	1
5224	13	nova vaga lll	47222	2016-05-25 00:44:37.894443	1
5225	174	enunciadp	47222	2016-05-25 00:44:37.894927	1
5226	1	 job description	47222	2016-05-25 00:44:37.895325	1
5227	13	e agora	47223	2016-05-25 00:44:50.523519	1
5228	174	fkfk	47223	2016-05-25 00:44:50.52434	1
5229	1	mmxmx\r\n	47223	2016-05-25 00:44:50.52497	1
5230	13	nova vaga lll	47224	2016-05-25 00:45:13.664112	1
5231	174	enunciadp	47224	2016-05-25 00:45:13.664622	1
5232	1	 job description	47224	2016-05-25 00:45:13.683608	1
5233	13	d1d	47225	2016-05-25 00:45:19.949213	1
5234	174	d1d1	47225	2016-05-25 00:45:19.950012	1
5235	1	d1d	47225	2016-05-25 00:45:19.950428	1
5236	13	d1d	47226	2016-05-25 00:45:27.241137	1
5237	174	d1d1	47226	2016-05-25 00:45:27.241913	1
5238	1	d1d	47226	2016-05-25 00:45:27.242322	1
5239	13	d1d	47227	2016-05-25 00:47:04.269113	1
5240	174	d1d1	47227	2016-05-25 00:47:04.269956	1
5241	1	d1d	47227	2016-05-25 00:47:04.270651	1
5242	13	ee232	47228	2016-05-25 00:48:11.274807	1
5243	174	e23e1	47228	2016-05-25 00:48:11.275788	1
5244	1	21e1	47228	2016-05-25 00:48:11.27631	1
5245	13	ee232	47229	2016-05-25 00:48:38.394946	1
5246	174	e23e1	47229	2016-05-25 00:48:38.395552	1
5247	1	21e1	47229	2016-05-25 00:48:38.395941	1
5248	13	w2w1	47230	2016-05-25 00:51:26.718489	1
5249	174	w12ww	47230	2016-05-25 00:51:26.719305	1
5250	1	21w1	47230	2016-05-25 00:51:26.71975	1
5251	13	w1	47231	2016-05-25 00:51:35.503342	1
5252	174	w12	47231	2016-05-25 00:51:35.504134	1
5253	1	wsw	47231	2016-05-25 00:51:35.504556	1
5254	13	w1	47232	2016-05-25 00:53:39.376033	1
5255	174	w12	47232	2016-05-25 00:53:39.376525	1
5256	1	wsw	47232	2016-05-25 00:53:39.376919	1
5257	13	w12	47233	2016-05-25 00:53:43.247105	1
5258	174	w12	47233	2016-05-25 00:53:43.247954	1
5259	1	w12	47233	2016-05-25 00:53:43.248362	1
5260	13	w12	47234	2016-05-25 00:54:20.205202	1
5261	174	w12	47234	2016-05-25 00:54:20.205662	1
5262	1	w12	47234	2016-05-25 00:54:20.206039	1
5263	13	w12	47235	2016-05-25 00:54:56.301409	1
5264	174	w12	47235	2016-05-25 00:54:56.302245	1
5265	1	w12	47235	2016-05-25 00:54:56.302656	1
5266	13	w12	47236	2016-05-25 00:55:32.535522	1
5267	174	w12	47236	2016-05-25 00:55:32.536092	1
5268	1	w12	47236	2016-05-25 00:55:32.536508	1
5269	11	Stefany Cruz	47237	2016-05-25 00:55:55.203747	273
5270	12	c#	47237	2016-05-25 00:55:55.204322	273
5271	2	hub	47237	2016-05-25 00:55:55.204758	273
5272	166	ginga	47237	2016-05-25 00:55:55.205287	273
5273	11	Stefany Cruz	47240	2016-05-25 00:56:48.293778	273
5274	12	c#	47240	2016-05-25 00:56:48.295806	273
5275	2	hub	47240	2016-05-25 00:56:48.341875	273
5276	166	ginga	47240	2016-05-25 00:56:48.342778	273
5277	11	Stefany Cruz	47243	2016-05-25 00:57:35.335045	273
5278	12	c#	47243	2016-05-25 00:57:35.335885	273
5279	2	hub	47243	2016-05-25 00:57:35.336298	273
5280	166	ginga	47243	2016-05-25 00:57:35.336779	273
5281	13	ee232	47246	2016-05-25 00:58:49.959572	1
5282	174	e23e1	47246	2016-05-25 00:58:49.960487	1
5283	1	21e1	47246	2016-05-25 00:58:49.960893	1
5284	11	Stefany Cruz	47247	2016-05-25 00:58:52.28154	273
5285	12	c#	47247	2016-05-25 00:58:52.282076	273
5286	2	hub	47247	2016-05-25 00:58:52.28246	273
5287	166	ginga	47247	2016-05-25 00:58:52.282866	273
5288	11	njk	47250	2016-05-25 01:05:06.598494	273
5289	12	njk	47250	2016-05-25 01:05:06.599435	273
5290	2	njk	47250	2016-05-25 01:05:06.599851	273
5291	166	njk	47250	2016-05-25 01:05:06.60025	273
5292	11	njk	47253	2016-05-25 01:05:20.190994	273
5293	12	njk	47253	2016-05-25 01:05:20.191841	273
5294	2	njk	47253	2016-05-25 01:05:20.192289	273
5295	166	njk	47253	2016-05-25 01:05:20.192704	273
5296	11	njk	47256	2016-05-25 01:06:26.331663	273
5297	12	njk	47256	2016-05-25 01:06:26.332187	273
5298	2	njk	47256	2016-05-25 01:06:26.337096	273
5299	166	njk	47256	2016-05-25 01:06:26.337606	273
5300	11	njk	47258	2016-05-25 01:11:07.342451	273
5301	12	njk	47258	2016-05-25 01:11:07.343035	273
5302	2	njk	47258	2016-05-25 01:11:07.343425	273
5303	166	njk	47258	2016-05-25 01:11:07.343792	273
5304	11	njk	47261	2016-05-25 01:15:30.733024	273
5305	12	njk	47261	2016-05-25 01:15:30.733468	273
5306	2	njk	47261	2016-05-25 01:15:30.733826	273
5307	166	njk	47261	2016-05-25 01:15:30.734185	273
5308	11	njk	47264	2016-05-25 01:15:51.222843	273
5309	12	njk	47264	2016-05-25 01:15:51.223312	273
5310	2	njk	47264	2016-05-25 01:15:51.223807	273
5311	166	njk	47264	2016-05-25 01:15:51.224205	273
5312	11	jiu	47267	2016-05-25 01:15:59.428403	273
5313	12	jui	47267	2016-05-25 01:15:59.428928	273
5314	2	hiu	47267	2016-05-25 01:15:59.429312	273
5315	166	hi	47267	2016-05-25 01:15:59.429795	273
5316	11	njk	47270	2016-05-25 01:18:11.425429	273
5317	12	njk	47270	2016-05-25 01:18:11.425932	273
5318	2	njk	47270	2016-05-25 01:18:11.430733	273
5319	166	njk	47270	2016-05-25 01:18:11.431206	273
5320	11	jiu	47273	2016-05-25 01:18:14.194722	273
5321	12	jui	47273	2016-05-25 01:18:14.19552	273
5322	2	hiu	47273	2016-05-25 01:18:14.195957	273
5323	166	hi	47273	2016-05-25 01:18:14.196383	273
5324	11	jiu	47276	2016-05-25 01:18:29.125081	273
5325	12	jui	47276	2016-05-25 01:18:29.126022	273
5326	2	hiu	47276	2016-05-25 01:18:29.126466	273
5327	166	hi	47276	2016-05-25 01:18:29.126956	273
5328	11	njk	47278	2016-05-25 01:18:33.679804	273
5329	12	njk	47278	2016-05-25 01:18:33.680293	273
5330	2	njk	47278	2016-05-25 01:18:33.680665	273
5331	166	njk	47278	2016-05-25 01:18:33.681017	273
5332	11	njk	47280	2016-05-25 01:22:07.232212	273
5333	12	njk	47280	2016-05-25 01:22:07.232871	273
5334	2	njk	47280	2016-05-25 01:22:07.233349	273
5335	166	njk	47280	2016-05-25 01:22:07.233743	273
5336	11	njk	47282	2016-05-25 01:22:29.137215	273
5337	12	njk	47282	2016-05-25 01:22:29.138234	273
5338	2	njk	47282	2016-05-25 01:22:29.138665	273
5339	166	njk	47282	2016-05-25 01:22:29.139045	273
5340	11	njk	47285	2016-05-25 01:22:55.86624	273
5341	12	njk	47285	2016-05-25 01:22:55.866731	273
5342	2	njk	47285	2016-05-25 01:22:55.867196	273
5343	166	njk	47285	2016-05-25 01:22:55.867567	273
5344	11	auto associa ?	47288	2016-05-25 01:28:41.890514	273
5345	12	tec	47288	2016-05-25 01:28:41.89139	273
5346	2	hubbb	47288	2016-05-25 01:28:41.891798	273
5347	166	consss	47288	2016-05-25 01:28:41.892194	273
5348	11	auto associa ?	47290	2016-05-25 01:28:53.561187	273
5349	12	tec	47290	2016-05-25 01:28:53.562042	273
5350	2	hubbb	47290	2016-05-25 01:28:53.562481	273
5351	166	consss	47290	2016-05-25 01:28:53.562946	273
5352	11	auto associa ?	47292	2016-05-25 01:30:54.587257	273
5353	12	tec	47292	2016-05-25 01:30:54.588164	273
5354	2	hubbb	47292	2016-05-25 01:30:54.588642	273
5355	166	consss	47292	2016-05-25 01:30:54.58904	273
5356	11	auto associa ?	47295	2016-05-25 01:31:01.550394	273
5357	12	tec	47295	2016-05-25 01:31:01.551236	273
5358	2	hubbb	47295	2016-05-25 01:31:01.551633	273
5359	166	consss	47295	2016-05-25 01:31:01.552001	273
5360	11	auto associa ?	47298	2016-05-25 01:31:04.311361	273
5361	12	tec	47298	2016-05-25 01:31:04.311924	273
5362	2	hubbb	47298	2016-05-25 01:31:04.312312	273
5363	166	consss	47298	2016-05-25 01:31:04.312688	273
5364	11	auto associa ?	47301	2016-05-25 01:31:22.432261	273
5365	12	tec	47301	2016-05-25 01:31:22.432812	273
5366	2	hubbb	47301	2016-05-25 01:31:22.43324	273
5367	166	consss	47301	2016-05-25 01:31:22.451055	273
5368	11	auto associa ?	47304	2016-05-25 01:31:25.528874	273
5369	12	tec	47304	2016-05-25 01:31:25.529631	273
5370	2	hubbb	47304	2016-05-25 01:31:25.530021	273
5371	166	consss	47304	2016-05-25 01:31:25.530442	273
5372	11	auto associa ?	47307	2016-05-25 01:32:02.17105	273
5373	12	tec	47307	2016-05-25 01:32:02.171559	273
5374	2	hubbb	47307	2016-05-25 01:32:02.172008	273
5375	166	consss	47307	2016-05-25 01:32:02.172422	273
5376	11	auto associa ?	47310	2016-05-25 01:32:56.431373	273
5377	12	tec	47310	2016-05-25 01:32:56.431937	273
5378	2	hubbb	47310	2016-05-25 01:32:56.432329	273
5379	166	consss	47310	2016-05-25 01:32:56.432699	273
5380	11	auto associa ?	47313	2016-05-25 01:33:16.238288	273
5381	12	tec	47313	2016-05-25 01:33:16.239195	273
5382	2	hubbb	47313	2016-05-25 01:33:16.239596	273
5383	166	consss	47313	2016-05-25 01:33:16.240029	273
5384	11	auto associa ?	47316	2016-05-25 01:33:28.039347	273
5385	12	tec	47316	2016-05-25 01:33:28.04025	273
5386	2	hubbb	47316	2016-05-25 01:33:28.040695	273
5387	166	consss	47316	2016-05-25 01:33:28.041117	273
5388	11	auto associa ?	47319	2016-05-25 01:34:30.102127	273
5389	12	tec	47319	2016-05-25 01:34:30.102995	273
5390	2	hubbb	47319	2016-05-25 01:34:30.1034	273
5391	166	consss	47319	2016-05-25 01:34:30.103861	273
5392	11	auto associa ?	47322	2016-05-25 01:35:09.998821	273
5393	12	tec	47322	2016-05-25 01:35:09.99937	273
5394	2	hubbb	47322	2016-05-25 01:35:09.999709	273
5395	166	consss	47322	2016-05-25 01:35:10.000091	273
5396	11	auto associa ?	47325	2016-05-25 01:38:40.990376	273
5397	12	tec	47325	2016-05-25 01:38:40.990883	273
5398	2	hubbb	47325	2016-05-25 01:38:40.991278	273
5399	166	consss	47325	2016-05-25 01:38:40.991652	273
5400	11	auto associa ?	47328	2016-05-25 01:38:49.6541	273
5401	12	tec	47328	2016-05-25 01:38:49.655044	273
5402	2	hubbb	47328	2016-05-25 01:38:49.655449	273
5403	166	consss	47328	2016-05-25 01:38:49.655847	273
5404	11	auto associa ?	47331	2016-05-25 01:41:11.995458	273
5405	12	tec	47331	2016-05-25 01:41:11.995973	273
5406	2	hubbb	47331	2016-05-25 01:41:11.996392	273
5407	166	consss	47331	2016-05-25 01:41:11.996831	273
5408	11	auto associa ?	47334	2016-05-25 01:41:22.151291	273
5409	12	tec	47334	2016-05-25 01:41:22.151898	273
5410	2	hubbb	47334	2016-05-25 01:41:22.152366	273
5411	166	consss	47334	2016-05-25 01:41:22.152733	273
5412	11	auto associa ?	47337	2016-05-25 01:41:25.431709	273
5413	12	tec	47337	2016-05-25 01:41:25.432559	273
5414	2	hubbb	47337	2016-05-25 01:41:25.433012	273
5415	166	consss	47337	2016-05-25 01:41:25.433419	273
5416	4	total	47257	2016-05-25 01:42:03.262049	274
5417	10	total	47257	2016-05-25 01:42:03.263007	274
5418	5	Denis	47256	2016-05-25 01:43:13.800718	275
5419	6	nao gostei do cara mas vai 	47256	2016-05-25 01:43:54.351813	276
5420	7	de todos os entrevistados foi o que apresentou melhor custo x beneficio	47256	2016-05-25 01:44:14.847634	277
5421	163	880	47256	2016-05-25 01:44:58.26117	278
5422	164	black friday	47256	2016-05-25 01:44:58.262003	278
5423	177	njk@oil	47256	2016-05-25 01:45:23.153723	279
5424	9	foi sim	47256	2016-05-25 01:45:23.15459	279
5425	11	miguel cruz	47340	2016-05-25 01:48:11.401685	273
5426	12	java e Go	47340	2016-05-25 01:48:11.402524	273
5427	2	hubb	47340	2016-05-25 01:48:11.402954	273
5428	166	Verx	47340	2016-05-25 01:48:11.403358	273
5429	180	Sr	47342	2016-05-25 01:49:04.273561	288
5430	181	to de boa	47342	2016-05-25 01:49:04.274594	288
5431	4	jr	47341	2016-05-25 01:49:36.507706	274
5432	10	sim	47341	2016-05-25 01:49:36.508697	274
5433	4	jr	47341	2016-05-25 01:49:45.963918	274
5434	10	sim	47341	2016-05-25 01:49:45.9649	274
5435	4	jr	47341	2016-05-25 01:49:49.71722	274
5436	10	sim	47341	2016-05-25 01:49:49.718254	274
5437	4	jr	47341	2016-05-25 01:50:31.080886	274
5438	10	sim	47341	2016-05-25 01:50:31.081893	274
5439	4	jr	47341	2016-05-25 01:52:55.645506	274
5440	10	sim	47341	2016-05-25 01:52:55.646603	274
5441	4	jr	47341	2016-05-25 01:53:57.355524	274
5442	10	sim	47341	2016-05-25 01:53:57.43274	274
5443	4	jr	47341	2016-05-25 01:54:00.106457	274
5444	10	sim	47341	2016-05-25 01:54:00.119839	274
5445	4	jr	47341	2016-05-25 01:54:33.187958	274
5446	10	sim	47341	2016-05-25 01:54:33.190142	274
5447	4	jr	47341	2016-05-25 01:59:07.37842	274
5448	10	sim	47341	2016-05-25 01:59:07.381024	274
5449	4	jr	47341	2016-05-25 02:01:44.34191	274
5450	10	sim	47341	2016-05-25 02:01:44.344082	274
5451	11	nome do candidato	47343	2016-05-30 22:13:10.002105	273
5452	2	kkn	47343	2016-05-30 22:13:10.011709	273
5453	166	mazza	47343	2016-05-30 22:13:10.012316	273
5454	182	php, asp, python	47343	2016-05-30 22:13:10.012747	273
5455	12	python	47343	2016-05-30 22:13:10.013144	273
5456	180	SR	47345	2016-05-30 22:13:53.443174	288
5457	181	ta de boa	47345	2016-05-30 22:13:53.508036	288
5458	4	Espec	47344	2016-05-30 22:14:15.923522	274
5459	10	fodao	47344	2016-05-30 22:14:15.983675	274
5460	13	android	47346	2016-05-30 23:28:33.525622	1
5461	174	enunciado	47346	2016-05-30 23:28:33.526292	1
5462	1	android...	47346	2016-05-30 23:28:33.526685	1
5463	11	marcos arthur	47347	2016-05-30 23:29:10.836033	273
5464	2	girmsk	47347	2016-05-30 23:29:10.836611	273
5465	166	,,sk	47347	2016-05-30 23:29:10.837009	273
5466	182	android	47347	2016-05-30 23:29:10.837391	273
5467	12	android	47347	2016-05-30 23:29:10.837836	273
5468	180	SR	47349	2016-05-30 23:31:25.085786	288
5469	181	xxxxx	47349	2016-05-30 23:31:25.086686	288
5470	4	sr	47348	2016-05-30 23:32:22.260304	274
5471	10	rsr	47348	2016-05-30 23:32:22.2765	274
5472	11	rossetto	47350	2016-05-30 23:36:29.145593	273
5473	2	kk	47350	2016-05-30 23:36:29.146262	273
5474	166	mm	47350	2016-05-30 23:36:29.14671	273
5475	182	ksks	47350	2016-05-30 23:36:29.147148	273
5476	12	nnnx	47350	2016-05-30 23:36:29.147552	273
5477	180	pl	47352	2016-05-30 23:37:11.555196	288
5478	181	kkskks	47352	2016-05-30 23:37:11.556207	288
5479	4	jr	47351	2016-05-30 23:37:41.193458	274
5480	10	kkmko	47351	2016-05-30 23:37:41.194399	274
5481	172	sxxasxa	47350	2016-05-30 23:38:11.507468	286
5482	5	paffi	47347	2016-05-30 23:38:23.449891	275
5483	170	cdscdscds	47350	2016-05-30 23:38:45.170937	285
5484	6	kkmoo	47347	2016-05-30 23:39:06.153753	276
5485	5	siqueira	47350	2016-05-30 23:39:26.8506	275
5486	7	jjj	47347	2016-05-30 23:39:38.657066	277
5487	167	nao gostei	47350	2016-05-30 23:39:57.002055	281
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 5487, true);


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
289	1	85	Relatórios	9	1	R	\N	\N	\N	\N	\N	\N
\.


--
-- Name: workflow_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_postos_id_seq', 289, true);


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
2401	47209	280	2016-05-24 23:25:15.998257	\N	\N
2389	47209	7	2016-05-22 01:36:22.926	2016-05-24 23:25:16.006478	\N
2402	47218	1	2016-05-25 00:41:20.736455	2016-05-25 00:41:20.736455	\N
2403	47218	2	2016-05-25 00:41:20.748751	\N	\N
2404	47219	1	2016-05-25 00:41:30.926159	2016-05-25 00:41:30.926159	\N
2405	47219	2	2016-05-25 00:41:30.938915	\N	\N
2406	47220	1	2016-05-25 00:43:08.573384	2016-05-25 00:43:08.573384	\N
2407	47220	2	2016-05-25 00:43:08.589875	\N	\N
2408	47221	1	2016-05-25 00:43:55.457058	2016-05-25 00:43:55.457058	\N
2409	47221	2	2016-05-25 00:43:55.705901	\N	\N
2410	47222	1	2016-05-25 00:44:37.896016	2016-05-25 00:44:37.896016	\N
2411	47222	2	2016-05-25 00:44:37.91326	\N	\N
2412	47223	1	2016-05-25 00:44:50.525763	2016-05-25 00:44:50.525763	\N
2413	47223	2	2016-05-25 00:44:50.537214	\N	\N
2414	47224	1	2016-05-25 00:45:13.68456	2016-05-25 00:45:13.68456	\N
2415	47224	2	2016-05-25 00:45:13.695926	\N	\N
2416	47225	1	2016-05-25 00:45:19.951346	2016-05-25 00:45:19.951346	\N
2417	47225	2	2016-05-25 00:45:19.963344	\N	\N
2418	47226	1	2016-05-25 00:45:27.24307	2016-05-25 00:45:27.24307	\N
2419	47226	2	2016-05-25 00:45:27.25598	\N	\N
2420	47227	1	2016-05-25 00:47:04.271741	2016-05-25 00:47:04.271741	\N
2421	47227	2	2016-05-25 00:47:04.284094	\N	\N
2422	47228	1	2016-05-25 00:48:11.277143	2016-05-25 00:48:11.277143	\N
2423	47228	2	2016-05-25 00:48:11.288535	\N	\N
2424	47229	1	2016-05-25 00:48:38.396677	2016-05-25 00:48:38.396677	\N
2425	47229	2	2016-05-25 00:48:38.414113	\N	\N
2426	47230	1	2016-05-25 00:51:26.72045	2016-05-25 00:51:26.72045	\N
2427	47230	2	2016-05-25 00:51:26.732372	\N	\N
2428	47231	1	2016-05-25 00:51:35.505626	2016-05-25 00:51:35.505626	\N
2429	47231	2	2016-05-25 00:51:35.518517	\N	\N
2430	47232	1	2016-05-25 00:53:39.377909	2016-05-25 00:53:39.377909	\N
2431	47232	2	2016-05-25 00:53:39.393972	\N	\N
2432	47233	1	2016-05-25 00:53:43.249148	2016-05-25 00:53:43.249148	\N
2433	47233	2	2016-05-25 00:53:43.260895	\N	\N
2434	47234	1	2016-05-25 00:54:20.20666	2016-05-25 00:54:20.20666	\N
2435	47234	2	2016-05-25 00:54:20.222981	\N	\N
2436	47235	1	2016-05-25 00:54:56.303351	2016-05-25 00:54:56.303351	\N
2437	47235	2	2016-05-25 00:54:56.315494	\N	\N
2438	47236	1	2016-05-25 00:55:32.537283	2016-05-25 00:55:32.537283	\N
2439	47236	2	2016-05-25 00:55:32.549017	\N	\N
2440	47238	3	2016-05-25 00:55:55.206605	\N	7
2441	47239	287	2016-05-25 00:55:55.240556	\N	5
2442	47241	3	2016-05-25 00:56:48.344475	\N	6
2443	47242	287	2016-05-25 00:56:48.378841	\N	7
2444	47244	3	2016-05-25 00:57:35.338074	\N	7
2445	47245	287	2016-05-25 00:57:35.371358	\N	3
2446	47246	1	2016-05-25 00:58:49.961614	2016-05-25 00:58:49.961614	\N
2447	47246	2	2016-05-25 00:58:49.972787	\N	\N
2448	47248	3	2016-05-25 00:58:52.288492	\N	6
2449	47249	287	2016-05-25 00:58:52.323435	\N	5
2450	47251	3	2016-05-25 01:05:06.601547	\N	3
2451	47252	287	2016-05-25 01:05:06.635675	\N	7
2452	47254	3	2016-05-25 01:05:20.194313	\N	3
2453	47255	287	2016-05-25 01:05:20.230386	\N	7
2455	47259	3	2016-05-25 01:11:07.349383	\N	6
2456	47260	287	2016-05-25 01:11:07.383913	\N	6
2457	47262	3	2016-05-25 01:15:30.739946	\N	6
2458	47263	287	2016-05-25 01:15:30.774812	\N	6
2459	47265	3	2016-05-25 01:15:51.230019	\N	7
2460	47266	287	2016-05-25 01:15:51.254835	\N	5
2461	47268	3	2016-05-25 01:15:59.431057	\N	3
2462	47269	287	2016-05-25 01:15:59.455768	\N	5
2463	47271	3	2016-05-25 01:18:11.432538	\N	6
2464	47272	287	2016-05-25 01:18:11.466138	\N	3
2465	47274	3	2016-05-25 01:18:14.197724	\N	3
2466	47275	287	2016-05-25 01:18:14.232434	\N	5
2467	47277	3	2016-05-25 01:18:29.128254	\N	\N
2468	47279	3	2016-05-25 01:18:33.682206	\N	\N
2469	47281	3	2016-05-25 01:22:07.234991	\N	\N
2470	47283	3	2016-05-25 01:22:29.140399	\N	5
2471	47284	287	2016-05-25 01:22:29.174144	\N	5
2472	47286	3	2016-05-25 01:22:55.873312	\N	3
2473	47287	287	2016-05-25 01:22:55.907976	\N	5
2474	47289	3	2016-05-25 01:28:41.893617	\N	\N
2475	47291	3	2016-05-25 01:28:53.564397	\N	\N
2476	47293	3	2016-05-25 01:30:54.590383	\N	6
2477	47294	287	2016-05-25 01:30:54.624546	\N	5
2478	47296	3	2016-05-25 01:31:01.553229	\N	5
2479	47297	287	2016-05-25 01:31:01.586821	\N	3
2480	47299	3	2016-05-25 01:31:04.314037	\N	7
2481	47300	287	2016-05-25 01:31:04.347147	\N	5
2482	47302	3	2016-05-25 01:31:22.452616	\N	5
2483	47303	287	2016-05-25 01:31:22.492563	\N	3
2484	47305	3	2016-05-25 01:31:25.532398	\N	3
2485	47306	287	2016-05-25 01:31:25.569146	\N	6
2486	47308	3	2016-05-25 01:32:02.173719	\N	3
2487	47309	287	2016-05-25 01:32:02.20861	\N	7
2488	47311	3	2016-05-25 01:32:56.433976	\N	7
2489	47312	287	2016-05-25 01:32:56.469528	\N	3
2490	47314	3	2016-05-25 01:33:16.241358	\N	5
2491	47315	287	2016-05-25 01:33:16.276196	\N	6
2492	47317	3	2016-05-25 01:33:28.042578	\N	7
2493	47318	287	2016-05-25 01:33:28.078548	\N	3
2494	47320	3	2016-05-25 01:34:30.105163	\N	3
2495	47321	287	2016-05-25 01:34:30.138603	\N	3
2496	47323	3	2016-05-25 01:35:10.001443	\N	3
2497	47324	287	2016-05-25 01:35:10.034566	\N	7
2498	47326	3	2016-05-25 01:38:40.99758	\N	3
2499	47327	287	2016-05-25 01:38:41.031959	\N	7
2500	47329	3	2016-05-25 01:38:49.65709	\N	5
2501	47330	287	2016-05-25 01:38:49.691636	\N	3
2502	47332	3	2016-05-25 01:41:11.998175	\N	6
2503	47333	287	2016-05-25 01:41:12.033705	\N	5
2504	47335	3	2016-05-25 01:41:22.153975	\N	7
2505	47336	287	2016-05-25 01:41:22.188266	\N	6
2506	47338	3	2016-05-25 01:41:25.434922	\N	7
2507	47339	287	2016-05-25 01:41:25.47009	\N	3
2454	47257	3	2016-05-25 01:06:26.338992	2016-05-25 01:42:03.263448	4
2508	47256	4	2016-05-25 01:42:03.274057	2016-05-25 01:43:13.831491	\N
2509	47256	5	2016-05-25 01:43:13.801887	2016-05-25 01:43:54.569396	\N
2510	47256	6	2016-05-25 01:43:54.433531	2016-05-25 01:44:14.878234	\N
2511	47256	8	2016-05-25 01:44:14.848892	2016-05-25 01:44:58.291431	\N
2513	47256	280	2016-05-25 01:45:23.15586	\N	\N
2512	47256	7	2016-05-25 01:44:58.263502	2016-05-25 01:45:23.184223	\N
2515	47342	287	2016-05-25 01:48:11.43906	2016-05-25 01:49:04.275458	6
2516	47340	4	2016-05-25 01:49:36.51886	\N	\N
2517	47340	4	2016-05-25 01:49:45.975083	\N	\N
2518	47340	4	2016-05-25 01:49:49.728568	\N	\N
2519	47340	4	2016-05-25 01:50:31.092386	\N	\N
2520	47340	4	2016-05-25 01:52:55.656775	\N	\N
2521	47340	4	2016-05-25 01:53:57.579206	\N	\N
2522	47340	4	2016-05-25 01:54:00.130739	\N	\N
2523	47340	4	2016-05-25 01:54:33.218326	\N	\N
2524	47340	4	2016-05-25 01:59:07.408894	\N	\N
2514	47341	3	2016-05-25 01:48:11.404664	2016-05-25 02:01:44.34489	3
2525	47340	4	2016-05-25 02:01:44.372859	\N	\N
2527	47345	287	2016-05-30 22:13:10.081717	2016-05-30 22:13:53.570215	6
2526	47344	3	2016-05-30 22:13:10.014562	2016-05-30 22:14:16.027977	6
2528	47343	4	2016-05-30 22:14:16.055537	\N	\N
2529	47346	1	2016-05-30 23:28:33.527386	2016-05-30 23:28:33.527386	\N
2530	47346	2	2016-05-30 23:28:33.560059	\N	\N
2532	47349	287	2016-05-30 23:29:10.871249	2016-05-30 23:31:25.087597	3
2531	47348	3	2016-05-30 23:29:10.839105	2016-05-30 23:32:22.277155	5
2535	47352	287	2016-05-30 23:36:29.181458	2016-05-30 23:37:11.557066	6
2534	47351	3	2016-05-30 23:36:29.148857	2016-05-30 23:37:41.19514	5
2536	47350	4	2016-05-30 23:37:41.204476	2016-05-30 23:38:11.535896	\N
2533	47347	4	2016-05-30 23:32:22.28664	2016-05-30 23:38:23.480265	\N
2537	47350	280	2016-05-30 23:38:11.50886	2016-05-30 23:38:45.200933	\N
2538	47347	5	2016-05-30 23:38:23.451192	2016-05-30 23:39:06.182366	\N
2539	47350	4	2016-05-30 23:38:45.17241	2016-05-30 23:39:26.880367	\N
2542	47347	8	2016-05-30 23:39:38.658336	\N	\N
2540	47347	6	2016-05-30 23:39:06.155025	2016-05-30 23:39:38.707393	\N
2543	47350	4	2016-05-30 23:39:57.00327	\N	\N
2541	47350	5	2016-05-30 23:39:26.85189	2016-05-30 23:39:57.032039	\N
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 2543, true);


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

