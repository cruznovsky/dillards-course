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

-- Write a query that will output the average number of tests completed by unique dogs in each Dognition personality dimension.
-- Exclude DogIDs with (1) non-NULL empty strings in the dimension column, (2) NULL values in the dimension column, 
-- and (3) values of "1" in the exclude column. Remember that Dognition clarified that both NULL values and 0 values in the "exclude" column are valid data.

SELECT 	NumberTests.dimension AS dogDimension, 
	COUNT(DISTINCT NumberTests.dogID) AS numTests,
	AVG(NumberTests.numbTests) AS avgTests
FROM (SELECT d.dog_guid AS dogID, 
	     d.dimension AS dimension,
	     COUNT(c.created_at) AS numbTests
        FROM dogs AS d
	INNER JOIN complete_tests AS c
                ON d.dog_guid = c.dog_guid
	WHERE (d.dimension <> '' AND d.dimension IS NOT NULL)
	        AND (d.exclude = 0 OR d.exclude IS NULL)
	GROUP BY dogID) AS NumberTests
GROUP BY dogDimension
