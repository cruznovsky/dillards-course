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

-- Which 5 states within the United States have the most Dognition customers, once all dog_guids and user_guids with a value of "1" in their exclude
-- columns are removed? 

select 	distinctUser.state as userState, 
		count(distinct distinctUser.userID) as customers
from complete_tests as c
inner join (select distinct d.dog_guid,
		u.user_guid as userID,
		u.state as state
		from dogs as d
		inner join users as u on d.user_guid = u.user_guid
		where (d.exclude = 0 or d.exclude is null)
			and (u.exclude = 0 or u.exclude is null)
			and u.country = 'US') as distinctUser
	on c.dog_guid = distinctUser.dog_guid
group by userState
order by customers desc
limit 5;
