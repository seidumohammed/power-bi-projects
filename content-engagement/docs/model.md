# Data model: Content and Email Engagement

A star schema with three fact tables (email, social posts and weekly web traffic) that share a content dimension, plus platform and audience dimensions. All data is synthetic.

## Tables

| Table | Type | Grain | Rows (clean) |
| :-- | :-- | :-- | --: |
| `dim_Content` | Dimension | One piece of content | 164 |
| `dim_Platform` | Dimension | One social platform | 5 |
| `dim_Audience` | Dimension | One email audience segment | 3 |
| `fact_Email` | Fact | One email send to one audience segment | 393 |
| `fact_Social` | Fact | One social post | 530 |
| `fact_Web` | Fact | One piece of content and week of web traffic | 2,210 |
| `dim_Date` | Dimension | One calendar day (2024 to 2025) | 731 |
| `_Measures` | Measure table | Holds all DAX measures | none |

## Relationships

All relationships are many-to-one with single-direction filters (from the dimension to the fact).

| From (many) | To (one) |
| :-- | :-- |
| `fact_Email.SendDate` | `dim_Date.Date` |
| `fact_Email.ContentID` | `dim_Content.ContentID` |
| `fact_Email.AudienceID` | `dim_Audience.AudienceID` |
| `fact_Social.PostDate` | `dim_Date.Date` |
| `fact_Social.ContentID` | `dim_Content.ContentID` |
| `fact_Social.PlatformID` | `dim_Platform.PlatformID` |
| `fact_Web.WeekStart` | `dim_Date.Date` |
| `fact_Web.ContentID` | `dim_Content.ContentID` |

The content dimension has **no** relationship to `dim_Date`; content published uses `TREATAS` on `PublishDate`. A topic, format or author filter reaches all three fact tables. A platform filter changes only social measures and an audience filter only email measures.

## Settings to apply in Power BI Desktop

1. Mark `dim_Date` as the date table (Table tools > Mark as date table > `Date`).
2. Sort `dim_Date[MonthName]` by `MonthNumber`, and `dim_Date[DayName]` by `DayNumber`.
3. Hide all key columns (`...ID`) and the raw numeric and date columns on the fact tables. Users should use measures only.
4. Set formats and display folders from the comments in `measures.dax`.

## Design decisions to explain in an interview

- **One content dimension for three channels:** the same topic, format and author filters answer all three channels, so the dashboard can compare them.
- **Rates are measures:** open, click, unsubscribe and engagement rates are ratios of totals. Bounce rate is weighted by sessions, never averaged across weeks.
- **Weekly web grain:** web traffic is recorded per content and week, which keeps the file small and still shows the first-week spike and decay.
- **Click-to-open:** clicks divided by opens separates a good subject line from a good body.
- **Why a star schema:** facts hold events and numbers, dimensions hold descriptions. Filters flow from dimensions to facts, so measures stay simple.
- **Why Power Query cleans the data and not DAX:** fix data problems once, upstream, so every report sees the same clean tables.
