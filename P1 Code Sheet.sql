Project 1: Investigate Relational database


Slide 1: Actors and movies
Question: whom the 10 actors with highest movies count?

SQL Code:
SELECT actor.first_name || ' ' || actor.last_name AS full_name, COUNT(film.title) AS actor_movies
FROM actor
JOIN film_actor
ON actor.actor_id = film_actor.actor_id
JOIN film
ON film.film_id = film_actor.film_id
GROUP BY full_name
ORDER BY 2 DESC
LIMIT 10


Slide 2: Categories with Highest number of actors per Movie
Question: What are top 10 categories with highest number of actors per movie?

SQL Code:
WITH actors AS
(SELECT actor.first_name || ' ' || actor.last_name AS full_name,
 COUNT(film.title) AS actor_movies,
 actor.actor_id
FROM actor
JOIN film_actor
ON actor.actor_id = film_actor.actor_id
JOIN film
ON film.film_id = film_actor.film_id
GROUP BY full_name, actor.actor_id
ORDER BY 2 DESC),

actors_for_category AS
(SELECT actor.actor_id, category.name AS catt, film.title AS mov_name,
 COUNT(actor.actor_id) AS category_actors
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN film
ON film.film_id = film_category.film_id
JOIN film_actor
ON film_actor.film_id = film.film_id
JOIN actor
ON film_actor.actor_id = actor.actor_id
GROUP BY 1, 2, 3)

SELECT DISTINCT(catt), COUNT(full_name) OVER(PARTITION BY mov_name) AS actors_per_movie
FROM actors
JOIN actors_for_category
ON actors.actor_id = actors_for_category.actor_id
ORDER BY 2 DESC
LIMIT 10

Slide 3: Rents per Category (Family Friendly)
Question: (Note: this question has been taken from the Questeion Set#1 from the Project part of the lessons and will be pasted without changes):
"We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.
Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out."

SQL Code:
SELECT film.title, category.name AS category_name, COUNT(rental.rental_id) AS rents_count
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film
ON film.film_id = inventory.film_id
JOIN film_category
ON film_category.film_id = film.film_id
JOIN category
ON category.category_id = film_category.category_id
WHERE category.name LIKE 'Children'
OR category.name = 'Animation'
OR category.name = 'Classics'
OR category.name = 'Comedy'
OR category.name = 'Family'

Slide 4: Movies per Category
Question: For the Family Friendly categories, How many movies are there in each category?

SQL Code:
WITH cats_eg AS
(SELECT inventory.inventory_id, category.name AS cat_n, film.title AS m_name,
rental.return_date - rental.rental_date AS rent_period
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
 JOIN film
 ON film.film_id = film_category.film_id
 JOIN inventory
 ON inventory.film_id = film.film_id
 JOIN rental
 ON rental.inventory_id = inventory.inventory_id
WHERE name LIKE 'Children'
OR name LIKE 'Animation'
OR name LIKE 'Classics'
OR name LIKE 'Comedy'
OR name LIKE 'Family'
OR name LIKE 'Music')

SELECT cats_eg.cat_n, COUNT(m_name) AS titles_count, SUM(rent_period)
FROM cats_eg
GROUP BY 1
