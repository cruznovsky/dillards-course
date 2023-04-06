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
ORDER BY sum(t.amt) DESC

-- Use a CASE expression and a subquery to determine the number of unique user_guids 
-- who reside in the United States (abbreviated "US") and outside of the US

SELECT CASE cleaned_users.country
            WHEN "US" THEN "In US"
            WHEN "N/A" THEN "Not Applicable"
            ELSE "Outside US"
            END AS US_user, 
      count(cleaned_users.user_guid)   
FROM (SELECT DISTINCT user_guid, country 
      FROM users
      WHERE country IS NOT NULL) AS cleaned_users
GROUP BY US_user
