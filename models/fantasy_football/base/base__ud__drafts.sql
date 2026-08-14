{{ config(alias='ud__drafts') }}

with source as (
    select
        payload,
        ingested_at
    from {{ source('landing', 'ud_drafts') }}
)

, fin as (
select
    cast(payload->>'id' as text) as id,
    cast(payload->>'clock' as integer) as clock,
    cast(payload->>'contest_style_id' as text) as contest_style_id,
    cast(payload->>'draft_at' as timestamptz) as draft_at,
    cast(payload->>'draft_type' as text) as draft_type,
    cast(payload->>'entry_count' as integer) as entry_count,
    cast(payload->>'entry_role' as text) as entry_role,
    cast(payload->>'entry_style_id' as text) as entry_style_id,
    cast(payload->>'mode' as text) as mode,
    cast(payload->>'salary_budget' as integer) as salary_budget,
    cast(payload->>'slate_id' as text) as slate_id,
    cast(payload->>'source' as text) as source,
    cast(payload->>'status' as text) as status,
    cast(payload->>'title' as text) as title,
    cast(payload->>'user_draft_entry_payout' as numeric) as user_draft_entry_payout,
    cast(payload->>'user_draft_entry_payout_text' as text) as user_draft_entry_payout_text,
    cast(payload->>'user_draft_entry_place' as integer) as user_draft_entry_place,
    cast(payload->>'user_draft_entry_points' as numeric) as user_draft_entry_points,
    cast(ingested_at as timestamptz) as ingested_at
from source
)

select * from fin