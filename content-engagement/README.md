# Content and Email Engagement (Power BI)

A dashboard for an invented financial-literacy publisher in Ghana: how its content performs by email, social media and its website. All data is synthetic.

## What it shows

- Email delivery, opens, clicks and unsubscribes by audience segment
- Social reach and engagement by platform
- Web traffic, time on page and signups by content
- Which topics and formats earn attention across all three channels

## Skills it demonstrates

| Area | Evidence |
| :-- | :-- |
| Power Query | 7 queries: mixed date formats, bounce rates stored as text ('42%'), duplicates and inconsistent names are cleaned; a generated date table (`powerquery/queries.pq`) |
| Data modelling | Star schema with 7 tables and 8 relationships (`docs/model.md`) |
| DAX | 33 measures: delivery, open, click and unsubscribe rates, engagement rate, bounce rate weighted by sessions, signups, content published with `TREATAS`, year-on-year and three-month average (`model/measures.dax`) |
| Report design | Four pages, a fixed palette and rules for colour, accessibility and interaction (`docs/report-design.md`) |
| Documentation | Data dictionary, model notes and a user guide for non-technical readers (`docs/`) |

## Contents

- `data/raw/`: 6 CSV files (164 pieces of content, 393 email sends, 530 social posts, 2,210 weekly web rows)
- `powerquery/queries.pq`, `model/measures.dax`
- `docs/`: `model.md`, `data-dictionary.md`, `report-design.md`, `user-guide.md`
- `pbip/ContentEngagement.pbip`: the Power BI project. See the [main README](../README.md) for how to open it and set the data folder.

## Pictures

### Screenshots from Power BI Desktop

_Screenshots will be added here._

## Setting and data

The publisher, its content and every figure are invented. Platform names are real services used only as labels. Nothing here is real audience data.
