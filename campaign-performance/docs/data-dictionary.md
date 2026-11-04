# Data dictionary: Campaign Performance

All data is synthetic and was generated with a fixed random seed. The retailer and all figures are invented. Channel names are real platforms used only as labels.

## Raw files (data/raw)

| File | Rows | Description |
| :-- | --: | :-- |
| `channels.csv` | 6 | Advertising channels |
| `campaigns.csv` | 20 | Campaigns, objectives and categories |
| `ad_results.csv` | 12,597 | One row per campaign and day |
| `budgets.csv` | 144 | Monthly budget per channel |

## Columns after cleaning

**dim_Channel**: ChannelID (string), Channel (string), ChannelType (string)
**dim_Campaign**: CampaignID (string), Campaign (string), Objective (string), ChannelID (string), Category (string)
**fact_Ads**: AdID (string), AdDate (dateTime), CampaignID (string), Impressions (int64), Clicks (int64), SpendGHS (double), Conversions (int64), RevenueGHS (double)
**fact_Budget**: MonthStart (dateTime), Channel (string), BudgetGHS (double)
**dim_Date**: Date (dateTime), Year (int64), Quarter (string), MonthNumber (int64), MonthName (string), MonthStart (dateTime), YearMonth (string), DayNumber (int64), DayName (string), IsWeekend (boolean)

## Deliberate data problems and how Power Query fixes them

| File | Problem injected | Rows affected | Fix in Power Query |
| :-- | :-- | --: | :-- |
| campaigns.csv | objective and campaign name with stray spaces or mixed case | 1 | trim and proper-case the objective, trim the name |
| ad_results.csv | date written dd/MM/yyyy | 372 | try one format, then the other |
| ad_results.csv | spend and revenue stored as text ('GHS 1,250.00') | 994 | strip prefix and commas, convert to number |
| ad_results.csv | duplicate rows (same ad_id) | 125 | keep one per ad_id |

After these steps every key matches and every date parses.

## Built-in patterns in the data

These make the charts worth reading. They are designed, measured on the generated data, and not real findings.

- Overall ROAS is 3.02: Google Search returns the most (4.11) and Display the least (1.04).
- November is the highest-spend month, lifted by Black Friday.
- Meta cost per acquisition rises from GHS 47.42 in 2024 to GHS 54.05 in 2025.
- TikTok spend grows from GHS 17,282 in 2024 to GHS 29,754 in 2025.
- Total spend grows 2.7% and revenue -10.4% from 2024 to 2025.
- Cost per acquisition is lowest on Influencer (GHS 49.02) and highest on Display (GHS 146.31).

## Totals to check after a refresh

Use these to confirm that the report loads and calculates correctly (no filters applied):

| Measure | Expected value with no filters |
| :-- | :-- |
| `Spend` | 366,285 |
| `Impressions` | 25,125,881 |
| `Clicks` | 253,474 |
| `Conversions` | 5,722 |
| `Revenue` | 1,106,530 |
| `CTR %` | 1.01% |
| `CPC` | 1.45 |
| `CPM` | 14.58 |
| `Conversion Rate %` | 2.26% |
| `CPA` | 64.01 |
| `ROAS` | 3.02 |
| `Budget` | 378,400 |
| `Budget Used %` | 96.8% |
| `Spend YoY %` | 2.7% |
| `Revenue YoY %` | -10.4% |
