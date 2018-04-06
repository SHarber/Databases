-- Find all films with maximum length or minimum rental duration (compared to all other films).
-- In other words let L be the maximum film length, and let R be the minimum rental duration in the table film. You need to find all films that have length L or duration R or both length L and duration R.
-- You just need to return attribute film id for this query.
SELECT film_id FROM film
    WHERE rental_duration = (
        SELECT MIN(rental_duration) FROM film)
    OR length = (
        SELECT MAX(length) FROM film);

-- We want to find out how many of each category of film ED CHASE has started in so return a table with category.name and the count
-- of the number of films that ED was in which were in that category order by the category name ascending (Your query should return every category even if ED has been in no films in that category).
SELECT category.name AS category_name,
    IFNULL(edchasecount.film_count, 0) AS num_of_ed_chase_movies
    FROM category
    LEFT JOIN(
        SELECT category.name AS category_name,
        COUNT(film.film_id) AS film_count
        FROM category
    INNER JOIN film_category ON film_category.category_id = category.category_id
    INNER JOIN film ON film.film_id = film_category.film_id
    INNER JOIN film_actor ON film_actor.film_id = film.film_id
    INNER JOIN actor ON actor.actor_id = film_actor.actor_id
    WHERE actor.first_name = 'ED' AND actor.last_name='CHASE'
    GROUP BY category.name ASC
	) AS edchasecount ON edchasecount.category_name = category.name;


-- Find the first name, last name and total combined film length of Sci-Fi films for every actor
-- That is the result should list the names of all of the actors(even if an actor has not been in any Sci-Fi films)and the total length of Sci-Fi films they have been in.

SELECT actor.first_name AS 'first_name', actor.last_name AS 'last_name', SUM(film.length) AS 'total_combined_film_length'
    FROM category
        INNER JOIN film_category ON film_category.category_id = category.category_id
            AND category.name = 'Sci-Fi'
            INNER JOIN film on film.film_id = film_category.film_id
            INNER JOIN film_actor ON film.film_id = film_actor.film_id
        RIGHT JOIN actor ON actor.actor_id = film_actor.actor_id
    GROUP BY actor.first_name, actor.last_name
    ORDER BY actor.last_name;


-- Find the first name and last name of all actors who have never been in a Sci-Fi film
SELECT actor.first_name AS 'first_name',
    actor.last_name AS 'last_name'
    FROM actor
    WHERE actor.actor_id NOT IN
        (SELECT DISTINCT actor.actor_id FROM actor
                INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id
                INNER JOIN film_category ON film_category.film_id = film_actor.film_id
                INNER JOIN category ON category.category_id = film_category.category_id
                WHERE category.name = 'Sci-Fi'
);


-- Find the film title of all films which feature both KIRSTEN PALTROW and WARREN NOLTE
-- Order the results by title, descending (use ORDER BY title DESC at the end of the query)
-- Warning, this is a tricky one and while the syntax is all things you know, you have to think oustide
-- the box a bit to figure out how to get a table that shows pairs of actors in movies
SELECT film.title FROM film
	INNER JOIN film_actor AS actor_1 ON actor_1.film_id = film.film_id
    INNER JOIN actor AS first_actor ON first_actor.actor_id = actor_1.actor_id
    INNER JOIN film_actor AS actor_2 ON actor_2.film_id = film.film_id
    INNER JOIN actor AS second_actor ON second_actor.actor_id = actor_2.actor_id
    WHERE first_actor.first_name = 'KIRSTEN' AND first_actor.last_name = 'PALTROW'
    AND second_actor.first_name = 'WARREN' AND second_actor.last_name = 'NOLTE'
	ORDER BY film.title DESC;
