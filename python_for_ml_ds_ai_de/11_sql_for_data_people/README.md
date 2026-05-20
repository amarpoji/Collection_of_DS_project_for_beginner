# Module 11: SQL for Data People

**Duration:** 16 hours

## Overview

SQL (Structured Query Language) is an essential skill for data scientists and ML practitioners. Most real-world data lives in relational databases, and the ability to query, join, and aggregate data directly in SQL is critical. This module bridges the gap between SQL and pandas, teaching you to think in both paradigms. The ML focus is on feature extraction from relational databases.

## Learning Objectives

By the end of this module, you will be able to:
- Understand why SQL matters for data science and ML
- Set up and query SQLite databases from Python using `sqlite3`
- Write SELECT queries with filtering, ordering, and limits
- Perform all types of JOINs (INNER, LEFT, RIGHT, FULL)
- Use GROUP BY with aggregation functions
- Write subqueries and Common Table Expressions (CTEs)
- Apply window functions (ROW_NUMBER, RANK, LAG)
- Compare SQL and pandas syntax for common operations
- Extract features from relational databases for ML

## Prerequisites

- Python fundamentals
- Basic pandas (read_sql)
- Understanding of tabular data

## Topics

### 1. Why SQL for Data Science?
- Prevalence of relational databases in industry
- SQL vs pandas: strengths and weaknesses
- When to use SQL vs Python for data manipulation
- Performance considerations

### 2. SQLite in Python
- Setting up SQLite with `sqlite3`
- Creating databases and tables
- Inserting data programmatically
- Connection management and best practices
- Using `pd.read_sql()` to query into DataFrames

### 3. SELECT and WHERE
- Basic SELECT queries
- Filtering with WHERE (AND, OR, IN, BETWEEN, LIKE)
- DISTINCT and aliases
- ORDER BY and LIMIT
- Logical operator precedence

### 4. GROUP BY and Aggregation
- Aggregate functions: COUNT, SUM, AVG, MIN, MAX
- GROUP BY with HAVING
- Multiple aggregations
- GROUP_CONCAT for string aggregation

### 5. JOIN Operations
- INNER JOIN
- LEFT JOIN (LEFT OUTER)
- RIGHT JOIN (RIGHT OUTER)
- FULL OUTER JOIN
- Self-joins
- Multiple table joins

### 6. Subqueries
- Scalar subqueries
- Row subqueries
- Table subqueries (derived tables)
- Correlated vs non-correlated subqueries
- EXISTS and NOT EXISTS

### 7. Common Table Expressions (CTEs)
- WITH clause syntax
- Recursive CTEs
- CTEs for readability and performance
- Multiple CTEs in a single query

### 8. Window Functions
- ROW_NUMBER(), RANK(), DENSE_RANK()
- LAG() and LEAD() for time-series
- SUM() OVER() for running totals
- PARTITION BY clause
- Frame specification (ROWS BETWEEN)

### 9. Pandas vs SQL Comparison
- Equivalent operations in both paradigms
- GroupBy in pandas vs SQL
- Merge/Join comparison
- Window functions in pandas
- Performance benchmarking

### 10. ML Focus: Feature Extraction from Relational Databases
- Designing queries for feature creation
- Aggregating historical data as features
- Time-based features from event tables
- Joining user profiles with behavioral data
- Creating training datasets from relational schemas

## Practice Questions

1. Create a SQLite database with tables: passengers, tickets, and survival_records. Insert sample data.
2. Write a query to find all passengers who survived and were in first class.
3. Calculate the survival rate by passenger class using GROUP BY.
4. Use a LEFT JOIN to find passengers without ticket records.
5. Write a CTE to compute average age per class, then select passengers older than their class average.
6. Use ROW_NUMBER() to find the top 3 most expensive tickets per passenger class.
7. Write a subquery to find passengers with fare above the overall average.
8. Use LAG() to compute the fare difference between consecutive passengers (ordered by fare).
9. Replicate a pandas groupby+agg operation in a single SQL query.
10. Design a feature extraction query that joins passenger demographics with ticket purchase history.

## Interview Questions

1. **What is the difference between WHERE and HAVING?**
   - WHERE filters rows before GROUP BY. HAVING filters groups after aggregation. HAVING can reference aggregate functions; WHERE cannot.

2. **Explain INNER JOIN vs LEFT JOIN with examples.**
   - INNER JOIN returns only matching rows from both tables. LEFT JOIN returns all rows from the left table and matching rows from the right (NULL for non-matches).

3. **What are window functions and when would you use them?**
   - Window functions perform calculations across rows related to the current row without collapsing groups. Used for running totals, rankings, and time-series analysis (LAG/LEAD).

4. **How do subqueries differ from CTEs?**
   - Subqueries can be used inline (in SELECT, FROM, WHERE). CTEs (WITH clause) are named temporary result sets that improve readability and can be referenced multiple times. CTEs can be recursive; subqueries cannot.

5. **What is the performance difference between SQL and pandas for large datasets?**
   - SQL databases use indexes and query optimizers, often outperforming pandas for large data. Pandas is constrained by RAM. For datasets under ~10GB, pandas is often faster for iterative analysis.

6. **Explain RANK() vs DENSE_RANK() vs ROW_NUMBER().**
   - ROW_NUMBER(): unique sequential number, no ties. RANK(): same rank for ties, gaps in sequence. DENSE_RANK(): same rank for ties, no gaps.

7. **How would you extract time-based features from an events table using SQL?**
   - Use aggregate functions with GROUP BY on time periods (e.g., COUNT of events per user per week). Use DATE_TRUNC for bucketing. Use LAG/LEAD for time between events.

8. **What is a self-join and when is it useful?**
   - Joining a table with itself (aliased differently). Useful for hierarchical data (employees/managers), pairwise comparisons, and sequential analysis.

9. **How do you handle NULLs in SQL aggregations?**
   - NULLs are ignored by aggregate functions (COUNT, SUM, AVG). COALESCE or IFNULL can replace NULLs. Use IS NULL/IS NOT NULL for filtering.

10. **How would you create an ML training dataset from multiple relational tables?**
    - Use JOINs to combine entity tables (users, products) with event/behavior tables. Use GROUP BY to aggregate events into features. Use window functions for time-based features. Materialize as a view or export to CSV.

## Common Pitfalls

1. **NULL comparisons**: `NULL = NULL` is always false. Use `IS NULL` instead of `= NULL`.
2. **Missing indexing**: Queries on large tables without indexes are slow. Always index join keys and filter columns.
3. **Ambiguous column names**: Always use table aliases when joining tables with same-named columns.
4. **SELECT ***: Avoid SELECT * in production; explicitly list columns for clarity and performance.
5. **Forgetting GROUP BY**: Any non-aggregated column in SELECT must be in GROUP BY (unless you want non-standard behavior).
6. **HAVING misuse**: Don't use HAVING for non-aggregated filters; use WHERE (better performance).
7. **Cartesian joins**: Forgetting JOIN conditions creates every pair of rows.
8. **SQL injection**: Never use string formatting for user input. Use parameterized queries (`?` placeholders).

## Resources

- [SQLite documentation](https://www.sqlite.org/docs.html)
- [Mode Analytics SQL Tutorial](https://mode.com/sql-tutorial/)
- [SQL Tutorial (W3Schools)](https://www.w3schools.com/sql/)
- [Pandas vs SQL comparison](https://pandas.pydata.org/docs/getting_started/comparison/comparison_with_sql.html)

## Next Module

Module 12: Data Cleaning & EDA — Master data quality assessment and exploratory analysis for ML.
