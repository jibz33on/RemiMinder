-- Phase 2: Make patient/caregiver explicit roles; treat legacy 'user' as unknown.

ALTER TABLE public.users
  ALTER COLUMN role DROP DEFAULT;

ALTER TABLE public.users
  ALTER COLUMN role DROP NOT NULL;

UPDATE public.users
SET role = NULL
WHERE role = 'user';

ALTER TABLE public.users
  DROP CONSTRAINT IF EXISTS users_role_check;

ALTER TABLE public.users
  ADD CONSTRAINT users_role_check
  CHECK (role IN ('patient', 'caregiver', 'admin'));
