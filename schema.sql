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
    ('tim', 'Tim', 'Pei', 'tim@u.nus.edu', 29-04-1993, 'pei', 0, 4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('kathy123', 'Kathy', 'Liu', 'liukathyy@gmail.com', 28-08-1993, 'pa55w0rd', 1, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('batman', 'Bruce', 'Wayne', 'darknight@wayneenterprises.com', 20-09-1975, 'rachel', 0, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('ironman', 'Tony', 'Stark', 'anthonystark@starkindustries.com', 17-07-1976, 'acdc', 0, 4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('arrow', 'Oliver', 'Queen', 'oliverqueen@queenconsolidated.com', 22-01-1983, 'verdant', 0, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('drizzy', 'Aubrey', 'Graham', 'drake@ovo.com', 24-10-1986, 'degrassi', 0, 5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('superman', 'Clark', 'Kent', 'clarkkent@smallville.com', 15-12-1970, 'louislane', 0, 6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('janejane', 'Jane', 'Li', 'jane@u.nus.edu', 05-07-1993, 'pa55w0rd', 1, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('mulan1', 'Mulan', 'Wu', 'mulan@disney.com', 20-09-1986, 'passwerd', 0, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('pocha', 'Pocha', 'Hontas', 'pochahontas@disney.com', 23-03-1967, 'acdc', 0, 4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('b3lla', 'Belle', 'P', 'belle@disney.com', 22-01-1983, 'verdant', 0, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('longhairduncare', 'Rapunzel', 'Tangled', 'rapunzel@disney.com', 24-10-1923, 'pass', 0, 5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('jaz', 'Jasmine', 'Kent', 'jaz@disney.com', 15-12-1970, 'iheartaladdin', 0, 6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('swim4life', 'Ariel', 'Mermaid', 'ariel@disney.com', 24-11-1983, 'water', 0, 5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('cinderella', 'Cinder', 'Rella', 'cinderlla@disney.com', 15-12-1943, 'passss', 0, 6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

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
    ('Greetings', 'Chinese greetings', 4, 'tim', CURRENT_TIMESTAMP, 4),
    ('Romance', 'Japanese pickup lines', 7, 'ironman', CURRENT_TIMESTAMP, 1),
    ('Colours', 'Chinese colours', 4, 'kathy123', CURRENT_TIMESTAMP, 1),
    ('School', 'French classroom items', 2, 'kathy123', CURRENT_TIMESTAMP, 5),
    ('Colours', 'French colours', 2, 'janejane', CURRENT_TIMESTAMP, 2),
    ('Numbers', 'Italian numbers', 9, 'janejane', CURRENT_TIMESTAMP, 6);

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
    ('晚上好', 'Good evening', 4),
    ('君は僕が待ち焦がれていたプリンセス?', 'Are you the princess I have been waiting for all this time?', 5),
    ('これって運命じゃない？', 'Is this not fate?', 5),
    ('さみしくない？俺は寂しい。一緒にいて。', 'Are you lonely? I am lonely. Let us be together.', 5),
    ('白 bai', 'White', 6),
    ('彩色 cai se', 'Rainbow', 6),
    ('黄 huang', 'Yellow', 6),
    ('蓝 lan', 'Blue', 6),
    ('绿 lu', 'Green', 6),
    ('红 hong', 'Red', 6),
    ('un stylo', 'a pen', 7),
    ('un crayon', 'a pencil', 7),
    ('un ordinateur', 'a computer', 7),
    ('un ecran', 'a monitor', 7),
    ('une livre', 'a book', 7),
    ('une etudiante', 'a student', 7),
    ('rouge', 'red', 8),
    ('orange', 'orange', 8),
    ('jaune', 'yellow', 8),
    ('vert', 'green', 8),
    ('bleu', 'blue', 8),
    ('violet', 'violet', 8),
    ('brun', 'brown', 8),
    ('rose', 'pink', 8),
    ('noir', 'noir', 8),
    ('blanc', 'white', 8),
    ('una sola', 'one', 9),
    ('due', 'two', 9),
    ('tre', 'three', 9),
    ('quattro', 'four', 9),
    ('cinque', 'five', 9),
    ('sei', 'six', 9),
    ('sette', 'seven', 9),
    ('otto', 'eight', 9),
    ('nove', 'nine', 9),
    ('deici', 'ten', 9),
    ('cento', 'one hundred', 9);

INSERT INTO UserCollection VALUES
    ('sumin', 1),
    ('sumin', 3),
    ('sumin', 2),
    ('tim', 2),
    ('tim', 4);
