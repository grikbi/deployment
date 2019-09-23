--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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

--
-- Name: ecosystem_backend_enum; Type: TYPE; Schema: public; Owner: coreapi
--

CREATE TYPE ecosystem_backend_enum AS ENUM (
    'none',
    'npm',
    'maven',
    'pypi',
    'rubygems',
    'scm',
    'crates',
    'nuget',
    'go'
);


ALTER TYPE ecosystem_backend_enum OWNER TO coreapi;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE alembic_version OWNER TO coreapi;

--
-- Name: analyses; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE analyses (
    id integer NOT NULL,
    access_count integer,
    started_at timestamp without time zone,
    finished_at timestamp without time zone,
    subtasks jsonb,
    release character varying(255),
    audit jsonb,
    version_id integer
);


ALTER TABLE analyses OWNER TO coreapi;

--
-- Name: analyses_id_seq; Type: SEQUENCE; Schema: public; Owner: coreapi
--

CREATE SEQUENCE analyses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE analyses_id_seq OWNER TO coreapi;

--
-- Name: analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: coreapi
--

ALTER SEQUENCE analyses_id_seq OWNED BY analyses.id;


--
-- Name: api_requests; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE api_requests (
    id character varying(64) NOT NULL,
    api_name character varying(256) NOT NULL,
    submit_time timestamp without time zone NOT NULL,
    user_email character varying(256),
    user_profile_digest character varying(128),
    origin character varying(64),
    team character varying(64),
    recommendation json,
    request_digest character varying(128)
);


ALTER TABLE api_requests OWNER TO coreapi;

--
-- Name: celery_taskmeta; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE celery_taskmeta (
    id integer NOT NULL,
    task_id character varying(155),
    status character varying(50),
    result bytea,
    date_done timestamp without time zone,
    traceback text
);


ALTER TABLE celery_taskmeta OWNER TO coreapi;

--
-- Name: celery_tasksetmeta; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE celery_tasksetmeta (
    id integer NOT NULL,
    taskset_id character varying(155),
    result bytea,
    date_done timestamp without time zone
);


ALTER TABLE celery_tasksetmeta OWNER TO coreapi;

--
-- Name: ecosystems; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE ecosystems (
    id integer NOT NULL,
    name character varying(255),
    _backend ecosystem_backend_enum,
    url character varying(255),
    fetch_url character varying(255)
);


ALTER TABLE ecosystems OWNER TO coreapi;

--
-- Name: ecosystems_id_seq; Type: SEQUENCE; Schema: public; Owner: coreapi
--

CREATE SEQUENCE ecosystems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ecosystems_id_seq OWNER TO coreapi;

--
-- Name: ecosystems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: coreapi
--

ALTER SEQUENCE ecosystems_id_seq OWNED BY ecosystems.id;


--
-- Name: export_table; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE export_table (
    id integer,
    worker character varying(255),
    analysis_id integer,
    task_result jsonb,
    external_request_id character varying(64),
    worker_id character varying(64),
    error boolean,
    ended_at timestamp without time zone,
    started_at timestamp without time zone
);


ALTER TABLE export_table OWNER TO coreapi;

--
-- Name: export_table1; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE export_table1 (
    id character varying(64),
    "submitTime" timestamp without time zone,
    "requestJson" json,
    origin character varying(64),
    result jsonb,
    team character varying(64),
    dep_snapshot jsonb
);


ALTER TABLE export_table1 OWNER TO coreapi;

--
-- Name: monitored_upstreams; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE monitored_upstreams (
    id integer NOT NULL,
    package_id integer,
    url character varying(255),
    updated_at timestamp without time zone,
    added_at timestamp without time zone NOT NULL,
    deactivated_at timestamp without time zone
);


ALTER TABLE monitored_upstreams OWNER TO coreapi;

--
-- Name: monitored_upstreams_id_seq; Type: SEQUENCE; Schema: public; Owner: coreapi
--

CREATE SEQUENCE monitored_upstreams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE monitored_upstreams_id_seq OWNER TO coreapi;

--
-- Name: monitored_upstreams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: coreapi
--

ALTER SEQUENCE monitored_upstreams_id_seq OWNED BY monitored_upstreams.id;


--
-- Name: osio_registered_repos; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE osio_registered_repos (
    git_url character varying(255) NOT NULL,
    git_sha character varying(255) NOT NULL,
    email_ids character varying(255) NOT NULL,
    last_scanned_at timestamp without time zone
);


ALTER TABLE osio_registered_repos OWNER TO coreapi;

--
-- Name: package_analyses; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE package_analyses (
    id integer NOT NULL,
    package_id integer,
    started_at timestamp without time zone,
    finished_at timestamp without time zone
);


ALTER TABLE package_analyses OWNER TO coreapi;

--
-- Name: package_analyses_id_seq; Type: SEQUENCE; Schema: public; Owner: coreapi
--

CREATE SEQUENCE package_analyses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE package_analyses_id_seq OWNER TO coreapi;

--
-- Name: package_analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: coreapi
--

ALTER SEQUENCE package_analyses_id_seq OWNED BY package_analyses.id;


--
-- Name: package_worker_results; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE package_worker_results (
    id integer NOT NULL,
    package_analysis_id integer,
    worker character varying(255),
    worker_id character varying(64),
    external_request_id character varying(64),
    task_result jsonb,
    error boolean NOT NULL,
    ended_at timestamp without time zone,
    started_at timestamp without time zone
);


ALTER TABLE package_worker_results OWNER TO coreapi;

--
-- Name: package_worker_results_id_seq; Type: SEQUENCE; Schema: public; Owner: coreapi
--

CREATE SEQUENCE package_worker_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE package_worker_results_id_seq OWNER TO coreapi;

--
-- Name: package_worker_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: coreapi
--

ALTER SEQUENCE package_worker_results_id_seq OWNED BY package_worker_results.id;


--
-- Name: packages; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE packages (
    id integer NOT NULL,
    ecosystem_id integer,
    name character varying(2048)
);


ALTER TABLE packages OWNER TO coreapi;

--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: coreapi
--

CREATE SEQUENCE packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE packages_id_seq OWNER TO coreapi;

--
-- Name: packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: coreapi
--

ALTER SEQUENCE packages_id_seq OWNED BY packages.id;


--
-- Name: recommendation_feedback; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE recommendation_feedback (
    id integer NOT NULL,
    package_name character varying(255) NOT NULL,
    recommendation_type character varying(255) NOT NULL,
    feedback_type boolean NOT NULL,
    ecosystem_id integer,
    stack_id character varying(64)
);


ALTER TABLE recommendation_feedback OWNER TO coreapi;

--
-- Name: recommendation_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: coreapi
--

CREATE SEQUENCE recommendation_feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE recommendation_feedback_id_seq OWNER TO coreapi;

--
-- Name: recommendation_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: coreapi
--

ALTER SEQUENCE recommendation_feedback_id_seq OWNED BY recommendation_feedback.id;


--
-- Name: security_vulnerabilities; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE security_vulnerabilities (
    vulnerability_id character varying(32) NOT NULL,
    cvss_score character varying(8)
);


ALTER TABLE security_vulnerabilities OWNER TO coreapi;

--
-- Name: stack_analyses_request; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE stack_analyses_request (
    id character varying(64) NOT NULL,
    "submitTime" timestamp without time zone NOT NULL,
    "requestJson" json NOT NULL,
    origin character varying(64),
    result jsonb,
    team character varying(64),
    dep_snapshot jsonb
);


ALTER TABLE stack_analyses_request OWNER TO coreapi;

--
-- Name: task_id_sequence; Type: SEQUENCE; Schema: public; Owner: coreapi
--

CREATE SEQUENCE task_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE task_id_sequence OWNER TO coreapi;

--
-- Name: taskset_id_sequence; Type: SEQUENCE; Schema: public; Owner: coreapi
--

CREATE SEQUENCE taskset_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taskset_id_sequence OWNER TO coreapi;

--
-- Name: versions; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE versions (
    id integer NOT NULL,
    package_id integer,
    identifier character varying(255),
    synced2graph boolean DEFAULT false NOT NULL,
    vulnerability_id character varying(32)
);


ALTER TABLE versions OWNER TO coreapi;

--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: coreapi
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE versions_id_seq OWNER TO coreapi;

--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: coreapi
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: worker_results; Type: TABLE; Schema: public; Owner: coreapi
--

CREATE TABLE worker_results (
    id integer NOT NULL,
    worker character varying(255),
    analysis_id integer,
    task_result jsonb,
    external_request_id character varying(64),
    worker_id character varying(64),
    error boolean DEFAULT false NOT NULL,
    ended_at timestamp without time zone,
    started_at timestamp without time zone
);


ALTER TABLE worker_results OWNER TO coreapi;

--
-- Name: worker_results_id_seq; Type: SEQUENCE; Schema: public; Owner: coreapi
--

CREATE SEQUENCE worker_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE worker_results_id_seq OWNER TO coreapi;

--
-- Name: worker_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: coreapi
--

ALTER SEQUENCE worker_results_id_seq OWNED BY worker_results.id;


--
-- Name: analyses id; Type: DEFAULT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY analyses ALTER COLUMN id SET DEFAULT nextval('analyses_id_seq'::regclass);


--
-- Name: ecosystems id; Type: DEFAULT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY ecosystems ALTER COLUMN id SET DEFAULT nextval('ecosystems_id_seq'::regclass);


--
-- Name: monitored_upstreams id; Type: DEFAULT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY monitored_upstreams ALTER COLUMN id SET DEFAULT nextval('monitored_upstreams_id_seq'::regclass);


--
-- Name: package_analyses id; Type: DEFAULT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY package_analyses ALTER COLUMN id SET DEFAULT nextval('package_analyses_id_seq'::regclass);


--
-- Name: package_worker_results id; Type: DEFAULT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY package_worker_results ALTER COLUMN id SET DEFAULT nextval('package_worker_results_id_seq'::regclass);


--
-- Name: packages id; Type: DEFAULT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY packages ALTER COLUMN id SET DEFAULT nextval('packages_id_seq'::regclass);


--
-- Name: recommendation_feedback id; Type: DEFAULT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY recommendation_feedback ALTER COLUMN id SET DEFAULT nextval('recommendation_feedback_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: worker_results id; Type: DEFAULT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY worker_results ALTER COLUMN id SET DEFAULT nextval('worker_results_id_seq'::regclass);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: analyses analyses_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY analyses
    ADD CONSTRAINT analyses_pkey PRIMARY KEY (id);


--
-- Name: api_requests api_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY api_requests
    ADD CONSTRAINT api_requests_pkey PRIMARY KEY (id);


--
-- Name: celery_taskmeta celery_taskmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_pkey PRIMARY KEY (id);


--
-- Name: celery_taskmeta celery_taskmeta_task_id_key; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_task_id_key UNIQUE (task_id);


--
-- Name: celery_tasksetmeta celery_tasksetmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_pkey PRIMARY KEY (id);


--
-- Name: celery_tasksetmeta celery_tasksetmeta_taskset_id_key; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_taskset_id_key UNIQUE (taskset_id);


--
-- Name: ecosystems ecosystems_name_key; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY ecosystems
    ADD CONSTRAINT ecosystems_name_key UNIQUE (name);


--
-- Name: ecosystems ecosystems_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY ecosystems
    ADD CONSTRAINT ecosystems_pkey PRIMARY KEY (id);


--
-- Name: packages ep_unique; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY packages
    ADD CONSTRAINT ep_unique UNIQUE (ecosystem_id, name);


--
-- Name: monitored_upstreams monitored_upstreams_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY monitored_upstreams
    ADD CONSTRAINT monitored_upstreams_pkey PRIMARY KEY (id);


--
-- Name: osio_registered_repos osio_registered_repos_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY osio_registered_repos
    ADD CONSTRAINT osio_registered_repos_pkey PRIMARY KEY (git_sha);


--
-- Name: package_analyses package_analyses_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY package_analyses
    ADD CONSTRAINT package_analyses_pkey PRIMARY KEY (id);


--
-- Name: package_worker_results package_worker_results_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY package_worker_results
    ADD CONSTRAINT package_worker_results_pkey PRIMARY KEY (id);


--
-- Name: package_worker_results package_worker_results_worker_id_key; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY package_worker_results
    ADD CONSTRAINT package_worker_results_worker_id_key UNIQUE (worker_id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: versions pv_unique; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT pv_unique UNIQUE (package_id, identifier);


--
-- Name: recommendation_feedback recommendation_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY recommendation_feedback
    ADD CONSTRAINT recommendation_feedback_pkey PRIMARY KEY (id);


--
-- Name: security_vulnerabilities security_vulnerabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY security_vulnerabilities
    ADD CONSTRAINT security_vulnerabilities_pkey PRIMARY KEY (vulnerability_id);


--
-- Name: stack_analyses_request stack_analyses_request_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY stack_analyses_request
    ADD CONSTRAINT stack_analyses_request_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: worker_results worker_results_pkey; Type: CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY worker_results
    ADD CONSTRAINT worker_results_pkey PRIMARY KEY (id);


--
-- Name: idx_wr_submit_time; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX idx_wr_submit_time ON public.stack_analyses_request USING btree ("submitTime");


--
-- Name: ix_analyses_version_id; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_analyses_version_id ON public.analyses USING btree (version_id);


--
-- Name: ix_api_requests_user_email; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_api_requests_user_email ON public.api_requests USING btree (user_email);


--
-- Name: ix_monitored_upstreams_package_id; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_monitored_upstreams_package_id ON public.monitored_upstreams USING btree (package_id);


--
-- Name: ix_package_analyses_package_id; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_package_analyses_package_id ON public.package_analyses USING btree (package_id);


--
-- Name: ix_package_worker_results_package_analysis_id; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_package_worker_results_package_analysis_id ON public.package_worker_results USING btree (package_analysis_id);


--
-- Name: ix_package_worker_results_worker; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_package_worker_results_worker ON public.package_worker_results USING btree (worker);


--
-- Name: ix_packages_name; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_packages_name ON public.packages USING btree (name);


--
-- Name: ix_versions_identifier; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_versions_identifier ON public.versions USING btree (identifier);


--
-- Name: ix_versions_synced2graph; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_versions_synced2graph ON public.versions USING btree (synced2graph);


--
-- Name: ix_worker_results_analysis_id; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_worker_results_analysis_id ON public.worker_results USING btree (analysis_id);


--
-- Name: ix_worker_results_ended_at; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_worker_results_ended_at ON public.worker_results USING btree (ended_at);


--
-- Name: ix_worker_results_external_request_id; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_worker_results_external_request_id ON public.worker_results USING btree (external_request_id);


--
-- Name: ix_worker_results_started_at; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_worker_results_started_at ON public.worker_results USING btree (started_at);


--
-- Name: ix_worker_results_worker; Type: INDEX; Schema: public; Owner: coreapi
--

CREATE INDEX ix_worker_results_worker ON public.worker_results USING btree (worker);


--
-- Name: analyses analyses_version_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY analyses
    ADD CONSTRAINT analyses_version_id_fkey FOREIGN KEY (version_id) REFERENCES versions(id);


--
-- Name: monitored_upstreams monitored_upstreams_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY monitored_upstreams
    ADD CONSTRAINT monitored_upstreams_package_id_fkey FOREIGN KEY (package_id) REFERENCES packages(id);


--
-- Name: package_analyses package_analyses_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY package_analyses
    ADD CONSTRAINT package_analyses_package_id_fkey FOREIGN KEY (package_id) REFERENCES packages(id);


--
-- Name: package_worker_results package_worker_results_package_analysis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY package_worker_results
    ADD CONSTRAINT package_worker_results_package_analysis_id_fkey FOREIGN KEY (package_analysis_id) REFERENCES package_analyses(id);


--
-- Name: packages packages_ecosystem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY packages
    ADD CONSTRAINT packages_ecosystem_id_fkey FOREIGN KEY (ecosystem_id) REFERENCES ecosystems(id);


--
-- Name: recommendation_feedback recommendation_feedback_ecosystem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY recommendation_feedback
    ADD CONSTRAINT recommendation_feedback_ecosystem_id_fkey FOREIGN KEY (ecosystem_id) REFERENCES ecosystems(id);


--
-- Name: recommendation_feedback recommendation_feedback_stack_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY recommendation_feedback
    ADD CONSTRAINT recommendation_feedback_stack_id_fkey FOREIGN KEY (stack_id) REFERENCES stack_analyses_request(id);


--
-- Name: versions versions_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_package_id_fkey FOREIGN KEY (package_id) REFERENCES packages(id);


--
-- Name: versions versions_vulnerability_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_vulnerability_id_fkey FOREIGN KEY (vulnerability_id) REFERENCES security_vulnerabilities(vulnerability_id);


--
-- Name: worker_results worker_results_analysis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: coreapi
--

ALTER TABLE ONLY worker_results
    ADD CONSTRAINT worker_results_analysis_id_fkey FOREIGN KEY (analysis_id) REFERENCES analyses(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: coreapi
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO coreapi;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

