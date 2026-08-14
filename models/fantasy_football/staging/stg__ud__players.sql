{{ config(alias='ud__players') }}

with source as (
    select *
    from {{ ref('base__ud__players') }}
)

, fin as (
    select
        id as player_id,
        action_path,
        country,
        dark_image_url,
        first_name,
        image_url,
        jersey_number,
        last_name,
        first_name || ' ' || last_name as player_name,
        light_image_url,
        position_display_name,
        position_id,
        position_name,
        sport_id,
        team_id,
        slate_id,
        ingested_at
    from source
)

select * from fin
