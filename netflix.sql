-------------------------CREATE TABLE---------------------------
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix(
show_id VARCHAR(5),
type VARCHAR(10),
title VARCHAR(250),
director VARCHAR(550),
cast_name VARCHAR(1050),
country	VARCHAR(550),
date_added VARCHAR(55),
release_year INT,
rating	VARCHAR(15),
duration VARCHAR(15),
listed_in VARCHAR(250),
description VARCHAR(550)
);
SELECT * FROM netflix;
-------------------------BUSINESS QUESTIONS---------------------------
--1. Count the number of Movies vs TV Shows
SELECT type, COUNT(*)
FROM netflix
GROUP BY type;

--2. Find the most common rating for movies and TV shows
SELECT rating, COUNT(*)
FROM netflix
GROUP BY rating
ORDER BY COUNT(*) DESC;

--3. List all movies released in a specific year (e.g., 2020)
SELECT release_year, title
FROM netflix
WHERE release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix
SELECT country, COUNT(type)
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY COUNT(type) DESC LIMIT 5;

--5. Identify the longest movie
SELECT title, duration
FROM netflix
WHERE type='Movie' AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC LIMIT 1;

--6. Find content added in the last 5 years
SELECT date_added, title
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= NOW()-INTERVAL '5 years';

--7. Find all the movies/TV shows by director 'Makoto Shinkai'!
SELECT director, title, type
FROM netflix
WHERE director='Makoto Shinkai';

--8. List all TV shows with more than 5 seasons
SELECT title, duration
FROM netflix
WHERE type='TV Show' AND SPLIT_PART(duration, ' ', 1)::INT>5;

--9. Count the number of content items in each genre
SELECT listed_in, COUNT(*)
FROM netflix
GROUP BY listed_in
ORDER BY listed_in DESC;

--10.Find each year and the average numbers of content release in Japan on netflix. 
WITH yearly_count AS (
SELECT release_year, COUNT(*) AS release_count
FROM netflix
WHERE country='Japan'
GROUP BY release_year
)
SELECT release_year, ROUND(AVG(release_count))
FROM yearly_count
GROUP BY release_year;

--11.return top 5 year with highest avg content release!
WITH yearly_count AS (
SELECT release_year, COUNT(*) AS release_count
FROM netflix
WHERE country='Japan'
GROUP BY release_year
)
SELECT release_year, ROUND(AVG(release_count)) AS average
FROM yearly_count
GROUP BY release_year
ORDER BY average DESC LIMIT 5;

--12. List all movies that are documentaries
SELECT title, listed_in
FROM netflix
WHERE type='Movie' AND listed_in='Documentaries';

--13. Find all content without a director
SELECT title, director
FROM netflix
WHERE director IS NULL;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in USA.
SELECT cast_name, COUNT(*)
FROM netflix
WHERE cast_name IS NOT NULL AND country='United States'
GROUP BY cast_name
ORDER BY COUNT(*) DESC LIMIT 10;

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
SELECT title, description
FROM netflix
WHERE description LIKE '%kill%' OR description LIKE '%violence%';

--16.Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
WITH category_content AS (
SELECT title, 
CASE WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad' ELSE 'Good' END AS category
FROM netflix
)
SELECT category, COUNT(*)
FROM category_content
GROUP BY category;












