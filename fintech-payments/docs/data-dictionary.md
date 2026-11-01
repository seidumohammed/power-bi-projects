# Data dictionary: FinTech Payments

All data is synthetic and was generated with a fixed random seed. The provider and every customer, transaction and loan are invented. Region names are real Ghana regions used only as labels.

## Raw files (data/raw)

| File | Rows | Description |
| :-- | --: | :-- |
| `regions.csv` | 5 | Regions |
| `customers.csv` | 3,200 | Customers with segment, region, acquisition channel and join date |
| `txn_types.csv` | 6 | Transaction types |
| `channels.csv` | 3 | Channels |
| `transactions.csv` | 52,214 | One row per transaction attempt |
| `loans.csv` | 2,323 | One row per small loan |
| `targets.csv` | 120 | Monthly transaction value target by region |

## Columns after cleaning

**dim_Region**: Region (string)
**dim_Customer**: CustomerID (string), Segment (string), Region (string), AcquisitionChannel (string), JoinedDate (dateTime)
**dim_TxnType**: TypeID (string), TxnType (string), TxnGroup (string)
**dim_Channel**: ChannelID (string), Channel (string)
**fact_Transaction**: TxnID (string), TxnDate (dateTime), CustomerID (string), TypeID (string), ChannelID (string), AmountGHS (double), FeeGHS (double), Status (string), FailureReason (string), IsFraud (int64), IsSuccess (int64), IsFailed (int64), IsReversed (int64), SuccessValueGHS (double), FraudValueGHS (double)
**fact_Loan**: LoanID (string), CustomerID (string), DisbursedDate (dateTime), AmountGHS (double), TermDays (int64), Status (string), DaysPastDue (int64), RepaidGHS (double), OutstandingGHS (double), IsDefault (int64), PAR30BalanceGHS (double)
**fact_Target**: MonthStart (dateTime), Region (string), TxnValueTargetGHS (double)
**dim_Date**: Date (dateTime), Year (int64), Quarter (string), MonthNumber (int64), MonthName (string), MonthStart (dateTime), YearMonth (string), DayNumber (int64), DayName (string), IsWeekend (boolean)

## Deliberate data problems and how Power Query fixes them

| File | Problem injected | Rows affected | Fix in Power Query |
| :-- | :-- | --: | :-- |
| customers.csv | segment with stray spaces or mixed case | 288 | trim and proper-case |
| transactions.csv | txn_date written dd/MM/yyyy | 1,542 | try one format, then the other |
| transactions.csv | amount stored as text ('GHS 1,250.00') | 2,108 | strip prefix and commas, convert to number |
| transactions.csv | status with stray spaces or mixed case | 2,910 | trim and proper-case |
| transactions.csv | duplicate transaction rows (same txn_id) | 517 | keep one per txn_id |
| loans.csv | disbursed_date written dd/MM/yyyy | 53 | try one format, then the other |
| loans.csv | amount stored as text | 97 | strip prefix and commas, convert to number |
| loans.csv | status with stray spaces or mixed case | 148 | trim and proper-case |
| loans.csv | duplicate loan rows (same loan_id) | 23 | keep one per loan_id |

After these steps every key matches and every date parses.

## Built-in patterns in the data

These make the charts worth reading. They are designed, measured on the generated data, and not real findings.

- The wallet grows: successful transaction value is 46% higher in 2025 than in 2024, and customers join steadily.
- Channels differ in reliability: USSD fails 5.9% of the time against 2.2% for App.
- A USSD incident is built into August 2024: the failure rate that month is 10.0%, against 3.6% in the other months on average.
- Failures fall over time as the app takes a larger share of payments: from 4.4% in the first three months to 2.9% in the last three.
- Fraud peaks in 2025Q1 at 36.6 cases per 10,000 transactions (the average is 25.3).
- Loan quality differs by segment: default rate is 5.9% for Student and 1.4% for Salaried.
- Monthly regional value sits close to target, from 91% to 112% of target (median 101%).

## Totals to check after a refresh

Use these to confirm that the report loads and calculates correctly (no filters applied):

| Measure | Expected value with no filters |
| :-- | :-- |
| `Transactions` | 51,697 |
| `Successful Transactions` | 49,475 |
| `Success Rate %` | 95.7% |
| `Failure Rate %` | 3.7% |
| `Reversal Rate %` | 0.6% |
| `Txn Value (GHS)` | 6,808,878 |
| `Avg Txn Value (GHS)` | 137.62 |
| `Fee Revenue (GHS)` | 43,413 |
| `Active Customers` | 3,013 |
| `Fraud Cases` | 131 |
| `Fraud Rate (per 10,000)` | 25.3 |
| `Fraud Value (GHS)` | 18,415 |
| `Loans Disbursed (count)` | 2,300 |
| `Loans Disbursed (GHS)` | 636,111 |
| `Loans Outstanding (GHS)` | 105,492 |
| `PAR30 %` | 15.5% |
| `Default Rate %` | 2.5% |
| `Txn Value YoY %` | 45.9% |
| `Fee Revenue YoY %` | 43.4% |
