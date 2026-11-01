# Data model: Hospital Operations

A star schema with three fact tables (admissions, a daily bed census and emergency visits) that share the date and patient-profile dimensions, plus a monthly occupancy target by ward. All data is synthetic.

## Tables

| Table | Type | Grain | Rows (clean) |
| :-- | :-- | :-- | --: |
| `dim_Ward` | Dimension | One ward, with its bed count | 7 |
| `dim_Diagnosis` | Dimension | One diagnosis group | 9 |
| `dim_PatientProfile` | Dimension | One combination of sex, age group, insurance and district (no individual patients) | 360 |
| `fact_Admission` | Fact | One hospital admission | 17,761 |
| `fact_Census` | Fact | One ward and day: beds occupied | 5,117 |
| `fact_ED` | Fact | One emergency department visit | 25,235 |
| `fact_Target` | Fact | One ward and month | 168 |
| `dim_Date` | Dimension | One calendar day (2024 to 2025) | 731 |
| `_Measures` | Measure table | Holds all DAX measures | none |

## Relationships

All relationships are many-to-one with single-direction filters (from the dimension to the fact).

| From (many) | To (one) |
| :-- | :-- |
| `fact_Admission.AdmitDate` | `dim_Date.Date` |
| `fact_Admission.ProfileID` | `dim_PatientProfile.ProfileID` |
| `fact_Admission.WardID` | `dim_Ward.WardID` |
| `fact_Admission.DiagnosisID` | `dim_Diagnosis.DiagnosisID` |
| `fact_Census.CensusDate` | `dim_Date.Date` |
| `fact_Census.WardID` | `dim_Ward.WardID` |
| `fact_ED.ArrivalDate` | `dim_Date.Date` |
| `fact_ED.ProfileID` | `dim_PatientProfile.ProfileID` |
| `fact_Target.Ward` | `dim_Ward.Ward` |

Facts point to `dim_PatientProfile`, a small table of 360 combinations of sex, age group, insurance and district. This keeps individual patients out of the model, which is also good privacy practice. `fact_Census` is related to date and ward only, so diagnosis and patient filters do not change occupancy. `fact_Target` uses `TREATAS` on `fact_Target[MonthStart]`.

## Settings to apply in Power BI Desktop

1. Mark `dim_Date` as the date table (Table tools > Mark as date table > `Date`).
2. Sort `dim_Date[MonthName]` by `MonthNumber`, and `dim_Date[DayName]` by `DayNumber`.
3. Hide all key columns (`...ID`) and the raw numeric and date columns on the fact tables. Users should use measures only.
4. Set formats and display folders from the comments in `measures.dax`.

## Design decisions to explain in an interview

- **No patient identity:** profiles replace patients. A profile is a combination such as 'female, 30 to 44, NHIS, Ho Municipal'. Nothing can be traced to a person.
- **Occupancy from a census:** bed occupancy is occupied bed-days divided by available bed-days. A daily census table gives occupied beds per ward and day, so occupancy does not depend on how admissions are counted.
- **Readmission flag:** a 30-day readmission is flagged on the original admission in the source data, and the rate is flagged admissions divided by admissions.
- **Emergency targets:** time targets by triage level (red 10, orange 30, yellow 60, green 120 minutes) are applied in Power Query as a within-target flag.
- **Why a star schema:** facts hold events and numbers, dimensions hold descriptions. Filters flow from dimensions to facts, so measures stay simple.
- **Why Power Query cleans the data and not DAX:** fix data problems once, upstream, so every report sees the same clean tables.
