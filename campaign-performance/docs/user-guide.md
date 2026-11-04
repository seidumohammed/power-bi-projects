# User guide: Campaign Performance dashboard

This dashboard shows how paid advertising is performing for an online retailer: reach, cost, conversions, return and budget. **All data is synthetic**, made up for demonstration.

## Who it is for

- Marketing managers who set budgets
- Media buyers who tune campaigns
- Finance partners who check marketing spend

## How to use it

1. **Choose a period and more** with the filters in the row under the top bar. Your choices carry over to the other pages. Every number on the page responds.
2. **Click a chart element** (a bar, a slice, a month) to filter the rest of the page. Click it again to clear.
3. **Hover over a point** to see extra figures.
4. **Use the page tabs** at the bottom to move between pages.

## The pages

| Page | Question it answers |
| :-- | :-- |
| Overview | How much did we spend, and what did it return? |
| Channels | Which channels are efficient? |
| Campaigns | Which campaigns earn their budget? |
| Budget and trends | Are we on budget, and are costs rising? |

## What the measures mean

| Measure | Definition |
| :-- | :-- |
| Spend | Money spent on advertising (GHS). |
| Impressions | Times ads were shown. |
| Clicks | Clicks on ads. |
| Conversions | Orders attributed to ads. |
| Revenue | Revenue attributed to ads (GHS). |
| CTR % | Clicks divided by impressions. |
| CPC | Spend per click (GHS). |
| CPM | Spend per 1,000 impressions (GHS). |
| Conversion Rate % | Conversions divided by clicks. |
| CPA | Spend per conversion (GHS). |
| ROAS | Revenue for each GHS 1 spent. |
| Avg Order Value | Revenue per conversion (GHS). |
| Budget | Planned spend for the months and channels selected. |
| Budget Used % | Spend divided by budget. |
| Budget Remaining | Budget minus spend. Negative means overspent. |
| Spend PY | Spend in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Spend YoY % | Change in spend in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Spend YTD | Spend from the start of the year to the date shown. |
| Spend 3M Average | Average monthly spend over the last three months up to the month shown. |
| Revenue PY | Revenue in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Revenue YoY % | Change in revenue in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Revenue YTD | Revenue from the start of the year to the date shown. |
| Revenue 3M Average | Average monthly revenue over the last three months up to the month shown. |

## Things to know

- Revenue is the revenue attributed to ads, not total company revenue.
- Budget measures are blank when a campaign, objective or category is selected, because budgets are set by channel.
- Black Friday in November lifts spend and revenue in both years.
- TikTok grows through the period; Meta cost per acquisition rises.
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
