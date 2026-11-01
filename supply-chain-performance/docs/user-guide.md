# User guide: Supply Chain Performance dashboard

This dashboard shows how a distributor serves its retail customers: deliveries, stock and suppliers. **All data is synthetic**, made up for demonstration.

## Who it is for

- Supply chain managers who track service levels
- Hub managers who watch stock and delivery
- Procurement staff who review supplier performance

## How to use it

1. **Choose a period and more** with the filters in the left rail of each page. Your choices carry over to the other pages. Every number on the page responds.
2. **Click a chart element** (a bar, a slice, a month) to filter the rest of the page. Click it again to clear.
3. **Hover over a point** to see extra figures.
4. **Use the page tabs** at the bottom to move between pages.

## The pages

| Page | Question it answers |
| :-- | :-- |
| Service overview | Are orders arriving on time and in full? |
| Hubs and carriers | Which hubs and carriers perform best and worst? |
| Inventory | How much stock is held, for how many days, and where do stockouts happen? |
| Suppliers | Which suppliers deliver on time, in full and without rejects? |

## What the measures mean

| Measure | Definition |
| :-- | :-- |
| Order Lines | Number of customer order lines. |
| Orders | Number of distinct customer orders. |
| Units Ordered | Units customers asked for. |
| Units Shipped | Units actually shipped. |
| Fill Rate % | Units shipped divided by units ordered. |
| On-Time % | Order lines delivered on or before the required date. |
| In-Full % | Order lines where the quantity shipped is at least the quantity ordered. |
| OTIF % | Order lines delivered both on time and in full. |
| Late Lines | Order lines delivered after the required date. |
| Avg Lead Time (days) | Average days from order to delivery. |
| Shipped Value (GHS) | Value of units shipped at list price, in Ghana cedis. |
| Freight Cost (GHS) | Total freight cost. |
| Freight per Unit (GHS) | Freight cost divided by units shipped. |
| OTIF Target | The OTIF rate each hub aims for in the months selected. |
| OTIF Attainment % | OTIF divided by its target. |
| OTIF Gap (points) | OTIF minus its target, in percentage points. Negative means below target. |
| OTIF Status | "Met" at 100% or more, "Close" from 95%, otherwise "Missed". |
| Stock On Hand (units) | Units in stock at the last month-end of the period selected. |
| Stock Value (GHS) | Stock on hand valued at unit cost. |
| Days of Cover | Days the closing stock would last at the demand of the last month. |
| Stockout Rate % | Share of month-end hub and product counts that were at zero. |
| Supplier Deliveries | Number of supplier delivery lines. |
| Supplier On-Time % | Supplier deliveries received on or before the expected date. |
| Supplier Fill % | Units received divided by units ordered from suppliers. |
| Rejection Rate % | Units rejected on arrival divided by units received. |
| Supplier Lead Time (days) | Average days from purchase order to receipt. |
| Shipped Value PY | Shipped Value in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Shipped Value YoY % | Change in shipped value in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Shipped Value YTD | Shipped Value from the start of the year to the date shown. |
| Shipped Value 3M Average | Average monthly shipped value over the last three months up to the month shown. |
| Order Lines PY | Order Lines in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Order Lines YoY % | Change in order lines in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Order Lines YTD | Order Lines from the start of the year to the date shown. |
| Order Lines 3M Average | Average monthly order lines over the last three months up to the month shown. |

## Things to know

- On time means the delivery date is on or before the required date. In full means the quantity shipped is at least the quantity ordered. OTIF needs both.
- Stock figures are month-end counts. For a period they show the closing position of the last month selected.
- The OTIF target is set per hub. Filtering by carrier, customer or category blanks the target on purpose.
- Suppliers and customers are linked to products only through the transactions, so a supplier filter does not change the order-line pages.
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
