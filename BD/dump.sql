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
46914	\N	1	2016-05-19 17:37:01.013726	1	Em Andamento	\N
46855	\N	1	2016-05-18 19:33:18.074628	1	Em Andamento	\N
46857	46856	3	2016-05-18 19:33:46.666966	1	Em Andamento	\N
46858	46856	3	2016-05-18 19:33:46.671848	1	Em Andamento	\N
46859	46855	2	2016-05-18 19:36:15.970327	1	\N	\N
46860	46859	3	2016-05-18 19:36:15.973345	1	Em Andamento	\N
46861	46859	3	2016-05-18 19:36:15.976451	1	Em Andamento	\N
46862	46855	2	2016-05-18 19:37:32.730361	1	\N	\N
46863	46862	3	2016-05-18 19:37:32.733636	1	Em Andamento	\N
46864	46862	3	2016-05-18 19:37:32.736846	1	Em Andamento	\N
46865	46855	2	2016-05-19 10:58:06.833294	1	\N	\N
46866	46865	3	2016-05-19 10:58:06.848373	1	Em Andamento	\N
46867	46865	3	2016-05-19 10:58:06.871346	1	Em Andamento	\N
46868	46855	2	2016-05-19 10:58:19.079411	1	\N	\N
46869	46868	3	2016-05-19 10:58:19.082459	1	Em Andamento	\N
46870	46868	3	2016-05-19 10:58:19.103703	1	Em Andamento	\N
46871	46855	2	2016-05-19 10:59:53.089376	1	\N	\N
46872	46871	3	2016-05-19 10:59:53.1558	1	Em Andamento	\N
46873	46871	3	2016-05-19 10:59:53.178082	1	Em Andamento	\N
46874	46855	2	2016-05-19 11:04:13.642483	1	\N	\N
46875	46874	3	2016-05-19 11:04:13.760586	1	Em Andamento	\N
46876	46874	3	2016-05-19 11:04:13.787346	1	Em Andamento	\N
46877	46855	2	2016-05-19 11:05:12.994887	1	\N	\N
46878	46877	3	2016-05-19 11:05:13.047655	1	Em Andamento	\N
46879	46877	3	2016-05-19 11:05:13.074117	1	Em Andamento	\N
46880	46855	2	2016-05-19 11:06:40.431247	1	\N	\N
46881	46880	3	2016-05-19 11:06:40.435809	1	Em Andamento	\N
46882	46855	2	2016-05-19 11:07:29.505788	1	\N	\N
46883	46882	3	2016-05-19 11:07:29.509675	1	Em Andamento	\N
46884	46855	2	2016-05-19 11:53:17.441458	1	\N	\N
46885	46884	3	2016-05-19 11:53:17.444551	1	Em Andamento	\N
46886	46855	2	2016-05-19 11:56:00.781174	1	\N	\N
46887	46886	3	2016-05-19 11:56:00.784238	1	Em Andamento	\N
46888	46855	2	2016-05-19 11:57:57.741566	1	\N	\N
46889	46888	3	2016-05-19 11:57:57.744613	1	Em Andamento	\N
46890	46888	3	2016-05-19 11:57:57.787525	1	Em Andamento	\N
46891	46855	2	2016-05-19 11:58:11.695659	1	\N	\N
46892	46891	3	2016-05-19 11:58:11.698618	1	Em Andamento	\N
46893	46891	3	2016-05-19 11:58:11.724584	1	Em Andamento	\N
46894	46855	2	2016-05-19 11:58:58.798619	1	\N	\N
46895	46894	3	2016-05-19 11:58:58.801725	1	Em Andamento	\N
46896	46894	3	2016-05-19 11:58:58.853639	1	Em Andamento	\N
46947	\N	1	2016-05-19 18:00:10.994619	1	Em Andamento	\N
46915	\N	1	2016-05-19 17:38:48.298259	1	Em Andamento	\N
46856	46855	2	2016-05-18 19:33:46.66254	1	Em Andamento	\N
46897	\N	1	2016-05-19 16:23:03.177696	1	Em Andamento	\N
46898	\N	1	2016-05-19 16:23:20.315617	1	Em Andamento	\N
46931	\N	1	2016-05-19 17:49:22.806263	1	Em Andamento	\N
46899	\N	1	2016-05-19 16:24:44.650059	1	Em Andamento	\N
46916	\N	1	2016-05-19 17:39:25.731452	1	Em Andamento	\N
46900	\N	1	2016-05-19 16:24:53.768863	1	Em Andamento	\N
46901	\N	1	2016-05-19 16:27:03.517825	1	Em Andamento	\N
46902	\N	1	2016-05-19 16:37:39.509676	1	Em Andamento	\N
46903	\N	1	2016-05-19 16:42:25.667307	1	\N	\N
46904	\N	1	2016-05-19 16:54:59.190271	1	Em Andamento	\N
46905	\N	1	2016-05-19 16:55:53.345956	1	Em Andamento	\N
46917	\N	1	2016-05-19 17:40:20.540199	1	Em Andamento	\N
46906	\N	1	2016-05-19 17:22:13.526082	1	Em Andamento	\N
46907	\N	1	2016-05-19 17:22:38.594658	1	Em Andamento	\N
46908	\N	1	2016-05-19 17:24:02.679956	1	\N	\N
46909	\N	1	2016-05-19 17:25:03.023535	1	\N	\N
46910	\N	1	2016-05-19 17:25:04.549975	1	\N	\N
46911	\N	1	2016-05-19 17:27:48.419571	1	\N	\N
46941	\N	1	2016-05-19 17:58:02.810163	1	Em Andamento	\N
46912	\N	1	2016-05-19 17:28:19.846368	1	Em Andamento	\N
46918	\N	1	2016-05-19 17:41:16.420236	1	Em Andamento	\N
46913	\N	1	2016-05-19 17:28:38.095626	1	Em Andamento	\N
46932	\N	1	2016-05-19 17:50:30.64344	1	Em Andamento	\N
46919	\N	1	2016-05-19 17:41:39.018218	1	Em Andamento	\N
46920	\N	1	2016-05-19 17:41:43.458292	1	Em Andamento	\N
46933	\N	1	2016-05-19 17:51:44.790712	1	Em Andamento	\N
46921	\N	1	2016-05-19 17:42:06.138192	1	Em Andamento	\N
46922	\N	1	2016-05-19 17:42:28.2627	1	Em Andamento	\N
46923	\N	1	2016-05-19 17:43:16.731858	1	Em Andamento	\N
46934	\N	1	2016-05-19 17:53:42.431316	1	Em Andamento	\N
46924	\N	1	2016-05-19 17:43:43.636936	1	Em Andamento	\N
46925	\N	1	2016-05-19 17:44:34.922885	1	Em Andamento	\N
46942	\N	1	2016-05-19 17:58:14.000618	1	Em Andamento	\N
46926	\N	1	2016-05-19 17:45:02.769553	1	Em Andamento	\N
46935	\N	1	2016-05-19 17:54:37.900835	1	Em Andamento	\N
46927	\N	1	2016-05-19 17:45:53.383159	1	Em Andamento	\N
46928	\N	1	2016-05-19 17:46:46.576938	1	Em Andamento	\N
46929	\N	1	2016-05-19 17:47:18.026044	1	Em Andamento	\N
46936	\N	1	2016-05-19 17:55:04.504507	1	Em Andamento	\N
46930	\N	1	2016-05-19 17:48:45.084273	1	Em Andamento	\N
46951	\N	1	2016-05-19 18:15:00.404958	1	Em Andamento	\N
46937	\N	1	2016-05-19 17:55:52.225979	1	Em Andamento	\N
46943	\N	1	2016-05-19 17:58:58.348666	1	Em Andamento	\N
46938	\N	1	2016-05-19 17:56:10.586779	1	Em Andamento	\N
46939	\N	1	2016-05-19 17:56:40.04963	1	Em Andamento	\N
46948	\N	1	2016-05-19 18:08:26.195262	1	Em Andamento	\N
46940	\N	1	2016-05-19 17:57:01.584952	1	Em Andamento	\N
46944	\N	1	2016-05-19 17:59:31.969539	1	Em Andamento	\N
46945	\N	1	2016-05-19 17:59:55.862661	1	Em Andamento	\N
46946	\N	1	2016-05-19 17:59:59.062662	1	Em Andamento	\N
46949	\N	1	2016-05-19 18:12:20.426181	1	Em Andamento	\N
46952	\N	1	2016-05-19 18:15:20.90559	1	Em Andamento	\N
46950	\N	1	2016-05-19 18:12:35.779878	1	Em Andamento	\N
46955	\N	1	2016-05-19 18:18:24.558485	1	Em Andamento	\N
46954	\N	1	2016-05-19 18:18:08.599943	1	Em Andamento	\N
46953	\N	1	2016-05-19 18:16:57.033617	1	Em Andamento	\N
46956	\N	1	2016-05-19 18:18:40.020418	1	Em Andamento	\N
46957	\N	1	2016-05-19 18:19:27.049523	1	Em Andamento	\N
46958	\N	1	2016-05-19 18:20:31.474988	1	Em Andamento	\N
46959	\N	1	2016-05-19 18:21:48.576878	1	Em Andamento	\N
46960	\N	1	2016-05-19 18:22:16.388408	1	Em Andamento	\N
46961	\N	1	2016-05-19 18:22:23.059605	1	Em Andamento	\N
46962	\N	1	2016-05-19 18:22:57.735264	1	Em Andamento	\N
46963	\N	1	2016-05-19 18:23:13.37071	1	Em Andamento	\N
46964	\N	1	2016-05-19 18:23:57.841062	1	Em Andamento	\N
46965	\N	1	2016-05-19 18:24:47.033182	1	Em Andamento	\N
46966	\N	1	2016-05-19 18:24:57.001728	1	Em Andamento	\N
46967	\N	1	2016-05-19 18:25:28.185009	1	Em Andamento	\N
46968	\N	1	2016-05-19 18:25:39.28903	1	Em Andamento	\N
46969	\N	1	2016-05-19 18:25:56.718312	1	Em Andamento	\N
47013	\N	1	2016-05-19 18:58:38.737053	1	Em Andamento	\N
46970	\N	1	2016-05-19 18:26:07.480298	1	Em Andamento	\N
46971	\N	1	2016-05-19 18:26:16.328996	1	Em Andamento	\N
46972	\N	1	2016-05-19 18:26:40.901	1	Em Andamento	\N
46973	\N	1	2016-05-19 18:26:57.247647	1	\N	\N
47014	\N	1	2016-05-19 19:01:56.501044	1	Em Andamento	\N
46974	\N	1	2016-05-19 18:27:18.829217	1	Em Andamento	\N
46975	\N	1	2016-05-19 18:28:54.43292	1	Em Andamento	\N
46976	\N	1	2016-05-19 18:29:17.672829	1	Em Andamento	\N
47015	\N	1	2016-05-19 19:02:28.511895	1	Em Andamento	\N
46977	\N	1	2016-05-19 18:29:23.399926	1	Em Andamento	\N
46978	\N	1	2016-05-19 18:29:35.783464	1	Em Andamento	\N
46979	\N	1	2016-05-19 18:30:36.445864	1	\N	\N
46980	\N	1	2016-05-19 18:30:59.521821	1	\N	\N
46981	\N	1	2016-05-19 18:31:53.379275	1	Em Andamento	\N
47016	\N	1	2016-05-19 19:03:15.296528	1	Em Andamento	\N
46982	\N	1	2016-05-19 18:32:02.365009	1	Em Andamento	\N
46983	\N	1	2016-05-19 18:33:42.932339	1	Em Andamento	\N
46984	\N	1	2016-05-19 18:36:29.694186	1	\N	\N
46985	\N	1	2016-05-19 18:36:41.941994	1	\N	\N
46986	\N	1	2016-05-19 18:40:39.353242	1	Em Andamento	\N
47017	\N	1	2016-05-19 19:03:28.227696	1	Em Andamento	\N
46987	\N	1	2016-05-19 18:40:56.220461	1	Em Andamento	\N
46988	\N	1	2016-05-19 18:41:23.516567	1	Em Andamento	\N
46989	\N	1	2016-05-19 18:41:45.88595	1	Em Andamento	\N
47018	\N	1	2016-05-19 19:03:49.07074	1	Em Andamento	\N
46990	\N	1	2016-05-19 18:42:48.249337	1	Em Andamento	\N
46991	\N	1	2016-05-19 18:43:16.709149	1	Em Andamento	\N
46992	\N	1	2016-05-19 18:43:25.227291	1	Em Andamento	\N
47019	\N	1	2016-05-19 19:04:02.402758	1	Em Andamento	\N
46993	\N	1	2016-05-19 18:43:46.700909	1	Em Andamento	\N
47020	\N	1	2016-05-19 19:04:59.224652	1	\N	\N
46994	\N	1	2016-05-19 18:44:43.556428	1	Em Andamento	\N
47021	\N	1	2016-05-19 19:05:25.873163	1	\N	\N
46995	\N	1	2016-05-19 18:44:52.230964	1	Em Andamento	\N
46996	\N	1	2016-05-19 18:46:13.650734	1	Em Andamento	\N
46997	\N	1	2016-05-19 18:46:30.097601	1	Em Andamento	\N
47022	\N	1	2016-05-19 19:05:46.511499	1	Em Andamento	\N
46998	\N	1	2016-05-19 18:47:10.735748	1	Em Andamento	\N
46999	\N	1	2016-05-19 18:48:04.940334	1	Em Andamento	\N
47000	\N	1	2016-05-19 18:48:23.692819	1	Em Andamento	\N
47023	\N	1	2016-05-19 19:06:19.376405	1	Em Andamento	\N
47001	\N	1	2016-05-19 18:48:31.314872	1	Em Andamento	\N
47002	\N	1	2016-05-19 18:48:41.517681	1	Em Andamento	\N
47003	\N	1	2016-05-19 18:49:41.847503	1	Em Andamento	\N
47024	\N	1	2016-05-19 19:07:16.72334	1	Em Andamento	\N
47004	\N	1	2016-05-19 18:50:07.722308	1	Em Andamento	\N
47005	\N	1	2016-05-19 18:50:57.817068	1	Em Andamento	\N
47006	\N	1	2016-05-19 18:51:45.476239	1	Em Andamento	\N
47007	\N	1	2016-05-19 18:52:04.138972	1	\N	\N
47025	\N	1	2016-05-19 19:07:37.731612	1	Em Andamento	\N
47008	\N	1	2016-05-19 18:52:46.568914	1	Em Andamento	\N
47009	\N	1	2016-05-19 18:53:42.37276	1	Em Andamento	\N
47010	\N	1	2016-05-19 18:54:43.661019	1	Em Andamento	\N
47011	\N	1	2016-05-19 18:55:43.46849	1	\N	\N
47012	\N	1	2016-05-19 18:58:28.428072	1	\N	\N
47026	\N	1	2016-05-19 19:08:18.155814	1	Em Andamento	\N
47027	\N	1	2016-05-19 19:08:36.804607	1	Em Andamento	\N
47028	\N	1	2016-05-19 19:09:00.098618	1	Em Andamento	\N
47029	\N	1	2016-05-19 19:09:11.569125	1	Em Andamento	\N
47030	\N	1	2016-05-19 19:09:32.425911	1	Em Andamento	\N
47031	\N	1	2016-05-19 19:10:06.013798	1	Em Andamento	\N
47032	\N	1	2016-05-19 19:10:35.407371	1	Em Andamento	\N
47033	\N	1	2016-05-19 19:10:43.423513	1	Em Andamento	\N
47034	\N	1	2016-05-19 19:10:56.07296	1	Em Andamento	\N
47035	\N	1	2016-05-19 19:11:23.173909	1	Em Andamento	\N
47036	\N	1	2016-05-19 19:12:13.138523	1	Em Andamento	\N
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 47036, true);


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
4188	13	Frontend	46855	2016-05-18 19:33:18.075854	1
4189	174	SEGUE ENUNCIADO....	46855	2016-05-18 19:33:18.076445	1
4190	1	job description.. angular...	46855	2016-05-18 19:33:18.076817	1
4191	11	bruno siqueira	46856	2016-05-18 19:33:46.663523	273
4192	12	php	46856	2016-05-18 19:33:46.664144	273
4193	2	hub	46856	2016-05-18 19:33:46.664568	273
4194	166	mazza	46856	2016-05-18 19:33:46.66497	273
4195	3	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	46856	2016-05-18 19:33:46.665412	273
4196	180	PL	46858	2016-05-18 19:34:01.997399	288
4197	181	PELO MEU ACHISMO	46858	2016-05-18 19:34:01.998626	288
4200	11	novo candidato 	46859	2016-05-18 19:36:15.971212	273
4201	12	1	46859	2016-05-18 19:36:15.97182	273
4202	2	2	46859	2016-05-18 19:36:15.97221	273
4203	166	3	46859	2016-05-18 19:36:15.9726	273
4204	11	aaaaa	46862	2016-05-18 19:37:32.731135	273
4205	12		46862	2016-05-18 19:37:32.731862	273
4206	2		46862	2016-05-18 19:37:32.732479	273
4207	166		46862	2016-05-18 19:37:32.732893	273
4208	-1	4	46863	2016-05-19 10:52:15.948453	3
4209	-1	4	46860	2016-05-19 10:52:20.08822	3
4210	-1	4	46861	2016-05-19 10:52:22.789283	287
4211	11	auto assumi	46865	2016-05-19 10:58:06.845044	273
4212	12		46865	2016-05-19 10:58:06.846014	273
4213	2		46865	2016-05-19 10:58:06.846518	273
4214	166		46865	2016-05-19 10:58:06.847016	273
4215	11	auto asssumi 2	46868	2016-05-19 10:58:19.080189	273
4216	12		46868	2016-05-19 10:58:19.080777	273
4217	2		46868	2016-05-19 10:58:19.08118	273
4218	166		46868	2016-05-19 10:58:19.081582	273
4219	11	auto asssumi 2	46871	2016-05-19 10:59:53.128399	273
4220	12		46871	2016-05-19 10:59:53.153489	273
4221	2		46871	2016-05-19 10:59:53.154093	273
4222	166		46871	2016-05-19 10:59:53.15459	273
4223	11	auto asssumi 2	46874	2016-05-19 11:04:13.757935	273
4224	12		46874	2016-05-19 11:04:13.758682	273
4225	2		46874	2016-05-19 11:04:13.75912	273
4226	166		46874	2016-05-19 11:04:13.75955	273
4227	11	auto asssumi 2	46877	2016-05-19 11:05:13.028807	273
4228	12		46877	2016-05-19 11:05:13.045804	273
4229	2		46877	2016-05-19 11:05:13.046312	273
4230	166		46877	2016-05-19 11:05:13.046717	273
4231	11	auto asssumi 2	46880	2016-05-19 11:06:40.432307	273
4232	12		46880	2016-05-19 11:06:40.43299	273
4233	2		46880	2016-05-19 11:06:40.433449	273
4234	166		46880	2016-05-19 11:06:40.43439	273
4235	11	auto asssumi 2	46882	2016-05-19 11:07:29.506815	273
4236	12		46882	2016-05-19 11:07:29.507441	273
4237	2		46882	2016-05-19 11:07:29.508058	273
4238	166		46882	2016-05-19 11:07:29.508473	273
4239	-1	7	46883	2016-05-19 11:07:29.558825	3
4240	11	auto asssumi 2	46884	2016-05-19 11:53:17.442337	273
4241	12		46884	2016-05-19 11:53:17.442968	273
4242	2		46884	2016-05-19 11:53:17.443345	273
4243	166		46884	2016-05-19 11:53:17.443716	273
4244	-1	6	46885	2016-05-19 11:53:17.466751	3
4245	11	auto asssumi 2	46886	2016-05-19 11:56:00.782029	273
4246	12		46886	2016-05-19 11:56:00.782675	273
4247	2		46886	2016-05-19 11:56:00.783061	273
4248	166		46886	2016-05-19 11:56:00.783456	273
4249	-1	5	46887	2016-05-19 11:56:00.806496	3
4250	11	auto asssumi 2	46888	2016-05-19 11:57:57.742362	273
4251	12		46888	2016-05-19 11:57:57.743028	273
4252	2		46888	2016-05-19 11:57:57.743447	273
4253	166		46888	2016-05-19 11:57:57.743804	273
4254	-1	4	46889	2016-05-19 11:57:57.767072	3
4255	-1	7	46890	2016-05-19 11:57:57.811838	287
4256	11	zzazaz	46891	2016-05-19 11:58:11.696413	273
4257	12		46891	2016-05-19 11:58:11.696986	273
4258	2		46891	2016-05-19 11:58:11.697387	273
4259	166		46891	2016-05-19 11:58:11.697834	273
4260	-1	6	46892	2016-05-19 11:58:11.721412	3
4261	-1	4	46893	2016-05-19 11:58:11.747248	287
4262	11	bnn	46894	2016-05-19 11:58:58.799377	273
4263	12		46894	2016-05-19 11:58:58.80009	273
4264	2		46894	2016-05-19 11:58:58.800541	273
4265	166		46894	2016-05-19 11:58:58.800959	273
4266	-1	6	46895	2016-05-19 11:58:58.850587	3
4267	-1	7	46896	2016-05-19 11:58:58.876953	287
4268	4	jr	46857	2016-05-19 11:59:19.410039	274
4269	10	ddd	46857	2016-05-19 11:59:19.411008	274
4270	5	dsass	46856	2016-05-19 11:59:31.347292	275
4271	6	dsdasda	46856	2016-05-19 11:59:36.723207	276
4272	7	dsadasd	46856	2016-05-19 11:59:42.124241	277
4273	169	dsadasd	46856	2016-05-19 11:59:47.609416	283
4274	13	dsa	46897	2016-05-19 16:23:03.193781	1
4275	174	dsa	46897	2016-05-19 16:23:03.194332	1
4276	1	dsa	46897	2016-05-19 16:23:03.194793	1
4277	13	dsa	46898	2016-05-19 16:23:20.316428	1
4278	174	dsa	46898	2016-05-19 16:23:20.317024	1
4279	1	dsa	46898	2016-05-19 16:23:20.317436	1
4280	13	dsa	46899	2016-05-19 16:24:44.651022	1
4281	174	dsa	46899	2016-05-19 16:24:44.651458	1
4282	1	dsa	46899	2016-05-19 16:24:44.651806	1
4283	13	dsa	46900	2016-05-19 16:24:53.769709	1
4284	174	da	46900	2016-05-19 16:24:53.770329	1
4285	1	dq	46900	2016-05-19 16:24:53.770712	1
4286	13	d1	46901	2016-05-19 16:27:03.518611	1
4287	174	d1	46901	2016-05-19 16:27:03.519216	1
4288	1	d23	46901	2016-05-19 16:27:03.519616	1
4289	13	dsaasd	46902	2016-05-19 16:37:39.510556	1
4290	174	d	46902	2016-05-19 16:37:39.511086	1
4291	1	sadas	46902	2016-05-19 16:37:39.511494	1
4292	13	dsaasd	46903	2016-05-19 16:42:25.668208	1
4293	174	d	46903	2016-05-19 16:42:25.668683	1
4294	1	sadas	46903	2016-05-19 16:42:25.669091	1
4295	13	dsaasd	46904	2016-05-19 16:54:59.191632	1
4296	174	d	46904	2016-05-19 16:54:59.192232	1
4297	1	sadas	46904	2016-05-19 16:54:59.192612	1
4298	13	dsaasd	46905	2016-05-19 16:55:53.346869	1
4299	174	d	46905	2016-05-19 16:55:53.347547	1
4300	1	sadas	46905	2016-05-19 16:55:53.347934	1
4301	13	dsaasd	46906	2016-05-19 17:22:13.527034	1
4302	174	d	46906	2016-05-19 17:22:13.527643	1
4303	1	sadas	46906	2016-05-19 17:22:13.528012	1
4304	13	dsaasd	46907	2016-05-19 17:22:38.595468	1
4305	174	d	46907	2016-05-19 17:22:38.595921	1
4306	1	sadas	46907	2016-05-19 17:22:38.596307	1
4307	13	dsaasd	46908	2016-05-19 17:24:02.680768	1
4308	174	d	46908	2016-05-19 17:24:02.681317	1
4309	1	sadas	46908	2016-05-19 17:24:02.699463	1
4310	13	dsaasd	46909	2016-05-19 17:25:03.024483	1
4311	174	d	46909	2016-05-19 17:25:03.024969	1
4312	1	sadas	46909	2016-05-19 17:25:03.025324	1
4313	13	dsaasd	46910	2016-05-19 17:25:04.55087	1
4314	174	d	46910	2016-05-19 17:25:04.551596	1
4315	1	sadas	46910	2016-05-19 17:25:04.551992	1
4316	13	dsaasd	46911	2016-05-19 17:27:48.420431	1
4317	174	d	46911	2016-05-19 17:27:48.420928	1
4318	1	sadas	46911	2016-05-19 17:27:48.421281	1
4319	13	dsaasd	46912	2016-05-19 17:28:19.847267	1
4320	174	d	46912	2016-05-19 17:28:19.847915	1
4321	1	sadas	46912	2016-05-19 17:28:19.848334	1
4322	13	dsaasd	46913	2016-05-19 17:28:38.096619	1
4323	174	d	46913	2016-05-19 17:28:38.097111	1
4324	1	sadas	46913	2016-05-19 17:28:38.097534	1
4325	13	dsaasd	46914	2016-05-19 17:37:01.014661	1
4326	174	d	46914	2016-05-19 17:37:01.01515	1
4327	1	sadas	46914	2016-05-19 17:37:01.015588	1
4328	13	dsaasd	46915	2016-05-19 17:38:48.299124	1
4329	174	d	46915	2016-05-19 17:38:48.299758	1
4330	1	sadas	46915	2016-05-19 17:38:48.300158	1
4331	13	dsaasd	46916	2016-05-19 17:39:25.732402	1
4332	174	d	46916	2016-05-19 17:39:25.732955	1
4333	1	sadas	46916	2016-05-19 17:39:25.73333	1
4334	13	dsaasd	46917	2016-05-19 17:40:20.541021	1
4335	174	d	46917	2016-05-19 17:40:20.541705	1
4336	1	sadas	46917	2016-05-19 17:40:20.542099	1
4337	13	dsaasd	46918	2016-05-19 17:41:16.421057	1
4338	174	d	46918	2016-05-19 17:41:16.421602	1
4339	1	sadas	46918	2016-05-19 17:41:16.421994	1
4340	13	dsaasd	46919	2016-05-19 17:41:39.019018	1
4341	174	d	46919	2016-05-19 17:41:39.019543	1
4342	1	sadas	46919	2016-05-19 17:41:39.019928	1
4343	13	dsaasd	46920	2016-05-19 17:41:43.459154	1
4344	174	d	46920	2016-05-19 17:41:43.459714	1
4345	1	sadas	46920	2016-05-19 17:41:43.460043	1
4346	13	dsaasd	46921	2016-05-19 17:42:06.139129	1
4347	174	d	46921	2016-05-19 17:42:06.139668	1
4348	1	sadas	46921	2016-05-19 17:42:06.140035	1
4349	13	dsaasd	46922	2016-05-19 17:42:28.310257	1
4350	174	d	46922	2016-05-19 17:42:28.381597	1
4351	1	sadas	46922	2016-05-19 17:42:28.493427	1
4352	13	dsaasd	46923	2016-05-19 17:43:16.732755	1
4353	174	d	46923	2016-05-19 17:43:16.733457	1
4354	1	sadas	46923	2016-05-19 17:43:16.733881	1
4355	13	dsaasd	46924	2016-05-19 17:43:43.637908	1
4356	174	d	46924	2016-05-19 17:43:43.638597	1
4357	1	sadas	46924	2016-05-19 17:43:43.638972	1
4358	13	dsaasd	46925	2016-05-19 17:44:34.923736	1
4359	174	d	46925	2016-05-19 17:44:34.9245	1
4360	1	sadas	46925	2016-05-19 17:44:34.924935	1
4361	13	dsaasd	46926	2016-05-19 17:45:02.770421	1
4362	174	d	46926	2016-05-19 17:45:02.771003	1
4363	1	sadas	46926	2016-05-19 17:45:02.771409	1
4364	13	dsaasd	46927	2016-05-19 17:45:53.384108	1
4365	174	d	46927	2016-05-19 17:45:53.384618	1
4366	1	sadas	46927	2016-05-19 17:45:53.384996	1
4367	13	dsaasd	46928	2016-05-19 17:46:46.5778	1
4368	174	d	46928	2016-05-19 17:46:46.578494	1
4369	1	sadas	46928	2016-05-19 17:46:46.57891	1
4370	13	dsaasd	46929	2016-05-19 17:47:18.02701	1
4371	174	d	46929	2016-05-19 17:47:18.027592	1
4372	1	sadas	46929	2016-05-19 17:47:18.028036	1
4373	13	dsaasd	46930	2016-05-19 17:48:45.085107	1
4374	174	d	46930	2016-05-19 17:48:45.085685	1
4375	1	sadas	46930	2016-05-19 17:48:45.086061	1
4376	13	dsaasd	46931	2016-05-19 17:49:22.807135	1
4377	174	d	46931	2016-05-19 17:49:22.807769	1
4378	1	sadas	46931	2016-05-19 17:49:22.808179	1
4379	13	dsaasd	46932	2016-05-19 17:50:30.644292	1
4380	174	d	46932	2016-05-19 17:50:30.644889	1
4381	1	sadas	46932	2016-05-19 17:50:30.645286	1
4382	13	dsaasd	46933	2016-05-19 17:51:44.791515	1
4383	174	d	46933	2016-05-19 17:51:44.791988	1
4384	1	sadas	46933	2016-05-19 17:51:44.792364	1
4385	13	dsaasd	46934	2016-05-19 17:53:42.432544	1
4386	174	d	46934	2016-05-19 17:53:42.433198	1
4387	1	sadas	46934	2016-05-19 17:53:42.450179	1
4388	13	dsaasd	46935	2016-05-19 17:54:37.901696	1
4389	174	d	46935	2016-05-19 17:54:37.90227	1
4390	1	sadas	46935	2016-05-19 17:54:37.902684	1
4391	13	dsaasd	46936	2016-05-19 17:55:04.505349	1
4392	174	d	46936	2016-05-19 17:55:04.505851	1
4393	1	sadas	46936	2016-05-19 17:55:04.506216	1
4394	13	dsaasd	46937	2016-05-19 17:55:52.226771	1
4395	174	d	46937	2016-05-19 17:55:52.227391	1
4396	1	sadas	46937	2016-05-19 17:55:52.227759	1
4397	13	dsaasd	46938	2016-05-19 17:56:10.587576	1
4398	174	d	46938	2016-05-19 17:56:10.588347	1
4399	1	sadas	46938	2016-05-19 17:56:10.588728	1
4400	13	dsaasd	46939	2016-05-19 17:56:40.050428	1
4401	174	d	46939	2016-05-19 17:56:40.050903	1
4402	1	sadas	46939	2016-05-19 17:56:40.05126	1
4403	13	dsaasd	46940	2016-05-19 17:57:01.585818	1
4404	174	d	46940	2016-05-19 17:57:01.58654	1
4405	1	sadas	46940	2016-05-19 17:57:01.586936	1
4406	13	dsaasd	46941	2016-05-19 17:58:02.811039	1
4407	174	d	46941	2016-05-19 17:58:02.81186	1
4408	1	sadas	46941	2016-05-19 17:58:02.812263	1
4409	13	dsaasd	46942	2016-05-19 17:58:14.00155	1
4410	174	d	46942	2016-05-19 17:58:14.002139	1
4411	1	sadas	46942	2016-05-19 17:58:14.00251	1
4412	13	dsaasd	46943	2016-05-19 17:58:58.349524	1
4413	174	d	46943	2016-05-19 17:58:58.349995	1
4414	1	sadas	46943	2016-05-19 17:58:58.350396	1
4415	13	dsaasd	46944	2016-05-19 17:59:31.970336	1
4416	174	d	46944	2016-05-19 17:59:31.971026	1
4417	1	sadas	46944	2016-05-19 17:59:31.971479	1
4418	13	dsaasd	46945	2016-05-19 17:59:55.86348	1
4419	174	d	46945	2016-05-19 17:59:55.864179	1
4420	1	sadas	46945	2016-05-19 17:59:55.864593	1
4421	13	dsaasd	46946	2016-05-19 17:59:59.063582	1
4422	174	d	46946	2016-05-19 17:59:59.064189	1
4423	1	sadas	46946	2016-05-19 17:59:59.064587	1
4424	13	dsaasd	46947	2016-05-19 18:00:10.995536	1
4425	174	d	46947	2016-05-19 18:00:10.995993	1
4426	1	sadas	46947	2016-05-19 18:00:10.996331	1
4427	13	dsaasd	46948	2016-05-19 18:08:26.196085	1
4428	174	d	46948	2016-05-19 18:08:26.196718	1
4429	1	sadas	46948	2016-05-19 18:08:26.19713	1
4430	13	dsaasd	46949	2016-05-19 18:12:20.427063	1
4431	174	d	46949	2016-05-19 18:12:20.427571	1
4432	1	sadas	46949	2016-05-19 18:12:20.427932	1
4433	13	dsaasd	46950	2016-05-19 18:12:35.780694	1
4434	174	d	46950	2016-05-19 18:12:35.781348	1
4435	1	sadas	46950	2016-05-19 18:12:35.781775	1
4436	13	dsaasd	46951	2016-05-19 18:15:00.405878	1
4437	174	d	46951	2016-05-19 18:15:00.4064	1
4438	1	sadas	46951	2016-05-19 18:15:00.424665	1
4439	13	dsaasd	46952	2016-05-19 18:15:20.90656	1
4440	174	d	46952	2016-05-19 18:15:20.90706	1
4441	1	sadas	46952	2016-05-19 18:15:20.907429	1
4442	13	dsaasd	46953	2016-05-19 18:16:57.03434	1
4443	174	d	46953	2016-05-19 18:16:57.034977	1
4444	1	sadas	46953	2016-05-19 18:16:57.035363	1
4445	13	dsaasd	46954	2016-05-19 18:18:08.600761	1
4446	174	d	46954	2016-05-19 18:18:08.601325	1
4447	1	sadas	46954	2016-05-19 18:18:08.601728	1
4448	13	dsaasd	46955	2016-05-19 18:18:24.559395	1
4449	174	d	46955	2016-05-19 18:18:24.559939	1
4450	1	sadas	46955	2016-05-19 18:18:24.560344	1
4451	13	dsaasd	46956	2016-05-19 18:18:40.021377	1
4452	174	d	46956	2016-05-19 18:18:40.021981	1
4453	1	sadas	46956	2016-05-19 18:18:40.022387	1
4454	13	dsaasd	46957	2016-05-19 18:19:27.050336	1
4455	174	d	46957	2016-05-19 18:19:27.050862	1
4456	1	sadas	46957	2016-05-19 18:19:27.051225	1
4457	13	dsaasd	46958	2016-05-19 18:20:31.475848	1
4458	174	d	46958	2016-05-19 18:20:31.476312	1
4459	1	sadas	46958	2016-05-19 18:20:31.476689	1
4460	13	dsaasd	46959	2016-05-19 18:21:48.577943	1
4461	174	d	46959	2016-05-19 18:21:48.578433	1
4462	1	sadas	46959	2016-05-19 18:21:48.578787	1
4463	13	dsaasd	46960	2016-05-19 18:22:16.389242	1
4464	174	d	46960	2016-05-19 18:22:16.389839	1
4465	1	sadas	46960	2016-05-19 18:22:16.39029	1
4466	13	dsaasd	46961	2016-05-19 18:22:23.060462	1
4467	174	d	46961	2016-05-19 18:22:23.060928	1
4468	1	sadas	46961	2016-05-19 18:22:23.061286	1
4469	13	dsaasd	46962	2016-05-19 18:22:57.73615	1
4470	174	d	46962	2016-05-19 18:22:57.73669	1
4471	1	sadas	46962	2016-05-19 18:22:57.737009	1
4472	13	dsaasd	46963	2016-05-19 18:23:13.389975	1
4473	174	d	46963	2016-05-19 18:23:13.405074	1
4474	1	sadas	46963	2016-05-19 18:23:13.405537	1
4475	13	dsaasd	46964	2016-05-19 18:23:57.842104	1
4476	174	d	46964	2016-05-19 18:23:57.842773	1
4477	1	sadas	46964	2016-05-19 18:23:57.843217	1
4478	13	dsaasd	46965	2016-05-19 18:24:47.034056	1
4479	174	d	46965	2016-05-19 18:24:47.034557	1
4480	1	sadas	46965	2016-05-19 18:24:47.034961	1
4481	13	dsaasd	46966	2016-05-19 18:24:57.002556	1
4482	174	d	46966	2016-05-19 18:24:57.003041	1
4483	1	sadas	46966	2016-05-19 18:24:57.003443	1
4484	13	dsaasd	46967	2016-05-19 18:25:28.186009	1
4485	174	d	46967	2016-05-19 18:25:28.186645	1
4486	1	sadas	46967	2016-05-19 18:25:28.187026	1
4487	13	dsaasd	46968	2016-05-19 18:25:39.290106	1
4488	174	d	46968	2016-05-19 18:25:39.290566	1
4489	1	sadas	46968	2016-05-19 18:25:39.290942	1
4490	13	dsaasd	46969	2016-05-19 18:25:56.719348	1
4491	174	d	46969	2016-05-19 18:25:56.719991	1
4492	1	sadas	46969	2016-05-19 18:25:56.720395	1
4493	13	dsaasd	46970	2016-05-19 18:26:07.48112	1
4494	174	d	46970	2016-05-19 18:26:07.481738	1
4495	1	sadas	46970	2016-05-19 18:26:07.48214	1
4496	13	dsaasd	46971	2016-05-19 18:26:16.330174	1
4497	174	d	46971	2016-05-19 18:26:16.330694	1
4498	1	sadas	46971	2016-05-19 18:26:16.331122	1
4499	13	dsaasd	46972	2016-05-19 18:26:40.901922	1
4500	174	d	46972	2016-05-19 18:26:40.902406	1
4501	1	sadas	46972	2016-05-19 18:26:40.902783	1
4502	13	dsaasd	46973	2016-05-19 18:26:57.248617	1
4503	174	d	46973	2016-05-19 18:26:57.249216	1
4504	1	sadas	46973	2016-05-19 18:26:57.249574	1
4505	13	dsaasd	46974	2016-05-19 18:27:18.830125	1
4506	174	d	46974	2016-05-19 18:27:18.830669	1
4507	1	sadas	46974	2016-05-19 18:27:18.83104	1
4508	13	dsaasd	46975	2016-05-19 18:28:54.433831	1
4509	174	d	46975	2016-05-19 18:28:54.434459	1
4510	1	sadas	46975	2016-05-19 18:28:54.434911	1
4511	13	dsaasd	46976	2016-05-19 18:29:17.673781	1
4512	174	d	46976	2016-05-19 18:29:17.674358	1
4513	1	sadas	46976	2016-05-19 18:29:17.674779	1
4514	13	dsaasd	46977	2016-05-19 18:29:23.400759	1
4515	174	d	46977	2016-05-19 18:29:23.40151	1
4516	1	sadas	46977	2016-05-19 18:29:23.40191	1
4517	13	dsaasd	46978	2016-05-19 18:29:35.78447	1
4518	174	d	46978	2016-05-19 18:29:35.785185	1
4519	1	sadas	46978	2016-05-19 18:29:35.785611	1
4520	13	dsaasd	46979	2016-05-19 18:30:36.446698	1
4521	174	d	46979	2016-05-19 18:30:36.447164	1
4522	1	sadas	46979	2016-05-19 18:30:36.447522	1
4523	13	dsaasd	46980	2016-05-19 18:30:59.522721	1
4524	174	d	46980	2016-05-19 18:30:59.523447	1
4525	1	sadas	46980	2016-05-19 18:30:59.523849	1
4526	13	dsaasd	46981	2016-05-19 18:31:53.380152	1
4527	174	d	46981	2016-05-19 18:31:53.380895	1
4528	1	sadas	46981	2016-05-19 18:31:53.381268	1
4529	13	dsaasd	46982	2016-05-19 18:32:02.365907	1
4530	174	d	46982	2016-05-19 18:32:02.366406	1
4531	1	sadas	46982	2016-05-19 18:32:02.366779	1
4532	13	dsaasd	46983	2016-05-19 18:33:42.933176	1
4533	174	d	46983	2016-05-19 18:33:42.933684	1
4534	1	sadas	46983	2016-05-19 18:33:42.951652	1
4535	13	dsaasd	46984	2016-05-19 18:36:29.695038	1
4536	174	d	46984	2016-05-19 18:36:29.695559	1
4537	1	sadas	46984	2016-05-19 18:36:29.69593	1
4538	13	dsaasd	46985	2016-05-19 18:36:41.942804	1
4539	174	d	46985	2016-05-19 18:36:41.94335	1
4540	1	sadas	46985	2016-05-19 18:36:41.943753	1
4541	13	dsaasd	46986	2016-05-19 18:40:39.354453	1
4542	174	d	46986	2016-05-19 18:40:39.355298	1
4543	1	sadas	46986	2016-05-19 18:40:39.355699	1
4544	13	dsaasd	46987	2016-05-19 18:40:56.221366	1
4545	174	d	46987	2016-05-19 18:40:56.221938	1
4546	1	sadas	46987	2016-05-19 18:40:56.222322	1
4547	13	dsaasd	46988	2016-05-19 18:41:23.517402	1
4548	174	d	46988	2016-05-19 18:41:23.518151	1
4549	1	sadas	46988	2016-05-19 18:41:23.518547	1
4550	13	dsaasd	46989	2016-05-19 18:41:45.887544	1
4551	174	d	46989	2016-05-19 18:41:45.889005	1
4552	1	sadas	46989	2016-05-19 18:41:45.889978	1
4553	13	dsaasd	46990	2016-05-19 18:42:48.250243	1
4554	174	d	46990	2016-05-19 18:42:48.250849	1
4555	1	sadas	46990	2016-05-19 18:42:48.251216	1
4556	13	dsaasd	46991	2016-05-19 18:43:16.710024	1
4557	174	d	46991	2016-05-19 18:43:16.71052	1
4558	1	sadas	46991	2016-05-19 18:43:16.71091	1
4559	13	dsaasd	46992	2016-05-19 18:43:25.228133	1
4560	174	d	46992	2016-05-19 18:43:25.229	1
4561	1	sadas	46992	2016-05-19 18:43:25.229426	1
4562	13	dsaasd	46993	2016-05-19 18:43:46.701748	1
4563	174	d	46993	2016-05-19 18:43:46.702304	1
4564	1	sadas	46993	2016-05-19 18:43:46.702732	1
4565	13	dsaasd	46994	2016-05-19 18:44:43.557551	1
4566	174	d	46994	2016-05-19 18:44:43.558156	1
4567	1	sadas	46994	2016-05-19 18:44:43.558639	1
4568	13	dsaasd	46995	2016-05-19 18:44:52.231808	1
4569	174	d	46995	2016-05-19 18:44:52.232265	1
4570	1	sadas	46995	2016-05-19 18:44:52.232718	1
4571	13	dsaasd	46996	2016-05-19 18:46:13.651574	1
4572	174	d	46996	2016-05-19 18:46:13.652043	1
4573	1	sadas	46996	2016-05-19 18:46:13.65241	1
4574	13	dsaasd	46997	2016-05-19 18:46:30.098418	1
4575	174	d	46997	2016-05-19 18:46:30.098921	1
4576	1	sadas	46997	2016-05-19 18:46:30.099292	1
4577	13	dsaasd	46998	2016-05-19 18:47:10.736622	1
4578	174	d	46998	2016-05-19 18:47:10.737241	1
4579	1	sadas	46998	2016-05-19 18:47:10.737605	1
4580	13	dsaasd	46999	2016-05-19 18:48:04.941146	1
4581	174	d	46999	2016-05-19 18:48:04.941891	1
4582	1	sadas	46999	2016-05-19 18:48:04.942306	1
4583	13	dsaasd	47000	2016-05-19 18:48:23.693601	1
4584	174	d	47000	2016-05-19 18:48:23.694255	1
4585	1	sadas	47000	2016-05-19 18:48:23.694644	1
4586	13	dsaasd	47001	2016-05-19 18:48:31.315915	1
4587	174	d	47001	2016-05-19 18:48:31.316611	1
4588	1	sadas	47001	2016-05-19 18:48:31.317058	1
4589	13	dsaasd	47002	2016-05-19 18:48:41.518525	1
4590	174	d	47002	2016-05-19 18:48:41.518981	1
4591	1	sadas	47002	2016-05-19 18:48:41.519339	1
4592	13	dsaasd	47003	2016-05-19 18:49:41.848354	1
4593	174	d	47003	2016-05-19 18:49:41.848831	1
4594	1	sadas	47003	2016-05-19 18:49:41.849263	1
4595	13	dsaasd	47004	2016-05-19 18:50:07.723333	1
4596	174	d	47004	2016-05-19 18:50:07.723922	1
4597	1	sadas	47004	2016-05-19 18:50:07.724302	1
4598	13	dsaasd	47005	2016-05-19 18:50:57.818067	1
4599	174	d	47005	2016-05-19 18:50:57.81871	1
4600	1	sadas	47005	2016-05-19 18:50:57.819088	1
4601	13	dsaasd	47006	2016-05-19 18:51:45.477124	1
4602	174	d	47006	2016-05-19 18:51:45.477641	1
4603	1	sadas	47006	2016-05-19 18:51:45.478041	1
4604	13	dsaasd	47007	2016-05-19 18:52:04.139821	1
4605	174	d	47007	2016-05-19 18:52:04.140544	1
4606	1	sadas	47007	2016-05-19 18:52:04.140931	1
4607	13	dsaasd	47008	2016-05-19 18:52:46.569779	1
4608	174	d	47008	2016-05-19 18:52:46.570312	1
4609	1	sadas	47008	2016-05-19 18:52:46.570779	1
4610	13	dsaasd	47009	2016-05-19 18:53:42.37368	1
4611	174	d	47009	2016-05-19 18:53:42.374179	1
4612	1	sadas	47009	2016-05-19 18:53:42.374568	1
4613	13	dsaasd	47010	2016-05-19 18:54:43.662055	1
4614	174	d	47010	2016-05-19 18:54:43.662702	1
4615	1	sadas	47010	2016-05-19 18:54:43.663139	1
4616	13	dsaasd	47011	2016-05-19 18:55:43.46945	1
4617	174	d	47011	2016-05-19 18:55:43.470065	1
4618	1	sadas	47011	2016-05-19 18:55:43.470461	1
4619	13	dsaasd	47012	2016-05-19 18:58:28.428879	1
4620	174	d	47012	2016-05-19 18:58:28.429398	1
4621	1	sadas	47012	2016-05-19 18:58:28.429786	1
4622	13	dsaasd	47013	2016-05-19 18:58:38.737921	1
4623	174	d	47013	2016-05-19 18:58:38.738435	1
4624	1	sadas	47013	2016-05-19 18:58:38.738815	1
4625	13	dsaasd	47014	2016-05-19 19:01:56.501913	1
4626	174	d	47014	2016-05-19 19:01:56.502521	1
4627	1	sadas	47014	2016-05-19 19:01:56.502918	1
4628	13	dsaasd	47015	2016-05-19 19:02:28.599264	1
4629	174	d	47015	2016-05-19 19:02:28.63333	1
4630	1	sadas	47015	2016-05-19 19:02:28.715623	1
4631	13	dsaasd	47016	2016-05-19 19:03:15.297439	1
4632	174	d	47016	2016-05-19 19:03:15.297981	1
4633	1	sadas	47016	2016-05-19 19:03:15.298329	1
4634	13	dsaasd	47017	2016-05-19 19:03:28.228745	1
4635	174	d	47017	2016-05-19 19:03:28.229367	1
4636	1	sadas	47017	2016-05-19 19:03:28.229754	1
4637	13	dsaasd	47018	2016-05-19 19:03:49.071589	1
4638	174	d	47018	2016-05-19 19:03:49.072339	1
4639	1	sadas	47018	2016-05-19 19:03:49.072756	1
4640	13	dsaasd	47019	2016-05-19 19:04:02.403599	1
4641	174	d	47019	2016-05-19 19:04:02.404108	1
4642	1	sadas	47019	2016-05-19 19:04:02.404485	1
4643	13	dsaasd	47020	2016-05-19 19:04:59.225512	1
4644	174	d	47020	2016-05-19 19:04:59.22598	1
4645	1	sadas	47020	2016-05-19 19:04:59.226339	1
4646	13	dsaasd	47021	2016-05-19 19:05:25.874035	1
4647	174	d	47021	2016-05-19 19:05:25.874613	1
4648	1	sadas	47021	2016-05-19 19:05:25.874996	1
4649	13	dsaasd	47022	2016-05-19 19:05:46.512464	1
4650	174	d	47022	2016-05-19 19:05:46.513056	1
4651	1	sadas	47022	2016-05-19 19:05:46.513486	1
4652	13	dsaasd	47023	2016-05-19 19:06:19.377331	1
4653	174	d	47023	2016-05-19 19:06:19.377809	1
4654	1	sadas	47023	2016-05-19 19:06:19.378183	1
4655	13	dsaasd	47024	2016-05-19 19:07:16.72418	1
4656	174	d	47024	2016-05-19 19:07:16.724653	1
4657	1	sadas	47024	2016-05-19 19:07:16.725014	1
4658	13	dsaasd	47025	2016-05-19 19:07:37.7324	1
4659	174	d	47025	2016-05-19 19:07:37.732899	1
4660	1	sadas	47025	2016-05-19 19:07:37.733622	1
4661	13	dsaasd	47026	2016-05-19 19:08:18.156796	1
4662	174	d	47026	2016-05-19 19:08:18.157362	1
4663	1	sadas	47026	2016-05-19 19:08:18.157729	1
4664	13	dsaasd	47027	2016-05-19 19:08:36.805452	1
4665	174	d	47027	2016-05-19 19:08:36.805981	1
4666	1	sadas	47027	2016-05-19 19:08:36.806431	1
4667	13	dsaasd	47028	2016-05-19 19:09:00.099531	1
4668	174	d	47028	2016-05-19 19:09:00.100183	1
4669	1	sadas	47028	2016-05-19 19:09:00.100573	1
4670	13	dsaasd	47029	2016-05-19 19:09:11.569966	1
4671	174	d	47029	2016-05-19 19:09:11.57043	1
4672	1	sadas	47029	2016-05-19 19:09:11.57081	1
4673	13	dsaasd	47030	2016-05-19 19:09:32.426944	1
4674	174	d	47030	2016-05-19 19:09:32.427655	1
4675	1	sadas	47030	2016-05-19 19:09:32.42808	1
4676	13	dsaasd	47031	2016-05-19 19:10:06.014808	1
4677	174	d	47031	2016-05-19 19:10:06.015345	1
4678	1	sadas	47031	2016-05-19 19:10:06.015744	1
4679	13	dsaasd	47032	2016-05-19 19:10:35.408256	1
4680	174	d	47032	2016-05-19 19:10:35.409004	1
4681	1	sadas	47032	2016-05-19 19:10:35.409387	1
4682	13	dsaasd	47033	2016-05-19 19:10:43.424454	1
4683	174	d	47033	2016-05-19 19:10:43.424999	1
4684	1	sadas	47033	2016-05-19 19:10:43.425458	1
4685	13	dsaasd	47034	2016-05-19 19:10:56.073775	1
4686	174	d	47034	2016-05-19 19:10:56.074297	1
4687	1	sadas	47034	2016-05-19 19:10:56.074693	1
4688	13	dsaasd	47035	2016-05-19 19:11:23.178905	1
4689	174	d	47035	2016-05-19 19:11:23.179507	1
4690	1	sadas	47035	2016-05-19 19:11:23.179911	1
4691	13	dsaasd	47036	2016-05-19 19:12:13.139452	1
4692	174	d	47036	2016-05-19 19:12:13.140025	1
4693	1	sadas	47036	2016-05-19 19:12:13.140416	1
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 4693, true);


--
-- Name: workflow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_id_seq', 25, true);


--
-- Data for Name: workflow_postos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_postos (id, id_workflow, idator, posto, ordem_cronologica, principal, lista, idtipoprocesso, starter, notif_saindoposto, notif_entrandoposto, tipodesignacao, regra_finalizacao) FROM stdin;
278	1	\N	Dados da Contratação	\N	0	F	2	\N	6	\N	\N	\N
280	1	\N	Processos Finalizados	9	1	L	\N	\N	\N	\N	\N	\N
281	1	85	Reprovacão de Candidato	\N	0	F	2	\N	\N	\N	\N	\N
282	1	85	Reprovacão de Candidato ja entrevistado	\N	0	F	2	\N	\N	\N	\N	\N
283	1	85	Negociacão Falha	\N	0	F	2	\N	\N	\N	\N	\N
284	1	85	TESTE	\N	0	F	2	\N	\N	\N	\N	\N
285	1	85	Re Ativar Processo Seletivo para este candidato	\N	0	F	2	\N	\N	\N	\N	\N
286	1	85	Arquivar processo de Candidato	\N	0	F	2	\N	\N	\N	\N	\N
279	1	\N	Onboarding de novo membro	\N	0	F	2	\N	7	\N	\N	\N
273	1	3	lançar candidato	\N	0	F	3	0	\N	\N	\N	\N
4	1	85	roteamento	4	1	L	2	\N	\N	3	\N	\N
5	1	85	entrevista presencial	5	1	L	2	\N	\N	4	\N	\N
6	1	85	entrevistados	6	1	L	2	\N	\N	\N	\N	\N
7	1	85	onboarding	8	1	L	2	\N	\N	\N	\N	\N
275	1	\N	Encaminhar para Gestor	\N	0	F	2	\N	\N	\N	\N	\N
276	1	\N	Dados da Entrevista	\N	0	F	2	\N	\N	\N	\N	\N
277	1	\N	Encaminhar para Negociacão	\N	0	F	2	\N	\N	\N	\N	\N
8	1	85	negociar com consultoria	7	1	L	2	\N	\N	5	\N	\N
2	1	3	cadastra retorno	2	1	L	1	1	\N	\N	\N	\N
1	1	85	job description	1	1	F	1	1	1	\N	\N	\N
274	1	1	Classificação de Senioridade	\N	0	F	3	\N	\N	\N	\N	\N
288	1	1	Classificação de Senioridade	\N	0	F	3	\N	\N	\N	\N	\N
3	1	2	Primeira Avaliação	3	1	L	3	\N	\N	2	AUTO-DIRECIONADO	\N
287	1	2	Segunda Avaliação	3	1	L	3	\N	\N	\N	AUTO-DIRECIONADO	\N
\.


--
-- Name: workflow_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_postos_id_seq', 288, true);


--
-- Data for Name: workflow_tramitacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_tramitacao (id, idprocesso, idworkflowposto, inicio, fim) FROM stdin;
1903	46855	1	2016-05-18 19:33:18.078072	2016-05-18 19:33:18.078072
1904	46855	2	2016-05-18 19:33:18.079656	\N
1906	46858	287	2016-05-18 19:33:46.673209	2016-05-18 19:34:01.999303
1907	46860	3	2016-05-18 19:36:15.974382	\N
1908	46861	287	2016-05-18 19:36:15.977421	\N
1909	46863	3	2016-05-18 19:37:32.734717	\N
1910	46864	287	2016-05-18 19:37:32.737827	\N
1911	46866	3	2016-05-19 10:58:06.850257	\N
1912	46867	287	2016-05-19 10:58:06.882585	\N
1913	46869	3	2016-05-19 10:58:19.083692	\N
1914	46870	287	2016-05-19 10:58:19.119353	\N
1915	46872	3	2016-05-19 10:59:53.15725	\N
1916	46873	287	2016-05-19 10:59:53.18829	\N
1917	46875	3	2016-05-19 11:04:13.762196	\N
1918	46876	287	2016-05-19 11:04:13.811587	\N
1919	46878	3	2016-05-19 11:05:13.048972	\N
1920	46879	287	2016-05-19 11:05:13.07553	\N
1921	46881	3	2016-05-19 11:06:40.43723	\N
1922	46883	3	2016-05-19 11:07:29.511129	\N
1923	46885	3	2016-05-19 11:53:17.445554	\N
1924	46887	3	2016-05-19 11:56:00.785433	\N
1925	46889	3	2016-05-19 11:57:57.745742	\N
1926	46890	287	2016-05-19 11:57:57.788519	\N
1927	46892	3	2016-05-19 11:58:11.699736	\N
1928	46893	287	2016-05-19 11:58:11.72556	\N
1929	46895	3	2016-05-19 11:58:58.802725	\N
1930	46896	287	2016-05-19 11:58:58.854629	\N
1905	46857	3	2016-05-18 19:33:46.668467	2016-05-19 11:59:19.411936
1931	46856	4	2016-05-19 11:59:19.415398	2016-05-19 11:59:31.350074
1932	46856	5	2016-05-19 11:59:31.348897	2016-05-19 11:59:36.725979
1933	46856	6	2016-05-19 11:59:36.72496	2016-05-19 11:59:42.126664
1935	46856	280	2016-05-19 11:59:47.610943	\N
1934	46856	8	2016-05-19 11:59:42.125651	2016-05-19 11:59:47.612003
1936	46897	1	2016-05-19 16:23:03.195768	2016-05-19 16:23:03.195768
1937	46897	2	2016-05-19 16:23:03.207616	\N
1938	46898	1	2016-05-19 16:23:20.318402	2016-05-19 16:23:20.318402
1939	46898	2	2016-05-19 16:23:20.329587	\N
1940	46899	1	2016-05-19 16:24:44.65291	2016-05-19 16:24:44.65291
1941	46899	2	2016-05-19 16:24:44.667951	\N
1942	46900	1	2016-05-19 16:24:53.771692	2016-05-19 16:24:53.771692
1943	46900	2	2016-05-19 16:24:53.784036	\N
1944	46901	1	2016-05-19 16:27:03.520543	2016-05-19 16:27:03.520543
1945	46901	2	2016-05-19 16:27:03.533032	\N
1946	46902	1	2016-05-19 16:37:39.512417	2016-05-19 16:37:39.512417
1947	46902	2	2016-05-19 16:37:39.520988	\N
1948	46903	1	2016-05-19 16:42:25.669991	2016-05-19 16:42:25.669991
1949	46904	1	2016-05-19 16:54:59.193606	2016-05-19 16:54:59.193606
1950	46904	2	2016-05-19 16:54:59.207136	\N
1951	46905	1	2016-05-19 16:55:53.348936	2016-05-19 16:55:53.348936
1952	46905	2	2016-05-19 16:55:53.361804	\N
1953	46906	1	2016-05-19 17:22:13.529059	2016-05-19 17:22:13.529059
1954	46906	2	2016-05-19 17:22:13.542783	\N
1955	46907	1	2016-05-19 17:22:38.597224	2016-05-19 17:22:38.597224
1956	46907	2	2016-05-19 17:22:38.615845	\N
1957	46908	1	2016-05-19 17:24:02.700498	2016-05-19 17:24:02.700498
1958	46909	1	2016-05-19 17:25:03.026413	2016-05-19 17:25:03.026413
1959	46910	1	2016-05-19 17:25:04.552986	2016-05-19 17:25:04.552986
1960	46911	1	2016-05-19 17:27:48.422475	2016-05-19 17:27:48.422475
1961	46912	1	2016-05-19 17:28:19.849302	2016-05-19 17:28:19.849302
1962	46912	2	2016-05-19 17:28:19.871824	\N
1963	46913	1	2016-05-19 17:28:38.098454	2016-05-19 17:28:38.098454
1964	46913	2	2016-05-19 17:28:38.130517	\N
1965	46914	1	2016-05-19 17:37:01.016573	2016-05-19 17:37:01.016573
1966	46914	2	2016-05-19 17:37:01.042427	\N
1967	46915	1	2016-05-19 17:38:48.301116	2016-05-19 17:38:48.301116
1968	46915	2	2016-05-19 17:38:48.327255	\N
1969	46916	1	2016-05-19 17:39:25.734294	2016-05-19 17:39:25.734294
1970	46916	2	2016-05-19 17:39:25.763597	\N
1971	46917	1	2016-05-19 17:40:20.543057	2016-05-19 17:40:20.543057
1972	46917	2	2016-05-19 17:40:20.56824	\N
1973	46918	1	2016-05-19 17:41:16.42312	2016-05-19 17:41:16.42312
1974	46918	2	2016-05-19 17:41:16.448379	\N
1975	46919	1	2016-05-19 17:41:39.020824	2016-05-19 17:41:39.020824
1976	46919	2	2016-05-19 17:41:39.050086	\N
1977	46920	1	2016-05-19 17:41:43.461116	2016-05-19 17:41:43.461116
1978	46920	2	2016-05-19 17:41:43.491322	\N
1979	46921	1	2016-05-19 17:42:06.141182	2016-05-19 17:42:06.141182
1980	46921	2	2016-05-19 17:42:06.170818	\N
1981	46922	1	2016-05-19 17:42:28.572077	2016-05-19 17:42:28.572077
1982	46922	2	2016-05-19 17:42:28.728453	\N
1983	46923	1	2016-05-19 17:43:16.734857	2016-05-19 17:43:16.734857
1984	46923	2	2016-05-19 17:43:16.759455	\N
1985	46924	1	2016-05-19 17:43:43.639907	2016-05-19 17:43:43.639907
1986	46924	2	2016-05-19 17:43:43.664362	\N
1987	46925	1	2016-05-19 17:44:34.925916	2016-05-19 17:44:34.925916
1988	46925	2	2016-05-19 17:44:34.950866	\N
1989	46926	1	2016-05-19 17:45:02.772405	2016-05-19 17:45:02.772405
1990	46926	2	2016-05-19 17:45:02.797563	\N
1991	46927	1	2016-05-19 17:45:53.386085	2016-05-19 17:45:53.386085
1992	46927	2	2016-05-19 17:45:53.411398	\N
1993	46928	1	2016-05-19 17:46:46.579933	2016-05-19 17:46:46.579933
1994	46928	2	2016-05-19 17:46:46.606351	\N
1995	46929	1	2016-05-19 17:47:18.029364	2016-05-19 17:47:18.029364
1996	46929	2	2016-05-19 17:47:18.057716	\N
1997	46930	1	2016-05-19 17:48:45.087023	2016-05-19 17:48:45.087023
1998	46930	2	2016-05-19 17:48:45.114523	\N
1999	46931	1	2016-05-19 17:49:22.809124	2016-05-19 17:49:22.809124
2000	46931	2	2016-05-19 17:49:22.835543	\N
2001	46932	1	2016-05-19 17:50:30.646347	2016-05-19 17:50:30.646347
2002	46932	2	2016-05-19 17:50:30.671971	\N
2003	46933	1	2016-05-19 17:51:44.793421	2016-05-19 17:51:44.793421
2004	46933	2	2016-05-19 17:51:44.839523	\N
2005	46934	1	2016-05-19 17:53:42.451619	2016-05-19 17:53:42.451619
2006	46934	2	2016-05-19 17:53:42.476482	\N
2007	46935	1	2016-05-19 17:54:37.903926	2016-05-19 17:54:37.903926
2008	46935	2	2016-05-19 17:54:37.929155	\N
2009	46936	1	2016-05-19 17:55:04.50709	2016-05-19 17:55:04.50709
2010	46936	2	2016-05-19 17:55:04.531825	\N
2011	46937	1	2016-05-19 17:55:52.228728	2016-05-19 17:55:52.228728
2012	46937	2	2016-05-19 17:55:52.254141	\N
2013	46938	1	2016-05-19 17:56:10.589747	2016-05-19 17:56:10.589747
2014	46938	2	2016-05-19 17:56:10.615509	\N
2015	46939	1	2016-05-19 17:56:40.052241	2016-05-19 17:56:40.052241
2016	46939	2	2016-05-19 17:56:40.08302	\N
2017	46940	1	2016-05-19 17:57:01.587924	2016-05-19 17:57:01.587924
2018	46940	2	2016-05-19 17:57:01.615553	\N
2019	46941	1	2016-05-19 17:58:02.813173	2016-05-19 17:58:02.813173
2020	46941	2	2016-05-19 17:58:02.838591	\N
2021	46942	1	2016-05-19 17:58:14.003488	2016-05-19 17:58:14.003488
2022	46942	2	2016-05-19 17:58:14.028345	\N
2023	46943	1	2016-05-19 17:58:58.351335	2016-05-19 17:58:58.351335
2024	46943	2	2016-05-19 17:58:58.380546	\N
2025	46944	1	2016-05-19 17:59:31.972713	2016-05-19 17:59:31.972713
2026	46944	2	2016-05-19 17:59:32.000873	\N
2027	46945	1	2016-05-19 17:59:55.865609	2016-05-19 17:59:55.865609
2028	46945	2	2016-05-19 17:59:55.890806	\N
2029	46946	1	2016-05-19 17:59:59.065519	2016-05-19 17:59:59.065519
2030	46946	2	2016-05-19 17:59:59.090473	\N
2031	46947	1	2016-05-19 18:00:10.99733	2016-05-19 18:00:10.99733
2032	46947	2	2016-05-19 18:00:11.025727	\N
2033	46948	1	2016-05-19 18:08:26.198038	2016-05-19 18:08:26.198038
2034	46948	2	2016-05-19 18:08:26.222881	\N
2035	46949	1	2016-05-19 18:12:20.428963	2016-05-19 18:12:20.428963
2036	46949	2	2016-05-19 18:12:20.458469	\N
2037	46950	1	2016-05-19 18:12:35.782771	2016-05-19 18:12:35.782771
2038	46950	2	2016-05-19 18:12:35.807819	\N
2039	46951	1	2016-05-19 18:15:00.425797	2016-05-19 18:15:00.425797
2040	46951	2	2016-05-19 18:15:00.45079	\N
2041	46952	1	2016-05-19 18:15:20.908308	2016-05-19 18:15:20.908308
2042	46952	2	2016-05-19 18:15:20.936703	\N
2043	46953	1	2016-05-19 18:16:57.036307	2016-05-19 18:16:57.036307
2044	46953	2	2016-05-19 18:16:57.063679	\N
2045	46954	1	2016-05-19 18:18:08.602726	2016-05-19 18:18:08.602726
2046	46954	2	2016-05-19 18:18:08.627068	\N
2047	46955	1	2016-05-19 18:18:24.579585	2016-05-19 18:18:24.579585
2048	46955	2	2016-05-19 18:18:24.604632	\N
2049	46956	1	2016-05-19 18:18:40.023452	2016-05-19 18:18:40.023452
2050	46956	2	2016-05-19 18:18:40.052886	\N
2051	46957	1	2016-05-19 18:19:27.05209	2016-05-19 18:19:27.05209
2052	46957	2	2016-05-19 18:19:27.083982	\N
2053	46958	1	2016-05-19 18:20:31.477619	2016-05-19 18:20:31.477619
2054	46958	2	2016-05-19 18:20:31.507842	\N
2055	46959	1	2016-05-19 18:21:48.579733	2016-05-19 18:21:48.579733
2056	46959	2	2016-05-19 18:21:48.608636	\N
2057	46960	1	2016-05-19 18:22:16.391539	2016-05-19 18:22:16.391539
2058	46960	2	2016-05-19 18:22:16.416613	\N
2059	46961	1	2016-05-19 18:22:23.062211	2016-05-19 18:22:23.062211
2060	46961	2	2016-05-19 18:22:23.091443	\N
2061	46962	1	2016-05-19 18:22:57.738057	2016-05-19 18:22:57.738057
2062	46962	2	2016-05-19 18:22:57.766929	\N
2063	46963	1	2016-05-19 18:23:13.406586	2016-05-19 18:23:13.406586
2064	46963	2	2016-05-19 18:23:13.43163	\N
2065	46964	1	2016-05-19 18:23:57.844513	2016-05-19 18:23:57.844513
2066	46964	2	2016-05-19 18:23:57.869418	\N
2067	46965	1	2016-05-19 18:24:47.035925	2016-05-19 18:24:47.035925
2068	46965	2	2016-05-19 18:24:47.060851	\N
2069	46966	1	2016-05-19 18:24:57.004394	2016-05-19 18:24:57.004394
2070	46966	2	2016-05-19 18:24:57.033051	\N
2071	46967	1	2016-05-19 18:25:28.188052	2016-05-19 18:25:28.188052
2072	46967	2	2016-05-19 18:25:28.216937	\N
2073	46968	1	2016-05-19 18:25:39.291833	2016-05-19 18:25:39.291833
2074	46968	2	2016-05-19 18:25:39.322185	\N
2075	46969	1	2016-05-19 18:25:56.721392	2016-05-19 18:25:56.721392
2076	46969	2	2016-05-19 18:25:56.746949	\N
2077	46970	1	2016-05-19 18:26:07.48306	2016-05-19 18:26:07.48306
2078	46970	2	2016-05-19 18:26:07.509268	\N
2079	46971	1	2016-05-19 18:26:16.332098	2016-05-19 18:26:16.332098
2080	46971	2	2016-05-19 18:26:16.357282	\N
2081	46972	1	2016-05-19 18:26:40.903707	2016-05-19 18:26:40.903707
2082	46972	2	2016-05-19 18:26:40.932546	\N
2083	46973	1	2016-05-19 18:26:57.250603	2016-05-19 18:26:57.250603
2084	46974	1	2016-05-19 18:27:18.832172	2016-05-19 18:27:18.832172
2085	46974	2	2016-05-19 18:27:18.860965	\N
2086	46975	1	2016-05-19 18:28:54.436107	2016-05-19 18:28:54.436107
2087	46975	2	2016-05-19 18:28:54.462835	\N
2088	46976	1	2016-05-19 18:29:17.675698	2016-05-19 18:29:17.675698
2089	46976	2	2016-05-19 18:29:17.700373	\N
2090	46977	1	2016-05-19 18:29:23.402804	2016-05-19 18:29:23.402804
2091	46977	2	2016-05-19 18:29:23.427467	\N
2092	46978	1	2016-05-19 18:29:35.786577	2016-05-19 18:29:35.786577
2093	46978	2	2016-05-19 18:29:35.811502	\N
2094	46979	1	2016-05-19 18:30:36.448407	2016-05-19 18:30:36.448407
2095	46980	1	2016-05-19 18:30:59.524879	2016-05-19 18:30:59.524879
2096	46981	1	2016-05-19 18:31:53.382187	2016-05-19 18:31:53.382187
2097	46981	2	2016-05-19 18:31:53.407248	\N
2098	46982	1	2016-05-19 18:32:02.367706	2016-05-19 18:32:02.367706
2099	46982	2	2016-05-19 18:32:02.398105	\N
2100	46983	1	2016-05-19 18:33:42.952912	2016-05-19 18:33:42.952912
2101	46983	2	2016-05-19 18:33:42.977726	\N
2102	46984	1	2016-05-19 18:36:29.696847	2016-05-19 18:36:29.696847
2103	46985	1	2016-05-19 18:36:41.944696	2016-05-19 18:36:41.944696
2104	46986	1	2016-05-19 18:40:39.357773	2016-05-19 18:40:39.357773
2105	46986	2	2016-05-19 18:40:39.379622	\N
2106	46987	1	2016-05-19 18:40:56.223375	2016-05-19 18:40:56.223375
2107	46987	2	2016-05-19 18:40:56.240767	\N
2108	46988	1	2016-05-19 18:41:23.519432	2016-05-19 18:41:23.519432
2109	46988	2	2016-05-19 18:41:23.535911	\N
2110	46989	1	2016-05-19 18:41:45.970714	2016-05-19 18:41:45.970714
2111	46989	2	2016-05-19 18:41:45.989199	\N
2112	46990	1	2016-05-19 18:42:48.252168	2016-05-19 18:42:48.252168
2113	46990	2	2016-05-19 18:42:48.270581	\N
2114	46991	1	2016-05-19 18:43:16.71178	2016-05-19 18:43:16.71178
2115	46991	2	2016-05-19 18:43:16.734593	\N
2116	46992	1	2016-05-19 18:43:25.230358	2016-05-19 18:43:25.230358
2117	46992	2	2016-05-19 18:43:25.249095	\N
2118	46993	1	2016-05-19 18:43:46.703689	2016-05-19 18:43:46.703689
2119	46993	2	2016-05-19 18:43:46.724908	\N
2120	46994	1	2016-05-19 18:44:43.560006	2016-05-19 18:44:43.560006
2121	46994	2	2016-05-19 18:44:43.578544	\N
2122	46995	1	2016-05-19 18:44:52.233689	2016-05-19 18:44:52.233689
2123	46995	2	2016-05-19 18:44:52.254885	\N
2124	46996	1	2016-05-19 18:46:13.653375	2016-05-19 18:46:13.653375
2125	46996	2	2016-05-19 18:46:13.675063	\N
2126	46997	1	2016-05-19 18:46:30.100204	2016-05-19 18:46:30.100204
2127	46997	2	2016-05-19 18:46:30.121672	\N
2128	46998	1	2016-05-19 18:47:10.738659	2016-05-19 18:47:10.738659
2129	46998	2	2016-05-19 18:47:10.753194	\N
2130	46999	1	2016-05-19 18:48:04.943473	2016-05-19 18:48:04.943473
2131	46999	2	2016-05-19 18:48:04.956374	\N
2132	47000	1	2016-05-19 18:48:23.695703	2016-05-19 18:48:23.695703
2133	47000	2	2016-05-19 18:48:23.708267	\N
2134	47001	1	2016-05-19 18:48:31.318105	2016-05-19 18:48:31.318105
2135	47001	2	2016-05-19 18:48:31.331867	\N
2136	47002	1	2016-05-19 18:48:41.520331	2016-05-19 18:48:41.520331
2137	47002	2	2016-05-19 18:48:41.541755	\N
2138	47003	1	2016-05-19 18:49:41.850161	2016-05-19 18:49:41.850161
2139	47003	2	2016-05-19 18:49:41.872436	\N
2140	47004	1	2016-05-19 18:50:07.725291	2016-05-19 18:50:07.725291
2141	47004	2	2016-05-19 18:50:07.746392	\N
2142	47005	1	2016-05-19 18:50:57.82002	2016-05-19 18:50:57.82002
2143	47005	2	2016-05-19 18:50:57.836997	\N
2144	47006	1	2016-05-19 18:51:45.478969	2016-05-19 18:51:45.478969
2145	47006	2	2016-05-19 18:51:45.495401	\N
2146	47007	1	2016-05-19 18:52:04.141901	2016-05-19 18:52:04.141901
2147	47008	1	2016-05-19 18:52:46.571921	2016-05-19 18:52:46.571921
2148	47008	2	2016-05-19 18:52:46.590682	\N
2149	47009	1	2016-05-19 18:53:42.375485	2016-05-19 18:53:42.375485
2150	47009	2	2016-05-19 18:53:42.398726	\N
2151	47010	1	2016-05-19 18:54:43.664306	2016-05-19 18:54:43.664306
2152	47010	2	2016-05-19 18:54:43.691389	\N
2153	47011	1	2016-05-19 18:55:43.471407	2016-05-19 18:55:43.471407
2154	47012	1	2016-05-19 18:58:28.430886	2016-05-19 18:58:28.430886
2155	47013	1	2016-05-19 18:58:38.739793	2016-05-19 18:58:38.739793
2156	47013	2	2016-05-19 18:58:38.766317	\N
2157	47014	1	2016-05-19 19:01:56.50401	2016-05-19 19:01:56.50401
2158	47014	2	2016-05-19 19:01:56.541356	\N
2159	47015	1	2016-05-19 19:02:28.817186	2016-05-19 19:02:28.817186
2160	47015	2	2016-05-19 19:02:29.007686	\N
2161	47016	1	2016-05-19 19:03:15.299298	2016-05-19 19:03:15.299298
2162	47016	2	2016-05-19 19:03:15.335167	\N
2163	47017	1	2016-05-19 19:03:28.23078	2016-05-19 19:03:28.23078
2164	47017	2	2016-05-19 19:03:28.270818	\N
2165	47018	1	2016-05-19 19:03:49.073726	2016-05-19 19:03:49.073726
2166	47018	2	2016-05-19 19:03:49.111428	\N
2167	47019	1	2016-05-19 19:04:02.405457	2016-05-19 19:04:02.405457
2168	47019	2	2016-05-19 19:04:02.4432	\N
2169	47020	1	2016-05-19 19:04:59.227226	2016-05-19 19:04:59.227226
2170	47021	1	2016-05-19 19:05:25.876072	2016-05-19 19:05:25.876072
2171	47022	1	2016-05-19 19:05:46.514512	2016-05-19 19:05:46.514512
2172	47022	2	2016-05-19 19:05:46.538533	\N
2173	47023	1	2016-05-19 19:06:19.379121	2016-05-19 19:06:19.379121
2174	47023	2	2016-05-19 19:06:19.407095	\N
2175	47024	1	2016-05-19 19:07:16.725891	2016-05-19 19:07:16.725891
2176	47024	2	2016-05-19 19:07:16.748927	\N
2177	47025	1	2016-05-19 19:07:37.734626	2016-05-19 19:07:37.734626
2178	47025	2	2016-05-19 19:07:37.757631	\N
2179	47026	1	2016-05-19 19:08:18.158637	2016-05-19 19:08:18.158637
2180	47026	2	2016-05-19 19:08:18.183001	\N
2181	47027	1	2016-05-19 19:08:36.80748	2016-05-19 19:08:36.80748
2182	47027	2	2016-05-19 19:08:36.830023	\N
2183	47028	1	2016-05-19 19:09:00.101509	2016-05-19 19:09:00.101509
2184	47028	2	2016-05-19 19:09:00.124714	\N
2185	47029	1	2016-05-19 19:09:11.571756	2016-05-19 19:09:11.571756
2186	47029	2	2016-05-19 19:09:11.599164	\N
2187	47030	1	2016-05-19 19:09:32.429068	2016-05-19 19:09:32.429068
2188	47030	2	2016-05-19 19:09:32.451778	\N
2189	47031	1	2016-05-19 19:10:06.016797	2016-05-19 19:10:06.016797
2190	47031	2	2016-05-19 19:10:06.035905	\N
2191	47032	1	2016-05-19 19:10:35.410405	2016-05-19 19:10:35.410405
2192	47032	2	2016-05-19 19:10:35.43162	\N
2193	47033	1	2016-05-19 19:10:43.426747	2016-05-19 19:10:43.426747
2194	47033	2	2016-05-19 19:10:43.451339	\N
2195	47034	1	2016-05-19 19:10:56.075637	2016-05-19 19:10:56.075637
2196	47034	2	2016-05-19 19:10:56.099027	\N
2197	47035	1	2016-05-19 19:11:23.180885	2016-05-19 19:11:23.180885
2198	47035	2	2016-05-19 19:11:23.200043	\N
2199	47036	1	2016-05-19 19:12:13.141313	2016-05-19 19:12:13.141313
2200	47036	2	2016-05-19 19:12:13.165714	\N
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 2200, true);


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

