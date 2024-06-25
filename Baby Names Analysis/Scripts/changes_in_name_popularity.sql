-- TRACK CHANGES IN NAME POPULARITY

-- Find the overall most popular girl's name by summing the number of births and ordering by the total number of births in descending order.
SELECT Name, SUM(Births) AS num_babies
FROM names
WHERE Gender = 'F'
GROUP BY Name
ORDER BY num_babies DESC
LIMIT 1; -- Answer is Jessica

-- Find the overall most popular boy's name by summing the number of births and ordering by the total number of births in descending order.
SELECT Name, SUM(Births) AS num_babies
FROM names
WHERE Gender = 'M'
GROUP BY Name
ORDER BY num_babies DESC
LIMIT 1; -- Answer is Michael

-- Track the popularity change of the name 'Jessica' over time.
-- The subquery calculates the yearly popularity ranking for each girl's name.
-- The outer query filters the results to only include the name 'Jessica'.
SELECT * FROM
(
	WITH girl_names AS 
	(
		SELECT Year, Name, SUM(Births) AS num_babies
		FROM names
		WHERE Gender = 'F'
		GROUP BY Year, Name
	)
    SELECT Year, Name, ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) AS popularity
	FROM girl_names
)
AS popular_girl_names
WHERE Name = 'Jessica';

-- Track the popularity change of the name 'Michael' over time.
-- The subquery calculates the yearly popularity ranking for each boy's name.
-- The outer query filters the results to only include the name 'Michael'.
SELECT * FROM
(
	WITH boy_names AS 
	(
		SELECT Year, Name, SUM(Births) AS num_babies
		FROM names
		WHERE Gender = 'M'
		GROUP BY Year, Name
	)
	SELECT Year, Name, ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) AS popularity
	FROM boy_names
)
AS popular_boy_names
WHERE Name = 'Michael';

-- Find the names with the biggest jumps in popularity from the first year (1980) to the last year (2009) of the data set.
-- Calculate the yearly popularity ranking for each name.
WITH all_names AS 
(
    SELECT Year, Name, SUM(Births) AS num_babies
    FROM names
    GROUP BY Year, Name
),
names_1980 AS
(
    SELECT Year, Name, ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) AS popularity
    FROM all_names
    WHERE Year = 1980
),
names_2009 AS
(
    SELECT Year, Name, ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) AS popularity
    FROM all_names
    WHERE Year = 2009
)
-- Join the data from 1980 and 2009 on the name to find the difference in popularity.
SELECT t1.Year, t1.Name, t1.popularity, t2.Year, t2.Name, t2.popularity, CAST(t2.popularity AS Signed) - CAST(t1.popularity AS Signed) AS diff
FROM names_1980 t1 INNER JOIN names_2009 t2
	ON t1.NAME = t2.NAME
ORDER BY diff; -- Biggest jump in name popularity between 1980 and 2009 is for Colton, Aidan, Rowan, Skylar, and Macy.