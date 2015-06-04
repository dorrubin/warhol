-- psql -f db/seeds.sql 

\c warhol

TRUNCATE TABLE users CASCADE;
TRUNCATE TABLE cards CASCADE;

INSERT INTO users (username, email, name, phone, password) VALUES ('andy', 'andy@example.com', 'Andy Warhol', '555-555-5555', 'jk');
INSERT INTO users (username, email, name, phone, password) VALUES ('randy', 'randy@example.com', 'Randy Friend', '555-555-5555', 'jk');
INSERT INTO cards (value, author_id, tags, created_at, last_updated) VALUES ('This is a test', 1, ARRAY['cats', 'dogs'], CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO cards (value, author_id, tags, created_at, last_updated) VALUES ('Sharing this card', 2, ARRAY['cars', 'trains', 'automobiles'], CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);