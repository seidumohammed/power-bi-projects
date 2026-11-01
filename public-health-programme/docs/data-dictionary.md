# Data dictionary: Public Health Programme

All data is synthetic and was generated with a fixed random seed. The directorate and all figures are invented. District names are real Northern Region districts used only as labels; facility names are made up.

## Raw files (data/raw)

| File | Rows | Description |
| :-- | --: | :-- |
| `districts.csv` | 10 | Districts, subregions and populations |
| `facilities.csv` | 65 | Health facilities, levels and catchment populations |
| `antigens.csv` | 4 | Vaccines |
| `diseases.csv` | 4 | Notifiable diseases |
| `immunisation.csv` | 6,302 | Doses and target children per facility, vaccine and month |
| `cases.csv` | 6,302 | Cases, deaths and tests per facility, disease and month |
| `reporting.csv` | 1,576 | Monthly report received and on time, per facility |
| `targets.csv` | 240 | Monthly coverage target per district |

## Columns after cleaning

**dim_District**: DistrictID (string), District (string), Subregion (string), Population (int64)
**dim_Facility**: FacilityID (string), Facility (string), DistrictID (string), FacilityLevel (string), CatchmentPopulation (int64)
**dim_Antigen**: AntigenID (string), Antigen (string), Schedule (string)
**dim_Disease**: DiseaseID (string), Disease (string), Type (string)
**fact_Immunisation**: RecordID (string), Month (dateTime), FacilityID (string), AntigenID (string), Doses (int64), TargetChildren (int64)
**fact_Cases**: CaseRecordID (string), Month (dateTime), FacilityID (string), DiseaseID (string), Cases (int64), Deaths (int64), Tested (int64), Positive (int64)
**fact_Reporting**: ReportID (string), Month (dateTime), FacilityID (string), Submitted (int64), OnTime (int64)
**fact_Target**: MonthStart (dateTime), District (string), CoverageTarget (double)
**dim_Date**: Date (dateTime), Year (int64), Quarter (string), MonthNumber (int64), MonthName (string), MonthStart (dateTime), YearMonth (string), DayNumber (int64), DayName (string), IsWeekend (boolean)

## Deliberate data problems and how Power Query fixes them

| File | Problem injected | Rows affected | Fix in Power Query |
| :-- | :-- | --: | :-- |
| facilities.csv | facility level with stray spaces | 5 | trim |
| immunisation.csv | month written dd/MM/yyyy | 197 | try one format, then the other |
| immunisation.csv | duplicate record rows (same record_id) | 62 | keep one per record_id |
| cases.csv | month written dd/MM/yyyy | 199 | try one format, then the other |
| cases.csv | duplicate case record rows (same case_record_id) | 62 | keep one per case_record_id |
| reporting.csv | month written dd/MM/yyyy | 46 | try one format, then the other |
| reporting.csv | duplicate report rows (same report_id) | 16 | keep one per report_id |

After these steps every key matches and every date parses.

## Built-in patterns in the data

These make the charts worth reading. They are designed, measured on the generated data, and not real findings.

- Coverage averages 83% against a 90% target: Tamale Metropolitan is highest (91%) and Gushegu lowest (67%).
- Coverage improves from 81% in 2024 to 84% in 2025.
- Penta dropout is 10.3% (children who started the series but did not finish).
- Malaria follows the rains: May is the peak month and November the lowest.
- Meningitis follows the dry season: March is the peak month, with an outbreak in February and March 2025.
- Reporting completeness is 88% overall: Hospital facilities report best (94%) and CHPS compound facilities worst (85%).

## Totals to check after a refresh

Use these to confirm that the report loads and calculates correctly (no filters applied):

| Measure | Expected value with no filters |
| :-- | :-- |
| `Doses Given` | 378,417 |
| `Children Targeted` | 456,140 |
| `Coverage %` | 83.0% |
| `Penta Dropout %` | 10.3% |
| `Cases` | 218,428 |
| `Deaths` | 1,460 |
| `Case Fatality %` | 0.67% |
| `Tests Done` | 292,763 |
| `Test Positivity %` | 45.3% |
| `Catchment Population` | 1,627,668 |
| `Reports Expected` | 1,560 |
| `Reports Submitted` | 1,370 |
| `Reporting Completeness %` | 87.8% |
| `Reporting Timeliness %` | 86.4% |
| `Facilities` | 65 |
| `Doses YoY %` | 3.8% |
| `Cases YoY %` | -3.2% |
