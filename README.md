# Netflix_project
# Netflix movies and TV shows Data Analysis using SQL

![image](https://github.com/user-attachments/assets/f1f9236d-090c-40b2-bc61-205ed6f1a323)


## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objective
1.Analyze the distribution of content types (movies vs TV shows).

2.Identify the most common ratings for movies and TV shows.

3.List and analyze content based on release years, countries, and durations.

4.Explore and categorize content based on specific criteria and keywords.

## Schema
``` sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
Objective: Determine the distribution of content types on Netflix.

## Business Problems and Solutions

## 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```

## 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```
Objective: Identify the most frequently occurring rating for each type of content.

## 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * FROM netflix
WHERE 
   type = 'Movie'
   AND
   release_year = 2020
```
Objective: Retrieve all movies released in a specific year.

## 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT (show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```
Objective: Identify the top 5 countries with the highest number of content items.

## 5. Identify the Longest Movie or TV show duration

```sql
SELECT * FROM netflix
WHERE 
   type = 'Movie'
   AND
   duration = (SELECT MAX (duration) FROM netflix)
```
Objective: Find the movie with the longest duration.

## 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE 
    TO_DATE(date_added, 'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'
```
Objective: Retrieve content added to Netflix in the last 5 years.


## 7. Find All Movies/TV Shows by Director 'Christopher Nolan'

```sql
SELECT * FROM netflix
WHERE director ILIKE '%Christopher Nolan%'
```
Objective: List all content directed by 'Christopher Nolan'.


## 8. List All TV Shows with More Than 5 Seasons
```sql
SELECT
   *
FROM netflix
WHERE 
    type = 'TV show'
	AND
    SPLIT_PART(duration, ' ', 1)::numeric > 5;
```
Objective: Identify TV shows with more than 5 seasons.


## 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    UNNEST (STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
```
Objective: Count the number of content items in each genre.

## 10.Find each year and the average numbers of content release in India on netflix. Return top 5 year with highest avg content release

```sql
Select 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India') * 100 
	,2)as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1
```
Objective: Calculate and rank years by the average number of content releases by India.

## 11. List All Movies that are Documentaries

```sql
SELECT * FROM netflix
WHERE 
    listed_in ILIKE '%documentaries%'
```
Objective: Retrieve all movies classified as documentaries.


## 12. Find All Content Without a Director

```sql
SELECT * FROM netflix
WHERE 
    director IS NULL
```
Objective: List content that does not have a director.


## 13. Find How Many Movies Actor 'Cillian Murphy' Appeared in the Last 10 Years

```sql
SELECT * FROM netflix
WHERE 
    casts ILIKE '%Cillian Murphy%'
    AND
	release_year > EXTRACT (YEAR FROM CURRENT_DATE) - 10
```
Objective: Count the number of movies featuring 'Cillian Murphy' in the last 10 years.

## 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT
   UNNEST (STRING_TO_ARRAY (casts, ',')) as actors,
   COUNT(*) as total_content
   FROM netflix
   WHERE country ILIKE '%India%'
   GROUP BY 1
   ORDER BY 2 DESC
   LIMIT 10
```
Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.

## 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```
Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.


## Findings and Conclusion
1. Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.

2. Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.

3. Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.

4. Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
















Thank you for your support, and I look forward to connecting with you!
