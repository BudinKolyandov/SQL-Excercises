/*
    Problem 1. DDL
*/

CREATE TABLE Students(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	MiddleName NVARCHAR(25),
	LastName NVARCHAR(30) NOT NULL,
	Age INT NOT NULL CHECK(Age >0),
	Address NVARCHAR(50),
	Phone NCHAR(10)
);

CREATE TABLE Subjects(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(20) NOT NULL,
	Lessons INT NOT NULL CHECK(Lessons >0)
);

CREATE TABLE StudentsSubjects(
	Id INT PRIMARY KEY IDENTITY,
	StudentId INT FOREIGN KEY REFERENCES Students(Id),
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id),
	Grade DECIMAL (12,2) CHECK (Grade >=2 AND Grade <= 6)
);

CREATE TABLE Exams(
	Id INT PRIMARY KEY IDENTITY,
	Date DATETIME,
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id)
);

CREATE TABLE StudentsExams(
	StudentId INT FOREIGN KEY REFERENCES Students(Id),
	ExamId INT FOREIGN KEY REFERENCES Exams(Id),
	Grade DECIMAL (12,2) CHECK (Grade >=2 AND Grade <= 6),
	PRIMARY KEY (StudentId, ExamId)
);

CREATE TABLE Teachers(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	Address NVARCHAR(20) NOT NULL,
	Phone CHAR(10),
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id)
);

CREATE TABLE StudentsTeachers(
	StudentId INT FOREIGN KEY REFERENCES Students(Id),
	TeacherId INT FOREIGN KEY REFERENCES Teachers(Id),
	PRIMARY KEY (StudentId, TeacherId)
);

/*
    Problem 2. Insert
*/

INSERT INTO Teachers (FirstName, LastName, Address, Phone, SubjectId) VALUES
('Ruthanne', 'Bamb', '84948 Mesta Junction', '3105500146', '6'),
('Gerrard', 'Lowin', '370 Talisman Plaza', '3324874824', '2'),
('Merrile', 'Lambdin', '81 Dahle Plaza', '4373065154', '5'),
('Bert', 'Ivie', '2 Gateway Circle', '4409584510', '4');

INSERT INTO Subjects(Name, Lessons) VALUES
('Geometry', '12'),
('Health', '10'),
('Drama', '7'),
('Sports', '9');

/*
    Problem 3. Update
*/

UPDATE StudentsSubjects
SET Grade = 6.00
WHERE Grade >= 5.50 AND SubjectId IN (1,2)

/*
    Problem 4. Delete
*/

DELETE FROM StudentsTeachers
WHERE TeacherId IN (SELECT Id FROM Teachers WHERE Phone LIKE '%72%')

DELETE FROM Teachers 
WHERE Phone LIKE '%72%'

/*
    Problem 5. Teen Students
*/

SELECT FirstName, LastName, Age
FROM Students
WHERE Age >= 12
ORDER BY FirstName, LastName

/*
    Problem 6. Students Teachers
*/

SELECT FirstName, LastName, COUNT(st.TeacherId) AS [TeachersCount]
FROM Students AS s
JOIN StudentsTeachers AS st ON st.StudentId = s.Id
GROUP BY FirstName, LastName

/*
    Problem 7. Students to Go
*/

SELECT CONCAT(s.FirstName, ' ', s.LastName) AS [Full Name]
FROM Students AS s
LEFT JOIN StudentsExams AS se ON se.StudentId = s.Id
WHERE se.ExamId IS NULL
ORDER BY [Full Name]

/*
    Problem 8. Top Students
*/

SELECT TOP(10) s.FirstName, s.LastName, CAST(AVG(se.Grade) AS DECIMAL(3,2)) AS [Grade]
FROM Students AS s
JOIN StudentsExams AS se ON se.StudentId = s.Id
GROUP BY s.FirstName, s.LastName
ORDER BY [Grade] DESC, s.FirstName, s.LastName

/*
    Problem 9. Not So In The Studying
*/

SELECT CONCAT(s.FirstName,' ' , s.MiddleName + ' ', s.LastName) AS [Full Name]
FROM Students AS s
LEFT JOIN StudentsSubjects AS ss ON ss.StudentId = s.Id
WHERE ss.Id IS NULL
ORDER BY [Full Name]
								      
/*
    Problem 10. Average Grade per Subject
*/
								      
SELECT s.Name, AVG(ss.Grade) AS [Grade]
FROM StudentsSubjects AS ss
JOIN Subjects AS s ON s.Id = ss.SubjectId
GROUP BY s.Name, s.Id
ORDER BY s.Id
								      
/*
    Problem 11. Exam Grades
*/
								      
CREATE FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(3,2))
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @currentId INT = (SELECT TOP(1) Id
							  FROM Students
							  WHERE Id = @studentId)
	IF(@currentId IS NULL)
	BEGIN
		RETURN 'The student with provided id does not exist in the school!';
	END
	IF(@grade > 6.00)
	BEGIN
		RETURN 'Grade cannot be above 6.00!';
	END

	DECLARE @studentFirstName VARCHAR(30) = (SELECT TOP(1) FirstName
											FROM Students 
											WHERE Id = @studentId);
	
	DECLARE @gradePlusPointFifty DECIMAL(3,2) = @grade + 0.50;
	DECLARE @count INT = (SELECT COUNT(Grade)
						  FROM StudentsExams
						  WHERE StudentId = @studentId AND Grade >= @grade AND Grade<=@gradePlusPointFifty);
	RETURN ('You have to update ' + CAST(@count AS NVARCHAR(10)) + ' grades for the student '+ @studentFirstName)

END								      
								      
/*
    Problem 12. Exclude From School
*/
					     
CREATE PROC usp_ExcludeFromSchool(@StudentId INT)
AS
BEGIN
	DECLARE @currentId INT = (SELECT TOP(1) Id
							  FROM Students
							  WHERE Id = @studentId)
	IF (@currentId IS NULL)
	BEGIN
		RAISERROR ('This school has no student with the provided id!', 16, 1)
	END

	DELETE FROM StudentsExams
	WHERE StudentId = @StudentId;

	DELETE FROM StudentsSubjects
	WHERE StudentId = @StudentId;

	DELETE FROM StudentsTeachers
	WHERE StudentId = @StudentId;

	DELETE FROM Students
	WHERE Id = @StudentId;
END
