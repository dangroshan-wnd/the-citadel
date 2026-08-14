with source as (
    select *
    from {{ ref('seed__exposure_target_ranges') }}
)

, fin as (
    select
        cast(exposure_season as text) as exposure_season,
        cast(exposure_group as text) as exposure_group,
        cast(exposure_floor as numeric) as exposure_floor
    from source
)

select * from fin
