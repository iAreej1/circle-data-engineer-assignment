from pipeline.database import get_connection
from pipeline.sql_runner import run_sql_folder
from pipeline.ingest import discover_csv_files


def main():
    print("🚀 Starting Pipeline")

    try:
        conn = get_connection()

        print("✅ Connected to PostgreSQL!")

        # Create schemas
        run_sql_folder(conn, "sql/raw")

        print("✅ Raw schema created successfully!")

        # Discover CSV files
        csv_files = discover_csv_files()

        print(f"\n📂 Found {len(csv_files)} CSV file(s):\n")

        for file in csv_files:
            print(f"   • {file.name}")

        conn.close()

        print("\n🔌 Connection Closed")

    except Exception as e:
        print(f"❌ Error: {e}")


if __name__ == "__main__":
    main()