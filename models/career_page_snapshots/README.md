# Future analytical models

V1 declares only the immutable `landing.career_page_snapshots` source. It deliberately does not
claim transformation lineage that has not been implemented.

The first follow-up model should be `staging.stg_job_postings`, which will expand each snapshot's
`payload.jobs` array into one row per observed source job while retaining `snapshot_id`,
`company_name`, `captured_at`, source identity, and the source's stable external job ID.

A later `marts.job_postings_history` model can derive:

- `first_seen_at`: earliest complete snapshot containing the company/source job identity.
- `last_seen_at`: latest complete snapshot containing that identity.
- `is_active`: whether the identity appears in the newest successful company snapshot.
- `days_open`: elapsed calendar time between first and last observation, with an explicit active-job
  convention chosen when the model is implemented.

Those models need decisions about identity changes, title/location history, reinstated postings, and
snapshot gaps. They remain documentation—not placeholder SQL—until those semantics are agreed.
