{{ config(alias='pfr__players') }}

with source as (
    select
        payload,
        ingested_at
    from {{ source('landing', 'pfr_players') }}
)

, fin as (
    select
        cast(payload->>'name' as text) as name,
        cast(payload->>'url' as text) as url,
        cast(payload->>'position' as text) as position,
        cast(payload->>'from_year' as integer) as from_year,
        cast(payload->>'to_year' as integer) as to_year,
        cast(payload->>'dob' as date) as dob,
        cast(payload->>'height' as text) as height,
        cast(payload->>'weight' as text) as weight,
        cast(payload->>'draft_info' as text) as draft_info,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
