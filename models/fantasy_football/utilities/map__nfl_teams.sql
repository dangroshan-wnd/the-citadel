with underdog as (
select
abbr
, team_name
, short_name
from {{ ref('stg__ud__teams') }}
)

, pfr as (
select
team_name
, pfr_abbr
from {{ ref('stg__pfr__active_teams') }}
where is_active
)

, final as (
select 
underdog.abbr as team_abbreviation
, underdog.team_name as team_name
, underdog.short_name as team_name_short
, underdog.abbr as ud_abbreviation
, underdog.team_name as ud_team_name
, underdog.short_name as ud_team_name_short
, pfr_abbr as pfr_abbreviation
, pfr.team_name as pfr_team_name_short
 
 from underdog 
 left join pfr
        on lower(pfr.pfr_abbr) = lower(underdog.abbr)
        or lower(underdog.team_name) = lower(pfr.team_name)
)

select * from final