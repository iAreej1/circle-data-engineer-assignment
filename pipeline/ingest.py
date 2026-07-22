from pathlib import Path


def discover_csv_files():
    """
    Discover all CSV files inside the data directory.
    Returns a sorted list of Path objects.
    """

    data_path = Path("data")

    csv_files = sorted(data_path.glob("*.csv"))

    return csv_files