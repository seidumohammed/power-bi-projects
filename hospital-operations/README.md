# Hospital Operations (Power BI)

A dashboard for an invented 120-bed regional hospital: admissions, bed occupancy, length of stay, quality of care and the emergency department. All data is synthetic.

## What it shows

- Admissions, length of stay and bed occupancy by ward, against an 85% occupancy target
- Quality indicators: 30-day readmission, mortality and referral rates by diagnosis group
- Emergency department waiting times, by triage level, against time targets
- Who the hospital serves: age group, insurance and district of residence

## Skills it demonstrates

| Area | Evidence |
| :-- | :-- |
| Power Query | 8 queries: mixed date formats, waiting times stored as text ('45 min'), duplicates and inconsistent text are cleaned; length of stay and emergency target flags are calculated; a generated date table (`powerquery/queries.pq`) |
| Data modelling | Star schema with 8 tables and 9 relationships (`docs/model.md`) |
| DAX | 27 measures: admissions, length of stay, bed occupancy from a daily census, readmission and mortality rates, emergency waiting times, year-on-year, three-month average and `TREATAS` occupancy targets (`model/measures.dax`) |
| Report design | Four pages, a fixed palette and rules for colour, accessibility and interaction (`docs/report-design.md`) |
| Documentation | Data dictionary, model notes and a user guide for non-technical readers (`docs/`) |

## Contents

- `data/raw/`: 7 CSV files (about 17,761 admissions, 25,235 emergency visits, 5,117 daily ward counts, 7 wards, 120 beds)
- `powerquery/queries.pq`, `model/measures.dax`
- `docs/`: `model.md`, `data-dictionary.md`, `report-design.md`, `user-guide.md`
- `pbip/HospitalOperations.pbip`: the Power BI project. See the [main README](../README.md) for how to open it and set the data folder.

## Pictures

### Screenshots from Power BI Desktop

_Screenshots will be added here._

## Setting and data

The hospital, its wards and every patient record are invented. No individual patient exists anywhere in the data: admissions and visits point to a small table of patient profiles. District names are real Volta Region districts used only as labels. Nothing here is medical advice or real health data.
