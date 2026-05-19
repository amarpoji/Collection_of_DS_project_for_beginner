# Lesson 15: CTEs — Common Table Expressions

## Why CTEs?

CTEs (Common Table Expressions) let you name a subquery and reference it like a temporary view within a single query. They make complex queries readable, reusable, and easier to debug.

CTEs are defined with the `WITH` keyword and exist **only for the duration of the query**.

---

## 1. Basic CTE — WITH ... AS

### Syntax
```sql
WITH cte_name AS (
    SELECT ...
)
SELECT ...
FROM cte_name;
```

### Example: Find top 5 products by revenue

```sql
WITH product_revenue AS (
    SELECT p.product_id,
           p.product_name,
           p.category,
           ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id
)
SELECT product_name, category, revenue
FROM product_revenue
ORDER BY revenue DESC
LIMIT 5;
```

**Expected output**
```
product_name|category|revenue
Standing Desk|Furniture|4803.75
Noise Canceling Headphones|Electronics|1270.74
27-inch Monitor|Electronics|960.49
Cable Organizer|Accessories|469.53
Notebook Set|Accessories|450.0
```

---

## 2. Multiple CTEs in One Query

You can define several CTEs, separated by commas. Later CTEs can reference earlier ones.

### Example: Multi-step sales analysis

```sql
WITH
    product_sales AS (
        SELECT p.product_id, p.product_name, p.category,
               SUM(oi.quantity) AS units_sold,
               ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
        FROM products p
        JOIN order_items oi ON p.product_id = oi.product_id
        GROUP BY p.product_id
    ),
    category_summary AS (
        SELECT category,
               COUNT(*) AS product_count,
               ROUND(SUM(revenue), 2) AS category_revenue,
               ROUND(AVG(revenue), 2) AS avg_product_revenue
        FROM product_sales
        GROUP BY category
    )
SELECT category, product_count, category_revenue, avg_product_revenue
FROM category_summary
ORDER BY category_revenue DESC;
```

**Expected output**
```
category|product_count|category_revenue|avg_product_revenue
Furniture|1|4803.75|4803.75
Electronics|6|3356.55|559.43
Accessories|5|1318.31|263.66
```

---

## 3. CTE vs Subquery Comparison

### Without CTE (nested subquery — harder to read)

```sql
SELECT department, employee, salary
FROM (
    SELECT d.department_name AS department,
           e.first_name || ' ' || e.last_name AS employee,
           e.salary,
           ROW_NUMBER() OVER (
               PARTITION BY e.department_id ORDER BY e.salary DESC
           ) AS rn
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
)
WHERE rn <= 2
ORDER BY department, rn;
```

### With CTE (much cleaner)

```sql
WITH ranked_employees AS (
    SELECT d.department_name AS department,
           e.first_name || ' ' || e.last_name AS employee,
           e.salary,
           ROW_NUMBER() OVER (
               PARTITION BY e.department_id ORDER BY e.salary DESC
           ) AS rn
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
)
SELECT department, employee, salary
FROM ranked_employees
WHERE rn <= 2
ORDER BY department, rn;
```

**Expected output**
```
department|employee|salary
Data & Analytics|Bob Johnson|110000.0
Data & Analytics|Edward Norton|100000.0
Engineering|George Harris|200000.0
Engineering|Jane Doe|95000.0
Human Resources|Julia Roberts|78000.0
Marketing|Diana Prince|85000.0
Marketing|Hannah Martin|60000.0
Product|Alice Williams|105000.0
Product|Fiona Apple|80000.0
Sales|Michael Jordan|130000.0
Sales|Laura Wilson|70000.0
```

---

## 4. CTEs for Running Calculations

### Example: Running total of orders by customer

```sql
WITH ordered_orders AS (
    SELECT customer_id, order_date, total_amount,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id ORDER BY order_date
           ) AS order_seq
    FROM orders
    WHERE status != 'Cancelled'
)
SELECT customer_id, order_seq, order_date, total_amount,
       ROUND(SUM(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ), 2) AS running_total
FROM ordered_orders
WHERE customer_id IN (1, 2)
ORDER BY customer_id, order_seq;
```

**Expected output**
```
customer_id|order_seq|order_date|total_amount|running_total
1|1|2024-01-05|125.99|125.99
1|2|2024-01-20|199.99|325.98
1|3|2024-03-10|89.99|415.97
1|4|2024-05-03|275.5|691.47
2|1|2024-01-07|89.5|89.5
2|2|2024-02-01|150.0|239.5
```

---

## 5. Recursive CTEs (Advanced)

SQLite supports recursive CTEs for walking hierarchies or generating sequences.

### Example: Generate a date series

```sql
WITH RECURSIVE dates(date) AS (
    SELECT DATE('2024-01-01')
    UNION ALL
    SELECT DATE(date, '+1 day')
    FROM dates
    WHERE date < '2024-01-10'
)
SELECT date FROM dates;
```

**Expected output**
```
date
2024-01-01
2024-01-02
2024-01-03
2024-01-04
2024-01-05
2024-01-06
2024-01-07
2024-01-08
2024-01-09
2024-01-10
```

### Example: Employee hierarchy (manager → reports)

```sql
WITH RECURSIVE org_chart AS (
    -- Anchor: top-level managers (string 'NULL' means no manager)
    SELECT employee_id, first_name || ' ' || last_name AS employee,
           manager_id, 0 AS level
    FROM employees
    WHERE manager_id = 'NULL'
    
    UNION ALL
    
    -- Recursive: employees reporting to those above
    SELECT e.employee_id, e.first_name || ' ' || e.last_name,
           e.manager_id, oc.level + 1
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT employee, level
FROM org_chart
ORDER BY level, employee;
```

**Expected output**
```
employee|level
George Harris|0
John Smith|0
Julia Roberts|0
Michael Jordan|0
Alice Williams|1
Bob Johnson|1
Diana Prince|1
Jane Doe|1
Laura Wilson|1
Charlie Brown|2
Edward Norton|2
Fiona Apple|2
Hannah Martin|2
Kevin Bacon|2
Ian Clark|3
```

---

## 6. When to Use CTEs

| Scenario | Use CTE? | Why |
|----------|----------|-----|
| Same subquery used multiple times | ✅ | Write once, reference twice |
| Multi-step data pipeline | ✅ | Each step is a named CTE |
| Recursive hierarchy (org chart, tree) | ✅ | RECURSIVE CTE is the only way |
| Simple one-off filter | ❌ | Subquery or WHERE is fine |
| Subquery used once, short | ❌ | No readability gain |
| Need performance with large data | ⚠️ | CTEs may materialize differently per DB |

---

## Exercises

1. **Top products per category** — Use a CTE to rank products by revenue within each category. Show category, product_name, revenue, and rank. Only return the top 2 per category.

2. **Customer order frequency** — Create a CTE that counts orders per customer. Then use it to find customers who have placed more than 3 orders. Show customer name and order count.

3. **Department salary analysis** — Create two CTEs: (1) `dept_avg` — average salary per department, (2) `dept_stats` — min, max, avg salary per department. Then show department name and all three stats.

4. **Compare employee salary to dept average** — Use a CTE to compute the average salary per department. Then in the main query, join it back to show each employee's salary vs their department's average.

5. **Running total by day** — Use a CTE with a window function to calculate a running total of revenue day by day. Show order_date and cumulative_revenue.

---

## 🔥 Mini Challenges

1. **Recursive CTE for date gaps** — Generate a complete date series for January 2024. LEFT JOIN it with daily order counts to find days with no orders. Show all dates and whether an order was placed.

2. **Multi-CTE pipeline** — Build a pipeline with 3 CTEs: (1) `customer_orders` — join customers + orders, (2) `customer_totals` — aggregate per customer, (3) `top_customers` — find top 3. The final query should show rank, customer name, total spent, and order count.
