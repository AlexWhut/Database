-- recent films  > 2005
USE sakila;

CREATE TABLE recent_films AS
SELECT * FROM film WHERE release_year > 2005;

SELECT * FROM recent_films;
