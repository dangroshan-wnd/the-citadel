{{ config(alias='ud__draft_entries') }}

with source as (
    select
        payload,
        draft_id,
        ingested_at
    from {{ source('landing', 'ud_draft_entries') }}
)

, fin as (
    select
        cast(payload->>'id' as text) as id,
        cast(payload->>'auto_pick' as text) as auto_pick,
        cast(payload->>'payout' as numeric) as payout,
        cast(payload->>'payout_text' as text) as payout_text,
        cast(payload->>'pick_order' as integer) as pick_order,
        cast(payload->>'place' as integer) as place,
        cast(payload->>'points' as numeric) as points,
        cast(payload->>'share_link' as text) as share_link,
        cast(payload->>'title' as text) as title,
        cast(payload->>'user_id' as text) as user_id,
        cast(draft_id as text) as draft_id,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
