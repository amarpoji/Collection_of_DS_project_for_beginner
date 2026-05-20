# Data Cleaning & EDA — Cheatsheet

## Imports
```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from sklearn.ensemble import IsolationForest
import ydata_profiling as yp
```

## Missing Data Analysis

```python
# Count missing
df.isna().sum()
df.isnull().sum()

# Percentage missing
(df.isna().sum() / len(df) * 100).round(2)

# Visualize missing pattern
import missingno as msno
msno.matrix(df)          # Missing pattern matrix
msno.heatmap(df)         # Missing correlation
msno.dendrogram(df)      # Missing clustering

# Missing by group
df.groupby('col')['other'].apply(lambda x: x.isna().mean())

# Little's MCAR test (pip install mcar)
# from mcar import little_mcar_test
# little_mcar_test(df)
```

## Handling Missing Data

```python
# Drop
df.dropna()                     # Drop rows with any NaN
df.dropna(axis=1, thresh=500)   # Drop cols with < 500 non-null
df.dropna(subset=['important'])  # Drop only if important col is NaN

# Simple imputation
df['col'].fillna(0)                                # Constant
df['col'].fillna(df['col'].median())                # Median
df['col'].fillna(df['col'].mode()[0])               # Mode
df['col'] = df.groupby('group')['col'].transform(lambda x: x.fillna(x.median()))

# Forward/backward fill
df['col'].fillna(method='ffill')   # Forward fill
df['col'].fillna(method='bfill')   # Backward fill

# Interpolation
df['col'].interpolate(method='linear')
df['col'].interpolate(method='time')  # For time series

# Sklearn imputation
from sklearn.impute import SimpleImputer, KNNImputer
SimpleImputer(strategy='median')
KNNImputer(n_neighbors=5)
```

## Outlier Detection

```python
# IQR Method
Q1 = df['col'].quantile(0.25)
Q3 = df['col'].quantile(0.75)
IQR = Q3 - Q1
lower = Q1 - 1.5 * IQR
upper = Q3 + 1.5 * IQR
outliers = df[(df['col'] < lower) | (df['col'] > upper)]

# Z-score Method
z_scores = np.abs(stats.zscore(df['col'], nan_policy='omit'))
outliers = df[z_scores > 3]

# Modified Z-score with MAD
from scipy.stats import median_abs_deviation
mad = median_abs_deviation(df['col'].dropna())
median = df['col'].median()
modified_z = 0.6745 * (df['col'] - median) / mad
outliers = df[np.abs(modified_z) > 3.5]

# Isolation Forest
from sklearn.ensemble import IsolationForest
iso = IsolationForest(contamination=0.05, random_state=42)
outlier_labels = iso.fit_predict(df[numeric_cols])
df[outlier_labels == -1]  # Outliers

# Visual
sns.boxplot(x=df['col'])
sns.histplot(df['col'])
df['col'].plot(kind='box')
```

## Outlier Handling

```python
# Capping (Winsorizing)
df['col'] = df['col'].clip(lower=lower, upper=upper)

# Quantile capping
df['col'] = df['col'].clip(lower=df['col'].quantile(0.01),
                            upper=df['col'].quantile(0.99))

# Log transform (makes outliers less extreme)
df['col_log'] = np.log1p(df['col'])

# Remove
df_clean = df[(df['col'] >= lower) & (df['col'] <= upper)]
```

## Duplicate Handling

```python
# Check duplicates
df.duplicated()                         # Boolean series
df.duplicated(subset=['col1', 'col2'])  # Subset check
df.duplicated(keep='first')            # 'first', 'last', False

# Count duplicates
df.duplicated().sum()

# Drop duplicates
df.drop_duplicates()
df.drop_duplicates(subset=['col1'], keep='last')

# Fuzzy duplicates (approximate matching)
# from thefuzz import fuzz
# from thefuzz import process
```

## Inconsistent Data Cleaning

```python
# Whitespace
df['col'] = df['col'].str.strip()
df['col'] = df['col'].str.lstrip()
df['col'] = df['col'].str.rstrip()

# Casing
df['col'] = df['col'].str.lower()
df['col'] = df['col'].str.upper()
df['col'] = df['col'].str.title()

# Replace values
df['col'] = df['col'].replace({'old': 'new', 'Old': 'new'})

# Regex replacement
df['col'] = df['col'].str.replace(r'\s+', ' ', regex=True)  # Multiple spaces

# Category mapping
df['col'] = df['col'].map({'yes': 1, 'no': 0, 'y': 1, 'n': 0})

# Standardize common typos
typo_map = {'mising': 'missing', 'N/A': np.nan, 'NA': np.nan}
df['col'] = df['col'].replace(typo_map)
```

## Date Parsing

```python
# Basic parsing
df['date'] = pd.to_datetime(df['date_col'])
df['date'] = pd.to_datetime(df['date_col'], format='%Y-%m-%d')
df['date'] = pd.to_datetime(df['date_col'], dayfirst=True)  # DD/MM/YYYY

# Error handling (coerce invalid to NaT)
df['date'] = pd.to_datetime(df['date_col'], errors='coerce')

# Extract components
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month
df['day'] = df['date'].dt.day
df['weekday'] = df['date'].dt.weekday
df['quarter'] = df['date'].dt.quarter
df['is_weekend'] = df['date'].dt.weekday >= 5

# Time differences
df['days_diff'] = (df['date2'] - df['date1']).dt.days
```

## Data Validation

```python
# Type checks
df['col'] = pd.to_numeric(df['col'], errors='coerce')

# Range checks
assert df['age'].between(0, 120).all(), 'Age out of range'
assert (df['price'] > 0).all(), 'Price must be positive'

# Uniqueness
assert df['id'].is_unique, 'IDs are not unique'

# Cross-field validation
assert (df['birth_date'] < df['death_date']).all(), 'Death before birth'

# Custom validation function
def validate_row(row):
    checks = []
    if row['age'] < 0:
        checks.append('Negative age')
    if row['fare'] < 0:
        checks.append('Negative fare')
    return checks
```

## EDA Framework

```python
# Univariate — Numeric
df['col'].describe()
df['col'].hist(bins=30)
df['col'].skew()           # Skewness
df['col'].kurtosis()       # Kurtosis

# Univariate — Categorical
df['col'].value_counts()
df['col'].value_counts(normalize=True)
sns.countplot(x=df['col'])

# Bivariate — Num vs Num
sns.scatterplot(x='col1', y='col2', data=df)
df[['col1', 'col2']].corr()

# Bivariate — Cat vs Num
df.groupby('cat_col')['num_col'].describe()
sns.boxplot(x='cat_col', y='num_col', data=df)

# Bivariate — Cat vs Cat
pd.crosstab(df['cat1'], df['cat2'], normalize='index')

# Multivariate
sns.pairplot(df, hue='target')
sns.heatmap(df.corr())
```

## Correlation Analysis

```python
# Pearson (linear)
df.corr(method='pearson')

# Spearman (monotonic)
df.corr(method='spearman')

# Point-biserial (binary vs continuous)
from scipy.stats import pointbiserialr
corr, pval = pointbiserialr(df['binary'], df['continuous'])

# Cramers V (categorical association)
from scipy.stats import chi2_contingency
def cramers_v(confusion_matrix):
    chi2 = chi2_contingency(confusion_matrix)[0]
    n = confusion_matrix.sum().sum()
    phi2 = chi2 / n
    r, k = confusion_matrix.shape
    phi2corr = max(0, phi2 - ((k-1)*(r-1))/(n-1))
    rcorr = r - ((r-1)**2)/(n-1)
    kcorr = k - ((k-1)**2)/(n-1)
    return np.sqrt(phi2corr / min((kcorr-1), (rcorr-1)))

# VIF (multicollinearity)
from statsmodels.stats.outliers_influence import variance_inflation_factor
vif = pd.DataFrame()
vif['VIF'] = [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]
vif['feature'] = X.columns
```

## Automated EDA

```python
# ydata-profiling
profile = yp.ProfileReport(df, title='EDA Report', explorative=True)
profile.to_file('eda_report.html')

# Sweetviz (comparison)
# import sweetviz as sv
# report = sv.compare([train, 'Train'], [test, 'Test'], 'target')
# report.show_html('sweetviz_report.html')

# D-Tale (interactive)
# import dtale
# d = dtale.show(df)
# d.open_browser()
```

## Data Cleaning Pipeline Template

```python
def clean_titanic(df):
    """Reusable Titanic data cleaning pipeline."""
    df = df.copy()
    
    # 1. Fix dtypes
    df['Pclass'] = df['Pclass'].astype('int8')
    
    # 2. Handle missing Age (group median imputation)
    df['Age'] = df.groupby(['Pclass', 'Sex'])['Age'].transform(
        lambda x: x.fillna(x.median())
    )
    
    # 3. Handle missing Embarked (mode)
    df['Embarked'] = df['Embarked'].fillna(df['Embarked'].mode()[0])
    
    # 4. Keep Cabin deck, drop Cabin
    df['Deck'] = df['Cabin'].str[0]
    df.drop(columns=['Cabin'], inplace=True)
    
    # 5. Feature engineering
    df['Family_Size'] = df['SibSp'] + df['Parch'] + 1
    df['Is_Alone'] = (df['Family_Size'] == 1).astype(int)
    
    # 6. Outlier capping for Fare
    upper = df['Fare'].quantile(0.99)
    df['Fare'] = df['Fare'].clip(upper=upper)
    
    return df
```
