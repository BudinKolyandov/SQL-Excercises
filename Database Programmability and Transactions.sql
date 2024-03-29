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

/*
    Problem 5. Salary Level Function
*/
                                                             
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(10) AS 
BEGIN
		DECLARE @SalaryLevel VARCHAR(10)
		IF(@salary < 30000)
		BEGIN 
			SET @SalaryLevel = 'Low'
		END
		ELSE IF(@salary >= 30000 AND @salary <= 50000)
		BEGIN 
			SET @SalaryLevel = 'Average'
		END
		ELSE
		BEGIN
			SET @SalaryLevel = 'High'
		END
RETURN @SalaryLevel
END

/*
    Problem 6. Employees by Salary Level
*/
                                                   
CREATE PROCEDURE usp_EmployeesBySalaryLevel(@SalaryLevel VARCHAR(10))
AS SELECT FirstName, 
	      LastName
FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

/*
    Problem 7. Define Function
*/

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50)) 
RETURNS BIT
AS
BEGIN
DECLARE @currentIndex int = 1;

WHILE(@currentIndex <= LEN(@word))
	BEGIN
	DECLARE @currentLetter varchar(1) = SUBSTRING(@word, @currentIndex, 1);
	IF(CHARINDEX(@currentLetter, @setOfLetters)) = 0
	BEGIN
	RETURN 0;
	END
	SET @currentIndex += 1;
	END
RETURN 1;
END
                 
/*
    Problem 8. Delete Employees and Departments
*/
                 
CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT) 
AS
DECLARE @empIDsToBeDeleted TABLE
(
Id int
)

INSERT INTO @empIDsToBeDeleted
SELECT e.EmployeeID
FROM Employees AS e
WHERE e.DepartmentID = @departmentId

ALTER TABLE Departments
ALTER COLUMN ManagerID int NULL 

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT Id from @empIDsToBeDeleted)

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id from @empIDsToBeDeleted)

UPDATE Departments
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id from @empIDsToBeDeleted)

DELETE FROM Employees
WHERE EmployeeID IN (SELECT Id from @empIDsToBeDeleted)

DELETE FROM Departments
WHERE DepartmentID = @departmentId

SELECT COUNT(*) AS [Employees]
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE e.DepartmentID = @departmentId
                 
/*
    Problem 9. Find Full Name
*/
                 
CREATE PROCEDURE usp_GetHoldersFullName
AS
SELECT FirstName + ' ' + LastName AS [Full Name]
FROM AccountHolders
                 
/*
    Problem 10. People with Balance Higher Than
*/
                 
CREATE PROC usp_GetHoldersWithBalanceHigherThan(@number DECIMAL(19,4)) AS 
SELECT FirstName,LastName
  FROM AccountHolders AS ah
  JOIN Accounts AS a ON ah.Id=a.AccountHolderId
 GROUP BY ah.Id, FirstName,LastName
 HAVING SUM (a.Balance) > @number
 ORDER BY ah.FirstName, ah.LastName
                                                                
/*
    Problem 11. Future Value Function
*/
                                                                
CREATE FUNCTION ufn_CalculateFutureValue(@Sum MONEY, @Rate FLOAT , @Years INT)
RETURNS MONEY
AS
BEGIN
	RETURN @Sum * POWER(1+@Rate,@Years)
END
                                                                
/*
    Problem 12. Calculating Interest
*/
                                                                
CREATE PROCEDURE usp_CalculateFutureValueForAccount(@AccountId INT, @InterestRate FLOAT)
AS
SELECT 
	a.Id AS [Account Id],
	ah.FirstName AS [First Name],
	ah.LastName AS [Last Name],
	a.Balance,
	dbo.ufn_CalculateFutureValue(Balance, @InterestRate, 5) AS [Balance in 5 years]
FROM AccountHolders AS ah
JOIN Accounts AS a ON ah.Id = a.Id
WHERE a.Id = @AccountId

/*
    Problem 13. Cash in User Games Odd Rows
*/
                                                                
CREATE FUNCTION ufn_CashInUsersGames(@gameName varchar(max))
RETURNS @returnedTable TABLE
(
SumCash money
)
AS
BEGIN
	DECLARE @result money
	SET @result = 
	(SELECT SUM(ug.Cash) AS Cash
	FROM
		(SELECT Cash, GameId, ROW_NUMBER() OVER (ORDER BY Cash DESC) AS RowNumber
		FROM UsersGames
		WHERE GameId = (SELECT Id FROM Games WHERE Name = @gameName)
		) AS ug
	WHERE ug.RowNumber % 2 != 0
	)

	INSERT INTO @returnedTable SELECT @result
	RETURN
END
                                                       
/*
    Problem 14. Create Table Logs
*/

CREATE TABLE Logs(
	LogID INT NOT NULL IDENTITY,
	AccountID INT FOREIGN KEY REFERENCES Accounts(Id),
	OldSum MONEY,
	NewSum MONEY
)

GO
                                                       
CREATE TRIGGER tr_BallanceChange ON Accounts
AFTER UPDATE
AS
BEGIN 
INSERT INTO Logs(AccountID, OldSum, NewSum)
SELECT i.Id, d.Balance, i.Balance
FROM inserted AS i
INNER JOIN deleted as d ON i.Id =d.Id
END
                                                       
/*
    Problem 15. Create Table Emails
*/

CREATE TABLE NotificationEmails
(
 Id INT NOT NULL IDENTITY,
 Recipient INT FOREIGN KEY REFERENCES Accounts(Id),
 [Subject] VARCHAR(50),
 Body TEXT
)

GO
                                                       
CREATE TRIGGER tr_EmailsNotifications
ON Logs AFTER INSERT 
AS
BEGIN
INSERT INTO NotificationEmails(Recipient,Subject,Body)
SELECT i.AccountID, 
CONCAT('Balance change for account: ',i.AccountId),
CONCAT('On ',GETDATE(),' your balance was changed from ',i.NewSum,' to ',i.OldSum)
  FROM inserted AS i
END 

/*
    Problem 16. Deposit Money
*/
						       
CREATE PROCEDURE usp_DepositMoney (@AccountId INT, @MoneyAmount MONEY)
AS
	BEGIN
	IF (@MoneyAmount < 0)
		BEGIN 
		RAISERROR('You can not deposit negative sum', 16, 1);
	END;
	ELSE
		BEGIN 
		IF(@AccountId IS NULL OR @MoneyAmount IS NULL)
			BEGIN
            RAISERROR('Missing value', 16, 1);
		END;
	END;
	BEGIN TRANSACTION;
	UPDATE Accounts
		SET Balance +=@MoneyAmount
		WHERE Id = @AccountId;
		IF(@@ROWCOUNT < 1)
			BEGIN
                 ROLLBACK;
                 RAISERROR('Account doesn''t exists', 16, 1);
        END;
	COMMIT;
END;
						  
/*
    Problem 17. Withdraw Money Procedure
*/
						       
CREATE PROCEDURE usp_WithdrawMoney (@AccountId INT, @MoneyAmount MONEY)
AS
	BEGIN
	IF (@MoneyAmount < 0)
		BEGIN 
		RAISERROR('You can not withdraw negative sum', 16, 1);
	END;
	ELSE
		BEGIN 
		IF(@AccountId IS NULL OR @MoneyAmount IS NULL)
			BEGIN
            RAISERROR('Missing value', 16, 1);
		END;
	END;
	BEGIN TRANSACTION;
	UPDATE Accounts
		SET Balance -=@MoneyAmount
		WHERE Id = @AccountId;
		IF(@@ROWCOUNT < 1)
			BEGIN
                 ROLLBACK;
                 RAISERROR('Account doesn''t exists', 16, 1);
        END;
		IF (0 > (SELECT Balance
                 FROM Accounts
                 WHERE Id = @accountId))
		BEGIN
			ROLLBACK;
			RAISERROR('Balance is not enough', 16, 1);
            END;
	COMMIT;
END;
			 
/*
    Problem 18. Money Transfer
*/
			 
CREATE PROCEDURE usp_TransferMoney(@senderId INT, @receiverId INT, @amount MONEY)
AS
     BEGIN
         IF(@amount < 0)
             BEGIN
                 RAISERROR('Can''t transfer negative amount', 16, 1);
         END;
             ELSE
             BEGIN
                 IF(@senderId IS NULL
                    OR @receiverId IS NULL
                    OR @amount IS NULL)
                     BEGIN
                         RAISERROR('Missing value', 16, 1);
                 END;
         END;

         BEGIN TRANSACTION;
         UPDATE Accounts
           SET
               Balance-=@amount
         WHERE Id = @senderId;
         IF(@@ROWCOUNT < 1)
             BEGIN
                 ROLLBACK;
                 RAISERROR('Sender''s account doesn''t exists', 16, 1);
         END;

         IF(0 >
           (
               SELECT Balance
               FROM Accounts
               WHERE ID = @senderId
           ))
             BEGIN
                 ROLLBACK;
                 RAISERROR('You need more money for that transaction', 16, 1);
         END;

         UPDATE Accounts
           SET
               Balance+=@amount
         WHERE ID = @receiverId;
         IF(@@ROWCOUNT < 1)
             BEGIN
                 ROLLBACK;
                 RAISERROR('Receiver''s account doesn''t exists', 16, 1);
         END;
         COMMIT;
     END;
		   
/*
    Problem 21. Employees with Three Projects
*/
		   
CREATE PROCEDURE usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
     BEGIN
         BEGIN TRANSACTION;
         INSERT INTO EmployeesProjects(EmployeeID, ProjectID)
         VALUES (@emloyeeId, @projectID);
         IF(
           (
               SELECT COUNT(EmployeeID)
               FROM EmployeesProjects
               WHERE EmployeeID = @emloyeeId
           ) > 3)
             BEGIN
                 ROLLBACK;
                 RAISERROR('The employee has too many projects!', 16, 1);
         END;
         COMMIT;
     END;
		   
/*
    Problem 22. Delete Employees
*/		   
		   
CREATE TABLE Deleted_Employees
(
             EmployeeId   INT IDENTITY PRIMARY KEY,
             FirstName    NVARCHAR(50),
             LastName     NVARCHAR(50),
             MiddleName   NVARCHAR(50),
             JobTitle     NVARCHAR(50),
             DepartmentId INT FOREIGN KEY(DepartmentId) REFERENCES Departments(DepartmentId),
             Salary       DECIMAL(15, 2)             
);
GO

CREATE TRIGGER tr_DeletedEmployeesSaver ON Employees
AFTER DELETE
AS
     BEGIN
         INSERT INTO Deleted_Employees
                SELECT FirstName,
                       LastName,
                       MiddleName,
                       JobTitle,
                       DepartmentID,
                       Salary
                FROM deleted;
     END;
	   
