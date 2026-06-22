import duckdb

con = duckdb.connect("airbnb.duckdb")
con.execute("CREATE SCHEMA IF NOT EXISTS raw")

print("Loading raw_listings...")
con.execute("""
    CREATE OR REPLACE TABLE raw.raw_listings AS
    SELECT * FROM read_csv_auto('https://dbt-datasets.s3.amazonaws.com/listings.csv')
""")

print("Loading raw_hosts...")
con.execute("""
    CREATE OR REPLACE TABLE raw.raw_hosts AS
    SELECT * FROM read_csv_auto('https://dbt-datasets.s3.amazonaws.com/hosts.csv')
""")

print("Loading raw_reviews...")
con.execute("""
    CREATE OR REPLACE TABLE raw.raw_reviews AS
    SELECT * FROM read_csv_auto('https://dbt-datasets.s3.amazonaws.com/reviews.csv')
""")

counts = con.execute("""
    SELECT 'raw_listings' AS tbl, COUNT(*) FROM raw.raw_listings
    UNION ALL
    SELECT 'raw_hosts',   COUNT(*) FROM raw.raw_hosts
    UNION ALL
    SELECT 'raw_reviews', COUNT(*) FROM raw.raw_reviews
""").fetchall()

print("\nDone!")
for tbl, cnt in counts:
    print(f"  {tbl}: {cnt:,} rows")

con.close()
