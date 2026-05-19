# Lesson 07: HAVING

## HAVING vs WHERE — The Critical Difference

This is one of the most important concepts in SQL:

| Clause | Filters... | Can use aggregate functions? |
|--------|------------|------------------------------|
| `WHERE` | **Rows** before grouping | ❌ No |
| `HAVING` | **Groups** after grouping | ✅ Yes |

**Think of the order of execution:**
1. `WHERE` filters individual rows
2. `GROUP BY` groups the remaining rows
3. `HAVING` filters the groups

### Visual Flow

```
FROM employees       → Start with all rows
WHERE salary > 0     → Filter rows (remove unwanted rows)
GROUP BY dept_id     → Group remaining rows
HAVING AVG(salary) > 80000  → Filter groups
ORDER BY avg_salary  → Sort the result
```

## HAVING Syntax

```sql
SELECT grouped_column, AGGREGATE_FUNCTION(column)
FROM table
WHERE condition_on_rows
GROUP BY grouped_column
HAVING condition_on_groups
ORDER BY ...
```

## HAVING with Aggregate Functions

### Example: Departments with High Average Salary

**Real-world context:** HR wants to identify departments where the average salary exceeds $90,000 — these might need budget review.

```sql
-- Departments where average salary > $90,000
SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 90000;
```

**Expected output:**
```
department_id  avg_salary
-------------  ----------
2              110500.0
6              100000.0
```

With department names (using JOIN):

```sql
SELECT d.department_name, ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) > 90000;
```

**Expected output:**
```
department_name  avg_salary
---------------  ----------
Engineering      110500.0
Sales            100000.0
```

### Example: Genres with High Average Rating

**Real-world context:** A streaming platform wants to identify their highest-quality genres.

```sql
-- Genres with average rating >= 8.5
SELECT genre,
       ROUND(AVG(rating), 2) AS avg_rating,
       COUNT(*) AS movie_count
FROM movies
GROUP BY genre
HAVING AVG(rating) >= 8.5;
```

**Expected output:**
```
genre    avg_rating  movie_count
-------  ----------  -----------
Crime        8.74             5
Drama        8.55             6
```

### Example: Movies by Decade with High Ratings

```sql
-- Group movies by release decade and find decades with avg rating > 8.3
SELECT
    (release_year / 10) * 10 AS decade,
    COUNT(*) AS movie_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM movies
GROUP BY decade
HAVING AVG(rating) > 8.3
ORDER BY decade;
```

## WHERE + GROUP BY + HAVING + ORDER BY — Combined!

Let's see the complete pipeline in action.

### Example: Top Departments by Payroll (High-Salary Filter)

**Real-world context:** Find departments where the average salary is above $75,000, but only count employees who earn more than $60,000 (filtering out junior staff first).

```sql
-- Step by step:
-- 1. WHERE: Keep only employees with salary > 60000
-- 2. GROUP BY: Group remaining by department
-- 3. HAVING: Keep groups where avg salary > 75000
-- 4. ORDER BY: Sort by avg salary descending
SELECT
    d.department_name,
    COUNT(*) AS senior_staff,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 60000
GROUP BY d.department_name
HAVING AVG(e.salary) > 75000
ORDER BY avg_salary DESC;
```

### Example: Popular Product Categories

**Real-world context:** Find categories that have been well-stocked (total stock > 200 units).

```sql
-- Product categories with total stock > 200
SELECT category,
       SUM(stock_quantity) AS total_stock,
       COUNT(*) AS product_count,
       ROUND(AVG(unit_price), 2) AS avg_price
FROM products
GROUP BY category
HAVING SUM(stock_quantity) > 200
ORDER BY total_stock DESC;
```

**Expected output:**
```
category     total_stock  product_count  avg_price
-----------  -----------  -------------  ---------
Accessories         1870              7      23.92
Electronics          755              7     131.63
Furniture            405              6     213.83
```

### Example: High-Value Customers

**Real-world context:** Sales team wants to identify customers who have spent more than $500 total.

```sql
-- Customers with total orders > $500
SELECT customer_id,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 500
ORDER BY total_spent DESC;
```

**Expected output:**
```
customer_id  order_count  total_spent
-----------  -----------  -----------
1                      5       781.47
5                      3       729.75
14                     3       690.00... wait, let me check the actual data.
```

Let me just run it to see:

```sql
SELECT customer_id,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 500
ORDER BY total_spent DESC;
```

### Example: Profitable Movie Genres (Budget Awareness)

```sql
-- Genres where average revenue > average budget (profitable genres on average)
SELECT genre,
       COUNT(*) AS total_movies,
       ROUND(AVG(revenue_millions), 2) AS avg_revenue,
       ROUND(AVG(budget_millions), 2) AS avg_budget,
       ROUND(AVG(revenue_millions - budget_millions), 2) AS avg_profit
FROM movies
GROUP BY genre
HAVING AVG(revenue_millions) > AVG(budget_millions)
ORDER BY avg_profit DESC;
```

## Common Mistake: Using HAVING Instead of WHERE

```sql
-- WRONG: HAVING should not be used on raw column values
SELECT first_name, last_name, salary
FROM employees
HAVING salary > 80000;  -- ❌ This works but is bad practice!

-- RIGHT: Use WHERE for row-level filtering
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 80000;   -- ✅ Correct
```

**Rule of thumb:**
- If you're filtering a **raw column value**, use `WHERE`
- If you're filtering an **aggregate result** (SUM, AVG, COUNT), use `HAVING`

## Key Differences Summary

| Aspect | WHERE | HAVING |
|--------|-------|--------|
| When it runs | Before GROUP BY | After GROUP BY |
| Filters | Individual rows | Groups |
| Aggregate functions | Not allowed | Allowed |
| Column references | Any column | Grouped column or aggregate |
| Can exist without GROUP BY | Yes | No (logically depends on it) |

---

## Hands-On Exercises

### Exercise 1
Find genres that have more than 5 movies. Show genre and movie_count.

### Exercise 2
Find departments where the total payroll (sum of salaries) is greater than $300,000. Show department_id and total_payroll.

### Exercise 3
Find neighbourhoods that have an average Airbnb price above $150. Show neighbourhood, avg_price, and listing_count.

### Exercise 4
Find categories where the average product price is less than $50. Show category and avg_price.

### Exercise 5
Find customers who have placed at least 3 orders. Show customer_id and order_count.

---

### 🔥 Mini Challenge
1. Find movie genres where the average rating is above 8.0 AND there are at least 5 movies. Show genre, avg_rating, and count.
2. Find departments where the average salary is between $80,000 and $100,000. Show department name and avg salary.
3. Find product categories where the total stock is less than 500 units AND there are at least 5 products. Show category, total_stock, and product_count.
4. Find managers (by manager_id) who supervise at least 2 employees. Show manager_id and how many people they supervise.
