{{ config(alias='ud__users') }}

with source as (
    select
        payload,
        ingested_at
    from {{ source('landing', 'ud_users') }}
)

, fin as (
    select
        cast(payload->>'id' as text) as id,
        cast(payload->>'username' as text) as username,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
