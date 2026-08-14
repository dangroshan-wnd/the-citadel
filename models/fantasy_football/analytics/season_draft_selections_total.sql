with draft_picks as (
select *
from {{ ref('draft_picks') }}
where is_full_season_slate 
and entry_count = 12
and projection_adp is not null
)

, draft_count as (
select
username
, slate_season
, count(distinct draft_id) as total_drafts
from draft_picks
where username = 'DGRO18'
group by 1,2
)

, final_adp as (
select 
draft_picks.slate_season
, draft_picks.player_id 
, draft_picks.player_name 
, draft_picks.projection_adp
, x.max_player_drafted_ts
from draft_picks
join (select slate_season, player_name, max(draft_at) as max_player_drafted_ts from draft_picks group by 1,2) x 
        on x.max_player_drafted_ts = draft_picks.draft_at
        and x.player_name = draft_picks.player_name
)

, exposure_targets as (
select
player_targets.exposure_season
, player_targets.player_id
, player_targets.exposure_group
, target_ranges.exposure_floor
from {{ ref('base__seed__player_exposure_targets') }} player_targets
left join {{ ref('base__seed__exposure_target_ranges') }} target_ranges
        on target_ranges.exposure_season = player_targets.exposure_season
        and target_ranges.exposure_group = player_targets.exposure_group
)

, pre as (
select
draft_picks.username
, draft_picks.slate_season
, draft_picks.is_full_season_slate 
, draft_picks.entry_count 
, draft_picks.player_name 
, draft_picks.position_name 
, draft_picks.team_name
, final_adp.projection_adp as final_adp
, draft_count.total_drafts
, exposure_targets.exposure_group
, exposure_targets.exposure_floor
, avg(draft_picks.pick_number) as personal_adp
, avg(draft_picks.pick_round_number) as personal_avg_pick_round_number
, count(distinct draft_picks.draft_id) as drafts_selected

from draft_picks
left join draft_count on draft_count.username = draft_picks.username and draft_count.slate_season = draft_picks.slate_season
left join final_adp on final_adp.player_id = draft_picks.player_id and final_adp.slate_season = draft_picks.slate_season
left join exposure_targets on exposure_targets.player_id = draft_picks.player_id and exposure_targets.exposure_season = draft_picks.slate_season
where draft_picks.username = 'DGRO18'

group by 1,2,3,4,5,6,7,8,9,10,11
)

, fin as (
select
pre.username
, pre.slate_season
, pre.is_full_season_slate 
, pre.entry_count 
, pre.player_name 
, pre.position_name 
, pre.team_name
, round(pre.personal_avg_pick_round_number::numeric, 2) as personal_avg_pick_round_number
, round(pre.personal_adp::numeric, 2) as personal_adp
, pre.final_adp
, pre.drafts_selected
, pre.total_drafts
, round((pre.drafts_selected::numeric / pre.total_drafts), 4) as exposure_percentage
, pre.exposure_group
, pre.exposure_floor
, round(
    (pre.drafts_selected::numeric / pre.total_drafts) - pre.exposure_floor,
    4
  ) as exposure_gap

from pre
)

select * from fin
