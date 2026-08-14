with source as (
    select *
    from {{ ref('seed__player_exposure_targets') }}
)

, fin as (
    select
        cast(exposure_season as text) as exposure_season,
        cast(player_id as text) as player_id,
        cast(player_name as text) as player_name,
        cast(exposure_group as text) as exposure_group
    from source
)

select * from fin
