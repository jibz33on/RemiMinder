-- Add output_type column to stt2_structured_summaries table
-- This column identifies the type of STT-2 processing (structured vs other types)

ALTER TABLE public.stt2_structured_summaries
ADD COLUMN IF NOT EXISTS output_type text NOT NULL DEFAULT 'stt2_structured'
CHECK (output_type IN ('stt2_structured'));

-- Add index for efficient querying by output_type
CREATE INDEX IF NOT EXISTS idx_stt2_structured_summaries_output_type
  ON public.stt2_structured_summaries (output_type);

-- Update any existing rows to have the correct output_type
UPDATE public.stt2_structured_summaries
SET output_type = 'stt2_structured'
WHERE output_type IS NULL;