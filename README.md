# Power BI portfolio projects

Ten Power BI dashboards, plus a gallery of thirteen design systems, built on **synthetic data**, each with documented Power Query cleaning, a star-schema data model, DAX measures, a report design and a user guide. Each project uses one of the design systems.

| Project | Question it answers | Setting |
| :-- | :-- | :-- |
| [Programme Monitoring](programme-monitoring/) | Is a field programme on track, and is its data getting better? | Central Region, Ghana (invented zones, savings groups and officers) |
| [Sales Performance](sales-performance/) | How is a retail business performing against last year and against target? | Six retail stores in Ghana (invented business) |
| [Real Estate Performance](real-estate-performance/) | How are listings, sales, agents and branches performing against target? | Greater Accra (invented agency) |
| [Supply Chain Performance](supply-chain-performance/) | Are orders delivered on time and in full, and is stock healthy? | Hubs in Tema, Takoradi, Tamale and Ho (invented distributor) |
| [FinTech Payments](fintech-payments/) | How do channels, fraud and loans perform? | Invented mobile money and lending provider |
| [Hospital Operations](hospital-operations/) | How busy is the hospital and how good is care? | Invented 120-bed hospital, Volta Region |
| [Public Health Programme](public-health-programme/) | How are immunisation, surveillance and reporting doing? | Invented health directorate, Northern Region |
| [Campaign Performance](campaign-performance/) | Which paid channels and campaigns earn their budget? | Invented online retailer in Accra |
| [Customer Acquisition and Retention](customer-retention/) | What does a customer cost to win, and how long do they stay? | Invented grocery delivery app, Ghana |
| [Content and Email Engagement](content-engagement/) | Which content engages by email, social and web? | Invented financial-literacy publisher |
| [Design Systems Gallery](design-systems/) | What do thirteen design systems look like on one dashboard? | Same hospital data on 13 pages |

All names, groups, businesses and numbers are made up. District and town names are real place names used only as labels. Nothing here comes from a real employer, programme or customer.

## What is in each project

```
<project>/
  data/raw/        raw CSV files, with deliberate and documented data problems
  powerquery/      queries.pq: every Power Query (M) script, with the cleaning rules explained
  model/           measures.dax: every DAX measure, with display folder and format
  docs/            model.md, data-dictionary.md, report-design.md, user-guide.md
  pbip/            the Power BI project (.pbip), as saved by Power BI Desktop
  images/          screenshots of each report page
```

## Open a report in Power BI Desktop

1. Install Power BI Desktop (free, Windows).
2. In Desktop, turn on **File > Options and settings > Options > Preview features > Power BI Project (.pbip) save option**, then restart. Newer builds may have it on already.
3. Open the `.pbip` file in the `pbip` folder of the project you want, for example `hospital-operations/pbip/HospitalOperations.pbip`.
4. The projects contain a placeholder data folder (`C:\path\to\power-bi-projects\...`). Set the real one once: Home > Transform data > Edit parameters > `DataFolder` = the project's `data\raw` folder, **with a trailing backslash**.
5. Home > **Refresh**.

Both reports were opened and refreshed in Power BI Desktop and render as designed; the screenshots in each project folder come from those reports.

If something does not load:

1. **A query fails on refresh.** Check that `DataFolder` ends with a backslash and points at `data/raw`.
2. **A model or report file reports a problem.** Note the message and the file it names. The tables are in `pbip/<Name>.SemanticModel/definition/tables/`, and the Power Query code inside each is identical to `powerquery/queries.pq`.
3. **Date table warnings.** Mark `dim_Date` as the date table (Table tools > Mark as date table).

## Build a report yourself from the files

About two hours per project, and the best way to learn it.

1. Home > Manage parameters > New parameter: name `DataFolder`, type Text, value = the project's `data/raw` folder with a trailing backslash.
2. For each query in `powerquery/queries.pq`: Home > Get data > Blank query > Advanced editor > paste the code > rename the query to the name after "Query:".
3. Close and apply. In Model view, create the relationships listed in `docs/model.md`, mark `dim_Date` as the date table, and apply the sorting and hiding.
4. Home > Enter data > one column "Dummy", name the table `_Measures`. Add each measure from `model/measures.dax`, with the format and display folder from the comment above it.
5. Build the pages from `docs/report-design.md` (visuals, fields and formatting for each).

## Design

Both reports share one design system: a custom report theme (fonts, colours, default chart formatting), a dark header band, a framed filter column that stays in sync across pages, KPI cards with accent bars, rounded chart panels and styled tables. Power BI is styled through its theme and visual formatting, not HTML or JavaScript. The details are in each project's `docs/report-design.md`.

Items described in the design docs but added by hand in Desktop rather than in the project files: Top N filters, conditional formatting, constant reference lines, page navigator buttons, drill-through pages and bookmarks.

## About the data

The data is synthetic and was generated with a fixed random seed. Patterns such as the fall in the data error rate, the December sales peak and the year-on-year growth were built into the data to make the reports readable. The raw files also carry deliberate problems (mixed date formats, duplicates, text in number columns, inconsistent codes) that the Power Query steps clean, and each project's `docs/data-dictionary.md` lists them with counts.