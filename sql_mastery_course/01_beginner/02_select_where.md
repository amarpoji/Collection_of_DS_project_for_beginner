# Lesson 02: SELECT & WHERE

## SELECT - Asking Questions from Your Data

`SELECT` is the most fundamental SQL command. It's how you **query** (ask questions about) your data.

### Basic Syntax

```sql
SELECT column1, column2 FROM table_name;
```

**Real-world context:** Imagine you're an HR manager who needs a list of all employee names and salaries.

```sql
-- Get first name, last name, and salary of all employees
SELECT first_name, last_name, salary
FROM employees;
```

**Expected output (first few rows):**
```
first_name  last_name   salary
----------  ----------  -------
John        Smith       75000.0
Jane        Doe         95000.0
Bob         Johnson     110000.0
```

### SELECT * - The "All Columns" Shorthand

```sql
SELECT * FROM table_name;
```

The `*` means "all columns." It's great for exploration but **dangerous in production** because:
1. You might get more data than you need (slower queries)
2. If the table schema changes, your app might break
3. You waste bandwidth transferring unused columns

```sql
-- Grab everything about employees (useful for quick exploration)
SELECT * FROM employees;
```

## WHERE - Filtering Data

`WHERE` lets you **filter rows** based on conditions. Think of it as "show me only the rows where..."

```sql
SELECT columns FROM table WHERE condition;
```

### Comparison Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | Equal to | `salary = 75000` |
| `!=` or `<>` | Not equal to | `salary != 75000` |
| `<` | Less than | `salary < 80000` |
| `>` | Greater than | `salary > 80000` |
| `<=` | Less than or equal | `salary <= 80000` |
| `>=` | Greater than or equal | `salary >= 80000` |

### Numeric Filtering

```sql
-- Find all employees who earn more than $90,000
SELECT first_name, last_name, job_title, salary
FROM employees
WHERE salary > 90000;
```

**Expected output:**
```
first_name  last_name   job_title           salary
----------  ----------  ----------------  --------
Jane        Doe         Software Engineer    95000
Bob         Johnson     Data Scientist      110000
Alice       Williams    Product Manager     105000
Edward      Norton      Data Engineer       100000
George      Harris      CTO                 200000
Kevin       Bacon       DevOps Engineer      92000
Michael     Jordan      Sales Manager       130000
```

### Text Filtering

Text values must be wrapped in **single quotes** in SQLite.

```sql
-- Find the employee named 'Alice'
SELECT employee_id, first_name, last_name, job_title
FROM employees
WHERE first_name = 'Alice';
```

**Expected output:**
```
employee_id  first_name  last_name   job_title
-----------  ----------  ----------  -------------
4            Alice       Williams    Product Manager
```

```sql
-- Find all employees in the 'Data & Analytics' department
SELECT first_name, last_name, job_title
FROM employees
WHERE department_id = 1;
```

**Expected output:**
```
first_name  last_name   job_title
----------  ----------  -------------
John        Smith       Data Analyst
Bob         Johnson     Data Scientist
Edward      Norton      Data Engineer
Ian         Clark       Jr Data Analyst
```

### Filtering with AND, OR, NOT

#### AND (both conditions must be true)

```sql
-- Find female customers from New York
SELECT first_name, last_name, city, state
FROM customers
WHERE gender = 'Female' AND state = 'NY';
```

**Expected output:**
```
first_name  last_name   city      state
----------  ----------  --------  -----
Sarah       Johnson     New York   NY
```

#### OR (at least one condition must be true)

```sql
-- Find customers from California OR Texas
SELECT first_name, last_name, city, state
FROM customers
WHERE state = 'CA' OR state = 'TX';
```

**Expected output:**
```
first_name  last_name   city            state
----------  ----------  --------------  -----
Mike        Chen        San Francisco   CA
Alex        Kumar       Austin          TX
Olivia      Martinez    Los Angeles     CA
Isabella    Lee         Houston         TX
Benjamin    Thomas      Dallas          TX
Charlotte   Jackson     San Diego       CA
```

#### NOT (negate a condition)

```sql
-- Find customers who are NOT active
SELECT first_name, last_name, email, is_active
FROM customers
WHERE NOT is_active = 1;
```

**Expected output:**
```
first_name  last_name   email               is_active
----------  ----------  -----------------  ----------
Sophia      Brown       sophia.b@email.com          0
Noah        Wilson      noah.w@email.com            0
Lucas       White       lucas.w@email.com           0
```

### IN - Check Against a List

```sql
-- Find movies that are Action, Sci-Fi, or Thriller
SELECT title, genre, release_year, rating
FROM movies
WHERE genre IN ('Action', 'Sci-Fi', 'Thriller');
```

**Expected output (first 3 rows of many):**
```
title          genre     release_year  rating
-------------  --------  ------------  ------
The Matrix     Sci-Fi         1999       8.7
Inception      Sci-Fi         2010       8.8
The Dark Night Action         2008       9.0
```

### BETWEEN - Range Filtering

`BETWEEN` is inclusive (includes the boundary values).

```sql
-- Find movies released between 2010 and 2020
SELECT title, release_year, rating
FROM movies
WHERE release_year BETWEEN 2010 AND 2020;
```

```sql
-- Find products priced between $50 and $150
SELECT product_name, category, unit_price
FROM products
WHERE unit_price BETWEEN 50 AND 150;
```

**Expected output:**
```
product_name              category      unit_price
------------------------  ----------  -----------
USB-C Hub                 Electronics        45.5
Webcam HD                 Electronics       79.99
Noise Canceling Headphones Electronics      199.99
Laptop Stand              Furniture         39.99
Desk Lamp                 Furniture         55.0
Backpack                  Accessories       65.0
LED Desk Strip            Accessories       29.99
Bluetooth Speaker         Electronics      149.99
Monitor Arm               Furniture         89.0
External SSD 1TB          Electronics      129.99
```

### LIKE - Pattern Matching with Wildcards

`LIKE` is used for **text pattern matching**.

- `%` matches any sequence of characters (zero or more)
- `_` matches exactly one character

```sql
-- Find customers whose last name starts with 'M'
SELECT first_name, last_name, email
FROM customers
WHERE last_name LIKE 'M%';
```

**Expected output:**
```
first_name  last_name   email
----------  ----------  -----------------
Olivia      Martinez    olivia.m@email.com
```

```sql
-- Find customers whose email domain is 'email.com'
SELECT first_name, last_name, email
FROM customers
WHERE email LIKE '%@email.com';
```

**Expected output:**
```
first_name  last_name   email
----------  ----------  -----------------
Sarah       Johnson     sarah.j@email.com
Mike        Chen        mike.chen@email.com
... (all 20 customers)
```

```sql
-- Find employees whose job title contains 'Data'
SELECT first_name, last_name, job_title
FROM employees
WHERE job_title LIKE '%Data%';
```

**Expected output:**
```
first_name  last_name   job_title
----------  ----------  ------------
John        Smith       Data Analyst
Bob         Johnson     Data Scientist
Edward      Norton      Data Engineer
Ian         Clark       Jr Data Analyst
```

```sql
-- Find movies whose title is exactly 4 characters (_ matches one char)
SELECT title, release_year
FROM movies
WHERE title LIKE '____';
```

---

## Hands-On Exercises

### Exercise 1
Select the `first_name`, `last_name`, and `city` of all customers who live in 'Chicago'.

### Exercise 2
Find all employees with a salary greater than or equal to $100,000. Show their first name, last name, job title, and salary.

### Exercise 3
Find all movies that have a rating of 8.5 or higher and were released after the year 2000.

### Exercise 4
Find all customers who are between 25 and 35 years old. Show their name, age, and city.

### Exercise 5
Find all employees whose job title ends with 'Engineer' (use LIKE with %).

---

### 🔥 Mini Challenge
Write a query that finds:
1. All Sci-Fi movies with a rating above 8.5 (use AND)
2. All orders that are either 'Pending' or 'Shipped' (use IN)
3. All employees hired between 2018 and 2020 whose salary is less than $100,000
4. All customers with email ending in '@email.com' who are NOT from California
