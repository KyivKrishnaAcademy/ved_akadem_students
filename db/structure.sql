--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.25
-- Dumped by pg_dump version 9.5.25

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: academic_group_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_group_schedules (
    id integer NOT NULL,
    academic_group_id integer,
    class_schedule_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: academic_group_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.academic_group_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: academic_group_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.academic_group_schedules_id_seq OWNED BY public.academic_group_schedules.id;


--
-- Name: academic_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_groups (
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
-- Name: academic_groups_courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_groups_courses (
    academic_group_id integer NOT NULL,
    course_id integer NOT NULL
);


--
-- Name: academic_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.academic_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: academic_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.academic_groups_id_seq OWNED BY public.academic_groups.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.answers (
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

CREATE SEQUENCE public.answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.answers_id_seq OWNED BY public.answers.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attendances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendances (
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

CREATE SEQUENCE public.attendances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attendances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attendances_id_seq OWNED BY public.attendances.id;


--
-- Name: certificate_template_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificate_template_entries (
    id integer NOT NULL,
    template character varying,
    certificate_template_id integer,
    certificate_template_font_id integer,
    character_spacing double precision DEFAULT 0.5,
    x integer DEFAULT 0,
    y integer DEFAULT 0,
    font_size integer DEFAULT 16,
    align integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    color character varying DEFAULT '#000000'::character varying NOT NULL
);


--
-- Name: certificate_template_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificate_template_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificate_template_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificate_template_entries_id_seq OWNED BY public.certificate_template_entries.id;


--
-- Name: certificate_template_fonts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificate_template_fonts (
    id integer NOT NULL,
    name character varying,
    file character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: certificate_template_fonts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificate_template_fonts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificate_template_fonts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificate_template_fonts_id_seq OWNED BY public.certificate_template_fonts.id;


--
-- Name: certificate_template_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificate_template_images (
    id integer NOT NULL,
    certificate_template_id integer,
    signature_id integer,
    scale double precision DEFAULT 1.0,
    x integer DEFAULT 0,
    y integer DEFAULT 0,
    angle double precision DEFAULT 0.0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: certificate_template_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificate_template_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificate_template_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificate_template_images_id_seq OWNED BY public.certificate_template_images.id;


--
-- Name: certificate_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificate_templates (
    id integer NOT NULL,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    file character varying,
    institution_id integer,
    program_type integer DEFAULT 0,
    certificates_count integer DEFAULT 0
);


--
-- Name: certificate_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificate_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificate_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificate_templates_id_seq OWNED BY public.certificate_templates.id;


--
-- Name: certificates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificates (
    id integer NOT NULL,
    academic_group_id integer,
    certificate_template_id integer,
    student_profile_id integer,
    issued_date timestamp without time zone,
    serial_id character varying,
    final_score integer
);


--
-- Name: certificates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificates_id_seq OWNED BY public.certificates.id;


--
-- Name: class_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_schedules (
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

CREATE SEQUENCE public.class_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: class_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.class_schedules_id_seq OWNED BY public.class_schedules.id;


--
-- Name: group_participations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_participations (
    id integer NOT NULL,
    student_profile_id integer,
    academic_group_id integer,
    join_date timestamp without time zone,
    leave_date timestamp without time zone
);


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    middle_name character varying(255),
    surname character varying(255),
    email character varying(255),
    gender boolean,
    birthday date,
    photo character varying(255),
    encrypted_password character varying(255),
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    complex_name character varying(255),
    provider character varying DEFAULT 'email'::character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    tokens jsonb DEFAULT '{}'::jsonb NOT NULL,
    locale character varying(2) DEFAULT 'uk'::character varying,
    fake_email boolean DEFAULT false,
    diploma_name character varying,
    notify_schedules boolean DEFAULT true,
    spam_complain boolean DEFAULT false
);


--
-- Name: student_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_profiles (
    id integer NOT NULL,
    person_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: teacher_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teacher_profiles (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description character varying(255),
    person_id integer
);


--
-- Name: class_schedules_with_people; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.class_schedules_with_people AS
 SELECT cs.id,
    cs.course_id,
    cs.teacher_profile_id,
    cs.classroom_id,
    cs.start_time,
    cs.finish_time,
    cs.subject,
    ( SELECT tp.person_id
           FROM public.teacher_profiles tp
          WHERE (tp.id = cs.teacher_profile_id)) AS teacher_id,
    ARRAY( SELECT DISTINCT p.id
           FROM ((((public.people p
             JOIN public.student_profiles sp ON ((sp.person_id = p.id)))
             JOIN public.group_participations gp ON ((gp.student_profile_id = sp.id)))
             JOIN public.academic_groups ag ON ((ag.id = gp.academic_group_id)))
             JOIN public.academic_group_schedules ags ON ((ags.academic_group_id = ag.id)))
          WHERE ((ags.class_schedule_id = cs.id) AND (gp.leave_date IS NULL) AND (ag.graduated_at IS NULL))) AS people_ids
   FROM public.class_schedules cs
  ORDER BY cs.start_time, cs.finish_time
  WITH NO DATA;


--
-- Name: classrooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.classrooms (
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

CREATE SEQUENCE public.classrooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classrooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.classrooms_id_seq OWNED BY public.classrooms.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courses (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying(255),
    description character varying(255),
    variant character varying,
    examination_results_count integer DEFAULT 0,
    class_schedules_count integer DEFAULT 0
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;


--
-- Name: examination_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.examination_results (
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

CREATE SEQUENCE public.examination_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: examination_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.examination_results_id_seq OWNED BY public.examination_results.id;


--
-- Name: examinations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.examinations (
    id integer NOT NULL,
    title character varying DEFAULT ''::character varying,
    description text DEFAULT ''::text,
    passing_score integer DEFAULT 1,
    min_result integer DEFAULT 0,
    max_result integer DEFAULT 1,
    course_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    examination_results_count integer DEFAULT 0
);


--
-- Name: examinations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.examinations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: examinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.examinations_id_seq OWNED BY public.examinations.id;


--
-- Name: group_participations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_participations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_participations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_participations_id_seq OWNED BY public.group_participations.id;


--
-- Name: institutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.institutions (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: institutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.institutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: institutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.institutions_id_seq OWNED BY public.institutions.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
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

CREATE SEQUENCE public.notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: people_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people_roles (
    id integer NOT NULL,
    person_id integer,
    role_id integer
);


--
-- Name: people_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_roles_id_seq OWNED BY public.people_roles.id;


--
-- Name: programs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programs (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title_uk character varying(255),
    title_ru character varying(255),
    description_uk text,
    description_ru text,
    visible boolean DEFAULT false,
    manager_id integer,
    "position" integer,
    study_applications_count integer DEFAULT 0,
    questionnaires_count integer DEFAULT 0
);


--
-- Name: programs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.programs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.programs_id_seq OWNED BY public.programs.id;


--
-- Name: programs_questionnaires; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programs_questionnaires (
    questionnaire_id integer,
    program_id integer,
    id integer NOT NULL
);


--
-- Name: programs_questionnaires_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.programs_questionnaires_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: programs_questionnaires_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.programs_questionnaires_id_seq OWNED BY public.programs_questionnaires.id;


--
-- Name: questionnaire_completenesses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questionnaire_completenesses (
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

CREATE SEQUENCE public.questionnaire_completenesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questionnaire_completenesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questionnaire_completenesses_id_seq OWNED BY public.questionnaire_completenesses.id;


--
-- Name: questionnaires; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questionnaires (
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

CREATE SEQUENCE public.questionnaires_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questionnaires_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questionnaires_id_seq OWNED BY public.questionnaires.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
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

CREATE SEQUENCE public.questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    activities character varying(255)[] DEFAULT '{}'::character varying[],
    name character varying(30),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: signatures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.signatures (
    id integer NOT NULL,
    name character varying,
    file character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: signatures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.signatures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: signatures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.signatures_id_seq OWNED BY public.signatures.id;


--
-- Name: student_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.student_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.student_profiles_id_seq OWNED BY public.student_profiles.id;


--
-- Name: study_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.study_applications (
    id integer NOT NULL,
    person_id integer,
    program_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: study_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.study_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: study_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.study_applications_id_seq OWNED BY public.study_applications.id;


--
-- Name: teacher_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teacher_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teacher_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teacher_profiles_id_seq OWNED BY public.teacher_profiles.id;


--
-- Name: teacher_specialities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teacher_specialities (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    teacher_profile_id integer,
    course_id integer
);


--
-- Name: teacher_specialities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teacher_specialities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teacher_specialities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teacher_specialities_id_seq OWNED BY public.teacher_specialities.id;


--
-- Name: telephones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.telephones (
    id integer NOT NULL,
    person_id integer,
    phone character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: telephones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.telephones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: telephones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.telephones_id_seq OWNED BY public.telephones.id;


--
-- Name: unsubscribes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unsubscribes (
    id integer NOT NULL,
    email character varying,
    code character varying,
    kind character varying,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: unsubscribes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.unsubscribes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: unsubscribes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.unsubscribes_id_seq OWNED BY public.unsubscribes.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
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

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_group_schedules ALTER COLUMN id SET DEFAULT nextval('public.academic_group_schedules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_groups ALTER COLUMN id SET DEFAULT nextval('public.academic_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers ALTER COLUMN id SET DEFAULT nextval('public.answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendances ALTER COLUMN id SET DEFAULT nextval('public.attendances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_template_entries ALTER COLUMN id SET DEFAULT nextval('public.certificate_template_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_template_fonts ALTER COLUMN id SET DEFAULT nextval('public.certificate_template_fonts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_template_images ALTER COLUMN id SET DEFAULT nextval('public.certificate_template_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_templates ALTER COLUMN id SET DEFAULT nextval('public.certificate_templates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates ALTER COLUMN id SET DEFAULT nextval('public.certificates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_schedules ALTER COLUMN id SET DEFAULT nextval('public.class_schedules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classrooms ALTER COLUMN id SET DEFAULT nextval('public.classrooms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_results ALTER COLUMN id SET DEFAULT nextval('public.examination_results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examinations ALTER COLUMN id SET DEFAULT nextval('public.examinations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_participations ALTER COLUMN id SET DEFAULT nextval('public.group_participations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.institutions ALTER COLUMN id SET DEFAULT nextval('public.institutions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people_roles ALTER COLUMN id SET DEFAULT nextval('public.people_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs ALTER COLUMN id SET DEFAULT nextval('public.programs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs_questionnaires ALTER COLUMN id SET DEFAULT nextval('public.programs_questionnaires_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questionnaire_completenesses ALTER COLUMN id SET DEFAULT nextval('public.questionnaire_completenesses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questionnaires ALTER COLUMN id SET DEFAULT nextval('public.questionnaires_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signatures ALTER COLUMN id SET DEFAULT nextval('public.signatures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_profiles ALTER COLUMN id SET DEFAULT nextval('public.student_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.study_applications ALTER COLUMN id SET DEFAULT nextval('public.study_applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teacher_profiles ALTER COLUMN id SET DEFAULT nextval('public.teacher_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teacher_specialities ALTER COLUMN id SET DEFAULT nextval('public.teacher_specialities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telephones ALTER COLUMN id SET DEFAULT nextval('public.telephones_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unsubscribes ALTER COLUMN id SET DEFAULT nextval('public.unsubscribes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: academic_group_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_group_schedules
    ADD CONSTRAINT academic_group_schedules_pkey PRIMARY KEY (id);


--
-- Name: academic_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_groups
    ADD CONSTRAINT academic_groups_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);


--
-- Name: certificate_template_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_template_entries
    ADD CONSTRAINT certificate_template_entries_pkey PRIMARY KEY (id);


--
-- Name: certificate_template_fonts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_template_fonts
    ADD CONSTRAINT certificate_template_fonts_pkey PRIMARY KEY (id);


--
-- Name: certificate_template_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_template_images
    ADD CONSTRAINT certificate_template_images_pkey PRIMARY KEY (id);


--
-- Name: certificate_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_templates
    ADD CONSTRAINT certificate_templates_pkey PRIMARY KEY (id);


--
-- Name: certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);


--
-- Name: class_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_schedules
    ADD CONSTRAINT class_schedules_pkey PRIMARY KEY (id);


--
-- Name: classrooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classrooms
    ADD CONSTRAINT classrooms_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: examination_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_results
    ADD CONSTRAINT examination_results_pkey PRIMARY KEY (id);


--
-- Name: examinations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examinations
    ADD CONSTRAINT examinations_pkey PRIMARY KEY (id);


--
-- Name: group_participations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_participations
    ADD CONSTRAINT group_participations_pkey PRIMARY KEY (id);


--
-- Name: institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.institutions
    ADD CONSTRAINT institutions_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: people_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people_roles
    ADD CONSTRAINT people_roles_pkey PRIMARY KEY (id);


--
-- Name: programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (id);


--
-- Name: programs_questionnaires_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs_questionnaires
    ADD CONSTRAINT programs_questionnaires_pkey PRIMARY KEY (id);


--
-- Name: questionnaire_completenesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questionnaire_completenesses
    ADD CONSTRAINT questionnaire_completenesses_pkey PRIMARY KEY (id);


--
-- Name: questionnaires_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questionnaires
    ADD CONSTRAINT questionnaires_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: signatures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signatures
    ADD CONSTRAINT signatures_pkey PRIMARY KEY (id);


--
-- Name: student_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_pkey PRIMARY KEY (id);


--
-- Name: study_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.study_applications
    ADD CONSTRAINT study_applications_pkey PRIMARY KEY (id);


--
-- Name: teacher_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teacher_profiles
    ADD CONSTRAINT teacher_profiles_pkey PRIMARY KEY (id);


--
-- Name: teacher_specialities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teacher_specialities
    ADD CONSTRAINT teacher_specialities_pkey PRIMARY KEY (id);


--
-- Name: telephones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telephones
    ADD CONSTRAINT telephones_pkey PRIMARY KEY (id);


--
-- Name: unsubscribes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unsubscribes
    ADD CONSTRAINT unsubscribes_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: class_schedules_with_people_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX class_schedules_with_people_id_idx ON public.class_schedules_with_people USING btree (id);


--
-- Name: class_schedules_with_people_people_ids_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX class_schedules_with_people_people_ids_idx ON public.class_schedules_with_people USING gin (people_ids) WITH (fastupdate=off);


--
-- Name: class_schedules_with_people_teacher_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX class_schedules_with_people_teacher_id_idx ON public.class_schedules_with_people USING hash (teacher_id);


--
-- Name: index_academic_groups_courses_on_course_id_and_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_academic_groups_courses_on_course_id_and_group_id ON public.academic_groups_courses USING btree (course_id, academic_group_id);


--
-- Name: index_academic_groups_courses_on_group_id_and_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_academic_groups_courses_on_group_id_and_course_id ON public.academic_groups_courses USING btree (academic_group_id, course_id);


--
-- Name: index_attendances_on_class_schedule_id_and_student_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_attendances_on_class_schedule_id_and_student_profile_id ON public.attendances USING btree (class_schedule_id, student_profile_id);


--
-- Name: index_certificate_template_entries_on_font_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificate_template_entries_on_font_id ON public.certificate_template_entries USING btree (certificate_template_font_id);


--
-- Name: index_certificate_template_entries_on_template_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificate_template_entries_on_template_id ON public.certificate_template_entries USING btree (certificate_template_id);


--
-- Name: index_certificate_template_fonts_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_certificate_template_fonts_on_name ON public.certificate_template_fonts USING btree (name);


--
-- Name: index_certificate_template_images_on_certificate_template_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificate_template_images_on_certificate_template_id ON public.certificate_template_images USING btree (certificate_template_id);


--
-- Name: index_certificate_template_images_on_signature_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificate_template_images_on_signature_id ON public.certificate_template_images USING btree (signature_id);


--
-- Name: index_certificate_templates_on_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificate_templates_on_institution_id ON public.certificate_templates USING btree (institution_id);


--
-- Name: index_certificates_on_academic_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificates_on_academic_group_id ON public.certificates USING btree (academic_group_id);


--
-- Name: index_certificates_on_certificate_template_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificates_on_certificate_template_id ON public.certificates USING btree (certificate_template_id);


--
-- Name: index_certificates_on_serial_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_certificates_on_serial_id ON public.certificates USING btree (serial_id);


--
-- Name: index_certificates_on_student_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_certificates_on_student_profile_id ON public.certificates USING btree (student_profile_id);


--
-- Name: index_examination_results_on_examination_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examination_results_on_examination_id ON public.examination_results USING btree (examination_id);


--
-- Name: index_examination_results_on_student_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examination_results_on_student_profile_id ON public.examination_results USING btree (student_profile_id);


--
-- Name: index_examinations_on_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examinations_on_course_id ON public.examinations USING btree (course_id);


--
-- Name: index_notes_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_person_id ON public.notes USING btree (person_id);


--
-- Name: index_people_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_email ON public.people USING btree (email);


--
-- Name: index_people_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_reset_password_token ON public.people USING btree (reset_password_token);


--
-- Name: index_people_on_uid_and_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_uid_and_provider ON public.people USING btree (uid, provider);


--
-- Name: index_programs_questionnaires_on_p_and_q; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_programs_questionnaires_on_p_and_q ON public.programs_questionnaires USING btree (program_id, questionnaire_id);


--
-- Name: index_signatures_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_signatures_on_name ON public.signatures USING btree (name);


--
-- Name: index_study_applications_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_study_applications_on_person_id ON public.study_applications USING btree (person_id);


--
-- Name: index_unsubscribes_on_email_and_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unsubscribes_on_email_and_code ON public.unsubscribes USING btree (email, code);


--
-- Name: index_unsubscribes_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_unsubscribes_on_person_id ON public.unsubscribes USING btree (person_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: fk_rails_0cd77a9a00; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_template_images
    ADD CONSTRAINT fk_rails_0cd77a9a00 FOREIGN KEY (certificate_template_id) REFERENCES public.certificate_templates(id);


--
-- Name: fk_rails_301a89d734; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT fk_rails_301a89d734 FOREIGN KEY (certificate_template_id) REFERENCES public.certificate_templates(id);


--
-- Name: fk_rails_45ed5e20c4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT fk_rails_45ed5e20c4 FOREIGN KEY (academic_group_id) REFERENCES public.academic_groups(id);


--
-- Name: fk_rails_4c75de44a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examinations
    ADD CONSTRAINT fk_rails_4c75de44a7 FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: fk_rails_63838bf553; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_results
    ADD CONSTRAINT fk_rails_63838bf553 FOREIGN KEY (examination_id) REFERENCES public.examinations(id);


--
-- Name: fk_rails_672a123b82; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT fk_rails_672a123b82 FOREIGN KEY (student_profile_id) REFERENCES public.student_profiles(id);


--
-- Name: fk_rails_786b08cf9b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_results
    ADD CONSTRAINT fk_rails_786b08cf9b FOREIGN KEY (student_profile_id) REFERENCES public.student_profiles(id);


--
-- Name: fk_rails_a476c2c1a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_template_images
    ADD CONSTRAINT fk_rails_a476c2c1a6 FOREIGN KEY (signature_id) REFERENCES public.signatures(id);


--
-- Name: fk_rails_ba00c048b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_template_entries
    ADD CONSTRAINT fk_rails_ba00c048b6 FOREIGN KEY (certificate_template_id) REFERENCES public.certificate_templates(id);


--
-- Name: fk_rails_eb310ca5a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificate_template_entries
    ADD CONSTRAINT fk_rails_eb310ca5a3 FOREIGN KEY (certificate_template_font_id) REFERENCES public.certificate_template_fonts(id);


--
-- Name: fk_rails_fb18d345ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unsubscribes
    ADD CONSTRAINT fk_rails_fb18d345ca FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20131104153415'),
('20131104155157'),
('20131106111439'),
('20131106111610'),
('20131107081926'),
('20131107082541'),
('20131107082931'),
('20131107083056'),
('20131108154327'),
('20131108154741'),
('20131108155311'),
('20131108155502'),
('20131108155847'),
('20131108160759'),
('20131108183224'),
('20131108183425'),
('20131108183524'),
('20131108183652'),
('20131108183825'),
('20131108183921'),
('20131109141935'),
('20131109142219'),
('20131109143231'),
('20131206142539'),
('20131224122713'),
('20140206161732'),
('20140211153102'),
('20140211154720'),
('20140805135413'),
('20140805150150'),
('20140807144123'),
('20140812184858'),
('20140817064104'),
('20140817070939'),
('20140819191836'),
('20140821192744'),
('20140824053737'),
('20140903122128'),
('20140903122216'),
('20140905191018'),
('20140905191211'),
('20140905191326'),
('20140906113626'),
('20140918091449'),
('20140920200640'),
('20140921162651'),
('20141001130412'),
('20141018192218'),
('20141101170505'),
('20141101170540'),
('20141102090630'),
('20141102185707'),
('20141105202042'),
('20150107152356'),
('20150107162032'),
('20150107162204'),
('20150112113434'),
('20150113111530'),
('20150118122903'),
('20150118130719'),
('20150213222112'),
('20150507103929'),
('20150519132845'),
('20150519133309'),
('20150521082032'),
('20150521082127'),
('20150524193448'),
('20150602100341'),
('20150602145846'),
('20150604104338'),
('20150614072444'),
('20150625201045'),
('20150709064042'),
('20150821112132'),
('20151102155321'),
('20160309211822'),
('20160319204426'),
('20160430185957'),
('20160611125828'),
('20160921113729'),
('20160921113902'),
('20160928042653'),
('20161204045002'),
('20170123053701'),
('20171008122007'),
('20171016033728'),
('20171016034251'),
('20171021080023'),
('20171029195342'),
('20171104053938'),
('20180803092524'),
('20180803111634'),
('20180817083213'),
('20180918034821'),
('20180920035801'),
('20180920193530'),
('20180922042307'),
('20181003033911'),
('20181006060751'),
('20181007124205'),
('20200124060236'),
('20201214174233'),
('20211204081027'),
('20220212194355'),
('20220701055504'),
('20220702070531'),
('20220705194303'),
('20220717060619'),
('20220717061020'),
('20220717072150'),
('20220903054050'),
('20230222180223'),
('20230225063808'),
('20230226200547'),
('20230226201309'),
('20230305211926'),
('20230306054610'),
('20231225134459'),
('20231225144737'),
('20231231091716'),
('20241126112155'),
('20241219135735');


