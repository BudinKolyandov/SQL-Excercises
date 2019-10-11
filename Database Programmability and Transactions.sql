/*
    Problem 1. Employees with Salary Above 35000
*/

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName
FROM Employees
WHERE Salary > '35000'

/*
    Problem 2. Employees with Salary Above Number
*/

CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@param AS DECIMAL(18,4)) 
AS
SELECT FirstName, LastName
FROM Employees
WHERE Salary >= @param

/*
    Problem 3. Town Names Starting With
*/

CREATE PROCEDURE usp_GetTownsStartingWith(@param AS VARCHAR(10)) 
AS
SELECT Name
FROM Towns
WHERE Name LIKE @param + '%'

/*
    Problem 4. Employees from Town
*/

CREATE PROCEDURE usp_GetEmployeesFromTown (@param AS VARCHAR(50)) 
AS
SELECT FirstName, LastName
FROM Employees AS e
JOIN Addresses a ON e.AddressID = a.AddressID
JOIN Towns t ON a.TownID = t.TownID
WHERE t.Name = @param
