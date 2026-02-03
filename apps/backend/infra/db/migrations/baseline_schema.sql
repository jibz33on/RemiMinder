-- =========================================
-- Clean baseline schema for new product
-- =========================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "citext";

-- Drop legacy and existing tables (clean reset)
DROP TABLE IF EXISTS
  audit_log,
  best_examples,
  caregivers,
  caregiver_alerts,
  care_team_invitations,
  care_team_members,
  doctors,
  feedback_log,
  invitations,
  jobs,
  patient_caregiver,
  patient_tasks,
  prompt_bank,
  reminder_logs,
  reminder_templates,
  reminders,
  summaries_log,
  users,
  visit_recordings,
  visit_summaries,
  visit_transcripts,
  visits
CASCADE;

-- Helper function: auto-update updated_at
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================================
-- users
-- =========================================
CREATE TABLE public.users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  external_auth_id text NOT NULL UNIQUE,
  auth_provider text NOT NULL DEFAULT 'unknown',
  email citext NOT NULL UNIQUE,
  full_name text,
  role text,
  is_active boolean NOT NULL DEFAULT true,
  app_language varchar(10) NOT NULL DEFAULT 'en',
  visit_language varchar(10) NOT NULL DEFAULT 'en',
  phone text,
  country text,
  timezone text,
  active_context text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT users_role_check CHECK (role IN ('patient', 'caregiver', 'admin'))
);

CREATE INDEX IF NOT EXISTS idx_users_email
  ON public.users (email);
CREATE INDEX IF NOT EXISTS idx_users_external_auth_id
  ON public.users (external_auth_id);
CREATE INDEX IF NOT EXISTS idx_users_app_language
  ON public.users (app_language);
CREATE INDEX IF NOT EXISTS idx_users_visit_language
  ON public.users (visit_language);

CREATE TRIGGER trg_users_updated
BEFORE UPDATE ON public.users
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- =========================================
-- visits
-- =========================================
CREATE TABLE public.visits (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  doctor text NULL,
  title text NULL,
  status text NULL,
  specialty text NULL,
  duration text NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT visits_pkey PRIMARY KEY (id),
  CONSTRAINT visits_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_visits_user
  ON public.visits (user_id);

-- =========================================
-- visit_transcripts
-- =========================================
CREATE TABLE public.visit_transcripts (
  transcript_id uuid NOT NULL DEFAULT gen_random_uuid(),
  visit_id uuid NULL,
  user_id text NULL,
  audio_url text NULL,
  transcript_text text NULL,
  image_url text NULL,
  image_metadata jsonb NULL,
  ocr_text text NULL,
  ocr_status text NOT NULL DEFAULT 'pending',
  ocr_error text NULL,
  ocr_provider text NULL,
  ocr_metadata jsonb NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT visit_transcripts_pkey PRIMARY KEY (transcript_id),
  CONSTRAINT visit_transcripts_visit_id_fkey
    FOREIGN KEY (visit_id)
    REFERENCES public.visits (id)
    ON DELETE CASCADE,
  CONSTRAINT visit_transcripts_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE CASCADE,
  CONSTRAINT visit_transcripts_ocr_status_check
    CHECK (ocr_status IN ('pending', 'processing', 'completed', 'failed'))
);

CREATE INDEX IF NOT EXISTS idx_visit_transcripts_visit
  ON public.visit_transcripts (visit_id);
CREATE INDEX IF NOT EXISTS idx_visit_transcripts_user
  ON public.visit_transcripts (user_id);
CREATE INDEX IF NOT EXISTS idx_visit_transcripts_image_url
  ON public.visit_transcripts (image_url)
  WHERE image_url IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_visit_transcripts_ocr_status
  ON public.visit_transcripts (ocr_status)
  WHERE ocr_status IS NOT NULL;

-- =========================================
-- summaries_log
-- =========================================
CREATE TABLE public.summaries_log (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  transcript_id uuid NOT NULL,
  visit_id uuid NULL,
  user_id text NULL,
  model_name text NOT NULL,
  summary_text text NOT NULL,
  structured_data_json jsonb NULL,
  latency_ms integer NULL,
  tokens_in integer NULL,
  tokens_out integer NULL,
  cost_usd numeric(10, 6) NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT summaries_log_pkey PRIMARY KEY (id),
  CONSTRAINT summaries_log_transcript_id_fkey
    FOREIGN KEY (transcript_id)
    REFERENCES public.visit_transcripts (transcript_id)
    ON DELETE CASCADE,
  CONSTRAINT summaries_log_visit_id_fkey
    FOREIGN KEY (visit_id)
    REFERENCES public.visits (id)
    ON DELETE SET NULL,
  CONSTRAINT summaries_log_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_summaries_log_transcript_id
  ON public.summaries_log (transcript_id);
CREATE INDEX IF NOT EXISTS idx_summaries_log_created_at
  ON public.summaries_log (created_at DESC);

-- =========================================
-- reminders
-- =========================================
CREATE TABLE public.reminders (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  visit_id uuid NULL,
  reminder_type text NOT NULL,
  title text NOT NULL,
  message text NOT NULL,
  scheduled_time timestamptz NOT NULL,
  timezone text NULL DEFAULT 'America/New_York',
  recurrence text NULL,
  status text NOT NULL DEFAULT 'pending',
  completed_at timestamptz NULL,
  snoozed_count integer NOT NULL DEFAULT 0,
  snooze_until timestamptz NULL,
  retry_count integer NOT NULL DEFAULT 0,
  consecutive_skips integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT reminders_pkey PRIMARY KEY (id),
  CONSTRAINT reminders_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE CASCADE,
  CONSTRAINT reminders_visit_id_fkey
    FOREIGN KEY (visit_id)
    REFERENCES public.visits (id)
    ON DELETE SET NULL,
  CONSTRAINT reminders_recurrence_check CHECK (
    recurrence IS NULL OR recurrence IN (
      'daily', 'weekly', 'fortnightly', 'monthly', 'annually', 'once'
    )
  ),
  CONSTRAINT reminders_reminder_type_check CHECK (
    reminder_type IN ('medication', 'task', 'appointment')
  ),
  CONSTRAINT reminders_status_check CHECK (
    status IN ('pending', 'completed', 'snoozed', 'skipped', 'failed')
  )
);

CREATE INDEX IF NOT EXISTS idx_reminders_user
  ON public.reminders (user_id);
CREATE INDEX IF NOT EXISTS idx_reminders_scheduled_status
  ON public.reminders (scheduled_time, status)
  WHERE status = 'pending';

CREATE TRIGGER trg_reminders_updated
BEFORE UPDATE ON public.reminders
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- =========================================
-- reminder_templates
-- =========================================
CREATE TABLE public.reminder_templates (
  id text NOT NULL,
  reminder_type text NOT NULL,
  template_name text NOT NULL,
  template_content text NOT NULL,
  tone_persona text NULL,
  example_trigger_time text NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT reminder_templates_pkey PRIMARY KEY (id)
);

-- =========================================
-- reminder_logs
-- =========================================
CREATE TABLE public.reminder_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  reminder_id uuid NULL,
  user_id text NOT NULL,
  action text NOT NULL,
  notes text NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT reminder_logs_pkey PRIMARY KEY (id),
  CONSTRAINT reminder_logs_reminder_id_fkey
    FOREIGN KEY (reminder_id)
    REFERENCES public.reminders (id)
    ON DELETE CASCADE,
  CONSTRAINT reminder_logs_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE CASCADE,
  CONSTRAINT reminder_logs_action_check CHECK (
    action IN ('sent', 'completed', 'snoozed', 'skipped')
  )
);

CREATE INDEX IF NOT EXISTS idx_logs_reminder
  ON public.reminder_logs (reminder_id);
CREATE INDEX IF NOT EXISTS idx_logs_user
  ON public.reminder_logs (user_id);

-- =========================================
-- caregiver_alerts
-- =========================================
CREATE TABLE public.caregiver_alerts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  caregiver_id text NOT NULL,
  user_id text NULL,
  reminder_id uuid NULL,
  alert_type text NOT NULL,
  message text NOT NULL,
  sent_at timestamptz NOT NULL DEFAULT now(),
  read boolean NOT NULL DEFAULT false,
  CONSTRAINT caregiver_alerts_pkey PRIMARY KEY (id),
  CONSTRAINT caregiver_alerts_caregiver_id_fkey
    FOREIGN KEY (caregiver_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE CASCADE,
  CONSTRAINT caregiver_alerts_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE SET NULL,
  CONSTRAINT caregiver_alerts_reminder_id_fkey
    FOREIGN KEY (reminder_id)
    REFERENCES public.reminders (id)
    ON DELETE CASCADE,
  CONSTRAINT caregiver_alerts_alert_type_check CHECK (
    alert_type IN ('skipped', 'multiple_snoozes')
  )
);

CREATE INDEX IF NOT EXISTS idx_alerts_caregiver
  ON public.caregiver_alerts (caregiver_id, sent_at);
CREATE INDEX IF NOT EXISTS idx_alerts_user
  ON public.caregiver_alerts (user_id);

-- =========================================
-- care_team_members
-- =========================================
CREATE TABLE public.care_team_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id text NOT NULL,
  member_user_id text NOT NULL,
  role text NOT NULL,
  permission text NOT NULL,
  status text NOT NULL DEFAULT 'active',
  invited_by_user_id text NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  revoked_at timestamptz NULL,
  CONSTRAINT care_team_members_patient_member_unique UNIQUE (patient_id, member_user_id),
  CONSTRAINT care_team_members_patient_id_fkey
    FOREIGN KEY (patient_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE CASCADE,
  CONSTRAINT care_team_members_member_user_id_fkey
    FOREIGN KEY (member_user_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE CASCADE,
  CONSTRAINT care_team_members_invited_by_user_id_fkey
    FOREIGN KEY (invited_by_user_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS care_team_members_patient_id_idx
  ON public.care_team_members (patient_id);
CREATE INDEX IF NOT EXISTS care_team_members_member_user_id_idx
  ON public.care_team_members (member_user_id);

-- =========================================
-- care_team_invitations
-- =========================================
CREATE TABLE public.care_team_invitations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id text NOT NULL,
  invitee_email citext NOT NULL,
  token text NOT NULL UNIQUE,
  role text NOT NULL,
  permission text NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  invited_by_user_id text NULL,
  accepted_by_user_id text NULL,
  expires_at timestamptz NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  accepted_at timestamptz NULL,
  CONSTRAINT care_team_invitations_patient_id_fkey
    FOREIGN KEY (patient_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE CASCADE,
  CONSTRAINT care_team_invitations_invited_by_user_id_fkey
    FOREIGN KEY (invited_by_user_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE SET NULL,
  CONSTRAINT care_team_invitations_accepted_by_user_id_fkey
    FOREIGN KEY (accepted_by_user_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS care_team_invitations_patient_id_idx
  ON public.care_team_invitations (patient_id);
CREATE INDEX IF NOT EXISTS care_team_invitations_invitee_email_idx
  ON public.care_team_invitations (invitee_email);

-- =========================================
-- jobs
-- =========================================
CREATE TABLE public.jobs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_type text NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  attempts integer NOT NULL DEFAULT 0,
  last_error text NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_jobs_status
  ON public.jobs (status);
CREATE INDEX IF NOT EXISTS idx_jobs_type
  ON public.jobs (job_type);

-- =========================================
-- patient_tasks
-- =========================================
CREATE TABLE public.patient_tasks (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  visit_id uuid NULL,
  title text NOT NULL,
  type text NOT NULL,
  due_date timestamptz NULL,
  status text NOT NULL DEFAULT 'pending',
  source_type text NOT NULL,
  source_id text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT patient_tasks_pkey PRIMARY KEY (id),
  CONSTRAINT patient_tasks_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users (external_auth_id)
    ON DELETE CASCADE,
  CONSTRAINT patient_tasks_visit_id_fkey
    FOREIGN KEY (visit_id)
    REFERENCES public.visits (id)
    ON DELETE SET NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_patient_tasks_idempotency
  ON public.patient_tasks (user_id, source_type, source_id, title, due_date);
CREATE INDEX IF NOT EXISTS idx_patient_tasks_home
  ON public.patient_tasks (user_id, status, due_date);
