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
-- Name: customworkflow; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE customworkflow WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';


ALTER DATABASE customworkflow OWNER TO postgres;

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
-- Name: arvore_processo; Type: VIEW; Schema: public; Owner: bsiquei
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


ALTER TABLE arvore_processo OWNER TO bsiquei;

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
-- Name: relacionamento_postos; Type: TABLE; Schema: public; Owner: bsiquei
--

CREATE TABLE relacionamento_postos (
    id integer NOT NULL,
    avanca_processo integer,
    idposto_atual integer
);


ALTER TABLE relacionamento_postos OWNER TO bsiquei;

--
-- Name: relacionamento_postos_id_seq; Type: SEQUENCE; Schema: public; Owner: bsiquei
--

CREATE SEQUENCE relacionamento_postos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE relacionamento_postos_id_seq OWNER TO bsiquei;

--
-- Name: relacionamento_postos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bsiquei
--

ALTER SEQUENCE relacionamento_postos_id_seq OWNED BY relacionamento_postos.id;


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
    login character varying
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
    avanca_processo integer,
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
    fim timestamp without time zone
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
-- Name: id; Type: DEFAULT; Schema: public; Owner: bsiquei
--

ALTER TABLE ONLY relacionamento_postos ALTER COLUMN id SET DEFAULT nextval('relacionamento_postos_id_seq'::regclass);


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
\.


--
-- Name: notificacoes_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('notificacoes_email_id_seq', 7, true);


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
46751	\N	1	2016-05-18 18:47:48.85943	1	Em Andamento	\N
46753	46752	3	2016-05-18 18:47:58.516573	1	Em Andamento	\N
46754	46752	3	2016-05-18 18:47:58.521073	1	Em Andamento	\N
46752	46751	2	2016-05-18 18:47:58.512116	1	Em Andamento	\N
46755	\N	1	2016-05-18 18:55:07.422097	1	Em Andamento	\N
46756	46755	2	2016-05-18 18:56:44.677977	1	\N	\N
46757	46756	3	2016-05-18 18:56:44.684657	1	Em Andamento	\N
46758	46756	3	2016-05-18 18:56:44.710578	1	Em Andamento	\N
46759	46755	2	2016-05-18 18:57:04.507136	1	\N	\N
46760	46759	3	2016-05-18 18:57:04.57512	1	Em Andamento	\N
46761	46759	3	2016-05-18 18:57:04.590604	1	Em Andamento	\N
46762	46755	2	2016-05-18 18:58:04.511226	1	\N	\N
46763	46762	3	2016-05-18 18:58:04.527005	1	Em Andamento	\N
46764	46762	3	2016-05-18 18:58:04.544158	1	Em Andamento	\N
46765	46755	2	2016-05-18 18:59:54.562474	1	\N	\N
46766	46755	2	2016-05-18 19:00:06.392483	1	\N	\N
46767	46755	2	2016-05-18 19:00:20.611335	1	\N	\N
46768	46755	2	2016-05-18 19:03:15.76175	1	\N	\N
46769	46755	2	2016-05-18 19:03:44.251358	1	\N	\N
46770	46755	2	2016-05-18 19:05:21.767721	1	\N	\N
46771	46770	3	2016-05-18 19:05:21.771069	1	Em Andamento	\N
46772	46770	3	2016-05-18 19:05:21.774951	1	Em Andamento	\N
46773	46755	2	2016-05-18 19:05:39.590199	1	\N	\N
46774	46773	3	2016-05-18 19:05:39.594443	1	Em Andamento	\N
46775	46773	3	2016-05-18 19:05:39.598929	1	Em Andamento	\N
46776	46755	2	2016-05-18 19:06:30.863939	1	\N	\N
46777	46776	3	2016-05-18 19:06:30.868403	1	Em Andamento	\N
46778	46776	3	2016-05-18 19:06:30.872336	1	Em Andamento	\N
46779	46755	2	2016-05-18 19:07:03.422576	1	\N	\N
46780	46779	3	2016-05-18 19:07:03.425889	1	Em Andamento	\N
46781	46779	3	2016-05-18 19:07:03.429614	1	Em Andamento	\N
46782	46755	2	2016-05-18 19:08:27.285911	1	\N	\N
46783	46782	3	2016-05-18 19:08:27.994627	1	Em Andamento	\N
46784	46782	3	2016-05-18 19:08:28.147715	1	Em Andamento	\N
46785	46755	2	2016-05-18 19:09:59.55366	1	\N	\N
46786	46785	3	2016-05-18 19:09:59.612769	1	Em Andamento	\N
46787	46785	3	2016-05-18 19:09:59.659665	1	Em Andamento	\N
46788	46755	2	2016-05-18 19:10:03.077709	1	\N	\N
46789	46788	3	2016-05-18 19:10:03.09834	1	Em Andamento	\N
46790	46788	3	2016-05-18 19:10:03.123929	1	Em Andamento	\N
46791	46755	2	2016-05-18 19:10:45.980073	1	\N	\N
46792	46791	3	2016-05-18 19:10:46.059885	1	Em Andamento	\N
46793	46791	3	2016-05-18 19:10:46.094024	1	Em Andamento	\N
46794	\N	1	2016-05-18 19:11:05.326903	1	Em Andamento	\N
46795	\N	1	2016-05-18 19:12:12.875393	1	Em Andamento	\N
46796	\N	1	2016-05-18 19:12:23.43694	1	Em Andamento	\N
46797	\N	1	2016-05-18 19:12:41.643069	1	Em Andamento	\N
46798	\N	1	2016-05-18 19:12:46.08582	1	Em Andamento	\N
46799	46798	2	2016-05-18 19:13:06.528278	1	\N	\N
46800	46799	3	2016-05-18 19:13:06.56477	1	Em Andamento	\N
46801	46799	3	2016-05-18 19:13:06.61419	1	Em Andamento	\N
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 46801, true);


--
-- Data for Name: relacionamento_postos; Type: TABLE DATA; Schema: public; Owner: bsiquei
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
-- Name: relacionamento_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bsiquei
--

SELECT pg_catalog.setval('relacionamento_postos_id_seq', 23, true);


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

COPY usuarios (id, email, nome, senha, login) FROM stdin;
2	babirondo@gmail.com	Analista de Seleção	analista	analista
1	babirondo@gmail.com	Bruno Siqueira	bruno	bruno
3	babirondo@gmail.com	Dev Avaliador	dev	dev
4	babirondo@gmail.com	Total	total	total
5	\N	Dev 2	dev2	dev2
6	\N	Dev 3	dev3	dev3
7	\N	Dev 1	dev1	dev1
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
3980	13	tipovaga	46751	2016-05-18 18:47:48.860243	1
3981	174	enunciado	46751	2016-05-18 18:47:48.860717	1
3982	1	job	46751	2016-05-18 18:47:48.86109	1
3983	11	bruno	46752	2016-05-18 18:47:58.512897	273
3984	12	php	46752	2016-05-18 18:47:58.513492	273
3985	2	hub	46752	2016-05-18 18:47:58.51389	273
3986	3	cv	46752	2016-05-18 18:47:58.514952	273
3987	166	consultoiaa	46752	2016-05-18 18:47:58.515469	273
3988	4	sr	46753	2016-05-18 18:48:12.486321	274
3989	10	 kkkk	46753	2016-05-18 18:48:12.501815	274
3990	180	jr 	46754	2016-05-18 18:48:26.516234	288
3991	181	jsjsjs	46754	2016-05-18 18:48:26.517259	288
3992	5	gestor interessado	46752	2016-05-18 18:49:15.535814	275
3993	6	parecer gestor entrevista presencial	46752	2016-05-18 18:49:39.062955	276
3994	7	parecer decisorio, vai a frente	46752	2016-05-18 18:49:54.79011	277
3995	163	100,00	46752	2016-05-18 18:50:09.832291	278
3996	164	amanha	46752	2016-05-18 18:50:09.833248	278
3997	177	novo@email	46752	2016-05-18 18:50:26.769118	279
3998	9	checklist executado	46752	2016-05-18 18:50:26.769997	279
3999	171	tst	46752	2016-05-18 18:50:37.746222	284
4000	177	novoemail@email	46752	2016-05-18 18:50:57.177384	279
4001	9	checklsit executado de novo	46752	2016-05-18 18:50:57.178664	279
4002	13	ewq	46755	2016-05-18 18:55:07.430651	1
4003	174	ewq	46755	2016-05-18 18:55:07.44337	1
4004	1	eqw	46755	2016-05-18 18:55:07.44405	1
4005	11	dsadas	46756	2016-05-18 18:56:44.678988	273
4006	12		46756	2016-05-18 18:56:44.679668	273
4007	2		46756	2016-05-18 18:56:44.680134	273
4008	166		46756	2016-05-18 18:56:44.683638	273
4009	11	dsadasd	46759	2016-05-18 18:57:04.517232	273
4010	12		46759	2016-05-18 18:57:04.526505	273
4011	2		46759	2016-05-18 18:57:04.52758	273
4012	166		46759	2016-05-18 18:57:04.561277	273
4013	11	dasdsa	46762	2016-05-18 18:58:04.512073	273
4014	12		46762	2016-05-18 18:58:04.524949	273
4015	2		46762	2016-05-18 18:58:04.525569	273
4016	166		46762	2016-05-18 18:58:04.526106	273
4017	11	dasdsa	46765	2016-05-18 18:59:54.563729	273
4018	12		46765	2016-05-18 18:59:54.564266	273
4019	2		46765	2016-05-18 18:59:54.564678	273
4020	166		46765	2016-05-18 18:59:54.579341	273
4021	11	dasdsa	46766	2016-05-18 19:00:06.399816	273
4022	12		46766	2016-05-18 19:00:06.400402	273
4023	2		46766	2016-05-18 19:00:06.40077	273
4024	166		46766	2016-05-18 19:00:06.401127	273
4025	11	dasdsa	46767	2016-05-18 19:00:20.621927	273
4026	12		46767	2016-05-18 19:00:20.622582	273
4027	2		46767	2016-05-18 19:00:20.639977	273
4028	166		46767	2016-05-18 19:00:20.640487	273
4029	11	dasdsa	46768	2016-05-18 19:03:15.763725	273
4030	12		46768	2016-05-18 19:03:15.76454	273
4031	2		46768	2016-05-18 19:03:15.777918	273
4032	166		46768	2016-05-18 19:03:15.778427	273
4033	11	dasdsa	46769	2016-05-18 19:03:44.256223	273
4034	12		46769	2016-05-18 19:03:44.256838	273
4035	2		46769	2016-05-18 19:03:44.257211	273
4036	166		46769	2016-05-18 19:03:44.257568	273
4037	11	dasdsa	46770	2016-05-18 19:05:21.768557	273
4038	12		46770	2016-05-18 19:05:21.769137	273
4039	2		46770	2016-05-18 19:05:21.769516	273
4040	166		46770	2016-05-18 19:05:21.769886	273
4041	3	/	46770	2016-05-18 19:05:21.770217	273
4042	11	dasdsa	46773	2016-05-18 19:05:39.591289	273
4043	12		46773	2016-05-18 19:05:39.591918	273
4044	2		46773	2016-05-18 19:05:39.592348	273
4045	166		46773	2016-05-18 19:05:39.592832	273
4046	3	/	46773	2016-05-18 19:05:39.593424	273
4047	11	dasdsa	46776	2016-05-18 19:06:30.864725	273
4048	12		46776	2016-05-18 19:06:30.8654	273
4049	2		46776	2016-05-18 19:06:30.865917	273
4050	166		46776	2016-05-18 19:06:30.866357	273
4051	3	/	46776	2016-05-18 19:06:30.867176	273
4052	11	dasdsa	46779	2016-05-18 19:07:03.423373	273
4053	12		46779	2016-05-18 19:07:03.424091	273
4054	2		46779	2016-05-18 19:07:03.424456	273
4055	166		46779	2016-05-18 19:07:03.424787	273
4056	3	/private/var/tmp/phphcKvHZ	46779	2016-05-18 19:07:03.425124	273
4057	11	dasdsa	46782	2016-05-18 19:08:27.322693	273
4058	12		46782	2016-05-18 19:08:27.348007	273
4059	2		46782	2016-05-18 19:08:27.46121	273
4060	166		46782	2016-05-18 19:08:27.461945	273
4061	3	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H/SxtWvXyqBBg+S8886TSy65RH8f//77byt+omyUTJSKhLMer732mnzzzTdyww03yI033ijoyN544w159dVX9Y80joczZGdn647hzDPPlOeff15nBeEDEVSlSpVwZh0Tab/zzjtSu3ZtXZayZcv6VSaIsgcffFDuv/9+ufTSS/26Jp5cIuFpCHUEj3HjxgnEmLuVAnFefvlleemllwpUDfcw7t+kpCSZMmWKwFpcMMtZyZLx85PA72WBZo3oAX4vPeP2xeXZZ5/VD6uerNMjRoyQpUuXyldffSV169YVWKPq1KnjOZM4PkpLRyGNh6fCb7/9VipUqCC33Xab/sSQxT333KOvxI2Sm5urt6+44gp58slcJ60U//Of/8h///tfvb9lyxaB2u3Xr59+qsTNt3fvXn0OeeCJ8//+7/+0RaV37966s0SngfD000/ruDNmzNDx0GFMnz7dxdJx+PBhwY9wjx49BOVYsGCBvtb8988//+j4ePq96qqr5OOPPzanpLBrYc0ZPny4XFxwwQX66RmdmDcLQmFp7d69Wx577DHp3r27Tg9sCwv16tWTRo0a6T8jPiZOnKhZ4GkdXFzxdFwwIYiA4S+Is4MHD2qejzzyiD4OPuA8e/Zsueaaa/SXH1wnfv/9d83srLPO0oxg2jThxx9/1OVEm3z66ady+eWXC35UEHy1Kc7//PPPctNNNwnEXCKEz5o1a3AFeQVcJ1wwXDAU1ElEQVQ4JAH1B5fLLrtMMDwyb968AumWKlVKCwrUzz3AooF67tmzR3OCeEU540V08Hsp2soaqu9lUb7j5l7i99KQcP30xAUx8H3ctGmTvPvuu64XHNvDPQ3rHX4j8TDRvn17qVWrlse48XwwoUTHiJ9XysfjAv/z1JCpqan6KbBjx45iH1/Dj3TLli21pWPdunX6UpjH4Gthwvr163WHgH38yKPDhChBh4fObPLkyToqOkdcXIvhmvnz50urVq0EnenUqVP1eZi/EZo3by633367FC9eXFx3FrjGCB50LFDIXCeccIJA7NjNeLgWAgdDFeiYkc77778vptyFXYtywYR/0UUXaUsPrD54uvYUCksLAgp1e/jhh+Xkk0+WF198UTZs2OApKesYOKADx58x/6OzRP0hgPAFrVq1qvZhwTF8uSESEM4++2wtNLC9bds2fQ0ESdOmTaV+/fqyYsUK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	46782	2016-05-18 19:08:27.463363	273
4062	11	dasdsa	46785	2016-05-18 19:09:59.557617	273
4063	12		46785	2016-05-18 19:09:59.558245	273
4064	2		46785	2016-05-18 19:09:59.558703	273
4065	166		46785	2016-05-18 19:09:59.574846	273
4066	3	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H/SxtWvXyqBBg+S8886TSy65RH8f//77byt+omyUTJSKhLMer732mnzzzTdyww03yI033ijoyN544w159dVX9Y80joczZGdn647hzDPPlOeff15nBeEDEVSlSpVwZh0Tab/zzjtSu3ZtXZayZcv6VSaIsgcffFDuv/9+ufTSS/26Jp5cIuFpCHUEj3HjxgnEmLuVAnFefvlleemllwpUDfcw7t+kpCSZMmWKwFpcMMtZyZLx85PA72WBZo3oAX4vPeP2xeXZZ5/VD6uerNMjRoyQpUuXyldffSV169YVWKPq1KnjOZM4PkpLRyGNh6fCb7/9VipUqCC33Xab/sSQxT333KOvxI2Sm5urt6+44gp58slcJ60U//Of/8h///tfvb9lyxaB2u3Xr59+qsTNt3fvXn0OeeCJ8//+7/+0RaV37966s0SngfD000/ruDNmzNDx0GFMnz7dxdJx+PBhwY9wjx49BOVYsGCBvtb8988//+j4ePq96qqr5OOPPzanpLBrYc0ZPny4XFxwwQX66RmdmDcLQmFp7d69Wx577DHp3r27Tg9sCwv16tWTRo0a6T8jPiZOnKhZ4GkdXFzxdFwwIYiA4S+Is4MHD2qejzzyiD4OPuA8e/Zsueaaa/SXH1wnfv/9d83srLPO0oxg2jThxx9/1OVEm3z66ady+eWXC35UEHy1Kc7//PPPctNNNwnEXCKEz5o1a3AFeQVcJ1wwXDAU1ElEQVQ4JAH1B5fLLrtMMDwyb968AumWKlVKCwrUzz3AooF67tmzR3OCeEU540V08Hsp2soaqu9lUb7j5l7i99KQcP30xAUx8H3ctGmTvPvuu64XHNvDPQ3rHX4j8TDRvn17qVWrlse48XwwoUTHiJ9XysfjAv/z1JCpqan6KbBjx45iH1/Dj3TLli21pWPdunX6UpjH4Gthwvr163WHgH38yKPDhChBh4fObPLkyToqOkdcXIvhmvnz50urVq0EnenUqVP1eZi/EZo3by633367FC9eXFx3FrjGCB50LFDIXCeccIJA7NjNeLgWAgdDFeiYkc77778vptyFXYtywYR/0UUXaUsPrD54uvYUCksLAgp1e/jhh+Xkk0+WF198UTZs2OApKesYOKADx58x/6OzRP0hgPAFrVq1qvZhwTF8uSESEM4++2wtNLC9bds2fQ0ESdOmTaV+/fqyYsUK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	46785	2016-05-18 19:09:59.599431	273
4067	11	dasdsa	46788	2016-05-18 19:10:03.08102	273
4068	12		46788	2016-05-18 19:10:03.081586	273
4069	2		46788	2016-05-18 19:10:03.081994	273
4070	166		46788	2016-05-18 19:10:03.082373	273
4071	3	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H/SxtWvXyqBBg+S8886TSy65RH8f//77byt+omyUTJSKhLMer732mnzzzTdyww03yI033ijoyN544w159dVX9Y80joczZGdn647hzDPPlOeff15nBeEDEVSlSpVwZh0Tab/zzjtSu3ZtXZayZcv6VSaIsgcffFDuv/9+ufTSS/26Jp5cIuFpCHUEj3HjxgnEmLuVAnFefvlleemllwpUDfcw7t+kpCSZMmWKwFpcMMtZyZLx85PA72WBZo3oAX4vPeP2xeXZZ5/VD6uerNMjRoyQpUuXyldffSV169YVWKPq1KnjOZM4PkpLRyGNh6fCb7/9VipUqCC33Xab/sSQxT333KOvxI2Sm5urt6+44gp58slcJ60U//Of/8h///tfvb9lyxaB2u3Xr59+qsTNt3fvXn0OeeCJ8//+7/+0RaV37966s0SngfD000/ruDNmzNDx0GFMnz7dxdJx+PBhwY9wjx49BOVYsGCBvtb8988//+j4ePq96qqr5OOPPzanpLBrYc0ZPny4XFxwwQX66RmdmDcLQmFp7d69Wx577DHp3r27Tg9sCwv16tWTRo0a6T8jPiZOnKhZ4GkdXFzxdFwwIYiA4S+Is4MHD2qejzzyiD4OPuA8e/Zsueaaa/SXH1wnfv/9d83srLPO0oxg2jThxx9/1OVEm3z66ady+eWXC35UEHy1Kc7//PPPctNNNwnEXCKEz5o1a3AFeQVcJ1wwXDAU1ElEQVQ4JAH1B5fLLrtMMDwyb968AumWKlVKCwrUzz3AooF67tmzR3OCeEU540V08Hsp2soaqu9lUb7j5l7i99KQcP30xAUx8H3ctGmTvPvuu64XHNvDPQ3rHX4j8TDRvn17qVWrlse48XwwoUTHiJ9XysfjAv/z1JCpqan6KbBjx45iH1/Dj3TLli21pWPdunX6UpjH4Gthwvr163WHgH38yKPDhChBh4fObPLkyToqOkdcXIvhmvnz50urVq0EnenUqVP1eZi/EZo3by633367FC9eXFx3FrjGCB50LFDIXCeccIJA7NjNeLgWAgdDFeiYkc77778vptyFXYtywYR/0UUXaUsPrD54uvYUCksLAgp1e/jhh+Xkk0+WF198UTZs2OApKesYOKADx58x/6OzRP0hgPAFrVq1qvZhwTF8uSESEM4++2wtNLC9bds2fQ0ESdOmTaV+/fqyYsUK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	46788	2016-05-18 19:10:03.083329	273
4072	11	dasdsa	46791	2016-05-18 19:10:45.995085	273
4073	12		46791	2016-05-18 19:10:46.003835	273
4074	2		46791	2016-05-18 19:10:46.004431	273
4075	166		46791	2016-05-18 19:10:46.004879	273
4076	3	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H/SxtWvXyqBBg+S8886TSy65RH8f//77byt+omyUTJSKhLMer732mnzzzTdyww03yI033ijoyN544w159dVX9Y80joczZGdn647hzDPPlOeff15nBeEDEVSlSpVwZh0Tab/zzjtSu3ZtXZayZcv6VSaIsgcffFDuv/9+ufTSS/26Jp5cIuFpCHUEj3HjxgnEmLuVAnFefvlleemllwpUDfcw7t+kpCSZMmWKwFpcMMtZyZLx85PA72WBZo3oAX4vPeP2xeXZZ5/VD6uerNMjRoyQpUuXyldffSV169YVWKPq1KnjOZM4PkpLRyGNh6fCb7/9VipUqCC33Xab/sSQxT333KOvxI2Sm5urt6+44gp58slcJ60U//Of/8h///tfvb9lyxaB2u3Xr59+qsTNt3fvXn0OeeCJ8//+7/+0RaV37966s0SngfD000/ruDNmzNDx0GFMnz7dxdJx+PBhwY9wjx49BOVYsGCBvtb8988//+j4ePq96qqr5OOPPzanpLBrYc0ZPny4XFxwwQX66RmdmDcLQmFp7d69Wx577DHp3r27Tg9sCwv16tWTRo0a6T8jPiZOnKhZ4GkdXFzxdFwwIYiA4S+Is4MHD2qejzzyiD4OPuA8e/Zsueaaa/SXH1wnfv/9d83srLPO0oxg2jThxx9/1OVEm3z66ady+eWXC35UEHy1Kc7//PPPctNNNwnEXCKEz5o1a3AFeQVcJ1wwXDAU1ElEQVQ4JAH1B5fLLrtMMDwyb968AumWKlVKCwrUzz3AooF67tmzR3OCeEU540V08Hsp2soaqu9lUb7j5l7i99KQcP30xAUx8H3ctGmTvPvuu64XHNvDPQ3rHX4j8TDRvn17qVWrlse48XwwoUTHiJ9XysfjAv/z1JCpqan6KbBjx45iH1/Dj3TLli21pWPdunX6UpjH4Gthwvr163WHgH38yKPDhChBh4fObPLkyToqOkdcXIvhmvnz50urVq0EnenUqVP1eZi/EZo3by633367FC9eXFx3FrjGCB50LFDIXCeccIJA7NjNeLgWAgdDFeiYkc77778vptyFXYtywYR/0UUXaUsPrD54uvYUCksLAgp1e/jhh+Xkk0+WF198UTZs2OApKesYOKADx58x/6OzRP0hgPAFrVq1qvZhwTF8uSESEM4++2wtNLC9bds2fQ0ESdOmTaV+/fqyYsUK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	46791	2016-05-18 19:10:46.021671	273
4077	13	ewqeq	46794	2016-05-18 19:11:05.33045	1
4078	174	ewqeq	46794	2016-05-18 19:11:05.339387	1
4079	1	eqweqw	46794	2016-05-18 19:11:05.339946	1
4080	13	dsa	46795	2016-05-18 19:12:12.879888	1
4081	174	dsada	46795	2016-05-18 19:12:12.890528	1
4082	1	dsa	46795	2016-05-18 19:12:12.897606	1
4083	13	dsa	46796	2016-05-18 19:12:23.446623	1
4084	174	dsada	46796	2016-05-18 19:12:23.447534	1
4085	1	dsa	46796	2016-05-18 19:12:23.474893	1
4086	13	dsa	46797	2016-05-18 19:12:41.655377	1
4087	174	dsada	46797	2016-05-18 19:12:41.656367	1
4088	1	dsa	46797	2016-05-18 19:12:41.685439	1
4089	13	d2d2	46798	2016-05-18 19:12:46.222843	1
4090	174	d32d	46798	2016-05-18 19:12:46.254851	1
4091	1	23d23d23d2	46798	2016-05-18 19:12:46.255814	1
4092	11	d32d23	46799	2016-05-18 19:13:06.534975	273
4093	12	d23d2	46799	2016-05-18 19:13:06.535715	273
4094	2	d3d2	46799	2016-05-18 19:13:06.53629	273
4095	166	d32d2	46799	2016-05-18 19:13:06.548829	273
4096	3	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7C3fS9qWMIICTlVRjotxOWFVUUzhgJQxdtkBrXaE9PE/Z+COOwSD3PkBhmm9rccxrYSY8JNXFyNWjqr6OqttlzisJJm1+pSTsjIZ41pcIkXJKx+kWAcMMmNcJ/OHcyCZ3zobpA0+v3dG5jtl8wOeMO0hdT5jd853CihRkhQPcfacHJ1tSriJ4xelYwfLnVC2a542i2nGWjOcCVrjy2qaLu3sCq+pJnUSheOvM4tGNnNnVcD5ahnV7/94tAtFPmz2JFEkiqsX8+8BVKQmixo40s5Z8Aa1XsQuCTk1iEzCkZcCRDRqfjtf5OwLUEsBAlwwXDAUXDBcMAgIXDCdbptIXDBcMFwwXDACXDBcMFwwXDBcMFwwXDAXXDBcMFwwXDBcMFwwXDBcMFwwXDBcMFwwXDBcMFwwXDBcMEJvbml0YUJQTUNvbW11bml0eS5hcHAvUEsBAlwwXDAUXDBcMAgIXDCrbptIXDBcMFwwXDACXDBcMFwwXDBcMFwwXDAgXDBcMFwwXDBcMFwwXDBcMFwwXDBcMFwwXDA3XDBcMFwwQm9uaXRhQlBNQ29tbXVuaXR5LmFwcC9Db250ZW50cy9QSwECXDBcMBRcMFwwCAhcMCo5fUgKud9cIocDXDBcMHYJXDBcMCpcMFwwXDBcMFwwXDBcMAFcMFwwXDBcMFwwd1wwXDBcMEJvbml0YUJQTUNvbW11bml0eS5hcHAvQ29udGVudHMvSW5mby5wbGlzdFBLAQJcMFwwFFwwXDAICFwwq26bSFwwXDBcMFwwAlwwXDBcMFwwXDBcMFwwJlwwXDBcMFwwXDBcMFwwXDBcMFwwXDBcMFwwRgRcMFwwQm9uaXRhQlBNQ29tbXVuaXR5LmFwcC9Db250ZW50cy9NYWNPUy9QSwECXDBcMBRcMFwwCAhcMKtum0hcMFwwXDBcMAJcMFwwXDBcMFwwXDBcMCpcMFwwXDBcMFwwXDBcMFwwXDBcMFwwXDBcMIwEXDBcMEJvbml0YUJQTUNvbW11bml0eS5hcHAvQ29udGVudHMvUmVzb3VyY2VzL1BLAQJcMFwwFFwwXDAICFwwKjl9SOVdM35fOVwwXDDxjlwwXDBSXDBcMFwwXDBcMFwwXDBcMFwwXDBcMFwwXDDWBFwwXDBCb25pdGFCUE1Db21tdW5pdHkuYXBwL0NvbnRlbnRzL1Jlc291cmNlcy9ib25pdGFzb2Z0LWljb24tMTI4LTEyOC10cmFuc3BhcmVudC5pY25zUEsBAlwwXDAUXDBcMAgIXDAqOX1ITPtLyVYkXDBcMBBiXDBcMDhcMFwwXDBcMFwwXDBcMFwwXDBcMFwwXDBcMKU+XDBcMEJvbml0YUJQTUNvbW11bml0eS5hcHAvQ29udGVudHMvTWFjT1MvQm9uaXRhQlBNQ29tbXVuaXR5UEsBAlwwXDAUXDBcMAgIXDCubptIrM4SsTYBXDBcMPgBXDBcMDxcMFwwXDBcMFwwXDBcMAFcMFwwXDBcMFwwUWNcMFwwQm9uaXRhQlBNQ29tbXVuaXR5LmFwcC9Db250ZW50cy9NYWNPUy9Cb25pdGFCUE1Db21tdW5pdHkuaW5pUEsFBlwwXDBcMFwwCFwwCFww5wJcMFww4WRcMFwwXDBcMA==	46799	2016-05-18 19:13:06.549995	273
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 4096, true);


--
-- Name: workflow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_id_seq', 25, true);


--
-- Data for Name: workflow_postos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_postos (id, id_workflow, idator, posto, ordem_cronologica, principal, lista, idtipoprocesso, starter, avanca_processo, notif_saindoposto, notif_entrandoposto, tipodesignacao, regra_finalizacao) FROM stdin;
278	1	\N	Dados da Contratação	\N	0	F	2	\N	7	6	\N	\N	\N
280	1	\N	Processos Finalizados	9	1	L	\N	\N	\N	\N	\N	\N	\N
281	1	85	Reprovacão de Candidato	\N	0	F	2	\N	4	\N	\N	\N	\N
282	1	85	Reprovacão de Candidato ja entrevistado	\N	0	F	2	\N	4	\N	\N	\N	\N
283	1	85	Negociacão Falha	\N	0	F	2	\N	280	\N	\N	\N	\N
284	1	85	TESTE	\N	0	F	2	\N	7	\N	\N	\N	\N
285	1	85	Re Ativar Processo Seletivo para este candidato	\N	0	F	2	\N	4	\N	\N	\N	\N
286	1	85	Arquivar processo de Candidato	\N	0	F	2	\N	280	\N	\N	\N	\N
279	1	\N	Onboarding de novo membro	\N	0	F	2	\N	280	7	\N	\N	\N
273	1	3	lançar candidato	\N	0	F	3	0	3	\N	\N	\N	\N
4	1	85	roteamento	4	1	L	2	\N	\N	\N	3	\N	\N
5	1	85	entrevista presencial	5	1	L	2	\N	\N	\N	4	\N	\N
6	1	85	entrevistados	6	1	L	2	\N	\N	\N	\N	\N	\N
7	1	85	onboarding	8	1	L	2	\N	\N	\N	\N	\N	\N
275	1	\N	Encaminhar para Gestor	\N	0	F	2	\N	5	\N	\N	\N	\N
276	1	\N	Dados da Entrevista	\N	0	F	2	\N	6	\N	\N	\N	\N
277	1	\N	Encaminhar para Negociacão	\N	0	F	2	\N	8	\N	\N	\N	\N
8	1	85	negociar com consultoria	7	1	L	2	\N	\N	\N	5	\N	\N
2	1	3	cadastra retorno	2	1	L	1	1	\N	\N	\N	\N	\N
1	1	85	job description	1	1	F	1	1	2	1	\N	\N	\N
274	1	1	Classificação de Senioridade	\N	0	F	3	\N	4	\N	\N	\N	\N
3	1	2	Primeira Avaliação	3	1	L	3	\N	\N	\N	2	Assumir	\N
287	1	2	Segunda Avaliação	3	1	L	3	\N	\N	\N	\N	Assumir	\N
288	1	1	Classificação de Senioridade	\N	0	F	3	\N	\N	\N	\N	\N	\N
\.


--
-- Name: workflow_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_postos_id_seq', 288, true);


--
-- Data for Name: workflow_tramitacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_tramitacao (id, idprocesso, idworkflowposto, inicio, fim) FROM stdin;
1811	46751	1	2016-05-18 18:47:48.862065	2016-05-18 18:47:48.862065
1812	46751	2	2016-05-18 18:47:48.863699	2016-05-18 18:47:58.523252
1813	46753	3	2016-05-18 18:47:58.518124	2016-05-18 18:48:12.502682
1814	46754	287	2016-05-18 18:47:58.522301	2016-05-18 18:48:26.518188
1815	46752	4	2016-05-18 18:48:26.521968	2016-05-18 18:49:15.539318
1816	46752	5	2016-05-18 18:49:15.538258	2016-05-18 18:49:39.065872
1817	46752	6	2016-05-18 18:49:39.06481	2016-05-18 18:49:54.793456
1818	46752	8	2016-05-18 18:49:54.792078	2016-05-18 18:50:09.836087
1819	46752	7	2016-05-18 18:50:09.834672	2016-05-18 18:50:26.772679
1820	46752	280	2016-05-18 18:50:26.771607	2016-05-18 18:50:37.749401
1822	46752	280	2016-05-18 18:50:57.180273	\N
1821	46752	7	2016-05-18 18:50:37.748293	2016-05-18 18:50:57.181433
1823	46755	1	2016-05-18 18:55:07.453064	2016-05-18 18:55:07.453064
1825	46757	3	2016-05-18 18:56:44.691283	\N
1826	46758	287	2016-05-18 18:56:44.715377	\N
1827	46760	3	2016-05-18 18:57:04.576419	\N
1828	46761	287	2016-05-18 18:57:04.595002	\N
1829	46763	3	2016-05-18 18:58:04.541104	\N
1830	46764	287	2016-05-18 18:58:04.552483	\N
1831	46771	3	2016-05-18 19:05:21.772191	\N
1832	46772	287	2016-05-18 19:05:21.776015	\N
1833	46774	3	2016-05-18 19:05:39.595832	\N
1834	46775	287	2016-05-18 19:05:39.60007	\N
1835	46777	3	2016-05-18 19:06:30.869644	\N
1836	46778	287	2016-05-18 19:06:30.873358	\N
1837	46780	3	2016-05-18 19:07:03.42693	\N
1838	46781	287	2016-05-18 19:07:03.430595	\N
1839	46783	3	2016-05-18 19:08:28.095864	\N
1840	46784	287	2016-05-18 19:08:28.213926	\N
1841	46786	3	2016-05-18 19:09:59.619558	\N
1842	46787	287	2016-05-18 19:09:59.667617	\N
1843	46789	3	2016-05-18 19:10:03.115084	\N
1844	46790	287	2016-05-18 19:10:03.136311	\N
1845	46792	3	2016-05-18 19:10:46.061822	\N
1846	46793	287	2016-05-18 19:10:46.103964	\N
1824	46755	2	2016-05-18 18:55:07.47387	2016-05-18 19:10:46.119507
1847	46794	1	2016-05-18 19:11:05.341354	2016-05-18 19:11:05.341354
1848	46794	2	2016-05-18 19:11:05.349887	\N
1849	46795	1	2016-05-18 19:12:12.93199	2016-05-18 19:12:12.93199
1850	46795	2	2016-05-18 19:12:12.951841	\N
1851	46796	1	2016-05-18 19:12:23.476244	2016-05-18 19:12:23.476244
1852	46796	2	2016-05-18 19:12:23.498629	\N
1853	46797	1	2016-05-18 19:12:41.686905	2016-05-18 19:12:41.686905
1854	46797	2	2016-05-18 19:12:41.703743	\N
1855	46798	1	2016-05-18 19:12:46.257606	2016-05-18 19:12:46.257606
1857	46800	3	2016-05-18 19:13:06.571189	\N
1858	46801	287	2016-05-18 19:13:06.620996	\N
1856	46798	2	2016-05-18 19:12:46.316134	2016-05-18 19:13:06.632185
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 1858, true);


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

