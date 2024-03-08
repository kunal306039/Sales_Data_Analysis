/*Inspecting the data*/
select* from db.sales;

/*checking for unique values*/
select distinct year_id from db.sales;
select distinct country from db.sales;
select distinct productline from db.sales;
select distinct dealsize from db.sales;
select distinct status from db.sales;
select distinct teritory from db.sales;

/*Total sales*/
select sum(sales) from db.sales; 
/*Approximate sales is ten million thirty two thousand six hundred and twenty eight*/

/*Total number of orders made*/
select count(distinct ordernumber) as total_orders
from db.sales;      
/*This dataset contains total of 307 separate orders*/

/*Yearly sales vs. number of orders*/
select year(orderdate),month(orderdate),count(distinct ordernumber) as total_orders
from db.sales
group by year(orderdate),month(orderdate)
order by year(orderdate),month(orderdate);

/*Productwise orders*/
select productline,count(*) as items_ordered
from db.sales
group by productline
order by items_ordered desc;
/*Trains are least ordered item and classic cars are most ordered items*/

/*How many orders are made on particular dealsize?*/
select dealsize,count(ordernumber) as no_of_deals_made
from db.sales
group by dealsize;
/*very few large size deals are made as compared to the other two*/

/*find out the second highest orders made by a customer*/
select customername,count(ordernumber) as total_orders
from db.sales
group by customername
order by total_orders desc
limit 1,1;

select city,sum(sales) as total_sales 
from db.sales
where city='Nashua'   /*we can change city name according to our condition*/
order by total_sales desc;
/* Total sales of city 'Nashua' is one lakh thirty one thousand six hundred and eighty five .

/*find the least priced product from sales*/
select productline,min(priceeach) as price
from db.sales
group by productline
order by price;
/*Vintage cars are the least price product*/

/*Quarterly sales distribution*/
select quarter,sum(monthly_sale)as quarterly_sales
from(select month(orderdate) as month_,case when month_id in(1,2,3) then 'first quarter'
when month(orderdate) in(4,5,6) then 'second quarter'
when month(orderdate)in(7,8,9) then 'third quarter'
else 'fourth quarter' end as quarter,
round(sum(sales),2) as monthly_sale
from db.sales)q
where year(orderdate)!=2005
group by month(orderdate),quarter
order by quarterly_sales desc;
/* 4th quarter is most selling quarter while 1st quarter is the least*/

/* countrywise sales*/

select country,round(sum(sales),2) as total_sales
from db.sales
group by country
order by total_sales desc;
/* USA has made highest sales whereas ireland has lowest sales

/* which city has highest number of sales for each country*/

with citywise_sales as(select city,country,round(sum(sales),2) as city_sales
from db.sales
group by city,country),
max as (select country,max(city_sales) as max_sales
from citywise_sales
group by country)
select citywise_sales.country,citywise_sales.city,max.max_sales
from citywise_sales join max
on citywise_sales.city_sales=max.max_sales
order by max.max_sales desc;
/* Madrid of spain has made the maximum sales*/

/* what was the best month for sales in a specific year? how much was earned that month?*/

select month_id,sum(sales) as total_sales,count(ordernumber)
from db.sales
group by month_id
order by total_sales desc;
/*November seems to be the month and around twenty one lakh eighteen thousand earned  that month*/

/* which product is highly sold in november 2005? */
select month_id,productline,count(ordernumber)
from db.sales
where year_id=2004 and month_id=11          /*we can change year and month according to our requirement*/
group by month_id,productline
order by 3 desc
limit 1;
/* classic cars were highly sold in the month of november */

/* find orderdates where total sales is greater than 115000*/
select sum(sales) as total_sales,orderdate
from db.sales
group by orderdate
having total_sales>115000
order by total_sales desc;
















