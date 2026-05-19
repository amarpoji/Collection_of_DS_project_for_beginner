-- ============================================================
-- Lesson 20: Transactions
-- SQL File with REAL outputs from sqlite3
-- ============================================================

-- ============================================================
-- 1. Basic Transaction: COMMIT and ROLLBACK
-- ============================================================

-- Start a transaction
BEGIN TRANSACTION;

-- Insert a new employee
INSERT INTO employees (employee_id, first_name, last_name, email, phone, hire_date, job_title, salary, department_id)
VALUES (16, 'Test', 'User', 'test.user@company.com', '555-0199', '2024-06-01', 'Intern', 40000, 1);

-- Check the data within the transaction
SELECT employee_id, first_name, last_name, job_title, salary
FROM employees WHERE employee_id = 16;
/*
employee_id|first_name|last_name|job_title|salary
16|Test|User|Intern|40000
*/

-- Rollback the transaction (undo the insert)
ROLLBACK;

-- Verify the row is gone
SELECT employee_id, first_name, last_name
FROM employees WHERE employee_id = 16;
-- No rows returned

-- ============================================================
-- 2. Practical Example: Money Transfer Between Accounts
-- ============================================================

-- Create temporary accounts table (in-memory for this demo)
CREATE TEMP TABLE accounts (
    account_id INTEGER PRIMARY KEY,
    account_name TEXT NOT NULL,
    balance REAL NOT NULL DEFAULT 0
);

-- Insert account data
INSERT INTO accounts VALUES (1, 'Alice', 1000.00);
INSERT INTO accounts VALUES (2, 'Bob', 500.00);

-- Show initial balances
SELECT * FROM accounts;
/*
account_id|account_name|balance
1|Alice|1000.0
2|Bob|500.0
*/

-- Transfer $200 from Alice to Bob (IN A TRANSACTION)
BEGIN TRANSACTION;

-- Step 1: Deduct from Alice's account
UPDATE accounts SET balance = balance - 200 WHERE account_id = 1;

-- Step 2: Check Alice's balance (should be $800)
SELECT * FROM accounts WHERE account_id = 1;
/*
account_id|account_name|balance
1|Alice|800.0
*/

-- Step 3: Add to Bob's account
UPDATE accounts SET balance = balance + 200 WHERE account_id = 2;

-- Step 4: Verify both accounts
SELECT * FROM accounts ORDER BY account_id;
/*
account_id|account_name|balance
1|Alice|800.0
2|Bob|700.0
*/

-- Commit the transaction
COMMIT;

-- Final state
SELECT * FROM accounts ORDER BY account_id;
/*
account_id|account_name|balance
1|Alice|800.0
2|Bob|700.0
*/

-- ============================================================
-- 3. Error Handling Within Transactions
-- ============================================================

-- Simulate a transfer that fails mid-way
BEGIN TRANSACTION;

-- Deduct from Alice
UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;

-- Simulate an error (e.g., Bob's account doesn't exist)
-- This UPDATE affects 0 rows, but doesn't error
UPDATE accounts SET balance = balance + 500 WHERE account_id = 999;

-- Oops! Let's check what happened
SELECT * FROM accounts ORDER BY account_id;
/*
account_id|account_name|balance
1|Alice|300.0   -- Deducted but not credited!
2|Bob|700.0
*/

-- If we COMMIT now, money is lost! So we ROLLBACK
ROLLBACK;

-- Verify accounts are restored
SELECT * FROM accounts ORDER BY account_id;
/*
account_id|account_name|balance
1|Alice|800.0   -- Restored!
2|Bob|700.0
*/

-- ============================================================
-- 4. SAVEPOINT and ROLLBACK TO
-- ============================================================

-- SAVEPOINTs allow partial rollback within a transaction

BEGIN TRANSACTION;

-- Update 1: Alice deposits $100
UPDATE accounts SET balance = balance + 100 WHERE account_id = 1;
SAVEPOINT deposit_done;

-- Check after deposit
SELECT * FROM accounts ORDER BY account_id;
/*
account_id|account_name|balance
1|Alice|900.0
2|Bob|700.0
*/

-- Update 2: Transfer $300 to Bob
UPDATE accounts SET balance = balance - 300 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 300 WHERE account_id = 2;

-- Check after transfer
SELECT * FROM accounts ORDER BY account_id;
/*
account_id|account_name|balance
1|Alice|600.0
2|Bob|1000.0
*/

-- Actually, the transfer was too much. Rollback to the savepoint (undo transfer, keep deposit)
ROLLBACK TO deposit_done;

-- Check: Alice should have $900 (deposit kept), Bob should have $700 (transfer undone)
SELECT * FROM accounts ORDER BY account_id;
/*
account_id|account_name|balance
1|Alice|900.0
2|Bob|700.0
*/

-- Now do a smaller transfer
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

-- Commit
COMMIT;

-- Final state
SELECT * FROM accounts ORDER BY account_id;
/*
account_id|account_name|balance
1|Alice|800.0
2|Bob|800.0
*/

-- Cleanup temp table
DROP TABLE IF EXISTS accounts;

-- ============================================================
-- 5. ACID Properties Demonstrated
-- ============================================================

-- ATOMICITY: The transfer either fully completes or fully rolls back
-- (demonstrated above with the failed transfer)

-- CONSISTENCY: The total money in the system is preserved
-- Before: $1000 + $500 = $1500
-- After successful transfer: $800 + $700 = $1500 ✓

-- ISOLATION: Other connections don't see partial changes
-- (SQLite uses serialized isolation by default)

-- DURABILITY: Once COMMIT returns, data is safely on disk
-- (SQLite uses write-ahead logging by default)

-- ============================================================
-- 6. Transaction Isolation Levels (Brief)
-- ============================================================

-- SQLite has three isolation levels:
-- 1. DEFERRED (default): Locks acquired on first read/write
-- 2. IMMEDIATE: Locks acquired at BEGIN, prevents other writers
-- 3. EXCLUSIVE: Locks acquired at BEGIN, prevents all access

-- Examples:
BEGIN DEFERRED TRANSACTION;
SELECT * FROM employees WHERE department_id = 1;
-- Lock acquired here
COMMIT;

BEGIN IMMEDIATE TRANSACTION;
-- Lock acquired here
UPDATE employees SET salary = salary * 1.05 WHERE department_id = 1;
COMMIT;

-- ============================================================
-- 🔥 Challenge: Multi-step Order Processing
-- ============================================================

-- Create a transaction that:
-- 1. Creates a new order for customer_id=1
-- 2. Adds 2 items to order_items (product_id=1, qty=2 and product_id=2, qty=1)
-- 3. Updates products.stock_quantity for each product
-- 4. Uses SAVEPOINTs so that if any step fails, previous steps are preserved
-- 5. Commits only if all steps succeed, otherwise rolls back

-- Setup (use temp tables to avoid affecting real data)
CREATE TEMP TABLE temp_products AS SELECT * FROM products;
CREATE TEMP TABLE temp_orders AS SELECT * FROM orders;
CREATE TEMP TABLE temp_order_items AS SELECT * FROM order_items;

-- Show stock before
SELECT product_id, product_name, stock_quantity
FROM temp_products WHERE product_id IN (1, 2);
/*
product_id|product_name|stock_quantity
1|Wireless Mouse|150
2|Mechanical Keyboard|80
*/

-- Execute the order (practical transaction)
BEGIN TRANSACTION;

-- Step 1: Create the order
INSERT INTO temp_orders (order_id, customer_id, order_date, status, total_amount, payment_method, shipping_city, shipping_state)
VALUES (2000, 1, date('now'), 'Pending', 141.97, 'Credit Card', 'New York', 'NY');

SAVEPOINT order_created;

-- Step 2: Add items
INSERT INTO temp_order_items (item_id, order_id, product_id, quantity, unit_price)
VALUES (200, 2000, 1, 2, 25.99);

INSERT INTO temp_order_items (item_id, order_id, product_id, quantity, unit_price)
VALUES (201, 2000, 2, 1, 89.99);

SAVEPOINT items_added;

-- Step 3: Update stock
UPDATE temp_products SET stock_quantity = stock_quantity - 2 WHERE product_id = 1;
UPDATE temp_products SET stock_quantity = stock_quantity - 1 WHERE product_id = 2;

-- Verify stock
SELECT product_id, product_name, stock_quantity
FROM temp_products WHERE product_id IN (1, 2);
/*
product_id|product_name|stock_quantity
1|Wireless Mouse|148
2|Mechanical Keyboard|79
*/

-- All good — commit
COMMIT;

-- Cleanup
DROP TABLE IF EXISTS temp_products;
DROP TABLE IF EXISTS temp_orders;
DROP TABLE IF EXISTS temp_order_items;

-- ============================================================
-- Exercises for Lesson 20
-- ============================================================
-- Exercise 1: Create a transaction that inserts a new department and then rolls it back
-- Exercise 2: Perform a transfer between two "accounts" (use CREATE TEMP TABLE)
--             that fails gracefully if the source has insufficient funds
-- Exercise 3: Use SAVEPOINT to create a multi-step order that can be partially rolled back
-- Exercise 4: Demonstrate isolation by reading uncommitted data (conceptual)
-- Exercise 5: Create a transaction that updates multiple employee salaries and commits only
--             if the total salary budget doesn't exceed a threshold
