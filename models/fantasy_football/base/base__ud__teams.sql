{{ config(alias='ud__teams') }}

with source as (
    select
        payload,
        ingested_at
    from {{ source('landing', 'ud_teams') }}
)

, fin as (
    select
        cast(payload->>'id' as text) as id,
        cast(payload->>'abbr' as text) as abbr,
        cast(payload->>'dark_image_url' as text) as dark_image_url,
        cast(payload->>'icon_url' as text) as icon_url,
        cast(payload->>'light_image_url' as text) as light_image_url,
        cast(payload->>'lobby_title' as text) as lobby_title,
        cast(payload->>'name' as text) as name,
        cast(payload->>'primary_color_dark_mode' as text) as primary_color_dark_mode,
        cast(payload->>'primary_color_light_mode' as text) as primary_color_light_mode,
        cast(payload->>'primary_text_color_dark_mode' as text) as primary_text_color_dark_mode,
        cast(payload->>'primary_text_color_light_mode' as text) as primary_text_color_light_mode,
        cast(payload->>'season_record' as text) as season_record,
        cast(payload->>'secondary_color_dark_mode' as text) as secondary_color_dark_mode,
        cast(payload->>'secondary_color_light_mode' as text) as secondary_color_light_mode,
        cast(payload->>'secondary_text_color_dark_mode' as text) as secondary_text_color_dark_mode,
        cast(payload->>'secondary_text_color_light_mode' as text) as secondary_text_color_light_mode,
        cast(payload->>'seed' as text) as seed,
        cast(payload->>'short_name' as text) as short_name,
        cast(payload->>'sport_id' as text) as sport_id,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
