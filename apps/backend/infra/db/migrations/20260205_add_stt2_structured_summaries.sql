-- STT-2 structured summaries (current state per visit)
CREATE TABLE IF NOT EXISTS public.stt2_structured_summaries (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  visit_id uuid NOT NULL,
  raw_stt_transcript_id uuid NOT NULL,
  raw_transcript_hash text NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  summary_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  prompt_version text NOT NULL,
  model_name text NOT NULL,
  last_error text NULL,
  completed_at timestamptz NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT stt2_structured_summaries_pkey PRIMARY KEY (id),
  CONSTRAINT stt2_structured_summaries_visit_id_key UNIQUE (visit_id),
  CONSTRAINT stt2_structured_summaries_visit_id_fkey
    FOREIGN KEY (visit_id)
    REFERENCES public.visits (id)
    ON DELETE CASCADE,
  CONSTRAINT stt2_structured_summaries_raw_stt_transcript_id_fkey
    FOREIGN KEY (raw_stt_transcript_id)
    REFERENCES public.raw_stt_transcripts (id)
    ON DELETE CASCADE,
  CONSTRAINT stt2_structured_summaries_status_check
    CHECK (status IN ('pending', 'processing', 'completed', 'failed'))
);

CREATE INDEX IF NOT EXISTS idx_stt2_structured_summaries_status
  ON public.stt2_structured_summaries (status);
CREATE INDEX IF NOT EXISTS idx_stt2_structured_summaries_created_at
  ON public.stt2_structured_summaries (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_stt2_structured_summaries_raw_stt_transcript_id
  ON public.stt2_structured_summaries (raw_stt_transcript_id);

CREATE TRIGGER trg_stt2_structured_summaries_updated
BEFORE UPDATE ON public.stt2_structured_summaries
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- STT-2 structured summary runs (append-only audit log)
CREATE TABLE IF NOT EXISTS public.stt2_structured_summary_runs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  visit_id uuid NOT NULL,
  raw_stt_transcript_id uuid NOT NULL,
  job_id uuid NULL,
  prompt_version text NOT NULL,
  model_name text NOT NULL,
  status text NOT NULL,
  output_json jsonb NULL,
  error_text text NULL,
  latency_ms integer NULL,
  tokens_in integer NULL,
  tokens_out integer NULL,
  cost_usd numeric(10, 6) NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT stt2_structured_summary_runs_pkey PRIMARY KEY (id),
  CONSTRAINT stt2_structured_summary_runs_visit_id_fkey
    FOREIGN KEY (visit_id)
    REFERENCES public.visits (id)
    ON DELETE CASCADE,
  CONSTRAINT stt2_structured_summary_runs_raw_stt_transcript_id_fkey
    FOREIGN KEY (raw_stt_transcript_id)
    REFERENCES public.raw_stt_transcripts (id)
    ON DELETE CASCADE,
  CONSTRAINT stt2_structured_summary_runs_job_id_fkey
    FOREIGN KEY (job_id)
    REFERENCES public.jobs (id)
    ON DELETE SET NULL,
  CONSTRAINT stt2_structured_summary_runs_status_check
    CHECK (status IN ('completed', 'failed'))
);

CREATE INDEX IF NOT EXISTS idx_stt2_structured_summary_runs_visit_id
  ON public.stt2_structured_summary_runs (visit_id);
CREATE INDEX IF NOT EXISTS idx_stt2_structured_summary_runs_created_at
  ON public.stt2_structured_summary_runs (created_at DESC);
