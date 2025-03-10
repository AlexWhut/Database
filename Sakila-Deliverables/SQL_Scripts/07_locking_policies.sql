-- polices
USE sakila;

START TRANSACTION;
UPDATE actor SET last_name = 'Locked' WHERE actor_id = 1;

UPDATE actor SET last_name = 'Conflict' WHERE actor_id = 1;

COMMIT;
