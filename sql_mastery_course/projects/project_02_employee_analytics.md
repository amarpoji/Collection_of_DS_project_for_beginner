# Project 2: Employee Performance & Compensation Analysis

## Scenario

You are an HR analytics specialist at a mid-sized company. The VP of People Operations wants a deep-dive into employee compensation. She needs to understand salary distribution across departments, identify who's above or below their department average, visualize reporting hierarchies, and detect potential pay equity issues.

This is an **intermediate-level** project focusing on window functions, self-joins, and statistical analysis.

## Datasets Used

| Table | Rows | Description |
|-------|------|-------------|
| `employees` | 15 | Employee details (name, job title, salary, department, manager) |
| `departments` | 6 | Department info (name, location, budget) |

## Prerequisites

- Proficiency with JOINs and GROUP BY
- Understanding of window functions (RANK, ROW_NUMBER)
- Familiarity with self-joins
- Basic statistical concepts (average, percentile)

---

## Step-by-Step Tasks

---

### Task 1: Show Employees with Their Department Names

**Objective:** Create a complete employee roster showing each person's department and job title.

**Hint:** LEFT JOIN `employees` to `departments` on `department_id`.

**Query:**
```sql
SELECT
  e.employee_id,
  e.first_name || ' ' || e.last_name AS employee_name,
  e.job_title,
  e.salary,
  d.department_name,
  d.location
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
ORDER BY e.employee_id;
```

**Expected Output (first 8 rows):**

| employee_id | employee_name | job_title | salary | department_name | location |
|-------------|---------------|-----------|--------|-----------------|----------|
| 1 | John Smith | Data Analyst | 75000 | Data & Analytics | New York |
| 2 | Jane Doe | Software Engineer | 95000 | Engineering | San Francisco |
| 3 | Bob Johnson | Data Scientist | 110000 | Data & Analytics | New York |
| 4 | Alice Williams | Product Manager | 105000 | Product | New York |
| 5 | Charlie Brown | Junior Developer | 65000 | Engineering | San Francisco |
| 6 | Diana Prince | Marketing Lead | 85000 | Marketing | Chicago |
| 7 | Edward Norton | Data Engineer | 100000 | Data & Analytics | New York |
| 8 | Fiona Apple | UX Designer | 80000 | Product | New York |

---

### Task 2: Calculate Average Salary by Department

**Objective:** Compare average compensation across departments to identify which teams are paid highest.

**Hint:** Join employees → departments, GROUP BY department.

**Query:**
```sql
SELECT
  d.department_name,
  COUNT(*) AS employee_count,
  ROUND(AVG(e.salary), 2) AS avg_salary,
  ROUND(MIN(e.salary), 2) AS min_salary,
  ROUND(MAX(e.salary), 2) AS max_salary,
  ROUND(MAX(e.salary) - MIN(e.salary), 2) AS salary_range
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_id
ORDER BY avg_salary DESC;
```

**Expected Output:**

| department_name | employee_count | avg_salary | min_salary | max_salary | salary_range |
|----------------|----------------|------------|------------|------------|--------------|
| Engineering | 4 | 113000.00 | 65000 | 200000 | 135000 |
| Sales | 2 | 100000.00 | 70000 | 130000 | 60000 |
| Product | 2 | 92500.00 | 80000 | 105000 | 25000 |
| Data & Analytics | 4 | 85000.00 | 55000 | 110000 | 55000 |
| Human Resources | 1 | 78000.00 | 78000 | 78000 | 0 |
| Marketing | 2 | 72500.00 | 60000 | 85000 | 25000 |

**Business Insight:** Engineering has the highest average salary ($113K) but also the widest range ($135K spread), driven by the CTO's $200K salary. Marketing has the lowest average at $72,500.

---

### Task 3: Find Employees Above Average Salary in Their Department

**Objective:** For each department, identify who earns more than the department average — these are the top performers relative to their peers.

**Hint:** Calculate department averages in a subquery/CTE, then join back.

**Query:**
```sql
WITH dept_avg AS (
  SELECT
    department_id,
    AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department_id
)
SELECT
  e.first_name || ' ' || e.last_name AS employee_name,
  e.job_title,
  e.salary,
  d.department_name,
  ROUND(da.avg_salary, 0) AS dept_average,
  ROUND(e.salary - da.avg_salary, 0) AS above_average_by
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN dept_avg da ON e.department_id = da.department_id
WHERE e.salary > da.avg_salary
ORDER BY d.department_name, e.salary DESC;
```

**Expected Output:**

| employee_name | job_title | salary | department_name | dept_average | above_average_by |
|---------------|-----------|--------|----------------|--------------|-----------------|
| Bob Johnson | Data Scientist | 110000 | Data & Analytics | 85000 | 25000 |
| Edward Norton | Data Engineer | 100000 | Data & Analytics | 85000 | 15000 |
| George Harris | CTO | 200000 | Engineering | 113000 | 87000 |
| Diana Prince | Marketing Lead | 85000 | Marketing | 72500 | 12500 |
| Alice Williams | Product Manager | 105000 | Product | 92500 | 12500 |
| Michael Jordan | Sales Manager | 130000 | Sales | 100000 | 30000 |

---

### Task 4: Show Salary Hierarchy (Who Reports to Whom)

**Objective:** Map the organizational reporting structure showing each employee and their manager.

**Hint:** Self-join `employees` to itself: one side as the employee, the other as the manager.

**Query:**
```sql
SELECT
  e.first_name || ' ' || e.last_name AS employee,
  e.job_title,
  e.salary,
  COALESCE(m.first_name || ' ' || m.last_name, 'CEO / No Manager') AS manager,
  COALESCE(m.job_title, 'N/A') AS manager_title
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.salary DESC;
```

**Expected Output (first 10 rows):**

| employee | job_title | salary | manager | manager_title |
|----------|-----------|--------|---------|---------------|
| George Harris | CTO | 200000 | CEO / No Manager | N/A |
| Michael Jordan | Sales Manager | 130000 | CEO / No Manager | N/A |
| Bob Johnson | Data Scientist | 110000 | John Smith | Data Analyst |
| Alice Williams | Product Manager | 105000 | John Smith | Data Analyst |
| Edward Norton | Data Engineer | 100000 | Bob Johnson | Data Scientist |
| Jane Doe | Software Engineer | 95000 | John Smith | Data Analyst |
| Kevin Bacon | DevOps Engineer | 92000 | Jane Doe | Software Engineer |
| Diana Prince | Marketing Lead | 85000 | John Smith | Data Analyst |
| Fiona Apple | UX Designer | 80000 | Alice Williams | Product Manager |
| Julia Roberts | HR Manager | 78000 | CEO / No Manager | N/A |

**Note:** John Smith (employee_id=1) serves as a central manager figure despite being a Data Analyst. The CEO-level employees (George Harris, Michael Jordan, Julia Roberts, John Smith) have `manager_id = NULL`.

---

### Task 5: Rank Employees by Salary Within Each Department

**Objective:** Use window functions to rank employees from highest to lowest paid within their department.

**Hint:** Use `RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)`.

**Query:**
```sql
SELECT
  d.department_name,
  e.first_name || ' ' || e.last_name AS employee_name,
  e.job_title,
  e.salary,
  RANK() OVER (
    PARTITION BY e.department_id
    ORDER BY e.salary DESC
  ) AS salary_rank
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, salary_rank;
```

**Expected Output:**

| department_name | employee_name | job_title | salary | salary_rank |
|----------------|---------------|-----------|--------|-------------|
| Data & Analytics | Bob Johnson | Data Scientist | 110000 | 1 |
| Data & Analytics | Edward Norton | Data Engineer | 100000 | 2 |
| Data & Analytics | John Smith | Data Analyst | 75000 | 3 |
| Data & Analytics | Ian Clark | Jr Data Analyst | 55000 | 4 |
| Engineering | George Harris | CTO | 200000 | 1 |
| Engineering | Jane Doe | Software Engineer | 95000 | 2 |
| Engineering | Kevin Bacon | DevOps Engineer | 92000 | 3 |
| Engineering | Charlie Brown | Junior Developer | 65000 | 4 |
| Human Resources | Julia Roberts | HR Manager | 78000 | 1 |
| Marketing | Diana Prince | Marketing Lead | 85000 | 1 |
| Marketing | Hannah Martin | Marketing Analyst | 60000 | 2 |
| Product | Alice Williams | Product Manager | 105000 | 1 |
| Product | Fiona Apple | UX Designer | 80000 | 2 |
| Sales | Michael Jordan | Sales Manager | 130000 | 1 |
| Sales | Laura Wilson | Sales Representative | 70000 | 2 |

---

### Task 6: Identify Salary Outliers Using Window Functions

**Objective:** Find employees whose salary is significantly higher or lower than their department peers.

**Hint:** Compare each salary to the department average and standard deviation (approximate by using a threshold like ±30% from average).

**Query:**
```sql
WITH dept_stats AS (
  SELECT
    department_id,
    AVG(salary) AS avg_salary,
    COUNT(*) AS emp_count
  FROM employees
  GROUP BY department_id
)
SELECT
  e.first_name || ' ' || e.last_name AS employee_name,
  e.job_title,
  e.salary,
  d.department_name,
  ROUND(s.avg_salary, 0) AS dept_avg,
  ROUND(e.salary - s.avg_salary, 0) AS difference_from_avg,
  ROUND((e.salary - s.avg_salary) * 100.0 / s.avg_salary, 1) AS pct_above_avg
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN dept_stats s ON e.department_id = s.department_id
WHERE ABS(e.salary - s.avg_salary) > 25000
ORDER BY pct_above_avg DESC;
```

**Expected Output:**

| employee_name | job_title | salary | department_name | dept_avg | diff_from_avg | pct_above_avg |
|---------------|-----------|--------|----------------|----------|---------------|---------------|
| George Harris | CTO | 200000 | Engineering | 113000 | 87000 | 77.0% |
| Michael Jordan | Sales Manager | 130000 | Sales | 100000 | 30000 | 30.0% |
| Bob Johnson | Data Scientist | 110000 | Data & Analytics | 85000 | 25000 | 29.4% |
| Ian Clark | Jr Data Analyst | 55000 | Data & Analytics | 85000 | -30000 | -35.3% |
| Charlie Brown | Junior Developer | 65000 | Engineering | 113000 | -48000 | -42.5% |

**Business Insight:** George Harris (CTO) is a significant outlier at 77% above the Engineering average. Ian Clark and Charlie Brown are outliers on the low end — possible junior/new hire positions. This may warrant a compensation equity review.

---

### Task 7: Calculate Salary Compression Ratios

**Objective:** For each manager, calculate the ratio of their salary to the average salary of their direct reports. A ratio close to 1.0 suggests salary compression.

**Hint:** Self-join employees as managers and their direct reports, then compute the ratio.

**Query:**
```sql
SELECT
  m.first_name || ' ' || m.last_name AS manager_name,
  m.job_title AS manager_title,
  m.salary AS manager_salary,
  COUNT(e.employee_id) AS direct_report_count,
  ROUND(AVG(e.salary), 0) AS avg_report_salary,
  ROUND(m.salary / AVG(e.salary), 2) AS compression_ratio,
  CASE
    WHEN ROUND(m.salary / AVG(e.salary), 2) < 1.1 THEN 'CRITICAL - Compression Risk'
    WHEN ROUND(m.salary / AVG(e.salary), 2) BETWEEN 1.1 AND 1.3 THEN 'Moderate'
    ELSE 'Healthy'
  END AS compression_status
FROM employees m
JOIN employees e ON m.employee_id = e.manager_id
GROUP BY m.employee_id
ORDER BY compression_ratio;
```

**Expected Output:**

| manager_name | manager_title | manager_salary | direct_reports | avg_report_salary | compression_ratio | status |
|--------------|---------------|---------------|-----------------|-------------------|-------------------|--------|
| Jane Doe | Software Engineer | 95000 | 2 | 78500 | 1.21 | Moderate |
| Bob Johnson | Data Scientist | 110000 | 2 | 77500 | 1.42 | Healthy |
| Alice Williams | Product Manager | 105000 | 1 | 80000 | 1.31 | Moderate |
| Diana Prince | Marketing Lead | 85000 | 1 | 60000 | 1.42 | Healthy |
| John Smith | Data Analyst | 75000 | 5 | 97000 | 0.77 | CRITICAL |

**Business Insight:** John Smith (Data Analyst) has a compression ratio of 0.77 — meaning his direct reports earn MORE than he does on average. This is a critical salary compression issue where a manager earns less than their subordinates. Jane Doe also has a moderate compression ratio (1.21), meaning her salary is only 21% higher than her reports, which could be tight.

---

## Bonus Challenge

**Question:** Which departments have the most pay disparity? Use the coefficient of variation (CV = standard deviation / mean) to measure.

```sql
WITH dept_stats AS (
  SELECT
    d.department_name,
    COUNT(*) AS emp_count,
    ROUND(AVG(e.salary), 2) AS mean_salary,
    ROUND(SQRT(AVG(e.salary * e.salary) - AVG(e.salary) * AVG(e.salary)), 2) AS std_dev_salary
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
  GROUP BY d.department_id
  HAVING COUNT(*) > 1
)
SELECT
  department_name,
  emp_count,
  mean_salary,
  std_dev_salary,
  ROUND(std_dev_salary / mean_salary * 100, 2) AS coefficient_of_variation
FROM dept_stats
ORDER BY coefficient_of_variation DESC;
```

## Learning Outcomes

- Writing self-joins for hierarchical data (manager → employee)
- Using window functions: `RANK()` with `PARTITION BY`
- Creating CTEs for intermediate calculations
- Computing statistical metrics (averages, ranges, ratios)
- Identifying outliers and compression risks
- Business interpretation of compensation data
