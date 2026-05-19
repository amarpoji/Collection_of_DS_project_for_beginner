-- ============================================================
-- LESSON 10: Subqueries — Queries Within Queries
-- Target: sqlite3 /mnt/c/Users/USER/.../sql_mastery.db
-- ========================================================================

-- ============================================================
-- 1. Subquery in WHERE
-- ============================================================

-- Employees earning more than the average salary
SELECT first_name || ' ' || last_name AS employee,
       job_title, salary
FROM employees
WHERE salary > (SELECT ROUND(AVG(salary), 2) FROM employees)
ORDER BY salary DESC;

-- Customers who have placed orders with status 'Shipped'
SELECT customer_id, first_name || ' ' || last_name AS customer
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE status = 'Shipped'
);

-- ============================================================
-- 2. Subquery in SELECT (Scalar Subquery)
-- ============================================================

-- Each employee's salary vs company average
SELECT first_name || ' ' || last_name AS employee,
       salary,
       ROUND((SELECT AVG(salary) FROM employees), 2) AS company_avg,
       ROUND(salary - (SELECT AVG(salary) FROM employees), 2) AS diff_from_avg
FROM employees
ORDER BY diff_from_avg DESC;

-- ============================================================
-- 3. Subquery in FROM (Derived Table)
-- ============================================================

-- Monthly revenue summary (filtering on aggregate)
SELECT month, ROUND(revenue, 2) AS revenue
FROM (
    SELECT SUBSTR(order_date, 1, 7) AS month,
           SUM(total_amount) AS revenue
    FROM orders
    WHERE status != 'Cancelled'
    GROUP BY month
) AS monthly_rev
WHERE revenue > 1500
ORDER BY month;

-- Top 3 highest-paid by department using derived table
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
) ranked
WHERE rn <= 3;

-- ============================================================
-- 4. EXISTS and NOT EXISTS
-- ============================================================

-- Customers with at least one order
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- Employees who are NOT managers (no one reports to them)
SELECT e1.employee_id, e1.first_name || ' ' || e1.last_name AS employee
FROM employees e1
WHERE NOT EXISTS (
    SELECT 1 FROM employees e2
    WHERE e2.manager_id = e1.employee_id
)
AND e1.manager_id != 'NULL';

-- ============================================================
-- 5. ANY and ALL Operators
-- ============================================================

-- Employees who earn more than ANY employee in Sales
SELECT first_name || ' ' || last_name AS employee, salary
FROM employees
WHERE salary > ANY (
    SELECT salary FROM employees
    JOIN departments d ON employees.department_id = d.department_id
    WHERE d.department_name = 'Sales'
);

-- Employees who earn more than ALL employees in Sales
SELECT first_name || ' ' || last_name AS employee, salary
FROM employees
WHERE salary > ALL (
    SELECT salary FROM employees
    JOIN departments d ON employees.department_id = d.department_id
    WHERE d.department_name = 'Sales'
);

-- ============================================================
-- 6. Correlated Subqueries
-- ============================================================

-- Employees earning more than their department's average
SELECT e1.first_name || ' ' || e1.last_name AS employee,
       e1.salary,
       d.department_name
FROM employees e1
JOIN departments d ON e1.department_id = d.department_id
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
)
ORDER BY d.department_name;

-- For each order, compare to customer's average
SELECT o.order_id, o.customer_id, o.total_amount,
       (SELECT ROUND(AVG(o2.total_amount), 2)
        FROM orders o2
        WHERE o2.customer_id = o.customer_id
          AND o2.status != 'Cancelled') AS customer_avg,
       CASE WHEN o.total_amount > (
               SELECT AVG(o2.total_amount)
               FROM orders o2
               WHERE o2.customer_id = o.customer_id
                 AND o2.status != 'Cancelled'
           ) THEN 'Above Avg' ELSE 'Below Avg' END AS comparison
FROM orders o
WHERE o.status != 'Cancelled'
LIMIT 10;

-- ============================================================
-- 🔥 Mini Challenges
-- ============================================================

-- MC1: Second-highest salary per department (correlated subquery)
SELECT d.department_name,
       e.first_name || ' ' || e.last_name AS employee,
       e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE (
    SELECT COUNT(DISTINCT e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
      AND e2.salary > e.salary
) = 1
ORDER BY d.department_name, e.salary DESC;

-- MC2: Customers who spent more than ANY customer in a different state
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer,
       c.state,
       ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING total_spent > ANY (
    SELECT ROUND(SUM(o2.total_amount), 2)
    FROM customers c2
    JOIN orders o2 ON c2.customer_id = o2.customer_id
    WHERE c2.state != c.state
    GROUP BY c2.customer_id
)
ORDER BY total_spent DESC;
