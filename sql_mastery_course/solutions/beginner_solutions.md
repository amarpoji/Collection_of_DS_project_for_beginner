# Beginner SQL Exercises — Complete Solutions

Database: `sql_mastery.db`

---

## Section 1: Basic SELECT & Exploration (Exercises 1-3)

---

### Exercise 1 — Exploring the Database

**Skills:** .tables, .schema, PRAGMA

**Question:**
Use sqlite3 dot commands to explore the database. List the answers to:
a) How many tables are in the database?
b) What is the schema of the `departments` table?
c) What columns does the `order_items` table have?

**Solution:**

```sql
-- a) List all tables
.tables

-- b) Show schema of departments table
.schema departments

-- c) Show schema of order_items table
.schema order_items
```

**Expected Output:**

a) 8 tables: airbnb_listings, customers, departments, employees, movies, order_items, orders, products

b) departments schema:
```
CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    department_name TEXT NOT NULL,
    location TEXT,
    budget REAL
);
```

c) order_items columns: item_id, order_id, product_id, quantity, unit_price

**Explanation:** SQLite dot commands are meta-commands that don't require SQL syntax. `.tables` lists all tables, `.schema` shows CREATE TABLE statements.

---

### Exercise 2 — Simple SELECT

**Skills:** SELECT, LIMIT

**Question:** Write a query to show the first 5 rows from the `customers` table, showing only `first_name`, `last_name`, `city`, and `state`.

**Solution:**

```sql
SELECT first_name, last_name, city, state
FROM customers
LIMIT 5;
```

**Expected Output:**

| first_name | last_name | city           | state |
|------------|-----------|----------------|-------|
| Sarah      | Johnson   | New York       | NY    |
| Mike       | Chen      | San Francisco  | CA    |
| Emma       | Davis     | Chicago        | IL    |
| Alex       | Kumar     | Austin         | TX    |
| Olivia     | Martinez  | Los Angeles    | CA    |

**Explanation:** SELECT specifies which columns to retrieve. LIMIT 5 restricts the result to 5 rows. By default, rows are returned in the order they were inserted.

---

### Exercise 3 — Counting Records

**Skills:** COUNT(*)

**Question:** Count how many records exist in each of these tables in a single result: employees, customers, products, movies.

**Solution:**

```sql
SELECT 'employees' AS table_name, COUNT(*) AS cnt FROM employees
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'movies', COUNT(*) FROM movies;
```

**Expected Output:**

| table_name | cnt |
|-----------|-----|
| employees  | 15  |
| customers  | 20  |
| products   | 20  |
| movies     | 40  |

**Explanation:** UNION ALL combines the results of multiple SELECT queries into a single result set. COUNT(*) counts all rows in each table.

---

## Section 2: WHERE Filtering (Exercises 4-7)

---

### Exercise 4 — Numeric Filtering

**Skills:** WHERE with comparisons

**Question:** Find all products with a unit price greater than $100. Show product_name, category, and unit_price. Sort by price descending.

**Solution:**

```sql
SELECT product_name, category, unit_price
FROM products
WHERE unit_price > 100
ORDER BY unit_price DESC;
```

**Expected Output:**

| product_name                | category     | unit_price |
|-----------------------------|--------------|------------|
| Standing Desk               | Furniture    | 599.00     |
| Ergonomic Chair             | Furniture    | 450.00     |
| 27-inch Monitor             | Electronics  | 349.99     |
| Noise Canceling Headphones  | Electronics  | 199.99     |
| Bluetooth Speaker           | Electronics  | 149.99     |
| External SSD 1TB            | Electronics  | 129.99     |

**Explanation:** WHERE filters rows before grouping. ORDER BY DESC sorts from highest to lowest. 6 products cost more than $100.

---

### Exercise 5 — Text Filtering

**Skills:** WHERE with text, LIKE

**Question:** Find all employees whose last name starts with 'B' or 'J'. Show their full name (first + last) and job title.

**Solution:**

```sql
SELECT first_name || ' ' || last_name AS full_name, job_title
FROM employees
WHERE last_name LIKE 'B%' OR last_name LIKE 'J%';
```

**Expected Output:**

| full_name      | job_title        |
|---------------|------------------|
| Bob Johnson   | Data Scientist   |
| Charlie Brown | Junior Developer |
| Kevin Bacon   | DevOps Engineer  |
| Michael Jordan| Sales Manager    |

**Explanation:** LIKE 'B%' means "starts with B followed by any characters". The || operator concatenates strings. The OR combines two conditions.

---

### Exercise 6 — BETWEEN & IN

**Skills:** BETWEEN, IN

**Question:** Find all orders placed in January 2024 (order_date BETWEEN '2024-01-01' AND '2024-01-31') with a status IN ('Delivered', 'Shipped'). Show order_id, order_date, status, and total_amount.

**Solution:**

```sql
SELECT order_id, order_date, status, total_amount
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
  AND status IN ('Delivered', 'Shipped');
```

**Expected Output:**

| order_id | order_date | status    | total_amount |
|----------|-----------|-----------|-------------|
| 1001     | 2024-01-05| Delivered | 125.99      |
| 1002     | 2024-01-07| Delivered | 89.50       |
| 1003     | 2024-01-10| Delivered | 249.99      |
| 1004     | 2024-01-12| Shipped   | 45.00       |
| 1005     | 2024-01-15| Delivered | 310.25      |
| 1007     | 2024-01-20| Delivered | 199.99      |
| 1009     | 2024-01-25| Delivered | 420.00      |
| 1010     | 2024-01-28| Delivered | 67.75       |

**Explanation:** BETWEEN is inclusive of both endpoints. IN checks if a value matches any item in a list. Both conditions must be true (AND).

---

### Exercise 7 — Complex WHERE with AND/OR

**Skills:** AND, OR, parentheses

**Question:** Find all movies that are either Drama genre with rating >= 8.5, OR Sci-Fi genre with rating >= 8.0. Show title, genre, and rating.

**Solution:**

```sql
SELECT title, genre, rating
FROM movies
WHERE (genre = 'Drama' AND rating >= 8.5)
   OR (genre = 'Sci-Fi' AND rating >= 8.0);
```

**Expected Output:**

| title                     | genre   | rating |
|---------------------------|---------|--------|
| Forrest Gump              | Drama   | 8.8    |
| The Shawshank Redemption  | Drama   | 9.3    |
| Fight Club                | Drama   | 8.8    |
| Whiplash                  | Drama   | 8.5    |
| The Matrix                | Sci-Fi  | 8.7    |
| Inception                 | Sci-Fi  | 8.8    |
| Interstellar              | Sci-Fi  | 8.6    |
| Dune                      | Sci-Fi  | 8.0    |

**Explanation:** Parentheses ensure the OR groups the two composite conditions correctly. Without parentheses, AND would bind tighter and the logic would change.

---

## Section 3: Sorting & Distinct (Exercises 8-10)

---

### Exercise 8 — ORDER BY

**Skills:** ORDER BY ASC/DESC, multiple columns

**Question:** List all employees sorted by department_id (ascending) and then by salary (descending within each department). Show first_name, last_name, department_id, and salary.

**Solution:**

```sql
SELECT first_name, last_name, department_id, salary
FROM employees
ORDER BY department_id ASC, salary DESC;
```

**Expected Output:**

| first_name | last_name | department_id | salary    |
|-----------|-----------|--------------|----------|
| Bob       | Johnson   | 1            | 110000.0 |
| Edward    | Norton    | 1            | 100000.0 |
| John      | Smith     | 1            | 75000.0  |
| Ian       | Clark     | 1            | 55000.0  |
| George    | Harris    | 2            | 200000.0 |
| Jane      | Doe       | 2            | 95000.0  |
| Kevin     | Bacon     | 2            | 92000.0  |
| Charlie   | Brown     | 2            | 65000.0  |
| ...       | ...       | ...          | ...      |

**Explanation:** The first column in ORDER BY is the primary sort, the second is the tiebreaker. ASC is the default direction.

---

### Exercise 9 — DISTINCT

**Skills:** SELECT DISTINCT

**Question:** Find all unique job titles in the employees table. Sort alphabetically.

**Solution:**

```sql
SELECT DISTINCT job_title
FROM employees
ORDER BY job_title;
```

**Expected Output:**

| job_title            |
|----------------------|
| CTO                  |
| Data Analyst         |
| Data Engineer        |
| Data Scientist       |
| DevOps Engineer      |
| HR Manager           |
| Jr Data Analyst      |
| Junior Developer     |
| Marketing Analyst    |
| Marketing Lead       |
| Product Manager      |
| Sales Manager        |
| Sales Representative |
| Software Engineer    |
| UX Designer          |

**Explanation:** DISTINCT removes duplicate values from the result set. There are 15 unique job titles across 15 employees.

---

### Exercise 10 — LIMIT with OFFSET

**Skills:** LIMIT, OFFSET

**Question:** Using a single query, show the 4th and 5th most expensive products. Show product_name and unit_price.

**Solution:**

```sql
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 2 OFFSET 3;
```

**Expected Output:**

| product_name               | unit_price |
|----------------------------|-----------|
| Noise Canceling Headphones | 199.99    |
| Bluetooth Speaker          | 149.99    |

**Explanation:** OFFSET 3 skips the first 3 rows (rank 1-3). LIMIT 2 returns the next 2 rows (rank 4-5). The 3 most expensive are: Standing Desk ($599), Ergonomic Chair ($450), 27-inch Monitor ($349.99).

---

## Section 4: Aliases & Aggregation (Exercises 11-14)

---

### Exercise 11 — Column Aliases

**Skills:** AS alias

**Question:** Write a query that shows each movie as: "title (release_year)" with an alias of "movie_info". Also show the rating and revenue_millions. Limit to 10 rows.

**Solution:**

```sql
SELECT title || ' (' || release_year || ')' AS movie_info,
       rating,
       revenue_millions
FROM movies
LIMIT 10;
```

**Expected Output:**

| movie_info                        | rating | revenue_millions |
|-----------------------------------|--------|-----------------|
| The Matrix (1999)                 | 8.7    | 467.0           |
| Inception (2010)                  | 8.8    | 836.0           |
| The Godfather (1972)              | 9.2    | 246.0           |
| Pulp Fiction (1994)               | 8.9    | 213.0           |
| The Dark Knight (2008)            | 9.0    | 1005.0          |
| Forrest Gump (1994)               | 8.8    | 677.0           |
| Interstellar (2014)               | 8.6    | 701.0           |
| Parasite (2019)                   | 8.5    | 258.0           |
| Spirited Away (2001)              | 8.6    | 395.0           |
| The Shawshank Redemption (1994)   | 9.3    | 73.0            |

**Explanation:** The || operator concatenates strings. AS renames the computed column. This is called a "column alias" and only affects the output, not the underlying table.

---

### Exercise 12 — Basic Aggregation

**Skills:** COUNT, SUM, AVG, MIN, MAX

**Question:** Calculate statistics for the products table: total_products, average_price (rounded to 2 decimals), cheapest_product, most_expensive_product, total_stock_quantity.

**Solution:**

```sql
SELECT COUNT(*) AS total_products,
       ROUND(AVG(unit_price), 2) AS average_price,
       MIN(unit_price) AS cheapest_product,
       MAX(unit_price) AS most_expensive_product,
       SUM(stock_quantity) AS total_stock_quantity
FROM products;
```

**Expected Output:**

| total_products | average_price | cheapest_product | most_expensive_product | total_stock_quantity |
|---------------|---------------|-----------------|----------------------|---------------------|
| 20            | 123.64        | 9.99            | 599.0                | 3030                |

**Explanation:** Aggregate functions operate on all rows (when no GROUP BY is specified). ROUND controls decimal places. The cheapest product is Cable Organizer ($9.99), the most expensive is Standing Desk ($599.00).

---

### Exercise 13 — Aggregate with WHERE

**Skills:** Aggregate + WHERE

**Question:** What is the total revenue (SUM of total_amount) from all 'Delivered' orders? What is the average delivered order amount?

**Solution:**

```sql
SELECT ROUND(SUM(total_amount), 2) AS total_delivered_revenue,
       ROUND(AVG(total_amount), 2) AS avg_delivered_amount
FROM orders
WHERE status = 'Delivered';
```

**Expected Output:**

| total_delivered_revenue | avg_delivered_amount |
|------------------------|---------------------|
| 6599.19                | 206.22              |

**Explanation:** WHERE filters before aggregation. Of 50 total orders, 32 are Delivered, with total revenue of $6,599.19 and an average of $206.22 per delivered order.

---

### Exercise 14 — ROUND with Aggregates

**Skills:** ROUND, AVG

**Question:** Find the average, minimum, and maximum rating for Airbnb listings. Round all values to 2 decimal places. Also show how many listings have a rating.

**Solution:**

```sql
SELECT ROUND(AVG(rating), 2) AS avg_rating,
       ROUND(MIN(rating), 2) AS min_rating,
       ROUND(MAX(rating), 2) AS max_rating,
       COUNT(rating) AS listings_with_rating
FROM airbnb_listings;
```

**Expected Output:**

| avg_rating | min_rating | max_rating | listings_with_rating |
|-----------|-----------|-----------|---------------------|
| 4.61      | 4.20      | 5.00      | 20                  |

**Explanation:** All 20 listings have a non-NULL rating. The overall average rating is 4.61/5.0, indicating generally positive guest experiences. The highest rating is a perfect 5.0 (The Penthouse Suite).

---

## Section 5: GROUP BY (Exercises 15-17)

---

### Exercise 15 — Simple GROUP BY

**Skills:** GROUP BY, COUNT

**Question:** Count how many movies exist in each genre. Show genre and movie_count. Sort by movie_count descending.

**Solution:**

```sql
SELECT genre, COUNT(*) AS movie_count
FROM movies
GROUP BY genre
ORDER BY movie_count DESC;
```

**Expected Output:**

| genre     | movie_count |
|-----------|------------|
| Animation | 7          |
| Sci-Fi    | 7          |
| Action    | 6          |
| Drama     | 6          |
| Crime     | 5          |
| Mystery   | 3          |
| Horror    | 2          |
| Comedy    | 1          |
| Musical   | 1          |
| Thriller  | 1          |
| War       | 1          |

**Explanation:** GROUP BY collapses rows with the same genre into a single row per genre. COUNT(*) counts the rows in each group. Animation and Sci-Fi tie for the most movies (7 each).

---

### Exercise 16 — GROUP BY with SUM

**Skills:** GROUP BY, SUM

**Question:** For each department, calculate the total payroll (sum of salaries). Show department_id and total_payroll. Sort by total_payroll descending.

**Solution:**

```sql
SELECT department_id, SUM(salary) AS total_payroll
FROM employees
GROUP BY department_id
ORDER BY total_payroll DESC;
```

**Expected Output:**

| department_id | total_payroll |
|--------------|--------------|
| 2            | 452000.0     |
| 1            | 340000.0     |
| 6            | 200000.0     |
| 3            | 185000.0     |
| 4            | 145000.0     |
| 5            | 78000.0      |

**Explanation:** SUM(salary) adds up all salaries within each department_id group. Department 2 (Engineering) has the highest total payroll at $452,000, driven by the CTO's $200,000 salary.

---

### Exercise 17 — GROUP BY with AVG

**Skills:** GROUP BY, AVG, JOIN

**Question:** For each department name (use JOIN with departments table), show department_name, employee_count, average_salary (rounded to 0 decimal places). Sort by average_salary descending.

**Solution:**

```sql
SELECT d.department_name,
       COUNT(*) AS employee_count,
       ROUND(AVG(e.salary), 0) AS average_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY average_salary DESC;
```

**Expected Output:**

| department_name   | employee_count | average_salary |
|------------------|---------------|---------------|
| Engineering      | 4             | 113000        |
| Sales            | 2             | 100000        |
| Product          | 2             | 92500         |
| Data & Analytics | 4             | 85000         |
| Human Resources  | 1             | 78000         |
| Marketing        | 2             | 72500         |

**Explanation:** JOIN combines employees with departments on department_id. GROUP BY uses the department name (from the joined table). Engineering pays the highest average at $113,000.

---

## Section 6: HAVING (Exercises 18-20)

---

### Exercise 18 — Basic HAVING

**Skills:** HAVING with COUNT

**Question:** Find neighbourhoods in the airbnb_listings table that have at least 2 listings. Show neighbourhood and listing_count. Sort by listing_count descending.

**Solution:**

```sql
SELECT neighbourhood, COUNT(*) AS listing_count
FROM airbnb_listings
GROUP BY neighbourhood
HAVING listing_count >= 2
ORDER BY listing_count DESC;
```

**Expected Output:**

| neighbourhood | listing_count |
|--------------|--------------|
| Manhattan    | 7            |
| Brooklyn     | 6            |
| Queens       | 3            |
| Staten Island| 2            |

**Explanation:** HAVING filters groups after GROUP BY (unlike WHERE which filters rows before). Only neighbourhoods with 2+ listings are shown. Manhattan has the most listings (7).

---

### Exercise 19 — HAVING with AVG

**Skills:** GROUP BY, HAVING, AVG

**Question:** Find product categories where the average unit price is above $50. Show category, avg_price (rounded to 2 decimals), and product_count. Sort by avg_price descending.

**Solution:**

```sql
SELECT category,
       ROUND(AVG(unit_price), 2) AS avg_price,
       COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING AVG(unit_price) > 50
ORDER BY avg_price DESC;
```

**Expected Output:**

| category     | avg_price | product_count |
|-------------|----------|--------------|
| Furniture   | 246.60   | 5            |
| Electronics | 133.93   | 8            |

**Explanation:** HAVING with AVG filters categories where the average price exceeds $50. Accessories average $23.91 (below $50 threshold), so it's excluded.

---

### Exercise 20 — WHERE + GROUP BY + HAVING + ORDER BY

**Skills:** Full pipeline

**Question:** Find customers who have placed at least 2 orders AND have a total spend (sum of total_amount) greater than $300. Show customer_id, order_count, and total_spent (rounded to 2 decimals). Sort by total_spent descending.

**Solution:**

```sql
SELECT customer_id,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS total_spent
FROM orders
GROUP BY customer_id
HAVING COUNT(*) >= 2 AND SUM(total_amount) > 300
ORDER BY total_spent DESC;
```

**Expected Output:**

| customer_id | order_count | total_spent |
|------------|------------|-------------|
| 14         | 3          | 1190.00     |
| 3          | 3          | 894.99      |
| 11         | 3          | 805.50      |
| 5          | 3          | 729.75      |
| 1          | 4          | 691.47      |
| 8          | 3          | 687.00      |
| 20         | 2          | 670.00      |
| 6          | 3          | 637.00      |
| 17         | 2          | 610.99      |
| 4          | 3          | 312.99      |

**Explanation:** 10 customers meet both criteria. Benjamin Thomas (customer 14) is #1 spender with $1,190 across 3 orders. Note: All customers have 2+ orders in this dataset.

---

## Section 7: Advanced Combined (Exercises 21-25)

---

### Exercise 21 — Everything Combined I

**Skills:** JOIN, GROUP BY, HAVING, ORDER BY, LIMIT

**Question:** Find the 3 departments with the highest average employee salary. Only include departments with at least 2 employees. Show department_name and avg_salary (rounded to 0 decimals).

**Solution:**

```sql
SELECT d.department_name,
       ROUND(AVG(e.salary), 0) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_id
HAVING COUNT(*) >= 2
ORDER BY avg_salary DESC
LIMIT 3;
```

**Expected Output:**

| department_name | avg_salary |
|----------------|-----------|
| Engineering    | 113000    |
| Sales          | 100000    |
| Product        | 92500     |

**Explanation:** JOIN merges tables, GROUP BY aggregates, HAVING filters groups (2+ employees), ORDER BY sorts, LIMIT restricts to top 3. Engineering leads with $113,000 average.

---

### Exercise 22 — Everything Combined II

**Skills:** All concepts

**Question:** Find all movies that are in the top 10 most profitable movies (revenue - budget). Show title, genre, release_year, profit_millions, and rating. Only include movies with a rating of 8.0 or higher. Sort by profit descending.

**Solution:**

```sql
SELECT title,
       genre,
       release_year,
       ROUND(revenue_millions - budget_millions, 1) AS profit_millions,
       rating
FROM movies
WHERE rating >= 8.0
ORDER BY profit_millions DESC
LIMIT 10;
```

**Expected Output:**

| title            | genre     | release_year | profit_millions | rating |
|-----------------|-----------|-------------|----------------|--------|
| The Avengers    | Action    | 2012        | 1299.0         | 8.0    |
| Joker           | Crime     | 2019        | 1019.0         | 8.4    |
| Jurassic Park   | Action    | 1993        | 994.0          | 8.2    |
| The Lion King   | Animation | 1994        | 923.0          | 8.5    |
| The Dark Knight | Action    | 2008        | 820.0          | 9.0    |
| Inception       | Sci-Fi    | 2010        | 676.0          | 8.8    |
| Coco            | Animation | 2017        | 639.0          | 8.4    |
| Forrest Gump    | Drama     | 1994        | 622.0          | 8.8    |
| The Incredibles | Animation | 2004        | 541.0          | 8.0    |
| Interstellar    | Sci-Fi    | 2014        | 536.0          | 8.6    |

**Explanation:** Computed column (revenue - budget) is used in ORDER BY. WHERE filters for high ratings only. The Avengers is the most profitable movie at $1,299M profit.

---

### Exercise 23 — Business Question

**Skills:** Real-world analytics

**Question:** Which payment method generates the highest average order value? Show payment_method, number of orders using it, and average order value (rounded to 2 decimals). Only include payment methods that have been used at least 10 times.

**Solution:**

```sql
SELECT payment_method,
       COUNT(*) AS num_orders,
       ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
GROUP BY payment_method
HAVING COUNT(*) >= 10
ORDER BY avg_order_value DESC;
```

**Expected Output:**

| payment_method | num_orders | avg_order_value |
|---------------|-----------|-----------------|
| Credit Card   | 19        | 217.33          |
| Debit Card    | 15        | 210.45          |
| PayPal        | 16        | 142.67          |

**Explanation:** Credit Card has the highest average order value ($217.33) and is the most used payment method (19 orders). PayPal has the lowest AOV ($142.67) despite being used 16 times.

**Business Insight:** Customers paying with Credit Cards tend to place higher-value orders. Consider promoting credit card payments for large purchases, or investigate why PayPal users have lower AOV.

---

### Exercise 24 — Multi-Table Analysis

**Skills:** JOINs across 3 tables

**Question:** Using orders and order_items, find the customer(s) who have ordered the most different products (count DISTINCT product_ids). Show customer_id and distinct_product_count.

**Solution:**

```sql
SELECT o.customer_id,
       COUNT(DISTINCT oi.product_id) AS distinct_product_count
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY distinct_product_count DESC;
```

**Expected Output:**

| customer_id | distinct_product_count |
|------------|-----------------------|
| 8          | 7                     |
| 16         | 6                     |
| 1          | 5                     |
| 2          | 4                     |
| 5          | 4                     |
| ...        | ...                   |

**Explanation:** JOIN connects orders to their line items. COUNT(DISTINCT product_id) counts unique products ordered, not total quantity. Customer 8 (Liam Garcia) ordered 7 different products — the highest variety.

---

### Exercise 25 — The Grand Finale

**Skills:** Everything!

**Question:** Write a query that generates a department salary report showing department name, number of employees, average salary (rounded to 0), minimum salary, maximum salary, total payroll, and salary_span (max - min). Only include departments where average salary is between $70,000 and $120,000 AND there are at least 2 employees. Sort by average salary descending.

**Solution:**

```sql
SELECT d.department_name,
       COUNT(*) AS num_employees,
       ROUND(AVG(e.salary), 0) AS avg_salary,
       ROUND(MIN(e.salary), 0) AS min_salary,
       ROUND(MAX(e.salary), 0) AS max_salary,
       ROUND(SUM(e.salary), 0) AS total_payroll,
       ROUND(MAX(e.salary) - MIN(e.salary), 0) AS salary_span
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) BETWEEN 70000 AND 120000
   AND COUNT(*) >= 2
ORDER BY avg_salary DESC;
```

**Expected Output:**

| department_name   | num_employees | avg_salary | min_salary | max_salary | total_payroll | salary_span |
|------------------|--------------|-----------|-----------|-----------|--------------|------------|
| Engineering      | 4            | 113000    | 65000     | 200000    | 452000       | 135000     |
| Sales            | 2            | 100000    | 70000     | 130000    | 200000       | 60000      |
| Product          | 2            | 92500     | 80000     | 105000    | 185000       | 25000      |
| Data & Analytics | 4            | 85000     | 55000     | 110000    | 340000       | 55000      |
| Marketing        | 2            | 72500     | 60000     | 85000     | 145000       | 25000      |

**Explanation:** This exercise brings together every beginner concept: JOIN (employees + departments), GROUP BY (per department), multiple aggregate functions, computed columns (salary_span), HAVING (filters on both AVG and COUNT), and ORDER BY. Human Resources is excluded because it has only 1 employee.
