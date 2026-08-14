{{ config(alias='ud__teams') }}

with source as (
    select *
    from {{ ref('base__ud__teams') }}
)

, fin as (
    select
        id as team_id,
        abbr,
        dark_image_url,
        icon_url,
        light_image_url,
        lobby_title,
        name as team_name,
        primary_color_dark_mode,
        primary_color_light_mode,
        primary_text_color_dark_mode,
        primary_text_color_light_mode,
        season_record,
        secondary_color_dark_mode,
        secondary_color_light_mode,
        secondary_text_color_dark_mode,
        secondary_text_color_light_mode,
        seed,
        short_name,
        sport_id,
        ingested_at
    from source
)

select * from fin
