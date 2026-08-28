-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.profiles (
  id uuid NOT NULL,
  name text NOT NULL,
  age integer,
  gender text,
  height numeric,
  weight numeric,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);
CREATE TABLE public.tutorial_videos (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  video_url text NOT NULL,
  thumbnail_url text,
  muscle_group text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT tutorial_videos_pkey PRIMARY KEY (id)
);
CREATE TABLE public.machines (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  name text NOT NULL,
  image_url text,
  muscle_group text NOT NULL,
  tutorial_video_id uuid,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT machines_pkey PRIMARY KEY (id),
  CONSTRAINT machines_tutorial_video_id_fkey FOREIGN KEY (tutorial_video_id) REFERENCES public.tutorial_videos(id)
);
CREATE TABLE public.workout_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  machine_id uuid NOT NULL,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  workout_session_id uuid NOT NULL,
  CONSTRAINT workout_logs_pkey PRIMARY KEY (id),
  CONSTRAINT workout_logs_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(id),
  CONSTRAINT workout_logs_session_id_fkey FOREIGN KEY (workout_session_id) REFERENCES public.workout_sessions(id)
);
CREATE TABLE public.workout_sets (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  workout_log_id uuid NOT NULL,
  set_number integer NOT NULL,
  weight numeric NOT NULL,
  reps integer NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT workout_sets_pkey PRIMARY KEY (id),
  CONSTRAINT workout_sets_workout_log_id_fkey FOREIGN KEY (workout_log_id) REFERENCES public.workout_logs(id)
);
CREATE TABLE public.workout_sessions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  performed_at timestamp with time zone DEFAULT now(),
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT workout_sessions_pkey PRIMARY KEY (id),
  CONSTRAINT workout_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id)
);