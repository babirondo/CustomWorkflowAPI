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
    regra_finalizacao character varying,
    relacionadoa integer
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
   FROM usuarios
UNION ALL
 SELECT p.id AS proprio,
    p_filhos.id AS filho,
    p_avo.id AS avo,
    ''::text AS status,
    p_bisavo.id AS bisavo,
    p.relacionadoa AS neto
   FROM (((( SELECT processos.id,
            processos.idpai,
            processos.idtipoprocesso,
            processos.inicio,
            processos.idworkflow,
            processos.status,
            processos.regra_finalizacao,
            processos.relacionadoa
           FROM processos
          WHERE (processos.relacionadoa IS NOT NULL)) p
     LEFT JOIN processos p_filhos ON ((p_filhos.idpai = p.relacionadoa)))
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
    atributo_valor character varying,
    agrupar integer
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
  WHERE (((ed.valor)::text = ANY (ARRAY[('3'::character varying)::text, ('4'::character varying)::text, ('5'::character varying)::text])) AND (ed.idfeaturecampo = ANY (ARRAY[3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 99])));


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
23	Go Lang
24	PLSQL
25	SQL Server
26	Oracle
27	GIT
28	Redis
30	Chef
29	Jenkins
31	Docker
7	Ruby on Rails
33	React
34	Express.js
\.


--
-- Name: tecnologias_id_seq; Type: SEQUENCE SET; Schema: configuracoes; Owner: postgres
--

SELECT pg_catalog.setval('tecnologias_id_seq', 35, true);


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
549	4	nodejs	101	2016-07-18 00:44:19.104799	13
550	55	php-bruno	101	2016-07-18 00:44:19.106279	13
551	54		101	2016-07-18 00:44:19.106934	13
552	53		101	2016-07-18 00:44:19.107354	13
553	52		101	2016-07-18 00:44:19.107772	13
554	51		101	2016-07-18 00:44:19.108157	13
555	50		101	2016-07-18 00:44:19.108595	13
556	49		101	2016-07-18 00:44:19.108982	13
557	48		101	2016-07-18 00:44:19.109366	13
548	1	primeirao	101	2016-07-18 00:22:56.67643	8
660	113	s	76	2016-07-18 00:50:01.2046	10
604	2	bruno.siqueira@walmart.com	4	2016-07-18 00:45:19.709092	12
661	112	s	76	2016-07-18 00:50:01.205228	10
606	4	2	4	2016-07-18 00:48:02.478617	13
663	113	bruno.siqueira	4	2016-07-18 00:51:05.505795	10
603	112	teste123	4	2016-07-18 00:45:19.707576	12
665	112	75	75	2016-07-18 00:56:27.787319	10
666	113	novinho entao...	126	2016-07-18 00:57:00.748021	8
669	1	nomee	126	2016-07-18 00:57:00.74957	8
668	2	email	126	2016-07-18 00:57:00.749154	8
659	3		4	2016-07-18 00:48:02.501319	13
658	99		4	2016-07-18 00:48:02.500946	13
657	5		4	2016-07-18 00:48:02.50052	13
656	6		4	2016-07-18 00:48:02.500131	13
655	7		4	2016-07-18 00:48:02.499716	13
654	8		4	2016-07-18 00:48:02.499345	13
653	9		4	2016-07-18 00:48:02.498909	13
652	10		4	2016-07-18 00:48:02.498317	13
651	11		4	2016-07-18 00:48:02.497678	13
650	12		4	2016-07-18 00:48:02.497035	13
648	14		4	2016-07-18 00:48:02.496276	13
647	15		4	2016-07-18 00:48:02.495905	13
646	16		4	2016-07-18 00:48:02.495529	13
645	17		4	2016-07-18 00:48:02.495163	13
644	18		4	2016-07-18 00:48:02.494808	13
643	19		4	2016-07-18 00:48:02.494442	13
642	20		4	2016-07-18 00:48:02.494069	13
641	21		4	2016-07-18 00:48:02.493678	13
640	22		4	2016-07-18 00:48:02.493312	13
639	23		4	2016-07-18 00:48:02.492928	13
638	24		4	2016-07-18 00:48:02.492547	13
637	25		4	2016-07-18 00:48:02.492183	13
636	26		4	2016-07-18 00:48:02.491811	13
635	27		4	2016-07-18 00:48:02.491427	13
633	29		4	2016-07-18 00:48:02.490676	13
632	30		4	2016-07-18 00:48:02.490305	13
631	31		4	2016-07-18 00:48:02.489918	13
630	32		4	2016-07-18 00:48:02.489561	13
629	33		4	2016-07-18 00:48:02.489196	13
628	34		4	2016-07-18 00:48:02.488837	13
627	35		4	2016-07-18 00:48:02.488471	13
626	36		4	2016-07-18 00:48:02.488078	13
625	37		4	2016-07-18 00:48:02.487676	13
624	38		4	2016-07-18 00:48:02.487299	13
623	39		4	2016-07-18 00:48:02.486921	13
622	40		4	2016-07-18 00:48:02.486548	13
621	41		4	2016-07-18 00:48:02.486141	13
620	42		4	2016-07-18 00:48:02.485744	13
618	44		4	2016-07-18 00:48:02.484999	13
617	45		4	2016-07-18 00:48:02.484616	13
616	46		4	2016-07-18 00:48:02.484259	13
615	47		4	2016-07-18 00:48:02.483863	13
614	48		4	2016-07-18 00:48:02.483397	13
613	49		4	2016-07-18 00:48:02.482954	13
612	50		4	2016-07-18 00:48:02.482472	13
611	51		4	2016-07-18 00:48:02.482024	13
610	52		4	2016-07-18 00:48:02.481595	13
609	53		4	2016-07-18 00:48:02.48122	13
608	54		4	2016-07-18 00:48:02.480729	13
607	55	4	4	2016-07-18 00:48:02.48005	13
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
605	1	Bruno Siqueira	4	2016-07-18 00:45:19.709827	12
619	43		4	2016-07-18 00:48:02.485371	13
634	28		4	2016-07-18 00:48:02.491049	13
649	13		4	2016-07-18 00:48:02.496643	13
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
321	303	+ Candidatos	305
324	300	Avaliar Candidato	309
325	299	Avaliar Candidato	310
328	308	( X ) Desistir deste candidato	313
326	308	Tenho Interesse ( >>> )	314
330	311	Desistir ( X )	313
331	306	Desistir deste candidato ( X )	313
323	306	Tenho Interesse ( >>> )	307
329	311	Contratar ( V )	315
332	298	Editar	301
\.


--
-- Name: posto_acao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('posto_acao_id_seq', 332, true);


--
-- Name: postos_campo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_id_seq', 227, true);


--
-- Data for Name: postos_campo_lista; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY postos_campo_lista (id, idposto, idpostocampo, atributo_campo, atributo_valor, agrupar) FROM stdin;
95	298	202	\N	\N	\N
96	298	203	\N	\N	\N
97	303	203	\N	\N	\N
98	303	204	\N	\N	\N
99	305	202	\N	\N	\N
100	305	203	\N	\N	\N
101	305	204	\N	\N	\N
104	306	204	\N	\N	\N
105	306	203	\N	\N	\N
106	306	202	\N	\N	\N
107	308	207	\N	\N	\N
108	308	202	\N	\N	\N
110	300	202	\N	\N	\N
111	299	202	\N	\N	\N
112	306	216	\N	\N	\N
113	306	219	\N	\N	\N
114	306	223	\N	\N	\N
115	306	213	\N	\N	\N
116	306	219	\N	\N	\N
117	306	220	\N	\N	\N
118	306	221	\N	\N	\N
119	306	222	\N	\N	\N
120	311	202	\N	\N	\N
121	311	204	\N	\N	\N
122	311	208	\N	\N	\N
123	311	213	\N	\N	\N
124	311	214	\N	\N	\N
125	311	215	\N	\N	\N
126	311	216	\N	\N	\N
127	311	219	\N	\N	\N
128	311	221	\N	\N	\N
129	311	223	\N	\N	\N
130	311	225	\N	\N	\N
131	305	219	\N	\N	\N
132	305	221	\N	\N	\N
133	305	223	\N	\N	\N
137	305	214	\N	\N	\N
138	305	216	\N	\N	\N
\.


--
-- Name: postos_campo_lista_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_lista_id_seq', 138, true);


--
-- Data for Name: processos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY processos (id, idpai, idtipoprocesso, inicio, idworkflow, status, regra_finalizacao, relacionadoa) FROM stdin;
343	\N	2	2016-07-25 23:53:59.702456	27	Em Andamento	\N	\N
344	\N	2	2016-07-26 00:02:45.752177	27	Em Andamento	\N	\N
345	\N	2	2016-07-26 00:05:53.546009	27	Em Andamento	\N	\N
346	\N	2	2016-07-26 00:07:30.885431	27	Em Andamento	\N	\N
347	\N	2	2016-07-26 00:10:05.808099	27	Em Andamento	\N	\N
348	\N	2	2016-07-26 00:11:12.680329	27	Em Andamento	\N	\N
349	\N	2	2016-07-26 00:12:39.908226	27	Em Andamento	\N	\N
350	\N	2	2016-07-26 00:13:12.617195	27	Em Andamento	\N	\N
351	\N	2	2016-07-26 00:13:48.333858	27	Em Andamento	\N	\N
352	\N	2	2016-07-26 00:14:21.532097	27	Em Andamento	\N	\N
353	\N	2	2016-07-26 00:15:01.368404	27	Em Andamento	\N	\N
354	\N	2	2016-07-26 00:15:34.38871	27	Em Andamento	\N	\N
355	\N	2	2016-07-26 00:16:12.970934	27	Em Andamento	\N	\N
356	355	3	2016-07-26 00:16:58.822174	27	Em Andamento	\N	\N
357	355	3	2016-07-26 00:16:58.863471	27	Em Andamento	\N	\N
358	354	3	2016-07-26 00:17:01.607302	27	Em Andamento	\N	\N
359	354	3	2016-07-26 00:17:01.647169	27	Em Andamento	\N	\N
360	353	3	2016-07-26 00:17:04.567492	27	Em Andamento	\N	\N
361	353	3	2016-07-26 00:17:04.607324	27	Em Andamento	\N	\N
362	352	3	2016-07-26 00:17:08.10941	27	Em Andamento	\N	\N
363	352	3	2016-07-26 00:17:08.149533	27	Em Andamento	\N	\N
364	351	3	2016-07-26 00:17:10.726021	27	Em Andamento	\N	\N
365	351	3	2016-07-26 00:17:10.766404	27	Em Andamento	\N	\N
366	350	3	2016-07-26 00:17:14.017098	27	Em Andamento	\N	\N
367	350	3	2016-07-26 00:17:14.058221	27	Em Andamento	\N	\N
368	349	3	2016-07-26 00:17:17.196312	27	Em Andamento	\N	\N
369	349	3	2016-07-26 00:17:17.408634	27	Em Andamento	\N	\N
370	348	3	2016-07-26 00:17:21.505917	27	Em Andamento	\N	\N
371	348	3	2016-07-26 00:17:21.548015	27	Em Andamento	\N	\N
372	347	3	2016-07-26 00:17:25.277899	27	Em Andamento	\N	\N
373	347	3	2016-07-26 00:17:25.320361	27	Em Andamento	\N	\N
374	346	3	2016-07-26 00:17:28.464019	27	Em Andamento	\N	\N
375	346	3	2016-07-26 00:17:28.505666	27	Em Andamento	\N	\N
376	345	3	2016-07-26 00:17:31.807809	27	Em Andamento	\N	\N
377	345	3	2016-07-26 00:17:31.84954	27	Em Andamento	\N	\N
378	344	3	2016-07-26 00:17:35.198771	27	Em Andamento	\N	\N
379	344	3	2016-07-26 00:17:35.240154	27	Em Andamento	\N	\N
380	343	3	2016-07-26 00:17:39.341073	27	Em Andamento	\N	\N
381	343	3	2016-07-26 00:17:39.382085	27	Em Andamento	\N	\N
382	\N	1	2016-07-26 00:37:18.268042	28	Em Andamento	\N	\N
383	\N	1	2016-07-26 00:38:02.576129	28	Em Andamento	\N	\N
384	\N	1	2016-07-26 00:38:58.420219	28	Em Andamento	\N	\N
385	\N	1	2016-07-26 00:40:38.633059	28	Em Andamento	\N	\N
386	\N	1	2016-07-26 00:41:22.37184	28	Em Andamento	\N	\N
387	\N	2	2016-07-26 00:44:14.367676	27	Em Andamento	\N	\N
388	387	3	2016-07-26 00:44:20.70823	27	Em Andamento	\N	\N
389	387	3	2016-07-26 00:44:20.74944	27	Em Andamento	\N	\N
391	\N	2	2016-07-26 00:58:47.150973	27	Em Andamento	\N	\N
392	391	3	2016-07-26 00:58:54.167249	27	Em Andamento	\N	\N
393	391	3	2016-07-26 00:58:54.212512	27	Em Andamento	\N	\N
394	\N	2	2016-07-26 01:04:53.095665	27	Em Andamento	\N	\N
395	394	3	2016-07-26 01:04:59.783884	27	Em Andamento	\N	\N
396	394	3	2016-07-26 01:04:59.825283	27	Em Andamento	\N	\N
397	\N	2	2016-07-26 01:08:35.013324	27	Em Andamento	\N	\N
398	397	3	2016-07-26 01:08:41.6316	27	Em Andamento	\N	\N
399	397	3	2016-07-26 01:08:41.672358	27	Em Andamento	\N	\N
400	\N	2	2016-07-26 01:12:47.67928	27	Em Andamento	\N	\N
401	400	3	2016-07-26 01:12:54.325633	27	Em Andamento	\N	\N
402	400	3	2016-07-26 01:12:54.384315	27	Em Andamento	\N	\N
403	\N	2	2016-07-26 01:26:22.916555	27	Em Andamento	\N	\N
404	403	3	2016-07-26 01:26:29.716888	27	Em Andamento	\N	\N
405	403	3	2016-07-26 01:26:29.768648	27	Em Andamento	\N	\N
406	\N	1	2016-07-26 20:03:51.838884	28	Em Andamento	\N	\N
407	\N	1	2016-07-26 20:14:35.788662	28	Em Andamento	\N	\N
408	386	6	2016-07-27 14:57:05.429564	28	Em Andamento	\N	345
409	386	6	2016-07-27 14:57:05.936753	28	Em Andamento	\N	346
410	\N	2	2016-07-27 23:04:52.58841	27	Em Andamento	\N	\N
390	386	6	2016-07-26 00:54:32.418072	28	Em Andamento	\N	345
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
33	306	305
34	308	307
35	299	302
37	312	313
38	311	314
39	312	315
\.


--
-- Name: relacionamento_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('relacionamento_postos_id_seq', 39, true);


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
6	Candidatura	1	\N	\N	\N
\.


--
-- Name: tipos_processo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipos_processo_id_seq', 6, true);


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
4	bruno.siqueira@walmart.com	Bruno Siqueira	teste123	bruno.siqueira	1	\N
\.


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuarios_id_seq', 410, true);


--
-- Data for Name: workflow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow (id, workflow, posto_inicial, posto_final, penultimo_posto) FROM stdin;
1	Recrutamento e Seleção	1	280	7
27	Candidatos	301	\N	\N
28	Vagas	304	312	\N
\.


--
-- Data for Name: workflow_campos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_campos (id, campo, maxlenght, inputtype, txtarea_cols, txtarea_rows, dica_preenchimento, valor_default, administrativo) FROM stdin;
204	Gestor demandante	\N	text	\N	\N	\N	\N	gestordemandante
202	Nome do Candidato	\N	text	\N	\N	\N	\N	nome
205	idvaga	\N	text	\N	\N	\N	\N	\N
206	idprocesso_candidato	\N	text	\N	\N	\N	\N	\N
207	Observações para encaminhar para entrevista	\N	textarea	30	7	\N	\N	\N
208	Tipo de Vaga	\N	text	\N	\N	\N	\N	\N
209	Enunciado e Regras do Teste Técnico	\N	text	\N	\N	\N	\N	\N
210	Job Description	\N	text	\N	\N	\N	\N	\N
211	Consultorias Destinatárias	\N	text	\N	\N	Separar os emails por ",". Exemplo: usuario@email.com, usuario2@email.com	\N	\N
213	Proposta inicial de produto-destino	\N	text	\N	\N	\N	\N	\N
215	link do Github	\N	text	\N	\N	\N	\N	\N
218	Comentários para solicitação de análise do teste técnico	\N	text	\N	\N	\N	\N	\N
220	Parecer Técnico	\N	text	\N	\N	\N	\N	\N
222	Parecer técnico	\N	text	\N	\N	\N	\N	\N
212	Tecnologias Secundárias	\N	list	\N	\N	\N	{configuracoes.tecnologias}	skills
217	Tecnologias que utilizou no teste	\N	list	\N	\N	\N	{configuracoes.tecnologias}	skills
223	Tecnologias que o candidato domina	\N	list	\N	\N	\N	{configuracoes.tecnologias}	skills
203	Tecnologias obrigatórias da vaga	\N	list	\N	\N	\N	{configuracoes.tecnologias}	skills
224	Motivo do desinteresse pelo candidato	\N	textarea	30	7	\N	\N	\N
225	Motivo de interesse no candidato	\N	textarea	30	7	\N	\N	\N
226	Valor/Hora	\N	text	\N	\N	\N	\N	\N
227	Data de Inicio	\N	text	\N	\N	\N	\N	\N
219	Nível de experiência avaliada	\N	text	\N	\N	Junior / PLeno / Senior	\N	senioridade2
221	Nivel de experiencia avaliada	\N	text	\N	\N	\N	\N	senioridade1
214	CV	\N	file	\N	\N	\N	\N	cv
216	Consultoria	\N	\N	\N	\N	\N	\N	consultoria
\.


--
-- Data for Name: workflow_dados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_dados (id, idpostocampo, valor, idprocesso, registro, idposto, idworkflowtramitacao) FROM stdin;
7284	202	Felipe Almeida	343	2016-07-25 23:53:59.779991	301	3173
7285	215	https://github.com/frontfelipe/walmart-cart-teste	343	2016-07-25 23:53:59.802657	301	3173
7286	216	mazza	343	2016-07-25 23:53:59.803239	301	3173
7287	217	4,14	343	2016-07-25 23:53:59.803628	301	3173
7288	223	3,4,11,14	343	2016-07-25 23:53:59.804039	301	3173
7289	202	Romero Gonçalves Dias	344	2016-07-26 00:02:45.831235	301	3174
7290	215	https://github.com/romerodias/walmart	344	2016-07-26 00:02:45.831883	301	3174
7291	216	Mazza	344	2016-07-26 00:02:45.832304	301	3174
7292	217	2	344	2016-07-26 00:02:45.832669	301	3174
7293	223	2,15	344	2016-07-26 00:02:45.833102	301	3174
7294	202	Wiliam Hiromitsu Kudaka	345	2016-07-26 00:05:53.612919	301	3175
7295	215	https://github.com/wkudaka/some-ruby-test-repository/	345	2016-07-26 00:05:53.613618	301	3175
7296	216	mazza	345	2016-07-26 00:05:53.614142	301	3175
7297	217	7	345	2016-07-26 00:05:53.614642	301	3175
7298	223	3,6,7,11	345	2016-07-26 00:05:53.615159	301	3175
7299	202	Luiz Junqueira	346	2016-07-26 00:07:30.926423	301	3176
7300	215	https://github.com/junqueira/shopapp e https://shopeng.herokuapp.com/	346	2016-07-26 00:07:30.92718	301	3176
7301	216	mazza	346	2016-07-26 00:07:30.927621	301	3176
7302	217	6	346	2016-07-26 00:07:30.928051	301	3176
7303	223	2,4,6	346	2016-07-26 00:07:30.928447	301	3176
7304	202	Gustavo Vieira	347	2016-07-26 00:10:05.865456	301	3177
7305	215	https://drive.google.com/a/avenuecode.com/file/d/0B-dYXZ2cOfG1NnpRbXBfTUxVQWs/view?usp=sharing	347	2016-07-26 00:10:05.866129	301	3177
7306	216	avenue code	347	2016-07-26 00:10:05.86655	301	3177
7307	217	1	347	2016-07-26 00:10:05.866952	301	3177
7308	223	1	347	2016-07-26 00:10:05.867389	301	3177
7309	202	Juliano Versolato	348	2016-07-26 00:11:12.734814	301	3178
7310	215	https://github.com/jversolato/Compromissos	348	2016-07-26 00:11:12.735557	301	3178
7311	216	mazza	348	2016-07-26 00:11:12.735969	301	3178
7312	217	1	348	2016-07-26 00:11:12.736409	301	3178
7313	223	1	348	2016-07-26 00:11:12.736832	301	3178
7314	202	Felipe Novaes	349	2016-07-26 00:12:39.944894	301	3179
7315	215	https://bitbucket.org/kamikazebr/raabbit - Android app https://bitbucket.org/kamikazebr/raabbitserver - Nodejs server	349	2016-07-26 00:12:39.945605	301	3179
7316	216	O2B	349	2016-07-26 00:12:39.946024	301	3179
7317	217	1,5	349	2016-07-26 00:12:39.946364	301	3179
7318	223	1,5	349	2016-07-26 00:12:39.946747	301	3179
7319	202	Diego Cezimbra	350	2016-07-26 00:13:12.654918	301	3180
7320	215	https://bitbucket.org/dicezimbra/projetodesafio-fcamara	350	2016-07-26 00:13:12.655741	301	3180
7321	216	FCAMARA	350	2016-07-26 00:13:12.656155	301	3180
7322	217	1	350	2016-07-26 00:13:12.656542	301	3180
7323	223	1	350	2016-07-26 00:13:12.656944	301	3180
7324	202	George Luiz de Souza Freire	351	2016-07-26 00:13:48.373993	301	3181
7325	215	https://github.com/GeorgeSouzaFreire/AgendaCompromisso	351	2016-07-26 00:13:48.374628	301	3181
7326	216	O2b	351	2016-07-26 00:13:48.374994	301	3181
7327	217	1	351	2016-07-26 00:13:48.375431	301	3181
7328	223	1	351	2016-07-26 00:13:48.375852	301	3181
7329	202	Lucas Caramelo	352	2016-07-26 00:14:21.568431	301	3182
7330	215	https://github.com/caramelool/SpiderMan	352	2016-07-26 00:14:21.569113	301	3182
7331	216	Ginga	352	2016-07-26 00:14:21.569533	301	3182
7332	217	1	352	2016-07-26 00:14:21.569949	301	3182
7333	223	1	352	2016-07-26 00:14:21.570349	301	3182
7334	202	Alex Zacarias Soares	353	2016-07-26 00:15:01.403961	301	3183
7335	215	https://bitbucket.org/asoares99/agendacompromissowalmart	353	2016-07-26 00:15:01.404498	301	3183
7336	216	mazza	353	2016-07-26 00:15:01.404912	301	3183
7337	217	1	353	2016-07-26 00:15:01.405307	301	3183
7338	223	1,2,3	353	2016-07-26 00:15:01.405705	301	3183
7339	202	Jose Cavalcanti	354	2016-07-26 00:15:34.426416	301	3184
7340	215	git@github.com:moraisholanda/heroes.git	354	2016-07-26 00:15:34.427151	301	3184
7341	216	ginga	354	2016-07-26 00:15:34.427576	301	3184
7342	217	1	354	2016-07-26 00:15:34.427979	301	3184
7343	223	1	354	2016-07-26 00:15:34.428389	301	3184
7344	202	Vitor Oliveira	355	2016-07-26 00:16:13.009279	301	3185
7345	215	https://github.com/victor-machado/Agenda.git https://github.com/victor-machado/agenda-services.git	355	2016-07-26 00:16:13.010077	301	3185
7346	216	Verotthi	355	2016-07-26 00:16:13.010558	301	3185
7347	217	1	355	2016-07-26 00:16:13.010999	301	3185
7348	223	1	355	2016-07-26 00:16:13.011398	301	3185
7349	218	Favor analisar.	356	2016-07-26 00:16:58.862006	302	3186
7350	218	Favor analisar.	357	2016-07-26 00:16:58.897161	302	3187
7351	218	Favor analisar.	358	2016-07-26 00:17:01.645665	302	3188
7352	218	Favor analisar.	359	2016-07-26 00:17:01.68206	302	3189
7353	218	Favor analisar.	360	2016-07-26 00:17:04.605909	302	3190
7354	218	Favor analisar.	361	2016-07-26 00:17:04.642083	302	3191
7355	218	Favor analisar.	362	2016-07-26 00:17:08.148083	302	3192
7356	218	Favor analisar.	363	2016-07-26 00:17:08.183874	302	3193
7357	218	Favor analisar.	364	2016-07-26 00:17:10.764957	302	3194
7358	218	Favor analisar.	365	2016-07-26 00:17:10.803445	302	3195
7359	218	Favor analisar.	366	2016-07-26 00:17:14.056373	302	3196
7360	218	Favor analisar.	367	2016-07-26 00:17:14.095331	302	3197
7361	218	Favor analisar.	368	2016-07-26 00:17:17.406228	302	3198
7362	218	Favor analisar.	369	2016-07-26 00:17:17.522934	302	3199
7363	218	Favor analisar.	370	2016-07-26 00:17:21.546508	302	3200
7364	218	Favor analisar.	371	2016-07-26 00:17:21.584924	302	3201
7365	218	Favor analisar.	372	2016-07-26 00:17:25.319019	302	3202
7366	218	Favor analisar.	373	2016-07-26 00:17:25.355415	302	3203
7367	218	Favor analisar.	374	2016-07-26 00:17:28.504123	302	3204
7368	218	Favor analisar.	375	2016-07-26 00:17:28.541014	302	3205
7369	218	Favor analisar.	376	2016-07-26 00:17:31.848293	302	3206
7370	218	Favor analisar.	377	2016-07-26 00:17:31.884519	302	3207
7371	218	Favor analisar.	378	2016-07-26 00:17:35.238605	302	3208
7372	218	Favor analisar.	379	2016-07-26 00:17:35.276898	302	3209
7373	218	Favor analisar.	380	2016-07-26 00:17:39.380562	302	3210
7374	218	Favor analisar.	381	2016-07-26 00:17:39.417021	302	3211
7375	219	pleno	376	2016-07-26 00:27:11.699024	309	3206
7376	220	cho que o nome dele eh William  [3:49]  nao conseguimos rodar aqui  [3:49]  a aplicacao noa subiu :disappointed:  [3:49]  nao *  [3:49]  instalei o docker aqui que eu nao tinha, mas a aplicacao nao subiu  [3:49]  porem eu gostei bastante da prova dele  Bruno Siqueira [3:50 PM]  como o classificaria?  maryfelvie [3:57 PM]  Olha, ele mandou bem no codigo em geral, olhando o codigo ele atendeu os requisitos solicitados na prova, se preocupou com tratamentos de erros, validacoes, separou bem as responsabilidades do codigo, criou chaves de configuracao dinamicas, usou recursos legais do ruby como o neo4j, comentou sobre o docker e a documentacao dele foi 100%  [3:57]  o unico ponto ruim foi que a aplicacao nao subiu	376	2016-07-26 00:27:11.699933	309	3206
7377	221	-	377	2016-07-26 00:27:40.265503	310	3207
7512	204	Marilene	407	2016-07-26 20:14:35.827671	304	3237
7513	208	Backend 	407	2016-07-26 20:14:35.828383	304	3237
7378	222	Prós Documentação bem feita e detalhada Usou container com consciência dos benefícios Usou um banco de dados baseado em grafos  Contras Usou form para receber dados Fez poucos commits Manteve código de acesso a banco relacional no código curl de exemplo para inclusão de rota não funciona e retorna erro com um HTML Log pobre Muito código comentado Achei trechos da query de busca de caminho de menor custo em buscas no google	377	2016-07-26 00:27:40.266407	310	3207
7379	221	Junior	375	2016-07-26 00:28:47.084457	310	3205
7380	222	Utilizou a linguagem Ruby On Rails para desenvolver o teste. Todas as telas e fluxos foram desenvolvidos, porém alguns fluxos um pouco complexos e com erros.  Critérios de avaliação:  Customização do front-end: utilizou o Twitter Bootstrap e não teve uma customização fina para as telas propostas. Dependência do framework: todos os controllers, models e views foram desenvolvidos utilizando o Scaffold do Rails. Alguns models não teriam a necessidade de serem utilizados, mas como foram auto-gerados para ter a tela referente ao fluxo, criou-se alguns models a mais. Padrões de projeto: nenhum padrão de projeto foi utilizado. Organização: Seguiu o modelo do RoR, o que já deixa o projeto bem organizado. Organização das camadas da App: as regras de negócio e consultar ao banco de dados foram inteiramente escritas no controller ou no model.  Avaliação:  O nível do candidato se aplicaria em um Full-stack Junior Ruby on Rails.	375	2016-07-26 00:28:47.085354	310	3205
7381	219	pleno	374	2016-07-26 00:29:03.961282	309	3204
7382	220	A Organização do projeto seguiu os padrão do Ruby On Rails, o candidato usou as rotas como API, mostrou conhecimentos como front-end com rails. O codigo que o candidato está bem enxuto e limpo, mostrou organização e soube seguir boas praticas, mas não teve nada que demostrasse que o candidato pudesse ser classificado como Senior. Também não demostrou nada que fizesse ser classificado como Junior, pois ele mostrou que tem conhecimento de boas praticas e soube usar on Ruby on Rails + Heroku para demostrar sua solução.  Então, o candidato está classificado como Pleno baseado nas informações na solução dele.	374	2016-07-26 00:29:03.962391	309	3204
7383	219	Junior	372	2016-07-26 00:29:26.115748	309	3202
7384	220	Código sem estrutura definida, falta de resposta ao usuário, uso de componentes antigos, camadas de layout desnecessárias. (Reprovado)	372	2016-07-26 00:29:26.116634	309	3202
7385	221	Junior	373	2016-07-26 00:29:44.690118	310	3203
7386	222	Código sem estrutura definida, falta de resposta ao usuário, uso de componentes antigos, camadas de layout desnecessárias. (Reprovado)	373	2016-07-26 00:29:44.691025	310	3203
7387	221	junior	371	2016-07-26 00:30:06.177092	310	3201
7388	222	Código sem estrutura definida, Async Task para conexões, código em português, layout sem usabilidade, CRUD incompleto. (Reprovado)	371	2016-07-26 00:30:06.178345	310	3201
7389	219	junior	370	2016-07-26 00:30:13.9105	309	3200
7390	220	Código sem estrutura definida, Async Task para conexões, código em português, layout sem usabilidade, CRUD incompleto. (Reprovado)	370	2016-07-26 00:30:13.911412	309	3200
7391	219	Junior pra pleno	368	2016-07-26 00:30:36.575964	309	3198
7392	220	Não consegui rodar o backend. Avaliando apenas o código: Código sem estrutura, métodos gigantes que tratam de tudo, de resto parece ok, porém conversei com um pessoal da ginga que já trabalhou com ele, ele foi demitido por alguma doidera, mas ninguém se lembra qual foi.	368	2016-07-26 00:30:36.576892	309	3198
7393	221	Junior pra pleno	369	2016-07-26 00:30:54.07111	310	3199
7394	222	Não consegui rodar o backend. Avaliando apenas o código: Código sem estrutura, métodos gigantes que tratam de tudo, de resto parece ok, porém conversei com um pessoal da ginga que já trabalhou com ele, ele foi demitido por alguma doidera, mas ninguém se lembra qual foi.	369	2016-07-26 00:30:54.072131	310	3199
7395	221	jr	367	2016-07-26 00:31:19.102075	310	3197
7396	222	Não consegui rodar o backend. Avaliando apenas o código: Classes criadas por outra pessoa, código sem estrutura definida, métodos com muitas funções, conexão feita com uma classe de terceiro cheia de código sem antigo e sem ser utilizado, Async Task. (reprovado)	367	2016-07-26 00:31:19.105475	310	3197
7397	219	jr	366	2016-07-26 00:31:25.894439	309	3196
7398	220	Não consegui rodar o backend. Avaliando apenas o código: Classes criadas por outra pessoa, código sem estrutura definida, métodos com muitas funções, conexão feita com uma classe de terceiro cheia de código sem antigo e sem ser utilizado, Async Task. (reprovado)	366	2016-07-26 00:31:25.895314	309	3196
7399	219	jr	364	2016-07-26 00:31:47.68888	309	3194
7400	220	Código sem estrutura definida, Async Task para conexões, código em português, código repetido, agenda do usuário pode ser acessado por qualquer usuário. (Reprovado)	364	2016-07-26 00:31:47.69877	309	3194
7401	221	jr	365	2016-07-26 00:31:57.824241	310	3195
7402	222	Código sem estrutura definida, Async Task para conexões, código em português, código repetido, agenda do usuário pode ser acessado por qualquer usuário. (Reprovado)	365	2016-07-26 00:31:57.840101	310	3195
7403	221	pleno	363	2016-07-26 00:32:18.90918	310	3193
7404	222	gostei	363	2016-07-26 00:32:18.910179	310	3193
7405	219	pleno	362	2016-07-26 00:32:26.551127	309	3192
7406	220	gostei	362	2016-07-26 00:32:26.552205	309	3192
7407	219	pleno	360	2016-07-26 00:32:52.447674	309	3190
7408	220	Código melhor organizado / Algumas coisas antigas que podem melhorar / Porém ainda não consegui rodar o serviço	360	2016-07-26 00:32:52.459165	309	3190
7409	221	pleno	361	2016-07-26 00:33:10.780406	310	3191
7410	222	Código melhor organizado / Algumas coisas antigas que podem melhorar / Porém ainda não consegui rodar o serviço	361	2016-07-26 00:33:10.781461	310	3191
7411	221	pleno	359	2016-07-26 00:33:25.413382	310	3189
7412	222	gostei	359	2016-07-26 00:33:25.414543	310	3189
7413	219	pleno	358	2016-07-26 00:33:31.470633	309	3188
7414	220	gostei	358	2016-07-26 00:33:31.471612	309	3188
7415	219	jr	356	2016-07-26 00:33:53.478858	309	3186
7416	220	Me parece um bom programador, mas sem muito conhecimento de específico de android.	356	2016-07-26 00:33:53.479784	309	3186
7417	221	jr	357	2016-07-26 00:34:00.181084	310	3187
7418	222	Me parece um bom programador, mas sem muito conhecimento de específico de android.	357	2016-07-26 00:34:00.182357	310	3187
7419	221	pleno	379	2016-07-26 00:35:11.1619	310	3209
7514	209	-	407	2016-07-26 20:14:35.828777	304	3237
7515	210	-	407	2016-07-26 20:14:35.829189	304	3237
7516	211	todas	407	2016-07-26 20:14:35.829569	304	3237
7517	213	stargate	407	2016-07-26 20:14:35.829937	304	3237
7518	212	5,6,28,30,29,31	407	2016-07-26 20:14:35.830323	304	3237
7519	203	2,25,26,27	407	2016-07-26 20:14:35.830714	304	3237
7520	206	345	408	2016-07-27 14:57:05.87543	305	3238
7521	205	386	408	2016-07-27 14:57:05.891935	305	3238
7522	206	346	409	2016-07-27 14:57:05.989663	305	3239
7523	205	386	409	2016-07-27 14:57:05.990065	305	3239
7526	216	alterado consultoria walmart	410	2016-07-27 23:04:52.649386	301	3240
7527	217	6	410	2016-07-27 23:04:52.649771	301	3240
7528	223	4	410	2016-07-27 23:04:52.650123	301	3240
7525	215	alterado github.git	410	2016-07-27 23:04:52.648928	301	3240
7529	214	Deiwson Pinheiro dos Santos.pdf|||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WFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APf6KKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiobm5jtLeSeZgscal2J7AUXsNK7siQuoGScAdzUMd/aTPsiuYZGH8KOCa8G8UeMNQ8RXbjzXisQf3cCnAx6t6mudSR43DxuysDkMpwRXI8Vroj26eSycbzlZn1EDmlrzL4eeNbi+uBpGpymSUgmCZurY6qfXjvXpg5FdFOopq6PKxGHnh58kxaKKKswCiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooADxXP694x0jw9Ikd3MWmb/llGNzAep9KwfG/j1dGDadpzq9+R879RD/ia8cnnluZ3mnkaSVzlnY5JNctXEcrtE9fA5Y6q56ui/M97svH/AIaviAmorEx/hmUp+p4/WuhhuYbiMSQypIh6MjAg/lXy/Vux1O+02XzLK6lgb1RiKiOKl1R1VMlg/wCHK3qfTIINc7478z/hC9T8r73lDOPTcM/pmuD0P4q3lsVi1eAXMfQzR/K4+o6H9K9HstV0rxPp0gtp0nhkQpInQgEdCOorZVI1ItI8yeFrYSopzWifyPnKiuj8T+EL/wAO3b5jeWyJ/dzqMjHofQ1zyI8jhEUsx4AAyTXA007M+rp1IVI88XdGv4T8z/hLNL8rO/7QvT07/pX0WOleY/DzwXcWFyNZ1OMxSKp8iJuoz1Y+nHatzxB8RtK0UtBbH7bdDgpGflX6t/hXZRtTheXU+fzC+KrqFFXsdluFZ1/r+k6WP9Nv4IT/AHWfn8uteJax4713V2ZWujbwn/llB8o/E9TXNFizFmJJPUmpliv5UXRyVvWrK3oe5yfEzw0s6xLcyupODIITtHvzz+ldXb3MN1brPBIskTjKupyCK+YK6Xwp4wvPDVyFBM1kx/eQE9PcehpQxLv7xpiMnjyXovXz6n0BRVLS9UtdXsY7yzlEkMg4Pcex96u12J3V0eBKLi7MKKKKYgooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAQnArivHvjAaDafZLNx/aE6/Kf+eS/3vr6V0uu6tBomjz6hcfdiHC92bsPzr521LULjVdRmvbp900rbmPp7D2rmxFXlXKtz1cswarT9pP4V+LKzu0js7sWZjkknkmm0UVwn04U5UZ2CopZicAAZJqxY2E1/MUiwqoN0kjnCxr6k1cfUYdPVoNJ3KTw92wxI/8Au/3B9OaCXLW0dw/siO0GdVuhantCi+ZKf+A5wv4kVPZ67b6PcifSbN1mX7s08xY/98rgfgc1hEknJPJop3tsS6fMrTd/yPaPCPxAttb2WOpBIL08Kf4Jfp6H2rqLyXStDtZL64WC3jQcuIwCfYY5Jr5wBIIIOCOhFdHLqV14psILO6uXa+tlIgDNxMPT/f8AT16da3jiHaz1Z5NfKoc6lB2j1/r+rF7xV8QL7XGe2sy1rY9NoPzSf7x/pXG0pBBwRgikrCUnJ3Z61KjClHlgrIKKKUAsQFBJPYUjQSitKPQNUdA5tHiQ9GmIjH5sRTv7DlH+svdPjPoblT/LNFmR7SHc0fB3iubw1qI3FnsZTiaP0/2h7ivera4iubaOeBw8UihlZehBr5zOiy8iO8sJD6LcqM/nivR/htfajab9IvYma35eCVWDqp6lcrnr1rpoVHF8rPHzTDQnH20N1v5npdFFFdx88FFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFVNSvk03Tri8k+5DGXP4Ck3ZXGk27I8m+KWum71WPSYW/dWo3SY7uR/Qfzrz6pru5lvLua5mbdJK5dj7k1DXlylzSufa4eiqNJU10CrWm6fcarqENlapvmlbCj09SfaqtexfDLw4LHTDq9wn+kXQ/d5HKx/8A16dODnKxGMxKw9Jz69DpPD3hWy0HSRZpGkrOP38jDPmH/D2rO1n4caJqqs8MX2K4PSSHp+K9P5V2FFej7ODVrHyaxVZTc1J3Z8+eIvBmq+HWLzR+da54uI/u/j6VztfUMkMckTRyIGRhhlYZBFeU+Nfh2LZZNS0WMmMfNLbDqo9V9vauSrh3HWJ7uCzVVHyVtH3PNKUEqQQSCDkEUlFcx7BsXgGrWTaigH2uHAu1A+8OgkH8j7896y4YJbiZIYY2kkc4VFGSTWt4Wsr++1yGKwh80niUN93yzw24+mK9q8N+ENM8Oxs1uhkuGJ3Tvy2PQela06TqHn4nGwwi5d30Rwfh74WT3KrPrMxgU8iCPlj9T0FejaX4b0nRkAsbGKJh/HjLfmea1sYpa7YUYx2Pnq+NrV37z07dDxz4jeEmsLhtYtAzW0rfvlzny2Pf6GvPa+nby0gvbOW2nQPDKpV1PcV87eItGl0HW7iwkyVQ5jYj7ynoa5a9Pld1sz28rxjqw9lPdfkZdS21zNaXCTwOySIdysp6GoqK5z1mr6M+j/Durx65oltfpgGRPnA/hYcEfnWtXlPwk1YiW80mRuGAmiHv0b+lerV6dKfNBM+NxlD2FaUOnQKKKK0OUKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigArifihf8A2Twm0CnDXUqx/gPmP8q7avKvjDcHzdLtgeAskh/QD+tZV3amzty6HPiYr5/ceX0UUV5p9eaGh6a2r63Z2C/8tpAGPovUn8s19IwRJBAkUahURQqqOwFeNfCmyE/iaW5I/wCPeAkH0LcfyzXtA6V24WPu3Pm85quVVQ7L8xaKKK6jxwooooA8g+I3g5bJ21nT49tux/0iNeiE/wAQ9jXBWFjcalfQ2dqheaVtqrX0tc28VzbyQTIHikUq6noQa5Hwh4Jj8O397dSESO7lbdu6x/4n+lcdSheemzPcwuaclBxnrJbef/DGx4Y8NWvhrTVt4QGmYZmmxy7f4VuUUV1xioqyPGnOVSTlJ3bCiiimQFebfFnSBNp9tqqL88DeXIQOqnp+v869JrG8VWY1DwzqNsRktAxA9xyP5VnVjzQaOnB1XSrxl5nznRRRXmH2ZveDL86d4t0+bOFaXy2+jcf1r6GXpXy9E7RzJIpwysGB+lfTttL59rFKP+WiBvzGa7MK90fP51C0oT76EtFFFdZ4YUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUU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RYLlfUZ3tdOuJ4oWmkjjZkjQZLkDgD614p8LfCGtQ+NpdY1vT7i38qN3Vpkxvkbjj8Ca9zIzRtFFgTBuleBweF9d8NfFr+0LDSrqXTkvNwljjyvlP16egY/lXvvWk2iiwJi1w/xA0291B7H7HbSTbA+7YM4ziu4pMUwRQ0SKSDRLKKVCkiQqGU9QcVoUgAFLQI848Y6Dqk+vfb7K3eZHVcGMZKkVU8/xv2F9/wB+x/hXqOBRilYq5V0wzHTrY3O7zzEvmbhzuxzU88MdxC8UqB43GGU9CKfjFLTJPNdX8B3tpcm40h/MjzlU3bXT8e9GlHxdFqdqlx9tNuJFD7xkbc8816TijFKw7geleca1pGozeOvtcVnM9v50TeYq8YAXP8jXpFJgUNAmLXEfEDTb3UG0/wCx2sk+wSbti5xnbj+VdvSYFMEZ2gRSQaDYwyoUkSEBlI5BrSpAMUtAgooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAMrxDcXVrpDy2e4SBl3Mi7mVc/MQO5xRokqz2rSR6k19GT8ruoDJ7HAH8qt332z7ODZGLzQ2cS5wR6cdKoaPps9pc3t3cmJZbplJjhB2rtBH5nNIfQmfV4Ibi9hlVkNrEJST0ZT3H5Yq1bXQmsI7pkaMOm8qeoGM1z/iWx+2atpkUbFXuC0cwA+9EMMc/l+tdIwPlMEwGxhc9KAKOk6o2qJ5y2kkUDLujkZlIYfgeD9ar6tql3ZatY28Fo8yTbt20rlsDOBk8Y60zR9JubTUpr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UUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRketABRRRQAUUZozQAUUUUAFFFFABRRmigAorz7xn8TP+ER1uLTjpRuvMiEnmfaNmMkjGNp9K9AUnHPWi4WFooooAKKM1V1C4a00+5uEALRRNIAehIBNAFqivPvh18QL3xneX0N1ZwW628aspiJOckjnNeg0AFFFFABRRkUUAFFFFABRRRQAUUZooAKKRiQuRXm3gn4kah4o8Tz6VcWVtDHFG7h4ycnawA6/Wi4WPSqKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAOe8c6ld6P4M1LULGXyrqFFMb7Q2DuA6HjvXluiaz8QvGHh69ubXV4oktGJaQIqSSHGdq7V4x/WvR/iZ/yTrWP+uS/+hrXI/Bsf8URrH/Xdv/RYqXuUtjnfCHibxz4qWbRLHVFWQDzWvJgN0aDjGQM8kj34rQ8B+L/EkXj3/hHNZvWu1d5In805KOik5B9Plqr8Cx/xUGqf9eo/9DFV9C/5L63/AF+3H/oD0DNfxl4y8RX3jr/hF9AuhaASLD5igBncgE5bGQBnHHpWfceJfF/gTxfbWGr6uNRgk2NIpO4FGOOCQCCOa2vHXxD1SDxA3hvw3CPtgYRvMEDMXI+6gPHGeprzfxPo+r6R4htV1y5M9/cKk0hLlyuWwAT36dqQHtniy28ey6qjeGb62gsfKAZZVQnfzn7yk+ledweNvHg8YQ6DLqsdxMLlYpVht4iDz8wB2DoM/lXqfjzxOvhbwxPdIw+1yfurdT3c9/wHNcP8GvDDETeJ71S0kpKWzN1773/E8fnTEbevW3xMOsXkuk6nZw6ZuzCsix5VcDrlCfXvXMeAvG/i7X/GltYXeoi5sl3tcbII1G0KcHIUHG7FdL8XfFX9j6ANKtpMXd+CrEdUiH3j+PT86n+FHhX+wfDYvriPF7fgO2eqIPur/X8fagOhxo8U+LfHHjC40zQ9TGn20Rdkx8uEU4yxAySf61b8JeLvEemfEH/hGNbvhfo0phZzyVbGQQ2M46cGoda8feIfFXiCTQvCUfkRbmTzUwHcDqxY/cX6c/yrnPDem3GkfF6x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z4m8CR63pDaFcTm/i8oSIjMoxuG4EAgjDHjiuy+GvhLUtG8La3c31s8VxfwlIYWHz7QrdR2JLdPavWMCjaPSiwXPIfg5oOraLqGqPqenXNoskSBDNGV3EE9KqeB/D2s2PxTutQutMuobR3uCszxkKck45969pwKMCiwXPM/Hmp+OrTxDFF4biumsDEpcx2qyDdk55Kntitv4j+HbnxL4QltrJA91DIs0Sk434yCPrgmuxwKMCiwXPnCa58TX3g6z8Gjw9d7recuJPKbLckgYxgcsec16fF4LuR8Ij4abb9taEuRnjzN+8DP1wK9AwKMCiwXPANB8QeJfCXh6+8PSeGruV5S+yQow8ssMHgKd35iuw+EPhW/0LTr6+1K3eCa7KCONxhgi55I7ZJ/SvT8CjAosFzxX4YeHdZ0vxzd3d9pl1b27wyBZJIyqklgRzRceHdZb42DVBpl0bAXqP9o8s7Nu0DOfSvatoowKLBc8X+Lnh7WNY8TWc+nabdXUSWwVnijLAHcTiu+8aXWu2nhTzPDqSnUQ8YAjiEh29+CDXVYFGBRYLnLeBbvXrvw35viNJV1DzXBEkQjO3jHAA968k8M6d4s8K+I7rWovDt3NEiuHiZSnmIx/hODz0PSvoTAo2iiwXPCvAmj6xr3xJfxFf2E1rCkjzuXQqNxBAUZ69f0q58TPDus6n49tLux0y6uLdYog0kUZZQQxJ5r2nAowKLBcWiiimIKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigBN3NGayda0m51VYRBqt3p+wkk25AL59c1xOn6frF54w1bRW8UaosVlHG6SBhubcoPPHvSuOx6YGzS1lW3l6Bo6/2hqbSLFnddXTgFskkZP6VZ0/VLHVITLY3cNzGDgtG4OKBFsNmlrkvA9/d30GqtdXEkxiv5Y0LnO1R0ArZHiHSTqBsBqVsbrO3yvMG7Ppj1ouOxpk4oByK4zx3rc1nFYWNlqSWk11dLHNIrLvjQ859vrXQ2s9vpmixSXOpCaGNBm7mcfP7k9KLhY06KoadrOnasGNhewXIT73lODinXerafYrI1zfW8Iix5m+QDbnpn60xF2iqlhqVnqcHn2V1FcRZxvjYEZqveeINJsLsWt1qVtDOekbyAGgDToqKW5t4IvNmnijj4+d3AHPuakBBAIIIPQigBaKKKACikzXCi58R654p1u107Xhp9nYPHGimzjl3Er83JweoP50Ad3RWVo9tqlnbyJqmqjUZC2VkFusO0Y6YHWuT0KTxX4ltJ9Rg8TLZ25uJEiiNhHJ8oPHPFK47HoNFU9MhvLewihv7z7ZcrnfOIhHv5OPlHA4wKj1jVY9HsWu5YbiZQQuyCPe2T7UxF8HNLXBeDfEd7r3i7WfOWeC2jiTyraXgx++OxPX8a3fEnihfD4VBYXl3M6FkWCIsv4t2pXHY3wcnFLXJ/DvUbvVfCsd3eztNM00gLMcnGeldZTEJuoByK89s5Na8Y6rqkkWsT6bYWc5t4Ut1G5mHUsf89a0fCmu37xazYarMJrnSJNrThQPMUgkHHr8ppXHY7KivPvDyeMNe0O21M+KlthOGIi/s6J8AMR149K1/E+s33hnwcbgzrc6gAkImMYUM56ttHHqcUXCx1IOaCcV5zqy+IvCGm2+tS67NfFZEW7tpUXYQx52+mK0vE+r6lc6zpOg6Rc/ZJL9GlkudoLJGBnjPfg/pRcLHaA5NLXBJcav4X8V6XYXOqzajYakWjHngb43GO47ciu8HSgGKaTdXG+K9U1OTXtL8O6Xc/ZJbwNJLchQSiL6e/B/Sqq3Gr+F/FWl2Fzqs2pWGpFox54G+Nxjv6cii4WO8JxQDmuJ1K91TX/F02g6fqEmn2tlEslzNEoLuzYIUE9Bg07RNS1PSfFU3hzVL43sbQfaLW4dQHwOqn17/AJUXCx2m4UteeaWdb8ZpdarDrk+nWglaO0hgUYwP4m9c1c0XxZd/8Itq0+oBXv8ASWeObaMCQjofbNFwsdtuFLXm1taeKL7w0fEJ8RTx3jxG5jtljXygoGQpH0rsvC+rtrvhuy1J0CPMh3qOgYEqcfiKEwaNeiiimIKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAENcRof/JVPE//AFxt/wD0Ba7c1xmi286fE7xJM0MixPDAEkKkK2EXOD3pMaM/xrqFsnjHRbTULea5sYopLh4Io/MLvyFyvfGKj8OXEEnxDmn0zT7qzsbizxKsluYlMin06Dir/itjo3izSPEcsUj2UUclvcsi7jGDna2PTJ/SrWi+ILnxD4nml095G0KGALvaLaJJSeoJG7gUhmHod7Jp3hDxZdxHEkV5cFT6HtWBcTaPP4Ehs7PRr46mqJIlyLQ5MmQSd/Ug810+g6RcXvhfxPYPE8clzdziPepGc9Dz2qnB4zeDwnBo2nx3KeI40W3W38jJRgQCxyNuMUDHeL9OtLw+Gb64tIzdXlzClyzLguCvINXfENhbXPi/w14cESppiJJO0C/dO0HAx6cfrVnxhbXch8MAo80sd9GZmRCRnHJOOgzR4x83SvEeieIxDJLbWnmRXPlrkojDAOPxP6UCK2u2VvoPjjw7e6fClt9rke2nSJQquuBjIHHemWWk2Wp/FTX5LyBJ/IigKLIMqCUXnHSh9Sg8Z+MtGfShJLYaazzzXJjKruIG1RkDnIrS0W3mT4keJJnhkWJ4rcI5UhWwgzg96AKfhS3h03xt4rtbZRFbRmF1jUcKSpJwPxNcvo+qaNfeHr9t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wWz6fOkwthcqzXDA8kN0UfU960df07Wjr2j+IdN05bme3haOa0aZUI3Dsx44ya7XaPSjAosFzidK0fXpvGy+INTit4I2tWiECSbjHzwM9/XNX9P0O5i8Xa7qM6obS/jjSMBsk4UA5HaunwPSjA9KLBc87sLPxf4b06bRNP02G9twzfZbw3Cp5asSfmU8nGe1dZ4V0X/hH/Dtrp7MHkQFpXH8Tk5P+H4VsYFL0osFwooopiMzxBpKa5oV3prttE6YDY+6eoP5gVy1lc+NtO02PTRoNvcSQoI0vPtiqhA4BKnk13lJgUrDucfYeFbiw8FX2meYkt/eLI8smcKZH/pW34Y0+fSvDVhYXO3zoIgj7TkZ+tauBSgYFFguFFFFMQUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAVFJbxTKRLGjg9mXNS0UmrjTa2MC98GaBf5M2mwhj/Enyn9K5+6+FenEl7C9ubR+3O4Cu/oqHRg90dEMZXh8MmeSS/DjXLidYJ9QL22777AE4+ma9N0bTI9H0i20+JiyQLtDHqe9XcClpU6MYO6HXxlWvFRnsgooorU5QooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACivKP+Fz/wDUA/8AJz/7Cj/hc/8A1AP/ACc/+wrL29Pudv8AZ2J/l/Ff5nq9FeUf8Ln/AOoB/wCTn/2FH/C5/wDqAf8Ak5/9hR7en3D+zsT/AC/iv8z1eivKP+Fz/wDUA/8AJz/7Cj/hc/8A1AP/ACc/+wo9vT7h/Z2J/l/Ff5nq9FeUf8Ln/wCoB/5Of/YUf8Ln/wCoB/5Of/YUe3p9w/s7E/y/iv8AM9Xoryj/AIXP/wBQD/yc/wDsKP8Ahc//AFAP/Jz/AOwo9vT7h/Z2J/l/Ff5nq9FeUf8AC5/+oB/5Of8A2FH/AAuf/qAf+Tn/ANhR7en3D+zsT/L+K/zPV6K8o/4XP/1AP/Jz/wCwo/4XP/1AP/Jz/wCwo9vT7h/Z2J/l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hY9rorxT/hoH/qWf/J//AO10f8NA/wDUs/8Ak/8A/a6LhY9rorxT/hoH/qWf/J//AO10f8NA/wDUs/8Ak/8A/a6LhY9rorxT/hoH/qWf/J//AO10f8NA/wDUs/8Ak/8A/a6LhY9rorxT/hoH/qWf/J//AO10f8NA/wDUs/8Ak/8A/a6LhY9rorxT/hoH/qWf/J//AO10f8NA/wDUs/8Ak/8A/a6LhY9rorxT/hoH/qWf/J//AO10UXCx57RRRXmH2YUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAVs+FP+Rr0v/r4T+dY1bPhT/ka9L/6+E/nQtyKvwP0PoPxB/wAi5qn/AF6S/wDoBr46r7F8Qf8AIuap/wBekv8A6Aa+Oq9JnyCCiiikMKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAOpooorzj7EKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAK2fCn/I16X/18J/OiihbkVfgfofQfiD/AJFzVP8Ar0l/9ANfHVFFekz5BBRRRSGFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFAH//ZDQplbmRzdHJlYW0NCmVuZG9iag0KNiAwIG9iag0KPDwvVHlwZS9FeHRHU3RhdGUvQk0vTm9ybWFsL2NhIDE+Pg0KZW5kb2JqDQo3IDAgb2JqDQo8PC9UeXBlL0ZvbnQvU3VidHlwZS9UcnVlVHlwZS9OYW1lL0YxL0Jhc2VGb250L0FCQ0RFRStDYWxpYnJpL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZy9Gb250RGVzY3JpcHRvciA4IDAgUi9GaXJzdENoYXIgMzIvTGFzdENoYXIgMzIvV2lkdGhzIDE1OCAwIFI+Pg0KZW5kb2JqDQo4IDAgb2JqDQo8PC9UeXBlL0ZvbnREZXNjcmlwdG9yL0ZvbnROYW1lL0FCQ0RFRStDYWxpYnJpL0ZsYWdzIDMyL0l0YWxpY0FuZ2xlIDAvQXNjZW50IDc1MC9EZXNjZW50IC0yNTAvQ2FwSGVpZ2h0IDc1MC9BdmdXaWR0aCA1MjEvTWF4V2lkdGggMTc0My9Gb250V2VpZ2h0IDQwMC9YSGVpZ2h0IDI1MC9TdGVtViA1Mi9Gb250QkJveFsgLTUwMyAtMjUwIDEyNDAgNzUwXSAvRm9udEZpbGUyIDE1OSAwIFI+Pg0KZW5kb2JqDQo5IDAgb2JqDQo8PC9UeXBlL0ZvbnQvU3VidHlwZS9UcnVlVHlwZS9OYW1lL0YyL0Jhc2VGb250L0FCQ0RFRStWZXJkYW5hL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZy9Gb250RGVzY3JpcHRvciAxMCAwIFIvRmlyc3RDaGFyIDMyL0xhc3RDaGFyIDI0NS9XaWR0aHMgMTYzIDAgUj4+DQplbmRvYmoNCjEwIDAgb2JqDQo8PC9UeXBlL0ZvbnREZXNjcmlwdG9yL0ZvbnROYW1lL0FCQ0RFRStWZXJkYW5hL0ZsYWdzIDMyL0l0YWxpY0FuZ2xlIDAvQXNjZW50IDEwMDUvRGVzY2VudCAtMjA3L0NhcEhlaWdodCA3NjUvQXZnV2lkdGggNTA4L01heFdpZHRoIDIwMDYvRm9udFdlaWdodCA0MDAvWEhlaWdodCAyNTAvU3RlbVYgNTAvRm9udEJCb3hbIC01NjAgLTIwNyAxNDQ3IDc2NV0gL0ZvbnRGaWxlMiAxNjEgMCBSPj4NCmVuZG9iag0KMTEgMCBvYmoNCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1RydWVUeXBlL05hbWUvRjMvQmFzZUZvbnQvQUJDREVFK1ZlcmRhbmEtQm9sZC9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcvRm9udERlc2NyaXB0b3IgMTIgMCBSL0ZpcnN0Q2hhciAzMi9MYXN0Q2hhciAyMzQvV2lkdGhzIDE2NyAwIFI+Pg0KZW5kb2JqDQoxMiAwIG9iag0KPDwvVHlwZS9Gb250RGVzY3JpcHRvci9Gb250TmFtZS9BQkNERUUrVmVyZGFuYS1Cb2xkL0ZsYWdzIDMyL0l0YWxpY0FuZ2xlIDAvQXNjZW50IDEwMDUvRGVzY2VudCAtMjA3L0NhcEhlaWdodCA3NjUvQXZnV2lkdGggNTY4L01heFdpZHRoIDIyNTcvRm9udFdlaWdodCA3MDAvWEhlaWdodCAyNTAvU3RlbVYgNTYvRm9udEJCb3hbIC01NTAgLTIwNyAxNzA3IDc2NV0gL0ZvbnRGaWxlMiAxNjUgMCBSPj4NCmVuZG9iag0KMTMgMCBvYmoNCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUwL0Jhc2VGb250L1N5bWJvbE1UL0VuY29kaW5nL0lkZW50aXR5LUgvRGVzY2VuZGFudEZvbnRzIDE0IDAgUi9Ub1VuaWNvZGUgMTY4IDAgUj4+DQplbmRvYmoNCjE0IDAgb2JqDQpbIDE1IDAgUl0gDQplbmRvYmoNCjE1IDAgb2JqDQo8PC9CYXNlRm9udC9TeW1ib2xNVC9TdWJ0eXBlL0NJREZvbnRUeXBlMi9UeXBlL0ZvbnQvQ0lEVG9HSURNYXAvSWRlbnRpdHkvRFcgMTAwMC9DSURTeXN0ZW1JbmZvIDE2IDAgUi9Gb250RGVzY3JpcHRvciAxNyAwIFIvVyAxNzAgMCBSPj4NCmVuZG9iag0KMTYgMCBvYmoNCjw8L09yZGVyaW5nKElkZW50aXR5KSAvUmVnaXN0cnkoQWRvYmUpIC9TdXBwbGVtZW50IDA+Pg0KZW5kb2JqDQoxNyAwIG9iag0KPDwvVHlwZS9Gb250RGVzY3JpcHRvci9Gb250TmFtZS9TeW1ib2xNVC9GbGFncyAzMi9JdGFsaWNBbmdsZSAwL0FzY2VudCAxMDA1L0Rlc2NlbnQgLTIxNi9DYXBIZWlnaHQgNjkzL0F2Z1dpZHRoIDYwMC9NYXhXaWR0aCAxMTEzL0ZvbnRXZWlnaHQgNDAwL1hIZWlnaHQgMjUwL1N0ZW1WIDYwL0ZvbnRCQm94WyAwIC0yMTYgMTExMyA2OTNdIC9Gb250RmlsZTIgMTY5IDAgUj4+DQplbmRvYmoNCjE4IDAgb2JqDQo8PC9UeXBlL0ZvbnQvU3VidHlwZS9UcnVlVHlwZS9OYW1lL0Y1L0Jhc2VGb250L0FyaWFsTVQvRW5jb2RpbmcvV2luQW5zaUVuY29kaW5nL0ZvbnREZXNjcmlwdG9yIDE5IDAgUi9GaXJzdENoYXIgMzIvTGFzdENoYXIgMzIvV2lkdGhzIDE3MSAwIFI+Pg0KZW5kb2JqDQoxOSAwIG9iag0KPDwvVHlwZS9Gb250RGVzY3JpcHRvci9Gb250TmFtZS9BcmlhbE1UL0ZsYWdzIDMyL0l0YWxpY0FuZ2xlIDAvQXNjZW50IDkwNS9EZXNjZW50IC0yMTAvQ2FwSGVpZ2h0IDcyOC9BdmdXaWR0aCA0NDEvTWF4V2lkdGggMjY2NS9Gb250V2VpZ2h0IDQwMC9YSGVpZ2h0IDI1MC9MZWFkaW5nIDMzL1N0ZW1WIDQ0L0ZvbnRCQm94WyAtNjY1IC0yMTAgMjAwMCA3MjhdID4+DQplbmRvYmoNCjIwIDAgb2JqDQo8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMC9CYXNlRm9udC9BQkNERUUrVmVyZGFuYS9FbmNvZGluZy9JZGVudGl0eS1IL0Rlc2NlbmRhbnRGb250cyAyMSAwIFIvVG9Vbmljb2RlIDE2MCAwIFI+Pg0KZW5kb2JqDQoyMSAwIG9iag0KWyAyMiAwIFJdIA0KZW5kb2JqDQoyMiAwIG9iag0KPDwvQmFzZUZvbnQvQUJDREVFK1ZlcmRhbmEvU3VidHlwZS9DSURGb250VHlwZTIvVHlwZS9Gb250L0NJRFRvR0lETWFwL0lkZW50aXR5L0RXIDEwMDAvQ0lEU3lzdGVtSW5mbyAyMyAwIFIvRm9udERlc2NyaXB0b3IgMjQgMCBSL1cgMTYyIDAgUj4+DQplbmRvYmoNCjIzIDAgb2JqDQo8PC9PcmRlcmluZyhJZGVudGl0eSkgL1JlZ2lzdHJ5KEFkb2JlKSAvU3VwcGxlbWVudCAwPj4NCmVuZG9iag0KMjQgMCBvYmoNCjw8L1R5cGUvRm9udERlc2NyaXB0b3IvRm9udE5hbWUvQUJDREVFK1ZlcmRhbmEvRmxhZ3MgMzIvSXRhbGljQW5nbGUgMC9Bc2NlbnQgMTAwNS9EZXNjZW50IC0yMDcvQ2FwSGVpZ2h0IDc2NS9BdmdXaWR0aCA1MDgvTWF4V2lkdGggMjAwNi9Gb250V2VpZ2h0IDQwMC9YSGVpZ2h0IDI1MC9TdGVtViA1MC9Gb250QkJveFsgLTU2MCAtMjA3IDE0NDcgNzY1XSAvRm9udEZpbGUyIDE2MSAwIFI+Pg0KZW5kb2JqDQoyNSAwIG9iag0KPDwvVHlwZS9Gb250L1N1YnR5cGUvVHlwZTAvQmFzZUZvbnQvQUJDREVFK1ZlcmRhbmEtQm9sZC9FbmNvZGluZy9JZGVudGl0eS1IL0Rlc2NlbmRhbnRGb250cyAyNiAwIFIvVG9Vbmljb2RlIDE2NCAwIFI+Pg0KZW5kb2JqDQoyNiAwIG9iag0KWyAyNyAwIFJdIA0KZW5kb2JqDQoyNyAwIG9iag0KPDwvQmFzZUZvbnQvQUJDREVFK1ZlcmRhbmEtQm9sZC9TdWJ0eXBlL0NJREZvbnRUeXBlMi9UeXBlL0ZvbnQvQ0lEVG9HSURNYXAvSWRlbnRpdHkvRFcgMTAwMC9DSURTeXN0ZW1JbmZvIDI4IDAgUi9Gb250RGVzY3JpcHRvciAyOSAwIFIvVyAxNjYgMCBSPj4NCmVuZG9iag0KMjggMCBvYmoNCjw8L09yZGVyaW5nKElkZW50aXR5KSAvUmVnaXN0cnkoQWRvYmUpIC9TdXBwbGVtZW50IDA+Pg0KZW5kb2Jq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NiAzNTIgNjIzIDYzMyAyNzQgMzQ0IDU5MiAyNzQgOTczIDYzMyA2MDcgNjIzIDYyMyA0MjcgNTIxIDM5NCA2MzMgNTkyIDgxOCA1OTIgNTkyIDUyNV0gIDEwNVsgNjAxXSAgMTA5WyA2MDFdICAxMTFbIDUyMSA1OTZdICAxMTRbIDU5Nl0gIDExNlsgMjc0XSAgMTIxWyA2MDddICAxMjVbIDYwN10gIDE1N1sgNTQ1XSAgMTc3WyA2MzZdIF0gDQplbmRvYmoNCjE2MyAwIG9iag0KWyAzNTIgMCAwIDgxOCAwIDAgMCAwIDQ1NCA0NTQgMCA4MTggMzY0IDQ1NCAzNjQgNDU0IDYzNiA2MzYgNjM2IDYzNiA2MzYgNjM2IDAgMCA2MzYgNjM2IDQ1NCAwIDAgMCAwIDAgMCA2ODQgNjg2IDY5OCA3NzEgNjMyIDU3NSA3NzUgNzUxIDQyMSA0NTUgNjkzIDU1NyA4NDMgNzQ4IDc4NyA2MDMgNzg3IDY5NSA2ODQgNjE2IDAgNjg0IDk4OSA2ODUgMCAwIDAgMCAwIDAgMCAwIDYwMSA2MjMgNTIxIDYyMyA1OTYgMzUyIDYyMyA2MzMgMjc0IDM0NCA1OTIgMjc0IDk3MyA2MzMgNjA3IDYyMyA2MjMgNDI3IDUyMSAzOTQgNjMzIDU5MiA4MTggNTkyIDU5MiA1MjUgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDU0NSAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCA2MDEgMCA2MDEgMCAwIDAgNTIxIDAgNTk2IDU5NiAwIDAgMjc0IDAgMCAwIDAgMCA2MDcgMCA2MDddIA0KZW5kb2JqDQoxNjQgMCBvYmoNCjw8L0ZpbHRlci9GbGF0ZURlY29kZS9MZW5ndGggMjI0Pj4NCnN0cmVhbQ0KeJxdkMFqwzAMhu9+Ch3bQ3HSXUNgaxnksG4s2wM4tpIZFtkoziFv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EEc0vcx2stu2BRNDnHOHnFg6b5PiJaN5r0tj/TDmTQ7n6jSb72MWzS8c/8WGTOvIZxfvz52R/OT0TKtrW0rEadO3z2sZLz+WZ7fK5Uc/doxw7KLk9b25rMqKsB/L1mHMnsdTxwLwfwDLeBlHDQplbmRzdHJlYW0NCmVuZG9iag0KMTY2IDAgb2JqDQpbIDBbIDEwMDBdICAzWyAzNDJdICAxN1sgMzYxIDY4OSA3MTEgNzExIDcxMV0gIDI0WyA3MTFdICAyN1sgNzExXSAgMjlbIDQwMl0gIDM2WyA3NzYgNzYyIDcyNCA4MzAgNjgzIDY1MCA4MTFdICA0NFsgNTQ2XSAgNDdbIDYzNyA5NDggODQ3XSAgNTFbIDczMyA4NTAgNzgyXSAgNTVbIDY4Ml0gIDY4WyA2NjggNjk5IDU4OCA2OTkgNjY0IDQyMiA2OTkgNzEyIDM0MiA0MDNdICA3OVsgMzQyIDEwNTggNzEyIDY4NyA2OTldICA4NVsgNDk3IDU5MyA0NTYgNzEyIDY1MF0gIDkxWyA2NjldICA5M1sgNTk3XSAgMTA5WyA2NjhdICAxMTFbIDU4OF0gIDExNFsgNjY0XSAgMTc3WyA3MTFdIF0gDQplbmRvYmoNCjE2NyAwIG9iag0KWyAzNDIgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAzNjEgNjg5IDcxMSA3MTEgNzExIDAgMCA3MTEgMCAwIDcxMSAwIDQwMiAwIDAgMCAwIDAgMCA3NzYgNzYyIDcyNCA4MzAgNjgzIDY1MCA4MTEgMCA1NDYgMCAwIDYzNyA5NDggODQ3IDAgNzMzIDg1MCA3ODIgMCA2ODIgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgNjY4IDY5OSA1ODggNjk5IDY2NCA0MjIgNjk5IDcxMiAzNDIgNDAzIDAgMzQyIDEwNTggNzEyIDY4NyA2OTkgMCA0OTcgNTkzIDQ1NiA3MTIgNjUwIDAgNjY5IDAgNTk3IDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCA2NjggMCAwIDAgNTg4IDAgMCA2NjRdIA0KZW5kb2JqDQoxNjggMCBvYmoNCjw8L0ZpbHRlci9GbGF0ZURlY29kZS9MZW5ndGggMjI1Pj4NCnN0cmVhbQ0KeJxdkMFqwzAMhu9+Ch27Q3G6S3sIga1jkEO7smwP4NhKZlhkoziHvP1kL3QwgQ3y/3/it/S5fWnJJ9A3DrbDBIMnxziHhS1Cj6MndajAeZu2rtx2MlFpgbt1Tji1NARV16DfRZwTr7B7cqHHB6Xf2CF7GmH3ee6k75YYv3FCSlCppgGHgwy6mHg1E4Iu2L51ovu07oX5c3ysEeGx9IffMDY4nKOxyIZGVHUl1UD9KtUoJPdP36h+sF+Gs/t4yu7q+Vjc23vm8vfuoezCLHnKDkqQHMET3tcUQ8xUPj8UIW9QDQplbmRzdHJlYW0NCmVuZG9iag0KMTY5IDAgb2JqDQo8PC9GaWx0ZXIvRmxhdGVEZWNvZGUvTGVuZ3RoIDEyMjIwL0xlbmd0aDEgMjQzMzI+Pg0Kc3RyZWFtDQp4nMx7CVxUVfv/c+6djWEb9k3gwrBvM4ALKOog4IaiAiqoJcMwwCgwEzOAqJlSueASb5aWLfKq9aa2DC6JmVvZ5qvt+cusTOVVKy0rl0zh/p97ZjAwDOzT+/m/53K/9znPWZ7lPOfMOcMdIADgjiACLjNvzKjjcXEBABk7AAIKxuXnjZ7+FbMXCy1Y69CEPFVS4Ys/ygDIC5ifMiVzfEFd8f1tAOIUvC/oKrWmuEfj2gECV2CdabpaCxdz6MbDAJE3sVxUaiqrvGfweRYg6Dzm15dpzSbwAweUtwn7U5RV1JeCw4HHAOIxKz5UXlI5Z8zkF54BcAxDJcvL9dqST7dolmHfcVhhoMBwbWaHYr4E82HllZY5IaOZbwEYzDKWCqNOe/TikRkASYewTkOldo6J8ZYI+i/FClyVtlJ/SjFxNkD/0QCuaSaj2cKHAfaV8ZBQbqrWm6Zsfm44do31WTMIvhIDrM67Mmmma9oVWSB2hWnj6NeHCM+Do1LFPN8xTHZO5ohZR1pfSPiUOXYMQ5zSsfVmguzcrZLONJdyDkAKVV0wQAEqmIzUD+L1tj5ER0kTSpeJ14mTMRtue7LNUMq4O7FiMWGIVMKIpbf1DPnjMzjQXOIu7RKv6BhJkmWO5I2Ft0pFR6GMEr/Z8swWaBPvAO3tvfyvJmkghP+3+mYvQ9ZfaScqAcPfrctfTezLMOv/tw49pANSQuDxu/Du9J7Z7d1ya3vvp6TvIntLBFgiZlmcd4ROZ196/SrjQQYyvgPXNQdEOcgRHcER0Qmc+HZwBmdEF3BBdAVX/ibOdQWiG7ghuoM7ogd4IHqCJ6IXePM3wJuiD/ggohz+N1w5/RD9wR8xAAL469AP+iEGQhByghCvQzAEI3LAIYZACGIohCIqQcn/CmEQhhgOEYgRFCMhkr8GURCFGA3RiDEQgxgLsfxViIM4xHhIQEwAFaKKohrU/BVIhETEJEhCTIZk/jL0h/5ID4CBSA+EQYiDKKZACmIqpPK/wGAYjDgEhiCmQRr/MwyFYYjDYDjicNDwP4EG8WdIh3TEETACMQMykJ8JmYhZMBJxJIziL8EoGI04muIYGIM4FsYiZkM24jgYhzgecvgfIQcmIE6AiYgTYRL/A0yimAu5iHmQh5gP+YiTYQp/EabAVMSpUIBYAIWIhRSnwTT+AobndMQZMAPxHrgX8V6YyX8PM6EIsQi0iFrE76AYipHWgQ6xBEqQo4dSxFIoQyyDcv5bKAcDogFmIc5CPA+zYTZiBVQgVkIVfw6qwIi0EUyIJrgPOfdBNWI1RTOYES1gQayBWv4s1EIdYh3MQZwD9Yj1MBdxLszj/wPzKM6H+Yj3wwLEBfAA4gOwkG+DhbAIcRE0IDbAg/wZeJDiQ/AQ4sOwGHExLEFcAksRl8Iy/jQsg0bERliOuBzxFKyAFYgrYSXiKniE/wYegSbEJvgHcv4BjyL9KKxGXA2PIT6GeBIeh8cR18BaxLXwBP81PAFPIj4J6xDXwVOIT8HT/FfwNOLX8Aw8g/SzsB7p9dCMdDP8E/GfsAFxA2zkv4SNsAlxEzyH+BzF5+FfiP+CFxBfgM2Im2ELfwK2wFbErfAi/wW8CC8h/RLiF/AyvIL4ClgRrdDCH4cW2Ia4DbYjbocdiDtgJ/857IRXEV+FXYi7oBWxFXYj7obX+P+D12AP4h54HfF12Msfg72wD3Ef7EfOfjiA9AE4iHgQ3kB8A97kP4M34RDiIXgL8S14m/8U3oZ3EN+Bd5HzLryH9HtwGPEw/Bvx33AE8QgcRTwK7yO+Dx/yn8AHFD+EjxA/go/5j+Fj+ATxE/gU8VP4jP8IPoNjSB+DzxH/D/Ej+ByOIx6HLxC/gBP8h3ACvkT8Er5C/Aq+5j+Ar+EbxJNwCvEbxPfhFJxG+jScQTwDbchpg/8g/gfOIp6F8/xROAffIp6n+C18xx+B7+B7xO/hAuIFuIh4EX5A/AEuIf4IP/H/hkvwM9I/UfwZfkHOL3AZ8TJc4Q/DFbiK9FX4FelrcB3xV/gN8Trie7jvuYH0DbiJeBPakdMOHfy70EEAkScEUVjbcf/rKJcKi/4fdlh3TvKe2eJuuT70J+69Sh+Tk80Gh763+N+zwdlJhhvku7HBqWd2d5Vkvfcj6bvIXpKriwPaIHLsewuXntndte6DT/4+GxSu8ru0wbVntsOf5HpMfRiqPiY3aoPYue8t/vds8HBzRBskd2GDW89s+Z/kekx3MQV7SV6ezsCC5A7O7Sl59sx2/JNcj6kPZvYx+Xq7oA2yOzi3p+TdM7v7ctWHcb2LKdhLCvBVoA0OHn1v4dszu7vWfRjXuwjfXlJggBuIwMGr7y0CemZ3X3IVvffz99nABXqgDXKfvrcI7Jmt6JbrQ2ze4XPmL6SQIE+0wfEubAjqma3oluuDDXexjPSSwpXeuE1wvEOA9JSUPbPdu+XusHh1TXexjPSSYiL80AaXOwRITymiZ3Z3re+weHVNd7GM9JISovvhzsUlpO8tontmd9far/d++jBUfUxJ8UFog+IOAdJTiu+Z3X3J7UNs3sUU7CUNTOJws+8W2fcWST2zu2t9h4nfNd3hc+YvpMEDlGiD+x0CpKc0oGd2v2654N77uYtlpJeUMTQKd5Beqr63GNozm+uWC+u9nz6Y2ceUnRmPO0jfOzi3p5TZM7v7fwCieu8ntO8ie0l52Um4g/Qf0vcW2T2zu0fjHSZ+13SHNfovpBl5g3AHGZje9xZ5PbO7a53Yez8xfRfZSyopSMNtc/Covrco6Jmt7pYb2Hs/CX0X2Xti7P8Z9MRNOCbij7cEuv4jEf7wv0MhL7qLb1fUPbO7u25y3/u7c5rzd3RCkwg0IJyLhC9+RJdCL42/VHKp+tIunge4FPJ7zvWM/Tp4u5c0mvzhw4amDRmcmjJoQP/kpES1KiE+LjYmOioyIjxMGRrCBQcF9gvw9/P18fby9HB3U7i6ODs5yh1kUolYxDIE4rKUI4s4a0SRVRShHD06XsgrtcjQdmEUWTlkjexex8oV0Wpc95oarFl6W02NrabmVk2i4NIgLT6Oy1Jy1qOZSq6VTJtUgPTKTGUhZ71I6fGUFkXQjDNmQkKwBZflW57JWUkRl2UdWVvemFWUif21OMozlBl6eXwctMgdkXREyuqjNLUQn2GEEoxP1uAWBmTOqJXVX5mZZfVTZgoqWNnwLG2JdeKkgqzMgJCQwvg4K8nQKYutoBxhdY2lVSCDirFKMqxSKoYzCObAcq4l7kDjilYFFBfFOpUoS7QzCqystlCQ4RaLcjOtPnPbfH/PYufuGQVLupYGsI1ZvgZOyDY2LuGszZMKupaGCFhYiH1gWyZ8ZFHjSBS9Ar2YncehNObhwgIreRhFcoIlglU2+/TKLIFTNIuzOihHKMsbZxXh2Pg3WiG3PmSbv79mN/8N+GdxjfkFyhDr8ABloTazX4snNObWb/fTcH7dS+LjWhRuNse2uLjaCSfnroT+VhmlaHWBys695VkiaKQcgxFh5XQcalKgRJtSBNCnQKMuBathKiTYylqCI2KwOmQUNSoGC3yhvVUcrlByjVcAI0B58UJ3jtbOkYQrroBACnFyK9awvJO2xsZaY2KEEJFm4JiijsNofkB8XG0rk640KTh8oPtgIvpWWzhYhe4PCREGeHmrBooxY104qcCW56A4YBtoVLGFVqZIKDnQWeI1WShZ2Flyq3mREiN5B53MXlZZxK0/V4W3R1b5YCvx/pNiva08O0+ZPWlaAZfVWGT3bXZ+t5ytPOVWmZ2yemQUsAGMnWICWFqKQTnjVmUhU+BkFYXjn4QGdUmrVIZRSTmEG2lVFI22YaE8JKSPjVr5S0Ir+vi9mV1N6+DY7vkh3fLd1HNqZFFhUQSTnT+tsVHerQwn+IgWJVk6qUVDluZNK9itwL3g0vyCbQxhMopGFLaEYVnBbg6XTsplbnGFHCfkIJtgwG5jZLQoYDcu0QtpqYgyaF7XSoDyZJ08ArpWxsZTUB6meGjJd0/3ZCLximAiwEi8sd5MihMoDqeoEpBRbVMFB7cyCduahUfctsBofIRpHE/5BydGugenRQp5H82Qiujgb7b4BZ/Ce2tkUvDStKTgB/FW4V2LeaFe5JboYGOksdK42LhENAi8hdOhu5tM00rOvDrZ08HTYVBTK9mvSZU27ZU2bZc2lUmbSqRNU6VNI6VNA6VNCdKmWGlTuLQpTOopc5cpZC4yJ5lcJpNJZCIZIwOZZyv/jSZW+Iz2lCiEh0QkoIjSCkZA4YUfDGCGyBgYC1YPNpvJzhtBsq0HdJBdzFmv5ilbiRxHVqwcQazu2ZCdP8LXmhKb3Srlc62DYrOt0onTC1oIWVWIXCuzFD2eX9BKeIH1cICwiO4GQviHVwbYn4WF4F073He4+zC31JGZPUCRHWN/T76xXVP2xPrXIZjU4DEqmFi2S4NXSwVuHnKbKLdJ4DZRrm+gdU12XoF1S2ChNUkg+MBCsj19p2aesO4WKbP0eBdZl9eW+1oXFnNci2anfUGOKCrWlQtPrd66U6nPtGqUmVxL+rweiucJxenKzBaYl5Vf0DJPo8/clq5Jz1JqMwt3Qw4pbolZ1U3csk5xuyGGFP+xx1ZSLHQZI0jMWdWDxFVCcY4gcZUgcZUgMUeTQyVmGYQBnFjQIoMRhTjZ6XM74yjHsSgKCCkc4a0wDaMDMyTEd0HAayLhhTpHXPuc8HPUGW+hKD49Pl0owoARilyEj1h7ke+CISEBr5EX7EUKZLspR0BsTextySwk8M0yZAo3arKbP8As3OYenBRbGAvieyBRPA6C8e7HPiYcTvlT9ruto5C/KJ4Nyo5Z/JeRwtdpO+y3LWnxzHUvnlnGwhtwCfaRGJgIB/gPQQcFTB2eA8bCI7ALDsDXeGQrwRD3J/OB45+GFXhseRCaIVXkz++EcXBe5greeOocTIwgAS8og2fJlzAGD0nxMAS3pMugGnES8q+RFCwheNi6B6U/Bk/BPngfToIf9pgAx4iUXOP3QAYeTXQwD3bD1+IR4uXgAf+Af8FmOAj/IQlkE/mO/YHfyR/hv8dW0XhCGQjThTcy4FH4J9b7F/ybUbIbeX9+Hv8C/y6e7zNhK1p9EN5CWVcJR6YQHfM8W9/xG1/Fb6U7Ui9Be7zS0ZocsMBzWPMY3CAOeDXgOjmc0XW48T7CTMGzdizqNxkqYQEshZVoxTpYD6/AeTKclJOj5AfGmVnI7BdPlOZIcxz2t3/Gj+KvCm8NQQhqOxVm4456gfCGBKzBlv9EWYfwugTtZCAZQoaRMSSXPEIWk+fIr0wsc4K5wbqwrmwcW8gWsfPZ0+x1mbh9Qsfajg/5ifwc9CUuR+jPcPRaJuTDDDCBGepgPixE7Vbh1YTe24qXFf25H6834Ss4g9dZOA8XCEPEaKOcxOClxmsI0ZCxZDKZScqImawlr5JWso+8Rb4jl5n+zEAmlZnA5DJljImxME2MlWlh9jNtzC+o5WA2izWzD7Bb2TfYd9mP2S8w6seKtCKDqEb0mMgq+kx0SXRZ1CEGsRKvBLFW3Ny+oSO7YzofwQ/hi/mVfBNe59HHQcLbTBCJ9kzEUdUJb9WgVSa4D6969N3DaNEaeBZ9J3jvVWiF1zFK3xDeoYAP4Qu07ys4LbwlgM4R7PMiISSeJKJ/h5JReE3Dcaol88lCsoqsQz+3kJ14HSBfopUdaOEUppC5l6ll5jMrmbXMU8xu5gBzDEeCZyU4Er7sKDabncpOZ+9lLewa9gn2SfZZdj3byh5g3xYxosGiiaJq0YOiJtEG0Suid0SfiL4Uq8VDxI14WcU7xXvFZyXukgBJf0mepFUqkdXLzsk6YDu8Ay2w8/YjE1lKFKQFXiLnWBG7kDnCFDCOzDHSIPqAROIIpBEQr4Iq+Bk1DCQfM4PIVFZHpqH/GkgpmQ7PsP3YDexYOCKuInnsRFICeaK1cFP8JmjFjcw2lhE3su3kOrMVymEVM7t9M19IXCCPbGKex4i5H9IgWuQPx5hU0W4SzkQz+6Uvk1YYJpWwqexgmSvmNrFnUM08mSv5DrTsaZw/p3Bu5TLP45pwlnwpnYDatbOvYJ37YRjZ1OEGm8WFTBHpx2wi49ofbP+cfYpfT/yY0wDtbu3pTAZG3GR+C7MPfoS1HddF38A+5gRMxlVDR2fOzzj36nClmQI3GWecT3m4jphwbSrD42UZnp9ZjJ8hmiCJVIenPbFIx4JcItaxLOPvIBXpCPjJolN8Y3MUl9PGt6flKK6mjVe0p8HwtPY04U5UJ7uFuIWHuIWUieAmxx64qRHDDeBEB+jryHwbnMb11Al8YdAuIM4eUhyhVrJgh3eiwtG/lQRqnOT9nRNF/T1m+ulX+MYqrra1t7XB8ParacOJm3tqaqLaQ8lGDOg/MDkJD6hSD0+JMtSefSiiQDJCpU4XM+kJ8enp8QnppIyNHeCVMW7cOL+YG28mpKcnJGg0ttei8fiM670U5/1mzbgUSGFGi8pFrSCOl6fJx8lnyCvk8+USkMmJ1EEukTqIQcawTiJHPASLAuUST7lcQhiWDZQTJAlIA2UODhIxOkzeylh2aESs3Gk/cx/uZl7C1U6MKCfXtzsKjvNTXG7zv3jRFz3mf3F4WlpaqgrdJl6SELvk/kNLEnyFB3FPFS7hT5qWhn+JariH3EM8komSJHuIQwh7ZnNJ+97y9j3lW5nn2x8iw9n9ZOVvO8TjOsy69iDbqV/yIVqoguOa+FGqqapa1WKVyFUZ5BAaGqwM8gsNjVcGRYaGMsogWahSoQzyClVyyqCIUGUr/49dPqDifBNUqlZi1Gh8fD19fHy9sc9IH28kvb3RgSoflS/nE88k+BDWz9fbi1FFRjjgTk/1GeT5JPr4+HMJ8ZHB3BFXwgidyBWufurEIyHpO3EHlUNDB6NGiJ8sfeZZjKCzIPgiLU1An1RhqN1S3QQnuKV2c03nDixRTe4JIW6ePt7JyV4hA5KTBg0c4NY/QqkcEEJIiJcyVCrxuq2UsGHtlwPCJ6o7otRTwrxzpvni+nWBtJGFqqlh3v3CJ6raD6inKr3br4jMN+fcHxwTHt6fq2ZrLbnhN06IaOZm4y32ihvLbBF9ip2FK0g0DIIaTdDcGBId2w8XzRiU2J8NcE6OjwlggRGrQ8OUrq0kROPsnSQj6iSlYyo6yamVSHclL+WuRPgliXF7q3GMV0X4paReCYkpp44af/HyRUX7xbYcwU0wfPzF4RcvKtLS3KiLfFJpXERERthmgPCVDU4HzEZGKEMlXp7ePt4CD2xTZKCPROAlJ6FmWIO0RiWsnrJm495ZIxLDvd385oWpNIUzZ716Lje349t9L3577+ufPP3M06XzlqtC/dmZkcr75g3IqR0dPyxULXdd7O4zPiGusnJZbe2Kox0nL1kN7zVI/N/ctWv/u+vyHlWHUc90jMSV04ozPQpe1EQFaQK9hskgIDBsurM0MMnLUeQS48MtdbvqwDYR4hclaopKkzn4RbcSl5ZVOPExRi62oamKNrQfTae2uwkLQEa9Ji4oUu4ZEe4aHhrhERHuFBUOjnKlCxdOgjwRIh3DwkmIAiHYPTAcMFpIbKwijcbNokUwJr9e4+7dLyDCJ9zfN3C1qJ+332rUkmANoe6iQbiuKAfSeBpk96qUupX19LZ7L4LG1+HgrV4SeUPD26drpxtXn5o0Im5gYkPe/S/Pfn6GOSl4UM21hzVRmWXMog8eenDDgvXb177t60amL6vIPrT5gePlhQNetX1n+Qlzgn0ZHCFkN7Bkh8bFQQr+zhI/J+cfQ4T1IjanTUFHHiO+y2LHnDi29oljx55Ye4xJtz2PgfBPJttVC+f+Gxd56m4uJupPrj1/y3X6f+uiG47+TO2tb11nQOf31MIeU2+nGfzcedhOs7hyzLDToi51xPgZucJO4+cQPGGnZbiXb7bTDrgf3m6n5YSDT+20IySRy3baCZKZCDvtTNYyhXbaBRLYS8K36yJcncBJFERpsfCLG1ECpSWUP4zSUsofS2kZpadRWnjxqVU0y04TcBL3t9MMuIgtdpqFXHGonRZ1qSMGX3GDnZaAQrzOTssgQrzFTjvACPGHdlrOaCTudtoRSmS5dtoJSmWv2mlnps2hn512gRlOQGl5FxuFl8QUTjMo7dSF7yLQThWUVgj6O82ntAfS7k6NlPbsUt+L+sFGe3fh+9G2T1M6gMqy9RnYpU5wFzqM1rfZG0/pVoGWddFZ1qV/py58J7v++fUmfalWp+c2c/nlem68scpoQRaXYaw2Gau1FoOxijNV6BK4TK1F+2eV0isquFxDWbnFzOXqzfrqWn1JZ73BefWVxcYKbnCtvtos1E1MGKTmosYbdNVGs7HUEp2rL6up0FZPsRcPSFCrbU3G59+ShYoay6q1pvL6riw9l1mtrTNUlXETSksNaEZiakpqfrnBzJUaqyycDkFrqDJz+YZKvZnL0ddxucZKbRU3qlqvn83ptCaDRVth5rRVJVyFsU5frdOa9XFcqaGsplpvYxdrzQYdZ6qp0llqbJZajGV6S7m+mqszWMo5LQqpqNDraJGxlKvUYhmCQaet4MyGsipbN2X6Kn01ckw16DKznpto4HTl2mqtzoJGJ3DcZOSVGqs5s95iEczp1o3QgVln0FdZDGgkV2esnk15WjMVX2mqQPPQXIuRw1acmfpOcEENVjJUcWYL1tZWl1CnmBPKLRbTYJWqrq4uodLuywTsRVVuqaxQVVqEH/WpKs0zbd0kCNw+tqjTVyBXT5vkTMgfM3JMRnr+mAk53ISR3LgxGVk5eVlc+qjcrKzxWTn5znJneZ8qFRpr0B31XA26yHJraNF2k7660mCx6HGQ6qnhWZPHpVMvChlTtbGkRmcR7K8rN+jKu7TFp6FKV1FTgk3RZyUGs6kCBQguNVUb7HGDDsVx6RRurKqo56IM0Zy+slho9XtfVZ21e1SJVi8RRhQDylJtoHHSRTw2v9XXEKpBlAGlWPSVwsyqNqDUEmNdVYVR21UoKq21qYphiPYaaTwaayymGgtXoq8VZgLWKddXmG6z6E9HUsipKrBxldk2iJADRqiGSjznVeBZsh5zxVBPnPGzZhbmvxV+Q3OrPA8s+KyCEsRqKGHXsS3sXnY/3rvZ19gXIR/bm4Tf6mC5Dp8cbMY7H0+/Aj0eexJ6s9hrcZBB+zZR1CLfQGtwyKnA9glIZVK+9i/3lC78Hgifucgpw9YWMNOcHp96rFuLWPKH/gajpfVoczHyhNaDab1qbNPZbyJqNwjUSEVhawNqW40lZrxLsZdoKqEMarC14Kkpt7UegK3VeHWVMh6t+6NdNo8asa9qehIvx/ydaumpv4R6dSipCttwMAH1KaX66anWqZCCt+BHA/VEKe3LgpTOTmlpWzPt1YDa6Smdg8866jkjjQXBilEoS4/XbNpa0M5A21fQFrY44TBnxJaC/UIdwetxVK6B+qfa3n9n7WJaR9BXiIIa5Oqwz5puY2qh/tDjs5z2y1F7hRxHI0VH/VmBZbourYSR4ajutnaV9j51VGOOSi2zW96pjSClisqw1TFRjU10pAV/TsQ2grxyOspaKs820kLscjDZXq+UxiVHcxYq1TY6d9amUwMzcgxUC6G01O6ZOtrf7C71tHa9bdZX0hlkGz3b6Ao+4+yyhF5/j7vOKKix92Sg3jJ3n+ldIkWwrZxaYcJ5ocKrjl4J2GP3uEyw66Ki9StRlgrRgnW0VDMhZ4aZ3bRJuFX375UhRGCFva6+i5QcnCH5MAZG4p2Bq4VAT0CuMHNGIo6j/Czk5CEK68konANZeI2n3HxwBjm9C6kPbWNaj88a+9hbephrttEy0VippLFroeuQEP/1XcYpCyNoHMr8PYI6S0x0vSlBKTrao23U6qgsHZ0JPcm15Q10VlVg2xK7VFt0lNByE12z6rvEliDLcNsqYYsrW5TfbrlQo4JSUdguGp96Or6dsnrSq+oPfffdS7/3XnJrZtnWFQvV/PdVoGfrDfZV5Xa9hnTxgWCJzRYLldf5SSP0b7O1hK5zVXS9097RUpuntd28alvDjHb8fVUTvGqha46F9q/HT6HOldzWTzmNalMvY/TXZ1JnmYquJjrao/m2+dO5O9DSOp35U3Q3oe+2u9B32z/QdUUUJEoUZYtGiYYipmJtLdooeE/QLF34nS5dl4RWrO3QzIfc8efpLH3zyR0Iz9PahF70jB0gvBRpf0k5IE3dEJAicYhZPHrxNWciZZobAqKRFc4QkuiodpCIY11Yxl8Maq1EHishItIwiCGi5jz1JHVcF06/DUEL+wk/x8ZrAgagmS5geur4YcKlDunSmcjzvVEj4orHDTx2gf/sWP+FV7Y9G/XvWc0NXifVDewhvOObWYYwjGLUfr/HT67MHZlx7UTlaOfETWrnW6oSMSq1aDlVkp0skngw09ITvdQeQkbm4TQVt5/66iouQ2vSJ3qq3QW21MMxs6a6WFtVa8AjTKIr9oZcuYckv1xbZ9EnBqoDBIajh6eNwWXoq+kRhB6EEoPVgUIx6+FtL6anLIu20iTsdzPS1UE+zurkxCR1fzVN03ycE4VsclLygNQBqdPUeV2UnZyX6KP2ssl3wZOgIQ/PTnHcmCpdQmKsOtomKLSzgIri8jpl5eF5E7etZkFoAwnt6hUiBraBuALy5UwDIbD58LZNR45yr8jvX/bikppLO3J+OnnQdX+Zdu/Gkn5f7Ll+OHnrQ+plBQtWnJj91cBnXfd/dGHOz3XPLzCm7V/9ivNr5ZcrHju8Nzd+6+ihV1797J6ZAcz631SzgzZd27juef93mVMPjMs941J0QdNvwW7nr4e/s+Pkkr0z585KTGCfXOTxwiju/USz89T4o3P6Jz/u/qT77q/LVVvOnnmjcUXMm8tDlpTufbBgqrFmf9qWiCX3HFZ4pa1/6Lv8g/KqQx1vjf1qt9Rtbej8E8MiPwqac2F94ns/nQ31O3Fo+6iMdf4zm4Oa2u698sP8n+7fWkweuTLe8esPQ6e88PjRl5fWvvzDa86/tI0/3nyjvPllzyHblxzcw7AY+BsXnVAv+lzdXyLDiBWLpYSIotQR6rDOvJos9rUfFYw6sykBT+4G4TArnBVo7AR6EMKLZGoJPhgC6nSBFywarE5RD2zu35y0WG1vrquu6NZaZYuVrqGSkZ6AtWikBoaLnNTyTi1YmdpFYLoKsoRXCCWoIebdRBiZm/zUPp3xzXo45eelY6ClxCfGD0i+bVawixbB2NnXvyt4I7Nf4rL6J2PX7G94kRzrN+6otbGg6qQseuO97x5e7XFOlOv846hIFaRY295bnbPu09Bir2vDB4VMMCUu/Gl5ypLt58+vhY4PJq/JCft4c2TO3Jd3adN/iXn/3HvH7/1qT+zDw3Y+s/P4qan8vh1vLbjygdOzl9Z2xH4yJDcgICXy2vCxOId5dQNzzj6Pnb+NvfTp59FLfZPEDveuq116+zz+r8yMP05HdUrX6Ti1j0JV6nib0IjehApl+upep+S2iVGjv/qkfO5DvpmlNfcsONS6XhfBD814er5biiJ8svl4TaShPWc3N+MT+fXmgJiLk6eEaD8POtH2evLsd378auMg/aqA1U6v5gXNmF86YKa4MaujNudk3sINi7hnXl46Y4Ps2n/U138IHTRuhPz9k28HHzo2+dtFw3fmbozbQub+vGHLygEd68/eM0u8fujsM/vXHOg4UnRdc07anPn9oklVz8X8/GqjIuriI19KmhdPXDdvrMxZHXhY8ezsa98WvCzarHlyW9T5R7xfTDuTZ8z+ZMAzO40lgdvXxO0Zeq7++8q5173PRrz0yo9P5u3SxD3eWr+l49PcrdGWBSMupAZtmOV9tnBPWPnnsDBDsWThbPuUPKxe9M5fnJJOt6Ykg0fHZNtkjFPHqKOaI5rDFofeaTJazOZ4nZZOP286/YQu/mQGSg70aQb2v30GCqO8ZI7pi5xcwk3/pv69BvWh9t1+a/b+A97ce/To25ddPuevjz+QXKx2e+uKJeDTR7+e+TTn0TI/a9/Eow+eW+jz4L8iV5d5jLxxuPWJdPbIU5Omi5c/8ILxl4CJAWEJPxtWVoRe23PY+/GLTpYD5XXHv3+yeMlBc9OvyyxzlVs3PjFvbcu1R6LvG59QEzA6/YtLO525/GN1zWsbdIZ2hw8aL9XscXjq+HW3yRHrtEn75jLWeYv3bXhzeWjcnI8G1L7+qHnG9d1nx3nJlUfaPv60f8IYjVeaa9HcsLefK/1xzQem74edu+y84MuP5m+svc9w8OkJo9QDQlo2vOJfnBZ7fNWWGOm8z323z5h3+pnnjB1py15SN4jccQn4zbYEuMJBWJ6WttTto2FXdRdOarp6TIQrgKlzbv+/6s0zrIlsjeMJCR0vEIpUSWgqqEwgktClSFmkhaoUgRCkKCAizQIJSFNE1FClBKQjRYSgohTpTRTBK7DgXjoiSl0VgZsAAnvVZz/t3Wc/5TlzMjPnzHnP7/z/75lh5RLV9PQK8KblVuH7cPvhSAUFNHwrebqehD2E3AMIbfyZ5481m+lZJAIQ2Rgmvu16rKenD1z9vI+Lp7erTwANDwpoAIkEAPQmHmQBpKwccrP4N7ToT5dyuie1XmNKc4aC+9Li/e2AqYy8aImTn1ZJxzIpqykZcNWLJhnJGTH2su4vNJwCZgp9W8z65t7dCROKSQt1LmtwD3QU6xVWHmQH35yIq68+6JyU5CKZ2KV4oJqt3EqyVnucRRUTdyBvn0LutF6IxnAo++Ok0+YOhcSLZPuDfscmEx84KSUZCyGZxLnT8sZjpfnGVBJw3PZW9Pg0YTQ2/PecD7fpGgW7q82PlkUGVytOm902LFrJCTzjY1jM1x7HvA8Bsrxh74p+rA9jVLZYs16+68zClP2SYGH5oULJjpfgB+1beloUTFot6QjqzRHwtlFurfrIlCkKlDFcaSmD+3FdGdrkRi5AyAIIGbR5CYYSkgBCfDCHdZfXB1fvVDGTy9z3Da6vtZG9///jR/yTGF+nAmmCtSZ6Pp7v8PtKsPi//Tjnbexl01JZ21TpYyNiWhTHEHMfLW8dKE/XaXb88PV1u5LSiTx5M9dV8TNqLe35g/QXf0VGq6RxeLk9XoUZ8bnWfO3SHOY8ATeacrxQnM/fLI2WOPgUT4ZFSbDjMn83E/qMaOnlmccWemjKMq4Qd38aPXV6l8nSk1ls05PxeuArHMkcIUzaL2DQI0yXNRv8FvLAeqH012bLGbxeE9as4gFkH2ztRu9HppjLlfENBegDI4EjuX7DvumgLje12pfyUW/VYbmH3QTd+g//9koIOpJ7FNp8Qg7jYSC0y5HCknGtu8dMTbtDyDzbqx+mGH7rfFrOy3QqFZ5RxUHxpjBwY000qgEJF3D21dORnfc++mYShP8uJADyVL2AQqJRKCSKJuCpiJeV/4YEQvYfJQMXwLlhN1gsHc65UKWAD/U+HOtLCNVsMGLxTmc8PZy+tYzlZy37WTdlqTf9rptiAGKjGwI7a5zw6+KDpkaM100B/HuS7KKRhGmdJM/a4dFVQ2uqxjOBda/EJZZ8OxFrHVIWhq13KMT7hwMOgupzmXpwLZSspcna2t7Sa3EZjF/YK4jYpHfExiccDbk1M+6h100FHxt/cQJH1vK+IrqAjvhrLcIwhss4k7dfVB6OokuHcIxiSmePoHQW3Iu0F/ee2yPapsG/x6QCm9Sd2cXVyK92luHMHAmhdVLjfU1LohO8shb1NUNr7MJ9YZnK7MEF8lAygn3VCqlujrlcbDU+Mn08QKLgdykZTjWMv6pGUI7LyGVRl91jv9ys99fC6pCNQiNvJdecujDFvBwGubSUeFZZOsc5oX3o4H+k6QTYUbr4RWVY8Wy4kLAk1rOdGnuQTCJYivo8JH+kwyH/DLzAGJg3DTgPlS90EAgIum5Rhf8F5YVyS3yS1rdt9ja7N7qULrWbd7n2sykB4N86hZsOyraHBWQKOk+165ogdYB1Xfis+w5tgH1LYNEDEOrPjnm5jjHc8Nt5+sqSKVZW1AsiUjXS8WgPU85nB3zzIcgXjK768/K5vSHdww0Wprnl/J3tY7Ppny0qdG/riI/miQwEvlriDYT1z98QnGayLbty4+E1q8dC7aRu0m25hdjBtYhkO309YwVJRbigGfrrJRueW88GhK5/dMAqjzK+d/4QMB3TaYnDk/j00gOH8JQhyaLVZlhFY0Z748mrXvOt/QVED8YBPP/D3KWwOmaNhFnJQtfA0lrpnBJnkazicCb3eK7KEvnEPfSZXJjMmkJA9RHiNZDd6ggTKraMHp0N5Hxkp8yGnr1VezPCEHqC3qbpeW/em98uxfrvXX7gkRXDIGdVaifFyQ4Q6eWoKBPcwBiLg3ZqG+29axD+uwzFPwUZ2+xTQMmh5GluCU3VRtTiYVoR8PlL+rFZD/lJ/Z9Kog5CHKbIJmOudmiwq4AU3aucInL1mW3YIduPpd6LBYURbuV9paIXWJubs/Rj7US5Jj8viqWUL3j4Fn2YuavcVF9z3EatoOycnGS2I8EhgOy44BFB6vL4tSnt5V0TTl+HR15ReHIcb2SOLaFLy3m03yL1SOvXAV/xQ1oAaLT30gUSZ4+VcOaEEWtLxEBGr2ni6VZca6Jb0k27YwacEzLd1tZ2J7GZ5w5mPQ49uusaP49vG1NfUrYXz4TBtOuK7X33mPf7TdCYq43aejy3jRNKFlzuvh5kPnvKJ9XvmvAV9/ip8ZNH29+Ond31Age6dQGZcJ31AdeTsq6Z2SHETJ69wwxaU+XZhiQigm9Sn8j177zLNgxm3rjnnTftMJoRNORn2JN5p+D57ZWfkC+PdlQMSiADhNTgH1KE7HP37+Df92JBf8P4aQEawJF01XTlMMUdxu/Mt+usOz8vd1faUZnNbfJzMrQJQIt/auzLrhtCox1OVBNQB9S2nChdmNzOfeTvr4v3/v6CPj/yhJg3H0iYZJsEblszD9chuubxsuXuOoN7MgVBZrv6ZCs+uY3tWkYI+KlmuQQ+IF2OspnTrA9Jxl+KMDa5SOReDDn3OuOpTSudV6fk6d1VWO6syBrKCLmdfD4l9qyKYI0FyKL8U6hkn53ccq9EoF1SX/bywpy6QKG59j3dgVgMlxWz3uw8MlykCnrdGoaHTLKadJHZohKfvKnN7WLikUCUV1hGCr2wDjuc1bqSHz6dh1ajaLoPw2ePVl0umpw1v0/WrcI/NUW9aZlgwEEZ/D2M13QfJ09pngjvv8cSvHi84cDIaJD1L6OyATOiV26yHSwztm6sO2JlVfCyY1imtmP6TBo6AEmEtlGx2UQHBgOE8n8MHP8A+O00djphAuDeWlD3gZGMEPr1ZDttmd0cemYIkm1n5pza9O0SK/JfwM5aHkBs+0QokjpvJQf3mHZ8sQJf2/9KVwathWtde3gM8N5xChvSCXBMxwTL/2DnHQ7S3tpr+cmuO1kyWPynse2z9Q7S/6pJKBEMauWY995d1PY1oDyxRFRfOiWhPSL5HnghyEUgn12uHNHjtjemTs0wfqyQN6ADVR7NWgNRmCOJz0FkjhNCXW5gwxU9TYYTsp89Qlmr4BqXD5li/I8oFxl+ecuY3/autjjj+aKOcWoETDktHhHalWw6bYU5IgwmiSlxcq1O66WwvaqqnkxsFQyhdF71Ojl3ccmIhbWa93Q/QtSpRxptol04rTNwE1PDUVrg1RGbFEkReflLBNBaMV9t/Y6ZxUkvBDTDMvpMsCFaZCZBLUhJulPa4N15875O+RFmYXia6pyNLSSSif+Cl2uriUoeYfB4TUkUf6WbUTP3ytWEOMqZHvoqFJRMpMoiInh5e8QYkETwNPXQBC28T/0lSc0fpFLZGJg2GkBHpUz6cYBvZ+yxbm/tgKmht1VDj2SnrffUBV5WlvZtO+oElb87Qg8G5TBMFKWUD0pFCdkDI59X43p/EALuplq6b7sOabat2HoY9CS916i/o0SxkPQ/Zu+Ur7/3Srn5sR4ezdCUL17qgTo69cNXuxserb2ve9m0ZgkO8S+d7EcEuaIeqcvkqAY+OJxCf6e+0pAbDQqfVLqef95ZGuaLNScmyDThmO5XY+sGn35kIa/U0c0viPeVajr0MUA8V/UTUmdDiqvQ9+GaaRVjw9X142igXm/l4v450XNDQNo9qfGeMD4kBd4QWWesqTKFl1N0MwOp6uRHSSWaCgJZU04OntnmlGxpBHuh/uDrtRCGLBG/dIM7iwYC5ZDdLz777W6+wXFFrfRUZ2QOFie2uqxwIsU2GHhupjJTQpkP6R+48V9/f0FPDQplbmRzdHJlYW0NCmVuZG9iag0KMTcwIDAgb2JqDQpbIDBbIDYwMF0gIDEyMFsgNDYwXSBdIA0KZW5kb2JqDQoxNzEgMCBvYmoNClsgMjc4XSANCmVuZG9iag0KMTcyIDAgb2JqDQo8PC9GaWx0ZXIvRmxhdGVEZWNvZGUvTGVuZ3RoIDIyNT4+DQpzdHJlYW0NCnicXZDBasMwDIbvfgodu0Nx2p0GITBSCjl0G8v2AI6tZIZFNopzyNtP9kIHE9gg//8nfku33aUjn0C/cbA9Jhg9OcYlrGwRBpw8qVMFztu0d+W2s4lKC9xvS8K5ozGougb9LuKSeIPDswsDPij9yg7Z0wSHz7aXvl9j/MYZKUGlmgYcjjLoZuKLmRF0wY6dE92n7SjMn+Njiwjn0p9+w9jgcInGIhuaUNWVVAP1VapRSO6fvlPDaL8MZ/fjU3ZX17a49/fM5e/dQ9mVWfKUHZQgOYInvK8phpipfH4AF85vXQ0KZW5kc3RyZWFtDQplbmRvYmoNCjE3MyAwIG9iag0KPDwvRmlsdGVyL0ZsYXRlRGVjb2RlL0xlbmd0aCAxMzEwMy9MZW5ndGgxIDI4MTQ4Pj4NCnN0cmVhbQ0KeJzcfAlgU1X673fuzdZ9XyAstw1tgS5JW7pBgZYuQCsILUuLKKTJbRObJjFJW6oOA6iABUdmRB0YFdwFtwCiwLgyLqjjNi4jojIqrmMdnFEZF5r3nXNv0pQgttM3773/O4fzO+ee5Tvfeu5J2gIEAOIRFCBUN86dPfONv8QDNNwEoG06b1HjHAVPPsLBt3HWJ+c36gvyXz6xAYDcg89LllTPa+p4sXMJgPJJLH8zdRidK35nPQyQpsE5y0xdHuEB/a5dAJNTcXxqq7Ot4+lvpnkB0s1Ic0Wb0e3U6CAc99uI9BLbbD2tV/W1rAPQLwJQ3WExd6zy9l/eABCxEyDJYhGN5qPkuc+Qdg7OL6Yd8QnhxfiM9GCCpcOzqqya/x6Aw0fubZvDZJyxfboWoOjfOOfZDuMqJy8o+rBN9xPsxg5xcfOKlwFKkP/Rdzsdbo9vGiCtBgsdd7pE5/nPZa0AyHwagF8EVFdKgP1F3y1dEVP+rUaLYmK68/7r+mn91KzPcV3/gvDj6nx8jGTzacJand+/AOXYDOB7Jfx4YMSfelnPh3AhSCQ5iAU9lOHSLxUrJBrqcWQL7q5RvKxAjvlkfw1mXoikbP1MmtcoCFBxUjj5kyqb3AH56nziXRMYVQCwB5X8rJkBdWETYevPkvt/LGk+gvt/aY5q7v8eedS//eW9/n9L6rT/sTJ/SAgBcmaknSORkEbo0H+SRrR4KOQJTXje/Fvjw/ND7euHMNAghkOY7zREQDi2IyEC21EQiRjNMAaiEGMhGjEOYnw/QTzEIiZAHGIixCMmQQJiMiT6foQUSEJMZTgKkhFHQwqiFlJ9P8AYGIU4FkYjjgMt4ngY4/seBBiLmMYwHcYh6mA84gQQfP+GDEhDzIR0xCzQIU6ECYiTIMN3CiYzzIZMxBzIQsyFiYh5MMn3HZ6PkxENkI2YDzmIBZDr+xYKGU6BPMQi0CMWgwGxBPJ930ApFCCWQSHiVJiCOA2KEMuh2PcvmM5wBpQgzoRSxAoo8/0TKmEq4iyYhlgF5YjVMB2xBmb4voZahrNhJuIcqECcC5WIdTDLdxLqoQrxPKhGnAe1iPMZno/4D1gAsxEXwhzEBpiL2Ah1vq9gEdQjLobzEJfAPMSlMB+xCbEPmuF8xGWwAPECWIi4HBoQL4RG35dwESxCXAGLEVfCEkQjwxZY6vs7mKAJ0QzNiCIsQ2yFC3xfQBssR7TAhYhWuAjxYliB2I74OdhgJWIHGBHt0ILoABOiE8y+z+ASEBFd0IrohjZED8NOsPg+hS6wInbDxYiroB2xB2y+T+BS6EC8DOyIl4MD8VcMV4PT9zH8Gi5BXAMuxLXgRlwHHsQroNN3Aq6ELsSroBtxPcMNsApxI/T4PoKr4VLEXrgMcRNcjrgZfuX7EK6B1Yi/gV8jXgtrELcw/C2s9X0Av4N1iNfBFYhb4SrE6xneAOt9f4MbYQPi72Ej4jaG2+FqxD9Ar+843ASbEG+GzYi3wDWIO+A3vvdhJ1yLeCtsQbyN4e3wW8Q74He+9+BOuA7xLtiKeDdcj3gP3IC4C270vQu74feI9zK8D7Yh3g83IT6AeAwehJsRvXAL4h7YgbgXdvregX1wK+JDcBvifrgd8WG4A/ERuNN3FA4wPAh3IR6CuxH/CPcgPgq7fG/DY7Ab8XG4F/EJuA/xSbjf91d4Ch5APMzwT/Ag4tPgRXwG9vjegmdhL+JzsA/xCDyE+DzsR3wBHva9CS8y/DM8gvgSHEB8GQ4ivgKHfG/Aq/BHxNfgUcS/wGOIr8PjvtfhDXgC8U2Gb8GTiMgF4ttw2PcXOAp/QnwHnkY8Bs8ivsvwPXjO9xq8D0cQjzP8GzyP+AG8gPghvOh7FT6CPyOegJcQP4aXET+BV3yvwKfwKuJn8Bri5wy/gL8g/h1e970MX8IbiH3wJuJX8BbiP+CviCfhbd9L8DUcRfwnvIP4L4bfwDHEb+Fd35/hO3gP8RS8j/hvOI74PfzN9yL8AB8g/ggfIv4EHyGeZtgPJ3wvgA8+RgQ8cQFORESp8GiPiBr6ayHS3wgLGQofyetmRIvPmSKjVchsZPTQVwTUESpjxEg4GdHic6aoGDVqMCpm6CsC6ghVfGRIzzDSiBafM8XEoaciDn1FYGooU8PwhtA0jHAZZoqN1yCzsfFDXxGYGsrUMLwhNI1IQedMcQlhyGx8wtBXBKaGyhg7Ek5GpKBzpoTkcNRgYvLQVyT5G6FMDcMbQtMwwmWYKSk1AtWfnDr0FSn+RihTiSPhZBiuNMyUqo1E9Y/SDn1FYGooUykhPcNISb885T9M2vHoqTBm/NBXjPM3QpkaPRJOhuFKw0xj02Lw4+a4tKGvEPyNUKsNwxtC04gUdM4kZMSiBtMyhr5igr8xKmRoXEjPMNLYkSw+Z0rLjENm0zOHviKgjlDFD8PjQ9N/T8aMyQkwBjInD33FJH8jlCndSDgZRrgMM002JGGEZRuGvkLvb4QyNXEknAwjXIaZ8opSUP36oqGvKPQ3JoQM5YyEk0m/POU/TAVloyATppQNfUWpv5EVMqQP6RlGyh3J4nOm4hla1GDpjKGvKPc3QmO4MKRnGMkwksXnTFNnjUUXK5819BUV/kZeyFDJSDiZMpLF50xV89KhAGrmDX1Fnb8RGsMzR8JJ+S9P+Q9T/ZJMjLB5S4a+otHfmBYyNHsknFSNZPE5U+OKyTADlqwY+orl/kZlyND5I+Gk7pen/IdpuTUPamCFdegrWv2NOSFDS0fCScNIFp8zmV0FUA9trqGvcPgboVYbhjeEpuaRLP6lxMk/qEsEnlYE76FEBcE/xA/9UR59Vvz8z95DkuHs3fWDnjYOnd5/ObHrgoK9QiJBgxpSnEw/Oe+k+aTr5E8+H8DJtIGnmI8wfxqbHDP9TC1VlJSWTCksyDfo83JzsidPmpiVmTFBl54mjB83dox29KjUlOSkxIT4uNiY6KjIiPAwjVqlVPAcgZwaXe1KwZu50qvI1M2Zk0ufdUbsMAZ1rPQK2FU7eI5XWMmmCYNnVuDM1jNmVkgzKwIzSaxQDuW5OUKNTvC+VK0TDpBlC5uwfU21rlnw9rH2PNZWZLKHKHxIS8MVQk2qpVrwkpVCjbe2y9Jbs7Ia6e2JCK/SVYnhuTmwJzwCmxHY8tbqnHtI7QzCGlxtzdQ9HGiikCtvna66xjtXV01Z8PIZNUazd8HCpppqbVpac26Ol1SZdC1e0M3yxmSzKVDFtvGqqrxqto1gpeLAJmFPzpO9mw/EQsvK7Eizzmxc3uTljc10j7hs72xdtXf2pSdSc3MOkLsWNXnDqg4QWNR0EOp8a/bMXVNd3Ux3i69q2sCmp+D0lEtPaPnemlSrQB97ezcI3p0Lm4JH0yg2NyPR3Jz6hqY05FpXs1mgYjQ0MQmQKEnVI5O0j4opCSzqamjPyosFb5huls7Se/FKNNboXi809KTtHV1XcdD3N6irEXoXNenSvDO1umZj9Zg9idDb0LNvboUwd/BIbs6e2DhJ03uiY+RGZFRwQwyMsRabTlvItV/VhHKkm4su4hVMAnLSpPNyGaUUxFLoNZXiNEzNBDVqRf2t7I2dSg2hzIjVCb3fAjqCru/LwT1GuUeVEfst0CZ1l4DL4bi/7c3O9k6eTD1FXYWmRc5msOei3Jwub73OGSt461FlsKAJFzVP1aPK09KolTcdqIAWfPCuWdgkPQvQot0LFfrsZi+3ko486R9JWkxH1vhHAstX6tCdH2KBnOTVZAb+xcQmJ9RYpnpJ8jmGRWkcw6dG2KNQZvQuaMo09m7SZq7s3dyMpqnFUOztrdUJtb0re40HfGtadEKsrndPfX2vs2alX6QDvic3ab0Vm5stBJXqLZS04U2oauK1XLPU4rR8cy5UREJtLbISH6epmCMc4Ir3zinA6gpWkfuk6l6p2iVV90jV3VJ1u1TdKlU7pGquVM2RqtlSNUuqKqRqhlSVS1WZVKmkSiFVvFSRivOxfhfLMSzvYHkLy5+wPIxlP5YHsdyP5T4s92C5G8sOLLdguRnLZixXYDFhWcFoPiiRvl+qdkvVXVJ1p1TdIVW3SFW1VFVK1XSpKpUqtVQppYqTKqiowPooljexHMHyHJZnsTyD5REsD2HZh+UBLDux/A5LDxbznILEsMSwki0HSFfFXPWWW9VbrlNvuUa9xaHeYlNvaVVvEdVblqu3LFNvaVZvaVJP0KRrBM04zRjNaE2qJlmTqInXxGqiNZGacI1Go9IoNJwGX0DeBL6eq2+cReq9T5qgvkXwfteoO0DCFy7zKnWziDe+HuoXzUr1lmZ7uY3sNDtAfHsI+c1VWnqQHQRCfFddo5Xr5mZIzg5NqYOe6hf0PArjSQmoEQv3qcc/raa9jdi7hfVuob1bWG8q2bsACuqNm1aOhbMQHkjknKODZtZYqbgLmvZoYFZz1XKp3sdFhKM8K7VpzbOSY50zmHDT0lJXaw8p6C9nRmA8R+ILIgoLHcqtzK2kQwpgQ9H03SEPpa6elqY9RO6Rh2KxOw5V+X/2njGE9NrPjuRjNpEmbi23DFt/gBbE7VjMWLbBVtjK7ZPm4Gd6E3ixVQefKo/gR0wX6y+EyxGr4d+ouPWspxxacLwFZz+D9QwcM2FNGI2tZDOrfwVXIu2vuX3cYe4wG52JdOvoDClz+5RHsJ/SuwIegPfJkzjnMrgOxw7Ca3QVUt4K98MpMhHzJvIx6eMWYC+h+yOddpy9Ffl9HI7Cv0gimUF6yaM4J55by3iRdluDc57B/BqjQvM8YiMO4iJXI80THM8VIVUHt5HbyXm5w3yzYobyiCpeVaK20d8cwzsdD3EoIaU2Hz9ktmC+JEBVyq8Sjiwki4iF3EB2Ig/PkD7M33C53EzUOs3X8ysVkYrPlO3K2zAfUS1W36xRIW0lqGA0CJABU1CqGtxjIfJshovhUpYvw3w56nId7ICdcCvsgj1wCJ6ie8IxeB9OoXZiMFO5SkgZWYq5GbOLrCZXoj42BeVryE1kHzmE/L1I3uTGo9RStqH0EpdXcNu5h7gXuT9zx7kT3Bfc1zzwYfwKvoV383fyu/lX+FcUcxQ7Fbcq3lW8qyRKL9NUvCpRdaFqE+bN6jB1u/pK9W/VN6sfDs+DFJQrB+Wqw09uJuhBSS7Hy3svs9oezA/BfsxH4AsqB2afLAnNZaSa1JLFmJvJMrwBdBA3WRWQ6A5yF7mHPISyvIn5bXKMfED+Tr5i+RSn4pK57IB8C7hGbinXzt3AbeNu4u5Fj9zHPcq9zb2PMp7gvkUZI/h4Pokfx9fwtZgX8Rfwq/gr+Pv5w/wxvg/tFqmYrpihWKy4EGV/VnFC8RlaklPyygxlkXIqZovSrlyt3KS8BT26T9mnimRaiVclqKapNqh2qPapjqpOq5PUyep0zHnqfHWj2qbuUu9Wn1B/qrkvrDLMGuYKz4Hd+PnnkTOidz/9XR7uQpUeRpNj6A2X8DE4S6Cxx0WqbWFWbh/lTt1IJqKl3oNTfBjUK56FpfwFYFO28BHqL+Ee4lasJffytXAf3KnuIo/yK/k+/k5lhmqapE9uO79b3aNeqf4UOf2Gv05pUeeRSuUmcg83EyPaRRbCd+RbuAh39nCT4Vm4GjaSLnzhbNXcR6Iw1p7hxpNNytv4vYqdfI1yNZmEFtQqj/BXQREk4WejiZCOvq7Ez470wyBHf6eaX4PRz+MLQlcRo36DKN4gt+NnKR8offxB8jGAvr8vtg9mfoWYbyiMS4vLSItLW8PD6TUc9IPyyA+laxRH6C9m1/mOqb9R9iHlCKQ/GnQwDe6omKhQacIi4hNTR6fpIrjouKRpfFmKdgpfoBQmZGTmqrKhYF0kKbNEH+CK9mZncwfIVRU5wAUtUozLTNLHksgJGVOmqYpB0E70jMuNi/UUK1M8+mvHHeCm7C0uVhwkAvLaV6Y/fbqvLLavjJW4+BQsUi0NYmcf600pY2MpZfmGFEKSE7CkZGRmkeLCgiQ1wUZyEkP8yMceUzKKi6Zk6tLVg6s6Uqdc8WXSDzfzHTdmEKL7w49xcRETCT89TTidlsdXxmhPqxLio/jyyOgfY8pISXVU9NjZ5UnJKbNnRkblFmaQHxUps/t/+PFzRfuCB/50oOqnWYrMcO6yUdGnSyMM3Oq00acFEhcbreV6soWfPpyzvHxsZISuLDMhIb14UkREFtX7VgDNVrRhCr4hpsJsWATL4baK6NIZRaR5cXHpVH7+lNTFqN1HGoEbNXaGsvkAV7JPq18/F2+gFcL89ZOr1odrG8PXTIalo8ZOKZq6FJV8QRaZUJDKLYy+AO+SFYkFCauiV1VMWJV17cJadf2qioUFfPFBkga5+r6UMlSpvq+P/ZN0zf6llOlhJjND7Onv+ug81H+ZbA+9Pt9A1FmZWVmZRVNQ4/SDtVqtSkpMSU7hqQlSiIo+J6WkJKtVunScVUL1rywh+ITGSC4sYPrHJYSuw2cc1qVnFFBMSuS919Qndr76954ll124XEE4V2LCbMXFY0f3bvjx/NKk5CUcr96+ffcS+71kuoVUbedfv8yZO+UHbf6sSQu2NhfNI/M/tlZUXNk/M5OI+fkGvm1JbnnhBW2/X+hsbLRr9CnJEXOmhEf0n+KeUpScnp2m0QiNYaPyN65Zu7RqafuzlVNU+ctPv1ygUUDqeGdDb13h4p++vHZW/sSJL7fP+bseE0bs/b5jmm0YLRMhG/IwcqdACVpvOtxckaudNDnHoNDHQ2S0Nis7L7+gcEpERkpRcWnZtHKVikSUTJ2uFNalZKyLj0/R03gZp4oYqzfQecUlpWVTI4pyJ03OnlY+XZXDR0SH8YfI+XiRLKiIyLo2Om9sjic3N7roILcYwvTMdFhOf3OCmU2KCORPGqFWi0sZ6EejJSniEkGXDkWxGUXFJZLxqDVKaNwkUuNkoVmSkklJQkIhT1KIMkVJ1BkJap7PSuBtpLX/+XeP9T9PWgvq1huvOFj0ZM+k6WExeR21179XdlvTukouYeJ35YWpZM6k/s9Ivab/HdKU2v9goaHubf3dCsvG3/XveLf/BVKM3TdvHB2Z1HbNjrw7BWVGVvkhw8a7osl5af2Pkur+YyRjfP87Kr22/6tJH/QfiiNj+n8VRzz0e7Ct8KPSpxLwhMp4JIYoomLilXCAa3lYDQp1vIIc5BohisoNzGVR4hQV8GqVmvpqZhYTNx6U7+reOv1Nb93ytKicMeVtFbZl8y4av4uLVwkFt55u6X+voGK8vr1y8/pk12u1ZCw3Gk/a+2Gr6gQ7acfDxfsV8UnJCnVlOLkFA1iLGIUWou0oTlkRBol8rAqjOvwQKYNxZNpeZXxsZQS2U8k0SCIiElFS5Ez0yMMA+waPPCxS6FHj4WFN+c83lBSlJZGktKI0DCEoLACMszR8LPZHz/2qkp9mnN5EDq4iow4fJqNWkQOnN916+Kr1T23dupWr7d162bbHSXz/V49vu2xrr+XBK5944soHmTSg6mTShMG0inAN3s7WwTqFEo/vuooo1RoFisJfy12rCAP60VRzm0LPjuXTcWUwk7XoWZFvyIhLS1DHlaTFqZXzfjxMTM8o+WdMiuk/Hm7Bxg+nn6Fv3kw5f0ge+29krick7//lzI/5v5Yb/udldoPKIIcD37gWgP87aoIeVCy3OVArP5PbPGiV78ttRdAcJUQqv5fbKohTKeW2GtaokuW2BhJVN8jtcOV9uJvUjoAC1W65HUXmqd6l36Ar6P0/UjOJtdX0L9o0RaxNf1fXrKmR2wTiNXvkNgfRiUlym4fiRCK3FUFzlJCaWCK3VZCeeL7cVhNIvERua2Bikr8dHtGk2SW3I8CctE1uR3Hbk06zdjjlM/VG1o6gfKbeydqRQf2xlDe5nYDt+NT9rJ0YNEfL1j7H2mOD+iewtX+lbU3yQH+kvO8uocBgKBbmWU0uh9vR6hGqHC6nw2X0WB32PKHSZhMarG0Wj1toEN2iq0s05y2yiMJSq73NjMUttDrsONgtukTBLLqtbXbRLLT0CPUuq1uY47B1iG7BaDcLVRajy4btWdY20eboFqx2Ib+szMDGsJGfJ0SFR4VT0kEEHS5rm9VutNl62B9LmoXzOk1Ws1GYa3LY3TlCpcvl6Maa0mj0GF1uweMQTI4Op03sEO0ewYPU5BUecZWHURZajR1WpIcs0mE3kvXz7XLnoZBsoxzBJTpcbUa79VL6QDdwiTbR6EYeJM4LBKM7SGkBfeQwsh6LS/RL4nQ5uqxmUTAKqIIOh93q6HQjAwFluUWP4GgVrFQm3MXpQj3bPUiLUUJxcA2TymEXKT2c60ReHagX1t3pEV2Cu8ftETskVdNloqQCNrvNZXRarCac3okWRP5xQavRJLoDOkdVG7FILLQ6XMKCqhyBsupxuHKEdrGnxWF0mWkXUkAJXUZTewuaJYeKZBbMLmsXdput7nbR46ETjE7k3Oh2S49OF9szB3W/KkcQPaa8HKq9bhGdC+uBbVutNqo1mxnlQ3oOUycTAjc2Wm0StjhWidjRbbWbme1NNqtT5o7K3m1EPbQYKSN5wly7YDSbrdSTc4I81mo32TpR/fLG3VaPRWhxIKBc0mxUFSU2oF20lLUVVWg3oTjuTpOF8e+ySmZyOGyS5i0Ibuo7RrqT0GajKpCZdNIet8nqdjuocC0iVV+Lo6MFhy2iqV2QJQtSTIcDjRLMlLXD2IZ8BxgQjWhriT22rQ3DBU2E3tDRgjxRYh6Xw+ZoY9aXp4l2k9VlsqHn2VG9LiObh15oE010G+oxxg7qYVQYJhaznsvRYmT+7bThDjgbowOjCWMZp7Jp2O7EqLf4HWuBwyr5sUTDjExIjyhVq0u8pJPGaGunnW1LzRLkqQNOivp20DG/JWmMG9FoGFGDeHb6d5ON4DnLKYWyOnBuK+rMyM4OStiE/LR22ujmZqPECpLrFumpx1g3W+kKyqzZ6hJlbumA29Njo8LWout2GV1W0dMjydrhNJo81EItnTab6JEMIaJu2uXTyuGixwxz7aVUM5TFAeawLdELHA5toqND9LisJkGyHdXKJZ3IOLWHw9bTxs5DPALbpN0Yc3gg5g1ooEFs67QZXVOFeY1T2ZG/BDeiuivKMxgC03LlaUHRgsa2Mjczooe1WakgyBh1S7HD6GpHWXAk6LH17O8Sqmpqk8V4qojsvPZIrwY9EnCwDUyOTjsKSVU6QGJRj9PB/KLH4vE4p+r13d3deR3+4TyMUb3H1Ymqd4p6ZmV9t593fbOjEw+NHnru4d5WyQ2oXdC9O6wej/SqolzVLD6vkh1B9AFPbHMnGhA57kZ3tASttQaODzN1RDzynDajZHV2yqEM6Ll2PHwE/+YOO572E62TBLGjha4aoGX3zz4rS2w6O0fQzNT2/jCRt2f6lGlNYxxMtOIu+BqgKnfRlxwekXabwxi8KYse+UAWApp3dHrwpMN3UpfVJNI5FtHmPEMisIMDXPRPMMEGjeDB2g5mRBfiLhDwOmbAXIyteWAFE/Y7wI2lFecKUMVWOxkasceKLTt+RBagEunZsG7Avjaw4JibPYlYizi7C9GMMxfhmIgjS3GeHWea5ZrObmXUpJXdbBWdaWY0KFU7oyFAC/Qg1uO4lc2dg+tsKJPIniSJKK8WJpdN7p/FaIj47EDqAttXwA/3ZZgNQeuknnwmVRT9Oyssfq7PzqGDcdLGKBqZHih/tN0hc3wedKIurUzTAszFNqXjhhymORfTcrf87OdDso6L7eXBcYGt6kDtU4koZTuziUfmbfAeHuxbxcb9PNMW5cgq8ydp0b/aLXN7pr7p/nmyJQckonxS2ankbYxjK1waGPFL4GLaFvHZLeshWOcFbKb7Zzwt1D9ygrilNaV+pk2cjEoX04LI6AuyF3SwWdRfO3GmpIFQz6J8ephFWxm3fjtJsjgZumXNS3wN8CRZR9pnwFYORtvPn0TXKevVIfvLwOxOZjcX46QHi4dZOtir/buJg7xggHYbi0wnzqLcS9Q75RiU9C/tQH3BxKQJ9XOXrDupDtZCK7O4AAswuqg9/Fr1sH7a045retC3HPKZ4p8l8SDZ0MX2bsdZUrTkBKxkZlah0dQlzzazGG9ndvEEKBiZDgUmoVu2mn/Uydb75cyR/X4Va9F5JpQ4J+B73UyTtsDz2aRtZTHj9zUb8xuX7JFm+ifsKN2AJSSJjWxNcJvqZBXTeA7b18osOhD3JpxjRe4H685v927GH5WphbUkjeSx08TO5pmZrvxncs7PnLG0RXfqlL1/sMTdjIKFnQ4OuSXZK5i2UdaXxNnZfFeKKSvTnInNNMnWcbNTyhKkf5dM2R9NDqbjYJ+3yC134NwxBmSiHm8LeMFgTToDc9zsZHSzmPNbrkW2fI4sbQeitJrGAPVP4Qybnd1jOhhN8RyasjIfaJP1HaoBkb1LLWdob0Bam/x2kaJIOhs6GG+2IM487Oyjb7e2oNgfTE1klrDiTBPzaDN7T0ne62Ir/PSks9DGNOGXxn/GGJm9pRjwW2bAWgOxR/lpYf3+89vJPM8dOL+kd4f0bpLey6L8xvNTk/o75Xe9JeTEWoCj1kHncTAfZlkTwaMuOZJpfQlSFgMcdDLt+KX1R8vZz9SznaSSfzsC686MSf973ChHmll+8/6cnp0hsg2OBM8Q71KSXR0y3VbZz4xB9w4/xyZZP1QXtoDk5qC73sCbhtrKf9cb0LqZRX2r/BaRNGtmHieeoVv/Cuq5PfItjVq2Vj51uxgvVnbO9QyyK/U+I6Pmj6EWxq+NzQ2OCFH2m/Yz7lZ0B/9tZuDUXhrwGb8Wz6Y5t2zBAf5Cbw5t7G7UwfpczGuEQXHn9xXqf0b5VpEjW5zeTdqC7ofSLbBtkGwDmjPKN7Sz+UADi7BOdj66YCrQm1Yjq/23/CWyRH6/K0JKdCSUWu4Z1M7+bpEi2xp0mhnlM6yNjXpkvzAHnZYiOx1d7Lx1BNacfbQVhvO5xO/V/jhZLN9VxKD7tQeCPzXoZQ4cQRKY2Pljly3p99KzcbEILedk56//vOhh0eHB9lSkrceYoTmP3cIHr86T36N6tk+n7PX0lNUHxbJevjcE610PzYxD6aZBI0W6a0lyWwedBv54kU7vDqYNvz4Gfx6oof9tEH42GbgF+UekO7aZvcU8AR13y6ej5Wf2tZ7l9mEOnIjSLc/JfCs41gfucoJ8S/HIEUttIIRITmdId/uJuG4S88YO9qY3/yxf9hDaQ9fSAPWB+4gUzf64P/NtMlj6Af8czNe0IB1QSSRZpE8Dfi93BT7JSbdIO3tTGn9W0oF3z+AbsnAWn3ew25x0p5M+J3UxacQAHQt7azl/wUbzYeDbBjHoycjuNMHfP0g3Xv+MD3DczlYY2TlrBvq9hfQ3FQC+Uvr/K541KdhfGIwBosHZ9K8L2E+xCPu5EhZtNQT+9wFtuWGdtlQVNnn9nPWnooia27lOOwm7MjhC8iMMYSpldjTPjVaCwagKz1YRBVlXwhHFzkbDQkNOUM+Y28atGQPlLJ+P3uBmZ7jItDCDZkNaEDFF4uLdPY98fOM2cu/ERwy7W/9wdfplRzU71yUdN6zjn8aSu5PnCMfFzn5i1PXHr2morTp1rGNOVP4dhqgAq0SJTK3dxJjkFytUCdyyyvwkQwJ90CRELhXp13t2ocroFPMTDfG0W50QUd3pajHau6w2m5gfg9SwNzxBtchi7PaI+WMNWtoRkZAodQhVosvDvi2nX1jljzeMpcN8QrI8vMjagbsYO9gX4lWVhnEpUYbC/ALDFANLy1Ki8uljYUFhUVlR2TJDYxCzixvzUwxJ0v7RS0SXtdHaZs8R5tpNefnZhknSRun+AbYV/aZR2qtRdNGvt9x003UkPVgrRAn8OhID2B/OrSMEdr2w944/vyQ8GP6rq+/b0HnyoflfH38q5ok242O3m8e888fvXyi890rD1U2rNx9rf6/4lpgnXvty1T+771rtKH/iugejDlm+sW194bGG3HvnTP/24TcvXKHldvygbx93x6nbt981+gj3wa/Pa/goeuWXFWNWH4x6f+ZzDx3f8NiKSy/Oz+O3rU24Z7bwcr47amnuS6umFF4fvy3+4PsW/e5PPjrcu3nynzalbWh97IqmpY7OJ8p3Z2648IXYpPIdV36x6Klw+9P9z9S9d1Add2P65cdmZL02btWXO/Kf//qT9FHHnt43u2r76BU7x205cdG3X13+9a/ubSHXfjsv4v1X05fcc/1LD2zseuCrQ1H/OjHv6M4fLTsfSJy2b8NTf+R4dPzb1x4zrH3bMEWlQY9VKtWEKCYaMg0T/M8Gsj5V/lLWYXI787roV9yod/qlLPOdsQmE+BQagworjoChkvaNV0w1lBqKd07ZWbDeIC83uWyDVuslXwl2larKPJzFPHVshiLSEO7ngtcYomlnDN2L/t2OCjnE5zgFeuYdowwpfv/mEyIXNVaio5Xm5ucWFZ4RFfzatVDX/v0XTYerx+Rf3bMt+4Yn1t1H3hpz3kve3ib7cc2k2y868sJ1CZ8qGqL+MTtLD6XeE89fN3/7G+ktSadmlqSd78xf8/Wm0g37PvvsRuh/ZfEN8yf8ZVfW/EsfeMRY+a/JL3/6/NGL3vtj9lUz9t+8/+gHS32PP/TM6m9fibzl5I392a9Pa9BqS7NOzazDGPYZ1nGfynEc9Xn2yTfenrQxtUAZdtH2ro1nxvF/JTJCw9FQGhyOS4e4qd6QK22a+UubNrIfvv5iSO5dMHHOe69bLr0ytbq188LVTx/YYcr0Ta+66fK40tiMxe6jnVnW0/MPCstfD/9+p3Zy3+Ilaca3xx078Whh+3P/eO/2EvE32usiH24ct/zy1qIVyt6a/q75xxvX3LZWuPmBjctv05z62PD9V+kl580Kf/n4s+Offmvx52tn7m+4PWc3ufSft+2+pqh/xycXXqzc8b+qN++oppI9jgcIHRYJXYrUiBS9oRjU0IsiIr0j0oIUpXcUSVSaCAKGqpAEA0SaiBSlSBQQEBQFURBBl44UqYoovARQ2VXfvvPOeW/P/pUzd3JvZu78fp/5fmcmyh6D91LqV9vsl9VG6bFa71BGngSpuYrYbZJTCX102EjDjLDDDKyAYOu2LI8P45bFYKJa+i3JsQTuQsSgiZdep+K1ci9nwbIUmWrl0ZB3p0KXuUegRSUz6SaVajKYqpAbq13GBbv8wzUm9wnh3blHrKrFXV+CIjS3RUV4bKZkK4B6+F+mJMu3lKQmK3X5jWSUAaQASSwUKx4p+qtk9Pfzk3VyWE8/7vX0ozzi32QgXf1/lIEKf85AyihHBXv3HjWmErZ5E9KCBhq+3OFLqU0EPahtb29a+O3l2rJ+vbwjwN646M/fldR//KowR+lp7TrD9nOjETzn8nYmn+DQWWmtSlOnacs0sqG9eDbfa57fkF9895zbpZOiH6pbuTFTLP71rkE979Ido0h+lz/G+IeKFeSkhaWWfkjY5aO/O4D/kHrv+3JWYdPuIGwq2sntC+OT2PcB1YyZPcvsZtAMB7m6UOqbYZF1+AcXRWWCnyoG1iT52S7fGTnCxSTWNvSsS2G3rhoXgs0+VLyJ4DKT8sT7ncroAmt439PTOYE+bqSrBgcBRZFSfMl2R4R0T/wNKfqwl7xltmG/XyN4rSJiigA0GEJGwKcNBLCBSKCLCEQ0+1OVJafJAbWtbwxMJoD319xm5hDV9PIO8V3ftJR02kU5ogD/00bcbpgQILDxZa6fbtHBRIAdG8PE+73e2MvLX1g9wN/Vy9fNP4SCh31wAAYDAPgmHuQoJxRhm8W/oUV/OZVT15K8Rw7MHeWXzE4NtgMm8MRLEsc/rmKO5FSuXsMLq5w2wmfiE+zlPJ5qOIdMFwa2mPbOvbsaKZCQfd6lrNEj1FGsWxDRz0aVNJbScE/WJSPDFZresV/mHku5JZSkM8qkopQiQ5Tclz+pe05j8DxbdcZJM4dC9GmcvWzQkfH0284HMgwFYAzinNnE0URp3hHlNCdOe0taZLYg3DjqQ97MFeom/s57ZtplMRH39k+aXjla/CUv9JT/0RLethRGSRGQxWV7N3i1HoQeYb5ms3LdhYkh9xnK3GKm4oAdNyoI3LtUVxyBWb3ZfrY7b7uvLaK15j1DjihQRnehpUw4iOPCwCY38gEUAUDhKXlJBUZlAKjUiG02Hd4zbr5ZYkbhnLf049ce4Xz//+OH/osYX6cCZoy5/tJ8Kq/iVBWV+Msg9nlbe7nsLOZHKrSJ0Qkt+0dE5t5bJMuUYw82O858ftF24IA1ca+p26r4KdWWthv9tKdfwy4pZ2/zdq9ehRjwutV/7tAcZLcWNphwDCu5wdcsDZeQrUPiILESbE45H0wFlkVaurnmjQs9NeXov6B5Pg6fOMlqtFQ7a/ywdrQB+CwMY4wWxOzarv9ckJowG/GG5rbNQunrZotppO5DY9OK2zSSkLXL3e8ZEsKrUhsL4DJDoUP5QYOBWFCHuyrp2d7YN+qQfEV3fvdXim+7BMBD+drgZmt5JU99AVbHSiZ8XOdzU1WddgGzXO9XkP1RyQHZec+wZCo8IIuDkk1h4M6cblAPEixg722gxrnsvPvVJAj+XUgA9pL1ggIMrqAAU6AIeDLi5fZ+RQIq94+SgQNg37AbTBYOfq5kKeBP/p1t61MI2WzQGyOdT3l5On9tGdOvWvarbsqRf/SHbooBIhvd2L61xhm5Lj4oasRw3RQI/0gSVgpJGNZJ8qBN+FLNwJqK4XTo/S5xiaXAxyJr7VLmR1uvVqJvKYbIghryGZ47tVQSlsZJpO7SuBQ8/Se2CrRxxjt0U+22xvz6aY/z8Sb81YafnKliSNxdaFeQWrDWIkTp6IqT0ZtPyneG4aUDTvRiB3zUFA4ueBTrLO70ExJ9pMEnZFRhnNGZ08HRxKfqQ3dqDiOidVxjqr4l3Vm4iqTwGa81EnZLcE9Vbv8CbiBThG3VEqZuphReYjk6NGkVIlHwQWoPu6pSsIrG2TzXoXBRV56Rw0kNwVrGB3EG52OSM+tPhE0wrkTSnFlK90FI57mktQ3I/i5NvZ1N4RByEQEpmY0SEIQae7WRY48mB00lRX4f0J/pcJp/Bl4gdIybBpyLzBdqGhoQeN2iCv4G5gZzSnyU1jvW7GtaNLyEleLhXiEtm6AAvm+3cFKDWYSYQCagALJd1wSpA8zrwmfdd+gAbN8EFi1AQ/7YkpfrGHMafDNPW3VzgplZ4SkaphLjqP2cIW/ZAdm8m+aT0iH1J+VzO891Djaam+SX8z1uG5nFLptXHLpyUHyYuKMvtGuJOxTyav4y/yTDsbILl+/EWVYLtGE6MVfkFxL716Iz7fR0DfdB9wvzm8I/n7HlSn7QJxD/3sEYMUw/5TITMpnw2MIJieHVxYYOICsHoMWrzZCKJnxb0/GL3vOtrwrQnvR9SL47+UuR9xk10mahhW6hpSTpvJsuOwglUQweqRxVN/emC9HmcCjl1BcCKndFXgC5rY4QgRKLS8Ozoex37RAs8NlkUlL0UbA1re3DJ93EnrdnEoN3rtz2JCTQyVuW2kmxswFoWnkyyvg3MMbkoJP1iPKfUBDyhxWKfwoyvrNvn4K8wl6KW4KTtRG5qEgpAv7/k35s1tP8ov4vJVE7KkWp2BY/Rxro7yjAXOpGXNtx8cGxyN3H3pf6LhYURruX95aKhjE3NxP0Eu1EOcaXF8WulS94BhbPTF9HPGyot7JVLSjzk4fmOqIcQnCOC57RmA7P1w+zn103Yg90uOsdi8SlcMfkHUN1aLkMvzLPUmv93BcovlsLAA13nwnDsD+3FMwZM2Buie7Dd5ukn2x1ak13z0iyO6LPPran08bG7rhxjp8sofq8NmscH1fgI4bejFxvrjH9Sbcvx255JEztMoIrXWzS0eW6Yph2c8H1+ot+Rp8T/llBcYIXPFInRo9rt70Z8WF96gRKDoOlxTPf5qgt65ieHRCZJto7TMM1lR9sSCI0VRL5jcT/4F2+w2C6x4MYYNJuMM1/lI9OKOdqwZMrX35BPiLlqhgYhQNQWRE/pQjO//rfwb8fxYLehvHTAjQANawKFhG5f4vx++PJOm8PN8rVPZsn4vz2UBKAEv/k2JdbN4QGW5yoJqAOqH5zotSR8r88sbf+XKTvjw/0/5knVOqZwShl2qZxHjP1dBugbh4tW+m8r1+0p+CsKWuvXMVH9xHWFZHtQSoE19DbmPBY2znNhnOZyDPRhkan0ZyL5/xe4OtsW6m9H0NP8tQYcxJi6iuHcG24gGuJPsr89eYg8/KP56G9dvIr3RKhdhm9uSsLc+rbC810ig71JSpxWDLqzs7DonbUgONtIEiacWajDhxLbHptDym/g4FLQqS8wiJG4KlNpCKh9cuNqEkiXLVS02NQeFa7Jrx4fNbsFu5QDbLORKGnZYzOCUwX7Gm4dqg6c0LTOupVEVPEolWjzNDwWZvDw3Ih06IXklhkywxtmu6rWVoWPGsf3ENqnzyVDQ+BocGPyNh8SE1FBaDK/zFw/APgvy9jY1FjAOe3CVWSCkZPQ7u+PE+ZZjeHnpEGxrJ15Zzc9O8lZthvwNZaLkDs+41gGDlvFTC33CLOzhvg0p60qEmj1GsqcusB3y23sMCcAUesUsTen27G6Xzb+PjFJicOGiH+69Oo3w6s/llNgtFUIEBp/7NXVpeVDd1iEy2ESxx6usdBnQ6c18RI7Wrm/XbBjqb3n2qO+1vkMa3+dm/c6sRVtqi6jz6WL5uuC+X3iTqcE34YX0pkP7/jkPXSuTa96xUyUOuMRHGZaq9Pja9x2Bs0nDk+7Is6wm071IcdCTrPJ9cYg5/xRJ1unBubil4Jb3Qp1VrKOiKTlhObNj7IG/ThTvVUekZZyYT+DQEDzxJh1ZsvjBLY7knwyhZ51YxF3zBMGi2Mm0Hf5T0eMp4aeRtWH16hjVzWqCfSMdgU6pjt8TTt5xsOL3meBW8uBoj2yWk+X8bjVpFU+LjHFuJrXe5DkZXSZx7vNapwb3nRy/v2QWMiDk2WRWiqle8jRgdDU02SL41RwvvE/2RR8ydLqSx0DBsNoCZTBmsF8G6NPebvWztU5ND7VkMLY6PM9+QJXk5OXg4mt8+azN8toQcBbxsuImAPczDsd74eXGHr/VbhJyHg4/yJm+fT/PAwDUeJypzWk2DZwTqCiPXE7ytjRtryBI+K0/f70s7f/ijJpUucGpczXKhSy9LVQ0dAckovdhL0WE7EJYzzOqoOYeaHai0mXmB4FHH7apfhQrjesbnjVtiXE6SsqxBWZ4WA0qB4mbLehK4F95gx5NgM0avQmsCa7Ap9njtYWrCGHlAWbGwzqO0TieMPhBrz3LHmYNGwSpKoCljdvlRowRa4Yj+e+K7lLLsdH76Jpyf2PeItQVfbb4ia+EjWtaBEV4TFqeJJc3z7havpUpNUWo6H07oCbv3epRQfn2EGnWzio7F92dJ8me7sePlCTUdD6sWiFQkOYnyGaua/AHkypsYNCmVuZHN0cmVhbQ0KZW5kb2JqDQoxNzQgMCBvYmoNClsgMFsgNTAwXSAgNTdbIDc4Nl0gXSANCmVuZG9iag0KMTc1IDAgb2JqDQo8PC9UeXBlL1hSZWYvU2l6ZSAxNzUvV1sgMSA0IDJdIC9Sb290IDEgMCBSL0luZm8gMzcgMCBSL0lEWzw2Mzk2MTlGM0I0NzUwMzREQTA4M0NCQzUwMTMxODdCQz48NjM5NjE5RjNCNDc1MDM0REEwODNDQkM1MDEzMTg3QkM+XSAvRmlsdGVyL0ZsYXRlRGVjb2RlL0xlbmd0aCA0MjA+Pg0Kc3RyZWFtDQp4nDXUyS+eURTA4ff7XlQpaqih5qmqpqpZzfPYGlpDjTUWVbOdoaooNSc2xoUgaWKhW4mF2lYskfgXbJEm+n7nx13cJzf33nNyFucoirZub3Xabq0oBgZgX9DbCfbHBnTDQVAnfDWDG2FkU/i2JIxmCN/jYR/OhLE+OBDGd4SJXOFHMPyGE2GyG4gytSv8jIYS+CdMk3aGtLNDwsq1sDoBW8JaISwL6/NaqVrRgUo39EAvdMHdkz7tw0bX/UkHJmAMKujBCB7AM7CGh2AK5mAGFvAIrMASHoMz2IINPAE7cAB7cAJHeAq+4Aou4A5u4Ake4A1e4AN+EAf+8BwC4AUEQSCEQDCEwksIg1cQAeEQBZEQA9HwGmIhHpIgERIgGVIgFdIgGzIgHbIgE3IgH/IgF97AWyiCQiiAYngHpVAC76EMyuED9EMFVEI9VEMV1EIN1MFHaIA2aIJG+ATN0Aot8BnaoRM64IvWHdt70lXbfw3oT6+Ecx8Daqq0vZo+ImReCNkyStRZC2GuXVgYFBZ/CYeHcCn8MReOZAioV9rdf+rnbGcNCmVuZHN0cmVhbQ0KZW5kb2JqDQp4cmVmDQowIDE3Ng0KMDAwMDAwMDAzOCA2NTUzNSBmDQowMDAwMDAwMDE3IDAwMDAwIG4NCjAwMDAwMDAxMjUgMDAwMDAgbg0KMDAwMDAwMDE4OCAwMDAwMCBuDQowMDAwMDAwNTMyIDAwMDAwIG4NCjAwMDAwMDU4MzkgMDAwMDAgbg0KMDAwMDA5ODM0OSAwMDAwMCBuDQowMDAwMDk4NDAyIDAwMDAwIG4NCjAwMDAwOTg1NzAgMDAwMDAgbg0KMDAwMDA5ODgxMCAwMDAwMCBuDQowMDAwMDk4OTgwIDAwMDAwIG4NCjAwMDAwOTkyMjIgMDAwMDAgbg0KMDAwMDA5OTM5OCAwMDAwMCBuDQowMDAwMDk5NjQ1IDAwMDAwIG4NCjAwMDAwOTk3NzIgMDAwMDAgbg0KMDAwMDA5OTgwMiAwMDAwMCBuDQowMDAwMDk5OTU3IDAwMDAwIG4NCjAwMDAxMDAwMzEgMDAwMDAgbg0KMDAwMDEwMDI2NCAwMDAwMCBuDQowMDAwMTAwNDI3IDAwMDAwIG4NCjAwMDAxMDA2NTQgMDAwMDAgbg0KMDAwMDEwMDc4NyAwMDAwMCBuDQowMDAwMTAwODE3IDAwMDAwIG4NCjAwMDAxMDA5NzggMDAwMDAgbg0KMDAwMDEwMTA1MiAwMDAwMCBuDQowMDAwMTAxMjk0IDAwMDAwIG4NCjAwMDAxMDE0MzIgMDAwMDAgbg0KMDAwMDEwMTQ2MiAwMDAwMCBuDQowMDAwMTAxNjI4IDAwMDAwIG4NCjAwMDAxMDE3MDIgMDAwMDAgbg0KMDAwMDEwMTk0OSAwMDAwMCBuDQowMDAwMTAyMjcxIDAwMDAwIG4NCjAwMDAxMDU3MjEgMDAwMDAgbg0KMDAwMDEwNTg2NCAwMDAwMCBuDQowMDAwMTA1ODk0IDAwMDAwIG4NCjAwMDAxMDYwNjUgMDAwMDAgbg0KMDAwMDEwNjEzOSAwMDAwMCBuDQowMDAwMTA2Mzg1IDAwMDAwIG4NCjAwMDAwMDAwMzkgNjU1MzUgZg0KMDAwMDAwMDA0MCA2NTUzNSBmDQowMDAwMDAwMDQxIDY1NTM1IGYNCjAwMDAwMDAwNDIgNjU1MzUgZg0KMDAwMDAwMDA0MyA2NTUzNSBmDQowMDAwMDAwMDQ0IDY1NTM1IGYNCjAwMDAwMDAwNDUgNjU1MzUgZg0KMDAwMDAwMDA0NiA2NTUzNSBmDQowMDAwMDAwMDQ3IDY1NTM1IGYNCjAwMDAwMDAwNDggNjU1MzUgZg0KMDAwMDAwMDA0OSA2NTUzNSBmDQowMDAwMDAwMDUwIDY1NTM1IGYNCjAwMDAwMDAwNTEgNjU1MzUgZg0KMDAwMDAwMDA1MiA2NTUzNSBmDQowMDAwMDAwMDUzIDY1NTM1IGYNCjAwMDAwMDAwNTQgNjU1MzUgZg0KMDAwMDAwMDA1NSA2NTUzNSBmDQowMDAwMDAwMDU2IDY1NTM1IGYNCjAwMDAwMDAwNTcgNjU1MzUgZg0KMDAwMDAwMDA1OCA2NTUzNSBmDQowMDAwMDAwMDU5IDY1NTM1IGYNCjAwMDAwMDAwNjAgNjU1MzUgZg0KMDAwMDAwMDA2MSA2NTUzNSBmDQowMDAwMDAwMDYyIDY1NTM1IGYNCjAwMDAwMDAwNjMgNjU1MzUgZg0KMDAwMDAwMDA2NCA2NTUzNSBmDQowMDAwMDAwMDY1IDY1NTM1IGYNCjAwMDAwMDAwNjYgNjU1MzUgZg0KMDAwMDAwMDA2NyA2NTUzNSBmDQowMDAwMDAwMDY4IDY1NTM1IGYNCjAwMDAwMDAwNjkgNjU1MzUgZg0KMDAwMDAwMDA3MCA2NTUzNSBmDQowMDAwMDAwMDcxIDY1NTM1IGYNCjAwMDAwMDAwNzIgNjU1MzUgZg0KMDAwMDAwMDA3MyA2NTUzNSBmDQowMDAwMDAwMDc0IDY1NTM1IGYNCjAwMDAwMDAwNzUgNjU1MzUgZg0KMDAwMDAwMDA3NiA2NTUzNSBmDQowMDAwMDAwMDc3IDY1NTM1IGYNCjAwMDAwMDAwNzggNjU1MzUgZg0KMDAwMDAwMDA3OSA2NTUzNSBmDQowMDAwMDAwMDgwIDY1NTM1IGYNCjAwMDAwMDAwODEgNjU1MzUgZg0KMDAwMDAwMDA4MiA2NTUzNSBmDQowMDAwMDAwMDgzIDY1NTM1IGYNCjAwMDAwMDAwODQgNjU1MzUgZg0KMDAwMDAwMDA4NSA2NTUzNSBmDQowMDAwMDAwMDg2IDY1NTM1IGYNCjAwMDAwMDAwODcgNjU1MzUgZg0KMDAwMDAwMDA4OCA2NTUzNSBmDQowMDAwMDAwMDg5IDY1NTM1IGYNCjAwMDAwMDAwOTAgNjU1MzUgZg0KMDAwMDAwMDA5MSA2NTUzNSBmDQowMDAwMDAwMDkyIDY1NTM1IGYNCjAwMDAwMDAwOTMgNjU1MzUgZg0KMDAwMDAwMDA5NCA2NTUzNSBmDQowMDAwMDAwMDk1IDY1NTM1IGYNCjAwMDAwMDAwOTYgNjU1MzUgZg0KMDAwMDAwMDA5NyA2NTUzNSBmDQowMDAwMDAwMDk4IDY1NTM1IGYNCjAwMDAwMDAwOTkgNjU1MzUgZg0KMDAwMDAwMDEwMCA2NTUzNSBmDQowMDAwMDAwMTAxIDY1NTM1IGYNCjAwMDAwMDAxMDIgNjU1MzUgZg0KMDAwMDAwMDEwMyA2NTUzNSBmDQowMDAwMDAwMTA0IDY1NTM1IGYNCjAwMDAwMDAxMDUgNjU1MzUgZg0KMDAwMDAwMDEwNiA2NTUzNSBmDQowMDAwMDAwMTA3IDY1NTM1IGYNCjAwMDAwMDAxMDggNjU1MzUgZg0KMDAwMDAwMDEwOSA2NTUzNSBmDQowMDAwMDAwMTEwIDY1NTM1IGYNCjAwMDAwMDAxMTEgNjU1MzUgZg0KMDAwMDAwMDExMiA2NTUzNSBmDQowMDAwMDAwMTEzIDY1NTM1IGYNCjAwMDAwMDAxMTQgNjU1MzUgZg0KMDAwMDAwMDExNSA2NTUzNSBmDQowMDAwMDAwMTE2IDY1NTM1IGYNCjAwMDAwMDAxMTcgNjU1MzUgZg0KMDAwMDAwMDExOCA2NTUzNSBmDQowMDAwMDAwMTE5IDY1NTM1IGYNCjAwMDAwMDAxMjAgNjU1MzUgZg0KMDAwMDAwMDEyMSA2NTUzNSBmDQowMDAwMDAwMTIyIDY1NTM1IGYNCjAwMDAwMDAxMjMgNjU1MzUgZg0KMDAwMDAwMDEyNCA2NTUzNSBmDQowMDAwMDAwMTI1IDY1NTM1IGYNCjAwMDAwMDAxMjYgNjU1MzUgZg0KMDAwMDAwMDEyNyA2NTUzNSBmDQowMDAwMDAwMTI4IDY1NTM1IGYNCjAwMDAwMDAxMjkgNjU1MzUgZg0KMDAwMDAwMDEzMCA2NTUzNSBmDQowMDAwMDAwMTMxIDY1NTM1IGYNCjAwMDAwMDAxMzIgNjU1MzUgZg0KMDAwMDAwMDEzMyA2NTUzNSBmDQowMDAwMDAwMTM0IDY1NTM1IGYNCjAwMDAwMDAxMzUgNjU1MzUgZg0KMDAwMDAwMDEzNiA2NTUzNSBmDQowMDAwMDAwMTM3IDY1NTM1IGYNCjAwMDAwMDAxMzggNjU1MzUgZg0KMDAwMDAwMDEzOSA2NTUzNSBmDQowMDAwMDAwMTQwIDY1NTM1IGYNCjAwMDAwMDAxNDEgNjU1MzUgZg0KMDAwMDAwMDE0MiA2NTUzNSBmDQowMDAwMDAwMTQzIDY1NTM1IGYNCjAwMDAwMDAxNDQgNjU1MzUgZg0KMDAwMDAwMDE0NSA2NTUzNSBmDQowMDAwMDAwMTQ2IDY1NTM1IGYNCjAwMDAwMDAxNDcgNjU1MzUgZg0KMDAwMDAwMDE0OCA2NTUzNSBmDQowMDAwMDAwMTQ5IDY1NTM1IGYNCjAwMDAwMDAxNTAgNjU1MzUgZg0KMDAwMDAwMDE1MSA2NTUzNSBmDQowMDAwMDAwMTUyIDY1NTM1IGYNCjAwMDAwMDAxNTMgNjU1MzUgZg0KMDAwMDAwMDE1NCA2NTUzNSBmDQowMDAwMDAwMTU1IDY1NTM1IGYNCjAwMDAwMDAxNTYgNjU1MzUgZg0KMDAwMDAwMDE1NyA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAxMDg0NjYgMDAwMDAgbg0KMDAwMDEwODQ5NCAwMDAwMCBuDQowMDAwMTg2ODcyIDAwMDAwIG4NCjAwMDAxODcxNzIgMDAwMDAgbg0KMDAwMDIxMzk1MSAwMDAwMCBuDQowMDAwMjE0NDAyIDAwMDAwIG4NCjAwMDAyMTUwMDYgMDAwMDAgbg0KMDAwMDIxNTMwNiAwMDAwMCBuDQowMDAwMjMzMjI5IDAwMDAwIG4NCjAwMDAyMzM1ODEgMDAwMDAgbg0KMDAwMDIzNDExMCAwMDAwMCBuDQowMDAwMjM0NDExIDAwMDAwIG4NCjAwMDAyNDY3MjMgMDAwMDAgbg0KMDAwMDI0Njc2NyAwMDAwMCBuDQowMDAwMjQ2Nzk1IDAwMDAwIG4NCjAwMDAyNDcwOTYgMDAwMDAgbg0KMDAwMDI2MDI5MSAwMDAwMCBuDQowMDAwMjYwMzM0IDAwMDAwIG4NCnRyYWlsZXINCjw8L1NpemUgMTc2L1Jvb3QgMSAwIFIvSW5mbyAzNyAwIFIvSURbPDYzOTYxOUYzQjQ3NTAzNERBMDgzQ0JDNTAxMzE4N0JDPjw2Mzk2MTlGM0I0NzUwMzREQTA4M0NCQzUwMTMxODdCQz5dID4+DQpzdGFydHhyZWYNCjI2MDk1Nw0KJSVFT0YNCnhyZWYNCjAgMA0KdHJhaWxlcg0KPDwvU2l6ZSAxNzYvUm9vdCAxIDAgUi9JbmZvIDM3IDAgUi9JRFs8NjM5NjE5RjNCNDc1MDM0REEwODNDQkM1MDEzMTg3QkM+PDYzOTYxOUYzQjQ3NTAzNERBMDgzQ0JDNTAxMzE4N0JDPl0gL1ByZXYgMjYwOTU3L1hSZWZTdG0gMjYwMzM0Pj4NCnN0YXJ0eHJlZg0KMjY0NjM3DQolJUVPRg==	410	2016-07-27 23:05:56.242586	301	3241
7420	222	a prova dele esta funcionando bonitinha, rodou de boas aqui, ele separou a aplicacao em camadinhas, usou mvc de forma limpa, e o bacana foi que ele usou angular, ja mostra que ele se preocupa em estar atualizado. Usou h2 como banco e o hibernate que usamos aqui em algumas aplicacoes tbm, usou bastante spring, ele mandou bem, foi simples, mas esta de acordo.  [3:44]  Uma ressalva no teste dele seria que ele nao se preocupou em tratamento de excecoes, logs com possiveis erros, e nao fez nehum teste unitario  [3:44]  isso eh ruim  [3:44]  mostrei para o Vitor tbm ele ele achou simples, bem arroz com feijao mesmo  [3:45]  mas pensando no tempo, e na correria que a pessoa tem para fazer o teste, eu nao tenho nada contra,  Bruno Siqueira [3:46 PM]  se tivesse que classificar este candidato, como o faria: jr, pl ou sr ?  maryfelvie [3:46 PM]  com relacao ao que usamos aqui, acho que nao seria nenhum bixo de 7 cabecas ara ele  [3:47]  hm dificil, junior com certeza ele nao eh, um pleno eu diria  [3:48]  a prova dele foi boa, mas nos achamos bem CRUD msm	379	2016-07-26 00:35:11.178076	310	3209
7421	204	Bruno Siqueira	382	2016-07-26 00:37:18.304335	304	3212
7422	208	Backend Java	382	2016-07-26 00:37:18.305181	304	3212
7423	209	--	382	2016-07-26 00:37:18.305593	304	3212
7424	210	--	382	2016-07-26 00:37:18.305939	304	3212
7425	211	todas	382	2016-07-26 00:37:18.306273	304	3212
7426	213	krabs	382	2016-07-26 00:37:18.306585	304	3212
7427	203	2,6	382	2016-07-26 00:37:18.306898	304	3212
7428	204	Luciano	383	2016-07-26 00:38:02.61199	304	3213
7429	208	Android	383	2016-07-26 00:38:02.612689	304	3213
7430	209	-	383	2016-07-26 00:38:02.613127	304	3213
7431	210	-	383	2016-07-26 00:38:02.613559	304	3213
7432	211	todas	383	2016-07-26 00:38:02.613932	304	3213
7433	213	Mobile	383	2016-07-26 00:38:02.6143	304	3213
7434	203	1	383	2016-07-26 00:38:02.614698	304	3213
7435	204	Luciano	384	2016-07-26 00:38:58.456625	304	3214
7436	208	PHP Magento	384	2016-07-26 00:38:58.457236	304	3214
7437	209	-	384	2016-07-26 00:38:58.457628	304	3214
7438	210	-	384	2016-07-26 00:38:58.458082	304	3214
7439	211	FCAMARA	384	2016-07-26 00:38:58.458483	304	3214
7440	213	Outlet	384	2016-07-26 00:38:58.458883	304	3214
7441	203	3,20	384	2016-07-26 00:38:58.459326	304	3214
7442	204	Bauer	385	2016-07-26 00:40:38.669586	304	3215
7443	208	Full Stack	385	2016-07-26 00:40:38.670193	304	3215
7444	209	-	385	2016-07-26 00:40:38.670633	304	3215
7445	210	-	385	2016-07-26 00:40:38.671033	304	3215
7446	211	todas	385	2016-07-26 00:40:38.671464	304	3215
7447	213	API Hub	385	2016-07-26 00:40:38.671823	304	3215
7448	203	4,5,13,14	385	2016-07-26 00:40:38.672207	304	3215
7449	204	Bauer	386	2016-07-26 00:41:22.409319	304	3216
7450	208	Full Stack	386	2016-07-26 00:41:22.410153	304	3216
7451	209	-	386	2016-07-26 00:41:22.410555	304	3216
7452	210	-	386	2016-07-26 00:41:22.410937	304	3216
7453	211	todas	386	2016-07-26 00:41:22.411341	304	3216
7454	213	Capcom	386	2016-07-26 00:41:22.411721	304	3216
7455	203	6,7	386	2016-07-26 00:41:22.412103	304	3216
7456	202	Bruno Rossetto	387	2016-07-26 00:44:14.404611	301	3217
7457	215	https://github.com/haptico/agenda.git	387	2016-07-26 00:44:14.405524	301	3217
7458	216	indicado Bruno Siqueira	387	2016-07-26 00:44:14.40598	301	3217
7459	217	1	387	2016-07-26 00:44:14.406362	301	3217
7460	223	1,2,3,4,9,10,11,12,15	387	2016-07-26 00:44:14.406753	301	3217
7461	218	Favor analisar.	388	2016-07-26 00:44:20.74793	302	3218
7462	218	Favor analisar.	389	2016-07-26 00:44:20.78633	302	3219
7463	221	bom Jr	389	2016-07-26 00:44:41.218699	310	3219
7464	222	Classes geradas automaticamente / Código duplicado / Falta de estrutura definida / ListView / Design bem feito / Serviço rodando externo	389	2016-07-26 00:44:41.219669	310	3219
7465	219	-	388	2016-07-26 00:45:05.675433	309	3218
7466	220	O time entende que teria que dedicar mais tempo para equalizar o conhecimento técnico, uma vez que ele não tem muita vivência com linguagens orientada objeto e design patterns. Gostaríamos de avaliar outros candidatos, para ver se é melhor dedicar esse tempo com as questões técnicas ou com outros pontos de outros candidatos.	388	2016-07-26 00:45:05.676387	309	3218
7467	206	345	390	2016-07-26 00:54:32.460475	305	3220
7468	205	386	390	2016-07-26 00:54:32.461121	305	3220
7469	202	Murilo Niéri	391	2016-07-26 00:58:47.365924	301	3221
7470	215	https://github.com/nieri/checkout	391	2016-07-26 00:58:47.366809	301	3221
7471	216	Mazza	391	2016-07-26 00:58:47.367418	301	3221
7472	217	2	391	2016-07-26 00:58:47.367847	301	3221
7473	223	2,9,10,11,12,13	391	2016-07-26 00:58:47.368341	301	3221
7474	218	Favor analisar.	392	2016-07-26 00:58:54.210811	302	3222
7475	218	Favor analisar.	393	2016-07-26 00:58:54.253342	302	3223
7476	202	Rafael Nojiri	394	2016-07-26 01:04:53.136309	301	3224
7477	215	 https://github.com/rnojiri/walmart	394	2016-07-26 01:04:53.136938	301	3224
7478	216	Indicado Doro	394	2016-07-26 01:04:53.137295	301	3224
7479	217	2	394	2016-07-26 01:04:53.137628	301	3224
7480	223	1,2,3,5,9,10,11,12	394	2016-07-26 01:04:53.13803	301	3224
7481	218	Favor analisar.	395	2016-07-26 01:04:59.823755	302	3225
7482	218	Favor analisar.	396	2016-07-26 01:04:59.860869	302	3226
7483	202	Juliano Eutacio	397	2016-07-26 01:08:35.054419	301	3227
7484	215	git clone https://bitbucket.org/walmartjuliano/walmartclient.git  e git clone https://bitbucket.org/walmartjuliano/walmartserver.git	397	2016-07-26 01:08:35.055191	301	3227
7485	216	Prospecção direta	397	2016-07-26 01:08:35.055616	301	3227
7486	217	2	397	2016-07-26 01:08:35.056006	301	3227
7487	223	2,9	397	2016-07-26 01:08:35.056408	301	3227
7488	218	Favor analisar.	398	2016-07-26 01:08:41.670926	302	3228
7489	218	Favor analisar.	399	2016-07-26 01:08:41.707405	302	3229
7490	202	Vitor Hugo Salgado	400	2016-07-26 01:12:47.715967	301	3230
7491	215	https://github.com/vitorsalgado/express-delivery	400	2016-07-26 01:12:47.716642	301	3230
7492	216	indicação Mary - Krabs	400	2016-07-26 01:12:47.717044	301	3230
7493	217	2,5	400	2016-07-26 01:12:47.71747	301	3230
7494	223	2,5,11,23	400	2016-07-26 01:12:47.718682	301	3230
7495	218	Favor analisar.	401	2016-07-26 01:12:54.382637	302	3231
7496	218	Favor analisar.	402	2016-07-26 01:12:54.443104	302	3232
7497	202	Alcides Queiroz	403	2016-07-26 01:26:22.967416	301	3233
7498	215	mandou o projeto zipado	403	2016-07-26 01:26:22.968289	301	3233
7499	216	Prospecção direta	403	2016-07-26 01:26:22.968803	301	3233
7500	217	5,13	403	2016-07-26 01:26:22.969437	301	3233
7501	223	5,9,10,11,13	403	2016-07-26 01:26:22.969925	301	3233
7502	218	Favor analisar.	404	2016-07-26 01:26:29.767047	302	3234
7503	218	Favor analisar.	405	2016-07-26 01:26:29.817488	302	3235
7504	204	Marilene	406	2016-07-26 20:03:51.875521	304	3236
7505	208	Full Stack	406	2016-07-26 20:03:51.898763	304	3236
7506	209	-	406	2016-07-26 20:03:51.899438	304	3236
7507	210	-	406	2016-07-26 20:03:51.899954	304	3236
7508	211	todas	406	2016-07-26 20:03:51.900448	304	3236
7509	213	stargate	406	2016-07-26 20:03:51.90094	304	3236
7510	212	28,30,29,31,33,34	406	2016-07-26 20:03:51.90143	304	3236
7511	203	2,5,10,11,13,25,26,27,7	406	2016-07-26 20:03:51.901891	304	3236
7524	202	alterado Candidato Teste	410	2016-07-27 23:04:52.625992	301	3240
7530	224	duplicado	390	2016-07-27 23:54:01.793913	313	3243
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 7530, true);


--
-- Name: workflow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_id_seq', 28, true);


--
-- Data for Name: workflow_posto_campos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_posto_campos (id, idposto, idcampo, obrigatorio) FROM stdin;
42	301	202	1
44	304	203	1
46	305	206	\N
47	305	205	\N
48	307	207	\N
52	304	211	\N
53	304	212	\N
45	304	204	1
49	304	208	1
50	304	209	1
51	304	210	1
54	304	213	1
56	301	215	1
58	301	217	1
55	301	214	\N
57	301	216	0
59	302	218	\N
60	309	219	1
61	309	220	1
62	310	221	1
63	310	222	1
43	301	223	1
64	313	224	1
65	314	225	1
66	315	226	1
67	315	227	1
\.


--
-- Name: workflow_posto_campos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_posto_campos_id_seq', 67, true);


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
304	28	2	Incluir nova Vaga	\N	0	F	1	\N	\N	\N	\N	\N
305	28	2	Candidatos para esta vaga	\N	0	VagaXCandidato	6	\N	\N	\N	\N	\N
307	28	2	Encaminhar para Entrevistas	\N	0	F	6	\N	\N	\N	\N	\N
309	28	2	Avaliar Candidato	\N	0	F	3	\N	\N	\N	\N	\N
310	28	2	Avaliar Candidato	\N	0	F	3	\N	\N	\N	\N	\N
303	28	2	Vagas	1	1	L	1	\N	\N	\N	\N	\N
306	28	2	Triagem de Candidatos pelo Gestor	2	1	L	6	\N	\N	\N	\N	\N
308	28	2	Candidatos já triados	3	1	L	6	\N	\N	\N	\N	\N
311	28	2	Deliberação de Candidatos	4	1	L	6	\N	\N	\N	\N	\N
312	28	2	Não considerados	\N	0	L	6	\N	\N	\N	\N	\N
313	28	2	Desinteresse no candidato	\N	0	F	6	\N	\N	\N	\N	\N
314	28	2	Avancar candidato para deliberação	\N	0	F	6	\N	\N	\N	\N	\N
315	28	2	Contratar novo membro	\N	0	F	6	\N	\N	\N	\N	\N
\.


--
-- Name: workflow_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_postos_id_seq', 315, true);


--
-- Data for Name: workflow_tramitacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_tramitacao (id, idprocesso, idworkflowposto, inicio, fim, id_usuario_associado) FROM stdin;
3173	343	298	2016-07-25 23:53:59.74043	\N	\N
3174	344	298	2016-07-26 00:02:45.770533	\N	\N
3175	345	298	2016-07-26 00:05:53.562601	\N	\N
3176	346	298	2016-07-26 00:07:30.886684	\N	\N
3177	347	298	2016-07-26 00:10:05.809561	\N	\N
3178	348	298	2016-07-26 00:11:12.696566	\N	\N
3179	349	298	2016-07-26 00:12:39.909631	\N	\N
3180	350	298	2016-07-26 00:13:12.618466	\N	\N
3181	351	298	2016-07-26 00:13:48.335149	\N	\N
3182	352	298	2016-07-26 00:14:21.533375	\N	\N
3183	353	298	2016-07-26 00:15:01.369473	\N	\N
3184	354	298	2016-07-26 00:15:34.389925	\N	\N
3185	355	298	2016-07-26 00:16:12.972192	\N	\N
3208	378	300	2016-07-26 00:17:35.19975	\N	\N
3210	380	300	2016-07-26 00:17:39.342104	\N	\N
3211	381	299	2016-07-26 00:17:39.382787	\N	\N
3206	376	300	2016-07-26 00:17:31.809023	2016-07-26 00:27:11.700352	\N
3207	377	299	2016-07-26 00:17:31.850206	2016-07-26 00:27:40.267234	\N
3205	375	299	2016-07-26 00:17:28.506475	2016-07-26 00:28:47.085818	\N
3204	374	300	2016-07-26 00:17:28.465047	2016-07-26 00:29:03.962912	\N
3202	372	300	2016-07-26 00:17:25.278942	2016-07-26 00:29:26.117503	\N
3203	373	299	2016-07-26 00:17:25.321047	2016-07-26 00:29:44.691468	\N
3201	371	299	2016-07-26 00:17:21.54867	2016-07-26 00:30:06.178956	\N
3200	370	300	2016-07-26 00:17:21.507013	2016-07-26 00:30:13.912217	\N
3198	368	300	2016-07-26 00:17:17.197432	2016-07-26 00:30:36.577353	\N
3199	369	299	2016-07-26 00:17:17.485935	2016-07-26 00:30:54.072808	\N
3197	367	299	2016-07-26 00:17:14.059813	2016-07-26 00:31:19.115814	\N
3196	366	300	2016-07-26 00:17:14.018161	2016-07-26 00:31:25.89623	\N
3194	364	300	2016-07-26 00:17:10.72707	2016-07-26 00:31:47.699457	\N
3195	365	299	2016-07-26 00:17:10.767043	2016-07-26 00:31:57.840803	\N
3193	363	299	2016-07-26 00:17:08.150221	2016-07-26 00:32:18.910648	\N
3192	362	300	2016-07-26 00:17:08.110405	2016-07-26 00:32:26.552838	\N
3190	360	300	2016-07-26 00:17:04.568453	2016-07-26 00:32:52.462699	\N
3191	361	299	2016-07-26 00:17:04.608006	2016-07-26 00:33:10.782236	\N
3189	359	299	2016-07-26 00:17:01.647811	2016-07-26 00:33:25.415326	\N
3188	358	300	2016-07-26 00:17:01.608403	2016-07-26 00:33:31.472023	\N
3186	356	300	2016-07-26 00:16:58.823239	2016-07-26 00:33:53.480651	\N
3187	357	299	2016-07-26 00:16:58.864106	2016-07-26 00:34:00.183002	\N
3209	379	299	2016-07-26 00:17:35.240853	2016-07-26 00:35:11.178667	\N
3212	382	303	2016-07-26 00:37:18.26918	\N	\N
3213	383	303	2016-07-26 00:38:02.577292	\N	\N
3214	384	303	2016-07-26 00:38:58.42144	\N	\N
3215	385	303	2016-07-26 00:40:38.63426	\N	\N
3216	386	303	2016-07-26 00:41:22.373033	\N	\N
3217	387	298	2016-07-26 00:44:14.368809	\N	\N
3219	389	299	2016-07-26 00:44:20.750116	2016-07-26 00:44:41.220075	\N
3218	388	300	2016-07-26 00:44:20.709531	2016-07-26 00:45:05.676803	\N
3221	391	298	2016-07-26 00:58:47.305669	\N	\N
3222	392	300	2016-07-26 00:58:54.168303	\N	\N
3223	393	299	2016-07-26 00:58:54.21327	\N	\N
3224	394	298	2016-07-26 01:04:53.096775	\N	\N
3225	395	300	2016-07-26 01:04:59.785002	\N	\N
3226	396	299	2016-07-26 01:04:59.825979	\N	\N
3227	397	298	2016-07-26 01:08:35.014638	\N	\N
3228	398	300	2016-07-26 01:08:41.632833	\N	\N
3229	399	299	2016-07-26 01:08:41.672992	\N	\N
3230	400	298	2016-07-26 01:12:47.680515	\N	\N
3231	401	300	2016-07-26 01:12:54.326692	\N	\N
3232	402	299	2016-07-26 01:12:54.385036	\N	\N
3233	403	298	2016-07-26 01:26:22.917869	\N	\N
3234	404	300	2016-07-26 01:26:29.718623	\N	\N
3235	405	299	2016-07-26 01:26:29.769358	\N	\N
3236	406	303	2016-07-26 20:03:51.840198	\N	\N
3237	407	303	2016-07-26 20:14:35.789837	\N	\N
3238	408	306	2016-07-27 14:57:05.517485	\N	\N
3239	409	306	2016-07-27 14:57:05.952304	\N	\N
3240	410	298	2016-07-27 23:04:52.589677	2016-07-27 23:05:55.754581	\N
3242	410	298	2016-07-27 23:09:13.394185	\N	\N
3241	410	298	2016-07-27 23:05:55.704798	2016-07-27 23:09:13.942291	\N
3243	390	312	2016-07-27 23:54:01.413422	\N	\N
3220	390	306	2016-07-26 00:54:32.419674	2016-07-27 23:54:01.473639	\N
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 3243, true);


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

