# Walmart Sales Performance & Demand Forecasting 

## About
This project analyses Walmart's retail sales data across 3 branches to understand top performing product lines, sales trends, customer behaviour, and revenue growth patterns. The goal is to derive actionable business insights that can help optimize sales strategies.

## Dataset
- **Source:** Kaggle — Walmart Sales Forecasting Competition
- **Records:** 1,000 transactions
- **Branches:** 3 (Yangon, Mandalay, Naypyitaw)
- **Period:** January 2019 — March 2019

## Tools Used
- **Database:** MySQL
- **Language:** SQL

## Table Structure

| Column | Description | Data Type |
|---|---|---|
| invoice_id | Unique invoice number | VARCHAR(30) |
| branch | Branch code (A, B, C) | VARCHAR(5) |
| city | Branch location | VARCHAR(30) |
| customer_type | Normal or Member | VARCHAR(30) |
| gender | Customer gender | VARCHAR(10) |
| product_line | Product category | VARCHAR(100) |
| unit_price | Price per product | DECIMAL(10,2) |
| quantity | Units sold | INT |
| VAT | Tax on purchase (5%) | FLOAT |
| total | Total bill amount | DECIMAL(12,4) |
| date | Transaction date | DATETIME |
| time | Transaction time | TIME |
| payment_method | Payment mode | VARCHAR(15) |
| cogs | Cost of goods sold | DECIMAL(10,2) |
| gross_margin_pct | Gross margin % | FLOAT |
| gross_income | Gross profit | DECIMAL(12,4) |
| rating | Customer rating | FLOAT |

---

## Analysis Approach

### 1. Feature Engineering
Created 3 new columns to enrich the analysis:
- **time_of_day** — Morning / Afternoon / Evening (from time column)
- **day_name** — Day of week (Mon–Sun) (from date column)
- **month_name** — Month name (Jan–Mar) (from date column)

### 2. Exploratory Data Analysis (EDA)
Answered 25+ business questions across 4 categories:
- Generic Analysis
- Product Analysis
- Sales Analysis
- Customer Analysis

### 3. Advanced Analysis
Applied window functions and CTEs for deeper insights:
- Revenue ranking using RANK()
- Month over month growth using LAG()
- Customer spending ranking using DENSE_RANK()
- Cumulative revenue using SUM() OVER()
- Customer segmentation using CTE + CASE

---

## Business Questions Answered

### Generic
1. How many unique cities does the data have?
2. In which city is each branch located?

### Product Analysis
1. How many unique product lines exist?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. Which month had the largest COGS?
6. Which product line had the largest revenue?
7. Which city generated the largest revenue?
8. Which product line had the largest VAT?
9. Which product lines are performing Good vs Bad vs average sales?
10. Which branch sold more than average products?
11. Most common product line by gender?
12. Average rating per product line?

### Sales Analysis
1. Number of sales per time of day per weekday
2. Which customer type brings most revenue?
3. Which city has the largest VAT?
4. Which customer type pays most VAT?

### Customer Analysis
1. How many unique customer types exist?
2. How many unique payment methods exist?
3. Most common customer type?
4. Which customer type buys the most?
5. Gender distribution of customers?
6. Gender distribution per branch?
7. Which time of day gets most ratings?
8. Which time of day gets most ratings per branch?
9. Which day of week has best average ratings?
10. Which day of week has best ratings per branch?

---

## Advanced Analysis

### 1. Revenue Ranking (RANK)
Ranked all product lines by total revenue to identify top performers.

### 2. Month over Month Growth (LAG)
Calculated revenue growth percentage between consecutive months.

### 3. Top Customer Segments by Spending (DENSE_RANK)
Ranked customer type + gender combinations by total spending.

### 4. Running Total of Revenue (SUM OVER)
Calculated cumulative revenue day by day to track growth trend.

### 5. Customer Value Segmentation (CTE + CASE)
Segmented customers into High / Mid / Low value based on total spending.

---

## Key Insights

**Insight 1 — Top Product Line:**
> Food and Beverages is the highest revenue generating product line at Walmart.

**Insight 2 — Revenue Trend:**
> February revenue dropped 17.68% compared to January but recovered strongly in March with 13.73% growth — showing a V-shaped revenue recovery pattern.

**Insight 3 — Customer Spending:**
> Female customers are the highest spenders — occupying both Rank 1 and Rank 2 in total spending across all customer segments.

**Insight 4 — Cumulative Revenue:**
> Walmart generated a total cumulative revenue of ₹3,20,886 across all transactions with consistent daily growth.

**Insight 5 — Customer Segmentation:**
> Both Normal and Member customer types fall in the HIGH value segment. Members spend slightly more (₹1,63,625) compared to Normal customers (₹1,57,261) — indicating strong customer loyalty across both segments.

---

## SQL Concepts Used

| Concept | Usage |
|---|---|
| DDL | CREATE DATABASE, CREATE TABLE, ALTER TABLE |
| DML | INSERT, UPDATE |
| Aggregations | SUM, COUNT, AVG, ROUND |
| Filtering | WHERE, HAVING, DISTINCT |
| Grouping | GROUP BY, ORDER BY |
| Joins | Self joins for branch analysis |
| Window Functions | RANK(), DENSE_RANK(), LAG(), SUM() OVER() |
| CTE | WITH clause for customer segmentation |
| CASE | Conditional logic for segmentation |
| Feature Engineering | DAYNAME(), MONTHNAME() |

---

## Files in this Repository

| File | Description |
|---|---|
| Walmart_salesdata.sql | Complete SQL queries file |
| WalmartSalesData.csv | Raw dataset |
| README.md | Project documentation |

---

## Future Enhancements
- Connect to Power BI for interactive dashboard
- Add Python analysis for predictive insights
- Automate data pipeline using stored procedures

---

## Author
**Neesha Pramod**
[LinkedIn](https://linkedin.com/in/neesha-p-231746244/) | [GitHub](https://github.com/Neesha29295/my_projects)
