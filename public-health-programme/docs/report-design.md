# Report design: Public Health Programme

Canvas: 16:9 (1280 x 720). The report theme sets fonts and colours.

## Style system

Every page uses the same building blocks, set by a custom theme file inside the report folder (`StaticResources/RegisteredResources`) and repeated on every page:

| Element | Style |
| :-- | :-- |
| Header band | Full-width dark band (72 px) with the page title (18 pt, semibold, white) and a one-line subtitle (10 pt) |
| Filters | One framed column on the right of every page (238 px wide) with a "Filters" title and dropdown slicers, each with a small grey label. The same filter keeps its selection on every page (synced) |
| KPI cards | Panel with a 10 pt label, a 26 pt semibold value, and a coloured accent bar on the left edge |
| Chart panels | Panel with a 1 px border, 6 px rounded corners, 12 pt semibold title, 9 pt axis and legend text, no axis titles |
| Tables and matrices | Header row in the dark colour with light text, thin horizontal grid lines, subtle alternate row shading |
| Fonts | Segoe UI and Segoe UI Semibold. Nothing larger than 26 pt except the page title |

### Palette

| Use | Colour |
| :-- | :-- |
| Page background | `#F1F5EC` |
| Header band, table headers | `#2F4B26` |
| Primary (values, main series) | `#4C8C2B` |
| Series 1 | `#4C8C2B` |
| Series 2 (target, prior year) | `#E2A72E` |
| Alert | `#C8553D` |
| Muted text | `#5E6B58` |

## Filters by page

| Page | Filters in the column |
| :-- | :-- |
| Programme overview | Year, Quarter, Subregion, District, Facility level |
| Immunisation | Year, Quarter, Subregion, District, Facility level, Vaccine |
| Disease surveillance | Year, Quarter, Subregion, District, Facility level, Disease |
| Reporting and facilities | Year, Quarter, Subregion, District, Facility level, Facility |

Filters that do not relate to a visual do not change it.

## Page 1: Programme overview

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Immunisation coverage | card | Values: `Coverage %` |
| Penta dropout | card | Values: `Penta Dropout %` |
| Cases reported | card | Values: `Cases` |
| Test positivity | card | Values: `Test Positivity %` |
| Reporting completeness | card | Values: `Reporting Completeness %` |
| Coverage against target | lineChart | Category: `dim_Date[MonthStart]`; Y: `Coverage %`, `Coverage Target` |
| Coverage by district | clusteredBarChart | Category: `dim_District[District]`; Y: `Coverage %` |
| Cases by disease, by month | lineChart | Category: `dim_Date[MonthStart]`; Series: `dim_Disease[Disease]`; Y: `Cases` |
| Reporting completeness by facility level | clusteredColumnChart | Category: `dim_Facility[FacilityLevel]`; Y: `Reporting Completeness %` |
## Page 2: Immunisation

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Doses given | card | Values: `Doses Given` |
| Coverage | card | Values: `Coverage %` |
| Gap to target | card | Values: `Coverage Gap (points)` |
| Penta dropout | card | Values: `Penta Dropout %` |
| Coverage by vaccine | clusteredColumnChart | Category: `dim_Antigen[Antigen]`; Y: `Coverage %` |
| Doses given against prior year | lineChart | Category: `dim_Date[MonthStart]`; Y: `Doses Given`, `Doses PY` |
| Gap to target by district | clusteredBarChart | Category: `dim_District[District]`; Y: `Coverage Gap (points)` |
| Coverage by district and vaccine | pivotTable | Rows: `dim_District[District]`; Columns: `dim_Antigen[Antigen]`; Values: `Coverage %` |
## Page 3: Disease surveillance

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Cases reported | card | Values: `Cases` |
| Deaths | card | Values: `Deaths` |
| Case fatality | card | Values: `Case Fatality %` |
| Test positivity | card | Values: `Test Positivity %` |
| Cases by disease, by month | lineChart | Category: `dim_Date[MonthStart]`; Series: `dim_Disease[Disease]`; Y: `Cases` |
| Cases per 1,000 by district | clusteredBarChart | Category: `dim_District[District]`; Y: `Cases per 1,000` |
| Case fatality by disease | clusteredColumnChart | Category: `dim_Disease[Disease]`; Y: `Case Fatality %` |
| Diseases | tableEx | Values: `dim_Disease[Disease]`, `Cases`, `Deaths`, `Case Fatality %`, `Test Positivity %`, `Cases per 1,000` |
## Page 4: Reporting and facilities

| Visual | Type | Fields |
| :-- | :-- | :-- |
| Facilities | card | Values: `Facilities` |
| Reports received | card | Values: `Reporting Completeness %` |
| Reports on time | card | Values: `Reporting Timeliness %` |
| Reports expected | card | Values: `Reports Expected` |
| Completeness and timeliness, by month | lineChart | Category: `dim_Date[MonthStart]`; Y: `Reporting Completeness %`, `Reporting Timeliness %` |
| Completeness by district | clusteredBarChart | Category: `dim_District[District]`; Y: `Reporting Completeness %` |
| Facilities by level | donutChart | Category: `dim_Facility[FacilityLevel]`; Y: `Facilities` |
| Facilities | tableEx | Values: `dim_Facility[Facility]`, `dim_Facility[FacilityLevel]`, `Coverage %`, `Reporting Completeness %`, `Reporting Timeliness %` |

## Added by hand in Desktop

Top N filters, conditional formatting, constant reference lines, page navigator buttons, drill-through pages and bookmarks are not in the generated project files. Add them in Desktop if you want them.
