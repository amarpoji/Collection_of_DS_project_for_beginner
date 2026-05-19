# Lesson 08: Beginner Review

Congratulations! You've completed the beginner SQL section. This lesson combines **everything you've learned** into comprehensive review exercises.

## What We've Covered

| Lesson | Topic | Key Skills |
|--------|-------|------------|
| 01 | What is SQL | Database concepts, exploring tables |
| 02 | SELECT & WHERE | Filtering rows with conditions |
| 03 | ORDER BY, LIMIT, DISTINCT | Sorting, pagination, unique values |
| 04 | Aliases & Filtering | Column/table aliases, complex conditions |
| 05 | Aggregate Functions | COUNT, SUM, AVG, MIN, MAX, ROUND |
| 06 | GROUP BY | Grouping rows for summaries |
| 07 | HAVING | Filtering groups after aggregation |

## Complete Query Structure

Here's the "recipe" for a complete SQL query:

```sql
SELECT     columns or aggregations       -- Step 5: Choose what to show
FROM       table(s)                      -- Step 1: Where's the data?
WHERE      filter conditions             -- Step 2: Filter rows
GROUP BY   grouping columns              -- Step 3: Group rows
HAVING     group filter conditions       -- Step 4: Filter groups
ORDER BY   sorting columns               -- Step 6: Sort results
LIMIT      number of rows;               -- Step 7: Limit results
```

## Real-World Business Questions

Let's answer real business questions using our practice database.

### 1. Which departments have the most employees?

```sql
-- HR wants the headcount per department
SELECT d.department_name, COUNT(*) AS headcount
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY headcount DESC;
```

### 2. What's the average order value by payment method?

```sql
-- Finance wants to know which payment methods have highest avg orders
SELECT payment_method,
       COUNT(*) AS order_count,
       ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
GROUP BY payment_method
ORDER BY avg_order_value DESC;
```

### 3. Which movies had the best return on investment?

```sql
-- Movie studio wants to know which films were most profitable
SELECT title, genre, release_year,
       revenue_millions - budget_millions AS profit_millions,
       ROUND((revenue_millions - budget_millions) / budget_millions, 2) AS roi
FROM movies
WHERE budget_millions > 0
ORDER BY roi DESC
LIMIT 10;
```

### 4. How many customers do we have in each state?

```sql
-- Marketing wants state-by-state customer distribution
SELECT state, COUNT(*) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC;
```

### 5. What's the top-selling product category?

```sql
-- Which product category generates the most revenue?
-- Using order_items to calculate by category
SELECT p.category,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;
```

### 6. Which employees earn above the company average?

```sql
-- Find employees earning above average (subquery + WHERE)
SELECT first_name, last_name, job_title, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;
```

**Expected output:**
```
first_name  last_name   job_title        salary
----------  ----------  --------------  -------
George      Harris      CTO             200000
Michael     Jordan      Sales Manager   130000
Bob         Johnson     Data Scientist  110000
Alice       Williams    Product Manager 105000
Edward      Norton      Data Engineer   100000
```

### 7. Which cities have more than 1 customer?

```sql
-- Cities with multiple customers
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY customer_count DESC;
```

### 8. How many orders in each status category?

```sql
-- Operations wants an order status breakdown
SELECT status,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS total_value
FROM orders
GROUP BY status
ORDER BY order_count DESC;
```

### 9. What's the most common Airbnb room type?

```sql
-- Count of listings by room type
SELECT room_type,
       COUNT(*) AS listing_count,
       ROUND(AVG(price), 2) AS avg_price,
       ROUND(AVG(rating), 2) AS avg_rating
FROM airbnb_listings
GROUP BY room_type;
```

### 10. Find high earners in specific departments

```sql
-- Employees in Engineering or Sales earning > $90,000
SELECT e.first_name, e.last_name, d.department_name, e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name IN ('Engineering', 'Sales')
  AND e.salary > 90000
ORDER BY e.salary DESC;
```

## Review Exercises (10 Questions)

These exercises test **all concepts** from the beginner section. Try to solve them without looking at the answers!

### Exercise 1: Basics
Show the first name, last name, and job title of all employees in the 'Data & Analytics' department. Use a JOIN with the departments table.

### Exercise 2: Filtering + Sorting
Find all movies released after 2010 with a rating of 8.0 or higher. Show title, release_year, and rating. Sort by rating descending.

### Exercise 3: Aggregation
What is the total number of orders, the average order amount, and the highest order amount in the entire orders table? Use appropriate aliases.

### Exercise 4: GROUP BY
Count how many orders were placed by each customer. Show only customers who placed 3 or more orders. Sort by order count descending.

### Exercise 5: HAVING
Find all product categories where the average unit price is greater than $30 AND there are at least 4 products in that category. Show category, avg_price, and product_count.

### Exercise 6: LIMIT + OFFSET
Show the 6th through 10th highest-paid employees. Display first_name, last_name, job_title, and salary.

### Exercise 7: DISTINCT + WHERE
List all distinct cities where customers live are from the state of California. Show the city names sorted alphabetically.

### Exercise 8: Complex Filtering
Find all orders that are either:
- "Delivered" with total_amount > $200, OR
- "Shipped" with total_amount > $150

Show order_id, customer_id, status, and total_amount. Sort by total_amount descending.

### Exercise 9: Aggregate with GROUP BY
For each job title in the company, show:
- The job title
- How many employees have that title
- The average salary for that title (rounded to 2 decimals)
- The minimum and maximum salary

Sort by average salary descending.

### Exercise 10: Full Pipeline
Find the top 5 genres by average revenue. Only include genres that:
- Have at least 3 movies
- Have an average rating of 7.5 or higher

Show genre, movie_count, avg_rating, and avg_revenue. Sort by avg_revenue descending.

---

## 🔥 The Ultimate Beginner Challenge

Write a query that answers this business question:

**"We need a report showing each department's performance:"
- Department name
- Number of employees
- Average salary (rounded)
- Total payroll
- Lowest and highest salary
- Only include departments with at least 2 employees
- Sort by average salary descending**

This uses: JOIN, GROUP BY, aggregate functions, HAVING, aliases, and ORDER BY — everything you've learned!

> **You've completed the Beginner section! 🎉 Move on to the Intermediate section for JOINs, subqueries, CASE statements, and more!**
