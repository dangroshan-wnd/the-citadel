{{ config(alias='pfr__box_scores') }}

with source as (
    select
        payload,
        game_id,
        ingested_at
    from {{ source('landing', 'pfr_box_scores') }}
)

, fin as (
    select
        cast(game_id as text) as game_id,
        cast(payload->>'player' as text) as player,
        cast(payload->>'team' as text) as team,
        cast(payload->>'date' as text) as date,
        cast(payload->>'pass_cmp' as integer) as pass_cmp,
        cast(payload->>'pass_att' as integer) as pass_att,
        cast(payload->>'pass_yds' as integer) as pass_yds,
        cast(payload->>'pass_td' as integer) as pass_td,
        cast(payload->>'pass_int' as integer) as pass_int,
        cast(payload->>'rush_att' as integer) as rush_att,
        cast(payload->>'rush_yds' as integer) as rush_yds,
        cast(payload->>'rush_td' as integer) as rush_td,
        cast(payload->>'targets' as integer) as targets,
        cast(payload->>'rec' as integer) as rec,
        cast(payload->>'rec_yds' as integer) as rec_yds,
        cast(payload->>'rec_td' as integer) as rec_td,
        cast(payload->>'fumbles' as integer) as fumbles,
        cast(payload->>'fumbles_lost' as integer) as fumbles_lost,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
