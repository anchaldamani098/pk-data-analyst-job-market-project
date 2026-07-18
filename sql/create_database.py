"""
Loads the cleaned dataset into job_market.db following schema.sql.
Run: python create_database.py
"""
import sqlite3
import pandas as pd
from pathlib import Path

BASE = Path(__file__).parent
df = pd.read_csv(BASE.parent / "data" / "cleaned" / "cleaned_job_listings.csv")
macro = pd.read_csv(BASE.parent / "data" / "raw" / "pk_labour_force_macro_stats_2024_25.csv")

db_path = BASE / "job_market.db"
db_path.unlink(missing_ok=True)
conn = sqlite3.connect(db_path)
cur = conn.cursor()

with open(BASE / "schema.sql") as f:
    cur.executescript(f.read())

rows = df.rename(columns={
    "city": "city_raw",
    "employment_type": "employment_type_raw",
    "experience_required": "experience_required_raw",
    "salary_pkr_month": "salary_raw",
}).to_dict(orient="records")

cols = ["job_title","company","city_raw","city_clean","sector","employment_type_raw",
        "work_mode","contract_type","experience_required_raw","experience_level",
        "salary_raw","salary_disclosed","salary_currency","salary_value_monthly",
        "salary_note","platform","date_posted_or_seen","source_url","notes","search_text"]

cur.executemany(
    f"INSERT INTO job_listings ({','.join(cols)}) VALUES ({','.join(['?']*len(cols))})",
    [tuple(r.get(c) for c in cols) for r in rows]
)

macro.to_sql("national_labour_stats", conn, if_exists="append", index=False)

conn.commit()
n1 = cur.execute("SELECT COUNT(*) FROM job_listings").fetchone()[0]
n2 = cur.execute("SELECT COUNT(*) FROM national_labour_stats").fetchone()[0]
print(f"Loaded {n1} rows into job_listings, {n2} rows into national_labour_stats")
conn.close()
