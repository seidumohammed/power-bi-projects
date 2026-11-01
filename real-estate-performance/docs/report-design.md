# Report design: Real Estate Performance

Canvas: 16:9 (1280 x 720). The report theme sets fonts and colours.

## Style system

Every page uses the same building blocks, set by a custom theme file inside the report folder (`StaticResources/RegisteredResources`) and repeated on every page:

| Element | Style |
| :-- | :-- |
| Header band | Full-width dark band (72 px) with the page title (18 pt, semibold, white) and a one-line subtitle (10 pt) |
| Filters | One framed column on the right of every page (238 px wide) with a "Filters" title and dropdown slicers, each with a small grey label. The same filter keeps its selection on every page (synced) |
| KPI cards | Panel with a 10 pt label, a 26 pt semibold value, and a coloured accent bar on the left edge |
| Chart panels | Panel with a 1 px border, 10 px rounded corners, 12 pt semibold title, 9 pt axis and legend text, no axis titles |
| Tables and matrices | Header row in the dark colour with light text, thin horizontal grid lines, subtle alternate row shading |
| Fonts | Segoe UI and Segoe UI Semibold. Nothing larger than 26 pt except the page title |

### Palette

| Use | Colour |
| :-- | :-- |
| Page background | `#F6F3EF` |
| Header band, table headers | `#2B2D42` |
| Primary (values, main series) | `#B8472F` |
| Series 1 | `#B8472F` |
| Series 2 (target, prior year) | `#2B2D42` |
| Alert | `#B23A48` |
| Muted text | `#5F6B73` |

## Filters by page

| Page | Filters in the column |
| :-- | :-- |
| Executive summary | Year, Quarter, Branch, Zone, Neighbourhood, Property type, Agent |
| Market and areas | Year, Quarter, Zone, Neighbourhood, Property type, Branch |
| Agents and branches | Year, Quarter, Branch, Agent, Property type |
| Listings and targets | Year, Quarter, Branch, Zone |

Filters that do not relate to a visual do not change it.

## Page 1: Executive summary

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Sales value (GHS) | card | Values: `Sales Value (GHS)` |
| Sales | card | Values: `Sales Count` |
| Average sale price (GHS) | card | Values: `Avg Sale Price (GHS)` |
| Days on market | card | Values: `Days on Market` |
| Target attainment | card | Values: `Sales Value Attainment %` |
| Sales value against prior year | lineChart | Category: `dim_Date[MonthStart]`; Y: `Sales Value (GHS)`, `Sales Value PY` |
| Sales value by branch | clusteredBarChart | Category: `dim_Branch[Branch]`; Y: `Sales Value (GHS)` |
| Sales value by property type | donutChart | Category: `dim_Property[PropertyType]`; Y: `Sales Value (GHS)` |
| Change on last year | card | Values: `Sales Value YoY %` |
| Sell-through | card | Values: `Sell-Through %` |
| Discount to asking price | card | Values: `Discount to List %` |
| Commission (GHS) | card | Values: `Commission (GHS)` |
| Active listings | card | Values: `Active Listings` |
| Price per sqm (GHS) | card | Values: `Avg Price per sqm (GHS)` |
## Page 2: Market and areas

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Price per square metre by neighbourhood | clusteredBarChart | Category: `dim_Area[Area]`; Y: `Avg Price per sqm (GHS)` |
| Price against days on market | scatterChart | Category: `dim_Area[Area]`; X: `Avg Price per sqm (GHS)`; Y: `Days on Market`; Size: `Sales Count` |
| Neighbourhoods | tableEx | Values: `dim_Area[Area]`, `dim_Area[Zone]`, `Sales Count`, `Sales Value (GHS)`, `Avg Price per sqm (GHS)`, `Days on Market` |
| Sales by property type | clusteredColumnChart | Category: `dim_Property[PropertyType]`; Y: `Sales Count` |
## Page 3: Agents and branches

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Agents | tableEx | Values: `dim_Agent[AgentName]`, `dim_Branch[Branch]`, `Sales Count`, `Sales Value (GHS)`, `Days on Market`, `Commission (GHS)` |
| Sales value by agent | clusteredBarChart | Category: `dim_Agent[AgentName]`; Y: `Sales Value (GHS)` |
| Sales value by branch and quarter | pivotTable | Rows: `dim_Branch[Branch]`; Columns: `dim_Date[Quarter]`; Values: `Sales Value (GHS)` |
## Page 4: Listings and targets

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Listings added | card | Values: `Listings Count` |
| Active listings | card | Values: `Active Listings` |
| Sell-through | card | Values: `Sell-Through %` |
| Target attainment | card | Values: `Sales Value Attainment %` |
| Sales value against target | lineClusteredColumnComboChart | Category: `dim_Date[MonthStart]`; Y: `Sales Value (GHS)`; Y2: `Sales Value Target` |
| Branches against target | tableEx | Values: `dim_Branch[Branch]`, `Sales Value (GHS)`, `Sales Value Target`, `Sales Value Attainment %`, `Sales Value Status` |
| Listings added and sales closed, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Listings Count`, `Sales Count` |

## Added by hand in Desktop

Top N filters, conditional formatting, constant reference lines, page navigator buttons, drill-through pages and bookmarks are not in the generated project files. Add them in Desktop if you want them.
