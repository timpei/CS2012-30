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

CREATE TABLE UserCollection (
    username VARCHAR(50) REFERENCES User(username),
    setID INTEGER REFERENCES CardSet(setID),
    PRIMARY KEY(username, setID)
);

CREATE VIEW MostCollected AS
SELECT c.setID AS setID, COUNT(u.username) AS numCollections
FROM CardSet c, UserCollection u
WHERE c.setID = u.setID
GROUP BY c.setID
ORDER BY COUNT(u.username) DESC
LIMIT 20;

CREATE VIEW BiggestSet AS
SELECT c.setID AS setID, COUNT(f.cardID) AS numCards
FROM CardSet c, Flashcard f
WHERE c.setID = f.setID
GROUP BY f.setID
ORDER BY COUNT(f.cardID) DESC
LIMIT 20;

CREATE VIEW CategorySetCount AS
SELECT ca.catID AS catID, COUNT(cs.setID) AS catCount
FROM Category ca, CardSet cs
WHERE ca.catID = cs.category
GROUP BY ca.catID;

CREATE VIEW LanguageSetCount AS
SELECT l.langID AS langID, COUNT(c.setID) AS langCount
FROM Language l, CardSet c
WHERE l.langID = c.language
GROUP BY l.langID;

INSERT INTO User(username, firstName, lastName, email, birthday,
    password, isAdmin, avatar, lastLogin, registerDate) VALUES
    ('admin', 'John', 'Smith', 'john@u.nus.edu', 01-01-1990, 'adm1n', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('sumin', 'Sumin', 'Kang', 'sumin@u.nus.edu', 21-05-1993, 'kang', 0, 6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('tim', 'Tim', 'Pei', 'tim@u.nus.edu', 29-04-1993, 'pei', 0, 4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO Language(name) VALUES
    ('English'),
    ('French'),
    ('Spanish'),
    ('Chinese'),
    ('Malay'),
    ('Thai'),
    ('Japanese'),
    ('Korean'),
    ('Italian');

INSERT INTO Category(name) VALUES
    ('Uncategorized'),
    ('Common Words'),
    ('Travel'),
    ('Business'),
    ('School'),
    ('Numbers'),
    ('Slang');

INSERT INTO CardSet(title, description, language, creator, lastUpdate, category) VALUES
    ('Food', 'Korean food terms', 8, 'sumin', CURRENT_TIMESTAMP, 1),
    ('Greetings', 'Simple greetings in Malay', 5, 'tim', CURRENT_TIMESTAMP, 3),
    ('Greetings', 'Spanish greetings', 3, 'sumin', CURRENT_TIMESTAMP, 3),
    ('Greetings', 'Chinese greetings', 4, 'tim', CURRENT_TIMESTAMP, 4);

INSERT INTO Flashcard(word, translation, setID) VALUES
    ('떡볶이', 'spicy rice cake', 1),
    ('파전', 'seafood pancake', 1),
    ('냉면', 'cold noodles', 1),
    ('감자탕', 'pork bone soup', 1),
    ('불고기', 'marinated beef', 1),
    ('Hai', 'Hello', 2),
    ('Selamat datang', 'Welcome', 2),
    ('Selamat tinggal', 'Goodbye', 2),
    ('Selamat pagi', 'Good morning', 2),
    ('Selamat petang', 'Good afternoon', 2),
    ('Selamat malam', 'Good evening', 2),
    ('Hola', 'Hello', 3),
    ('Bienvenidos', 'Welcome', 3),
    ('Adios', 'Goodbye', 3),
    ('Chao', 'Goodbye', 3),
    ('Buenos dias', 'Good morning', 3),
    ('Buenas tardes', 'Good afternoon', 3),
    ('Buenas noches', 'Good evening', 3),
    ('你好', 'Hello', 4),
    ('再见', 'Goodbye', 4),
    ('早上好', 'Good morning', 4),
    ('下午好', 'Good afternoon', 4),
    ('晚上好', 'Good evening', 4);

INSERT INTO UserCollection VALUES
    ('sumin', 1),
    ('sumin', 3),
    ('sumin', 2),
    ('tim', 2),
    ('tim', 4);
