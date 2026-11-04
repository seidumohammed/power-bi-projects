# Report design: Campaign Performance

Canvas: 16:9 (1280 x 720). The report theme sets fonts and colours.

## Style system

Every page uses the same building blocks, set by a custom theme file inside the report folder (`StaticResources/RegisteredResources`) and repeated on every page:

| Element | Style |
| :-- | :-- |
| Top bar | A slim dark bar with the project name, the page title (14 pt) and the data note |
| Filters | One row of dropdown filters, each with a small grey label. The same filter keeps its selection on every page (synced) |
| KPI cards | Panel with a 10 pt label, a 26 pt semibold value, and a coloured accent bar along the top edge |
| Chart panels | Panel with a 1 px border, 4 px rounded corners, 12 pt semibold title, 9 pt axis and legend text, no axis titles |
| Tables and matrices | Header row in the dark colour with light text, thin horizontal grid lines, subtle alternate row shading |
| Fonts | Segoe UI and Segoe UI Semibold. Nothing larger than 26 pt except the page title |

### Palette

| Use | Colour |
| :-- | :-- |
| Page background | `#EAF0F7` |
| Header band, table headers | `#0B3C6F` |
| Primary (values, main series) | `#1565C0` |
| Series 1 | `#1565C0` |
| Series 2 (target, prior year) | `#F57C00` |
| Alert | `#D8523F` |
| Muted text | `#5C6672` |

## Filters by page

| Page | Filters in the column |
| :-- | :-- |
| Overview | Year, Quarter, Channel, Objective, Product category |
| Channels | Year, Quarter, Channel, Objective, Product category |
| Campaigns | Year, Quarter, Channel, Objective, Product category, Campaign |
| Budget and trends | Year, Quarter, Channel |

Filters that do not relate to a visual do not change it.

## Page 1: Overview

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Spend (GHS) | card | Values: `Spend` |
| Revenue (GHS) | card | Values: `Revenue` |
| Return on ad spend | card | Values: `ROAS` |
| Cost per acquisition (GHS) | card | Values: `CPA` |
| Conversion rate | card | Values: `Conversion Rate %` |
| Spend and revenue, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Spend`, `Revenue` |
| Revenue by channel | clusteredBarChart | Category: `dim_Channel[Channel]`; Y: `Revenue` |
| ROAS by channel | clusteredColumnChart | Category: `dim_Channel[Channel]`; Y: `ROAS` |
| Revenue against prior year | lineChart | Category: `dim_Date[MonthStart]`; Y: `Revenue`, `Revenue PY` |
## Page 2: Channels

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Channels | tableEx | Values: `dim_Channel[Channel]`, `Spend`, `Impressions`, `CTR %`, `CPC`, `Conversions`, `CPA`, `ROAS` |
| Cost per acquisition by channel | clusteredBarChart | Category: `dim_Channel[Channel]`; Y: `CPA` |
| Spend against ROAS | scatterChart | Category: `dim_Channel[Channel]`; X: `Spend`; Y: `ROAS`; Size: `Conversions` |
| ROAS by channel and quarter | pivotTable | Rows: `dim_Channel[Channel]`; Columns: `dim_Date[Quarter]`; Values: `ROAS` |
## Page 3: Campaigns

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Campaigns | tableEx | Values: `dim_Campaign[Campaign]`, `dim_Campaign[Objective]`, `Spend`, `Conversions`, `CPA`, `ROAS` |
| ROAS by objective | clusteredColumnChart | Category: `dim_Campaign[Objective]`; Y: `ROAS` |
| Revenue by product category | clusteredBarChart | Category: `dim_Campaign[Category]`; Y: `Revenue` |
| Spend, three-month average | lineChart | Category: `dim_Date[MonthStart]`; Y: `Spend 3M Average` |
## Page 4: Budget and trends

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Budget (GHS) | card | Values: `Budget` |
| Spend (GHS) | card | Values: `Spend` |
| Budget used | card | Values: `Budget Used %` |
| Remaining (GHS) | card | Values: `Budget Remaining` |
| Spend against budget, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Spend`, `Budget` |
| Budget used by channel | clusteredBarChart | Category: `dim_Channel[Channel]`; Y: `Budget Used %` |
| Cost per acquisition, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `CPA` |
| Budget by channel | tableEx | Values: `dim_Channel[Channel]`, `Budget`, `Spend`, `Budget Used %`, `Budget Remaining` |

## Added by hand in Desktop

Top N filters, conditional formatting, constant reference lines, page navigator buttons, drill-through pages and bookmarks are not in the generated project files. Add them in Desktop if you want them.
