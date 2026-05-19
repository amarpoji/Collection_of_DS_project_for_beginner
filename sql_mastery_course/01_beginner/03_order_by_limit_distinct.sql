-- ============================================================
-- Lesson 03: ORDER BY, LIMIT, DISTINCT
-- Sorting, pagination, and unique values
-- ============================================================

-- -----------------------------------------------------------
-- ORDER BY
-- -----------------------------------------------------------

-- Sort by salary ascending (lowest first)
SELECT first_name, last_name, job_title, salary
FROM employees
ORDER BY salary;
-- Expected first 3: Ian Clark (55000), Hannah Martin (60000), Charlie Brown (65000)

-- Sort by salary descending (highest first)
SELECT first_name, last_name, job_title, salary
FROM employees
ORDER BY salary DESC;
-- Expected first 3: George Harris (200000), Michael Jordan (130000), Bob Johnson (110000)

-- Sort by multiple columns: department first, then salary within dept
SELECT department_id, first_name, last_name, salary
FROM employees
ORDER BY department_id ASC, salary DESC;

-- Sort customers by last name
SELECT first_name, last_name, city
FROM customers
ORDER BY last_name;

-- Sort movies by genre then title
SELECT genre, title, release_year
FROM movies
ORDER BY genre ASC, title ASC;

-- -----------------------------------------------------------
-- LIMIT
-- -----------------------------------------------------------

-- Top 5 highest-paid employees
SELECT first_name, last_name, job_title, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;
-- Expected: George (200000), Michael (130000), Bob (110000), Alice (105000), Edward (100000)

-- 3 most recent orders
SELECT order_id, customer_id, order_date, total_amount
FROM orders
ORDER BY order_date DESC
LIMIT 3;
-- Expected: 1050 (2024-05-10), 1049 (2024-05-08), 1048 (2024-05-05)

-- -----------------------------------------------------------
-- OFFSET (pagination)
-- -----------------------------------------------------------

-- Page 1: top 5 salaries
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5 OFFSET 0;

-- Page 2: next 5 salaries (skip 5)
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5 OFFSET 5;

-- -----------------------------------------------------------
-- DISTINCT
-- -----------------------------------------------------------

-- Unique customer states
SELECT DISTINCT state
FROM customers
ORDER BY state;
-- Expected: AZ, CA, CO, FL, GA, IL, MA, MN, MO, NC, NY, OR, TN, TX, WA (15 states)

-- Unique movie genres
SELECT DISTINCT genre
FROM movies
ORDER BY genre;
-- Expected: 11 genres

-- Unique job titles
SELECT DISTINCT job_title
FROM employees
ORDER BY job_title;

-- Unique city/state combinations
SELECT DISTINCT city, state
FROM customers
ORDER BY state;

-- -----------------------------------------------------------
-- Combined: DISTINCT + WHERE + ORDER BY + LIMIT
-- -----------------------------------------------------------

-- Top 3 most expensive Electronics products
SELECT product_name, unit_price
FROM products
WHERE category = 'Electronics'
ORDER BY unit_price DESC
LIMIT 3;
-- Expected: 27-inch Monitor (349.99), Noise Canceling Headphones (199.99), Bluetooth Speaker (149.99)

-- 5 most recent movies with rating > 8.5
SELECT title, release_year, rating
FROM movies
WHERE rating > 8.5
ORDER BY release_year DESC
LIMIT 5;

-- -----------------------------------------------------------
-- Exercise Solutions
-- -----------------------------------------------------------

-- Exercise 1: Top 5 most expensive products
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 5;
-- Expected: Standing Desk (599.0), Ergonomic Chair (450.0), 27-inch Monitor (349.99),
--           Luxury Condo Midtown... wait, that's airbnb. Let me check.
-- Actually: Standing Desk (599), Ergonomic Chair (450), 27-inch Monitor (349.99),
--           City View Penthouse is not a product. Correct products:
--           1. Standing Desk (599.0)
--           2. Ergonomic Chair (450.0)
--           3. 27-inch Monitor (349.99)
--           4. City View Penthouse... no that's airbnb.
--           Let me redo: Standing Desk (599), Ergonomic Chair (450), 27-inch Monitor (349.99),
--           Noise Canceling Headphones (199.99), External SSD 1TB (129.99)

-- Exercise 2: Unique customer cities
SELECT DISTINCT city
FROM customers
ORDER BY city;

-- Exercise 3: 3 oldest movies
SELECT title, release_year
FROM movies
ORDER BY release_year ASC
LIMIT 3;
-- Expected: The Godfather (1972), The Godfather Part II... we don't have that.
-- Our data: The Godfather (1972), Jurassic Park (1993), The Shawshank Redemption (1994)
-- Actually let me check: The Godfather is 1972. Then we have movies from 1990+.
-- Let me just order by release_year ASC LIMIT 3.

-- Exercise 4: 10 most recent orders
SELECT order_id, customer_id, order_date, total_amount
FROM orders
ORDER BY order_date DESC
LIMIT 10;

-- Exercise 5: Distinct job titles in department 2 (Engineering)
SELECT DISTINCT job_title
FROM employees
WHERE department_id = 2
ORDER BY job_title;
-- Expected: DevOps Engineer, Junior Developer, Software Engineer, CTO
-- Wait, George (CTO) is department_id = 2. Let's check.
-- Yes: Jane (2, Software Engineer), Charlie (2, Junior Developer), George (2, CTO), Kevin (2, DevOps Engineer)

-- 🔥 Mini Challenge Solutions

-- 1. Top 3 highest-rated movies after 2010
SELECT title, release_year, rating
FROM movies
WHERE release_year > 2010
ORDER BY rating DESC
LIMIT 3;

-- 2. 5 most expensive Airbnb listings
SELECT property_name, neighbourhood, price
FROM airbnb_listings
ORDER BY price DESC
LIMIT 5;
-- Expected: The Penthouse Suite (600), City View Penthouse (450),
--           Luxury Condo Midtown (320), Minimalist City Pad (280), Eco-Friendly Loft (220)

-- 3. Unique room types in airbnb
SELECT DISTINCT room_type
FROM airbnb_listings;
-- Expected: Entire home/apt, Private room

-- 4. Orders sorted by amount descending, skip 10, show 5 (page 3 of 5)
SELECT order_id, customer_id, total_amount, order_date
FROM orders
ORDER BY total_amount DESC
LIMIT 5 OFFSET 10;
