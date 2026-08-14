{{ config(alias='agent_app__query_logs') }}

with source as (
    select
        payload
    from {{ source('landing', 'agent_app_query_logs') }}
)

, fin as (
    select
        cast(payload->>'timestamp_utc' as timestamptz) as timestamp_utc,
        cast(
            coalesce(
                payload->>'query_id',
                payload->'metadata'->>'query_id'
            )
            as text
        ) as query_id,
        cast(payload->>'question' as text) as question,
        cast(payload->>'success' as boolean) as success,
        cast(payload->>'row_count' as integer) as row_count,
        cast(payload->>'answer' as text) as answer,
        cast(payload->>'error_message' as text) as error_message,
        cast(payload->>'user_feedback' as text) as user_feedback,
        cast(payload->>'user_acceptance' as boolean) as user_acceptance,
        cast(payload->>'input_tokens' as integer) as input_tokens,
        cast(payload->>'output_tokens' as integer) as output_tokens,
        cast(payload->>'total_tokens' as integer) as total_tokens,
        payload->'token_usage_by_stage' as token_usage_by_stage,
        cast(
            payload->'token_usage_by_stage'->'planning'->>'input_tokens'
            as integer
        ) as planning_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->>'cached_input_tokens'
            as integer
        ) as planning_cached_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->>'cache_write_input_tokens'
            as integer
        ) as planning_cache_write_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->>'uncached_input_tokens'
            as integer
        ) as planning_uncached_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->>'output_tokens'
            as integer
        ) as planning_output_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->>'reasoning_tokens'
            as integer
        ) as planning_reasoning_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->>'visible_output_tokens'
            as integer
        ) as planning_visible_output_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->>'total_tokens'
            as integer
        ) as planning_total_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->>'response_id'
            as text
        ) as planning_response_id,
        cast(
            payload->'token_usage_by_stage'->'planning'->>'model'
            as text
        ) as planning_model,
        cast(
            payload->'token_usage_by_stage'->'planning'->>'service_tier'
            as text
        ) as planning_service_tier,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'metric_routing'->>'input_tokens'
            as integer
        ) as metric_routing_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'metric_routing'->>'cached_input_tokens'
            as integer
        ) as metric_routing_cached_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'metric_routing'->>'cache_write_input_tokens'
            as integer
        ) as metric_routing_cache_write_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'metric_routing'->>'uncached_input_tokens'
            as integer
        ) as metric_routing_uncached_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'metric_routing'->>'output_tokens'
            as integer
        ) as metric_routing_output_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'metric_routing'->>'reasoning_tokens'
            as integer
        ) as metric_routing_reasoning_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'metric_routing'->>'visible_output_tokens'
            as integer
        ) as metric_routing_visible_output_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'metric_routing'->>'total_tokens'
            as integer
        ) as metric_routing_total_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'metric_routing'->>'response_id'
            as text
        ) as metric_routing_response_id,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'metric_routing'->>'model'
            as text
        ) as metric_routing_model,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'metric_routing'->>'service_tier'
            as text
        ) as metric_routing_service_tier,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'query_planning'->>'input_tokens'
            as integer
        ) as query_planning_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'query_planning'->>'cached_input_tokens'
            as integer
        ) as query_planning_cached_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'query_planning'->>'cache_write_input_tokens'
            as integer
        ) as query_planning_cache_write_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'query_planning'->>'uncached_input_tokens'
            as integer
        ) as query_planning_uncached_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'query_planning'->>'output_tokens'
            as integer
        ) as query_planning_output_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'query_planning'->>'reasoning_tokens'
            as integer
        ) as query_planning_reasoning_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'query_planning'->>'visible_output_tokens'
            as integer
        ) as query_planning_visible_output_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'query_planning'->>'total_tokens'
            as integer
        ) as query_planning_total_tokens,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'query_planning'->>'response_id'
            as text
        ) as query_planning_response_id,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'query_planning'->>'model'
            as text
        ) as query_planning_model,
        cast(
            payload->'token_usage_by_stage'->'planning'->'substage_usage'
                ->'query_planning'->>'service_tier'
            as text
        ) as query_planning_service_tier,
        cast(
            payload->'token_usage_by_stage'->'summarization'->>'input_tokens'
            as integer
        ) as summarization_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'summarization'->>'cached_input_tokens'
            as integer
        ) as summarization_cached_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'summarization'->>'cache_write_input_tokens'
            as integer
        ) as summarization_cache_write_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'summarization'->>'uncached_input_tokens'
            as integer
        ) as summarization_uncached_input_tokens,
        cast(
            payload->'token_usage_by_stage'->'summarization'->>'output_tokens'
            as integer
        ) as summarization_output_tokens,
        cast(
            payload->'token_usage_by_stage'->'summarization'->>'reasoning_tokens'
            as integer
        ) as summarization_reasoning_tokens,
        cast(
            payload->'token_usage_by_stage'->'summarization'->>'visible_output_tokens'
            as integer
        ) as summarization_visible_output_tokens,
        cast(
            payload->'token_usage_by_stage'->'summarization'->>'total_tokens'
            as integer
        ) as summarization_total_tokens,
        cast(
            payload->'token_usage_by_stage'->'summarization'->>'response_id'
            as text
        ) as summarization_response_id,
        cast(
            payload->'token_usage_by_stage'->'summarization'->>'model'
            as text
        ) as summarization_model,
        cast(
            payload->'token_usage_by_stage'->'summarization'->>'service_tier'
            as text
        ) as summarization_service_tier,
        cast(payload->>'compiled_sql' as text) as compiled_sql,
        payload->'query_trace' as query_trace,
        cast(payload->'query_trace'->>'version' as integer) as trace_version,
        cast(payload->'query_trace'->>'skill_name' as text) as trace_skill_name,
        cast(payload->'query_trace'->>'stage' as text) as trace_stage,
        cast(payload->'query_trace'->>'status' as text) as trace_status,
        cast(
            payload->'query_trace'->>'started_at_utc'
            as timestamptz
        ) as trace_started_at_utc,
        payload->'query_trace'->'raw_plan' as raw_plan,
        payload->'query_trace'->'resolved_plan' as resolved_plan,
        payload->'query_trace'->'lightdash_queries' as lightdash_queries,
        payload->'query_trace'->'lightdash_payload' as lightdash_payload,
        cast(
            payload->'query_trace'->>'lightdash_query_uuid'
            as text
        ) as lightdash_query_uuid,
        payload->'query_trace'->'lightdash_response' as lightdash_response,
        cast(
            payload->'query_trace'->>'error_type'
            as text
        ) as trace_error_type,
        cast(
            payload->'query_trace'->>'error_message'
            as text
        ) as trace_error_message,
        payload->'query_trace'->'timings_ms' as trace_timings_ms,
        payload->'metadata'->'lightdash_query_uuids' as lightdash_query_uuids,
        cast(payload->'metadata'->>'source' as text) as metadata_source,
        cast(payload->'metadata'->>'debug' as boolean) as metadata_debug,
        cast(
            payload->'metadata'->>'latency_ms'
            as integer
        ) as metadata_latency_ms
    from source
)

select * from fin
