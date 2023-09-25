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
        

-- Most prolific actor


SELECT a.first_name, a.last_name, COUNT(fa.actor_id) AS num_films
FROM sakila.actor a
JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY num_films DESC
LIMIT 1;

-- Films with the most prolific actor

SELECT f.title FROM sakila.film f WHERE f.film_id IN (SELECT fa.film_id
    FROM sakila.film_actor fa
    WHERE fa.actor_id = 
    (SELECT actor_id FROM sakila.film_actor
	GROUP BY actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1));
    
-- Films rented by most profitable customer    
    
SELECT f.title
FROM sakila.film f
JOIN sakila.inventory i ON f.film_id = i.film_id
JOIN sakila.rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = (SELECT customer_id FROM sakila.payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 1);

-- Client IDs and amounts that clients spend more when more than the average.

SELECT p.customer_id, SUM(p.amount) AS total_amount_spent
FROM sakila.payment p
GROUP BY p.customer_id
HAVING total_amount_spent > (SELECT AVG(total) FROM (SELECT SUM(amount) AS total FROM sakila.payment
GROUP BY customer_id) AS sub);

        


