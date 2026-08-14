{{ config(alias='seed__ud_pfr_name_bridge') }}

with source as (
    select *
    from {{ ref('base__seed__ud_pfr_name_bridge') }}
)

, fin as (
    select
        ud_player,
        pfr_player,
        player_join_key
    from source
)

select * from fin
