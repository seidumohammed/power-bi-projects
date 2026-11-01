# Power BI portfolio: Twitter threads and LinkedIn posts

Repository: https://github.com/seidumohammed/power-bi-projects
Add the screenshot named in each section to the first post. Each tweet is under 280 characters.
Before posting a project, check that its folder is on GitHub. Real Estate, Supply Chain, FinTech, Hospital and Public Health are not pushed yet.

---

## 1. Programme Monitoring (Central Region)

### Twitter thread

1/ I built a Power BI dashboard that monitors a village savings programme in Ghana's Central Region. The programme, zones and groups are invented, and so is all the data. Thread on how it works.

2/ The data arrives messy on purpose: dates in two formats, amounts stored as text, duplicate rows, inconsistent names. Power Query cleans each problem once, so every page reads the same clean tables.

3/ The model is a star schema. Dimensions describe zones, groups and time. Facts hold savings, loans and repayments. Filters flow one way, which keeps the DAX measures short and easy to check.

4/ Every page has the same filter column, a fixed palette and a short list of visuals. I wrote down the rules, so the report looks the same on every page.

5/ The project includes a data dictionary, a model note and a user guide. Code and data are on GitHub: https://github.com/seidumohammed/power-bi-projects/tree/main/programme-monitoring

### LinkedIn post

I have published a Power BI project that monitors a village savings and loan programme in Ghana's Central Region.

The programme, zones and groups are invented, and all data is synthetic. I chose a setting I know how to read, then built the whole workflow around it.

What the project covers:
- Power Query steps that fix mixed date formats, amounts stored as text, duplicates and inconsistent names.
- A star schema with dimensions for zones, groups and time, and facts for savings, loans and repayments.
- DAX measures for savings, loan repayment and year-on-year change.
- Four report pages with one filter column, a fixed palette and written design rules.
- A data dictionary, a model note and a user guide for non-technical readers.

The repository contains the raw files, the queries, the measures and the report project.

https://github.com/seidumohammed/power-bi-projects/tree/main/programme-monitoring

#PowerBI #DataAnalytics #DAX

---

## 2. Sales Performance

### Twitter thread

1/ I built a Power BI sales dashboard on synthetic retail data. It answers one question: are we selling more than last year, and where? Thread.

2/ Year-on-year was the hardest measure. My first version compared all dates against all dates and showed 111.9%. The correct version compares the latest selected year with the year before. The result is 11.9%.

3/ Rolling totals had a similar problem. A three-month rolling total looks like a monthly figure but is three times too large. I changed it to a three-month average.

4/ Targets use TREATAS on the month, so a target appears only where it applies. The report shows blanks where no target exists, not zeros.

5/ The pages cover products, stores and customers, and targets and trends. Everything is on GitHub: https://github.com/seidumohammed/power-bi-projects/tree/main/sales-performance

### LinkedIn post

A good measure can still be wrong. My first year-on-year calculation in a Power BI sales project showed 111.9%. The correct figure was 11.9%.

The first version compared every date in the model with every date a year earlier. The fix was to compare the latest selected year with the year before it. The same review caught a rolling three-month total that should have been an average.

I found both problems by checking the report against totals calculated outside Power BI. I now write those expected totals into the project documentation, so anyone can verify a refresh.

The project uses synthetic retail data and includes cleaning steps in Power Query, a star schema, DAX measures for targets and time comparisons, and pages for products, stores, customers and trends.

https://github.com/seidumohammed/power-bi-projects/tree/main/sales-performance

#PowerBI #DAX #DataAnalytics

---

## 3. Real Estate Performance

### Twitter thread

1/ New Power BI project: a real estate dashboard for an invented agency in Greater Accra, with three branches and 24 agents. All data is synthetic. Thread.

2/ The model has listings, sales and branch targets. Days on market and commission are calculated in Power Query, so the measures stay simple.

3/ The report answers four questions: how the business is doing, which areas sell, which agents and branches perform, and whether listings and targets are on track.

4/ Layout uses a header band and a filter panel on the right. It is one of three layout systems I built for this series.

5/ Code, data and documentation: https://github.com/seidumohammed/power-bi-projects/tree/main/real-estate-performance

### LinkedIn post

I have added a real estate performance dashboard to my Power BI portfolio.

It follows an invented agency in Greater Accra with three branches and 24 agents. All listings and sales are synthetic.

The model links listings, sales and branch targets to shared dimensions for time, area and agent. Days on market and commission are calculated in Power Query. DAX covers sales value, price per square metre, conversion from listing to sale, and performance against target.

The four pages are an executive summary, market and areas, agents and branches, and listings and targets. The layout uses a dark header band and a filter panel on the right.

The repository includes the data, the queries, the measures and written documentation.

https://github.com/seidumohammed/power-bi-projects/tree/main/real-estate-performance

#PowerBI #RealEstate #DataAnalytics

---

## 4. Supply Chain Performance

### Twitter thread

1/ New Power BI project: supply chain performance for an invented distributor with hubs in Tema, Takoradi, Tamale and Ho. All data is synthetic. Thread.

2/ The main measure is on-time-in-full delivery. I calibrated the synthetic data so service sits near 85%, with a few stockouts, because a flat 100% or a collapsed 40% tells a reader nothing.

3/ Stock is a month-end snapshot, so inventory measures read the latest stock in the period, not a sum. Summing stock across months is a common modelling error.

4/ Pages: service overview, hubs and carriers, inventory, and suppliers. The layout is a dark left rail that carries every filter.

5/ Repository: https://github.com/seidumohammed/power-bi-projects/tree/main/supply-chain-performance

### LinkedIn post

Stock is not a flow. If a model sums month-end inventory across months, the total is meaningless.

That was one of the modelling points in my new supply chain Power BI project. The data is synthetic and belongs to an invented distributor with hubs in Tema, Takoradi, Tamale and Ho.

The model holds order lines, month-end stock, supplier receipts and a service target. Inventory measures use the latest snapshot in the period selected. Service is measured as on-time-in-full delivery, and the data is calibrated so that the figure sits near 85% with a small share of stockouts.

The four pages cover service, hubs and carriers, inventory, and suppliers. A dark left rail carries all filters.

Code, data and documentation are in the repository.

https://github.com/seidumohammed/power-bi-projects/tree/main/supply-chain-performance

#PowerBI #SupplyChain #DataAnalytics

---

## 5. FinTech Payments

### Twitter thread

1/ New Power BI project: a payments dashboard for an invented mobile money and lending provider. All data is synthetic. Thread.

2/ The data holds a planned event. A USSD outage in August 2024 should be visible in the channel chart, and it is. I measured the pattern after generating the data, instead of assuming it.

3/ Fraud peaks in early 2025. Loan portfolio at risk over 30 days sits near 15.5% and default near 2.5%.

4/ The design is dark: a dark canvas, dark panels and a top filter strip. It is the third layout system in the series.

5/ Repository: https://github.com/seidumohammed/power-bi-projects/tree/main/fintech-payments

### LinkedIn post

I have published a payments and lending dashboard built in Power BI. The provider, customers and transactions are invented, and the data is synthetic.

The data includes events an analyst would need to find: a USSD channel outage in August 2024, a rise in fraud in early 2025, and a loan book with portfolio at risk near 15.5%. I checked each pattern against the generated data before writing it into the documentation.

The model covers transactions, loans and targets, with dimensions for customers, regions, transaction types and channels. The four pages are overview, channels and reliability, customers and growth, and fraud and loans.

This project uses a dark layout with a filter strip across the top.

https://github.com/seidumohammed/power-bi-projects/tree/main/fintech-payments

#PowerBI #FinTech #DataAnalytics

---

## 6. Hospital Operations

### Twitter thread

1/ New Power BI project: hospital operations for an invented 120-bed regional hospital in Ghana's Volta Region. All data is synthetic, and no individual patient exists in the model. Thread.

2/ Facts point to patient profiles, such as "female, 30 to 44, NHIS, Ho Municipal". Nothing can be traced to a person. It is a privacy choice as much as a modelling one.

3/ Bed occupancy comes from a daily census, so it does not depend on how admissions are counted. Occupancy is compared with an 85% target by ward.

4/ The emergency department page measures waiting time against targets for each triage level. Some waiting times arrive as text, such as "45 min", and Power Query converts them.

5/ Repository: https://github.com/seidumohammed/power-bi-projects/tree/main/hospital-operations

### LinkedIn post

Health data needs care even when it is synthetic, so I designed my hospital Power BI project without individual patients.

The hospital is invented: 120 beds in the Volta Region. Admissions and emergency visits point to a small table of patient profiles, each a combination of sex, age group, insurance and district. Nothing can be traced to a person, which is also how a real model would limit risk.

The report covers admissions, length of stay, bed occupancy against an 85% target, readmission and mortality by diagnosis group, and emergency waiting times against triage targets. Waiting times stored as text are converted in Power Query.

This is not real health data and not medical advice.

https://github.com/seidumohammed/power-bi-projects/tree/main/hospital-operations

#PowerBI #HealthcareAnalytics #DataAnalytics

---

## 7. Public Health Programme

### Twitter thread

1/ New Power BI project: a regional health directorate in Ghana's Northern Region, covering immunisation, disease surveillance and reporting. District names are real labels, but all figures and facilities are invented. Thread.

2/ Immunisation coverage is measured against a 90% target. In the data, coverage averages 83%, and the gap between districts is wide. Gushegu is lowest and Tamale Metropolitan highest.

3/ Disease surveillance follows seasons. Malaria rises in the rains, and meningitis in the dry season, with an outbreak built into February and March 2025.

4/ Reporting quality gets its own page. Completeness and timeliness tell a reader whether the other numbers can be trusted.

5/ Repository: https://github.com/seidumohammed/power-bi-projects/tree/main/public-health-programme

### LinkedIn post

Programme dashboards often show results without showing whether the reporting behind them is reliable. My public health Power BI project puts reporting quality on its own page.

The setting is an invented regional health directorate in the Northern Region. District names are real and used as labels. Facilities, populations and every figure are invented, and nothing describes real conditions.

The report covers immunisation coverage against a 90% target, Penta dropout, disease cases and fatality, test positivity, incidence per 1,000 people, and reporting completeness and timeliness by district and facility level. The data carries seasonal patterns for malaria and meningitis.

Code, data and documentation are in the repository.

https://github.com/seidumohammed/power-bi-projects/tree/main/public-health-programme

#PowerBI #PublicHealth #DataAnalytics
