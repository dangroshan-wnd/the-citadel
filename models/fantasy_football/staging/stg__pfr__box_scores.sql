{{ config(alias='pfr__box_scores') }}

with source as (
    select *
    from {{ ref('base__pfr__box_scores') }}
)

, fin as (
    select
        game_id,
        player,
        team,
        date as game_date_long,
        to_date(date, 'FMDay Mon DD, YYYY') as game_date,
        pass_cmp,
        pass_att,
        pass_yds,
        pass_td,
        pass_int,
        rush_att,
        rush_yds,
        rush_td,
        targets,
        rec,
        rec_yds,
        rec_td,
        fumbles,
        fumbles_lost,
        ingested_at
    from source
    where player not in ('Player', '0')
)

select * from fin
