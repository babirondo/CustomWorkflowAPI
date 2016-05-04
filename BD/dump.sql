--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5beta2
-- Dumped by pg_dump version 9.5beta2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pb; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE pb WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';


ALTER DATABASE pb OWNER TO postgres;

\connect pb

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
-- Name: FEED; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "FEED" (
    "ID_FEED" integer NOT NULL,
    "ID_JOGADOR" integer,
    "NEW" text,
    "PUBLICADO" timestamp without time zone
);


ALTER TABLE "FEED" OWNER TO postgres;

--
-- Name: FEED_ID_FEED_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "FEED_ID_FEED_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "FEED_ID_FEED_seq" OWNER TO postgres;

--
-- Name: FEED_ID_FEED_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "FEED_ID_FEED_seq" OWNED BY "FEED"."ID_FEED";


--
-- Name: JOGADOR; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "JOGADOR" (
    "ID_JOGADOR" integer NOT NULL,
    "NOME" text,
    "EMAIL" text,
    "SENHA" text,
    "NUM" text,
    "PESO" text,
    "ALTURA" text,
    "FOTOJOGADOR" text
);


ALTER TABLE "JOGADOR" OWNER TO postgres;

--
-- Name: JOGADOR_ID_JOGADOR_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "JOGADOR_ID_JOGADOR_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "JOGADOR_ID_JOGADOR_seq" OWNER TO postgres;

--
-- Name: JOGADOR_ID_JOGADOR_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "JOGADOR_ID_JOGADOR_seq" OWNED BY "JOGADOR"."ID_JOGADOR";


--
-- Name: JOGADOR_POSICOES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "JOGADOR_POSICOES" (
    "ID_JOGADOR" integer,
    "ID_POSICAO_JOGADOR" integer NOT NULL,
    "ID_POSICAO" integer
);


ALTER TABLE "JOGADOR_POSICOES" OWNER TO postgres;

--
-- Name: JOGADOR_POSICOES_ID_POSICAO_JOGADOR_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "JOGADOR_POSICOES_ID_POSICAO_JOGADOR_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "JOGADOR_POSICOES_ID_POSICAO_JOGADOR_seq" OWNER TO postgres;

--
-- Name: JOGADOR_POSICOES_ID_POSICAO_JOGADOR_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "JOGADOR_POSICOES_ID_POSICAO_JOGADOR_seq" OWNED BY "JOGADOR_POSICOES"."ID_POSICAO_JOGADOR";


--
-- Name: POSICOES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "POSICOES" (
    "ID_POSICAO" integer NOT NULL,
    "POSICAO" text
);


ALTER TABLE "POSICOES" OWNER TO postgres;

--
-- Name: POSICOES_ID_POSICAO_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "POSICOES_ID_POSICAO_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "POSICOES_ID_POSICAO_seq" OWNER TO postgres;

--
-- Name: POSICOES_ID_POSICAO_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "POSICOES_ID_POSICAO_seq" OWNED BY "POSICOES"."ID_POSICAO";


--
-- Name: TIMES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "TIMES" (
    "ID_TIME" integer NOT NULL,
    "TIME" text
);


ALTER TABLE "TIMES" OWNER TO postgres;

--
-- Name: TIMES_ID_TIME_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "TIMES_ID_TIME_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "TIMES_ID_TIME_seq" OWNER TO postgres;

--
-- Name: TIMES_ID_TIME_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "TIMES_ID_TIME_seq" OWNED BY "TIMES"."ID_TIME";


--
-- Name: TIME_JOGADORES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "TIME_JOGADORES" (
    "ID_TIME_JOGADOR" integer NOT NULL,
    "ID_TIME" integer,
    "ID_JOGADOR" integer,
    entrada date,
    saida date
);


ALTER TABLE "TIME_JOGADORES" OWNER TO postgres;

--
-- Name: TIME_JOGADORES_ID_TIME_JOGADOR_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "TIME_JOGADORES_ID_TIME_JOGADOR_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "TIME_JOGADORES_ID_TIME_JOGADOR_seq" OWNER TO postgres;

--
-- Name: TIME_JOGADORES_ID_TIME_JOGADOR_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "TIME_JOGADORES_ID_TIME_JOGADOR_seq" OWNED BY "TIME_JOGADORES"."ID_TIME_JOGADOR";


--
-- Name: TIME_JOGADOR_POSICOES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "TIME_JOGADOR_POSICOES" (
    "ID_TIME_JOGADOR_POSICAO" integer NOT NULL,
    "ID_TIME_JOGADOR" integer,
    "ID_POSICAO" integer
);


ALTER TABLE "TIME_JOGADOR_POSICOES" OWNER TO postgres;

--
-- Name: TIME_JOGADOR_POSICOES_ID_TIME_JOGADOR_POSICAO_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "TIME_JOGADOR_POSICOES_ID_TIME_JOGADOR_POSICAO_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "TIME_JOGADOR_POSICOES_ID_TIME_JOGADOR_POSICAO_seq" OWNER TO postgres;

--
-- Name: TIME_JOGADOR_POSICOES_ID_TIME_JOGADOR_POSICAO_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "TIME_JOGADOR_POSICOES_ID_TIME_JOGADOR_POSICAO_seq" OWNED BY "TIME_JOGADOR_POSICOES"."ID_TIME_JOGADOR_POSICAO";


--
-- Name: ID_FEED; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "FEED" ALTER COLUMN "ID_FEED" SET DEFAULT nextval('"FEED_ID_FEED_seq"'::regclass);


--
-- Name: ID_JOGADOR; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "JOGADOR" ALTER COLUMN "ID_JOGADOR" SET DEFAULT nextval('"JOGADOR_ID_JOGADOR_seq"'::regclass);


--
-- Name: ID_POSICAO_JOGADOR; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "JOGADOR_POSICOES" ALTER COLUMN "ID_POSICAO_JOGADOR" SET DEFAULT nextval('"JOGADOR_POSICOES_ID_POSICAO_JOGADOR_seq"'::regclass);


--
-- Name: ID_POSICAO; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "POSICOES" ALTER COLUMN "ID_POSICAO" SET DEFAULT nextval('"POSICOES_ID_POSICAO_seq"'::regclass);


--
-- Name: ID_TIME; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "TIMES" ALTER COLUMN "ID_TIME" SET DEFAULT nextval('"TIMES_ID_TIME_seq"'::regclass);


--
-- Name: ID_TIME_JOGADOR; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "TIME_JOGADORES" ALTER COLUMN "ID_TIME_JOGADOR" SET DEFAULT nextval('"TIME_JOGADORES_ID_TIME_JOGADOR_seq"'::regclass);


--
-- Name: ID_TIME_JOGADOR_POSICAO; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "TIME_JOGADOR_POSICOES" ALTER COLUMN "ID_TIME_JOGADOR_POSICAO" SET DEFAULT nextval('"TIME_JOGADOR_POSICOES_ID_TIME_JOGADOR_POSICAO_seq"'::regclass);


--
-- Data for Name: FEED; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "FEED" ("ID_FEED", "ID_JOGADOR", "NEW", "PUBLICADO") FROM stdin;
14	2	TESTE DE PUBLICACAO	2015-12-16 19:27:31.81161
\.


--
-- Name: FEED_ID_FEED_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"FEED_ID_FEED_seq"', 14, true);


--
-- Data for Name: JOGADOR; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "JOGADOR" ("ID_JOGADOR", "NOME", "EMAIL", "SENHA", "NUM", "PESO", "ALTURA", "FOTOJOGADOR") FROM stdin;
2	Bruno Siqueira	babirondo@gmail.com	senha	13	99	1,78	/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB\nAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEB\nAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCADAAMADASIA\nAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA\nAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3\nODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm\np6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA\nAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx\nBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK\nU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3\nuLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9BrN2\n8hG3Dt6/89JPfIGOvJ6g4yDn0rwl4qvtOV41mIhfbhHzzy3vnPB47HOSQefMLNsxMx7bfxxI/wDh\n/wDXJJz0mmkbH99v6tLj/wBBP+evylP/AHep6wPWrfF/27/7ce4p4jS/Qs7YkkQfJ9S/fnH3VPUj\n5jyCMmS2mOW+bPT+ZHfjt+hwcj5vMbSRiG2HlMc4Hq+OD146d8Zyc4FdTYXr87znpn1PL5OOnbj1\nGO6kV3c1O3s+luz7+m/Xv1vcz9tLl+L3dvhXf0vv179bnf2l8FheNn/u+v8Aek9vp26EcHu2KTfn\nP4frj88fUcgg4JPKx3bSM/l/7I9O7fjg46deD1JNaVu0jhGaRh05TPYt755yO+eowck1dP4f6/mq\n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\n3Z9P657deaAP/9k=\n
\.


--
-- Name: JOGADOR_ID_JOGADOR_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"JOGADOR_ID_JOGADOR_seq"', 2, true);


--
-- Data for Name: JOGADOR_POSICOES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "JOGADOR_POSICOES" ("ID_JOGADOR", "ID_POSICAO_JOGADOR", "ID_POSICAO") FROM stdin;
2	105	2
2	107	6
2	131	4
\.


--
-- Name: JOGADOR_POSICOES_ID_POSICAO_JOGADOR_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"JOGADOR_POSICOES_ID_POSICAO_JOGADOR_seq"', 131, true);


--
-- Data for Name: POSICOES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "POSICOES" ("ID_POSICAO", "POSICAO") FROM stdin;
1	SNAKE
2	SNAKE CORNER
3	BACK CENTER
4	DORITOS
5	DORITOS CORNER
6	COACH
\.


--
-- Name: POSICOES_ID_POSICAO_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"POSICOES_ID_POSICAO_seq"', 6, true);


--
-- Data for Name: TIMES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "TIMES" ("ID_TIME", "TIME") FROM stdin;
3	Mega Play Paintball Team
\.


--
-- Name: TIMES_ID_TIME_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"TIMES_ID_TIME_seq"', 3, true);


--
-- Data for Name: TIME_JOGADORES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "TIME_JOGADORES" ("ID_TIME_JOGADOR", "ID_TIME", "ID_JOGADOR", entrada, saida) FROM stdin;
9	3	2	2015-12-13	\N
\.


--
-- Name: TIME_JOGADORES_ID_TIME_JOGADOR_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"TIME_JOGADORES_ID_TIME_JOGADOR_seq"', 9, true);


--
-- Data for Name: TIME_JOGADOR_POSICOES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "TIME_JOGADOR_POSICOES" ("ID_TIME_JOGADOR_POSICAO", "ID_TIME_JOGADOR", "ID_POSICAO") FROM stdin;
59	9	1
61	9	3
62	9	4
63	9	5
64	9	2
\.


--
-- Name: TIME_JOGADOR_POSICOES_ID_TIME_JOGADOR_POSICAO_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"TIME_JOGADOR_POSICOES_ID_TIME_JOGADOR_POSICAO_seq"', 64, true);


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

