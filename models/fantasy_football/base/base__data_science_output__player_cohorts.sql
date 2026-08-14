{{
    config(
        alias='data_science_output__player_cohorts',
        materialized='table',
    )
}}

with source as (
    select
        payload,
        ingested_at
    from {{ source('landing', 'data_science_output__player_cohorts') }}
)

, fin as (
    select
        cast(payload->>'slate_season' as text) as slate_season,
        cast(payload->>'user_id' as text) as user_id,
        cast(payload->>'username' as text) as username,
        cast(payload->>'entry_count' as integer) as entry_count,
        cast(payload->>'cohort_size' as integer) as cohort_size,
        cast(payload->>'round_scope' as text) as round_scope,
        cast(payload->>'round_cutoff' as integer) as round_cutoff,
        cast(payload->>'cohort_key' as text) as cohort_key,
        array(
            select jsonb_array_elements_text(payload->'player_ids')
        ) as player_ids,
        array(
            select jsonb_array_elements_text(payload->'player_names')
        ) as player_names,
        array(
            select jsonb_array_elements_text(payload->'positions')
        ) as positions,
        array(
            select jsonb_array_elements_text(payload->'nfl_teams')
        ) as nfl_teams,
        array(
            select jsonb_array_elements_text(payload->'draft_ids')
        ) as draft_ids,
        cast(payload->>'draft_count' as integer) as draft_count,
        cast(payload->>'total_drafts' as integer) as total_drafts,
        cast(payload->>'exposure_percent' as numeric) as exposure_percent,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
