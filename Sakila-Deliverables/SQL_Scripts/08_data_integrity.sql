-- data integrity
USE sakila;

ALTER TABLE rental ADD CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id);

DELIMITER $$

CREATE TRIGGER prevent_out_of_stock
BEFORE INSERT ON rental
FOR EACH ROW
BEGIN
    DECLARE available INT;

    -- Comprobar si el inventario está disponible
    SELECT COUNT(*) INTO available
    FROM inventory
    WHERE inventory_id = NEW.inventory_id;

    -- Si no hay stock disponible, lanzamos un error
    IF available = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No stock available';
    END IF;
END $$

DELIMITER ;
