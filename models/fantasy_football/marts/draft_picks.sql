with drafts as (
    select distinct
    slate_id
    ,draft_id
    ,draft_at
    ,draft_type
    ,entry_count
    from {{ ref('stg__ud__drafts') }}
)

, entries as (
    select *
    from {{ ref('stg__ud__draft_entries') }}
)

, picks as (
    select *
    from {{ ref('stg__ud__draft_entry_picks') }}
)

, appearances as (
    select *
    from {{ ref('stg__ud__appearances') }}
)

, players as (
    select *
    from {{ ref('stg__ud__players') }}
)

, teams as (
    select *
    from {{ ref('stg__ud__teams') }}
)

, slates as (
    select *
    from {{ ref('stg__ud__slates') }}
)

, bridge_names as (
    select *
    from {{ ref('stg__seed__ud_pfr_name_bridge') }}
)

, users as (
    select *
    from {{ ref('stg__ud__users') }}
)

, round_count as (
    select 
    picks.draft_id
    , max(pick_number) as picks 
    from picks 
    group by 1
)

, fin as (
    select
    -- ID Fields --
    drafts.slate_id
    ,drafts.draft_id
    ,entries.draft_entry_id
    ,picks.pick_id
    ,picks.appearance_id
    ,players.player_id
    ,appearances.team_id
    -- Draft Details --
    ,slates.slate_name
    ,slates.slate_season
    ,slates.is_full_season_slate
    ,drafts.draft_at
    ,drafts.draft_type
    ,drafts.entry_count
    ,round_count.picks/drafts.entry_count as round_count
    -- Entries Details --
    ,entries.place 
    ,entries.payout
    ,entries.pick_order
    -- Pick Details
    ,users.user_id
    ,users.username
    ,picks.pick_created_at
    ,picks.pick_number
    ,1+floor(pick_number/(0.001+entry_count)) as pick_round_number
    ,teams.team_name
    ,players.player_name
    ,bridge_names.player_join_key
    ,players.position_name
    ,picks.projection_adp
    ,picks.projection_points

    from drafts
    left join entries 
        on entries.draft_id = drafts.draft_id
    left join picks 
        on picks.draft_entry_id = entries.draft_entry_id
    left join users
        on users.user_id = entries.user_id
    left join appearances 
        on appearances.appearance_id = picks.appearance_id
    left join players 
        on players.player_id = appearances.player_id 
        and players.slate_id = drafts.slate_id
    left join teams
        on teams.team_id = appearances.team_id
    left join slates
        on slates.slate_id = drafts.slate_id
    left join bridge_names 
        on bridge_names.ud_player = players.player_name
    left join round_count 
        on round_count.draft_id = drafts.draft_id
)

select * from fin