-- modify_actor 
USE sakila;

INSERT INTO actor (first_name, last_name) VALUES ('John', 'Doe');

UPDATE actor 
SET last_name = 'Smith' 
WHERE first_name = 'John' AND last_name = 'Doe';

DELETE FROM actor 
WHERE first_name = 'John' AND last_name = 'Smith';
