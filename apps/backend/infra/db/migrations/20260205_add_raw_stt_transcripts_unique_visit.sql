-- Ensure no duplicate raw transcripts exist before enforcing uniqueness
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM raw_stt_transcripts
    GROUP BY visit_id
    HAVING COUNT(*) > 1
  ) THEN
    RAISE EXCEPTION 'raw_stt_transcripts has duplicate visit_id; resolve before adding unique constraint';
  END IF;
END $$;

-- Enforce one raw transcript per visit
ALTER TABLE public.raw_stt_transcripts
  ADD CONSTRAINT raw_stt_transcripts_visit_id_key UNIQUE (visit_id);
