from pipeline.database import get_connection
from pipeline.sql_runner import run_sql_file


def main():
    print("🚀 Starting Pipeline")

    try:
        # Connect to PostgreSQL
        conn = get_connection()
        print("✅ Connected to PostgreSQL!")

        # Create raw schema
        run_sql_file(
            conn,
            "sql/raw/01_create_schema.sql"
        )

        print("✅ Raw schema created successfully!")

        # Close connection
        conn.close()
        print("🔌 Connection Closed")

    except Exception as e:
        print(f"❌ Pipeline Failed: {e}")


if __name__ == "__main__":
    main()