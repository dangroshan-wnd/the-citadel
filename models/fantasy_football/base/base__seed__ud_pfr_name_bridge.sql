with source as (
    select *
    from {{ ref('seed__ud_pfr_name_bridge') }} -- coming from a .csv seed
)

, prep as (
    select
    cast(replace(player_name,'"','') as TEXT) as player_name
    ,cast(replace(player,'"','') as TEXT) as player
    ,cast(key as TEXT) as key

    from source
)

, fin as (
    select
    player_name as ud_player 
    , player as pfr_player 
    , key as player_join_key

    from prep
)

select * from fin