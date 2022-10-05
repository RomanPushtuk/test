CREATE TABLE IF NOT EXISTS "Test" (
 	id serial PRIMARY KEY,
 	name text NOT NULL
);

CREATE TYPE question_type_enum AS enum ('select', 'multiselect');

CREATE TABLE IF NOT EXISTS "Question" (
	id serial PRIMARY KEY,
	text text NOT NULL,
	type question_type_enum NOT NULL,
	test_id integer REFERENCES "Test" (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Answer" (
	id serial PRIMARY KEY,
	text text NOT NULL,
	question_id integer REFERENCES "Question" (id) ON DELETE CASCADE
);


CREATE OR REPLACE PROCEDURE add_test(name text)
AS $$
BEGIN
	INSERT INTO "Test"("name") VALUES (name);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE remove_test(test_id integer)
AS $$
BEGIN
    DELETE FROM "Test" WHERE id = test_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_test(test_row "Test")
AS $$
BEGIN
	DELETE FROM "Test" WHERE id = test_row.id;
	INSERT INTO "Test" VALUES (test_row.*);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_question(test_id integer, "text" text, type question_type_enum DEFAULT 'select')
AS $$
BEGIN
	INSERT INTO "Question"("test_id", "text", "type") VALUES (test_id, add_question.text, add_question.type);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE remove_question(question_id integer)
AS $$
BEGIN
    DELETE FROM "Question" WHERE id = question_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_question(question_row "Question")
AS $$
BEGIN
    DELETE FROM "Question" WHERE id = question_row.id;
    INSERT INTO "Question" VALUES (question_row.*);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_answer(question_id integer, "text" text)
AS $$
BEGIN
	INSERT INTO "Answer"("question_id", "text") VALUES (question_id, add_answer.text );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE remove_answer(answer_id integer)
AS $$
BEGIN
    DELETE FROM "Answer" WHERE id = answer_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_answer(answer_row "Answer")
AS $$
BEGIN
    DELETE FROM "Answer" WHERE id = question_row.id;
    INSERT INTO "Answer" VALUES (answer_row.*);
END;
$$ LANGUAGE plpgsql;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS "User" (
    id text default gen_random_uuid() PRIMARY KEY,
);

CREATE OR REPLACE PROCEDURE add_user()
AS $$
BEGIN
    INSERT INTO "User" DEFAULT VALUES;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE remove_user(id text)
AS $$
BEGIN
    DELETE FROM "User" WHERE id = remove_user.id;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE "UserAnswer" (
    user_id text REFERENCES "User"(id) ON DELETE CASCADE,
    question_id integer REFERENCES "Question"(id) ON DELETE CASCADE,
    user_answer jsonb,
    PRIMARY KEY (user_id, question_id)
);

CREATE OR REPLACE PROCEDURE add_user_answer(user_answer_row "UserAnswer")
AS $$
BEGIN
    INSERT INTO "UserAnswer" VALUES (user_answer_row.*);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE remove_user_answer(user_id text, question_id integer)
AS $$
BEGIN
    DELETE FROM "UserAnswer"
        WHERE user_id = remove_user_answer.user_id AND question_id = remove_user_answer.question_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_user_answer(user_answer_row "UserAnswer")
AS $$
BEGIN
    DELETE FROM "UserAnswer"
            WHERE user_id = remove_user_answer.user_id AND question_id = remove_user_answer.question_id;
    INSERT INTO "UserAnswer" VALUES (user_answer_row.*);
END;
$$ LANGUAGE plpgsql;