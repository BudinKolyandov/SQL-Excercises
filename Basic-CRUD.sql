/*
    Problem 1. Find All Information About Departments
*/

SELECT * FROM Departments

/*
    Problem 2. Find all Department Names
*/

SELECT Name FROM Departments

/*
    Problem 3. Find Salary of Each Employee
*/

SELECT FirstName, LastName, Salary 
FROM Employees

/*
    Problem 4. Find Full Name of Each Employee
*/

SELECT FirstName, MiddleName,LastName
FROM Employees

/*
    Problem 5. Find Email Address of Each Employee
*/

SELECT FirstName + '.' + Lastname + '@softuni.bg' AS 'Full Email Address'
FROM Employees; 

/*
    Problem 6. Find All Different Employee’s Salaries
*/

SELECT DISTINCT Salary
FROM Employees

/*
    Problem 7. Find all Information About Employees
*/

SELECT * FROM Employees
WHERE JobTitle ='Sales Representative';

/*
    Problem 8. Find Names of All Employees by Salary in Range
*/

SELECT FirstName, LastName, JobTitle 
FROM Employees
WHERE Salary BETWEEN 20000 AND 30000;

/*
    Problem 9. Find Names of All Employees
*/

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS 'Full Name'
FROM Employees
WHERE Salary IN ('25000', '14000', '12500', '23600');

/*
    Problem 10. Find All Employees Without Manager
*/

SELECT FirstName, LastName
FROM Employees
WHERE ManagerId IS NULL

/*
    Problem 11. Find All Employees with Salary More Than
*/

SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC;

/*
    Problem 12. Find 5 Best Paid Employees
*/

SELECT TOP (5) FirstName, LastName
FROM Employees
ORDER BY Salary DESC;

/*
    Problem 13. Find All Employees Except Marketing
*/

SELECT FirstName, LastName
FROM Employees
WHERE DepartmentId <> 4

/*
    Problem 14. Sort Employees Table
*/

SELECT *
FROM Employees
ORDER BY Salary DESC, FirstName ASC, LastName DESC, MiddleName ASC; 

/*
    Problem 15. Create View Employees with Salaries
*/

CREATE VIEW V_EmployeesSalaries
AS
     SELECT FirstName,
            LastName,
            Salary
     FROM Employees;
     
GO

SELECT *
FROM V_EmployeesSalaries;

/*
    Problem 16. Create View Employees with Job Titles
*/

CREATE VIEW V_EmployeeNameJobTitle 
AS
     SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS 'Full Name', 
	 JobTitle AS 'Job Title'
	 FROM Employees
   
/*
    Problem 17. Distinct Job Titles
*/

SELECT DISTINCT JobTitle
FROM Employees

/*
    Problem 18. Find First 10 Started Projects
*/

SELECT TOP(10) *
FROM Projects
ORDER BY StartDate,
		[Name];
    
/*
    Problem 19. Last 7 Hired Employees
*/

SELECT TOP(7) FirstName, LastName, HireDate
FROM Employees
ORDER BY HireDate DESC

/*
    Problem 20. Increase Salaries
*/


DECLARE @EngineeringID INT;

DECLARE @ToolDesignID INT;

DECLARE @MarketingID INT;

DECLARE @InformationServicesID INT;

SELECT TOP (1) @EngineeringID = DepartmentID
FROM Departments
WHERE [Name] = 'Engineering';

SELECT TOP (1) @ToolDesignID = DepartmentID
FROM Departments
WHERE [Name] = 'Tool Design';

SELECT TOP (1) @MarketingID = DepartmentID
FROM Departments
WHERE [Name] = 'Marketing';

SELECT TOP (1) @InformationServicesID = DepartmentID
FROM Departments
WHERE [Name] = 'Information Services';

UPDATE Employees
  SET
      Salary *= 1.12
WHERE DepartmentID IN(@EngineeringID, @ToolDesignID, @MarketingID, @InformationServicesID);

SELECT Salary
FROM Employees;

/*
    Problem 21. All Mountain Peaks
*/

SELECT PeakName
FROM Peaks
ORDER BY PeakName

/*
    Problem 22. Biggest Countries by Population
*/

SELECT TOP(30) CountryName, Population
FROM Countries
WHERE ContinentCode ='EU'
ORDER BY Population DESC,
		[CountryName];

/*
    Problem 23. Countries and Currency (Euro / Not Euro)
*/

SELECT CountryName,
       CountryCode,
       CASE CurrencyCode
           WHEN 'EUR'
           THEN 'Euro'
           ELSE 'Not Euro'
       END AS 'Currency'
FROM Countries
ORDER BY CountryName;

/*
    Problem 24. All Diablo Characters
*/

SELECT Name
FROM Characters
ORDER BY Name;
