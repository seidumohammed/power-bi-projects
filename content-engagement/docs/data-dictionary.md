# Data dictionary: Content and Email Engagement

All data is synthetic and was generated with a fixed random seed. The publisher and all figures are invented. Platform names are real services used only as labels.

## Raw files (data/raw)

| File | Rows | Description |
| :-- | --: | :-- |
| `content.csv` | 166 | One row per piece of content |
| `platforms.csv` | 5 | Social platforms |
| `audiences.csv` | 3 | Email audience segments |
| `email.csv` | 397 | One row per email send and segment |
| `social.csv` | 535 | One row per social post |
| `web.csv` | 2,232 | Weekly web traffic per content |

## Columns after cleaning

**dim_Content**: ContentID (string), Title (string), Topic (string), Format (string), Author (string), PublishDate (dateTime)
**dim_Platform**: PlatformID (string), Platform (string)
**dim_Audience**: AudienceID (string), AudienceSegment (string)
**fact_Email**: EmailID (string), SendDate (dateTime), ContentID (string), AudienceID (string), Sent (int64), Delivered (int64), Opens (int64), Clicks (int64), Unsubscribes (int64), Signups (int64)
**fact_Social**: PostID (string), PostDate (dateTime), ContentID (string), PlatformID (string), Impressions (int64), Engagements (int64), Shares (int64), FollowersGained (int64)
**fact_Web**: WebID (string), WeekStart (dateTime), ContentID (string), Sessions (int64), Users (int64), BounceRate (double), AvgSeconds (double), Signups (int64)
**dim_Date**: Date (dateTime), Year (int64), Quarter (string), MonthNumber (int64), MonthName (string), MonthStart (dateTime), YearMonth (string), DayNumber (int64), DayName (string), IsWeekend (boolean)

## Deliberate data problems and how Power Query fixes them

| File | Problem injected | Rows affected | Fix in Power Query |
| :-- | :-- | --: | :-- |
| content.csv | publish date written dd/MM/yyyy | 4 | try one format, then the other |
| content.csv | topic, format and author with stray spaces or mixed case | 17 | trim and proper-case topic and format, trim author |
| content.csv | duplicate rows (same content_id) | 2 | keep one per content_id |
| email.csv | send_date written dd/MM/yyyy | 9 | try one format, then the other |
| email.csv | duplicate rows (same email_id) | 4 | keep one per email_id |
| social.csv | post_date written dd/MM/yyyy | 16 | try one format, then the other |
| social.csv | duplicate rows (same post_id) | 5 | keep one per post_id |
| web.csv | week_start written dd/MM/yyyy | 65 | try one format, then the other |
| web.csv | bounce rate stored as text ('42%') | 106 | remove % and divide by 100 |
| web.csv | duplicate rows (same web_id) | 22 | keep one per web_id |

After these steps every key matches and every date parses.

## Built-in patterns in the data

These make the charts worth reading. They are designed, measured on the generated data, and not real findings.

- Email open rate is 36.3% overall: Small business owners open most (41%) and Students least (29%).
- Unsubscribes spike in 2024-11: 1.14% of delivered emails, after send volume rose.
- Instagram has the highest social engagement rate (6.2%) and X the lowest (2.3%).
- Investing content engages most on social (6.1%); Insurance content engages least (3.2%).
- Budgeting brings the most web sessions (155,334), and traffic peaks in the first week after publishing.
- Web sessions change 12.4% from 2024 to 2025.

## Totals to check after a refresh

Use these to confirm that the report loads and calculates correctly (no filters applied):

| Measure | Expected value with no filters |
| :-- | :-- |
| `Content Published` | 164 |
| `Emails Sent` | 2,380,805 |
| `Delivery Rate %` | 98.2% |
| `Open Rate %` | 36.3% |
| `Click Rate %` | 3.1% |
| `Click to Open %` | 8.6% |
| `Unsubscribe Rate %` | 0.43% |
| `Email Signups` | 8,891 |
| `Social Impressions` | 3,255,176 |
| `Engagements` | 143,464 |
| `Engagement Rate %` | 4.4% |
| `Followers Gained` | 4,829 |
| `Sessions` | 613,621 |
| `Bounce Rate %` | 45.6% |
| `Avg Time on Page (sec)` | 124 |
| `Web Signups` | 7,820 |
| `Total Signups` | 16,711 |
| `Sessions YoY %` | 12.4% |
