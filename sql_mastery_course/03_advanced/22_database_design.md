# Lesson 22: Database Design Basics

Good database design is the foundation of every well-performing application. A well-designed database is easy to query, maintain, and extend.

## 1. Entity-Relationship (ER) Basics

### Entities and Relationships

| Relationship | Symbol | Example |
|-------------|--------|---------|
| **1:1** (One-to-One) | `---` | Employee ↔ Desk (one desk per employee) |
| **1:M** (One-to-Many) | `---<` | Department → Employees (one dept, many emps) |
| **M:N** (Many-to-Many) | `>---<` | Orders ↔ Products (via order_items junction) |

### Primary Keys (PK)
- Uniquely identifies each row
- Usually an auto-incrementing integer
- Can be composite (multiple columns)

### Foreign Keys (FK)
- References a PK in another table
- Enforces referential integrity
- Creates relationships between tables

## 2. Design Pattern: Library System

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  library_books  │     │  library_loans   │     │ library_members │
├─────────────────┤     ├──────────────────┤     ├─────────────────┤
│ PK book_id      │◄────│ FK book_id       │────►│ PK member_id    │
│ isbn (UNIQUE)   │     │ FK member_id     │     │ first_name      │
│ title           │     │ loan_date        │     │ last_name       │
│ author          │     │ due_date         │     │ email (UNIQUE)  │
│ publisher       │     │ return_date      │     │ phone           │
│ total_copies    │     │ status           │     │ membership_date │
│ available_copies│     └──────────────────┘     │ status          │
└─────────────────┘                              └─────────────────┘
```

The loans table is a **junction table** that resolves the M:N relationship between books and members (a book can be borrowed by many members, a member can borrow many books).

## 3. Design Pattern: Blog Database

```
blog_users ──< blog_posts ──< blog_comments
    │              │
    │              └──>── blog_post_tags ──<── blog_tags
    └───────────────────────────────────────────┘
```

- **1:M**: One user has many posts, one post has many comments
- **M:N**: Posts and Tags (via `blog_post_tags` junction table)
- Composite PK in `blog_post_tags`: `(post_id, tag_id)`

## 4. Database Design Principles

### Normalization (covered in depth in Lesson 23)
- Eliminate data redundancy
- Ensure data integrity
- Break large tables into smaller, related tables

### Naming Conventions
- Use `snake_case` for names
- Tables are plural: `employees`, `orders`
- PK column: `table_name_id` (e.g., `order_id`)
- Junction tables: `table1_table2` (e.g., `order_items`, `post_tags`)

### Foreign Keys
```sql
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### Lookup Tables
Use for statuses, categories, or any field with a fixed set of values.
```sql
CREATE TABLE order_statuses (
    status_code TEXT PRIMARY KEY,
    status_name TEXT NOT NULL,
    description TEXT
);
```

---

## Exercises

1. **E-Commerce ER Diagram**: Describe the tables needed for a simple e-commerce system with customers, products, a shopping cart, and cart items. What are the relationships?

2. **Job Titles Lookup**: Create a lookup table for employee job titles with descriptions.

3. **Movie Cast (M:N)**: Design the tables for a M:N relationship between movies and actors. What columns would the `cast_members` junction table need beyond the two FKs?

4. **School Database**: Design tables for students, courses, and enrollments (with a grade column). What type of relationship is enrollment?

5. **Add Foreign Keys**: Write the SQL to add a foreign key constraint to `employees.department_id` referencing `departments.department_id`.

---

🔥 **Challenge**: Design a complete **Airbnb clone** database with tables for:
- Users (hosts and guests)
- Properties (linked to hosts)
- Bookings (guests booking properties, with check-in/check-out dates)
- Reviews (guests reviewing stays)
- Payments (transaction records)

Include all PKs, FKs, appropriate data types, and at least one junction table. Write the CREATE TABLE statements with proper constraints.
