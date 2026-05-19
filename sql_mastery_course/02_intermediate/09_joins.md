# Lesson 09: JOINs — Combining Data from Multiple Tables

## Why JOINs Matter

Real-world data is never in one table. Customers are separate from orders. Employees belong to departments. JOINs let you connect related tables using foreign keys (e.g., `orders.customer_id` → `customers.customer_id`) so you can answer business questions that span multiple sources.

---

## 1. INNER JOIN — Only Matching Rows

Returns rows where the join condition is true in **both** tables. If a customer has no orders, they don't appear.

### Syntax
```sql
SELECT columns
FROM table_a
INNER JOIN table_b ON table_a.fk = table_b.pk;
```

`INNER JOIN` is the same as just `JOIN`.

### Example 1: Orders with customer names
```sql
SELECT o.order_id, o.order_date, o.total_amount,
       c.first_name || ' ' || c.last_name AS customer,
       c.city, c.state
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LIMIT 5;
```

**Expected output**
```
order_id|order_date|total_amount|customer|city|state
1001|2024-01-05|125.99|Sarah Johnson|New York|NY
1002|2024-01-07|89.5|Mike Chen|San Francisco|CA
1003|2024-01-10|249.99|Emma Davis|Chicago|IL
1004|2024-01-12|45.0|Alex Kumar|Los Angeles|CA
1005|2024-01-15|310.25|Olivia Martinez|Houston|TX
```

### Example 2: Employees with their department names
```sql
SELECT e.first_name || ' ' || e.last_name AS employee,
       e.job_title, e.salary,
       d.department_name, d.location
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
```

**Expected output (first 5 rows)**
```
John Smith|Data Analyst|75000.0|Data & Analytics|New York
Jane Doe|Software Engineer|95000.0|Engineering|San Francisco
Bob Johnson|Data Scientist|110000.0|Data & Analytics|New York
Alice Williams|Product Manager|105000.0|Product|New York
Charlie Brown|Junior Developer|65000.0|Engineering|San Francisco
```

---

## 2. LEFT JOIN — All Rows from Left, Matching from Right

Returns **every row** from the left table. If there's no match on the right, the right-side columns are `NULL`.

This is the most common JOIN type — "give me all X, and their Y if they have one."

### Example: All customers with their orders (including 0-order customers)
```sql
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer,
       o.order_id, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
```

All 20 customers appear. If a customer never ordered, `order_id`/`order_date`/`total_amount` are NULL.

### LEFT JOIN with WHERE — Find customers with no orders
```sql
SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

---

## 3. RIGHT JOIN / FULL OUTER JOIN (SQLite Workarounds)

SQLite does **not** support `RIGHT JOIN` or `FULL OUTER JOIN` natively. You simulate them with `LEFT JOIN` + table swapping, or `LEFT JOIN` UNION `LEFT JOIN`.

### RIGHT JOIN ≈ LEFT JOIN with swapped tables
```sql
-- What RIGHT JOIN would do: all rows from departments, matching employees
-- Simulate it:
SELECT d.department_name, e.first_name || ' ' || e.last_name AS employee
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;
-- In SQLite: use LEFT JOIN with tables swapped
SELECT d.department_name, e.first_name || ' ' || e.last_name AS employee
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id;
```

### FULL OUTER JOIN — All rows from both sides
```sql
-- All employees and all departments, matched where possible
-- Step 1: LEFT JOIN employees → departments
-- Step 2: LEFT JOIN departments → employees (simulate RIGHT)
-- Step 3: UNION them

SELECT e.first_name || ' ' || e.last_name AS employee,
       d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
UNION
SELECT e.first_name || ' ' || e.last_name AS employee,
       d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;  -- only the unmatched departments
```

---

## 4. JOIN with Multiple Tables — 3+, 4+ Tables

Orders → Order Items → Products: the classic e-commerce chain.

```sql
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
```

**Expected output (for order 1001)**
```
order_id|order_date|customer|product_name|quantity|unit_price|line_total
1001|2024-01-05|Sarah Johnson|Wireless Mouse|2|25.99|51.98
1001|2024-01-05|Sarah Johnson|Notebook Set|3|12.5|37.5
1001|2024-01-05|Sarah Johnson|Cable Organizer|5|9.99|49.95
```

---

## 5. Self-Join — Joining a Table to Itself

Used when a row references another row in the same table. Classic example: employees and their managers (both stored in `employees`).

```sql
SELECT e1.first_name || ' ' || e1.last_name AS employee,
       e1.job_title,
       e2.first_name || ' ' || e2.last_name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id
WHERE e1.manager_id != 'NULL'
ORDER BY e1.employee_id;
```

**Expected output**
```
employee|job_title|manager
Jane Doe|Software Engineer|John Smith
Bob Johnson|Data Scientist|John Smith
Alice Williams|Product Manager|John Smith
Charlie Brown|Junior Developer|Jane Doe
Diana Prince|Marketing Manager|John Smith
Edward Norton|Data Analyst|Bob Johnson
Fiona Apple|UI Designer|Alice Williams
Hannah Martin|Marketing Specialist|Diana Prince
Ian Clark|Junior Data Analyst|Bob Johnson
Kevin Bacon|DevOps Engineer|Jane Doe
Laura Wilson|Sales Associate|John Smith
```

> **Note:** `manager_id` is stored as the string `'NULL'` (not SQL NULL) for top-level managers. The condition `e1.manager_id != 'NULL'` filters them out.

---

## 6. Real Business Examples

### 6A. Department budget vs actual salary spend
```sql
SELECT d.department_name, d.budget,
       ROUND(SUM(e.salary), 2) AS total_salaries,
       ROUND(d.budget - SUM(e.salary), 2) AS remaining
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id
ORDER BY remaining DESC;
```

### 6B. Top customers by lifetime value
```sql
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer,
       COUNT(o.order_id) AS order_count,
       ROUND(SUM(o.total_amount), 2) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY lifetime_value DESC
LIMIT 5;
```

### 6C. Products that have never been ordered
```sql
SELECT p.product_id, p.product_name, p.category, p.unit_price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.item_id IS NULL;
```

---

## Exercises

1. **List all departments and the number of employees in each.** Include departments with zero employees.

2. **Show every order with: customer name, product names, quantities, and line totals.** Use a 4-table JOIN.

3. **Find employees who earn more than their manager's salary.** Requires a self-join + comparison.

4. **List all movies and their genres; include the studio name.** (Only one table — do a self-JOIN practice by listing movies with director's other movies, e.g., find movies directed by the same director.)

5. **Identify customers who spent more than $500 total.** JOIN customers + orders + GROUP BY + HAVING.

---

## 🔥 Mini Challenges

1. **Full outer join simulation** — Write a query that shows ALL employees and ALL departments, marking unmatched rows with `'No Match'`. Use `UNION` and a literal column.

2. **Organic growth analysis** — For each employee, show their hire date and the hire date of the person hired just before them. (This uses a self-join with a date condition — a preview of window function concepts.)
