--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
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
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE usuarios (
    id integer NOT NULL,
    email character varying,
    nome character varying,
    senha character varying,
    login character varying,
    admin integer,
    criacao timestamp without time zone
);


ALTER TABLE usuarios OWNER TO postgres;

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
-- Name: processos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE processos (
    id integer DEFAULT nextval('usuarios_id_seq'::regclass) NOT NULL,
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
    ''::text AS status,
    p_bisavo.id AS bisavo,
    p_netos.id AS neto
   FROM ((((processos p
     LEFT JOIN processos p_filhos ON ((p_filhos.idpai = p.id)))
     LEFT JOIN processos p_avo ON ((p_avo.id = p.idpai)))
     LEFT JOIN processos p_bisavo ON ((p_bisavo.id = p_avo.idpai)))
     LEFT JOIN processos p_netos ON ((p_netos.idpai = p_filhos.id)))
UNION ALL
 SELECT usuarios.id AS proprio,
    NULL::integer AS filho,
    NULL::integer AS avo,
    ''::text AS status,
    NULL::integer AS bisavo,
    NULL::integer AS neto
   FROM usuarios;


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
-- Name: engine_campos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE engine_campos (
    id integer NOT NULL,
    campo character varying,
    maxlenght integer,
    inputtype character varying,
    txtarea_cols integer,
    txtarea_rows integer,
    dica_preenchimento character varying,
    valor_default character varying,
    administrativo character varying
);


ALTER TABLE engine_campos OWNER TO postgres;

--
-- Name: eng_feature_campo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE eng_feature_campo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE eng_feature_campo_id_seq OWNER TO postgres;

--
-- Name: eng_feature_campo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE eng_feature_campo_id_seq OWNED BY engine_campos.id;


--
-- Name: eng_feature_campos_lista; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE eng_feature_campos_lista (
    id integer NOT NULL,
    idfeature integer,
    idfeaturecampo integer
);


ALTER TABLE eng_feature_campos_lista OWNER TO postgres;

--
-- Name: eng_feature_campos_lista_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE eng_feature_campos_lista_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE eng_feature_campos_lista_id_seq OWNER TO postgres;

--
-- Name: eng_feature_campos_lista_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE eng_feature_campos_lista_id_seq OWNED BY eng_feature_campos_lista.id;


--
-- Name: eng_features; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE eng_features (
    id integer NOT NULL,
    idator integer,
    feature character varying,
    idtipoprocesso integer,
    lista character varying
);


ALTER TABLE eng_features OWNER TO postgres;

--
-- Name: eng_features_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE eng_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE eng_features_id_seq OWNER TO postgres;

--
-- Name: eng_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE eng_features_id_seq OWNED BY eng_features.id;


--
-- Name: engine_acao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE engine_acao (
    id integer NOT NULL,
    idfeature integer,
    acao character varying,
    goto integer
);


ALTER TABLE engine_acao OWNER TO postgres;

--
-- Name: engine_acao_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE engine_acao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE engine_acao_id_seq OWNER TO postgres;

--
-- Name: engine_acao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE engine_acao_id_seq OWNED BY engine_acao.id;


--
-- Name: engine_dados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE engine_dados (
    id integer NOT NULL,
    idfeaturecampo integer,
    valor character varying,
    idprocesso integer,
    registro timestamp without time zone,
    idmenu integer
);


ALTER TABLE engine_dados OWNER TO postgres;

--
-- Name: engine_dados_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE engine_dados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE engine_dados_id_seq OWNER TO postgres;

--
-- Name: engine_dados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE engine_dados_id_seq OWNED BY engine_dados.id;


--
-- Name: engine_feature_campos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE engine_feature_campos (
    id integer NOT NULL,
    idcampo integer,
    idfeature integer,
    obrigatorio integer
);


ALTER TABLE engine_feature_campos OWNER TO postgres;

--
-- Name: engine_feature_campos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE engine_feature_campos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE engine_feature_campos_id_seq OWNER TO postgres;

--
-- Name: engine_feature_campos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE engine_feature_campos_id_seq OWNED BY engine_feature_campos.id;


--
-- Name: engine_funcoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE engine_funcoes (
    id integer NOT NULL,
    idfeature integer,
    funcao character varying,
    goto integer
);


ALTER TABLE engine_funcoes OWNER TO postgres;

--
-- Name: engine_funcoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE engine_funcoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE engine_funcoes_id_seq OWNER TO postgres;

--
-- Name: engine_funcoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE engine_funcoes_id_seq OWNED BY engine_funcoes.id;


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
-- Name: menus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE menus (
    id integer NOT NULL,
    menu character varying,
    irpara integer,
    idpai integer,
    arquivo character varying,
    tipodestino character varying
);


ALTER TABLE menus OWNER TO postgres;

--
-- Name: menus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE menus_id_seq OWNER TO postgres;

--
-- Name: menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE menus_id_seq OWNED BY menus.id;


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
-- Name: workflow_campos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE workflow_campos (
    id integer NOT NULL,
    campo character varying,
    maxlenght integer,
    inputtype character varying,
    txtarea_cols integer,
    txtarea_rows integer,
    dica_preenchimento character varying,
    valor_default character varying,
    administrativo character varying
);


ALTER TABLE workflow_campos OWNER TO postgres;

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

ALTER SEQUENCE postos_campo_id_seq OWNED BY workflow_campos.id;


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
-- Name: usuarios_avaliadores_tecnologias; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW usuarios_avaliadores_tecnologias AS
 SELECT ed.idprocesso AS idusuario,
    efc.campo
   FROM (engine_dados ed
     JOIN engine_campos efc ON ((efc.id = ed.idfeaturecampo)))
  WHERE (((ed.valor)::text = ANY ((ARRAY['3'::character varying, '4'::character varying, '5'::character varying])::text[])) AND (ed.idfeaturecampo = ANY (ARRAY[3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 99])));


ALTER TABLE usuarios_avaliadores_tecnologias OWNER TO postgres;

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
-- Name: workflow_posto_campos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE workflow_posto_campos (
    id integer NOT NULL,
    idposto integer,
    idcampo integer,
    obrigatorio integer
);


ALTER TABLE workflow_posto_campos OWNER TO postgres;

--
-- Name: workflow_posto_campos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE workflow_posto_campos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workflow_posto_campos_id_seq OWNER TO postgres;

--
-- Name: workflow_posto_campos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE workflow_posto_campos_id_seq OWNED BY workflow_posto_campos.id;


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

ALTER TABLE ONLY eng_feature_campos_lista ALTER COLUMN id SET DEFAULT nextval('eng_feature_campos_lista_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY eng_features ALTER COLUMN id SET DEFAULT nextval('eng_features_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY engine_acao ALTER COLUMN id SET DEFAULT nextval('engine_acao_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY engine_campos ALTER COLUMN id SET DEFAULT nextval('eng_feature_campo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY engine_dados ALTER COLUMN id SET DEFAULT nextval('engine_dados_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY engine_feature_campos ALTER COLUMN id SET DEFAULT nextval('engine_feature_campos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY engine_funcoes ALTER COLUMN id SET DEFAULT nextval('engine_funcoes_id_seq'::regclass);


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

ALTER TABLE ONLY menus ALTER COLUMN id SET DEFAULT nextval('menus_id_seq'::regclass);


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

ALTER TABLE ONLY postos_campo_lista ALTER COLUMN id SET DEFAULT nextval('postos_campo_lista_id_seq'::regclass);


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

ALTER TABLE ONLY workflow ALTER COLUMN id SET DEFAULT nextval('workflow_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY workflow_campos ALTER COLUMN id SET DEFAULT nextval('postos_campo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY workflow_dados ALTER COLUMN id SET DEFAULT nextval('workflow_dados_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY workflow_posto_campos ALTER COLUMN id SET DEFAULT nextval('workflow_posto_campos_id_seq'::regclass);


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
-- Name: eng_feature_campo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('eng_feature_campo_id_seq', 114, true);


--
-- Data for Name: eng_feature_campos_lista; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY eng_feature_campos_lista (id, idfeature, idfeaturecampo) FROM stdin;
1	3	1
2	3	2
\.


--
-- Name: eng_feature_campos_lista_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('eng_feature_campos_lista_id_seq', 2, true);


--
-- Data for Name: eng_features; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY eng_features (id, idator, feature, idtipoprocesso, lista) FROM stdin;
3	85	Usuários	5	L
4	85	Recrutamento e Seleção	1	L
5	85	Incluir novo Usuário	5	F
6	85	Editar usuário	5	F
7	85	Meu Perfil	5	F
8	85	Meus Dados	5	F
9	85	Minhas Skills	5	F
\.


--
-- Name: eng_features_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('eng_features_id_seq', 9, true);


--
-- Data for Name: engine_acao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY engine_acao (id, idfeature, acao, goto) FROM stdin;
2	7	editar	10
\.


--
-- Name: engine_acao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('engine_acao_id_seq', 2, true);


--
-- Data for Name: engine_campos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY engine_campos (id, campo, maxlenght, inputtype, txtarea_cols, txtarea_rows, dica_preenchimento, valor_default, administrativo) FROM stdin;
114	Tipo de Usuário	\N	list	\N	\N	\N	{public.atores}	tipousuario
3	Java	\N	text	\N	\N	\N	\N	\N
99	Perl	\N	text	\N	\N	\N	\N	\N
5	Python	\N	text	\N	\N	\N	\N	\N
6	Scala	\N	text	\N	\N	\N	\N	\N
7	Go	\N	text	\N	\N	\N	\N	\N
8	Ruby	\N	text	\N	\N	\N	\N	\N
9	.Net	\N	text	\N	\N	\N	\N	\N
10	Spring	\N	text	\N	\N	\N	\N	\N
11	Ruby on Rails	\N	text	\N	\N	\N	\N	\N
12	Resteasy	\N	text	\N	\N	\N	\N	\N
13	Spring Core	\N	text	\N	\N	\N	\N	\N
14	Spring MVC	\N	text	\N	\N	\N	\N	\N
15	Spring Data	\N	text	\N	\N	\N	\N	\N
16	Apache Camel	\N	text	\N	\N	\N	\N	\N
17	React	\N	text	\N	\N	\N	\N	\N
18	Javascript	\N	text	\N	\N	\N	\N	\N
19	CSS	\N	text	\N	\N	\N	\N	\N
20	Kraken	\N	text	\N	\N	\N	\N	\N
21	Angular	\N	text	\N	\N	\N	\N	\N
22	Sass	\N	text	\N	\N	\N	\N	\N
23	Stylus	\N	text	\N	\N	\N	\N	\N
24	Atomic Css	\N	text	\N	\N	\N	\N	\N
25	Bootstrap	\N	text	\N	\N	\N	\N	\N
26	Grunt	\N	text	\N	\N	\N	\N	\N
27	Gulp	\N	text	\N	\N	\N	\N	\N
28	Siteprism	\N	text	\N	\N	\N	\N	\N
29	Sonar	\N	text	\N	\N	\N	\N	\N
30	BDD	\N	text	\N	\N	\N	\N	\N
31	Capybara	\N	text	\N	\N	\N	\N	\N
32	Selenium	\N	text	\N	\N	\N	\N	\N
33	Httparty	\N	text	\N	\N	\N	\N	\N
34	Rest-Assured	\N	text	\N	\N	\N	\N	\N
35	WireMock	\N	text	\N	\N	\N	\N	\N
36	Cucumber	\N	text	\N	\N	\N	\N	\N
37	Redis	\N	text	\N	\N	\N	\N	\N
38	Hazelcast	\N	text	\N	\N	\N	\N	\N
39	Mongo	\N	text	\N	\N	\N	\N	\N
40	Oracle	\N	text	\N	\N	\N	\N	\N
41	SQL Server	\N	text	\N	\N	\N	\N	\N
42	MySQL	\N	text	\N	\N	\N	\N	\N
43	Rabbit MQ	\N	text	\N	\N	\N	\N	\N
44	ActiveMQ	\N	text	\N	\N	\N	\N	\N
45	nginx	\N	text	\N	\N	\N	\N	\N
46	Git	\N	text	\N	\N	\N	\N	\N
47	Docker	\N	text	\N	\N	\N	\N	\N
48	Jenkins	\N	text	\N	\N	\N	\N	\N
49	rpm	\N	text	\N	\N	\N	\N	\N
50	Backbone	\N	text	\N	\N	\N	\N	\N
51	Oracle Forms	\N	text	\N	\N	\N	\N	\N
52	Oracle Reports	\N	text	\N	\N	\N	\N	\N
53	Cassandra	\N	text	\N	\N	\N	\N	\N
54	PL/SQL	\N	text	\N	\N	\N	\N	\N
55	PHP	\N	text	\N	\N	\N	\N	\N
4	NodeJS	\N	text	\N	\N	\N	\N	\N
1	Meu Nome	\N	text	\N	\N	\N	\N	nome
2	Email	\N	text	\N	\N	\N	\N	email
112	Senha	\N	password	\N	\N	\N	\N	senha
113	login	\N	text	\N	\N	\N	\N	login
\.


--
-- Data for Name: engine_dados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY engine_dados (id, idfeaturecampo, valor, idprocesso, registro, idmenu) FROM stdin;
521	113	lll	95	2016-07-18 00:20:44.964698	8
522	112	kkk	95	2016-07-18 00:20:44.965405	8
418	1	stefany siqueira	76	2016-07-17 01:34:31.707294	8
518	112	s3nha	94	2016-07-18 00:16:16.499418	8
419	2	causais	77	2016-07-17 01:36:48.001962	8
420	1	casuais siiii	77	2016-07-17 01:36:48.002806	8
421	2	mais um gaming	78	2016-07-17 01:49:37.890009	8
422	1	 lifeee	78	2016-07-17 01:49:37.89064	8
415	2	babirondo@gmail	75	2016-07-17 01:33:05.178189	8
423	2	symphony	79	2016-07-17 23:29:01.67552	8
424	1	x	79	2016-07-17 23:29:01.676094	8
425	4	12	80	2016-07-17 23:34:08.562986	13
426	55		80	2016-07-17 23:34:08.563714	13
427	54		80	2016-07-17 23:34:08.564129	13
428	53		80	2016-07-17 23:34:08.564538	13
429	52		80	2016-07-17 23:34:08.564973	13
430	51		80	2016-07-17 23:34:08.565399	13
431	50		80	2016-07-17 23:34:08.565801	13
432	49		80	2016-07-17 23:34:08.56622	13
433	48		80	2016-07-17 23:34:08.566657	13
434	47		80	2016-07-17 23:34:08.567136	13
435	46		80	2016-07-17 23:34:08.567592	13
436	45		80	2016-07-17 23:34:08.56802	13
437	44		80	2016-07-17 23:34:08.568411	13
438	43		80	2016-07-17 23:34:08.568815	13
439	42		80	2016-07-17 23:34:08.569267	13
440	41		80	2016-07-17 23:34:08.569692	13
441	40		80	2016-07-17 23:34:08.570113	13
442	39		80	2016-07-17 23:34:08.570554	13
443	38		80	2016-07-17 23:34:08.571106	13
444	37		80	2016-07-17 23:34:08.571527	13
445	36		80	2016-07-17 23:34:08.571917	13
446	35		80	2016-07-17 23:34:08.572318	13
447	34		80	2016-07-17 23:34:08.5727	13
448	33		80	2016-07-17 23:34:08.573073	13
449	32		80	2016-07-17 23:34:08.57348	13
450	31		80	2016-07-17 23:34:08.573857	13
451	30		80	2016-07-17 23:34:08.574294	13
452	29		80	2016-07-17 23:34:08.574673	13
453	28		80	2016-07-17 23:34:08.575123	13
454	27		80	2016-07-17 23:34:08.575489	13
455	26		80	2016-07-17 23:34:08.576003	13
456	25		80	2016-07-17 23:34:08.576394	13
457	24		80	2016-07-17 23:34:08.576787	13
458	23		80	2016-07-17 23:34:08.577132	13
459	22		80	2016-07-17 23:34:08.577526	13
460	21		80	2016-07-17 23:34:08.577921	13
461	20		80	2016-07-17 23:34:08.578299	13
462	19		80	2016-07-17 23:34:08.5787	13
463	18		80	2016-07-17 23:34:08.57913	13
464	17		80	2016-07-17 23:34:08.579514	13
465	16		80	2016-07-17 23:34:08.579922	13
466	15		80	2016-07-17 23:34:08.580303	13
467	14		80	2016-07-17 23:34:08.580689	13
468	13		80	2016-07-17 23:34:08.581112	13
469	12		80	2016-07-17 23:34:08.581486	13
470	11		80	2016-07-17 23:34:08.581835	13
471	10		80	2016-07-17 23:34:08.582217	13
472	9		80	2016-07-17 23:34:08.582593	13
473	8		80	2016-07-17 23:34:08.58321	13
474	7		80	2016-07-17 23:34:08.583739	13
475	6		80	2016-07-17 23:34:08.584114	13
476	5		80	2016-07-17 23:34:08.584469	13
477	99		80	2016-07-17 23:34:08.584857	13
478	3		80	2016-07-17 23:34:08.585345	13
479	2	d2	81	2016-07-17 23:47:33.817245	8
480	1	23	81	2016-07-17 23:47:33.843083	8
481	2	d2	82	2016-07-17 23:47:45.169981	8
482	1	23	82	2016-07-17 23:47:45.170621	8
483	2	d2	83	2016-07-17 23:48:02.429743	8
484	1	23	83	2016-07-17 23:48:02.430391	8
485	2	d2	84	2016-07-18 00:09:10.109014	8
486	1	23	84	2016-07-18 00:09:10.111322	8
487	2	d2	85	2016-07-18 00:10:01.22379	8
488	1	23	85	2016-07-18 00:10:01.224522	8
489	2	d2	86	2016-07-18 00:10:23.089622	8
490	1	23	86	2016-07-18 00:10:23.090305	8
491	2	d2	87	2016-07-18 00:10:30.354718	8
492	1	23	87	2016-07-18 00:10:30.357966	8
493	113	login	88	2016-07-18 00:13:31.961542	8
494	112	senha	88	2016-07-18 00:13:31.962163	8
495	2	email	88	2016-07-18 00:13:31.962532	8
496	1	nome	88	2016-07-18 00:13:31.962953	8
497	113	login	89	2016-07-18 00:13:38.911	8
498	112	senha	89	2016-07-18 00:13:38.920757	8
499	2	email	89	2016-07-18 00:13:38.929579	8
500	1	nome	89	2016-07-18 00:13:38.936908	8
501	113	login	90	2016-07-18 00:14:15.206013	8
502	112	senha	90	2016-07-18 00:14:15.206731	8
503	2	email	90	2016-07-18 00:14:15.207108	8
504	1	nome	90	2016-07-18 00:14:15.20755	8
505	113	babirondo	91	2016-07-18 00:14:37.028294	8
506	112	s3nha	91	2016-07-18 00:14:37.02901	8
507	2	babirondo@gmail.com	91	2016-07-18 00:14:37.029531	8
508	1	siqueira	91	2016-07-18 00:14:37.029963	8
509	113	babirondo	92	2016-07-18 00:14:42.332898	8
510	112	s3nha	92	2016-07-18 00:14:42.333626	8
511	2	babirondo@gmail.com	92	2016-07-18 00:14:42.334023	8
512	1	siqueira	92	2016-07-18 00:14:42.334404	8
513	113	babirondo	93	2016-07-18 00:15:08.278936	8
514	112	s3nha	93	2016-07-18 00:15:08.279564	8
515	2	babirondo@gmail.com	93	2016-07-18 00:15:08.280004	8
516	1	siqueira	93	2016-07-18 00:15:08.280423	8
523	2	mm	95	2016-07-18 00:20:44.965807	8
524	1	nn	95	2016-07-18 00:20:44.966172	8
525	113	lll	96	2016-07-18 00:20:52.046804	8
526	112	kkk	96	2016-07-18 00:20:52.047458	8
527	2	mm	96	2016-07-18 00:20:52.047924	8
528	1	nn	96	2016-07-18 00:20:52.048334	8
529	113	lll	97	2016-07-18 00:22:11.987208	8
530	112	kkk	97	2016-07-18 00:22:12.003309	8
531	2	mm	97	2016-07-18 00:22:12.020508	8
532	1	nn	97	2016-07-18 00:22:12.052321	8
533	113	lll	98	2016-07-18 00:22:15.997953	8
534	112	kkk	98	2016-07-18 00:22:15.998804	8
535	2	mm	98	2016-07-18 00:22:15.999211	8
536	1	nn	98	2016-07-18 00:22:15.999595	8
537	113	novo login	99	2016-07-18 00:22:33.165933	8
538	112	nova senha	99	2016-07-18 00:22:33.349903	8
539	2	novo email	99	2016-07-18 00:22:33.619458	8
540	1	novo usuario	99	2016-07-18 00:22:33.725477	8
541	113	novo login	100	2016-07-18 00:22:34.435061	8
542	112	nova senha	100	2016-07-18 00:22:34.522415	8
519	2	babirondo@gmail.com	94	2016-07-18 00:16:16.500067	8
520	1	siqueira	94	2016-07-18 00:16:16.500532	8
416	1	bruno 123	75	2016-07-17 01:33:05.1788	8
517	113	babirondo nao vai	94	2016-07-18 00:16:16.49853	8
543	2	novo email	100	2016-07-18 00:22:34.599745	8
544	1	novo usuario	100	2016-07-18 00:22:34.630497	8
558	47		101	2016-07-18 00:44:19.109726	13
559	46		101	2016-07-18 00:44:19.110112	13
560	45		101	2016-07-18 00:44:19.110506	13
561	44		101	2016-07-18 00:44:19.110903	13
562	43		101	2016-07-18 00:44:19.111264	13
563	42		101	2016-07-18 00:44:19.111705	13
564	41		101	2016-07-18 00:44:19.112117	13
565	40		101	2016-07-18 00:44:19.1125	13
566	39		101	2016-07-18 00:44:19.112921	13
567	38		101	2016-07-18 00:44:19.11348	13
568	37		101	2016-07-18 00:44:19.113889	13
569	36		101	2016-07-18 00:44:19.11433	13
570	35		101	2016-07-18 00:44:19.114739	13
571	34		101	2016-07-18 00:44:19.115181	13
572	33		101	2016-07-18 00:44:19.115698	13
573	32		101	2016-07-18 00:44:19.11609	13
574	31		101	2016-07-18 00:44:19.116469	13
575	30		101	2016-07-18 00:44:19.116858	13
576	29		101	2016-07-18 00:44:19.117191	13
577	28		101	2016-07-18 00:44:19.117561	13
578	27		101	2016-07-18 00:44:19.117976	13
579	26		101	2016-07-18 00:44:19.118358	13
580	25		101	2016-07-18 00:44:19.11872	13
581	24		101	2016-07-18 00:44:19.119109	13
582	23		101	2016-07-18 00:44:19.119477	13
583	22		101	2016-07-18 00:44:19.119857	13
584	21		101	2016-07-18 00:44:19.120185	13
585	20		101	2016-07-18 00:44:19.120553	13
586	19		101	2016-07-18 00:44:19.120902	13
587	18		101	2016-07-18 00:44:19.121257	13
588	17		101	2016-07-18 00:44:19.12167	13
589	16		101	2016-07-18 00:44:19.122041	13
590	15		101	2016-07-18 00:44:19.122362	13
591	14		101	2016-07-18 00:44:19.122702	13
592	13		101	2016-07-18 00:44:19.1231	13
593	12		101	2016-07-18 00:44:19.123443	13
594	11		101	2016-07-18 00:44:19.123809	13
595	10		101	2016-07-18 00:44:19.124251	13
596	9		101	2016-07-18 00:44:19.124671	13
597	8		101	2016-07-18 00:44:19.125125	13
598	7		101	2016-07-18 00:44:19.125513	13
599	6		101	2016-07-18 00:44:19.125876	13
600	5		101	2016-07-18 00:44:19.126246	13
601	99		101	2016-07-18 00:44:19.126671	13
602	3		101	2016-07-18 00:44:19.127102	13
545	113	ok222	101	2016-07-18 00:22:56.674907	8
417	2	stefanysiqueira16	76	2016-07-17 01:34:31.706725	8
546	112	s	101	2016-07-18 00:22:56.675554	8
547	2	espirro	101	2016-07-18 00:22:56.67598	8
664	112	75	75	2016-07-18 00:56:04.696525	10
662	113	bruno.siqueira	4	2016-07-18 00:50:56.676667	10
606	4	1	4	2016-07-18 00:48:02.478617	13
607	55	4	4	2016-07-18 00:48:02.48005	13
549	4	nodejs	101	2016-07-18 00:44:19.104799	13
550	55	php-bruno	101	2016-07-18 00:44:19.106279	13
551	54		101	2016-07-18 00:44:19.106934	13
552	53		101	2016-07-18 00:44:19.107354	13
553	52		101	2016-07-18 00:44:19.107772	13
554	51		101	2016-07-18 00:44:19.108157	13
555	50		101	2016-07-18 00:44:19.108595	13
556	49		101	2016-07-18 00:44:19.108982	13
557	48		101	2016-07-18 00:44:19.109366	13
608	54		4	2016-07-18 00:48:02.480729	13
609	53		4	2016-07-18 00:48:02.48122	13
610	52		4	2016-07-18 00:48:02.481595	13
548	1	primeirao	101	2016-07-18 00:22:56.67643	8
660	113	s	76	2016-07-18 00:50:01.2046	10
603	112	teste123	4	2016-07-18 00:45:19.707576	12
611	51		4	2016-07-18 00:48:02.482024	13
612	50		4	2016-07-18 00:48:02.482472	13
613	49		4	2016-07-18 00:48:02.482954	13
614	48		4	2016-07-18 00:48:02.483397	13
615	47		4	2016-07-18 00:48:02.483863	13
616	46		4	2016-07-18 00:48:02.484259	13
617	45		4	2016-07-18 00:48:02.484616	13
618	44		4	2016-07-18 00:48:02.484999	13
619	43		4	2016-07-18 00:48:02.485371	13
620	42		4	2016-07-18 00:48:02.485744	13
621	41		4	2016-07-18 00:48:02.486141	13
622	40		4	2016-07-18 00:48:02.486548	13
623	39		4	2016-07-18 00:48:02.486921	13
624	38		4	2016-07-18 00:48:02.487299	13
625	37		4	2016-07-18 00:48:02.487676	13
626	36		4	2016-07-18 00:48:02.488078	13
627	35		4	2016-07-18 00:48:02.488471	13
628	34		4	2016-07-18 00:48:02.488837	13
629	33		4	2016-07-18 00:48:02.489196	13
630	32		4	2016-07-18 00:48:02.489561	13
631	31		4	2016-07-18 00:48:02.489918	13
632	30		4	2016-07-18 00:48:02.490305	13
633	29		4	2016-07-18 00:48:02.490676	13
634	28		4	2016-07-18 00:48:02.491049	13
635	27		4	2016-07-18 00:48:02.491427	13
636	26		4	2016-07-18 00:48:02.491811	13
637	25		4	2016-07-18 00:48:02.492183	13
638	24		4	2016-07-18 00:48:02.492547	13
639	23		4	2016-07-18 00:48:02.492928	13
640	22		4	2016-07-18 00:48:02.493312	13
641	21		4	2016-07-18 00:48:02.493678	13
642	20		4	2016-07-18 00:48:02.494069	13
643	19		4	2016-07-18 00:48:02.494442	13
644	18		4	2016-07-18 00:48:02.494808	13
645	17		4	2016-07-18 00:48:02.495163	13
646	16		4	2016-07-18 00:48:02.495529	13
647	15		4	2016-07-18 00:48:02.495905	13
648	14		4	2016-07-18 00:48:02.496276	13
649	13		4	2016-07-18 00:48:02.496643	13
650	12		4	2016-07-18 00:48:02.497035	13
651	11		4	2016-07-18 00:48:02.497678	13
652	10		4	2016-07-18 00:48:02.498317	13
653	9		4	2016-07-18 00:48:02.498909	13
654	8		4	2016-07-18 00:48:02.499345	13
655	7		4	2016-07-18 00:48:02.499716	13
656	6		4	2016-07-18 00:48:02.500131	13
657	5		4	2016-07-18 00:48:02.50052	13
658	99		4	2016-07-18 00:48:02.500946	13
659	3		4	2016-07-18 00:48:02.501319	13
661	112	s	76	2016-07-18 00:50:01.205228	10
604	2	bruno.siqueira@walmart.com	4	2016-07-18 00:45:19.709092	12
663	113	bruno.siqueira	4	2016-07-18 00:51:05.505795	10
605	1	Bruno Siqueiraaaaaa	4	2016-07-18 00:45:19.709827	12
665	112	75	75	2016-07-18 00:56:27.787319	10
666	113	novinho entao...	126	2016-07-18 00:57:00.748021	8
669	1	nomee	126	2016-07-18 00:57:00.74957	8
668	2	email	126	2016-07-18 00:57:00.749154	8
667	112	teste123	126	2016-07-18 00:57:00.748729	8
670	113	l	127	2016-07-18 23:39:24.95402	8
671	112	l	127	2016-07-18 23:39:24.991525	8
672	2	l	127	2016-07-18 23:39:24.992039	8
673	1	l	127	2016-07-18 23:39:24.992537	8
674	114	2	127	2016-07-18 23:39:24.99297	8
675	113	l	128	2016-07-18 23:46:47.863732	8
676	112	l	128	2016-07-18 23:46:47.864563	8
677	2	l	128	2016-07-18 23:46:47.865018	8
678	1	l	128	2016-07-18 23:46:47.865421	8
679	114	2	128	2016-07-18 23:46:47.865829	8
680	113	m	129	2016-07-18 23:47:10.129375	8
681	112	kn	129	2016-07-18 23:47:10.130083	8
682	2	dsa	129	2016-07-18 23:47:10.130487	8
683	1	3	129	2016-07-18 23:47:10.1309	8
684	114	3,5,85	129	2016-07-18 23:47:10.131323	8
685	113	m	130	2016-07-18 23:47:15.233016	8
686	112	kn	130	2016-07-18 23:47:15.23353	8
687	2	dsa	130	2016-07-18 23:47:15.233955	8
688	1	3	130	2016-07-18 23:47:15.234322	8
689	114	3,5,85	130	2016-07-18 23:47:15.234693	8
690	113	m	131	2016-07-18 23:50:46.629743	8
691	112	kn	131	2016-07-18 23:50:46.630479	8
692	2	dsa	131	2016-07-18 23:50:46.630977	8
693	1	3	131	2016-07-18 23:50:46.631437	8
694	114	3,5,85	131	2016-07-18 23:50:46.631866	8
695	113	m	132	2016-07-18 23:54:23.273748	8
696	112	kn	132	2016-07-18 23:54:23.274466	8
697	2	dsa	132	2016-07-18 23:54:23.274887	8
698	1	3	132	2016-07-18 23:54:23.275286	8
699	114	3,5,85	132	2016-07-18 23:54:23.275655	8
700	113	comator	133	2016-07-18 23:55:22.660921	8
701	112	comator	133	2016-07-18 23:55:22.661457	8
702	2	comator	133	2016-07-18 23:55:22.661842	8
703	1	comator	133	2016-07-18 23:55:22.662196	8
704	114	2	133	2016-07-18 23:55:22.662568	8
\.


--
-- Name: engine_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('engine_dados_id_seq', 704, true);


--
-- Data for Name: engine_feature_campos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY engine_feature_campos (id, idcampo, idfeature, obrigatorio) FROM stdin;
65	112	8	1
55	1	5	1
67	112	6	1
56	2	5	1
59	1	6	1
60	2	6	1
61	1	8	1
62	2	8	1
1	3	9	\N
2	99	9	\N
3	5	9	\N
4	6	9	\N
5	7	9	\N
6	8	9	\N
7	9	9	\N
8	10	9	\N
9	11	9	\N
10	12	9	\N
11	13	9	\N
12	14	9	\N
13	15	9	\N
14	16	9	\N
15	17	9	\N
16	18	9	\N
17	19	9	\N
18	20	9	\N
19	21	9	\N
20	22	9	\N
21	23	9	\N
22	24	9	\N
23	25	9	\N
24	26	9	\N
25	27	9	\N
26	28	9	\N
27	29	9	\N
28	30	9	\N
29	31	9	\N
30	32	9	\N
31	33	9	\N
32	34	9	\N
33	35	9	\N
34	36	9	\N
35	37	9	\N
36	38	9	\N
37	39	9	\N
38	40	9	\N
39	41	9	\N
40	42	9	\N
41	43	9	\N
42	44	9	\N
43	45	9	\N
44	46	9	\N
45	47	9	\N
46	48	9	\N
47	49	9	\N
48	50	9	\N
49	51	9	\N
50	52	9	\N
51	53	9	\N
52	54	9	\N
53	55	9	\N
54	4	9	\N
63	112	5	1
64	113	5	1
69	114	5	1
\.


--
-- Name: engine_feature_campos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('engine_feature_campos_id_seq', 69, true);


--
-- Data for Name: engine_funcoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY engine_funcoes (id, idfeature, funcao, goto) FROM stdin;
1	3	Novo Usuário	8
\.


--
-- Name: engine_funcoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('engine_funcoes_id_seq', 1, true);


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
2	298	Novo Candidato	301
3	303	Incluir nova vaga	304
\.


--
-- Name: funcoes_posto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('funcoes_posto_id_seq', 3, true);


--
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY menus (id, menu, irpara, idpai, arquivo, tipodestino) FROM stdin;
6	Admin	\N	\N	\N	unico
7	Usuários	3	6	\N	unico
11	Meu Perfil	7	\N	\N	unico
13	Minhas Skills	9	11	\N	unico
8	Incluir novo Usuário	5	7	\N	admin-criar-usuario
12	Meus Dados	8	11	\N	admin-alterar-usuario
10	Editar usuário	6	7	\N	admin-alterar-usuario
14	Candidatos	27	\N	\N	workflow
17	Vagas	28	\N	\N	workflow
\.


--
-- Name: menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('menus_id_seq', 17, true);


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
320	298	Solicitar análise	302
321	303	Candidatos	305
\.


--
-- Name: posto_acao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('posto_acao_id_seq', 321, true);


--
-- Name: postos_campo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_id_seq', 204, true);


--
-- Data for Name: postos_campo_lista; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY postos_campo_lista (id, idposto, idpostocampo, atributo_campo, atributo_valor) FROM stdin;
95	298	202	\N	\N
96	298	203	\N	\N
97	303	203	\N	\N
98	303	204	\N	\N
99	305	202	\N	\N
100	305	203	\N	\N
101	305	204	\N	\N
\.


--
-- Name: postos_campo_lista_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_lista_id_seq', 101, true);


--
-- Data for Name: processos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY processos (id, idpai, idtipoprocesso, inicio, idworkflow, status, regra_finalizacao) FROM stdin;
209	\N	2	2016-07-21 00:38:28.740803	27	Em Andamento	\N
210	\N	2	2016-07-21 00:57:14.379942	27	Em Andamento	\N
211	\N	2	2016-07-21 00:57:22.668577	27	Em Andamento	\N
212	\N	1	2016-07-21 00:59:29.629633	28	Em Andamento	\N
213	\N	1	2016-07-21 00:59:36.04331	28	Em Andamento	\N
214	\N	1	2016-07-21 02:43:57.343665	28	Em Andamento	\N
215	\N	2	2016-07-21 02:44:15.540882	27	Em Andamento	\N
\.


--
-- Name: processos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('processos_id_seq', 26, true);


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
29	298	301
30	300	302
31	299	302
32	303	304
\.


--
-- Name: relacionamento_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('relacionamento_postos_id_seq', 32, true);


--
-- Data for Name: sla; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sla (id, nomeregra, idnotificacao, tabela, sla_emhorascorridas, campo_calculado, campo_localizador, valor_localizador, where_tabela, idpai) FROM stdin;
41	Tempo no posto Roteamento	8	workflow_tramitacao wt	5	wt.inicio	wt.id	4	wt.fim is null and wt.idworkflowposto = 4	\N
46	Tempo no Posto Negociar com COnsultoria	9	workflow_tramitacao wt	5	wt.inicio	wt.id	8	wt.fim is null and wt.idworkflowposto = 8	\N
45	Tempo no Posto Entrevistados	10	workflow_tramitacao wt	5	wt.inicio	wt.id	6	wt.fim is null and wt.idworkflowposto = 6	\N
44	Tempo no Posto Entrevista Presencial	11	workflow_tramitacao wt	5	wt.inicio	wt.id	5	wt.fim is null and wt.idworkflowposto = 5	\N
42	Tempo no Posto Primeira Avaliação	12	workflow_tramitacao wt	5	wt.inicio	wt.id	3	wt.fim is null and wt.idworkflowposto = 3	\N
43	Tempo no Posto Segunda Avaliação	12	workflow_tramitacao wt	5	wt.inicio	wt.id	287	wt.fim is null and wt.idworkflowposto = 287	\N
39	Tempo no Posto Onboarding	13	workflow_tramitacao wt	5	wt.inicio	wt.id	7	wt.fim is null and wt.idworkflowposto = 7	\N
40	Tempo máximo de Candidatura	14	processos p	5	p.inicio	p.id		p.status IN (null,   'Em Andamento') and p.idtipoprocesso = 2	\N
49	Escalonamento, nível 1, Tempo máximo de candidatura	17	sla_notificacoes sn 	5	sn.datanotificacao	sn.chave	\N	sn.idsla = 40	40
48	Escalonamento, nível 2, posto Primeira Avaliação	16	sla_notificacoes sn	5	sn.datanotificacao	sn.chave	\N	sn.idsla = 47	47
50	Escalonamento nível 2, tempo máximo de processo do candidato	18	sla_notificacoes sn	5	sn.datanotificacao	sn.chave	\N	sn.idsla = 49	49
47	Escalonamento, nível 1, posto Primeira Avaliação	15	sla_notificacoes sn	5	sn.datanotificacao	sn.chave	\N	sn.idsla = 42	42
\.


--
-- Name: sla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_id_seq', 50, true);


--
-- Data for Name: sla_notificacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sla_notificacoes (id, idsla, datanotificacao, chave) FROM stdin;
37542	42	2016-07-12 19:55:24.598514	2896
37543	43	2016-07-12 19:55:24.66609	2897
37544	42	2016-07-13 00:27:57.563748	2900
37545	43	2016-07-13 00:27:57.764652	2901
37546	42	2016-07-13 00:57:28.14234	2896
37547	43	2016-07-13 00:57:28.190774	2897
37548	47	2016-07-13 00:57:28.22267	2896
37549	42	2016-07-15 18:41:51.709648	2902
37550	42	2016-07-15 18:41:51.942624	2917
37551	42	2016-07-15 18:41:51.99179	2913
37552	42	2016-07-15 18:41:52.031257	2919
37553	42	2016-07-15 18:41:52.071761	2906
37554	42	2016-07-15 18:41:52.112123	2904
37555	42	2016-07-15 18:41:52.157083	2896
37556	42	2016-07-15 18:41:52.200919	2915
37557	42	2016-07-15 18:41:52.255565	2921
37558	42	2016-07-15 18:41:52.334833	2900
37559	42	2016-07-15 18:41:52.366377	2923
37560	42	2016-07-15 18:41:52.406211	2908
37561	42	2016-07-15 18:41:52.44849	2912
37562	42	2016-07-15 18:41:52.493145	2910
37563	43	2016-07-15 18:41:52.533808	2918
37564	43	2016-07-15 18:41:52.573433	2924
37565	43	2016-07-15 18:41:52.615489	2897
37566	43	2016-07-15 18:41:52.657366	2922
37567	43	2016-07-15 18:41:52.706179	2916
37568	43	2016-07-15 18:41:52.747045	2905
37569	43	2016-07-15 18:41:52.787727	2909
37570	43	2016-07-15 18:41:52.82805	2901
37571	43	2016-07-15 18:41:52.872606	2911
37572	43	2016-07-15 18:41:52.91438	2914
37573	43	2016-07-15 18:41:52.955032	2920
37574	43	2016-07-15 18:41:52.995505	2903
37575	43	2016-07-15 18:41:53.035567	2907
37576	48	2016-07-15 18:41:53.077604	2896
37577	47	2016-07-15 18:41:53.120349	2896
37578	47	2016-07-15 18:41:53.161941	2900
37579	42	2016-07-16 15:36:34.547949	2902
37580	42	2016-07-16 15:36:34.741759	2917
37581	42	2016-07-16 15:36:34.790846	2913
37582	42	2016-07-16 15:36:34.824812	2919
37583	42	2016-07-16 15:36:34.869379	2906
37584	42	2016-07-16 15:36:34.911754	2904
37585	42	2016-07-16 15:36:34.943431	2896
37586	42	2016-07-16 15:36:34.975899	2915
37587	42	2016-07-16 15:36:35.011246	2921
37588	42	2016-07-16 15:36:35.069976	2900
37589	42	2016-07-16 15:36:35.125028	2923
37590	42	2016-07-16 15:36:35.190544	2908
37591	42	2016-07-16 15:36:35.252749	2912
37592	42	2016-07-16 15:36:35.301463	2910
37593	43	2016-07-16 15:36:35.349646	2918
37594	43	2016-07-16 15:36:35.40475	2924
37595	43	2016-07-16 15:36:35.443723	2897
37596	43	2016-07-16 15:36:35.494524	2922
37597	43	2016-07-16 15:36:35.522329	2916
37598	43	2016-07-16 15:36:35.573347	2905
37599	43	2016-07-16 15:36:35.619126	2909
37600	43	2016-07-16 15:36:35.660177	2901
37601	43	2016-07-16 15:36:35.699457	2911
37602	43	2016-07-16 15:36:35.743173	2914
37603	43	2016-07-16 15:36:35.785152	2920
37604	43	2016-07-16 15:36:35.824193	2903
37605	43	2016-07-16 15:36:35.908669	2907
37606	48	2016-07-16 15:36:35.944341	2896
37607	48	2016-07-16 15:36:35.990739	2900
37608	47	2016-07-16 15:36:36.025473	2910
37609	47	2016-07-16 15:36:36.068721	2896
37610	47	2016-07-16 15:36:36.102057	2908
37611	47	2016-07-16 15:36:36.135188	2902
37612	47	2016-07-16 15:36:36.169322	2919
37613	47	2016-07-16 15:36:36.195844	2917
37614	47	2016-07-16 15:36:36.22193	2912
37615	47	2016-07-16 15:36:36.247737	2904
37616	47	2016-07-16 15:36:36.273861	2913
37617	47	2016-07-16 15:36:36.299368	2906
37618	47	2016-07-16 15:36:36.32545	2915
37619	47	2016-07-16 15:36:36.350964	2921
37620	47	2016-07-16 15:36:36.376736	2923
37621	47	2016-07-16 15:36:36.402674	2900
37622	42	2016-07-16 20:53:52.004527	2908
37623	42	2016-07-16 20:53:52.329626	2904
37624	42	2016-07-16 20:53:52.387321	2912
37625	42	2016-07-16 20:53:52.508196	2900
37626	42	2016-07-16 20:53:52.579449	2902
37627	42	2016-07-16 20:53:52.69447	2917
37628	42	2016-07-16 20:53:52.797934	2923
37629	42	2016-07-16 20:53:52.837452	2896
37630	42	2016-07-16 20:53:52.868201	2906
37631	42	2016-07-16 20:53:52.903497	2915
37632	42	2016-07-16 20:53:52.941708	2910
37633	42	2016-07-16 20:53:53.001454	2913
37634	42	2016-07-16 20:53:53.044961	2919
37635	43	2016-07-16 20:53:53.078418	2905
37636	43	2016-07-16 20:53:53.109514	2911
37637	43	2016-07-16 20:53:53.148604	2918
37638	43	2016-07-16 20:53:53.185105	2907
37639	43	2016-07-16 20:53:53.22878	2909
37640	43	2016-07-16 20:53:53.280166	2924
37641	43	2016-07-16 20:53:53.309753	2914
37642	43	2016-07-16 20:53:53.339565	2897
37643	43	2016-07-16 20:53:53.383713	2903
37644	43	2016-07-16 20:53:53.440822	2922
37645	43	2016-07-16 20:53:53.483958	2920
37646	43	2016-07-16 20:53:53.529533	2916
37647	43	2016-07-16 20:53:53.561994	2901
37648	48	2016-07-16 20:53:53.597315	2910
37649	48	2016-07-16 20:53:53.64994	2896
37650	48	2016-07-16 20:53:53.684482	2908
37651	48	2016-07-16 20:53:53.733368	2902
37652	48	2016-07-16 20:53:53.802079	2919
37653	48	2016-07-16 20:53:53.858331	2917
37654	48	2016-07-16 20:53:53.916459	2912
37655	48	2016-07-16 20:53:53.966026	2913
37656	48	2016-07-16 20:53:54.003016	2906
37657	48	2016-07-16 20:53:54.040107	2915
37658	48	2016-07-16 20:53:54.080682	2921
37659	48	2016-07-16 20:53:54.107617	2923
37660	48	2016-07-16 20:53:54.133461	2900
37661	48	2016-07-16 20:53:54.160261	2904
37662	47	2016-07-16 20:53:54.186999	2910
37663	47	2016-07-16 20:53:54.213615	2896
37664	47	2016-07-16 20:53:54.265663	2908
37665	47	2016-07-16 20:53:54.291843	2902
37666	47	2016-07-16 20:53:54.317757	2919
37667	47	2016-07-16 20:53:54.343847	2917
37668	47	2016-07-16 20:53:54.370199	2912
37669	47	2016-07-16 20:53:54.395913	2913
37670	47	2016-07-16 20:53:54.42173	2906
37671	47	2016-07-16 20:53:54.44849	2915
37672	47	2016-07-16 20:53:54.47512	2921
37673	47	2016-07-16 20:53:54.50223	2923
37674	47	2016-07-16 20:53:54.530636	2900
37675	47	2016-07-16 20:53:54.5578	2904
37676	42	2016-07-17 01:57:44.416451	2908
37677	42	2016-07-17 01:57:44.528239	2904
37678	42	2016-07-17 01:57:44.556414	2912
37679	42	2016-07-17 01:57:44.583295	2900
37680	42	2016-07-17 01:57:44.610471	2902
37681	42	2016-07-17 01:57:44.637444	2917
37682	42	2016-07-17 01:57:44.672213	2923
37683	42	2016-07-17 01:57:44.716196	2896
37684	42	2016-07-17 01:57:44.749679	2906
37685	42	2016-07-17 01:57:44.781323	2915
37686	42	2016-07-17 01:57:44.830108	2910
37687	42	2016-07-17 01:57:44.862896	2913
37688	42	2016-07-17 01:57:44.889617	2919
37689	43	2016-07-17 01:57:44.918097	2905
37690	43	2016-07-17 01:57:44.946268	2911
37691	43	2016-07-17 01:57:44.974997	2918
37692	43	2016-07-17 01:57:45.003975	2907
37693	43	2016-07-17 01:57:45.031489	2909
37694	43	2016-07-17 01:57:45.09336	2924
37695	43	2016-07-17 01:57:45.138844	2914
37696	43	2016-07-17 01:57:45.166731	2897
37697	43	2016-07-17 01:57:45.193614	2903
37698	43	2016-07-17 01:57:45.224346	2922
37699	43	2016-07-17 01:57:45.253075	2920
37700	43	2016-07-17 01:57:45.282287	2916
37701	43	2016-07-17 01:57:45.308655	2901
37702	48	2016-07-17 01:57:45.337999	2910
37703	48	2016-07-17 01:57:45.364896	2896
37704	48	2016-07-17 01:57:45.39226	2908
37705	48	2016-07-17 01:57:45.421086	2902
37706	48	2016-07-17 01:57:45.449422	2919
37707	48	2016-07-17 01:57:45.477207	2917
37708	48	2016-07-17 01:57:45.507019	2912
37709	48	2016-07-17 01:57:45.535875	2913
37710	48	2016-07-17 01:57:45.564049	2906
37711	48	2016-07-17 01:57:45.608832	2915
37712	48	2016-07-17 01:57:45.637348	2921
37713	48	2016-07-17 01:57:45.667323	2923
37714	48	2016-07-17 01:57:45.694967	2900
37715	48	2016-07-17 01:57:45.726019	2904
37716	47	2016-07-17 01:57:45.756399	2910
37717	47	2016-07-17 01:57:45.785504	2896
37718	47	2016-07-17 01:57:45.813194	2908
37719	47	2016-07-17 01:57:45.842536	2902
37720	47	2016-07-17 01:57:45.87164	2919
37721	47	2016-07-17 01:57:45.900312	2917
37722	47	2016-07-17 01:57:45.927116	2912
37723	47	2016-07-17 01:57:45.9615	2913
37724	47	2016-07-17 01:57:45.990168	2906
37725	47	2016-07-17 01:57:46.020315	2915
37726	47	2016-07-17 01:57:46.050857	2921
37727	47	2016-07-17 01:57:46.079276	2923
37728	47	2016-07-17 01:57:46.106198	2900
37729	47	2016-07-17 01:57:46.133658	2904
37730	42	2016-07-17 23:27:52.871246	2908
37731	42	2016-07-17 23:27:53.202748	2904
37732	42	2016-07-17 23:27:53.243186	2912
37733	42	2016-07-17 23:27:53.269367	2900
37734	42	2016-07-17 23:27:53.296141	2902
37735	42	2016-07-17 23:27:53.368659	2917
37736	42	2016-07-17 23:27:53.43685	2923
37737	42	2016-07-17 23:27:53.542184	2896
37738	42	2016-07-17 23:27:53.619454	2906
37739	42	2016-07-17 23:27:53.725255	2915
37740	42	2016-07-17 23:27:53.763386	2910
37741	42	2016-07-17 23:27:53.81675	2913
37742	42	2016-07-17 23:27:53.851243	2919
37743	43	2016-07-17 23:27:53.880472	2905
37744	43	2016-07-17 23:27:53.934057	2911
37745	43	2016-07-17 23:27:53.96207	2918
37746	43	2016-07-17 23:27:53.988984	2907
37747	43	2016-07-17 23:27:54.036646	2909
37748	43	2016-07-17 23:27:54.085043	2924
37749	43	2016-07-17 23:27:54.119513	2914
37750	43	2016-07-17 23:27:54.17204	2897
37751	43	2016-07-17 23:27:54.216536	2903
37752	43	2016-07-17 23:27:54.308921	2922
37753	43	2016-07-17 23:27:54.340292	2920
37754	43	2016-07-17 23:27:54.389009	2916
37755	43	2016-07-17 23:27:54.42224	2901
37756	48	2016-07-17 23:27:54.466743	2910
37757	48	2016-07-17 23:27:54.496335	2896
37758	48	2016-07-17 23:27:54.541122	2908
37759	48	2016-07-17 23:27:54.576603	2902
37760	48	2016-07-17 23:27:54.619719	2919
37761	48	2016-07-17 23:27:54.661719	2917
37762	48	2016-07-17 23:27:54.702269	2912
37763	48	2016-07-17 23:27:54.749147	2913
37764	48	2016-07-17 23:27:54.785454	2906
37765	48	2016-07-17 23:27:54.82097	2915
37766	48	2016-07-17 23:27:54.866264	2921
37767	48	2016-07-17 23:27:54.905149	2923
37768	48	2016-07-17 23:27:54.93637	2900
37769	48	2016-07-17 23:27:54.979322	2904
37770	47	2016-07-17 23:27:55.02069	2910
37771	47	2016-07-17 23:27:55.065074	2896
37772	47	2016-07-17 23:27:55.11422	2908
37773	47	2016-07-17 23:27:55.158052	2902
37774	47	2016-07-17 23:27:55.185076	2919
37775	47	2016-07-17 23:27:55.215138	2917
37776	47	2016-07-17 23:27:55.257538	2912
37777	47	2016-07-17 23:27:55.294391	2913
37778	47	2016-07-17 23:27:55.330596	2906
37779	47	2016-07-17 23:27:55.372354	2915
37780	47	2016-07-17 23:27:55.417293	2921
37781	47	2016-07-17 23:27:55.452259	2923
37782	47	2016-07-17 23:27:55.50492	2900
37783	47	2016-07-17 23:27:55.546409	2904
37784	42	2016-07-18 23:29:55.206568	2908
37785	42	2016-07-18 23:29:55.681115	2904
37786	42	2016-07-18 23:29:55.721656	2912
37787	42	2016-07-18 23:29:55.766886	2900
37788	42	2016-07-18 23:29:55.8038	2902
37789	42	2016-07-18 23:29:55.848705	2917
37790	42	2016-07-18 23:29:55.893772	2923
37791	42	2016-07-18 23:29:55.968753	2896
37792	42	2016-07-18 23:29:56.038264	2906
37793	42	2016-07-18 23:29:56.126866	2915
37794	42	2016-07-18 23:29:56.230221	2910
37795	42	2016-07-18 23:29:56.350489	2913
37796	42	2016-07-18 23:29:56.43062	2919
37797	43	2016-07-18 23:29:56.485937	2905
37798	43	2016-07-18 23:29:56.576264	2911
37799	43	2016-07-18 23:29:56.616963	2918
37800	43	2016-07-18 23:29:56.652344	2907
37801	43	2016-07-18 23:29:56.689231	2909
37802	43	2016-07-18 23:29:56.719858	2924
37803	43	2016-07-18 23:29:56.763996	2914
37804	43	2016-07-18 23:29:56.805789	2897
37805	43	2016-07-18 23:29:56.84089	2903
37806	43	2016-07-18 23:29:56.880016	2922
37807	43	2016-07-18 23:29:56.911796	2920
37808	43	2016-07-18 23:29:56.94851	2916
37809	43	2016-07-18 23:29:56.985793	2901
37810	48	2016-07-18 23:29:57.030496	2910
37811	48	2016-07-18 23:29:57.064499	2896
37812	48	2016-07-18 23:29:57.105773	2908
37813	48	2016-07-18 23:29:57.139377	2902
37814	48	2016-07-18 23:29:57.189849	2919
37815	48	2016-07-18 23:29:57.26016	2917
37816	48	2016-07-18 23:29:57.313884	2912
37817	48	2016-07-18 23:29:57.349076	2913
37818	48	2016-07-18 23:29:57.392931	2906
37819	48	2016-07-18 23:29:57.43554	2915
37820	48	2016-07-18 23:29:57.470937	2921
37821	48	2016-07-18 23:29:57.514812	2923
37822	48	2016-07-18 23:29:57.547228	2900
37823	48	2016-07-18 23:29:57.583987	2904
37824	47	2016-07-18 23:29:57.620839	2910
37825	47	2016-07-18 23:29:57.704183	2896
37826	47	2016-07-18 23:29:57.739257	2908
37827	47	2016-07-18 23:29:57.784181	2902
37828	47	2016-07-18 23:29:57.827976	2919
37829	47	2016-07-18 23:29:57.866344	2917
37830	47	2016-07-18 23:29:57.913981	2912
37831	47	2016-07-18 23:29:57.948852	2913
37832	47	2016-07-18 23:29:58.002233	2906
37833	47	2016-07-18 23:29:58.041177	2915
37834	47	2016-07-18 23:29:58.080151	2921
37835	47	2016-07-18 23:29:58.110926	2923
37836	47	2016-07-18 23:29:58.14543	2900
37837	47	2016-07-18 23:29:58.188987	2904
37838	40	2016-07-20 23:16:54.130943	191
37839	48	2016-07-20 23:16:58.319763	2910
37840	48	2016-07-20 23:16:58.531314	2896
37841	48	2016-07-20 23:16:58.732735	2908
37842	48	2016-07-20 23:16:58.942535	2902
37843	48	2016-07-20 23:16:59.090002	2919
37844	48	2016-07-20 23:16:59.687307	2917
37845	48	2016-07-20 23:16:59.846153	2912
37846	48	2016-07-20 23:16:59.971141	2913
37847	48	2016-07-20 23:17:00.209241	2906
37848	48	2016-07-20 23:17:00.415479	2915
37849	48	2016-07-20 23:17:00.634645	2921
37850	48	2016-07-20 23:17:00.746586	2923
37851	48	2016-07-20 23:17:00.876411	2900
37852	48	2016-07-20 23:17:01.110394	2904
37853	47	2016-07-20 23:17:01.332985	2910
37854	47	2016-07-20 23:17:01.47179	2896
37855	47	2016-07-20 23:17:01.547805	2908
37856	47	2016-07-20 23:17:01.71746	2902
37857	47	2016-07-20 23:17:01.870932	2919
37858	47	2016-07-20 23:17:01.993113	2917
37859	47	2016-07-20 23:17:02.114745	2912
37860	47	2016-07-20 23:17:02.261408	2913
37861	47	2016-07-20 23:17:02.384884	2906
37862	47	2016-07-20 23:17:02.570243	2915
37863	47	2016-07-20 23:17:02.8316	2921
37864	47	2016-07-20 23:17:02.940266	2923
37865	47	2016-07-20 23:17:03.338253	2900
37866	47	2016-07-20 23:17:03.461327	2904
\.


--
-- Name: sla_notificacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sla_notificacoes_id_seq', 37866, true);


--
-- Data for Name: tipos_processo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipos_processo (id, tipo, id_pai, regra_finalizacao, regra_handover, avanca_processo_filhos_fechados) FROM stdin;
3	Avaliação	2	\N	ANYTIME	\N
1	Vaga	\N	\N	ANYTIME	\N
4	Prospecção	1	\N	ANYTIME	\N
5	Usuário	\N	\N	ANYTIME	\N
2	Candidato	\N	\N	TODOS_FILHOS_FECHADOS	\N
\.


--
-- Name: tipos_processo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipos_processo_id_seq', 5, true);


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
105	132	3
106	132	5
107	132	85
108	133	2
\.


--
-- Name: usuario_atores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuario_atores_id_seq', 108, true);


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarios (id, email, nome, senha, login, admin, criacao) FROM stdin;
14	\N	Bruno Silva	teste123	bruno.silva	\N	\N
15	\N	Gabriel Prado	teste123	gabriel.prado	\N	\N
16	\N	Luciano Neucamp	teste123	luciano.neucamp	\N	\N
17	\N	Daniele Blanco	teste123	daniele.blanco	\N	\N
21	\N	Danilo Trindade	teste123	danilo.trindade	\N	\N
22	\N	Daniel Doro	teste123	daniel.doro	1	\N
95	mm	nn	kkk	lll	\N	\N
96	mm	nn	kkk	lll	\N	\N
97	mm	nn	kkk	lll	\N	\N
98	mm	nn	kkk	lll	\N	\N
99	novo email	novo usuario	nova senha	novo login	\N	\N
100	novo email	novo usuario	nova senha	novo login	\N	\N
4	bruno.siqueira@walmart.com	Bruno Siqueira	teste123	bruno.siqueira	1	\N
101	espirro	primeirao	s	l	\N	\N
94	babirondo@gmail.com	siqueira	s3nha	babirondo	\N	\N
126	email	nomee	teste123	novinho entao...	\N	\N
127	l	l	l	l	\N	\N
131	dsa	3	kn	m	\N	\N
132	dsa	3	kn	m	\N	\N
133	comator	comator	comator	comator	\N	\N
\.


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuarios_id_seq', 215, true);


--
-- Data for Name: workflow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow (id, workflow, posto_inicial, posto_final, penultimo_posto) FROM stdin;
1	Recrutamento e Seleção	1	280	7
27	Candidatos	301	\N	\N
28	Vagas	304	\N	\N
\.


--
-- Data for Name: workflow_campos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_campos (id, campo, maxlenght, inputtype, txtarea_cols, txtarea_rows, dica_preenchimento, valor_default, administrativo) FROM stdin;
203	Tecnologias	\N	list	\N	\N	\N	{configuracoes.tecnologias}	skills
204	Gestor demandante	\N	text	\N	\N	\N	\N	gestordemandante
202	Nome do Candidato	\N	text	\N	\N	\N	\N	nome
\.


--
-- Data for Name: workflow_dados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_dados (id, idpostocampo, valor, idprocesso, registro, idposto, idworkflowtramitacao) FROM stdin;
6822	202	Bruno	209	2016-07-21 00:38:28.775521	301	3027
6823	203	3	209	2016-07-21 00:38:28.776246	301	3027
6824	202	Trias	210	2016-07-21 00:57:14.417811	301	3028
6825	203	2	210	2016-07-21 00:57:14.418515	301	3028
6826	202	Siqueira	211	2016-07-21 00:57:22.706623	301	3029
6827	203	2,3	211	2016-07-21 00:57:22.707402	301	3029
6828	203	2	212	2016-07-21 00:59:29.66897	304	3030
6829	204	ssss	212	2016-07-21 00:59:29.669607	304	3030
6830	203	2	213	2016-07-21 00:59:36.083399	304	3031
6831	204	ssss	213	2016-07-21 00:59:36.084146	304	3031
6832	203	3	214	2016-07-21 02:43:57.380811	304	3032
6833	204	bauer	214	2016-07-21 02:43:57.381502	304	3032
6834	203	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,20,21,22	215	2016-07-21 02:44:15.576813	301	3033
6835	202	Stefany	215	2016-07-21 02:44:15.577473	301	3033
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 6835, true);


--
-- Name: workflow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_id_seq', 28, true);


--
-- Data for Name: workflow_posto_campos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_posto_campos (id, idposto, idcampo, obrigatorio) FROM stdin;
42	301	202	1
43	301	203	1
44	304	203	1
45	304	204	\N
\.


--
-- Name: workflow_posto_campos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_posto_campos_id_seq', 45, true);


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
299	27	2	Primeira avaliação	\N	1	L	3	\N	\N	\N	\N	\N
300	27	2	Segunda avaliaçÃo	\N	1	L	3	\N	\N	\N	\N	\N
301	27	2	Cadastrar novo candidato	\N	0	F	2	\N	\N	\N	\N	\N
298	27	2	BAse de Candidatos	\N	1	L	2	\N	\N	\N	\N	\N
302	27	2	Encaminhar para análise	\N	0	F	3	\N	\N	\N	\N	\N
303	28	2	Vagas	\N	1	L	1	\N	\N	\N	\N	\N
304	28	2	Incluir nova Vaga	\N	0	F	1	\N	\N	\N	\N	\N
305	28	2	Candidatos para esta vaga	\N	0	VagaXCandidato	2	\N	\N	\N	\N	\N
\.


--
-- Name: workflow_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_postos_id_seq', 305, true);


--
-- Data for Name: workflow_tramitacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_tramitacao (id, idprocesso, idworkflowposto, inicio, fim, id_usuario_associado) FROM stdin;
3027	209	298	2016-07-21 00:38:28.742073	\N	\N
3028	210	298	2016-07-21 00:57:14.381673	\N	\N
3029	211	298	2016-07-21 00:57:22.669838	\N	\N
3030	212	303	2016-07-21 00:59:29.631175	\N	\N
3031	213	303	2016-07-21 00:59:36.044661	\N	\N
3032	214	303	2016-07-21 02:43:57.344775	\N	\N
3033	215	298	2016-07-21 02:44:15.54201	\N	\N
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 3033, true);


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

