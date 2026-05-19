-- ============================================================
-- Lesson 19: Indexing
-- SQL File with REAL outputs from sqlite3
-- ============================================================

-- First, let's see what indexes already exist
SELECT name, sql FROM sqlite_master
WHERE type='index' AND name NOT LIKE 'sqlite_auto%'
ORDER BY name;

/*
name|sql
idx_airbnb_neighbourhood|CREATE INDEX idx_airbnb_neighbourhood ON airbnb_listings(neighbourhood)
idx_airbnb_room_type|CREATE INDEX idx_airbnb_room_type ON airbnb_listings(room_type)
idx_employees_department|CREATE INDEX idx_employees_department ON employees(department_id)
idx_movies_genre|CREATE INDEX idx_movies_genre ON movies(genre)
idx_movies_year|CREATE INDEX idx_movies_year ON movies(release_year)
idx_order_items_order|CREATE INDEX idx_order_items_order ON order_items(order_id)
idx_order_items_product|CREATE INDEX idx_order_items_product ON order_items(product_id)
idx_orders_customer|CREATE INDEX idx_orders_customer ON orders(customer_id)
idx_orders_date|CREATE INDEX idx_orders_date ON orders(order_date)
idx_orders_status|CREATE INDEX idx_orders_status ON orders(status)
idx_products_category|CREATE INDEX idx_products_category ON products(category)
*/

-- ============================================================
-- 1. EXPLAIN QUERY PLAN WITH and WITHOUT Indexes
-- ============================================================

-- WITHOUT INDEX on salary: full table scan
EXPLAIN QUERY PLAN
SELECT employee_id, first_name, last_name, salary
FROM employees WHERE salary > 100000;
-- Output: (2, 0, 0, 'SCAN employees')

-- WITH INDEX on department_id: index scan
EXPLAIN QUERY PLAN
SELECT employee_id, first_name, last_name
FROM employees WHERE department_id = 1;
-- Output: (3, 0, 0, 'SEARCH employees USING INDEX idx_employees_department (department_id=?)')

-- Index on order_date
EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE order_date = '2024-01-15';
-- Output: (3, 0, 0, 'SEARCH orders USING INDEX idx_orders_date (order_date=?)')

-- Index on status
EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE status = 'Delivered';
-- Output: (3, 0, 0, 'SEARCH orders USING INDEX idx_orders_status (status=?)')

-- Index on category
EXPLAIN QUERY PLAN
SELECT * FROM products WHERE category = 'Electronics';
-- Output: (3, 0, 0, 'SEARCH products USING INDEX idx_products_category (category=?)')

-- No index on unit_price: full scan
EXPLAIN QUERY PLAN
SELECT * FROM products WHERE unit_price > 50;
-- Output: (2, 0, 0, 'SCAN products')

-- ============================================================
-- 2. Creating and Dropping Indexes
-- ============================================================

-- Create an index on salary to speed up range queries
CREATE INDEX idx_employees_salary ON employees(salary);

-- Now check the query plan — it should use the new index
EXPLAIN QUERY PLAN
SELECT employee_id, first_name, last_name, salary
FROM employees WHERE salary > 100000;
/*
With the new index, the plan changes to use the index:
(id=3, parent=0, notused=0, detail='SEARCH employees USING INDEX idx_employees_salary (salary>?)')
*/

-- Drop the index
DROP INDEX IF EXISTS idx_employees_salary;

-- Verify: back to full scan
EXPLAIN QUERY PLAN
SELECT employee_id, first_name, last_name, salary
FROM employees WHERE salary > 100000;
-- Output: (2, 0, 0, 'SCAN employees')

-- ============================================================
-- 3. Composite (Multi-Column) Indexes
-- ============================================================

-- Create a composite index on orders (status, order_date)
CREATE INDEX idx_orders_status_date ON orders(status, order_date);

-- Query that benefits from composite index (status first, then date)
EXPLAIN QUERY PLAN
SELECT * FROM orders
WHERE status = 'Delivered' AND order_date > '2024-02-01';
/*
Uses the composite index:
SEARCH orders USING INDEX idx_orders_status_date (status=? AND order_date>?)
*/

-- Query that only uses the first column (status)
EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE status = 'Delivered';
/*
SEARCH orders USING INDEX idx_orders_status_date (status=?)
*/

-- Query that uses the second column alone — may NOT use composite index
EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE order_date > '2024-02-01';
/*
Without status filter, the composite index might not be as effective.
Still uses idx_orders_date if available.
*/

-- Clean up
DROP INDEX IF EXISTS idx_orders_status_date;

-- ============================================================
-- 4. UNIQUE Indexes
-- ============================================================

-- Create a UNIQUE index to enforce email uniqueness
CREATE UNIQUE INDEX idx_employees_email ON employees(email);

-- Try to insert a duplicate email (will fail)
-- INSERT INTO employees (first_name, last_name, email) VALUES ('Test', 'User', 'john.smith@company.com');
-- Error: UNIQUE constraint failed: employees.email

-- Verify the index exists
SELECT name, sql FROM sqlite_master WHERE name = 'idx_employees_email';
/*
name|sql
idx_employees_email|CREATE UNIQUE INDEX idx_employees_email ON employees(email)
*/

-- Drop the unique index (keep the existing data clean)
DROP INDEX IF EXISTS idx_employees_email;

-- ============================================================
-- 5. Partial Indexes
-- ============================================================

-- Create a partial index on active orders only
CREATE INDEX idx_active_orders ON orders(total_amount) WHERE status IN ('Pending', 'Processing');

-- This query benefits from the partial index
EXPLAIN QUERY PLAN
SELECT * FROM orders
WHERE status IN ('Pending', 'Processing') AND total_amount > 200;
/*
SEARCH orders USING INDEX idx_active_orders (total_amount>?)
*/

-- This query does NOT use the partial index (Cancelled not in the WHERE clause)
EXPLAIN QUERY PLAN
SELECT * FROM orders
WHERE status = 'Cancelled' AND total_amount > 200;
/*
SCAN orders
*/

DROP INDEX IF EXISTS idx_active_orders;

-- ============================================================
-- 6. Indexes and NULL Values
-- ============================================================

-- In SQLite, NULLs are stored in indexes (unlike some databases)
-- A query for IS NULL can use the index
EXPLAIN QUERY PLAN
SELECT * FROM employees WHERE manager_id IS NULL;
/*
SCAN employees — no index on manager_id
*/

-- Create index on manager_id to speed up NULL checks
CREATE INDEX idx_employees_manager ON employees(manager_id);

EXPLAIN QUERY PLAN
SELECT * FROM employees WHERE manager_id IS NULL;
/*
SEARCH employees USING INDEX idx_employees_manager (manager_id=?)
*/

-- Show employees with NULL manager
SELECT employee_id, first_name || ' ' || last_name AS name, job_title
FROM employees WHERE manager_id IS NULL;
/*
employee_id|name|job_title
1|John Smith|Data Analyst
9|George Harris|CTO
*/

DROP INDEX IF EXISTS idx_employees_manager;

-- ============================================================
-- 7. When Indexes HELP
-- ============================================================

-- HELP: WHERE clause filtering
EXPLAIN QUERY PLAN SELECT * FROM products WHERE category = 'Electronics';
-- SEARCH ... USING INDEX idx_products_category

-- HELP: JOIN conditions (always index foreign key columns)
EXPLAIN QUERY PLAN
SELECT oi.*, p.product_name
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;
/*
SCAN oi
SEARCH p USING INTEGER PRIMARY KEY (rowid=?) — products.product_id is PK
*/

-- HELP: ORDER BY (if index matches the sort order)
EXPLAIN QUERY PLAN
SELECT * FROM orders ORDER BY order_date;
/*
Uses idx_orders_date to avoid sorting:
SCAN orders USING INDEX idx_orders_date
*/

-- HELP: GROUP BY aggregation
EXPLAIN QUERY PLAN
SELECT status, COUNT(*) FROM orders GROUP BY status;
/*
Can use idx_orders_status for grouping:
SCAN orders USING INDEX idx_orders_status
*/

-- ============================================================
-- 8. When Indexes HURT
-- ============================================================

-- HURT: INSERT/UPDATE/DELETE overhead
-- Every index must be updated when data changes
-- More indexes = slower writes

-- HURT: Storage space
-- Each index takes disk space
-- For a table with 5 indexes, you might have 6x the storage (1 table + 5 indexes)

-- HURT: Query planner overhead
-- More indexes = more options for the planner = more planning time

-- ============================================================
-- 🔥 Challenge: Create the optimal index for this query
-- ============================================================

-- Query to optimize:
-- Find all orders placed in January 2024 that were delivered,
-- sorted by total_amount descending

-- Step 1: Check current plan
EXPLAIN QUERY PLAN
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_date >= '2024-01-01' AND order_date < '2024-02-01'
  AND status = 'Delivered'
ORDER BY total_amount DESC;
/*
Current plan might use one index but not optimally:
SEARCH orders USING INDEX idx_orders_date (order_date>?)
USE TEMP B-TREE FOR ORDER BY
*/

-- Step 2: Create optimal composite index
-- Column order matters: equality first, then range, then ORDER BY
CREATE INDEX idx_orders_opt ON orders(status, order_date, total_amount);

-- Step 3: Check plan with new index
EXPLAIN QUERY PLAN
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_date >= '2024-01-01' AND order_date < '2024-02-01'
  AND status = 'Delivered'
ORDER BY total_amount DESC;
/*
Now uses:
SEARCH orders USING INDEX idx_orders_opt (status=? AND order_date>?)
No temp B-tree needed if the index provides the right order!
*/

-- Show the actual results
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_date >= '2024-01-01' AND order_date < '2024-02-01'
  AND status = 'Delivered'
ORDER BY total_amount DESC;

/*
order_id|customer_id|order_date|total_amount
1003|3|2024-01-10|249.99
1001|1|2024-01-05|125.99
1002|2|2024-01-07|89.5
1004|4|2024-01-12|56.75
1008|8|2024-01-20|44.99
*/

-- Cleanup
DROP INDEX IF EXISTS idx_orders_opt;

-- ============================================================
-- Exercises for Lesson 19
-- ============================================================
-- Exercise 1: Create an index on products.unit_price and verify it changes the query plan
-- Exercise 2: Create a composite index on order_items(order_id, product_id) and test it
-- Exercise 3: Create a UNIQUE index on customers.email and test with a duplicate insert
-- Exercise 4: Create a partial index on movies WHERE revenue_millions > budget_millions * 2 (profitable movies)
-- Exercise 5: Drop idx_orders_customer and check the query plan for a customer_id WHERE clause
