# Lesson 10: Subqueries — Queries Within Queries

## Why Subqueries?

Sometimes you can't get the answer in a single SELECT. You need to compare each row against an aggregate (like "above average"), or use the result of one query as a filter or table for another. Subqueries (nested queries) solve this.

---

## 1. Subquery in WHERE — Filter with a Computed Value

### Example: Employees earning more than the average salary
```sql
SELECT first_name || ' ' || last_name AS employee,
       job_title, salary
FROM employees
WHERE salary > (SELECT ROUND(AVG(salary), 2) FROM employees)
ORDER BY salary DESC;
```

**Expected output**
```
employee|job_title|salary
George Harris|Engineering Director|200000.0
Michael Jordan|Sales Director|130000.0
Bob Johnson|Data Scientist|110000.0
Alice Williams|Product Manager|105000.0
Edward Norton|Data Analyst|100000.0
Jane Doe|Software Engineer|95000.0
Kevin Bacon|DevOps Engineer|92000.0
```

### Subquery with IN — Multiple values from another table
```sql
-- Find customers who have placed orders with status 'Shipped'
SELECT customer_id, first_name || ' ' || last_name AS customer
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE status = 'Shipped'
);
```

---

## 2. Subquery in SELECT — Scalar Subquery as a Column

Every row gets a computed column from a subquery that returns exactly **one value**.

### Example: Each employee's salary vs the company average
```sql
SELECT first_name || ' ' || last_name AS employee,
       salary,
       ROUND((SELECT AVG(salary) FROM employees), 2) AS company_avg,
       ROUND(salary - (SELECT AVG(salary) FROM employees), 2) AS diff_from_avg
FROM employees
ORDER BY diff_from_avg DESC;
```

---

## 3. Subquery in FROM — Derived Table

The subquery acts as a temporary table that the outer query selects from.

### Example: Monthly revenue summary
```sql
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
```

**Expected output**
```
month|revenue
2024-02|2230.73
2024-03|1975.74
2024-04|2442.23
```

### Example: Top 3 highest-paid by department using derived table
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
WHERE rn <= 3;
```

---

## 4. EXISTS and NOT EXISTS

`EXISTS` returns TRUE if the subquery returns at least one row. Often faster than `IN` for large datasets.

### Example: Customers who have at least one order
```sql
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);
```

### Example: Employees who are NOT managers (no one reports to them)
```sql
SELECT e1.employee_id, e1.first_name || ' ' || e1.last_name AS employee
FROM employees e1
WHERE NOT EXISTS (
    SELECT 1 FROM employees e2
    WHERE e2.manager_id = e1.employee_id
)
AND e1.manager_id != 'NULL';  -- exclude top-level
```

---

## 5. ANY and ALL Operators

Compare a value against a list from a subquery.

### ANY — true if the comparison holds for ANY value in the subquery
```sql
-- Employees who earn more than ANY employee in the 'Sales' department
SELECT first_name || ' ' || last_name AS employee, salary
FROM employees
WHERE salary > ANY (
    SELECT salary FROM employees
    JOIN departments d ON employees.department_id = d.department_id
    WHERE d.department_name = 'Sales'
);
```

### ALL — true if the comparison holds for ALL values
```sql
-- Employees who earn more than ALL employees in the 'Sales' department
SELECT first_name || ' ' || last_name AS employee, salary
FROM employees
WHERE salary > ALL (
    SELECT salary FROM employees
    JOIN departments d ON employees.department_id = d.department_id
    WHERE d.department_name = 'Sales'
);
```

---

## 6. Correlated Subqueries

A subquery that references a column from the outer query. It runs **once per row** of the outer query.

### Example: Find employees who earn more than the average of their own department
```sql
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
```

### Example: For each order, show if it's above the customer's average order amount
```sql
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
```

---

## Exercises

1. **Find products that are priced above the average price of all products.** Use a subquery in WHERE.

2. **List employees who earn more than the average salary in their own department.** (Correlated subquery)

3. **Show each department's name alongside its highest-paid employee's salary.** Use a subquery in SELECT.

4. **Find customers who have spent more than the average total across all customers.** Use a subquery with SUM + GROUP BY.

5. **Identify employees who are someone's manager.** Use EXISTS (self-referencing).

---

## 🔥 Mini Challenges

1. **Second-highest salary per department** — Use a correlated subquery to find the second-highest salary in each department without using LIMIT/OFFSET. (Hint: count how many people have a salary greater than each employee's salary within the same dept.)

2. **Customers who spent more than any customer in a different state** — For each customer, show if their total spending exceeds the total of ANY customer from a different state. Use ANY with a correlated subquery.
