{{ config(
  materialized='table'
) }}

with source as (
    select *
    from {{ ref('base__data_science_output__player_cohorts') }}
)

, fin as (
select
{{ dbt_utils.generate_surrogate_key([
    'slate_season',
    'user_id',
    'entry_count',
    'cohort_size',
    'round_scope',
    'round_cutoff',
    'cohort_key',
]) }} as id
, slate_season
, user_id
, username
, entry_count
, cohort_size
, round_scope
, round_cutoff
, cohort_key
, player_ids
, array_to_string(player_names, '|') as player_names
, array_to_string(positions, '|') as positions
, array_to_string(nfl_teams, '|') as nfl_teams
, draft_ids
, draft_count
, total_drafts
, exposure_percent

from source
)

select * from fin
