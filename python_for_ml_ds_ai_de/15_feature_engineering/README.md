# Module 15: Feature Engineering

**Duration: 18 hours**

## Overview

Feature engineering is the art and science of transforming raw data into features that better represent the underlying problem to machine learning models. This module covers scaling, encoding, imputation, feature creation, and selection techniques — with a focus on building effective feature pipelines for Kaggle competitions and real-world projects.

## Learning Objectives

By the end of this module, you will be able to:
- Apply numerical feature scaling (StandardScaler, MinMaxScaler, RobustScaler)
- Encode categorical variables (OneHot, Label, Ordinal, Target encoding)
- Implement missing value imputation strategies
- Create interaction and polynomial features
- Use binning and discretization techniques
- Engineer date/time and text features
- Select optimal features (SelectKBest, RFE, feature_importances_)
- Build complete feature pipelines with sklearn

## Prerequisites

- Python for ML (Module 14) or equivalent sklearn experience
- Pandas and NumPy proficiency

## Topics

### 1. Numerical Feature Scaling (3 hours)
- StandardScaler: zero mean, unit variance
- MinMaxScaler: scale to [0, 1] range
- RobustScaler: robust to outliers using IQR
- When to use each scaler
- Scaling before vs after split

### 2. Categorical Encoding (4 hours)
- OneHotEncoder: creates binary columns per category
- LabelEncoder: assigns integer labels
- OrdinalEncoder: preserves ordinal relationships
- Target Encoding: replace category with mean target
- Frequency encoding: replace with count
- Handling high-cardinality features

### 3. Missing Value Imputation (3 hours)
- SimpleImputer: mean, median, most_frequent, constant
- KNNImputer: impute using k-nearest neighbors
- IterativeImputer: model-based imputation
- Indicator features for missingness

### 4. Feature Construction (4 hours)
- Interaction features (poly interactions)
- PolynomialFeatures (degree 2, 3)
- Binning/KBinsDiscretizer
- Date/time feature extraction (day, month, weekday, hour)
- Text features: CountVectorizer, TfidfVectorizer

### 5. Feature Selection (3 hours)
- Filter methods: SelectKBest, chi-square, ANOVA
- Wrapper methods: RFE, RFECV
- Embedded methods: feature_importances_, L1 regularization
- Variance threshold for constant features

### 6. Feature Pipelines (1 hour)
- Combining transformers with ColumnTransformer
- Building end-to-end pipelines with Pipeline
- Feature engineering strategy for Kaggle

## ML Focus
- Feature pipelines for Kaggle competitions
- Avoid data leakage in feature engineering
- Impact of feature engineering on model performance

## Datasets Used
- Titanic — categorical encoding, missing value imputation
- California Housing — scaling, binning, polynomial features
- Iris — feature selection, interaction features
- Custom text data — TF-IDF, CountVectorizer

## Files
- `README.md` — This file
- `lesson.ipynb` — Main lesson notebook
- `exercises.ipynb` — Practice exercises
- `solutions.ipynb` — Exercise solutions
- `cheatsheet.md` — Quick reference
- `mini_project/README.md` — Mini project description

## Practice Questions
1. When would you use RobustScaler over StandardScaler?
2. What is the difference between OneHotEncoder and LabelEncoder?
3. How does target encoding cause data leakage?
4. What is the bias-variance tradeoff in polynomial features?
5. When is RFE preferred over SelectKBest?

## Interview Questions
1. "Explain how you would handle a categorical feature with 1000 unique values."
2. "How do you prevent data leakage during feature engineering?"
3. "Compare filter, wrapper, and embedded feature selection methods."
4. "What's your approach to missing data — when is deletion acceptable?"
5. "How does feature scaling affect tree-based vs distance-based models?"

## Common Pitfalls
- **Data leakage**: Fitting encoders/scalers on entire dataset before split
- **Target leakage**: Using future information in time series feature engineering
- **Over-engineering**: Creating too many polynomial features (curse of dimensionality)
- **Ignoring ordinality**: Treating ordinal features as nominal
- **Inconsistent encoding**: Different categories in train vs test
- **Missing value masking**: Not tracking which values were imputed
