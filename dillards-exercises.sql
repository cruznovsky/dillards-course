-- What department (with department description), brand, style, and color brought in the greatest total amount of sales?  

select  d.dept, 
        d.deptdesc, 
        info.brand, 
        info.style, 
        info.color, 
        sum(t.amt)
from deptinfo as d 
inner join skuinfo as info
    on d.dept = info.dept
inner join trnsact as t
    on info.sku = t.sku
group by d.dept, d.deptdesc, info.brand, info.style, info.color
order by sum(t.amt) desc
