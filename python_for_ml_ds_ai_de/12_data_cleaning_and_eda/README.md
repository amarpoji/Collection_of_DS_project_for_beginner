# Module 12: Data Cleaning & Exploratory Data Analysis (EDA)

**Duration:** 20 hours

## Overview

Data cleaning and EDA are the most time-consuming parts of any data science project — often taking 60-80% of total project time. This module provides a systematic framework for assessing data quality, detecting and handling issues, and performing thorough exploratory analysis. The ML focus is on cleaning the Titanic and Ames Housing datasets for modeling.

## Learning Objectives

By the end of this module, you will be able to:
- Identify missing data patterns (MCAR, MAR, MNAR)
- Detect outliers using IQR, Z-score, and Isolation Forest
- Handle duplicates, inconsistent data, and formatting issues
- Parse dates and validate data types
- Apply a structured EDA framework (univariate, bivariate, multivariate)
- Perform correlation analysis and interpret results
- Use automated EDA with pandas-profiling/ydata-profiling
- Clean real-world datasets for ML modeling

## Prerequisites

- Pandas proficiency (Module 09)
- Data visualization skills (Module 10)
- Basic statistics (mean, median, correlation, distributions)

## Topics

### 1. Missing Data Patterns
- MCAR (Missing Completely At Random)
- MAR (Missing At Random)
- MNAR (Missing Not At Random)
- Visualizing missing patterns with matrix and heatmap
- Impact of missing data on ML models

### 2. Outlier Detection
- IQR method (Tukey's fences)
- Z-score method (standard deviation threshold)
- Modified Z-score with MAD
- Isolation Forest algorithm
- Visual detection (box plots, scatter plots)
- Handling outliers: capping, transformation, removal

### 3. Duplicate Handling
- Exact duplicate detection
- Partial/fuzzy duplicate detection
- Strategies: keep first, keep last, drop all, aggregate
- Business rules for duplicate resolution

### 4. Inconsistent Data
- Whitespace issues (strip, lstrip, rstrip)
- Casing inconsistencies (lower, upper, title)
- Common typos and standardization
- Regex-based pattern cleaning
- Category mapping and normalization

### 5. Date Parsing
- Common date formats and parsing strategies
- Handling ambiguous dates (MM/DD vs DD/MM)
- Timezone handling
- Extracting date components
- Dealing with invalid dates

### 6. Data Validation
- Type validation and coercion
- Range checks (min/max constraints)
- Uniqueness constraints
- Cross-field validation
- Custom validation rules

### 7. EDA Framework
- Univariate analysis (distributions, central tendency, dispersion)
- Bivariate analysis (relationships, correlations, cross-tabulations)
- Multivariate analysis (interactions, feature dependencies)
- Target variable analysis (classification vs regression)

### 8. Correlation Analysis
- Pearson correlation (linear relationships)
- Spearman rank correlation (monotonic relationships)
- Point-biserial correlation (binary vs continuous)
- Cramers V (categorical association)
- Correlation interpretation and pitfalls

### 9. Automated EDA Tools
- ydata-profiling (formerly pandas-profiling)
- Sweetviz for comparison analysis
- AutoViz for automated visualization
- D-Tale for interactive exploration
- When to use automated vs manual EDA

### 10. ML Focus: Cleaning Real Datasets
- Titanic: comprehensive cleaning for modeling
- Ames Housing: handling missing values, outliers, and skewed features
- Creating a reusable data cleaning pipeline
- Validating cleaning impact on model performance

## Practice Questions

1. Load the Titanic dataset and classify each column's missing data mechanism (MCAR/MAR/MNAR).
2. Use the IQR method to detect outliers in Fare. How many outliers exist per Pclass?
3. Find and remove any exact duplicate rows in the dataset.
4. Standardize the 'Sex' column (ensure consistent casing, no whitespace).
5. Parse the 'Name' column to extract titles, then standardize rare titles into 'Other'.
6. Create a data validation function that checks Age (0-120), Fare (>0), Pclass (1-3).
7. Perform a full EDA on the cleaned Titanic dataset and identify the top 5 features most correlated with survival.
8. Use ydata-profiling to generate an automated EDA report.
9. Clean the Ames Housing dataset: handle missing GarageYrBlt, LotFrontage, and Electrical.
10. Compare model performance (logistic regression) on raw vs cleaned Titanic data.

## Interview Questions

1. **Explain MCAR, MAR, and MNAR with examples.**
   - MCAR: missingness unrelated to data (e.g., survey page skipped randomly). MAR: missingness related to observed data (e.g., men more likely to skip weight question). MNAR: missingness related to the missing value itself (e.g., high earners hide income).

2. **How do you choose between dropping and imputing missing data?**
   - Drop when: missing percentage is low (<5%) and data is MCAR, or when column has >60% missing. Impute when: data is MAR/MNAR, the column is important, or you have domain knowledge for imputation.

3. **What's the difference between IQR and Z-score for outlier detection?**
   - IQR is robust to non-normal distributions (uses quartiles). Z-score assumes normality. For skewed data, use IQR or modified Z-score with MAD.

4. **How would you handle outliers in a feature that has a skewed distribution?**
   - Log-transform the feature first, then detect outliers, or use IQR (which is robust to skewness). Alternatively, cap at percentiles (e.g., 1st and 99th).

5. **What is the EDA framework you follow?**
   - 1) Univariate: distributions and statistics of each variable. 2) Bivariate: relationships between pairs (feature-feature, feature-target). 3) Multivariate: interactions and conditional relationships. 4) Missing data and outlier analysis.

6. **How do you detect multicollinearity during EDA?**
   - Correlation matrix heatmaps (|r| > 0.8 indicates concern). Variance Inflation Factor (VIF > 10). Pair plots for visual inspection.

7. **What's the difference between Pearson and Spearman correlation?**
   - Pearson measures linear relationships. Spearman measures monotonic relationships (rank-based). Use Spearman when data isn't normally distributed or relationships aren't linear.

8. **How would you validate that data cleaning improved model performance?**
   - Train the same model on raw data (with minimal cleaning) and cleaned data. Compare metrics (accuracy, F1, RMSE) on the same test set. Also compare training stability and feature importance.

9. **What are common data quality issues in real-world datasets?**
   - Missing values, outliers, duplicates, inconsistent formatting, date parsing errors, incorrect types, domain violations (negative ages), normalization issues, and data leakage.

10. **How do you build a reusable data cleaning pipeline?**
    - Use sklearn's Pipeline and ColumnTransformer. Define custom transformers for imputation, outlier capping, and encoding. Use FunctionTransformer for custom cleaning functions. Store pipeline parameters in config files.

## Common Pitfalls

1. **Leaky cleaning**: Computing imputation values using test data. Always fit on train, transform on test.
2. **Ignoring missing data mechanisms**: Treating all missing data the same leads to biased models.
3. **Outlier removal without understanding**: Outliers may contain valuable signals (fraud, rare events).
4. **Failing to validate after cleaning**: Always check cleaning results — did imputation introduce bias?
5. **Automated EDA over-reliance**: Automated reports miss domain-specific insights. Always supplement with manual analysis.
6. **Circular cleaning**: Cleaning one issue creates another (e.g., filling missing data then detecting outliers in filled values).
7. **Not documenting cleaning decisions**: Critical for reproducibility and debugging.

## Resources

- [ydata-profiling documentation](https://docs.profiling.ydata.ai/)
- [Ames Housing dataset](https://www.kaggle.com/c/house-prices-advanced-regression-techniques)
- [Scikit-learn imputation guide](https://scikit-learn.org/stable/modules/impute.html)
- [Outlier detection with sklearn](https://scikit-learn.org/stable/modules/outlier_detection.html)

## Next Module

Module 13: Statistics for Data — Bridge into statistical analysis and hypothesis testing for data science.
