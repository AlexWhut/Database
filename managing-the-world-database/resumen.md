# **Managing the World Database**

## **Introducción**
Este documento contiene los comandos SQL utilizados para completar el ejercicio de gestión de la base de datos `world`, junto con explicaciones detalladas de cada paso.

---

## **1️⃣ Parte 1: Tipos de Datos, Restricciones e Índices**
### **Objetivo:**
- Practicar el uso de diferentes tipos de datos.
- Aplicar restricciones de validación.
- Crear índices para mejorar el rendimiento.

### **Comandos SQL:**
```sql
-- Listar todas las tablas en la base de datos "world"
SHOW TABLES;

-- Ver estructura de las tablas country, city y countrylanguage
DESCRIBE country;
DESCRIBE city;
DESCRIBE countrylanguage;

-- Agregar una columna booleana a city
ALTER TABLE city ADD COLUMN is_population_large BOOLEAN GENERATED ALWAYS AS (population > 1000000) STORED;

-- Agregar una columna con valor por defecto en country
ALTER TABLE country ADD COLUMN region_code CHAR(3) DEFAULT 'NA';

-- Agregar una restricción CHECK para que la población no sea negativa
ALTER TABLE city ADD CONSTRAINT chk_population CHECK (population >= 0);

-- Asegurar que el código del país en country sea único
ALTER TABLE country ADD CONSTRAINT unique_country_code UNIQUE (code);

-- Crear un índice en la columna name de city
CREATE INDEX idx_city_name ON city(name);

-- Analizar el impacto del índice
EXPLAIN SELECT * FROM city WHERE name = 'Madrid';
```
### **Explicación:**
- Se usa `ALTER TABLE` para modificar las tablas y agregar restricciones.
- La columna `is_population_large` se genera automáticamente en función de la población.
- Se agrega un índice a `city(name)` para mejorar la velocidad de búsqueda.

---

## **2️⃣ Parte 2: Vistas, Usuarios y Privilegios**
### **Objetivo:**
- Crear vistas para consultas optimizadas.
- Gestionar usuarios y permisos.

### **Comandos SQL:**
```sql
-- Crear una vista con ciudades de más de 1 millón de habitantes
CREATE VIEW high_population_cities AS 
SELECT name, countrycode, population FROM city WHERE population > 1000000;

-- Crear una vista que une country y countrylanguage (excluyendo inglés)
CREATE VIEW countries_with_languages AS
SELECT c.name AS country_name, cl.language 
FROM country c 
JOIN countrylanguage cl ON c.code = cl.countrycode
WHERE cl.language <> 'English';

-- Crear usuario con privilegios específicos
CREATE USER 'db_user'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT ON world.city TO 'db_user'@'localhost';
GRANT SELECT ON world.country TO 'db_user'@'localhost';
GRANT INSERT, UPDATE ON world.city TO 'db_user'@'localhost';
REVOKE INSERT, UPDATE, DELETE ON world.country FROM 'db_user'@'localhost';
GRANT SELECT ON world.high_population_cities TO 'db_user'@'localhost';
```
### **Explicación:**
- Se crean vistas para optimizar consultas.
- Se otorgan permisos limitados al usuario `db_user`.
- Se revocan permisos sobre la tabla `country`.

---

## **3️⃣ Parte 3: Operadores y Comparadores**
### **Objetivo:**
- Practicar operadores lógicos y comparadores en SQL.

### **Comandos SQL:**
```sql
-- Países con población entre 50M y 200M
SELECT name FROM country WHERE population BETWEEN 50000000 AND 200000000;

-- Países con población entre 20M y 50M usando IN
SELECT name FROM country WHERE population IN (20000000, 30000000, 40000000, 50000000);

-- Ciudades con población entre 1M y 10M, excluyendo Asia
SELECT name FROM city WHERE population BETWEEN 1000000 AND 10000000 
AND countrycode NOT IN (SELECT code FROM country WHERE region = 'Asia');
```
---

## **4️⃣ Parte 4: Subconsultas y Joins**
### **Objetivo:**
- Aplicar subconsultas y combinaciones de tablas.

### **Comandos SQL:**
```sql
-- Países con más de 5 ciudades con población >1M
SELECT name FROM country WHERE code IN (
    SELECT countrycode FROM city WHERE population > 1000000 GROUP BY countrycode HAVING COUNT(*) > 5
);

-- Países con más de 3 idiomas oficiales
SELECT name FROM country WHERE code IN (
    SELECT countrycode FROM countrylanguage WHERE isofficial = 'T' GROUP BY countrycode HAVING COUNT(*) > 3
);
```
---

## **5️⃣ Parte 5: Optimización de Consultas**
### **Objetivo:**
- Mejorar el rendimiento de consultas SQL.

### **Comandos SQL:**
```sql
-- Obtener las 10 ciudades más pobladas
SELECT name, population FROM city ORDER BY population DESC LIMIT 10;

-- Evaluar optimización con EXPLAIN
EXPLAIN SELECT name, population FROM city ORDER BY population DESC LIMIT 10;

-- Crear índice para optimizar búsqueda
CREATE INDEX idx_city_population ON city(population);
```
---

## **6️⃣ Parte 6: Transacciones**
### **Objetivo:**
- Manejar transacciones SQL.

### **Comandos SQL:**
```sql
-- Iniciar una transacción y hacer un rollback
START TRANSACTION;
INSERT INTO city (name, countrycode, district, population) VALUES ('TestCity', 'ESP', 'Madrid', 500000);
SELECT * FROM city WHERE name = 'TestCity';
ROLLBACK;

-- Iniciar transacción con commit si todo es exitoso
START TRANSACTION;
INSERT INTO city (name, countrycode, district, population) VALUES ('NewCity', 'FRA', 'Paris', 600000);
UPDATE country SET population = population + 600000 WHERE code = 'FRA';
COMMIT;
```

---

## **Conclusión**
Este documento contiene las soluciones del ejercicio de administración de la base de datos `world`, utilizando SQL en MySQL desde la terminal. Además, se incluyen explicaciones detalladas de cada parte para facilitar la comprensión. 🚀
