# Data dictionary: Customer Acquisition and Retention

All data is synthetic and was generated with a fixed random seed. The app and all figures are invented. Customers are anonymous IDs. Region names are real regions used only as labels.

## Raw files (data/raw)

| File | Rows | Description |
| :-- | --: | :-- |
| `channels.csv` | 5 | Acquisition channels |
| `customers.csv` | 6,061 | One row per customer: segment, region, channel, signup and churn dates |
| `orders.csv` | 30,581 | One row per order |
| `funnel.csv` | 120 | Visits, signups and first orders per channel and month |
| `spend.csv` | 120 | Marketing spend per channel and month |

## Columns after cleaning

**dim_Channel**: ChannelID (string), AcquisitionChannel (string)
**dim_Customer**: CustomerID (string), Segment (string), Region (string), ChannelID (string), SignupDate (dateTime), ChurnDate (dateTime)
**fact_Order**: OrderID (string), OrderDate (dateTime), CustomerID (string), OrderValueGHS (double), Items (int64)
**fact_Funnel**: Month (dateTime), ChannelID (string), Visits (int64), Signups (int64), FirstOrders (int64)
**fact_Spend**: Month (dateTime), ChannelID (string), SpendGHS (double)
**dim_Date**: Date (dateTime), Year (int64), Quarter (string), MonthNumber (int64), MonthName (string), MonthStart (dateTime), YearMonth (string), DayNumber (int64), DayName (string), IsWeekend (boolean)

## Deliberate data problems and how Power Query fixes them

| File | Problem injected | Rows affected | Fix in Power Query |
| :-- | :-- | --: | :-- |
| customers.csv | dates written dd/MM/yyyy; blank churn date means still active | 246 | try one format, then the other; blanks stay blank |
| customers.csv | segment and region with stray spaces or mixed case | 548 | trim and proper-case the segment, trim the region |
| customers.csv | duplicate customer rows (same customer_id) | 60 | keep one per customer_id |
| orders.csv | date written dd/MM/yyyy | 945 | try one format, then the other |
| orders.csv | order value stored as text ('GHS 85.50') | 1,210 | strip prefix and commas, convert to number |
| orders.csv | duplicate order rows (same order_id) | 303 | keep one per order_id |

After these steps every key matches and every date parses.

## Built-in patterns in the data

These make the charts worth reading. They are designed, measured on the generated data, and not real findings.

- CAC is lowest for Organic search (GHS 19) and highest for Influencer (GHS 375).
- Referral customers stay longest: 32% have left, against 72% of paid social customers.
- December is the highest-revenue month, lifted by the festive season.
- New customers grow 27.4% and revenue 155.3% from 2024 to 2025.
- 86% of customers who ordered placed two or more orders. Family customers bring the most revenue.
- Revenue per customer to date is GHS 953; with a blended CAC of GHS 129, the LTV to CAC ratio is 7.4.

## Totals to check after a refresh

Use these to confirm that the report loads and calculates correctly (no filters applied):

| Measure | Expected value with no filters |
| :-- | :-- |
| `New Customers` | 6,001 |
| `Churned Customers` | 3,147 |
| `Customers at Period End` | 2,854 |
| `Orders` | 30,278 |
| `Revenue` | 4,696,129 |
| `Avg Order Value` | 155.10 |
| `Active Customers` | 4,927 |
| `Orders per Active Customer` | 6.1 |
| `Repeat Customer %` | 85.7% |
| `Visits` | 128,637 |
| `Signups` | 6,001 |
| `First Orders` | 4,980 |
| `Visit to Signup %` | 4.7% |
| `Signup to First Order %` | 83.0% |
| `Marketing Spend` | 775,216 |
| `CAC` | 129.18 |
| `Revenue per Customer to Date` | 953 |
| `LTV to CAC` | 7.4 |
| `New Customers YoY %` | 27.4% |
| `Revenue YoY %` | 155.3% |
