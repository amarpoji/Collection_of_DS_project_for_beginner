-- ============================================================
-- LESSON 09: JOINs — Combining Data from Multiple Tables
-- Target: sqlite3 /mnt/c/Users/USER/.../sql_mastery.db
-- ========================================================================

-- ============================================================
-- 1. INNER JOIN — Only Matching Rows
-- ============================================================

-- 1A. Orders with customer names
SELECT o.order_id, o.order_date, o.total_amount,
       c.first_name || ' ' || c.last_name AS customer,
       c.city, c.state
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LIMIT 5;

-- 1B. Employees with their department names
SELECT e.first_name || ' ' || e.last_name AS employee,
       e.job_title, e.salary,
       d.department_name, d.location
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- ============================================================
-- 2. LEFT JOIN — All Rows from Left, Matching from Right
-- ============================================================

-- 2A. All customers with their orders (NULL if no order)
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer,
       o.order_id, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- 2B. Customers who have NO orders (using LEFT JOIN + IS NULL)
SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- ============================================================
-- 3. Simulating RIGHT JOIN (SQLite workaround)
-- ============================================================

-- All departments, even those with no employees
SELECT d.department_name, e.first_name || ' ' || e.last_name AS employee
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id;

-- ============================================================
-- 4. FULL OUTER JOIN Simulation (LEFT JOIN UNION LEFT JOIN)
-- ============================================================

-- All employees and all departments, matched where possible
SELECT e.first_name || ' ' || e.last_name AS employee,
       d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
UNION
SELECT e.first_name || ' ' || e.last_name AS employee,
       d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

-- ============================================================
-- 5. Multi-Table JOIN (orders → order_items → products)
-- ============================================================

SELECT o.order_id, o.order_date,
       c.first_name || ' ' || c.last_name AS customer,
       p.product_name,
       oi.quantity, oi.unit_price,
       ROUND(oi.quantity * oi.unit_price, 2) AS line_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_id = 1001
ORDER BY line_total DESC;

-- ============================================================
-- 6. Self-Join: Employees with their Managers
-- ============================================================

SELECT e1.first_name || ' ' || e1.last_name AS employee,
       e1.job_title,
       e2.first_name || ' ' || e2.last_name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id
WHERE e1.manager_id != 'NULL'
ORDER BY e1.employee_id;

-- ============================================================
-- 7. Real Business Examples
-- ============================================================

-- 7A. Department budget vs actual salary spend
SELECT d.department_name, d.budget,
       ROUND(SUM(e.salary), 2) AS total_salaries,
       ROUND(d.budget - SUM(e.salary), 2) AS remaining
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id
ORDER BY remaining DESC;

-- 7B. Top customers by lifetime value
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer,
       COUNT(o.order_id) AS order_count,
       ROUND(SUM(o.total_amount), 2) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY lifetime_value DESC
LIMIT 5;

-- 7C. Products that have never been ordered
SELECT p.product_id, p.product_name, p.category, p.unit_price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.item_id IS NULL;

-- ============================================================
-- 🔥 Mini Challenges
-- ============================================================

-- MC1: Full outer join with 'No Match' markers
SELECT e.first_name || ' ' || e.last_name AS employee,
       COALESCE(d.department_name, 'No Match') AS department
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
UNION
SELECT 'No Match' AS employee,
       d.department_name AS department
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

-- MC2: For each employee, find who was hired just before them
-- (Self-join on hire date)
SELECT e1.first_name || ' ' || e1.last_name AS employee,
       e1.hire_date,
       e2.first_name || ' ' || e2.last_name AS prev_hire,
       e2.hire_date AS prev_hire_date
FROM employees e1
LEFT JOIN employees e2 ON e2.hire_date < e1.hire_date
GROUP BY e1.employee_id
HAVING e2.hire_date = MAX(e2.hire_date)
ORDER BY e1.hire_date;
