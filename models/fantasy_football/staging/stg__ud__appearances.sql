{{ config(alias='ud__appearances') }}

with source as (
    select *
    from {{ ref('base__ud__appearances') }}
)

, fin as (
    select
        id as appearance_id,
        latest_news_item_updated_at,
        lineup_status_id,
        match_id,
        match_type,
        player_id,
        position_id,
        score,
        team_id,
        projection_id,
        adp,
        avg_weekly_points,
        points,
        position_rank,
        scoring_type_id,
        slate_id,
        ingested_at
    from source
)

select * from fin
