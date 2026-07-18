-- ============================================================
-- Pakistan Data Analyst Job Market — Analytical Queries
-- Engine: SQLite 3 (tested via create_database.py / job_market.db)
-- Each query is grouped by the business question it answers and
-- annotated with the SQL technique it demonstrates.
-- ============================================================


-- --------------------------------------------------------------
-- Q1. City-wise listing distribution, ranked
-- Technique: GROUP BY, ORDER BY, window function RANK()
-- --------------------------------------------------------------
SELECT
    city_clean,
    COUNT(*)                                   AS listing_count,
    RANK() OVER (ORDER BY COUNT(*) DESC)       AS city_rank,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM job_listings), 1) AS pct_of_total
FROM job_listings
GROUP BY city_clean
ORDER BY listing_count DESC;


-- --------------------------------------------------------------
-- Q2. Cities that individually account for at least 5% of listings
-- Technique: GROUP BY + HAVING with a scalar subquery
-- --------------------------------------------------------------
SELECT
    city_clean,
    COUNT(*) AS listing_count
FROM job_listings
GROUP BY city_clean
HAVING COUNT(*) >= 0.05 * (SELECT COUNT(*) FROM job_listings)
ORDER BY listing_count DESC;


-- --------------------------------------------------------------
-- Q3. Top 3 most recent listings per platform
-- Technique: window function ROW_NUMBER() PARTITION BY, CTE
-- --------------------------------------------------------------
WITH ranked_listings AS (
    SELECT
        platform,
        job_title,
        city_clean,
        date_posted_or_seen,
        ROW_NUMBER() OVER (
            PARTITION BY platform
            ORDER BY date_posted_or_seen DESC
        ) AS recency_rank
    FROM job_listings
)
SELECT platform, job_title, city_clean, date_posted_or_seen
FROM ranked_listings
WHERE recency_rank <= 3
ORDER BY platform, recency_rank;


-- --------------------------------------------------------------
-- Q4. Experience-level demand, only among listings that disclose it
-- Technique: CASE WHEN, CTE, percentage-of-total window function
-- --------------------------------------------------------------
WITH disclosed_experience AS (
    SELECT
        experience_level,
        CASE
            WHEN experience_level = 'Senior'      THEN 3
            WHEN experience_level = 'Mid'         THEN 2
            WHEN experience_level = 'Entry/Fresh' THEN 1
            ELSE 0
        END AS seniority_rank
    FROM job_listings
    WHERE experience_level != 'Not disclosed'
)
SELECT
    experience_level,
    COUNT(*) AS listing_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_disclosed
FROM disclosed_experience
GROUP BY experience_level, seniority_rank
ORDER BY seniority_rank DESC;


-- --------------------------------------------------------------
-- Q5. Skill demand — mention counts across job titles & notes
-- Technique: UNION ALL to pivot a fixed skill list into rows,
-- correlated subquery with LIKE for counting
-- --------------------------------------------------------------
WITH skills(skill) AS (
    SELECT 'power bi' UNION ALL SELECT 'sql' UNION ALL SELECT 'python'
    UNION ALL SELECT 'business intelligence' UNION ALL SELECT 'analytics'
    UNION ALL SELECT 'reporting' UNION ALL SELECT 'etl'
    UNION ALL SELECT 'excel' UNION ALL SELECT 'machine learning'
    UNION ALL SELECT 'data warehouse'
)
SELECT
    skills.skill,
    (SELECT COUNT(*) FROM job_listings
     WHERE search_text LIKE '%' || skills.skill || '%') AS mention_count
FROM skills
ORDER BY mention_count DESC;


-- --------------------------------------------------------------
-- Q6. Salary transparency summary
-- Technique: conditional aggregation with CASE/COUNT, ROUND, COALESCE
-- --------------------------------------------------------------
SELECT
    COUNT(*)                                                       AS total_listings,
    SUM(CASE WHEN salary_disclosed = 'Yes' THEN 1 ELSE 0 END)       AS disclosed_count,
    ROUND(100.0 * SUM(CASE WHEN salary_disclosed = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS disclosed_pct,
    ROUND(AVG(CASE WHEN salary_currency = 'PKR' THEN salary_value_monthly END), 0) AS avg_pkr_monthly,
    COALESCE(MIN(CASE WHEN salary_currency = 'PKR' THEN salary_value_monthly END), 0) AS min_pkr_monthly,
    COALESCE(MAX(CASE WHEN salary_currency = 'PKR' THEN salary_value_monthly END), 0) AS max_pkr_monthly
FROM job_listings;


-- --------------------------------------------------------------
-- Q7. Platforms performing above the average listings-per-platform
-- Technique: subquery in WHERE clause (HAVING vs subquery comparison)
-- --------------------------------------------------------------
SELECT platform, COUNT(*) AS listing_count
FROM job_listings
GROUP BY platform
HAVING COUNT(*) > (
    SELECT AVG(cnt) FROM (
        SELECT COUNT(*) AS cnt FROM job_listings GROUP BY platform
    )
)
ORDER BY listing_count DESC;


-- --------------------------------------------------------------
-- Q8. Sector concentration within each city (top sector per city)
-- Technique: window function ROW_NUMBER PARTITION BY + CTE, multi-level GROUP BY
-- --------------------------------------------------------------
WITH city_sector_counts AS (
    SELECT
        city_clean,
        sector,
        COUNT(*) AS n,
        ROW_NUMBER() OVER (PARTITION BY city_clean ORDER BY COUNT(*) DESC) AS rn
    FROM job_listings
    WHERE city_clean IN ('Karachi','Lahore','Islamabad')
    GROUP BY city_clean, sector
)
SELECT city_clean, sector AS top_sector, n AS listing_count
FROM city_sector_counts
WHERE rn = 1;


-- --------------------------------------------------------------
-- Q9. Sample vs national context — cross-referencing the two tables
-- Technique: no shared key, so values are pulled independently and
-- combined via a CTE + UNION ALL into one comparison result set
-- --------------------------------------------------------------
WITH sample_metric AS (
    SELECT
        'Sample: Salary disclosure rate' AS metric,
        ROUND(100.0 * SUM(CASE WHEN salary_disclosed = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS value,
        '%' AS unit
    FROM job_listings
),
national_metric AS (
    SELECT indicator AS metric, value, unit
    FROM national_labour_stats
    WHERE indicator IN (
        'Labour Force Participation Rate (LFPR)',
        'Services sector share of employment',
        'Overall unemployment rate'
    )
)
SELECT * FROM sample_metric
UNION ALL
SELECT * FROM national_metric;


-- --------------------------------------------------------------
-- Q10. Reusable view: one-stop salary transparency dashboard source
-- Technique: CREATE VIEW for downstream BI-tool consumption
-- --------------------------------------------------------------
DROP VIEW IF EXISTS v_salary_transparency;
CREATE VIEW v_salary_transparency AS
SELECT
    city_clean,
    platform,
    experience_level,
    salary_disclosed,
    salary_currency,
    salary_value_monthly
FROM job_listings;

-- Example use of the view:
-- SELECT city_clean, COUNT(*) FROM v_salary_transparency
-- WHERE salary_disclosed = 'Yes' GROUP BY city_clean;
