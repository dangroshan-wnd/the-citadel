{{
    config(
        alias='data_science_output__scored_lineups',
        materialized='incremental',
        unique_key=['pick_id', 'week_num'],
        incremental_strategy='merge',
    )
}}

with source as (
    select
        payload,
        ingested_at
    from {{ source('landing', 'data_science_output__scored_lineups') }}
    {% if is_incremental() %}
    where ingested_at > (select coalesce(max(ingested_at), '1970-01-01'::timestamptz) from {{ this }})
    {% endif %}
)

, fin as (
    select
        cast(payload->>'draft_entry_id' as text) as draft_entry_id,
        cast(payload->>'pick_id' as text) as pick_id,
        cast(payload->>'season' as text) as season,
        cast(payload->>'position_name' as text) as position_name,
        cast(payload->>'week_num' as integer) as week_num,
        cast(payload->>'std_scoring_points_total' as float) as std_scoring_points_total,
        cast(payload->>'is_in_lineup' as boolean) as is_in_lineup,
        cast(payload->>'lineup_slot' as text) as lineup_slot,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
