# Data model: Sales Performance

A classic star schema: one sales fact table at order-line grain, one target table at store and month grain, and four dimensions. All data is synthetic.

## Tables

| Table | Type | Grain | Rows (clean) |
| :-- | :-- | :-- | --: |
| `fact_Sales` | Fact | One order line | about 74,990 |
| `fact_Target` | Fact | One store and month | 144 |
| `dim_Date` | Dimension | One calendar day (2024 to 2025) | 731 |
| `dim_Product` | Dimension | One product | 36 |
| `dim_Customer` | Dimension | One customer | 600 |
| `dim_Store` | Dimension | One store | 6 |
| `_Measures` | Measure table | Holds all DAX measures | none |

## Relationships

All relationships are many-to-one, single direction (from the dimension to the fact).

| From (many) | To (one) | Notes |
| :-- | :-- | :-- |
| `fact_Sales[OrderDate]` | `dim_Date[Date]` | Active |
| `fact_Sales[ProductID]` | `dim_Product[ProductID]` | |
| `fact_Sales[CustomerID]` | `dim_Customer[CustomerID]` | |
| `fact_Sales[StoreID]` | `dim_Store[StoreID]` | |
| `fact_Target[StoreID]` | `dim_Store[StoreID]` | |

Two choices worth noting:

- `fact_Target` has no direct link to `dim_Date`. The target measures use `TREATAS` to match the months shown by the date filter to `fact_Target[MonthStart]`. This avoids a many-to-many relationship.
- `dim_Customer[HomeStoreID]` is deliberately **not** related to `dim_Store`. A second path from store to sales would create ambiguity. Treat it as a descriptive attribute only.

```
dim_Date     -> fact_Sales <- dim_Product
dim_Customer -> fact_Sales <- dim_Store -> fact_Target
```

## Calculated columns and measures

Line amounts are calculated in Power Query so the measures stay simple:

| Column (in `fact_Sales`) | Formula |
| :-- | :-- |
| GrossSales | Quantity x UnitPriceGHS |
| DiscountAmount | GrossSales x DiscountPct |
| NetSales | GrossSales minus DiscountAmount |
| TotalCost | Quantity x UnitCostGHS |

Everything that depends on the filter context (margins, shares, year-on-year, targets, rankings) is a DAX measure. See `measures.dax`.

## Settings to apply in Power BI Desktop

1. Mark `dim_Date` as the date table (Table tools > Mark as date table > `Date`).
2. Sort `dim_Date[MonthName]` by `MonthNumber`, and `dim_Date[DayName]` by `DayNumber`.
3. Hide all key columns (`...ID`), the raw `fact_Sales` amount columns and `fact_Target` from the report view. Users should use measures only.
4. Set formats and display folders from the comments in `measures.dax`.
5. Set data categories: none are needed. `dim_Store[Region]` can be tagged as State or Province if you add a map.

## Design decisions to explain in an interview

- **Why line amounts in Power Query and ratios in DAX:** row-level arithmetic never depends on a slicer, so it is cheaper to compute once. A ratio such as margin must be computed after summing, so it must be a measure.
- **Why `Profit Margin %` is a measure and not a column:** averaging row margins gives the wrong answer. Margin is total profit divided by total net sales.
- **Why `TREATAS` for targets:** targets are monthly by store, a coarser grain than daily sales.
- **Why the date table is separate:** time intelligence functions such as `SAMEPERIODLASTYEAR` need a complete, continuous date table.
