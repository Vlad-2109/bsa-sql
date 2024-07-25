SELECT
    m.id AS "ID",
    m.title AS "Title",
    COUNT(c.person_id) AS "Actors count"
FROM
    movie m
JOIN
    character c ON m.id = c.movie_id
JOIN
    person p ON c.person_id = p.id
WHERE
    m.release_date >= CURRENT_DATE - INTERVAL '5 years'
GROUP BY
    m.id, m.title
ORDER BY
    m.id;