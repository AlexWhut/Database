-- transaction
USE sakila;

START TRANSACTION;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (NOW(), 1, 1, NULL, 1);

UPDATE inventory SET last_update = NOW() WHERE inventory_id = 1;

COMMIT;
