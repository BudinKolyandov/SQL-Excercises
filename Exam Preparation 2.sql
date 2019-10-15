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

