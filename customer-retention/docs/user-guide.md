# User guide: Customer Acquisition and Retention dashboard

This dashboard shows how a grocery delivery app wins and keeps customers. **All data is synthetic**, made up for demonstration.

## Who it is for

- Growth managers who decide where to spend
- Retention and CRM managers who plan win-back work
- Finance partners who check unit economics

## How to use it

1. **Choose a period and more** with the filters in the panel on the left of each page. Your choices carry over to the other pages. Every number on the page responds.
2. **Click a chart element** (a bar, a slice, a month) to filter the rest of the page. Click it again to clear.
3. **Hover over a point** to see extra figures.
4. **Use the page tabs** at the bottom to move between pages.

## The pages

| Page | Question it answers |
| :-- | :-- |
| Overview | How is the customer base growing? |
| Acquisition | Which channels win customers, and at what cost? |
| Retention | Who stays, and who leaves? |
| Value | Is a customer worth what it costs to win? |

## What the measures mean

| Measure | Definition |
| :-- | :-- |
| New Customers | Customers who signed up in the dates selected. |
| Churned Customers | Customers who left in the dates selected. |
| Customers at Period End | Customers signed up by the last date shown, minus those who left by then. |
| Customers at Period Start | Customers at the start of the first date shown. |
| Churn Rate % | Customers who left divided by the average size of the base in the period. |
| Retention Rate % | One minus the churn rate. |
| Orders | Number of orders. |
| Revenue | Order value (GHS). |
| Avg Order Value | Revenue per order (GHS). |
| Active Customers | Customers who ordered in the dates selected. |
| Orders per Active Customer | Orders divided by customers who ordered. |
| Repeat Customer % | Customers with two or more orders in the dates selected. |
| Visits | Visits to the app or site. |
| Signups | Accounts created. |
| First Orders | Customers who placed a first order within 30 days of signup. |
| Visit to Signup % | Signups divided by visits. |
| Signup to First Order % | First orders divided by signups. |
| Marketing Spend | Marketing spend (GHS). |
| CAC | Customer acquisition cost: marketing spend per new customer (GHS). |
| Revenue per Customer to Date | All revenue of the customers selected divided by the customers who ordered (GHS). |
| LTV to CAC | Revenue per customer divided by the cost of winning one. |
| New Customers PY | New Customers in the same period one year earlier. Use it on a monthly chart, not on a card. |
| New Customers YoY % | Change in new customers in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| New Customers YTD | New Customers from the start of the year to the date shown. |
| New Customers 3M Average | Average monthly new customers over the last three months up to the month shown. |
| Revenue PY | Revenue in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Revenue YoY % | Change in revenue in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Revenue YTD | Revenue from the start of the year to the date shown. |
| Revenue 3M Average | Average monthly revenue over the last three months up to the month shown. |

## Things to know

- Funnel and spend are recorded by channel and month. CAC and funnel measures respond to channel and date filters but not to segment or region.
- A customer who never orders is treated as churned 30 days after signup.
- Customers at period end is a snapshot, read at the last date shown.
- The app launches in January 2024, so 2024 is a ramp-up year and year-on-year growth in 2025 is large.
- Churn rate is churned customers divided by customers at the start of the period.
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
