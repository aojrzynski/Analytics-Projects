-- EXPLORE UNIQUE NAMES

-- Find the 10 most popular androgynous names (names given to both females and males).
-- This query calculates the number of distinct genders for each name.
SELECT Name, COUNT(DISTINCT Gender) AS num_genders, SUM(Births) as num_babies
FROM names
GROUP BY Name
HAVING num_genders = 2
ORDER BY num_babies DESC
LIMIT 10;

-- Find the length of the shortest and longest names. Identify the most popular short names (those with the fewest characters) and long names (those with the most characters).
-- Find the shortest and longest name lengths.
SELECT Name, LENGTH(Name) as name_length
FROM names
ORDER BY name_length; -- Shortest is 2 characters

-- Find the most popular short names (fewest characters).
SELECT Name, LENGTH(Name) as name_length
FROM names
ORDER BY name_length DESC; -- Longest is 15 characters

-- Find the most popular long names (most characters).
WITH short_long_names AS 
(
SELECT * 
FROM names
WHERE LENGTH(Name) IN (2, 15)
)
SELECT Name, SUM(Births) AS num_babies
FROM short_long_names
GROUP BY Name
ORDER BY num_babies DESC;

-- Find the state with the highest percent of Adams’s.
-- Calculate the total births by state and the number of births with the name 'Adam' by state.
SELECT State, num_adam / num_babies * 100 AS pct_adam
FROM
(
	WITH count_adam AS
	(
		SELECT State, SUM(Births) AS num_adam
		FROM names
		WHERE name = 'Adam'
		GROUP BY State
	),
	count_all AS
	(
		SELECT State, SUM(Births) AS num_babies
		FROM names
		GROUP BY State
	)
    -- Calculate the percentage of births with the name 'Adam' in each state.
	SELECT cc.State, cc.num_adam, ca.num_babies
	FROM count_adam cc INNER JOIN count_all ca
	ON cc.State = ca.State
) AS adam_state_all
ORDER BY pct_adam DESC;
