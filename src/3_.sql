SELECT
  u.id AS "ID",
  u.username AS "Username",
  ARRAY_AGG(fm.movie_id) AS "Favorite movie IDs"
FROM
    app_user u
LEFT JOIN
    favorite_movie fm ON u.id = fm.user_id
GROUP BY
    u.id, u.username
ORDER BY
    u.id;