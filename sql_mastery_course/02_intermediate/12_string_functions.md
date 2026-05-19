# Lesson 12: String Functions — Manipulating Text Data

## Why String Functions Matter

Raw text data is messy — inconsistent casing, leading/trailing spaces, mixed formats, embedded characters. String functions let you clean, transform, extract, and analyze text directly in SQL without exporting to a scripting language.

All examples use **SQLite** string functions. Most databases have equivalent functions (sometimes with different names).

---

## 1. UPPER / LOWER — Change Case

### Syntax
```sql
UPPER(text)  -- converts to uppercase
LOWER(text)  -- converts to lowercase
```

### Example: Normalize customer emails for comparison

```sql
SELECT email,
       UPPER(email) AS upper_email,
       LOWER(email) AS lower_email
FROM customers
LIMIT 5;
```

**Expected output**
```
email|upper_email|lower_email
sarah.j@email.com|SARAH.J@EMAIL.COM|sarah.j@email.com
mike.chen@email.com|MIKE.CHEN@EMAIL.COM|mike.chen@email.com
emma.d@email.com|EMMA.D@EMAIL.COM|emma.d@email.com
alex.k@email.com|ALEX.K@EMAIL.COM|alex.k@email.com
olivia.m@email.com|OLIVIA.M@EMAIL.COM|olivia.m@email.com
```

---

## 2. LENGTH — Count Characters

### Example: Find customers with short or long names

```sql
SELECT first_name || ' ' || last_name AS full_name,
       LENGTH(first_name || ' ' || last_name) AS name_length
FROM customers
ORDER BY name_length DESC
LIMIT 8;
```

**Expected output**
```
full_name|name_length
Charlotte Jackson|18
Benjamin Thomas|15
Isabella Lee|13
Olivia Martinez|16
...
```

---

## 3. SUBSTR / SUBSTRING — Extract Part of a String

`SUBSTR(string, start, length)` — 1-based indexing. If length is omitted, returns everything from start to end.

### Example 1: Extract first 3 characters of product names

```sql
SELECT product_name,
       SUBSTR(product_name, 1, 3) AS short_code
FROM products
LIMIT 8;
```

**Expected output**
```
product_name|short_code
Wireless Mouse|Wir
Mechanical Keyboard|Mec
USB-C Hub|USB
27-inch Monitor|27-
Webcam HD|Web
Noise Canceling Headphones|Noi
Standing Desk|Sta
Ergonomic Chair|Erg
```

### Example 2: Extract last 4 characters of phone numbers

```sql
SELECT first_name, last_name, phone,
       SUBSTR(phone, -4) AS last_four
FROM employees;
```

**Expected output (first 3 rows)**
```
first_name|last_name|phone|last_four
John|Smith|555-0101|0101
Jane|Doe|555-0102|0102
Bob|Johnson|555-0103|0103
```

---

## 4. INSTR — Find Position of a Substring

Returns the 1-based position of the first occurrence, or 0 if not found.

### Example: Find the '@' position in emails (for domain extraction)

```sql
SELECT email,
       INSTR(email, '@') AS at_position
FROM customers
LIMIT 5;
```

**Expected output**
```
email|at_position
sarah.j@email.com|9
mike.chen@email.com|10
emma.d@email.com|7
alex.k@email.com|7
olivia.m@email.com|9
```

---

## 5. TRIM — Remove Leading/Trailing Characters

`TRIM(string)` removes spaces. `LTRIM` / `RTRIM` for left/right only. Also accepts a character set to remove.

### Example: Clean up city names (if they had spaces — demo purpose)

```sql
SELECT city,
       LENGTH(city) AS original_len,
       TRIM('  ' || city || '  ') AS trimmed_city
FROM customers
LIMIT 3;
```

---

## 6. REPLACE — Find and Replace Text

### Example 1: Mask email domains for privacy

```sql
SELECT email,
       REPLACE(email, '@email.com', '@company.com') AS updated_email
FROM customers
LIMIT 5;
```

**Expected output**
```
email|updated_email
sarah.j@email.com|sarah.j@company.com
mike.chen@email.com|mike.chen@company.com
emma.d@email.com|emma.d@company.com
alex.k@email.com|alex.k@company.com
olivia.m@email.com|olivia.m@company.com
```

### Example 2: Clean up product names (remove hyphens)

```sql
SELECT product_name,
       REPLACE(product_name, '-', ' ') AS cleaned_name
FROM products
WHERE product_name LIKE '%-%';
```

**Expected output**
```
product_name|cleaned_name
USB-C Hub|USB C Hub
27-inch Monitor|27 inch Monitor
...
```

---

## 7. Concatenation with ||

Combine strings. SQLite uses `||` (standard SQL). Some databases use `+` or `CONCAT()`.

### Example: Build a full address from customer data

```sql
SELECT first_name || ' ' || last_name AS customer,
       city || ', ' || state AS location
FROM customers
LIMIT 5;
```

**Expected output**
```
customer|location
Sarah Johnson|New York, NY
Mike Chen|San Francisco, CA
Emma Davis|Chicago, IL
Alex Kumar|Austin, TX
Olivia Martinez|Los Angeles, CA
```

---

## 8. Putting It All Together — Real Examples

### Example 1: Extract email domains and count users per domain

```sql
SELECT SUBSTR(email, INSTR(email, '@') + 1) AS domain,
       COUNT(*) AS user_count
FROM customers
GROUP BY domain;
```

**Expected output**
```
domain|user_count
email.com|20
```

### Example 2: Format employee names for a directory

```sql
SELECT UPPER(last_name) || ', ' || first_name AS directory_name,
       LOWER(email) AS email,
       REPLACE(phone, '-', '.') AS formatted_phone
FROM employees
LIMIT 5;
```

**Expected output**
```
directory_name|email|formatted_phone
SMITH, John|john.smith@company.com|555.0101
DOE, Jane|jane.doe@company.com|555.0102
JOHNSON, Bob|bob.johnson@company.com|555.0103
WILLIAMS, Alice|alice.williams@company.com|555.0104
BROWN, Charlie|charlie.brown@company.com|555.0105
```

### Example 3: Product name analysis — category prefix detection

```sql
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
```

**Expected output**
```
product_name|product_family
27-inch Monitor|Displays & Ports
Bluetooth Speaker|Other
External SSD 1TB|Other
Mechanical Keyboard|Input
Noise Canceling Headphones|Other
USB-C Hub|Displays & Ports
Webcam HD|Other
Wireless Mouse|Connectivity
```

### Example 4: Customer city cleanup — normalize casing

```sql
SELECT DISTINCT city,
       UPPER(SUBSTR(city, 1, 1)) || LOWER(SUBSTR(city, 2)) AS proper_city
FROM customers
ORDER BY city;
```

**Expected output**
```
city|proper_city
Atlanta|Atlanta
Austin|Austin
Boston|Boston
Charlotte|Charlotte
Chicago|Chicago
...
```

---

## Exercises

1. **Email username extraction** — Extract the username (part before '@') from customer emails. Show email and username.

2. **Product code generation** — Create a short product code: first 3 letters of product name (uppercase) + last 2 digits of unit_price (as integer). Show product_name and product_code.

3. **Name formatting** — Show employee names as `Lastname, Firstname` (last name in all caps) and a column `initials` (first letter of first + last name, uppercase).

4. **City character count** — Find the longest city name in the customers table. Show the city and its character length.

5. **Phone area code** — Extract the first 3 digits of phone numbers (before the first dash). Show employee name and area_code.

---

## 🔥 Mini Challenges

1. **Domain anonymization** — Replace everything after the '@' in customer emails with '@redacted.com' and create a masked_email column. Hint: use INSTR + SUBSTR.

2. **Product name word count** — Count how many words each product name has (split by space). Show product_name and word_count. Hint: LENGTH - LENGTH(REPLACE) is one approach.
