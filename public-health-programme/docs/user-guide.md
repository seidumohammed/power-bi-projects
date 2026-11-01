# User guide: Public Health Programme dashboard

This dashboard shows how a regional health directorate is performing: immunisation, disease surveillance and reporting. **All data is synthetic**, made up for demonstration.

## Who it is for

- Regional and district health directors who manage programmes
- Disease control officers who track outbreaks
- Data managers who check the quality of reporting

## How to use it

1. **Choose a period and more** with the filters in the column on the right of each page. Your choices carry over to the other pages. Every number on the page responds.
2. **Click a chart element** (a bar, a slice, a month) to filter the rest of the page. Click it again to clear.
3. **Hover over a point** to see extra figures.
4. **Use the page tabs** at the bottom to move between pages.

## The pages

| Page | Question it answers |
| :-- | :-- |
| Programme overview | How is the directorate doing overall? |
| Immunisation | Which districts and vaccines fall short of target? |
| Disease surveillance | Which diseases are rising, and where? |
| Reporting and facilities | Can the data be trusted, and who is late? |

## What the measures mean

| Measure | Definition |
| :-- | :-- |
| Doses Given | Vaccine doses given. |
| Children Targeted | Children expected to be vaccinated in the months selected. |
| Coverage % | Doses given divided by children targeted. |
| Coverage Target | The coverage each district aims for. |
| Coverage Gap (points) | Coverage minus its target, in percentage points. |
| Penta 1 Doses | First Penta doses given. |
| Penta 3 Doses | Third Penta doses given. |
| Penta Dropout % | Children who started Penta but did not finish the series. |
| Cases | Reported cases. |
| Deaths | Reported deaths. |
| Case Fatality % | Deaths divided by cases. |
| Tests Done | Tests done. |
| Test Positivity % | Positive tests divided by tests done. |
| Catchment Population | People living in the catchment areas of the facilities selected. |
| Cases per 1,000 | Cases per 1,000 people in the catchment, for the months selected. |
| Reports Expected | Monthly reports expected: one per facility per month. |
| Reports Submitted | Reports received. |
| Reports On Time | Reports received by the deadline. |
| Reporting Completeness % | Reports received divided by reports expected. |
| Reporting Timeliness % | Reports on time divided by reports received. |
| Facilities | Number of facilities. |
| Doses PY | Doses in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Doses YoY % | Change in doses in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Doses YTD | Doses from the start of the year to the date shown. |
| Doses 3M Average | Average monthly doses over the last three months up to the month shown. |
| Cases PY | Cases in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Cases YoY % | Change in cases in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Cases YTD | Cases from the start of the year to the date shown. |
| Cases 3M Average | Average monthly cases over the last three months up to the month shown. |

## Things to know

- Coverage and dropout respond to antigen filters. Disease measures respond to the disease filter.
- Incidence is cases per 1,000 people in the catchment populations of the facilities selected.
- Case fatality is deaths divided by cases. Test positivity is positive tests divided by tests done.
- Reporting is expected from every facility every month.
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
