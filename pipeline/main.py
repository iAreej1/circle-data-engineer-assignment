from pipeline.database import get_connection, get_engine
from pipeline.sql_runner import run_sql_folder
from pipeline.ingest import (
    discover_csv_files,
    get_table_name,
    read_csv,
    load_dataframe,
    validate_table,
)


def main():
    print("🚀 Starting Pipeline")

    conn = None

    try:
        # -----------------------------------
        # Connect to PostgreSQL
        # -----------------------------------
        conn = get_connection()
        engine = get_engine()

        print("✅ Connected to PostgreSQL!")

        # -----------------------------------
        # Create Raw Schema
        # -----------------------------------
        run_sql_folder(conn, "sql/raw")

        print("✅ Raw schema created successfully!\n")

        # -----------------------------------
        # Discover CSV files
        # -----------------------------------
        csv_files = discover_csv_files()

        print(f"📂 Found {len(csv_files)} CSV file(s)\n")

        # -----------------------------------
        # Load Raw Tables
        # -----------------------------------
        for csv_file in csv_files:

            table_name = get_table_name(csv_file)

            df = read_csv(csv_file)

            print(f"📥 Loading raw.{table_name}")
            print(f"   Source : {csv_file.name}")
            print(f"   Rows   : {len(df):,}")
            print(f"   Columns: {len(df.columns)}")

            load_dataframe(
                df,
                table_name,
                engine
            )

            validate_table(
                connection=conn,
                schema_name="raw",
                table_name=table_name
            )

            print()

        print("🎉 Raw data ingestion completed successfully!")

        # -----------------------------------
        # Build Staging Layer
        # -----------------------------------
        print("\n📦 Building Staging Layer\n")

        run_sql_folder(conn, "sql/staging")

        validate_table(
            connection=conn,
            schema_name="staging",
            table_name="stg_orders"
        )

        print("\n✅ Staging layer built successfully!")

    except Exception as e:
        print("\n❌ Pipeline Failed")
        print(e)

    finally:
        if conn:
            conn.close()
            print("\n🔌 Connection Closed")


if __name__ == "__main__":
    main()