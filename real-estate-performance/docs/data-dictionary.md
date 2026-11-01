# Data dictionary: Real Estate Performance

All data is synthetic and was generated with a fixed random seed. The agency, agents and properties are invented. Neighbourhood names are real Greater Accra locations used only as labels, and prices are illustrative.

## Raw files (data/raw)

| File | Rows | Description |
| :-- | --: | :-- |
| `branches.csv` | 3 | Agency branches |
| `areas.csv` | 12 | Neighbourhoods with their zone |
| `agents.csv` | 24 | Agents and their branch |
| `properties.csv` | 3,763 | Properties, with type, bedrooms and floor area |
| `listings.csv` | 3,537 | One row per listing, with asking price and status |
| `sales.csv` | 3,196 | One row per completed sale |
| `targets.csv` | 72 | Monthly sales target by branch |

## Columns after cleaning

**dim_Branch**: BranchID (string), Branch (string), City (string)
**dim_Area**: AreaID (string), Area (string), Zone (string)
**dim_Agent**: AgentID (string), AgentName (string), BranchID (string), JoinedDate (dateTime)
**dim_Property**: PropertyID (string), AreaID (string), PropertyType (string), Bedrooms (int64), FloorAreaSqm (double)
**fact_Listing**: ListingID (string), PropertyID (string), AgentID (string), ListDate (dateTime), ListPriceGHS (double), Status (string)
**fact_Sale**: SaleID (string), ListingID (string), PropertyID (string), AgentID (string), ListDate (dateTime), SaleDate (dateTime), ListPriceGHS (double), SalePriceGHS (double), DaysOnMarket (int64), CommissionGHS (double)
**fact_Target**: MonthStart (dateTime), Branch (string), SalesTargetGHS (double)
**dim_Date**: Date (dateTime), Year (int64), Quarter (string), MonthNumber (int64), MonthName (string), MonthStart (dateTime), YearMonth (string), DayNumber (int64), DayName (string), IsWeekend (boolean)

## Deliberate data problems and how Power Query fixes them

| File | Problem injected | Rows affected | Fix in Power Query |
| :-- | :-- | --: | :-- |
| properties.csv | property_type with stray spaces or mixed case | 241 | trim and proper-case |
| listings.csv | list_date written dd/MM/yyyy | 131 | try one format, then the other |
| listings.csv | status with stray spaces or mixed case | 155 | trim and proper-case |
| listings.csv | duplicate listing rows (same listing_id) | 35 | keep one per listing_id |
| sales.csv | list_date and sale_date written dd/MM/yyyy | 201 | try one format, then the other |
| sales.csv | sale price stored as text ('GHS 1,250,000.00') | 143 | strip prefix and commas, convert to number |
| sales.csv | duplicate sale rows (same sale_id) | 32 | keep one per sale_id |

After these steps every key matches and every date parses.

## Built-in patterns in the data

These make the charts worth reading. They are designed, measured on the generated data, and not real findings.

- Prices rise through the period: price per square metre is 3% higher in 2025 than in 2024.
- Prime neighbourhoods are far more expensive than outer ones: GHS 13,274 against GHS 3,790 per square metre.
- Homes in prime areas sell faster: about 54 days on the market against 77 in outer areas.
- Sales value peaks in December and is lowest in April.
- The largest branch (East Accra) closes 45% of sales.
- Monthly branch sales sit close to target, from 89% to 108% of target (median 100%).

## Totals to check after a refresh

Use these to confirm that the report loads and calculates correctly (no filters applied):

| Measure | Expected value with no filters |
| :-- | :-- |
| `Sales Count` | 3,164 |
| `Sales Value (GHS)` | 7,478,987,000 |
| `Avg Sale Price (GHS)` | 2,363,776 |
| `Avg Price per sqm (GHS)` | 8,296 |
| `Days on Market` | 64.7 |
| `Discount to List %` | 4.5% |
| `Commission (GHS)` | 224,369,610 |
| `Listings Count` | 3,502 |
| `Active Listings` | 315 |
| `Withdrawn Listings` | 284 |
| `Sales Value YoY %` | 12.7% |
| `Sales Value Attainment %` | 98.8% |
