# Pandas Cheatsheet

## Import
```python
import pandas as pd
import numpy as np
```

## Creating Data Structures

```python
# Series
pd.Series([1, 2, 3], index=['a', 'b', 'c'])
pd.Series({'a': 1, 'b': 2})

# DataFrame
pd.DataFrame({'A': [1, 2], 'B': [3, 4]})
pd.DataFrame(np.random.randn(3, 2), columns=['A', 'B'])
```

## Reading Data

```python
pd.read_csv('file.csv', sep=',', header=0, index_col=0, parse_dates=['date'])
pd.read_excel('file.xlsx', sheet_name='Sheet1', header=0)
pd.read_sql('SELECT * FROM table', con)
pd.read_json('file.json')
pd.read_parquet('file.parquet')
```

## Inspection

```python
df.head(n=5)          # First n rows
df.tail(n=5)          # Last n rows
df.sample(n=5)        # Random sample
df.info()             # Column info + dtypes + memory
df.describe()         # Summary statistics (numeric)
df.describe(include='all')
df.dtypes             # Data types
df.shape              # (rows, cols)
df.columns            # Column names
df.index              # Index
df.memory_usage(deep=True)
df.nunique()          # Unique value counts
df['col'].value_counts()
df['col'].unique()
```

## Selection

```python
# By column
df['col']             # Series
df[['a', 'b']]        # DataFrame

# By row (label)
df.loc[0:5]           # Inclusive of 5
df.loc[df['age'] > 30]
df.loc[rows, cols]

# By row (position)
df.iloc[0:5]          # Exclusive of 5
df.iloc[:, 0:2]

# Scalar access
df.at[0, 'col']
df.iat[0, 0]

# Boolean indexing
df[(df['age'] > 30) & (df['sex'] == 'male')]
df[df['name'].str.contains('Smith')]
```

## Missing Data

```python
df.isna().sum()            # Missing count per column
df.isnull().sum()
df.notna().sum()

df.dropna(axis=0)          # Drop rows with any NaN
df.dropna(axis=1)          # Drop columns with any NaN
df.dropna(how='all')       # Drop rows where ALL are NaN
df.dropna(thresh=5)        # Keep rows with at least 5 non-NaN

df.fillna(0)               # Fill with scalar
df.fillna(method='ffill')  # Forward fill
df.fillna(method='bfill')  # Backward fill
df.fillna(df.mean())       # Fill with mean

df.interpolate(method='linear')
df.interpolate(method='time')
```

## GroupBy

```python
df.groupby('col')['value'].mean()
df.groupby(['col1', 'col2']).agg({'val1': 'sum', 'val2': 'mean'})
df.groupby('col').agg(['mean', 'std', 'count'])
df.groupby('col').transform(lambda x: x - x.mean())
df.groupby('col').filter(lambda x: x['val'].sum() > 100)
```

## Merge / Join / Concat

```python
pd.merge(df1, df2, on='key')
pd.merge(df1, df2, how='left', on='key')
pd.merge(df1, df2, how='outer', left_on='key1', right_on='key2')

df1.join(df2, how='inner')

pd.concat([df1, df2], axis=0)          # Row bind
pd.concat([df1, df2], axis=1)          # Column bind
pd.concat([df1, df2], keys=['A', 'B'])  # With keys
```

## Apply / Map

```python
df['col'].map({'yes': 1, 'no': 0})     # Dict mapping
df['col'].map(lambda x: x**2)           # Function on Series

df['col'].apply(len)                    # Function on each element
df.apply(lambda row: row.sum(), axis=1) # Row-wise
df.apply(lambda col: col.mean(), axis=0) # Column-wise

df.applymap(lambda x: str(x))           # Element-wise on entire DF
```

## Pivot Tables

```python
pd.pivot_table(df, values='val', index='row', columns='col', aggfunc='mean')
pd.pivot_table(df, values='val', index=['r1', 'r2'], aggfunc={'val1': 'sum', 'val2': 'mean'})
pd.crosstab(df['col1'], df['col2'], normalize=True)
pd.melt(df, id_vars=['id'], value_vars=['a', 'b'], var_name='variable', value_name='value')
```

## Datetime

```python
pd.to_datetime('2024-01-01')
pd.to_datetime(df['date_col'], format='%Y-%m-%d')
pd.date_range('2024-01-01', periods=10, freq='D')

df['date'].dt.year
df['date'].dt.month
df['date'].dt.day
df['date'].dt.weekday
df['date'].dt.hour
df['date'].dt.strftime('%Y-%m')

df.set_index('date').resample('M').mean()
```

## String Operations

```python
df['col'].str.lower()
df['col'].str.upper()
df['col'].str.strip()
df['col'].str.replace('old', 'new')
df['col'].str.contains('pattern')
df['col'].str.startswith('prefix')
df['col'].str.endswith('suffix')
df['col'].str.split(',', expand=True)
df['col'].str.extract(r'(\d+)')
df['col'].str.len()
```

## Memory Optimization

```python
df['cat_col'] = df['cat_col'].astype('category')
pd.to_numeric(df['col'], downcast='integer')
pd.to_numeric(df['col'], downcast='float')
df['col'] = df['col'].astype('int8')  # or int16, int32
```

## Multi-Index

```python
df.set_index(['col1', 'col2'], inplace=True)
df.reset_index()
df.swaplevel(0, 1)
df.sort_index(level=0)
df.xs('value', level='col1')
df.loc[('val1', 'val2')]
```

## Sorting

```python
df.sort_values('col', ascending=False)
df.sort_values(['col1', 'col2'], ascending=[True, False])
df.sort_index()
```

## Filtering

```python
df.query('age > 30 and sex == "male"')
df.filter(items=['col1', 'col2'])
df.filter(regex='pattern')
df['col'].between(10, 20)
df['col'].isin(['a', 'b'])
df.duplicated()
df.drop_duplicates(subset=['col'])
```

## I/O Performance Tips

- Use `pd.read_csv(engine='pyarrow')` for large files (pandas 2.0+)
- Use `pd.read_parquet()` for fast columnar storage
- Use `usecols` to read only needed columns
- Use `chunksize` to process large files iteratively

## Common Gotchas

- `.loc` includes end index; `.iloc` excludes it
- `df['col'].isna()` vs `df['col'] == np.nan` (always False)
- SettingWithCopyWarning → use `.loc` for assignment
- `inplace=True` is deprecated in many future versions
