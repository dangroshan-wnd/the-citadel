{{ config(
  materialized='table',
  enabled=false
) }}

with draft_10_18 as (
    select
        '10_team_18_round' as draft_style_name,
        *
    from {{ ref('calc__draft_equity_10_18') }} -- coming from a .csv seed
)

, draft_12_18 as (
    select
        '12_team_18_round' as draft_style_name,
        *
    from {{ ref('calc__draft_equity_12_18') }} -- coming from a .csv seed
)

, draft_12_20 as (
    select 
        '12_team_20_round' as draft_style_name,
        *
    from {{ ref('calc__draft_equity_12_20') }} -- coming from a .csv seed
)

, unite as (
select * from draft_10_18
union all 
select * from draft_12_18
union all 
select * from draft_12_20
)

select * from unite