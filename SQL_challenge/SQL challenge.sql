-- SQA challenge day
-- Part 1: Sakila
USE sakila; 

-- 1. list all actors
SELECT first_name, last_name FROM actor;

-- 2. find the surname of the actor w the forename 'John'
SELECT last_name FROM actor WHERE first_name='John';

-- 3. Find all actors with surname 'Neeson'
SELECT first_name, last_name FROM actor WHERE last_name='Neeson';

-- 4. Find all actors with ID numbers divisible by 10 (took this to mean is a multiple of 10)
SELECT first_name, last_name, actor_id FROM actor WHERE actor_id LIKE '%0';

-- 5. What is the description of the movie with an ID of 100
SELECT title, `description` FROM film WHERE film_id=100;

-- 6. Find every R rated movie
SELECT title, rating FROM film WHERE rating='R';

-- 7. Find every non-R rated movie
SELECT title, rating FROM film WHERE rating != 'R';

-- 8. Find the 10 shortest movies
SELECT title, length FROM film ORDER BY length ASC LIMIT 10;

-- 9. Find the movies with the longest runtime without using limit
SELECT title, length FROM film ORDER BY length DESC;

-- 10. Find all movies that have deleted scenes
SELECT title, special_features FROM film WHERE special_features LIKE '%deleted scenes%';

-- 11. Using HAVING, reverse-alphabetically list the last names that are not repeated
SELECT last_name, COUNT(last_name) AS number_repeats FROM actor GROUP BY last_name HAVING number_repeats <1 ORDER BY last_name ASC;

SELECT last_name FROM actor ORDER BY last_name DESC;

-- 12. Using HAVING list the names that appear more than once, from highest to lowest frequency
SELECT first_name, COUNT(first_name) AS number_firstnamereps FROM actor GROUP BY first_name HAVING number_firstnamereps>1 ORDER BY number_firstnamereps DESC;

-- 13. Which actor appeared in the most films *
SELECT a.first_name, a.last_name, fa.actor_id, f.title FROM film f
JOIN film_actor fa ON fa.film_id=f.film_id
JOIN actor a ON fa.actor_id=a.actor_id
WHERE a.actor_id=(

SELECT actor_id FROM film_actor GROUP BY actor_id ORDER BY COUNT(actor_id) DESC LIMIT 1);

-- 14. When is 'Academy dinosaur' due => assume this means what is the most recent date for return?
SELECT f.title, r.return_date FROM film f
JOIN inventory i ON f.film_id=i.film_id
JOIN rental r ON r.inventory_id=i.inventory_id
WHERE f.title='Academy dinosaur' ORDER BY r.return_date DESC LIMIT 1;

-- 15. What is the average run time of all films
SELECT AVG(length) FROM film;

-- 16. List the average runtime for every film category *
SELECT c.`name`, AVG(f.length) 
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id;

-- 17. List all movies featuing a robot
SELECT title, `description` FROM film WHERE `description` LIKE '%robot%';

-- 18. How many movies were released in 2010
SELECT COUNT(release_year) FROM film WHERE release_year=( 
SELECT release_year FROM film WHERE release_year=2010
); 

-- 19. Find all the titles of all the horror movies 
SELECT f.title, f.film_id, c.category_id FROM film f
INNER JOIN film_category fc ON f.film_id=fc.film_id
INNER JOIN category c ON fc.category_id=c.category_id
	WHERE c.category_id=(
	SELECT category_id FROM category WHERE `name`='horror'
	);
    
-- 20. List the full name of the staff member with the ID of 2
SELECT first_name, last_name FROM staff WHERE staff_id=2;

-- 21. List all the movies that Fred Costner has appeared in 
SELECT f.title, a.first_name, a.last_name FROM film f
JOIN film_actor fa ON f.film_id=fa.film_id
JOIN actor a ON fa.actor_id=a.actor_id
WHERE a.actor_id=(

SELECT actor_id FROM actor WHERE first_name='Fred' and last_name='Costner');

-- 22. HOw many distinct countries are there
SELECT COUNT(country) FROM country; 

-- 23. LIst the name of every language in reverse alphabetical order
SELECT `name` FROM `language` ORDER BY `name` DESC;

-- 24. List the full names of of every actor whose surname ends with 'son' in alpha order by first name
SELECT first_name, last_name FROM actor WHERE last_name LIKE '%son' ORDER BY first_name ASC;

-- 25. Which category contains the most films 
SELECT `name` FROM category WHERE category_id=(

SELECT category_id
FROM film_category
GROUP BY category_id
ORDER BY COUNT(category_id) DESC LIMIT 1);

-- Part 2 World
USE world;

-- 1. Using COUNT, get the number of cities in the USA
SELECT COUNT(`Name`) FROM city WHERE CountryCode='USA';

-- 2. Find out the population and life expectanct for people in Argentina
SELECT `Name`, Population, LifeExpectancy FROM country WHERE `name`='Argentina';

-- 3. Using IS NOT NULL, ORDER BY and LIMIT, which country has the highest life expectancy
SELECT `Name`, LifeExpectancy FROM country WHERE LifeExpectancy IS NOT NULL ORDER BY LifeExpectancy DESC LIMIT 1;

-- 4. USING JOIN, find the capital city of Spain *
SELECT country.`name`, country.capital, city.`name` FROM country
INNER JOIN city ON country.`Code`=city.`CountryCode`
WHERE city.`name`=(
SELECT `name` FROM city WHERE ID =( SELECT capital FROM country WHERE `name`='Spain'));

-- 5. Using JOIN list all the languages spoken in the SE Asia region
SELECT cl.`language` FROM country c
INNER JOIN countrylanguage cl ON c.`code`=cl.CountryCode
WHERE c.region='Southeast Asia';

-- 6. Using a single query list 25 cities that start w LETTER f
SELECT `name` FROM city WHERE `name` LIKE 'F%' LIMIT 25;

-- 7. Using COUNT and JOIN get the number of cities in china
SELECT COUNT(city.`name`) FROM city
INNER JOIN country ON country.`code`=city.CountryCode
WHERE country.`name`='China';

-- 8. Using IS NOT NULL, ORDER BY, and LIMIT, which country has the lowest population? Discard non-zero populations.
SELECT `name`, Population FROM country WHERE Population IS NOT NULL AND Population !=0 ORDER BY Population ASC LIMIT 1;

-- 9. Using aggregate functions, return the number of countries the database contains.
SELECT COUNT(`name`) FROM country;

-- 10. What are the top ten largest countries by area?
SELECT `name`, SurfaceArea FROM country ORDER BY SurfaceArea DESC LIMIT 10;

-- 11.  List the five largest cities by population in Japan.
SELECT `name`, Population FROM city WHERE CountryCode=(
SELECT `code` FROM Country WHERE `name`='Japan') 
ORDER BY Population DESC LIMIT 5;

-- 12. List the names and country codes of every country with Elizabeth II as its Head of State. You will need to fix the mistake first!
UPDATE country
SET HeadOfState = 'Elizabeth II' 
WHERE HeadOfState = 'Elisabeth II';

SELECT `name`, `Code`, HeadOfState FROM country WHERE HeadOfState='Elizabeth II';

-- 13.List the top ten countries with the smallest population-to-area ratio. Discard any countries with a ratio of 0.
SELECT `name`, Population/SurfaceArea AS PR_ratio FROM country HAVING PR_ratio>0 ORDER BY PR_ratio ASC; 

-- 14. List every unique world language
SELECT DISTINCT `language` FROM countrylanguage;

-- 15. List the names and GNP of the world's top 10 richest countries.
SELECT `name`, GNP FROM country ORDER BY GNP DESC LIMIT 10;

-- 16. List the names of, and number of languages spoken by, the top ten most multilingual countries.
SELECT c.`name`, COUNT(cl.`language`), cl.countrycode
FROM country c
INNER JOIN countrylanguage cl ON cl.countrycode=c.`code`;
WHERE 
ORDER BY COUNT(`language`) DESC LIMIT 10;

WHERE c.`code` IN (
SELECT countrycode FROM countrylanguage GROUP BY countrycode ORDER BY COUNT(countrycode) DESC LIMIT 10); 


-- 17. List every country where over 50% of its population can speak German.
SELECT `name` FROM country WHERE `Code` IN (
SELECT CountryCode FROM countrylanguage WHERE `Language`='German' and `Percentage`>50);

-- 18. Which country has the worst life expectancy? Discard zero or null values.
SELECT `name`, LifeExpectancy FROM country WHERE LifeExpectancy IS NOT NULL AND LifeExpectancy != 0 ORDER BY LifeExpectancy ASC LIMIT 1;

-- 19. List the top three most common government forms.
SELECT governmentform, COUNT(governmentform) AS govformcount
FROM country 
GROUP BY governmentform
ORDER BY govformcount DESC LIMIT 3;

-- 20. How many countries have gained independence since records began?
SELECT COUNT(indepyear) FROM country;

-- PART 3 MovieLens
USE movielens;

-- 1. List the titles and release dates of movies released between 1983-1993 in reverse chronological order.
SELECT title, release_date FROM movies WHERE release_date BETWEEN '1983-01-01' AND '1993-01-01' ORDER BY release_date DESC;

-- 2. Without using LIMIT, list the titles of the movies with the lowest average rating.
SELECT m.title, r.rating FROM movies m
JOIN ratings r ON m.id=r.movie_id
WHERE m.id IN (
SELECT movie_id FROM ratings GROUP BY movie_id
ORDER BY AVG(rating) ASC)
ORDER BY rating ASC;

-- 3. List the unique records for Sci-Fi movies where male 24-year-old students have given 5-star ratings.
SELECT m.title, g.`name`, u.age, u.gender, r.rating FROM genres g
INNER JOIN genres_movies gm ON g.id=gm.genre_id
INNER JOIN movies m ON m.id=gm.movie_id
INNER JOIN ratings r ON r.movie_id=m.id
INNER JOIN users u ON u.id=r.user_id
INNER JOIN occupations o ON o.id=u.occupation_id
WHERE g.`name`='Sci-Fi' and u.age=24 and u.gender='M' and r.rating=5;

-- 4. List the unique titles of each of the movies released on the most popular release day.
SELECT DISTINCT title FROM movies WHERE release_date=(
SELECT release_date FROM movies GROUP BY release_date ORDER BY COUNT(release_date) DESC LIMIT 1);

SELECT title, release_date FROM pop_release_date;

-- 5. Find the total number of movies in each genre; list the results in ascending numeric order.
SELECT g.id, g.`name` FROM genres g
INNER JOIN genres_movies gm ON g.id=gm.genre_id
INNER JOIN movies m ON m.id=gm.movie_id;

SELECT (COUNT(movie_id)/(COUNT(genre_id)) GROUP BY genre_id AS movies_per_genre FROM genres_movies;

SELECT genre_id
FROM genres_movies
GROUP BY genre_id
ORDER BY COUNT(genre_id) ASC);


GROUP BY g.`name`
ORDER BY COUNT(`name`);
	
