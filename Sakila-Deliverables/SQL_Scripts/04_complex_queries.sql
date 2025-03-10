-- complex queries
USE sakila;

SELECT DISTINCT customer_id FROM rental WHERE rental_date >= NOW() - INTERVAL 30 DAY;

SELECT film_id, COUNT(*) AS rent_count 
FROM rental INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id 
GROUP BY film_id ORDER BY rent_count DESC LIMIT 1;

SELECT store.store_id, SUM(payment.amount) AS total_revenue
FROM payment 
JOIN rental ON payment.rental_id = rental.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN store ON inventory.store_id = store.store_id
GROUP BY store.store_id;
