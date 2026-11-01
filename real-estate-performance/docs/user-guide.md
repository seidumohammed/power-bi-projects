# User guide: Real Estate Performance dashboard

This dashboard shows how a property agency is performing: what it sells, at what price, how fast, and against its targets. **All data is synthetic**, made up for demonstration.

## Who it is for

- Sales directors who track branch results against targets
- Branch managers who coach agents
- Analysts who study prices and time on the market

## How to use it

1. **Choose a period and more** with the filters in the column on the right of each page. Your choices carry over to the other pages. Every number on the page responds.
2. **Click a chart element** (a bar, a slice, a month) to filter the rest of the page. Click it again to clear.
3. **Hover over a point** to see extra figures.
4. **Use the page tabs** at the bottom to move between pages.

## The pages

| Page | Question it answers |
| :-- | :-- |
| Executive summary | How are sales doing overall, and against last year and target? |
| Market and areas | Where are prices highest, and where do homes sell fastest? |
| Agents and branches | Which agents and branches perform best? |
| Listings and targets | Are listings turning into sales, and are branches meeting target? |

## What the measures mean

| Measure | Definition |
| :-- | :-- |
| Sales Count | Number of completed sales. |
| Sales Value (GHS) | Total sale price of completed sales, in Ghana cedis. |
| Avg Sale Price (GHS) | Sales value divided by the number of sales. |
| Avg Price per sqm (GHS) | Sales value divided by the total floor area sold. Mixes property types unless one is selected. |
| Days on Market | Average days from listing to sale for completed sales. |
| Discount to List % | How far sale prices fall below the asking price. |
| Commission (GHS) | Commission at an assumed 3% of the sale price. |
| Listings Count | Number of listings added. |
| Avg List Price (GHS) | Average asking price of listings added. |
| Active Listings | Listings still on the market at the end of the data. |
| Withdrawn Listings | Listings taken off the market without a sale. |
| Sell-Through % | Sales closed divided by listings added in the same period (a guide, not an exact match). |
| Active Agents | Agents with at least one sale. |
| Sales per Agent | Average number of sales per active agent. |
| Value per Agent (GHS) | Average sales value per active agent. |
| Sales Value Target | Planned sales value for the months and filters selected. |
| Sales Value Attainment % | Sales Value divided by its target. |
| Sales Value Variance | Sales Value minus its target. Negative means below target. |
| Sales Value Status | "Met" at 100% or more, "Close" from 95%, otherwise "Missed". |
| Sales Value PY | Sales Value in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Sales Value YoY % | Change in sales value in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Sales Value YTD | Sales Value from the start of the year to the date shown. |
| Sales Value 3M Average | Average monthly sales value over the last three months up to the month shown. |
| Sales Count PY | Sales Count in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Sales Count YoY % | Change in sales count in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Sales Count YTD | Sales Count from the start of the year to the date shown. |
| Sales Count 3M Average | Average monthly sales count over the last three months up to the month shown. |

## Things to know

- Targets are set per branch and month. Filtering by agent, neighbourhood or property type blanks the target cards on purpose.
- Sell-through is sales closed divided by listings added in the same period. A sale can come from an earlier listing, so treat it as a guide.
- Commission uses an assumed 3% rate. It is not a real agency figure.
- Land and office listings are included, so price per square metre mixes property types. Filter by property type for a like-for-like view.
- The data covers January 2024 to December 2025. Year-on-year figures start in 2025.

## Refreshing the data

1. Replace the CSV files in `data/raw` (same file names and columns).
2. Open the report in Power BI Desktop, then Home > Refresh.
3. If you moved the folder, change the `DataFolder` parameter: Home > Transform data > Edit parameters.

The Power Query steps clean known problems. New kinds of problems will need new steps.

## Known limits

- Synthetic data: the patterns were built into the data to make the charts readable.
- There is no row-level security. In a real deployment, restrict each user to the data they should see.
- The date table covers 2024 to 2025 only. Extend the `dim_Date` query for later data.
