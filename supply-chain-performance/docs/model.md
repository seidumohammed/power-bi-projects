# Data model: Supply Chain Performance

A star schema with three fact tables (order lines, month-end stock and supplier receipts) that share date, hub and product dimensions, plus a monthly OTIF target by hub. All data is synthetic.

## Tables

| Table | Type | Grain | Rows (clean) |
| :-- | :-- | :-- | --: |
| `dim_Warehouse` | Dimension | One distribution hub | 4 |
| `dim_Customer` | Dimension | One retail customer | 80 |
| `dim_Product` | Dimension | One product | 30 |
| `dim_Supplier` | Dimension | One supplier | 8 |
| `dim_Carrier` | Dimension | One carrier | 5 |
| `fact_OrderLine` | Fact | One customer order line | 35,285 |
| `fact_Stock` | Fact | One hub, product and month-end stock count | 2,880 |
| `fact_Receipt` | Fact | One supplier delivery line | 2,880 |
| `fact_Target` | Fact | One hub and month | 96 |
| `dim_Date` | Dimension | One calendar day (2024 to 2025) | 731 |
| `_Measures` | Measure table | Holds all DAX measures | none |

## Relationships

All relationships are many-to-one with single-direction filters (from the dimension to the fact).

| From (many) | To (one) |
| :-- | :-- |
| `fact_OrderLine.OrderDate` | `dim_Date.Date` |
| `fact_OrderLine.CustomerID` | `dim_Customer.CustomerID` |
| `fact_OrderLine.ProductID` | `dim_Product.ProductID` |
| `fact_OrderLine.WarehouseID` | `dim_Warehouse.WarehouseID` |
| `fact_OrderLine.CarrierID` | `dim_Carrier.CarrierID` |
| `fact_Stock.SnapshotDate` | `dim_Date.Date` |
| `fact_Stock.WarehouseID` | `dim_Warehouse.WarehouseID` |
| `fact_Stock.ProductID` | `dim_Product.ProductID` |
| `fact_Receipt.PODate` | `dim_Date.Date` |
| `fact_Receipt.SupplierID` | `dim_Supplier.SupplierID` |
| `fact_Receipt.ProductID` | `dim_Product.ProductID` |
| `fact_Receipt.WarehouseID` | `dim_Warehouse.WarehouseID` |
| `fact_Target.Warehouse` | `dim_Warehouse.Warehouse` |

`dim_Product[SupplierID]` is **not** related to `dim_Supplier`. Receipts already link to both product and supplier, and a second route from supplier to receipts would make the model ambiguous. The supplier shown on a receipt is the one on the delivery.

`fact_Target` has no direct link to `dim_Date`. The target measure uses `TREATAS` to match the months shown by the date filter to `fact_Target[MonthStart]`. Stock is a month-end snapshot, so stock measures read the latest snapshot in the selected period, not a sum.

## Settings to apply in Power BI Desktop

1. Mark `dim_Date` as the date table (Table tools > Mark as date table > `Date`).
2. Sort `dim_Date[MonthName]` by `MonthNumber`, and `dim_Date[DayName]` by `DayNumber`.
3. Hide all key columns (`...ID`) and the raw numeric and date columns on the fact tables. Users should use measures only.
4. Set formats and display folders from the comments in `measures.dax`.

## Design decisions to explain in an interview

- **Latest-snapshot measures:** stock on hand is not additive over time. The measures take the last month-end in the selection, so a quarter shows its closing stock and not three months added together.
- **Flags in Power Query:** on-time, in-full, OTIF and stockout are calculated once as 1 or 0 columns, so every rate is a simple sum divided by a count.
- **OTIF target:** set per hub and month as a rate. The target measure averages it and returns blank when the report is filtered by carrier, customer or category, because the target cannot be split that way.
- **Why a star schema:** facts hold events and numbers, dimensions hold descriptions. Filters flow from dimensions to facts, so measures stay simple.
- **Why Power Query cleans the data and not DAX:** fix data problems once, upstream, so every report sees the same clean tables.
