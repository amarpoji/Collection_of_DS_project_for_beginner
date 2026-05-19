# Advanced SQL Exercises — Complete Solutions

Database: `sql_mastery.db`

---

## Advanced Window Functions (Lessons 17, 24)

---

### Exercise 1 — Revenue Contribution by Category (Percent of Total)

**Question:** Using SUM() OVER() without a PARTITION BY, calculate each product's revenue as a percentage of total company revenue. Show product_name, category, revenue, pct_of_total. Round to 2 decimal places.

**Solution:**

```sql
SELECT p.product_name,
       p.category,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
       ROUND(SUM(oi.quantity * oi.unit_price) * 100.0 /
             SUM(SUM(oi.quantity * oi.unit_price)) OVER(), 2) AS pct_of_total
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY revenue DESC;
```

**Expected Output (top 5):**

| product_name               | category     | revenue | pct_of_total |
|---------------------------|-------------|---------|--------------|
| Standing Desk             | Furniture   | 4803.75 | 50.68        |
| Noise Canceling Headphones| Electronics | 1270.74 | 13.41        |
| 27-inch Monitor           | Electronics | 960.49  | 10.13        |
| Cable Organizer           | Accessories | 469.53  | 4.95         |
| Notebook Set              | Accessories | 450.00  | 4.75         |

**Explanation:** SUM() OVER() without PARTITION BY computes the grand total across all rows. Each product's revenue is divided by this grand total to find percentage contribution. The Standing Desk alone accounts for 50.68% of all company revenue — a critical product to protect.

---

### Exercise 2 — Customer Order Gap Analysis

**Question:** For each customer, use LAG() to calculate days between consecutive orders. Show customer_id, order_id, order_date, previous_order_date, days_gap. Only show gaps > 14 days. Order by days_gap DESC.

**Solution:**

```sql
SELECT customer_id,
       order_id,
       order_date,
       previous_order_date,
       days_gap
FROM (
    SELECT customer_id,
           order_id,
           order_date,
           LAG(order_date) OVER (
               PARTITION BY customer_id ORDER BY order_date
           ) AS previous_order_date,
           CAST(julianday(order_date) - julianday(LAG(order_date) OVER (
               PARTITION BY customer_id ORDER BY order_date
           )) AS INTEGER) AS days_gap
    FROM orders
) sub
WHERE days_gap > 14
ORDER BY days_gap DESC;
```

**Expected Output (top 5):**

| customer_id | order_id | order_date | previous_order_date | days_gap |
|------------|---------|-----------|-------------------|----------|
| 7          | 1038    | 2024-04-10| 2024-01-22        | 79       |
| 10         | 1041    | 2024-04-18| 2024-02-03        | 75       |
| 12         | 1042    | 2024-04-20| 2024-02-08        | 72       |
| 16         | 1046    | 2024-05-01| 2024-02-20        | 71       |
| 4          | 1043    | 2024-04-22| 2024-02-22        | 60       |

**Explanation:** LAG retrieves the previous order date. JULIANDAY difference gives days between orders. The subquery filters for gaps > 14 days (roughly 2 weeks). Customer 7 (Sophia Brown) has the longest gap at 79 days — a potential churn risk since she's also marked inactive.

---

### Exercise 3 — Rolling 90th Percentile Threshold

**Question:** Using NTILE(10) over a sliding window of 20 orders (ROWS BETWEEN 19 PRECEDING AND CURRENT ROW), identify orders in the top 10%. Show order_id, total_amount, and flag 'High Value' or 'Normal'.

**Solution:**

```sql
SELECT order_id,
       total_amount,
       NTILE(10) OVER (ORDER BY total_amount) AS decile,
       CASE WHEN NTILE(10) OVER (ORDER BY total_amount) = 10
            THEN 'High Value' ELSE 'Normal'
       END AS value_flag
FROM orders;
```

**Expected Output (top decile only):**

| order_id | total_amount | decile | value_flag |
|---------|-------------|-------|------------|
| 1009    | 420.00      | 10    | High Value |
| 1036    | 430.00      | 10    | High Value |
| 1021    | 445.00      | 10    | High Value |
| 1016    | 500.00      | 10    | High Value |
| 1039    | 520.00      | 10    | High Value |

**Explanation:** NTILE(10) divides the ordered data into 10 equal buckets. The 10th decile represents the top 10% highest-value orders. All 5 orders in the top decile exceed $400. Note: SQLite doesn't support ROWS BETWEEN with NTILE, so we use ORDER BY total_amount.

---

### Exercise 4 — First Purchase vs Repeat Purchase Metrics

**Question:** For each customer, use FIRST_VALUE() to get their first order amount. Show customer_id, order_id, order_date, total_amount, first_order_amount, and `above_first` ('Yes'/'No').

**Solution:**

```sql
SELECT customer_id,
       order_id,
       order_date,
       total_amount,
       FIRST_VALUE(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ) AS first_order_amount,
       CASE WHEN total_amount > FIRST_VALUE(total_amount) OVER (
                PARTITION BY customer_id ORDER BY order_date
            ) THEN 'Yes' ELSE 'No'
       END AS above_first
FROM orders
ORDER BY customer_id, order_date;
```

**Expected Output (sample):**

| customer_id | order_id | order_date | total_amount | first_order_amount | above_first |
|------------|---------|-----------|-------------|-------------------|-------------|
| 1          | 1001    | 2024-01-05| 125.99      | 125.99            | No          |
| 1          | 1007    | 2024-01-20| 199.99      | 125.99            | Yes         |
| 1          | 1026    | 2024-03-10| 89.99       | 125.99            | No          |
| 1          | 1047    | 2024-05-03| 275.50      | 125.99            | Yes         |
| 3          | 1003    | 2024-01-10| 249.99      | 249.99            | No          |
| 3          | 1036    | 2024-04-05| 430.00      | 249.99            | Yes         |

**Explanation:** FIRST_VALUE returns the first value in the ordered partition. By ordering by order_date ascending, the first row per customer is their first order. This helps identify whether customers increase or decrease their spending over time.

---

### Exercise 5 — Department Salary Compression Analysis

**Question:** Calculate spread between highest and lowest salary in each department. Show department_name, lowest_salary, highest_salary, spread, and ratio. Order by spread DESC.

**Solution:**

```sql
SELECT d.department_name,
       ROUND(MIN(e.salary), 0) AS lowest_salary,
       ROUND(MAX(e.salary), 0) AS highest_salary,
       ROUND(MAX(e.salary) - MIN(e.salary), 0) AS spread,
       ROUND(MAX(e.salary) * 1.0 / MIN(e.salary), 2) AS ratio
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(*) >= 2
ORDER BY spread DESC;
```

**Expected Output:**

| department_name   | lowest_salary | highest_salary | spread   | ratio |
|------------------|--------------|---------------|----------|-------|
| Engineering      | 65000        | 200000        | 135000   | 3.08  |
| Sales            | 70000        | 130000        | 60000    | 1.86  |
| Data & Analytics | 55000        | 110000        | 55000    | 2.00  |
| Product          | 80000        | 105000        | 25000    | 1.31  |
| Marketing        | 60000        | 85000         | 25000    | 1.42  |

**Explanation:** Spread = max_salary - min_salary. Ratio = max_salary / min_salary. Engineering has the highest spread ($135K) and ratio (3.08x), driven by the CTO's $200K salary versus a Junior Developer's $65K. Product has the tightest spread ($25K, ratio 1.31), suggesting more equitable pay.

---

## Query Optimization (Lesson 18)

---

### Exercise 6 — EXPLAIN QUERY PLAN: JOIN Strategies

**Question:** Write three queries finding customers who ordered 'Standing Desk' (product_id=7): subquery with IN, EXISTS, and JOIN. Run EXPLAIN QUERY PLAN on each.

**Solution:**

```sql
-- Approach 1: Subquery with IN
EXPLAIN QUERY PLAN
SELECT * FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders
    WHERE order_id IN (
        SELECT order_id FROM order_items WHERE product_id = 7
    )
);

-- Approach 2: EXISTS
EXPLAIN QUERY PLAN
SELECT * FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id
    AND EXISTS (
        SELECT 1 FROM order_items oi
        WHERE oi.order_id = o.order_id AND oi.product_id = 7
    )
);

-- Approach 3: JOIN
EXPLAIN QUERY PLAN
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.product_id = 7;
```

**Expected Output:** The JOIN approach typically uses indexes efficiently and avoids nested subquery execution. The IN approach may materialize the subquery results first. EXISTS can short-circuit early.

**Explanation:** For well-indexed databases (which ours is: idx_orders_customer, idx_order_items_product), the JOIN and EXISTS approaches are usually most efficient. The IN approach creates intermediate result sets. All three produce the same results — customers who purchased Standing Desk.

---

### Exercise 7 — Index Analysis

**Question:** Create an index, run EXPLAIN QUERY PLAN, drop the index, run again. Compare.

**Solution:**

```sql
-- Create composite index
CREATE INDEX IF NOT EXISTS idx_orders_date_status ON orders(order_date, status);

-- Run with index
EXPLAIN QUERY PLAN
SELECT order_date, total_amount FROM orders
WHERE order_date >= '2024-03-01' AND status = 'Delivered'
ORDER BY order_date;

-- Drop index
DROP INDEX IF EXISTS idx_orders_date_status;

-- Run without index
EXPLAIN QUERY PLAN
SELECT order_date, total_amount FROM orders
WHERE order_date >= '2024-03-01' AND status = 'Delivered'
ORDER BY order_date;
```

**Explanation:** With the index, SQLite performs a "SEARCH using index" operation, directly locating the relevant rows. Without the index, SQLite performs a full table scan ("SCAN TABLE orders"), reading all 50 rows and filtering after. For small tables (50 rows), the difference is negligible. On millions of rows, the indexed query would be orders of magnitude faster.

---

### Exercise 8 — Subquery vs CTE Performance

**Question:** Write the same query using subquery and CTE approaches. Find each dept's total budget, show each employee's salary percentage of their department budget. Use EXPLAIN QUERY PLAN.

**Solution:**

```sql
-- CTE approach
EXPLAIN QUERY PLAN
WITH dept_total AS (
    SELECT department_id, SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.first_name || ' ' || e.last_name AS employee,
       e.salary,
       ROUND(e.salary * 100.0 / dt.total_salary, 2) AS pct_of_dept
FROM employees e
JOIN dept_total dt ON e.department_id = dt.department_id;

-- Subquery approach
EXPLAIN QUERY PLAN
SELECT e.first_name || ' ' || e.last_name AS employee,
       e.salary,
       ROUND(e.salary * 100.0 / (
           SELECT SUM(salary) FROM employees e2
           WHERE e2.department_id = e.department_id
       ), 2) AS pct_of_dept
FROM employees e;
```

**Explanation:** For this dataset, both approaches produce identical results with similar execution plans. The CTE approach joins after computing aggregates once. The subquery approach recalculates the department total for each row (which could be slower with more data). In practice, CTEs often optimize better because the optimizer recognizes them as materialized result sets.

---

### Exercise 9 — IN vs EXISTS Deep Dive

**Question:** Filter orders by customers from California. Write three versions (IN, EXISTS, JOIN). Run EXPLAIN QUERY PLAN. Which is most efficient?

**Solution:**

```sql
-- Version 1: IN
EXPLAIN QUERY PLAN
SELECT * FROM orders
WHERE customer_id IN (
    SELECT customer_id FROM customers WHERE state = 'CA'
);

-- Version 2: EXISTS
EXPLAIN QUERY PLAN
SELECT * FROM orders o
WHERE EXISTS (
    SELECT 1 FROM customers c
    WHERE c.customer_id = o.customer_id AND c.state = 'CA'
);

-- Version 3: JOIN
EXPLAIN QUERY PLAN
SELECT o.*
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.state = 'CA';
```

**Explanation:** For SQLite's query planner, the JOIN version often produces the simplest plan (SEARCH both tables using indexes). EXISTS can also be efficient as it supports semi-join optimization. IN with a subquery may materialize the inner result first. For this dataset, all three are fast, but in general: JOIN > EXISTS > IN for correlated subqueries.

---

## Multi-Table Analytical Queries

---

### Exercise 10 — Monthly Retention Cohort Pivot

**Question:** Build a cohort retention matrix. For each registration month, show total customers and Month 0, 1, 2, 3 active customers.

**Solution:**

```sql
SELECT strftime('%Y-%m', c.registration_date) AS cohort_month,
       COUNT(DISTINCT c.customer_id) AS total_customers,
       COUNT(DISTINCT CASE WHEN CAST(julianday(o.order_date) - julianday(c.registration_date) AS INTEGER)
                               BETWEEN 0 AND 30 THEN c.customer_id END) AS month_0,
       COUNT(DISTINCT CASE WHEN CAST(julianday(o.order_date) - julianday(c.registration_date) AS INTEGER)
                               BETWEEN 31 AND 60 THEN c.customer_id END) AS month_1,
       COUNT(DISTINCT CASE WHEN CAST(julianday(o.order_date) - julianday(c.registration_date) AS INTEGER)
                               BETWEEN 61 AND 90 THEN c.customer_id END) AS month_2,
       COUNT(DISTINCT CASE WHEN CAST(julianday(o.order_date) - julianday(c.registration_date) AS INTEGER)
                               BETWEEN 91 AND 120 THEN c.customer_id END) AS month_3
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY cohort_month
ORDER BY cohort_month;
```

**Expected Output:**

| cohort_month | total_customers | month_0 | month_1 | month_2 | month_3 |
|-------------|----------------|---------|---------|---------|---------|
| 2022-09     | 1              | 0       | 0       | 0       | 0       |
| ...         | ...            | ...     | ...     | ...     | ...     |
| 2023-03     | 2              | 0       | 0       | 0       | 0       |
| 2023-04     | 2              | 0       | 0       | 0       | 0       |

**Explanation:** The cohort matrix shows which customers placed orders within 30-day windows of their registration. All zeros indicate that customers placed their first orders well after their registration month (often months later). This is because registrations occurred in 2022-2023 but all orders are in 2024. A real cohort analysis would need a longer observation window or aligned time periods.

---

### Exercise 11 — Product Affinity Analysis (Basket Analysis)

**Question:** Find products frequently purchased together (at least 2 times). Show product pair, times_bought_together, support_pct.

**Solution:**

```sql
WITH product_pairs AS (
    SELECT oi1.product_id AS pid1,
           oi2.product_id AS pid2,
           COUNT(DISTINCT oi1.order_id) AS times_bought_together
    FROM order_items oi1
    JOIN order_items oi2 ON oi1.order_id = oi2.order_id
        AND oi1.product_id < oi2.product_id
    GROUP BY oi1.product_id, oi2.product_id
    HAVING times_bought_together >= 2
)
SELECT p1.product_name AS product_1,
       p2.product_name AS product_2,
       pp.times_bought_together,
       ROUND(pp.times_bought_together * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS support_pct
FROM product_pairs pp
JOIN products p1 ON pp.pid1 = p1.product_id
JOIN products p2 ON pp.pid2 = p2.product_id
ORDER BY times_bought_together DESC;
```

**Expected Output:**

| product_1           | product_2       | times_bought_together | support_pct |
|--------------------|----------------|----------------------|-------------|
| Notebook Set       | Cable Organizer| 11                   | 22.00       |
| Wireless Mouse     | Cable Organizer| 8                    | 16.00       |
| Wireless Mouse     | Notebook Set   | 6                    | 12.00       |
| Water Bottle       | Cable Organizer| 4                    | 8.00        |
| Mechanical Keyboard| Water Bottle   | 3                    | 6.00        |
| Coffee Mug         | Cable Organizer| 3                    | 6.00        |
| USB-C Hub          | Wrist Rest     | 2                    | 4.00        |
| Coffee Mug         | Water Bottle   | 2                    | 4.00        |
| Water Bottle       | Notebook Set   | 2                    | 4.00        |

**Explanation:** The self-join on order_items (oi1.product_id < oi2.product_id) finds all product pairs within the same order. Notebook Set + Cable Organizer appear in 22% of all orders — a strong cross-sell opportunity.

---

### Exercise 12 — Employee-Product Cross-Analysis

**Question:** Find which departments are responsible for products generating the most revenue. Show department_name, top product category by revenue, total_revenue.

**Solution:**

```sql
WITH dept_category_revenue AS (
    SELECT d.department_name,
           p.category,
           ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
    FROM departments d
    JOIN employees e ON d.department_id = e.department_id
    JOIN orders o ON e.employee_id IS NOT NULL  -- creative join through customers
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE c.state = (
        CASE d.department_id
            WHEN 1 THEN 'NY'  -- Data & Analytics
            WHEN 2 THEN 'CA'  -- Engineering
            WHEN 3 THEN 'NY'  -- Product
            WHEN 4 THEN 'IL'  -- Marketing
            WHEN 5 THEN 'NY'  -- HR
            WHEN 6 THEN 'CO'  -- Sales
        END
    )
    GROUP BY d.department_name, p.category
),
ranked_categories AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY department_name ORDER BY total_revenue DESC) AS rn
    FROM dept_category_revenue
)
SELECT department_name, category, total_revenue
FROM ranked_categories
WHERE rn = 1
ORDER BY total_revenue DESC;
```

**Explanation:** This creative exercise connects departments to products through geography (customers in the same state as the department's location). The assumption is that departments serve customers in their geographic area.

---

## Business Intelligence Queries (Lesson 24)

---

### Exercise 13 — Executive Dashboard: Single-Query Monthly Report

**Question:** Write a single query with CTEs and window functions producing: month, total_orders, total_revenue, cumulative_revenue, revenue_growth_pct, avg_order_value, aov_change_pct, top_category, top_category_revenue.

**Solution:**

```sql
WITH monthly_totals AS (
    SELECT strftime('%Y-%m', o.order_date) AS month,
           COUNT(DISTINCT o.order_id) AS total_orders,
           ROUND(SUM(o.total_amount), 2) AS total_revenue,
           ROUND(AVG(o.total_amount), 2) AS avg_order_value
    FROM orders o
    WHERE o.status != 'Cancelled'
    GROUP BY month
),
monthly_category AS (
    SELECT strftime('%Y-%m', o.order_date) AS month,
           p.category,
           ROUND(SUM(oi.quantity * oi.unit_price), 2) AS category_revenue,
           ROW_NUMBER() OVER (PARTITION BY strftime('%Y-%m', o.order_date)
                              ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS rn
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.status != 'Cancelled'
    GROUP BY month, p.category
),
top_category_per_month AS (
    SELECT month, category AS top_category, category_revenue AS top_category_revenue
    FROM monthly_category
    WHERE rn = 1
)
SELECT mt.month,
       mt.total_orders,
       mt.total_revenue,
       ROUND(SUM(mt.total_revenue) OVER (ORDER BY mt.month), 2) AS cumulative_revenue,
       ROUND((mt.total_revenue - LAG(mt.total_revenue) OVER (ORDER BY mt.month)) * 100.0 /
             LAG(mt.total_revenue) OVER (ORDER BY mt.month), 2) AS revenue_growth_pct,
       mt.avg_order_value,
       ROUND((mt.avg_order_value - LAG(mt.avg_order_value) OVER (ORDER BY mt.month)) * 100.0 /
             LAG(mt.avg_order_value) OVER (ORDER BY mt.month), 2) AS aov_change_pct,
       tc.top_category,
       tc.top_category_revenue
FROM monthly_totals mt
JOIN top_category_per_month tc ON mt.month = tc.month
ORDER BY mt.month;
```

**Expected Output (abbreviated):**

| month   | orders | revenue | cumulative | revenue_growth | aov | aov_change | top_category | top_cat_rev |
|---------|--------|---------|------------|---------------|-----|-----------|-------------|-------------|
| 2024-01 | 10     | 1641.97 | 1641.97    | NULL          | ... | NULL      | Furniture   | 1259.75     |
| 2024-02 | 12     | 2265.72 | 3907.69    | 37.99%        | ... | ...       | Furniture   | 1505.25     |

**Explanation:** Five CTEs work together: monthly aggregation, per-category breakdown, top category identification, and final dashboard with window functions for running totals and growth rates.

---

### Exercise 14 — Customer Lifetime Value Prediction (Simple Model)

**Question:** For each customer, calculate actual avg_order_value, monthly purchase frequency, predicted CLV (avg_order_value * frequency * 24 for active, * 1 for inactive). Show actual revenue, predicted_clv, ratio.

**Solution:**

```sql
SELECT c.first_name || ' ' || c.last_name AS customer_name,
       ROUND(AVG(o.total_amount), 2) AS avg_order_value,
       ROUND(COUNT(o.order_id) * 1.0 / MAX(1,
           CAST(julianday(MAX(o.order_date)) - julianday(MIN(o.order_date)) AS REAL) / 30.0 + 1
       ), 2) AS monthly_frequency,
       ROUND(SUM(o.total_amount), 2) AS actual_total_revenue,
       ROUND(AVG(o.total_amount) * (COUNT(o.order_id) * 1.0 / MAX(1,
           CAST(julianday(MAX(o.order_date)) - julianday(MIN(o.order_date)) AS REAL) / 30.0 + 1
       )) * CASE WHEN c.is_active = 1 THEN 24 ELSE 1 END, 2) AS predicted_clv,
       ROUND(AVG(o.total_amount) * (COUNT(o.order_id) * 1.0 / MAX(1,
           CAST(julianday(MAX(o.order_date)) - julianday(MIN(o.order_date)) AS REAL) / 30.0 + 1
       )) * CASE WHEN c.is_active = 1 THEN 24 ELSE 1 END / SUM(o.total_amount), 2) AS ratio
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY actual_total_revenue DESC;
```

**Explanation:** This CLV model uses: AOV * monthly frequency * estimated lifetime (24 months for active, 1 for inactive). Active customers with high frequency and AOV show the highest predicted CLV. The ratio compares predicted to actual — values > 1 suggest untapped potential.

---

### Exercise 15 — Anomaly Detection: Unusual Order Amounts

**Question:** Find orders where total_amount deviates from customer's normal behavior by more than 2 standard deviations.

**Solution:**

```sql
WITH customer_stats AS (
    SELECT customer_id,
           AVG(total_amount) AS avg_amount,
           SQRT(AVG(total_amount * total_amount) - AVG(total_amount) * AVG(total_amount)) AS std_amount
    FROM orders
    GROUP BY customer_id
)
SELECT o.customer_id,
       o.order_id,
       o.total_amount,
       ROUND(cs.avg_amount, 2) AS customer_avg,
       ROUND(cs.std_amount, 2) AS customer_std,
       CASE
           WHEN o.total_amount > cs.avg_amount + 2 * cs.std_amount THEN 'Anomaly High'
           WHEN o.total_amount < cs.avg_amount - 2 * cs.std_amount THEN 'Anomaly Low'
           ELSE 'Normal'
       END AS anomaly_flag
FROM orders o
JOIN customer_stats cs ON o.customer_id = cs.customer_id
WHERE cs.std_amount > 0
  AND (o.total_amount > cs.avg_amount + 2 * cs.std_amount
    OR o.total_amount < cs.avg_amount - 2 * cs.std_amount)
ORDER BY o.customer_id, o.order_date;
```

**Explanation:** Standard deviation is calculated manually using the formula: SQRT(AVG(x^2) - AVG(x)^2). Orders exceeding 2 standard deviations from a customer's personal average are flagged. This helps identify extraordinary purchases (potential fraud or big wins) and unusually small orders (possible data issues).

---

### Exercise 16 — Daily Revenue Forecasting (7-Day Moving Average)

**Question:** Create a daily revenue forecast using a 7-day moving average. Show date, actual_daily_revenue, forecast. Only show April 1 to May 31, 2024.

**Solution:**

```sql
WITH RECURSIVE dates(date) AS (
    SELECT '2024-04-01'
    UNION ALL
    SELECT DATE(date, '+1 day')
    FROM dates
    WHERE date < '2024-05-31'
),
daily_revenue AS (
    SELECT d.date,
           COALESCE(SUM(o.total_amount), 0) AS actual_daily_revenue
    FROM dates d
    LEFT JOIN orders o ON d.date = o.order_date
    GROUP BY d.date
)
SELECT date,
       actual_daily_revenue,
       ROUND(AVG(actual_daily_revenue) OVER (
           ORDER BY date
           ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ), 2) AS forecast
FROM daily_revenue
ORDER BY date;
```

**Explanation:** A recursive CTE generates the full date range. LEFT JOIN with orders fills in actual revenue (0 for no-order days). The 7-day moving average smooths daily fluctuations to produce a forecast. This is a simple forecasting model — more sophisticated approaches would use exponential smoothing or ARIMA.

---

## Database Design Challenges (Lessons 22-23)

---

### Exercise 17 — Design a Subscription Platform Schema

**Solution:**

```sql
-- 1NF: All tables have atomic columns and primary keys
-- 2NF: No partial dependencies (all tables have single-column PKs or natural keys)
-- 3NF: No transitive dependencies

-- Users table (3NF)
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    full_name TEXT NOT NULL,
    created_at TEXT DEFAULT (datetime('now'))
);

-- Plan definitions (3NF)
CREATE TABLE plans (
    plan_id INTEGER PRIMARY KEY,
    plan_name TEXT NOT NULL CHECK(plan_name IN ('Free', 'Pro', 'Enterprise')),
    monthly_price REAL NOT NULL,
    max_team_members INTEGER DEFAULT 1,
    storage_gb INTEGER DEFAULT 5
);

-- Subscriptions (3NF)
CREATE TABLE subscriptions (
    subscription_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    plan_id INTEGER NOT NULL REFERENCES plans(plan_id),
    start_date TEXT NOT NULL,
    end_date TEXT,
    auto_renew INTEGER DEFAULT 1,
    status TEXT DEFAULT 'active' CHECK(status IN ('active', 'canceled', 'expired'))
);

-- Payment methods (3NF - junction between users and payment providers)
CREATE TABLE payment_methods (
    payment_method_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    card_last_four TEXT NOT NULL,
    card_brand TEXT,
    is_default INTEGER DEFAULT 0,
    expiry_date TEXT,
    created_at TEXT DEFAULT (datetime('now'))
);

-- Invoices (3NF)
CREATE TABLE invoices (
    invoice_id INTEGER PRIMARY KEY,
    subscription_id INTEGER NOT NULL REFERENCES subscriptions(subscription_id),
    invoice_date TEXT NOT NULL,
    total_amount REAL NOT NULL,
    paid INTEGER DEFAULT 0,
    due_date TEXT
);

-- Invoice line items (usage-based charges)
CREATE TABLE invoice_line_items (
    line_item_id INTEGER PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(invoice_id),
    description TEXT NOT NULL,
    quantity INTEGER DEFAULT 1,
    unit_price REAL NOT NULL,
    total_price REAL GENERATED ALWAYS AS (quantity * unit_price) STORED
);

-- Team members (junction table for users-to-subscriptions with roles)
CREATE TABLE team_members (
    team_member_id INTEGER PRIMARY KEY,
    subscription_id INTEGER NOT NULL REFERENCES subscriptions(subscription_id),
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    role TEXT NOT NULL CHECK(role IN ('Admin', 'Member', 'Viewer')),
    joined_at TEXT DEFAULT (datetime('now')),
    UNIQUE(subscription_id, user_id)
);

-- Indexes
CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_invoices_subscription ON invoices(subscription_id);
CREATE INDEX idx_team_members_subscription ON team_members(subscription_id);
CREATE INDEX idx_payment_methods_user ON payment_methods(user_id);
```

**Explanation:** This schema is in 3NF. Each table has a single purpose. The team_members table is a junction table enabling many-to-many relationships between subscriptions and users. CHECK constraints enforce data integrity. Computed columns (generated columns) simplify invoice calculations.

---

### Exercise 18 — Normalize a Denormalized Event Log

**Solution:**

```sql
-- Original denormalized table
-- event_log(log_id, event_date, user_id, user_name, user_email, event_type,
--           event_data, ip_address, session_id, session_start, session_end,
--           device_type, device_os)

-- Normalized to 3NF:

-- Users (separate user details)
CREATE TABLE users_event (
    user_id INTEGER PRIMARY KEY,
    user_name TEXT NOT NULL,
    user_email TEXT UNIQUE NOT NULL
);

-- Sessions (session-level info)
CREATE TABLE sessions (
    session_id TEXT PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users_event(user_id),
    session_start TEXT,
    session_end TEXT,
    ip_address TEXT,
    device_type TEXT,
    device_os TEXT
);

-- Event types (reference data)
CREATE TABLE event_types (
    event_type_id INTEGER PRIMARY KEY,
    event_type_name TEXT UNIQUE NOT NULL
);

-- Events (core fact table, 3NF)
CREATE TABLE events (
    event_id INTEGER PRIMARY KEY,
    session_id TEXT NOT NULL REFERENCES sessions(session_id),
    user_id INTEGER NOT NULL REFERENCES users_event(user_id),
    event_type_id INTEGER NOT NULL REFERENCES event_types(event_type_id),
    event_date TEXT NOT NULL,
    page_path TEXT,
    duration_sec INTEGER,
    browser TEXT
);

-- Sample migration INSERT statements
INSERT INTO users_event (user_id, user_name, user_email)
SELECT DISTINCT user_id, user_name, user_email FROM event_log;

INSERT INTO event_types (event_type_name)
SELECT DISTINCT event_type FROM event_log;
```

**Explanation:** The original table violates 3NF because user_name and user_email depend on user_id (transitive dependency through the event log). session_start, session_end, device_type, device_os depend on session_id. The event_data JSON blob is split into structured columns (page_path, duration_sec, browser). This normalization reduces redundancy and improves query performance on individual dimensions.

---

### Exercise 19 — Build a Product Review System Schema

```sql
-- Products (3NF)
CREATE TABLE products_review (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT,
    manufacturer TEXT
);

-- Users (3NF)
CREATE TABLE users_review (
    user_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    join_date TEXT DEFAULT (datetime('now'))
);

-- Reviews (3NF - one review per user per product enforced by UNIQUE)
CREATE TABLE reviews (
    review_id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products_review(product_id),
    user_id INTEGER NOT NULL REFERENCES users_review(user_id),
    rating INTEGER NOT NULL CHECK(rating BETWEEN 1 AND 5),
    title TEXT,
    body TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    UNIQUE(product_id, user_id)  -- Ensures one review per user per product
);

-- Review votes (3NF - users can upvote/downvote reviews)
CREATE TABLE review_votes (
    vote_id INTEGER PRIMARY KEY,
    review_id INTEGER NOT NULL REFERENCES reviews(review_id),
    user_id INTEGER NOT NULL REFERENCES users_review(user_id),
    vote INTEGER NOT NULL CHECK(vote IN (-1, 1)),  -- -1 = downvote, 1 = upvote
    created_at TEXT DEFAULT (datetime('now')),
    UNIQUE(review_id, user_id),  -- One vote per user per review
    CHECK(user_id != (SELECT user_id FROM reviews WHERE review_id = review_votes.review_id))
    -- Prevents voting on your own review (SQLite doesn't enforce CHECK with subqueries;
    -- use a trigger in practice)
);

-- Review comments (threaded — comments can reply to other comments)
CREATE TABLE review_comments (
    comment_id INTEGER PRIMARY KEY,
    review_id INTEGER NOT NULL REFERENCES reviews(review_id),
    user_id INTEGER NOT NULL REFERENCES users_review(user_id),
    parent_comment_id INTEGER REFERENCES review_comments(comment_id),
    body TEXT NOT NULL,
    created_at TEXT DEFAULT (datetime('now'))
);

-- Review photos (each review can have multiple photos)
CREATE TABLE review_photos (
    photo_id INTEGER PRIMARY KEY,
    review_id INTEGER NOT NULL REFERENCES reviews(review_id),
    photo_url TEXT NOT NULL,
    caption TEXT,
    sort_order INTEGER DEFAULT 0
);

-- Indexes for performance
CREATE INDEX idx_reviews_product ON reviews(product_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_review_votes_review ON review_votes(review_id);
CREATE INDEX idx_review_comments_review ON review_comments(review_id);
CREATE INDEX idx_review_photos_review ON review_photos(review_id);

-- Efficient top-rated products (avg rating with minimum 5 reviews)
CREATE VIEW top_rated_products AS
SELECT p.product_id,
       p.product_name,
       ROUND(AVG(r.rating), 2) AS avg_rating,
       COUNT(*) AS review_count
FROM products_review p
JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id
HAVING COUNT(*) >= 5
ORDER BY avg_rating DESC;
```

**Explanation:** The UNIQUE(product_id, user_id) constraint ensures one review per user per product. The self-referencing parent_comment_id enables threaded comments. The CHECK constraint on review_votes prevents self-voting (though SQLite requires a trigger for enforcement since CHECK constraints can't reference other tables directly).

---

### Exercise 20 — Denormalization Trade-Off Analysis

**Solution:**

```sql
-- Denormalized e-commerce table optimized for:
-- "Find total revenue per customer by category for the last 3 months"

CREATE TABLE denormalized_sales (
    sale_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    customer_name TEXT,
    customer_city TEXT,
    customer_state TEXT,
    order_id INTEGER,
    order_date TEXT,
    product_id INTEGER,
    product_name TEXT,
    product_category TEXT,
    quantity INTEGER,
    unit_price REAL,
    line_total REAL,
    payment_method TEXT
);

-- Query against denormalized table:
SELECT customer_id,
       customer_name,
       product_category,
       SUM(line_total) AS total_revenue
FROM denormalized_sales
WHERE order_date >= DATE('now', '-3 months')
GROUP BY customer_id, product_category;

-- Equivalent query against normalized tables:
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       p.category,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_date >= DATE('now', '-3 months')
GROUP BY c.customer_id, p.category;
```

**Trade-off Analysis:**

| Aspect | Normalized | Denormalized |
|--------|-----------|-------------|
| SELECT speed | Slower (4 JOINs) | Faster (single table scan) |
| Storage | Minimal (no redundancy) | Larger (duplicated customer/product data) |
| UPDATE complexity | Simple (one place) | Complex (must update all copies) |
| INSERT complexity | Simple | Complex (duplicate data entry) |
| DELETE anomalies | No | Possible (deletion may lose related data) |
| Data integrity | Strong (FK constraints) | Weak (no constraints between copies) |
| Query complexity | Higher (JOINs needed) | Lower (flat structure) |
| Schema flexibility | High (add attributes easily) | Low (wide table, many NULLs) |

**Recommendation:** For an OLTP (transactional) system, prefer the normalized schema. For a reporting/analytics (OLAP) system with frequent SELECT and rare UPDATE, denormalization can significantly improve query performance.
