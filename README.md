# The Citadel

The single repository for dbt modeling across projects. Ingestion repositories
own landing/raw writes; the Citadel declares those sources and owns downstream
transformations, tests, documentation, and small static reference seeds.

## Domains

- `models/fantasy_football/` contains the active fantasy-football models moved
  from the application repository.
- `models/career_page_snapshots/` declares the immutable
  `landing.career_page_snapshots` source. No transformation lineage is claimed
  until those models are implemented.

Large raw extracts and disabled legacy datasets do not belong here. The former
fantasy-football legacy seed CSVs intentionally remain with that repository for
now; only the four active reference seeds are included in `seeds/`.

## Local setup

Create a virtual environment and install the development dependencies:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements-dev.txt
```

Set the `DBT_POSTGRES_*` environment variables described in `profiles.yml`,
then validate the project:

```powershell
.\.venv\Scripts\dbt.exe deps --profiles-dir .
.\.venv\Scripts\dbt.exe parse --profiles-dir . --no-partial-parse
.\.venv\Scripts\dbt.exe compile --profiles-dir .
```

Never commit database credentials, local profiles containing secrets, `.env`
files, dbt packages, or generated targets/logs.

The migrated fantasy SQL predates the repository's SQLFluff configuration and
has a substantial existing style backlog. CI initially gates on dbt dependency
resolution, parsing, and compilation; SQLFluff is available locally but becomes
a required check only after that backlog is handled deliberately.
