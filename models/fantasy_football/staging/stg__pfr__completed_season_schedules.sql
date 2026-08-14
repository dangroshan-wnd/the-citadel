{{ config(alias='pfr__completed_season_schedules') }}

with source as (
    select *
    from {{ ref('base__pfr__completed_season_schedules') }}
)

, fin as (
    select
        game_id,
        season,
        week as week_label,
        case
            when week ~ '^[0-9]+$' then cast(week as integer)
        end as week_num,
        date as game_date,
        home_team,
        case
            when home_team = 'Washington Football Team' then 'was'
            else home_abbr
        end as home_abv,
        away_team,
        case
            when away_team = 'Washington Football Team' then 'was'
            else away_abbr
        end as away_abv,
        boxscore_url,
        winner,
        loser,
        ingested_at
    from source
)

select * from fin
