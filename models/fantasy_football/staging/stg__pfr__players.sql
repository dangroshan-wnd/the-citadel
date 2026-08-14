{{ config(alias='pfr__players') }}

with source as (
    select *
    from {{ ref('base__pfr__players') }}
)

, fin as (
    select
        name as player_name,
        url as player_url,
        position as player_position_name,
        from_year,
        to_year,
        dob,
        height,
        weight,
        draft_info,
        ingested_at
    from source
)

select * from fin
