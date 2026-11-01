# Data model: Programme Monitoring

A star schema with two fact areas (field visits and savings groups) sharing one date table and one geography chain. The setting is the Central Region of Ghana, grouped into three invented zones. All data is synthetic.

## Tables

| Table | Type | Grain | Rows (clean) |
| :-- | :-- | :-- | --: |
| `fact_Visit` | Fact | One field visit | about 12,700 |
| `fact_VslaMeeting` | Fact | One savings-group meeting | about 1,070 |
| `fact_Target` | Fact | One zone and month | 72 |
| `dim_Date` | Dimension | One calendar day (2024 to 2025) | 731 |
| `dim_Officer` | Dimension | One field officer | 18 |
| `dim_Community` | Dimension | One community | 60 |
| `dim_District` | Dimension | One district | 12 |
| `dim_Zone` | Dimension | One zone | 3 |
| `dim_VslaGroup` | Dimension | One savings group | 48 |
| `_Measures` | Measure table | Holds all DAX measures | none |

## Relationships

All relationships are many-to-one, single direction (from the dimension to the fact).

| From (many) | To (one) | Notes |
| :-- | :-- | :-- |
| `fact_Visit[OfficerID]` | `dim_Officer[OfficerID]` | |
| `fact_Visit[CommunityID]` | `dim_Community[CommunityID]` | |
| `fact_Visit[VisitDate]` | `dim_Date[Date]` | Active |
| `fact_VslaMeeting[GroupID]` | `dim_VslaGroup[GroupID]` | |
| `fact_VslaMeeting[MeetingDate]` | `dim_Date[Date]` | Active |
| `dim_VslaGroup[CommunityID]` | `dim_Community[CommunityID]` | |
| `dim_Community[DistrictID]` | `dim_District[DistrictID]` | |
| `dim_District[Zone]` | `dim_Zone[Zone]` | |
| `fact_Target[Zone]` | `dim_Zone[Zone]` | |

`fact_Target` has no direct link to `dim_Date`. The target measures use `TREATAS` to match the months shown by the date filter to `fact_Target[MonthStart]`. This avoids a many-to-many relationship and is a useful pattern to teach.

```
dim_Zone -> dim_District -> dim_Community -> fact_Visit      <- dim_Officer
                                  |                 ^
                                  v                 |
                             dim_VslaGroup -> fact_VslaMeeting
dim_Zone -> fact_Target                dim_Date -> fact_Visit, fact_VslaMeeting
```

## Settings to apply in Power BI Desktop

1. Mark `dim_Date` as the date table (Table tools > Mark as date table > `Date`).
2. Sort `dim_Date[MonthName]` by `MonthNumber`, and `dim_Date[DayName]` by `DayNumber`.
3. Hide all key columns (`...ID`) and the raw date columns on the fact tables from the report view.
4. Set formats as listed in `measures.dax` (the `format:` comment on each measure).
5. Put the measures in display folders using the `folder:` comment.
6. Set `dim_Officer[OfficerName]` and `dim_Zone[Zone]` as categories for sorting and slicing.

## Design decisions to explain in an interview

- **Why a star schema:** facts hold events and numbers, dimensions hold descriptions. Filters flow from dimensions to facts, so measures stay simple.
- **Why `fact_Target` uses `TREATAS`:** targets are set per zone and month, a coarser grain than the daily facts.
- **Why target measures return blank when an officer is filtered:** targets exist only at zone level, so showing them against one officer would mislead. The measure checks `ISFILTERED` and returns blank.
- **Why Power Query cleans the data and not DAX:** fix data problems once, upstream, so every report sees the same clean tables.
