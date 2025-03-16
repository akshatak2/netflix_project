-- Netflix Project


DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix 
(

show_id VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)

);


SELECT * FROM netflix;



SELECT 
    COUNT(*) as total_content
FROM netflix;


SELECT 
   DISTINCT type
FROM netflix;



-- 15 business problems
-- 1. Count the number of movies vs TV shows

SELECT type,
  COUNT (*) as total_content
FROM netflix
GROUP BY type

--2. Find the most common rating for movies and TV shows
SELECT 
   type, 
   rating
FROM

(SELECT 
  type,
  rating,
  COUNT (*),
  RANK() OVER(PARTITION BY type ORDER BY COUNT (*) DESC) as ranking
FROM netflix
GROUP BY 1, 2) as t1 
WHERE ranking = 1



--3. List all movies released in a specific year (eg. 2020)

SELECT * FROM netflix
WHERE 
   type = 'Movie'
   AND
   release_year = 2020


--4. Find the top 5 countries with the most content on netflix

SELECT 
    UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT (show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
    

--5. Identify the longest movie or TV show duration

SELECT * FROM netflix
WHERE 
   type = 'Movie'
   AND
   duration = (SELECT MAX (duration) FROM netflix)


--6. Find content added in the last 5 years 

SELECT *
FROM netflix
WHERE 
    TO_DATE(date_added, 'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'


--7. Find all the movie/ Tv shows by director 'Christopher Nolan'

SELECT * FROM netflix
WHERE director ILIKE '%Christopher Nolan%'


--8. List all Tv shows with more than 5 seasons

SELECT
   *
FROM netflix
WHERE 
    type = 'TV show'
	AND
    SPLIT_PART(duration, ' ', 1)::numeric > 5;


--9. Count the nuumber of content items in each genre
  
SELECT 
    UNNEST (STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1


--10. Find each year and the average numbers of content release by Indiaon netflix. 
      return top 5 year with higest avg content release
total content 333/972
Select 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India') * 100 
	,2)as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1


--11. List all movies that are documentaries

SELECT * FROM netflix
WHERE 
    listed_in ILIKE '%documentaries%'

--12. Find all content without a director
 
SELECT * FROM netflix
WHERE 
    director IS NULL

--13. Find how many movies actor 'Cillian Murphy' appeared in last 10 years

SELECT * FROM netflix
WHERE 
    casts ILIKE '%Cillian Murphy%'
    AND
	release_year > EXTRACT (YEAR FROM CURRENT_DATE) - 10
	
--14. Find the top 10 actors who have appeared in the highest number of movies produced in India
   SELECT
   --show_id,
   --casts,
   UNNEST (STRING_TO_ARRAY (casts, ',')) as actors,
   COUNT(*) as total_content
   FROM netflix
   WHERE country ILIKE '%India%'
   GROUP BY 1
   ORDER BY 2 DESC
   LIMIT 10



--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
      the description field . Label content containing these keywords as 'Bad' and all other content as 'Good'.
	  Count how many items fall into each category.


 WITH new_table
 AS
 (
 SELECT 
 *, 
    CASE
	WHEN 
	   description ILIKE '%kill%' OR 
	   description ILIKE '%violence%' THEN 'Bad_Content'
	   ELSE 'Good_Content'
    END category
 FROM netflix
 )
SELECT 
    category,
	COUNT(*) as total_content
FROM new_table
GROUP BY 1












	  