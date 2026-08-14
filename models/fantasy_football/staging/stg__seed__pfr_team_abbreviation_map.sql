{{ config(alias='seed__pfr_team_abbreviation_map') }}

with source as (
    select *
    from {{ ref('base__seed__pfr_team_abbreviation_map') }}
)

, fin as (
    select
        team_name,
        url_abv,
        box_abv
    from source
)

select * from fin
