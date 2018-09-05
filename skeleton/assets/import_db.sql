
DROP TABLE IF EXISTS question_tags;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;  -- turn on the foreign key constraints to ensure data integrity

-- USERS
--this statement makes sqlite3 actually respect the foreign key constraints y ou've added in yur CREATE TABLE statements

CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

-- needs ID?
CREATE TABLE question_follows (
 id INTEGER PRIMARY KEY NOT NULL,
 user_id INTEGER NOT NULL,
 question_id INTEGER NOT NULL,

 FOREIGN KEY (user_id) REFERENCES users(id),
 FOREIGN KEY (question_id) REFERENCES questions(id)
);

--
CREATE TABLE replies (
  id INTEGER PRIMARY KEY NOT NULL,
  parent_reply_id INTEGER,
  body TEXT NOT NULL,
  question_id INTEGER,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes(
  likes INTEGER,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- INSERT INTO
--       users (fname, lname)
--       VALUES ('Chris', 'Atwood'), ('Jerry', 'Wang');


-- added info to insert from solution
INSERT INTO
    users (fname, lname)
  VALUES
    ("Ned", "Ruggeri"), ("Kush", "Patel"), ("Earl", "Cat");



INSERT INTO
    questions (title, body, author_id)
  SELECT
    "Ned Question", "NED NED NED", 1
  FROM
    users
  WHERE
    users.fname = "Ned" AND users.lname = "Ruggeri";

INSERT INTO
    questions (title, body, author_id)
  SELECT
    "Kush Question", "KUSH KUSH KUSH", users.id
  FROM
    users
  WHERE
    users.fname = "Kush" AND users.lname = "Patel";

INSERT INTO
    questions (title, body, author_id)
  SELECT
    "Earl Question", "MEOW MEOW MEOW", users.id
  FROM
    users
  WHERE
    users.fname = "Earl" AND users.lname = "Cat";

-- INSERT INTO
--   question_follows (user_id, question_id)
-- VALUES
--   ((SELECT id FROM users WHERE fname = "Ned" AND lname = "Ruggeri"),
--   (SELECT id FROM questions WHERE title = "Earl Question")),
--
--   ((SELECT id FROM users WHERE fname = "Kush" AND lname = "Patel"),
--   (SELECT id FROM questions WHERE title = "Earl Question")
-- );
INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Ned" AND lname = "Ruggeri"),
  (SELECT id FROM questions WHERE title = "Earl Question")),

  ((SELECT id FROM users WHERE fname = "Kush" AND lname = "Patel"),
  (SELECT id FROM questions WHERE title = "Earl Question")
);



INSERT INTO
    replies (question_id, parent_reply_id, author_id, body)
  VALUES
    ((SELECT id FROM questions WHERE title = "Earl Question"),
    NULL,
    (SELECT id FROM users WHERE fname = "Ned" AND lname = "Ruggeri"),
    "Did you say NOW NOW NOW?"
  );

INSERT INTO
    replies (question_id, parent_reply_id, author_id, body)
  VALUES
    ((SELECT id FROM questions WHERE title = "Earl Question"),
    (SELECT id FROM replies WHERE body = "Did you say NOW NOW NOW?"),
    (SELECT id FROM users WHERE fname = "Kush" AND lname = "Patel"),
    "I think he said MEOW MEOW MEOW."
  );

INSERT INTO
    question_likes (user_id, question_id)
  VALUES
    ((SELECT id FROM users WHERE fname = "Kush" AND lname = "Patel"),
    (SELECT id FROM questions WHERE title = "Earl Question")
  );
