from pipeline.database import get_connection, get_engine
from pipeline.sql_runner import run_sql_folder
from pipeline.ingest import (
    discover_csv_files,
    get_table_name,
    read_csv,
    load_dataframe,
    validate_load,
)


def main():
    print("🚀 Starting Pipeline")

    try:
        # Connect to PostgreSQL
        conn = get_connection()
        engine = get_engine()

        print("✅ Connected to PostgreSQL!")

        # Execute SQL scripts
        run_sql_folder(conn, "sql/raw")
        print("✅ Raw schema created successfully!")

        # Discover CSV files
        csv_files = discover_csv_files()

        print(f"\n📂 Found {len(csv_files)} CSV file(s)\n")

        # Load each CSV into PostgreSQL
        for csv_file in csv_files:

            table_name = get_table_name(csv_file)

            df = read_csv(csv_file)

            print(f"📥 Loading raw.{table_name}")
            print(f"   Source : {csv_file.name}")
            print(f"   Rows   : {len(df):,}")
            print(f"   Columns: {len(df.columns)}")

            # Load data into PostgreSQL
            load_dataframe(df, table_name, engine)

            # Validate row count
            validate_load(
                connection=conn,
                table_name=table_name,
                expected_rows=len(df)
            )

            print()

        # Close PostgreSQL connection
        conn.close()

        print("🎉 Raw data ingestion completed successfully!")
        print("🔌 Connection Closed")

    except Exception as e:
        print(f"❌ Pipeline Failed: {e}")


if __name__ == "__main__":
    main()