# Report design: Supply Chain Performance

Canvas: 16:9 (1280 x 720). The report theme sets fonts and colours.

## Style system

Every page uses the same building blocks, set by a custom theme file inside the report folder (`StaticResources/RegisteredResources`) and repeated on every page:

| Element | Style |
| :-- | :-- |
| Left rail | A dark rail 250 px wide and full height. It carries the project name and every filter as a dropdown with a small label. The same filter keeps its selection on every page (synced) |
| Page heading | Page title (20 pt, semibold) and a one-line subtitle at the top of the content area |
| KPI cards | Panel with a 10 pt label, a 26 pt semibold value, and a coloured accent bar along the top edge |
| Chart panels | Panel with a 1 px border, 6 px rounded corners, 12 pt semibold title, 9 pt axis and legend text, no axis titles |
| Tables and matrices | Header row in the dark colour with light text, thin horizontal grid lines, subtle alternate row shading |
| Fonts | Segoe UI and Segoe UI Semibold. Nothing larger than 26 pt except the page title |

### Palette

| Use | Colour |
| :-- | :-- |
| Page background | `#F4F1EA` |
| Header band, table headers | `#22333B` |
| Primary (values, main series) | `#B86B12` |
| Series 1 | `#B86B12` |
| Series 2 (target, prior year) | `#22333B` |
| Alert | `#C8553D` |
| Muted text | `#6B7280` |

## Filters by page

| Page | Filters in the column |
| :-- | :-- |
| Service overview | Year, Quarter, Hub, Customer region, Customer type, Category, Carrier |
| Hubs and carriers | Year, Quarter, Hub, Carrier, Customer region, Category |
| Inventory | Year, Quarter, Hub, Category, Product |
| Suppliers | Year, Quarter, Supplier, Hub, Category |

Filters that do not relate to a visual do not change it.

## Page 1: Service overview

| Visual | Type | Fields |
| :-- | :-- | :-- |
| On time, in full | card | Values: `OTIF %` |
| On time | card | Values: `On-Time %` |
| In full | card | Values: `In-Full %` |
| Fill rate | card | Values: `Fill Rate %` |
| Lead time (days) | card | Values: `Avg Lead Time (days)` |
| OTIF against target, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `OTIF %`, `OTIF Target` |
| OTIF by hub | clusteredBarChart | Category: `dim_Warehouse[Warehouse]`; Y: `OTIF %` |
| OTIF by carrier | clusteredColumnChart | Category: `dim_Carrier[Carrier]`; Y: `OTIF %` |
| Order lines by month | areaChart | Category: `dim_Date[MonthStart]`; Y: `Order Lines` |
## Page 2: Hubs and carriers

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Hubs against target | tableEx | Values: `dim_Warehouse[Warehouse]`, `Order Lines`, `OTIF %`, `Fill Rate %`, `Avg Lead Time (days)`, `OTIF Status` |
| Carriers | tableEx | Values: `dim_Carrier[Carrier]`, `Order Lines`, `OTIF %`, `Late Lines`, `Freight per Unit (GHS)` |
| Freight per unit against OTIF | scatterChart | Category: `dim_Carrier[Carrier]`; X: `Freight per Unit (GHS)`; Y: `OTIF %`; Size: `Order Lines` |
| OTIF by hub and quarter | pivotTable | Rows: `dim_Warehouse[Warehouse]`; Columns: `dim_Date[Quarter]`; Values: `OTIF %` |
## Page 3: Inventory

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Stock on hand (units) | card | Values: `Stock On Hand (units)` |
| Stock value (GHS) | card | Values: `Stock Value (GHS)` |
| Days of cover | card | Values: `Days of Cover` |
| Stockout rate | card | Values: `Stockout Rate %` |
| Stock on hand at month-end | lineChart | Category: `dim_Date[MonthStart]`; Y: `Stock On Hand (units)` |
| Days of cover by hub | clusteredBarChart | Category: `dim_Warehouse[Warehouse]`; Y: `Days of Cover` |
| Stockout rate by category | clusteredColumnChart | Category: `dim_Product[Category]`; Y: `Stockout Rate %` |
| Products | tableEx | Values: `dim_Product[Product]`, `dim_Product[Category]`, `Stock On Hand (units)`, `Days of Cover`, `Stockout Rate %` |
## Page 4: Suppliers

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Supplier on time | card | Values: `Supplier On-Time %` |
| Supplier fill rate | card | Values: `Supplier Fill %` |
| Rejection rate | card | Values: `Rejection Rate %` |
| Lead time (days) | card | Values: `Supplier Lead Time (days)` |
| Supplier on-time rate | clusteredBarChart | Category: `dim_Supplier[Supplier]`; Y: `Supplier On-Time %` |
| Supplier on-time and fill rate, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Supplier On-Time %`, `Supplier Fill %` |
| Suppliers | tableEx | Values: `dim_Supplier[Supplier]`, `dim_Supplier[Origin]`, `Supplier Deliveries`, `Supplier On-Time %`, `Rejection Rate %`, `Supplier Lead Time (days)` |
| Lead time against on-time rate | scatterChart | Category: `dim_Supplier[Supplier]`; X: `Supplier Lead Time (days)`; Y: `Supplier On-Time %`; Size: `Supplier Deliveries` |

## Added by hand in Desktop

Top N filters, conditional formatting, constant reference lines, page navigator buttons, drill-through pages and bookmarks are not in the generated project files. Add them in Desktop if you want them.
