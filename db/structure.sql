--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: academic_group_schedules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE academic_group_schedules (
    id integer NOT NULL,
    academic_group_id integer,
    class_schedule_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: academic_group_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE academic_group_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: academic_group_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE academic_group_schedules_id_seq OWNED BY academic_group_schedules.id;


--
-- Name: academic_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE academic_groups (
    id integer NOT NULL,
    title character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    group_description character varying,
    establ_date date,
    message_ru text,
    message_uk text,
    praepostor_id integer,
    curator_id integer,
    administrator_id integer,
    graduated_at timestamp without time zone
);


--
-- Name: academic_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE academic_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: academic_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE academic_groups_id_seq OWNED BY academic_groups.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE answers (
    id integer NOT NULL,
    question_id integer,
    person_id integer,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE answers_id_seq OWNED BY answers.id;


--
-- Name: attendances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE attendances (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    class_schedule_id integer,
    student_profile_id integer,
    presence boolean
);


--
-- Name: attendances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attendances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attendances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attendances_id_seq OWNED BY attendances.id;


--
-- Name: certificate_templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE certificate_templates (
    id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    background_height integer DEFAULT 0 NOT NULL,
    background_width integer DEFAULT 0 NOT NULL,
    background character varying,
    title character varying,
    fields jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: certificate_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE certificate_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificate_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE certificate_templates_id_seq OWNED BY certificate_templates.id;


--
-- Name: class_schedules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE class_schedules (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    course_id integer,
    teacher_profile_id integer,
    classroom_id integer,
    start_time timestamp without time zone,
    finish_time timestamp without time zone,
    subject character varying
);


--
-- Name: class_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE class_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: class_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE class_schedules_id_seq OWNED BY class_schedules.id;


--
-- Name: group_participations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE group_participations (
    id integer NOT NULL,
    student_profile_id integer,
    academic_group_id integer,
    join_date timestamp without time zone,
    leave_date timestamp without time zone
);


--
-- Name: people; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    middle_name character varying,
    surname character varying,
    spiritual_name character varying,
    email character varying,
    gender boolean,
    birthday date,
    emergency_contact character varying,
    photo character varying,
    profile_fullness boolean,
    encrypted_password character varying,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    deleted boolean DEFAULT false,
    passport character varying,
    education text,
    work text,
    marital_status character varying,
    friends_to_be_with character varying,
    special_note text,
    complex_name character varying,
    provider character varying DEFAULT 'email'::character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    tokens jsonb DEFAULT '{}'::jsonb NOT NULL,
    locale character varying(2) DEFAULT 'uk'::character varying
);


--
-- Name: student_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE student_profiles (
    id integer NOT NULL,
    person_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: teacher_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teacher_profiles (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description character varying,
    person_id integer
);


--
-- Name: class_schedules_with_people; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW class_schedules_with_people AS
 SELECT cs.id,
    cs.course_id,
    cs.teacher_profile_id,
    cs.classroom_id,
    cs.start_time,
    cs.finish_time,
    cs.subject,
    ( SELECT tp.person_id
           FROM teacher_profiles tp
          WHERE (tp.id = cs.teacher_profile_id)) AS teacher_id,
    ARRAY( SELECT DISTINCT p.id
           FROM ((((people p
             JOIN student_profiles sp ON ((sp.person_id = p.id)))
             JOIN group_participations gp ON ((gp.student_profile_id = sp.id)))
             JOIN academic_groups ag ON ((ag.id = gp.academic_group_id)))
             JOIN academic_group_schedules ags ON ((ags.academic_group_id = ag.id)))
          WHERE (((ags.class_schedule_id = cs.id) AND (gp.leave_date IS NULL)) AND (ag.graduated_at IS NULL))) AS people_ids
   FROM class_schedules cs
  WHERE (cs.finish_time > now())
  ORDER BY cs.start_time, cs.finish_time
  WITH NO DATA;


--
-- Name: classrooms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE classrooms (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location character varying,
    description character varying,
    roominess integer DEFAULT 0,
    title character varying
);


--
-- Name: classrooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE classrooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classrooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE classrooms_id_seq OWNED BY classrooms.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE courses (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying,
    description character varying
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: group_participations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_participations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_participations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_participations_id_seq OWNED BY group_participations.id;


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_id_seq OWNED BY people.id;


--
-- Name: people_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people_roles (
    id integer NOT NULL,
    person_id integer,
    role_id integer
);


--
-- Name: people_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_roles_id_seq OWNED BY people_roles.id;


--
-- Name: programs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE programs (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title_uk character varying,
    title_ru character varying,
    description_uk text,
    description_ru text,
    courses_uk text,
    courses_ru text,
    visible boolean DEFAULT false
);


--
-- Name: programs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE programs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE programs_id_seq OWNED BY programs.id;


--
-- Name: programs_questionnaires; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE programs_questionnaires (
    questionnaire_id integer,
    program_id integer
);


--
-- Name: questionnaire_completenesses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questionnaire_completenesses (
    id integer NOT NULL,
    questionnaire_id integer,
    person_id integer,
    completed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    result text
);


--
-- Name: questionnaire_completenesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questionnaire_completenesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questionnaire_completenesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questionnaire_completenesses_id_seq OWNED BY questionnaire_completenesses.id;


--
-- Name: questionnaires; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questionnaires (
    id integer NOT NULL,
    description_uk text,
    title_uk character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title_ru character varying,
    description_ru text,
    kind character varying,
    rule text
);


--
-- Name: questionnaires_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questionnaires_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questionnaires_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questionnaires_id_seq OWNED BY questionnaires.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    questionnaire_id integer,
    format character varying,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "position" integer
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    activities character varying[] DEFAULT '{}'::character varying[],
    name character varying(30),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: student_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_profiles_id_seq OWNED BY student_profiles.id;


--
-- Name: study_applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE study_applications (
    id integer NOT NULL,
    person_id integer,
    program_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: study_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE study_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: study_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE study_applications_id_seq OWNED BY study_applications.id;


--
-- Name: teacher_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teacher_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teacher_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teacher_profiles_id_seq OWNED BY teacher_profiles.id;


--
-- Name: teacher_specialities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teacher_specialities (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    teacher_profile_id integer,
    course_id integer,
    since date
);


--
-- Name: teacher_specialities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teacher_specialities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teacher_specialities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teacher_specialities_id_seq OWNED BY teacher_specialities.id;


--
-- Name: telephones; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE telephones (
    id integer NOT NULL,
    person_id integer,
    phone character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: telephones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE telephones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: telephones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE telephones_id_seq OWNED BY telephones.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY academic_group_schedules ALTER COLUMN id SET DEFAULT nextval('academic_group_schedules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY academic_groups ALTER COLUMN id SET DEFAULT nextval('academic_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY answers ALTER COLUMN id SET DEFAULT nextval('answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attendances ALTER COLUMN id SET DEFAULT nextval('attendances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY certificate_templates ALTER COLUMN id SET DEFAULT nextval('certificate_templates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY class_schedules ALTER COLUMN id SET DEFAULT nextval('class_schedules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY classrooms ALTER COLUMN id SET DEFAULT nextval('classrooms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_participations ALTER COLUMN id SET DEFAULT nextval('group_participations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people ALTER COLUMN id SET DEFAULT nextval('people_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people_roles ALTER COLUMN id SET DEFAULT nextval('people_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY programs ALTER COLUMN id SET DEFAULT nextval('programs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questionnaire_completenesses ALTER COLUMN id SET DEFAULT nextval('questionnaire_completenesses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questionnaires ALTER COLUMN id SET DEFAULT nextval('questionnaires_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_profiles ALTER COLUMN id SET DEFAULT nextval('student_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY study_applications ALTER COLUMN id SET DEFAULT nextval('study_applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teacher_profiles ALTER COLUMN id SET DEFAULT nextval('teacher_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teacher_specialities ALTER COLUMN id SET DEFAULT nextval('teacher_specialities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY telephones ALTER COLUMN id SET DEFAULT nextval('telephones_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: academic_group_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY academic_group_schedules
    ADD CONSTRAINT academic_group_schedules_pkey PRIMARY KEY (id);


--
-- Name: academic_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY academic_groups
    ADD CONSTRAINT academic_groups_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);


--
-- Name: certificate_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY certificate_templates
    ADD CONSTRAINT certificate_templates_pkey PRIMARY KEY (id);


--
-- Name: class_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY class_schedules
    ADD CONSTRAINT class_schedules_pkey PRIMARY KEY (id);


--
-- Name: classrooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY classrooms
    ADD CONSTRAINT classrooms_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: group_participations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY group_participations
    ADD CONSTRAINT group_participations_pkey PRIMARY KEY (id);


--
-- Name: people_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: people_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY people_roles
    ADD CONSTRAINT people_roles_pkey PRIMARY KEY (id);


--
-- Name: programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (id);


--
-- Name: questionnaire_completenesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questionnaire_completenesses
    ADD CONSTRAINT questionnaire_completenesses_pkey PRIMARY KEY (id);


--
-- Name: questionnaires_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questionnaires
    ADD CONSTRAINT questionnaires_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: student_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY student_profiles
    ADD CONSTRAINT student_profiles_pkey PRIMARY KEY (id);


--
-- Name: study_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY study_applications
    ADD CONSTRAINT study_applications_pkey PRIMARY KEY (id);


--
-- Name: teacher_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teacher_profiles
    ADD CONSTRAINT teacher_profiles_pkey PRIMARY KEY (id);


--
-- Name: teacher_specialities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teacher_specialities
    ADD CONSTRAINT teacher_specialities_pkey PRIMARY KEY (id);


--
-- Name: telephones_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY telephones
    ADD CONSTRAINT telephones_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: class_schedules_with_people_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX class_schedules_with_people_id_idx ON class_schedules_with_people USING btree (id);


--
-- Name: class_schedules_with_people_people_ids_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX class_schedules_with_people_people_ids_idx ON class_schedules_with_people USING gin (people_ids) WITH (fastupdate=off);


--
-- Name: class_schedules_with_people_teacher_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX class_schedules_with_people_teacher_id_idx ON class_schedules_with_people USING hash (teacher_id);


--
-- Name: index_certificate_templates_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_certificate_templates_on_status ON certificate_templates USING btree (status);


--
-- Name: index_people_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_people_on_email ON people USING btree (email);


--
-- Name: index_people_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_people_on_reset_password_token ON people USING btree (reset_password_token);


--
-- Name: index_people_on_uid_and_provider; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_people_on_uid_and_provider ON people USING btree (uid, provider);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20131104153415');

INSERT INTO schema_migrations (version) VALUES ('20131104155157');

INSERT INTO schema_migrations (version) VALUES ('20131106111439');

INSERT INTO schema_migrations (version) VALUES ('20131106111610');

INSERT INTO schema_migrations (version) VALUES ('20131107081926');

INSERT INTO schema_migrations (version) VALUES ('20131107082541');

INSERT INTO schema_migrations (version) VALUES ('20131107082931');

INSERT INTO schema_migrations (version) VALUES ('20131107083056');

INSERT INTO schema_migrations (version) VALUES ('20131108154327');

INSERT INTO schema_migrations (version) VALUES ('20131108154741');

INSERT INTO schema_migrations (version) VALUES ('20131108155311');

INSERT INTO schema_migrations (version) VALUES ('20131108155502');

INSERT INTO schema_migrations (version) VALUES ('20131108155847');

INSERT INTO schema_migrations (version) VALUES ('20131108160759');

INSERT INTO schema_migrations (version) VALUES ('20131108183224');

INSERT INTO schema_migrations (version) VALUES ('20131108183425');

INSERT INTO schema_migrations (version) VALUES ('20131108183524');

INSERT INTO schema_migrations (version) VALUES ('20131108183652');

INSERT INTO schema_migrations (version) VALUES ('20131108183825');

INSERT INTO schema_migrations (version) VALUES ('20131108183921');

INSERT INTO schema_migrations (version) VALUES ('20131109141935');

INSERT INTO schema_migrations (version) VALUES ('20131109142219');

INSERT INTO schema_migrations (version) VALUES ('20131109143231');

INSERT INTO schema_migrations (version) VALUES ('20131206142539');

INSERT INTO schema_migrations (version) VALUES ('20131224122713');

INSERT INTO schema_migrations (version) VALUES ('20140206161732');

INSERT INTO schema_migrations (version) VALUES ('20140211153102');

INSERT INTO schema_migrations (version) VALUES ('20140211154720');

INSERT INTO schema_migrations (version) VALUES ('20140805135413');

INSERT INTO schema_migrations (version) VALUES ('20140805150150');

INSERT INTO schema_migrations (version) VALUES ('20140807144123');

INSERT INTO schema_migrations (version) VALUES ('20140812184858');

INSERT INTO schema_migrations (version) VALUES ('20140817064104');

INSERT INTO schema_migrations (version) VALUES ('20140817070939');

INSERT INTO schema_migrations (version) VALUES ('20140819191836');

INSERT INTO schema_migrations (version) VALUES ('20140821192744');

INSERT INTO schema_migrations (version) VALUES ('20140824053737');

INSERT INTO schema_migrations (version) VALUES ('20140903122128');

INSERT INTO schema_migrations (version) VALUES ('20140903122216');

INSERT INTO schema_migrations (version) VALUES ('20140905191018');

INSERT INTO schema_migrations (version) VALUES ('20140905191211');

INSERT INTO schema_migrations (version) VALUES ('20140905191326');

INSERT INTO schema_migrations (version) VALUES ('20140906113626');

INSERT INTO schema_migrations (version) VALUES ('20140918091449');

INSERT INTO schema_migrations (version) VALUES ('20140920200640');

INSERT INTO schema_migrations (version) VALUES ('20140921162651');

INSERT INTO schema_migrations (version) VALUES ('20141001130412');

INSERT INTO schema_migrations (version) VALUES ('20141018192218');

INSERT INTO schema_migrations (version) VALUES ('20141101170505');

INSERT INTO schema_migrations (version) VALUES ('20141101170540');

INSERT INTO schema_migrations (version) VALUES ('20141102090630');

INSERT INTO schema_migrations (version) VALUES ('20141102185707');

INSERT INTO schema_migrations (version) VALUES ('20141105202042');

INSERT INTO schema_migrations (version) VALUES ('20150107152356');

INSERT INTO schema_migrations (version) VALUES ('20150107162032');

INSERT INTO schema_migrations (version) VALUES ('20150107162204');

INSERT INTO schema_migrations (version) VALUES ('20150112113434');

INSERT INTO schema_migrations (version) VALUES ('20150113111530');

INSERT INTO schema_migrations (version) VALUES ('20150118122903');

INSERT INTO schema_migrations (version) VALUES ('20150118130719');

INSERT INTO schema_migrations (version) VALUES ('20150213222112');

INSERT INTO schema_migrations (version) VALUES ('20150507103929');

INSERT INTO schema_migrations (version) VALUES ('20150519132845');

INSERT INTO schema_migrations (version) VALUES ('20150519133309');

INSERT INTO schema_migrations (version) VALUES ('20150521082032');

INSERT INTO schema_migrations (version) VALUES ('20150521082127');

INSERT INTO schema_migrations (version) VALUES ('20150524193448');

INSERT INTO schema_migrations (version) VALUES ('20150602100341');

INSERT INTO schema_migrations (version) VALUES ('20150602145846');

INSERT INTO schema_migrations (version) VALUES ('20150604104338');

INSERT INTO schema_migrations (version) VALUES ('20150614072444');

INSERT INTO schema_migrations (version) VALUES ('20150625201045');

INSERT INTO schema_migrations (version) VALUES ('20150709064042');

INSERT INTO schema_migrations (version) VALUES ('20150821112132');

INSERT INTO schema_migrations (version) VALUES ('20151102155321');

INSERT INTO schema_migrations (version) VALUES ('20160226214442');

INSERT INTO schema_migrations (version) VALUES ('20160309211822');

