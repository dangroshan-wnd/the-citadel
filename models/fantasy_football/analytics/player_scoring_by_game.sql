with box_scores as (
    select *
    from {{ ref('box_scores') }}
)

, std_scoring as (
select 
0.04 as std_scoring_pass_yds
, 4 as std_scoring_pass_td
, -1 as std_scoring_pass_int
, 0.1 as std_scoring_rush_yds
, 6 as std_scoring_rush_td
, 0.5 as std_scoring_rec
, 0.1 as std_scoring_rec_yds
, 6 as std_scoring_rec_td
, -2 as std_scoring_fumbles_lost
)

, score as (
select 
box.season 
, box.week_label
, box.week_num
, box.is_regular_season
, box.is_home_team
, box.game_date
, box.player_name
, box.player_join_key
, box.player_position_name
, box.player_team_abbreviation
, box.player_team_name
, box.player_team_name_short
, box.opponent_team_abbreviation
, box.opponent_team_name
, box.opponent_team_name_short
, box.pass_completions
, box.pass_attempts
, box.pass_yards
, box.pass_touchdowns
, box.pass_interceptions
, box.rush_attempts
, box.rush_yards
, box.rush_touchdowns
, box.receiving_targets
, box.receptions
, box.receiving_yards
, box.receiving_touchdowns
, box.scrimmage_yards
, box.scrimmage_touchdowns
, box.fumbles
, box.fumbles_lost
-- Standard Scoring --
, std.std_scoring_pass_yds
, std.std_scoring_pass_td
, std.std_scoring_pass_int
, std.std_scoring_rush_yds
, std.std_scoring_rush_td
, std.std_scoring_rec
, std.std_scoring_rec_yds
, std.std_scoring_rec_td
, std.std_scoring_fumbles_lost

from box_scores box
cross join std_scoring std 
)

, calculate as (
select
score.season 
, score.week_label
, score.week_num
, score.is_regular_season
, score.is_home_team
, score.game_date
, score.player_name
, score.player_join_key
, score.player_position_name
, score.player_team_abbreviation
, score.player_team_name
, score.player_team_name_short
, score.opponent_team_abbreviation
, score.opponent_team_name
, score.opponent_team_name_short
, score.pass_completions
, score.pass_attempts
, score.pass_yards
, score.pass_touchdowns
, score.pass_interceptions
, score.rush_attempts
, score.rush_yards
, score.rush_touchdowns
, score.receiving_targets
, score.receptions
, score.receiving_yards
, score.receiving_touchdowns
, score.scrimmage_yards
, score.scrimmage_touchdowns
, score.fumbles
, score.fumbles_lost
-- Standard Scoring --
, coalesce(score.std_scoring_pass_yds*score.pass_yards,0) as std_scoring_points_pass_yds
, coalesce(score.std_scoring_pass_td*score.pass_touchdowns,0) as std_scoring_points_pass_td
, coalesce(score.std_scoring_pass_int*score.pass_interceptions,0) as std_scoring_points_pass_int
, coalesce(score.std_scoring_rush_yds*score.rush_yards,0) as std_scoring_points_rush_yds
, coalesce(score.std_scoring_rush_td*score.rush_touchdowns,0) as std_scoring_points_rush_td
, coalesce(score.std_scoring_rec*score.receptions,0) as std_scoring_points_rec
, coalesce(score.std_scoring_rec_yds*score.receiving_yards,0) as std_scoring_points_rec_yds
, coalesce(score.std_scoring_rec_td*score.receiving_touchdowns,0) as std_scoring_points_rec_td
, coalesce(score.std_scoring_fumbles_lost*score.fumbles_lost,0) as std_scoring_points_fumbles_lost

from score
)

, fin as (
select
calc.season 
, calc.week_label
, calc.week_num
, calc.is_regular_season
, calc.is_home_team
, calc.game_date
, calc.player_name
, calc.player_join_key
, calc.player_position_name
, calc.player_team_abbreviation
, calc.player_team_name
, calc.player_team_name_short
, calc.opponent_team_abbreviation
, calc.opponent_team_name
, calc.opponent_team_name_short
, calc.pass_completions
, calc.pass_attempts
, calc.pass_yards
, calc.pass_touchdowns
, calc.pass_interceptions
, calc.rush_attempts
, calc.rush_yards
, calc.rush_touchdowns
, calc.receiving_targets
, calc.receptions
, calc.receiving_yards
, calc.receiving_touchdowns
, calc.scrimmage_yards
, calc.scrimmage_touchdowns
, calc.fumbles
, calc.fumbles_lost
-- Standard Scoring --
, calc.std_scoring_points_pass_yds
, calc.std_scoring_points_pass_td
, calc.std_scoring_points_pass_int
, calc.std_scoring_points_rush_yds
, calc.std_scoring_points_rush_td
, calc.std_scoring_points_rec
, calc.std_scoring_points_rec_yds
, calc.std_scoring_points_rec_td
, calc.std_scoring_points_fumbles_lost
, (calc.std_scoring_points_pass_yds + calc.std_scoring_points_pass_td + calc.std_scoring_points_pass_int + calc.std_scoring_points_rush_yds + calc.std_scoring_points_rush_td + calc.std_scoring_points_rec + calc.std_scoring_points_rec_yds + calc.std_scoring_points_rec_td + calc.std_scoring_points_fumbles_lost) as std_scoring_points_total

from calculate calc
)

select * from fin
