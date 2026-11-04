# Data model: Customer Acquisition and Retention

A star schema with orders as the main fact, a customer dimension that carries signup and churn dates, and monthly funnel and spend facts by acquisition channel. All data is synthetic.

## Tables

| Table | Type | Grain | Rows (clean) |
| :-- | :-- | :-- | --: |
| `dim_Channel` | Dimension | One acquisition channel | 5 |
| `dim_Customer` | Dimension | One customer, with signup and churn dates | 6,001 |
| `fact_Order` | Fact | One order | 30,278 |
| `fact_Funnel` | Fact | One channel and month: visits, signups, first orders | 120 |
| `fact_Spend` | Fact | One channel and month: marketing spend | 120 |
| `dim_Date` | Dimension | One calendar day (2024 to 2025) | 731 |
| `_Measures` | Measure table | Holds all DAX measures | none |

## Relationships

All relationships are many-to-one with single-direction filters (from the dimension to the fact).

| From (many) | To (one) |
| :-- | :-- |
| `dim_Customer.ChannelID` | `dim_Channel.ChannelID` |
| `fact_Order.OrderDate` | `dim_Date.Date` |
| `fact_Order.CustomerID` | `dim_Customer.CustomerID` |
| `fact_Funnel.Month` | `dim_Date.Date` |
| `fact_Funnel.ChannelID` | `dim_Channel.ChannelID` |
| `fact_Spend.Month` | `dim_Date.Date` |
| `fact_Spend.ChannelID` | `dim_Channel.ChannelID` |

`dim_Customer` is related to `dim_Channel`, and to orders through `CustomerID`. It has **no** relationship to `dim_Date`. New and churned customers use `TREATAS` on `SignupDate` and `ChurnDate`, so one customer table answers both questions and the date filter still works. Funnel and spend are by channel and month only, so CAC shows blank when a segment or region is selected.

## Settings to apply in Power BI Desktop

1. Mark `dim_Date` as the date table (Table tools > Mark as date table > `Date`).
2. Sort `dim_Date[MonthName]` by `MonthNumber`, and `dim_Date[DayName]` by `DayNumber`.
3. Hide all key columns (`...ID`) and the raw numeric and date columns on the fact tables. Users should use measures only.
4. Set formats and display folders from the comments in `measures.dax`.

## Design decisions to explain in an interview

- **Two dates on one customer:** signup and churn dates live on the customer. `TREATAS` applies the date filter to each in turn, which avoids a second, inactive relationship to the date table.
- **Customers at period end:** customers signed up on or before the last date shown, minus those who churned on or before it. It is a stock, so it is read at the end of the period, not added over months.
- **CAC:** marketing spend divided by new customers. It is blank when a segment or region filter is on, because spend is not split by them.
- **Revenue per customer to date:** all revenue of the customers selected divided by those customers. Divided by CAC, it gives the LTV to CAC ratio.
- **Why a star schema:** facts hold events and numbers, dimensions hold descriptions. Filters flow from dimensions to facts, so measures stay simple.
- **Why Power Query cleans the data and not DAX:** fix data problems once, upstream, so every report sees the same clean tables.
