with picks as (
    select *
    from {{ ref('draft_picks') }}
)

, games as (
    select *
    from {{ ref('player_scoring_by_game') }}
    where is_regular_season
    and season >= '2024'
)

, fin as (
select
{{ dbt_utils.generate_surrogate_key(['pick_id', 'week_num']) }} as id
, picks.draft_id
, picks.draft_entry_id
, picks.pick_id
, picks.draft_at
, picks.entry_count
, picks.place
, picks.payout
, picks.pick_order
, picks.username
, picks.pick_number
, picks.team_name
, picks.player_name
, picks.player_join_key
, picks.position_name
, games.season
, games.week_num
, games.game_date
, games.std_scoring_points_total

from picks
left join games 
    on games.player_join_key = picks.player_join_key
    and games.season = picks.slate_season
where draft_entry_id is not null -- excludes where for example Drafts has been scraped but Draft Entries has not
and pick_id is not null -- excludes where for example Draft Entries has been scraped but Draft Entry Picks has not
)

select * from fin

