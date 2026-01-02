-- =========================================
-- Migration: Add Firebase Auth Support
-- =========================================

-- Add firebase_uid column to users table
-- This allows Firebase users to be stored alongside Supabase users
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS firebase_uid TEXT UNIQUE;

-- Add index for firebase_uid lookups
CREATE INDEX IF NOT EXISTS idx_users_firebase_uid
  ON public.users (firebase_uid);

-- =========================================
-- Notes:
-- - firebase_uid is TEXT to accommodate Firebase's string UIDs
-- - firebase_uid is UNIQUE to prevent duplicate Firebase users
-- - firebase_uid is nullable (existing Supabase users will have NULL)
-- - auth_uid column remains unchanged for backward compatibility
-- =========================================
