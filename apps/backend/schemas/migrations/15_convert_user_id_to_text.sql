-- =========================================
-- Convert user_id references to TEXT (Firebase UID)
-- =========================================

-- Drop FKs that reference users(id) on user-related columns
ALTER TABLE public.patient_caregiver
DROP CONSTRAINT IF EXISTS patient_caregiver_patient_id_fkey;

ALTER TABLE public.invitations
DROP CONSTRAINT IF EXISTS invitations_patient_id_fkey;

ALTER TABLE public.visits
DROP CONSTRAINT IF EXISTS visits_user_id_fkey;

ALTER TABLE public.visit_recordings
DROP CONSTRAINT IF EXISTS visit_recordings_user_id_fkey;

ALTER TABLE public.visit_transcripts
DROP CONSTRAINT IF EXISTS visit_transcripts_user_id_fkey;

ALTER TABLE public.visit_summaries
DROP CONSTRAINT IF EXISTS visit_summaries_user_id_fkey;

ALTER TABLE public.ai_usage
DROP CONSTRAINT IF EXISTS ai_usage_user_id_fkey;

ALTER TABLE public.summaries_log
DROP CONSTRAINT IF EXISTS summaries_log_user_id_fkey;

ALTER TABLE public.feedback_log
DROP CONSTRAINT IF EXISTS feedback_log_user_id_fkey;

ALTER TABLE public.audit_log
DROP CONSTRAINT IF EXISTS audit_log_actor_user_id_fkey;

ALTER TABLE public.reminders
DROP CONSTRAINT IF EXISTS reminders_user_id_fkey;

ALTER TABLE public.reminder_logs
DROP CONSTRAINT IF EXISTS reminder_logs_user_id_fkey;

ALTER TABLE public.caregiver_alerts
DROP CONSTRAINT IF EXISTS caregiver_alerts_user_id_fkey;

ALTER TABLE public.care_team_members
DROP CONSTRAINT IF EXISTS care_team_members_patient_id_fkey;

ALTER TABLE public.care_team_members
DROP CONSTRAINT IF EXISTS care_team_members_member_user_id_fkey;

ALTER TABLE public.care_team_members
DROP CONSTRAINT IF EXISTS care_team_members_invited_by_user_id_fkey;

ALTER TABLE public.care_team_invitations
DROP CONSTRAINT IF EXISTS care_team_invitations_patient_id_fkey;

ALTER TABLE public.care_team_invitations
DROP CONSTRAINT IF EXISTS care_team_invitations_invited_by_user_id_fkey;

ALTER TABLE public.care_team_invitations
DROP CONSTRAINT IF EXISTS care_team_invitations_accepted_by_user_id_fkey;

-- Convert user_id and user reference columns to TEXT
ALTER TABLE public.patient_caregiver
ALTER COLUMN patient_id TYPE text USING patient_id::text;

ALTER TABLE public.invitations
ALTER COLUMN patient_id TYPE text USING patient_id::text;

ALTER TABLE public.visits
ALTER COLUMN user_id TYPE text USING user_id::text;

ALTER TABLE public.visit_recordings
ALTER COLUMN user_id TYPE text USING user_id::text;

ALTER TABLE public.visit_transcripts
ALTER COLUMN user_id TYPE text USING user_id::text;

ALTER TABLE public.visit_summaries
ALTER COLUMN user_id TYPE text USING user_id::text;

ALTER TABLE public.ai_usage
ALTER COLUMN user_id TYPE text USING user_id::text;

ALTER TABLE public.summaries_log
ALTER COLUMN user_id TYPE text USING user_id::text;

ALTER TABLE public.feedback_log
ALTER COLUMN user_id TYPE text USING user_id::text;

ALTER TABLE public.audit_log
ALTER COLUMN actor_user_id TYPE text USING actor_user_id::text;

ALTER TABLE public.reminders
ALTER COLUMN user_id TYPE text USING user_id::text;

ALTER TABLE public.reminder_logs
ALTER COLUMN user_id TYPE text USING user_id::text;

ALTER TABLE public.caregiver_alerts
ALTER COLUMN user_id TYPE text USING user_id::text;

ALTER TABLE public.care_team_members
ALTER COLUMN patient_id TYPE text USING patient_id::text;

ALTER TABLE public.care_team_members
ALTER COLUMN member_user_id TYPE text USING member_user_id::text;

ALTER TABLE public.care_team_members
ALTER COLUMN invited_by_user_id TYPE text USING invited_by_user_id::text;

ALTER TABLE public.care_team_invitations
ALTER COLUMN patient_id TYPE text USING patient_id::text;

ALTER TABLE public.care_team_invitations
ALTER COLUMN invited_by_user_id TYPE text USING invited_by_user_id::text;

ALTER TABLE public.care_team_invitations
ALTER COLUMN accepted_by_user_id TYPE text USING accepted_by_user_id::text;

ALTER TABLE public.patient_tasks
ALTER COLUMN user_id TYPE text USING user_id::text;
