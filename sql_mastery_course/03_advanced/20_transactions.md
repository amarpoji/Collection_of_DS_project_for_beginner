# Lesson 20: Transactions

Transactions are the foundation of data integrity in SQL. They group multiple operations into a single atomic unit — either **all** succeed or **none** take effect.

## 1. Basic Transaction Syntax

```sql
BEGIN TRANSACTION;
    -- SQL statements here
COMMIT;            -- Save all changes
-- or
ROLLBACK;          -- Undo all changes
```

```sql
BEGIN TRANSACTION;
INSERT INTO employees (...) VALUES (...);
-- Oops, we made a mistake
ROLLBACK;          -- The insert disappears
```

## 2. ACID Properties

| Property | Meaning | Example |
|----------|---------|---------|
| **A**tomicity | All or nothing | Transfer either fully completes or fully rolls back |
| **C**onsistency | Data remains valid | Total money is preserved ($1500 → $1500) |
| **I**solation | Concurrent transactions don't interfere | Other users don't see partial transfers |
| **D**urability | Committed data survives failures | Once COMMIT returns, data is on disk |

## 3. Practical Example: Money Transfer

```sql
BEGIN TRANSACTION;

-- Step 1: Deduct from Alice
UPDATE accounts SET balance = balance - 200 WHERE account_id = 1;

-- Step 2: Add to Bob
UPDATE accounts SET balance = balance + 200 WHERE account_id = 2;

-- Step 3: Verify (optional)
SELECT * FROM accounts;

-- Only now do we commit
COMMIT;
```

If step 2 fails, step 1 is rolled back — Alice keeps her money. **This is why transactions exist.**

## 4. SAVEPOINTs

SAVEPOINTs allow **partial rollback** within a transaction. They create named checkpoints you can roll back to without aborting the entire transaction.

```sql
BEGIN TRANSACTION;

UPDATE accounts SET balance = balance + 100 WHERE id = 1;
SAVEPOINT after_deposit;

UPDATE accounts SET balance = balance - 300 WHERE id = 1;
UPDATE accounts SET balance = balance + 300 WHERE id = 2;

-- Change of plans: keep the deposit, undo the transfer
ROLLBACK TO after_deposit;

-- Now do a smaller transfer
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

COMMIT;   -- Only the deposit + smaller transfer are committed
```

## 5. Error Handling Patterns

The key pattern: check conditions before committing.

```sql
BEGIN TRANSACTION;
UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 999;  -- doesn't exist!

-- Check: did both updates affect the right rows?
SELECT * FROM accounts;  -- Alice lost $500, Bob got nothing!

-- Disaster! Rollback!
ROLLBACK;
```

**Always verify before committing** in critical operations.

## 6. Isolation Levels (SQLite)

SQLite supports three transaction types:

| Type | Behavior |
|------|----------|
| `DEFERRED` (default) | Locks acquired lazily (on first read/write) |
| `IMMEDIATE` | Locks acquired at BEGIN, blocks other writers |
| `EXCLUSIVE` | Lock at BEGIN, blocks all readers and writers |

```sql
BEGIN IMMEDIATE TRANSACTION;
-- No other connection can write until this commits
```

---

## Exercises

1. **Insert and Rollback**: Create a transaction that inserts a new department, then rolls it back. Verify the department doesn't exist afterward.

2. **Safe Money Transfer**: Create a temp accounts table and perform a transfer. What happens if the source account has insufficient funds? How would you handle this?

3. **SAVEPOINT Practice**: Create a multi-step order process using SAVEPOINTs where you can undo item additions without losing the order header.

4. **Salary Budget Check**: Create a transaction that updates multiple employee salaries and commits only if the total salary budget doesn't exceed a threshold.

5. **Concurrent Access**: (Conceptual) Explain what would happen if two users tried to transfer money from the same account simultaneously without transactions.

---

🔥 **Challenge**: Write a complete order-processing transaction that:
1. Creates a new order
2. Inserts order items
3. Updates product stock quantities
4. Uses SAVEPOINTs so any step can be rolled back independently
5. Verifies stock availability before processing
6. Commits only if everything succeeds
