-- Add OCR columns to visit_transcripts table
-- This extends the existing table for OCR functionality
-- Follows same lifecycle pattern as audio processing

ALTER TABLE public.visit_transcripts
ADD COLUMN IF NOT EXISTS ocr_text text,
ADD COLUMN IF NOT EXISTS ocr_status text NOT NULL DEFAULT 'pending',
ADD COLUMN IF NOT EXISTS ocr_error text,
ADD COLUMN IF NOT EXISTS ocr_provider text,
ADD COLUMN IF NOT EXISTS ocr_metadata jsonb;

-- Add index for ocr_status to support lifecycle queries
CREATE INDEX IF NOT EXISTS idx_visit_transcripts_ocr_status
ON public.visit_transcripts (ocr_status)
WHERE ocr_status IS NOT NULL;

-- Add constraint for ocr_status values
ALTER TABLE public.visit_transcripts
ADD CONSTRAINT visit_transcripts_ocr_status_check
CHECK (ocr_status IN ('pending', 'processing', 'completed', 'failed'));
