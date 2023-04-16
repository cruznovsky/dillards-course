-- What department (with department description), brand, style, and color brought in the greatest total amount of sales?  

SELECT  d.dept, 
        d.deptdesc, 
        info.brand, 
        info.style, 
        info.color, 
        sum(t.amt)
FROM deptinfo AS d 
INNER JOIN skuinfo AS info
    ON d.dept = info.dept
INNER JOIN trnsact AS t
    ON info.sku = t.sku
GROUP BY d.dept, d.deptdesc, info.brand, info.style, info.color
ORDER BY sum(t.amt) DESC;

-- How many distinct dates are there in the saledate column of the transaction
-- table for each month/year/store combination in the database? Sort your results by the
-- number of days per combination in ascending order

select 	distinct extract(month from saledate) as month_num,
	extract(year from saledate) as year_num,
	store,
	count(distinct saledate) as days_num
from trnsact
group by year_num, month_num, store
order by days_num;

-- Determine which sku had the greatest total sales during the combined summer months of June, July, and August

select 	sku,
	sum(case when extract(month from saledate) = 6
		then amt
	end) as sum_in_june,
	sum(case when extract(month from saledate) = 7
		then amt
	end) as sum_in_july,
	sum(case when extract(month from saledate) = 8
		then amt
	end) as sum_in_august,
	(sum_in_june +  sum_in_july + sum_in_august) as sum_in_summer
from trnsact
where stype = 'P'
group by sku
order by sum_in_summer desc;

-- What is the average daily revenue for each store/month/year combination in the database? Modify the query you wrote to assess the
-- average daily revenue for each store/month/year combination with a clause that removes all the data from August, 2005. 
-- Excludes all store/month/yearthat have less than 20 days of data in each month

select 	sub.store as store, 
	ub.year_num as year_num, 
	sub.month_num as month_num, 
	sub.avg_revenue as avg_revenue
from (select store,
	extract(year from saledate) as year_num,
	extract(month from saledate) as month_num,
	count(distinct saledate) as num_days,
	sum(amt) / count(distinct saledate) as avg_revenue
	from trnsact
	where stype = 'p'
		and not (month_num = 8 and year_num = 2005)
	group by year_num, month_num, store
	having num_days >= 20
	) as sub
order by year_num, month_num;

-- What is the average daily revenue brought in by Dillard’s stores in areas of high, medium, or low levels of high school education?
-- Define areas of “low” education as those that have high school graduation rates between 50-60%, areas of “medium” education as 
-- those that have high school graduation rates between 60.01-70%, and areas of “high” education as those that have high school graduation rates of
-- above 70%

select 	case when msa.msa_high between 50 and 60 then 'Low'
		when msa.msa_high > 60 and msa.msa_high <= 70 then 'Medium'
		when msa.msa_high > 70 then 'High'
		end as edu_level,
		(sum(sub.sum_amt) / sum(sub.num_days)) as avg_rev
from (
	select 	store,
		extract(year from saledate) as year_num,
		extract(month from saledate) as month_num,
		count(distinct saledate) as num_days,
		sum(amt) as sum_amt
	from trnsact
	where stype = 'p'
		and not (extract(month from saledate) = 8 and extract(year from saledate) = 2005)
	group by year_num, month_num, store
	having num_days >= 20
     ) as sub
inner join store_msa as msa
	on sub.store = msa.store
group by edu_level;

-- Compare the average daily revenues of the stores with the highest median msa_income and the lowest median msa_income.
-- In what city and state were these stores, and which store had a higher average daily revenue? 

select 	city,
	state,
	(sum(sum_amt) / sum(num_days)) as avg_rev
from (
	select 	store,
		extract(year from saledate) as year_num,
		extract(month from saledate) as month_num,
		count(distinct saledate) as num_days,
		sum(amt) as sum_amt
	from trnsact
	where stype = 'p'
		and not (extract(month from saledate) = 8 and extract(year from saledate) = 2005)
	group by year_num, month_num, store
	having num_days >= 20
     ) as sub
inner join store_msa as msa
	on sub.store = msa.store
where msa_income in (
	(select max(msa_income) from store_msa), (select min(msa_income) from store_msa))
group by city, state;

-- What is the brand of the sku with the greatest standard deviation in sprice?
-- Only examine skus that have been part of over 100 transactions.

select s.sku, s.brand, stddev_samp(t.sprice) AS st_dev
from skuinfo AS s
inner join trnsact AS t on s.sku = t.sku
group by s.sku, s.brand
having count(*) > 100 
	and stddev_samp(t.sprice) = (
			select max(st_dev)
			from (
				select stddev_samp(t2.sprice) as st_dev
				from skuinfo as s2
				inner join trnsact  as t2 on s2.sku = t2.sku 
				group by s2.sku, s2.brand
				having count(*) > 100
			      ) as st_devs
				    );

-- What was the average daily revenue Dillard’s brought in during each month of the year? 

select  year_month,  
	sum(sum_amt)/sum(num_days) as avg_revenue
from (
	select 	store, 
		extract(year from saledate)||extract(month from saledate) as year_month,
		count(distinct saledate) as num_days,
		sum(amt) as sum_amt
	from trnsact
	where stype = 'p'
		and not (extract(month from saledate) = 8 and extract(year from saledate) = 2005)
	group by year_month, store
	having num_days >= 20) as sub
group by year_month
order by avg_revenue desc;

-- What vendor has the greatest number of distinct skus in the transaction table that do not exist in the skstinfo table?  

SELECT 	skuinfo.vendor, 
	COUNT(DISTINCT trnsact.SKU) AS distinct_skus_not_in_skstinfo
FROM trnsact
JOIN skuinfo ON trnsact.SKU = skuinfo.SKU
LEFT JOIN skstinfo ON trnsact.SKU = skstinfo.SKU
WHERE skstinfo.SKU IS NULL
GROUP BY skuinfo.vendor
ORDER BY distinct_skus_not_in_skstinfo DESC
LIMIT 1;
