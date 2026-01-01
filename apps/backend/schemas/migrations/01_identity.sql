-- =========================================
-- Extensions
-- =========================================
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "citext";

-- =========================================
-- Helper function: auto-update updated_at
-- =========================================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================================
-- users table
-- =========================================
CREATE TABLE public.users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_uid uuid UNIQUE,
  email citext NOT NULL UNIQUE,
  full_name text,
  role text NOT NULL DEFAULT 'user',
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  date_of_birth date,
  gender text,
  phone text,
  notes text,
  CONSTRAINT users_role_check CHECK (
    role IN ('user', 'caregiver', 'admin')
  )
);

-- =========================================
-- Indexes
-- =========================================
CREATE INDEX IF NOT EXISTS idx_users_email
  ON public.users (email);

-- =========================================
-- Triggers
-- =========================================
CREATE TRIGGER trg_users_updated
BEFORE UPDATE ON public.users
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- =========================================
-- caregivers table
-- =========================================
CREATE TABLE public.caregivers (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  auth_uid uuid NULL,
  email text NOT NULL,
  full_name text NOT NULL,
  phone text NOT NULL,
  relationship text NULL,
  notes text NULL,
  date_of_birth date NULL,
  gender text NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT caregivers_pkey PRIMARY KEY (id),
  CONSTRAINT caregivers_email_key UNIQUE (email)
);

-- =========================================
-- caregivers indexes
-- =========================================
CREATE INDEX IF NOT EXISTS idx_caregivers_auth_uid
  ON public.caregivers (auth_uid);


-- =========================================
-- doctors table
-- =========================================
CREATE TABLE public.doctors (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  specialty text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT doctors_pkey PRIMARY KEY (id),
  CONSTRAINT doctors_specialty_check CHECK (
    specialty IN (
      'General Practice',
      'Emergency Medicine'
    )
  )
);

-- =========================================
-- patient_caregiver table
-- =========================================
CREATE TABLE public.patient_caregiver (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  patient_id uuid NOT NULL,
  caregiver_id uuid NOT NULL,
  linked_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT patient_caregiver_pkey PRIMARY KEY (id),
  CONSTRAINT patient_caregiver_patient_id_key UNIQUE (patient_id)
);


-- =========================================
-- invitations table
-- =========================================
CREATE TABLE public.invitations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  caregiver_email citext NOT NULL,
  patient_id uuid NULL,
  token text NOT NULL,
  expires_at timestamptz NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  status text NOT NULL DEFAULT 'pending',
  caregiver_name text NULL,
  accepted_at timestamptz NULL,
  CONSTRAINT invitations_pkey PRIMARY KEY (id)
);

-- =========================================
-- invitations indexes
-- =========================================
CREATE INDEX IF NOT EXISTS idx_invite_email
  ON public.invitations (caregiver_email);
