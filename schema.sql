CREATE TABLE User (
	username VARCHAR (50) PRIMARY KEY,
	firstName VARCHAR(50) NOT NULL,
	lastName VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	birthday DATE NOT NULL,
	password VARCHAR(255) NOT NULL,
	isAdmin BOOLEAN NOT NULL,
	avatar INTEGER NOT NULL,
	lastLogin DATETIME NOT NULL,
	registerDate DATETIME NOT NULL
);

CREATE TABLE Language(
	langID INTEGER PRIMARY KEY AUTOINCREMENT,
	name VARCHAR(50) NOT NULL
);

CREATE TABLE Category(
	catID INTEGER PRIMARY KEY AUTOINCREMENT,
	name VARCHAR(50) NOT NULL
);

CREATE TABLE CardSet (
	setID INTEGER PRIMARY KEY AUTOINCREMENT,
	title VARCHAR(255) NOT NULL,
	description TEXT,
	language INTEGER REFERENCES Language(langID),
	creator REFERENCES User(username),
	lastUpdate DATETIME NOT NULL,
	category INTEGER REFERENCES Category(catID)
);

CREATE TABLE Flashcard( 
	word VARCHAR(255) NOT NULL,
	translation VARCHAR(255) NOT NULL,
	setID INTEGER REFERENCES CardSet(setID),
	cardID INTEGER PRIMARY KEY AUTOINCREMENT
);

INSERT INTO User(username, firstName, lastName, email, birthday, password, isAdmin, avatar, lastLogin, registerDate)
VALUES('admin', 'John', 'Smith', 'john@u.nus.edu', 01-01-1990, 'adm1n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO User(username, firstName, lastName, email, birthday, password, isAdmin, avatar, lastLogin, registerDate)
VALUES('sumin', 'Sumin', 'Kang', 'sumin@u.nus.edu', 21-05-1993, 'kang', 0, 6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO User(username, firstName, lastName, email, birthday, password, isAdmin, avatar, lastLogin, registerDate)
VALUES('tim', 'Tim', 'Pei', 'tim@u.nus.edu', 29-04-1993, 'pei', 0, 4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);