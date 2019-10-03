/*
    Problem 1. Records’ Count
*/

SELECT COUNT(*) AS Count 
FROM WizzardDeposits;
  
/*
    Problem 2. Longest Magic Wand
*/

SELECT MAX(MagicWandSize) AS LongestMagicWand 
FROM WizzardDeposits;

/*
    Problem 3. Longest Magic Wand per Deposit Groups
*/

SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand 
FROM WizzardDeposits
GROUP BY DepositGroup;

/*
    Problem 4. Smallest Deposit Group per Magic Wand Size
*/

SELECT TOP(2) DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize);

/*
    Problem 5. Deposits Sum
*/

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup;

/*
    Problem 6. Deposits Sum for Ollivander Family
*/

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander Family'
GROUP BY DepositGroup;

/*
    Problem 7. Deposits Filter
*/

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander Family'
GROUP BY DepositGroup
HAVING SUM (DepositAmount) < 150000
ORDER BY TotalSum DESC;

/*
    Problem 8. Deposit Charge
*/

SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup;

/*
    Problem 9. Age Groups
*/

SELECT *, COUNT(*) AS WizardCount FROM
(
SELECT
	CASE 
		WHEN Age <= 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		ELSE '[61+]'
	END AS AgeGroup 
	FROM WizzardDeposits
)AS t
GROUP BY AgeGroup
ORDER BY AgeGroup

/*
    Problem 10. First Letter
*/

SELECT LEFT (FirstName, 1) AS FirstLetter 
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT (FirstName, 1)

/*
    Problem 11. Average Interest
*/

SELECT DepositGroup, 
IsDepositExpired, 
AVG (DepositInterest)
FROM WizzardDeposits
WHERE DATEPART(YEAR, DepositStartDate) >= 1985
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

/*
    Problem 12. Rich Wizard, Poor Wizard
*/

SELECT SUM(Difference) 
FROM(
SELECT Wizzard1.FirstName AS [Host Wizzard], Wizzard1.DepositAmount AS[Host Wizard Deposit],
	   Wizzard2.FirstName AS [Guest Wizzard], Wizzard2.DepositAmount AS[Guest Wizard Deposit],
	   Wizzard1.DepositAmount - Wizzard2.DepositAmount AS Difference
FROM WizzardDeposits AS Wizzard1
INNER JOIN WizzardDeposits AS Wizzard2
ON Wizzard1.Id = Wizzard2.Id-1) AS t

/*
    Problem 13. Departments Total Salaries
*/

SELECT DepartmentID, SUM(Salary) AS[TotalSalary]
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

/*
    Problem 14. Employees Minimum Salaries
*/

SELECT DepartmentID, MIN(Salary) AS MinimumSalary
FROM Employees
WHERE DATEPART(YEAR, HireDate) >= 2000
GROUP BY DepartmentID
HAVING DepartmentID IN (2,5,7)

/*
    Problem 15. Employees Average Salaries
*/

SELECT * INTO Average 
FROM Employees
WHERE Salary > 30000

DELETE FROM Average WHERE ManagerID = 42

UPDATE Average 
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS[AverageSalary]
FROM Average
GROUP BY DepartmentID

/*
    Problem 16. Employees Maximum Salaries
*/

SELECT DepartmentID, MAX(Salary) AS [MaxSalary]
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

/*
    Problem 17. Employees Count Salaries
*/

SELECT COUNT(Salary) AS [Count]
FROM Employees
WHERE ManagerID IS NULL


/*
    Problem 18. 3rd Highest Salary
*/

SELECT a.DepartmentId,
(
	SELECT DISTINCT b.Salary 
	FROM Employees AS b
	WHERE b.DepartmentID = a.DepartmentId
	ORDER BY Salary DESC
	OFFSET 2 ROWS
	FETCH NEXT 1 ROWS ONLY
) AS [ThirdHighestSalary]
FROM Employees AS a
WHERE (
	SELECT DISTINCT b.Salary 
	FROM Employees AS b
	WHERE b.DepartmentID = a.DepartmentId
	ORDER BY Salary DESC
	OFFSET 2 ROWS
	FETCH NEXT 1 ROWS ONLY
	) IS NOT NULL
GROUP BY a.DepartmentId


/*
    Problem 19. Salary Challenge
*/

SELECT TOP(10) FirstName, LastName, DepartmentID  
FROM Employees AS e
WHERE Salary >
		(
		SELECT AVG(Salary) FROM Employees AS e2
		WHERE e.DepartmentID = e2.DepartmentID
		)
ORDER BY DepartmentID
