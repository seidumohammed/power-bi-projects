# Customer Acquisition and Retention (Power BI)

A dashboard for an invented grocery delivery app in Ghana: how customers are won, what each costs, and how long they stay. All data is synthetic.

## What it shows

- The acquisition funnel by channel: visits, signups and first orders
- Customer acquisition cost (CAC) and revenue per customer, by channel
- Churn, retention and repeat purchase by segment and channel
- Revenue, order value and the value of a customer against what it cost to win

## Skills it demonstrates

| Area | Evidence |
| :-- | :-- |
| Power Query | 6 queries: mixed date formats, blank churn dates, order values stored as text ('GHS 85.50'), duplicates and inconsistent names are cleaned; a generated date table (`powerquery/queries.pq`) |
| Data modelling | Star schema with 6 tables and 7 relationships (`docs/model.md`) |
| DAX | 30 measures: new and churned customers with `TREATAS` on customer dates, customers at period end, churn, repeat rate, CAC, revenue per customer, LTV to CAC, year-on-year and three-month average (`model/measures.dax`) |
| Report design | Four pages, a fixed palette and rules for colour, accessibility and interaction (`docs/report-design.md`) |
| Documentation | Data dictionary, model notes and a user guide for non-technical readers (`docs/`) |

## Contents

- `data/raw/`: 5 CSV files (6,001 customers, 30,278 orders, 5 acquisition channels)
- `powerquery/queries.pq`, `model/measures.dax`
- `docs/`: `model.md`, `data-dictionary.md`, `report-design.md`, `user-guide.md`
- `pbip/CustomerRetention.pbip`: the Power BI project. See the [main README](../README.md) for how to open it and set the data folder.

## Pictures

### Screenshots from Power BI Desktop

_Screenshots will be added here._

## Setting and data

The app, its customers and every figure are invented. Region names are real regions used only as labels. Customers are anonymous IDs; no personal data exists in the files.
