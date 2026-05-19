# Beginner SQL Exercises

This exercise set covers all beginner SQL topics from Lessons 01-08. Each exercise specifies which skills it tests.

**Database:** sql_mastery.db
**Tables:** employees, departments, customers, products, orders, order_items, movies, airbnb_listings

---

## Section 1: Basic SELECT & Exploration (Exercises 1-3)

### Exercise 1 — Exploring the Database
**Skills:** .tables, .schema, PRAGMA
**Difficulty:** ⭐

Use sqlite3 dot commands to explore the database. List the answers to:
a) How many tables are in the database?
b) What is the schema of the `departments` table?
c) What columns does the `order_items` table have?

### Exercise 2 — Simple SELECT
**Skills:** SELECT, LIMIT
**Difficulty:** ⭐

Write a query to show the first 5 rows from the `customers` table, showing only `first_name`, `last_name`, `city`, and `state`.

### Exercise 3 — Counting Records
**Skills:** COUNT(*)
**Difficulty:** ⭐

Count how many records exist in each of these tables in a single result:
- employees
- customers
- products
- movies

---

## Section 2: WHERE Filtering (Exercises 4-7)

### Exercise 4 — Numeric Filtering
**Skills:** WHERE with comparisons
**Difficulty:** ⭐

Find all products with a unit price greater than $100. Show product_name, category, and unit_price. Sort by price descending.

### Exercise 5 — Text Filtering
**Skills:** WHERE with text, LIKE
**Difficulty:** ⭐

Find all employees whose last name starts with 'B' or 'J'. Show their full name (first + last) and job title.

### Exercise 6 — BETWEEN & IN
**Skills:** BETWEEN, IN
**Difficulty:** ⭐⭐

Find all orders placed in January 2024 (order_date BETWEEN '2024-01-01' AND '2024-01-31') with a status IN ('Delivered', 'Shipped'). Show order_id, order_date, status, and total_amount.

### Exercise 7 — Complex WHERE with AND/OR
**Skills:** AND, OR, parentheses
**Difficulty:** ⭐⭐

Find all movies that are either:
- Drama genre with rating >= 8.5, OR
- Sci-Fi genre with rating >= 8.0

Show title, genre, and rating.

---

## Section 3: Sorting & Distinct (Exercises 8-10)

### Exercise 8 — ORDER BY
**Skills:** ORDER BY ASC/DESC, multiple columns
**Difficulty:** ⭐

List all employees sorted by department_id (ascending) and then by salary (descending within each department). Show first_name, last_name, department_id, and salary.

### Exercise 9 — DISTINCT
**Skills:** SELECT DISTINCT
**Difficulty:** ⭐

Find all unique job titles in the employees table. Sort alphabetically.

### Exercise 10 — LIMIT with OFFSET
**Skills:** LIMIT, OFFSET
**Difficulty:** ⭐⭐

Using a single query, show the 4th and 5th most expensive products. Show product_name and unit_price.

---

## Section 4: Aliases & Aggregation (Exercises 11-14)

### Exercise 11 — Column Aliases
**Skills:** AS alias
**Difficulty:** ⭐

Write a query that shows each movie as: "title (release_year)" with an alias of "movie_info". Also show the rating and revenue_millions. Limit to 10 rows.

### Exercise 12 — Basic Aggregation
**Skills:** COUNT, SUM, AVG, MIN, MAX
**Difficulty:** ⭐⭐

Calculate the following statistics for the products table in a single query:
- total_products
- average_price (rounded to 2 decimals)
- cheapest_product
- most_expensive_product
- total_stock_quantity

### Exercise 13 — Aggregate with WHERE
**Skills:** Aggregate + WHERE
**Difficulty:** ⭐⭐

What is the total revenue (SUM of total_amount) from all 'Delivered' orders? What is the average delivered order amount?

### Exercise 14 — ROUND with Aggregates
**Skills:** ROUND, AVG
**Difficulty:** ⭐⭐

Find the average, minimum, and maximum rating for Airbnb listings. Round all values to 2 decimal places. Also show how many listings have a rating.

---

## Section 5: GROUP BY (Exercises 15-17)

### Exercise 15 — Simple GROUP BY
**Skills:** GROUP BY, COUNT
**Difficulty:** ⭐⭐

Count how many movies exist in each genre. Show genre and movie_count. Sort by movie_count descending.

### Exercise 16 — GROUP BY with SUM
**Skills:** GROUP BY, SUM
**Difficulty:** ⭐⭐

For each department, calculate the total payroll (sum of salaries). Show department_id and total_payroll. Sort by total_payroll descending.

### Exercise 17 — GROUP BY with AVG
**Skills:** GROUP BY, AVG, JOIN
**Difficulty:** ⭐⭐⭐

For each department name (use JOIN with departments table), show:
- department_name
- employee_count
- average_salary (rounded to 0 decimal places)

Sort by average_salary descending.

---

## Section 6: HAVING (Exercises 18-20)

### Exercise 18 — Basic HAVING
**Skills:** HAVING with COUNT
**Difficulty:** ⭐⭐

Find neighbourhoods in the airbnb_listings table that have at least 2 listings. Show neighbourhood and listing_count. Sort by listing_count descending.

### Exercise 19 — HAVING with AVG
**Skills:** GROUP BY, HAVING, AVG
**Difficulty:** ⭐⭐⭐

Find product categories where the average unit price is above $50. Show category, avg_price (rounded to 2 decimals), and product_count. Sort by avg_price descending.

### Exercise 20 — WHERE + GROUP BY + HAVING + ORDER BY
**Skills:** Full pipeline
**Difficulty:** ⭐⭐⭐

Find customers who:
- Have placed at least 2 orders
- Have a total spend (sum of total_amount) greater than $300

Show customer_id, order_count, and total_spent (rounded to 2 decimals). Sort by total_spent descending.

---

## Section 7: Advanced Combined (Exercises 21-25)

### Exercise 21 — Everything Combined I
**Skills:** JOIN, GROUP BY, HAVING, ORDER BY, LIMIT
**Difficulty:** ⭐⭐⭐

Find the 3 departments with the highest average employee salary. Only include departments with at least 2 employees. Show department_name and avg_salary (rounded to 0 decimals).

### Exercise 22 — Everything Combined II
**Skills:** All concepts
**Difficulty:** ⭐⭐⭐

Find all movies that are in the top 10 most profitable movies (revenue - budget). Show title, genre, release_year, profit_millions, and rating. Only include movies with a rating of 8.0 or higher. Sort by profit descending.

### Exercise 23 — Business Question
**Skills:** Real-world analytics
**Difficulty:** ⭐⭐⭐⭐

The sales team wants to know: Which payment method generates the highest average order value? Show payment_method, number of orders using it, and average order value (rounded to 2 decimals). Only include payment methods that have been used at least 10 times.

### Exercise 24 — Multi-Table Analysis
**Skills:** JOINs across 3 tables
**Difficulty:** ⭐⭐⭐⭐

Using orders and order_items, find the customer(s) who have ordered the most different products (count DISTINCT product_ids). Show customer_id and distinct_product_count.

### Exercise 25 — The Grand Finale
**Skills:** Everything!
**Difficulty:** ⭐⭐⭐⭐⭐

Write a query that generates a department salary report showing:
- Department name
- Number of employees
- Average salary (rounded to 0)
- Minimum salary
- Maximum salary
- Total payroll
- The difference between max and min salary (salary_span)

Only include departments where:
- The average salary is between $70,000 and $120,000
- There are at least 2 employees

Sort by average salary descending.

---

## Answer Key

Solutions are available in the corresponding `.sql` files for each lesson. Try solving the exercises on your own first before checking!

**Good luck and happy querying! 🚀**
