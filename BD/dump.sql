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
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 47342, true);


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
\.


--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_notificacoes_id_seq', 4639, true);


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
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 5450, true);


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
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 2525, true);


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

