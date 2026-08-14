{{ config(alias='pfr__completed_season_schedules') }}

with source as (
    select
        payload,
        game_id,
        ingested_at
    from {{ source('landing', 'pfr_completed_season_schedules') }}
)

, fin as (
    select
        cast(game_id as text) as game_id,
        cast(payload->>'season' as text) as season,
        cast(payload->>'week' as text) as week,
        to_date(payload->>'date', 'YYYYMMDD') as date,
        cast(payload->>'home_team' as text) as home_team,
        cast(payload->>'home_abbr' as text) as home_abbr,
        cast(payload->>'away_team' as text) as away_team,
        cast(payload->>'away_abbr' as text) as away_abbr,
        cast(payload->>'boxscore_url' as text) as boxscore_url,
        cast(payload->>'winner' as text) as winner,
        cast(payload->>'loser' as text) as loser,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
