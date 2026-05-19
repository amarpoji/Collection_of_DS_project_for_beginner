-- =============================================================================
-- SQL Mastery Course - Data Import Script
-- =============================================================================
-- This script imports all CSV data into the SQLite database.
-- Run: sqlite3 sql_mastery.db < import_data.sql
-- =============================================================================

.mode csv
.import datasets/departments.csv departments
.import datasets/employees.csv employees
.import datasets/customers.csv customers
.import datasets/products.csv products
.import datasets/orders.csv orders
.import datasets/order_items.csv order_items
.import datasets/movies.csv movies
.import datasets/airbnb_listings.csv airbnb_listings

.print '=== DATA IMPORT COMPLETE ==='
.print 'All CSV data imported successfully.'
.print ''
-- Verify by counting rows
SELECT 'departments: ' || COUNT(*) FROM departments;
SELECT 'employees: ' || COUNT(*) FROM employees;
SELECT 'customers: ' || COUNT(*) FROM customers;
SELECT 'products: ' || COUNT(*) FROM products;
SELECT 'orders: ' || COUNT(*) FROM orders;
SELECT 'order_items: ' || COUNT(*) FROM order_items;
SELECT 'movies: ' || COUNT(*) FROM movies;
SELECT 'airbnb_listings: ' || COUNT(*) FROM airbnb_listings;
