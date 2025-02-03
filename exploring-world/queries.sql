-- Part 3: SQL Queries
-- Basic Queries

-- 1. Retrieve all country names and their official languages
SELECT country.Name, countrylanguage.Language
FROM country
JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial = 'T';

-- 2. List all cities in Germany along with their population
SELECT Name, Population
FROM city
WHERE CountryCode = 'DEU';

-- 3. Find the five smallest countries by surface area
SELECT Name, SurfaceArea
FROM country
ORDER BY SurfaceArea ASC
LIMIT 5;

-- Filtering & Aggregation

-- 4. Find all countries with a population greater than 50 million and sort them in descending order of population
SELECT Name, Population
FROM country
WHERE Population > 50000000
ORDER BY Population DESC;

-- 5. Retrieve the average life expectancy per continent
SELECT Continent, AVG(LifeExpectancy) AS AverageLifeExpectancy
FROM country
GROUP BY Continent;

-- 6. Calculate the total population per region
SELECT Region, SUM(Population) AS TotalPopulation
FROM country
GROUP BY Region;

-- 7. Count the number of cities in each country and sort by the highest count
SELECT country.Name, COUNT(city.ID) AS NumberOfCities
FROM country
LEFT JOIN city ON country.Code = city.CountryCode
GROUP BY country.Name
ORDER BY NumberOfCities DESC;

-- Joins & Subqueries

-- 8. Display the top 10 largest cities along with their country name
SELECT city.Name AS CityName, country.Name AS CountryName, city.Population
FROM city
JOIN country ON city.CountryCode = country.Code
ORDER BY city.Population DESC
LIMIT 10;

-- 9. Retrieve the names of all countries that have an official language of French
SELECT DISTINCT country.Name
FROM country
JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'French' AND countrylanguage.IsOfficial = 'T';

-- 10. Find all countries where English is spoken, but it is not the official language
SELECT DISTINCT country.Name
FROM country
JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'English' AND countrylanguage.IsOfficial = 'F';

-- Advanced Queries

-- 11. Find countries where the population tripled in the past 50 years (if historical data is available)
-- NOTE: The 'Year' column does not exist in the 'country' table, and no historical data is available in this database.
-- The following query assumes population data from the last 50 years would be available, but it is not in this case.

-- 12. List the richest and poorest countries in each continent based on GNP (Gross National Product)
SELECT continent,
       (SELECT Name FROM country WHERE continent = c.continent ORDER BY GNP DESC LIMIT 1) AS RichestCountry,
       MAX(GNP) AS RichestGNP
FROM country c
GROUP BY continent

UNION

SELECT continent,
       (SELECT Name FROM country WHERE continent = c.continent ORDER BY GNP ASC LIMIT 1) AS PoorestCountry,
       MIN(GNP) AS PoorestGNP
FROM country c
GROUP BY continent;

-- 13. Identify countries with a life expectancy below the global average
SELECT Name, LifeExpectancy
FROM country
WHERE LifeExpectancy < (SELECT AVG(LifeExpectancy) FROM country);

-- 14. Retrieve the capital cities of countries with a population above 100 million
SELECT city.Name AS CapitalCity, country.Name AS CountryName
FROM city
JOIN country ON city.ID = country.Capital
WHERE country.Population > 100000000;

-- 15. Find the continent with the highest number of countries
SELECT Continent, COUNT(*) AS NumberOfCountries
FROM country
GROUP BY Continent
ORDER BY NumberOfCountries DESC
LIMIT 1;
