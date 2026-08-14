{{ config(alias='ud__appearances') }}

with source as (
    select
        payload,
        slate_id,
        ingested_at
    from {{ source('landing', 'ud_appearances') }}
)

, fin as (
    select
        cast(payload->>'id' as text) as id,
        cast(payload->>'latest_news_item_updated_at' as timestamptz) as latest_news_item_updated_at,
        cast(payload->>'lineup_status_id' as text) as lineup_status_id,
        cast(payload->>'match_id' as text) as match_id,
        cast(payload->>'match_type' as text) as match_type,
        cast(payload->>'player_id' as text) as player_id,
        cast(payload->>'position_id' as text) as position_id,
        cast(
            nullif(
                nullif(
                    case
                        when jsonb_typeof(payload->'score') = 'object'
                            then payload->'score'->>'points'
                        else payload->>'score'
                    end,
                    ''
                ),
                '-'
            ) as numeric
        ) as score,
        cast(payload->>'team_id' as text) as team_id,
        cast(payload->'projection'->>'id' as text) as projection_id,
        cast(nullif(nullif(payload->'projection'->>'adp', ''), '-') as numeric) as adp,
        cast(nullif(nullif(payload->'projection'->>'avg_weekly_points', ''), '-') as numeric) as avg_weekly_points,
        cast(nullif(nullif(payload->'projection'->>'points', ''), '-') as numeric) as points,
        cast(payload->'projection'->>'position_rank' as text) as position_rank,
        cast(payload->'projection'->>'scoring_type_id' as text) as scoring_type_id,
        cast(slate_id as text) as slate_id,
        cast(ingested_at as timestamptz) as ingested_at
    from source
)

select * from fin
