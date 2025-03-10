-- Parte 1: Tipos de Datos, Restricciones e Índices
SHOW TABLES;
DESCRIBE country;
DESCRIBE city;
DESCRIBE countrylanguage;

ALTER TABLE city ADD COLUMN is_population_large BOOLEAN GENERATED ALWAYS AS (population > 1000000) STORED;
ALTER TABLE country ADD COLUMN region_code CHAR(3) DEFAULT 'NA';
ALTER TABLE city ADD CONSTRAINT chk_population CHECK (population >= 0);
ALTER TABLE country ADD CONSTRAINT unique_country_code UNIQUE (code);
CREATE INDEX idx_city_name ON city(name);
EXPLAIN SELECT * FROM city WHERE name = 'Madrid';

-- Parte 2: Vistas, Usuarios y Privilegios
CREATE VIEW high_population_cities AS 
SELECT name, countrycode, population FROM city WHERE population > 1000000;

CREATE VIEW countries_with_languages AS
SELECT c.name AS country_name, cl.language 
FROM country c 
JOIN countrylanguage cl ON c.code = cl.countrycode
WHERE cl.language <> 'English';

CREATE USER 'db_user'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT ON world.city TO 'db_user'@'localhost';
GRANT SELECT ON world.country TO 'db_user'@'localhost';
GRANT INSERT, UPDATE ON world.city TO 'db_user'@'localhost';
REVOKE INSERT, UPDATE, DELETE ON world.country FROM 'db_user'@'localhost';
GRANT SELECT ON world.high_population_cities TO 'db_user'@'localhost';

-- Parte 3: Operadores y Comparadores
SELECT name FROM country WHERE population BETWEEN 50000000 AND 200000000;
SELECT name FROM country WHERE population IN (20000000, 30000000, 40000000, 50000000);
SELECT name FROM city WHERE population BETWEEN 1000000 AND 10000000 
AND countrycode NOT IN (SELECT code FROM country WHERE region = 'Asia');

-- Parte 4: Subconsultas y Joins
SELECT name FROM country WHERE code IN (
    SELECT countrycode FROM city WHERE population > 1000000 GROUP BY countrycode HAVING COUNT(*) > 5
);
SELECT name FROM country WHERE code IN (
    SELECT countrycode FROM countrylanguage WHERE isofficial = 'T' GROUP BY countrycode HAVING COUNT(*) > 3
);

-- Parte 5: Optimización de Consultas
SELECT name, population FROM city ORDER BY population DESC LIMIT 10;
EXPLAIN SELECT name, population FROM city ORDER BY population DESC LIMIT 10;
CREATE INDEX idx_city_population ON city(population);

-- Parte 6: Transacciones
START TRANSACTION;
INSERT INTO city (name, countrycode, district, population) VALUES ('TestCity', 'ESP', 'Madrid', 500000);
SELECT * FROM city WHERE name = 'TestCity';
ROLLBACK;

START TRANSACTION;
INSERT INTO city (name, countrycode, district, population) VALUES ('NewCity', 'FRA', 'Paris', 600000);
UPDATE country SET population = population + 600000 WHERE code = 'FRA';
COMMIT;