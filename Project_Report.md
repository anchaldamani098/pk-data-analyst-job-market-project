# Pakistan Data Analyst Job Market — A Snapshot Analysis (June 2026)

## Executive Summary
This project analyzes **155 manually verified, source-linked job listings** for Data Analyst and related technical roles across Pakistan, collected from six job platforms (Indeed Pakistan, Glassdoor, LinkedIn, BeBee, Rozee.pk, Bayt.com) in June–July 2026. The sample is cross-referenced against **official Pakistan Bureau of Statistics (PBS) Labour Force Survey 2024-25** data to place hiring trends in national economic context. Key findings: Karachi and Lahore dominate hiring, Power BI and SQL are the most-cited technical skills, and only **2.6% of listings disclose an exact salary** — a transparency gap consistent with Pakistan's broader informal-wage-reporting patterns.

## Data Sources & Methodology
| Source | Rows | Description |
|---|---|---|
| Live job platform search (6 platforms) | 155 | Individual job postings — title, company, city, sector, salary if disclosed |
| Pakistan Bureau of Statistics — Labour Force Survey 2024-25 | 15 indicators | Official national employment statistics |
| Platform aggregate search-page counts (BeBee, Glassdoor, LinkedIn) | 14 metrics | Market-size context (not merged into the row-level sample) |

**Methodology notes:**
- Every listing is traceable to a live `source_url`; no row was scraped automatically — all were manually verified via live search sessions.
- Fields the source listing did not disclose (salary, employer name) were **kept as "Not disclosed" / "Confidential" and never estimated or invented**. Filling these with guessed values would misrepresent the dataset as more complete than it actually is.
- Data-cleaning logic (city normalization, work-mode/contract-type splitting, experience-level bucketing, currency-aware salary parsing) is documented in the `Cleaned_Data` sheet of the accompanying workbook.
- A data-quality check confirmed **zero duplicate listings** (matched on job title + company + city + platform + source URL).

## Key Findings

### 1. City Distribution
Karachi (43 listings, including neighborhood-tagged sub-locations) and Lahore (35) together account for **50%** of all listings. Islamabad follows with 16. A notable 34 listings (22%) are remote or country-wide with no specific city — reflecting growth in remote/distributed tech hiring.

| City | Listings |
|---|---|
| Karachi | 43 |
| Lahore | 35 |
| Remote / Unspecified | 34 |
| Islamabad | 16 |
| Rawalpindi | 5 |
| Hyderabad | 4 |
| Faisalabad | 3 |
| Multi-city | 3 |

### 2. Platform Coverage
Indeed Pakistan (67) and Glassdoor (37) together sourced two-thirds of the sample, followed by LinkedIn (19), BeBee (17), Rozee.pk (12), and Bayt.com (3).

### 3. Work Mode & Experience Level
**133 of 155 listings (86%) do not disclose work mode** (remote/onsite/hybrid) in the snippet text — a real limitation of platform search-result data, not a data-collection gap. Among the 22 that do: Remote (11) leads over Onsite (7) and Hybrid (4).

Experience level is similarly under-disclosed (99/155, 64% not specified), but among listings that do specify: **Senior roles (26) outnumber Mid-level (17) and Entry/Fresh (13)** — suggesting Pakistan's advertised data-analyst market currently skews toward experienced hires.

### 4. Salary Transparency
Only **4 of 155 listings (2.6%)** disclose a usable salary figure — and of those, only 2 are in PKR with a clear monthly value (average PKR 76,250/month, range PKR 32,500–120,000), 1 is USD-denominated, and 1 is an hourly USD contract rate (excluded from the monthly comparison as a different unit). This scarcity of disclosed salary is itself a finding, not a gap to be filled — see Macro Context below.

### 5. Skills in Demand
Extracted from job titles and listing notes, **Power BI (13 mentions)** and **SQL (7 mentions)** are the most-cited technical skills, followed by "Analytics" and "Business Intelligence" (9 each) as general role descriptors, and Python (5). This suggests Pakistani employers currently prioritize **BI/reporting tooling over general-purpose programming** for data-analyst-level roles.

## Macro Context: Sample vs. National Picture
Cross-referencing with PBS Labour Force Survey 2024-25:
- National **Labour Force Participation Rate rose from 44.9% (2020-21) to 47.7% (2024-25)**, and the **services sector's employment share grew to 41.2%** (from 37.4% agriculture previously dominant) — consistent with the sample's concentration in IT Services (63/155) and Technology (19/155) sectors.
- The national **average monthly wage is PKR 39,000** (Planning Commission, 2024-25). The two PKR-disclosed data-analyst-track salaries in this sample (PKR 32,500 and PKR 120,000) bracket that figure — one below, one nearly 3x above — illustrating the wide pay dispersion within tech roles compared to the national average.
- The sample's **2.6% salary-disclosure rate** mirrors a broader pattern of wage opacity documented in Pakistan's large informal/under-reported labour segment.

## Limitations
1. Manually compiled from live search sessions, not an automated scrape — 155 listings is a solid snapshot but smaller than a production crawler could gather.
2. Some employer names are genuinely "Confidential" in the source listings and were left as such rather than guessed.
3. Snapshot in time (late June–early July 2026); job postings expire and get replaced continuously.
4. Work-mode and experience-level are frequently absent from platform search snippets — this reflects real data availability, not a processing error.

## Conclusion
Pakistan's advertised data-analyst job market is concentrated in Karachi and Lahore, sourced predominantly through Indeed and Glassdoor, skews toward BI/reporting tool skills (Power BI, SQL) over general programming, and — like the broader national labour market — offers limited salary transparency. Aspiring analysts should prioritize Power BI and SQL proficiency and expect most listings to require direct outreach to learn compensation details.

---
*Full data, cleaning logic, formulas, and charts: see `Pakistan_Data_Analyst_Job_Market_Analysis.xlsx`*
