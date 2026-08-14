{{ config(alias='pfr__active_teams') }}

with source as (
    select *
    from {{ ref('base__pfr__active_teams') }}
)

, fin as (
    select
        team_name,
        pfr_abbr,
        url_slug,
        full_name,
        first_season,
        last_season,
        is_active,
        wins,
        losses,
        ties,
        av,
        passer,
        rusher,
        receiver,
        coaching,
        playoff_yrs,
        playoff_wins,
        playoff_losses,
        championships,
        super_bowls,
        conf_titles,
        div_titles,
        ingested_at
    from source
)

select * from fin
