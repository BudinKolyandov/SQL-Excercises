/*
    Problem 1.	Insert Records in Both Tables
*/

INSERT INTO Towns(Id, Name)
VALUES ('1', 'Sofia'), ('2', 'Plovdiv'), ('3', 'Varna');

INSERT INTO Minions (Id, Name, Age, TownId)
VALUES ('1', 'Kevin', '22', '1'), ('2',	'Bob',	'15', '3'), ('3', 'Steward', NULL, '2');

/*
    Problem 2.	Create Table People
*/

CREATE TABLE People(
	Id int IDENTITY PRIMARY KEY,
	Name NVARCHAR(200) NOT NULL,
	Picture VARBINARY(2000),
	Height FLOAT(2),
	Weight FLOAT(2),
	Gender CHAR NOT NULL CHECK(Gender ='m' OR Gender = 'f'),
	Birthdate DATE NOT NULL,
	Biography NVARCHAR(MAX)
);

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Pesho', Null, '1.80', '60.10', 'm', '2015-05-03', null),
	   ('Misho', Null, '1.90', '100.00', 'm','1992-09-07', null),
	   ('Maria', Null, '1.50', '45.80', 'f', '1992-09-07', null),
	   ('Vasko', Null, '1.75', '71.10', 'm', '1992-09-07', null),
	   ('Mincho', Null, '1.80', '60.10', 'm','1992-09-07', null)

/*
    Problem 3.	Create Table Users
*/

CREATE TABLE Users(
	Id int IDENTITY PRIMARY KEY,
	Username VARCHAR(30) NOT NULL UNIQUE,
	Password VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(900),	
	LastLoginTime DATE,
	IsDeleted BIT NOT NULL
);

INSERT INTO Users (Username, Password, ProfilePicture, LastLoginTime, IsDeleted)
VALUES ('Pesho',  '123548645613554', NULL, '2015-05-03', 'false'),
	   ('Misho',  '123548645613554', NULL, '1992-09-07', 'true'),
	   ('Maria',  '123548645613554', NULL, '1992-09-07', 'false'),
	   ('Vasko',  '123548645613554', NULL, '1992-09-07', 'false'),
	   ('Mincho', '123548645613554', NULL, '1992-09-07', 'false')

/*
    Problem 4.	Movies Database
*/

CREATE TABLE Directors(
	Id INT PRIMARY KEY IDENTITY,
	DirectorName varchar(200) NOT NULL,
	Notes VARCHAR(max)
);

CREATE TABLE Genres(
	Id INT PRIMARY KEY IDENTITY,
	GenreName varchar(200) NOT NULL,
	Notes VARCHAR(max)
);

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName varchar(200) NOT NULL,
	Notes VARCHAR(max)
);

CREATE TABLE Movies(
	Id INT PRIMARY KEY IDENTITY,
	Title varchar(200) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id) NOT NULL,
	CopyrightYear DATE,
	Length TIME,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Rating DECIMAL (3,2),
	Notes VARCHAR(max)
);

INSERT INTO Directors(DirectorName)
Values('Pesho'),
	('Gosho'),
	('Stefcho'),
	('Misho'),
	('Nedelcho');

INSERT INTO Genres(GenreName)
Values('Comedy'),
	('Action'),
	('Romantic'),
	('Comic-book'),
	('Sy-fi');

INSERT INTO Categories(CategoryName)
Values('Kids'),
	('Adults only'),
	('13+'),
	('16+'),
	('Everyone');

INSERT INTO Movies(Title, DirectorId, GenreId, CategoryId)
VALUES('Inception', '1', '4', '3'),
      ('Die Hard', '2', '2', '1'),
      ('Spider-man', '1', '3', '2'),
      ('The Matrix', '4', '1', '3'),
	  ('Rising star', '1', '4', '3');

/*
    Problem 5.	Car Rental Database
*/

CREATE TABLE Categories(
	Id int PRIMARY KEY IDENTITY,
	CategoryName VARCHAR(50) NOT NULL,
	DailyRate DECIMAL(4,2),
	WeeklyRate DECIMAL(4,2),
	MonthlyRate DECIMAL(4,2),
	WeekendRate DECIMAL(4,2),
);

CREATE TABLE Cars(
	Id INT PRIMARY KEY IDENTITY,
	PlateNumber VARCHAR(10) NOT NULL,
	Manufacturer VARCHAR(20),
	Model VARCHAR(20),
	CarYear DATE,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Doors INT,
	Picture VARBINARY,
	Condition VARCHAR(20),
	AVAILABLE BIT 
);

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20),
	Title VARCHAR(20),
	Notes VARCHAR(MAX)
);

CREATE TABLE Customers(
	Id INT PRIMARY KEY IDENTITY,
	DriverLicenceNumber VARCHAR(10)NOT NULL,
	FullName VARCHAR(30) NOT NULL,
	Adress VARCHAR(50),
	City VARCHAR(10),
	ZIPCode VARCHAR(10),
	Notes VARCHAR(MAX)
);


CREATE TABLE RentalOrders(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id),
	CarId INT FOREIGN KEY REFERENCES Cars(Id),
	TankLevel VARCHAR(10),
	KilometrageStart DECIMAL(10,2),
	KilometrageEnd DECIMAL(10,2),
	TotalKilometrage DECIMAL(10,2),
	StartDate DATE,
	EndDate DATE,
	TotalDays INT,
	RateApplied DECIMAL(4,2),
	TaxRate DECIMAL(4,2),
	OrderStatus VARCHAR(20),
	Notes VARCHAR(MAX)
);


INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES ('Economy', '22.50', '25.50', '80.50', '50.00'),
	   ('Busines', '50.50', '75.50', '10.50', '50.00'),
	   ('Luxury', '10.50', '50.50', '20.50', '75.00');
	  
	  
INSERT INTO Cars(PlateNumber, Manufacturer, Model)
VALUES ('SA1565KN', 'FORD', 'Fiesta'),
	   ('KN5824BB', 'McLarren', 'SLR'),
	   ('R8546SV', 'Mazda', '7');

INSERT INTO Employees(FirstName)
Values ('Pesho'),
	   ('Gossho'),
	   ('Ivo');

INSERT INTO Customers(DriverLicenceNumber, FullName)
VALUES ('45613216', 'Dimitar Spasov'),
	   ('4654464asd', 'Nedelcho Hristov'),
	   ('4654618464', 'Misho Mladenov');

INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TotalDays, RateApplied)
VALUES ('1', '1', '1', '2', '20.50'),
	   ('2', '2', '2', '8', '20.50'),
	   ('3', '3', '3', '5', '20.50');

/*
    Problem 6.	Hotel Database
*/

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(20),
	LastName VARCHAR(20),
	Title VARCHAR(20),
	Notes VARCHAR(MAX)
);

CREATE TABLE Customers (
	AccountNumber INT PRIMARY KEY,
	FirstName VARCHAR(20),
	LastName VARCHAR(20),
	PhoneNumber INT,
	EmergencyName VARCHAR(20),
	EmergencyNumber INT,
	Notes VARCHAR(MAX)
);

CREATE TABLE RoomStatus(
	RoomStatus VARCHAR(10) PRIMARY KEY,
	Notes VARCHAR(MAX)
);

CREATE TABLE RoomTypes(
	RoomType VARCHAR(10) PRIMARY KEY,
	Notes VARCHAR(MAX)
);

CREATE TABLE BedTypes(
	BedType VARCHAR(10) PRIMARY KEY,
	Notes VARCHAR(MAX)
);

CREATE TABLE Rooms(
	RoomNumber INT PRIMARY KEY IDENTITY,
	RoomType Varchar(10) FOREIGN KEY REFERENCES RoomTypes(RoomType),
	BedType Varchar(10) FOREIGN KEY REFERENCES BedTypes(BedType),
	Rate DECIMAL (3,2),
	RoomStatus Varchar(10) FOREIGN KEY REFERENCES RoomStatus(RoomStatus),
	Notes VARCHAR(MAX)
);

CREATE TABLE Payments(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	PaymentDate DATE,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
	FirstDateOccupied DATE,
	LastDateOccupied DATE,
	TotalDays INT,
	AmountCharged MONEY,
	TaxRate DECIMAL(4,2),
	TaxAmount DECIMAL(4,2),
	PaymentTotal Money,
	Notes VARCHAR(MAX)
);

CREATE TABLE Occupancies (
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	DateOccupied DATE,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
	RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber),
	RateApplied DECIMAL(4,2),
	PhoneCharge DECIMAL(4,2),
	Notes VARCHAR(MAX)
);

INSERT INTO Employees (FirstName, LastName)
VALUES ('Pesho', 'Nikolov'),
	   ('Misho', 'Nedelchev'),
	   ('Nedko', 'Spasimirov');

INSERT INTO Customers  (AccountNumber, FirstName, LastName)
VALUES ('123451', 'Pesho', 'Nikolov'),
	   ('131251', 'Misho', 'Nedelchev'),
	   ('1535451', 'Nedko', 'Spasimirov');


INSERT INTO RoomStatus (RoomStatus)
VALUES ('Available'),
	   ('Occupied'),
	   ('Broken')


INSERT INTO RoomTypes(RoomType)
VALUES ('Double'),
	   ('Single'),
	   ('Tripple')

INSERT INTO BedTypes (BedType)
VALUES ('Soft'),
	   ('Firm'),
	   ('Royal')

INSERT INTO Rooms(RoomType, BedType, RoomStatus)
VALUES ('Double', 'Royal', 'Occupied'),
	   ('Double', 'Soft', 'Available'),
	   ('Single', 'Firm', 'Available')


INSERT INTO Payments(EmployeeId, AccountNumber, TotalDays)
VALUES ('1', '123451', '5'),
	   ('2', '1535451', '1'),
	   ('3', '131251','9')


INSERT INTO Occupancies (EmployeeId, AccountNumber)
VALUES ('1', '123451'),
	   ('2', '1535451'),
	   ('3', '131251')

/*
    Problem 7.	Basic Select All Fields
*/

SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

/*
    Problem 8.	Basic Select All Fields and Order Them
*/

SELECT * FROM Towns
ORDER BY Name ASC

SELECT * FROM Departments
ORDER BY Name ASC

SELECT * FROM Employees
ORDER BY Salary DESC

/*
    Problem 9.	Basic Select Some Fields
*/

SELECT Name
FROM Towns
ORDER BY Name ASC

SELECT Name
FROM Departments
ORDER BY Name ASC

SELECT FirstName, LastName, JobTitle, Salary
FROM Employees
ORDER BY Salary DESC

/*
    Problem 10.	Increase Employees Salary
*/

UPDATE Employees 
SET Salary =  Salary + (Salary * 10.0 / 100.0)

SELECT Salary
FROM Employees

/*
    Problem 11.	Decrease Tax Rate
*/

UPDATE Payments 
SET TaxRate = TaxRate - (TaxRate * 3.0 / 100.0)

SELECT TaxRate
FROM Payments

/*
    Problem 12.	Delete All Records
*/

DELETE FROM Occupancies
