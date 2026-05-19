# Lesson 16: Window Functions Basics

## Why Window Functions?

Before window functions, ranking or running totals required complex subqueries or self-joins. Window functions let you perform calculations **across a group (window) of rows** without collapsing them into a single output row. Each row keeps its identity while gaining access to aggregate or analytic values.

---

## 1. OVER() and PARTITION BY

### Syntax
```sql
function() OVER (
    PARTITION BY column1, column2   -- groups like GROUP BY but keeps rows
    ORDER BY column3                -- ordering within each partition
    frame_specification            -- which rows in the window (RANGE, ROWS)
)
```

### What PARTITION BY Does

`PARTITION BY` divides rows into groups. The window function resets for each partition — like GROUP BY but each row stays separate.

#### Example: Show salary alongside department average

```sql
SELECT e.first_name || ' ' || e.last_name AS employee,
       d.department_name,
       e.salary,
       ROUND(AVG(e.salary) OVER (PARTITION BY e.department_id), 2) AS dept_avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, e.salary DESC;
```

**Expected output**
```
employee|department_name|salary|dept_avg_salary
Bob Johnson|Data & Analytics|110000.0|85000.0
Edward Norton|Data & Analytics|100000.0|85000.0
John Smith|Data & Analytics|75000.0|85000.0
Ian Clark|Data & Analytics|55000.0|85000.0
George Harris|Engineering|200000.0|113000.0
Jane Doe|Engineering|95000.0|113000.0
Kevin Bacon|Engineering|92000.0|113000.0
Charlie Brown|Engineering|65000.0|113000.0
Julia Roberts|Human Resources|78000.0|78000.0
Diana Prince|Marketing|85000.0|72500.0
Hannah Martin|Marketing|60000.0|72500.0
Alice Williams|Product|105000.0|92500.0
Fiona Apple|Product|80000.0|92500.0
Michael Jordan|Sales|130000.0|100000.0
Laura Wilson|Sales|70000.0|100000.0
```

---

## 2. ROW_NUMBER(), RANK(), DENSE_RANK()

These assign a numeric rank to each row within a partition.

| Function | Ties | Gap after tie? |
|----------|------|----------------|
| `ROW_NUMBER()` | Arbitrary | No ties |
| `RANK()` | Same rank | Yes (gaps) |
| `DENSE_RANK()` | Same rank | No gaps |

### Example: Rank employees by salary per department

```sql
SELECT d.department_name,
       e.first_name || ' ' || e.last_name AS employee,
       e.salary,
       ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS row_num,
       RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rank,
       DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS dense_rank
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, e.salary DESC;
```

**Expected output**
```
department_name|employee|salary|row_num|rank|dense_rank
Data & Analytics|Bob Johnson|110000.0|1|1|1
Data & Analytics|Edward Norton|100000.0|2|2|2
Data & Analytics|John Smith|75000.0|3|3|3
Data & Analytics|Ian Clark|55000.0|4|4|4
Engineering|George Harris|200000.0|1|1|1
Engineering|Jane Doe|95000.0|2|2|2
Engineering|Kevin Bacon|92000.0|3|3|3
Engineering|Charlie Brown|65000.0|4|4|4
Human Resources|Julia Roberts|78000.0|1|1|1
Marketing|Diana Prince|85000.0|1|1|1
Marketing|Hannah Martin|60000.0|2|2|2
Product|Alice Williams|105000.0|1|1|1
Product|Fiona Apple|80000.0|2|2|2
Sales|Michael Jordan|130000.0|1|1|1
Sales|Laura Wilson|70000.0|2|2|2
```

### Example: Top 3 highest-rated movies per genre

```sql
WITH ranked_movies AS (
    SELECT title, genre, rating,
           ROW_NUMBER() OVER (PARTITION BY genre ORDER BY rating DESC) AS rn
    FROM movies
)
SELECT genre, title, rating
FROM ranked_movies
WHERE rn <= 3
ORDER BY genre, rn;
```

**Expected output**
```
genre|title|rating
Action|The Dark Knight|9.0
Action|Gladiator|8.5
Action|Jurassic Park|8.2
Animation|Spirited Away|8.6
Animation|The Lion King|8.5
Animation|Coco|8.4
... (truncated)
```

---

## 3. LAG() and LEAD() — Access Adjacent Rows

`LAG(column, offset, default)` — get a value from N rows **before** the current row.
`LEAD(column, offset, default)` — get a value from N rows **after** the current row.

### Example: Compare each order to the customer's previous order

```sql
SELECT customer_id, order_id, order_date, total_amount,
       LAG(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ) AS previous_order_amount,
       ROUND(total_amount - LAG(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ), 2) AS difference
FROM orders
WHERE status != 'Cancelled'
  AND customer_id IN (1, 3, 5)
ORDER BY customer_id, order_date;
```

**Expected output**
```
customer_id|order_id|order_date|total_amount|previous_order_amount|difference
1|1001|2024-01-05|125.99|NULL|NULL
1|1007|2024-01-20|199.99|125.99|74.0
1|1026|2024-03-10|89.99|199.99|-110.0
1|1047|2024-05-03|275.5|89.99|185.51
3|1003|2024-01-10|249.99|NULL|NULL
3|1018|2024-02-18|215.0|249.99|-34.99
3|1036|2024-04-05|430.0|215.0|215.0
5|1005|2024-01-15|310.25|NULL|NULL
5|1024|2024-03-05|320.0|310.25|9.75
5|1037|2024-04-08|99.5|320.0|-220.5
```

### Example: LEAD — What's the next order's value?

```sql
SELECT customer_id, order_id, order_date, total_amount,
       LEAD(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ) AS next_order_amount
FROM orders
WHERE customer_id = 1
ORDER BY order_date;
```

**Expected output**
```
customer_id|order_id|order_date|total_amount|next_order_amount
1|1001|2024-01-05|125.99|199.99
1|1007|2024-01-20|199.99|89.99
1|1026|2024-03-10|89.99|275.5
1|1047|2024-05-03|275.5|NULL
```

---

## 4. SUM() OVER() — Running Totals

### Example: Running monthly revenue

```sql
WITH monthly_revenue AS (
    SELECT strftime('%Y-%m', order_date) AS month,
           ROUND(SUM(total_amount), 2) AS revenue
    FROM orders
    WHERE status != 'Cancelled'
    GROUP BY month
)
SELECT month, revenue,
       ROUND(SUM(revenue) OVER (ORDER BY month), 2) AS running_total
FROM monthly_revenue
ORDER BY month;
```

**Expected output**
```
month|revenue|running_total
2024-01|1515.98|1515.98
2024-02|2230.73|3746.71
2024-03|1975.74|5722.45
2024-04|2442.23|8164.68
2024-05|1112.5|9277.18
```

### Example: Running total per customer (order by order_date)

```sql
SELECT customer_id, order_date, total_amount,
       ROUND(SUM(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ), 2) AS customer_running_total
FROM orders
WHERE customer_id IN (1, 2) AND status != 'Cancelled'
ORDER BY customer_id, order_date;
```

**Expected output**
```
customer_id|order_date|total_amount|customer_running_total
1|2024-01-05|125.99|125.99
1|2024-01-20|199.99|325.98
1|2024-03-10|89.99|415.97
1|2024-05-03|275.5|691.47
2|2024-01-07|89.5|89.5
2|2024-02-01|150.0|239.5
```

---

## 5. Real Business Examples

### 5A. Employee salary rank within department

```sql
SELECT d.department_name,
       e.first_name || ' ' || e.last_name AS employee,
       e.salary,
       RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, salary_rank;
```

### 5B. Month-over-month revenue change

```sql
WITH monthly_revenue AS (
    SELECT strftime('%Y-%m', order_date) AS month,
           ROUND(SUM(total_amount), 2) AS revenue
    FROM orders
    WHERE status != 'Cancelled'
    GROUP BY month
)
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
       ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) /
              LAG(revenue) OVER (ORDER BY month) * 100, 2) AS change_pct
FROM monthly_revenue
ORDER BY month;
```

**Expected output**
```
month|revenue|prev_month_revenue|change_pct
2024-01|1515.98|NULL|NULL
2024-02|2230.73|1515.98|47.15
2024-03|1975.74|2230.73|-11.43
2024-04|2442.23|1975.74|23.62
2024-05|1112.5|2442.23|-54.44
```

### 5C. Running total of orders by shipping state

```sql
SELECT shipping_state, order_date, total_amount,
       ROUND(SUM(total_amount) OVER (
           PARTITION BY shipping_state ORDER BY order_date
       ), 2) AS state_running_total
FROM orders
WHERE status != 'Cancelled' AND shipping_state IN ('CA', 'NY')
ORDER BY shipping_state, order_date
LIMIT 8;
```

**Expected output**
```
shipping_state|order_date|total_amount|state_running_total
CA|2024-01-07|89.5|89.5
CA|2024-01-15|310.25|399.75
CA|2024-02-01|150.0|549.75
CA|2024-03-22|55.5|605.25
CA|2024-04-01|210.0|815.25
CA|2024-04-08|99.5|914.75
NY|2024-01-05|125.99|125.99
NY|2024-01-20|199.99|325.98
```

---

## Exercises

1. **Rank products by price within category** — Use ROW_NUMBER() to assign a rank to each product within its category, ordered by unit_price descending. Show category, product_name, unit_price, and rank.

2. **Employee salary vs previous employee in same department** — Use LAG() to show each employee's salary and the salary of the previous employee (by hire_date) in the same department. Show department, employee, hire_date, salary, prev_salary.

3. **Running total of movie revenue by studio** — For each studio, show movie title, revenue_millions, and a running total of revenue ordered by release_year. Use SUM() OVER(PARTITION BY studio ORDER BY release_year).

4. **Airbnb ranking by price per neighbourhood** — Within each neighbourhood, rank listings by price ascending (cheapest first). Show neighbourhood, property_name, price, and rank.

5. **Order value compare to previous order** — For customer_id = 1, show each order with its amount, the previous order's amount (using LAG), and the difference.

---

## 🔥 Mini Challenges

1. **Top 2 per group with ties** — Find the top 2 best-selling products (by revenue) in each category. Use DENSE_RANK() so if two products tie for 2nd place, both are included. Show category, product_name, revenue, and dense_rank.

2. **Three-month moving average** — Calculate a 3-month moving average of revenue. Use AVG() OVER(ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW). Show month, revenue, and moving_avg_3m.
