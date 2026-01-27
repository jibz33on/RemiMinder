-- =========================================
-- patient_tasks table
-- =========================================
CREATE TABLE public.patient_tasks (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  visit_id uuid NULL,
  title text NOT NULL,
  type text NOT NULL,
  due_date timestamptz NULL,
  status text NOT NULL DEFAULT 'pending',
  source_type text NOT NULL,
  source_id text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT patient_tasks_pkey PRIMARY KEY (id)
);

-- =========================================
-- patient_tasks indexes
-- =========================================
CREATE UNIQUE INDEX IF NOT EXISTS idx_patient_tasks_idempotency
  ON public.patient_tasks (user_id, source_type, source_id, title, due_date);

CREATE INDEX IF NOT EXISTS idx_patient_tasks_home
  ON public.patient_tasks (user_id, status, due_date);
