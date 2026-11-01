# User guide: Programme Monitoring dashboard

This dashboard shows how a field programme is performing: how many visits the team completes, how good the data is, and how the savings groups are doing. **All data is synthetic**, made up for demonstration, and describes no real programme or savings group. The setting is the Central Region of Ghana.

## Who it is for

- Programme managers who track field activity and targets
- Team leads who coach field officers on data quality
- Anyone who needs a quick view of savings group results

## How to use it

1. **Choose a period and zone** with the filters in the column on the right of each page. Your choices carry over to the other pages. Every number on the page responds.
2. **Click a chart element** (a bar, a slice, a month) to filter the rest of the page. Click it again to clear.
3. **Hover over a point** to see extra figures such as change on last year and progress against target.
4. **Right-click an officer** on the Field team page and choose Drill through > Officer detail to see that person's trend.
5. **Use the page buttons** at the top to move between pages.

## The pages

| Page | Question it answers |
| :-- | :-- |
| Overview | Are we on track overall? |
| Field team | Which officers and teams need support? |
| Data quality | Is the quality of collected data improving? Where are errors concentrated? |
| Savings groups | How much are groups saving, and are loans being repaid? |

## What the measures mean

| Measure | Definition |
| :-- | :-- |
| Visits Completed | Visits with status "Completed" (missed visits are excluded) |
| Completion Rate | Completed visits divided by all planned visits |
| Farmers Reached | Farmers seen during completed visits |
| Data Error Rate | Records with errors divided by records collected |
| Error Rate Target | 5%. The status turns red above it |
| Visits Target | Monthly zone target. Blank when you filter by officer or team, because targets are set per zone |
| Savings (GHS) | Money saved at group meetings, in Ghana cedis |
| Loan Repayment Rate | Loans repaid divided by loans disbursed |
| Attendance Rate | Members present divided by total group membership |

## Things to know

- Targets exist only at zone level. If you select an officer or a team, the target cards go blank on purpose.
- The data covers January 2024 to December 2025. Year-on-year figures start in 2025.
- Missing meetings are real gaps in the data, not zeros. About 5% of meetings were not held.

## Refreshing the data

1. Replace the CSV files in `data/raw` (same file names and columns).
2. Open the report in Power BI Desktop, then Home > Refresh.
3. If you moved the folder, change the `DataFolder` parameter: Home > Transform data > Manage parameters.

The Power Query steps clean known problems (mixed date formats, duplicates, text in number columns). New kinds of problems will need new steps.

## Known limits

- Synthetic data: patterns such as the fall in error rate were built into the data to make the charts readable.
- The model has no row-level security. In a real deployment, restrict each team lead to their own officers.
- The date table covers 2024 to 2025 only. Extend the `dim_Date` query for later data.
