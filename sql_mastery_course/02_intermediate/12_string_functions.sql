-- ========================================================================
-- LESSON 12: String Functions — Manipulating Text Data
-- Target: sqlite3 /mnt/c/Users/USER/.../sql_mastery.db
-- ========================================================================

-- ============================================================
-- 1. UPPER / LOWER — Change Case
-- ============================================================

SELECT email,
       UPPER(email) AS upper_email,
       LOWER(email) AS lower_email
FROM customers
LIMIT 5;

-- Expected:
-- sarah.j@email.com|SARAH.J@EMAIL.COM|sarah.j@email.com
-- mike.chen@email.com|MIKE.CHEN@EMAIL.COM|mike.chen@email.com
-- emma.d@email.com|EMMA.D@EMAIL.COM|emma.d@email.com
-- alex.k@email.com|ALEX.K@EMAIL.COM|alex.k@email.com
-- olivia.m@email.com|OLIVIA.M@EMAIL.COM|olivia.m@email.com

-- ============================================================
-- 2. LENGTH — Count Characters
-- ============================================================

SELECT first_name || ' ' || last_name AS full_name,
       LENGTH(first_name || ' ' || last_name) AS name_length
FROM customers
ORDER BY name_length DESC
LIMIT 8;

-- ============================================================
-- 3. SUBSTR — Extract Part of a String
-- ============================================================

-- 3A. First 3 chars of product names
SELECT product_name,
       SUBSTR(product_name, 1, 3) AS short_code
FROM products
LIMIT 8;

-- Expected:
-- Wireless Mouse|Wir
-- Mechanical Keyboard|Mec
-- USB-C Hub|USB
-- 27-inch Monitor|27-
-- Webcam HD|Web
-- Noise Canceling Headphones|Noi
-- Standing Desk|Sta
-- Ergonomic Chair|Erg

-- 3B. Last 4 characters of phone numbers
SELECT first_name, last_name, phone,
       SUBSTR(phone, -4) AS last_four
FROM employees;

-- ============================================================
-- 4. INSTR — Find Position of a Substring
-- ============================================================

SELECT email,
       INSTR(email, '@') AS at_position
FROM customers
LIMIT 5;

-- Expected:
-- sarah.j@email.com|9
-- mike.chen@email.com|10
-- emma.d@email.com|7
-- alex.k@email.com|7
-- olivia.m@email.com|9

-- ============================================================
-- 5. TRIM — Remove Leading/Trailing Spaces
-- ============================================================

SELECT city,
       LENGTH(city) AS original_len,
       TRIM('  ' || city || '  ') AS trimmed_city,
       LENGTH(TRIM('  ' || city || '  ')) AS trimmed_len
FROM customers
LIMIT 3;

-- ============================================================
-- 6. REPLACE — Find and Replace
-- ============================================================

-- 6A. Mask email domains
SELECT email,
       REPLACE(email, '@email.com', '@company.com') AS updated_email
FROM customers
LIMIT 5;

-- Expected:
-- sarah.j@email.com|sarah.j@company.com
-- mike.chen@email.com|mike.chen@company.com
-- emma.d@email.com|emma.d@company.com
-- alex.k@email.com|alex.k@company.com
-- olivia.m@email.com|olivia.m@company.com

-- 6B. Clean product names (replace hyphens)
SELECT product_name,
       REPLACE(product_name, '-', ' ') AS cleaned_name
FROM products
WHERE product_name LIKE '%-%';

-- ============================================================
-- 7. Concatenation with ||
-- ============================================================

SELECT first_name || ' ' || last_name AS customer,
       city || ', ' || state AS location
FROM customers
LIMIT 5;

-- Expected:
-- Sarah Johnson|New York, NY
-- Mike Chen|San Francisco, CA
-- Emma Davis|Chicago, IL
-- Alex Kumar|Austin, TX
-- Olivia Martinez|Los Angeles, CA

-- ============================================================
-- 8. Putting It All Together
-- ============================================================

-- 8A. Extract email domains and count
SELECT SUBSTR(email, INSTR(email, '@') + 1) AS domain,
       COUNT(*) AS user_count
FROM customers
GROUP BY domain;

-- Expected:
-- email.com|20

-- 8B. Format employee directory names
SELECT UPPER(last_name) || ', ' || first_name AS directory_name,
       LOWER(email) AS email,
       REPLACE(phone, '-', '.') AS formatted_phone
FROM employees
LIMIT 5;

-- Expected:
-- SMITH, John|john.smith@company.com|555.0101
-- DOE, Jane|jane.doe@company.com|555.0102
-- JOHNSON, Bob|bob.johnson@company.com|555.0103
-- WILLIAMS, Alice|alice.williams@company.com|555.0104
-- BROWN, Charlie|charlie.brown@company.com|555.0105

-- 8C. Product name analysis — category prefix detection
SELECT product_name,
       CASE
           WHEN SUBSTR(product_name, 1, 4) = 'Wire' THEN 'Connectivity'
           WHEN SUBSTR(product_name, 1, 3) IN ('USB', '27-') THEN 'Displays & Ports'
           WHEN INSTR(product_name, 'Keyboard') > 0 THEN 'Input'
           ELSE 'Other'
       END AS product_family
FROM products
WHERE category = 'Electronics'
ORDER BY product_name;

-- Expected:
-- 27-inch Monitor|Displays & Ports
-- Bluetooth Speaker|Other
-- External SSD 1TB|Other
-- Mechanical Keyboard|Input
-- Noise Canceling Headphones|Other
-- USB-C Hub|Displays & Ports
-- Webcam HD|Other
-- Wireless Mouse|Connectivity

-- 8D. Proper case for city names
SELECT DISTINCT city,
       UPPER(SUBSTR(city, 1, 1)) || LOWER(SUBSTR(city, 2)) AS proper_city
FROM customers
ORDER BY city;

-- ============================================================
-- Exercises (uncomment to run)
-- ============================================================

-- 1. Email username extraction
-- SELECT email,
--        SUBSTR(email, 1, INSTR(email, '@') - 1) AS username
-- FROM customers;

-- 2. Product code: first 3 letters (UPPER) + last 2 digits of price
-- SELECT product_name,
--        UPPER(SUBSTR(product_name, 1, 3)) ||
--        CAST(CAST(unit_price AS INTEGER) % 100 AS TEXT) AS product_code
-- FROM products;

-- 3. Name formatting: LASTNAME, Firstname + initials
-- SELECT UPPER(last_name) || ', ' || first_name AS directory_name,
--        UPPER(SUBSTR(first_name, 1, 1) || SUBSTR(last_name, 1, 1)) AS initials
-- FROM employees;

-- 4. Longest city name
-- SELECT city, LENGTH(city) AS city_len
-- FROM customers
-- ORDER BY city_len DESC
-- LIMIT 1;

-- 5. Phone area codes
-- SELECT first_name || ' ' || last_name AS employee,
--        SUBSTR(phone, 1, INSTR(phone, '-') - 1) AS area_code
-- FROM employees;

-- ============================================================
-- 🔥 Mini Challenges (uncomment to run)
-- ============================================================

-- 1. Email anonymization
-- SELECT email,
--        SUBSTR(email, 1, INSTR(email, '@')) || 'redacted.com' AS masked_email
-- FROM customers;

-- 2. Word count in product names
-- SELECT product_name,
--        LENGTH(product_name) - LENGTH(REPLACE(product_name, ' ', '')) + 1 AS word_count
-- FROM products
-- ORDER BY word_count DESC;
