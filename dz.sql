--1.1
SELECT SUM(si.UnitPrice * si.Quantity) AS Sales
FROM sales_items
WHERE SalesId IN (
    SELECT SalesId
    FROM sales
    WHERE ShipCountry = 'USA' AND SalesDate BETWEEN '2012-01-01' AND '2012-03-31'
);

-- 1.2
SELECT SUM(ItemSales.Total) AS Sales
FROM (
    SELECT si.UnitPrice * si.Quantity AS Total
    FROM sales s
    JOIN sales_items si ON s.SalesId = si.SalesId
    WHERE s.ShipCountry = 'USA' 
      AND s.SalesDate BETWEEN '2012-01-01' AND '2012-03-31'
) AS ItemSales;

-- 2.1
SELECT FirstName, LastName
FROM customers
WHERE FirstName NOT IN (SELECT FirstName FROM employees);

-- 2.2
SELECT c.FirstName, c.LastName
FROM customers c
LEFT JOIN employees e ON c.FirstName = e.FirstName
WHERE e.FirstName IS NULL;

-- 3
SELECT FirstName, LastName
FROM customers
EXCEPT
SELECT FirstName, LastName
FROM employees;

-- Задание 3 (Теоритическое)
-- НЕТ, тк в одном случае происходит джойн и затем выбираются строки. В другом, происходит джойн по условию
-- Второй список будет больше тк в первом запросе строки из t1, где column1 != 0, будут исключены после WHERE
-- 4.1
SELECT Title AS AlbumTitle, 
       (SELECT COUNT(*) FROM tracks t WHERE t.AlbumId = a.AlbumId) AS TrackCount
FROM albums a;

-- 4.2
SELECT a.Title AS AlbumTitle, COUNT(t.TrackId) AS TrackCount
FROM albums a
JOIN tracks t ON a.AlbumId = t.AlbumId
GROUP BY a.Title;

-- 5
SELECT DISTINCT c.LastName, c.FirstName
FROM customers c
JOIN sales s ON c.CustomerId = s.CustomerId
WHERE c.Country = 'Germany' 
  AND s.SalesDate BETWEEN '2009-01-01' AND '2009-12-31'
  AND s.ShipCity = 'Berlin';

-- 6.1
SELECT c.LastName, c.FirstName
FROM customers c
WHERE (SELECT SUM(si.Quantity)
       FROM sales s
       JOIN sales_items si ON s.SalesId = si.SalesId
       WHERE s.CustomerId = c.CustomerId) > 30;

-- 6.2
SELECT c.LastName, c.FirstName
FROM customers c
JOIN sales s ON c.CustomerId = s.CustomerId
JOIN sales_items si ON s.SalesId = si.SalesId
GROUP BY c.CustomerId
HAVING SUM(si.Quantity) > 30;

-- 7 (средняя стоимость трека в каждом жанре)
SELECT g.Name, ROUND(AVG(t.UnitPrice), 4) AS Avg_price
FROM genres g
JOIN tracks t ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY Avg_price;

-- 8 (жанры со средней стоимостью трека > 1)
SELECT g.Name
FROM genres g
JOIN tracks t ON t.GenreId = g.GenreId
GROUP BY g.GenreId
HAVING AVG(t.UnitPrice) > 1
ORDER BY g.Name;