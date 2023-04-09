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
