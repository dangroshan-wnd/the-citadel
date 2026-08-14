with wrap as (
select 
draft_id
, draft_status
, draft_type
, entry_count
, pick_order
, place
, payout
, count(pick_id) as pick_count
, sum(case when position_name = 'QB' then 1 else 0 end) as qb_count
, sum(case when position_name = 'RB' then 1 else 0 end) as rb_count
, sum(case when position_name = 'WR' then 1 else 0 end) as wr_count
, sum(case when position_name = 'TE' then 1 else 0 end) as te_count
from dbt_marts.draft_picks

where draft_status = 'settled'
and username = 'DGRO18'

group by 1,2,3,4,5,6,7
)

select *
from wrap