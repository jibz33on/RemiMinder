-- Add image_url column for OCR input media persistence
-- Extends visit_transcripts table to support OCR image storage
-- Idempotent and safe for production

ALTER TABLE public.visit_transcripts
ADD COLUMN IF NOT EXISTS image_url text;

-- Add index for image_url queries (OCR processing)
CREATE INDEX IF NOT EXISTS idx_visit_transcripts_image_url_ocr
ON public.visit_transcripts (image_url)
WHERE image_url IS NOT NULL AND ocr_status IS NOT NULL;
