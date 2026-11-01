# User guide: Hospital Operations dashboard

This dashboard shows how a regional hospital is performing: admissions, bed use, quality of care and the emergency department. **All data is synthetic**, made up for demonstration.

## Who it is for

- Hospital managers who plan beds and staff
- Clinical leads who review quality of care
- Emergency department managers who track waiting times

## How to use it

1. **Choose a period and more** with the filters in the left rail of each page. Your choices carry over to the other pages. Every number on the page responds.
2. **Click a chart element** (a bar, a slice, a month) to filter the rest of the page. Click it again to clear.
3. **Hover over a point** to see extra figures.
4. **Use the page tabs** at the bottom to move between pages.

## The pages

| Page | Question it answers |
| :-- | :-- |
| Hospital overview | How busy is the hospital and how good is care? |
| Wards and stays | Which wards are full, and how long do patients stay? |
| Emergency department | How long do emergency patients wait? |
| Patients and quality | Who is admitted, and how do outcomes differ? |

## What the measures mean

| Measure | Definition |
| :-- | :-- |
| Admissions | Number of admissions. |
| Avg Length of Stay (days) | Average days from admission to discharge. |
| Bed Days Used | Total days patients spent in a bed. |
| Readmission Rate % | Admissions followed by another admission within 30 days, divided by all admissions. |
| Mortality Rate % | Admissions that ended in death, divided by all admissions. |
| Referral Rate % | Admissions referred to another facility, divided by all admissions. |
| NHIS Share % | Share of admissions covered by national health insurance. |
| Occupied Bed Days | Beds occupied, summed over the days selected. |
| Available Bed Days | Beds available, summed over the days selected. |
| Bed Occupancy % | Occupied bed days divided by available bed days. |
| Occupancy Target | The occupancy rate each ward aims for. |
| Occupancy Gap (points) | Occupancy minus its target, in percentage points. |
| ED Visits | Number of emergency department visits. |
| Avg Wait (min) | Average minutes from arrival to being seen. |
| Seen Within Target % | Visits seen within the time target for their triage level. |
| ED Target % | Aim: 90% of visits seen within target. |
| Left Without Being Seen % | Visits where the patient left before being seen. |
| ED Admission Rate % | Emergency visits that led to an admission. |
| Admissions PY | Admissions in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Admissions YoY % | Change in admissions in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Admissions YTD | Admissions from the start of the year to the date shown. |
| Admissions 3M Average | Average monthly admissions over the last three months up to the month shown. |
| ED Visits PY | ED Visits in the same period one year earlier. Use it on a monthly chart, not on a card. |
| ED Visits YoY % | Change in ed visits in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| ED Visits YTD | ED Visits from the start of the year to the date shown. |
| ED Visits 3M Average | Average monthly ed visits over the last three months up to the month shown. |

## Things to know

- Bed occupancy comes from the daily census. It responds to date and ward filters but not to diagnosis or patient filters.
- Length of stay is at least one day. Admissions still open at the end of the data are counted as discharged on the last day.
- The emergency within-target rate uses time targets by triage level: red 10, orange 30, yellow 60 and green 120 minutes.
- There are no individual patients. Patient filters (sex, age group, insurance, district) select profiles.
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
