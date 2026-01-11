-- =========================================
-- Add language preference columns to users table
-- =========================================
ALTER TABLE users
ADD COLUMN IF NOT EXISTS app_language VARCHAR(10) NOT NULL DEFAULT 'en',
ADD COLUMN IF NOT EXISTS visit_language VARCHAR(10) NOT NULL DEFAULT 'en';

-- =========================================
-- Add index for potential future queries
-- =========================================
CREATE INDEX IF NOT EXISTS idx_users_app_language
  ON public.users (app_language);

CREATE INDEX IF NOT EXISTS idx_users_visit_language
  ON public.users (visit_language);