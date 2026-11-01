# Data model: Public Health Programme

A star schema with three fact tables (immunisation, disease cases and facility reporting) that share the date and facility dimensions, plus a monthly coverage target by district. All data is synthetic.

## Tables

| Table | Type | Grain | Rows (clean) |
| :-- | :-- | :-- | --: |
| `dim_District` | Dimension | One district | 10 |
| `dim_Facility` | Dimension | One health facility, with its district and level | 65 |
| `dim_Antigen` | Dimension | One vaccine | 4 |
| `dim_Disease` | Dimension | One notifiable disease | 4 |
| `fact_Immunisation` | Fact | One facility, vaccine and month | 6,240 |
| `fact_Cases` | Fact | One facility, disease and month | 6,240 |
| `fact_Reporting` | Fact | One facility and month | 1,560 |
| `fact_Target` | Fact | One district and month | 240 |
| `dim_Date` | Dimension | One calendar day (2024 to 2025) | 731 |
| `_Measures` | Measure table | Holds all DAX measures | none |

## Relationships

All relationships are many-to-one with single-direction filters (from the dimension to the fact).

| From (many) | To (one) |
| :-- | :-- |
| `dim_Facility.DistrictID` | `dim_District.DistrictID` |
| `fact_Immunisation.Month` | `dim_Date.Date` |
| `fact_Immunisation.FacilityID` | `dim_Facility.FacilityID` |
| `fact_Immunisation.AntigenID` | `dim_Antigen.AntigenID` |
| `fact_Cases.Month` | `dim_Date.Date` |
| `fact_Cases.FacilityID` | `dim_Facility.FacilityID` |
| `fact_Cases.DiseaseID` | `dim_Disease.DiseaseID` |
| `fact_Reporting.Month` | `dim_Date.Date` |
| `fact_Reporting.FacilityID` | `dim_Facility.FacilityID` |
| `fact_Target.District` | `dim_District.District` |

`dim_Facility` is related to `dim_District`, so a district filter reaches every fact through the facility. `fact_Target` is related to `dim_District[District]` and used through `TREATAS` on `fact_Target[MonthStart]`.

## Settings to apply in Power BI Desktop

1. Mark `dim_Date` as the date table (Table tools > Mark as date table > `Date`).
2. Sort `dim_Date[MonthName]` by `MonthNumber`, and `dim_Date[DayName]` by `DayNumber`.
3. Hide all key columns (`...ID`) and the raw numeric and date columns on the fact tables. Users should use measures only.
4. Set formats and display folders from the comments in `measures.dax`.

## Design decisions to explain in an interview

- **Coverage logic:** coverage is doses given divided by the children expected in the month. Both numbers sit in the same fact row, so any slice stays consistent.
- **Penta dropout:** the share of children who received the first Penta dose but not the third, calculated from the two antigens' doses.
- **Seasonality:** malaria cases peak in the rainy season and meningitis in the dry season. The disease dimension allows both to appear in one chart.
- **Reporting quality:** completeness is reports submitted divided by reports expected. Timeliness is reports on time divided by submitted.
- **Why a star schema:** facts hold events and numbers, dimensions hold descriptions. Filters flow from dimensions to facts, so measures stay simple.
- **Why Power Query cleans the data and not DAX:** fix data problems once, upstream, so every report sees the same clean tables.
