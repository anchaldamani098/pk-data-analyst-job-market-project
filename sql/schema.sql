-- ============================================================
-- Pakistan Data Analyst Job Market — Database Schema
-- Engine: SQLite (portable; same schema works on PostgreSQL/MySQL
-- with minor type adjustments noted below)
-- ============================================================

DROP TABLE IF EXISTS job_listings;
DROP TABLE IF EXISTS national_labour_stats;

-- ------------------------------------------------------------
-- job_listings: one row per verified job posting
-- ------------------------------------------------------------
CREATE TABLE job_listings (
    listing_id            INTEGER PRIMARY KEY AUTOINCREMENT,
    job_title             TEXT NOT NULL,
    company               TEXT,                      -- 'Confidential' where the source listing withheld it
    city_raw              TEXT,                       -- original, uncleaned city string
    city_clean            TEXT,                       -- normalized city (see /data cleaning step)
    sector                TEXT,
    employment_type_raw   TEXT,                       -- original messy employment_type string
    work_mode             TEXT,                       -- Remote / Onsite / Hybrid / Not disclosed
    contract_type         TEXT,                       -- Full-time / Internship / Trainee / Contract / Not disclosed
    experience_required_raw TEXT,
    experience_level      TEXT,                       -- Entry/Fresh / Mid / Senior / Not disclosed
    salary_raw            TEXT,                       -- original salary_pkr_month string
    salary_disclosed      TEXT CHECK (salary_disclosed IN ('Yes','No')),
    salary_currency       TEXT,                       -- PKR / USD / NULL
    salary_value_monthly  REAL,                       -- NULL unless a genuine monthly figure could be parsed
    salary_note           TEXT,
    platform               TEXT NOT NULL,             -- source job platform
    date_posted_or_seen   TEXT,                        -- ISO date/month string
    source_url            TEXT NOT NULL,               -- verification link — every row must have one
    notes                 TEXT,
    search_text            TEXT                        -- lowercased title+notes+sector, used for skill-keyword search
);

-- ------------------------------------------------------------
-- national_labour_stats: official PBS macro indicators, used
-- for benchmarking the sample against the national picture
-- ------------------------------------------------------------
CREATE TABLE national_labour_stats (
    indicator   TEXT PRIMARY KEY,
    value       REAL NOT NULL,
    unit        TEXT,
    period      TEXT,
    source      TEXT
);

-- Indexes to support the common filter/aggregation patterns
-- used in queries.sql
CREATE INDEX idx_job_listings_city   ON job_listings(city_clean);
CREATE INDEX idx_job_listings_plat   ON job_listings(platform);
CREATE INDEX idx_job_listings_exp    ON job_listings(experience_level);
CREATE INDEX idx_job_listings_salary ON job_listings(salary_disclosed);
