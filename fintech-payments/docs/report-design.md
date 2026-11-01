# Report design: FinTech Payments

Canvas: 16:9 (1280 x 720). The report theme sets fonts and colours.

## Style system

Every page uses the same building blocks, set by a custom theme file inside the report folder (`StaticResources/RegisteredResources`) and repeated on every page:

| Element | Style |
| :-- | :-- |
| Dark canvas | A dark page with dark panels and light text, and a thin accent line under the header |
| Filters | One row of dropdown filters across the top of every page, each with a small label. The same filter keeps its selection on every page (synced) |
| KPI cards | Panel with a 10 pt label, a 26 pt semibold value, and a coloured accent bar along the bottom edge |
| Chart panels | Panel with a 1 px border, 12 px rounded corners, 12 pt semibold title, 9 pt axis and legend text, no axis titles |
| Tables and matrices | Header row in the dark colour with light text, thin horizontal grid lines, subtle alternate row shading |
| Fonts | Segoe UI and Segoe UI Semibold. Nothing larger than 26 pt except the page title |

### Palette

| Use | Colour |
| :-- | :-- |
| Page background | `#0E1020` |
| Header band, table headers | `#262B4F` |
| Primary (values, main series) | `#A99BFF` |
| Series 1 | `#A99BFF` |
| Series 2 (target, prior year) | `#2EE6A6` |
| Alert | `#FF6B81` |
| Muted text | `#98A0C9` |

## Filters by page

| Page | Filters in the column |
| :-- | :-- |
| Overview | Year, Quarter, Region, Segment, Channel, Transaction type |
| Channels and reliability | Year, Quarter, Region, Channel, Transaction type |
| Customers and growth | Year, Quarter, Region, Segment, Joined through |
| Fraud and loans | Year, Quarter, Region, Segment, Transaction type |

Filters that do not relate to a visual do not change it.

## Page 1: Overview

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Transaction value (GHS) | card | Values: `Txn Value (GHS)` |
| Successful transactions | card | Values: `Successful Transactions` |
| Active customers | card | Values: `Active Customers` |
| Success rate | card | Values: `Success Rate %` |
| Fee revenue (GHS) | card | Values: `Fee Revenue (GHS)` |
| Transaction value against target | lineChart | Category: `dim_Date[MonthStart]`; Y: `Txn Value (GHS)`, `Txn Value Target` |
| Value by transaction type | donutChart | Category: `dim_TxnType[TxnType]`; Y: `Txn Value (GHS)` |
| Value by region | clusteredColumnChart | Category: `dim_Region[Region]`; Y: `Txn Value (GHS)` |
| Active customers by month | areaChart | Category: `dim_Date[MonthStart]`; Y: `Active Customers` |
## Page 2: Channels and reliability

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Success rate | card | Values: `Success Rate %` |
| Failure rate | card | Values: `Failure Rate %` |
| Reversal rate | card | Values: `Reversal Rate %` |
| Average transaction (GHS) | card | Values: `Avg Txn Value (GHS)` |
| Failure rate by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Failure Rate %` |
| Failure rate by channel | clusteredColumnChart | Category: `dim_Channel[Channel]`; Y: `Failure Rate %` |
| Failed transactions by reason | clusteredBarChart | Category: `fact_Transaction[FailureReason]`; Y: `Failed Transactions` |
| Channels | tableEx | Values: `dim_Channel[Channel]`, `Transactions`, `Success Rate %`, `Failure Rate %`, `Txn Value (GHS)`, `Fee Revenue (GHS)` |
## Page 3: Customers and growth

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Active customers | card | Values: `Active Customers` |
| New customers | card | Values: `New Customers` |
| Transactions per active customer | card | Values: `Txns per Active Customer` |
| Average transaction (GHS) | card | Values: `Avg Txn Value (GHS)` |
| Active and new customers, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Active Customers`, `New Customers` |
| Active customers by segment | clusteredBarChart | Category: `dim_Customer[Segment]`; Y: `Active Customers` |
| Regions | tableEx | Values: `dim_Region[Region]`, `Active Customers`, `New Customers`, `Txn Value (GHS)`, `Txns per Active Customer` |
| New customers by how they joined | clusteredColumnChart | Category: `dim_Customer[AcquisitionChannel]`; Y: `New Customers` |
## Page 4: Fraud and loans

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Fraud per 10,000 transactions | card | Values: `Fraud Rate (per 10,000)` |
| Fraud value (GHS) | card | Values: `Fraud Value (GHS)` |
| Portfolio at risk (30+ days) | card | Values: `PAR30 %` |
| Loan default rate | card | Values: `Default Rate %` |
| Fraud rate by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Fraud Rate (per 10,000)` |
| Portfolio at risk by segment | clusteredColumnChart | Category: `dim_Customer[Segment]`; Y: `PAR30 %` |
| Loan book by segment | tableEx | Values: `dim_Customer[Segment]`, `Loans Disbursed (count)`, `Loans Disbursed (GHS)`, `Loans Outstanding (GHS)`, `PAR30 %`, `Default Rate %` |
| Loans disbursed by month | areaChart | Category: `dim_Date[MonthStart]`; Y: `Loans Disbursed (GHS)` |

## Added by hand in Desktop

Top N filters, conditional formatting, constant reference lines, page navigator buttons, drill-through pages and bookmarks are not in the generated project files. Add them in Desktop if you want them.
