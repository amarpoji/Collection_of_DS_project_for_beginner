-- ============================================================
-- Lesson 18: Query Optimization
-- SQL File with REAL outputs from sqlite3
-- ============================================================

-- ============================================================
-- 1. Understanding EXPLAIN QUERY PLAN
-- ============================================================

-- Full table scan (no WHERE clause)
EXPLAIN QUERY PLAN SELECT * FROM employees;
-- Output: (2, 0, 0, 'SCAN employees')
-- SCAN = full table scan — reads every row

-- Full table scan with ORDER BY (needs temp B-tree)
EXPLAIN QUERY PLAN SELECT * FROM employees ORDER BY salary;
-- Output: (3, 0, 0, 'SCAN employees')
--         (19, 0, 0, 'USE TEMP B-TREE FOR ORDER BY')
-- Two operations: scan all rows + sort with temporary B-tree

-- Filter without index = still full scan
EXPLAIN QUERY PLAN SELECT * FROM employees WHERE salary > 100000;
-- Output: (2, 0, 0, 'SCAN employees')
-- salary has no index, so SQLite must examine every row

-- Filter WITH index = efficient
EXPLAIN QUERY PLAN SELECT * FROM employees WHERE department_id = 1;
-- Output: (3, 0, 0, 'SEARCH employees USING INDEX idx_employees_department (department_id=?)')
-- SEARCH USING INDEX = efficient lookup via the index

-- ============================================================
-- 2. JOIN Operations
-- ============================================================

-- Simple JOIN between employees and departments
EXPLAIN QUERY PLAN
SELECT e.*, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
-- Output: (3, 0, 0, 'SCAN e')
--         (5, 0, 0, 'SEARCH d USING INTEGER PRIMARY KEY (rowid=?)')
-- SCAN on employees (outer table), then SEARCH departments by PK

-- ============================================================
-- 3. EXISTS vs IN vs JOIN
-- ============================================================

-- Approach 1: IN with subquery
EXPLAIN QUERY PLAN
SELECT e.* FROM employees e
WHERE e.department_id IN (
    SELECT department_id FROM departments WHERE budget > 500000
);
-- Output: (3, 0, 0, 'SEARCH e USING INDEX idx_employees_department (department_id=?)')
--         (7, 0, 0, 'LIST SUBQUERY 1')
--         (9, 7, 0, 'SCAN departments')
-- Uses the index on department_id - efficient

-- Approach 2: EXISTS with correlated subquery
EXPLAIN QUERY PLAN
SELECT e.* FROM employees e
WHERE EXISTS (
    SELECT 1 FROM departments d
    WHERE d.department_id = e.department_id AND d.budget > 500000
);
-- Output: (2, 0, 0, 'SCAN e')
--         (5, 0, 0, 'CORRELATED SCALAR SUBQUERY 1')
--         (9, 5, 0, 'SEARCH d USING INTEGER PRIMARY KEY (rowid=?)')
-- SCAN employees, then for EACH row run the subquery (correlated)
-- For small tables this is fine, but on large datasets IN is usually better

-- Approach 3: JOIN with DISTINCT
EXPLAIN QUERY PLAN
SELECT DISTINCT e.* FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.budget > 500000;
-- Output: (5, 0, 0, 'SCAN e USING INDEX idx_employees_department')
--         (8, 0, 0, 'SEARCH d USING INTEGER PRIMARY KEY (rowid=?)')
-- Index scan + PK lookup - also efficient

-- Actual results from all 3 approaches:
SELECT e.* FROM employees e WHERE e.department_id IN (
    SELECT department_id FROM departments WHERE budget > 500000
);
/*
employee_id|first_name|last_name|email|phone|hire_date|job_title|salary|department_id|manager_id
1|John|Smith|john.smith@company.com|555-0101|2018-03-15|Data Analyst|75000|1|
3|Bob|Johnson|bob.johnson@company.com|555-0103|2020-01-10|Data Scientist|110000|1|1
7|Edward|Norton|edward.norton@company.com|555-0107|2022-02-28|Data Engineer|100000|1|3
11|Ian|Clark|ian.clark@company.com|555-0111|2023-01-15|Jr Data Analyst|55000|1|3
2|Jane|Doe|jane.doe@company.com|555-0102|2019-06-20|Software Engineer|95000|2|1
5|Charlie|Brown|charlie.brown@company.com|555-0105|2021-04-18|Junior Developer|65000|2|2
9|George|Harris|george.harris@company.com|555-0109|2016-03-20|CTO|200000|2|1
13|Kevin|Bacon|kevin.bacon@company.com|555-0113|2019-11-01|DevOps Engineer|92000|2|9
4|Alice|Williams|alice.williams@company.com|555-0104|2017-11-05|Product Manager|105000|3|1
8|Fiona|Apple|fiona.apple@company.com|555-0108|2020-06-15|UX Designer|80000|3|4
6|Diana|Prince|diana.prince@company.com|555-0106|2019-07-01|Marketing Lead|85000|4|1
10|Hannah|Martin|hannah.martin@company.com|555-0110|2021-09-01|Marketing Analyst|60000|4|6
14|Laura|Wilson|laura.wilson@company.com|555-0114|2020-04-01|Sales Representative|70000|6|15
15|Michael|Jordan|michael.jordan@company.com|555-0115|2017-10-01|Sales Manager|130000|6|1
*/

-- ============================================================
-- 4. Avoiding N+1 Query Problems
-- ============================================================

-- BAD: N+1 pattern (conceptual - you'd do this in application code)
-- 1 query to get employees + N queries to get each department
-- This would look like:
--   SELECT * FROM employees;  -- 1 query
--   SELECT * FROM departments WHERE department_id = ?; -- for each employee (N queries)

-- GOOD: Single JOIN query
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS employee_name,
       d.department_name, d.location
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY e.employee_id;

/*
employee_id|employee_name|department_name|location
1|John Smith|Data & Analytics|New York
2|Jane Doe|Engineering|San Francisco
3|Bob Johnson|Data & Analytics|New York
4|Alice Williams|Product|New York
5|Charlie Brown|Engineering|San Francisco
6|Diana Prince|Marketing|Chicago
7|Edward Norton|Data & Analytics|New York
8|Fiona Apple|Product|New York
9|George Harris|Engineering|San Francisco
10|Hannah Martin|Marketing|Chicago
11|Ian Clark|Data & Analytics|New York
12|Julia Roberts|Human Resources|New York
13|Kevin Bacon|Engineering|San Francisco
14|Laura Wilson|Sales|Denver
15|Michael Jordan|Sales|Denver
*/

-- ============================================================
-- 5. Column Selection (Avoid SELECT *)
-- ============================================================

-- BAD: SELECT * (retrieves unnecessary columns)
EXPLAIN QUERY PLAN SELECT * FROM orders WHERE customer_id = 5;
-- (Uses idx_orders_customer which is good, but returns all columns)

-- GOOD: SELECT specific columns (less data transfer)
EXPLAIN QUERY PLAN
SELECT order_id, order_date, total_amount
FROM orders
WHERE customer_id = 5;
-- Same plan, but less data transferred from disk and over network

-- Actual comparison:
SELECT * FROM orders WHERE customer_id = 5;
/*
order_id|customer_id|order_date|status|total_amount|payment_method|shipping_city|shipping_state
1009|5|2024-01-22|Delivered|567.0|Credit Card|Phoenix|AZ
1020|5|2024-02-18|Shipped|48.75|Debit Card|Phoenix|AZ
1045|5|2024-05-08|Pending|114.0|Credit Card|Phoenix|AZ
*/

SELECT order_id, order_date, total_amount FROM orders WHERE customer_id = 5;
/*
order_id|order_date|total_amount
1009|2024-01-22|567.0
1020|2024-02-18|48.75
1045|2024-05-08|114.0
*/

-- ============================================================
-- 6. Optimizing GROUP BY with Indexes
-- ============================================================

-- GROUP BY on indexed column
EXPLAIN QUERY PLAN
SELECT status, COUNT(*), ROUND(AVG(total_amount), 2) as avg_amount
FROM orders
GROUP BY status;
-- Uses the idx_orders_status index for grouping

SELECT status, COUNT(*), ROUND(AVG(total_amount), 2) as avg_amount
FROM orders
GROUP BY status;
/*
status|COUNT(*)|avg_amount
Cancelled|4|136.87
Delivered|24|232.63
Pending|5|202.8
Processing|8|218.19
Shipped|9|196.46
*/

-- ============================================================
-- 7. Before/After Optimization Comparison
-- ============================================================

-- "Before": Full scan on salary (no index)
EXPLAIN QUERY PLAN
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > 100000
ORDER BY salary DESC;
-- Output: (2, 0, 0, 'SCAN employees')
--         (19, 0, 0, 'USE TEMP B-TREE FOR ORDER BY')

-- "After": If we CREATE INDEX on salary, the plan would change to:
-- SEARCH employees USING INDEX (salary=?) — but we haven't created it yet
-- See Lesson 19 for indexing examples

-- ============================================================
-- 🔥 Challenge: Analyze and optimize these queries
-- ============================================================

-- 1. Check the query plan for: SELECT * FROM products WHERE unit_price > 50
-- 2. Rewrite this query to be more efficient:
--    SELECT * FROM employees WHERE department_id IN (1,2,3)
-- 3. Compare EXISTS vs IN for: employees in high-budget departments
-- 4. Write a query that finds employees earning above their department's average
-- 5. Create a query that avoids SELECT * and uses proper column selection

-- Solution to challenge 4 (correlated subquery - harder to optimize):
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS name,
       e.salary, e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary) FROM employees WHERE department_id = e.department_id
)
ORDER BY e.department_id;

/*
employee_id|name|salary|department_id
3|Bob Johnson|110000|1
12|Julia Roberts|78000|5
6|Diana Prince|85000|4
13|Kevin Bacon|92000|2
*/
