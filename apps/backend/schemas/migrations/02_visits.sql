-- =========================================
-- visits table
-- =========================================
CREATE TABLE public.visits (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  transcript_id uuid NULL,
  doctor text NULL,
  title text NULL,
  status text NULL,
  specialty text NULL,
  duration text NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT visits_pkey PRIMARY KEY (id)
);

-- =========================================
-- visit_recordings table
-- =========================================
CREATE TABLE public.visit_recordings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  caregiver_id uuid NULL,
  object_key text NOT NULL,
  duration_sec integer NULL,
  size_bytes bigint NULL,
  content_type text NULL,
  recorded_at timestamptz NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz NULL,
  CONSTRAINT visit_recordings_pkey PRIMARY KEY (id),
  CONSTRAINT visit_recordings_duration_sec_check CHECK (
    duration_sec IS NULL OR duration_sec >= 0
  ),
  CONSTRAINT visit_recordings_size_bytes_check CHECK (
    size_bytes IS NULL OR size_bytes >= 0
  )
);

-- =========================================
-- visit_recordings indexes
-- =========================================
CREATE INDEX IF NOT EXISTS idx_vr_user
  ON public.visit_recordings (user_id);

CREATE INDEX IF NOT EXISTS idx_vr_caregiver
  ON public.visit_recordings (caregiver_id);

CREATE INDEX IF NOT EXISTS idx_vr_created_at
  ON public.visit_recordings (created_at DESC);

-- =========================================
-- visit_transcripts table
-- =========================================
CREATE TABLE public.visit_transcripts (
  transcript_id uuid NOT NULL DEFAULT gen_random_uuid(),
  visit_id uuid NULL,
  user_id uuid NULL,
  audio_url text NULL,
  transcript_text text NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT visit_transcripts_pkey PRIMARY KEY (transcript_id)
);

-- =========================================
-- visit_summaries table
-- =========================================
CREATE TABLE public.visit_summaries (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  visit_id uuid NULL,
  transcript_id uuid NULL,
  user_id uuid NOT NULL,
  summary text NULL,
  action_items text NULL,
  questions_next_visit text NULL,
  key_diagnoses text NULL,
  medications text NULL,
  reminders jsonb NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT visit_summaries_pkey PRIMARY KEY (id)
);
