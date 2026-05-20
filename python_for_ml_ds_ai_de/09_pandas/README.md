# Module 09: Pandas for Data Science & Machine Learning

**Duration:** 30 hours

## Overview

Pandas is the backbone of data manipulation in Python for data science and machine learning. This module provides a comprehensive deep dive into pandas, from foundational Series and DataFrame operations to advanced techniques like multi-indexing, memory optimization, and datetime handling. The ML focus is on real-world EDA using the Titanic dataset and preparing data for ML pipelines.

## Learning Objectives

By the end of this module, you will be able to:
- Create and manipulate Series and DataFrames
- Read data from CSV, Excel, and SQL sources
- Inspect and explore datasets efficiently
- Select data using `.loc`, `.iloc`, and boolean indexing
- Handle missing data with `.isna()`, `.dropna()`, `.fillna()`, and `.interpolate()`
- Perform grouped operations with `.groupby()`
- Merge, join, and concatenate DataFrames
- Apply functions with `.apply()`, `.map()`, and `.applymap()`
- Create pivot tables and cross-tabulations
- Handle datetime data effectively
- Perform string operations with the `.str` accessor
- Optimize memory usage with proper dtypes and categorical types
- Work with multi-index DataFrames
- Perform end-to-end EDA on the Titanic dataset for ML preparation

## Prerequisites

- Python fundamentals (variables, data types, functions)
- Basic NumPy (arrays, broadcasting, vectorization)
- Familiarity with Jupyter notebooks

## Topics

### 1. Series and DataFrame Fundamentals
- Creating Series from lists, dicts, and scalars
- DataFrame creation from dicts, lists of dicts, and NumPy arrays
- Index and column attributes
- Data types and memory usage

### 2. Reading Data
- `pd.read_csv()` — parameters, parsing options
- `pd.read_excel()` — sheet selection, header handling
- `pd.read_sql()` — querying databases
- Handling URLs and compressed files

### 3. Data Inspection
- `.head()`, `.tail()`, `.sample()`
- `.info()`, `.describe()`, `.dtypes`
- `.shape`, `.columns`, `.index`
- `.value_counts()`, `.nunique()`, `.unique()`

### 4. Data Selection
- `.loc[]` — label-based indexing
- `.iloc[]` — integer position indexing
- Boolean indexing and filtering
- `.at[]` and `.iat[]` for scalar access
- `.xs()` for cross-sectional selection

### 5. Handling Missing Data
- Detecting missing values with `.isna()` and `.isnull()`
- Dropping with `.dropna()` — axis, how, thresh
- Filling with `.fillna()` — value, method, limit
- Interpolation with `.interpolate()` — linear, time, polynomial
- Forward/backward fill

### 6. GroupBy Operations
- Split-apply-combine pattern
- `.groupby()` on single and multiple columns
- Aggregation with `.agg()` — multiple functions
- `.transform()` and `.filter()`
- Custom aggregation functions

### 7. Merge, Join, Concatenate
- `pd.merge()` — inner, outer, left, right joins
- `.join()` — index-based joining
- `pd.concat()` — row and column concatenation
- Handling overlapping columns

### 8. Apply, Map, ApplyMap
- `.apply()` on rows and columns
- `.map()` for Series transformations
- `.applymap()` for element-wise DataFrame operations
- Vectorized vs. loop performance

### 9. Pivot Tables
- `pd.pivot_table()` — index, columns, values, aggfunc
- `pd.crosstab()` for frequency tables
- Melting and unpivoting with `pd.melt()`

### 10. Datetime Handling
- `pd.to_datetime()` parsing
- `.dt` accessor — year, month, day, weekday
- Date ranges with `pd.date_range()`
- Time-based indexing and resampling
- Time deltas and offsets

### 11. String Operations
- `.str` accessor — upper, lower, strip, split
- `.str.contains()`, `.str.extract()`, `.str.replace()`
- `.str.startswith()`, `.str.endswith()`
- Regex patterns with `.str`

### 12. Memory Optimization
- Understanding `dtypes` and memory footprint
- Using `category` dtype for low-cardinality strings
- Downcasting numeric types
- `pd.to_numeric()` with errors handling

### 13. Multi-Index
- Creating hierarchical indexes
- `.set_index()` and `.reset_index()`
- `.swaplevel()`, `.reorder_levels()`
- Slicing with `.xs()`

### 14. ML-Focused Titanic EDA
- Loading and inspecting the Titanic dataset
- Data quality assessment
- Feature engineering (titles, family size, cabins)
- Handling missing Age, Embarked, Cabin
- Creating dummy variables
- Preparing the final feature matrix for modeling

## Practice Questions

1. Load the Titanic dataset and display the first 10 rows. How many passengers survived?
2. Find the average age of passengers by passenger class and sex.
3. Create a new feature 'family_size' = SibSp + Parch + 1.
4. Fill missing Age values with the median age per passenger class.
5. Merge the Titanic dataset with a custom dataset of passenger titles.
6. Use `.apply()` to categorize ages into bins: child (0-12), teen (13-19), adult (20-59), senior (60+).
7. Create a pivot table showing survival rates by passenger class and sex.
8. Extract the year, month, and weekday from a datetime column.
9. Use `.str.extract()` to extract cabin deck letters from the Cabin column.
10. Optimize the Titanic DataFrame to use categorical dtypes for object columns.

## Interview Questions

1. **What is the difference between `.loc` and `.iloc`?**
   - `.loc` uses label-based indexing (row/column names), while `.iloc` uses integer-based positional indexing. `.loc` includes the endpoint in slices, `.iloc` excludes it.

2. **Explain the split-apply-combine pattern in pandas GroupBy.**
   - Split: data is grouped by key column(s). Apply: a function is applied to each group independently. Combine: results are combined into a DataFrame.

3. **How would you handle missing data in a dataset with 50% missing values in a column?**
   - Depends on context: if the column is important, use domain knowledge or model-based imputation. If not critical, consider dropping the column. For time series, interpolation is preferred.

4. **What is the difference between `pd.merge()` and `pd.concat()`?**
   - `merge()` combines DataFrames on columns/indices (SQL-like joins). `concat()` stacks them along an axis (vertical or horizontal), optionally with a key.

5. **How do you optimize memory usage in pandas?**
   - Use `category` dtype for string columns with low cardinality. Downcast float64 to float32 or float16. Use `int8`/`int16` for small integers. Use `pd.to_numeric()` with `downcast`.

6. **Explain multi-indexing and when you'd use it.**
   - Multi-index allows hierarchical row/column labels. Useful for time series with multiple grouping levels, or when a single index can't uniquely identify rows.

7. **How does pandas handle datetime data?**
   - Use `pd.to_datetime()` for parsing. The `.dt` accessor provides component extraction. Time-based indexing with `DatetimeIndex` enables resampling and slicing.

8. **What is the difference between `.apply()` and `.map()`?**
   - `.map()` works only on Series for element-wise mapping (dict or function). `.apply()` works on both Series and DataFrame, applying a function along an axis.

9. **How would you detect and handle outliers in a pandas DataFrame?**
   - Use IQR or Z-score methods with boolean indexing. Apply `.quantile()` for IQR, or `scipy.stats.zscore` for Z-score.

10. **What are the common pitfalls with chained indexing in pandas?**
    - Using `df[df['col'] > 0]['col2']` (chained indexing) may create a copy instead of a view, causing SettingWithCopyWarning. Use `.loc[row_condition, 'col2']` instead.

## Common Pitfalls

1. **Chained Indexing**: Always use `.loc` for setting values to avoid SettingWithCopyWarning.
2. **In-Place vs Copy**: Many methods (`dropna`, `fillna`) return a new object by default; use `inplace=True` cautiously.
3. **Mixing dtypes**: Object columns consume more memory and are slower. Convert to appropriate types.
4. **Forgetting `axis` parameter**: Operations default to axis=0 (rows). Set axis=1 for column-wise operations.
5. **NaNs in comparisons**: `NaN != NaN` is True. Use `.isna()` for missing value detection.
6. **Date parsing**: Always specify `parse_dates` in `read_csv` or use `pd.to_datetime()` explicitly.
7. **GroupBy performance**: Avoid custom lambdas in `.agg()` when built-in functions suffice.
8. **Merge key dtype mismatch**: Ensure merge key columns have the same dtype to avoid unexpected results.

## Resources

- [pandas official documentation](https://pandas.pydata.org/docs/)
- [pandas cheat sheet](https://pandas.pydata.org/Pandas_Cheat_Sheet.pdf)
- [Titanic dataset on Kaggle](https://www.kaggle.com/c/titanic)
- [10 Minutes to pandas](https://pandas.pydata.org/docs/user_guide/10min.html)

## Next Module

Module 10: Data Visualization — Learn to visualize data effectively with matplotlib and seaborn.
