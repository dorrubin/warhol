-- psql -f db/schema.sql 

DROP DATABASE IF EXISTS warhol;
CREATE DATABASE warhol;
\c warhol

CREATE TABLE users (
	id 			  SERIAL  PRIMARY KEY,
	username  VARCHAR NOT NULL,
	email 	  VARCHAR NOT NULL,
	name 		  VARCHAR,
	phone 	  VARCHAR,
	password  VARCHAR NOT NULL
);

CREATE TABLE cards (
	id 			  SERIAL 	PRIMARY KEY,
	value 	  VARCHAR, 
	author 	  INTEGER NOT NULL,
	tags 		  VARCHAR ARRAY
);