{{ config(
  materialized='table'
) }}

with source as (
    select *
    from {{ ref('base__data_science_output__scored_lineups') }}
)

, fin as (
select
{{ dbt_utils.generate_surrogate_key(['pick_id', 'week_num']) }} as id
, draft_entry_id
, pick_id
, season
, position_name
, week_num
, std_scoring_points_total
, is_in_lineup
, lineup_slot

from source
)

select * from fin
