from pathlib import Path

import pandas as pd


def discover_csv_files():
    """
    Discover all CSV files inside the data directory.
    """

    data_path = Path("data")

    return sorted(data_path.glob("*.csv"))


def get_table_name(csv_file):
    """
    Convert CSV filename into a PostgreSQL table name.
    """

    table_name = csv_file.stem

    table_name = table_name.replace("olist_", "")

    table_name = table_name.replace("_dataset", "")

    return table_name


def read_csv(csv_file):
    """
    Read a CSV file into a pandas DataFrame.
    """

    df = pd.read_csv(csv_file)

    return df

def load_dataframe(df, table_name, engine):
    """
    Load a DataFrame into PostgreSQL.
    """

    df.to_sql(
        name=table_name,
        con=engine,
        schema="raw",
        if_exists="replace",
        index=False,
    )

    print(f"   ✅ Loaded {len(df):,} rows")

def validate_table(connection, schema_name, table_name):
    """
    Print the number of rows inside a PostgreSQL table.
    """

    cursor = connection.cursor()

    cursor.execute(
        f"SELECT COUNT(*) FROM {schema_name}.{table_name};"
    )

    rows = cursor.fetchone()[0]

    cursor.close()

    print(f"   ✅ {schema_name}.{table_name} contains {rows:,} rows")

    return rows