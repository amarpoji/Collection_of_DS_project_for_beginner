# SQL for Data People — Cheatsheet

## Python Setup
```python
import sqlite3
import pandas as pd

# Connect (creates file if not exists)
conn = sqlite3.connect('database.db')

# Create cursor
cur = conn.cursor()

# Execute SQL
cur.execute('SELECT * FROM table')
rows = cur.fetchall()  # or fetchone(), fetchmany(5)

# Direct to DataFrame
df = pd.read_sql('SELECT * FROM table', conn)

# Parameterized query (safe from SQL injection)
cur.execute('SELECT * FROM users WHERE age > ?', (25,))

# Commit and close
conn.commit()
conn.close()
```

## CREATE / INSERT / UPDATE / DELETE

```sql
-- Create table
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    age INTEGER,
    email TEXT UNIQUE,
    created_at DATE DEFAULT CURRENT_DATE
);

-- Insert
INSERT INTO users (name, age, email) VALUES ('Alice', 30, 'alice@example.com');
INSERT INTO users VALUES (2, 'Bob', 25, 'bob@example.com', '2024-01-15');

-- Update
UPDATE users SET age = 31 WHERE name = 'Alice';

-- Delete
DELETE FROM users WHERE age < 18;

-- Drop
DROP TABLE IF EXISTS users;
```

## SELECT
```sql
-- Basic
SELECT col1, col2 FROM table;

-- All columns
SELECT * FROM table;

-- Distinct
SELECT DISTINCT col FROM table;

-- Aliases
SELECT col AS alias FROM table;

-- Calculated
SELECT col1 + col2 AS sum_col FROM table;
```

## WHERE Filtering
```sql
SELECT * FROM table
WHERE col1 = 'value'
  AND col2 > 100
  OR col3 IN ('a', 'b', 'c')
  AND col4 BETWEEN 10 AND 20
  AND col5 LIKE '%pattern%'
  AND col6 IS NOT NULL;

-- IN with subquery
WHERE id IN (SELECT id FROM other_table);
```

## ORDER BY & LIMIT
```sql
SELECT * FROM table
ORDER BY col1 ASC, col2 DESC
LIMIT 10
OFFSET 5;
```

## GROUP BY & Aggregation
```sql
SELECT col1, COUNT(*) AS cnt, AVG(col2) AS avg_val,
       SUM(col3) AS total, MIN(col4), MAX(col5)
FROM table
WHERE condition
GROUP BY col1
HAVING COUNT(*) > 5
ORDER BY cnt DESC;

-- Multiple aggregations
SELECT category,
       COUNT(*) AS count,
       ROUND(AVG(price), 2) AS avg_price,
       SUM(quantity) AS total_qty
FROM products
GROUP BY category;
```

## JOINs
```sql
-- INNER JOIN
SELECT t1.col, t2.col
FROM table1 t1
INNER JOIN table2 t2 ON t1.id = t2.fk_id;

-- LEFT JOIN
SELECT t1.*, t2.col
FROM customers t1
LEFT JOIN orders t2 ON t1.id = t2.customer_id;

-- RIGHT JOIN (not supported in SQLite -- reverse order)
SELECT t1.*, t2.*
FROM orders t2
RIGHT JOIN customers t1 ON t1.id = t2.customer_id;

-- FULL OUTER JOIN (not supported in SQLite -- use LEFT + UNION + LEFT)
SELECT * FROM t1 LEFT JOIN t2 ON t1.id = t2.id
UNION
SELECT * FROM t1 RIGHT JOIN t2 ON t1.id = t2.id;

-- Self-join
SELECT e1.name AS employee, e2.name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.id;

-- Multiple joins
SELECT *
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN products p ON o.product_id = p.id;
```

## Subqueries
```sql
-- Scalar subquery (in SELECT)
SELECT name, (SELECT AVG(price) FROM products) AS avg_price
FROM products;

-- In WHERE
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Derived table (in FROM)
SELECT t.category, t.avg_price
FROM (SELECT category, AVG(price) AS avg_price
      FROM products GROUP BY category) t
WHERE t.avg_price > 50;

-- EXISTS
SELECT * FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);
```

## CTEs (Common Table Expressions)
```sql
-- Basic CTE
WITH avg_salary AS (
    SELECT department, AVG(salary) AS avg_sal
    FROM employees GROUP BY department
)
SELECT e.name, e.salary, a.avg_sal
FROM employees e
JOIN avg_salary a ON e.department = a.department
WHERE e.salary > a.avg_sal;

-- Multiple CTEs
WITH
dept_stats AS (
    SELECT department, COUNT(*) AS emp_count, AVG(salary) AS avg_sal
    FROM employees GROUP BY department
),
top_depts AS (
    SELECT department FROM dept_stats WHERE emp_count > 10
)
SELECT * FROM employees WHERE department IN (SELECT * FROM top_depts);

-- Recursive CTE (hierarchy)
WITH RECURSIVE org_tree AS (
    SELECT id, name, manager_id, 1 AS level
    FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id, e.name, e.manager_id, t.level + 1
    FROM employees e JOIN org_tree t ON e.manager_id = t.id
)
SELECT * FROM org_tree;
```

## Window Functions
```sql
-- ROW_NUMBER
SELECT name, salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
FROM employees;

-- RANK and DENSE_RANK
SELECT name, department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS overall_dense_rank
FROM employees;

-- LAG and LEAD
SELECT date, revenue,
       LAG(revenue, 1) OVER (ORDER BY date) AS prev_day_revenue,
       LEAD(revenue, 1) OVER (ORDER BY date) AS next_day_revenue,
       revenue - LAG(revenue) OVER (ORDER BY date) AS daily_change
FROM daily_sales;

-- Running total
SELECT date, revenue,
       SUM(revenue) OVER (ORDER BY date) AS running_total
FROM daily_sales;

-- Moving average (3-day)
SELECT date, revenue,
       AVG(revenue) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS ma_3
FROM daily_sales;

-- FIRST_VALUE, LAST_VALUE, NTH_VALUE
SELECT name, salary,
       FIRST_VALUE(name) OVER (ORDER BY salary DESC) AS highest_paid,
       NTH_VALUE(name, 2) OVER (ORDER BY salary DESC) AS second_highest
FROM employees;
```

## Pandas vs SQL Equivalents

| SQL | Pandas |
|-----|--------|
| `SELECT * FROM t` | `df` |
| `SELECT col FROM t` | `df['col']` |
| `WHERE col > 5` | `df[df['col'] > 5]` |
| `GROUP BY col` | `df.groupby('col')` |
| `COUNT(*)` | `.size()` or `.count()` |
| `HAVING COUNT(*) > 5` | `.filter(lambda x: len(x) > 5)` |
| `ORDER BY col DESC` | `df.sort_values('col', ascending=False)` |
| `LIMIT 10` | `df.head(10)` |
| `INNER JOIN` | `pd.merge(how='inner')` |
| `LEFT JOIN` | `pd.merge(how='left')` |
| `UNION` | `pd.concat()` |
| `ROW_NUMBER()` | `df.groupby(...).cumcount()` |
| `LAG(col)` | `df['col'].shift(1)` |
| `SUM() OVER()` | `df['col'].cumsum()` |

## Useful SQLite-Specific
```sql
-- Date/time functions
SELECT DATE('now');
SELECT DATETIME('now');
SELECT STRFTIME('%Y-%m-%d', 'now');
SELECT DATE('2024-01-01', '+7 days', '+1 month');

-- String functions
SELECT UPPER(name), LOWER(name), LENGTH(name),
       SUBSTR(name, 1, 3), TRIM(name)
FROM users;

-- Type conversion
SELECT CAST('123' AS INTEGER);
SELECT typeof(column) FROM table;

-- Create index
CREATE INDEX idx_name ON table(col);
CREATE UNIQUE INDEX idx_unique ON table(col1, col2);
```

## Performance Tips
- Use EXPLAIN QUERY PLAN to check query efficiency
- Index foreign keys used in JOINs
- Prefer WHERE over HAVING for row filters
- Use EXISTS instead of IN for large subqueries
- Limit columns in SELECT (avoid SELECT *)
- Use LIMIT for pagination; avoid OFFSET on large tables
