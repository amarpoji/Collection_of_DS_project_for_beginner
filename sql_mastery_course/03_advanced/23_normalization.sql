-- ============================================================
-- Lesson 23: Normalization
-- SQL File with REAL outputs from sqlite3
-- ============================================================

-- ============================================================
-- DEMONSTRATION: Normalizing a Denormalized Sales Table
-- Step by step through 1NF → 2NF → 3NF
-- ============================================================

-- ============================================================
-- STEP 0: The Denormalized Sales Table (Anti-Pattern)
-- ============================================================

-- This is what BAD database design looks like.
-- One table stores everything: order, customer, product, and payment info all together.

CREATE TABLE IF NOT EXISTS denormalized_sales (
    order_id INTEGER,
    order_date TEXT,
    customer_name TEXT,
    customer_email TEXT,
    customer_city TEXT,
    customer_state TEXT,
    product_ids TEXT,           -- Comma-separated list (violates 1NF!)
    product_names TEXT,         -- Comma-separated list (violates 1NF!)
    quantities TEXT,            -- Comma-separated list (violates 1NF!)
    prices TEXT,                -- Comma-separated list (violates 1NF!)
    total_amount REAL,
    payment_method TEXT,
    shipping_city TEXT,
    shipping_state TEXT
);

-- Insert sample denormalized data
INSERT INTO denormalized_sales VALUES
    (1001, '2024-01-05', 'Sarah Johnson', 'sarah.j@email.com', 'New York', 'NY',
     '1,14,18', 'Wireless Mouse, Notebook Set, Desk Lamp',
     '2,3,5', '25.99,12.50,9.99', 125.99, 'Credit Card', 'New York', 'NY'),

    (1002, '2024-01-07', 'Mike Chen', 'mike.chen@email.com', 'San Francisco', 'CA',
     '3,1', 'USB-C Hub, Wireless Mouse',
     '1,1', '45.50,25.99', 89.50, 'PayPal', 'San Francisco', 'CA');

-- Problems with this design:
-- 1️⃣ Product data is stored as comma-separated strings (not atomic → violates 1NF)
-- 2️⃣ Customer info is repeated on every order (redundant → violates 2NF/3NF)
-- 3️⃣ Cannot easily query: "which products were ordered together?"
-- 4️⃣ Cannot enforce data integrity (what if a product name changes?)

SELECT * FROM denormalized_sales;
/*
order_id|order_date|customer_name|customer_email|customer_city|customer_state|product_ids|product_names|quantities|prices|total_amount|payment_method|shipping_city|shipping_state
1001|2024-01-05|Sarah Johnson|sarah.j@email.com|New York|NY|1,14,18|Wireless Mouse, Notebook Set, Desk Lamp|2,3,5|25.99,12.50,9.99|125.99|Credit Card|New York|NY
1002|2024-01-07|Mike Chen|mike.chen@email.com|San Francisco|CA|3,1|USB-C Hub, Wireless Mouse|1,1|45.50,25.99|89.5|PayPal|San Francisco|CA
*/

-- ============================================================
-- STEP 1: First Normal Form (1NF)
-- ============================================================

-- 1NF Rules:
-- 1. Each cell contains a single, atomic value (no lists)
-- 2. All entries in a column are the same type
-- 3. Each row is unique (has a primary key)
-- 4. No repeating groups

-- To achieve 1NF, we "explode" the multi-valued columns into separate rows,
-- each with a single product value:

CREATE TABLE IF NOT EXISTS sales_1nf (
    order_id INTEGER,
    order_date TEXT,
    customer_name TEXT,
    customer_email TEXT,
    customer_city TEXT,
    customer_state TEXT,
    product_id INTEGER,
    product_name TEXT,
    quantity INTEGER,
    unit_price REAL,
    total_amount REAL,
    payment_method TEXT,
    shipping_city TEXT,
    shipping_state TEXT,
    PRIMARY KEY (order_id, product_id)
);

INSERT INTO sales_1nf VALUES
    -- Order 1001, Product 1
    (1001, '2024-01-05', 'Sarah Johnson', 'sarah.j@email.com', 'New York', 'NY',
     1, 'Wireless Mouse', 2, 25.99, 125.99, 'Credit Card', 'New York', 'NY'),
    -- Order 1001, Product 14
    (1001, '2024-01-05', 'Sarah Johnson', 'sarah.j@email.com', 'New York', 'NY',
     14, 'Notebook Set', 3, 12.50, 125.99, 'Credit Card', 'New York', 'NY'),
    -- Order 1001, Product 18
    (1001, '2024-01-05', 'Sarah Johnson', 'sarah.j@email.com', 'New York', 'NY',
     18, 'Desk Lamp', 5, 9.99, 125.99, 'Credit Card', 'New York', 'NY'),
    -- Order 1002, Product 3
    (1002, '2024-01-07', 'Mike Chen', 'mike.chen@email.com', 'San Francisco', 'CA',
     3, 'USB-C Hub', 1, 45.50, 89.50, 'PayPal', 'San Francisco', 'CA'),
    -- Order 1002, Product 1
    (1002, '2024-01-07', 'Mike Chen', 'mike.chen@email.com', 'San Francisco', 'CA',
     1, 'Wireless Mouse', 1, 25.99, 89.50, 'PayPal', 'San Francisco', 'CA');

-- Now in 1NF: each cell is atomic, composite PK (order_id, product_id)
-- But still has redundancy: customer info repeats per product

SELECT * FROM sales_1nf ORDER BY order_id, product_id;
/*
order_id|order_date|customer_name|customer_email|customer_city|customer_state|product_id|product_name|quantity|unit_price|total_amount|payment_method|shipping_city|shipping_state
1001|2024-01-05|Sarah Johnson|sarah.j@email.com|New York|NY|1|Wireless Mouse|2|25.99|125.99|Credit Card|New York|NY
1001|2024-01-05|Sarah Johnson|sarah.j@email.com|New York|NY|14|Notebook Set|3|12.5|125.99|Credit Card|New York|NY
1001|2024-01-05|Sarah Johnson|sarah.j@email.com|New York|NY|18|Desk Lamp|5|9.99|125.99|Credit Card|New York|NY
1002|2024-01-07|Mike Chen|mike.chen@email.com|San Francisco|CA|3|USB-C Hub|1|45.5|89.5|PayPal|San Francisco|CA
1002|2024-01-07|Mike Chen|mike.chen@email.com|San Francisco|CA|1|Wireless Mouse|1|25.99|89.5|PayPal|San Francisco|CA
*/

-- ============================================================
-- STEP 2: Second Normal Form (2NF)
-- ============================================================

-- 2NF Rules (additional to 1NF):
-- 1. Must be in 1NF
-- 2. No partial dependencies: every non-key column must depend on
--    the ENTIRE primary key, not just part of it

-- In sales_1nf, the PK is (order_id, product_id).
-- But: customer_name depends ONLY on order_id (not on product_id) → PARTIAL DEPENDENCY
--      product_name depends ONLY on product_id (not on order_id) → PARTIAL DEPENDENCY
-- These violate 2NF.

-- To achieve 2NF, split into three tables:

-- Table A: Orders (depends on order_id only)
CREATE TABLE IF NOT EXISTS orders_2nf (
    order_id INTEGER PRIMARY KEY,
    order_date TEXT,
    total_amount REAL,
    payment_method TEXT,
    shipping_city TEXT,
    shipping_state TEXT
);

-- Table B: Products (depends on product_id only)
CREATE TABLE IF NOT EXISTS products_2nf (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL
);

-- Table C: Order_Items (depends on the FULL composite key)
-- This is the junction table that resolves the M:N relationship
CREATE TABLE IF NOT EXISTS order_items_2nf (
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    unit_price REAL NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders_2nf(order_id),
    FOREIGN KEY (product_id) REFERENCES products_2nf(product_id)
);

-- Insert data
INSERT INTO orders_2nf VALUES
    (1001, '2024-01-05', 125.99, 'Credit Card', 'New York', 'NY'),
    (1002, '2024-01-07', 89.50, 'PayPal', 'San Francisco', 'CA');

INSERT INTO products_2nf VALUES
    (1, 'Wireless Mouse'),
    (3, 'USB-C Hub'),
    (14, 'Notebook Set'),
    (18, 'Desk Lamp');

INSERT INTO order_items_2nf VALUES
    (1001, 1, 2, 25.99),
    (1001, 14, 3, 12.50),
    (1001, 18, 5, 9.99),
    (1002, 3, 1, 45.50),
    (1002, 1, 1, 25.99);

-- Now no partial dependencies! Each table's non-key columns depend on
-- the entire PK of that table.

-- But we still have customer info in... wait, we haven't added customers yet!
-- Let's also extract customer info (already demonstrating 3NF need)

-- ============================================================
-- STEP 3: Third Normal Form (3NF)
-- ============================================================

-- 3NF Rules (additional to 2NF):
-- 1. Must be in 2NF
-- 2. No transitive dependencies: non-key columns must depend ONLY on the PK,
--    not on other non-key columns

-- In orders_2nf, we need to add customer_id (FK). But if we store
-- customer_name, customer_email, etc. directly in orders_2nf, those
-- depend on customer_id, not on order_id — that's a transitive dependency.

-- FIX: Extract customer info into its own table.

-- Table: Customers
CREATE TABLE IF NOT EXISTS customers_3nf (
    customer_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT,
    city TEXT,
    state TEXT
);

-- Revised Orders table (with FK to customers)
CREATE TABLE IF NOT EXISTS orders_3nf (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TEXT,
    total_amount REAL,
    payment_method TEXT,
    shipping_city TEXT,
    shipping_state TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers_3nf(customer_id)
);

-- Products and Order_Items tables from 2NF remain unchanged (they're already in 3NF)
-- Products: product_id → product_name (direct dependency on PK ✓)
-- Order_Items: (order_id, product_id) → quantity, unit_price (direct ✓)

-- Insert customer data
INSERT INTO customers_3nf VALUES
    (1, 'Sarah', 'Johnson', 'sarah.j@email.com', 'New York', 'NY'),
    (2, 'Mike', 'Chen', 'mike.chen@email.com', 'San Francisco', 'CA');

-- Insert into revised orders
INSERT INTO orders_3nf VALUES
    (1001, 1, '2024-01-05', 125.99, 'Credit Card', 'New York', 'NY'),
    (1002, 2, '2024-01-07', 89.50, 'PayPal', 'San Francisco', 'CA');

-- ============================================================
-- FINAL: Querying the Normalized Schema
-- ============================================================

-- Reconstruct the full denormalized view (for reporting)
SELECT
    o.order_id,
    o.order_date,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email AS customer_email,
    c.city AS customer_city,
    c.state AS customer_state,
    p.product_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    o.total_amount,
    o.payment_method,
    o.shipping_city,
    o.shipping_state
FROM orders_3nf o
JOIN customers_3nf c ON o.customer_id = c.customer_id
JOIN order_items_2nf oi ON o.order_id = oi.order_id
JOIN products_2nf p ON oi.product_id = p.product_id
ORDER BY o.order_id, p.product_id;

/*
order_id|order_date|customer_name|customer_email|customer_city|customer_state|product_id|product_name|quantity|unit_price|total_amount|payment_method|shipping_city|shipping_state
1001|2024-01-05|Sarah Johnson|sarah.j@email.com|New York|NY|1|Wireless Mouse|2|25.99|125.99|Credit Card|New York|NY
1001|2024-01-05|Sarah Johnson|sarah.j@email.com|New York|NY|14|Notebook Set|3|12.5|125.99|Credit Card|New York|NY
1001|2024-01-05|Sarah Johnson|sarah.j@email.com|New York|NY|18|Desk Lamp|5|9.99|125.99|Credit Card|New York|NY
1002|2024-01-07|Mike Chen|mike.chen@email.com|San Francisco|CA|3|USB-C Hub|1|45.5|89.5|PayPal|San Francisco|CA
1002|2024-01-07|Mike Chen|mike.chen@email.com|San Francisco|CA|1|Wireless Mouse|1|25.99|89.5|PayPal|San Francisco|CA
*/

-- Same data as the denormalized table, but now it's:
-- ✅ Consistent (product name stored once)
-- ✅ Non-redundant (customer info stored once)
-- ✅ Flexible (can add products, customers independently)
-- ✅ Queryable (can ask "which products sell together?")

-- ============================================================
-- Normalization Levels Summary
-- ============================================================

-- 1NF: Atomic values, no repeating groups
-- 2NF: 1NF + no partial dependencies (all non-key → full PK)
-- 3NF: 2NF + no transitive dependencies (non-key → non-key → PK)
-- BCNF: 3NF + every determinant is a candidate key
-- 4NF: BCNF + no multi-valued dependencies
-- 5NF: 4NF + every join dependency is implied by candidate keys

-- ============================================================
-- When to De-Normalize
-- ============================================================

-- Sometimes, for performance, you might denormalize:
-- 1. Reporting/Data Warehouse: Pre-joined tables for faster reads
-- 2. Read-heavy apps: Reduce JOINs at the cost of some redundancy
-- 3. Materialized views: Store computed results

-- But: denormalization trades data integrity for speed.
-- Always start normalized, denormalize only when you MEASURE a bottleneck.

-- ============================================================
-- Cleanup
-- ============================================================
DROP TABLE IF EXISTS denormalized_sales;
DROP TABLE IF EXISTS sales_1nf;
DROP TABLE IF EXISTS orders_2nf;
DROP TABLE IF EXISTS products_2nf;
DROP TABLE IF EXISTS order_items_2nf;
DROP TABLE IF EXISTS customers_3nf;
DROP TABLE IF EXISTS orders_3nf;

-- ============================================================
-- Exercises for Lesson 23
-- ============================================================
-- Exercise 1: Identify which normal form this table violates:
--   student_courses(student_id, student_name, course_ids_csv) (where course_ids_csv = "101,102,103")
-- Exercise 2: Normalize this table to 2NF: order_summary(order_id, product_id, product_name, qty, price, customer_name)
-- Exercise 3: Identify the transitive dependency: employees(emp_id, dept_id, dept_name, salary)
-- Exercise 4: Normalize this to 3NF: project_assignments(emp_id, emp_name, project_id, project_name, hours)
-- Exercise 5: When would you choose to DENORMALIZE a 3NF schema? Give a real-world example.
