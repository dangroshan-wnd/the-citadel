with source as (
    select *
    from {{ ref('seed__pfr_team_abbreviation_map') }}
)

, prep as (
    select
        cast(team_name as text) as team_name,
        cast(url_abbr as text) as url_abbr,
        cast(box_abbr as text) as box_abbr
    from source
)

, fin as (
    select
        team_name,
        url_abbr as url_abv,
        box_abbr as box_abv
    from prep
)

select * from fin
