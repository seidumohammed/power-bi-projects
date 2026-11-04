# Campaign Performance (Power BI)

A dashboard for the paid media of an invented online retailer in Accra: spend, reach, conversions, return on ad spend and budget control across six channels. All data is synthetic.

## What it shows

- Spend, revenue and return on ad spend (ROAS) by channel and campaign
- Cost per click and cost per acquisition, and how they move through the year
- Budget against actual spend by channel and month
- Which campaigns earn their budget, and which do not

## Skills it demonstrates

| Area | Evidence |
| :-- | :-- |
| Power Query | 5 queries: mixed date formats, spend stored as text ('GHS 1,250.00'), duplicates and inconsistent names are cleaned; a generated date table (`powerquery/queries.pq`) |
| Data modelling | Star schema with 5 tables and 4 relationships (`docs/model.md`) |
| DAX | 24 measures: spend, reach, CTR, CPC, CPM, conversion rate, CPA, ROAS, budget used, year-on-year, three-month average and `TREATAS` budgets (`model/measures.dax`) |
| Report design | Four pages, a fixed palette and rules for colour, accessibility and interaction (`docs/report-design.md`) |
| Documentation | Data dictionary, model notes and a user guide for non-technical readers (`docs/`) |

## Contents

- `data/raw/`: 4 CSV files (20 campaigns on 6 channels, 12,597 daily result rows)
- `powerquery/queries.pq`, `model/measures.dax`
- `docs/`: `model.md`, `data-dictionary.md`, `report-design.md`, `user-guide.md`
- `pbip/CampaignPerformance.pbip`: the Power BI project. See the [main README](../README.md) for how to open it and set the data folder.

## Pictures

### Screenshots from Power BI Desktop

_Screenshots will be added here._

## Setting and data

The retailer, its campaigns and every figure are invented. Channel names are real platforms used only as labels. Nothing here is real advertising data.
