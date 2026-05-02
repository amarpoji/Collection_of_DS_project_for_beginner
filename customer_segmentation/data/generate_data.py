"""
Data Generator: Synthetic Customer Dataset for Segmentation

Generates a realistic customer dataset with 4 distinct segments:
  Segment 0: Young, low income, high spending  → "Spendthrift Youth"
  Segment 1: Middle-aged, high income, high spending → "Affluent Professionals"
  Segment 2: Senior, moderate income, low spending → "Prudent Seniors"
  Segment 3: Middle-aged, moderate income, moderate spending → "Balanced Families"
"""

import numpy as np
import pandas as pd
import os

np.random.seed(42)

n_per_segment = 100
total = n_per_segment * 4

# ── Segment centres (Age, Income, Spending) ──
centres = [
    (22, 30,  75),   # Spendthrift Youth
    (42, 80,  82),   # Affluent Professionals
    (60, 45,  28),   # Prudent Seniors
    (40, 55,  50),   # Balanced Families
]

segments_data = []
segment_names = []
for idx, (age_c, inc_c, spend_c) in enumerate(centres):
    ages   = np.random.normal(age_c,   5, n_per_segment).clip(18, 80)
    incomes = np.random.normal(inc_c,  10, n_per_segment).clip(10, 130)
    spends  = np.random.normal(spend_c, 8, n_per_segment).clip(1,  100)
    genders = np.random.choice(['Male', 'Female'], n_per_segment, p=[0.48, 0.52])

    for i in range(n_per_segment):
        segments_data.append({
            'CustomerID': idx * n_per_segment + i + 1,
            'Gender': genders[i],
            'Age': int(round(ages[i])),
            'AnnualIncome_k': round(incomes[i], 1),
            'SpendingScore': int(round(spends[i])),
        })
    segment_names.append(f'Segment_{idx}')

df = pd.DataFrame(segments_data)

# Save
data_dir = os.path.dirname(os.path.abspath(__file__))
path = os.path.join(data_dir, 'customer_data.csv')
df.to_csv(path, index=False)
print(f"✅ Dataset saved → {path}")
print(f"   Shape: {df.shape}")
print(f"   Features: {list(df.columns)}")
print(f"   Segments generated: {n_per_segment} × {len(centres)} = {total} customers")
print(df.describe())
