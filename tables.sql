/*
 * Drop pour clean la BDD
 * correction de bugs de syntaxe + clés
 */

/*
DROP TABLE PERSON CASCADE;
DROP TABLE KARATEKA CASCADE;
DROP TABLE LEADER CASCADE;
DROP VIEW vKarateka CASCADE;
DROP VIEW vLeader CASCADE;
DROP TABLE PARTICIPATE CASCADE;
DROP TABLE CLUB CASCADE;
DROP TABLE MASTERIES CASCADE;
DROP TABLE COMPETITION CASCADE;
DROP TABLE KATAFAMILY CASCADE;
DROP TABLE KATA CASCADE;
DROP TABLE VIDEO CASCADE;
DROP TABLE KARATEKAMOV CASCADE;
DROP TABLE CATEGORY CASCADE;
DROP TABLE KATAMOV CASCADE;
DROP TABLE HIT CASCADE;
DROP TABLE HITDONE CASCADE;
DROP TABLE RULE CASCADE;
DROP TABLE COMPETITIONPHOTO CASCADE;
DROP TABLE CONFRONTATION CASCADE;
DROP TABLE PARTICIPATION CASCADE;
DROP TABLE CONFRONTATIONKUMITE CASCADE;
DROP TABLE CONFRONTATIONTW CASCADE;
DROP TABLE CONFRONTATIONKATA CASCADE;
DROP VIEW VCONFRONTATIONKUMITE CASCADE;
DROP VIEW VCONFRONTATIONTW CASCADE;
DROP VIEW VCONFRONTATIONKATA CASCADE;
*/


CREATE TABLE PERSON(
	Id SERIAL PRIMARY KEY,
	FirstName VARCHAR,
	LastName VARCHAR
);

CREATE TABLE LEADER(
	Id INTEGER REFERENCES PERSON(Id) PRIMARY KEY,
	Mail VARCHAR UNIQUE,
	Phone VARCHAR UNIQUE
);

CREATE TABLE CLUB(
	Name VARCHAR PRIMARY KEY,
	WebSite VARCHAR UNIQUE,
	Leader INTEGER REFERENCES LEADER(Id)
);

CREATE TABLE KARATEKA(
	Id INTEGER REFERENCES PERSON(Id) PRIMARY KEY,
	UrlPhoto VARCHAR,
	Weight DECIMAL,
	Height DECIMAL,
	Belt VARCHAR,
	Dans INTEGER,
	ClubName VARCHAR REFERENCES CLUB(Name),
	Teacher BOOLEAN,
	CHECK(Belt = 'yellow' OR Belt = 'orange' OR Belt = 'green' OR Belt = 'blue' OR Belt =   'brown' OR Belt = 'black')
);

CREATE VIEW VKARATEKA AS
SELECT P.firstname, P.lastname, K.* FROM KARATEKA K, PERSON P
WHERE K.Id = P.Id;

CREATE VIEW VLEADER AS
SELECT P.firstname, P.lastname, L.* FROM Leader L, PERSON P
WHERE L.Id = P.Id;

CREATE TABLE COMPETITION(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR UNIQUE,
	Date DATE NOT NULL,
	Place VARCHAR UNIQUE,
	Type VARCHAR,
CHECK(Type = 'kumite' OR Type = 'tamashi wari' OR Type = 'kata' OR Type = 'mixte'),
Organisator VARCHAR REFERENCES CLUB(Name) NOT NULL
);

CREATE TABLE PARTICIPATE(
	Idk INTEGER,
	Competition INTEGER,
	PRIMARY KEY(Idk, Competition),
	FOREIGN KEY (Idk) REFERENCES KARATEKA(Id),
	FOREIGN KEY (Competition) REFERENCES Competition(Id)
);


CREATE TABLE KATAFAMILY(
	NameJ VARCHAR PRIMARY KEY,
	NameFR VARCHAR UNIQUE
);

CREATE TABLE KATA(
	NameJ VARCHAR PRIMARY KEY,
NameFR VARCHAR,
Descritpion VARCHAR,
NumberMov INTEGER,
Belt VARCHAR,
Dans INTEGER,
Family VARCHAR REFERENCES KATAFAMILY(NameJ) NOT NULL,
CHECK(Belt = 'yellow' OR Belt = 'orange' OR Belt = 'green' OR Belt = 'blue' OR Belt =   'brown' OR Belt = 'black')
);


CREATE TABLE MASTERIES(
	Karateka INTEGER REFERENCES KARATEKA(Id),
	Kata VARCHAR REFERENCES KATA(NameJ),
	PRIMARY KEY(Karateka, Kata)
);



CREATE TABLE VIDEO(
	Url VARCHAR,
	Kata VARCHAR REFERENCES KATA(NameJ),
	PRIMARY KEY(Url, Kata)
);

CREATE TABLE CATEGORY(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR UNIQUE,
	SubC VARCHAR
);


CREATE TABLE KARATEMOV(
	NameJ VARCHAR PRIMARY KEY,
	NameFR VARCHAR UNIQUE,
	Category INTEGER REFERENCES Category(Id) NOT NULL,
	Url VARCHAR
);

CREATE TABLE KATAMOV(
	Kata VARCHAR REFERENCES KATA(NameJ),
	Number INTEGER,
	Movment VARCHAR REFERENCES KARATEMOV(NameJ) NOT NULL,
	PRIMARY KEY(Kata, Number)
);

CREATE TABLE HIT(
	Name VARCHAR PRIMARY KEY,
	Category INTEGER REFERENCES CATEGORY(Id)
);

CREATE TABLE CONFRONTATION(
	Id SERIAL PRIMARY KEY,
	Competition INTEGER REFERENCES COMPETITION(Id) NOT NULL
);

CREATE TABLE CONFRONTATIONKUMITE(
	Confrontation INTEGER REFERENCES CONFRONTATION(Id) PRIMARY KEY
);

CREATE TABLE CONFRONTATIONTW(
	Confrontation INTEGER REFERENCES CONFRONTATION(Id) PRIMARY KEY
);

CREATE TABLE CONFRONTATIONKATA(
	Confrontation INTEGER REFERENCES CONFRONTATION(Id) PRIMARY KEY
);

CREATE TABLE HITDONE(
	Hit VARCHAR REFERENCES HIT,
	Confrontation INTEGER REFERENCES CONFRONTATIONKUMITE(Confrontation),
	Karateka INTEGER REFERENCES KARATEKA(Id),
	PRIMARY KEY(Hit, Confrontation, Karateka)
);

CREATE TABLE RULE(
	Competition INTEGER REFERENCES COMPETITION(Id),
	Category INTEGER REFERENCES CATEGORY(Id),
	Points INTEGER,
	PRIMARY KEY(Competition, Category)
);

CREATE TABLE COMPETITIONPHOTO(
	Competition INTEGER REFERENCES COMPETITION(Id),
	Url VARCHAR,
	PRIMARY KEY(Competition, Url)
);




CREATE TABLE PARTICIPATION(
	Confrontation INTEGER REFERENCES CONFRONTATION(Id),
	Karateka INTEGER REFERENCES KARATEKA(Id),
	Points INTEGER,
	PRIMARY KEY(Confrontation, Karateka)
);



CREATE VIEW VCONFRONTATIONTW AS
SELECT C.*
FROM CONFRONTATION C, CONFRONTATIONTW CTW
WHERE C.Id = CTW.Confrontation;

CREATE VIEW VCONFRONTATIONKUMITE AS
SELECT C.*
FROM CONFRONTATION C, CONFRONTATIONKUMITE CK
WHERE C.Id = CK.Confrontation;

CREATE VIEW VCONFRONTATIONKATA AS
SELECT C.*
FROM CONFRONTATION C, CONFRONTATIONKATA CKATA
WHERE C.Id = CKATA.Confrontation;