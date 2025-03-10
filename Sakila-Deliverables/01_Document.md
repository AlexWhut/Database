# MySQL Workbench Tools & MySQL CMD Commands

## 1. SQL Statements for Modifying Database Content

### INSERT (Add Records)
```sql
INSERT INTO actor (first_name, last_name) 
VALUES ('John', 'Doe');
```

### UPDATE (Modify Records)
```sql
UPDATE actor 
SET last_name = 'Smith' 
WHERE actor_id = 1;
```

### DELETE (Remove Records)
```sql
DELETE FROM actor 
WHERE actor_id = 1;
```

### ALTER (Modify Table Structure)
```sql
ALTER TABLE actor 
ADD COLUMN birthdate DATE;
```
```sql
ALTER TABLE actor 
DROP COLUMN birthdate;
```

### TRUNCATE (Empty a Table Without Deleting Structure)
```sql
TRUNCATE TABLE rental;
```

### DROP (Delete a Table or Database)
```sql
DROP TABLE test_table;
```
```sql
DROP DATABASE sakila;
```

---

## 2. MySQL Workbench Tools

### SQL Editor
📌 **Functionality:**  
The SQL Editor is the area where you can write and execute SQL commands. It allows you to run queries, modify data, and manage the database visually.

📌 **Equivalent CMD Command:**  
```bash
mysql -u root -p
USE sakila;
SELECT * FROM actor;
```

---

### Schema Inspector
📌 **Functionality:**  
The Schema Inspector allows you to inspect table structures within a database, displaying information about columns, indexes, foreign keys, and more.

📌 **Equivalent CMD Command:**  
```sql
DESC actor;
```
```sql
SHOW CREATE TABLE actor;
```

---

### Query Builder
📌 **Functionality:**  
The Query Builder is a visual tool that helps construct SQL queries without manually writing the code.

📌 **Equivalent CMD Command:**  
```sql
SELECT first_name, last_name, film.title 
FROM actor 
JOIN film_actor ON actor.actor_id = film_actor.actor_id 
JOIN film ON film_actor.film_id = film.film_id;
```

---

## 3. Data Insertion, Deletion, and Update

### Insert a New Actor
```sql
INSERT INTO actor (first_name, last_name) 
VALUES ('John', 'Doe');
```

### Update an Actor's Last Name
```sql
UPDATE actor 
SET last_name = 'Smith' 
WHERE first_name = 'John' AND last_name = 'Doe';
```

### Delete an Actor
```sql
DELETE FROM actor 
WHERE first_name = 'John' AND last_name = 'Smith';
```

---

## 4. Creating a Table from a Query Result

```sql
CREATE TABLE recent_films AS
SELECT * FROM film WHERE release_year > 2005;
```
```sql
SELECT * FROM recent_films;
```

---

## 5. Designing Complex SQL Queries

### Customers Who Rented in the Last 30 Days
```sql
SELECT DISTINCT customer_id FROM rental WHERE rental_date >= NOW() - INTERVAL 30 DAY;
```

### Most Rented Film
```sql
SELECT film_id, COUNT(*) AS rent_count 
FROM rental INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id 
GROUP BY film_id ORDER BY rent_count DESC LIMIT 1;
```

### Total Revenue Per Store
```sql
SELECT store.store_id, SUM(payment.amount) AS total_revenue
FROM payment 
JOIN rental ON payment.rental_id = rental.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN store ON inventory.store_id = store.store_id
GROUP BY store.store_id;
```

---

## 6. Understanding Transactions

```sql
START TRANSACTION;
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (NOW(), 1, 1, NULL, 1);
UPDATE inventory SET last_update = NOW() WHERE inventory_id = 1;
COMMIT;
```

---

## 7. Rolling Back Transactions

```sql
START TRANSACTION;
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (NOW(), 9999, 1, NULL, 1); 
ROLLBACK;
```

---

## 8. Record Locking Policies

### Lock a Record (Session 1)
```sql
START TRANSACTION;
UPDATE actor SET last_name = 'Locked' WHERE actor_id = 1;
```

### Attempt to Update the Same Record (Session 2)
```sql
UPDATE actor SET last_name = 'Conflict' WHERE actor_id = 1;
```

### Commit or Rollback to Unlock (Session 1)
```sql
COMMIT;
```

---

## 9. Ensuring Data Integrity

### Foreign Key Constraint
```sql
ALTER TABLE rental ADD CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id);
```

### Prevent Rentals Without Stock (Trigger)
```sql
CREATE TRIGGER prevent_out_of_stock
BEFORE INSERT ON rental
FOR EACH ROW
BEGIN
    DECLARE available INT;
    SELECT COUNT(*) INTO available FROM inventory WHERE inventory_id = NEW.inventory_id;
    IF available = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No stock available';
    END IF;
END;
```

---

## Conclusion
These SQL commands and MySQL Workbench tools provide powerful ways to manage databases. Even when using CMD, you can achieve the same results through SQL queries.

