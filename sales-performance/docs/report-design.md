# Report design: Sales Performance

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
| Page background | `#F0F3F8` |
| Header band, table headers | `#14213D` |
| Primary (values, main series) | `#1F5F8B` |
| Series 1 (this year) | `#1F5F8B` |
| Series 2 (target, prior year) | `#F29E4C` |
| Good / alert | `#3A9D6F` / `#D1495B` |
| Muted text | `#5F6B73` |

Blue means this year, orange means target or prior year, red is for a miss.


## Filters by page

| Page | Filters in the column |
| :-- | :-- |
| Executive summary | Year, Quarter, Store, Region, Channel, Customer segment, Product category |
| Products | Year, Quarter, Product category, Subcategory, Store, Channel, Customer segment |
| Stores and customers | Year, Quarter, Store, Region, Customer segment, Channel, Product category |
| Targets and trends | Year, Quarter, Store, Region |

Filters that do not relate to a visual do not change it. For example, in the programme report Team and Visit type filter visits and data quality, but not savings.

## Page 1: Executive summary

| Visual | Fields |
| :-- | :-- |
| Filters | In the filter column on the right (see "Filters by page") |
| Cards (row of five) | `Net Sales (GHS)`, `Profit Margin %`, `Orders`, `Avg Order Value (GHS)`, `Target Attainment %` |
| Line chart | Axis `dim_Date[MonthStart]`; values `Net Sales (GHS)`, `Net Sales PY (GHS)` |
| Clustered bar | Axis `dim_Store[Store]`; value `Net Sales (GHS)` |
| Donut | Legend `dim_Product[Category]`; value `Net Sales (GHS)` |

Show `Net Sales YoY %` as the small secondary value on the first card.

## Page 2: Products

| Visual | Fields |
| :-- | :-- |
| Slicers | `dim_Product[Category]`, `dim_Date[Year]` |
| Bar chart | Axis `dim_Product[ProductName]`; value `Net Sales (GHS)`; filter Top 10 by `Net Sales (GHS)` |
| Treemap | Group `dim_Product[Category]`, details `dim_Product[Subcategory]`; value `Net Sales (GHS)` |
| Scatter | X `Net Sales (GHS)`, Y `Profit Margin %`, details `dim_Product[Subcategory]`, size `Units Sold` |
| Table | `ProductName`, `Units Sold`, `Net Sales (GHS)`, `% of Total Net Sales`, `Profit Margin %`, `Product Rank` |

Conditional formatting: data bars on `Net Sales (GHS)`; red font where `Profit Margin %` is below 15%.

## Page 3: Stores and customers

| Visual | Fields |
| :-- | :-- |
| Slicers | `dim_Customer[Segment]`, `dim_Date[Year]` |
| Matrix | Rows `dim_Store[Store]`; columns `dim_Date[Quarter]`; value `Net Sales (GHS)`; colour scale |
| Clustered column | Axis `dim_Customer[Segment]`; values `Net Sales (GHS)`, `Discount Rate` (secondary axis) |
| Line chart | Axis `dim_Date[MonthStart]`; values `Online Share %` |
| Cards | `Active Customers`, `Discount Rate` |

## Page 4: Targets and trends

| Visual | Fields |
| :-- | :-- |
| Slicer | `dim_Date[Year]` |
| Combo chart | Axis `dim_Date[MonthStart]`; columns `Net Sales (GHS)`; line `Sales Target (GHS)` |
| Table | `Store`, `Net Sales (GHS)`, `Sales Target (GHS)`, `Variance to Target (GHS)`, `Target Attainment %`, `Target Status` |
| Gauge | Value `Target Attainment %`, target value 1 |
| Line chart | Axis `dim_Date[MonthStart]`; values `Net Sales (GHS)`, `Net Sales 3M Average (GHS)` |

Conditional formatting on `Target Status`: green for "Met", amber for "Close", red for "Missed".

## Interaction and navigation

- Add a page navigator (Insert > Buttons > Navigator > Page navigator) at the top of every page.
- Add one drill-through page "Product detail" (hidden): drill-through field `dim_Product[ProductName]`; show sales by month, by store and by customer segment. Right-click a product on page 2 to reach it.
- Add a bookmark pair on page 1 for "Net sales" and "Profit" views of the main chart, switched with a button or field parameter.
- Edit interactions so the donut filters the cards but not the line chart if you want the trend to stay whole.

## Accessibility and polish checklist

- Alt text on every visual.
- Tab order matches reading order (View > Selection pane).
- Contrast of text on coloured backgrounds at least 4.5 to 1.
- No more than six visuals per page.
- Units in titles ("Net sales, GHS", "Profit margin, % of net sales").
