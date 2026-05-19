-- ========================================================================
-- LESSON 13: Date Functions — Working with Time
-- Target: sqlite3 /mnt/c/Users/USER/.../sql_mastery.db
-- ========================================================================

-- ============================================================
-- 1. DATE() — Current Date / Parse
-- ============================================================

SELECT DATE('now') AS today;
-- Expected: 2026-05-18 (or whatever today is)

-- ============================================================
-- 2. TIME() — Time Component
-- ============================================================

SELECT TIME('now') AS current_time;

-- ============================================================
-- 3. STRFTIME() — Format Dates
-- ============================================================

SELECT order_id, order_date,
       strftime('%Y', order_date) AS year,
       strftime('%m', order_date) AS month,
       strftime('%d', order_date) AS day,
       strftime('%w', order_date) AS weekday_num,
       strftime('%Y-%m', order_date) AS year_month
FROM orders
LIMIT 5;

-- Expected:
-- 1001|2024-01-05|2024|01|05|5|2024-01
-- 1002|2024-01-07|2024|01|07|0|2024-01
-- 1003|2024-01-10|2024|01|10|3|2024-01
-- 1004|2024-01-12|2024|01|12|5|2024-01
-- 1005|2024-01-15|2024|01|15|1|2024-01

-- ============================================================
-- 4. JULIANDAY() — Date Differences in Days
-- ============================================================

-- 4A. Order age in days
SELECT order_id, order_date,
       ROUND(JULIANDAY('2024-06-01') - JULIANDAY(order_date)) AS days_old
FROM orders
LIMIT 8;

-- Expected:
-- 1001|2024-01-05|148
-- 1002|2024-01-07|146
-- ...

-- 4B. Customer tenure in days
SELECT first_name || ' ' || last_name AS customer,
       registration_date,
       ROUND(JULIANDAY('2024-06-01') - JULIANDAY(registration_date)) AS tenure_days
FROM customers
ORDER BY tenure_days DESC
LIMIT 5;

-- ============================================================
-- 5. DATE Arithmetic
-- ============================================================

-- 5A. Estimated delivery (+7 days)
SELECT order_id, order_date,
       DATE(order_date, '+7 days') AS est_delivery
FROM orders
LIMIT 5;

-- Expected:
-- 1001|2024-01-05|2024-01-12
-- 1002|2024-01-07|2024-01-14
-- 1003|2024-01-10|2024-01-17
-- 1004|2024-01-12|2024-01-19
-- 1005|2024-01-15|2024-01-22

-- 5B. Follow-up date (+1 month from registration)
SELECT first_name || ' ' || last_name AS customer,
       registration_date,
       DATE(registration_date, '+1 month') AS follow_up_date
FROM customers
LIMIT 5;

-- Expected:
-- Sarah Johnson|2023-01-15|2023-02-15
-- Mike Chen|2023-02-20|2023-03-20
-- Emma Davis|2023-03-10|2023-04-10
-- Alex Kumar|2023-01-25|2023-02-25
-- Olivia Martinez|2023-04-05|2023-05-05

-- ============================================================
-- 6. GROUP BY Date Parts
-- ============================================================

-- 6A. Monthly revenue trends
SELECT strftime('%Y-%m', order_date) AS month,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS revenue
FROM orders
WHERE status != 'Cancelled'
GROUP BY month
ORDER BY month;

-- Expected:
-- 2024-01|8|1515.98
-- 2024-02|11|2230.73
-- 2024-03|9|1975.74
-- 2024-04|11|2442.23
-- 2024-05|4|1112.5

-- 6B. Day-of-week analysis
SELECT CASE CAST(strftime('%w', order_date) AS INTEGER)
           WHEN 0 THEN 'Sunday'
           WHEN 1 THEN 'Monday'
           WHEN 2 THEN 'Tuesday'
           WHEN 3 THEN 'Wednesday'
           WHEN 4 THEN 'Thursday'
           WHEN 5 THEN 'Friday'
           WHEN 6 THEN 'Saturday'
       END AS weekday,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS revenue
FROM orders
GROUP BY strftime('%w', order_date)
ORDER BY strftime('%w', order_date);

-- Expected:
-- Sunday|7|1374.72
-- Monday|8|1660.74
-- Tuesday|6|1243.49
-- Wednesday|9|1725.98
-- Thursday|8|1591.5
-- Friday|7|1096.73
-- Saturday|5|583.25

-- 6C. Movies by decade
SELECT (CAST(strftime('%Y', release_year || '-01-01') AS INTEGER) / 10) * 10 AS decade,
       COUNT(*) AS movie_count,
       ROUND(AVG(rating), 2) AS avg_rating
FROM movies
GROUP BY decade
ORDER BY decade;

-- Expected:
-- 1970|1|9.2
-- 1990|8|8.41
-- 2000|10|8.38
-- 2010|14|8.07
-- 2020|7|7.87

-- ============================================================
-- 7. Real Business Examples
-- ============================================================

-- 7A. Customer purchase recency
SELECT c.first_name || ' ' || c.last_name AS customer,
       MAX(o.order_date) AS last_order_date,
       ROUND(JULIANDAY('2024-06-01') - JULIANDAY(MAX(o.order_date))) AS days_since_last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status != 'Cancelled'
GROUP BY c.customer_id
ORDER BY days_since_last_order DESC
LIMIT 5;

-- 7B. Employee tenure in years
SELECT first_name || ' ' || last_name AS employee,
       hire_date,
       ROUND((JULIANDAY('2024-06-01') - JULIANDAY(hire_date)) / 365.25, 1) AS tenure_years
FROM employees
ORDER BY tenure_years DESC;

-- Expected (first 3):
-- George Harris|2016-05-22|8.0
-- John Smith|2018-03-15|6.2
-- Julia Roberts|2018-08-08|5.8

-- ============================================================
-- Exercises (uncomment to run)
-- ============================================================

-- 1. Weekend vs weekday orders
-- SELECT
--     COUNT(CASE WHEN CAST(strftime('%w', order_date) AS INTEGER) IN (0,6) THEN 1 END) AS weekend_count,
--     COUNT(CASE WHEN CAST(strftime('%w', order_date) AS INTEGER) NOT IN (0,6) THEN 1 END) AS weekday_count
-- FROM orders;

-- 2. Quarterly revenue
-- SELECT
--     CASE
--         WHEN CAST(strftime('%m', order_date) AS INTEGER) BETWEEN 1 AND 3 THEN 'Q1'
--         WHEN CAST(strftime('%m', order_date) AS INTEGER) BETWEEN 4 AND 6 THEN 'Q2'
--         WHEN CAST(strftime('%m', order_date) AS INTEGER) BETWEEN 7 AND 9 THEN 'Q3'
--         ELSE 'Q4'
--     END AS quarter,
--     ROUND(SUM(total_amount), 2) AS revenue
-- FROM orders
-- WHERE status != 'Cancelled'
-- GROUP BY quarter
-- ORDER BY quarter;

-- 3. Order aging for pending orders
-- SELECT order_id, order_date,
--        ROUND(JULIANDAY('2024-06-01') - JULIANDAY(order_date)) AS days_pending
-- FROM orders
-- WHERE status = 'Pending'
-- ORDER BY days_pending DESC;

-- 4. Employees hired by month
-- SELECT CASE CAST(strftime('%m', hire_date) AS INTEGER)
--            WHEN 1 THEN 'January' WHEN 2 THEN 'February'
--            WHEN 3 THEN 'March' WHEN 4 THEN 'April'
--            WHEN 5 THEN 'May' WHEN 6 THEN 'June'
--            WHEN 7 THEN 'July' WHEN 8 THEN 'August'
--            WHEN 9 THEN 'September' WHEN 10 THEN 'October'
--            WHEN 11 THEN 'November' WHEN 12 THEN 'December'
--        END AS month_name,
--        COUNT(*) AS hire_count
-- FROM employees
-- GROUP BY strftime('%m', hire_date)
-- ORDER BY strftime('%m', hire_date);

-- 5. 7-day rolling order count (self-join)
-- SELECT a.order_date,
--        COUNT(b.order_id) AS orders_in_prior_7_days
-- FROM orders a
-- LEFT JOIN orders b ON b.order_date >= DATE(a.order_date, '-7 days')
--                    AND b.order_date < a.order_date
-- GROUP BY a.order_date
-- ORDER BY a.order_date
-- LIMIT 10;

-- ============================================================
-- 🔥 Mini Challenges (uncomment to run)
-- ============================================================

-- 1. First order of each month
-- SELECT strftime('%Y-%m', order_date) AS month,
--        MIN(order_id) AS first_order_id,
--        MIN(order_date) AS first_order_date
-- FROM orders
-- GROUP BY month
-- ORDER BY month;

-- 2. Month-over-month revenue growth
-- SELECT month,
--        revenue,
--        LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
--        ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month) * 100, 2) AS growth_pct
-- FROM (
--     SELECT strftime('%Y-%m', order_date) AS month,
--            ROUND(SUM(total_amount), 2) AS revenue
--     FROM orders
--     WHERE status != 'Cancelled'
--     GROUP BY month
-- )
-- ORDER BY month;
