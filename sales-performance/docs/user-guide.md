# User guide: Sales Performance dashboard

This dashboard shows how a retail business is performing: what it sells, where, to whom, and how sales compare with targets. **All data is synthetic**, made up for demonstration, and describes no real business.

## Who it is for

- Managers who track sales against targets
- Store managers who compare their store with others
- Buyers and category managers who review product performance

## How to use it

1. **Choose a period, store, channel and more** with the filters in the column on the right of each page. Your choices carry over to the other pages. Every number on the page responds.
2. **Click a chart element** (a bar, a slice, a month) to filter the rest of the page. Click it again to clear.
3. **Hover over a point** to see extra figures such as change on last year.
4. **Right-click a product** on the Products page and choose Drill through > Product detail to see that product's sales by month, store and customer segment.
5. **Use the page buttons** at the top to move between pages.

## The pages

| Page | Question it answers |
| :-- | :-- |
| Executive summary | How are we doing overall, and against last year? |
| Products | Which products and categories drive sales and margin? |
| Stores and customers | Which stores and customer segments perform best? How fast is online growing? |
| Targets and trends | Are stores meeting their targets? What is the underlying trend? |

## What the measures mean

| Measure | Definition |
| :-- | :-- |
| Gross Sales | Quantity times list price, before discounts |
| Net Sales | Gross sales minus discounts |
| Discount Rate | Discounts divided by gross sales |
| Profit | Net sales minus the cost of goods sold |
| Profit Margin % | Profit divided by net sales |
| Orders | Number of distinct orders (an order can have several lines) |
| Avg Order Value | Net sales divided by orders |
| Net Sales YoY % | Change in net sales in the latest year selected compared with the year before (same quarters if a quarter is selected). With no year selected it compares 2025 with 2024 |
| Net Sales 3M Average | Average monthly net sales over the last three months up to the month shown |
| Target Attainment % | Net sales divided by the sales target for the same months and stores |
| Target Status | "Met" at 100% or more, "Close" from 95%, otherwise "Missed" |
| % of Total Net Sales | Share of the total for the items currently selected |

## Things to know

- The data covers January 2024 to December 2025, so year-on-year figures appear only for 2025.
- Targets are set per store and month. If you filter by product or customer segment, the target does not change, so attainment is only meaningful for store and date filters.
- December is the peak month. Compare it with the previous December, not with November.
- "Customer home store" is a description only. Sales are always counted in the store that made the sale.

## Refreshing the data

1. Replace the CSV files in `data/raw` (same file names and columns).
2. Open the report in Power BI Desktop, then Home > Refresh.
3. If you moved the folder, change the `DataFolder` parameter: Home > Transform data > Manage parameters.

The Power Query steps clean known problems (mixed date formats, duplicates, text in number columns, inconsistent product codes). New kinds of problems will need new steps.

## Known limits

- Synthetic data: the seasonality and growth were built into the data to make the charts readable.
- There is no row-level security. In a real deployment, limit each store manager to their own store.
- The date table covers 2024 to 2025 only. Extend the `dim_Date` query for later data.
