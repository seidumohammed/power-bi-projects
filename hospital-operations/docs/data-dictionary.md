# Data dictionary: Hospital Operations

All data is synthetic and was generated with a fixed random seed. The hospital and all records are invented. There are no individual patients, only profiles. District names are real Volta Region districts used only as labels.

## Raw files (data/raw)

| File | Rows | Description |
| :-- | --: | :-- |
| `wards.csv` | 7 | Wards, departments and beds |
| `diagnoses.csv` | 9 | Diagnosis groups |
| `profiles.csv` | 360 | Patient profiles (sex, age group, insurance, district) |
| `admissions.csv` | 17,939 | One row per admission |
| `census.csv` | 5,117 | Beds occupied per ward and day |
| `ed_visits.csv` | 25,487 | One row per emergency visit |
| `targets.csv` | 168 | Monthly occupancy target per ward |

## Columns after cleaning

**dim_Ward**: WardID (string), Ward (string), Department (string), Beds (int64)
**dim_Diagnosis**: DiagnosisID (string), DiagnosisGroup (string), Category (string)
**dim_PatientProfile**: ProfileID (string), Sex (string), AgeGroup (string), Insurance (string), District (string)
**fact_Admission**: AdmissionID (string), AdmitDate (dateTime), DischargeDate (dateTime), ProfileID (string), WardID (string), DiagnosisID (string), Outcome (string), Readmitted30 (int64), LengthOfStay (int64), IsDeceased (int64), IsReferred (int64)
**fact_Census**: CensusDate (dateTime), WardID (string), OccupiedBeds (int64)
**fact_ED**: VisitID (string), ArrivalDate (dateTime), ProfileID (string), TriageLevel (string), WaitMinutes (double), Disposition (string), IsWithinTarget (int64), IsLWBS (int64), IsAdmitted (int64)
**fact_Target**: MonthStart (dateTime), Ward (string), OccupancyTarget (double)
**dim_Date**: Date (dateTime), Year (int64), Quarter (string), MonthNumber (int64), MonthName (string), MonthStart (dateTime), YearMonth (string), DayNumber (int64), DayName (string), IsWeekend (boolean)

## Deliberate data problems and how Power Query fixes them

| File | Problem injected | Rows affected | Fix in Power Query |
| :-- | :-- | --: | :-- |
| profiles.csv | sex and insurance with stray spaces or mixed case | 47 | trim and proper-case (sex), trim (insurance) |
| admissions.csv | dates written dd/MM/yyyy | 1,075 | try one format, then the other |
| admissions.csv | outcome with stray spaces or mixed case | 1,050 | trim and proper-case |
| admissions.csv | duplicate admission rows (same admission_id) | 178 | keep one per admission_id |
| ed_visits.csv | arrival_date written dd/MM/yyyy | 718 | try one format, then the other |
| ed_visits.csv | waiting time stored as text ('45 min') | 1,251 | remove 'min' and convert to number |
| ed_visits.csv | triage level and disposition with stray spaces or mixed case | 2,525 | trim and proper-case |
| ed_visits.csv | duplicate visit rows (same visit_id) | 252 | keep one per visit_id |

After these steps every key matches and every date parses.

## Built-in patterns in the data

These make the charts worth reading. They are designed, measured on the generated data, and not real findings.

- Bed occupancy averages 88%: Male Medical is the busiest ward (97%) and Emergency Observation the quietest (72%).
- Malaria admissions follow the rains: June is the peak month and March the lowest.
- Outcomes differ by diagnosis: mortality is 20.5% for Critical illness against 0.5% for Maternal and newborn.
- Emergency waits improve: the average wait falls from 66 minutes in 2024 to 62 minutes in 2025.
- Admissions grow by 5.4% from 2024 to 2025.
- 4.1% of emergency visits end with the patient leaving before being seen.

## Totals to check after a refresh

Use these to confirm that the report loads and calculates correctly (no filters applied):

| Measure | Expected value with no filters |
| :-- | :-- |
| `Admissions` | 17,761 |
| `Avg Length of Stay (days)` | 3.92 |
| `Bed Days Used` | 69,626 |
| `Readmission Rate %` | 6.6% |
| `Mortality Rate %` | 2.8% |
| `Referral Rate %` | 2.8% |
| `Occupied Bed Days` | 76,863 |
| `Available Bed Days` | 87,720 |
| `Bed Occupancy %` | 87.6% |
| `ED Visits` | 25,235 |
| `Avg Wait (min)` | 64.2 |
| `Seen Within Target %` | 73.8% |
| `Left Without Being Seen %` | 4.1% |
| `ED Admission Rate %` | 12.1% |
| `Admissions YoY %` | 5.4% |
