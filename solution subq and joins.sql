USE SAKILA;

-- How many "Hunchback Impossible" copies are there?

SELECT COUNT(*) 
FROM sakila.inventory 
WHERE film_id = (SELECT film_id FROM sakila.film WHERE title = 'Hunchback Impossible');

-- List films longer than the average film length

SELECT title 
FROM sakila.film 
WHERE length > (SELECT AVG(length) FROM sakila.film);

-- Use a subquery to display all actors who appear in the film "Alone Trip"

SELECT a.first_name, a.last_name FROM sakila.actor a
WHERE a.actor_id IN 
    (SELECT fa.actor_id 
    FROM sakila.film_actor fa
    WHERE fa.film_id = (SELECT film_id FROM sakila.film WHERE title = 'Alone Trip'));

--  Identify all movies categorized as family films.


SELECT f.title FROM sakila.film f 

WHERE f.film_id IN
 (SELECT fc.film_id
    FROM sakila.film_category fc
    WHERE fc.category_id = (
        SELECT c.category_id
        FROM sakila.category c
        WHERE c.name = 'Family'));


-- Retrieve the name and email of customers from Canada using both subqueries and joins

-- Subquery

SELECT c.first_name, c.email FROM sakila.customer c
WHERE c.address_id IN 
(SELECT a.address_id
    FROM sakila.address a
    WHERE a.city_id IN 
       (SELECT ci.city_id
        FROM sakila.city ci
        WHERE ci.country_id = (SELECT country_id FROM sakila.country WHERE country = 'Canada')));
        
-- Join

SELECT c.first_name, c.email
FROM sakila.customer c
JOIN sakila.address a ON c.address_id = a.address_id
JOIN sakila.city ci ON a.city_id = ci.city_id
JOIN sakila.country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';


        


