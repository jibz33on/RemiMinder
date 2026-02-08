import json
from typing import Optional

from sqlalchemy import text

from domain.ports.db import get_db_engine
from domain.ports.logging import get_logger

logger = get_logger()


async def get_raw_stt_transcript_for_visit(visit_id: str) -> Optional[dict]:
    """
    Fetch raw_stt_transcripts row for a visit.
    Returns dict with id and transcript_text, or None if missing.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT id, transcript_text
                FROM raw_stt_transcripts
                WHERE visit_id = :visit_id
                LIMIT 1
            """)
            row = conn.execute(query, {"visit_id": visit_id}).fetchone()
            if not row:
                return None
            return {"id": str(row[0]), "transcript_text": row[1]}
    except Exception as exc:
        logger.error(f"Error fetching raw STT transcript for visit {visit_id}: {exc}")
        raise


async def insert_stt2_structured_summary(
    visit_id: str,
    raw_stt_transcript_id: str,
    raw_transcript_hash: str,
    prompt_version: str,
    model_name: str,
) -> Optional[str]:
    """
    Insert a pending STT-2 structured summary row.
    Returns summary id if inserted, None if already exists.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            insert_query = text("""
                INSERT INTO stt2_structured_summaries (
                    visit_id,
                    raw_stt_transcript_id,
                    raw_transcript_hash,
                    status,
                    summary_json,
                    prompt_version,
                    model_name
                )
                VALUES (
                    :visit_id,
                    :raw_stt_transcript_id,
                    :raw_transcript_hash,
                    'pending',
                    :summary_json,
                    :prompt_version,
                    :model_name
                )
                ON CONFLICT (visit_id) DO NOTHING
                RETURNING id
            """)
            result = conn.execute(
                insert_query,
                {
                    "visit_id": visit_id,
                    "raw_stt_transcript_id": raw_stt_transcript_id,
                    "raw_transcript_hash": raw_transcript_hash,
                    "summary_json": json.dumps({}),
                    "prompt_version": prompt_version,
                    "model_name": model_name,
                },
            )
            row = result.fetchone()
            return str(row[0]) if row and row[0] else None
    except Exception as exc:
        logger.error(f"Error inserting STT-2 summary for visit {visit_id}: {exc}")
        raise


async def get_stt2_summary_status(visit_id: str) -> Optional[str]:
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT status
                FROM stt2_structured_summaries
                WHERE visit_id = :visit_id
            """)
            row = conn.execute(query, {"visit_id": visit_id}).fetchone()
            return str(row[0]) if row and row[0] else None
    except Exception as exc:
        logger.error(f"Error fetching STT-2 status for visit {visit_id}: {exc}")
        raise


async def get_stt2_summary_info(visit_id: str) -> Optional[dict]:
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT raw_stt_transcript_id, prompt_version, model_name
                FROM stt2_structured_summaries
                WHERE visit_id = :visit_id
            """)
            row = conn.execute(query, {"visit_id": visit_id}).fetchone()
            if not row:
                return None
            return {
                "raw_stt_transcript_id": str(row[0]),
                "prompt_version": row[1],
                "model_name": row[2],
            }
    except Exception as exc:
        logger.error(f"Error fetching STT-2 summary info for visit {visit_id}: {exc}")
        raise


async def get_stt2_summary_row(visit_id: str) -> Optional[dict]:
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT status,
                       raw_stt_transcript_id,
                       raw_transcript_hash,
                       prompt_version,
                       model_name
                FROM stt2_structured_summaries
                WHERE visit_id = :visit_id
            """)
            row = conn.execute(query, {"visit_id": visit_id}).fetchone()
            if not row:
                return None
            return {
                "status": row[0],
                "raw_stt_transcript_id": str(row[1]),
                "raw_transcript_hash": row[2],
                "prompt_version": row[3],
                "model_name": row[4],
            }
    except Exception as exc:
        logger.error(f"Error fetching STT-2 summary row for visit {visit_id}: {exc}")
        raise


async def mark_stt2_summary_processing(visit_id: str, raw_stt_transcript_id: str, raw_transcript_hash: str) -> Optional[dict]:
    """
    Mark STT-2 summary as processing. Uses UPSERT to ensure row exists.
    This handles cases where the row wasn't created during enqueue.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            # First, try to update existing row to processing
            update_query = text("""
                UPDATE stt2_structured_summaries
                SET status = 'processing',
                    updated_at = now()
                WHERE visit_id = :visit_id
                  AND status IN ('pending', 'failed')
                RETURNING raw_stt_transcript_id, raw_transcript_hash, prompt_version, model_name
            """)
            row = conn.execute(update_query, {"visit_id": visit_id}).fetchone()
            if row:
                return {
                    "raw_stt_transcript_id": str(row[0]),
                    "raw_transcript_hash": row[1],
                    "prompt_version": row[2],
                    "model_name": row[3],
                }

            # If no row was updated, create one with the transcript data
            # This handles the case where the summary row doesn't exist yet
            insert_query = text("""
                INSERT INTO stt2_structured_summaries (
                    visit_id,
                    raw_stt_transcript_id,
                    raw_transcript_hash,
                    status,
                    summary_json,
                    prompt_version,
                    model_name
                )
                VALUES (
                    :visit_id,
                    :raw_stt_transcript_id,
                    :raw_transcript_hash,
                    'processing',
                    :summary_json,
                    :prompt_version,
                    :model_name
                )
                RETURNING raw_stt_transcript_id, raw_transcript_hash, prompt_version, model_name
            """)
            try:
                row = conn.execute(
                    insert_query,
                    {
                        "visit_id": visit_id,
                        "raw_stt_transcript_id": raw_stt_transcript_id,
                        "raw_transcript_hash": raw_transcript_hash,
                        "summary_json": json.dumps({}),
                        "prompt_version": "stt2_v0_fallback",
                        "model_name": "fallback_model",
                    },
                ).fetchone()
            except Exception as insert_exc:
                # If INSERT failed (likely due to duplicate key), try UPDATE instead
                logger.warning(f"INSERT failed for visit {visit_id}, trying UPDATE: {insert_exc}")
                update_query = text("""
                    UPDATE stt2_structured_summaries
                    SET status = 'processing',
                        raw_stt_transcript_id = :raw_stt_transcript_id,
                        raw_transcript_hash = :raw_transcript_hash,
                        updated_at = now()
                    WHERE visit_id = :visit_id
                    RETURNING raw_stt_transcript_id, raw_transcript_hash, prompt_version, model_name
                """)
                row = conn.execute(
                    update_query,
                    {
                        "visit_id": visit_id,
                        "raw_stt_transcript_id": raw_stt_transcript_id,
                        "raw_transcript_hash": raw_transcript_hash,
                    },
                ).fetchone()

            if row:
                return {
                    "raw_stt_transcript_id": str(row[0]) if row[0] else None,
                    "raw_transcript_hash": row[1],
                    "prompt_version": row[2],
                    "model_name": row[3],
                }
            return None
    except Exception as exc:
        logger.error(f"Error updating STT-2 status to processing for visit {visit_id}: {exc}")
        raise


async def mark_stt2_summary_completed(
    visit_id: str,
    summary_json: dict,
    raw_transcript_hash: str,
    raw_stt_transcript_id: str,
    prompt_version: str,
    model_name: str,
) -> None:
    """
    Mark STT-2 summary as completed. Uses UPSERT for robustness.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            # Use UPSERT to ensure the row exists and gets updated
            upsert_query = text("""
                INSERT INTO stt2_structured_summaries (
                    visit_id,
                    raw_stt_transcript_id,
                    status,
                    summary_json,
                    raw_transcript_hash,
                    output_type,
                    prompt_version,
                    model_name,
                    last_error,
                    completed_at,
                    updated_at
                )
                VALUES (
                    :visit_id,
                    :raw_stt_transcript_id,
                    'completed',
                    :summary_json,
                    :raw_transcript_hash,
                    'stt2_structured',
                    :prompt_version,
                    :model_name,
                    NULL,
                    now(),
                    now()
                )
                ON CONFLICT (visit_id) DO UPDATE SET
                    raw_stt_transcript_id = :raw_stt_transcript_id,
                    status = 'completed',
                    summary_json = :summary_json,
                    raw_transcript_hash = :raw_transcript_hash,
                    output_type = 'stt2_structured',
                    prompt_version = :prompt_version,
                    model_name = :model_name,
                    last_error = NULL,
                    completed_at = now(),
                    updated_at = now()
            """)
            conn.execute(
                upsert_query,
                {
                    "visit_id": visit_id,
                    "raw_stt_transcript_id": raw_stt_transcript_id,
                    "summary_json": json.dumps(summary_json),
                    "raw_transcript_hash": raw_transcript_hash,
                    "prompt_version": prompt_version,
                    "model_name": model_name,
                },
            )
    except Exception as exc:
        logger.error(f"Error updating STT-2 status to completed for visit {visit_id}: {exc}")
        raise


async def mark_stt2_summary_failed(visit_id: str, error: str) -> None:
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            update_query = text("""
                UPDATE stt2_structured_summaries
                SET status = 'failed',
                    last_error = :error,
                    updated_at = now()
                WHERE visit_id = :visit_id
            """)
            conn.execute(update_query, {"visit_id": visit_id, "error": error})
    except Exception as exc:
        logger.error(f"Error updating STT-2 status to failed for visit {visit_id}: {exc}")
        raise


async def insert_stt2_summary_run(
    visit_id: str,
    raw_stt_transcript_id: str,
    job_id: str | None,
    prompt_version: str,
    model_name: str,
    status: str,
    output_json: dict | None,
    error_text: str | None,
    latency_ms: int | None,
    tokens_in: int | None,
    tokens_out: int | None,
    cost_usd: float = 0.0,
) -> None:
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            insert_query = text("""
                INSERT INTO stt2_structured_summary_runs (
                    visit_id,
                    raw_stt_transcript_id,
                    job_id,
                    prompt_version,
                    model_name,
                    status,
                    output_json,
                    error_text,
                    latency_ms,
                    tokens_in,
                    tokens_out,
                    cost_usd
                )
                VALUES (
                    :visit_id,
                    :raw_stt_transcript_id,
                    :job_id,
                    :prompt_version,
                    :model_name,
                    :status,
                    :output_json,
                    :error_text,
                    :latency_ms,
                    :tokens_in,
                    :tokens_out,
                    :cost_usd
                )
            """)
            conn.execute(
                insert_query,
                {
                    "visit_id": visit_id,
                    "raw_stt_transcript_id": raw_stt_transcript_id,
                    "job_id": job_id,
                    "prompt_version": prompt_version,
                    "model_name": model_name,
                    "status": status,
                    "output_json": json.dumps(output_json) if output_json is not None else None,
                    "error_text": error_text,
                    "latency_ms": latency_ms,
                    "tokens_in": tokens_in,
                    "tokens_out": tokens_out,
                    "cost_usd": cost_usd,
                },
            )
    except Exception as exc:
        logger.error(f"Error inserting STT-2 run for visit {visit_id}: {exc}")
        raise
