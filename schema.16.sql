--
-- PostgreSQL database dump
--

\restrict q83eeiu8Dugn7DN8TUcLRald9FFhjZEHcdHip9bjjCBHXcCAjzDgQP5gvXgkptw

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audio_journals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audio_journals (
    aj_path text NOT NULL,
    aj_name text NOT NULL,
    aj_datetime timestamp without time zone NOT NULL,
    aj_day integer NOT NULL,
    aj_session integer NOT NULL,
    subject_id text NOT NULL,
    study_id text NOT NULL
);


--
-- Name: decrypted_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.decrypted_files (
    source_path text NOT NULL,
    destination_path text NOT NULL,
    requested_by text NOT NULL,
    decrypted boolean DEFAULT false NOT NULL,
    process_time real,
    requested_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    decrypted_at timestamp without time zone
);


--
-- Name: expected_interviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expected_interviews (
    interview_name text NOT NULL,
    subject_id text NOT NULL,
    study_id text NOT NULL,
    form_name text NOT NULL,
    event_name text NOT NULL,
    expected_interview_date timestamp without time zone NOT NULL,
    expected_interview_day integer NOT NULL,
    expected_interview_type text NOT NULL
);


--
-- Name: fau_role_validation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fau_role_validation (
    interview_name text NOT NULL,
    frv_fau_metrics jsonb,
    frv_matches_with_transcript boolean,
    frv_timestamp timestamp without time zone
);


--
-- Name: ffprobe_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ffprobe_metadata (
    fm_source_path text NOT NULL,
    fm_requested_by text NOT NULL,
    fm_format_name text,
    fm_format_long_name text,
    fm_duration text,
    fm_size text,
    fm_bit_rate text,
    fm_probe_score text,
    fm_tags text,
    fm_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: ffprobe_metadata_audio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ffprobe_metadata_audio (
    fma_source_path text NOT NULL,
    fma_requested_by text NOT NULL,
    fma_index integer NOT NULL,
    fma_codec_name character varying(255) NOT NULL,
    fma_codec_long_name character varying(255) NOT NULL,
    fma_profile character varying(255) NOT NULL,
    fma_codec_type character varying(255) NOT NULL,
    fma_codec_tag_string character varying(255) NOT NULL,
    fma_codec_tag character varying(255) NOT NULL,
    fma_sample_fmt character varying(255) NOT NULL,
    fma_sample_rate integer NOT NULL,
    fma_channels integer NOT NULL,
    fma_channel_layout character varying(255) NOT NULL,
    fma_bits_per_sample integer NOT NULL,
    fma_r_frame_rate character varying(255) NOT NULL,
    fma_avg_frame_rate character varying(255) NOT NULL,
    fma_time_base character varying(255) NOT NULL,
    fma_start_pts integer NOT NULL,
    fma_start_time character varying(255) NOT NULL,
    fma_duration character varying(255) NOT NULL,
    fma_extradata_size integer NOT NULL
);


--
-- Name: ffprobe_metadata_video; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ffprobe_metadata_video (
    fmv_source_path text NOT NULL,
    fmv_requested_by text NOT NULL,
    ir_role character varying(255),
    fmv_index integer NOT NULL,
    fmv_codec_name character varying(255) NOT NULL,
    fmv_codec_long_name character varying(255) NOT NULL,
    fmv_profile character varying(255) NOT NULL,
    fmv_codec_type character varying(255) NOT NULL,
    fmv_codec_tag_string character varying(255) NOT NULL,
    fmv_codec_tag character varying(255) NOT NULL,
    fmv_width integer NOT NULL,
    fmv_height integer NOT NULL,
    fmv_coded_width integer NOT NULL,
    fmv_coded_height integer NOT NULL,
    fmv_closed_captions integer NOT NULL,
    fmv_film_grain integer NOT NULL,
    fmv_has_b_frames integer NOT NULL,
    fmv_sample_aspect_ratio character varying(255) NOT NULL,
    fmv_display_aspect_ratio character varying(255) NOT NULL,
    fmv_pix_fmt character varying(255) NOT NULL,
    fmv_level integer NOT NULL,
    fmv_color_range character varying(255) NOT NULL,
    fmv_chrorma_location character varying(255) NOT NULL,
    fmv_field_order character varying(255) NOT NULL,
    fmv_refs integer NOT NULL,
    fmv_r_frame_rate character varying(255) NOT NULL,
    fmv_avg_frame_rate character varying(255) NOT NULL,
    fmv_time_base character varying(255) NOT NULL,
    fmv_start_pts integer NOT NULL,
    fmv_start_time character varying(255) NOT NULL,
    fmv_duration character varying(255) NOT NULL,
    fmv_extradata_size integer NOT NULL
);


--
-- Name: files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.files (
    file_name text NOT NULL,
    file_type text NOT NULL,
    file_size_mb double precision NOT NULL,
    file_path text NOT NULL,
    m_time timestamp without time zone NOT NULL,
    md5 text
);


--
-- Name: form_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.form_data (
    subject_id text NOT NULL,
    study_id text NOT NULL,
    form_name text NOT NULL,
    event_name text NOT NULL,
    form_data jsonb NOT NULL,
    source_mdata timestamp without time zone NOT NULL,
    imported_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: interview_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interview_files (
    interview_path text NOT NULL,
    interview_file text NOT NULL,
    interview_file_tags text,
    ignored boolean DEFAULT false
);


--
-- Name: interview_parts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interview_parts (
    interview_path text NOT NULL,
    interview_name text,
    interview_day integer NOT NULL,
    interview_part integer NOT NULL,
    interview_datetime timestamp without time zone NOT NULL,
    is_primary boolean DEFAULT false,
    is_duplicate boolean DEFAULT false
);


--
-- Name: interview_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interview_roles (
    ir_role text NOT NULL
);


--
-- Name: interview_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interview_types (
    interview_type text NOT NULL
);


--
-- Name: interviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interviews (
    interview_name text NOT NULL,
    interview_type text NOT NULL,
    subject_id text NOT NULL,
    study_id text NOT NULL
);


--
-- Name: key_store; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_store (
    name text NOT NULL,
    value text NOT NULL
);


--
-- Name: llm_language_identification; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.llm_language_identification (
    llm_source_transcript text NOT NULL,
    ollama_model_identifier text NOT NULL,
    llm_identified_language_code text,
    llm_confidence double precision,
    llm_metrics jsonb NOT NULL,
    llm_timestamp timestamp without time zone NOT NULL,
    llm_task_duration_s double precision NOT NULL
);


--
-- Name: llm_speaker_identification; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.llm_speaker_identification (
    llm_source_transcript text NOT NULL,
    ollama_model_identifier text NOT NULL,
    llm_role text NOT NULL,
    llm_identified_speaker_label text NOT NULL,
    llm_confidence double precision,
    llm_metrics jsonb NOT NULL,
    llm_timestamp timestamp without time zone NOT NULL,
    llm_task_duration_s double precision NOT NULL
);


--
-- Name: load_openface; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.load_openface (
    interview_name text NOT NULL,
    subject_id text NOT NULL,
    study_id text NOT NULL,
    subject_of_processed_path text,
    interviewer_of_processed_path text,
    lof_notes text,
    lof_process_time real,
    lof_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    lof_report_generation_possible boolean DEFAULT false NOT NULL
);


--
-- Name: logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.logs (
    log_id integer NOT NULL,
    log_module text NOT NULL,
    log_message text NOT NULL,
    log_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.logs_log_id_seq OWNED BY public.logs.log_id;


--
-- Name: manual_qc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manual_qc (
    qc_target_id text NOT NULL,
    qc_target_type text NOT NULL,
    qc_data jsonb NOT NULL,
    qc_user_id text NOT NULL,
    qc_timestamp timestamp without time zone NOT NULL
);


--
-- Name: openface; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.openface (
    vs_path text NOT NULL,
    ir_role text NOT NULL,
    video_path text NOT NULL,
    of_processed_path text NOT NULL,
    of_process_time real,
    of_overlay_provess_time real,
    of_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: openface_qc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.openface_qc (
    of_processed_path text NOT NULL,
    faces_count integer NOT NULL,
    frames_count integer NOT NULL,
    sucessful_frames_count integer NOT NULL,
    sucessful_frames_percentage real NOT NULL,
    successful_frames_confidence_mean real,
    successful_frames_confidence_std real,
    successful_frames_confidence_median real,
    passed boolean NOT NULL,
    ofqc_process_time real,
    ofqc_timestamp timestamp without time zone NOT NULL
);


--
-- Name: pdf_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pdf_reports (
    interview_name text NOT NULL,
    pr_version text NOT NULL,
    pr_path text NOT NULL,
    pr_generation_time real NOT NULL,
    pr_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: study; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.study (
    study_id text NOT NULL
);


--
-- Name: subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subjects (
    study_id text NOT NULL,
    subject_id text NOT NULL,
    is_active boolean NOT NULL,
    consent_date date NOT NULL,
    optional_notes json
);


--
-- Name: transcript_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transcript_files (
    transcript_file text NOT NULL,
    identifier_name text NOT NULL,
    identifier_type text NOT NULL,
    transcript_file_tags text
);


--
-- Name: video_quick_qc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.video_quick_qc (
    video_path text NOT NULL,
    has_black_bars boolean NOT NULL,
    black_bar_height integer,
    vqqc_process_time real NOT NULL,
    vqqc_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: video_streams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.video_streams (
    vs_path text NOT NULL,
    video_path text NOT NULL,
    ir_role text NOT NULL,
    vs_process_time real,
    vs_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: logs log_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logs ALTER COLUMN log_id SET DEFAULT nextval('public.logs_log_id_seq'::regclass);


--
-- Name: audio_journals audio_journals_aj_day_aj_session_subject_id_study_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audio_journals
    ADD CONSTRAINT audio_journals_aj_day_aj_session_subject_id_study_id_key UNIQUE (aj_day, aj_session, subject_id, study_id);


--
-- Name: audio_journals audio_journals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audio_journals
    ADD CONSTRAINT audio_journals_pkey PRIMARY KEY (aj_path);


--
-- Name: decrypted_files decrypted_files_destination_path_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decrypted_files
    ADD CONSTRAINT decrypted_files_destination_path_key UNIQUE (destination_path);


--
-- Name: decrypted_files decrypted_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decrypted_files
    ADD CONSTRAINT decrypted_files_pkey PRIMARY KEY (source_path);


--
-- Name: expected_interviews expected_interviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expected_interviews
    ADD CONSTRAINT expected_interviews_pkey PRIMARY KEY (interview_name);


--
-- Name: fau_role_validation fau_role_validation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fau_role_validation
    ADD CONSTRAINT fau_role_validation_pkey PRIMARY KEY (interview_name);


--
-- Name: ffprobe_metadata_audio ffprobe_metadata_audio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ffprobe_metadata_audio
    ADD CONSTRAINT ffprobe_metadata_audio_pkey PRIMARY KEY (fma_source_path);


--
-- Name: ffprobe_metadata ffprobe_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ffprobe_metadata
    ADD CONSTRAINT ffprobe_metadata_pkey PRIMARY KEY (fm_source_path);


--
-- Name: ffprobe_metadata_video ffprobe_metadata_video_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ffprobe_metadata_video
    ADD CONSTRAINT ffprobe_metadata_video_pkey PRIMARY KEY (fmv_source_path);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (file_path);


--
-- Name: form_data form_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_data
    ADD CONSTRAINT form_data_pkey PRIMARY KEY (subject_id, study_id, form_name, event_name);


--
-- Name: interview_files interview_files_interview_file_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_files
    ADD CONSTRAINT interview_files_interview_file_key UNIQUE (interview_file);


--
-- Name: interview_files interview_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_files
    ADD CONSTRAINT interview_files_pkey PRIMARY KEY (interview_path, interview_file);


--
-- Name: interview_parts interview_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_parts
    ADD CONSTRAINT interview_parts_pkey PRIMARY KEY (interview_path);


--
-- Name: interview_roles interview_roles_ir_role_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_roles
    ADD CONSTRAINT interview_roles_ir_role_key UNIQUE (ir_role);


--
-- Name: interview_types interview_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_types
    ADD CONSTRAINT interview_types_pkey PRIMARY KEY (interview_type);


--
-- Name: interviews interviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interviews
    ADD CONSTRAINT interviews_pkey PRIMARY KEY (interview_name);


--
-- Name: key_store key_store_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_store
    ADD CONSTRAINT key_store_pkey PRIMARY KEY (name);


--
-- Name: llm_language_identification llm_language_identification_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.llm_language_identification
    ADD CONSTRAINT llm_language_identification_pkey PRIMARY KEY (llm_source_transcript, ollama_model_identifier);


--
-- Name: llm_speaker_identification llm_speaker_identification_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.llm_speaker_identification
    ADD CONSTRAINT llm_speaker_identification_pkey PRIMARY KEY (llm_source_transcript, ollama_model_identifier, llm_role);


--
-- Name: load_openface load_openface_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.load_openface
    ADD CONSTRAINT load_openface_pkey PRIMARY KEY (interview_name);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (log_id);


--
-- Name: manual_qc manual_qc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manual_qc
    ADD CONSTRAINT manual_qc_pkey PRIMARY KEY (qc_target_id, qc_target_type);


--
-- Name: openface openface_of_processed_path_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openface
    ADD CONSTRAINT openface_of_processed_path_key UNIQUE (of_processed_path);


--
-- Name: openface openface_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openface
    ADD CONSTRAINT openface_pkey PRIMARY KEY (vs_path);


--
-- Name: openface_qc openface_qc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openface_qc
    ADD CONSTRAINT openface_qc_pkey PRIMARY KEY (of_processed_path);


--
-- Name: pdf_reports pdf_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pdf_reports
    ADD CONSTRAINT pdf_reports_pkey PRIMARY KEY (interview_name, pr_version);


--
-- Name: study study_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.study
    ADD CONSTRAINT study_pkey PRIMARY KEY (study_id);


--
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (study_id, subject_id);


--
-- Name: transcript_files transcript_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transcript_files
    ADD CONSTRAINT transcript_files_pkey PRIMARY KEY (transcript_file);


--
-- Name: video_quick_qc video_quick_qc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_quick_qc
    ADD CONSTRAINT video_quick_qc_pkey PRIMARY KEY (video_path);


--
-- Name: video_streams video_streams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_streams
    ADD CONSTRAINT video_streams_pkey PRIMARY KEY (vs_path);


--
-- Name: video_streams video_streams_video_path_ir_role_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_streams
    ADD CONSTRAINT video_streams_video_path_ir_role_key UNIQUE (video_path, ir_role);


--
-- Name: audio_journals audio_journals_aj_path_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audio_journals
    ADD CONSTRAINT audio_journals_aj_path_fkey FOREIGN KEY (aj_path) REFERENCES public.files(file_path);


--
-- Name: audio_journals audio_journals_subject_id_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audio_journals
    ADD CONSTRAINT audio_journals_subject_id_study_id_fkey FOREIGN KEY (subject_id, study_id) REFERENCES public.subjects(subject_id, study_id);


--
-- Name: decrypted_files decrypted_files_source_path_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decrypted_files
    ADD CONSTRAINT decrypted_files_source_path_fkey FOREIGN KEY (source_path) REFERENCES public.interview_files(interview_file);


--
-- Name: expected_interviews expected_interviews_subject_id_study_id_form_name_event_na_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expected_interviews
    ADD CONSTRAINT expected_interviews_subject_id_study_id_form_name_event_na_fkey FOREIGN KEY (subject_id, study_id, form_name, event_name) REFERENCES public.form_data(subject_id, study_id, form_name, event_name);


--
-- Name: fau_role_validation fau_role_validation_interview_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fau_role_validation
    ADD CONSTRAINT fau_role_validation_interview_name_fkey FOREIGN KEY (interview_name) REFERENCES public.load_openface(interview_name);


--
-- Name: ffprobe_metadata_audio ffprobe_metadata_audio_fma_source_path_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ffprobe_metadata_audio
    ADD CONSTRAINT ffprobe_metadata_audio_fma_source_path_fkey FOREIGN KEY (fma_source_path) REFERENCES public.ffprobe_metadata(fm_source_path);


--
-- Name: ffprobe_metadata_video ffprobe_metadata_video_fmv_source_path_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ffprobe_metadata_video
    ADD CONSTRAINT ffprobe_metadata_video_fmv_source_path_fkey FOREIGN KEY (fmv_source_path) REFERENCES public.ffprobe_metadata(fm_source_path);


--
-- Name: form_data form_data_subject_id_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_data
    ADD CONSTRAINT form_data_subject_id_study_id_fkey FOREIGN KEY (subject_id, study_id) REFERENCES public.subjects(subject_id, study_id);


--
-- Name: interview_files interview_files_interview_file_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_files
    ADD CONSTRAINT interview_files_interview_file_fkey FOREIGN KEY (interview_file) REFERENCES public.files(file_path);


--
-- Name: interview_files interview_files_interview_path_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_files
    ADD CONSTRAINT interview_files_interview_path_fkey FOREIGN KEY (interview_path) REFERENCES public.interview_parts(interview_path);


--
-- Name: interview_parts interview_parts_interview_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_parts
    ADD CONSTRAINT interview_parts_interview_name_fkey FOREIGN KEY (interview_name) REFERENCES public.interviews(interview_name);


--
-- Name: interviews interviews_interview_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interviews
    ADD CONSTRAINT interviews_interview_type_fkey FOREIGN KEY (interview_type) REFERENCES public.interview_types(interview_type);


--
-- Name: interviews interviews_subject_id_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interviews
    ADD CONSTRAINT interviews_subject_id_study_id_fkey FOREIGN KEY (subject_id, study_id) REFERENCES public.subjects(subject_id, study_id);


--
-- Name: llm_language_identification llm_language_identification_llm_source_transcript_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.llm_language_identification
    ADD CONSTRAINT llm_language_identification_llm_source_transcript_fkey FOREIGN KEY (llm_source_transcript) REFERENCES public.transcript_files(transcript_file);


--
-- Name: llm_speaker_identification llm_speaker_identification_llm_source_transcript_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.llm_speaker_identification
    ADD CONSTRAINT llm_speaker_identification_llm_source_transcript_fkey FOREIGN KEY (llm_source_transcript) REFERENCES public.transcript_files(transcript_file);


--
-- Name: load_openface load_openface_subject_id_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.load_openface
    ADD CONSTRAINT load_openface_subject_id_study_id_fkey FOREIGN KEY (subject_id, study_id) REFERENCES public.subjects(subject_id, study_id);


--
-- Name: load_openface load_openface_subject_of_processed_path_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.load_openface
    ADD CONSTRAINT load_openface_subject_of_processed_path_fkey FOREIGN KEY (subject_of_processed_path) REFERENCES public.openface(of_processed_path);


--
-- Name: openface_qc openface_qc_of_processed_path_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openface_qc
    ADD CONSTRAINT openface_qc_of_processed_path_fkey FOREIGN KEY (of_processed_path) REFERENCES public.openface(of_processed_path);


--
-- Name: openface openface_video_path_ir_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openface
    ADD CONSTRAINT openface_video_path_ir_role_fkey FOREIGN KEY (video_path, ir_role) REFERENCES public.video_streams(video_path, ir_role);


--
-- Name: openface openface_vs_path_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openface
    ADD CONSTRAINT openface_vs_path_fkey FOREIGN KEY (vs_path) REFERENCES public.video_streams(vs_path);


--
-- Name: pdf_reports pdf_reports_interview_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pdf_reports
    ADD CONSTRAINT pdf_reports_interview_name_fkey FOREIGN KEY (interview_name) REFERENCES public.load_openface(interview_name);


--
-- Name: subjects subjects_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- Name: transcript_files transcript_files_transcript_file_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transcript_files
    ADD CONSTRAINT transcript_files_transcript_file_fkey FOREIGN KEY (transcript_file) REFERENCES public.files(file_path);


--
-- Name: video_quick_qc video_quick_qc_video_path_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_quick_qc
    ADD CONSTRAINT video_quick_qc_video_path_fkey FOREIGN KEY (video_path) REFERENCES public.decrypted_files(destination_path);


--
-- Name: video_streams video_streams_ir_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_streams
    ADD CONSTRAINT video_streams_ir_role_fkey FOREIGN KEY (ir_role) REFERENCES public.interview_roles(ir_role);


--
-- Name: video_streams video_streams_video_path_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_streams
    ADD CONSTRAINT video_streams_video_path_fkey FOREIGN KEY (video_path) REFERENCES public.video_quick_qc(video_path);


--
-- PostgreSQL database dump complete
--

\unrestrict q83eeiu8Dugn7DN8TUcLRald9FFhjZEHcdHip9bjjCBHXcCAjzDgQP5gvXgkptw

