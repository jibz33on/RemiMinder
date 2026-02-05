-- Add canonical audio path to visit_transcripts
ALTER TABLE public.visit_transcripts
  ADD COLUMN IF NOT EXISTS canonical_audio_path text NULL;

-- Raw STT transcript artifacts (append-only)
CREATE TABLE IF NOT EXISTS public.raw_stt_transcripts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  visit_id uuid NOT NULL,
  transcript_text text NOT NULL,
  stt_engine text NOT NULL,
  language text NULL,
  confidence real NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT raw_stt_transcripts_pkey PRIMARY KEY (id),
  CONSTRAINT raw_stt_transcripts_visit_id_fkey
    FOREIGN KEY (visit_id)
    REFERENCES public.visits (id)
    ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_raw_stt_transcripts_visit_id
  ON public.raw_stt_transcripts (visit_id);
