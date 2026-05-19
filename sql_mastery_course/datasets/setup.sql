-- =============================================================================
-- SQL MASTERY COURSE - Master Database Setup Script
-- =============================================================================
-- This script creates ALL tables needed for the course and imports data.
-- Run: sqlite3 sql_mastery.db < setup.sql
-- =============================================================================

-- Drop existing tables if they exist (for re-runs)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS airbnb_listings;

-- =============================================================================
-- 1. EMPLOYEES & DEPARTMENTS DATABASE
-- =============================================================================

CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    department_name TEXT NOT NULL,
    location TEXT,
    budget REAL
);

CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT,
    hire_date TEXT,
    job_title TEXT,
    salary REAL,
    department_id INTEGER,
    manager_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- =============================================================================
-- 2. E-COMMERCE DATABASE (Customers, Orders, Products, Order_Items)
-- =============================================================================

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE,
    gender TEXT,
    age INTEGER,
    city TEXT,
    state TEXT,
    registration_date TEXT,
    is_active INTEGER DEFAULT 1
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT,
    unit_price REAL NOT NULL,
    stock_quantity INTEGER DEFAULT 0,
    supplier_id INTEGER
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    status TEXT CHECK(status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    total_amount REAL,
    payment_method TEXT,
    shipping_city TEXT,
    shipping_state TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =============================================================================
-- 3. MOVIES DATABASE
-- =============================================================================

CREATE TABLE movies (
    movie_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    genre TEXT,
    release_year INTEGER,
    rating REAL,
    duration_min INTEGER,
    director TEXT,
    studio TEXT,
    budget_millions REAL,
    revenue_millions REAL
);

-- =============================================================================
-- 4. AIRBNB / HOUSING DATABASE
-- =============================================================================

CREATE TABLE airbnb_listings (
    property_id INTEGER PRIMARY KEY,
    property_name TEXT,
    host_id INTEGER,
    neighbourhood TEXT,
    room_type TEXT,
    price REAL,
    nights_booked INTEGER,
    reviews INTEGER,
    rating REAL,
    bedrooms INTEGER,
    bathrooms INTEGER,
    superhost INTEGER DEFAULT 0
);

-- =============================================================================
-- 5. CREATE INDEXES FOR PERFORMANCE
-- =============================================================================

CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_movies_genre ON movies(genre);
CREATE INDEX idx_movies_year ON movies(release_year);
CREATE INDEX idx_airbnb_neighbourhood ON airbnb_listings(neighbourhood);
CREATE INDEX idx_airbnb_room_type ON airbnb_listings(room_type);

.print '=== DATABASE SETUP COMPLETE ==='
.print 'All tables and indexes created successfully.'
.print 'Next: Import the CSV data using .import commands.'
