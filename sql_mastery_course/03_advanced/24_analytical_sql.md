# Lesson 24: Analytical SQL for Business Intelligence

Analytical SQL transforms raw transactional data into actionable business insights. This lesson covers the patterns and techniques used in real-world business intelligence (BI) — the same queries that power dashboards, executive reports, and data-driven decisions.

## What You'll Learn

- Running totals and cumulative metrics
- Moving averages for trend identification
- Cohort analysis for customer retention
- Data pivoting with CASE + GROUP BY
- Percentile analysis with NTILE and PERCENT_RANK
- Business KPI calculations (CLV, churn, AOV)
- Time-series analysis and growth rates
- Real business case studies using our e-commerce data

---

## 1. Running Totals (Cumulative Metrics)

A running total (or rolling sum) shows the cumulative value up to each row. This is the most common window function pattern.

```sql
SELECT order_date, order_id, total_amount,
    ROUND(SUM(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS running_total
FROM orders
WHERE status != 'Cancelled'
ORDER BY order_date;
```

**Expected output** (first 5 rows):
```
order_date|order_id|total_amount|running_total
2024-01-05|1001|125.99|125.99
2024-01-07|1002|89.5|215.49
2024-01-10|1003|249.99|465.48
2024-01-12|1004|45.0|510.48
2024-01-15|1005|310.25|820.73
```

**Key insight**: The `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` frame clause tells SQL to include all rows from the start of the partition up to the current row. Without this clause, SUM(...) OVER (ORDER BY date) defaults to `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`.

---

## 2. Moving Averages

Moving averages smooth out short-term fluctuations to reveal underlying trends.

### 3-Order Moving Average

```sql
SELECT order_date, order_id, total_amount,
    ROUND(AVG(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3
FROM orders
WHERE status != 'Cancelled'
ORDER BY order_date
LIMIT 8;
```

**Expected output**:
```
order_date|order_id|total_amount|moving_avg_3
2024-01-05|1001|125.99|125.99
2024-01-07|1002|89.5|107.75
2024-01-10|1003|249.99|155.16
2024-01-12|1004|45.0|128.16
2024-01-15|1005|310.25|201.75
2024-01-18|1006|78.5|144.58
2024-01-20|1007|199.99|196.25
2024-01-25|1009|420.0|232.83
```

### Monthly Moving Average (CTE Pattern)

```sql
WITH monthly_revenue AS (
    SELECT
        strftime('%Y-%m', order_date) AS month,
        ROUND(SUM(total_amount), 2) AS revenue
    FROM orders
    WHERE status != 'Cancelled'
    GROUP BY strftime('%Y-%m', order_date)
)
SELECT month, revenue,
    ROUND(AVG(revenue) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3month
FROM monthly_revenue
ORDER BY month;
```

**Expected output**:
```
month|revenue|moving_avg_3month
2024-01|1586.97|1586.97
2024-02|2230.73|1908.85
2024-03|1975.74|1931.15
2024-04|2442.23|2216.23
2024-05|1112.5|1843.49
```

**Interpretation**: The 3-month moving average smooths out the May dip. While May alone was $1,112.50, the 3-month average of $1,843.49 tells us the broader trend is still positive.

---

## 3. Cohort Analysis (Customer Retention)

Cohort analysis groups customers by a shared characteristic (e.g., registration month) and tracks their behavior over time. It answers: *"Do customers registered this month behave differently from those registered last month?"*

### Monthly Retention Cohort

The query:
1. Assigns each customer to a cohort (their registration month)
2. For each order, calculates months since registration
3. Counts how many unique customers from each cohort ordered in each subsequent month
4. Computes retention rate = active_in_month / total_in_cohort

```sql
WITH customer_cohort AS (
    SELECT
        customer_id,
        strftime('%Y-%m', registration_date) AS cohort_month
    FROM customers
),
order_activity AS (
    SELECT
        cc.customer_id, cc.cohort_month,
        strftime('%Y-%m', o.order_date) AS order_month,
        (CAST(strftime('%Y', o.order_date) AS INTEGER) -
         CAST(substr(cc.cohort_month, 1, 4) AS INTEGER)) * 12
        + (CAST(strftime('%m', o.order_date) AS INTEGER) -
           CAST(substr(cc.cohort_month, 6, 2) AS INTEGER))
            AS months_since_registration
    FROM customer_cohort cc
    JOIN orders o ON cc.customer_id = o.customer_id
    WHERE o.status != 'Cancelled'
)
SELECT
    cohort_month, months_since_registration,
    COUNT(DISTINCT customer_id) AS active_customers,
    ...
```

**Partial output**:
```
cohort_month|months_since_registration|active_customers|total_in_cohort|retention_pct
2023-02|0|2|2|100.0
2023-02|11|1|2|50.0
2023-02|12|2|2|100.0
2023-04|8|1|2|50.0
```

**Reading the cohort table**: Customers registered in Feb 2023 had 100% activity in month 0 (their first month), 50% activity by month 11, and 100% by month 12 — suggesting seasonal ordering patterns.

### Why Cohorts Matter

- **Identify retention problems**: If the 2024-03 cohort retains worse than 2024-01, something changed
- **Measure product-market fit**: High retention = strong product
- **Forecast LTV**: Use early cohort data to predict lifetime value

---

## 4. Pivoting Data with CASE + GROUP BY

SQLite doesn't have a `PIVOT` function, but you can pivot rows into columns using `CASE` inside aggregate functions.

### Payment Method Pivot

```sql
SELECT
    strftime('%Y-%m', order_date) AS month,
    COUNT(CASE WHEN payment_method = 'Credit Card' THEN 1 END) AS credit_card,
    COUNT(CASE WHEN payment_method = 'PayPal' THEN 1 END) AS paypal,
    COUNT(CASE WHEN payment_method = 'Debit Card' THEN 1 END) AS debit_card,
    COUNT(*) AS total_orders
FROM orders
GROUP BY strftime('%Y-%m', order_date)
ORDER BY month;
```

**Expected output**:
```
month|credit_card|paypal|debit_card|total_orders
2024-01|4|3|3|10
2024-02|5|4|3|12
2024-03|4|3|4|11
2024-04|4|4|4|12
2024-05|2|2|1|5
```

### Revenue Category Pivot

```sql
SELECT
    strftime('%Y-%m', o.order_date) AS month,
    ROUND(SUM(CASE WHEN p.category = 'Electronics'
        THEN oi.quantity * oi.unit_price ELSE 0 END), 2) AS electronics_rev,
    ROUND(SUM(CASE WHEN p.category = 'Furniture'
        THEN oi.quantity * oi.unit_price ELSE 0 END), 2) AS furniture_rev,
    ROUND(SUM(CASE WHEN p.category = 'Accessories'
        THEN oi.quantity * oi.unit_price ELSE 0 END), 2) AS accessories_rev,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status != 'Cancelled'
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY month;
```

**Expected output**:
```
month|electronics_rev|furniture_rev|accessories_rev|total_revenue
2024-01|511.11|1153.48|134.73|1799.32
2024-02|1095.99|1273.0|262.47|2631.46
2024-03|572.49|1575.0|278.21|2425.7
2024-04|831.97|1313.0|336.06|2481.03
2024-05|338.98|685.5|87.0|1111.48
```

### How CASE Pivoting Works

- `COUNT(CASE WHEN condition THEN 1 END)` counts rows matching the condition
- `SUM(CASE WHEN condition THEN value ELSE 0 END)` sums values for matching rows
- Each `CASE` becomes a column in the output
- `GROUP BY` creates one row per group (e.g., per month)

---

## 5. Percentile Analysis

Percentiles help you understand data distribution — who are your top 25% customers? Which salaries are outliers?

### NTILE: Equi-Height Buckets

NTILE(n) divides rows into n groups of roughly equal size.

```sql
SELECT customer_name, total_spent,
    NTILE(4) OVER (ORDER BY total_spent) AS spending_quartile,
    CASE NTILE(4) OVER (ORDER BY total_spent)
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium-Low'
        WHEN 3 THEN 'Medium-High'
        WHEN 4 THEN 'High'
    END AS tier
FROM customer_spending
ORDER BY total_spent;
```

**Output interpretation**:
| Quartile | Spend Range | Count |
|----------|-------------|-------|
| 1 (Low) | $0 - $210 | 5 customers |
| 2 (Medium-Low) | $239 - $299 | 5 customers |
| 3 (Medium-High) | $313 - $691 | 5 customers |
| 4 (High) | $611 - $1,190 | 5 customers |

### PERCENT_RANK and CUME_DIST

- **PERCENT_RANK()**: Relative rank from 0 (lowest) to 1 (highest). Formula: (rank - 1) / (total_rows - 1)
- **CUME_DIST()**: Cumulative distribution. Formula: number_of_rows <= current / total_rows

```sql
SELECT employee_id, name, salary,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary), 4) AS pct_rank,
    ROUND(CUME_DIST() OVER (ORDER BY salary), 4) AS cume_dist,
    CASE
        WHEN PERCENT_RANK() OVER (ORDER BY salary) <= 0.25 THEN 'Bottom 25%'
        WHEN PERCENT_RANK() OVER (ORDER BY salary) <= 0.50 THEN '25-50%'
        WHEN PERCENT_RANK() OVER (ORDER BY salary) <= 0.75 THEN '50-75%'
        ELSE 'Top 25%'
    END AS salary_tier
FROM employees
ORDER BY salary;
```

**Partial output**:
```
name|salary|pct_rank|cume_dist|salary_tier
Mike Brown|72000|0.0|0.0667|Bottom 25%
John Smith|75000|0.0714|0.1333|Bottom 25%
...
Grace Kim|155000|1.0|1.0|Top 25%
```

---

## 6. Business KPI Queries

### Customer Lifetime Value (CLV)

```sql
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count,
    ROUND(COALESCE(SUM(o.total_amount), 0), 2) AS total_revenue,
    ROUND(COALESCE(SUM(o.total_amount), 0) / NULLIF(COUNT(o.order_id), 0), 2) AS avg_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status != 'Cancelled'
GROUP BY c.customer_id
ORDER BY total_revenue DESC;
```

**Top customers**:
```
customer_name|order_count|total_revenue|avg_order_value
Benjamin Thomas|3|1190.0|396.67
Emma Davis|3|894.99|298.33
Isabella Lee|3|805.5|268.5
...
```

### Churn Rate

```sql
SELECT
    ROUND(SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_pct,
    SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) AS churned_customers,
    COUNT(*) AS total_customers
FROM customers;
```

**Result: 15.0% churn rate** (3 out of 20 customers inactive)

### Average Order Value (AOV) Trend

```sql
SELECT
    strftime('%Y-%m', order_date) AS month,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
WHERE status != 'Cancelled'
GROUP BY strftime('%Y-%m', order_date)
ORDER BY month;
```

**Monthly AOV trend**: AOV grew from $176.33 in January to $222.50 in May — a 26% increase.

---

## 7. Time-Series Analysis

### Month-over-Month Growth

```sql
WITH monthly_revenue AS (
    SELECT
        strftime('%Y-%m', order_date) AS month,
        ROUND(SUM(total_amount), 2) AS revenue
    FROM orders
    WHERE status != 'Cancelled'
    GROUP BY strftime('%Y-%m', order_date)
)
SELECT
    month, revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    CASE
        WHEN LAG(revenue) OVER (ORDER BY month) IS NOT NULL
        THEN ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0
             / LAG(revenue) OVER (ORDER BY month), 1)
        ELSE NULL
    END AS mom_growth_pct,
    ROUND(SUM(revenue) OVER (ORDER BY month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;
```

**Expected output**:
```
month|revenue|prev_month_revenue|mom_growth_pct|cumulative_revenue
2024-01|1586.97|||1586.97
2024-02|2230.73|1586.97|40.6|3817.7
2024-03|1975.74|2230.73|-11.4|5793.44
2024-04|2442.23|1975.74|23.6|8235.67
2024-05|1112.5|2442.23|-54.4|9348.17
```

**Key formulas**:
- **MoM Growth %**: `(current - previous) / previous * 100`
- **Cumulative Revenue**: Window sum with UNBOUNDED PRECEDING

### Year-over-Year (Movies Example)

Since our e-commerce data has only one year, we use movies to demonstrate YoY:

```sql
WITH yearly_data AS (
    SELECT release_year, COUNT(*) AS movie_count,
        ROUND(SUM(revenue_millions), 0) AS total_revenue_m
    FROM movies GROUP BY release_year
)
SELECT release_year, total_revenue_m,
    LAG(total_revenue_m) OVER (ORDER BY release_year) AS prev_year_rev,
    CASE WHEN LAG(total_revenue_m) OVER (ORDER BY release_year) IS NOT NULL
        THEN ROUND((total_revenue_m - LAG(total_revenue_m) OVER (ORDER BY release_year))
             * 100.0 / LAG(total_revenue_m) OVER (ORDER BY release_year), 1)
        ELSE NULL
    END AS yoy_growth_pct
FROM yearly_data
ORDER BY release_year;
```

### Day-of-Week Pattern Analysis

```sql
SELECT
    CASE CAST(strftime('%w', order_date) AS INTEGER)
        WHEN 0 THEN 'Sunday' WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday' WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday' WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM orders
WHERE status != 'Cancelled'
GROUP BY strftime('%w', order_date)
ORDER BY order_count DESC;
```

**Friday is peak ordering day** (21.7% of all orders), while Saturday-Sunday sees lowest activity (8.7% each).

---

## 8. Real Business Case Studies

### Case Study 1: RFM Customer Segmentation

RFM (Recency, Frequency, Monetary) is the gold standard for customer segmentation:

```sql
WITH customer_rfm AS (
    SELECT c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        CAST(julianday('2024-05-15') - julianday(MAX(o.order_date)) AS INTEGER) AS recency_days,
        COUNT(o.order_id) AS frequency,
        ROUND(COALESCE(SUM(o.total_amount), 0), 2) AS monetary
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status != 'Cancelled'
    GROUP BY c.customer_id
)
SELECT *,
    NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency) AS f_score,
    NTILE(4) OVER (ORDER BY monetary) AS m_score
FROM customer_rfm;
```

**Segments identified**:
- **Champions** (high R, F, M): Benjamin Thomas, Liam Garcia — our best customers
- **Active Customers**: Sarah Johnson, Ethan Williams, Alex Kumar
- **Big Spenders (needs reactivation)**: Amelia Harris ($610.99 but no recent orders)
- **Needs Attention**: 8 customers with low engagement

### Case Study 2: Product Performance with Market Share

```sql
WITH product_revenue AS (
    SELECT p.product_name, p.category,
        COUNT(DISTINCT o.order_id) AS times_ordered,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status != 'Cancelled'
    GROUP BY p.product_id
)
SELECT product_name, revenue,
    ROUND(revenue * 100.0 / SUM(revenue) OVER (), 1) AS market_share_pct,
    ROUND(SUM(revenue) OVER (ORDER BY revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS running_total
FROM product_revenue
ORDER BY revenue DESC;
```

**Key finding**: Standing Desk alone generates 51.4% of all revenue — a single-product dependency risk.

### Case Study 3: Employee Equity Analysis (Compa-Ratio)

**Compa-ratio** = employee salary / department average * 100. Values below 85 indicate potential underpayment; above 115 indicate above-market compensation.

```sql
SELECT e.first_name || ' ' || e.last_name AS name,
    d.department_name, e.salary,
    ROUND(AVG(e.salary) OVER (PARTITION BY e.department_id), 0) AS dept_avg,
    ROUND(e.salary * 100.0 / AVG(e.salary) OVER (PARTITION BY e.department_id), 1) AS compa_ratio
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, compa_ratio DESC;
```

**Insight**: Grace Kim has a 137.2 compa-ratio (highest in Data & Analytics), while Mike Brown at 63.8 is significantly below department average.

---

## Exercises

### Exercise 1: Revenue Acceleration
Using the monthly_revenue CTE, compute the acceleration (change in MoM growth rate) for each month. Positive acceleration means growth is speeding up.

### Exercise 2: Customer Recency Analysis
Find all customers who haven't ordered in the last 30 days but have spent more than $500 total. Use window functions to calculate days since last order.

### Exercise 3: Product Cross-Sell Analysis
For each product, show the top 3 products most frequently purchased in the same order. Use a self-join on order_items.

### Exercise 4: Cohort Retention Heatmap
Build a pivot table showing cohort months as rows, months-since-registration as columns, and retention percentage as values. Format it as a matrix.

### Exercise 5: Rolling 90th Percentile
Using NTILE(10) per rolling window of 20 orders, identify orders in the top 10% of their recent window. This simulates anomaly detection.

---

## Summary

Analytical SQL is the bridge between raw data and business decisions. The patterns in this lesson are used daily by data analysts:

| Pattern | Business Question |
|---------|------------------|
| Running Total | "What's our cumulative revenue this quarter?" |
| Moving Average | "Is this month's dip a trend or an anomaly?" |
| Cohort Analysis | "Are our newer customers retaining better?" |
| CASE Pivot | "How do payment methods trend over time?" |
| NTILE / Percentile | "Who are our top 25% customers?" |
| KPI Queries | "What's our churn rate and AOV?" |
| Time-Series | "How fast are we growing month-over-month?" |

**Next step**: Combine multiple patterns into executive dashboards and automated reporting pipelines.
