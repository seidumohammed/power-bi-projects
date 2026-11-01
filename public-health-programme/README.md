# Public Health Programme (Power BI)

A dashboard for an invented regional health directorate in the Northern Region: immunisation coverage, disease surveillance and the quality of facility reporting. All data is synthetic.

## What it shows

- Immunisation coverage by district and vaccine, against a 90% target
- Disease surveillance: cases, deaths and test positivity, with their seasons
- Reporting completeness and timeliness by district and facility level
- Which districts and facilities fall behind

## Skills it demonstrates

| Area | Evidence |
| :-- | :-- |
| Power Query | 9 queries: mixed month formats, counts stored as text ('1,250'), duplicates and inconsistent names are cleaned; a generated date table (`powerquery/queries.pq`) |
| Data modelling | Star schema with 9 tables and 10 relationships (`docs/model.md`) |
| DAX | 30 measures: coverage against target, Penta dropout, case fatality, test positivity, incidence per 1,000, reporting completeness and timeliness, year-on-year, three-month average and `TREATAS` targets (`model/measures.dax`) |
| Report design | Four pages, a fixed palette and rules for colour, accessibility and interaction (`docs/report-design.md`) |
| Documentation | Data dictionary, model notes and a user guide for non-technical readers (`docs/`) |

## Contents

- `data/raw/`: 8 CSV files (65 facilities in 10 districts, 6,240 immunisation rows, 6,240 surveillance rows, 1,560 monthly reports)
- `powerquery/queries.pq`, `model/measures.dax`
- `docs/`: `model.md`, `data-dictionary.md`, `report-design.md`, `user-guide.md`
- `pbip/PublicHealthProgramme.pbip`: the Power BI project. See the [main README](../README.md) for how to open it and set the data folder.

## Pictures

### Screenshots from Power BI Desktop

_Screenshots will be added here._

## Setting and data

The directorate, its facilities and every figure are invented. District names are real Northern Region districts used only as labels; facility names are made up. Nothing here is real health data and nothing shown describes real conditions in those districts.
