# Data model: FinTech Payments

A star schema with two fact tables (transactions and loans) that share the customer and date dimensions, plus a monthly value target by region. All data is synthetic.

## Tables

| Table | Type | Grain | Rows (clean) |
| :-- | :-- | :-- | --: |
| `dim_Region` | Dimension | One region | 5 |
| `dim_Customer` | Dimension | One customer | 3,200 |
| `dim_TxnType` | Dimension | One transaction type | 6 |
| `dim_Channel` | Dimension | One channel | 3 |
| `fact_Transaction` | Fact | One transaction attempt | 51,697 |
| `fact_Loan` | Fact | One loan | 2,300 |
| `fact_Target` | Fact | One region and month | 120 |
| `dim_Date` | Dimension | One calendar day (2024 to 2025) | 731 |
| `_Measures` | Measure table | Holds all DAX measures | none |

## Relationships

All relationships are many-to-one with single-direction filters (from the dimension to the fact).

| From (many) | To (one) |
| :-- | :-- |
| `fact_Transaction.TxnDate` | `dim_Date.Date` |
| `fact_Transaction.CustomerID` | `dim_Customer.CustomerID` |
| `fact_Transaction.TypeID` | `dim_TxnType.TypeID` |
| `fact_Transaction.ChannelID` | `dim_Channel.ChannelID` |
| `fact_Loan.DisbursedDate` | `dim_Date.Date` |
| `fact_Loan.CustomerID` | `dim_Customer.CustomerID` |
| `dim_Customer.Region` | `dim_Region.Region` |
| `fact_Target.Region` | `dim_Region.Region` |

Region sits in a small `dim_Region` table that both customers and targets point to, so a region filter reaches transactions, loans and targets by one route each. `fact_Target` has no direct link to `dim_Date`: the target measure uses `TREATAS` on `fact_Target[MonthStart]`.

## Settings to apply in Power BI Desktop

1. Mark `dim_Date` as the date table (Table tools > Mark as date table > `Date`).
2. Sort `dim_Date[MonthName]` by `MonthNumber`, and `dim_Date[DayName]` by `DayNumber`.
3. Hide all key columns (`...ID`) and the raw numeric and date columns on the fact tables. Users should use measures only.
4. Set formats and display folders from the comments in `measures.dax`.

## Design decisions to explain in an interview

- **Attempts and value:** the fact table holds every attempt, including failed and reversed ones. Value measures count successful transactions only, and rates use all attempts.
- **Flags in Power Query:** success, failure, reversal, fraud value and loan-risk flags are calculated once, so each rate is a sum divided by a count.
- **Portfolio at risk:** the outstanding balance of loans more than 30 days late, divided by all outstanding balances. Outstanding is calculated per loan in Power Query.
- **Targets by region:** the target measure returns blank when the report is filtered by segment, transaction type or channel, because the target is set per region only.
- **Why a star schema:** facts hold events and numbers, dimensions hold descriptions. Filters flow from dimensions to facts, so measures stay simple.
- **Why Power Query cleans the data and not DAX:** fix data problems once, upstream, so every report sees the same clean tables.
