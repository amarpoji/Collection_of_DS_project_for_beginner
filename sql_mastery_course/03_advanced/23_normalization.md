# Lesson 23: Normalization

Normalization is the process of organizing data to reduce redundancy and improve integrity. It's done in progressive "normal forms" — each form is stricter than the last.

## The Denormalized Anti-Pattern

```sql
-- ❌ BAD: Everything in one table with comma-separated values
CREATE TABLE denormalized_sales (
    order_id INTEGER,
    customer_name TEXT,
    customer_email TEXT,
    product_ids TEXT,      -- "1,14,18"
    product_names TEXT,    -- "Wireless Mouse, Notebook Set, Desk Lamp"
    quantities TEXT,       -- "2,3,5"
    prices TEXT,           -- "25.99,12.50,9.99"
    total_amount REAL,
    payment_method TEXT
);
```

**Problems**: Can't enforce data types, can't query individual products, redundant customer data.

## 1NF: First Normal Form

**Rules:**
1. Each column contains atomic (indivisible) values
2. All values in a column are the same type
3. Each row is unique (has a primary key)
4. No repeating groups

**Fix**: "Explode" multi-valued columns into separate rows.

```sql
CREATE TABLE sales_1nf (
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price REAL,
    -- ...other columns...
    PRIMARY KEY (order_id, product_id)
);
```

Now each row has one order + one product. But we still have redundancy: customer name repeats for every product in the order.

## 2NF: Second Normal Form

**Rules (in addition to 1NF):**
1. Must be in 1NF
2. **No partial dependencies**: every non-key column must depend on the **entire** primary key

In `sales_1nf`, the PK is `(order_id, product_id)`. But:
- `customer_name` depends only on `order_id` → **partial dependency** ❌
- `product_name` depends only on `product_id` → **partial dependency** ❌

**Fix**: Split into three tables.

```
orders(order_id, order_date, total_amount, ...)
  ↳ depends on order_id only ✓

products(product_id, product_name)
  ↳ depends on product_id only ✓

order_items(order_id, product_id, quantity, unit_price)
  ↳ depends on (order_id, product_id) together ✓
```

## 3NF: Third Normal Form

**Rules (in addition to 2NF):**
1. Must be in 2NF
2. **No transitive dependencies**: non-key columns must depend ONLY on the PK, not on other non-key columns

In `orders_2nf`, if we store `customer_name` directly in the orders table, it depends on `customer_id` (a non-key concept), not on `order_id`. That's a **transitive dependency**.

**Fix**: Extract customer info into its own table.

```
customers(customer_id, first_name, last_name, email, city, state)
orders(order_id, customer_id, order_date, total_amount, ...)
  ↳ customer_id is a FK, not a transitive dependency ✓
```

## BCNF and Beyond

| Normal Form | Rule | Practical |
|-------------|------|-----------|
| **BCNF** | Every determinant is a candidate key | Rarely needed |
| **4NF** | No multi-valued dependencies | Very rare |
| **5NF** | Decomposition must be lossless | Academic |

For 99% of real-world databases, **3NF is sufficient.**

## When to Denormalize

**Denormalize when** (and only when):
- You have measured a real performance bottleneck
- The data is read-heavy and write-light
- You're building a reporting/data warehouse system
- The JOIN cost exceeds the storage/consistency cost

**Be aware**: Denormalization introduces update anomalies. If a customer's email changes, you now need to update it in multiple places.

---

## Exercises

1. **Identify Violations**: What normal form does this violate?
   `student_courses(student_id, student_name, course_ids_csv)` where `course_ids_csv = "101,102,103"`

2. **Normalize to 2NF**: Normalize `order_summary(order_id, product_id, product_name, qty, price, customer_name)` to 2NF.

3. **Find Transitive Dependency**: What's the transitive dependency in `employees(emp_id, dept_id, dept_name, salary)`?

4. **Normalize to 3NF**: Take `project_assignments(emp_id, emp_name, project_id, project_name, hours)` through to 3NF.

5. **When to Denormalize**: Give a real-world scenario where denormalization is the right choice.

---

🔥 **Challenge**: You're given this denormalized table from a legacy system:
```sql
invoices(invoice_id, customer_name, customer_address,
         item_list, qty_list, price_list, total)
```
Where `item_list = "Widget,Gadget,Doohickey"`, `qty_list = "2,1,3"`, `price_list = "10.00,25.00,5.00"`.

Write the SQL to:
1. Parse the comma-separated values into atomic rows
2. Create the 1NF version
3. Extract to 2NF (separate invoices, products, invoice_items)
4. Extract to 3NF (separate customers table)
5. Write a query that reconstructs the original view from the normalized schema
