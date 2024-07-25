CREATE TYPE role AS ENUM('leading', 'supporting', 'background');
CREATE TYPE gender as ENUM('male', 'female', 'other');

CREATE TABLE file (
    id SERIAL PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(255) NOT NULL,
    key VARCHAR(255) NOT NULL,
    url VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE app_user (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    avatar_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (avatar_id) REFERENCES file(id)
);

CREATE TABLE genre (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE director (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE movie (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    budget DECIMAL NOT NULL,
    release_date DATE NOT NULL,
    duration TIME NOT NULL,
    director_id INT,
    country_id INT,
    poster_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE poster (
    id SERIAL PRIMARY KEY,
    movie_id INT,
    file_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE person (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    biography TEXT NOT NULL,
    date_of_birth DATE NOT NULL,
    gender gender,
    country_id INT,
    movie_id INT,
    primary_photo_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE character (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    role role,
    movie_id INT,
    person_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE movie_genre (
    id SERIAL PRIMARY KEY,
    movie_id INT,
    genre_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE favorite_movie (
    id SERIAL PRIMARY KEY,
    user_id INT,
    movie_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE person_photo (
    id SERIAL PRIMARY KEY,
    person_id INT,
    file_id INT,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE movie
ADD CONSTRAINT fk_director_id
FOREIGN KEY (director_id) REFERENCES director(id),
ADD CONSTRAINT fk_country_id
FOREIGN KEY (country_id) REFERENCES country(id),
ADD CONSTRAINT fk_poster_id
FOREIGN KEY (poster_id) REFERENCES poster(id);

ALTER TABLE poster
ADD CONSTRAINT fk_movie_id
FOREIGN KEY (movie_id) REFERENCES movie(id),
ADD CONSTRAINT fk_file_id
FOREIGN KEY (file_id) REFERENCES file(id);

ALTER TABLE person
ADD CONSTRAINT fk_country_id
FOREIGN KEY (country_id) REFERENCES country(id),
ADD CONSTRAINT fk_movie_id
FOREIGN KEY (movie_id) REFERENCES movie(id),
ADD CONSTRAINT fk_primary_photo_id
FOREIGN KEY (primary_photo_id) REFERENCES person_photo(id);

ALTER TABLE character
ADD CONSTRAINT fk_movie_id
FOREIGN KEY (movie_id) REFERENCES movie(id),
ADD CONSTRAINT fk_person_id
FOREIGN KEY (person_id) REFERENCES person(id);

ALTER TABLE movie_genre
ADD CONSTRAINT fk_movie_id
FOREIGN KEY (movie_id) REFERENCES movie(id),
ADD CONSTRAINT fk_genre_id
FOREIGN KEY (genre_id) REFERENCES genre(id);

ALTER TABLE favorite_movie
ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id) REFERENCES app_user(id),
ADD CONSTRAINT fk_movie_id
FOREIGN KEY (movie_id) REFERENCES movie(id);

ALTER TABLE person_photo
ADD CONSTRAINT fk_person_id
FOREIGN KEY (person_id) REFERENCES person(id),
ADD CONSTRAINT fk_file_id
FOREIGN KEY (file_id) REFERENCES file(id);



INSERT INTO file (file_name, mime_type, key, url) VALUES
('avatar1.jpg', 'image/jpeg', 'avatar1', 'http://placeholder.com/avatar1.jpg'),
('avatar2.jpg', 'image/jpeg', 'avatar2', 'http://placeholder.com/avatar2.jpg');

INSERT INTO app_user (username, first_name, last_name, email, password, avatar_id) VALUES
('john_doe', 'John', 'Doe', 'john.doe@example.com', 'password123', 1),
('jane_smith', 'Jane', 'Smith', 'jane.smith@example.com', 'password456', 2);

INSERT INTO genre (name) VALUES
('Action'),
('Comedy');

INSERT INTO country (name) VALUES
('USA'),
('UK');

INSERT INTO director (first_name, last_name) VALUES
('Steven', 'Spielberg'),
('Christopher', 'Nolan');

INSERT INTO person (first_name, last_name, biography, date_of_birth, gender, country_id, primary_photo_id) VALUES
('Leonardo', 'DiCaprio', 'Famous actor.', '1974-11-11', 'male', 1, NULL),
('Emma', 'Watson', 'Actress and activist.', '1990-04-15', 'female', 2, NULL);

INSERT INTO person_photo (person_id, file_id, is_primary) VALUES
(1, 1, TRUE),
(2, 2, TRUE);

UPDATE person SET primary_photo_id = (SELECT id FROM person_photo WHERE person_id = person.id AND is_primary = TRUE) WHERE primary_photo_id IS NULL;

INSERT INTO movie (title, description, budget, release_date, duration, director_id, country_id) VALUES
('Jurassic Park', 'Dinosaurs come back to life.', 63.0, '2023-06-11', '02:16:00', 1, 1),
('Inception', 'A mind-bending thriller about dreams within dreams.', 160.0, '2010-07-16', '02:28:00', 2, 1);

INSERT INTO poster (movie_id, file_id) VALUES
(1, 1),
(2, 2);

INSERT INTO character (name, description, role, movie_id, person_id) VALUES
('Dr. Alan Grant', 'Paleontologist and the film’s hero.', 'leading', 1, 1),
('Mal', 'The team leader who manipulates dreams.', 'leading', 2, 2);

INSERT INTO movie_genre (movie_id, genre_id) VALUES
(1, 1),
(2, 2);

INSERT INTO favorite_movie (user_id, movie_id) VALUES
(1, 1),
(1, 2),
(2, 2);
