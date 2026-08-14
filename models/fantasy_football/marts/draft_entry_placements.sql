with drafts as (
    select distinct
    slate_id,
    draft_id,
    draft_at,
    draft_type,
    entry_count
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

, slates as (
    select *
    from {{ ref('stg__ud__slates') }}
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

, draft_prizes as (
    select
    draft_id
    , max(payout) as first_place_prize
    from entries
    where user_id is not null
    group by 1
)

, fin as (
    select
    -- ID Fields --
    drafts.slate_id
    ,drafts.draft_id
    ,entries.draft_entry_id
    -- Draft Details --
    ,slates.slate_name
    ,slates.slate_season
    ,drafts.draft_at
    ,drafts.draft_type
    ,drafts.entry_count
    ,round_count.picks/drafts.entry_count as round_count
    ,draft_prizes.first_place_prize
    ,case
        when drafts.entry_count = 12 and draft_prizes.first_place_prize = 20 then 3
        when drafts.entry_count = 12 and draft_prizes.first_place_prize = 32 then 5
        when drafts.entry_count = 12 and draft_prizes.first_place_prize = 64 then 10
        when drafts.entry_count = 12 and draft_prizes.first_place_prize = 195 then 25
        end as entry_fee
    -- Entries Details --
    ,entries.place 
    ,entries.payout
    ,entries.pick_order
    ,users.username

    from drafts
    left join entries 
        on entries.draft_id = drafts.draft_id
    left join slates
        on slates.slate_id = drafts.slate_id
    left join users
        on users.user_id = entries.user_id
    left join round_count 
        on round_count.draft_id = drafts.draft_id
    left join draft_prizes
        on draft_prizes.draft_id = drafts.draft_id
)

select * from fin
