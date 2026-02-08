-- Add summary column to visits table for Stage 3.4 final summaries
ALTER TABLE public.visits
  ADD COLUMN IF NOT EXISTS summary text NULL;

CREATE INDEX IF NOT EXISTS idx_visits_summary
  ON public.visits (summary)
  WHERE summary IS NOT NULL;