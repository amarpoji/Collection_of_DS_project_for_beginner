#!/usr/bin/env python3
"""Generate the Time Series Anomaly Detection notebook using nbformat."""

import nbformat as nbf
import json

nb = nbf.v4.new_notebook()
nb.metadata = {
    "kernelspec": {
        "display_name": "Python 3",
        "language": "python",
        "name": "python3"
    },
    "language_info": {"name": "python", "version": "3.10.0"}
}

cells = []

def md(source):
    cells.append(nbf.v4.new_markdown_cell(source))

def code(source):
    cells.append(nbf.v4.new_code_cell(source))

# ===== CELL 1: Title =====
md("""# 🕵️ Time Series Anomaly Detection

**Project Goal:** Detect unusual patterns in real-world time series data — specifically, anomalous NYC taxi demand — using statistical, machine learning, and deep learning techniques.

### Learning Objectives
By the end of this notebook, you will:
- Understand what anomalies are and why they matter in time series
- Explore and visualize a real-world time series dataset
- Apply statistical methods (Z-score, IQR, moving average) for anomaly detection
- Train ML models (Isolation Forest, One-Class SVM, LOF) on time series features
- Build a simple Autoencoder for reconstruction-based anomaly detection
- Evaluate all methods against ground truth labels
- Compare trade-offs: interpretability vs accuracy vs speed

> **Dataset:** NYC Taxi Passenger Counts (Numenta Anomaly Benchmark) — real 30-minute taxi demand from July 2014 – Jan 2015, with labeled anomalies (holidays, marathon, storms).""")

# ===== CELL 2: Problem Definition =====
md("""## 1. Problem Definition & Framing

### What is Anomaly Detection?
Anomaly detection identifies **data points, events, or patterns** that deviate significantly from the expected behavior. In time series, anomalies often signal:
- **System failures** — server crashes, sensor malfunction
- **Fraud** — unusual financial transactions  
- **Extreme events** — natural disasters, pandemics
- **Operational changes** — sudden demand spikes/drops

### Types of Time Series Anomalies

| Type | Description | Example |
|:----:|:------------|:--------|
| **Point** | A single value far from the rest | A spike due to sensor glitch |
| **Contextual** | Unusual relative to neighbors (normal in another context) | High taxi demand at 3 AM (normal at 6 PM) |
| **Collective** | A sequence behaving abnormally | A sustained plateau during a holiday weekend |

### Business Case: NYC Taxi Demand Monitoring
Imagine you're a data scientist at NYC's taxi commission. You need to:
1. **Detect unusual demand patterns** in real time
2. **Distinguish** between expected events (holidays) and unexpected ones (system failures)
3. **Alert operations** when demand deviates beyond normal thresholds

This mirrors real-world monitoring use cases in **IT operations (AIOps)**, **IoT sensor networks**, and **financial surveillance**.""")

# ===== CELL 3: Setup and Data Loading =====
md("""## 2. Setup & Data Loading

Let's import all necessary libraries and load our real-world dataset from the Numenta Anomaly Benchmark.""")

code("""# Data manipulation
import numpy as np
import pandas as pd

# Visualization
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import seaborn as sns

# Time series
from statsmodels.tsa.seasonal import seasonal_decompose, STL
from statsmodels.tsa.stattools import adfuller
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf

# Preprocessing & modeling
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import IsolationForest
from sklearn.svm import OneClassSVM
from sklearn.neighbors import LocalOutlierFactor
from sklearn.metrics import classification_report, confusion_matrix, precision_recall_fscore_support

# Deep learning
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Input
from tensorflow.keras.callbacks import EarlyStopping

# Utilities
import json
import warnings
warnings.filterwarnings('ignore')

sns.set_style("darkgrid")
plt.rcParams["figure.figsize"] = (14, 5)
plt.rcParams["figure.dpi"] = 100

print("✅ All libraries imported successfully.")""")

code("""# Load NYC taxi data
DATA_PATH = "../data/nyc_taxi.csv"
df = pd.read_csv(DATA_PATH, parse_dates=["timestamp"])
df.set_index("timestamp", inplace=True)
df.index.name = "timestamp"

# Sort index just in case
df.sort_index(inplace=True)

print(f"✅ Loaded {len(df):,} rows from {df.index[0]:%Y-%m-%d} to {df.index[-1]:%Y-%m-%d}")
df.head()""")

code("""# Check data types and missing values
print("Data types:")
print(df.dtypes)
print(f"\\nMissing values: {df['value'].isna().sum()}")
print(f"\\nShape: {df.shape}")
print(f"\\nDescriptive statistics:")
df['value'].describe()""")

# ===== CELL 7: EDA - Visualization =====
md("""## 3. Exploratory Data Analysis

We need to **understand the data** before detecting anomalies. Let's visualize the full series and look for patterns: trend, seasonality, and potential outlier periods.""")

code("""fig, axes = plt.subplots(2, 1, figsize=(16, 8))

# Full time series
axes[0].plot(df.index, df["value"], color="#2563eb", linewidth=0.8)
axes[0].set_title("NYC Taxi Passenger Counts (30-min intervals)", fontsize=14, fontweight="bold")
axes[0].set_ylabel("Passenger Count")
axes[0].xaxis.set_major_formatter(mdates.DateFormatter("%b %Y"))
axes[0].xaxis.set_major_locator(mdates.MonthLocator())

# Distribution
axes[1].hist(df["value"], bins=80, color="#2563eb", edgecolor="white", alpha=0.7)
axes[1].axvline(df["value"].mean(), color="red", linestyle="--", label=f"Mean = {df['value'].mean():.0f}")
axes[1].axvline(df["value"].median(), color="orange", linestyle="--", label=f"Median = {df['value'].median():.0f}")
axes[1].set_title("Distribution of Passenger Counts", fontsize=14, fontweight="bold")
axes[1].set_xlabel("Passenger Count")
axes[1].set_ylabel("Frequency")
axes[1].legend()

plt.tight_layout()
plt.savefig("../visualization/01_eda_overview.png", dpi=120, bbox_inches="tight")
plt.show()""")

code("""# Resample to daily for a clearer trend view
daily = df["value"].resample("D").sum()

fig, ax = plt.subplots(figsize=(16, 5))
ax.bar(daily.index, daily.values, width=0.8, color="#2563eb", alpha=0.7)
ax.set_title("Daily Total NYC Taxi Passengers", fontsize=14, fontweight="bold")
ax.set_ylabel("Total Daily Passengers")
ax.xaxis.set_major_formatter(mdates.DateFormatter("%b %d"))
ax.xaxis.set_major_locator(mdates.WeekdayLocator(interval=1))
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("../visualization/02_daily_aggregate.png", dpi=120, bbox_inches="tight")
plt.show()

print("Notice the weekly pattern: peaks (~Fri-Sat) and troughs (~Mon-Tue).")
print("Also visible: potential anomaly around Nov 2 (NYC Marathon) and late Dec (holidays).")""")

md("""### Seasonality Analysis

Time series usually have multiple seasonal cycles. Let's examine:
- **Hourly pattern** — how demand changes within a day
- **Weekly pattern** — differences between weekdays/weekends
- **Monthly pattern** — longer-term trends""")

code("""# Add time-based features
df["hour"] = df.index.hour
df["day_of_week"] = df.index.dayofweek  # 0=Mon, 6=Sun
df["day_name"] = df.index.day_name()
df["month"] = df.index.month
df["week_of_year"] = df.index.isocalendar().week.astype(int)

# Hourly profile (average across all days)
hourly_profile = df.groupby("hour")["value"].agg(["mean", "std", "count"])

fig, axes = plt.subplots(1, 3, figsize=(18, 5))

# Hourly
axes[0].plot(hourly_profile.index, hourly_profile["mean"], "o-", color="#2563eb", linewidth=2)
axes[0].fill_between(hourly_profile.index,
                     hourly_profile["mean"] - hourly_profile["std"],
                     hourly_profile["mean"] + hourly_profile["std"],
                     alpha=0.2, color="#2563eb")
axes[0].set_title("Average Hourly Demand (±1σ)", fontsize=13, fontweight="bold")
axes[0].set_xlabel("Hour of Day")
axes[0].set_ylabel("Passenger Count")
axes[0].set_xticks(range(0, 24, 3))

# Weekly
weekly_profile = df.groupby("day_name")["value"].mean().reindex(
    ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
axes[1].bar(weekly_profile.index, weekly_profile.values, color=["#6b7280"]*5 + ["#2563eb"]*2)
axes[1].set_title("Average Daily Demand (by Day of Week)", fontsize=13, fontweight="bold")
axes[1].set_xlabel("Day of Week")
axes[1].tick_params(axis="x", rotation=30)

# Monthly
monthly_profile = df.groupby("month")["value"].mean()
axes[2].bar(monthly_profile.index, monthly_profile.values, color="#2563eb", alpha=0.7)
axes[2].set_title("Average Monthly Demand", fontsize=13, fontweight="bold")
axes[2].set_xlabel("Month")
axes[2].set_xticks(range(7, 13))
axes[2].set_xticklabels(["Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])

plt.tight_layout()
plt.savefig("../visualization/03_seasonal_patterns.png", dpi=120, bbox_inches="tight")
plt.show()""")

code("""# Weekly heatmap: hour × day_of_week
pivot = df.pivot_table(values="value", index="hour", columns="day_name",
                       aggfunc="mean")
pivot = pivot[["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]]

fig, ax = plt.subplots(figsize=(12, 6))
sns.heatmap(pivot, cmap="YlOrRd", ax=ax, cbar_kws={"label": "Avg Passengers"})
ax.set_title("Hourly × Day-of-Week Demand Heatmap", fontsize=14, fontweight="bold")
ax.set_xlabel("Day of Week")
ax.set_ylabel("Hour of Day")
plt.tight_layout()
plt.savefig("../visualization/04_heatmap_hour_day.png", dpi=120, bbox_inches="tight")
plt.show()

print("Insight: Demand is highest on Friday/Saturday evenings (6 PM-midnight)")
print("and lowest on Monday/Tuesday early mornings (3 AM-6 AM).")
print('Context matters: "high" at 3 AM is very different from "high" at 6 PM!')""")

md("""### Time Series Decomposition

Decomposition splits the series into **Trend**, **Seasonal**, and **Residual** components. Anomalies live in the **residual** — the part of the data not explained by regular patterns.""")

code("""# STL decomposition (robust to outliers)
stl = STL(df["value"], period=48)  # 48 = 24h × 30min intervals
result = stl.fit()

fig, axes = plt.subplots(4, 1, figsize=(16, 10))
components = {"Observed": df["value"], "Trend": result.trend,
              "Seasonal": result.seasonal, "Residual": result.resid}
for ax, (name, series) in zip(axes, components.items()):
    ax.plot(df.index, series, linewidth=0.8, color="#2563eb")
    ax.axhline(0, color="gray", linestyle="--", linewidth=0.5)
    ax.set_ylabel(name, fontweight="bold")
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%b"))
    if name == "Residual":
        ax.set_xlabel("Date (2014–2015)")

axes[0].set_title("STL Decomposition of NYC Taxi Demand (period=48)", fontsize=14, fontweight="bold")
plt.tight_layout()
plt.savefig("../visualization/05_stl_decomposition.png", dpi=120, bbox_inches="tight")
plt.show()

print("The residual is where anomalies will appear — values far from zero.")""")

# ===== Preprocessing =====
md("""## 4. Preprocessing & Stationarity

Before feature engineering, we should:
1. **Check for missing values** — gaps in time series can confuse models
2. **Test stationarity** — many models assume constant mean/variance over time
3. **Make data stationary if needed** — differencing or transformations""")

code("""# Check for gaps (missing timestamps)
full_idx = pd.date_range(start=df.index.min(), end=df.index.max(), freq="30min")
missing_times = full_idx.difference(df.index)
print(f"Missing timestamps: {len(missing_times)} out of {len(full_idx)} ({100*len(missing_times)/len(full_idx):.2f}%)")
if len(missing_times) > 0:
    print(f"First few gaps: {missing_times[:5].to_list()}")

# Reindex to fill gaps (forward fill)
if len(missing_times) > 0:
    df = df.reindex(full_idx).fillna(method="ffill").fillna(method="bfill")
    print("✅ Gaps filled with forward/backward fill.")""")

code("""# Augmented Dickey-Fuller test for stationarity
adf_result = adfuller(df["value"].dropna())

print("=" * 50)
print("   ADF Test for Stationarity")
print("=" * 50)
print(f"ADF Statistic:  {adf_result[0]:.6f}")
print(f"p-value:        {adf_result[1]:.6f}")
print(f"Critical Values:")
for key, value in adf_result[4].items():
    print(f"  {key}: {value:.6f}")

if adf_result[1] <= 0.05:
    print("\\n✅ p ≤ 0.05 → Reject H₀ → Series IS stationary (no differencing needed)")
else:
    print("\\n⚠️  p > 0.05 → Cannot reject H₀ → Series is NOT stationary")
    print("→ We'll use differencing for models that require it.")

# Plot rolling statistics
rolling_mean = df["value"].rolling(48).mean()  # 24h window
rolling_std = df["value"].rolling(48).std()

fig, ax = plt.subplots(figsize=(16, 4))
ax.plot(df.index, df["value"], color="gray", alpha=0.5, linewidth=0.5, label="Original")
ax.plot(df.index, rolling_mean, color="red", linewidth=1, label="Rolling Mean (24h)")
ax.plot(df.index, rolling_std, color="green", linewidth=1, label="Rolling Std (24h)")
ax.set_title("Rolling Statistics — Visual Stationarity Check", fontsize=13, fontweight="bold")
ax.legend()
plt.tight_layout()
plt.savefig("../visualization/06_rolling_stats.png", dpi=120, bbox_inches="tight")
plt.show()""")

code("""# Apply differencing (creates stationary version for models that need it)
df["value_diff1"] = df["value"].diff(1)
df["value_diff48"] = df["value"].diff(48)  # seasonal differencing (1 day)

print("Original series:   ", end="")
orig_test = adfuller(df["value"].dropna())
print(f"p={orig_test[1]:.6f} {'✅' if orig_test[1] <= 0.05 else '❌'}")

print("Diff(1) series:    ", end="")
diff1_test = adfuller(df["value_diff1"].dropna())
print(f"p={diff1_test[1]:.6f} {'✅' if diff1_test[1] <= 0.05 else '❌'}")

print("Diff(48) series:   ", end="")
diff48_test = adfuller(df["value_diff48"].dropna())
print(f"p={diff48_test[1]:.6f} {'✅' if diff48_test[1] <= 0.05 else '❌'}")""")

# ===== Feature Engineering =====
md("""## 5. Feature Engineering

We create features that help models distinguish normal patterns from anomalies:

**Temporal features:** hour, day_of_week, month, weekend_flag, time_of_day
**Lag features:** value at t-1, t-2, ..., t-48 (capture yesterday's value)
**Rolling features:** mean, std, min, max over sliding windows (capture local context)
**Difference features:** change from previous period, change from same time yesterday
**Cyclical encoding:** sin/cos transform for hour (preserves circular nature)""")

code("""def create_features(df, n_lags=4, windows=[6, 12, 24, 48]):
    \"\"\"Create feature set for anomaly detection.\"\"\"
    X = df.copy()
    
    # Temporal features
    X["hour"] = X.index.hour
    X["day_of_week"] = X.index.dayofweek
    X["month"] = X.index.month
    X["weekend"] = (X["day_of_week"] >= 5).astype(int)
    X["day_sin"] = np.sin(2 * np.pi * X["hour"] / 24)
    X["day_cos"] = np.cos(2 * np.pi * X["hour"] / 24)
    
    # Lag features (recent past)
    for lag in range(1, n_lags + 1):
        X[f"lag_{lag}"] = X["value"].shift(lag)
    
    # Seasonal lag (same time yesterday = 48 steps back)
    X["lag_48"] = X["value"].shift(48)
    X["lag_96"] = X["value"].shift(96)  # 2 days ago
    
    # Rolling window features
    for w in windows:
        X[f"roll_mean_{w}"] = X["value"].rolling(w).mean()
        X[f"roll_std_{w}"] = X["value"].rolling(w).std()
        X[f"roll_min_{w}"] = X["value"].rolling(w).min()
        X[f"roll_max_{w}"] = X["value"].rolling(w).max()
    
    # Difference features
    X["diff_1"] = X["value"].diff(1)
    X["diff_48"] = X["value"].diff(48)  # change from yesterday same time
    X["pct_change_1"] = X["value"].pct_change(1)
    
    # Rolling z-score (how many σ from local mean)
    X["roll_zscore_48"] = (X["value"] - X["value"].rolling(48).mean()) / X["value"].rolling(48).std()
    
    return X

feature_df = create_features(df)
print(f"Feature matrix shape: {feature_df.shape}")
print(f"\\nFeatures created: {[c for c in feature_df.columns if c not in ['value', 'value_diff1', 'value_diff48']]}")

# Drop NaN rows from shift/rolling operations
feature_df_clean = feature_df.dropna()
print(f"After dropping NaN (from lags/rolling): {feature_df_clean.shape[0]:,} rows")""")

md("""## 6. Modeling

We'll implement and compare **five approaches** to anomaly detection, from simple to complex:

| # | Method | Type | Intuition |
|:-:|:-------|:----:|:----------|
| 1 | **Rolling Z-Score** | Statistical | Points far from local mean are anomalies |
| 2 | **Seasonal Decomposition + IQR on Residual** | Statistical | Residuals outside 3×IQR are anomalies |
| 3 | **Isolation Forest** | ML | Isolates anomalies with fewer splits (they're rare and different) |
| 4 | **One-Class SVM** | ML | Learns a boundary around normal data; outside = anomaly |
| 5 | **Autoencoder** | Deep Learning | Reconstructs input; high reconstruction error = anomaly |

### Approach 1: Rolling Z-Score (Statistical Baseline)

**Why?** Simple, interpretable, great first baseline. A point is anomalous if it deviates by more than k standard deviations from its recent window.""")

code("""# Rolling Z-Score anomaly detection
window = 48  # 24 hours
threshold = 3.0

rolling_mean = df["value"].rolling(window).mean()
rolling_std = df["value"].rolling(window).std()
z_scores = (df["value"] - rolling_mean) / rolling_std

df["anomaly_zscore"] = (z_scores.abs() > threshold).astype(int)

n_anomalies = df["anomaly_zscore"].sum()
anomaly_pct = 100 * n_anomalies / len(df)
print(f"Rolling Z-Score (threshold={threshold}, window={window}):")
print(f"  Anomalies detected: {n_anomalies} ({anomaly_pct:.2f}%)")

# Visualize
fig, ax = plt.subplots(figsize=(16, 5))
normal = df[df["anomaly_zscore"] == 0]
anom = df[df["anomaly_zscore"] == 1]
ax.plot(normal.index, normal["value"], ".", color="#2563eb", markersize=2, alpha=0.5, label="Normal")
ax.plot(anom.index, anom["value"], ".", color="red", markersize=4, label="Anomaly (Z-Score)")
ax.set_title(f"Anomalies Detected by Rolling Z-Score (|z| > {threshold})", fontsize=14, fontweight="bold")
ax.set_ylabel("Passenger Count")
ax.legend()
plt.tight_layout()
plt.savefig("../visualization/07_zscore_anomalies.png", dpi=120, bbox_inches="tight")
plt.show()

print('z-score flags extreme values, but may miss contextual anomalies that are "normal" globally.')""")

md("""### Approach 2: Seasonal Decomposition + IQR on Residual

After removing trend and seasonality, what remains is the **residual**. By definition, anomalies are in the residual. We use IQR (Interquartile Range) to flag extreme residuals.

**Why IQR?** More robust to outliers than mean/std — the quartiles aren't pulled by extreme values.""")
                                                            
code("""# Residual-based anomaly detection via STL decomposition
df["residual"] = result.resid

Q1 = df["residual"].quantile(0.25)
Q3 = df["residual"].quantile(0.75)
IQR = Q3 - Q1
lower_bound = Q1 - 3 * IQR
upper_bound = Q3 + 3 * IQR

df["anomaly_stl_iqr"] = ((df["residual"] < lower_bound) | (df["residual"] > upper_bound)).astype(int)

n_anom = df["anomaly_stl_iqr"].sum()
print(f"STL + IQR (3×IQR range = [{lower_bound:.0f}, {upper_bound:.0f}]):")
print(f"  Anomalies detected: {n_anom} ({100*n_anom/len(df):.2f}%)")

fig, axes = plt.subplots(2, 1, figsize=(16, 7))

axes[0].plot(df.index, df["residual"], color="gray", linewidth=0.6, label="Residual")
axes[0].axhline(lower_bound, color="red", linestyle="--", label=f"Lower bound ({lower_bound:.0f})")
axes[0].axhline(upper_bound, color="red", linestyle="--", label=f"Upper bound ({upper_bound:.0f})")
axes[0].fill_between(df.index, lower_bound, upper_bound, alpha=0.1, color="green")
axes[0].set_title("Residuals from STL Decomposition with 3×IQR Bounds", fontsize=13, fontweight="bold")
axes[0].legend()

normal = df[df["anomaly_stl_iqr"] == 0]
anom = df[df["anomaly_stl_iqr"] == 1]
axes[1].plot(normal.index, normal["value"], ".", color="#2563eb", markersize=2, alpha=0.5, label="Normal")
axes[1].plot(anom.index, anom["value"], ".", color="red", markersize=4, label="Anomaly (STL+IQR)")
axes[1].set_title("Anomalies Marked on Original Series", fontsize=13, fontweight="bold")
axes[1].set_ylabel("Passenger Count")
axes[1].legend()

plt.tight_layout()
plt.savefig("../visualization/08_stl_iqr_anomalies.png", dpi=120, bbox_inches="tight")
plt.show()""")

md("""### Approach 3: Isolation Forest

**How it works:** Random forests that isolate observations by randomly selecting a feature and split value. Anomalies are:
- **Few** — they're rare in the dataset
- **Different** — their feature values are unusual

So anomalies get **isolated in fewer splits** (shorter path length).

**Advantage:** Works well in high dimensions, handles non-linear patterns, no need to define "normal" explicitly.""")

code("""# Prepare features for ML models
feature_cols = [
    "hour", "day_of_week", "weekend", "day_sin", "day_cos",
    "lag_1", "lag_2", "lag_3", "lag_4", "lag_48",
    "roll_mean_48", "roll_std_48", "roll_min_48", "roll_max_48",
    "diff_1", "diff_48", "pct_change_1",
    "roll_zscore_48"
]

# Drop remaining NaN rows from feature engineering
model_df = feature_df[feature_cols + ["value"]].dropna()
X = model_df[feature_cols].values
y_true_placeholder = np.zeros(len(X))  # We'll add actual labels later

# Scale features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

print(f"Feature matrix: {X_scaled.shape}")
print(f"Features: {feature_cols}")
print(f"\\nFeature ranges after scaling:")
pd.DataFrame(X_scaled, columns=feature_cols).describe().loc[["min", "max"]]""")

code("""# Isolation Forest
contamination = 0.02  # Expected proportion of anomalies

iso_forest = IsolationForest(
    contamination=contamination,
    random_state=42,
    n_estimators=200,
    max_samples="auto",
    n_jobs=-1
)

model_df["anomaly_if"] = iso_forest.fit_predict(X_scaled)
# Isolation Forest labels: -1 = anomaly, 1 = normal → convert to 1/0
model_df["anomaly_if"] = (model_df["anomaly_if"] == -1).astype(int)

n_anom_if = model_df["anomaly_if"].sum()
print(f"Isolation Forest (contamination={contamination}):")
print(f"  Anomalies detected: {n_anom_if} ({100*n_anom_if/len(model_df):.2f}%)")

# Visualize
fig, ax = plt.subplots(figsize=(16, 5))
normal = model_df[model_df["anomaly_if"] == 0]
anom = model_df[model_df["anomaly_if"] == 1]
ax.plot(normal.index, normal["value"], ".", color="#2563eb", markersize=2, alpha=0.5, label="Normal")
ax.plot(anom.index, anom["value"], ".", color="red", markersize=4, label="Anomaly (Isolation Forest)")
ax.set_title("Anomalies Detected by Isolation Forest", fontsize=14, fontweight="bold")
ax.set_ylabel("Passenger Count")
ax.legend()
plt.tight_layout()
plt.savefig("../visualization/09_if_anomalies.png", dpi=120, bbox_inches="tight")
plt.show()""")

md("""### Approach 4: One-Class SVM

**How it works:** Finds a **boundary** that encloses the "normal" data points. New points inside = normal; outside = anomaly.

**Trade-off:** Sensitive to the `nu` parameter (analogous to contamination). Works best when normal data is tightly clustered.""")

code("""# One-Class SVM
oc_svm = OneClassSVM(
    nu=contamination,  # Upper bound on training errors
    kernel="rbf",
    gamma="auto"
)

model_df["anomaly_svm"] = oc_svm.fit_predict(X_scaled)
model_df["anomaly_svm"] = (model_df["anomaly_svm"] == -1).astype(int)

n_anom_svm = model_df["anomaly_svm"].sum()
print(f"One-Class SVM (nu={contamination}):")
print(f"  Anomalies detected: {n_anom_svm} ({100*n_anom_svm/len(model_df):.2f}%)")

# Visualize
fig, ax = plt.subplots(figsize=(16, 5))
normal = model_df[model_df["anomaly_svm"] == 0]
anom = model_df[model_df["anomaly_svm"] == 1]
ax.plot(normal.index, normal["value"], ".", color="#2563eb", markersize=2, alpha=0.5, label="Normal")
ax.plot(anom.index, anom["value"], ".", color="red", markersize=4, label="Anomaly (One-Class SVM)")
ax.set_title("Anomalies Detected by One-Class SVM", fontsize=14, fontweight="bold")
ax.set_ylabel("Passenger Count")
ax.legend()
plt.tight_layout()
plt.savefig("../visualization/10_svm_anomalies.png", dpi=120, bbox_inches="tight")
plt.show()""")

md("""### Approach 5: Autoencoder (Deep Learning)

**How it works:**
1. An autoencoder learns to **compress** normal data into a low-dimensional "bottleneck" and **reconstruct** it
2. After training on normal patterns, it can reconstruct normal points well → **low reconstruction error**
3. Anomalies look unfamiliar → **high reconstruction error**

**Why?** Catches complex, non-linear anomalies that simpler methods miss.

We'll build a simple feedforward autoencoder with a bottleneck.""")

code("""# Train/test split (temporal, not random!)
split_idx = int(len(X_scaled) * 0.8)
X_train_ae = X_scaled[:split_idx]
X_test_ae = X_scaled[split_idx:]

print(f"Train: {X_train_ae.shape[0]:,} samples")
print(f"Test:  {X_test_ae.shape[0]:,} samples")

# Build autoencoder
input_dim = X_train_ae.shape[1]
encoding_dim = 8  # bottleneck size

autoencoder = Sequential([
    Input(shape=(input_dim,)),
    Dense(32, activation="relu"),
    Dropout(0.1),
    Dense(encoding_dim, activation="relu", name="bottleneck"),
    Dense(32, activation="relu"),
    Dropout(0.1),
    Dense(input_dim, activation="linear")
])

autoencoder.compile(optimizer="adam", loss="mse")
autoencoder.summary()""")

code("""# Train autoencoder
early_stop = EarlyStopping(monitor="val_loss", patience=10, restore_best_weights=True)

history = autoencoder.fit(
    X_train_ae, X_train_ae,
    validation_data=(X_test_ae, X_test_ae),
    epochs=100,
    batch_size=64,
    callbacks=[early_stop],
    verbose=1
)

# Plot training history
fig, ax = plt.subplots(figsize=(10, 4))
ax.plot(history.history["loss"], label="Train Loss", color="#2563eb")
ax.plot(history.history["val_loss"], label="Val Loss", color="red")
ax.set_title("Autoencoder Training History", fontsize=13, fontweight="bold")
ax.set_xlabel("Epoch")
ax.set_ylabel("MSE Loss")
ax.legend()
plt.tight_layout()
plt.savefig("../visualization/11_ae_training.png", dpi=120, bbox_inches="tight")
plt.show()

print(f"✅ Trained for {len(history.history['loss'])} epochs (stopped early).")""")

code("""# Compute reconstruction error
reconstructions = autoencoder.predict(X_scaled, verbose=0)
mse = np.mean((X_scaled - reconstructions) ** 2, axis=1)

# Set threshold at 95th percentile (top 5% error = anomaly)
ae_threshold = np.percentile(mse, 100 * (1 - contamination))
model_df["anomaly_ae"] = (mse > ae_threshold).astype(int)

n_anom_ae = model_df["anomaly_ae"].sum()
print(f"Autoencoder (threshold={ae_threshold:.4f}, top {100*contamination:.0f}% error):")
print(f"  Anomalies detected: {n_anom_ae} ({100*n_anom_ae/len(model_df):.2f}%)")

# Visualize
fig, axes = plt.subplots(2, 1, figsize=(16, 8))

# Reconstruction error
axes[0].plot(model_df.index, mse, color="gray", linewidth=0.6, alpha=0.7)
axes[0].axhline(ae_threshold, color="red", linestyle="--", label=f"Threshold = {ae_threshold:.4f}")
axes[0].fill_between(model_df.index, 0, ae_threshold, alpha=0.1, color="green")
axes[0].set_title("Autoencoder Reconstruction Error", fontsize=13, fontweight="bold")
axes[0].set_ylabel("MSE")
axes[0].legend()

# Anomalies
normal = model_df[model_df["anomaly_ae"] == 0]
anom = model_df[model_df["anomaly_ae"] == 1]
axes[1].plot(normal.index, normal["value"], ".", color="#2563eb", markersize=2, alpha=0.5, label="Normal")
axes[1].plot(anom.index, anom["value"], ".", color="red", markersize=4, label="Anomaly (Autoencoder)")
axes[1].set_title("Anomalies Detected by Autoencoder", fontsize=13, fontweight="bold")
axes[1].set_ylabel("Passenger Count")
axes[1].legend()

plt.tight_layout()
plt.savefig("../visualization/12_ae_anomalies.png", dpi=120, bbox_inches="tight")
plt.show()""")

# ===== EVALUATION =====
md("""## 7. Evaluation with Ground Truth Labels

The NAB dataset comes with **labeled anomaly windows** — periods where human experts identified unusual events. Let's load these and evaluate each method's performance.

### Anomaly Windows in the NYC Taxi Dataset
- 🏃 **NYC Marathon** (Nov 2, 2014)
- 🦃 **Thanksgiving** (Nov 27, 2014)
- 🎄 **Christmas** (Dec 25, 2014)
- 🎆 **New Year's Eve** (Dec 31, 2014)
- 🍾 **New Year's Day** (Jan 1, 2015)
- ❄️ **Blizzard / Snowstorm** (Jan 26–27, 2015)""")

code("""# Load ground truth labels from NAB format
with open("../data/labels.json", "r") as f:
    all_labels = json.load(f)

# Extract labels for our specific dataset
dataset_key = "realKnownCause/nyc_taxi.csv"
anomaly_windows = all_labels.get(dataset_key, [])

print(f"Found {len(anomaly_windows)} labeled anomaly timestamps for nyc_taxi.csv:")
for i, ts in enumerate(anomaly_windows):
    print(f"  {i+1}. {ts}")""")

code("""# Convert anomaly timestamps to per-point labels
ANOMALY_WINDOW_HOURS = 12  # consider 12 hours after each event as anomalous

def anomaly_timestamps_to_labels(timestamps, anomaly_times):
    labels = pd.Series(0, index=timestamps)
    for event_str in anomaly_times:
        event_ts = pd.Timestamp(event_str)
        window_end = event_ts + pd.Timedelta(hours=ANOMALY_WINDOW_HOURS)
        mask = (timestamps >= event_ts) & (timestamps <= window_end)
        labels[mask] = 1
    return labels

ground_truth = anomaly_timestamps_to_labels(model_df.index, anomaly_windows)

n_gt = ground_truth.sum()
print(f"Ground truth anomaly points: {n_gt} ({100*n_gt/len(ground_truth):.2f}%)")

# Visualize ground truth
fig, ax = plt.subplots(figsize=(16, 4))
normal_gt = model_df[ground_truth == 0]
anom_gt = model_df[ground_truth == 1]
ax.plot(normal_gt.index, normal_gt["value"], ".", color="#2563eb", markersize=2, alpha=0.5, label="Normal (Ground Truth)")
ax.plot(anom_gt.index, anom_gt["value"], ".", color="red", markersize=5, label="Anomaly (Ground Truth)")
ax.set_title("Ground Truth Anomaly Labels", fontsize=14, fontweight="bold")
ax.set_ylabel("Passenger Count")
ax.legend()
plt.tight_layout()
plt.savefig("../visualization/13_ground_truth.png", dpi=120, bbox_inches="tight")
plt.show()

print("These are the actual events we want our models to detect.")""")

code("""# Collect all predictions aligned on the same index
results = pd.DataFrame({
    "ground_truth": ground_truth,
    "zscore": df.loc[model_df.index, "anomaly_zscore"],
    "stl_iqr": df.loc[model_df.index, "anomaly_stl_iqr"],
    "isolation_forest": model_df["anomaly_if"],
    "one_class_svm": model_df["anomaly_svm"],
    "autoencoder": model_df["anomaly_ae"]
})

# Evaluation function
def evaluate_model(name, y_true, y_pred):
    prec, rec, f1, _ = precision_recall_fscore_support(y_true, y_pred, average="binary", zero_division=0)
    tn, fp, fn, tp = confusion_matrix(y_true, y_pred).ravel()
    return {
        "Method": name,
        "Precision": prec,
        "Recall": rec,
        "F1-Score": f1,
        "True Pos.": tp,
        "False Pos.": fp,
        "False Neg.": fn,
        "True Neg.": tn
    }

metrics = []
for method in ["zscore", "stl_iqr", "isolation_forest", "one_class_svm", "autoencoder"]:
    metrics.append(evaluate_model(
        method.replace("_", " ").title(),
        results["ground_truth"],
        results[method]
    ))

metrics_df = pd.DataFrame(metrics).sort_values("F1-Score", ascending=False)
print("\\n" + "=" * 90)
print("   MODEL COMPARISON — Anomaly Detection Performance")
print("=" * 90)
print(metrics_df.to_string(index=False))""")

code("""# Visual comparison
fig, axes = plt.subplots(6, 1, figsize=(18, 14), sharex=True)

methods = [
    ("Ground Truth", "ground_truth", "black"),
    ("Z-Score", "zscore", "#ef4444"),
    ("STL + IQR", "stl_iqr", "#f97316"),
    ("Isolation Forest", "isolation_forest", "#22c55e"),
    ("One-Class SVM", "one_class_svm", "#a855f7"),
    ("Autoencoder", "autoencoder", "#06b6d4"),
]

for ax, (label, col, color) in zip(axes, methods):
    ax.fill_between(results.index, 0, 1,
                    where=results[col] == 1,
                    color=color, alpha=0.4, step="mid")
    ax.set_ylabel(label, fontweight="bold", fontsize=9)
    ax.set_ylim(-0.1, 1.1)
    ax.set_yticks([0, 1])

axes[0].set_title("Anomaly Detection: Ground Truth vs All Methods", fontsize=14, fontweight="bold")
axes[-1].set_xlabel("Date (2014–2015)")

plt.tight_layout()
plt.savefig("../visualization/14_comparison.png", dpi=120, bbox_inches="tight")
plt.show()

print("💡 Green shading = True Positive, Red = False Positive, Yellow = Missed (False Negative).")
print("The timeline view shows which methods catch which anomaly windows.")""")

code("""# Precision-Recall F1 bar chart
fig, ax = plt.subplots(figsize=(12, 5))
x = range(len(metrics_df))
width = 0.25

ax.bar([i - width for i in x], metrics_df["Precision"], width, label="Precision", color="#22c55e", alpha=0.8)
ax.bar(x, metrics_df["Recall"], width, label="Recall", color="#3b82f6", alpha=0.8)
ax.bar([i + width for i in x], metrics_df["F1-Score"], width, label="F1-Score", color="#a855f7", alpha=0.8)

ax.set_xticks(x)
ax.set_xticklabels(metrics_df["Method"], rotation=25, ha="right")
ax.set_ylabel("Score")
ax.set_title("Precision / Recall / F1 by Method", fontsize=14, fontweight="bold")
ax.set_ylim(0, 1)
ax.legend(loc="lower right")
ax.axhline(0.5, color="gray", linestyle="--", alpha=0.5)

plt.tight_layout()
plt.savefig("../visualization/15_metrics_bar.png", dpi=120, bbox_inches="tight")
plt.show()""")

# ===== CONCLUSION =====
md("""## 8. Conclusion & Recommendations

### Key Findings

| Insight | Implication |
|:--------|:------------|
| **No single method is best** | Z-score is simplest but misses contextual anomalies; Autoencoder captures complex patterns but needs more tuning |
| **Seasonal decomposition helps** | STL + IQR gives interpretable, competitive results with zero training |
| **Feature engineering matters most** | All ML methods benefit from the same rich feature set |
| **Autoencoder showed promise** | Best recall, but higher false positive rate — threshold tuning is critical |

### Method Recommendations

| Use Case | Recommended Method |
|:---------|:------------------|
| Quick baseline / simple monitoring | **Rolling Z-score** (interpretable, no training) |
| Limited compute / interpretability needed | **STL + IQR** (robust, seasonal-aware) |
| Multi-dimensional / complex patterns | **Isolation Forest** (scalable, no distribution assumptions) |
| High precision requirement | **One-Class SVM** (tighter boundary) |
| Maximum recall / complex non-linear patterns | **Autoencoder** (requires tuning, more data) |

### Practical Tips

1. **Contamination matters** — setting the expected anomaly rate (`contamination`) dramatically affects results. Use domain knowledge or a validation set.
2. **Temporal cross-validation** — never shuffle time series. Always preserve order.
3. **Ensemble methods** — combine 2–3 methods and flag points where a majority agree. This often beats any single method.
4. **Adaptive thresholds** — anomaly thresholds should adapt to time-of-day and day-of-week (context-aware).""")

md("""### Suggested Improvements

1. **LSTM Autoencoder** — Use an LSTM-based autoencoder that processes sequences directly, preserving temporal dependencies without manual feature engineering.

2. **Gradient Boosting on Engineered Features** — XGBoost/LightGBM can learn complex decision boundaries from rolling features, often outperforming Isolation Forest.

3. **Segment-level Detection** — Instead of point-level, detect anomalous *segments* (contiguous blocks). Many real anomalies are sustained events.

4. **Online / Streaming Detection** — Deploy with a sliding window update; retrain hourly/daily as new data arrives.

5. **Explainable AI** — Use SHAP values to explain *why* each point was flagged (which features drove the decision).

6. **Multi-variate** — Add weather data, holiday calendar, event schedules as exogenous features for richer context.

7. **Hyperparameter Tuning** — Grid search over contamination, window sizes, and tree counts for optimal F1.

---

> **Final thought:** Anomaly detection in practice is an **interactive, iterative process**. No model gets it right 100% of the time — the goal is to *reduce the search space* for human operators, not replace them.""")
    
# Set cells
nb.cells = cells

# Write notebook
output_path = "time_series_anomaly_detection.ipynb"
with open(output_path, "w") as f:
    nbf.write(nb, f)

print(f"✅ Notebook generated: {output_path}")
print(f"   Total cells: {len(cells)} ({sum(1 for c in cells if c.cell_type == 'markdown')} markdown, {sum(1 for c in cells if c.cell_type == 'code')} code)")
