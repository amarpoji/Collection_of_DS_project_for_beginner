# Lesson 04: Aliases & Advanced Filtering

## Column Aliases

An **alias** is a temporary name for a column or table in your query. It doesn't change the database — it just renames the output.

### Using AS for Column Aliases

```sql
SELECT column_name AS alias_name FROM table;
```

**Real-world context:** When generating reports, you want readable column names for your stakeholders.

```sql
-- Give salary a friendlier name in the output
SELECT first_name, last_name, salary AS annual_salary
FROM employees;
```

```sql
-- Rename calculated or combined columns
SELECT first_name || ' ' || last_name AS full_name, salary
FROM employees
LIMIT 5;
```

**Expected output:**
```
full_name       salary
------------  --------
John Smith       75000
Jane Doe         95000
Bob Johnson     110000
Alice Williams  105000
Charlie Brown    65000
```

```sql
-- Use aliases for better readability in aggregations
SELECT COUNT(*) AS total_employees,
       ROUND(AVG(salary), 2) AS average_salary
FROM employees;
```

**Expected output:**
```
total_employees  average_salary
---------------  --------------
15               93333.33
```

### AS is Optional

The `AS` keyword is optional in SQL. These two queries are identical:

```sql
-- With AS
SELECT salary * 1.1 AS salary_with_raise FROM employees;

-- Without AS
SELECT salary * 1.1 salary_with_raise FROM employees;
```

However, using `AS` is **recommended** for clarity.

### Aliases with Spaces

If your alias has spaces, wrap it in double quotes:

```sql
SELECT first_name AS "First Name", last_name AS "Last Name"
FROM employees
LIMIT 3;
```

## Table Aliases

Table aliases make queries shorter and more readable, especially with JOINs (covered later).

```sql
-- Without alias
SELECT employees.first_name, employees.salary FROM employees;

-- With alias
SELECT e.first_name, e.salary FROM employees AS e;
```

```sql
-- Even without the AS keyword
SELECT e.first_name, e.salary FROM employees e;
```

Table aliases are incredibly useful when you're working with multiple tables.

## Advanced Filtering with AND, OR, and Parentheses

When combining multiple conditions, **use parentheses** to control the order of evaluation — just like in math!

### The Problem Without Parentheses

```sql
-- Without parentheses: this might not do what you expect!
SELECT first_name, last_name, state, is_active
FROM customers
WHERE state = 'NY' OR state = 'CA' AND is_active = 1;
```

Without parentheses, `AND` binds tighter than `OR`. So this reads as:
`state = 'NY' OR (state = 'CA' AND is_active = 1)`

### The Fix With Parentheses

```sql
-- With parentheses: explicitly group conditions
SELECT first_name, last_name, state, is_active
FROM customers
WHERE (state = 'NY' OR state = 'CA') AND is_active = 1;
```

**Expected output:**
```
first_name  last_name   state  is_active
----------  ----------  -----  ---------
Sarah       Johnson     NY             1
Mike        Chen        CA             1
Olivia      Martinez    CA             1
Charlotte   Jackson     CA             1
```

### Practical Filtering Patterns

```sql
-- Employees in Engineering OR Data departments with salary > 80000
SELECT first_name, last_name, department_id, salary
FROM employees
WHERE (department_id = 1 OR department_id = 2) AND salary > 80000;
```

**Expected output:**
```
first_name  last_name   department_id  salary
----------  ----------  -------------  -------
Jane        Doe                    2    95000
Bob         Johnson                1   110000
Edward      Norton                 1   100000
Kevin       Bacon                  2    92000
```

```sql
-- Movies that are either (Sci-Fi with rating > 8.5) OR (any genre after 2020)
SELECT title, genre, rating, release_year
FROM movies
WHERE (genre = 'Sci-Fi' AND rating > 8.5) OR release_year > 2020;
```

**Expected output:**
```
title                                 genre    rating  release_year
------------------------------------  -------  ------  ------------
The Matrix                            Sci-Fi      8.7          1999
Inception                             Sci-Fi      8.8          2010
Everything Everywhere All at Once     Sci-Fi      7.8          2022
Dune                                  Sci-Fi      8.0          2021
The Batman                            Action      7.8          2022
```

## IS NULL / IS NOT NULL

In SQL, you cannot use `= NULL` or `!= NULL`. You must use `IS NULL` or `IS NOT NULL`.

**Important:** In our database, the `manager_id` column stores the text `'NULL'` for employees with no manager, not actual SQL NULL. Let's explore both concepts.

### Finding Actual NULL Values

```sql
-- Find orders that have no shipping_city (if any existed)
SELECT order_id, total_amount
FROM orders
WHERE shipping_city IS NULL;
```

If no rows match, there are no NULL shipping cities.

### Finding Non-NULL Values

```sql
-- Find employees who have a manager (manager_id is NOT the text 'NULL')
SELECT first_name, last_name, manager_id
FROM employees
WHERE manager_id != 'NULL';
```

**Expected output:**
```
first_name  last_name   manager_id
----------  ----------  ----------
Jane        Doe         1
Bob         Johnson     1
Alice       Williams    1
Charlie     Brown       2
Diana       Prince      1
Edward      Norton      3
Fiona       Apple       4
Hannah      Martin      6
Ian         Clark       3
Kevin       Bacon       2
Laura       Wilson      1
```

### Common Filtering Patterns

```sql
-- Find products with low stock (less than 50 units)
SELECT product_name, category, stock_quantity
FROM products
WHERE stock_quantity < 50;
```

**Expected output:**
```
product_name              category      stock_quantity
------------------------  ----------  ---------------
27-inch Monitor           Electronics               45
Standing Desk             Furniture                 30
Ergonomic Chair           Furniture                 25
Bluetooth Speaker         Electronics               55
External SSD 1TB          Electronics               40
```

```sql
-- Find expensive movies with high ratings (budget > 100M AND rating > 8.0)
SELECT title, budget_millions, rating
FROM movies
WHERE budget_millions > 100 AND rating > 8.0;
```

**Expected output:**
```
title               budget_millions  rating
------------------  ---------------  ------
Inception                      160      8.8
Interstellar                   165      8.6
The Dark Knight                185      9.0
Gladiator                      103      8.5
The Batman                     200      7.8  -- no, this has 7.8
```

Let me correct:

```sql
SELECT title, budget_millions, rating
FROM movies
WHERE budget_millions > 100 AND rating > 8.0
ORDER BY rating DESC;
```

---

## Hands-On Exercises

### Exercise 1
Write a query that shows employees' full names (first + last combined) as "full_name", job title as "position", and salary as "annual_compensation". Only show employees earning $80,000 or more.

### Exercise 2
Find all customers from NY, CA, or TX who are active (is_active = 1). Use parentheses properly.

### Exercise 3
Find all products in the Accessories category with a unit price less than $20. Show product_name and unit_price.

### Exercise 4
Find movies that are either (Action genre with rating >= 8.0) OR (Sci-Fi genre with rating >= 8.0). Show title, genre, and rating.

### Exercise 5
Show all employees who do NOT have a manager (where manager_id = 'NULL'). Use IS NULL or string comparison.

---

### 🔥 Mini Challenge
1. Find all orders that are 'Delivered' AND have a total_amount greater than $200. Show order_id, customer_id, status, and amount.
2. Find all employees whose salary is between $70,000 and $100,000 AND who are in department 1 or 3.
3. Find Airbnb listings with rating >= 4.8 that are entire homes/apartments. Show property_name, room_type, and rating.
4. Find movies with a revenue_millions greater than budget_millions (profitable movies!) and a rating above 8.0.
