# Project 4: Airbnb NYC Market Analysis

## Scenario

You're a data analyst at a hospitality consulting firm. A real estate investment group wants to enter the short-term rental market in New York City. They've provided Airbnb listing data across all five boroughs plus Downtown. Your job is to analyze pricing patterns, identify what makes a property successful, segment the market, and predict revenue potential.

This is an **advanced-level** project requiring window functions, CASE segmentation, correlation analysis, and predictive thinking.

## Datasets Used

| Table | Rows | Description |
|-------|------|-------------|
| `airbnb_listings` | 20 | NYC Airbnb properties (price, room type, neighborhood, host info, reviews, bookings) |

## Prerequisites

- Window functions: RANK, NTILE, AVG OVER
- CASE expressions for data bucketing
- Subqueries and CTEs
- Understanding of business metrics (occupancy, revenue potential)

---

## Step-by-Step Tasks

---

### Task 1: Average Price by Neighbourhood and Room Type

**Objective:** Understand the pricing landscape across NYC neighborhoods and property types.

**Hint:** Two-level GROUP BY on neighbourhood and room_type.

**Query:**
```sql
SELECT
  neighbourhood,
  room_type,
  COUNT(*) AS listing_count,
  ROUND(AVG(price), 2) AS avg_price,
  MIN(price) AS min_price,
  MAX(price) AS max_price,
  ROUND(AVG(rating), 2) AS avg_rating,
  ROUND(AVG(nights_booked), 1) AS avg_nights_booked
FROM airbnb_listings
GROUP BY neighbourhood, room_type
ORDER BY neighbourhood, avg_price DESC;
```

**Expected Output:**

| neighbourhood | room_type | listings | avg_price | min_price | max_price | avg_rating | avg_nights |
|---------------|-----------|----------|-----------|-----------|-----------|------------|------------|
| Bronx | Entire home/apt | 1 | 130.00 | 130 | 130 | 4.20 | 85.0 |
| Brooklyn | Entire home/apt | 4 | 182.50 | 140 | 220 | 4.50 | 111.3 |
| Brooklyn | Private room | 2 | 77.50 | 70 | 85 | 4.55 | 235.0 |
| Downtown | Entire home/apt | 1 | 120.00 | 120 | 120 | 4.80 | 180.0 |
| Manhattan | Entire home/apt | 6 | 341.67 | 190 | 600 | 4.85 | 100.8 |
| Manhattan | Private room | 1 | 95.00 | 95 | 95 | 4.60 | 190.0 |
| Queens | Entire home/apt | 2 | 95.00 | 90 | 100 | 4.60 | 205.0 |
| Queens | Private room | 1 | 55.00 | 55 | 55 | 4.30 | 300.0 |
| Staten Island | Entire home/apt | 2 | 135.00 | 110 | 160 | 4.45 | 127.5 |

**Business Insight:** Manhattan commands the highest average prices at $341.67 for entire home/apt — nearly 2x Brooklyn's average. Private rooms are significantly cheaper and tend to have higher booking volumes (more nights booked), suggesting they serve budget-conscious travelers.

---

### Task 2: Superhost Analysis — Do They Charge More, Have Higher Occupancy?

**Objective:** Compare superhosts vs. regular hosts across key metrics to quantify the "superhost premium."

**Query:**
```sql
SELECT
  CASE WHEN superhost = 1 THEN 'Superhost' ELSE 'Regular Host' END AS host_type,
  COUNT(*) AS listing_count,
  ROUND(AVG(price), 2) AS avg_price,
  ROUND(AVG(nights_booked), 1) AS avg_nights_booked,
  ROUND(AVG(rating), 2) AS avg_rating,
  ROUND(AVG(reviews), 1) AS avg_reviews,
  ROUND(AVG(bedrooms), 1) AS avg_bedrooms,
  ROUND(AVG(price * nights_booked), 0) AS avg_estimated_revenue
FROM airbnb_listings
GROUP BY superhost;
```

**Expected Output:**

| host_type | listings | avg_price | avg_nights | avg_rating | avg_reviews | avg_bedrooms | avg_estimated_revenue |
|-----------|----------|-----------|------------|------------|-------------|--------------|----------------------|
| Regular Host | 11 | 119.55 | 169.5 | 4.45 | 44.1 | 1.5 | 19,699 |
| Superhost | 9 | 275.56 | 119.4 | 4.81 | 27.1 | 1.8 | 31,184 |

**Business Insight:** Superhosts charge 2.3x more per night on average ($275.56 vs $119.55), have 0.36 points higher ratings (4.81 vs 4.45), and generate 58% more estimated revenue ($31.2K vs $19.7K). However, they have fewer nights booked (119 vs 170), likely because higher prices reduce booking volume but increase per-night profitability. This supports the "premium strategy" for Airbnb investing.

---

### Task 3: Property Performance Ranking Using Window Functions

**Objective:** Rank properties within each neighbourhood by a performance score (price × nights booked = estimated revenue).

**Query:**
```sql
SELECT
  neighbourhood,
  property_name,
  room_type,
  price,
  nights_booked,
  ROUND(price * nights_booked, 0) AS estimated_revenue,
  RANK() OVER (
    PARTITION BY neighbourhood
    ORDER BY price * nights_booked DESC
  ) AS revenue_rank
FROM airbnb_listings
ORDER BY neighbourhood, revenue_rank;
```

**Expected Output (first 15 rows):**

| neighbourhood | property_name | room_type | price | nights | est_revenue | rank |
|---------------|---------------|-----------|-------|--------|-------------|------|
| Bronx | Spacious Family Apt | Entire home/apt | 130 | 85 | 11050 | 1 |
| Brooklyn | Charming Brownstone | Entire home/apt | 175 | 130 | 22750 | 1 |
| Brooklyn | Suburban Comfort | Entire home/apt | 140 | 140 | 19600 | 2 |
| Brooklyn | Sunny Loft Space | Private room | 85 | 220 | 18700 | 3 |
| Brooklyn | Artsy Loft Williamsburg | Entire home/apt | 195 | 95 | 18525 | 4 |
| Brooklyn | Eco-Friendly Loft | Entire home/apt | 220 | 80 | 17600 | 5 |
| Brooklyn | Hipster Hideaway | Private room | 70 | 250 | 17500 | 6 |
| Downtown | Cozy Studio Apt | Entire home/apt | 120 | 180 | 21600 | 1 |
| Manhattan | City View Penthouse | Entire home/apt | 450 | 90 | 40500 | 1 |
| Manhattan | The Penthouse Suite | Entire home/apt | 600 | 60 | 36000 | 2 |
| Manhattan | Luxury Condo Midtown | Entire home/apt | 320 | 110 | 35200 | 3 |
| Manhattan | Modern Riverside Apt | Entire home/apt | 210 | 150 | 31500 | 4 |
| Manhattan | Designer Studio Soho | Entire home/apt | 190 | 120 | 22800 | 5 |
| Manhattan | Minimalist City Pad | Entire home/apt | 280 | 75 | 21000 | 6 |
| Manhattan | Petite Room Near Park | Private room | 95 | 190 | 18050 | 7 |

**Business Insight:** In Manhattan, high-price-low-volume properties (City View Penthouse at $450/night, 90 nights) outrank high-volume-low-price ones (Petite Room at $95/night, 190 nights). But in Brooklyn, medium-priced properties with high booking volumes dominate the rankings, showing different optimal strategies per neighborhood.

---

### Task 4: Price Segmentation Analysis (CASE WHEN Buckets)

**Objective:** Segment listings into Budget, Mid, Premium, and Luxury tiers to understand market composition.

**Hint:** Use `CASE WHEN` to create price buckets: <$100 (Budget), $100-199 (Mid), $200-399 (Premium), $400+ (Luxury).

**Query:**
```sql
SELECT
  CASE
    WHEN price < 100 THEN 'Budget (< $100)'
    WHEN price BETWEEN 100 AND 199 THEN 'Mid ($100-$199)'
    WHEN price BETWEEN 200 AND 399 THEN 'Premium ($200-$399)'
    ELSE 'Luxury ($400+)'
  END AS price_segment,
  COUNT(*) AS listing_count,
  ROUND(AVG(price), 2) AS avg_price,
  ROUND(AVG(nights_booked), 1) AS avg_nights_booked,
  ROUND(AVG(rating), 2) AS avg_rating,
  ROUND(AVG(reviews), 1) AS avg_reviews,
  ROUND(AVG(price * nights_booked), 0) AS avg_estimated_revenue
FROM airbnb_listings
GROUP BY price_segment
ORDER BY avg_price;
```

**Expected Output:**

| price_segment | listings | avg_price | avg_nights | avg_rating | avg_reviews | avg_est_revenue |
|---------------|----------|-----------|------------|------------|-------------|-----------------|
| Budget (< $100) | 5 | 79.00 | 234.0 | 4.54 | 66.8 | 17,702 |
| Mid ($100-$199) | 9 | 146.67 | 133.9 | 4.50 | 34.3 | 19,505 |
| Premium ($200-$399) | 4 | 257.50 | 103.8 | 4.83 | 21.8 | 26,435 |
| Luxury ($400+) | 2 | 525.00 | 75.0 | 4.85 | 12.5 | 38,250 |

**Business Insight:** The market is concentrated in the Mid segment (9 listings). However, Premium and Luxury segments generate higher estimated revenue despite fewer bookings. Luxury properties have an 82% higher average estimated revenue than Budget properties ($38,250 vs $17,702). Budget properties have the highest booking volume (234 nights) but lowest revenue, suggesting a "volume vs. value" trade-off.

---

### Task 5: Revenue Potential Prediction Based on Nights Booked

**Objective:** Calculate estimated annual revenue for each property and compare to the neighborhood average.

**Hint:** Compute `price * nights_booked` as estimated revenue and use `AVG() OVER (PARTITION BY neighbourhood)` for the neighborhood benchmark.

**Query:**
```sql
SELECT
  property_name,
  neighbourhood,
  room_type,
  price,
  nights_booked,
  ROUND(price * nights_booked, 0) AS estimated_annual_revenue,
  ROUND(AVG(price * nights_booked) OVER (PARTITION BY neighbourhood), 0) AS neighbourhood_avg_revenue,
  ROUND(price * nights_booked - AVG(price * nights_booked) OVER (PARTITION BY neighbourhood), 0) AS above_neighbourhood_avg,
  ROUND((price * nights_booked) * 100.0 / AVG(price * nights_booked) OVER (PARTITION BY neighbourhood), 1) AS pct_of_neighbourhood_avg
FROM airbnb_listings
ORDER BY estimated_annual_revenue DESC
LIMIT 15;
```

**Expected Output:**

| property_name | neighbourhood | room_type | price | nights | est_revenue | neighbourhood_avg | above_avg | pct_of_avg |
|---------------|---------------|-----------|-------|--------|-------------|-------------------|-----------|------------|
| City View Penthouse | Manhattan | Entire home/apt | 450 | 90 | 40500 | 29364 | 11136 | 137.9% |
| The Penthouse Suite | Manhattan | Entire home/apt | 600 | 60 | 36000 | 29364 | 6636 | 122.6% |
| Luxury Condo Midtown | Manhattan | Entire home/apt | 320 | 110 | 35200 | 29364 | 5836 | 119.9% |
| Modern Riverside Apt | Manhattan | Entire home/apt | 210 | 150 | 31500 | 29364 | 2136 | 107.3% |
| Designer Studio Soho | Manhattan | Entire home/apt | 190 | 120 | 22800 | 29364 | -6564 | 77.6% |
| Charming Brownstone | Brooklyn | Entire home/apt | 175 | 130 | 22750 | 19013 | 3737 | 119.7% |
| Cozy Studio Apt | Downtown | Entire home/apt | 120 | 180 | 21600 | 21600 | 0 | 100.0% |
| Minimalist City Pad | Manhattan | Entire home/apt | 280 | 75 | 21000 | 29364 | -8364 | 71.5% |
| Cozy Queens Retreat | Queens | Entire home/apt | 100 | 200 | 20000 | 17833 | 2167 | 112.2% |
| Suburban Comfort | Brooklyn | Entire home/apt | 140 | 140 | 19600 | 19013 | 587 | 103.1% |

**Business Insight:** The top earners are Manhattan luxury properties. City View Penthouse generates $40,500 estimated annual revenue — 38% above the Manhattan average. However, properties like Designer Studio Soho and Minimalist City Pad underperform their neighborhood average, suggesting they may be overpriced or need better marketing.

---

### Task 6: Neighbourhood Price vs Rating Correlation

**Objective:** Analyze whether higher-priced neighborhoods also have higher ratings, and identify the best-value neighborhoods.

**Query:**
```sql
SELECT
  neighbourhood,
  COUNT(*) AS listing_count,
  ROUND(AVG(price), 2) AS avg_price,
  ROUND(AVG(rating), 2) AS avg_rating,
  ROUND(AVG(nights_booked), 1) AS avg_nights_booked,
  ROUND(AVG(reviews), 1) AS avg_reviews,
  ROUND(AVG(price * nights_booked), 0) AS avg_estimated_revenue,
  ROUND(AVG(price) / AVG(rating), 2) AS price_per_rating_point
FROM airbnb_listings
GROUP BY neighbourhood
ORDER BY avg_price DESC;
```

**Expected Output:**

| neighbourhood | listings | avg_price | avg_rating | avg_nights | avg_reviews | avg_est_revenue | price_per_rating_pt |
|---------------|----------|-----------|------------|------------|-------------|-----------------|---------------------|
| Manhattan | 7 | 306.43 | 4.81 | 113.6 | 27.1 | 29,364 | 63.70 |
| Brooklyn | 6 | 147.50 | 4.52 | 152.5 | 44.2 | 19,013 | 32.66 |
| Staten Island | 2 | 135.00 | 4.45 | 127.5 | 31.0 | 16,700 | 30.34 |
| Bronx | 1 | 130.00 | 4.20 | 85.0 | 18.0 | 11,050 | 30.95 |
| Downtown | 1 | 120.00 | 4.80 | 180.0 | 45.0 | 21,600 | 25.00 |
| Queens | 3 | 81.67 | 4.50 | 236.7 | 65.7 | 17,833 | 18.15 |

**Business Insight:** There is NOT a perfect correlation between price and rating. Downtown has a moderate price ($120) but the second-highest rating (4.80), making it the best value (lowest price-per-rating-point at $25.00). Queens offers the lowest average price ($81.67) with a respectable rating (4.50) and the highest booking volume (236.7 nights). Manhattan commands premium prices but has the worst price-per-rating-point ($63.70), suggesting diminishing returns on pricing.

---

## Bonus Challenge

**Question:** Which properties are "underpriced" — meaning they have high ratings but below-average prices in their neighborhood?

```sql
WITH neighbourhood_stats AS (
  SELECT
    neighbourhood,
    AVG(price) AS avg_neighbourhood_price,
    AVG(rating) AS avg_neighbourhood_rating
  FROM airbnb_listings
  GROUP BY neighbourhood
)
SELECT
  al.property_name,
  al.neighbourhood,
  al.room_type,
  al.price,
  ROUND(ns.avg_neighbourhood_price, 2) AS neighbourhood_avg_price,
  al.rating,
  ROUND(ns.avg_neighbourhood_rating, 2) AS neighbourhood_avg_rating,
  ROUND(ns.avg_neighbourhood_price - al.price, 2) AS price_discount_vs_avg,
  ROUND(al.price * al.nights_booked, 0) AS estimated_revenue
FROM airbnb_listings al
JOIN neighbourhood_stats ns ON al.neighbourhood = ns.neighbourhood
WHERE al.rating > ns.avg_neighbourhood_rating
  AND al.price < ns.avg_neighbourhood_price
ORDER BY price_discount_vs_avg DESC;
```

## Learning Outcomes

- Advanced GROUP BY with multi-level segmentation
- Window functions for ranking within partitions
- CASE-based data bucketing for segmentation
- Financial modeling: estimated revenue calculations
- Comparative analytics: superhost vs regular, neighborhood benchmarks
- Price-to-quality ratio analysis
- Identifying investment opportunities through data
