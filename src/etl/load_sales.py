import pandas as pd
import os

# Configuration
DATA_DIR = "data/sample"

def transform_data(df):
    """A simple transformation function."""
    # Convert currency (dummy example)
    df['amount_eur'] = df['amount'] * 0.93  # Assuming USD to EUR
    return df

def load_data_to_sql(df):
    """Placeholder function to simulate loading data to SQL.
    In a real scenario, this would use pyodbc or similar to connect to a database.
    """
    print("Simulating load to SQL...")
    print(df.head())
    print(f"Loaded {len(df)} records.")

if __name__ == "__main__":
    # Read the generated data
    csv_path = os.path.join(DATA_DIR, "sales_2024.csv")
    parquet_path = os.path.join(DATA_DIR, "sales_2025.parquet")

    if os.path.exists(csv_path):
        sales_2024_df = pd.read_csv(csv_path)
        transformed_2024 = transform_data(sales_2024_df.copy())
        load_data_to_sql(transformed_2024)
    else:
        print(f"File not found: {csv_path}")

    if os.path.exists(parquet_path):
        sales_2025_df = pd.read_parquet(parquet_path)
        transformed_2025 = transform_data(sales_2025_df.copy())
        load_data_to_sql(transformed_2025)
    else:
        print(f"File not found: {parquet_path}")
