# Lesson 05: Aggregate Functions

Aggregate functions **summarize** multiple rows into a single result. They're the foundation of business reporting and analytics.

## The Five Essential Aggregate Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `COUNT()` | Counts the number of rows | How many employees? |
| `SUM()` | Adds up values | Total payroll cost |
| `AVG()` | Calculates average | Average salary |
| `MIN()` | Finds minimum value | Cheapest product |
| `MAX()` | Finds maximum value | Most expensive product |

## COUNT() - Counting Rows

### COUNT(*) vs COUNT(column)

This is a **critical distinction** in SQL:

- `COUNT(*)` — counts **all rows** including those with NULL values
- `COUNT(column)` — counts only rows where that column has a **non-NULL** value

```sql
-- Count all employees
SELECT COUNT(*) AS total_employees
FROM employees;
```

**Expected output:**
```
total_employees
---------------
15
```

```sql
-- Count the total number of orders
SELECT COUNT(*) AS total_orders
FROM employees;
```

Wait, that's wrong. Let me fix:

```sql
-- Count total orders
SELECT COUNT(*) AS total_orders
FROM orders;
```

**Expected output:**
```
total_orders
------------
50
```

```sql
-- Count distinct states our customers come from
SELECT COUNT(DISTINCT state) AS unique_states
FROM customers;
```

**Expected output:**
```
unique_states
-------------
15
```

## SUM() - Adding Values

```sql
-- What's the total payroll for the entire company?
SELECT SUM(salary) AS total_payroll
FROM employees;
```

**Expected output:**
```
total_payroll
-------------
1400000.0
```

```sql
-- Total revenue from all delivered orders
SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'Delivered';
```

```sql
-- Total stock of all products in the warehouse
SELECT SUM(stock_quantity) AS total_items_in_stock
FROM products;
```

## AVG() - Calculating Averages

```sql
-- What's the average salary across the company?
SELECT AVG(salary) AS average_salary
FROM employees;
```

**Expected output:**
```
average_salary
-------------
93333.33...
```

```sql
-- Average rating of all movies in our collection
SELECT AVG(rating) AS average_rating
FROM movies;
```

**Expected output:**
```
average_rating
-------------
8.29...
```

## MIN() and MAX() - Finding Extremes

```sql
-- What's the lowest and highest salary?
SELECT MIN(salary) AS lowest_salary,
       MAX(salary) AS highest_salary
FROM employees;
```

**Expected output:**
```
lowest_salary  highest_salary
-------------  --------------
55000.0        200000.0
```

```sql
-- Cheapest and most expensive product
SELECT MIN(unit_price) AS cheapest_product,
       MAX(unit_price) AS most_expensive_product
FROM products;
```

**Expected output:**
```
cheapest_product  most_expensive_product
----------------  ----------------------
9.99              599.0
```

```sql
-- Find the oldest and newest movie release years
SELECT MIN(release_year) AS oldest_movie,
       MAX(release_year) AS newest_movie
FROM movies;
```

**Expected output:**
```
oldest_movie  newest_movie
------------  ------------
1972          2022
```

## ROUND() - Formatting Numbers

`ROUND()` controls decimal places. It's not an aggregate function, but it's essential for formatting aggregate results.

```sql
-- Average salary rounded to 2 decimal places
SELECT ROUND(AVG(salary), 2) AS avg_salary_formatted
FROM employees;
```

**Expected output:**
```
avg_salary_formatted
-------------------
93333.33
```

```sql
-- Average movie rating rounded to 1 decimal
SELECT ROUND(AVG(rating), 1) AS avg_rating
FROM movies;
```

## Real-World Business Examples

### Employee Analytics

```sql
-- HR dashboard: key employee metrics
SELECT
    COUNT(*) AS total_employees,
    ROUND(AVG(salary), 0) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    SUM(salary) AS total_payroll
FROM employees;
```

**Expected output:**
```
total_employees  avg_salary  min_salary  max_salary  total_payroll
---------------  ----------  ----------  ----------  -------------
15               93333       55000       200000      1400000.0
```

### E-Commerce Metrics

```sql
-- Order summary statistics
SELECT
    COUNT(*) AS total_orders,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    MIN(total_amount) AS smallest_order,
    MAX(total_amount) AS largest_order,
    SUM(total_amount) AS total_revenue
FROM orders;
```

### Movie Analytics

```sql
-- Movie collection overview
SELECT
    COUNT(*) AS total_movies,
    ROUND(AVG(rating), 2) AS avg_rating,
    MIN(rating) AS lowest_rating,
    MAX(rating) AS highest_rating,
    ROUND(AVG(duration_min), 0) AS avg_duration_min
FROM movies;
```

### Airbnb Analytics

```sql
-- Airbnb listing overview
SELECT
    COUNT(*) AS total_listings,
    ROUND(AVG(price), 2) AS avg_price,
    MIN(price) AS cheapest_price,
    MAX(price) AS most_expensive,
    ROUND(AVG(rating), 2) AS avg_rating
FROM airbnb_listings;
```

### Products Analytics

```sql
-- Product inventory summary
SELECT
    COUNT(*) AS total_products,
    ROUND(AVG(unit_price), 2) AS avg_price,
    MIN(unit_price) AS min_price,
    MAX(unit_price) AS max_price,
    SUM(stock_quantity) AS total_stock
FROM products;
```

---

## Hands-On Exercises

### Exercise 1
How many movies are in the database? How many unique genres?

### Exercise 2
What is the total revenue (sum of total_amount) from all orders that were actually delivered?

### Exercise 3
What is the average price of Airbnb listings? Round to 2 decimal places.

### Exercise 4
Find the minimum, maximum, and average age of all customers.

### Exercise 5
What is the total stock quantity across ALL product categories combined? Show total_stock with a nice alias.

---

### 🔥 Mini Challenge
1. Calculate the average budget and average revenue for movies. How much profit does the average movie make? (revenue - budget)
2. Find the highest-rated Airbnb listing price and the lowest-rated Airbnb listing price in one query.
3. Count how many employees have a salary above $80,000 vs. at or below $80,000 (you'll need two queries or a CASE statement).
