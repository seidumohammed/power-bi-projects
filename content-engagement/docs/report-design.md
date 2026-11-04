# Report design: Content and Email Engagement

Canvas: 16:9 (1280 x 720). The report theme sets fonts and colours.

## Style system

Every page uses the same building blocks, set by a custom theme file inside the report folder (`StaticResources/RegisteredResources`) and repeated on every page:

| Element | Style |
| :-- | :-- |
| Header | No band: the page title (20 pt) sits on the page background |
| Filters | One row of dropdown filters at the bottom of the page, each with a small label. The same filter keeps its selection on every page (synced) |
| KPI cards | Panel with a 10 pt label, a 26 pt semibold value, and a coloured accent bar along the bottom edge |
| Chart panels | Panel with a 1 px border, 16 px rounded corners, 12 pt semibold title, 9 pt axis and legend text, no axis titles |
| Tables and matrices | Header row in the dark colour with light text, thin horizontal grid lines, subtle alternate row shading |
| Fonts | Segoe UI and Segoe UI Semibold. Nothing larger than 26 pt except the page title |

### Palette

| Use | Colour |
| :-- | :-- |
| Page background | `#FBF4F0` |
| Header band, table headers | `#6C5B7B` |
| Primary (values, main series) | `#6C5B7B` |
| Series 1 | `#6C5B7B` |
| Series 2 (target, prior year) | `#F08A5D` |
| Alert | `#D8523F` |
| Muted text | `#5C6672` |

## Filters by page

| Page | Filters in the column |
| :-- | :-- |
| Overview | Year, Quarter, Topic, Format, Author |
| Email | Year, Quarter, Audience segment, Topic, Format |
| Social | Year, Quarter, Platform, Topic, Format |
| Content | Year, Quarter, Topic, Format, Author |

Filters that do not relate to a visual do not change it.

## Page 1: Overview

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Content published | card | Values: `Content Published` |
| Email open rate | card | Values: `Open Rate %` |
| Social engagement | card | Values: `Engagement Rate %` |
| Web sessions | card | Values: `Sessions` |
| Signups | card | Values: `Total Signups` |
| Web sessions against prior year | lineChart | Category: `dim_Date[MonthStart]`; Y: `Sessions`, `Sessions PY` |
| Sessions by topic | clusteredBarChart | Category: `dim_Content[Topic]`; Y: `Sessions` |
| Signups by format | clusteredColumnChart | Category: `dim_Content[Format]`; Y: `Total Signups` |
| Social engagements against prior year | lineChart | Category: `dim_Date[MonthStart]`; Y: `Engagements`, `Engagements PY` |
## Page 2: Email

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Emails sent | card | Values: `Emails Sent` |
| Open rate | card | Values: `Open Rate %` |
| Click rate | card | Values: `Click Rate %` |
| Click to open | card | Values: `Click to Open %` |
| Unsubscribe rate | card | Values: `Unsubscribe Rate %` |
| Open and click rate, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Open Rate %`, `Click Rate %` |
| Open rate by audience | clusteredColumnChart | Category: `dim_Audience[AudienceSegment]`; Y: `Open Rate %` |
| Unsubscribe rate, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Unsubscribe Rate %` |
| Audience segments | tableEx | Values: `dim_Audience[AudienceSegment]`, `Emails Sent`, `Open Rate %`, `Click Rate %`, `Unsubscribe Rate %`, `Email Signups` |
## Page 3: Social

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Impressions | card | Values: `Social Impressions` |
| Engagements | card | Values: `Engagements` |
| Engagement rate | card | Values: `Engagement Rate %` |
| Shares | card | Values: `Shares` |
| Followers gained | card | Values: `Followers Gained` |
| Engagement rate, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Engagement Rate %` |
| Engagement rate by platform | clusteredBarChart | Category: `dim_Platform[Platform]`; Y: `Engagement Rate %` |
| Engagements by format | clusteredColumnChart | Category: `dim_Content[Format]`; Y: `Engagements` |
| Platforms | tableEx | Values: `dim_Platform[Platform]`, `Social Impressions`, `Engagements`, `Engagement Rate %`, `Shares`, `Followers Gained` |
## Page 4: Content

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Web sessions | card | Values: `Sessions` |
| Bounce rate | card | Values: `Bounce Rate %` |
| Seconds on page | card | Values: `Avg Time on Page (sec)` |
| Signup rate | card | Values: `Web Signup Rate %` |
| Web signups | card | Values: `Web Signups` |
| Signup rate by topic | clusteredBarChart | Category: `dim_Content[Topic]`; Y: `Web Signup Rate %` |
| Bounce rate by format | clusteredColumnChart | Category: `dim_Content[Format]`; Y: `Bounce Rate %` |
| Sessions by author | clusteredBarChart | Category: `dim_Content[Author]`; Y: `Sessions` |
| Content | tableEx | Values: `dim_Content[Title]`, `dim_Content[Topic]`, `Sessions`, `Avg Time on Page (sec)`, `Web Signups` |

## Added by hand in Desktop

Top N filters, conditional formatting, constant reference lines, page navigator buttons, drill-through pages and bookmarks are not in the generated project files. Add them in Desktop if you want them.
