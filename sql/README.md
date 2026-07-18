# SQL Analysis

This folder demonstrates the same analysis as the rest of the project, done in **SQL** — a relational schema, an indexed SQLite database, and 10 queries covering the techniques most commonly tested in SQL interviews: `GROUP BY`/`HAVING`, window functions (`RANK`, `ROW_NUMBER`, `SUM() OVER()`), CTEs, correlated and scalar subqueries, `CASE WHEN`, `UNION ALL`, and views.

## Files

| File | Purpose |
|---|---|
| `schema.sql` | Formal table definitions (`job_listings`, `national_labour_stats`) with types, constraints, and indexes |
| `create_database.py` | Loads the cleaned CSV into `job_market.db` following `schema.sql` |
| `queries.sql` | 10 annotated analytical queries, each tagged with the SQL technique it demonstrates |
| `query_outputs.md` | Actual results of every query, so they're readable without running anything |
| `job_market.db` | The SQLite database file itself — open directly with any SQLite client (e.g. DB Browser for SQLite, `sqlite3` CLI, or the free VS Code SQLite extension) |

## Run it yourself

```bash
cd sql
python create_database.py      # rebuilds job_market.db from the cleaned CSV
sqlite3 job_market.db < queries.sql
```

Or open `job_market.db` directly in [DB Browser for SQLite](https://sqlitebrowser.org/) (free, cross-platform GUI) and run queries interactively.

## What each query answers

1. City-wise listing distribution, ranked
2. Cities accounting for ≥5% of listings
3. Top 3 most recent listings per platform
4. Experience-level demand among listings that disclose it
5. Skill/keyword mention counts (Power BI, SQL, Python, etc.)
6. Salary transparency summary (disclosure rate, min/avg/max)
7. Platforms performing above the average listing volume
8. Top hiring sector within each major city
9. Sample metrics benchmarked against official PBS national statistics
10. A reusable view (`v_salary_transparency`) for downstream BI-tool consumption

Full annotated queries + real output: [`queries.sql`](./queries.sql) and [`query_outputs.md`](./query_outputs.md)
