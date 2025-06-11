USE AdventureWorks2019;
GO

-- Q1: List all customers
SELECT * FROM Sales.Customer;

-- Q2: Customers whose company name ends with 'N'
SELECT c.CustomerID, s.Name AS CompanyName
FROM Sales.Customer c
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE s.Name LIKE '%N';


-- Q3: Top 10 customers by total purchases
SELECT TOP 10 c.CustomerID, SUM(soh.TotalDue) AS TotalPurchase
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalPurchase DESC;

-- Q4: Customers with their sales representative (SalesPersonID)
SELECT 
    c.CustomerID,
    c.AccountNumber,
    sp.BusinessEntityID AS SalesPersonID,
    per.FirstName + ' ' + per.LastName AS SalesRepName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Person.Person per ON e.BusinessEntityID = per.BusinessEntityID
WHERE soh.SalesPersonID IS NOT NULL;


-- Q5: Products with category and subcategory
SELECT p.Name AS ProductName, pc.Name AS Category, psc.Name AS Subcategory
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID;

-- Q6: Orders placed in 2013
SELECT * FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013;

-- Q7: Number of orders by each customer
SELECT CustomerID, COUNT(SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;

-- Q8: Customers who never placed an order
SELECT * FROM Sales.Customer
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID FROM Sales.SalesOrderHeader
);

-- Q9: Most sold product (by quantity)
SELECT TOP 1 ProductID, SUM(OrderQty) AS TotalSold
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY TotalSold DESC;

-- Q10: Employees and their manager names
SELECT 
    e.BusinessEntityID AS EmployeeID,
    p1.FirstName + ' ' + p1.LastName AS EmployeeName,
    p2.FirstName + ' ' + p2.LastName AS ManagerName
FROM HumanResources.Employee e
LEFT JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN Person.Person p1 ON e.BusinessEntityID = p1.BusinessEntityID
LEFT JOIN Person.Person p2 ON m.BusinessEntityID = p2.BusinessEntityID;

-- 11: Details of first order of the system
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY OrderDate ASC;

-- 12: Find the details of most expensive order date
SELECT TOP 1 OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- 13: For each order get the OrderID and average quantity of items in that order
SELECT SalesOrderID, AVG(OrderQty) AS AvgQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- 14: For each order get the orderID, minimum quantity and maximum quantity for that order
SELECT SalesOrderID, MIN(OrderQty) AS MinQty, MAX(OrderQty) AS MaxQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- 15: Get a list of all managers and total number of employees who report to them
SELECT 
    m.BusinessEntityID AS ManagerID,
    p.FirstName + ' ' + p.LastName AS ManagerName,
    COUNT(e.BusinessEntityID) AS TotalReports
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN Person.Person p ON m.BusinessEntityID = p.BusinessEntityID
GROUP BY m.BusinessEntityID, p.FirstName, p.LastName;

-- 16: Get the OrderID and the total quantity for each order that has a total quantity of greater than 300
SELECT SalesOrderID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;

-- 17: List of all orders placed on or after 1996/12/31
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';

-- 18: List of all orders shipped to Canada
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'CA';

-- 19: List of all orders with order total > 200
SELECT *
FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;

-- 20: List of countries and sales made in each country
SELECT cr.Name AS Country, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name;

-- 21: List of Customer ContactName and number of orders they placed
SELECT p.FirstName + ' ' + p.LastName AS ContactName, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName;

-- 22: List of customer contact names who have placed more than 3 orders
SELECT p.FirstName + ' ' + p.LastName AS ContactName, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 3;

-- 23: List of discontinued products which were ordered between 1/1/1997 and 1/1/1998
SELECT DISTINCT p.Name
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE p.DiscontinuedDate IS NOT NULL
  AND soh.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

-- 24: List of employee firstname, lastname, supervisor firstname, lastname
SELECT 
    e.BusinessEntityID AS EmployeeID,
    p1.FirstName AS EmployeeFirstName, p1.LastName AS EmployeeLastName,
    p2.FirstName AS SupervisorFirstName, p2.LastName AS SupervisorLastName
FROM HumanResources.Employee e
LEFT JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN Person.Person p1 ON e.BusinessEntityID = p1.BusinessEntityID
LEFT JOIN Person.Person p2 ON m.BusinessEntityID = p2.BusinessEntityID;

-- 25: List of Employee ID and total sale conducted by employee
SELECT sp.BusinessEntityID AS EmployeeID, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
GROUP BY sp.BusinessEntityID;

-- 26: List of employees whose FirstName contains character 'a'
SELECT FirstName, LastName
FROM Person.Person
WHERE BusinessEntityID IN (
    SELECT BusinessEntityID FROM HumanResources.Employee
)
AND FirstName LIKE '%a%';

-- 27: List of managers who have more than four people reporting to them
SELECT 
    m.BusinessEntityID AS ManagerID,
    p.FirstName + ' ' + p.LastName AS ManagerName,
    COUNT(e.BusinessEntityID) AS ReportCount
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN Person.Person p ON m.BusinessEntityID = p.BusinessEntityID
GROUP BY m.BusinessEntityID, p.FirstName, p.LastName
HAVING COUNT(e.BusinessEntityID) > 4;

-- 28: List of Orders and ProductNames
SELECT soh.SalesOrderID, p.Name AS ProductName
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID;

-- 29: List of orders placed by the best customer
SELECT TOP 1 soh.CustomerID, soh.SalesOrderID, soh.OrderDate, soh.TotalDue
FROM Sales.SalesOrderHeader soh
JOIN (
    SELECT CustomerID, SUM(TotalDue) AS TotalSpent
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
) best ON soh.CustomerID = best.CustomerID
ORDER BY best.TotalSpent DESC;

-- 30: List of orders placed by customers who do not have a Fax number
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID
WHERE pp.PhoneNumber IS NULL;

-- 31: List of Postal codes where the product Tofu was shipped
SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE p.Name = 'Tofu';

-- 32: List of product Names that were shipped to France
SELECT DISTINCT p.Name
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'FR';

-- 33: List of Product Names and Categories for the supplier 'Specialty Biscuits, Ltd.'
SELECT p.Name AS ProductName, pc.Name AS Category
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';

-- 34: List of products that were never ordered
SELECT p.Name
FROM Production.Product p
WHERE p.ProductID NOT IN (
    SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail
);

-- 35: List of products where units in stock is less than 10 and units on order are 0
SELECT Name
FROM Production.ProductInventory
JOIN Production.Product ON Production.ProductInventory.ProductID = Production.Product.ProductID
WHERE Quantity < 10 AND Quantity > 0;

-- 36: List of top 10 countries by sales
SELECT TOP 10 cr.Name AS Country, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name
ORDER BY TotalSales DESC;

-- 37: Number of orders each employee has taken for customers with CustomerIDs between 'A' and 'AO'
-- NOTE: CustomerIDs are integers in AdventureWorks; this might not apply directly
-- We'll use a different valid ID range
SELECT SalesPersonID, COUNT(SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader
WHERE CustomerID BETWEEN 1 AND 100
GROUP BY SalesPersonID;

-- 38: OrderDate of most expensive order
SELECT TOP 1 OrderDate
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- 39: Product name and total revenue from that product
SELECT p.Name, SUM(sod.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name;

-- 40: SupplierID and number of products offered
SELECT pv.BusinessEntityID AS SupplierID, COUNT(DISTINCT pv.ProductID) AS ProductCount
FROM Purchasing.ProductVendor pv
GROUP BY pv.BusinessEntityID;

-- 41: Top ten customers based on their business (total purchase)
SELECT TOP 10 CustomerID, SUM(TotalDue) AS TotalBusiness
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalBusiness DESC;

-- 42: What is the total revenue of the company
SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader;



