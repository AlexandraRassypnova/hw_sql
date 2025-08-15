DROP TABLE IF EXISTS TrackCollection, Collection, Track, SingerAlbum, Album, SingerGenre, Genre, Singer CASCADE;

CREATE TABLE Singer (
    id SERIAL PRIMARY KEY,
    singer_name VARCHAR(255) NOT NULL 
);

CREATE TABLE Genre (
    id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL 
);

CREATE TABLE SingerGenre (
    singer_id INT REFERENCES Singer(id) ON DELETE CASCADE,
    genre_id INT REFERENCES Genre(id) ON DELETE CASCADE,
    PRIMARY KEY (singer_id, genre_id)
);

CREATE TABLE Album (
    id SERIAL PRIMARY KEY,
    album_name VARCHAR(255) NOT NULL,
    album_year INT
);

CREATE TABLE SingerAlbum (
    singer_id INT REFERENCES Singer(id) ON DELETE CASCADE,
    album_id INT REFERENCES Album(id) ON DELETE CASCADE,
    PRIMARY KEY (singer_id, album_id)
);

CREATE TABLE Track (
    id SERIAL PRIMARY KEY,
    track_name VARCHAR(255) NOT NULL,
    track_duration INT,
    album_id INT REFERENCES Album(id) ON DELETE CASCADE
);

CREATE TABLE Collection (
    id SERIAL PRIMARY KEY,
    collection_name VARCHAR(255) NOT NULL,
    release_year INT,
	UNIQUE (collection_name, release_year)
);

CREATE TABLE TrackCollection (
    collection_id INT REFERENCES Collection(id) ON DELETE CASCADE,
    track_id INT REFERENCES Track(id) ON DELETE CASCADE,
    PRIMARY KEY (collection_id, track_id)
);

ЗАДАНИЕ №1.

INSERT INTO Singer (singer_name) VALUES
('Cher'),
('Tupac'),
('Ella Fitzgerald'),
('Selena Gomez');

INSERT INTO Genre (genre_name) VALUES
('Pop'),
('Jazz'),
('Hip-Hop');

INSERT INTO SingerGenre (singer_id, genre_id) VALUES
((SELECT id FROM Singer WHERE singer_name = 'Cher'), (SELECT id FROM Genre WHERE genre_name = 'Pop')),
((SELECT id FROM Singer WHERE singer_name = 'Tupac'), (SELECT id FROM Genre WHERE genre_name = 'Hip-Hop')),
((SELECT id FROM Singer WHERE singer_name = 'Ella Fitzgerald'), (SELECT id FROM Genre WHERE genre_name = 'Jazz')),
((SELECT id FROM Singer WHERE singer_name = 'Selena Gomez'), (SELECT id FROM Genre WHERE genre_name = 'Pop'));

INSERT INTO Album (album_name, album_year) VALUES
('Me Against the World', 1999),
('Mermaids', 2020),
('Hello, Dolly!', 1956);

INSERT INTO SingerAlbum (singer_id, album_id) VALUES
((SELECT id FROM Singer WHERE singer_name = 'Cher'), (SELECT id FROM Album WHERE album_name = 'Mermaids')),
((SELECT id FROM Singer WHERE singer_name = 'Tupac'), (SELECT id FROM Album WHERE album_name = 'Me Against the World')),
((SELECT id FROM Singer WHERE singer_name = 'Ella Fitzgerald'), (SELECT id FROM Album WHERE album_name = 'Hello, Dolly!'));

INSERT INTO Track (track_name, track_duration, album_id) values
('People', 300, (SELECT id FROM Album WHERE album_name = 'Hello, Dolly!')),
('The thrill is gone', 285, (SELECT id FROM Album WHERE album_name = 'Hello, Dolly!')),
('My baby I am Yours', 215, (SELECT id FROM Album WHERE album_name = 'Mermaids')), 
('Old School', 255, (SELECT id FROM Album WHERE album_name = 'Me Against the World')),
('Dear Mama', 375, (SELECT id FROM Album WHERE album_name = 'Me Against the World')),
('If I die 2nite', 200, (SELECT id FROM Album WHERE album_name = 'Me Against the World'));

INSERT INTO Collection (collection_name, release_year) VALUES
('First', 2001),
('Second', 2009),
('Third', 2018),
('Fourth', 2020);

INSERT INTO TrackCollection (collection_id, track_id) VALUES
((SELECT id FROM Collection WHERE collection_name = 'First'), (SELECT id FROM Track WHERE track_name = 'People')),
((SELECT id FROM Collection WHERE collection_name = 'First'), (SELECT id FROM Track WHERE track_name = 'My baby I am Yours')),
((SELECT id FROM Collection WHERE collection_name = 'Second'), (SELECT id FROM Track WHERE track_name = 'The thrill is gone')),
((SELECT id FROM Collection WHERE collection_name = 'Second'), (SELECT id FROM Track WHERE track_name = 'Dear Mama')),
((SELECT id FROM Collection WHERE collection_name = 'Third'), (SELECT id FROM Track WHERE track_name = 'Old School')),
((SELECT id FROM Collection WHERE collection_name = 'Third'), (SELECT id FROM Track WHERE track_name = 'If I die 2nite'));

ЗАДАНИЕ №2.

SELECT track_name, track_duration
FROM Track
ORDER BY track_duration DESC
LIMIT 1;

SELECT track_name
FROM Track
WHERE track_duration >= 210;

SELECT collection_name
FROM Collection
WHERE release_year BETWEEN 2018 AND 2020;

SELECT singer_name
FROM Singer
WHERE singer_name NOT LIKE '% %';

SELECT track_name
FROM Track 
WHERE track_name ILIKE '%my%'
   OR track_name ILIKE '%мой%';

ЗАДАНИЕ №3.
   
SELECT g.genre_name, COUNT(sg.singer_id) AS singer_count
FROM Genre g
JOIN SingerGenre sg ON g.id = sg.genre_id
GROUP BY g.genre_name;

SELECT COUNT(t.id) AS track_count
FROM Track t
JOIN Album a ON t.album_id = a.id
WHERE a.album_year BETWEEN 2019 AND 2020;

SELECT a.album_name, AVG(t.track_duration) AS avg_duration
FROM Album a
JOIN Track t ON a.id = t.album_id
GROUP BY a.album_name;

SELECT s.singer_name
FROM Singer s
WHERE s.id NOT IN (
    SELECT sa.singer_id
    FROM SingerAlbum sa
    JOIN Album a ON sa.album_id = a.id
    WHERE a.album_year = 2020
);

SELECT DISTINCT c.collection_name
FROM Collection c
JOIN TrackCollection tc ON c.id = tc.collection_id
JOIN Track t ON tc.track_id = t.id
JOIN Album a ON t.album_id = a.id
JOIN SingerAlbum sa ON a.id = sa.album_id
JOIN Singer s ON sa.singer_id = s.id
WHERE s.singer_name = 'Tupac';