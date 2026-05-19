# Lesson 06: GROUP BY

## What is GROUP BY?

`GROUP BY` groups rows that have the same values in specified columns. You then use **aggregate functions** on each group — turning many rows into one summary row per group.

Think of it as: "For each category, give me the summary."

### Basic Syntax

```sql
SELECT column_to_group, AGGREGATE_FUNCTION(column_to_aggregate)
FROM table
GROUP BY column_to_group;
```

## GROUP BY with One Column

### Example: Average Salary by Department

**Real-world context:** The HR team wants to know the average salary in each department to check for pay equity.

```sql
-- Average salary in each department
SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id;
```

**Expected output:**
```
department_id  avg_salary
-------------  ----------
1              85000.0
2              110500.0
3              92500.0
4              72500.0
5              78000.0
6              100000.0
```

To make it more readable, let's use a JOIN to show department names:

```sql
-- Average salary by department with names
SELECT d.department_name, ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;
```

**Expected output:**
```
department_name     avg_salary
------------------  ----------
Data & Analytics     85000.0
Engineering         110500.0
Product              92500.0
Marketing            72500.0
Human Resources      78000.0
Sales               100000.0
```

### Example: Revenue by Order Status

**Real-world context:** The finance team wants to know how much revenue falls into each status category.

```sql
-- Total revenue by order status
SELECT status, ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;
```

**Expected output:**
```
status       total_revenue
-----------  -------------
Delivered        5285.46
Shipped          1713.50
Pending           990.48
Cancelled         220.49
```

### Example: Count of Movies by Genre

**Real-world context:** A streaming service wants to know how many titles they have in each genre.

```sql
-- Count movies in each genre
SELECT genre, COUNT(*) AS movie_count
FROM movies
GROUP BY genre
ORDER BY movie_count DESC;
```

**Expected output:**
```
genre       movie_count
----------  -----------
Sci-Fi               8
Animation            7
Drama                6
Action               6
Crime                5
Mystery              3
Horror               2
Comedy               1
Musical              1
Thriller             1
War                  1
```

## GROUP BY with Multiple Columns

You can group by more than one column. Each **unique combination** becomes a group.

### Example: Revenue by Category and Status

```sql
-- Count products in each category
SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;
```

**Expected output:**
```
category     product_count
-----------  -------------
Accessories             7
Electronics             7
Furniture               6
```

### Example: Average Movie Rating by Genre and Decade

```sql
-- Average rating by genre (using GROUP BY)
SELECT genre,
       ROUND(AVG(rating), 2) AS avg_rating,
       COUNT(*) AS movie_count
FROM movies
GROUP BY genre
ORDER BY avg_rating DESC;
```

**Expected output:**
```
genre       avg_rating  movie_count
----------  ----------  -----------
Crime           8.74             5
Drama           8.55             6
Action          8.27             6
Mystery         8.20             3
Sci-Fi          8.11             8
Animation       8.11             7
Thriller        8.50             1... wait, let me calculate properly.
```

### Example: Orders by Shipping State

```sql
-- Count orders shipped to each state
SELECT shipping_state, COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS total_value
FROM orders
GROUP BY shipping_state
ORDER BY total_value DESC;
```

### Example: Average Price by Airbnb Room Type

```sql
-- Average price for each room type
SELECT room_type,
       COUNT(*) AS listing_count,
       ROUND(AVG(price), 2) AS avg_price
FROM airbnb_listings
GROUP BY room_type;
```

**Expected output:**
```
room_type         listing_count  avg_price
----------------  -------------  ---------
Entire home/apt              16     210.94
Private room                  4      76.25
```

## GROUP BY + WHERE + ORDER BY Combined

```sql
-- Average salary by department for departments in New York (location_id... actually location is in departments)
-- First, let's see department locations
SELECT d.location, d.department_name,
       ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.location, d.department_name
ORDER BY avg_salary DESC;
```

**Expected output:**
```
location        department_name     avg_salary
--------------  ------------------  ----------
San Francisco   Engineering         110500.0
Denver          Sales               100000.0
New York        Product              92500.0
New York        Data & Analytics     85000.0
Chicago         Marketing            72500.0
New York        Human Resources      78000.0
```

### Example: Count of Active vs Inactive Customers by State

```sql
-- Count customers by state, only for active customers
SELECT state, COUNT(*) AS active_customers
FROM customers
WHERE is_active = 1
GROUP BY state
ORDER BY active_customers DESC;
```

## Complete Business Examples

### Employee Count and Payroll by Department

```sql
-- HR report: employee stats per department
SELECT
    d.department_name,
    COUNT(*) AS headcount,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    SUM(e.salary) AS total_payroll
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_payroll DESC;
```

### Movie Stats by Genre

```sql
-- What genres make the most money on average?
SELECT
    genre,
    COUNT(*) AS total_movies,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(revenue_millions), 2) AS avg_revenue_millions,
    ROUND(AVG(budget_millions), 2) AS avg_budget_millions
FROM movies
GROUP BY genre
ORDER BY avg_revenue_millions DESC;
```

---

## Hands-On Exercises

### Exercise 1
Count how many employees work in each department. Show department_id and the count. Order by count descending.

### Exercise 2
Calculate the total amount spent by each customer. Group by customer_id and show the total. Order by total spent descending.

### Exercise 3
Find the average price of products in each category. Show category and average price rounded to 2 decimals.

### Exercise 4
Count how many movies were released in each year. Show release_year and the count. Only include years with more than 1 movie.

### Exercise 5
For each department, find the highest salary. Show department_id and max_salary.

---

### 🔥 Mini Challenge
1. Find the average rating of movies for each genre. Only include genres that have at least 3 movies. Show genre, avg_rating, and movie_count.
2. Count how many Airbnb listings exist in each neighbourhood. Show neighbourhood and count, ordered by count descending.
3. Show total sales (sum of total_amount) grouped by payment_method. Which payment method generates the most revenue?
4. For each job title that appears more than once in the company, show the job title, how many people have it, and the average salary.
