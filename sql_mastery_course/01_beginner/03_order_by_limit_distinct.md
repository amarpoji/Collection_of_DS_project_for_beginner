# Lesson 03: ORDER BY, LIMIT & DISTINCT

## ORDER BY - Sorting Results

`ORDER BY` sorts your query results. By default, it sorts in **ascending** order (A-Z, smallest to largest).

### Basic Syntax

```sql
SELECT columns FROM table ORDER BY column1 ASC|DESC;
```

- `ASC` = Ascending (default, can be omitted)
- `DESC` = Descending

### Sorting by One Column

```sql
-- Show employees ordered by salary (lowest first)
SELECT first_name, last_name, job_title, salary
FROM employees
ORDER BY salary;
```

**Expected output (first 3 rows):**
```
first_name  last_name   job_title           salary
----------  ----------  ----------------  --------
Ian         Clark       Jr Data Analyst     55000
Hannah      Martin      Marketing Analyst   60000
Charlie     Brown       Junior Developer    65000
```

```sql
-- Show employees ordered by salary (highest first)
SELECT first_name, last_name, job_title, salary
FROM employees
ORDER BY salary DESC;
```

**Expected output (first 3 rows):**
```
first_name  last_name   job_title   salary
----------  ----------  ----------  -------
George      Harris      CTO         200000
Michael     Jordan      Sales Manager 130000
Bob         Johnson     Data Scientist 110000
```

### Sorting by Multiple Columns

When two rows have the same value in the first sort column, the second column breaks the tie.

```sql
-- Sort employees by department first, then by salary within each dept
SELECT department_id, first_name, last_name, salary
FROM employees
ORDER BY department_id ASC, salary DESC;
```

**Expected output:**
```
department_id  first_name  last_name   salary
-------------  ----------  ----------  -------
1              Bob         Johnson     110000
1              Edward      Norton      100000
1              John        Smith        75000
1              Ian         Clark        55000
2              George      Harris      200000
2              Jane        Doe          95000
2              Kevin       Bacon        92000
2              Charlie     Brown        65000
3              Alice       Williams    105000
3              Fiona       Apple        80000
4              Diana       Prince       85000
4              Hannah      Martin       60000
5              Julia       Roberts      78000
6              Michael     Jordan      130000
6              Laura       Wilson       70000
```

### Sorting Text Columns

```sql
-- Sort customers alphabetically by last name
SELECT first_name, last_name, city
FROM customers
ORDER BY last_name;
```

```sql
-- Sort movies alphabetically within each genre
SELECT genre, title, release_year
FROM movies
ORDER BY genre ASC, title ASC;
```

## LIMIT - Getting Only the Top Results

`LIMIT` restricts how many rows are returned. Perfect for "top 5" or "first 10" scenarios.

```sql
-- Get the 5 highest-paid employees
SELECT first_name, last_name, job_title, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;
```

**Expected output:**
```
first_name  last_name   job_title       salary
----------  ----------  -------------  -------
George      Harris      CTO            200000
Michael     Jordan      Sales Manager  130000
Bob         Johnson     Data Scientist 110000
Alice       Williams    Product Manager 105000
Edward      Norton      Data Engineer  100000
```

```sql
-- Get the 3 most recent orders
SELECT order_id, customer_id, order_date, total_amount
FROM orders
ORDER BY order_date DESC
LIMIT 3;
```

**Expected output:**
```
order_id  customer_id  order_date  total_amount
--------  -----------  ----------  ------------
1050      14           2024-05-10         410.0
1049      8            2024-05-08          92.0
1048      11           2024-05-05         180.0
```

## OFFSET - Pagination with LIMIT

`OFFSET` skips a certain number of rows. Combined with `LIMIT`, it's how you build **pagination**.

```sql
-- Page 1: Rows 1-5 (skip 0 rows)
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5 OFFSET 0;
```

```sql
-- Page 2: Rows 6-10 (skip 5 rows)
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5 OFFSET 5;
```

## SELECT DISTINCT - Removing Duplicates

`DISTINCT` returns only **unique values** for the selected columns.

```sql
-- What states do our customers live in?
SELECT DISTINCT state
FROM customers
ORDER BY state;
```

**Expected output:**
```
state
-----
AZ
CA
CO
FL
GA
IL
MA
MN
MO
NC
NY
OR
TN
TX
WA
```

```sql
-- What genres do we have in our movie collection?
SELECT DISTINCT genre
FROM movies
ORDER BY genre;
```

**Expected output:**
```
genre
---------
Action
Animation
Comedy
Crime
Drama
Horror
Musical
Mystery
Sci-Fi
Thriller
War
```

```sql
-- What job titles exist in the company?
SELECT DISTINCT job_title
FROM employees
ORDER BY job_title;
```

### DISTINCT with Multiple Columns

```sql
-- Find unique city/state combinations
SELECT DISTINCT city, state
FROM customers
ORDER BY state;
```

## Combining Everything

You can chain `SELECT DISTINCT ... WHERE ... ORDER BY ... LIMIT` together!

```sql
-- Top 3 most expensive products in the Electronics category
SELECT product_name, unit_price
FROM products
WHERE category = 'Electronics'
ORDER BY unit_price DESC
LIMIT 3;
```

**Expected output:**
```
product_name                unit_price
-------------------------  ----------
27-inch Monitor                 349.99
Noise Canceling Headphones      199.99
Bluetooth Speaker               149.99
```

```sql
-- 5 most recent movies with rating above 8.5
SELECT title, release_year, rating
FROM movies
WHERE rating > 8.5
ORDER BY release_year DESC
LIMIT 5;
```

**Expected output:**
```
title                          release_year  rating
-----------------------------  ------------  ------
Parasite                               2019     8.5
Interstellar                           2014     8.6
Inception                              2010     8.8
The Dark Knight                         2008     9.0
Pulp Fiction                            1994     8.9
```

---

## Hands-On Exercises

### Exercise 1
List all products ordered by price from highest to lowest. Show only the first 5.

### Exercise 2
Show all unique cities where customers live, sorted alphabetically.

### Exercise 3
Find the 3 oldest movies (by release_year) in the database.

### Exercise 4
Get the top 10 most recent orders. Show order_id, customer_id, order_date, and total_amount.

### Exercise 5
Show distinct job titles in the Engineering department (department_id = 2). Sort alphabetically.

---

### 🔥 Mini Challenge
1. Find the top 3 highest-rated movies (by rating) released after 2010.
2. Get 5 most expensive Airbnb listings, showing property name, neighbourhood, and price.
3. Find all unique room_types from the airbnb_listings table.
4. Show orders sorted by total_amount descending, but skip the first 10 and show the next 5 (like page 3 if page size is 5).
