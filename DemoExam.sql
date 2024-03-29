/*
    Problem 1. DDL
*/

CREATE DATABASE Bitbucket

USE Bitbucket

CREATE TABLE Users(
	Id INT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(30) NOT NULL,
	Email VARCHAR(50) NOT NULL
);

CREATE TABLE Repositories(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL
);

CREATE TABLE RepositoriesContributors(
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id),
	ContributorId INT FOREIGN KEY REFERENCES Users(Id)
	PRIMARY KEY (RepositoryId, ContributorId)
);

CREATE TABLE Issues(
	Id INT PRIMARY KEY IDENTITY,
	Title VARCHAR(255) NOT NULL,
	IssueStatus CHAR(6) NOT NULL,
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id),
	AssigneeId INT FOREIGN KEY REFERENCES Users(Id)
);

CREATE TABLE Commits(
	Id INT PRIMARY KEY IDENTITY,
	[Message] VARCHAR(255) NOT NULL,
	IssueId INT FOREIGN KEY REFERENCES Issues(Id),
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id),
	ContributorId INT FOREIGN KEY REFERENCES Users(Id)
);

CREATE TABLE Files(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	Size DECIMAL(18,2) NOT NULL,
	ParentId INT FOREIGN KEY REFERENCES Files(Id),
	CommitId INT FOREIGN KEY REFERENCES Commits(Id)
);

/*
    Problem 2. Insert
*/

INSERT INTO Files(Name, Size, ParentId, CommitId) VALUES
('Trade.idk', '2598.0', 1, 1),
('menu.net', '9238.3', 2, 2),
('Administrate.soshy', '1246.93', 3, 3),
('Controller.php', '7353.15', 4, 4),
('Find.java', '9957.86', 5, 5),
('Controller.json', '14034.87', 3, 6),
('Operate.xix', '7662.92', 7, 7);

INSERT INTO Issues (Title, IssueStatus, RepositoryId, AssigneeId) VALUES
('Critical Problem with HomeController.cs file', 'open', 1, 4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs', 'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9, 8);

/*
    Problem 3. Update
*/

UPDATE Issues
SET IssueStatus = 'closed'
WHERE AssigneeId = 6

/*
    Problem 4. Delete
*/

DELETE FROM Issues
WHERE RepositoryId = (SELECT Id
			FROM Repositories 
			WHERE Name = 'Softuni-Teamwork')

DELETE FROM RepositoriesContributors
WHERE RepositoryId = (SELECT Id
			FROM Repositories 
			WHERE Name = 'Softuni-Teamwork');

/*
    Problem 5. Commits
*/

SELECT Id, [Message], [RepositoryId], ContributorId
FROM Commits
ORDER BY Id, [Message], [RepositoryId], ContributorId

/*
    Problem 6. Heavy HTML
*/

SELECT Id, [Name], Size
FROM Files
WHERE Size > 1000 AND [Name] LIKE '%html%'
ORDER BY Size DESC, Id, [Name]

/*
    Problem 7. Issues and Users
*/

SELECT i.Id, CONCAT(u.Username, ' : ', i.Title) AS [IssueAssignee]
FROM Issues AS i
JOIN Users as u ON u.Id = i.AssigneeId
ORDER BY i.Id DESC, IssueAssignee

/*
    Problem 8. Non-Directory Files
*/

SELECT f.Id, f.Name, CONCAT(f.Size,'KB') AS [Size]
FROM Files AS f
LEFT JOIN Files AS jf ON jf.ParentId = f.Id
WHERE jf.ParentId IS NULL
ORDER BY f.Id, f.Name, [Size] DESC

/*
    Problem 9. Most Contributed Repositories
*/

SELECT TOP(5) r.Id, r.Name, COUNT(c.RepositoryId) AS [Commits]
FROM Repositories AS r
JOIN Commits AS c ON c.RepositoryId = r.Id
LEFT JOIN RepositoriesContributors AS rc ON r.Id = rc.RepositoryId
GROUP BY r.Id, r.Name
ORDER BY [Commits] DESC, r.Id, r.[Name]

/*
    Problem 10. User and Files
*/

SELECT U.Username, AVG(f.Size) AS [Size]
FROM Users AS u
JOIN Commits AS c ON c.ContributorId = u.Id
JOIN Files AS f ON f.CommitId = c.Id
GROUP BY u.Username
ORDER BY [Size] DESC, u.Username

/*
    Problem 11. User Total Commits
*/

CREATE FUNCTION udf_UserTotalCommits(@username VARCHAR(30))
RETURNS INT
AS
BEGIN

DECLARE @userId INT = (SELECT TOP (1)Id 
					   FROM Users 
					   WHERE Username = @username);
DECLARE @result INT = (SELECT COUNT(c.RepositoryId)
					   FROM Repositories AS r
					   JOIN Commits AS c ON c.RepositoryId = r.Id
                       WHERE c.ContributorId = @userId) 
RETURN @result
END	
