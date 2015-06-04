-- psql -f db/seeds.sql 

\c warhol

TRUNCATE TABLE users CASCADE;
TRUNCATE TABLE cards CASCADE;

INSERT INTO users (id, username, email, name, phone, password) VALUES (1, 'awarhol', 'andy@example.com', 'Andy Warhol', '555-555-5555', 'jk');
INSERT INTO cards (id, value, author, tags) VALUES (1, 'This is a test', 1, '{cats, dogs, soup}');
