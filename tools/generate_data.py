import pandas as pd
from faker import Faker
import random
import os

# Initialize Faker
fake = Faker()

# Configuration
NUM_ROWS = 2500
OUTPUT_DIR = "data/sample"

# Ensure output directory exists
os.makedirs(OUTPUT_DIR, exist_ok=True)

def generate_sales_data(num_rows):
    data = []
    for _ in range(num_rows):
        data.append({
            "order_id": fake.uuid4(),
            "order_date": fake.date_between(start_date='-2y', end_date='today'),
            "customer_id": fake.random_int(min=1000, max=9999),
            "amount": round(random.uniform(10.5, 500.5), 2),
            "currency": "USD",
            "channel": random.choice(["online", "store", "partner"])
        })
    return pd.DataFrame(data)

if __name__ == "__main__":
    # Generate data for two years
    sales_2024_df = generate_sales_data(NUM_ROWS)
    sales_2024_df['order_date'] = pd.to_datetime(sales_2024_df['order_date']).dt.strftime('%Y-%m-%d')
    sales_2024_df = sales_2024_df[pd.to_datetime(sales_2024_df['order_date']).dt.year == 2024]

    sales_2025_df = generate_sales_data(NUM_ROWS)
    sales_2025_df['order_date'] = pd.to_datetime(sales_2025_df['order_date']).dt.strftime('%Y-%m-%d')
    sales_2025_df = sales_2025_df[pd.to_datetime(sales_2025_df['order_date']).dt.year == 2025]

    # Define output paths
    csv_path_2024 = os.path.join(OUTPUT_DIR, "sales_2024.csv")
    parquet_path_2025 = os.path.join(OUTPUT_DIR, "sales_2025.parquet")

    # Save to files
    sales_2024_df.to_csv(csv_path_2024, index=False)
    sales_2025_df.to_parquet(parquet_path_2025, index=False)

    print(f"Generated {len(sales_2024_df)} records in {csv_path_2024}")
    print(f"Generated {len(sales_2025_df)} records in {parquet_path_2025}")
