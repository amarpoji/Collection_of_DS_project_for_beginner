# Lesson 17: Advanced Window Functions

Window functions are one of the most powerful features of SQL. They allow you to perform calculations across sets of rows related to the current row without collapsing them into a single output row (like GROUP BY does).

## 1. Frame Specifications: ROWS, RANGE, GROUPS

The frame clause defines which rows are included in the window calculation relative to the current row.

```sql
function() OVER (
    PARTITION BY col1
    ORDER BY col2
    ROWS | RANGE | GROUPS BETWEEN frame_start AND frame_end
)
```

| Frame Type | Behavior |
|------------|----------|
| **ROWS** | Physical rows — counts actual rows regardless of values |
| **RANGE** | Logical — includes all rows with the same ORDER BY value as the current row |
| **GROUPS** | Similar to RANGE but groups by distinct ORDER BY values |

**Frame boundaries:**
- `UNBOUNDED PRECEDING` — from the start of the partition
- `n PRECEDING` — n rows/values before current
- `CURRENT ROW` — the current row
- `n FOLLOWING` — n rows/values after current
- `UNBOUNDED FOLLOWING` — to the end of partition

## 2. Running Totals

```sql
SELECT order_date, order_id, total_amount,
    SUM(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders
WHERE order_date LIKE '2024-01%';
```

Output:
```
order_date|order_id|total_amount|running_total
2024-01-05|1001|125.99|125.99
2024-01-07|1002|89.5|215.49
2024-01-10|1003|249.99|465.48
2024-01-12|1004|56.75|522.23
...
2024-01-30|1012|210.0|2154.46
```

**With PARTITION BY** — running total per department:
```sql
SELECT department_id, employee_id, name, salary,
    SUM(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS dept_running_total
FROM employees;
```

## 3. Moving Averages

A moving average smooths out short-term fluctuations. The 3-day moving average uses 2 preceding rows + current row:

```sql
SELECT order_date, order_id, total_amount,
    ROUND(AVG(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3day
FROM orders;
```

## 4. NTILE(n) — Bucketing into n Groups

NTILE divides rows into n buckets as evenly as possible.

```sql
-- Quartiles (4 buckets)
SELECT name, salary,
    NTILE(4) OVER (ORDER BY salary) AS salary_quartile
FROM employees;
```

Output:
```
name|salary|salary_quartile
Mike Brown|72000|1
John Smith|75000|1
Sara White|85000|1
Sam Green|92000|1
Jane Doe|95000|2
...            ...   ...
Grace Kim|155000|4
```

## 5. FIRST_VALUE / LAST_VALUE / NTH_VALUE

These functions retrieve values from specific positions in the window.

**Important:** Always use `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` with LAST_VALUE, otherwise it only sees rows up to the current row (default frame).

```sql
-- Lowest and highest paid per department
SELECT department_id, name, salary,
    FIRST_VALUE(name) OVER (
        PARTITION BY department_id
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_paid,
    LAST_VALUE(name) OVER (
        PARTITION BY department_id
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS highest_paid
FROM employees;
```

`NTH_VALUE(col, n)` gets the nth value in the ordered window.

## 6. PERCENT_RANK and CUME_DIST

| Function | Range | Meaning |
|----------|-------|---------|
| `PERCENT_RANK()` | 0 to 1 | (rank - 1) / (total_rows - 1) |
| `CUME_DIST()` | 0 to 1 | number of rows <= current / total_rows |

```sql
SELECT name, salary,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary), 4) AS pct_rank,
    ROUND(CUME_DIST() OVER (ORDER BY salary), 4) AS cume_dist
FROM employees
ORDER BY salary;
```

## 7. Practical Examples

### 3-Month Moving Average of Revenue

```sql
WITH monthly_revenue AS (
    SELECT strftime('%Y-%m', order_date) AS month,
           ROUND(SUM(total_amount), 2) AS revenue
    FROM orders
    GROUP BY strftime('%Y-%m', order_date)
)
SELECT month, revenue,
    ROUND(AVG(revenue) OVER (
        ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3month
FROM monthly_revenue;
```

### Employee Salary Percentile Ranking

```sql
SELECT name, department_name, salary,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary), 4) AS pct_rank,
    CASE
        WHEN PERCENT_RANK() OVER (ORDER BY salary) <= 0.25 THEN 'Bottom 25%'
        WHEN PERCENT_RANK() OVER (ORDER BY salary) <= 0.50 THEN 'Lower Middle'
        WHEN PERCENT_RANK() OVER (ORDER BY salary) <= 0.75 THEN 'Upper Middle'
        ELSE 'Top 25%'
    END AS salary_tier
FROM employees e JOIN departments d USING (department_id);
```

### Year-over-Year Growth with LAG

```sql
WITH yearly AS (
    SELECT release_year,
           ROUND(SUM(revenue_millions), 0) AS total_revenue
    FROM movies
    GROUP BY release_year
)
SELECT release_year, total_revenue,
    LAG(total_revenue) OVER (ORDER BY release_year) AS prev_year,
    CASE WHEN LAG(total_revenue) OVER (ORDER BY release_year) IS NOT NULL
         THEN ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY release_year))
                * 100.0 / LAG(total_revenue) OVER (ORDER BY release_year), 1)
         ELSE NULL
    END AS yoy_growth_pct
FROM yearly;
```

---

## Exercises

1. **NTILE(3) Salary Tiers**: Use NTILE(3) to group employees into 3 salary tiers (low/medium/high). Show name, salary, and tier number.

2. **2-Month Moving Average**: Calculate a 2-month moving average of order totals.

3. **Salary Gaps with LEAD()**: Find the salary gap between each employee and the next higher-paid employee.

4. **Top 30% with CUME_DIST**: Use CUME_DIST to find employees in the top 30% of salaries.

5. **Department Salary Contribution**: For each department, show the employee with the highest salary and what percentage that salary represents of the department's total salary.

---

🔥 **Challenge**: Using window functions, calculate a running total of movie revenue by genre ordered by release_year. Also calculate each movie's revenue as a percentage of its genre's total revenue. Show title, genre, release_year, revenue, genre_running_total, and pct_of_genre.
