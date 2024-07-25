SELECT
    p.id AS "ID",
    p.first_name AS "First name",
    p.last_name AS "Last name",
    SUM(m.budget) AS "Total movies budget"
FROM
    person p
JOIN
    character c ON p.id = c.person_id
JOIN
    movie m ON c.movie_id = m.id
GROUP BY
    p.id, p.first_name, p.last_name
ORDER BY
    p.id;