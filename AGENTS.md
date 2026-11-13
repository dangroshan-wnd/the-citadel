# Working in The Citadel

dbt models for every project. Ingestion repos (mainly
[the-wasteland](../the-wasteland)) own landing and raw writes. The Citadel
declares those tables as sources and owns the transformations, tests, docs,
and small reference seeds built on them. This repo is **public**.

## Start here

- Read [README.md](README.md) for the domains under `models/`, local setup,
  and validation commands.
- Shared conventions: [home/docs/standards.md](../home/docs/standards.md).

## Rules

- Never write to landing or raw tables from here. If a source needs to change,
  make the change in the ingestion repo that owns it.
- Before calling a change done, run `dbt deps`, `dbt parse`, and
  `dbt compile` with `--profiles-dir .` (the full commands are in the README).
  CI checks the same three.
- SQLFluff has an existing backlog and does not block CI. Lint the files you
  touch, but don't reformat unrelated SQL.
- Never commit credentials, local profiles with secrets, `.env` files, dbt
  packages, or generated `target/` and log folders.

## TODO

- [Dan: add model naming and layering conventions (staging, intermediate,
  marts) once they are settled.]
