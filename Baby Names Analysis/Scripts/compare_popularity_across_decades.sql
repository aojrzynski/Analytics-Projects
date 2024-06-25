-- COMPARE NAME POPULARITY ACROSS DECADES

-- For each year, return the 3 most popular girl names and 3 most popular boy names.
-- The subquery calculates the total number of births for each name by year and gender.
-- The outer query ranks the names by the number of births in descending order and filters to the top 3 for each gender per year.
SELECT * FROM
(
	WITH babies_by_year AS
	(
		SELECT Year, Gender, Name, SUM(Births) AS num_babies
		FROM Names
		GROUP BY Year, Gender, Name
	)
	SELECT Year, Gender, Name, num_babies,
		ROW_NUMBER() OVER(PARTITION BY Year, Gender ORDER BY num_babies DESC) AS popularity
	FROM babies_by_year
) AS top_three
WHERE popularity < 4;

-- For each decade, return the 3 most popular girl names and 3 most popular boy names.
-- The subquery categorizes each year into a decade and calculates the total number of births for each name by decade and gender.
-- The outer query ranks the names by the number of births in descending order and filters to the top 3 for each gender per decade.
SELECT * FROM
(
	WITH babies_by_decade AS
	(
		SELECT (CASE WHEN Year BETWEEN 1980 AND 1989 THEN 'Eighties'
					 WHEN Year BETWEEN 1990 AND 1999 THEN 'Nineties'
                     WHEN Year Between 2000 AND 2009 THEN 'Two_Thousands'
					 ELSE 'None' END) AS decade,
        Gender, Name, SUM(Births) AS num_babies
		FROM Names
		GROUP BY decade, Gender, Name
	)
	SELECT decade, Gender, Name, num_babies,
		ROW_NUMBER() OVER(PARTITION BY decade, Gender ORDER BY num_babies DESC) AS popularity
	FROM babies_by_decade
) AS top_three
WHERE popularity < 4;