# Lesson 14: NULL Handling & Views

## Why NULL Handling Matters

NULL means "unknown" or "missing" — and NULL is contagious in SQL. Any arithmetic or comparison with NULL produces NULL. A `WHERE` clause with `= NULL` (instead of `IS NULL`) returns no rows. Understanding NULL behavior is critical to writing correct queries.

Views are virtual tables — saved SELECT statements that act like tables. They simplify complex queries, enforce security, and create reusable data abstractions.

---

## Part 1: NULL Handling

### 1. NULL Behavior — The Basics

NULL ≠ 0, NULL ≠ '' (empty string), and NULL ≠ NULL.

```sql
-- This returns NO rows (always false):
SELECT * FROM employees WHERE manager_id = NULL;

-- This works:
SELECT * FROM employees WHERE manager_id IS NULL;
```

### 2. IFNULL — Replace NULL with a Default

#### Syntax
```sql
IFNULL(expression, replacement_value)
```

> **Note:** The `employees.manager_id` column stores the string `'NULL'` instead of SQL NULL. For demonstration, we'll use a LEFT JOIN which naturally produces NULLs.

#### Example: Replace NULL shipping info with 'Unknown'

```sql
SELECT c.first_name || ' ' || c.last_name AS customer,
       COALESCE(o.shipping_city, 'Unknown') AS city,
       COALESCE(o.shipping_state, 'N/A') AS state
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
LIMIT 5;
```

No output because every customer has orders. Let's use a different approach — create a derived NULL scenario:

```sql
-- Create a scenario with NULLs using LEFT JOIN to find unmatched records
SELECT p.product_id, p.product_name,
       IFNULL(ROUND(SUM(oi.quantity * oi.unit_price), 2), 0) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
HAVING total_revenue = 0;
```

**Expected output (products with no sales have 0 instead of NULL)**
```
product_id|product_name|total_revenue
8|Ergonomic Chair|0.0
9|Laptop Stand|0.0
10|Desk Lamp|0.0
13|Backpack|0.0
15|LED Desk Strip|0.0
16|Bluetooth Speaker|0.0
17|Monitor Arm|0.0
19|External SSD 1TB|0.0
```

Without IFNULL, those would show NULL in total_revenue.

### 3. COALESCE — Return the First Non-NULL Value

COALESCE takes any number of arguments and returns the first one that is NOT NULL.

#### Syntax
```sql
COALESCE(val1, val2, val3, ..., default)
```

#### Example: Priority-based contact info

```sql
-- Simulate: use email if available, otherwise phone, otherwise 'No Contact'
-- (All customers have both, so this is illustrative)
SELECT first_name || ' ' || last_name AS customer,
       COALESCE(email, phone, 'No Contact') AS contact
FROM customers
LIMIT 5;
```

**Expected output**
```
customer|contact
Sarah Johnson|sarah.j@email.com
Mike Chen|mike.chen@email.com
Emma Davis|emma.d@email.com
Alex Kumar|alex.k@email.com
Olivia Martinez|olivia.m@email.com
```

#### Real COALESCE with actual NULLs from a LEFT JOIN

```sql
-- Count orders per customer, replacing NULL with 0
SELECT c.first_name || ' ' || c.last_name AS customer,
       COALESCE(COUNT(o.order_id), 0) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING order_count = 0;
```

**Expected output**
```
customer|order_count
(no rows — all customers have orders)
```

### 4. NULLIF — Return NULL When Two Values Are Equal

#### Syntax
```sql
NULLIF(value1, value2)
```
Returns NULL if value1 == value2, otherwise returns value1.

#### Example: Convert string 'NULL' to actual NULL

Since `manager_id` is stored as the string `'NULL'`, we can clean it:

```sql
SELECT employee_id, first_name || ' ' || last_name AS employee,
       NULLIF(manager_id, 'NULL') AS manager_id_clean
FROM employees
WHERE manager_id = 'NULL';
```

**Expected output**
```
employee_id|employee|manager_id_clean
1|John Smith|NULL
9|George Harris|NULL
12|Julia Roberts|NULL
15|Michael Jordan|NULL
```

### 5. NULL in WHERE, ORDER BY, and GROUP BY

#### WHERE with NULL
```sql
-- Find employees who are NOT managers (no one reports to them)
SELECT first_name || ' ' || last_name AS employee
FROM employees
WHERE manager_id != 'NULL'
  AND employee_id NOT IN (
      SELECT DISTINCT manager_id FROM employees
      WHERE manager_id != 'NULL'
  );
```

**Expected output**
```
employee
Ian Clark
Hannah Martin
Laura Wilson
Fiona Apple
Charlie Brown
Kevin Bacon
Edward Norton
```

#### ORDER BY with NULL
```sql
-- NULLs sort last by default in SQLite
SELECT first_name, last_name, NULLIF(manager_id, 'NULL') AS mgr
FROM employees
ORDER BY mgr;
```

**Expected output (first 3 rows — actual manager_ids sorted ascending, NULLs last)**
```
first_name|last_name|mgr
Jane|Doe|1
Bob|Johnson|1
Diana|Prince|1
...
John|Smith|NULL
George|Harris|NULL
Julia|Roberts|NULL
Michael|Jordan|NULL
```

---

## Part 2: Views

### 1. CREATE VIEW — Save a Query as a Virtual Table

#### Syntax
```sql
CREATE VIEW view_name AS
SELECT ...
FROM ...;
```

#### Example 1: Active customers view

```sql
CREATE VIEW IF NOT EXISTS active_customers AS
SELECT customer_id, first_name, last_name, email, city, state,
       registration_date
FROM customers
WHERE is_active = 1;

-- Use it like a table
SELECT * FROM active_customers ORDER BY last_name LIMIT 5;
```

**Expected output**
```
customer_id|first_name|last_name|email|city|state|registration_date
13|Mia|Anderson|mia.a@email.com|Atlanta|GA|2023-08-19
2|Mike|Chen|mike.chen@email.com|San Francisco|CA|2023-02-20
18|Henry|Clark|henry.c@email.com|St. Louis|MO|2023-01-10
3|Emma|Davis|emma.d@email.com|Chicago|IL|2023-03-10
14|Benjamin|Thomas|ben.t@email.com|Dallas|TX|2023-04-15
```

#### Example 2: Order summary view

```sql
CREATE VIEW IF NOT EXISTS order_summary AS
SELECT o.order_id, o.order_date, o.status,
       o.total_amount, o.payment_method,
       c.first_name || ' ' || c.last_name AS customer,
       c.city, c.state
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Query the view
SELECT order_id, customer, total_amount
FROM order_summary
WHERE status = 'Delivered'
ORDER BY total_amount DESC
LIMIT 5;
```

**Expected output**
```
order_id|customer|total_amount
1039|Harper Lewis|520.0
1016|Benjamin Thomas|500.0
1036|Emma Davis|430.0
1009|Liam Garcia|420.0
1050|Benjamin Thomas|410.0
```

#### Example 3: Department budgets view

```sql
CREATE VIEW IF NOT EXISTS department_budgets AS
SELECT d.department_id, d.department_name, d.location,
       d.budget,
       COUNT(e.employee_id) AS employee_count,
       ROUND(SUM(e.salary), 2) AS total_salaries,
       ROUND(d.budget - SUM(e.salary), 2) AS remaining_budget
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id;

-- Query the view
SELECT * FROM department_budgets ORDER BY remaining_budget DESC;
```

**Expected output**
```
department_id|department_name|location|budget|employee_count|total_salaries|remaining_budget
4|Marketing|Chicago|600000.0|2|145000.0|455000.0
3|Product|New York|800000.0|2|185000.0|615000.0
6|Sales|Denver|750000.0|2|200000.0|550000.0
5|Human Resources|New York|300000.0|1|78000.0|222000.0
2|Engineering|San Francisco|1200000.0|4|452000.0|748000.0
1|Data & Analytics|New York|500000.0|4|340000.0|160000.0
```

### 2. DROP VIEW — Remove a View

```sql
DROP VIEW IF EXISTS active_customers;
DROP VIEW IF EXISTS order_summary;
DROP VIEW IF EXISTS department_budgets;
```

### 3. Views vs Tables

| Aspect | View | Table |
|--------|------|-------|
| Storage | No data stored, just the query | Data physically stored |
| Up-to-date | Always reflects source data | Must be updated |
| Performance | Runs query each time | Direct reads |
| Can index? | No | Yes |
| Can UPDATE? | Some (if simple) | Always |

### 4. Best Practices for Views

1. Use views for **frequently used complex queries** (multi-JOIN, aggregation)
2. Name views descriptively: `customer_orders`, `monthly_revenue`, `active_users`
3. Don't nest views too deeply (view on view on view) — performance suffers
4. Use `IF NOT EXISTS` to avoid errors on re-creation
5. Document what each view does

---

## Exercises

1. **Create a view `product_sales`** that shows product_id, product_name, category, total_quantity_sold, and total_revenue. Query it to find the top 5 products by revenue.

2. **Use COALESCE** — Write a query against `employees` that shows employee name, salary, and a column `bonus_eligible`. Set it to 'Yes' if salary < 80000, 'No' otherwise. (Use NULLIF to convert 'NULL' manager_id to real NULL first.)

3. **Create a view `high_value_orders`** for orders with total_amount > 300. Include customer name, order_id, order_date, amount. Then query the view.

4. **IFNULL for safety** — Write a query that shows all products and their total sales. Use IFNULL to show 0 instead of NULL for products that have never been sold.

5. **Create and then drop a view** called `short_movies` that shows movies with duration < 100 minutes. Verify it exists, then drop it.

---

## 🔥 Mini Challenges

1. **Dynamic NULL handling** — The `airbnb_listings` table has no NULLs. Simulate NULLs by doing a LEFT JOIN that produces them (e.g., all neighbourhoods vs listings). Use COALESCE to replace NULLs with meaningful defaults.

2. **Views for reporting** — Create a view `monthly_kpi` that shows: month, total_orders, total_revenue (excl. cancelled), distinct_customers, and avg_order_value. Query it to find the best month by revenue.
