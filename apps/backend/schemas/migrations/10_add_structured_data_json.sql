-- =========================================
-- Add structured_data_json column to summaries_log
-- =========================================
ALTER TABLE summaries_log ADD COLUMN structured_data_json JSONB;
