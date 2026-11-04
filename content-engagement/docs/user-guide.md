# User guide: Content and Email Engagement dashboard

This dashboard shows how a publisher's content performs by email, social media and its website. **All data is synthetic**, made up for demonstration.

## Who it is for

- Content managers who plan the calendar
- Email and CRM managers who tune sends
- Social media managers who choose platforms

## How to use it

1. **Choose a period and more** with the filters in the row at the bottom of each page. Your choices carry over to the other pages. Every number on the page responds.
2. **Click a chart element** (a bar, a slice, a month) to filter the rest of the page. Click it again to clear.
3. **Hover over a point** to see extra figures.
4. **Use the page tabs** at the bottom to move between pages.

## The pages

| Page | Question it answers |
| :-- | :-- |
| Overview | How does content perform across channels? |
| Email | Which sends and segments work? |
| Social | Which platforms engage? |
| Content | Which topics and formats bring people in? |

## What the measures mean

| Measure | Definition |
| :-- | :-- |
| Content Published | Pieces of content published in the dates selected. |
| Emails Sent | Emails sent. |
| Emails Delivered | Emails that reached an inbox. |
| Delivery Rate % | Delivered divided by sent. |
| Email Opens | Emails opened. |
| Open Rate % | Opens divided by delivered. |
| Email Clicks | Clicks on links in emails. |
| Click Rate % | Clicks divided by delivered. |
| Click to Open % | Clicks divided by opens. |
| Unsubscribes | Readers who unsubscribed. |
| Unsubscribe Rate % | Unsubscribes divided by delivered. |
| Email Signups | Signups that followed an email click. |
| Social Impressions | Times posts were shown. |
| Engagements | Likes, comments, shares and clicks. |
| Engagement Rate % | Engagements divided by impressions. |
| Shares | Times posts were shared. |
| Followers Gained | New followers from posts. |
| Sessions | Website visits. |
| Web Users | Weekly visitors, summed over weeks. |
| Bounce Rate % | Share of visits that left after one page, weighted by sessions. |
| Avg Time on Page (sec) | Average seconds on the page, weighted by sessions. |
| Web Signups | Signups made on the website. |
| Web Signup Rate % | Signups divided by sessions. |
| Total Signups | Signups from email and the website. |
| Sessions PY | Sessions in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Sessions YoY % | Change in sessions in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Sessions YTD | Sessions from the start of the year to the date shown. |
| Sessions 3M Average | Average monthly sessions over the last three months up to the month shown. |
| Engagements PY | Engagements in the same period one year earlier. Use it on a monthly chart, not on a card. |
| Engagements YoY % | Change in engagements in the latest year selected compared with the year before (same quarters if a quarter is selected). |
| Engagements YTD | Engagements from the start of the year to the date shown. |
| Engagements 3M Average | Average monthly engagements over the last three months up to the month shown. |

## Things to know

- Email measures respond to the audience filter; social measures respond to the platform filter. Other measures ignore them.
- Click rate is clicks divided by delivered emails; click-to-open is clicks divided by opens.
- Web figures are weekly. The first week after publishing is the highest and traffic then decays.
- Budgeting content peaks in January; investing content engages most.
- The data covers January 2024 to December 2025. Year-on-year figures start in 2025.

## Refreshing the data

1. Replace the CSV files in `data/raw` (same file names and columns).
2. Open the report in Power BI Desktop, then Home > Refresh.
3. If you moved the folder, change the `DataFolder` parameter: Home > Transform data > Edit parameters.

The Power Query steps clean known problems. New kinds of problems will need new steps.

## Known limits

- Synthetic data: the patterns were built into the data to make the charts readable.
- There is no row-level security. In a real deployment, restrict each user to the data they should see.
- The date table covers 2024 to 2025 only. Extend the `dim_Date` query for later data.
