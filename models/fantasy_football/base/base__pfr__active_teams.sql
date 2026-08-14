{{ config(alias='pfr__active_teams') }}

with source as (
    select
        payload,
        ingested_at
    from {{ source('landing', 'pfr_active_teams') }}
)

, fin as (
    select
        cast(payload->>'team_name' as text) as team_name,
        cast(payload->>'pfr_abbr' as text) as pfr_abbr,
        cast(payload->>'url_slug' as text) as url_slug,
        cast(payload->>'full_name' as text) as full_name,
        cast(payload->>'first_season' as integer) as first_season,
        cast(payload->>'last_season' as integer) as last_season,
        cast(payload->>'is_active' as boolean) as is_active,
        cast(payload->>'wins' as integer) as wins,
        cast(payload->>'losses' as integer) as losses,
        cast(payload->>'ties' as integer) as ties,
        cast(payload->>'av' as text) as av,
        cast(payload->>'passer' as text) as passer,
        cast(payload->>'rusher' as text) as rusher,
        cast(payload->>'receiver' as text) as receiver,
        cast(payload->>'coaching' as text) as coaching,
        cast(payload->>'playoff_yrs' as integer) as playoff_yrs,
        cast(payload->>'playoff_wins' as integer) as playoff_wins,
        cast(payload->>'playoff_losses' as integer) as playoff_losses,
        cast(payload->>'championships' as integer) as championships,
        cast(payload->>'super_bowls' as integer) as super_bowls,
        cast(payload->>'conf_titles' as integer) as conf_titles,
        cast(payload->>'div_titles' as integer) as div_titles,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
