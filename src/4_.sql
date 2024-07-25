SELECT
    d.id AS "Director ID",
    CONCAT(d.first_name, ' ', d.last_name) AS "Director name",
    AVG(m.budget) AS "Average budget"
FROM
    director d
JOIN
    movie m ON d.id = m.director_id
GROUP BY
    d.id, CONCAT(d.first_name, ' ', d.last_name)
ORDER BY
    d.id;