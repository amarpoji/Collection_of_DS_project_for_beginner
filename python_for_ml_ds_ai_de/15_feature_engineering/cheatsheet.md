# Feature Engineering — Cheatsheet

## Numerical Scaling

```python
from sklearn.preprocessing import StandardScaler, MinMaxScaler, RobustScaler

StandardScaler()     # (x - mean) / std — assumes normal distribution
MinMaxScaler()       # (x - min) / (max - min) — scales to [0,1]
RobustScaler()       # (x - median) / IQR — robust to outliers
```

**Rule**: Scale AFTER train/test split. Never scale before.

## Categorical Encoding

```python
from sklearn.preprocessing import OneHotEncoder, LabelEncoder, OrdinalEncoder

# Nominal (no order)
OneHotEncoder(sparse_output=False, drop='first')

# Ordinal (has order)
OrdinalEncoder(categories=[['low', 'medium', 'high']])

# Label (for target)
LabelEncoder()  # fit on y, not X
```

**Target Encoding** (manual):
```python
mean_target = df.groupby('category')['target'].mean()
df['cat_encoded'] = df['category'].map(mean_target)
# Risk of leakage — use cross-validation schemes!
```

## Missing Value Imputation

```python
from sklearn.impute import SimpleImputer, KNNImputer

SimpleImputer(strategy='mean')         # mean, median, most_frequent, constant
SimpleImputer(strategy='constant', fill_value=0)
KNNImputer(n_neighbors=5)              # uses feature similarity
```

## Feature Construction

```python
from sklearn.preprocessing import PolynomialFeatures, KBinsDiscretizer

# Polynomial/interaction
PolynomialFeatures(degree=2, include_bias=False, interaction_only=True)

# Binning
KBinsDiscretizer(n_bins=5, encode='onehot', strategy='quantile')
# strategy: 'uniform', 'quantile', 'kmeans'
```

**Date features:**
```python
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month
df['day'] = df['date'].dt.day
df['dayofweek'] = df['date'].dt.dayofweek
df['is_weekend'] = df['dayofweek'].isin([5,6]).astype(int)
df['quarter'] = df['date'].dt.quarter
```

**Text features:**
```python
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer

CountVectorizer(stop_words='english', max_features=1000)
TfidfVectorizer(stop_words='english', max_features=1000)
```

## Feature Selection

```python
from sklearn.feature_selection import SelectKBest, f_classif, f_regression, RFE

# Filter
SelectKBest(score_func=f_classif, k=5)     # classification
SelectKBest(score_func=f_regression, k=5)  # regression

# Wrapper
RFE(estimator=LogisticRegression(), n_features_to_select=5)

# Embedded
RandomForestClassifier().fit(X,y).feature_importances_

# Low-variance removal
VarianceThreshold(threshold=0.01)
```

## ColumnTransformer + Pipeline

```python
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline

preprocessor = ColumnTransformer([
    ('num', StandardScaler(), ['age', 'fare']),
    ('cat', OneHotEncoder(), ['sex', 'embarked'])
])

pipeline = Pipeline([
    ('prep', preprocessor),
    ('clf', RandomForestClassifier())
])

pipeline.fit(X_train, y_train)
```

## Kaggle Tips

1. **Create domain-specific features** — interaction, ratio, aggregation
2. **Use mean encoding** carefully — cross-validate to prevent leakage
3. **Log transform** right-skewed targets/features
4. **Feature selection** often improves generalization
5. **Build lists of features** (numeric, categorical, text, date) before coding
6. **Use Pipeline** to ensure reproducibility

## Common Pitfalls

| Mistake | Fix |
|---------|-----|
| Fitting scaler before split | Fit on train only, transform test |
| Target encoding without cross-val | Use stratified k-fold target encoding |
| OneHot on high cardinality | Use target encoding or frequency encoding |
| Creating too many poly features | Use interaction_only or regularize |
| Not handling unseen categories | Set handle_unknown='ignore' in OneHotEncoder |
