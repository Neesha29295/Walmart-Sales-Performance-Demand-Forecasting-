Create database if not exists salesDataWalmart;
use salesDataWalmart;
Create table if not exists sales (
	invoice_id varchar(30) Not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float(6,4) not null,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(11,9) ,
    gross_income decimal(12,4) not null,
    rating float(2,1)
    );
    select * from salesDataWalmart.sales;
    
-- ------------------------------------------------------------------------------------------------------------------   
-- ----------------------Feature Engineering-------------------------------------------------------------------------
-- 1. Time of day
	select time,
    (case 
    when time between '00:00:00' and '12:00:00' then "Morning" 
    when time between '12:01:00' and '16:00:00' then "Afternoon"
    else "Evening"
    end
    ) as time_of_day
    from sales;

-- ------------------------------------------------------------------------------------------------------------------	
alter table sales add column time_of_day varchar(20);

update sales set time_of_day = (
case 
    when time between "00:00:00" and "12:00:00" then "Morning" 
    when time between "12:01:00" and "16:00:00" then "Afternoon"
    else "Evening"
    end
    );
-- ---------------------------------------------------------------------------------------------------------------------------------
-- 2. Day_name ------------------------------------------------------------------------------------------------------------------------
 select date, dayname(date) from sales;
 alter table sales add column day_name varchar(10);
 update sales set day_name = dayname(date);
 
-- ---------------------------------------------------------------------------------------------------------------------------------------
-- 3. Month_name -------------------------------------------------------------------------------------------------------------------------
select date, monthname(date) from sales;
alter table sales add column month_name varchar(15);
update sales set month_name = monthname(date);

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------BUSINESS QUESTIONS -------------------------------------------------------------------------
-- Generic Questions ----------------------------------------------------------------------------------------------------------------------
-- 1. How many unique cities does the data have?
	select distinct city from sales;
    
-- 2. In which city is each branch?
	select distinct branch from sales;
    
    select distinct city, branch from sales;
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Product questions ----------------------------------------------------------------------------------------------------------------------
-- 1. How many unique product lines does the data have?
select count(distinct product_line)as unique_prod_line from sales;    

-- 2. What is the most common payment method?
select payment_method,count(payment_method) as cnt from sales group by payment_method order by cnt desc;

-- 3. What is the most selling product line?
select product_line,count(product_line) as cnt from sales group by product_line order by cnt desc;

-- 4. What is the total revenue by month?
select month_name as month,sum(total) as total_revenue from sales group by month_name order by total_revenue desc;

-- 5. What month had the largest COGS?
select month_name as month, sum(cogs) as cogs from sales group by month_name order by cogs desc;

-- 6. What product line had the largest revenue?
select product_line, sum(total) as revenue from sales group by product_line order by revenue desc;

-- 7. What is the city with the largest revenue?
select branch,city, sum(total) as revenue from sales group by branch,city order by revenue desc;

-- 8. What product line had the largest VAT?
select product_line, avg(VAT) as avg_tax from sales group by product_line order by avg_tax desc;
    
-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select avg(quantity) as avg_quantity from sales;
select product_line, 
case 
when avg(quantity) > 6 then "Good"
else "Bad"
end as Remark
from sales group by product_line;

-- 10. Which branch sold more products than average product sold?
select branch, sum(quantity) as quantity from sales group by branch having sum(quantity) > (select avg(quantity) from sales);

-- 11. What is the most common product line by gender?
select gender, product_line, count(gender) as total_cnt from sales group by gender, product_line order by total_cnt desc;

--  12. What is the average rating of each product line?
select round(avg(rating),2) as avg_rating, product_line from sales group by product_line order by avg_rating desc;

-- -------------------------------------------------------------------------------------------------------------------------------------------
-- Sales Questions
-- 1. Number of sales made in each time of the day per weekday
select time_of_day, count(*) as total_sales from sales where day_name ="Monday" group by time_of_day order by total_sales desc;

-- 2. Which of the customer types brings the most revenue?
select customer_type, sum(total) as total_revenue from sales group by customer_type order by total_revenue desc;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
select city, avg(vat) as VAT from sales group by city order by VAT desc;

--  Which customer type pays the most in VAT?
select customer_type, avg(vat) as VAT from sales group by customer_type order by VAT desc;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Customer Questions --------------------------------------------------------------------------------------------------------------------
-- 1. How many unique customer types does the data have?
select distinct(customer_type) from sales;

-- 2. How many unique payment methods does the data have?
select distinct payment_method from sales;

-- 3. What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- 4. Which customer type buys the most?
select customer_type, count(*) as customer_count from sales group by customer_type;

-- 5. What is the gender of most of the customers?
select gender, count(*) as gender_count from sales group by gender order by gender_count;

-- 6. What is the gender distribution per branch?
select gender, count(*) as gender_count from sales where branch ="A" group by gender order by gender_count;

-- 7. Which time of the day do customers give most ratings?
select time_of_day, avg(rating) as avg_Rating from sales group by time_of_day order by avg_Rating desc;

-- 8. Which time of the day do customers give most ratings per branch?
select time_of_day, avg(rating) as avg_Rating from sales where branch ="C" group by time_of_day order by avg_Rating desc;
 
-- 9. Which day fo the week has the best avg ratings?
select day_name, avg(rating) as avg_rating from sales group by day_name order by avg_rating desc ;

-- 10. Which day of the week has the best average ratings per branch?
select day_name, avg(rating) as avg_rating from sales where branch = "A" group by day_name order by avg_rating desc ;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Advance Analysis (Product Analysis)
-- 1. Rank each product line by total revenue.
select product_line, sum(total) as total_revenue, rank() over (order by sum(total) desc) as revenuew_rank
from sales group by product_line;

-- 2. Find month over month revenue growth.
SELECT 
    month_name,
    SUM(total) as total_revenue,
    LAG(SUM(total)) OVER (ORDER BY MIN(date)) as prev_revenue,
    ROUND((SUM(total) - LAG(SUM(total)) OVER (ORDER BY MIN(date))) 
    * 100 / LAG(SUM(total)) OVER (ORDER BY MIN(date)), 2) 
    as growth_pct
FROM sales
GROUP BY month_name;

-- 3. Find top 3 customers by total spending.
select customer_type, gender, sum(total) as total_spending, dense_rank() over (order by sum(total) desc) as spending_rank
from sales group by customer_type,gender;

-- 4. Show running total of revenue
SELECT 
    date,
    SUM(total) as daily_revenue,
    SUM(SUM(total)) OVER (ORDER BY date) as running_total
FROM sales
GROUP BY date
ORDER BY date;
-- 5.Segment customers into High, Mid, Low
WITH customer_spending AS (
    SELECT 
        customer_type,
        SUM(total) as total_spending
    FROM sales
    GROUP BY customer_type
)
SELECT 
    customer_type,
    total_spending,
    CASE
        WHEN total_spending > 3000 THEN 'High'
        WHEN total_spending BETWEEN 1000 AND 3000 THEN 'Mid'
        ELSE 'Low'
    END as customer_segment
FROM customer_spending;