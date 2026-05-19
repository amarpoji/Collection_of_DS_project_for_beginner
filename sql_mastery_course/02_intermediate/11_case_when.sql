-- ========================================================================
-- LESSON 11: CASE WHEN — Conditional Logic in SQL
-- Target: sqlite3 /mnt/c/Users/USER/.../sql_mastery.db
-- ========================================================================

-- ============================================================
-- 1. Simple CASE Expression — Compare one expr against values
-- ============================================================

-- 1A. Categorize departments by location
SELECT department_name, location,
       CASE location
           WHEN 'New York' THEN 'Headquarters'
           WHEN 'San Francisco' THEN 'West Coast Hub'
           ELSE 'Regional Office'
       END AS office_type
FROM departments;

-- Expected:
-- Data & Analytics|New York|Headquarters
-- Engineering|San Francisco|West Coast Hub
-- Product|New York|Headquarters
-- Marketing|Chicago|Regional Office
-- Human Resources|New York|Headquarters
-- Sales|Denver|Regional Office

-- ============================================================
-- 2. Searched CASE — Independent Boolean conditions
-- ============================================================

-- 2A. Salary brackets
SELECT first_name || ' ' || last_name AS employee,
       salary,
       CASE
           WHEN salary < 65000 THEN 'Low'
           WHEN salary BETWEEN 65000 AND 90000 THEN 'Medium'
           WHEN salary BETWEEN 90001 AND 130000 THEN 'High'
           ELSE 'Executive'
       END AS salary_bracket
FROM employees
ORDER BY salary;

-- Expected (truncated):
-- Ian Clark|55000.0|Low
-- Hannah Martin|60000.0|Low
-- Charlie Brown|65000.0|Medium
-- ...
-- George Harris|200000.0|Executive

-- 2B. Order size categories
SELECT order_id, total_amount,
       CASE
           WHEN total_amount < 100 THEN 'Small'
           WHEN total_amount BETWEEN 100 AND 300 THEN 'Medium'
           ELSE 'Large'
       END AS order_size
FROM orders
LIMIT 10;

-- Expected:
-- 1001|125.99|Medium
-- 1002|89.5|Small
-- 1003|249.99|Medium
-- 1004|45.0|Small
-- 1005|310.25|Large
-- 1006|78.5|Small
-- 1007|199.99|Medium
-- 1008|55.0|Small
-- 1009|420.0|Large
-- 1010|67.75|Small

-- 2C. Movie rating buckets
SELECT title, rating,
       CASE
           WHEN rating >= 9.0 THEN 'Masterpiece'
           WHEN rating >= 8.0 THEN 'Excellent'
           WHEN rating >= 7.0 THEN 'Good'
           ELSE 'Average'
       END AS rating_category
FROM movies
ORDER BY rating DESC
LIMIT 10;

-- Expected:
-- The Shawshank Redemption|9.3|Masterpiece
-- The Godfather|9.2|Masterpiece
-- The Dark Knight|9.0|Masterpiece
-- Pulp Fiction|8.9|Excellent
-- ...

-- 2D. Airbnb revenue tiers
SELECT property_name, price, nights_booked,
       price * nights_booked AS estimated_revenue,
       CASE
           WHEN price * nights_booked < 15000 THEN 'Bronze'
           WHEN price * nights_booked BETWEEN 15000 AND 30000 THEN 'Silver'
           WHEN price * nights_booked BETWEEN 30001 AND 50000 THEN 'Gold'
           ELSE 'Platinum'
       END AS revenue_tier
FROM airbnb_listings
ORDER BY estimated_revenue DESC
LIMIT 8;

-- Expected:
-- The Penthouse Suite|600.0|60|36000|Gold
-- City View Penthouse|450.0|90|40500|Gold
-- ...

-- ============================================================
-- 3. CASE with GROUP BY — Pivot-Style Analysis
-- ============================================================

-- 3A. Count orders by status per month
SELECT strftime('%Y-%m', order_date) AS month,
       COUNT(CASE WHEN status = 'Delivered' THEN 1 END) AS delivered,
       COUNT(CASE WHEN status = 'Shipped' THEN 1 END) AS shipped,
       COUNT(CASE WHEN status = 'Pending' THEN 1 END) AS pending,
       COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) AS cancelled,
       COUNT(*) AS total
FROM orders
GROUP BY month
ORDER BY month;

-- Expected:
-- 2024-01|6|1|1|1|9
-- 2024-02|8|2|1|1|12
-- 2024-03|6|2|1|1|10
-- 2024-04|6|3|2|1|12
-- 2024-05|3|1|0|0|4

-- 3B. Revenue by payment method per quarter
SELECT CASE
           WHEN order_date BETWEEN '2024-01-01' AND '2024-03-31' THEN 'Q1'
           WHEN order_date BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Q2'
       END AS quarter,
       ROUND(SUM(CASE WHEN payment_method = 'Credit Card' THEN total_amount ELSE 0 END), 2) AS credit_card,
       ROUND(SUM(CASE WHEN payment_method = 'PayPal' THEN total_amount ELSE 0 END), 2) AS paypal,
       ROUND(SUM(CASE WHEN payment_method = 'Debit Card' THEN total_amount ELSE 0 END), 2) AS debit_card,
       ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
WHERE status != 'Cancelled'
GROUP BY quarter
ORDER BY quarter;

-- Expected:
-- Q1|1435.46|1450.23|1266.52|4152.21
-- Q2|1888.49|1068.74|1400.73|4357.96

-- 3C. Employee count by department and salary tier
SELECT d.department_name,
       COUNT(CASE WHEN e.salary < 70000 THEN 1 END) AS junior,
       COUNT(CASE WHEN e.salary BETWEEN 70000 AND 100000 THEN 1 END) AS mid,
       COUNT(CASE WHEN e.salary > 100000 THEN 1 END) AS senior,
       COUNT(*) AS total_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY d.department_name;

-- Expected:
-- Data & Analytics|1|1|2|4
-- Engineering|1|1|2|4
-- Human Resources|0|1|0|1
-- Marketing|1|1|0|2
-- Product|0|1|1|2
-- Sales|0|1|1|2

-- ============================================================
-- Exercises (uncomment to run)
-- ============================================================

-- 1. Customer age groups
-- SELECT first_name || ' ' || last_name AS customer, age,
--        CASE
--            WHEN age < 25 THEN 'Young'
--            WHEN age BETWEEN 25 AND 40 THEN 'Adult'
--            ELSE 'Senior'
--        END AS age_group
-- FROM customers
-- ORDER BY age;

-- 2. Product stock status
-- SELECT product_name, stock_quantity,
--        CASE
--            WHEN stock_quantity < 50 THEN 'Low'
--            WHEN stock_quantity BETWEEN 50 AND 150 THEN 'Medium'
--            ELSE 'High'
--        END AS stock_status
-- FROM products
-- ORDER BY stock_quantity;

-- 3. Movie profitability
-- SELECT title, revenue_millions,
--        CASE
--            WHEN revenue_millions > 500 THEN 'Blockbuster'
--            WHEN revenue_millions BETWEEN 200 AND 500 THEN 'Hit'
--            WHEN revenue_millions BETWEEN 50 AND 200 THEN 'Moderate'
--            ELSE 'Flop'
--        END AS profit_category
-- FROM movies
-- ORDER BY revenue_millions DESC;

-- 4. Revenue by room type across neighbourhoods (pivot)
-- SELECT neighbourhood,
--        COUNT(CASE WHEN room_type = 'Entire home/apt' THEN 1 END) AS entire_home,
--        COUNT(CASE WHEN room_type = 'Private room' THEN 1 END) AS private_room
-- FROM airbnb_listings
-- GROUP BY neighbourhood
-- ORDER BY neighbourhood;

-- 5. Order value segments (requires subquery)
-- SELECT c.first_name || ' ' || c.last_name AS customer,
--        ROUND(SUM(o.total_amount), 2) AS total_spent,
--        CASE
--            WHEN SUM(o.total_amount) < 200 THEN 'Low'
--            WHEN SUM(o.total_amount) BETWEEN 200 AND 500 THEN 'Medium'
--            ELSE 'High'
--        END AS segment
-- FROM customers c
-- JOIN orders o ON c.customer_id = o.customer_id
-- WHERE o.status != 'Cancelled'
-- GROUP BY c.customer_id
-- ORDER BY total_spent DESC;

-- ============================================================
-- 🔥 Mini Challenges (uncomment to run)
-- ============================================================

-- 1. Dynamic salary band report by department
-- SELECT d.department_name,
--        COUNT(CASE WHEN e.salary BETWEEN 0 AND 60000 THEN 1 END) AS band_0_60k,
--        COUNT(CASE WHEN e.salary BETWEEN 60001 AND 80000 THEN 1 END) AS band_60_80k,
--        COUNT(CASE WHEN e.salary BETWEEN 80001 AND 100000 THEN 1 END) AS band_80_100k,
--        COUNT(CASE WHEN e.salary BETWEEN 100001 AND 130000 THEN 1 END) AS band_100_130k,
--        COUNT(CASE WHEN e.salary > 130000 THEN 1 END) AS band_130k_plus
-- FROM employees e
-- JOIN departments d ON e.department_id = d.department_id
-- GROUP BY d.department_name
-- ORDER BY d.department_name;

-- 2. Bonus calculation
-- SELECT first_name || ' ' || last_name AS employee,
--        salary,
--        CASE
--            WHEN salary < 70000 THEN 15
--            WHEN salary BETWEEN 70000 AND 100000 THEN 10
--            ELSE 5
--        END AS bonus_pct,
--        ROUND(salary *
--            CASE
--                WHEN salary < 70000 THEN 0.15
--                WHEN salary BETWEEN 70000 AND 100000 THEN 0.10
--                ELSE 0.05
--            END, 2) AS bonus_amount
-- FROM employees
-- ORDER BY salary;
