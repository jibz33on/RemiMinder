-- =========================================
-- Care Team Tables
-- =========================================

-- care_team_members table
-- Stores which users can access which patient's data
CREATE TABLE IF NOT EXISTS public.care_team_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id uuid NOT NULL,
  member_user_id uuid NOT NULL,
  role text NOT NULL,
  permission text NOT NULL,
  status text NOT NULL DEFAULT 'active',
  invited_by_user_id uuid NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  revoked_at timestamptz NULL,
  CONSTRAINT care_team_members_patient_member_unique UNIQUE (patient_id, member_user_id),
  CONSTRAINT care_team_members_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users (id),
  CONSTRAINT care_team_members_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.users (id),
  CONSTRAINT care_team_members_invited_by_user_id_fkey FOREIGN KEY (invited_by_user_id) REFERENCES public.users (id)
);

-- care_team_invitations table
-- Stores pending invitations sent by a patient
CREATE TABLE IF NOT EXISTS public.care_team_invitations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id uuid NOT NULL,
  invitee_email citext NOT NULL,
  token text NOT NULL UNIQUE,
  role text NOT NULL,
  permission text NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  invited_by_user_id uuid NULL,
  accepted_by_user_id uuid NULL,
  expires_at timestamptz NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  accepted_at timestamptz NULL,
  CONSTRAINT care_team_invitations_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users (id),
  CONSTRAINT care_team_invitations_invited_by_user_id_fkey FOREIGN KEY (invited_by_user_id) REFERENCES public.users (id),
  CONSTRAINT care_team_invitations_accepted_by_user_id_fkey FOREIGN KEY (accepted_by_user_id) REFERENCES public.users (id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS care_team_members_patient_id_idx
  ON public.care_team_members (patient_id);
CREATE INDEX IF NOT EXISTS care_team_members_member_user_id_idx
  ON public.care_team_members (member_user_id);
CREATE INDEX IF NOT EXISTS care_team_invitations_patient_id_idx
  ON public.care_team_invitations (patient_id);
CREATE INDEX IF NOT EXISTS care_team_invitations_invitee_email_idx
  ON public.care_team_invitations (invitee_email);
