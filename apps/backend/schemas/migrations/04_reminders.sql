-- =========================================
-- reminders table
-- =========================================
CREATE TABLE public.reminders (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
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
  CONSTRAINT reminders_recurrence_check CHECK (
    recurrence IS NULL OR recurrence IN (
      'daily',
      'weekly',
      'fortnightly',
      'monthly',
      'annually',
      'once'
    )
  ),
  CONSTRAINT reminders_reminder_type_check CHECK (
    reminder_type IN ('medication', 'task', 'appointment')
  ),
  CONSTRAINT reminders_status_check CHECK (
    status IN ('pending', 'completed', 'snoozed', 'skipped', 'failed')
  )
);

-- =========================================
-- reminders indexes
-- =========================================
CREATE INDEX IF NOT EXISTS idx_reminders_user
  ON public.reminders (user_id);

CREATE INDEX IF NOT EXISTS idx_reminders_scheduled_status
  ON public.reminders (scheduled_time, status)
  WHERE status = 'pending';

-- =========================================
-- reminders triggers
-- =========================================
CREATE TRIGGER trg_reminders_updated
BEFORE UPDATE ON public.reminders
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- =========================================
-- reminder_templates table
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
-- reminder_logs table
-- =========================================
CREATE TABLE public.reminder_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  reminder_id uuid NULL,
  user_id uuid NOT NULL,
  action text NOT NULL,
  notes text NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT reminder_logs_pkey PRIMARY KEY (id),
  CONSTRAINT reminder_logs_action_check CHECK (
    action IN ('sent', 'completed', 'snoozed', 'skipped')
  )
);

-- =========================================
-- reminder_logs indexes
-- =========================================
CREATE INDEX IF NOT EXISTS idx_logs_reminder
  ON public.reminder_logs (reminder_id);

CREATE INDEX IF NOT EXISTS idx_logs_user
  ON public.reminder_logs (user_id);

-- =========================================
-- caregiver_alerts table
-- =========================================
CREATE TABLE public.caregiver_alerts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  caregiver_id uuid NOT NULL,
  user_id uuid NULL,
  reminder_id uuid NULL,
  alert_type text NOT NULL,
  message text NOT NULL,
  sent_at timestamptz NOT NULL DEFAULT now(),
  read boolean NOT NULL DEFAULT false,
  CONSTRAINT caregiver_alerts_pkey PRIMARY KEY (id),
  CONSTRAINT caregiver_alerts_alert_type_check CHECK (
    alert_type IN ('skipped', 'multiple_snoozes')
  )
);

-- =========================================
-- caregiver_alerts indexes
-- =========================================
CREATE INDEX IF NOT EXISTS idx_alerts_caregiver
  ON public.caregiver_alerts (caregiver_id, sent_at);

CREATE INDEX IF NOT EXISTS idx_alerts_user
  ON public.caregiver_alerts (user_id);
