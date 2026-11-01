# User guide: FinTech Payments dashboard

This dashboard shows how a mobile wallet provider is performing: payments, reliability, customers, fraud and loans. **All data is synthetic**, made up for demonstration.

## Who it is for

- Product and operations teams who track payment reliability
- Growth teams who watch customers and channels
- Risk teams who monitor fraud and loan quality

## How to use it

1. **Choose a period and more** with the filters in the row across the top of each page. Your choices carry over to the other pages. Every number on the page responds.
2. **Click a chart element** (a bar, a slice, a month) to filter the rest of the page. Click it again to clear.
3. **Hover over a point** to see extra figures.
4. **Use the page tabs** at the bottom to move between pages.

## The pages

| Page | Question it answers |
| :-- | :-- |
| Overview | How much is flowing through the wallet, and against target? |
| Channels and reliability | Which channels fail most, and why? |
| Customers and growth | How many customers are active and how fast is the base growing? |
| Fraud and loans | How large are fraud losses and loan arrears? |

## What the measures mean

| Measure | Definition |
| :-- | :-- |
| Transactions | Number of transaction attempts, successful or not. |
| Successful Transactions | Transactions that completed. |
| Failed Transactions | Transactions that failed. |
| Success Rate % | Successful transactions divided by all attempts. |
| Failure Rate % | Failed transactions divided by all attempts. |
| Reversal Rate % | Transactions reversed after completing, divided by all attempts. |
| Txn Value (GHS) | Value of successful transactions, in Ghana cedis. |
| Avg Txn Value (GHS) | Average value of a successful transaction. |
| Fee Revenue (GHS) | Fees charged on successful transactions. |
| Active Customers | Customers with at least one successful transaction in the period. |
| New Customers | Customers who joined in the period selected. |
| Txns per Active Customer | Successful transactions divided by active customers. |
| Fraud Cases | Transactions flagged as fraud. |
| Fraud Rate (per 10,000) | Fraud cases per 10,000 transactions. |
| Fraud Value (GHS) | Value of transactions flagged as fraud. |
| Loans Disbursed (count) | Number of loans disbursed. |
| Loans Disbursed (GHS) | Value of loans disbursed. |
| Loans Outstanding (GHS) | Balance still owed on loans. |
| PAR30 % | Portfolio at risk: balance of loans more than 30 days late divided by the total balance owed. |
| Default Rate % | Loans in default divided by loans disbursed. |
| Avg Loan Size (GHS) | Average loan amount. |
| Txn Value Target | Planned txn value for the months and filters selected. |
| Txn Value Attainment % | Txn Value divided by its target. |
| Txn Value Variance | Txn Value minus its target. Negative means below target. |
| Txn Value Status | "Met" at 100% or more, "Close" from 95%, otherwise "Missed". |
| Txn Value PY | Txn Value in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Txn Value YoY % | Change in txn value in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Txn Value YTD | Txn Value from the start of the year to the date shown. |
| Txn Value 3M Average | Average monthly txn value over the last three months up to the month shown. |
| Fee Revenue PY | Fee Revenue in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Fee Revenue YoY % | Change in fee revenue in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Fee Revenue YTD | Fee Revenue from the start of the year to the date shown. |
| Fee Revenue 3M Average | Average monthly fee revenue over the last three months up to the month shown. |

## Things to know

- Transaction value counts successful transactions only. Rates (success, failure, reversal) use all attempts.
- Active customers are customers with at least one successful transaction in the period selected.
- Fraud rate is shown per 10,000 transactions because the rate is small.
- Portfolio at risk (PAR30) is the outstanding balance of loans more than 30 days late divided by all outstanding balances.
- Targets are set per region and month. Filtering by segment, transaction type or channel blanks the target on purpose.
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
