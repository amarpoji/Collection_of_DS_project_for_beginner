-- ============================================================
-- Lesson 22: Database Design Basics
-- SQL File with REAL outputs from sqlite3
-- ============================================================

-- ============================================================
-- 1. Examining the Existing Database Schema
-- ============================================================

-- Our database already has well-designed tables. Let's examine them:

-- Departments (lookup table for employee departments)
PRAGMA table_info(departments);
/*
cid|name|type|notnull|dflt_value|pk
0|department_id|INTEGER|0||1
1|department_name|TEXT|1||0
2|location|TEXT|0||0
3|budget|REAL|0||0
*/

-- Employees (with FK to departments, self-referencing FK manager_id)
PRAGMA table_info(employees);
/*
cid|name|type|notnull|dflt_value|pk
0|employee_id|INTEGER|0||1
1|first_name|TEXT|1||0
2|last_name|TEXT|1||0
3|email|TEXT|0||0
4|phone|TEXT|0||0
5|hire_date|TEXT|0||0
6|job_title|TEXT|0||0
7|salary|REAL|0||0
8|department_id|INTEGER|0||0
9|manager_id|INTEGER|0||0
*/

-- Orders and Order_Items (1:M relationship)
PRAGMA table_info(orders);
-- Note: customer_id is FK to customers, order_id is PK

PRAGMA table_info(order_items);
-- Note: item_id is PK, order_id FK to orders, product_id FK to products

-- ============================================================
-- 2. Relationship Types Demonstrated
-- ============================================================

-- 1:1 Relationship (one-to-one)
-- Example: An employee has one desk, a desk is assigned to one employee
-- In our schema: could be employee <-> employee_contact_info

-- 1:M Relationship (one-to-many)
-- Example: A department has many employees
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY employee_count DESC;
/*
department_name|employee_count
Data & Analytics|4
Engineering|4
Marketing|2
Product|2
Sales|2
Human Resources|1
*/

-- M:N Relationship (many-to-many)
-- Example: Orders and Products (via order_items junction table)
-- An order can contain many products, a product can be in many orders
SELECT o.order_id, COUNT(oi.product_id) AS product_count,
       GROUP_CONCAT(p.product_name, ', ') AS products
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_id IN (1001, 1002)
GROUP BY o.order_id;
/*
order_id|product_count|products
1001|3|Wireless Mouse, Notebook Set, Desk Lamp
1002|2|USB-C Hub, Wireless Mouse
*/

-- ============================================================
-- 3. Designing a Library System
-- ============================================================

-- Let's design and create a library database schema

-- Table: Books
CREATE TABLE IF NOT EXISTS library_books (
    book_id INTEGER PRIMARY KEY,
    isbn TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    publisher TEXT,
    publish_year INTEGER,
    genre TEXT,
    total_copies INTEGER DEFAULT 1,
    available_copies INTEGER DEFAULT 1
);

-- Table: Members
CREATE TABLE IF NOT EXISTS library_members (
    member_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT,
    membership_date TEXT DEFAULT (date('now')),
    membership_status TEXT DEFAULT 'Active'
);

-- Table: Loans (junction table for the M:N relationship between members and books)
CREATE TABLE IF NOT EXISTS library_loans (
    loan_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    loan_date TEXT DEFAULT (date('now')),
    due_date TEXT,
    return_date TEXT,
    status TEXT DEFAULT 'Borrowed',
    FOREIGN KEY (member_id) REFERENCES library_members(member_id),
    FOREIGN KEY (book_id) REFERENCES library_books(book_id)
);

-- Insert sample data
INSERT INTO library_books VALUES
    (1, '978-0-13-110362-7', 'The C Programming Language', 'Kernighan & Ritchie', 'Prentice Hall', 1978, 'Technology', 3, 3),
    (2, '978-0-596-51774-8', 'Learning SQL', 'Alan Beaulieu', "O'Reilly", 2009, 'Technology', 2, 2),
    (3, '978-0-321-12521-7', 'Domain-Driven Design', 'Eric Evans', 'Addison-Wesley', 2003, 'Technology', 1, 1);

INSERT INTO library_members VALUES
    (1, 'Alice', 'Johnson', 'alice.j@email.com', '555-1001', '2024-01-15', 'Active'),
    (2, 'Bob', 'Smith', 'bob.s@email.com', '555-1002', '2024-02-20', 'Active');

INSERT INTO library_loans (loan_id, member_id, book_id, loan_date, due_date, status)
VALUES
    (1, 1, 2, '2024-05-01', '2024-05-15', 'Borrowed'),
    (2, 2, 1, '2024-05-05', '2024-05-19', 'Borrowed');

-- Query: Who has borrowed what?
SELECT lm.first_name || ' ' || lm.last_name AS member,
       lb.title AS book,
       ll.loan_date, ll.due_date,
       CASE WHEN ll.due_date < date('now') AND ll.return_date IS NULL
            THEN 'OVERDUE' ELSE ll.status END AS status
FROM library_loans ll
JOIN library_members lm ON ll.member_id = lm.member_id
JOIN library_books lb ON ll.book_id = lb.book_id;
/*
member|book|loan_date|due_date|status
Alice Johnson|Learning SQL|2024-05-01|2024-05-15|OVERDUE
Bob Smith|The C Programming Language|2024-05-05|2024-05-19|Borrowed
*/

-- ============================================================
-- 4. Designing a Blog Database
-- ============================================================

-- Users table
CREATE TABLE IF NOT EXISTS blog_users (
    user_id INTEGER PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    display_name TEXT,
    registered_at TEXT DEFAULT (date('now'))
);

-- Posts table (1:M with users)
CREATE TABLE IF NOT EXISTS blog_posts (
    post_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    content TEXT,
    published_at TEXT,
    status TEXT DEFAULT 'Draft',
    FOREIGN KEY (user_id) REFERENCES blog_users(user_id)
);

-- Comments table (1:M with posts, 1:M with users)
CREATE TABLE IF NOT EXISTS blog_comments (
    comment_id INTEGER PRIMARY KEY,
    post_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    created_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (post_id) REFERENCES blog_posts(post_id),
    FOREIGN KEY (user_id) REFERENCES blog_users(user_id)
);

-- Tags (lookup table)
CREATE TABLE IF NOT EXISTS blog_tags (
    tag_id INTEGER PRIMARY KEY,
    tag_name TEXT UNIQUE NOT NULL
);

-- Post_Tags (junction table for M:N between posts and tags)
CREATE TABLE IF NOT EXISTS blog_post_tags (
    post_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    PRIMARY KEY (post_id, tag_id),
    FOREIGN KEY (post_id) REFERENCES blog_posts(post_id),
    FOREIGN KEY (tag_id) REFERENCES blog_tags(tag_id)
);

-- Insert sample blog data
INSERT INTO blog_users VALUES
    (1, 'john_doe', 'john@blog.com', 'John Doe', '2024-01-01'),
    (2, 'jane_author', 'jane@blog.com', 'Jane Author', '2024-02-01');

INSERT INTO blog_posts VALUES
    (1, 1, 'Getting Started with SQL', 'SQL is amazing...', '2024-03-01', 'Published'),
    (2, 2, 'Database Design Tips', 'Design your schema carefully...', '2024-03-15', 'Published'),
    (3, 1, 'Advanced Window Functions', 'Window functions are powerful...', '2024-04-01', 'Draft');

INSERT INTO blog_comments VALUES
    (1, 1, 2, 'Great intro to SQL!', '2024-03-02 10:00:00'),
    (2, 2, 1, 'Very helpful tips, thanks!', '2024-03-16 14:30:00');

INSERT INTO blog_tags VALUES
    (1, 'SQL'),
    (2, 'Database'),
    (3, 'Tutorial');

INSERT INTO blog_post_tags VALUES
    (1, 1), (1, 3),
    (2, 2), (2, 3),
    (3, 1), (3, 2);

-- Query posts with tags
SELECT bp.title, bu.display_name AS author,
       GROUP_CONCAT(bt.tag_name, ', ') AS tags,
       bp.status, bp.published_at
FROM blog_posts bp
JOIN blog_users bu ON bp.user_id = bu.user_id
LEFT JOIN blog_post_tags bpt ON bp.post_id = bpt.post_id
LEFT JOIN blog_tags bt ON bpt.tag_id = bt.tag_id
GROUP BY bp.post_id
ORDER BY bp.published_at;
/*
title|author|tags|status|published_at
Getting Started with SQL|John Doe|SQL, Tutorial|Published|2024-03-01
Database Design Tips|Jane Author|Database, Tutorial|Published|2024-03-15
Advanced Window Functions|John Doe|SQL, Database|Draft|2024-04-01
*/

-- ============================================================
-- 5. Design Patterns Demonstrated
-- ============================================================

-- Looking up statuses (lookup/enum table)
CREATE TABLE IF NOT EXISTS order_statuses (
    status_code TEXT PRIMARY KEY,
    status_name TEXT NOT NULL,
    description TEXT
);

INSERT INTO order_statuses VALUES
    ('Pending', 'Pending', 'Order received, awaiting processing'),
    ('Processing', 'Processing', 'Order is being prepared'),
    ('Shipped', 'Shipped', 'Order has been shipped'),
    ('Delivered', 'Delivered', 'Order delivered to customer'),
    ('Cancelled', 'Cancelled', 'Order was cancelled');

-- Junction table pattern (M:N relationship)
-- Already demonstrated with order_items, blog_post_tags, library_loans

-- ============================================================
-- Cleanup (optional)
-- ============================================================
-- DROP TABLE IF EXISTS library_books;
-- DROP TABLE IF EXISTS library_members;
-- DROP TABLE IF EXISTS library_loans;
-- DROP TABLE IF EXISTS blog_users;
-- DROP TABLE IF EXISTS blog_posts;
-- DROP TABLE IF EXISTS blog_comments;
-- DROP TABLE IF EXISTS blog_tags;
-- DROP TABLE IF EXISTS blog_post_tags;
-- DROP TABLE IF EXISTS order_statuses;

-- ============================================================
-- Exercises for Lesson 22
-- ============================================================
-- Exercise 1: Draw (describe) an ER diagram for a simple e-commerce database with:
--             customers, products, shopping_cart, cart_items
-- Exercise 2: Create a lookup table for employee job titles with descriptions
-- Exercise 3: Design a M:N relationship between movies and actors (cast_members table)
-- Exercise 4: Create a school database with tables: students, courses, enrollments (with grade)
-- Exercise 5: Add foreign key constraints to the existing employees.department_id column
