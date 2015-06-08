-- psql -f db/seeds.sql 

\c warhol

TRUNCATE TABLE users CASCADE;
TRUNCATE TABLE cards CASCADE;

INSERT INTO users (username, email, name, phone, password) VALUES ('andy', 'andy@example.com', 'Andy Warhol', '555-555-5555', 'jk');
INSERT INTO users (username, email, name, phone, password) VALUES ('pablo', 'pablo@example.com', 'Pablo Picaso', '555-555-5555', 'jk');
INSERT INTO users (username, email, name, phone, password) VALUES ('billy', 'bill@example.com', 'Bill Gates', '555-555-5555', 'jk');
INSERT INTO users (username, email, name, phone, password) VALUES ('steve', 'steve@apple.com', 'Steve Jobs', '555-555-5555', 'jk');
INSERT INTO users (username, email, name, phone, password) VALUES ('mt', 'mark@example.com', 'Samuel Langhorne Clemens', '555-555-5555', 'jk');
INSERT INTO cards (value, author_id, tags, created_at, last_updated) VALUES ('Best, idea, every. Paint can of soup, over and over again', 1, ARRAY['soup', 'celebrities'], CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO cards (value, author_id, tags, created_at, last_updated) VALUES ('Faces look too normal. They should be jumbled up.', 2, ARRAY['faces', 'cubism', 'soup'], CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);