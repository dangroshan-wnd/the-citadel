{{ config(alias='ud__users') }}

with source as (
    select *
    from {{ ref('base__ud__users') }}
)

, fin as (
    select
        id as user_id,
        username,
        ingested_at
    from source
)

select * from fin
