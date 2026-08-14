{{ config(alias='ud__players') }}

with source as (
    select
        payload,
        slate_id,
        ingested_at
    from {{ source('landing', 'ud_players') }}
)

, fin as (
    select
        cast(payload->>'id' as text) as id,
        cast(payload->>'action_path' as text) as action_path,
        cast(payload->>'country' as text) as country,
        cast(payload->>'dark_image_url' as text) as dark_image_url,
        cast(payload->>'first_name' as text) as first_name,
        cast(payload->>'image_url' as text) as image_url,
        cast(payload->>'jersey_number' as text) as jersey_number,
        cast(payload->>'last_name' as text) as last_name,
        cast(payload->>'light_image_url' as text) as light_image_url,
        cast(payload->>'position_display_name' as text) as position_display_name,
        cast(payload->>'position_id' as text) as position_id,
        cast(payload->>'position_name' as text) as position_name,
        cast(payload->>'sport_id' as text) as sport_id,
        cast(payload->>'team_id' as text) as team_id,
        cast(slate_id as text) as slate_id,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
