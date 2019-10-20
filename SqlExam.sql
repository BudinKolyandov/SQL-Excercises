/*
    Problem 1. DDL
*/

CREATE DATABASE Service

USE Service

GO

CREATE TABLE Users(
	Id INT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(50) NOT NULL,
	[Name] VARCHAR(50),
	Birthdate DATETIME,
	Age INT CHECK (Age >= 14 AND Age <= 110),
	Email VARCHAR(50) NOT NULL
);

CREATE TABLE Departments(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
);

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(25),
	LastName VARCHAR(25) ,
	Birthdate DATETIME,
	Age INT CHECK (Age >= 18 AND Age <= 110),
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL
);


CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)	NOT NULL
);


CREATE TABLE Status(
	Id INT PRIMARY KEY IDENTITY,
	Label VARCHAR(30) NOT NULL
);

CREATE TABLE Reports(
	Id INT PRIMARY KEY IDENTITY,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	StatusId INT FOREIGN KEY REFERENCES Status(Id) NOT NULL,
	OpenDate DATETIME NOT NULL,
	CloseDate DATETIME,
	[Description] VARCHAR(200) NOT NULL,
	UserId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id)
);

/*
    Problem 2. Insert
*/

INSERT INTO Employees (FirstName, LastName, Birthdate, DepartmentId) VALUES
('Marlo', 'O''Malley', '1958-9-21', 1 ),
('Niki', 'Stanaghan', '1969-11-26', 4),
('Ayrton', 'Senna', '1960-03-21',9),
('Ronnie', 'Peterson', '1944-02-14', 9),
('Giovanna', 'Amati', '1959-07-20', 5);

INSERT INTO Reports (CategoryId, StatusId, OpenDate, CloseDate, [Description], UserId, EmployeeId) VALUES
(1, 1, '2017-04-13', NULL, 'Stuck Road on Str.133', 6, 2),
(6, 3, '2015-09-05', '2015-12-06', 'Charity trail running', 3, 5),
(14, 2, '2015-09-07', NULL, 'Falling bricks on Str.58', 5, 2),
(4, 3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1, 1);

/*
    Problem 3. Update
*/

UPDATE Reports
SET CloseDate = GETDATE()
WHERE CloseDate IS NULL

/*
    Problem 4. Delete
*/

DELETE FROM Reports
WHERE StatusId = 4

DELETE FROM Status
WHERE Id = 4

/*
    Problem 5. Unassigned Reports
*/

SELECT Description, FORMAT(OpenDate, 'dd-MM-yyyy') AS [OpenDate]
FROM Reports
WHERE EmployeeId IS NULL
ORDER BY convert(datetime, OpenDate, 103), Description

/*
    Problem 6. Reports & Categories
*/

SELECT r.[Description], c.[Name]
FROM Reports AS r
JOIN Categories AS c ON c.Id = r.CategoryId
ORDER BY r.[Description], c.[Name]

/*
    Problem 7. Most Reported Category
*/

SELECT TOP(5) c.[Name], COUNT(c.Id) AS [ReportsNumber]
FROM Categories AS c
JOIN Reports as r ON r.CategoryId = c.Id
GROUP BY c.[Name]
ORDER BY [ReportsNumber] DESC, c.[Name]

/*
    Problem 8. Birthday Report
*/

SELECT u.Username, c.Name
FROM Reports AS r
JOIN Users AS u ON u.Id = r.UserId
LEFT JOIN Categories AS c ON c.Id = r.CategoryId
WHERE FORMAT(r.OpenDate, 'dd-MM') = FORMAT(u.Birthdate, 'dd-MM')
ORDER BY u.Username, c.Name

/*
    Problem 9. User per Employee
*/

SELECT CONCAT(e.FirstName, ' ', e.LastName) AS [FullName], COUNT(u.Id) AS [UsersCount]
FROM Employees AS e
LEFT JOIN Reports AS r ON r.EmployeeId = e.Id
LEFT JOIN Users AS u ON u.Id = r.UserId
GROUP BY CONCAT(e.FirstName, ' ', e.LastName)
ORDER BY [UsersCount] DESC, [FullName]

/*
    Problem 10. Full Info
*/

SELECT ISNULL((e.FirstName + ' ' + e.LastName), 'None') AS [Employee],
	   ISNULL(d.[Name], 'None') AS [Department],
	   ISNULL(c.[Name], 'None') AS [Category],
	   ISNULL(r.[Description], 'None') AS [Description],
	   FORMAT(r.OpenDate, 'dd.MM.yyyy') AS [OpenDate],
	   ISNULL(s.Label, 'None') AS [Status],
	   ISNULL(u.[Name], 'None') AS [User]
FROM Reports AS r
LEFT JOIN Employees AS e ON e.Id = r.EmployeeId
LEFT JOIN Departments AS d ON d.Id = e.DepartmentId
LEFT JOIN Categories AS c ON c.Id = r.CategoryId
LEFT JOIN Status AS s ON s.Id = r.StatusId
LEFT JOIN Users AS u ON u.Id = r.UserId
ORDER BY e.FirstName DESC,
		 e.LastName DESC,
		 d.[Name], 
		 c.[Name],
		 r.[Description],
		 r.OpenDate,
		 s.Label,
		 u.[Name]

/*
    Problem 11. Hours to Complete
*/

GO

CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS
BEGIN
	IF(@StartDate = NULL)
	BEGIN 
		RETURN 0;
	END
	
	IF(@EndDate = NULL)
	BEGIN 
		RETURN 0;
	END

	RETURN DATEDIFF(hour, @startDate, @endDate);

END

GO

/*
    Problem 12. Assign Employee
*/

CREATE PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
AS
BEGIN
	
	DECLARE @employeeDepartmentId INT = (SELECT TOP(1) DepartmentId
										 FROM Employees
										 WHERE Id = @EmployeeId)
	DECLARE @reportDepartmentId INT = (SELECT TOP (1) c.DepartmentId
									   FROM Reports AS r
									   JOIN Categories AS c ON c.Id = r.CategoryId
									   WHERE r.Id = @ReportId)

	IF(@employeeDepartmentId != @reportDepartmentId)
	BEGIN
		RAISERROR('Employee doesn''t belong to the appropriate department!', 16, 2)
	END

	UPDATE Reports
	SET EmployeeId = @EmployeeId
	WHERE Id = @ReportId

END
