-- COMPARE NAME POPULARITY ACROSS REGIONS

-- QA the data: Select all records from the regions table and find distinct regions to identify any discrepancies.
SELECT * FROM regions;
SELECT DISTINCT Region FROM regions;

-- Merge all 'New England' entries into 'New_England', resolve issues with the MI state, and return the number of births in each region.
WITH clean_regions AS 
(
	SELECT State,
		   CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS clean_region
	FROM regions
	UNION
	SELECT  'MI' AS State, 'Midwest' AS Region
)
SELECT clean_region, SUM(Births) AS num_babies
FROM names n LEFT JOIN clean_regions cr
	ON n.State = cr.State
GROUP BY clean_region;

-- Return the 3 most popular girl names and 3 most popular boy names within each region.
SELECT * FROM
(
	WITH babies_by_region AS 
	(
		-- Clean the regions data by merging 'New England' entries and adding missing 'MI' state.
		WITH clean_regions AS 
		(
			SELECT State,
				   CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS clean_region
			FROM regions
			UNION
			SELECT  'MI' AS State, 'Midwest' AS Region
		)
        -- Calculate the total number of births for each name by region and gender.
		SELECT cr.clean_region, n.Gender, n.Name, SUM(n.Births) AS num_babies
		FROM names n LEFT JOIN clean_regions cr
			ON n.State = cr.State
		GROUP BY cr.clean_region, n.Gender, n.Name
	)
    -- Rank the names by the number of births in descending order and filter to the top 3 for each gender per region.
	SELECT clean_region, Gender, Name,
		ROW_NUMBER() OVER (PARTITION BY clean_region, gender ORDER BY num_babies DESC) AS popularity
	FROM babies_by_region
) AS region_popularity
WHERE popularity < 4;