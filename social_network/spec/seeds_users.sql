TRUNCATE TABLE users RESTART IDENTITY CASCADE; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (email, username) VALUES ('example@email.com', 'test_user');
INSERT INTO users (email, username) VALUES ('test@online.com', 'sample_account');
