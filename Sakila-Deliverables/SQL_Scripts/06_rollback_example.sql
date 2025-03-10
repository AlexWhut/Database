-- rollback
USE sakila;

START TRANSACTION;

INSERT INTO inventory (inventory_id, film_id, store_id, last_update)
VALUES (9999, 1, 1, NOW());

ROLLBACK;
