# Project Solutions — Complete Answers

This file contains solutions to all 5 projects and the executive capstone.

---

# Project 1: E-commerce Sales Analysis

Solutions are provided inline within the project file at `projects/project_01_ecommerce_analysis.md`. The file already contains the SQL queries, expected outputs, and business insights for all 7 tasks plus the bonus challenge.

Key solutions summary:

**Task 1:** Join orders + customers for order ledger.
**Task 2:** GROUP BY status — 32 Delivered ($6,599.19), 9 Shipped, 5 Pending, 4 Cancelled.
**Task 3:** Top spender: Benjamin Thomas ($1,190.00 from Dallas, TX).
**Task 4:** Overall AOV = $191.37, total revenue = $9,568.66.
**Task 5:** Monthly trend — revenue ranges $1,112.50 (May) to $2,517.23 (April).
**Task 6:** Best-selling by quantity: Cable Organizer (47 units); by revenue: Standing Desk ($4,803.75).
**Task 7:** 55% repeat customers, 45% VIPs (3+ orders), no one-time buyers.
**Bonus:** Highest AOV customers with category preferences.

---

# Project 2: Employee Performance & Compensation Analysis

Solutions are provided inline within the project file at `projects/project_02_employee_analytics.md`. The file contains solutions for all 7 tasks plus bonus.

Key solutions summary:

**Task 1:** Employee roster with department names (self-join).
**Task 2:** Engineering highest avg salary ($113K), Marketing lowest ($72.5K).
**Task 3:** 6 employees above department average (CTE + JOIN).
**Task 4:** Org hierarchy — John Smith manages 5 people despite being a Data Analyst.
**Task 5:** Salary ranking within departments using RANK() OVER (PARTITION BY).
**Task 6:** George Harris (CTO) is 77% above Engineering average; Ian Clark is 35% below.
**Task 7:** John Smith has critical salary compression (ratio 0.77 — reports earn more than manager).
**Bonus:** Coefficient of variation — Engineering has highest pay disparity.

---

# Project 3: Movie Database Insights

Solutions are provided inline within the project file at `projects/project_03_movie_insights.md`. The file covers all 8 tasks plus bonus.

Key solutions summary:

**Task 1:** Top-rated per genre (ROW_NUMBER + PARTITION BY genre).
**Task 2:** Horror has highest avg ROI (37x), Action leads in total profit ($4.3B).
**Task 3:** YoY trends with LAG — 1994 was a golden year (avg rating 8.88).
**Task 4:** Christopher Nolan most valuable director ($2.3B total profit, 5 movies).
**Task 5:** Longer movies (160+ min) have highest avg rating (8.53).
**Task 6:** Warner Bros leads total profit ($3.7B); Universal best ROI (19.6x).
**Task 7:** Best investment: Whisper of the Heart (79x ROI); Worst: Soul (loss).
**Task 8:** 1970s highest avg rating (9.2); 2020s lowest (7.78) with highest budgets.
**Bonus:** Directors with most consistent track records (lowest rating variance).

---

# Project 4: Airbnb NYC Market Analysis

Solutions are provided inline within the project file at `projects/project_04_airbnb_market.md`. The file covers all 6 tasks plus bonus.

Key solutions summary:

**Task 1:** Avg price by neighbourhood/room type — Manhattan highest ($341.67 entire home).
**Task 2:** Superhosts charge 2.3x more ($275.56 vs $119.55), earn 58% more revenue.
**Task 3:** Revenue ranking within neighbourhoods using RANK() OVER (PARTITION BY).
**Task 4:** Price segmentation — Luxury ($400+) earns $38,250 avg revenue vs Budget $17,702.
**Task 5:** Revenue prediction — City View Penthouse ($40,500) tops Manhattan.
**Task 6:** Best value: Downtown ($25/rating-point); Worst value: Manhattan ($63.70/rating-point).
**Bonus:** Underpriced properties with high ratings but below-average prices.

---

# Project 5: Customer 360 Analysis

Solutions are provided inline within the project file at `projects/project_05_customer_360.md`. The file covers all 7 tasks plus bonus.

Key solutions summary:

**Task 1:** CLV calculation — Benjamin Thomas highest ($1,190).
**Task 2:** Purchase frequency — Mike Chen orders most frequently (0.86/month).
**Task 3:** Regional preferences — TX favors Furniture/Electronics, CA diverse.
**Task 4:** Churn risk — All customers at "Medium Risk" (30-90 days since last order).
**Task 5:** Cohort analysis — April 2023 cohort strongest ($959.88 per customer).
**Task 6:** RFM segmentation — Champions: Benjamin Thomas, Isabella Lee, Sarah Johnson.
**Task 7:** Market basket — Notebook Set + Cable Organizer most common pair (22% support).
**Bonus:** Personalized cross-sell recommendations.

---

# Capstone: Executive Dashboard

See `projects/capstone_executive_dashboard.md` for the complete capstone project with all 12 questions, SQL queries, outputs, and business insights.

---

## How to Verify Solutions

For each solution:
1. Open the database: `sqlite3 sql_mastery.db`
2. Copy-paste the SQL query
3. Compare output with expected output shown
4. Read the business insight to understand the "so what"

All queries have been tested against the actual database. If a query produces different output, ensure you're querying the correct database file.
