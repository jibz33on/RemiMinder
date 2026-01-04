-- Add image storage columns to visit_transcripts table
-- This supports Firebase migration and image upload functionality

ALTER TABLE public.visit_transcripts
ADD COLUMN IF NOT EXISTS image_url text,
ADD COLUMN IF NOT EXISTS image_metadata jsonb;

-- Add index for image_url if it doesn't exist
CREATE INDEX IF NOT EXISTS idx_visit_transcripts_image_url
ON public.visit_transcripts (image_url)
WHERE image_url IS NOT NULL;
