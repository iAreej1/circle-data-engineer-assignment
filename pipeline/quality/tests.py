from pathlib import Path


def format_test_name(file_name):
    """
    Convert file name into a readable test name.

    Example:
    FAIL_01_orders_primary_key
        -> Orders Primary Key

    WARN_04_products_missing_attributes
        -> Products Missing Attributes
    """

    name = file_name.replace("FAIL_", "").replace("WARN_", "")

    parts = name.split("_", 1)

    if len(parts) == 2 and parts[0].isdigit():
        name = parts[1]

    return name.replace("_", " ").title()


def run_all_tests(connection):

    print("\n" + "=" * 60)
    print("🧪 DATA QUALITY TESTS")
    print("=" * 60)

    quality_folder = Path("sql/quality")

    sql_files = sorted(quality_folder.glob("*.sql"))

    if not sql_files:
        print("⚠ No quality tests found.")
        return

    cursor = connection.cursor()

    for sql_file in sql_files:

        with open(sql_file, "r", encoding="utf-8") as f:
            sql = f.read()

        cursor.execute(sql)

        failed_records = cursor.fetchone()[0]

        file_name = sql_file.stem
        display_name = format_test_name(file_name)

        # -----------------------------
        # FAIL TESTS
        # -----------------------------
        if file_name.startswith("FAIL_"):

            if failed_records == 0:

                print(f"✅ {display_name}")

            else:

                raise Exception(
                    f"{display_name} FAILED ({failed_records} invalid record(s))"
                )

        # -----------------------------
        # WARNING TESTS
        # -----------------------------
        elif file_name.startswith("WARN_"):

            if failed_records == 0:

                print(f"✅ {display_name}")

            else:

                print(
                    f"⚠ {display_name} ({failed_records} record(s) found)"
                )

        else:

            print(f"ℹ Skipping {file_name}")

    cursor.close()

    print("\n" + "=" * 60)
    print("✅ DATA QUALITY CHECKS COMPLETED")
    print("=" * 60)