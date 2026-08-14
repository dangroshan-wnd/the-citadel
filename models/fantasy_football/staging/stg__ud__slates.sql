{{ config(alias='ud__slates') }}

with source as (
    select *
    from {{ ref('base__ud__slates') }}
)

, fin as (
    select
        id as slate_id,
        best_ball,
        contest_style_ids,
        cutoff_at,
        description,
        game_count,
        lobby_hidden,
        rank,
        show_salaries,
        sport_id,
        start_at,
        swap_rankings,
        title as slate_name,
        substring(title from '(20\d{2})') as slate_season,
        case 
            when title like '%Resurrection%' then false 
            when title like '%Weeks%' then false
            else true
            end as is_full_season_slate,
        ingested_at
    from source
)

select * from fin
