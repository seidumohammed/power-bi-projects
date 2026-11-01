# Data dictionary: Programme Monitoring

All data is synthetic and was generated with a fixed random seed. Names, places and values are illustrative and describe no real person, community, savings group or programme. The setting is the Central Region of Ghana. District names are real district names used only as labels; the three "zones" (Western Coast, Central Coast, Eastern Coast) are an invented grouping.

## Raw files (data/raw)

| File | Rows | Description |
| :-- | --: | :-- |
| `districts.csv` | 12 | District and zone lookup (Central Region) |
| `communities.csv` | 60 | Five communities per district |
| `officers.csv` | 18 | Field officers, with team and home zone |
| `visits.csv` | 12,840 | One row per planned field visit, completed or missed |
| `vsla_groups.csv` | 48 | Savings groups, each with an invented name |
| `vsla_meetings.csv` | 1,082 | One row per monthly group meeting |
| `targets.csv` | 72 | Monthly visit and savings targets by zone |

## Columns after cleaning

**fact_Visit**

| Column | Type | Meaning |
| :-- | :-- | :-- |
| VisitID | Text | Unique visit key |
| VisitDate | Date | Date of the visit |
| OfficerID | Text | Field officer |
| CommunityID | Text | Community visited |
| VisitType | Text | Training, Monitoring, Data Collection or Follow-up |
| VisitStatus | Text | Completed or Missed |
| FarmersVisited | Whole number | Farmers reached (0 when missed) |
| DurationMin | Whole number | Visit length in minutes |
| RecordsCollected | Whole number | Data records captured |
| RecordsWithErrors | Whole number | Records that failed the quality check |

**fact_VslaMeeting**

| Column | Type | Meaning |
| :-- | :-- | :-- |
| MeetingID, GroupID | Text | Keys |
| MeetingDate | Date | Date of the meeting |
| MembersPresent | Whole number | Attendance |
| SavingsGHS | Decimal | Savings collected, in Ghana cedis |
| LoansDisbursedGHS | Decimal | Loans issued |
| LoansRepaidGHS | Decimal | Loans repaid |

**fact_Target**: MonthStart (date), Zone, VisitsTarget, SavingsTargetGHS.

**Dimensions**: see `powerquery/queries.pq` for the renamed columns of `dim_Officer`, `dim_Community`, `dim_District`, `dim_Zone`, `dim_VslaGroup` and `dim_Date`.

## Deliberate data problems and how Power Query fixes them

| File | Problem injected | Share | Fix in Power Query |
| :-- | :-- | --: | :-- |
| visits.csv | Dates written dd/MM/yyyy instead of yyyy-MM-dd | about 3% | `try` one format, `otherwise` the other |
| visits.csv | Duplicate rows (same visit_id) | about 1% | `Table.Distinct` on `visit_id` |
| visits.csv | visit_type with stray spaces and mixed case | about 5% | trim, proper-case, restore "Follow-up" |
| vsla_meetings.csv | Dates in two formats | about 2% | same `try` pattern |
| vsla_meetings.csv | savings_ghs stored as text such as "GHS 1,250.00" | about 4% | strip "GHS" and commas, convert to number |
| vsla_meetings.csv | Duplicate rows (same meeting_id) | about 1% | `Table.Distinct` on `meeting_id` |
| officers.csv | home_zone in mixed case with stray spaces | about 20% | trim and proper-case |

## Built-in patterns in the data

These make the charts worth reading. They are designed, not real findings.

- The data error rate falls from about 12% in the first half of 2024 to about 5% in late 2025, after a quality push in mid-2024.
- Visits and savings sit close to their targets, with zone-months ranging from about 75% to 120% of target.
- Visit numbers grow steadily across the two years.
- Officers differ in error rate, so the officer view shows clear outliers.
- Savings per meeting rise slowly, and about 5% of meetings are missed.
