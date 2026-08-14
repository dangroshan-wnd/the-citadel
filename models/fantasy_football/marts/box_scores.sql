with box as (
    select *
    from {{ ref('stg__pfr__box_scores') }}
)

, map as (
    select distinct
        url_abbr,
        box_abbr
    from {{ ref('seed__pfr_team_abbreviation_map') }}
)

, schedule as (
    select *
    from {{ ref('stg__pfr__completed_season_schedules') }}
)

, bridge_names as (
    select *
    from {{ ref('stg__seed__ud_pfr_name_bridge') }}
)

, nfl_teams as (
    select
        team_abbreviation,
        team_name,
        team_name_short,
        pfr_abbreviation
    from {{ ref('map__nfl_teams') }}
)

, pfr_players as (
    select
        player_name,
        max(player_position_name) as player_position_name
    from {{ ref('stg__pfr__players') }}
    group by 1
)

, fin as (
select
schedule.season 
, schedule.week_label
, schedule.week_num
, box.game_date
, box.player as player_name
, coalesce(
    direct_bridge.player_join_key,
    alias_bridge.player_join_key
    ) as player_join_key
, coalesce(
    pfr_players.player_position_name,
    alias_pfr_players.player_position_name
    ) as player_position_name
, CASE
    WHEN lower(box.team) = away.box_abbr then away_team_labels.team_abbreviation
    WHEN lower(box.team) = home.box_abbr then home_team_labels.team_abbreviation
    END as player_team_abbreviation
, CASE
    WHEN lower(box.team) = away.box_abbr then away_team_labels.team_name
    WHEN lower(box.team) = home.box_abbr then home_team_labels.team_name
    END as player_team_name
, CASE
    WHEN lower(box.team) = away.box_abbr then away_team_labels.team_name_short
    WHEN lower(box.team) = home.box_abbr then home_team_labels.team_name_short
    END as player_team_name_short
, CASE
    WHEN lower(box.team) = away.box_abbr then home_team_labels.team_abbreviation
    WHEN lower(box.team) = home.box_abbr then away_team_labels.team_abbreviation
    END as opponent_team_abbreviation
, CASE
    WHEN lower(box.team) = away.box_abbr then home_team_labels.team_name
    WHEN lower(box.team) = home.box_abbr then away_team_labels.team_name
    END as opponent_team_name
, CASE
    WHEN lower(box.team) = away.box_abbr then home_team_labels.team_name_short
    WHEN lower(box.team) = home.box_abbr then away_team_labels.team_name_short
    END as opponent_team_name_short
, box.pass_cmp as pass_completions
, box.pass_att as pass_attempts
, box.pass_yds as pass_yards
, box.pass_td as pass_touchdowns
, box.pass_int as pass_interceptions
, box.rush_att as rush_attempts
, box.rush_yds as rush_yards
, box.rush_td as rush_touchdowns
, box.targets as receiving_targets
, box.rec as receptions
, box.rec_yds as receiving_yards
, box.rec_td as receiving_touchdowns
, coalesce(box.rush_yds, 0) + coalesce(box.rec_yds, 0) as scrimmage_yards
, coalesce(box.rush_td, 0) + coalesce(box.rec_td, 0) as scrimmage_touchdowns
, box.fumbles
, box.fumbles_lost
, CASE 
    WHEN lower(box.team) = away.box_abbr then false
    WHEN lower(box.team) = home.box_abbr then true
    END as is_home_team
, CASE
    WHEN schedule.week_num <= 18 then true
    ELSE false 
    END as is_regular_season

from schedule
left join map home on home.url_abbr = schedule.home_abv
left join map away on away.url_abbr = schedule.away_abv
left join box 
    on (lower(box.team) = away.box_abbr or lower(box.team) = home.box_abbr)
    and box.game_date = schedule.game_date
left join pfr_players on pfr_players.player_name = box.player
left join bridge_names direct_bridge
    on direct_bridge.pfr_player = box.player
left join bridge_names alias_bridge
    on alias_bridge.ud_player = box.player
left join pfr_players alias_pfr_players
    on alias_pfr_players.player_name = alias_bridge.pfr_player
    and pfr_players.player_position_name is null
left join nfl_teams home_team_labels
    on lower(home_team_labels.pfr_abbreviation) = lower(schedule.home_abv)
left join nfl_teams away_team_labels
    on lower(away_team_labels.pfr_abbreviation) = lower(schedule.away_abv)

where schedule.season >= '2022'
)

select
    {{ dbt_utils.generate_surrogate_key(['season', 'week_label', 'week_num', 'player_name']) }} as id
    , *
from fin
