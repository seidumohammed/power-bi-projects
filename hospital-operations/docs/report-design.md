# Report design: Hospital Operations

Canvas: 16:9 (1280 x 720). The report theme sets fonts and colours.

## Style system

Every page uses the same building blocks, set by a custom theme file inside the report folder (`StaticResources/RegisteredResources`) and repeated on every page:

| Element | Style |
| :-- | :-- |
| Left rail | A dark rail 250 px wide and full height. It carries the project name and every filter as a dropdown with a small label. The same filter keeps its selection on every page (synced) |
| Page heading | Page title (20 pt, semibold) and a one-line subtitle at the top of the content area |
| KPI cards | Panel with a 10 pt label, a 26 pt semibold value, and a coloured accent bar on the left edge |
| Chart panels | Panel with a 1 px border, 8 px rounded corners, 12 pt semibold title, 9 pt axis and legend text, no axis titles |
| Tables and matrices | Header row in the dark colour with light text, thin horizontal grid lines, subtle alternate row shading |
| Fonts | Segoe UI and Segoe UI Semibold. Nothing larger than 26 pt except the page title |

### Palette

| Use | Colour |
| :-- | :-- |
| Page background | `#EEF3F8` |
| Header band, table headers | `#12355B` |
| Primary (values, main series) | `#1D7A8C` |
| Series 1 | `#1D7A8C` |
| Series 2 (target, prior year) | `#E4572E` |
| Alert | `#E4572E` |
| Muted text | `#5C6B7A` |

## Filters by page

| Page | Filters in the column |
| :-- | :-- |
| Hospital overview | Year, Quarter, Department, Ward, Diagnosis group, Insurance, District of residence |
| Wards and stays | Year, Quarter, Department, Ward, Diagnosis group |
| Emergency department | Year, Quarter, Triage level, Outcome of visit, Insurance |
| Patients and quality | Year, Quarter, Insurance, District of residence, Age group, Sex |

Filters that do not relate to a visual do not change it.

## Page 1: Hospital overview

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Admissions | card | Values: `Admissions` |
| Average stay (days) | card | Values: `Avg Length of Stay (days)` |
| Bed occupancy | card | Values: `Bed Occupancy %` |
| 30-day readmission | card | Values: `Readmission Rate %` |
| Mortality | card | Values: `Mortality Rate %` |
| Admissions against prior year | lineChart | Category: `dim_Date[MonthStart]`; Y: `Admissions`, `Admissions PY` |
| Admissions by diagnosis group | clusteredBarChart | Category: `dim_Diagnosis[DiagnosisGroup]`; Y: `Admissions` |
| Bed occupancy by ward | clusteredColumnChart | Category: `dim_Ward[Ward]`; Y: `Bed Occupancy %` |
| Bed occupancy against target | lineChart | Category: `dim_Date[MonthStart]`; Y: `Bed Occupancy %`, `Occupancy Target` |
## Page 2: Wards and stays

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Wards | tableEx | Values: `dim_Ward[Ward]`, `dim_Ward[Beds]`, `Admissions`, `Avg Length of Stay (days)`, `Bed Occupancy %`, `Mortality Rate %` |
| Average stay by diagnosis group | clusteredBarChart | Category: `dim_Diagnosis[DiagnosisGroup]`; Y: `Avg Length of Stay (days)` |
| Stay against occupancy by ward | scatterChart | Category: `dim_Ward[Ward]`; X: `Avg Length of Stay (days)`; Y: `Bed Occupancy %`; Size: `Admissions` |
| Occupancy by ward and quarter | pivotTable | Rows: `dim_Ward[Ward]`; Columns: `dim_Date[Quarter]`; Values: `Bed Occupancy %` |
## Page 3: Emergency department

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Emergency visits | card | Values: `ED Visits` |
| Average wait (minutes) | card | Values: `Avg Wait (min)` |
| Seen within target | card | Values: `Seen Within Target %` |
| Left without being seen | card | Values: `Left Without Being Seen %` |
| Seen within target, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Seen Within Target %`, `ED Target %` |
| Average wait by triage level | clusteredColumnChart | Category: `fact_ED[TriageLevel]`; Y: `Avg Wait (min)` |
| Visits by outcome | clusteredBarChart | Category: `fact_ED[Disposition]`; Y: `ED Visits` |
| Triage levels | tableEx | Values: `fact_ED[TriageLevel]`, `ED Visits`, `Avg Wait (min)`, `Seen Within Target %`, `Left Without Being Seen %`, `ED Admission Rate %` |
## Page 4: Patients and quality

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Admissions | card | Values: `Admissions` |
| Covered by NHIS | card | Values: `NHIS Share %` |
| 30-day readmission | card | Values: `Readmission Rate %` |
| Referred out | card | Values: `Referral Rate %` |
| Admissions by age group | clusteredColumnChart | Category: `dim_PatientProfile[AgeGroup]`; Y: `Admissions` |
| Admissions by district of residence | clusteredBarChart | Category: `dim_PatientProfile[District]`; Y: `Admissions` |
| Admissions by insurance | donutChart | Category: `dim_PatientProfile[Insurance]`; Y: `Admissions` |
| Quality by diagnosis group | tableEx | Values: `dim_Diagnosis[DiagnosisGroup]`, `Admissions`, `Avg Length of Stay (days)`, `Readmission Rate %`, `Mortality Rate %` |

## Added by hand in Desktop

Top N filters, conditional formatting, constant reference lines, page navigator buttons, drill-through pages and bookmarks are not in the generated project files. Add them in Desktop if you want them.
