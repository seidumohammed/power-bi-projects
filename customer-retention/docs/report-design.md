# Report design: Customer Acquisition and Retention

Canvas: 16:9 (1280 x 720). The report theme sets fonts and colours.

## Style system

Every page uses the same building blocks, set by a custom theme file inside the report folder (`StaticResources/RegisteredResources`) and repeated on every page:

| Element | Style |
| :-- | :-- |
| Dark canvas | A dark page with a lighter panel on the left that carries the project name and every filter |
| Filters | Every filter is a dropdown in a column with a small label. The same filter keeps its selection on every page (synced) |
| KPI cards | Panel with a 10 pt label, a 26 pt semibold value, and a coloured accent bar on the left edge |
| Chart panels | Panel with a 1 px border, 8 px rounded corners, 12 pt semibold title, 9 pt axis and legend text, no axis titles |
| Tables and matrices | Header row in the dark colour with light text, thin horizontal grid lines, subtle alternate row shading |
| Fonts | Segoe UI and Segoe UI Semibold. Nothing larger than 26 pt except the page title |

### Palette

| Use | Colour |
| :-- | :-- |
| Page background | `#14161B` |
| Header band, table headers | `#0F1115` |
| Primary (values, main series) | `#F2A93B` |
| Series 1 | `#F2A93B` |
| Series 2 (target, prior year) | `#4FC3F7` |
| Alert | `#D8523F` |
| Muted text | `#A3AAB5` |

## Filters by page

| Page | Filters in the column |
| :-- | :-- |
| Overview | Year, Quarter, Acquisition channel, Segment, Region |
| Acquisition | Year, Quarter, Acquisition channel |
| Retention | Year, Quarter, Acquisition channel, Segment, Region |
| Value | Year, Quarter, Acquisition channel, Segment, Region |

Filters that do not relate to a visual do not change it.

## Page 1: Overview

| Visual | Type | Fields |
| :-- | :-- | :-- |
| New customers | card | Values: `New Customers` |
| Active customers | card | Values: `Active Customers` |
| Revenue (GHS) | card | Values: `Revenue` |
| Churn rate | card | Values: `Churn Rate %` |
| Cost to acquire (GHS) | card | Values: `CAC` |
| New customers against prior year | lineChart | Category: `dim_Date[MonthStart]`; Y: `New Customers`, `New Customers PY` |
| Revenue by acquisition channel | clusteredBarChart | Category: `dim_Channel[AcquisitionChannel]`; Y: `Revenue` |
| Customers by segment | clusteredColumnChart | Category: `dim_Customer[Segment]`; Y: `Customers at Period End` |
| Customers at the end of each month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Customers at Period End` |
## Page 2: Acquisition

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Visits | card | Values: `Visits` |
| Signups | card | Values: `Signups` |
| First orders | card | Values: `First Orders` |
| Visit to signup | card | Values: `Visit to Signup %` |
| Signup to first order | card | Values: `Signup to First Order %` |
| Signups and first orders, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Signups`, `First Orders` |
| Visit to signup, by channel | clusteredBarChart | Category: `dim_Channel[AcquisitionChannel]`; Y: `Visit to Signup %` |
| Cost to acquire, by channel | clusteredColumnChart | Category: `dim_Channel[AcquisitionChannel]`; Y: `CAC` |
| Channels | tableEx | Values: `dim_Channel[AcquisitionChannel]`, `Visits`, `Signups`, `First Orders`, `Marketing Spend`, `CAC` |
## Page 3: Retention

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Churned customers | card | Values: `Churned Customers` |
| Churn rate | card | Values: `Churn Rate %` |
| Repeat customers | card | Values: `Repeat Customer %` |
| Orders per customer | card | Values: `Orders per Active Customer` |
| Churn rate, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Churn Rate %` |
| Churn rate by acquisition channel | clusteredColumnChart | Category: `dim_Channel[AcquisitionChannel]`; Y: `Churn Rate %` |
| Repeat customers by segment | clusteredBarChart | Category: `dim_Customer[Segment]`; Y: `Repeat Customer %` |
| Segments | tableEx | Values: `dim_Customer[Segment]`, `Active Customers`, `Orders per Active Customer`, `Repeat Customer %`, `Churn Rate %` |
## Page 4: Value

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Revenue (GHS) | card | Values: `Revenue` |
| Orders | card | Values: `Orders` |
| Average order (GHS) | card | Values: `Avg Order Value` |
| Revenue per customer (GHS) | card | Values: `Revenue per Customer to Date` |
| Value to cost ratio | card | Values: `LTV to CAC` |
| Revenue against prior year | lineChart | Category: `dim_Date[MonthStart]`; Y: `Revenue`, `Revenue PY` |
| Average order by region | clusteredColumnChart | Category: `dim_Customer[Region]`; Y: `Avg Order Value` |
| Revenue by segment | clusteredBarChart | Category: `dim_Customer[Segment]`; Y: `Revenue` |
| Value of a customer, by channel | tableEx | Values: `dim_Channel[AcquisitionChannel]`, `New Customers`, `CAC`, `Revenue per Customer to Date`, `LTV to CAC` |

## Added by hand in Desktop

Top N filters, conditional formatting, constant reference lines, page navigator buttons, drill-through pages and bookmarks are not in the generated project files. Add them in Desktop if you want them.
