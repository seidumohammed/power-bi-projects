# Data dictionary: Supply Chain Performance

All data is synthetic and was generated with a fixed random seed. The distributor and every customer, product, supplier and carrier are invented. Hub town names are real Ghana towns used only as labels.

## Raw files (data/raw)

| File | Rows | Description |
| :-- | --: | :-- |
| `warehouses.csv` | 4 | Distribution hubs |
| `customers.csv` | 80 | Retail customers, with type and region |
| `products.csv` | 30 | Products with category, supplier, cost and price |
| `suppliers.csv` | 8 | Suppliers and their country |
| `carriers.csv` | 5 | Carriers and mode |
| `order_lines.csv` | 35,638 | One row per customer order line |
| `stock.csv` | 2,880 | Month-end stock count per hub and product |
| `receipts.csv` | 2,909 | One row per supplier delivery line |
| `targets.csv` | 96 | Monthly OTIF target per hub |

## Columns after cleaning

**dim_Warehouse**: WarehouseID (string), Warehouse (string), Region (string)
**dim_Customer**: CustomerID (string), Customer (string), CustomerType (string), Region (string)
**dim_Product**: ProductID (string), Product (string), Category (string), SupplierID (string), UnitCostGHS (double), UnitPriceGHS (double)
**dim_Supplier**: SupplierID (string), Supplier (string), Origin (string)
**dim_Carrier**: CarrierID (string), Carrier (string), Mode (string)
**fact_OrderLine**: LineID (string), OrderID (string), OrderDate (dateTime), RequiredDate (dateTime), ShipDate (dateTime), DeliveryDate (dateTime), CustomerID (string), ProductID (string), WarehouseID (string), CarrierID (string), OrderedQty (int64), ShippedQty (int64), UnitPriceGHS (double), FreightCostGHS (double), IsOnTime (int64), IsInFull (int64), IsOTIF (int64), LeadTimeDays (int64), ShippedValueGHS (double)
**fact_Stock**: SnapshotDate (dateTime), WarehouseID (string), ProductID (string), OnHandQty (int64), DemandQty (int64), IsStockout (int64)
**fact_Receipt**: ReceiptID (string), PODate (dateTime), ExpectedDate (dateTime), ReceiptDate (dateTime), SupplierID (string), ProductID (string), WarehouseID (string), OrderedQty (int64), ReceivedQty (int64), RejectedQty (int64), IsOnTime (int64), LeadTimeDays (int64)
**fact_Target**: MonthStart (dateTime), Warehouse (string), OTIFTarget (double)
**dim_Date**: Date (dateTime), Year (int64), Quarter (string), MonthNumber (int64), MonthName (string), MonthStart (dateTime), YearMonth (string), DayNumber (int64), DayName (string), IsWeekend (boolean)

## Deliberate data problems and how Power Query fixes them

| File | Problem injected | Rows affected | Fix in Power Query |
| :-- | :-- | --: | :-- |
| customers.csv | customer_type with stray spaces or mixed case | 9 | trim and proper-case |
| order_lines.csv | dates written dd/MM/yyyy | 4,306 | try one format, then the other |
| order_lines.csv | freight cost stored as text ('GHS 340.00') | 1,382 | strip prefix and commas, convert to number |
| order_lines.csv | duplicate order-line rows (same line_id) | 353 | keep one per line_id |
| receipts.csv | dates written dd/MM/yyyy | 271 | try one format, then the other |
| receipts.csv | duplicate receipt rows (same receipt_id) | 29 | keep one per receipt_id |

After these steps every key matches and every date parses.

## Built-in patterns in the data

These make the charts worth reading. They are designed, measured on the generated data, and not real findings.

- Service improves over time: OTIF is 81% in 2024 and 85% in 2025.
- One carrier is clearly weaker: Carrier C reaches 72% OTIF against 88% for the best carrier.
- The northern hub is the hardest to serve: Tamale Hub has the lowest OTIF (79%).
- Order volumes peak in December (33% above the average month) and grow through the two years.
- Overseas suppliers are less punctual: Supplier E delivers on time 64% of the time against 91% for the best supplier.
- Stockouts are rare but real: 0.9% of month-end hub and product counts are at zero.

## Totals to check after a refresh

Use these to confirm that the report loads and calculates correctly (no filters applied):

| Measure | Expected value with no filters |
| :-- | :-- |
| `Order Lines` | 35,285 |
| `Orders` | 14,061 |
| `Units Ordered` | 1,200,385 |
| `Units Shipped` | 1,183,805 |
| `Fill Rate %` | 98.6% |
| `On-Time %` | 87.7% |
| `In-Full %` | 94.4% |
| `OTIF %` | 82.9% |
| `Avg Lead Time (days)` | 3.32 |
| `Shipped Value (GHS)` | 56,751,545 |
| `Freight per Unit (GHS)` | 1.38 |
| `Stock On Hand (units)` | 148,029 |
| `Stock Value (GHS)` | 5,285,589 |
| `Stockout Rate %` | 0.9% |
| `Supplier On-Time %` | 79.5% |
| `Supplier Fill %` | 98.7% |
| `Rejection Rate %` | 1.8% |
| `Shipped Value YoY %` | 14.9% |
