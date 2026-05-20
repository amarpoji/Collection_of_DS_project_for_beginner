# Mini Project: Cleaning Titanic & Ames Housing for Modeling

## Objective

Apply a comprehensive data cleaning and EDA pipeline to two real-world datasets: Titanic (classification) and Ames Housing (regression). The goal is to produce clean, validated datasets ready for ML modeling.

## Datasets

### 1. Titanic Dataset
- URL: `https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv`
- 891 rows, 12 columns
- Target: `Survived` (binary classification)

### 2. Ames Housing Dataset
- URL: `https://raw.githubusercontent.com/ageron/handson-ml2/master/datasets/housing/housing.csv`
- 20,640 rows, 10 columns (or use the full Ames dataset from Kaggle)
- Alternative: `https://raw.githubusercontent.com/ageron/data/main/housing/housing.csv`
- Target: `median_house_value` (regression)

## Requirements

### Part 1: Titanic — Comprehensive Cleaning & EDA (40%)

**Data Quality Assessment:**
1. Load and inspect the dataset
2. Identify missing data patterns (use missingno matrix and heatmap)
3. Classify missing mechanisms (MCAR/MAR/MNAR) for each column with missing data
4. Document your reasoning for each column

**Missing Data Treatment:**
1. Age: Impute using grouped median (Pclass + Sex)
2. Embarked: Fill with mode
3. Cabin: Extract deck letter, then drop original Cabin column
4. Drop any remaining rows with missing values if < 5 rows affected

**Outlier Detection & Treatment:**
1. Detect Fare outliers using IQR method
2. Detect Fare outliers using Z-score (threshold=3)
3. Compare the two methods — how many overlap?
4. Cap Fare at the 99th percentile
5. Detect Age outliers and decide whether to treat them

**Inconsistent Data:**
1. Check and fix whitespace issues in Embarked
2. Check and fix casing in Sex
3. Standardize Title from Name column (Mr, Mrs, Miss, Master, Rare)

**Data Validation:**
1. Create validation rules and verify:
   - Age between 0 and 120
   - Fare > 0
   - Pclass in {1, 2, 3}
   - Survived in {0, 1}
   - No duplicate PassengerId

**EDA:**
1. Univariate: distributions of all features
2. Bivariate: correlation with target (Survived)
3. Multivariate: pairplot of top 5 features
4. Automated EDA report using ydata-profiling

**Final Output:**
- `titanic_clean.csv` (no missing values, all numeric types)
- `titanic_eda_report.html` (from ydata-profiling)

### Part 2: Ames Housing — Cleaning for Regression (40%)

**Data Quality:**
1. Handle missing values in GarageYrBlt (replace with 0 or year built)
2. Handle LotFrontage (impute with median by neighborhood)
3. Handle missing Electrical (mode imputation, only 1 missing)
4. Handle any other missing values appropriately

**Outlier Detection:**
1. Detect outliers in SalePrice using IQR
2. Detect outliers in GrLivArea (above-ground living area)
3. Remove extreme outliers (SalesPrice < $50,000 or > $700,000?)
4. Log-transform SalePrice for normality

**Feature Engineering:**
1. Create TotalSF = TotalBsmtSF + GrLivArea
2. Create HouseAge = YrSold - YearBuilt
3. Create Remodeled flag = (YearRemodAdd != YearBuilt)

**Validation:**
1. Check all numeric columns for valid ranges
2. Verify no missing values remain
3. Check that final DataFrame has no object columns (or mark them for encoding)

**Final Output:**
- `ames_clean.csv` (cleaned dataset ready for modeling)

### Part 3: Comparison & Documentation (20%)

1. Compare model performance (logistic regression on Titanic, linear regression on Ames):
   - Train on raw data (minimal cleaning)
   - Train on cleaned data
   - Report accuracy/RMSE improvement
2. Document all cleaning decisions in markdown cells
3. Create a reusable cleaning function for each dataset

## Deliverables

1. `data_cleaning_eda.ipynb` — Complete notebook
2. `titanic_clean.csv` — Cleaned Titanic dataset
3. `ames_clean.csv` — Cleaned Ames Housing dataset
4. `titanic_eda_report.html` — Automated EDA report

## Evaluation Criteria

- All missing data is handled with appropriate strategies
- Outlier detection uses multiple methods and sound reasoning
- Data validation catches and reports issues
- EDA includes univariate, bivariate, and multivariate analysis
- Automated EDA report is generated
- Cleaning decisions are documented with rationale
- Final datasets are truly ML-ready (no missing values, valid ranges)

## Stretch Goals

- Build a custom DataValidator class with configurable rules
- Use Isolation Forest for outlier detection
- Create a Streamlit dashboard showing the cleaning process
- Compare multiple imputation strategies (SimpleImputer vs KNNImputer)
- Perform feature selection after cleaning using mutual information
