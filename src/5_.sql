SELECT
    m.id AS "ID",
    m.title AS "Title",
    m.release_date AS "Release date",
    m.duration AS "Duration",
    m.description AS "Description",
    json_build_object(
        'id', p.id,
        'movie_id', p.movie_id,
        'file_name', f.file_name,
        'mime_type', f.mime_type,
        'key', f.key,
        'url', f.url,
        'created_at', f.created_at,
        'updated_at', f.updated_at
    ) AS "Poster",
    json_build_object(
        'ID', d.id,
        'First name', d.first_name,
        'Last name', d.last_name
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
    movie_genre mg ON m.id = mg.movie_id
JOIN
    genre g ON mg.genre_id = g.id
WHERE
    m.country_id = 1
    AND m.release_date >= '2022-01-01'
    AND m.duration > '02:15:00'
    AND g.name IN ('Action', 'Drama')
GROUP BY
     m.id, p.id, f.id, d.id
ORDER BY
    m.id;