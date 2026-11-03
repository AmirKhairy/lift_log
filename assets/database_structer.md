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

-- Public, singleton configuration used by the force-update check.
-- Enable SELECT for anon/authenticated roles, and restrict INSERT/UPDATE/DELETE
-- to administrators (or manage this row through the Supabase dashboard).
CREATE TABLE public.app_settings (
  id integer PRIMARY KEY CHECK (id = 1),
  minimum_android_version text NOT NULL,
  minimum_ios_version text NOT NULL,
  android_store_url text NOT NULL,
  ios_store_url text NOT NULL,
  -- Keys use TargetMuscle.name, for example: {"biceps": "https://..."}.
  target_muscle_image_urls jsonb NOT NULL DEFAULT '{}'::jsonb,
  updated_at timestamp with time zone DEFAULT now()
);
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read app settings"
  ON public.app_settings FOR SELECT TO anon, authenticated USING (true);

-- If app_settings already exists in Supabase, apply this migration instead:
-- ALTER TABLE public.app_settings
-- ADD COLUMN IF NOT EXISTS target_muscle_image_urls jsonb NOT NULL DEFAULT '{}'::jsonb;
-- Example after uploading the images to a public Supabase Storage bucket:
-- UPDATE public.app_settings
-- SET target_muscle_image_urls = jsonb_build_object(
--   'biceps', 'https://<project>.supabase.co/storage/v1/object/public/app-images/muscles/biceps.png',
--   'triceps', 'https://<project>.supabase.co/storage/v1/object/public/app-images/muscles/triceps.png',
--   'quadriceps', 'https://<project>.supabase.co/storage/v1/object/public/app-images/muscles/quadriceps.png'
-- )
-- WHERE id = 1;
CREATE TABLE public.tutorial_videos (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  video_url text NOT NULL,
  thumbnail_url text,
  muscle_group text NOT NULL,
  target_muscle text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT tutorial_videos_pkey PRIMARY KEY (id)
);
CREATE TABLE public.machines (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  name text NOT NULL,
  image_url text,
  muscle_group text NOT NULL,
  target_muscle text,
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
  started_at timestamp with time zone,
  ended_at timestamp with time zone,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT workout_sessions_pkey PRIMARY KEY (id),
  CONSTRAINT workout_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id)
);

-- Routines saved by a user. Apply these tables in Supabase before enabling
-- routine persistence in the app.
CREATE TABLE public.workout_routines (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.profiles(id),
  name text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT workout_routines_pkey PRIMARY KEY (id)
);
CREATE TABLE public.workout_routine_exercises (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  routine_id uuid NOT NULL REFERENCES public.workout_routines(id) ON DELETE CASCADE,
  machine_id uuid NOT NULL REFERENCES public.machines(id),
  notes text,
  CONSTRAINT workout_routine_exercises_pkey PRIMARY KEY (id)
);
CREATE TABLE public.workout_routine_sets (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  routine_exercise_id uuid NOT NULL REFERENCES public.workout_routine_exercises(id) ON DELETE CASCADE,
  set_number integer NOT NULL,
  weight numeric NOT NULL,
  reps integer NOT NULL,
  CONSTRAINT workout_routine_sets_pkey PRIMARY KEY (id)
);
