{{ config(alias='ud__drafts') }}

with source as (
    select *
    from {{ ref('base__ud__drafts') }}
)

, fin as (
    select
        id as draft_id,
        clock,
        contest_style_id,
        draft_at,
        draft_type,
        entry_count,
        entry_role,
        entry_style_id,
        mode,
        salary_budget,
        slate_id,
        source,
        status,
        title,
        user_draft_entry_payout,
        user_draft_entry_payout_text,
        user_draft_entry_place,
        user_draft_entry_points,
        ingested_at
    from source
)

select * from fin
