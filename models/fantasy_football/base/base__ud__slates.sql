{{ config(alias='ud__slates') }}

with source as (
    select
        payload,
        ingested_at
    from {{ source('landing', 'ud_slates') }}
)

, fin as (
    select
        cast(payload->>'id' as text) as id,
        cast(payload->>'best_ball' as boolean) as best_ball,
        cast(payload->'contest_style_ids' as jsonb) as contest_style_ids,
        cast(payload->>'cutoff_at' as timestamptz) as cutoff_at,
        cast(payload->>'description' as text) as description,
        cast(payload->>'game_count' as integer) as game_count,
        cast(payload->>'lobby_hidden' as boolean) as lobby_hidden,
        cast(payload->>'rank' as integer) as rank,
        cast(payload->>'show_salaries' as boolean) as show_salaries,
        cast(payload->>'sport_id' as text) as sport_id,
        cast(payload->>'start_at' as timestamptz) as start_at,
        cast(payload->>'swap_rankings' as boolean) as swap_rankings,
        cast(payload->>'title' as text) as title,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
