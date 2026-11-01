# Report design: Programme Monitoring

Canvas: 16:9 (1280 x 720). The report theme sets fonts and colours.

## Style system

Every page uses the same building blocks, set by a custom theme file inside the report folder (`StaticResources/RegisteredResources`) and repeated on every page:

| Element | Style |
| :-- | :-- |
| Header band | Full-width dark band (72 px) with the page title (18 pt, semibold, white), a one-line subtitle (10 pt) and, where used, the selection label |
| Filters | One framed column on the right of every page (238 px wide) with a "Filters" title and dropdown slicers, each with a small grey label. The same filter keeps its selection on every page (synced). |
| KPI cards | White panel, 10 pt grey label, 26 pt semibold value, and a coloured accent bar on the left edge |
| Chart panels | White panel, 1 px light border, rounded corners, 12 pt semibold title, 9 pt axis and legend text, no axis titles |
| Tables and matrices | Dark header row with white text, light horizontal grid lines, subtle alternate row shading |
| Fonts | Segoe UI and Segoe UI Semibold. Nothing larger than 26 pt except the page title |

### Palette

| Use | Colour |
| :-- | :-- |
| Page background | `#EDF3F3` |
| Header band, table headers | `#0B3C49` |
| Primary (values, main series) | `#0F6E6E` |
| Series 1 (actuals) | `#1B998B` |
| Series 2 (targets) | `#F2A541` |
| Alert | `#E4572E` |
| Muted text | `#5F6B73` |

Teal means actual, amber means target, red is for problems only.


## Filters by page

| Page | Filters in the column |
| :-- | :-- |
| Overview | Year, Quarter, Zone, District, Team, Visit type |
| Field team | Year, Quarter, Zone, District, Team, Visit type, Officer |
| Data quality | Year, Quarter, Zone, District, Team, Visit type |
| Savings groups | Year, Quarter, Zone, District, Savings group |

Filters that do not relate to a visual do not change it. For example, in the programme report Team and Visit type filter visits and data quality, but not savings.

## Page 1: Overview

| Visual | Fields |
| :-- | :-- |
| Filters | In the filter column on the right (see "Filters by page") |
| Cards (row of five) | `Visits Completed`, `Farmers Reached`, `Data Error Rate`, `Savings (GHS)`, `Loan Repayment Rate` |
| Line chart | Axis `dim_Date[MonthStart]`; values `Visits Completed`, `Visits Target` |
| Clustered bar | Axis `dim_Zone[Zone]`; value `Farmers Reached` |
| Donut | Legend `fact_Visit[VisitType]`; value `Visits Completed` |

Add the cards' secondary value (small text) from `Visits Completed YoY %` and `Visits vs Target %`.

## Page 2: Field team

| Visual | Fields |
| :-- | :-- |
| Slicers | `dim_Officer[Team]`, `fact_Visit[VisitType]` |
| Table | `OfficerName`, `Team`, `Visits Completed`, `Completion Rate`, `Farmers Reached`, `Data Error Rate` |
| Bar chart | Axis `OfficerName`; value `Data Error Rate`; filter Top 10 by `Data Error Rate`; constant line at `Error Rate Target` |
| Scatter | X `Visits Completed`, Y `Data Error Rate`, details `OfficerName`, size `Farmers Reached` |

Conditional formatting on `Data Error Rate` in the table: red font when `Error Rate Status` is "Above target" (Format by rules, based on `Error Rate Target`).

## Page 3: Data quality

| Visual | Fields |
| :-- | :-- |
| Line chart | Axis `dim_Date[MonthStart]`; values `Data Error Rate`; constant line `Error Rate Target` |
| Clustered column | Axis `fact_Visit[VisitType]`; value `Data Error Rate` |
| Matrix (heat map) | Rows `dim_Zone[Zone]`; columns `dim_Date[Quarter]`; value `Data Error Rate`; background colour scale (white to red) |
| Cards | `Records Collected`, `Records With Errors` |
| Decomposition tree | Analyse `Records With Errors`; explain by Zone, Team, OfficerName |

## Page 4: Savings groups

| Visual | Fields |
| :-- | :-- |
| Slicer | `dim_Date[Year]` |
| Cards | `Savings (GHS)`, `Active Groups`, `Attendance Rate`, `Loan Repayment Rate` |
| Area chart | Axis `dim_Date[MonthStart]`; values `Savings (GHS)`, `Savings Target (GHS)` |
| Clustered column | Axis `dim_Zone[Zone]`; value `Savings per Member Present (GHS)` |
| Table | `GroupName`, `Community`, `Members`, `Savings (GHS)`, `Loan Repayment Rate` (sorted by savings, top 15) |

## Interaction and navigation

- Add a page navigator (Insert > Buttons > Navigator > Page navigator) at the top of every page.
- Add one drill-through page "Officer detail" (hidden): drill-through field `dim_Officer[OfficerName]`; show visits by month, visit types and error rate over time. Right-click an officer on page 2 to reach it.
- Turn off cross-filtering from the donut to the cards only if it confuses users; otherwise leave interactions on and mention it in the user guide.
- Set the tooltips for the line charts to show `Visits Completed YoY %` and `Visits vs Target %`.

## Accessibility and polish checklist

- Alt text on every visual.
- Tab order matches reading order (View > Selection pane).
- Contrast of text on coloured backgrounds at least 4.5 to 1.
- No more than six visuals per page.
- Units in titles ("Savings (GHS)", "Error rate, % of records").
