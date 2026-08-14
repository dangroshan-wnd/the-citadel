{{ config(alias='ud__draft_entries') }}

with source as (
    select *
    from {{ ref('base__ud__draft_entries') }}
)

, fin as (
    select
        id as draft_entry_id,
        draft_id,
        user_id,
        auto_pick as entry_auto_pick,
        pick_order,
        place,
        points as entry_points,
        payout,
        payout_text,
        share_link,
        title as entry_title,
        ingested_at
    from source
)

select * from fin
