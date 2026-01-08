#Question 1: Explain the fundamental differences between DDL, DML, and DQL commands in SQL. Provide one example
#for each type of command.

#Ans 1: DDL (Data Definition Language) commands are used to define, modify, or delete database structures such as 
#tables, schemas, or indexes and directly affect the database structure; common DDL commands include CREATE, ALTER, 
#and DROP, for example CREATE TABLE Students (ID INT);. DML (Data Manipulation Language) commands are used to insert, 
#update, or delete data stored inside tables and affect the data itself rather than the structure; examples include 
#INSERT, UPDATE, and DELETE, such as INSERT INTO Students VALUES (1);. DQL (Data Query Language) commands are used to 
#retrieve data from the database without modifying it, and the primary DQL command is SELECT, for example SELECT * FROM 
#Students, which fetches records based on specified conditions.


#Question 2: What is the purpose of SQL constraints? Name and describe three common types of constraints, providing a 
#simple scenario where each would be useful.

#Ans 2: SQL constraints are used to enforce rules on table data to maintain data accuracy, consistency, and integrity 
#within a database. A PRIMARY KEY constraint uniquely identifies each record in a table and prevents duplicate or NULL 
#values, such as using CustomerID as a primary key to uniquely identify customers. A FOREIGN KEY constraint establishes 
#a relationship between two tables and ensures referential integrity, for example linking Orders.CustomerID to Customers.
#CustomerID so that orders cannot exist without a valid customer. A UNIQUE constraint ensures that all values in a column 
#are distinct, such as enforcing unique email addresses for users to prevent duplicate registrations.


#Question 3: Explain the difference between LIMIT and OFFSET clauses in SQL. How would you use them together to retrieve 
#the third page of results, assuming each page has 10 records?

#Ans 3: The LIMIT clause in SQL specifies the maximum number of records to return in a query result, while the OFFSET 
#clause specifies the number of records to skip before starting to return rows. LIMIT is commonly used for pagination 
#to control how many rows are displayed at a time, and OFFSET helps move through result pages. To retrieve the third 
#page of results when each page contains 10 records, OFFSET would skip the first 20 records and LIMIT would return the 
#next 10 records, for example SELECT * FROM table_name LIMIT 10 OFFSET 20;.


#Question 4: What is a Common Table Expression (CTE) in SQL, and what are its main benefits? Provide a simple SQL example 
#demonstrating its usage.

#A Common Table Expression (CTE) is a temporary named result set defined using the WITH clause that exists only for the 
#duration of a query and helps simplify complex SQL queries by improving readability and reusability. CTEs are especially 
#useful for breaking down complex joins, performing recursive queries, and making large queries easier to debug and maintain. 
#For example, a CTE can be used to calculate average salary and then filter results: WITH AvgSalary AS (SELECT AVG(salary) 
#AS avg_sal FROM Employees) SELECT * FROM Employees WHERE salary > (SELECT avg_sal FROM AvgSalary);.

#Question 5: Describe the concept of SQL Normalization and its primary goals. Briefly explain the first three normal forms 
#(1NF, 2NF, 3NF).

#Ans 5: SQL normalization is a database design technique used to organize data efficiently by reducing redundancy and dependency, 
#thereby improving data integrity and minimizing update anomalies. The primary goals of normalization are to eliminate 
#duplicate data, ensure logical data storage, and maintain consistency across the database. First Normal Form (1NF) requires 
#that each table column contains atomic values with no repeating groups. Second Normal Form (2NF) builds on 1NF by ensuring 
#that all non-key attributes are fully dependent on the entire primary key. Third Normal Form (3NF) further refines the structure 
#by removing transitive dependencies so that non-key attributes depend only on the primary key and not on other non-key attributes.


#Question 6: Create ECommerceDB, Tables & Insert Records

create database ECommerceDB;
USE ECommerceDB;

create table Categories (
CategoryID int primary key,
CategoryName varchar(50) not null unique
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    CategoryID INT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Home Goods'),
(4, 'Apparel');

INSERT INTO Products VALUES
(101, 'Laptop Pro', 1, 1200.00, 50),
(102, 'SQL Handbook', 2, 45.50, 200),
(103, 'Smart Speaker', 1, 99.99, 150),
(104, 'Coffee Maker', 3, 75.00, 80),
(105, 'Novel: The Great SQL', 2, 25.00, 120),
(106, 'Wireless Earbuds', 1, 150.00, 100),
(107, 'Blender X', 3, 120.00, 60),
(108, 'T-Shirt Casual', 4, 20.00, 300);

INSERT INTO Customers VALUES
(1, 'Alice Wonderland', 'alice@example.com', '2023-01-10'),
(2, 'Bob the Builder', 'bob@example.com', '2022-11-25'),
(3, 'Charlie Chaplin', 'charlie@example.com', '2023-03-01'),
(4, 'Diana Prince', 'diana@example.com', '2021-04-26');

INSERT INTO Orders VALUES
(1001, 1, '2023-04-26', 1245.50),
(1002, 2, '2023-10-12', 99.99),
(1003, 1, '2023-07-01', 145.00),
(1004, 3, '2023-01-14', 150.00),
(1005, 2, '2023-09-24', 120.00),
(1006, 1, '2023-06-19', 20.00);


#Question 7 : Generate a report showing CustomerName, Email, and the
#TotalNumberofOrders for each customer. Include customers who have not placed
#any orders, in which case their TotalNumberofOrders should be 0. Order the results
#by CustomerName.

SELECT 
    c.CustomerName,
    c.Email,
    COUNT(o.OrderID) AS TotalNumberOfOrders
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.Email
ORDER BY c.CustomerName;


#Question 8 : Retrieve Product Information with Category: Write a SQL query to
#display the ProductName, Price, StockQuantity, and CategoryName for all
#products. Order the results by CategoryName and then ProductName alphabetically.

SELECT 
    p.ProductName,
    p.Price,
    p.StockQuantity,
    c.CategoryName
FROM Products p
INNER JOIN Categories c
ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName, p.ProductName;


#Question 9 : Write a SQL query that uses a Common Table Expression (CTE) and a
#Window Function (specifically ROW_NUMBER() or RANK()) to display the
#CategoryName, ProductName, and Price for the top 2 most expensive products in
#each CategoryName.

WITH RankedProducts AS (
    SELECT 
        c.CategoryName,
        p.ProductName,
        p.Price,
        ROW_NUMBER() OVER (
            PARTITION BY c.CategoryName 
            ORDER BY p.Price DESC
        ) AS PriceRank
    FROM Products p
    JOIN Categories c
    ON p.CategoryID = c.CategoryID
)
SELECT CategoryName, ProductName, Price
FROM RankedProducts
WHERE PriceRank <= 2;


#Question 10 : You are hired as a data analyst by Sakila Video Rentals, a global movie
#rental company. The management team is looking to improve decision-making by
#analyzing existing customer, rental, and inventory data.

#1. Top 5 Customers by Total Spending
#SELECT 
#    c.first_name,
#    c.last_name,
#    c.email,
#    SUM(p.amount) AS TotalSpent
#FROM customer c
#JOIN payment p
#ON c.customer_id = p.customer_id
#GROUP BY c.customer_id
#ORDER BY TotalSpent DESC
#LIMIT 5;
#Explanation: Payments are aggregated per customer to identify the top spenders.

#2. Top 3 Movie Categories by Rental Count
#SELECT 
#    cat.name AS CategoryName,
#    COUNT(r.rental_id) AS RentalCount
#FROM category cat
#JOIN film_category fc ON cat.category_id = fc.category_id
#JOIN inventory i ON fc.film_id = i.film_id
#JOIN rental r ON i.inventory_id = r.inventory_id
#GROUP BY cat.name
#ORDER BY RentalCount DESC
#LIMIT 3;

#3. Films Available vs Never Rented per Store
#SELECT 
#    s.store_id,
#    COUNT(i.inventory_id) AS TotalFilms,
#    SUM(CASE WHEN r.rental_id IS NULL THEN 1 ELSE 0 END) AS NeverRented
#FROM store s
#JOIN inventory i ON s.store_id = i.store_id
#LEFT JOIN rental r ON i.inventory_id = r.inventory_id
#GROUP BY s.store_id;

#4. Monthly Revenue for 2023
#SELECT 
#    MONTH(payment_date) AS Month,
#    SUM(amount) AS TotalRevenue
#FROM payment
#WHERE YEAR(payment_date) = 2023
#GROUP BY MONTH(payment_date)
#ORDER BY Month;

#5. Customers Renting More Than 10 Times in Last 6 Months
#SELECT 
#    c.customer_id,
#    c.first_name,
#    c.last_name,
#    COUNT(r.rental_id) AS RentalCount
#FROM customer c
#JOIN rental r ON c.customer_id = r.customer_id
#WHERE r.rental_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
#GROUP BY c.customer_id
#HAVING COUNT(r.rental_id) > 10;


 











