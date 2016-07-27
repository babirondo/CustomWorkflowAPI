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
608	54		4	2016-07-18 00:48:02.480729	13
663	113	bruno.siqueira	4	2016-07-18 00:51:05.505795	10
603	112	teste123	4	2016-07-18 00:45:19.707576	12
665	112	75	75	2016-07-18 00:56:27.787319	10
666	113	novinho entao...	126	2016-07-18 00:57:00.748021	8
669	1	nomee	126	2016-07-18 00:57:00.74957	8
668	2	email	126	2016-07-18 00:57:00.749154	8
607	55	4	4	2016-07-18 00:48:02.48005	13
606	4	2	4	2016-07-18 00:48:02.478617	13
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
763	3	4	422	2016-07-27 00:16:11.79236	13
762	99		422	2016-07-27 00:16:11.791929	13
761	5		422	2016-07-27 00:16:11.79152	13
705	113	galfas	422	2016-07-27 00:14:58.955854	8
706	112	teste123	422	2016-07-27 00:14:58.966712	8
707	2	g@g	422	2016-07-27 00:14:58.967345	8
708	1	Marcelo Galfas	422	2016-07-27 00:14:58.96784	8
709	114	2,3,5,85	422	2016-07-27 00:14:58.968291	8
764	113	denis.gois	423	2016-07-27 00:17:27.905612	8
765	112	teste123	423	2016-07-27 00:17:27.906297	8
766	2	denis	423	2016-07-27 00:17:27.906814	8
767	1	Denis Gois	423	2016-07-27 00:17:27.907207	8
768	114	2,3,5,85	423	2016-07-27 00:17:27.90788	8
769	4		423	2016-07-27 00:18:05.692642	13
770	55		423	2016-07-27 00:18:05.694168	13
771	54		423	2016-07-27 00:18:05.694853	13
772	53		423	2016-07-27 00:18:05.695444	13
773	52		423	2016-07-27 00:18:05.695856	13
774	51		423	2016-07-27 00:18:05.696245	13
775	50		423	2016-07-27 00:18:05.696641	13
776	49		423	2016-07-27 00:18:05.697013	13
777	48		423	2016-07-27 00:18:05.697415	13
778	47		423	2016-07-27 00:18:05.69782	13
779	46		423	2016-07-27 00:18:05.69827	13
780	45		423	2016-07-27 00:18:05.69865	13
781	44		423	2016-07-27 00:18:05.699026	13
782	43		423	2016-07-27 00:18:05.699409	13
783	42		423	2016-07-27 00:18:05.699782	13
784	41		423	2016-07-27 00:18:05.700154	13
785	40		423	2016-07-27 00:18:05.700528	13
786	39		423	2016-07-27 00:18:05.700967	13
787	38		423	2016-07-27 00:18:05.701373	13
788	37		423	2016-07-27 00:18:05.701758	13
760	6		422	2016-07-27 00:16:11.791094	13
759	7		422	2016-07-27 00:16:11.790624	13
758	8		422	2016-07-27 00:16:11.790125	13
757	9		422	2016-07-27 00:16:11.789365	13
756	10		422	2016-07-27 00:16:11.788943	13
755	11	4	422	2016-07-27 00:16:11.788559	13
754	12		422	2016-07-27 00:16:11.788169	13
753	13		422	2016-07-27 00:16:11.787719	13
752	14		422	2016-07-27 00:16:11.787285	13
751	15		422	2016-07-27 00:16:11.78686	13
750	16		422	2016-07-27 00:16:11.786423	13
749	17		422	2016-07-27 00:16:11.785895	13
748	18		422	2016-07-27 00:16:11.785505	13
747	19		422	2016-07-27 00:16:11.785133	13
746	20		422	2016-07-27 00:16:11.784679	13
745	21		422	2016-07-27 00:16:11.78428	13
744	22		422	2016-07-27 00:16:11.783869	13
743	23		422	2016-07-27 00:16:11.783483	13
742	24		422	2016-07-27 00:16:11.783103	13
741	25		422	2016-07-27 00:16:11.782718	13
740	26		422	2016-07-27 00:16:11.782333	13
739	27		422	2016-07-27 00:16:11.781935	13
738	28		422	2016-07-27 00:16:11.781525	13
737	29		422	2016-07-27 00:16:11.781109	13
736	30		422	2016-07-27 00:16:11.780738	13
735	31		422	2016-07-27 00:16:11.780353	13
734	32		422	2016-07-27 00:16:11.779954	13
733	33		422	2016-07-27 00:16:11.779546	13
732	34		422	2016-07-27 00:16:11.779118	13
731	35		422	2016-07-27 00:16:11.778754	13
730	36		422	2016-07-27 00:16:11.778347	13
729	37		422	2016-07-27 00:16:11.777954	13
728	38		422	2016-07-27 00:16:11.777529	13
727	39		422	2016-07-27 00:16:11.777143	13
726	40		422	2016-07-27 00:16:11.776746	13
725	41		422	2016-07-27 00:16:11.776345	13
724	42		422	2016-07-27 00:16:11.775969	13
723	43		422	2016-07-27 00:16:11.775519	13
722	44		422	2016-07-27 00:16:11.775144	13
721	45		422	2016-07-27 00:16:11.774756	13
720	46		422	2016-07-27 00:16:11.774366	13
719	47		422	2016-07-27 00:16:11.773979	13
718	48		422	2016-07-27 00:16:11.77358	13
717	49		422	2016-07-27 00:16:11.773179	13
716	50		422	2016-07-27 00:16:11.772778	13
715	51		422	2016-07-27 00:16:11.772357	13
714	52		422	2016-07-27 00:16:11.771964	13
713	53		422	2016-07-27 00:16:11.771566	13
712	54		422	2016-07-27 00:16:11.771159	13
711	55		422	2016-07-27 00:16:11.770677	13
710	4	4	422	2016-07-27 00:16:11.769257	13
789	36		423	2016-07-27 00:18:05.702139	13
790	35		423	2016-07-27 00:18:05.725505	13
791	34		423	2016-07-27 00:18:05.726156	13
792	33		423	2016-07-27 00:18:05.726583	13
793	32		423	2016-07-27 00:18:05.726992	13
794	31		423	2016-07-27 00:18:05.727396	13
795	30		423	2016-07-27 00:18:05.727831	13
796	29		423	2016-07-27 00:18:05.72822	13
797	28		423	2016-07-27 00:18:05.728619	13
798	27		423	2016-07-27 00:18:05.729014	13
799	26		423	2016-07-27 00:18:05.729394	13
800	25		423	2016-07-27 00:18:05.729809	13
801	24		423	2016-07-27 00:18:05.730326	13
802	23		423	2016-07-27 00:18:05.730718	13
803	22		423	2016-07-27 00:18:05.731218	13
804	21		423	2016-07-27 00:18:05.731626	13
805	20		423	2016-07-27 00:18:05.732021	13
806	19		423	2016-07-27 00:18:05.732419	13
807	18		423	2016-07-27 00:18:05.732803	13
808	17		423	2016-07-27 00:18:05.733206	13
809	16		423	2016-07-27 00:18:05.733594	13
810	15		423	2016-07-27 00:18:05.733983	13
811	14		423	2016-07-27 00:18:05.73436	13
812	13		423	2016-07-27 00:18:05.734751	13
813	12		423	2016-07-27 00:18:05.735133	13
814	11		423	2016-07-27 00:18:05.735515	13
815	10		423	2016-07-27 00:18:05.735898	13
816	9		423	2016-07-27 00:18:05.736288	13
817	8		423	2016-07-27 00:18:05.736669	13
818	7		423	2016-07-27 00:18:05.73704	13
819	6		423	2016-07-27 00:18:05.737413	13
820	5		423	2016-07-27 00:18:05.737787	13
821	99		423	2016-07-27 00:18:05.738165	13
822	3	4	423	2016-07-27 00:18:05.738541	13
823	113	leandro.miserani	424	2016-07-27 00:18:53.639225	8
824	112	teste123	424	2016-07-27 00:18:53.6399	8
825	2	kk	424	2016-07-27 00:18:53.640358	8
826	1	leandro	424	2016-07-27 00:18:53.640806	8
827	114	2,3,5,85	424	2016-07-27 00:18:53.641238	8
828	4	3	424	2016-07-27 00:19:54.691017	13
829	55		424	2016-07-27 00:19:54.692485	13
830	54		424	2016-07-27 00:19:54.693337	13
831	53		424	2016-07-27 00:19:54.693865	13
832	52		424	2016-07-27 00:19:54.694288	13
833	51		424	2016-07-27 00:19:54.694711	13
834	50		424	2016-07-27 00:19:54.69511	13
835	49		424	2016-07-27 00:19:54.695513	13
836	48		424	2016-07-27 00:19:54.695914	13
837	47		424	2016-07-27 00:19:54.696308	13
838	46		424	2016-07-27 00:19:54.696712	13
839	45		424	2016-07-27 00:19:54.697086	13
840	44		424	2016-07-27 00:19:54.697512	13
841	43		424	2016-07-27 00:19:54.697908	13
842	42		424	2016-07-27 00:19:54.698386	13
843	41		424	2016-07-27 00:19:54.698795	13
844	40		424	2016-07-27 00:19:54.69921	13
845	39		424	2016-07-27 00:19:54.699619	13
846	38		424	2016-07-27 00:19:54.700024	13
847	37		424	2016-07-27 00:19:54.700548	13
848	36		424	2016-07-27 00:19:54.70097	13
849	35		424	2016-07-27 00:19:54.701369	13
850	34		424	2016-07-27 00:19:54.701766	13
851	33		424	2016-07-27 00:19:54.702149	13
852	32		424	2016-07-27 00:19:54.702536	13
853	31		424	2016-07-27 00:19:54.702917	13
854	30		424	2016-07-27 00:19:54.703303	13
855	29		424	2016-07-27 00:19:54.703717	13
856	28		424	2016-07-27 00:19:54.70411	13
857	27		424	2016-07-27 00:19:54.704528	13
858	26		424	2016-07-27 00:19:54.704894	13
859	25		424	2016-07-27 00:19:54.705263	13
860	24		424	2016-07-27 00:19:54.705637	13
861	23		424	2016-07-27 00:19:54.706011	13
862	22		424	2016-07-27 00:19:54.706475	13
863	21	3	424	2016-07-27 00:19:54.70707	13
864	20		424	2016-07-27 00:19:54.707634	13
865	19		424	2016-07-27 00:19:54.708038	13
866	18		424	2016-07-27 00:19:54.708434	13
867	17		424	2016-07-27 00:19:54.708829	13
868	16		424	2016-07-27 00:19:54.709266	13
869	15		424	2016-07-27 00:19:54.709945	13
870	14		424	2016-07-27 00:19:54.710321	13
871	13		424	2016-07-27 00:19:54.710682	13
872	12		424	2016-07-27 00:19:54.711055	13
873	11	3	424	2016-07-27 00:19:54.711421	13
874	10		424	2016-07-27 00:19:54.711832	13
875	9		424	2016-07-27 00:19:54.712209	13
876	8		424	2016-07-27 00:19:54.712586	13
877	7		424	2016-07-27 00:19:54.712943	13
878	6		424	2016-07-27 00:19:54.713308	13
879	5		424	2016-07-27 00:19:54.713657	13
880	99		424	2016-07-27 00:19:54.714016	13
881	3	3	424	2016-07-27 00:19:54.714428	13
882	113	leonardo.nickel	425	2016-07-27 00:20:46.250178	8
883	112	teste123	425	2016-07-27 00:20:46.250892	8
884	2	kkk@k	425	2016-07-27 00:20:46.251356	8
885	1	nickel	425	2016-07-27 00:20:46.251828	8
886	114	2,3,5,85	425	2016-07-27 00:20:46.252241	8
887	4		425	2016-07-27 00:22:27.860263	13
888	55		425	2016-07-27 00:22:27.861757	13
889	54		425	2016-07-27 00:22:27.862293	13
890	53		425	2016-07-27 00:22:27.862694	13
891	52		425	2016-07-27 00:22:27.863089	13
892	51		425	2016-07-27 00:22:27.863487	13
893	50		425	2016-07-27 00:22:27.863859	13
894	49		425	2016-07-27 00:22:27.864232	13
895	48		425	2016-07-27 00:22:27.864618	13
896	47		425	2016-07-27 00:22:27.865018	13
897	46		425	2016-07-27 00:22:27.865402	13
898	45		425	2016-07-27 00:22:27.865789	13
899	44		425	2016-07-27 00:22:27.866163	13
900	43		425	2016-07-27 00:22:27.86653	13
901	42		425	2016-07-27 00:22:27.866905	13
902	41		425	2016-07-27 00:22:27.867284	13
903	40		425	2016-07-27 00:22:27.867678	13
904	39		425	2016-07-27 00:22:27.868043	13
905	38		425	2016-07-27 00:22:27.868427	13
906	37		425	2016-07-27 00:22:27.868802	13
907	36		425	2016-07-27 00:22:27.869188	13
908	35		425	2016-07-27 00:22:27.86956	13
909	34		425	2016-07-27 00:22:27.869936	13
910	33		425	2016-07-27 00:22:27.870309	13
911	32		425	2016-07-27 00:22:27.870681	13
912	31		425	2016-07-27 00:22:27.871134	13
913	30		425	2016-07-27 00:22:27.871544	13
914	29		425	2016-07-27 00:22:27.871916	13
915	28		425	2016-07-27 00:22:27.872326	13
916	27		425	2016-07-27 00:22:27.872698	13
917	26		425	2016-07-27 00:22:27.873067	13
918	25		425	2016-07-27 00:22:27.873756	13
919	24		425	2016-07-27 00:22:27.874221	13
920	23		425	2016-07-27 00:22:27.874707	13
921	22		425	2016-07-27 00:22:27.875105	13
922	21		425	2016-07-27 00:22:27.875666	13
923	20		425	2016-07-27 00:22:27.876373	13
924	19		425	2016-07-27 00:22:27.876877	13
925	18		425	2016-07-27 00:22:27.877327	13
926	17		425	2016-07-27 00:22:27.877744	13
927	16		425	2016-07-27 00:22:27.878172	13
928	15		425	2016-07-27 00:22:27.878607	13
929	14		425	2016-07-27 00:22:27.87901	13
930	13		425	2016-07-27 00:22:27.87941	13
931	12		425	2016-07-27 00:22:27.87979	13
932	11		425	2016-07-27 00:22:27.880193	13
933	10		425	2016-07-27 00:22:27.880561	13
934	9		425	2016-07-27 00:22:27.880933	13
935	8	3	425	2016-07-27 00:22:27.881315	13
936	7	3	425	2016-07-27 00:22:27.881697	13
937	6	3	425	2016-07-27 00:22:27.882071	13
938	5		425	2016-07-27 00:22:27.882431	13
939	99		425	2016-07-27 00:22:27.882788	13
940	3	3	425	2016-07-27 00:22:27.883175	13
941	113	luis.vieira	426	2016-07-27 00:23:26.965435	8
942	112	teste123	426	2016-07-27 00:23:26.966133	8
943	2	kkk	426	2016-07-27 00:23:26.966535	8
944	1	Luis Vieira	426	2016-07-27 00:23:26.966978	8
945	114	2,3,5,85	426	2016-07-27 00:23:26.967397	8
946	4		426	2016-07-27 00:23:53.698559	13
947	55		426	2016-07-27 00:23:53.700027	13
948	54		426	2016-07-27 00:23:53.700726	13
949	53		426	2016-07-27 00:23:53.701159	13
950	52		426	2016-07-27 00:23:53.701623	13
951	51		426	2016-07-27 00:23:53.702101	13
952	50		426	2016-07-27 00:23:53.7031	13
953	49		426	2016-07-27 00:23:53.703798	13
954	48		426	2016-07-27 00:23:53.704555	13
955	47		426	2016-07-27 00:23:53.704971	13
956	46		426	2016-07-27 00:23:53.705383	13
957	45		426	2016-07-27 00:23:53.705794	13
958	44		426	2016-07-27 00:23:53.706197	13
959	43		426	2016-07-27 00:23:53.70661	13
960	42		426	2016-07-27 00:23:53.707057	13
961	41		426	2016-07-27 00:23:53.707456	13
962	40		426	2016-07-27 00:23:53.707855	13
963	39		426	2016-07-27 00:23:53.708285	13
964	38		426	2016-07-27 00:23:53.708649	13
965	37		426	2016-07-27 00:23:53.709019	13
966	36		426	2016-07-27 00:23:53.709335	13
967	35		426	2016-07-27 00:23:53.709728	13
968	34		426	2016-07-27 00:23:53.710101	13
969	33		426	2016-07-27 00:23:53.710449	13
970	32		426	2016-07-27 00:23:53.710811	13
971	31		426	2016-07-27 00:23:53.711173	13
972	30		426	2016-07-27 00:23:53.711531	13
973	29		426	2016-07-27 00:23:53.711885	13
974	28		426	2016-07-27 00:23:53.712237	13
975	27		426	2016-07-27 00:23:53.712603	13
976	26		426	2016-07-27 00:23:53.712974	13
977	25		426	2016-07-27 00:23:53.713333	13
978	24		426	2016-07-27 00:23:53.71369	13
979	23		426	2016-07-27 00:23:53.714045	13
980	22		426	2016-07-27 00:23:53.714707	13
981	21		426	2016-07-27 00:23:53.715103	13
982	20		426	2016-07-27 00:23:53.715468	13
983	19		426	2016-07-27 00:23:53.715853	13
984	18		426	2016-07-27 00:23:53.716224	13
985	17		426	2016-07-27 00:23:53.716593	13
986	16		426	2016-07-27 00:23:53.716955	13
987	15		426	2016-07-27 00:23:53.717312	13
988	14		426	2016-07-27 00:23:53.717688	13
989	13		426	2016-07-27 00:23:53.718047	13
990	12		426	2016-07-27 00:23:53.718399	13
991	11		426	2016-07-27 00:23:53.718782	13
992	10		426	2016-07-27 00:23:53.719281	13
993	9		426	2016-07-27 00:23:53.719649	13
994	8		426	2016-07-27 00:23:53.720021	13
995	7	3	426	2016-07-27 00:23:53.720392	13
996	6		426	2016-07-27 00:23:53.720757	13
997	5		426	2016-07-27 00:23:53.721138	13
998	99		426	2016-07-27 00:23:53.721515	13
999	3	3	426	2016-07-27 00:23:53.721895	13
1000	113	lucas.trias	427	2016-07-27 00:25:57.114555	8
1001	112	teste123	427	2016-07-27 00:25:57.11535	8
1002	2	kkk	427	2016-07-27 00:25:57.11584	8
1003	1	Trias	427	2016-07-27 00:25:57.116241	8
1004	114	2,3,5,85	427	2016-07-27 00:25:57.116641	8
1056	5		427	2016-07-27 00:26:48.89294	13
1054	7		427	2016-07-27 00:26:48.892198	13
1053	8		427	2016-07-27 00:26:48.891832	13
1052	9		427	2016-07-27 00:26:48.891475	13
1051	10		427	2016-07-27 00:26:48.891101	13
1050	11	3	427	2016-07-27 00:26:48.890735	13
1049	12		427	2016-07-27 00:26:48.890379	13
1048	13		427	2016-07-27 00:26:48.889982	13
1047	14		427	2016-07-27 00:26:48.889613	13
1046	15		427	2016-07-27 00:26:48.889226	13
1045	16		427	2016-07-27 00:26:48.88891	13
1044	17		427	2016-07-27 00:26:48.888561	13
1043	18		427	2016-07-27 00:26:48.888207	13
1042	19		427	2016-07-27 00:26:48.887846	13
1041	20		427	2016-07-27 00:26:48.887373	13
1039	22		427	2016-07-27 00:26:48.886602	13
1038	23		427	2016-07-27 00:26:48.886231	13
1037	24		427	2016-07-27 00:26:48.885875	13
1036	25		427	2016-07-27 00:26:48.885489	13
1035	26		427	2016-07-27 00:26:48.885126	13
1034	27		427	2016-07-27 00:26:48.884766	13
1033	28		427	2016-07-27 00:26:48.884404	13
1032	29		427	2016-07-27 00:26:48.883992	13
1031	30		427	2016-07-27 00:26:48.883407	13
1030	31		427	2016-07-27 00:26:48.882986	13
1029	32		427	2016-07-27 00:26:48.882614	13
1028	33		427	2016-07-27 00:26:48.88226	13
1027	34		427	2016-07-27 00:26:48.881906	13
1026	35		427	2016-07-27 00:26:48.881498	13
1024	37		427	2016-07-27 00:26:48.88073	13
1023	38		427	2016-07-27 00:26:48.88036	13
1022	39		427	2016-07-27 00:26:48.879991	13
1021	40		427	2016-07-27 00:26:48.879627	13
1020	41		427	2016-07-27 00:26:48.879187	13
1019	42		427	2016-07-27 00:26:48.878785	13
1018	43		427	2016-07-27 00:26:48.878392	13
1017	44		427	2016-07-27 00:26:48.878024	13
1016	45		427	2016-07-27 00:26:48.877665	13
1015	46		427	2016-07-27 00:26:48.877301	13
1014	47		427	2016-07-27 00:26:48.876939	13
1013	48		427	2016-07-27 00:26:48.876568	13
1012	49		427	2016-07-27 00:26:48.876191	13
1011	50		427	2016-07-27 00:26:48.875818	13
1009	52		427	2016-07-27 00:26:48.875064	13
1008	53		427	2016-07-27 00:26:48.874669	13
1007	54		427	2016-07-27 00:26:48.874159	13
1006	55		427	2016-07-27 00:26:48.873321	13
1005	4		427	2016-07-27 00:26:48.871854	13
1058	3	3	427	2016-07-27 00:26:48.893678	13
1057	99		427	2016-07-27 00:26:48.893307	13
1055	6		427	2016-07-27 00:26:48.892579	13
1040	21		427	2016-07-27 00:26:48.887004	13
1025	36		427	2016-07-27 00:26:48.881106	13
1010	51		427	2016-07-27 00:26:48.875449	13
\.


--
-- Name: engine_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('engine_dados_id_seq', 1058, true);


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
332	298	Editar 	301
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
131	305	223	\N	\N	\N
132	305	219	\N	\N	\N
133	305	221	\N	\N	\N
134	298	223	\N	\N	\N
135	298	216	\N	\N	\N
136	298	217	\N	\N	\N
137	305	214	\N	\N	\N
\.


--
-- Name: postos_campo_lista_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postos_campo_lista_id_seq', 137, true);


--
-- Data for Name: processos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY processos (id, idpai, idtipoprocesso, inicio, idworkflow, status, regra_finalizacao, relacionadoa) FROM stdin;
448	447	3	2016-07-27 20:22:05.21201	27	Em Andamento	\N	\N
449	447	3	2016-07-27 20:22:05.440401	27	Em Andamento	\N	\N
447	\N	2	2016-07-27 20:21:53.199211	27	Em Andamento	\N	\N
450	\N	1	2016-07-27 20:42:08.944715	28	Em Andamento	\N	\N
451	\N	2	2016-07-27 20:43:28.008928	27	Em Andamento	\N	\N
452	450	6	2016-07-27 20:43:58.29876	28	Em Andamento	\N	447
453	450	6	2016-07-27 20:43:58.34826	28	Em Andamento	\N	451
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
109	422	2
110	422	3
111	422	5
112	422	85
113	423	2
114	423	3
115	423	5
116	423	85
117	424	2
118	424	3
119	424	5
120	424	85
121	425	2
122	425	3
123	425	5
124	425	85
125	426	2
126	426	3
127	426	5
128	426	85
129	427	2
130	427	3
131	427	5
132	427	85
\.


--
-- Name: usuario_atores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuario_atores_id_seq', 132, true);


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarios (id, email, nome, senha, login, admin, criacao) FROM stdin;
4	bruno.siqueira@walmart.com	Bruno Siqueira	teste123	bruno.siqueira	1	\N
422	g@g	Marcelo Galfas	teste123	galfas	\N	\N
423	denis	Denis Gois	teste123	denis.gois	\N	\N
424	kk	leandro	teste123	leandro.miserani	\N	\N
425	kkk@k	nickel	teste123	leonardo.nickel	\N	\N
426	kkk	Luis Vieira	teste123	luis.vieira	\N	\N
427	kkk	Trias	teste123	lucas.trias	\N	\N
\.


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuarios_id_seq', 453, true);


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
216	Consultoria	\N	\N	\N	\N	\N	\N	\N
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
\.


--
-- Data for Name: workflow_dados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_dados (id, idpostocampo, valor, idprocesso, registro, idposto, idworkflowtramitacao) FROM stdin;
7633	214	Felipe Novaes Fortunato da Rocha.pdf|||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HMaOjfuNX3my8MnI0+yn0xPFP6v+XPvM/Nl3v3j+0j8ZOznyXPz806+bXmi+2Pdy9sueqbCph6+Er6Zfl7zRfLP/Lett37uYd6PT+e+x7ys/WHzo/hj08f4n4adPvwHJ4vTiCmVuZHN0cmVhbQplbmRvYmoKNiAwIG9iagpbL0lDQ0Jhc2VkIDUgMCBSXQplbmRvYmoKNyAwIG9iago8PAogIC9UeXBlIC9NZXRhZGF0YQogIC9TdWJ0eXBlIC9YTUwKICAvTGVuZ3RoIDEyIDAgUgo+PgpzdHJlYW0KPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KCjx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iPgo8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgo8cmRmOkRlc2NyaXB0aW9uIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgcmRmOmFib3V0PSIiPgo8ZGM6Zm9ybWF0PmFwcGxpY2F0aW9uL3BkZjwvZGM6Zm9ybWF0Pgo8ZGM6bGFuZ3VhZ2U+eC11bmtub3duPC9kYzpsYW5ndWFnZT4KPGRjOmRhdGU+MjAxNi0wNi0wOFQxNDo0ODozNlo8L2RjOmRhdGU+CjwvcmRmOkRlc2NyaXB0aW9uPgo8cmRmOkRlc2NyaXB0aW9uIHhtbG5zOnBkZj0iaHR0cDovL25zLmFkb2JlLmNvbS9wZGYvMS4zLyIgcmRmOmFib3V0PSIiPgo8cGRmOlByb2R1Y2VyPkFwYWNoZSBGT1AgVmVyc2lvbiAxLjE8L3BkZjpQcm9kdWNlcj4KPHBkZjpQREZWZXJzaW9uPjEuNDwvcGRmOlBERlZlcnNpb24+CjwvcmRmOkRlc2NyaXB0aW9uPgo8cmRmOkRlc2NyaXB0aW9uIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIgcmRmOmFib3V0PSIiPgo8eG1wOkNyZWF0b3JUb29sPkFwYWNoZSBGT1AgVmVyc2lvbiAxLjE8L3htcDpDcmVhdG9yVG9vbD4KPHhtcDpNZXRhZGF0YURhdGU+MjAxNi0wNi0wOFQxNDo0ODozNlo8L3htcDpNZXRhZGF0YURhdGU+Cjx4bXA6Q3JlYXRlRGF0ZT4yMDE2LTA2LTA4VDE0OjQ4OjM2WjwveG1wOkNyZWF0ZURhdGU+CjwvcmRmOkRlc2NyaXB0aW9uPgo8L3JkZjpSREY+CjwveDp4bXBtZXRhPgo8P3hwYWNrZXQgZW5kPSJyIj8+CgoKZW5kc3RyZWFtCmVuZG9iagoxMCAwIG9iago8PCAvTGVuZ3RoIDEzIDAgUiAvRmlsdGVyIC9GbGF0ZURlY29kZSA+PgpzdHJlYW0KeJyNVmtT2zgU/c6vuDM7swNTY2z5Fe+nhQDtMgRSnD5mm35QYhEEtpXKdoD++j2ynZIHpJvAJFako3PvufdIP/ZccvA+NB9RzGia7/3oxlzyQvOHoY/rg1HQjDo02zsZ7R2dB+Q6NLp9wQqcyI6iOI57UY96tsdi82I0yunb/nDs+e5MFvzgO40uVhZ5wdZct51zNtqk0PJybLbkEBFb54CJoR05BszptWjnIpNzQVdqwUVJ50pXdcErRSmnGzW96wg18XgbWF7P7rEeAgqiFutULESm5kLThE8fDkWR0hHlaiIz0cI4dghuKxChY/ssdhynF7QQtw0du2jo2Now+HuWc5nZU5X/CvwHkAKH0fu9b9+BkiL+R6Q+8u04DB3Ho5wCf/U5owTZWgoTbibFceyY9RzH9VsWN6Ksc9VxBuNmFdtcxXw7iAHvhF38hzRogiUkgsb7F2xwZh0XqVYyJWZ776wvg9AOLJLXCX27ntwf9o+SR3lbfR8f0IbwgPcZ4IM49hx/CX8qyodKzZf4fMGTM6v/h/X5xOq/e2cNPwyt4XN1p4rxwTYecr2Jlwi9gFovcGdnFrUIFkoiFfZFgoEPw9fwot42P17xCS9RSMnHS+LQ/+rafBvvD57xCShVVjMtmu83kj9YyFgxU6cn2E4o/8Lqq3p6h0fMkJV4bds43Nr2WKe1LNTWXOb6W3M/FbJ69k5B5U5VqugyICg5T74yEE1yrqtz9dT+sCTwds0xD8Mh9vC7olsZaKuuLfq3ao8FiAe15wbL4jt7QgfJsRewYir5ahFG20XIoILPzG69lyakK1ncc6IC/3Suhch4MRX6pYVerWcW+3aEbKGj4xbqnhdCaniBgJG4AdEhEa/AzCWFvs5FAaN4tbPdEK0XgZbxz23g8b6L6lAUUi5QLcsswwzWQBwbPYmXG5PnMjs2zcY6FxxpVFp2hxpThLhIPIlpDReNxl4YoADBea7VvahUSbcvKaArzPEUibJSNaVSi4qbOATxslTIdwfHSeRzLUpu/0YAoNmMhY7ruZ2jHhc8k2XFTbeKYqGyhUiVpmEmEHGrSSLhaYmQZWcYO1Txgrh1mZ7XwvMZemipCWs1mWiZdSM+vaFIEEERKBBE3jboUpD4/wsSRRuiDpFicc/bqhCg00Uvm5G/NrpzDSsONrAQ1fE8k1O+omh7kECXxj8Fdc5q7wD2XW8b+IuYlGhuOQVmXTYF9C+OqqM+fxCwOuOEyfXV0dfB5fhgJ7jnboMPYJoZn4Ek5Jig5hqlUpQVtDYeuBMx3MypibSvtKCReKqs9uulmvJKGoduHo3nGt/qDJMset8/xcDoTgueQkqLkkrp54niOi3pT6wqykpzWVQlpi0kp5NaZqnQu5j1thQS1IcwXipnCnF/lmXNM3N/yHlFl7yY1ciC2fzTP5+leIRaMm9olxYdn1+J6lHpB1nM4E8oGfOA8eFVCdzr6+GuLAXM5D10mAMf6jquPWOTTlbrV44GvAANbZldZqYOfw20+bLoRCueTnmJZNyIqZAwfaw3ZyGebzMxbVK9i44Xb9ChLvUIZVBnlax4+QDMD6PRsJ9JkEDav+BcTa6Ph9bNWTK6rTOTqff9wVr0b3pOEDm2w8zNI970nKFWMySUG8cx94/OcN7LXBUoIsSj8rpYb6zL0enxDgcKeqHtmVM0dJbnQp3dLR3IaR1o1ZTctywIN5AwAG0gvoK69CD2vz0odPx1Gztd9xzDh6/YiDF+nK2lMtn6yVNu0bQG79xY/lwVWAOdZD7PhFnPp+0SoGT8WdUoEVRHBTgYt9hREiFj67zoTmn5UwFSYoOZlik+6rKBFk/mnCkVhNBiVmccTzTnmhM6VOi5OaFeiJjblCD4FygXDRvYVzN7aTa7ePnOBq/WmHDhlwtl2/bvLjth1N5tori77KwMtJcd8/4PNSB8CQplbmRzdHJlYW0KZW5kb2JqCjggMCBvYmoKPDwKICAvUmVzb3VyY2VzIDMgMCBSCiAgL1R5cGUgL1BhZ2UKICAvTWVkaWFCb3ggWzAgMCA2MTIgNzkyXQogIC9Dcm9wQm94IFswIDAgNjEyIDc5Ml0KICAvQmxlZWRCb3ggWzAgMCA2MTIgNzkyXQogIC9UcmltQm94IFswIDAgNjEyIDc5Ml0KICAvUGFyZW50IDEgMCBSCiAgL0NvbnRlbnRzIDEwIDAgUgo+PgoKZW5kb2JqCjExIDAgb2JqCjI1OTIKZW5kb2JqCjEyIDAgb2JqCjg1NAplbmRvYmoKMTMgMCBvYmoKMTQ1NgplbmRvYmoKMTUgMCBvYmoKPDwgL0xlbmd0aCAxNiAwIFIgL0ZpbHRlciAvRmxhdGVEZWNvZGUgPj4Kc3RyZWFtCnicrZhbb5tIFMff8ymOtC+N6rDcwXnzuk3aqtkktVdaqe7DCUycsYChDLjtfvo9w8WXqfEWtHGsyBP4/87tP0Py9cICk15X6kcwtSFKL762axY4vvqmpcfjxcCrV01YX/yxvPj9xgPLhOXzXsszAyMIptNpGIQQGo49VV82LFP4/Oph5bjWmmd4+QWWHw5ucryfrrWba94u9RCauEzDP4jBP4qBLnRILTTpK2jJhdiwUsid6F6S3lPDPsoqAMvWFU3DtH2l2Mb3hiUlzhJWlAirV7M84RGWfCsgxwKBP7yIjK0uG14do65o+4Y19Shhy2szNi0HsFw5ntX9EJCKlGWl0Apmgutqd/8lK1Xdggt5fcMSnjP4U2yRSbgRRVllWAqIET6J6AUncMOKDDP6fGvALSuQS4klayim4VIhdizKvK6kaU3B16lXcMezF1RJlzziOVIMAb0dcQ1zIXKS3q1ARhEwybKtSLa8TgtiAdHK8Z2Yr+tflgzyQqwLTNEALenDQEL7p0DeMBkVfE8j6bzp+jUcNUsVtkoB9y2LGUi2rgrM1O2UDZNSYGLATGnQBy4yLKgbT6JsxRlgLTc5E6RlmlqUxEWgzCWuWUpjQzLsKkWegKhgcbdYXTbhUY04xtjMkron4ZJCp8ub0CTdS+mK5IWrq1gioNr1n0R49iyKlBqsD85ReFaoh0cgEWHC/znoGvuOCt1VBb5WlLsqWwV1vyQrtnXZhUEtT1Vpn6ssUiVre8ypMdSGSZMbjxkmTWaSl1VL8j0mz8Xq6G5pilHQ3Bgndwp6+5bhj/N13doh3t1gxnhRzwXZeOffTGxZ+rRf/79t/EnEInkWMEdZFmK4fe9hn+4pYzRdSsncudrP5AT4/QIYzLK4EDyegMgos8Phg1wob8Q8aj0jIRJZSWFLKsIQR9NgVRKeMeUJx0KxGc2emmk1d3zLCiAPaSPUBESejbis/YKbKqZCPaHyD0a6kZWoxhlmaCKxJ1Y0Vjl09wQ2lZr+iCxxylZIcSd7WxmDhn/lWG2rcigFNVA5jQHtm2XFCcpgo/oBJdsyoP1F1b4eddOkffFblgiM5bFvTMMjC9xefP5CAcRkoG/kG4cO0sAnsgUpeO7RQgILzXAObSiuMtwvH8vvYy5SlCcNbAcHihrICUY4+0EZaE2D6tlniJ20RvScwbz32Tr5D1ij2l/+gHZoqnbodeXfL5woP1koHFR+2q5zpnYqm/ZrOlToNJI5WYdGNcaYnQm8Qx1H4JrDn6M+4BZ7Oa2gRrGCZigGce5+LB4/9oM6TQ3ltHkOQrW7Yz/MOV09NxzxHHr/tGGR2g6v5v3ATlkD+s4IG9EJ0A/qFDVQMB3u1ncP/ZhGT4NM3RFj8TaiM1ayflSnegzzzOmIwfg7EnE/aqepoWxvxFg0f4DALG8Pc5HRUb+lB8VcHRX9MXQwLQbXHDEprQ9+DdwRNLA3HDv/rZ/inWIE1ojBUfvWgv7gyM/k1AlrvNAfMTvEqtJ+VKd5jPJNe8TszNY8YXDHyhf1eCnW/MxJsCNoYGvMCT1//bofZJ08mH1n+MHcv1G2ahrCDUfMx8MPKl/WT3JPPtn4tIEOn413y7uP4PWzOlGNFYz5v8d8sXD6SZ3kY/36FxdoZFAKZW5kc3RyZWFtCmVuZG9iagoxNCAwIG9iago8PAogIC9SZXNvdXJjZXMgMyAwIFIKICAvVHlwZSAvUGFnZQogIC9NZWRpYUJveCBbMCAwIDYxMiA3OTJdCiAgL0Nyb3BCb3ggWzAgMCA2MTIgNzkyXQogIC9CbGVlZEJveCBbMCAwIDYxMiA3OTJdCiAgL1RyaW1Cb3ggWzAgMCA2MTIgNzkyXQogIC9QYXJlbnQgMSAwIFIKICAvQ29udGVudHMgMTUgMCBSCj4+CgplbmRvYmoKMTYgMCBvYmoKMTIzMQplbmRvYmoKMTggMCBvYmoKPDwgL0xlbmd0aCAxOSAwIFIgL0ZpbHRlciAvRmxhdGVEZWNvZGUgPj4Kc3RyZWFtCniclZfbcts2EIbv9RR72c40LM+H3lm2lDoTJ0qoTjqNcwGREI2EBBSAspM+fRciKZmwqCkkcTQCwf9b7C4Wq+8zD1x8v9JfSeZD0cy+92MeBLH+4NCH8WASHUZdqGbz9ez3ZQSeC+vtSStyEydJsixLkxRSJ/Az/fJh3cDnX1b3QehVjJNfv8D6zbOHgujF3KCbs1ibJgRjCxLw/JEFOM11XD928dVr5Q+0riEvJNu1jFdH5ZOun+hvY714RU6oR/83aSVUW0maf3h71nyNGTTHpMB1UivSHSukUGLbAsIgp/KRyknmoD5mhrHjWzHnNeXlBcwgOMbEnhNbYa72rbi+upnEDIJjTJLYQUqxobB6EC2GTOzgOo8ngZ30GJf5lqnRAW/req9aSVohLyIHeSMfcXfZpUlHXdZEPcB8z+pL4TuqG1A/sMyTfqn8hipW8YvrPIobzCC1TJpr8o2u/lxNgwZFc4fbRfEf3AGwlKShT0J+u7DJz0Uvzixz5pa3WLnYG7i9WVxNwwZdA5eGlsnyjrZzSriaJg2SY5LvupYZckcKeJ9Pco6CBgdrp11WfGK8FE8KkmnUoGmgAs8u5ZWizab+CW8Jr/akotPATtnAYem0S42Pi3y93dfwiW508WcFnQ7bUd2AYiG1S5Ab0pINURTuREnr50fpC+SgbSCTxLaWyHLPuJgGDYoGCAuoXarkT2zbTmMGPX3DdSJ86vXs8xe8X+KMJ+xHAg87nzjKMg8aiMLRADYf5nnv9wXeRdlTMxWbVgbYFqXayqSzcilkQ7CNSvAKBJCClPdB5DesIGdtR1Joe/7+xRk2E4qVpKRwTdr7IA5qBAD+nEuiEBjVrOcdzDYl/djxMlx55kV9FDmpmWoJUMBDgfJHUT+yhvJWaNEcb9GGqN9w43ue0RxiW+E7wUENPdnV+o9/ABjT/MhBj+jGM375wFoSjp4aZ9HZKIZYeTwMWhr1UXw20EXxcsBCvXQfG2A36b25+LGjkukg8YIRKEQDeP5vSP0gFKAf9rzVbbFkot/AurU9G6gwTPtIZWnfbkqxpUphL4Fe/JuUkv4LwAkA4J0KTykCC1WIGkNHYEkadjlsYRx2jovdrAN83aOZWhwrcgjwCkCnQ+SBgEYc4tfbjMlcnaQwpQ5J63oZhKnvRKjopkHvEK7wL8AjgR+dwTuJaaFa1uxrIlFYkoKJgnEmoBYVKwQmzQ7H6MF/BL1G0GlCOc/6+LOxjNCMKI7dYUOefneR1O//AO4r7bUKZW5kc3RyZWFtCmVuZG9iagoxNyAwIG9iago8PAogIC9SZXNvdXJjZXMgMyAwIFIKICAvVHlwZSAvUGFnZQogIC9NZWRpYUJveCBbMCAwIDYxMiA3OTJdCiAgL0Nyb3BCb3ggWzAgMCA2MTIgNzkyXQogIC9CbGVlZEJveCBbMCAwIDYxMiA3OTJdCiAgL1RyaW1Cb3ggWzAgMCA2MTIgNzkyXQogIC9QYXJlbnQgMSAwIFIKICAvQ29udGVudHMgMTggMCBSCj4+CgplbmRvYmoKMTkgMCBvYmoKOTQ5CmVuZG9iagoyMSAwIG9iago8PCAvVVJJIChodHRwczovL3d3dy5saW5rZWRpbi5jb20vcHJvZmlsZS92aWV3P2lkPUFBRUFBQWZIanNnQlNGS2xBQVdvMzdSQ0c3N1QtOTJDX0cwLVJEayZhdXRoVHlwZT1uYW1lJmF1dGhUb2tlbj1VTVc0JmdvYmFjaz0lMkVwZGZfQUFFQUFBZkhqc2dCU0ZLbEFBV28zN1JDRzc3VCo1OTJDKjRHMCo1UkRrXyoxX3B0KjRCUl9uYW1lX1VNVzRfRmVsaXBlTm92YWVzK0ZvcnR1bmF0bytkYStSb2NoYV90cnVlXyoxKQovUyAvVVJJID4+CmVuZG9iagoyMiAwIG9iago8PCAvVHlwZSAvQW5ub3QKL1N1YnR5cGUgL0xpbmsKL1JlY3QgWyAzNi4wIDU4OC4wMTYgMjk2LjI5MiA1OTguODE2IF0KL0MgWyAwIDAgMCBdCi9Cb3JkZXIgWyAwIDAgMCBdCi9BIDIxIDAgUgovSCAvSQoKPj4KZW5kb2JqCjI0IDAgb2JqCjw8IC9MZW5ndGggMjUgMCBSIC9GaWx0ZXIgL0ZsYXRlRGVjb2RlID4+CnN0cmVhbQp4nKVZTZMkNxG916/QEYiwLCn1eSMIvAQEQbB4bsaHcW3vzoSre7zDYP4+70nV3VLNVoM9Xn+1XlUqM5X5MlP1ebLK4M9X/E8qTs3H6fO6ZpVE/o2l9+NiCnXVqE/TH+6mr98FZY26+3iVFUzSKZVScsoqa3GFfzl1d1Tf/ebv/xRvPz2e7n/7vbr7S/eShFfP+vbMN3dbFZpeRruzDkm5UQc8GHUyFGZyk/busDz+dFB/e/r5/vAv9e7p+eXfp/uXJ/XhXv3jaX5YFar2yEaWZJ1dhkEhNVl/PPx8WJ5+OjyrH+7nH786nD6or9Xx6YfH5dDEGB2hWyciGu1dMcbk0ER8rOroU1VHP1OD33863j8uen46Xgz/DEnBOPWn6bvvIeUD7P8PXJ+8LjEaI+qogu9/L+rb6i2DV8xFBf47J+1CO2J4Lhn+1dDNz+raJCJ4nWIE51mcLSWZpPC/YvGow9YjIjoERylBibU6RDzmo6f7cBbGMx5SofzJm6JTMfCn5ZbL5K2HDmvIGOUt5EJsdsX2cof1ThNI7BFrnE4x1l9V+IAlbX0oJZqiztvG7KKyFodW+FZUg4I9ME+DMT20TM1sU5K3boAGPw0abJBO73nX78sN5GH62I7/f59wVOs/Rop6/rRGTIEKTpg2Dgfsgy4mUCEZkGVAUtKxHpGnCvBPtMJITzcQZ7QNlCZEzKvf425vNCsWeBxPik0bA3vEAxFEQy48zOB0ECpbwg1kVHNvn1vIwwRqyL5agcyBW22g7KodHCaAXCwDkmA4BSTGltMmIWaQ/8O6Q7o3Fs6IJSBWEDARezinJQXVhJfiA0I86+jJvTGQqUoAcyJ1++V5CkG7c3T2SEDUQ04J3p1lD0uDIj3Sqw7hloCHi3tTI6kI2gSbh/V5123LDQRx9Lu3BFKKOpPXjImbQCqifSIt+O0B90j0OrMosYZuENFgFiLINFBeZoDB5mhRevBMZLB5bRycXs8IItpxzlPBwZAN8JwKrL31mQJi4DOC4up15L6h+EoygfSTohuAebImg2sZ5zyQ/h1wWYmQmrxXoSAM8H5AtRmACFdnqOEjGXmARo9YhERIoYbYPgJfmciQ9XGD+IzSjnIcMmm2IOIyYx50DvqFrID+gLZ4T1tq3bgCcFfRPsd2iD0CNwYGvgc9+XjVECcTfUsqX2AifIo+YB6OrwPGcz1TR8BJLUP8bJCEXChkcdiRtOfxgy3UXsTtrc+7Mfr26LdIXmOZvVjrCfs4WfGaP7bIMiCbw+7F3YBgELIfB2BLhcAU7HWMoL5Y7VjawUm1vmRtE0+zbJPQZhCWRTRa2VYyCEMySY0gZNu1nNscdGYKRBwj2rDMchd8fQXIOej+L8SiaDjmd3A1gy7xMViK7ZNdU2bed/dyC3pjqXQiaG/I7K66N4PNj3XVMahsKKwyoeD/heQu5CrErQ/garjfNdvH9aCFAe2E8TlAcIt3aBDgCYcMN+xkAqsasprtBVgK9qEZi0wI8FsPwEUFAUBZ1o/v2MxWCkUgISODoAasETMAMV1DCcJ6KLPtDC0HLRLa+mxAnYF0kGg933G2xh+8EmUAYCUqZDDRgJ/i+I5D/CZnrDtH4hoJTnASgl1APKqYK0dBmAOZBexTUHpTQTqs3lgAwTicrI0ewxYot3DICKjyJMZsmwIZgXVpDKwgyJNxlm90APYxoHCB0qUMCH5rOhBZCOZhkTi7ueTa0sHawGjputcvBdKys/owURAKSktC+kHYLyQyC5DiESIgEhUiuDhXakRYYD+WSQ9FgmErwS7YAsC4lnPzUA/wVCLiDaQrKY3vWFIH/YjKiV1SobnoWgeg12ze1Xm5gbyVgh0mvYA+tHLXSMEDhPbcpcB8JScQkuoQ9GBbyCJ+cORiawFNAc8Jmnq0evA7jhPzDFPLM+bgcwBQNl/z9ALAvaxcRRBzfvOORHSmTKdoWStRTwnkCly4gel4bncZQB2EdBQGgePowOJs2EzDvUitzLOSBH+AWG1O2B4/egDCYI1JyAbvx1eS041a4BkkXbHcJLB9ZuPIQEMvlGtzCuVLzZJEY9i3onPuoaVCGQ4wQdYKRCjWyAdVxb7YDUhLiYiERHdlvCHVKgLOmlZB4AEL18PuPALoHCwPzVdGHKCxMuzGzk3oYQQxyAQ2OsihbcyhLmQ2hgmUScCDmK2geMLHl4GXAM4X9OfBGKgq5zsa+lWuZA6rUlm7VDyvBWMk/sTGcZ6+J4Dtz2zSAxAWOHom6BbGV1AMLDs7dnk4Y88jYXM9AGwJTOudKapDApiYxgsZG3uQGDL6Q448mY4Rb6tede7NoO8eYCCimJ2NHN6B9VLWERE9jjfrNNSSdyVyRHiiKiKhegz7mJZVdVDCK65kNaxjDxK6Fzeus9jZi1o90h3xsn/6v4TM7PkqCQyD4YHG19k5stzSE8cRQm8c03pbtkziOnfegKrAlXGWL+x1A1rVoE2CsRSRh9+5Tt15nVepo2DyQB2uSdhD4CZEKGoqm3mOtefebAA4CbORXS+SAKH2g97ASZybLXOOY+66i9Q+Bg4nGTiuo3ai+oF78gBAFkQLZl7oPr6C7gAlGSRG3uQeNNRsAerFkEypyuqgaktgRVBSB3mEZcqhGc913sbioQx9PTivX5+/4MoVWva9/KvCCqXckwNTttuwihysXOt2xqMeIGRs8mvrtIVASxykCwsha1RmTbKtXT9TOoHYaofUmk/yKnU8hyMxw9dy5et8fqZnQe1lk1mFcd6uk0wRABGMKUbQJw8AhKFJRbuJ08GgOLyTPS8fUSFxvJzR2X/wwnoAOKPzCgE5U4V1UHWOI1Fk3u+hu2KbijpYbkGc0g0geGsLed4RIdwNPCIQUdBGVQrn0A12QxFGVMEeTALs7mQAoB0Y0dBxJo2Q1Nu0tR9nM8Bss4nfBSLvHHCIeIojuWMBqEW7nWhrAHpkGRGSyxWpYZVWBV5B8dwWouvBGRcWCLUbirvAvB++b+8XvWP7imOxvMFln7Ee/hEQGrRATiwjtIwQJucW/bFepmNKEUwmmLXDKwihyWGugHmqwHUUJyTaM1UimvgtxL5orXsQ6Hl71e5RKDCw1tjiCQl9ZBM6SOFtGbMV03RGRqEiILr8BojXEW6eRihcm6S6i7jWKaBriZd19jN2bfM6YB692kPLvsNvQg8blwe0Neu8eNy4vIOa8y75RshRAoOfxO1rlazWBs5ymLXGdfbRa7s/TyOERp79dsYZtU3Wrw0EKk1ithoV64B5Y04HbYNrNGcfooc84waNrq27FQ40LCbHEYJnMW+16wXMemyO6eZcr08576FMVtUDibw26h3QAoVj6fg4P12sscAN6CepvumAXinK6SEwNRW0LXhzWjv5bK+j6qBTD9CdnR3DO4NTuk32nDXv+7E5OVwm162PO6SmD5pF5iJUSx7EGFDdsquXEeg93MacDmgudhzUUnabdxjD50/H4TodjMDGzx1UeDFOwo6i2i4R6/WihfOH2erVrTcvX0zp3+hMrxuoPTfNuw68UPn7qX2Qfb5+PnevPl2H67hePxZ/c3p5PqjDUc1Pp5f60frx+fByfzycXg5YO6r14/bpSf318fTj4cOfT9238/fTfwF3ZWaICmVuZHN0cmVhbQplbmRvYmoKMjMgMCBvYmoKWwoyMiAwIFIKXQplbmRvYmoKMjAgMCBvYmoKPDwKICAvUmVzb3VyY2VzIDMgMCBSCiAgL1R5cGUgL1BhZ2UKICAvTWVkaWFCb3ggWzAgMCA2MTIgNzkyXQogIC9Dcm9wQm94IFswIDAgNjEyIDc5Ml0KICAvQmxlZWRCb3ggWzAgMCA2MTIgNzkyXQogIC9UcmltQm94IFswIDAgNjEyIDc5Ml0KICAvUGFyZW50IDEgMCBSCiAgL0Fubm90cyAyMyAwIFIKICAvQ29udGVudHMgMjQgMCBSCj4+CgplbmRvYmoKMjUgMCBvYmoKMjcyNQplbmRvYmoKMjYgMCBvYmoKPDwKICAvVHlwZSAvRm9udAogIC9TdWJ0eXBlIC9UeXBlMQogIC9CYXNlRm9udCAvVGltZXMtQm9sZAogIC9FbmNvZGluZyAvV2luQW5zaUVuY29kaW5nCj4+CgplbmRvYmoKMjcgMCBvYmoKPDwKICAvVHlwZSAvRm9udAogIC9TdWJ0eXBlIC9UeXBlMQogIC9CYXNlRm9udCAvVGltZXMtUm9tYW4KICAvRW5jb2RpbmcgL1dpbkFuc2lFbmNvZGluZwo+PgoKZW5kb2JqCjEgMCBvYmoKPDwgL1R5cGUgL1BhZ2VzCi9Db3VudCA0Ci9LaWRzIFs4IDAgUiAxNCAwIFIgMTcgMCBSIDIwIDAgUiBdID4+CmVuZG9iagoyIDAgb2JqCjw8CiAgL1R5cGUgL0NhdGFsb2cKICAvUGFnZXMgMSAwIFIKICAvTGFuZyAoeC11bmtub3duKQogIC9NZXRhZGF0YSA3IDAgUgogIC9QYWdlTGFiZWxzIDkgMCBSCj4+CgplbmRvYmoKMyAwIG9iago8PAogIC9Gb250IDw8IC9GNyAyNiAwIFIgL0Y1IDI3IDAgUiA+PgoKICAvUHJvY1NldCBbL1BERiAvSW1hZ2VCIC9JbWFnZUMgL1RleHRdCiAgL0NvbG9yU3BhY2UgPDwgL0RlZmF1bHRSR0IgNiAwIFIgPj4KCj4+CgplbmRvYmoKOSAwIG9iago8PCAvTnVtcyBbMCA8PCAvUCAoMSkgPj4KIDEgPDwgL1AgKDIpID4+CiAyIDw8IC9QICgzKSA+PgogMyA8PCAvUCAoNCkgPj4KXSA+PgoKZW5kb2JqCnhyZWYKMCAyOAowMDAwMDAwMDAwIDY1NTM1IGYgCjAwMDAwMTIwMTYgMDAwMDAgbiAKMDAwMDAxMjA5NSAwMDAwMCBuIAowMDAwMDEyMjA3IDAwMDAwIG4gCjAwMDAwMDAwMTUgMDAwMDAgbiAKMDAwMDAwMDEzOSAwMDAwMCBuIAowMDAwMDAyODE3IDAwMDAwIG4gCjAwMDAwMDI4NTAgMDAwMDAgbiAKMDAwMDAwNTMyNiAwMDAwMCBuIAowMDAwMDEyMzQ1IDAwMDAwIG4gCjAwMDAwMDM3OTQgMDAwMDAgbiAKMDAwMDAwNTUxOCAwMDAwMCBuIAowMDAwMDA1NTM5IDAwMDAwIG4gCjAwMDAwMDU1NTkgMDAwMDAgbiAKMDAwMDAwNjg4NyAwMDAwMCBuIAowMDAwMDA1NTgwIDAwMDAwIG4gCjAwMDAwMDcwODAgMDAwMDAgbiAKMDAwMDAwODEyNiAwMDAwMCBuIAowMDAwMDA3MTAxIDAwMDAwIG4gCjAwMDAwMDgzMTkgMDAwMDAgbiAKMDAwMDAxMTU2OCAwMDAwMCBuIAowMDAwMDA4MzM5IDAwMDAwIG4gCjAwMDAwMDg2MDMgMDAwMDAgbiAKMDAwMDAxMTU0MSAwMDAwMCBuIAowMDAwMDA4NzQwIDAwMDAwIG4gCjAwMDAwMTE3NzggMDAwMDAgbiAKMDAwMDAxMTc5OSAwMDAwMCBuIAowMDAwMDExOTA3IDAwMDAwIG4gCnRyYWlsZXIKPDwKICAvUm9vdCAyIDAgUgogIC9JbmZvIDQgMCBSCiAgL0lEIFs8N0Q3QkIwNDgxMEEzRkY3ODk5Q0Y3NUY3MkIzN0Q4Njc+IDw3RDdCQjA0ODEwQTNGRjc4OTlDRjc1RjcyQjM3RDg2Nz5dCiAgL1NpemUgMjgKPj4Kc3RhcnR4cmVmCjEyNDM5CiUlRU9GCg==	447	2016-07-27 20:21:53.25497	301	3304
7634	218	please	448	2016-07-27 20:22:05.438396	302	3305
7635	218	please	449	2016-07-27 20:22:05.502455	302	3306
7628	202	Bruno R Siqueira	447	2016-07-27 20:21:53.25246	301	3304
7629	215	babirondo.git	447	2016-07-27 20:21:53.253202	301	3304
7630	216	walmart	447	2016-07-27 20:21:53.253589	301	3304
7631	217	2	447	2016-07-27 20:21:53.253994	301	3304
7632	223	3	447	2016-07-27 20:21:53.25437	301	3304
7636	204	a	450	2016-07-27 20:42:08.983475	304	3310
7637	208	a	450	2016-07-27 20:42:08.984296	304	3310
7638	209	a	450	2016-07-27 20:42:08.984672	304	3310
7639	210	a	450	2016-07-27 20:42:08.985039	304	3310
7640	211	a	450	2016-07-27 20:42:08.985415	304	3310
7641	213	a	450	2016-07-27 20:42:08.985764	304	3310
7642	212	1	450	2016-07-27 20:42:08.986311	304	3310
7643	203	1,2,3,4	450	2016-07-27 20:42:08.986736	304	3310
7644	202	Stefany CRuz	451	2016-07-27 20:43:28.059725	301	3311
7645	215	oo	451	2016-07-27 20:43:28.060583	301	3311
7646	216	kkl	451	2016-07-27 20:43:28.061203	301	3311
7647	217	2,4	451	2016-07-27 20:43:28.061998	301	3311
7648	223	1,2	451	2016-07-27 20:43:28.063169	301	3311
7649	214	Ginga One - Victor Fernandes.pdf|||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L0ZvbnQvU3VidHlwZS9UeXBlMC9CYXNlRm9udC9BcmlhbE1UL0VuY29kaW5nL0lkZW50aXR5LUgvRGVzY2VuZGFudEZvbnRzIDEwIDAgUi9Ub1VuaWNvZGUgMzEgMCBSPj4NCmVuZG9iag0KMTAgMCBvYmoNClsgMTEgMCBSXSANCmVuZG9iag0KMTEgMCBvYmoNCjw8L0Jhc2VGb250L0FyaWFsTVQvU3VidHlwZS9DSURGb250VHlwZTIvVHlwZS9Gb250L0NJRFRvR0lETWFwL0lkZW50aXR5L0RXIDEwMDAvQ0lEU3lzdGVtSW5mbyAxMiAwIFIvRm9udERlc2NyaXB0b3IgMTMgMCBSL1cgMzMgMCBSPj4NCmVuZG9iag0KMTIgMCBvYmoNCjw8L09yZGVyaW5nKElkZW50aXR5KSAvUmVnaXN0cnkoQWRvYmUpIC9TdXBwbGVtZW50IDA+Pg0KZW5kb2JqDQoxMyAwIG9iag0KPDwvVHlwZS9Gb250RGVzY3JpcHRvci9Gb250TmFtZS9BcmlhbE1UL0ZsYWdzIDMyL0l0YWxpY0FuZ2xlIDAvQXNjZW50IDkwNS9EZXNjZW50IC0yMTAvQ2FwSGVpZ2h0IDcyOC9BdmdXaWR0aCA0NDEvTWF4V2lkdGggMjY2NS9Gb250V2VpZ2h0IDQwMC9YSGVpZ2h0IDI1MC9MZWFkaW5nIDMzL1N0ZW1WIDQ0L0ZvbnRCQm94WyAtNjY1IC0yMTAgMjAwMCA3MjhdIC9Gb250RmlsZTIgMzIgMCBSPj4NCmVuZG9iag0KMTQgMCBvYmoNCjw8L1R5cGUvWE9iamVjdC9TdWJ0eXBlL0ltYWdlL1dpZHRoIDE5Mi9IZWlnaHQgNDYvQ29sb3JTcGFjZS9EZXZpY2VSR0IvQml0c1BlckNvbXBvbmVudCA4L0ZpbHRlci9EQ1REZWNvZGUvSW50ZXJwb2xhdGUgdHJ1ZS9MZW5ndGggMjQ5Mz4+DQpzdHJlYW0NCv/Y/+AAEEpGSUYAAQEBAGAAYAAA/9sAQwANCQoLCggNCwsLDw4NEBQhFRQSEhQoHR4YITAqMjEvKi4tNDtLQDQ4RzktLkJZQkdOUFRVVDM/XWNcUmJLU1RR/9sAQwEODw8UERQnFRUnUTYuNlFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFR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dCA3MDAvWEhlaWdodCAyNTAvTGVhZGluZyAzMy9TdGVtViA0Ny9Gb250QkJveFsgLTYyOCAtMjEwIDIwMDAgNzI4XSA+Pg0KZW5kb2JqDQoxNyAwIG9iag0KPDwvVHlwZS9Gb250L1N1YnR5cGUvVHlwZTAvQmFzZUZvbnQvQXJpYWwtQm9sZE1UL0VuY29kaW5nL0lkZW50aXR5LUgvRGVzY2VuZGFudEZvbnRzIDE4IDAgUi9Ub1VuaWNvZGUgMzUgMCBSPj4NCmVuZG9iag0KMTggMCBvYmoNClsgMTkgMCBSXSANCmVuZG9iag0KMTkgMCBvYmoNCjw8L0Jhc2VGb250L0FyaWFsLUJvbGRNVC9TdWJ0eXBlL0NJREZvbnRUeXBlMi9UeXBlL0ZvbnQvQ0lEVG9HSURNYXAvSWRlbnRpdHkvRFcgMTAwMC9DSURTeXN0ZW1JbmZvIDIwIDAgUi9Gb250RGVzY3JpcHRvciAyMSAwIFIvVyAzNyAwIFI+Pg0KZW5kb2JqDQoyMCAwIG9iag0KPDwvT3JkZXJpbmcoSWRlbnRpdHkpIC9SZWdpc3RyeShBZG9iZSkgL1N1cHBsZW1lbnQgMD4+DQplbmRvYmoNCjIxIDAgb2JqDQo8PC9UeXBlL0ZvbnREZXNjcmlwdG9yL0ZvbnROYW1lL0FyaWFsLUJvbGRNVC9GbGFncyAzMi9JdGFsaWNBbmdsZSAwL0FzY2VudCA5MDUvRGVzY2VudCAtMjEwL0NhcEhlaWdodCA3MjgvQXZnV2lkdGggNDc5L01heFdpZHRoIDI2MjgvRm9udFdlaWdodCA3MDAvWEhlaWdodCAyNTAvTGVhZGluZyAzMy9TdGVtViA0Ny9Gb250QkJveFsgLTYyOCAtMjEwIDIwMDAgNzI4XSAvRm9udEZpbGUyIDM2IDAgUj4+DQplbmRvYmoNCjIyIDAgb2JqDQo8PC9UeXBlL1BhZ2UvUGFyZW50IDIgMCBSL1Jlc291cmNlczw8L0ZvbnQ8PC9GMSA1IDAgUi9GMiA5IDAgUi9GMyAxNSAwIFI+Pi9FeHRHU3RhdGU8PC9HUzcgNyAwIFIvR1M4IDggMCBSPj4vWE9iamVjdDw8L0ltYWdlMjQgMjQgMCBSPj4vUHJvY1NldFsvUERGL1RleHQvSW1hZ2VCL0ltYWdlQy9J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YmoNCjMzIDAgb2JqDQpbIDBbIDc1MF0gIDNbIDI3OF0gIDZbIDU1Nl0gIDExWyAzMzMgMzMzXSAgMTRbIDU4NCAyNzggMzMzIDI3OCAyNzggNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTZdICAyNlsgNTU2IDU1NiA1NTYgMjc4IDI3OF0gIDM1WyAxMDE1IDY2NyA2NjcgNzIyIDcyMiA2NjcgNjExIDc3OCA3MjIgMjc4IDUwMF0gIDQ3WyA1NTYgODMzIDcyMiA3NzggNjY3IDc3OCA3MjIgNjY3IDYxMSA3MjIgNjY3IDk0NF0gIDY4WyA1NTYgNTU2IDUwMCA1NTYgNTU2IDI3OCA1NTYgNTU2IDIyMiAyMjIgNTAwIDIyMiA4MzMgNTU2IDU1NiA1NTYgNTU2IDMzMyA1MDAgMjc4IDU1NiA1MDAgNzIyIDUwMCA1MDAgNTAwXSAgMTA1WyA1NTZdICAxMDlbIDU1Nl0gIDExMVsgNTAwIDU1Nl0gIDExNFsgNTU2XSAgMTE2WyAyNzhdICAxMjFbIDU1Nl0gIDEyM1sgNTU2XSAgMTI1WyA1NTYgNTU2XSAgMTU4WyAzNjVdICAxNzdbIDU1Nl0gIDIwMFsgNjY3XSBdIA0KZW5kb2JqDQozNCAwIG9iag0KWyAyNzggMCAwIDU1NiAwIDAgMCAwIDMzMyAzMzMgMCA1ODQgMjc4IDMzMyAyNzggMjc4IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDAgNTU2IDU1NiA1NTYgMjc4IDI3OCAwIDAgMCAwIDEwMTUgNjY3IDY2NyA3MjIgNzIyIDY2NyA2MTEgNzc4IDcyMiAyNzggNTAwIDAgNTU2IDgzMyA3MjIgNzc4IDY2NyA3NzggNzIyIDY2NyA2MTEgNzIyIDY2NyA5NDQgMCAwIDAgMCAwIDAgMCAwIDAgNTU2IDU1NiA1MDAgNTU2IDU1NiAyNzggNTU2IDU1NiAyMjIgMjIyIDUwMCAyMjIgODMzIDU1NiA1NTYgNTU2IDU1NiAzMzMgNTAwIDI3OCA1NTYgNTAwIDcyMiA1MDAgNTAwIDUwMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAw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IDE3N1sgNTU2XSBdIA0KZW5kb2JqDQozOCAwIG9iag0KWyAyNzggMCAwIDU1NiAwIDAgMCAwIDAgMCAwIDAgMCAzMzMgMCAwIDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiAwIDAgNTU2IDMzMyAwIDAgMCAwIDAgMCA3MjIgNzIyIDcyMiA3MjIgNjY3IDYxMSA3NzggNzIyIDI3OCA1NTYgMCA2MTEgODMzIDcyMiA3NzggNjY3IDc3OCAwIDY2NyA2MTEgNzIyIDY2NyA5NDQgMCAwIDAgMCAwIDAgMCAwIDAgNTU2IDYxMSA1NTYgNjExIDU1NiAzMzMgNjExIDYxMSAyNzggMjc4IDU1NiAyNzggODg5IDYxMSA2MTEgNjExIDAgMzg5IDU1NiAzMzMgNjExIDU1NiA3NzggNTU2IDAgNTAwIDAgMjgwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgNTU2IDAgNTU2IDAgMCAwIDU1NiAwIDU1NiA1NTYgMCAwIDI3OCAwIDAgMCAwIDAgNjExIDYxMSA2MTEgMCAwIDAgMCA2MTFdIA0KZW5kb2JqDQozOSAwIG9iag0KWyAyNzhdIA0KZW5kb2JqDQo0MCAwIG9iag0KPDwvVHlwZS9YUmVmL1NpemUgNDAvV1sgMSA0IDJdIC9Sb290IDEgMCBSL0luZm8gMzAgMCBSL0lEWzw5NzNEMTIxRDQ5RDFGQjQzOUU0MzE5NjUyOTlCRjlGMj48OTczRDEyMUQ0OUQxRkI0MzlFNDMxOTY1Mjk5QkY5RjI+XSAvRmlsdGVyL0ZsYXRlRGVjb2RlL0xlbmd0aCAxNDk+Pg0Kc3RyZWFtDQp4nCXOPQ4BURiF4XvVEoZOMf42IJPIEPQSyUwyMyxAbIFKorEEiVJBYgn2YA1KsQLqce97vuJ7yvMa464srfuBMZ5EnMA+oXaG+giClkjFERpGhOIBTSt+EG6gXRVf6OyE9rqR2ENvC/0rREOY3mD2grmSsjvkCygGsIxhtfbYhECbviErID94KvEHxheYuLI/zM4Z1g0KZW5kc3RyZWFtDQplbmRvYmoNCnhyZWYNCjAgNDENCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAxNyAwMDAwMCBuDQowMDAwMDAwMDc4IDAwMDAwIG4NCjAwMDAwMDAxNDggMDAwMDAgbg0KMDAwMDAwMDQ1OCAwMDAwMCBuDQowMDAwMDAzOTkxIDAwMDAwIG4NCjAwMDAwMDQxNTIgMDAwMDAgbg0KMDAwMDAwNDM3OCAwMDAwMCBuDQowMDAwMDA0NDMxIDAwMDAwIG4NCjAwMDAwMDQ0ODQgMDAwMDAgbg0KMDAwMDAwNDYwOCAwMDAwMCBuDQowMDAwMDA0NjM4IDAwMDAwIG4NCjAwMDAwMDQ3OTEgMDAwMDAgbg0KMDAwMDAwNDg2NSAwMDAwMCBuDQowMDAwMDA1MTA5IDAwMDAwIG4NCjAwMDAwMDc3ODAgMDAwMDAgbg0KMDAwMDAwNzk0OCAwMDAwMCBuDQowMDAwMDA4MTgwIDAwMDAwIG4NCjAwMDAwMDgzMTAgMDAwMDAgbg0KMDAwMDAwODM0MCAwMDAwMCBuDQowMDAwMDA4NDk4IDAwMDAwIG4NCjAwMDAwMDg1NzIgMDAwMDAgbg0KMDAwMDAwODgyMSAwMDAwMCBuDQowMDAwMDA5MTIzIDAwMDAwIG4NCjAwMDAwMTI4NTMgMDAwMDAgbg0KMDAwMDAxNTUyNCAwMDAwMCBuDQowMDAwMDE1ODM2IDAwMDAwIG4NCjAwMDAwMTg0ODggMDAwMDAgbg0KMDAwMDAyMTE1OSAwMDAwMCBuDQowMDAwMDIxMzIzIDAwMDAwIG4NCjAwMDAwMjE1NTIgMDAwMDAgbg0KMDAwMDAyMTgxNSAwMDAwMCBuDQowMDAwMDIyMTE0IDAwMDAwIG4NCjAwMDAwODU1MDQgMDAwMDAgbg0KMDAwMDA4NTk4OCAwMDAwMCBuDQowMDAwMDg2NjEyIDAwMDAwIG4NCjAwMDAwODY5MTEgMDAwMDAgbg0KMDAwMDE0NTM4MiAwMDAwMCBuDQowMDAwMTQ1ODIzIDAwMDAwIG4NCjAwMDAxNDY0MjAgMDAwMDAgbg0KMDAwMDE0NjQ0NyAwMDAwMCBuDQp0cmFpbGVyDQo8PC9TaXplIDQxL1Jvb3QgMSAwIFIvSW5mbyAzMCAwIFIvSURbPDk3M0QxMjFENDlEMUZCNDM5RTQzMTk2NTI5OUJGOUYyPjw5NzNEMTIxRDQ5RDFGQjQzOUU0MzE5NjUyOTlCRjlGMj5dID4+DQpzdGFydHhyZWYNCjE0Njc5Nw0KJSVFT0YNCnhyZWYNCjAgMA0KdHJhaWxlcg0KPDwvU2l6ZSA0MS9Sb290IDEgMCBSL0luZm8gMzAgMCBSL0lEWzw5NzNEMTIxRDQ5RDFGQjQzOUU0MzE5NjUyOTlCRjlGMj48OTczRDEyMUQ0OUQxRkI0MzlFNDMxOTY1Mjk5QkY5RjI+XSAvUHJldiAxNDY3OTcvWFJlZlN0bSAxNDY0NDc+Pg0Kc3RhcnR4cmVmDQoxNDc3NzUNCiUlRU9G	451	2016-07-27 20:43:28.067398	301	3311
7650	206	447	452	2016-07-27 20:43:58.34407	305	3312
7651	205	450	452	2016-07-27 20:43:58.344895	305	3312
7652	206	451	453	2016-07-27 20:43:58.3973	305	3313
7653	205	450	453	2016-07-27 20:43:58.398184	305	3313
\.


--
-- Name: workflow_dados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_dados_id_seq', 7653, true);


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
299	27	2	Primeira avaliação	\N	1	L	3	\N	\N	\N	AUTO-DIRECIONADO	\N
300	27	2	Segunda avaliaçÃo	\N	1	L	3	\N	\N	\N	AUTO-DIRECIONADO	\N
\.


--
-- Name: workflow_postos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_postos_id_seq', 315, true);


--
-- Data for Name: workflow_tramitacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY workflow_tramitacao (id, idprocesso, idworkflowposto, inicio, fim, id_usuario_associado) FROM stdin;
3305	448	300	2016-07-27 20:22:05.214235	\N	425
3306	449	299	2016-07-27 20:22:05.441439	\N	424
3304	447	298	2016-07-27 20:21:53.201225	2016-07-27 20:36:44.2025	\N
3307	447	298	2016-07-27 20:36:44.11855	2016-07-27 20:37:12.860799	\N
3309	447	298	2016-07-27 20:41:22.117118	\N	\N
3308	447	298	2016-07-27 20:37:12.800077	2016-07-27 20:41:22.197541	\N
3310	450	303	2016-07-27 20:42:08.945862	\N	\N
3311	451	298	2016-07-27 20:43:28.010574	\N	\N
3312	452	306	2016-07-27 20:43:58.299943	\N	\N
3313	453	306	2016-07-27 20:43:58.348971	\N	\N
\.


--
-- Name: workflow_tramitacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('workflow_tramitacao_id_seq', 3313, true);


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

