# Data dictionary: Sales Performance

All data is synthetic and was generated with a fixed random seed. The business, its stores, products and customers are invented. Town names are real Ghana towns used only as store labels.

## Raw files (data/raw)

| File | Rows | Description |
| :-- | --: | :-- |
| `stores.csv` | 6 | Retail stores and their regions |
| `products.csv` | 36 | Products in four categories, with list price and unit cost |
| `customers.csv` | 600 | Customers with segment (Retail, Wholesale, Corporate) |
| `sales.csv` | 75,744 | One row per order line, 2024 to 2025 |
| `targets.csv` | 144 | Monthly sales target for each store |

## Columns after cleaning

**fact_Sales**

| Column | Type | Meaning |
| :-- | :-- | :-- |
| LineID | Text | Unique order-line key |
| OrderID | Text | Order number (an order has one to four lines) |
| OrderDate | Date | Date of the order |
| StoreID, CustomerID, ProductID | Text | Keys |
| Channel | Text | "In store" or "Online" |
| Quantity | Whole number | Units sold |
| UnitPriceGHS | Decimal | List price per unit, in Ghana cedis |
| DiscountPct | Decimal | Discount as a fraction (0.05 is 5%) |
| UnitCostGHS | Decimal | Cost per unit |
| GrossSales, DiscountAmount, NetSales, TotalCost | Decimal | Calculated in Power Query |

**fact_Target**: MonthStart (date), StoreID, SalesTargetGHS.

**dim_Product**: ProductID, ProductName, Category, Subcategory, ListPriceGHS, UnitCostGHS, UnitMarginGHS.
**dim_Customer**: CustomerID, Segment, HomeStoreID, JoinedDate.
**dim_Store**: StoreID, Store, Region, OpenedDate.
**dim_Date**: Date, Year, Quarter, MonthNumber, MonthName, MonthStart, YearMonth, DayNumber, DayName, IsWeekend.

## Deliberate data problems and how Power Query fixes them

| File | Problem injected | Rows affected | Fix in Power Query |
| :-- | :-- | --: | :-- |
| sales.csv | Dates written dd/MM/yyyy instead of yyyy-MM-dd | about 2,250 | `try` one format, `otherwise` the other |
| sales.csv | Discount stored as text with a percent sign ("5%") | about 3,750 | detect "%", strip it and divide by 100 |
| sales.csv | product_id with stray spaces or lower case | about 2,060 | trim and upper-case so it matches `dim_Product` |
| sales.csv | Duplicate rows (same line_id) | 750 | `Table.Distinct` on `line_id` |
| customers.csv | segment in mixed case with stray spaces | about 8% | trim and proper-case |

After these steps every sales line matches a product and every date parses. Without the product fix, about 2,000 lines would silently drop out of every product total.

## Built-in patterns in the data

These make the charts worth reading. They are designed, not real findings.

- Net sales grow from about GHS 14.9 million in 2024 to about GHS 16.7 million in 2025 (about 12%).
- Sales peak in December (about 35% above the average month) and dip in the first quarter.
- Online share of sales rises through the two years (about 18% of 2025 net sales).
- Wholesale and Corporate customers buy larger quantities with deeper discounts.
- Packaged Foods is the largest category (about 37% of net sales). Accra Osu and Kumasi Central are the largest stores (about 26% and 24%).
- Monthly net sales sit close to target, ranging from about 89% to 108% of target. About 60% of store-months fall short.
- Overall profit margin is about 25%.
