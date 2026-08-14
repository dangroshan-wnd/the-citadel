-- Used for exporting to G Sheets when preparing Rankings
-- Current Rankings loc: https://docs.google.com/spreadsheets/d/1u6FeJIl6N9Y4BdiZRHx1rU4GyZ7xdn7K2QXvfyGfmEw/edit?gid=0#gid=0

with players as (
select
position_name, id, player_name, slate_id, team_id
from core.players
where slate_id like '%2'
and team_id is not null
)

, drafts as (
select appearance_id, max(created_at) as freshness
from core.drafts
group by 1
)

, appearances as (
select *
from core.appearances
)

, combine as (
select
freshness
, position_name
, player_id
, player_name
, adp
from appearances
left join drafts on drafts.appearance_id = appearances.id
left join players on players.id = cast(appearances.player_id as TEXT)
)

, fin as (
select
combine.position_name
, combine.player_id
, combine.player_name
, combine.adp
from combine 
join (select player_id, max(freshness) as maxx from combine group by 1) x on x.player_id = combine.player_id and x.maxx = combine.freshness
)

select * 
from fin 
where position_name = 'WR' 
and adp is not null

