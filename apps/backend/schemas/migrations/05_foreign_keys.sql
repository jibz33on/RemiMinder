-- ======================================
-- 01 Identity
-- ======================================

--patient_caregiver

ALTER TABLE public.patient_caregiver
ADD CONSTRAINT patient_caregiver_patient_id_fkey
FOREIGN KEY (patient_id)
REFERENCES public.users (id)
ON DELETE CASCADE;

ALTER TABLE public.patient_caregiver
ADD CONSTRAINT patient_caregiver_caregiver_id_fkey
FOREIGN KEY (caregiver_id)
REFERENCES public.caregivers (id)
ON DELETE CASCADE;

--invitations

ALTER TABLE public.invitations
ADD CONSTRAINT invitations_patient_id_fkey
FOREIGN KEY (patient_id)
REFERENCES public.users (id)
ON DELETE SET NULL;

-- ======================================
-- 02 Visits domain 
-- ======================================

--visits 

ALTER TABLE public.visits
ADD CONSTRAINT visits_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE CASCADE;

--visit_recordings

ALTER TABLE public.visit_recordings
ADD CONSTRAINT visit_recordings_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE CASCADE;

ALTER TABLE public.visit_recordings
ADD CONSTRAINT visit_recordings_caregiver_id_fkey
FOREIGN KEY (caregiver_id)
REFERENCES public.caregivers (id)
ON DELETE SET NULL;

-- visit_transcripts

ALTER TABLE public.visit_transcripts
ADD CONSTRAINT visit_transcripts_visit_id_fkey
FOREIGN KEY (visit_id)
REFERENCES public.visits (id)
ON DELETE SET NULL;

ALTER TABLE public.visit_transcripts
ADD CONSTRAINT visit_transcripts_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE SET NULL;

--visit summaries

ALTER TABLE public.visit_summaries
ADD CONSTRAINT visit_summaries_visit_id_fkey
FOREIGN KEY (visit_id)
REFERENCES public.visits (id)
ON DELETE CASCADE;

ALTER TABLE public.visit_summaries
ADD CONSTRAINT visit_summaries_transcript_id_fkey
FOREIGN KEY (transcript_id)
REFERENCES public.visit_transcripts (transcript_id)
ON DELETE CASCADE;

ALTER TABLE public.visit_summaries
ADD CONSTRAINT visit_summaries_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE CASCADE;

-- ======================================
-- 03 AI domain
-- ======================================

-- ai_usage

ALTER TABLE public.ai_usage
ADD CONSTRAINT ai_usage_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE SET NULL;

ALTER TABLE public.ai_usage
ADD CONSTRAINT ai_usage_visit_id_fkey
FOREIGN KEY (visit_id)
REFERENCES public.visits (id)
ON DELETE SET NULL;

ALTER TABLE public.ai_usage
ADD CONSTRAINT ai_usage_transcript_id_fkey
FOREIGN KEY (transcript_id)
REFERENCES public.visit_transcripts (transcript_id)
ON DELETE SET NULL;

--best_examples

ALTER TABLE public.best_examples
ADD CONSTRAINT best_examples_source_summary_id_fkey
FOREIGN KEY (source_summary_id)
REFERENCES public.summaries_log (id)
ON DELETE SET NULL;

-- feedback_log

ALTER TABLE public.feedback_log
ADD CONSTRAINT feedback_log_summary_id_fkey
FOREIGN KEY (summary_id)
REFERENCES public.summaries_log (id)
ON DELETE CASCADE;

ALTER TABLE public.feedback_log
ADD CONSTRAINT feedback_log_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE SET NULL;

-- audit_log

ALTER TABLE public.audit_log
ADD CONSTRAINT audit_log_actor_user_id_fkey
FOREIGN KEY (actor_user_id)
REFERENCES public.users (id)
ON DELETE SET NULL;

-- ======================================
-- 04 Reminders domain
-- ======================================

-- reminders 

ALTER TABLE public.reminders
ADD CONSTRAINT reminders_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE CASCADE;

ALTER TABLE public.reminders
ADD CONSTRAINT reminders_visit_id_fkey
FOREIGN KEY (visit_id)
REFERENCES public.visits (id)
ON DELETE SET NULL;


-- reminder_logs

ALTER TABLE public.reminder_logs
ADD CONSTRAINT reminder_logs_reminder_id_fkey
FOREIGN KEY (reminder_id)
REFERENCES public.reminders (id)
ON DELETE CASCADE;

ALTER TABLE public.reminder_logs
ADD CONSTRAINT reminder_logs_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE CASCADE;


-- caregiver_alerts

ALTER TABLE public.caregiver_alerts
ADD CONSTRAINT caregiver_alerts_caregiver_id_fkey
FOREIGN KEY (caregiver_id)
REFERENCES public.caregivers (id)
ON DELETE CASCADE;

ALTER TABLE public.caregiver_alerts
ADD CONSTRAINT caregiver_alerts_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE SET NULL;

ALTER TABLE public.caregiver_alerts
ADD CONSTRAINT caregiver_alerts_reminder_id_fkey
FOREIGN KEY (reminder_id)
REFERENCES public.reminders (id)
ON DELETE CASCADE;

