from pathlib import Path


def run_sql_file(connection, file_path):
    """
    Execute a single SQL file.
    """

    with open(file_path, "r", encoding="utf-8") as file:
        sql = file.read()

    cursor = connection.cursor()

    cursor.execute(sql)

    connection.commit()

    cursor.close()

    print(f"✅ Executed: {Path(file_path).name}")


def run_sql_folder(connection, folder_path):
    """
    Execute every SQL file inside a folder in sorted order.
    """

    sql_files = sorted(Path(folder_path).glob("*.sql"))

    for sql_file in sql_files:
        run_sql_file(connection, sql_file)