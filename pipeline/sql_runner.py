import os


def run_sql_file(connection, file_path):
    """
    Execute a SQL file.
    """

    with open(file_path, "r", encoding="utf-8") as file:
        sql = file.read()

    cursor = connection.cursor()

    cursor.execute(sql)

    connection.commit()

    cursor.close()

    print(f"✅ Executed: {os.path.basename(file_path)}")