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
\.


--
-- Name: posto_acao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('posto_acao_id_seq', 331, true);


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
\.


--
-- Name: postos_campo_lista_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_lista_id_seq', 130, true);


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

SELECT pg_catalog.setval('usuarios_id_seq', 381, true);


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
214	CV	\N	file	\N	\N	\N	\N	\N
215	link do Github	\N	text	\N	\N	\N	\N	\N
216	Consultoria	\N	\N	\N	\N	\N	\N	\N
218	Comentários para solicitação de análise do teste técnico	\N	text	\N	\N	\N	\N	\N
219	Nível de experiência avaliada	\N	text	\N	\N	Junior / PLeno / Senior	\N	\N
220	Parecer Técnico	\N	text	\N	\N	\N	\N	\N
221	Nivel de experiencia avaliada	\N	text	\N	\N	\N	\N	\N
222	Parecer técnico	\N	text	\N	\N	\N	\N	\N
212	Tecnologias Secundárias	\N	list	\N	\N	\N	{configuracoes.tecnologias}	skills
217	Tecnologias que utilizou no teste	\N	list	\N	\N	\N	{configuracoes.tecnologias}	skills
223	Tecnologias que o candidato domina	\N	list	\N	\N	\N	{configuracoes.tecnologias}	skills
203	Tecnologias obrigatórias da vaga	\N	list	\N	\N	\N	{configuracoes.tecnologias}	skills
224	Motivo do desinteresse pelo candidato	\N	textarea	30	7	\N	\N	\N
225	Motivo de interesse no candidato	\N	textarea	30	7	\N	\N	\N
226	Valor/Hora	\N	text	\N	\N	\N	\N	\N
227	Data de Inicio	\N	text	\N	\N	\N	\N	\N
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
7420	222	a prova dele esta funcionando bonitinha, rodou de boas aqui, ele separou a aplicacao em camadinhas, usou mvc de forma limpa, e o bacana foi que ele usou angular, ja mostra que ele se preocupa em estar atualizado. Usou h2 como banco e o hibernate que usamos aqui em algumas aplicacoes tbm, usou bastante spring, ele mandou bem, foi simples, mas esta de acordo.  [3:44]  Uma ressalva no teste dele seria que ele nao se preocupou em tratamento de excecoes, logs com possiveis erros, e nao fez nehum teste unitario  [3:44]  isso eh ruim  [3:44]  mostrei para o Vitor tbm ele ele achou simples, bem arroz com feijao mesmo  [3:45]  mas pensando no tempo, e na correria que a pessoa tem para fazer o teste, eu nao tenho nada contra,  Bruno Siqueira [3:46 PM]  se tivesse que classificar este candidato, como o faria: jr, pl ou sr ?  maryfelvie [3:46 PM]  com relacao ao que usamos aqui, acho que nao seria nenhum bixo de 7 cabecas ara ele  [3:47]  hm dificil, junior com certeza ele nao eh, um pleno eu diria  [3:48]  a prova dele foi boa, mas nos achamos bem CRUD msm	379	2016-07-26 00:35:11.178076	310	3209
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 7420, true);


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
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 3211, true);


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

