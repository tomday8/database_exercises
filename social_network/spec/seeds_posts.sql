TRUNCATE TABLE posts RESTART IDENTITY;

INSERT INTO posts (title, content, views, user_id) VALUES ('title1', ' some content for you', 244, 1);
INSERT INTO posts (title, content, views, user_id) VALUES ('title2', 'April 2022 content', 364, 2);