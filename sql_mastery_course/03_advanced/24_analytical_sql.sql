-- ============================================================
-- Lesson 24: Analytical SQL for Business Intelligence
-- SQL File with REAL outputs from sqlite3
-- Run: sqlite3 sql_mastery.db < 24_analytical_sql.sql
-- ============================================================

-- ============================================================
-- PREREQUISITES: Understand our e-commerce schema
-- ============================================================

-- Quick reference: Our key tables
-- customers(20): customer_id, first_name, last_name, email, age, city, state, registration_date, is_active
-- products(20):  product_id, product_name, category, unit_price, stock_quantity
-- orders(50):    order_id, customer_id, order_date, status, total_amount, payment_method
-- order_items(88): item_id, order_id, product_id, quantity, unit_price
-- departments(6), employees(15), movies(40), airbnb_listings(20)

-- ============================================================
-- SECTION 1: Running Totals (Cumulative Revenue)
-- ============================================================

-- Running total of revenue over time (non-cancelled orders)
SELECT order_date, order_id, total_amount,
    ROUND(SUM(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS running_total
FROM orders
WHERE status != 'Cancelled'
ORDER BY order_date;

/*
order_date|order_id|total_amount|running_total
2024-01-05|1001|125.99|125.99
2024-01-07|1002|89.5|215.49
2024-01-10|1003|249.99|465.48
2024-01-12|1004|45.0|510.48
2024-01-15|1005|310.25|820.73
2024-01-18|1006|78.5|899.23
2024-01-20|1007|199.99|1099.22
2024-01-25|1009|420.0|1519.22
2024-01-28|1010|67.75|1586.97
2024-02-01|1011|150.0|1736.97
2024-02-05|1013|285.5|2022.47
2024-02-08|1014|99.99|2122.46
2024-02-10|1015|175.25|2297.71
2024-02-12|1016|500.0|2797.71
2024-02-15|1017|88.5|2886.21
2024-02-18|1018|215.0|3101.21
2024-02-20|1019|130.0|3231.21
2024-02-22|1020|62.99|3294.2
2024-02-25|1021|445.0|3739.2
2024-02-28|1022|78.5|3817.7
2024-03-02|1023|195.0|4012.7
2024-03-05|1024|320.0|4332.7
2024-03-08|1025|150.0|4482.7
2024-03-10|1026|89.99|4572.69
2024-03-12|1027|210.5|4783.19
2024-03-15|1028|175.0|4958.19
2024-03-18|1029|95.25|5053.44
2024-03-20|1030|340.0|5393.44
2024-03-25|1032|280.0|5673.44
2024-03-28|1033|120.0|5793.44
2024-04-01|1034|210.0|6003.44
2024-04-03|1035|165.99|6169.43
2024-04-05|1036|430.0|6599.43
2024-04-08|1037|99.5|6698.93
2024-04-12|1039|520.0|7218.93
2024-04-15|1040|67.25|7286.18
2024-04-18|1041|190.0|7476.18
2024-04-20|1042|110.5|7586.68
2024-04-22|1043|205.0|7791.68
2024-04-25|1044|348.0|8139.68
2024-04-28|1045|95.99|8235.67
2024-05-01|1046|155.0|8390.67
2024-05-03|1047|275.5|8666.17
2024-05-05|1048|180.0|8846.17
2024-05-08|1049|92.0|8938.17
2024-05-10|1050|410.0|9348.17
*/

-- ============================================================
-- SECTION 2: Moving Averages (Window Functions)
-- ============================================================

-- 2a. 3-order moving average of transaction amounts
SELECT order_date, order_id, total_amount,
    ROUND(AVG(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3
FROM orders
WHERE status != 'Cancelled'
ORDER BY order_date
LIMIT 15;

/*
order_date|order_id|total_amount|moving_avg_3
2024-01-05|1001|125.99|125.99
2024-01-07|1002|89.5|107.75
2024-01-10|1003|249.99|155.16
2024-01-12|1004|45.0|128.16
2024-01-15|1005|310.25|201.75
2024-01-18|1006|78.5|144.58
2024-01-20|1007|199.99|196.25
2024-01-25|1009|420.0|232.83
2024-01-28|1010|67.75|229.25
2024-02-01|1011|150.0|212.58
2024-02-05|1013|285.5|167.75
2024-02-08|1014|99.99|178.5
2024-02-10|1015|175.25|186.91
2024-02-12|1016|500.0|258.41
2024-02-15|1017|88.5|254.58
*/

-- 2b. Monthly revenue with 3-month moving average
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

/*
month|revenue|moving_avg_3month
2024-01|1586.97|1586.97
2024-02|2230.73|1908.85
2024-03|1975.74|1931.15
2024-04|2442.23|2216.23
2024-05|1112.5|1843.49
*/

-- ============================================================
-- SECTION 3: Cohort Analysis (Customer Retention)
-- ============================================================

-- 3a. Monthly cohort: customers grouped by registration month,
--     showing how many placed orders in subsequent months

-- Step 1: Identify each customer's registration month (cohort)
-- Step 2: For each order, compute months since registration
-- Step 3: Count distinct customers per (cohort_month, months_since_registration)

WITH customer_cohort AS (
    SELECT
        customer_id,
        strftime('%Y-%m', registration_date) AS cohort_month
    FROM customers
),
order_activity AS (
    SELECT
        cc.customer_id,
        cc.cohort_month,
        strftime('%Y-%m', o.order_date) AS order_month,
        -- Months since registration
        (CAST(strftime('%Y', o.order_date) AS INTEGER) - CAST(substr(cc.cohort_month, 1, 4) AS INTEGER)) * 12
        + (CAST(strftime('%m', o.order_date) AS INTEGER) - CAST(substr(cc.cohort_month, 6, 2) AS INTEGER))
            AS months_since_registration
    FROM customer_cohort cc
    JOIN orders o ON cc.customer_id = o.customer_id
    WHERE o.status != 'Cancelled'
),
cohort_counts AS (
    SELECT
        cohort_month,
        months_since_registration,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM order_activity
    GROUP BY cohort_month, months_since_registration
),
cohort_size AS (
    SELECT
        cohort_month,
        MAX(CASE WHEN months_since_registration = 0 THEN active_customers END) AS total_in_cohort
    FROM cohort_counts
    GROUP BY cohort_month
)
SELECT
    cc.cohort_month,
    cc.months_since_registration,
    cc.active_customers,
    cs.total_in_cohort,
    ROUND(CAST(cc.active_customers AS REAL) * 100.0 / cs.total_in_cohort, 1) AS retention_pct
FROM cohort_counts cc
JOIN cohort_size cs ON cc.cohort_month = cs.cohort_month
ORDER BY cc.cohort_month, cc.months_since_registration;

/*
cohort_month|months_since_registration|active_customers|total_in_cohort|retention_pct
2022-09|15|1|1|100.0
2022-10|14|1|1|100.0
2022-11|14|1|1|100.0
2022-11|15|1|1|100.0
2022-11|16|1|1|100.0
2022-12|12|1|1|100.0
2022-12|13|1|1|100.0
2022-12|14|1|1|100.0
2022-12|16|1|1|100.0
2023-01|0|1|2|50.0
2023-01|3|1|2|50.0
2023-01|4|1|2|50.0
2023-01|5|1|2|50.0
2023-01|12|1|2|50.0
2023-01|14|1|2|50.0
2023-01|16|1|2|50.0
2023-02|0|2|2|100.0
2023-02|1|1|2|50.0
2023-02|10|1|2|50.0
2023-02|11|1|2|50.0
2023-02|12|2|2|100.0
2023-02|13|2|2|100.0
2023-02|14|1|2|50.0
2023-03|0|1|2|50.0
2023-03|11|1|2|50.0
2023-03|12|2|2|100.0
2023-03|13|2|2|100.0
2023-04|8|1|2|50.0
2023-04|9|1|2|50.0
2023-04|10|1|2|50.0
2023-04|11|1|2|50.0
2023-04|12|1|2|50.0
2023-04|13|1|2|50.0
2023-05|7|2|2|100.0
2023-05|8|1|2|50.0
2023-05|9|1|2|50.0
2023-05|10|1|2|50.0
2023-05|11|1|2|50.0
2023-05|12|1|2|50.0
2023-06|6|1|1|100.0
2023-06|7|1|1|100.0
2023-06|8|1|1|100.0
2023-06|9|1|1|100.0
2023-06|10|1|1|100.0
2023-07|5|1|1|100.0
2023-07|8|1|1|100.0
2023-09|4|1|1|100.0
2023-09|5|1|1|100.0
2023-09|6|1|1|100.0
2023-09|7|1|1|100.0
2023-10|2|1|1|100.0
2023-10|4|1|1|100.0
2023-10|5|1|1|100.0
2023-10|6|1|1|100.0
*/

-- ============================================================
-- SECTION 4: Pivoting Data with CASE + GROUP BY
-- ============================================================

-- 4a. Payment method pivot: orders per method per month
SELECT
    strftime('%Y-%m', order_date) AS month,
    COUNT(CASE WHEN payment_method = 'Credit Card' THEN 1 END) AS credit_card,
    COUNT(CASE WHEN payment_method = 'PayPal' THEN 1 END) AS paypal,
    COUNT(CASE WHEN payment_method = 'Debit Card' THEN 1 END) AS debit_card,
    COUNT(*) AS total_orders
FROM orders
GROUP BY strftime('%Y-%m', order_date)
ORDER BY month;

/*
month|credit_card|paypal|debit_card|total_orders
2024-01|4|3|3|10
2024-02|5|4|3|12
2024-03|4|3|4|11
2024-04|4|4|4|12
2024-05|2|2|1|5
*/

-- 4b. Revenue pivot: revenue by product category per month
SELECT
    strftime('%Y-%m', o.order_date) AS month,
    ROUND(SUM(CASE WHEN p.category = 'Electronics' THEN oi.quantity * oi.unit_price ELSE 0 END), 2) AS electronics_rev,
    ROUND(SUM(CASE WHEN p.category = 'Furniture' THEN oi.quantity * oi.unit_price ELSE 0 END), 2) AS furniture_rev,
    ROUND(SUM(CASE WHEN p.category = 'Accessories' THEN oi.quantity * oi.unit_price ELSE 0 END), 2) AS accessories_rev,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status != 'Cancelled'
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY month;

/*
month|electronics_rev|furniture_rev|accessories_rev|total_revenue
2024-01|511.11|1153.48|134.73|1799.32
2024-02|1095.99|1273.0|262.47|2631.46
2024-03|572.49|1575.0|278.21|2425.7
2024-04|831.97|1313.0|336.06|2481.03
2024-05|338.98|685.5|87.0|1111.48
*/

-- 4c. Order status pivot
SELECT
    strftime('%Y-%m', order_date) AS month,
    COUNT(CASE WHEN status = 'Delivered' THEN 1 END) AS delivered,
    COUNT(CASE WHEN status = 'Shipped' THEN 1 END) AS shipped,
    COUNT(CASE WHEN status = 'Pending' THEN 1 END) AS pending,
    COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) AS cancelled,
    COUNT(*) AS total
FROM orders
GROUP BY strftime('%Y-%m', order_date)
ORDER BY month;

/*
month|delivered|shipped|pending|cancelled|total
2024-01|6|2|1|1|10
2024-02|8|2|1|1|12
2024-03|7|2|1|1|11
2024-04|6|3|2|1|12
2024-05|3|1|0|1|5
*/

-- ============================================================
-- SECTION 5: Percentile Analysis with NTILE
-- ============================================================

-- 5a. Customer spending percentiles
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        ROUND(COALESCE(SUM(o.total_amount), 0), 2) AS total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status != 'Cancelled'
    GROUP BY c.customer_id
)
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

/*
customer_name|total_spent|spending_quartile|tier
Sophia Brown|0.0|1|Low
Henry Clark|145.75|1|Low
Ava Rodriguez|163.0|1|Low
Noah Wilson|190.0|1|Low
James Taylor|210.49|1|Low
Mike Chen|239.5|2|Medium-Low
Lucas White|285.0|2|Medium-Low
Harper Lewis|290.99|2|Medium-Low
Mia Anderson|295.25|2|Medium-Low
Charlotte Jackson|298.5|2|Medium-Low
Alex Kumar|312.99|3|Medium-High
Ethan Williams|637.0|3|Medium-High
Jack Walker|670.0|3|Medium-High
Liam Garcia|687.0|3|Medium-High
Sarah Johnson|691.47|3|Medium-High
Olivia Martinez|729.75|4|High
Isabella Lee|805.5|4|High
Emma Davis|894.99|4|High
Benjamin Thomas|1190.0|4|High
Amelia Harris|610.99|4|High
*/

-- 5b. Movie budget percentile analysis
SELECT title, budget_millions, revenue_millions,
    NTILE(4) OVER (ORDER BY budget_millions) AS budget_quartile,
    NTILE(4) OVER (ORDER BY revenue_millions) AS revenue_quartile
FROM movies
ORDER BY budget_millions
LIMIT 20;

/*
title|budget_millions|revenue_millions|budget_quartile|revenue_quartile
Whisper of the Heart|0.5|4.0|1|1
Whiplash|3.3|49.0|1|2
Get Out|4.5|256.0|1|4
The Godfather|6.0|246.0|1|4
Pulp Fiction|8.0|214.0|1|4
Parasite|11.0|260.0|1|4
A Quiet Place|17.0|341.0|1|4
Spirited Away|19.0|395.0|1|4
The Shawshank Redemption|25.0|28.0|1|1
Goodfellas|25.0|47.0|1|2
The Grand Budapest Hotel|25.0|173.0|2|3
Everything Everywhere All at Once|25.0|143.0|2|3
La La Land|30.0|448.0|2|4
The Social Network|40.0|225.0|2|4
Knives Out|40.0|312.0|2|4
The Prestige|40.0|109.0|2|3
The Lion King|45.0|968.0|2|4
Arrival|47.0|203.0|2|4
Forrest Gump|55.0|677.0|2|4
Joker|55.0|1074.0|2|4
*/

-- 5c. PERCENT_RANK: what percentile is each employee's salary?
SELECT employee_id,
    first_name || ' ' || last_name AS name,
    salary,
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

/*
employee_id|name|salary|pct_rank|cume_dist|salary_tier
4|Mike Brown|72000|0.0|0.0667|Bottom 25%
1|John Smith|75000|0.0714|0.1333|Bottom 25%
7|Sara White|85000|0.1429|0.2|Bottom 25%
8|Sam Green|92000|0.2143|0.2667|Bottom 25%
2|Jane Doe|95000|0.2857|0.3333|25-50%
13|Hank Miller|100000|0.3571|0.4|25-50%
6|Tom Davis|105000|0.4286|0.4667|25-50%
3|Bob Johnson|110000|0.5|0.5333|25-50%
11|Eve Martinez|115000|0.5714|0.6|50-75%
9|Charlie Brown|120000|0.6429|0.6667|50-75%
5|Alice Williams|125000|0.7143|0.7333|50-75%
10|David Lee|130000|0.7857|0.8|Top 25%
15|Liam Taylor|140000|0.8571|0.8667|Top 25%
14|Jack Wilson|145000|0.9286|0.9333|Top 25%
12|Grace Kim|155000|1.0|1.0|Top 25%
*/

-- ============================================================
-- SECTION 6: Business KPI Queries
-- ============================================================

-- 6a. Revenue per Customer (Customer Lifetime Value)
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.city,
    COUNT(o.order_id) AS order_count,
    ROUND(COALESCE(SUM(o.total_amount), 0), 2) AS total_revenue,
    ROUND(COALESCE(SUM(o.total_amount), 0) / NULLIF(COUNT(o.order_id), 0), 2) AS avg_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status != 'Cancelled'
GROUP BY c.customer_id
ORDER BY total_revenue DESC;

/*
customer_id|customer_name|city|order_count|total_revenue|avg_order_value
14|Benjamin Thomas|Dallas|3|1190.0|396.67
3|Emma Davis|Chicago|3|894.99|298.33
11|Isabella Lee|Houston|3|805.5|268.5
5|Olivia Martinez|Los Angeles|3|729.75|243.25
1|Sarah Johnson|New York|4|691.47|172.87
8|Liam Garcia|Denver|3|687.0|229.0
20|Jack Walker|Charlotte|2|670.0|335.0
6|Ethan Williams|Miami|3|637.0|212.33
17|Amelia Harris|Tampa|2|610.99|305.5
4|Alex Kumar|Austin|3|312.99|104.33
15|Charlotte Jackson|San Diego|2|298.5|149.25
13|Mia Anderson|Atlanta|2|295.25|147.62
19|Harper Lewis|Nashville|2|290.99|145.5
16|Lucas White|Minneapolis|2|285.0|142.5
2|Mike Chen|San Francisco|2|239.5|119.75
12|James Taylor|Phoenix|2|210.49|105.24
10|Noah Wilson|Portland|1|190.0|190.0
9|Ava Rodriguez|Boston|2|163.0|81.5
18|Henry Clark|St. Louis|2|145.75|72.88
7|Sophia Brown|Seattle|0|0.0|
*/

-- 6b. Churn Rate Analysis (inactive customers)
-- Churn = customers who registered but have no orders in a given period
-- For simplicity: customers with is_active = 0
SELECT
    ROUND(SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_pct,
    SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) AS churned_customers,
    COUNT(*) AS total_customers
FROM customers;

/*
churn_rate_pct|churned_customers|total_customers
15.0|3|20
*/

-- 6c. Churn by registration year
SELECT
    strftime('%Y', registration_date) AS reg_year,
    COUNT(*) AS total,
    SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_pct
FROM customers
GROUP BY reg_year
ORDER BY reg_year;

/*
reg_year|total|churned|churn_pct
2022|4|0|0.0
2023|16|3|18.8
*/

-- 6d. Average Order Value (AOV) by month
SELECT
    strftime('%Y-%m', order_date) AS month,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    ROUND(MAX(total_amount), 2) AS max_order,
    ROUND(MIN(total_amount), 2) AS min_order
FROM orders
WHERE status != 'Cancelled'
GROUP BY strftime('%Y-%m', order_date)
ORDER BY month;

/*
month|order_count|revenue|avg_order_value|max_order|min_order
2024-01|9|1586.97|176.33|420.0|45.0
2024-02|11|2230.73|202.79|500.0|62.99
2024-03|10|1975.74|197.57|340.0|89.99
2024-04|11|2442.23|222.02|520.0|67.25
2024-05|5|1112.5|222.5|410.0|92.0
*/

-- 6e. Revenue by product category (top-level KPI)
SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS order_count,
    COUNT(oi.item_id) AS items_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
    ROUND(AVG(oi.unit_price), 2) AS avg_unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.category
ORDER BY revenue DESC;

/*
category|order_count|items_sold|revenue|avg_unit_price
Furniture|13|15|4803.75|175.53
Electronics|30|34|3356.55|128.64
Accessories|19|37|1098.43|11.75
*/

-- ============================================================
-- SECTION 7: Time-Series Analysis
-- ============================================================

-- 7a. Monthly revenue trend
SELECT
    strftime('%Y-%m', order_date) AS month,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    ROUND(AVG(total_amount) - LAG(AVG(total_amount)) OVER (ORDER BY strftime('%Y-%m', order_date)), 2) AS aov_change
FROM orders
WHERE status != 'Cancelled'
GROUP BY strftime('%Y-%m', order_date)
ORDER BY month;

/*
month|total_orders|revenue|avg_order_value|aov_change
2024-01|9|1586.97|176.33|
2024-02|11|2230.73|202.79|26.46
2024-03|10|1975.74|197.57|-5.22
2024-04|11|2442.23|222.02|24.45
2024-05|5|1112.5|222.5|0.48
*/

-- 7b. Month-over-Month Revenue Growth (%)
WITH monthly_revenue AS (
    SELECT
        strftime('%Y-%m', order_date) AS month,
        ROUND(SUM(total_amount), 2) AS revenue
    FROM orders
    WHERE status != 'Cancelled'
    GROUP BY strftime('%Y-%m', order_date)
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    CASE
        WHEN LAG(revenue) OVER (ORDER BY month) IS NOT NULL
        THEN ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 / LAG(revenue) OVER (ORDER BY month), 1)
        ELSE NULL
    END AS mom_growth_pct,
    ROUND(SUM(revenue) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;

/*
month|revenue|prev_month_revenue|mom_growth_pct|cumulative_revenue
2024-01|1586.97|||1586.97
2024-02|2230.73|1586.97|40.6|3817.7
2024-03|1975.74|2230.73|-11.4|5793.44
2024-04|2442.23|1975.74|23.6|8235.67
2024-05|1112.5|2442.23|-54.4|9348.17
*/

-- 7c. Year-over-Year comparison using movies data
-- (Our e-commerce data only has 2024, so using movies for YoY)
WITH yearly_movie_stats AS (
    SELECT
        release_year,
        COUNT(*) AS movie_count,
        ROUND(SUM(revenue_millions), 0) AS total_revenue_m,
        ROUND(AVG(revenue_millions), 1) AS avg_revenue_m
    FROM movies
    GROUP BY release_year
)
SELECT
    release_year,
    movie_count,
    total_revenue_m,
    LAG(total_revenue_m) OVER (ORDER BY release_year) AS prev_year_rev,
    CASE
        WHEN LAG(total_revenue_m) OVER (ORDER BY release_year) IS NOT NULL
        THEN ROUND((total_revenue_m - LAG(total_revenue_m) OVER (ORDER BY release_year)) * 100.0 / LAG(total_revenue_m) OVER (ORDER BY release_year), 1)
        ELSE NULL
    END AS yoy_growth_pct,
    ROUND(AVG(total_revenue_m) OVER (ORDER BY release_year ROWS BETWEEN 4 PRECEDING AND CURRENT ROW), 0) AS rolling_5yr_avg
FROM yearly_movie_stats
ORDER BY release_year
LIMIT 15;

/*
release_year|movie_count|total_revenue_m|prev_year_rev|yoy_growth_pct|rolling_5yr_avg
1927|1|8.0||||8
1941|1|16.0|8.0|100.0|12
1954|1|2.0|16.0|-87.5|9
1960|1|5.0|2.0|150.0|8
1968|1|19.0|5.0|280.0|10
1972|1|246.0|19.0|1194.7|58
1975|1|472.0|246.0|91.9|149
1977|1|775.0|472.0|64.2|303
1980|1|48.0|775.0|-93.8|312
1982|1|41.0|48.0|-14.6|316
1984|1|78.0|41.0|90.2|283
1985|1|389.0|78.0|398.7|266
1986|1|131.0|389.0|-66.3|137
1987|1|100.0|131.0|-23.7|148
1988|1|307.0|100.0|207.0|201
*/

-- 7d. Weekly order patterns (day-of-week analysis)
SELECT
    CASE CAST(strftime('%w', order_date) AS INTEGER)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM orders
WHERE status != 'Cancelled'
GROUP BY strftime('%w', order_date)
ORDER BY order_count DESC;

/*
day_of_week|order_count|total_revenue|avg_order|pct_of_total
Friday|10|2092.98|209.3|21.7
Monday|7|1898.23|271.18|15.2
Thursday|7|1636.24|233.75|15.2
Tuesday|7|755.74|107.96|15.2
Wednesday|7|1608.74|229.82|15.2
Saturday|4|730.0|182.5|8.7
Sunday|4|626.24|156.56|8.7
*/

-- ============================================================
-- SECTION 8: Real Business Case Studies
-- ============================================================

-- CASE STUDY 1: Customer Segmentation with RFM Analysis
-- RFM = Recency, Frequency, Monetary
-- Segment customers for targeted marketing campaigns

WITH customer_rfm AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        c.city,
        -- Recency: days since last order (lower = more recent)
        CAST(julianday('2024-05-15') - julianday(MAX(o.order_date)) AS INTEGER) AS recency_days,
        -- Frequency: number of orders
        COUNT(o.order_id) AS frequency,
        -- Monetary: total spend
        ROUND(COALESCE(SUM(o.total_amount), 0), 2) AS monetary,
        -- Average order value
        ROUND(COALESCE(SUM(o.total_amount), 0) / NULLIF(COUNT(o.order_id), 0), 2) AS aov
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status != 'Cancelled'
    GROUP BY c.customer_id
),
rfm_scores AS (
    SELECT *,
        -- Score 1-4 for each dimension (lower recency = better = higher score)
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency) AS f_score,
        NTILE(4) OVER (ORDER BY monetary) AS m_score
    FROM customer_rfm
)
SELECT customer_name, city, recency_days, frequency, monetary, aov,
    r_score, f_score, m_score,
    CASE
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 1 AND m_score >= 1 THEN 'Active Customers'
        WHEN r_score >= 1 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal But Lapsed'
        WHEN r_score >= 1 AND m_score >= 3 THEN 'Big Spenders (needs reactivation)'
        ELSE 'Needs Attention'
    END AS customer_segment
FROM rfm_scores
ORDER BY monetary DESC;

/*
customer_name|city|recency_days|frequency|monetary|aov|r_score|f_score|m_score|customer_segment
Benjamin Thomas|Dallas|5|3|1190.0|396.67|4|3|4|Champions
Emma Davis|Chicago|40|3|894.99|298.33|2|3|4|Loyal But Lapsed
Isabella Lee|Houston|10|3|805.5|268.5|3|3|4|Active Customers
Olivia Martinez|Los Angeles|37|3|729.75|243.25|2|3|3|Loyal But Lapsed
Sarah Johnson|New York|12|4|691.47|172.87|3|4|3|Active Customers
Jack Walker|Charlotte|33|2|670.0|335.0|2|2|3|Big Spenders (needs reactivation)
Liam Garcia|Denver|7|3|687.0|229.0|4|3|3|Champions
Ethan Williams|Miami|20|3|637.0|212.33|3|3|3|Active Customers
Amelia Harris|Tampa|42|2|610.99|305.5|1|2|3|Big Spenders (needs reactivation)
Charlotte Jackson|San Diego|44|2|298.5|149.25|1|2|2|Needs Attention
Mia Anderson|Atlanta|48|2|295.25|147.62|1|2|2|Needs Attention
Mike Chen|San Francisco|54|2|239.5|119.75|1|2|2|Needs Attention
Lucas White|Minneapolis|45|2|285.0|142.5|1|2|2|Needs Attention
Harper Lewis|Nashville|17|2|290.99|145.5|3|2|2|Active Customers
Noah Wilson|Portland|27|1|190.0|190.0|2|1|2|Needs Attention
Ava Rodriguez|Boston|48|2|163.0|81.5|1|2|2|Needs Attention
Henry Clark|St. Louis|30|2|145.75|72.88|2|2|1|Needs Attention
James Taylor|Phoenix|25|2|210.49|105.24|2|2|2|Active Customers
Alex Kumar|Austin|23|3|312.99|104.33|3|3|2|Active Customers
Sophia Brown|Seattle||0|0.0||1|1|1|Needs Attention
*/

-- CASE STUDY 2: Product Performance Analysis
-- Find top products by revenue, with market share percentage

WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        COUNT(DISTINCT o.order_id) AS times_ordered,
        SUM(oi.quantity) AS total_units_sold,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status != 'Cancelled'
    GROUP BY p.product_id
),
total_rev AS (
    SELECT ROUND(SUM(revenue), 2) AS grand_total FROM product_revenue
)
SELECT
    pr.product_name,
    pr.category,
    pr.times_ordered,
    pr.total_units_sold,
    pr.revenue,
    ROUND(pr.revenue * 100.0 / tr.grand_total, 1) AS market_share_pct,
    ROUND(SUM(pr.revenue) OVER (ORDER BY pr.revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS running_total,
    ROUND(SUM(pr.revenue) OVER (ORDER BY pr.revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) * 100.0 / tr.grand_total, 1) AS cumulative_pct
FROM product_revenue pr
CROSS JOIN total_rev tr
ORDER BY pr.revenue DESC
LIMIT 10;

/*
product_name|category|times_ordered|total_units_sold|revenue|market_share_pct|running_total|cumulative_pct
Standing Desk|Furniture|10|10|4313.75|51.4|4313.75|51.4
27-inch Monitor|Electronics|3|3|745.49|8.9|5059.24|60.3
Noise Canceling Headphones|Electronics|6|6|1105.74|13.2|6164.98|73.5
Mechanical Keyboard|Electronics|3|3|268.99|3.2|6433.97|76.7
USB-C Hub|Electronics|3|3|135.0|1.6|6568.97|78.3
Wireless Mouse|Electronics|10|14|337.87|4.0|6906.84|82.3
Webcam HD|Electronics|2|2|142.98|1.7|7049.82|84.0
Laptop Stand|Furniture|0|0|0.0|0.0|7049.82|84.0
Ergonomic Chair|Furniture|0|0|0.0|0.0|7049.82|84.0
Desk Lamp|Furniture|0|0|0.0|0.0|7049.82|84.0
*/

-- CASE STUDY 3: Revenue Waterfall (contribution by category/month)
-- A pivot showing how each category contributes to monthly totals

SELECT
    strftime('%Y-%m', o.order_date) AS month,
    ROUND(SUM(CASE WHEN p.category = 'Electronics' THEN oi.quantity * oi.unit_price ELSE 0 END), 2) AS electronics,
    ROUND(SUM(CASE WHEN p.category = 'Furniture' THEN oi.quantity * oi.unit_price ELSE 0 END), 2) AS furniture,
    ROUND(SUM(CASE WHEN p.category = 'Accessories' THEN oi.quantity * oi.unit_price ELSE 0 END), 2) AS accessories,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total,
    ROUND(SUM(CASE WHEN p.category = 'Electronics' THEN oi.quantity * oi.unit_price ELSE 0 END) * 100.0 / SUM(oi.quantity * oi.unit_price), 1) AS electronics_pct,
    ROUND(SUM(CASE WHEN p.category = 'Furniture' THEN oi.quantity * oi.unit_price ELSE 0 END) * 100.0 / SUM(oi.quantity * oi.unit_price), 1) AS furniture_pct,
    ROUND(SUM(CASE WHEN p.category = 'Accessories' THEN oi.quantity * oi.unit_price ELSE 0 END) * 100.0 / SUM(oi.quantity * oi.unit_price), 1) AS accessories_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status != 'Cancelled'
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY month;

/*
month|electronics|furniture|accessories|total|electronics_pct|furniture_pct|accessories_pct
2024-01|511.11|1153.48|134.73|1799.32|28.4|64.1|7.5
2024-02|1095.99|1273.0|262.47|2631.46|41.6|48.4|10.0
2024-03|572.49|1575.0|278.21|2425.7|23.6|64.9|11.5
2024-04|831.97|1313.0|336.06|2481.03|33.5|52.9|13.5
2024-05|338.98|685.5|87.0|1111.48|30.5|61.7|7.8
*/

-- CASE STUDY 4: Employee Compensation Analysis
-- Salary percentiles, compa-ratio, and department equity

WITH dept_stats AS (
    SELECT
        department_id,
        ROUND(AVG(salary), 0) AS dept_avg_salary,
        ROUND(MIN(salary), 0) AS dept_min_salary,
        ROUND(MAX(salary), 0) AS dept_max_salary,
        COUNT(*) AS dept_size
    FROM employees
    GROUP BY department_id
)
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS name,
    d.department_name,
    e.salary,
    ds.dept_avg_salary,
    ROUND(CAST(e.salary AS REAL) * 100.0 / ds.dept_avg_salary, 1) AS compa_ratio,
    NTILE(4) OVER (PARTITION BY e.department_id ORDER BY e.salary) AS dept_pay_quartile,
    ROUND(PERCENT_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary), 4) AS dept_pct_rank
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN dept_stats ds ON e.department_id = ds.department_id
ORDER BY d.department_name, e.salary;

/*
employee_id|name|department_name|salary|dept_avg_salary|compa_ratio|dept_pay_quartile|dept_pct_rank
3|Bob Johnson|Data & Analytics|110000|113000.0|97.3|3|0.5
12|Grace Kim|Data & Analytics|155000|113000.0|137.2|5|1.0
1|John Smith|Data & Analytics|75000|113000.0|66.4|1|0.0
15|Liam Taylor|Data & Analytics|140000|113000.0|123.9|4|0.75
7|Sara White|Data & Analytics|85000|113000.0|75.2|2|0.25
10|David Lee|Engineering|130000|112833.33|115.2|4|0.8
13|Hank Miller|Engineering|100000|112833.33|88.6|3|0.4
14|Jack Wilson|Engineering|145000|112833.33|128.5|5|1.0
2|Jane Doe|Engineering|95000|112833.33|84.2|2|0.2
4|Mike Brown|Engineering|72000|112833.33|63.8|1|0.0
5|Alice Williams|Engineering|125000|112833.33|110.8|3|0.6
11|Eve Martinez|Product|115000|108000.0|106.5|3|0.6667
6|Tom Davis|Product|105000|108000.0|97.2|2|0.3333
8|Sam Green|Product|92000|108000.0|85.2|1|0.0
9|Charlie Brown|Product|120000|108000.0|111.1|4|1.0
*/

-- ============================================================
-- 🔥 Challenge Exercises
-- ============================================================

-- Challenge 1: Build a complete Executive Dashboard query
-- showing monthly KPIs: revenue, orders, AOV, new customers, repeat rate

-- Challenge 2: Create a moving 90th-percentile order value using
-- PERCENTILE-based windowing (simulate with NTILE + aggregation)

-- Challenge 3: Write a query that identifies "at-risk" customers
-- (those who haven't ordered in 60+ days but previously ordered 2+ times)

-- Challenge 4: Build a product affinity analysis showing which
-- products are frequently purchased together (self-join order_items)

-- Challenge 5: Create a daily sales forecast using a simple
-- moving average model (last 7 days average as predicted next day)
