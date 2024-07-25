WITH movie_data AS (
    SELECT
        m.id AS "ID",
        m.title AS "Title",
        m.release_date AS "Release date",
        m.duration AS "Duration",
        m.description AS "Description",
        json_build_object(
            'id', p.id,
            'file_name', f.file_name,
            'mime_type', f.mime_type,
            'key', f.key,
            'url', f.url,
            'created_at', f.created_at,
            'updated_at', f.updated_at
        ) AS "Poster",
        json_build_object(
            'id', d.id,
            'first_name', d.first_name,
            'last_name', d.last_name,
            'photo', json_build_object(
                'id', pf.id,
                'file_name', pf.file_name,
                'mime_type', pf.mime_type,
                'key', pf.key,
                'url', pf.url,
                'created_at', pf.created_at,
                'updated_at', pf.updated_at
            )
        ) AS "Director"
    FROM
        movie m
    JOIN
        poster p ON m.id = p.movie_id
    JOIN
        file f ON p.file_id = f.id
    JOIN
        director d ON m.director_id = d.id
    JOIN
        person dp ON d.id = dp.id
    JOIN
        person_photo pp ON dp.primary_photo_id = pp.id
    JOIN
        file pf ON pp.file_id = pf.id
    WHERE
        m.id = 1
),
actors_data AS (
    SELECT
        json_agg(json_build_object(
            'id', p.id,
            'first_name', p.first_name,
            'last_name', p.last_name,
            'photo', json_build_object(
                'id', f.id,
                'file_name', f.file_name,
                'mime_type', f.mime_type,
                'key', f.key,
                'url', f.url,
                'created_at', f.created_at,
                'updated_at', f.updated_at
            )
        )) AS "Actors"
    FROM
        character c
    JOIN
        person p ON c.person_id = p.id
    JOIN
        person_photo pp ON p.primary_photo_id = pp.id
    JOIN
        file f ON pp.file_id = f.id
    WHERE
        c.movie_id = 1
),
genres_data AS (
    SELECT
        json_agg(json_build_object(
            'id', g.id,
            'name', g.name
        )) AS "Genres"
    FROM
        movie_genre mg
    JOIN
        genre g ON mg.genre_id = g.id
    WHERE
        mg.movie_id = 1
)
SELECT
    md."ID",
    md."Title",
    md."Release date",
    md."Duration",
    md."Description",
    md."Poster",
    md."Director",
    ad."Actors",
    gd."Genres"
FROM
    movie_data md,
    actors_data ad,
    genres_data gd;