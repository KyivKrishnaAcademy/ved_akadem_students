--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.4
-- Dumped by pg_dump version 9.5.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

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
-- Name: academic_group_schedules; Type: TABLE; Schema: public; Owner: -
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
-- Name: academic_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE academic_groups (
    id integer NOT NULL,
    title character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    group_description character varying(255),
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
-- Name: academic_groups_programs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE academic_groups_programs (
    academic_group_id integer NOT NULL,
    program_id integer NOT NULL
);


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -
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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attendances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE attendances (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    class_schedule_id integer,
    student_profile_id integer,
    presence boolean,
    revision integer DEFAULT 1
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
-- Name: certificate_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE certificate_templates (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying
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
-- Name: class_schedules; Type: TABLE; Schema: public; Owner: -
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
-- Name: group_participations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE group_participations (
    id integer NOT NULL,
    student_profile_id integer,
    academic_group_id integer,
    join_date timestamp without time zone,
    leave_date timestamp without time zone
);


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE people (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    middle_name character varying(255),
    surname character varying(255),
    spiritual_name character varying(255),
    email character varying(255),
    gender boolean,
    birthday date,
    emergency_contact character varying(255),
    photo character varying(255),
    encrypted_password character varying(255),
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    education text,
    work text,
    marital_status character varying(255),
    friends_to_be_with character varying(255),
    complex_name character varying(255),
    provider character varying DEFAULT 'email'::character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    tokens jsonb DEFAULT '{}'::jsonb NOT NULL,
    locale character varying(2) DEFAULT 'uk'::character varying,
    fake_email boolean DEFAULT false,
    diksha_guru character varying,
    verified boolean DEFAULT false
);


--
-- Name: student_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE student_profiles (
    id integer NOT NULL,
    person_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: teacher_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE teacher_profiles (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description character varying(255),
    person_id integer
);


--
-- Name: class_schedules_with_people; Type: MATERIALIZED VIEW; Schema: public; Owner: -
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
          WHERE ((ags.class_schedule_id = cs.id) AND (gp.leave_date IS NULL) AND (ag.graduated_at IS NULL))) AS people_ids
   FROM class_schedules cs
  ORDER BY cs.start_time, cs.finish_time
  WITH NO DATA;


--
-- Name: classrooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE classrooms (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location character varying(255),
    description character varying(255),
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
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE courses (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying(255),
    description character varying(255),
    variant character varying
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
-- Name: courses_programs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE courses_programs (
    course_id integer NOT NULL,
    program_id integer NOT NULL
);


--
-- Name: examination_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE examination_results (
    id integer NOT NULL,
    examination_id integer,
    student_profile_id integer,
    score integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: examination_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE examination_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: examination_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE examination_results_id_seq OWNED BY examination_results.id;


--
-- Name: examinations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE examinations (
    id integer NOT NULL,
    title character varying DEFAULT ''::character varying,
    description text DEFAULT ''::text,
    passing_score integer DEFAULT 1,
    min_result integer DEFAULT 0,
    max_result integer DEFAULT 1,
    course_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: examinations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE examinations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: examinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE examinations_id_seq OWNED BY examinations.id;


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
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notes (
    id integer NOT NULL,
    person_id integer,
    date date,
    message text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


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
-- Name: people_roles; Type: TABLE; Schema: public; Owner: -
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
-- Name: programs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE programs (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title_uk character varying(255),
    title_ru character varying(255),
    description_uk text,
    description_ru text,
    courses_uk text,
    courses_ru text,
    visible boolean DEFAULT false,
    manager_id integer
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
-- Name: programs_questionnaires; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE programs_questionnaires (
    questionnaire_id integer,
    program_id integer
);


--
-- Name: questionnaire_completenesses; Type: TABLE; Schema: public; Owner: -
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
-- Name: questionnaires; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE questionnaires (
    id integer NOT NULL,
    description_uk text,
    title_uk character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title_ru character varying(255),
    description_ru text,
    kind character varying(255),
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
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE questions (
    id integer NOT NULL,
    questionnaire_id integer,
    format character varying(255),
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
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles (
    id integer NOT NULL,
    activities character varying(255)[] DEFAULT '{}'::character varying[],
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
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
-- Name: study_applications; Type: TABLE; Schema: public; Owner: -
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
-- Name: teacher_specialities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE teacher_specialities (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    teacher_profile_id integer,
    course_id integer
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
-- Name: telephones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE telephones (
    id integer NOT NULL,
    person_id integer,
    phone character varying(255),
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
-- Name: versions; Type: TABLE; Schema: public; Owner: -
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

ALTER TABLE ONLY examination_results ALTER COLUMN id SET DEFAULT nextval('examination_results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY examinations ALTER COLUMN id SET DEFAULT nextval('examinations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_participations ALTER COLUMN id SET DEFAULT nextval('group_participations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


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
-- Name: academic_group_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY academic_group_schedules
    ADD CONSTRAINT academic_group_schedules_pkey PRIMARY KEY (id);


--
-- Name: academic_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY academic_groups
    ADD CONSTRAINT academic_groups_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);


--
-- Name: certificate_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY certificate_templates
    ADD CONSTRAINT certificate_templates_pkey PRIMARY KEY (id);


--
-- Name: class_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY class_schedules
    ADD CONSTRAINT class_schedules_pkey PRIMARY KEY (id);


--
-- Name: classrooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY classrooms
    ADD CONSTRAINT classrooms_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: examination_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY examination_results
    ADD CONSTRAINT examination_results_pkey PRIMARY KEY (id);


--
-- Name: examinations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY examinations
    ADD CONSTRAINT examinations_pkey PRIMARY KEY (id);


--
-- Name: group_participations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_participations
    ADD CONSTRAINT group_participations_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: people_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY people_roles
    ADD CONSTRAINT people_roles_pkey PRIMARY KEY (id);


--
-- Name: programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (id);


--
-- Name: questionnaire_completenesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY questionnaire_completenesses
    ADD CONSTRAINT questionnaire_completenesses_pkey PRIMARY KEY (id);


--
-- Name: questionnaires_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY questionnaires
    ADD CONSTRAINT questionnaires_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: student_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_profiles
    ADD CONSTRAINT student_profiles_pkey PRIMARY KEY (id);


--
-- Name: study_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study_applications
    ADD CONSTRAINT study_applications_pkey PRIMARY KEY (id);


--
-- Name: teacher_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teacher_profiles
    ADD CONSTRAINT teacher_profiles_pkey PRIMARY KEY (id);


--
-- Name: teacher_specialities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teacher_specialities
    ADD CONSTRAINT teacher_specialities_pkey PRIMARY KEY (id);


--
-- Name: telephones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY telephones
    ADD CONSTRAINT telephones_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: class_schedules_with_people_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX class_schedules_with_people_id_idx ON class_schedules_with_people USING btree (id);


--
-- Name: class_schedules_with_people_people_ids_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX class_schedules_with_people_people_ids_idx ON class_schedules_with_people USING gin (people_ids) WITH (fastupdate=off);


--
-- Name: class_schedules_with_people_teacher_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX class_schedules_with_people_teacher_id_idx ON class_schedules_with_people USING hash (teacher_id);


--
-- Name: index_academic_groups_programs_on_group_id_and_program_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_academic_groups_programs_on_group_id_and_program_id ON academic_groups_programs USING btree (academic_group_id, program_id);


--
-- Name: index_academic_groups_programs_on_program_id_and_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_academic_groups_programs_on_program_id_and_group_id ON academic_groups_programs USING btree (program_id, academic_group_id);


--
-- Name: index_attendances_on_class_schedule_id_and_student_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_attendances_on_class_schedule_id_and_student_profile_id ON attendances USING btree (class_schedule_id, student_profile_id);


--
-- Name: index_courses_programs_on_course_id_and_program_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_programs_on_course_id_and_program_id ON courses_programs USING btree (course_id, program_id);


--
-- Name: index_courses_programs_on_program_id_and_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_programs_on_program_id_and_course_id ON courses_programs USING btree (program_id, course_id);


--
-- Name: index_examination_results_on_examination_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examination_results_on_examination_id ON examination_results USING btree (examination_id);


--
-- Name: index_examination_results_on_student_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examination_results_on_student_profile_id ON examination_results USING btree (student_profile_id);


--
-- Name: index_examinations_on_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examinations_on_course_id ON examinations USING btree (course_id);


--
-- Name: index_notes_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_person_id ON notes USING btree (person_id);


--
-- Name: index_people_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_email ON people USING btree (email);


--
-- Name: index_people_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_reset_password_token ON people USING btree (reset_password_token);


--
-- Name: index_people_on_uid_and_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_uid_and_provider ON people USING btree (uid, provider);


--
-- Name: index_study_applications_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_study_applications_on_person_id ON study_applications USING btree (person_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_4c75de44a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY examinations
    ADD CONSTRAINT fk_rails_4c75de44a7 FOREIGN KEY (course_id) REFERENCES courses(id);


--
-- Name: fk_rails_63838bf553; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY examination_results
    ADD CONSTRAINT fk_rails_63838bf553 FOREIGN KEY (examination_id) REFERENCES examinations(id);


--
-- Name: fk_rails_786b08cf9b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY examination_results
    ADD CONSTRAINT fk_rails_786b08cf9b FOREIGN KEY (student_profile_id) REFERENCES student_profiles(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20131104153415'), ('20131104155157'), ('20131106111439'), ('20131106111610'), ('20131107081926'), ('20131107082541'), ('20131107082931'), ('20131107083056'), ('20131108154327'), ('20131108154741'), ('20131108155311'), ('20131108155502'), ('20131108155847'), ('20131108160759'), ('20131108183224'), ('20131108183425'), ('20131108183524'), ('20131108183652'), ('20131108183825'), ('20131108183921'), ('20131109141935'), ('20131109142219'), ('20131109143231'), ('20131206142539'), ('20131224122713'), ('20140206161732'), ('20140211153102'), ('20140211154720'), ('20140805135413'), ('20140805150150'), ('20140807144123'), ('20140812184858'), ('20140817064104'), ('20140817070939'), ('20140819191836'), ('20140821192744'), ('20140824053737'), ('20140903122128'), ('20140903122216'), ('20140905191018'), ('20140905191211'), ('20140905191326'), ('20140906113626'), ('20140918091449'), ('20140920200640'), ('20140921162651'), ('20141001130412'), ('20141018192218'), ('20141101170505'), ('20141101170540'), ('20141102090630'), ('20141102185707'), ('20141105202042'), ('20150107152356'), ('20150107162032'), ('20150107162204'), ('20150112113434'), ('20150113111530'), ('20150118122903'), ('20150118130719'), ('20150213222112'), ('20150507103929'), ('20150519132845'), ('20150519133309'), ('20150521082032'), ('20150521082127'), ('20150524193448'), ('20150602100341'), ('20150602145846'), ('20150604104338'), ('20150614072444'), ('20150625201045'), ('20150709064042'), ('20150821112132'), ('20151102155321'), ('20160309211822'), ('20160319204426'), ('20160430185957'), ('20160611125828'), ('20160921113729'), ('20160921113902'), ('20160928042653'), ('20161204045002'), ('20170123053701'), ('20171008122007'), ('20171016033728'), ('20171016034251'), ('20171021080023'), ('20171029195342'), ('20171104053938'), ('20180803092524'), ('20180803111634'), ('20180817083213'), ('20180918034821'), ('20180920035801');


