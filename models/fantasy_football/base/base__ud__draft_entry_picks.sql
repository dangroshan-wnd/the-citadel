{{ config(alias='ud__draft_entry_picks') }}

with source as (
    select
        payload,
        draft_id,
        ingested_at
    from {{ source('landing', 'ud_draft_entry_picks') }}
)

, fin as (
    select
        cast(payload->>'id' as text) as id,
        cast(payload->>'appearance_id' as text) as appearance_id,
        cast(payload->>'created_at' as timestamptz) as created_at,
        cast(payload->>'draft_entry_id' as text) as draft_entry_id,
        cast(payload->>'drafted_percentage' as numeric) as drafted_percentage,
        cast(payload->>'number' as integer) as number,
        cast(payload->>'pick_slot_id' as text) as pick_slot_id,
        cast(payload->>'points' as numeric) as points,
        case when payload->>'projection_adp' = '-' then null else cast(payload->>'projection_adp' as numeric) end as projection_adp,
        cast(payload->>'projection_average' as numeric) as projection_average,
        cast(payload->>'projection_points' as numeric) as projection_points,
        cast(payload->>'salary' as numeric) as salary,
        cast(payload->>'swapped' as boolean) as swapped,
        cast(draft_id as text) as draft_id,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
