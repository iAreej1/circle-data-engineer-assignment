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
    print("=" * 60)
    print("🚀 CIRCLE DATA ENGINEERING PIPELINE")
    print("=" * 60)

    try:
        # ---------------------------------------------------------
        # Connect to PostgreSQL
        # ---------------------------------------------------------
        connection = get_connection()
        engine = get_engine()

        print("✅ Connected to PostgreSQL!\n")

        # ---------------------------------------------------------
        # RAW LAYER
        # ---------------------------------------------------------
        print("=" * 60)
        print("📂 RAW LAYER")
        print("=" * 60)

        run_sql_folder(connection, "sql/raw")

        print("✅ Raw schema created successfully!\n")

        csv_files = discover_csv_files()

        print(f"📂 Found {len(csv_files)} CSV file(s)\n")

        for csv_file in csv_files:

            table_name = get_table_name(csv_file)

            df = read_csv(csv_file)

            print(f"📥 Loading raw.{table_name}")
            print(f"   Source : {csv_file.name}")
            print(f"   Rows   : {len(df):,}")
            print(f"   Columns: {len(df.columns)}")

            load_dataframe(df, table_name, engine)

            validate_table(connection, "raw", table_name)

            print()

        print("=" * 60)
        print("✅ RAW LAYER COMPLETED")
        print("=" * 60)

        # ---------------------------------------------------------
        # STAGING LAYER
        # ---------------------------------------------------------
        print("\n" + "=" * 60)
        print("📦 STAGING LAYER")
        print("=" * 60)

        run_sql_folder(connection, "sql/staging")

        staging_tables = [
            "stg_orders",
            "stg_customers",
            "stg_products",
            "stg_order_payments",
            "stg_order_items",
            "stg_order_reviews",
            "stg_product_category_translation",
            "stg_sellers",
            "stg_geolocation",
        ]

        print()

        for table in staging_tables:
            validate_table(connection, "staging", table)

        print()

        print("=" * 60)
        print("✅ STAGING LAYER COMPLETED")
        print("=" * 60)

        # ---------------------------------------------------------
        # Pipeline Finished
        # ---------------------------------------------------------
        print("\n" + "=" * 60)
        print("🎉 PIPELINE COMPLETED SUCCESSFULLY")
        print("=" * 60)

    except Exception as e:
        print("\n❌ Pipeline Failed")
        print(e)

    finally:
        try:
            connection.close()
            print("\n🔌 Connection Closed")
        except Exception:
            pass


if __name__ == "__main__":
    main()