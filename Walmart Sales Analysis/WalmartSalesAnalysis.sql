use WalmartSales;
select * from Sales;

-- --------------------------------------------------------------------------------------------------------------
-- ------------------------------------------Feature Engineering ------------------------------------------------




-- time_of_day


select time,
case when time between '00:00:00' and '12:00:00' then 'Morning'
 when time between '12:01:00' and '16:00:00' then 'Afternoon'
 else 'Evening'
 end as time_of_day
 from Sales;


 alter table Sales add time_of_day nvarchar(20) ;

 update Sales
 set time_of_day =(case when time between '00:00:00' and '12:00:00' then 'Morning'
 when time between '12:01:00' and '16:00:00' then 'Afternoon'
 else 'Evening'
 end );



 -- day_name


 alter table Sales add day_name nvarchar(20);

 update Sales
 set day_name= datename(weekday,Date);

 


 -- month_name

 
 alter table sales add month_name nvarchar(20);

 update sales
 set month_name= datename(month,date) from sales;

 select * from sales;

 


 -- --------------------------------------------------------------------------------------------------------------------------------------------------
 -- ------------------------------------------------------------Generic-------------------------------------------------------------------------------

 -- How many unique cities does the data have?

 select distinct city from sales;
 select count(distinct city) from sales;



 -- In which city is each branch?


 select distinct branch,city from sales;





 -- ---------------------------------------------------------------------------------------------------------------------------------------------------------
 -- ---------------------------------------------------------- Product --------------------------------------------------------------------------------------


 -- How many unique product lines does the data have?

 select distinct product_line from Sales;

 select count(distinct product_line) from Sales;



 -- What is the most common payment method?

 select top 1 payment from sales group by payment
 order by count(payment) desc
 

 -- What is the most selling product line?


 select product_line,count(quantity) as cnt from sales
 group by product_line
 order by cnt desc;

  select top 1 product_line from sales
 group by product_line
 order by count(quantity) desc;



 --	What is the total revenue by month?

 select month_name,sum(total) total_revenue from sales
 group by month_name;



 -- What month had the largest COGS?

 
 select top 1 month_name,sum(cogs) as cogs_total from sales 
 group by month_name
 order by cogs_total desc;

 
 -- What product line had the largest revenue?


 select  top 1 product_line,sum(total) as total_revenue from sales 
 group by product_line
 order by total_revenue desc;


 -- What is the city with the largest revenue?

 
 select  top 1 city,sum(total) as total_revenue from sales 
 group by city
 order by total_revenue desc;


 -- What product line had the largest VAT?


 select  top 1 product_line,avg(VAT) as total_vat from sales 
 group by product_line
 order by total_vat desc;



-- Fetch each product line and add a column to those product line showing 'Good','Bad'.Good if its geater than average sales


 select  product_line,sum(total) as total_revenue ,
 case when sum(total)>(select avg(total) from sales) then 'Good' else 'Bad'
 end as Category
 from sales 
 group by product_line
 order by total_revenue desc


 -- Which branch sold more products than average products sold?

 select  branch,sum(quantity) as Products_sold 
 from sales 
 group by branch
having sum(quantity)  >(select avg(quantity) from sales)
 order by Products_sold desc



 -- What is the most common product line by gender?


  select 
  distinct product_line,
  sum(case when Gender ='Male' then 1 else 0 end)  over (partition by product_line) as Male_count,
  sum(case when Gender ='Female' then 1 else 0 end ) over (partition by product_line) as Female_count
 from sales
 order by 3 desc;


 -- What is the average rating of each product line?


 select product_line, avg(rating) from sales 
 group by product_line;





 -- -------------------------------------------------------------------------------------------------------------------------------------------------------
 -- --------------------------------------------------Sales -----------------------------------------------------------------------------------------------

 -- No of sales made in each time of the day per weekday




select * from
(select day_name,time_of_day, count(*) cnt

 from sales
 group by day_name,time_of_day) src
pivot
(sum(cnt)
for time_of_day in([Morning],[Afternoon],[Evening]))
piv;




 -- Which of the customer types bring the most revenue?



 select customer_type,sum(total) Total_revenue from sales
 group by customer_type
 order by Total_revenue desc;



 -- Which city had the largest tax percent/VAT?

 select city,avg(vat) as tax_pct from sales
 group by city
 order by tax_pct desc;


 -- Which customer type pays the mostin VAT ?

 select customer_type,avg(vat) as tax_pct from sales
 group by customer_type
 order by tax_pct desc




 -- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- ---------------------------------------------------------Customer ---------------------------------------------------------------------------------------------

 -- What is the gender distribution per branch?

 select distinct branch,
 sum(case when gender='Male' then 1 else 0 end) over(partition by branch ) as Male_count,
 sum(case when gender='Female' then 1 else 0 end) over(partition by branch ) as Female_count
 from sales;
 

 -- Which time of the day do customers give most ratings per branch?

 select branch,time_of_day,avg(rating) avg_rating 
 from sales
 group by branch,time_of_day
 order by avg_rating desc;



 -- Which day of the week has the best average ratings?

 select day_name ,round(avg(rating),2)
 from sales
 group by day_name
 order by 2 desc;