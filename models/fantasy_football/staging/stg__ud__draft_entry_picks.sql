{{ config(alias='ud__draft_entry_picks') }}

with source as (
    select *
    from {{ ref('base__ud__draft_entry_picks') }}
)

, fin as (
    select
        id as pick_id,
        draft_id,
        draft_entry_id,
        appearance_id,
        created_at as pick_created_at,
        number as pick_number,
        pick_slot_id,
        points as pick_points,
        projection_adp,
        projection_average,
        projection_points,
        drafted_percentage,
        salary,
        swapped,
        ingested_at
    from source
)

select * from fin
