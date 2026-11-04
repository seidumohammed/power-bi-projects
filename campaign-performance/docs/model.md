# Data model: Campaign Performance

A star schema with one daily fact table of ad results, a monthly budget by channel, and dimensions for channel, campaign and date. All data is synthetic.

## Tables

| Table | Type | Grain | Rows (clean) |
| :-- | :-- | :-- | --: |
| `dim_Channel` | Dimension | One advertising channel | 6 |
| `dim_Campaign` | Dimension | One campaign, with its objective, channel and product category | 20 |
| `fact_Ads` | Fact | One campaign and day | 12,472 |
| `fact_Budget` | Fact | One channel and month | 144 |
| `dim_Date` | Dimension | One calendar day (2024 to 2025) | 731 |
| `_Measures` | Measure table | Holds all DAX measures | none |

## Relationships

All relationships are many-to-one with single-direction filters (from the dimension to the fact).

| From (many) | To (one) |
| :-- | :-- |
| `dim_Campaign.ChannelID` | `dim_Channel.ChannelID` |
| `fact_Ads.AdDate` | `dim_Date.Date` |
| `fact_Ads.CampaignID` | `dim_Campaign.CampaignID` |
| `fact_Budget.Channel` | `dim_Channel.Channel` |

`dim_Campaign` is related to `dim_Channel`, so a channel filter reaches the ad results through the campaign. `fact_Budget` is related to `dim_Channel[Channel]` and used through `TREATAS` on `fact_Budget[MonthStart]`. Budget is set by channel and month, so it shows blank when a campaign, objective or category is selected.

## Settings to apply in Power BI Desktop

1. Mark `dim_Date` as the date table (Table tools > Mark as date table > `Date`).
2. Sort `dim_Date[MonthName]` by `MonthNumber`, and `dim_Date[DayName]` by `DayNumber`.
3. Hide all key columns (`...ID`) and the raw numeric and date columns on the fact tables. Users should use measures only.
4. Set formats and display folders from the comments in `measures.dax`.

## Design decisions to explain in an interview

- **Ratios are measures:** CTR, CPC, CPM, CPA and ROAS are calculated from totals (sums first, then divide), never averaged from daily ratios.
- **ROAS:** revenue attributed to the ad divided by spend. 3.0 means GHS 3 of revenue for each GHS 1 spent.
- **Budget grain:** budgets exist by channel and month only, so the budget measures return blank below that level instead of showing a wrong number.
- **Spend as text:** some spend values arrive as text ('GHS 1,250.00') and are converted in Power Query.
- **Why a star schema:** facts hold events and numbers, dimensions hold descriptions. Filters flow from dimensions to facts, so measures stay simple.
- **Why Power Query cleans the data and not DAX:** fix data problems once, upstream, so every report sees the same clean tables.
