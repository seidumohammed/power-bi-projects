# Data model: Real Estate Performance

A star schema with two fact tables (listings and completed sales) that share the property, agent and date dimensions, plus a monthly target table at branch level. All data is synthetic.

## Tables

| Table | Type | Grain | Rows (clean) |
| :-- | :-- | :-- | --: |
| `dim_Branch` | Dimension | One branch | 3 |
| `dim_Area` | Dimension | One neighbourhood | 12 |
| `dim_Agent` | Dimension | One agent | 24 |
| `dim_Property` | Dimension | One property | 3,763 |
| `fact_Listing` | Fact | One listing | 3,502 |
| `fact_Sale` | Fact | One completed sale | 3,164 |
| `fact_Target` | Fact | One branch and month | 72 |
| `dim_Date` | Dimension | One calendar day (2024 to 2025) | 731 |
| `_Measures` | Measure table | Holds all DAX measures | none |

## Relationships

All relationships are many-to-one with single-direction filters (from the dimension to the fact).

| From (many) | To (one) |
| :-- | :-- |
| `fact_Listing.PropertyID` | `dim_Property.PropertyID` |
| `fact_Listing.AgentID` | `dim_Agent.AgentID` |
| `fact_Listing.ListDate` | `dim_Date.Date` |
| `fact_Sale.PropertyID` | `dim_Property.PropertyID` |
| `fact_Sale.AgentID` | `dim_Agent.AgentID` |
| `fact_Sale.SaleDate` | `dim_Date.Date` |
| `dim_Property.AreaID` | `dim_Area.AreaID` |
| `dim_Agent.BranchID` | `dim_Branch.BranchID` |
| `fact_Target.Branch` | `dim_Branch.Branch` |

`fact_Target` has no direct link to `dim_Date`. The target measures use `TREATAS` to match the months shown by the date filter to `fact_Target[MonthStart]`. Listings and sales each use their own date (list date and sale date), so the same month filter counts listings by when they were added and sales by when they closed.

## Settings to apply in Power BI Desktop

1. Mark `dim_Date` as the date table (Table tools > Mark as date table > `Date`).
2. Sort `dim_Date[MonthName]` by `MonthNumber`, and `dim_Date[DayName]` by `DayNumber`.
3. Hide all key columns (`...ID`) and the raw numeric and date columns on the fact tables. Users should use measures only.
4. Set formats and display folders from the comments in `measures.dax`.

## Design decisions to explain in an interview

- **Two fact tables:** listings and sales have different dates and different grains, so they are separate. Sell-through compares sales closed in a period with listings added in the same period, which is an approximation and the guide says so.
- **Targets by branch:** targets are set per branch and month. The target measures return blank when the report is filtered by agent, area or property type, because the target cannot be split that way.
- **Commission:** calculated in Power Query as 3% of the sale price (an assumed rate for this demo).
- **Why a star schema:** facts hold events and numbers, dimensions hold descriptions. Filters flow from dimensions to facts, so measures stay simple.
- **Why Power Query cleans the data and not DAX:** fix data problems once, upstream, so every report sees the same clean tables.
