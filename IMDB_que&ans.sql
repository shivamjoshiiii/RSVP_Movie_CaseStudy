USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?

SELECT 
    (SELECT 
            COUNT(*)
        FROM
            director_mapping) AS director_mapping_row_count,
    (SELECT 
            COUNT(*)
        FROM
            genre) AS genre_row_count,
    (SELECT 
            COUNT(*)
        FROM
            movie) AS movie_row_count,
    (SELECT 
            COUNT(*)
        FROM
            names) AS names_row_count,
    (SELECT 
            COUNT(*)
        FROM
            ratings) AS ratings_row_count,
    (SELECT 
            COUNT(*)
        FROM
            role_mapping) AS role_mapping_row_count;


-- Q2. Which columns in the movie table have null values?

SELECT 
    'id' AS column_name,
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS null_count
FROM
    movie
HAVING null_count > 0 
UNION ALL SELECT 
    'title' AS column_name,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS null_count
FROM
    movie
HAVING null_count > 0 
UNION ALL SELECT 
    'year' AS column_name,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS null_count
FROM
    movie
HAVING null_count > 0 
UNION ALL SELECT 
    'date_published' AS column_name,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS null_count
FROM
    movie
HAVING null_count > 0 
UNION ALL SELECT 
    'duration' AS column_name,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS null_count
FROM
    movie
HAVING null_count > 0 
UNION ALL SELECT 
    'country' AS column_name,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS null_count
FROM
    movie
HAVING null_count > 0 
UNION ALL SELECT 
    'worlwide_gross_income' AS column_name,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS null_count
FROM
    movie
HAVING null_count > 0 
UNION ALL SELECT 
    'languages' AS column_name,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS null_count
FROM
    movie
HAVING null_count > 0 
UNION ALL SELECT 
    'production_company' AS column_name,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS null_count
FROM
    movie
HAVING null_count > 0;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */

SELECT 
    Year, COUNT(*) AS number_of_movies
FROM
    movie
GROUP BY Year;

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??

SELECT 
    country, COUNT(*) AS number_of_movies
FROM
    movie
WHERE
    year = 2019
        AND country IN ('USA' , 'India')
GROUP BY country;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?

SELECT DISTINCT
    genre
FROM
    genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?

SELECT 
    genre, COUNT(*) AS highest_number_of_movies
FROM
    genre
GROUP BY genre
ORDER BY highest_number_of_movies DESC
LIMIT 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?


SELECT 
    COUNT(*) AS single_genre_movies_count
FROM
    (SELECT 
        movie_id
    FROM
        genre
    GROUP BY movie_id
    HAVING COUNT(genre) = 1) AS single_genre_movies;


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */


SELECT 
    genre, AVG(duration) AS avg_duration
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
GROUP BY g.genre;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/

WITH genre_movie_count AS (
SELECT genre, COUNT(movie_id) AS movie_count,
RANK()OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank FROM genre
GROUP BY genre
)SELECT * FROM genre_movie_count 
WHERE genre = 'Thriller';

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings; 

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/

WITH movie_avg_rating_rank AS(
SELECT title, avg_rating, DENSE_RANK()OVER(ORDER BY avg_rating DESC) AS movie_rank 
FROM movie AS m
INNER JOIN 
ratings AS r  ON m.id = r.movie_id
)SELECT * 
FROM movie_avg_rating_rank
HAVING movie_rank <=10;
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;


-- Order by is good to have

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/

SELECT m.production_company, COUNT(m.title) AS movie_count,AVG(r.avg_rating) AS avg_rating,
DENSE_RANK() OVER (ORDER BY COUNT(m.title) DESC) AS prod_company_rank
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE  r.avg_rating > 8 AND m.production_company IS NOT NULL
GROUP BY m.production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

SELECT genre, COUNT(*) AS movie_count
FROM movie AS m
INNER JOIN 
genre AS g ON m.id = g.movie_id
INNER JOIN 
ratings AS r ON m.id = r.movie_id
WHERE 
country in ('USA')
AND
MONTH(date_published) = 3
AND
year = 2017
AND 
total_votes < 1000
GROUP BY genre;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/

SELECT title, avg_rating,genre 
FROM movie AS m
INNER JOIN genre AS g ON m.id = g.movie_id
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE title LIKE 'The%'  
AND avg_rating > 8     
ORDER BY genre, title;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

SELECT COUNT(id) AS movie_count
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'
AND median_rating = 8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.

SELECT country, SUM(total_votes) AS sum_votes 
FROM movie AS m 
INNER JOIN 
ratings AS r ON m.id = r.movie_id 
WHERE country IN ('Germany','Italy')
GROUP BY country;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;








/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

WITH GenreRatings AS (
    SELECT g.genre, m.id AS movie_id, r.avg_rating
    FROM movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN genre g ON m.id = g.movie_id
    WHERE r.avg_rating > 8
),
TopGenres AS (
    SELECT 
        genre, 
        COUNT(*) AS movie_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
    FROM GenreRatings
    GROUP BY genre
    LIMIT 3 -- Ensures only the top 3 genres are considered
)
SELECT 
    n.name AS director_name,
    COUNT(dm.movie_id) AS movie_count
FROM director_mapping dm
INNER JOIN names n ON dm.name_id = n.id
INNER JOIN GenreRatings gr ON dm.movie_id = gr.movie_id
INNER JOIN TopGenres tg ON gr.genre = tg.genre
WHERE gr.avg_rating > 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 3;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */

SELECT 
   n.name AS actor_name,
       Count(movie_id) AS movie_count
FROM role_mapping AS rm
       INNER JOIN movie AS m
             ON m.id = rm.movie_id
       INNER JOIN ratings AS r USING(movie_id)
       INNER JOIN names AS n
             ON n.id = rm.name_id
WHERE r.median_rating >= 8
	  AND category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/

SELECT 
    production_company,
    SUM(r.total_votes) AS total_votes,
    RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_company_rank
FROM movie m
JOIN ratings r ON m.id = r.movie_id
GROUP BY production_company
HAVING total_votes > 0
ORDER BY total_votes DESC
LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
WITH ActorRatings AS (
    SELECT
        rm.name_id,
        n.name AS actor_name,
        SUM(r.avg_rating * r.total_votes) AS weighted_sum_rating,
        SUM(r.total_votes) AS total_votes,
        COUNT(DISTINCT rm.movie_id) AS movie_count
    FROM names AS n
    JOIN role_mapping AS rm ON n.id = rm.name_id
    JOIN movie AS m ON rm.movie_id = m.id
    JOIN ratings AS r ON m.id = r.movie_id
    WHERE m.country = 'India'
    GROUP BY rm.name_id, n.name
    HAVING COUNT(DISTINCT rm.movie_id) >= 5
)
    SELECT 
        actor_name,
        total_votes,
        movie_count,
        (weighted_sum_rating / total_votes) AS actor_avg_rating,
        RANK() OVER (ORDER BY (weighted_sum_rating / total_votes) DESC, total_votes DESC) AS actor_rank
    FROM ActorRatings





-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

SELECT n.name AS actress_name,
    SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actress_avg_rating,
    COUNT(DISTINCT rm.movie_id) AS movie_count,
    SUM(r.total_votes) AS total_votes,
    RANK() OVER (ORDER BY SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) DESC, SUM(r.total_votes) DESC) AS actress_rank
FROM 
    names AS n
JOIN 
    role_mapping AS rm ON n.id = rm.name_id
JOIN 
    movie AS m ON rm.movie_id = m.id
JOIN 
    ratings AS r ON m.id = r.movie_id
WHERE 
    rm.category='actress' AND m.country = 'India' AND m.languages LIKE '%Hindi%'
GROUP BY 
    rm.name_id, n.name
HAVING 
    COUNT(DISTINCT rm.movie_id) >= 3
ORDER BY 
    actress_rank
LIMIT 5;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

SELECT
    m.title AS movie_name,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        ELSE 'Flop'
    END AS movie_category
FROM movie m
JOIN ratings r ON m.id = r.movie_id
JOIN genre g ON m.id = g.movie_id
WHERE g.genre = 'Thriller' AND r.total_votes >= 25000
ORDER BY r.avg_rating DESC;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/

SELECT genre, ROUND(AVG(duration),2) AS avg_duration, 
ROUND(SUM(AVG(duration)) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS running_total_duration,
ROUND(AVG(AVG(duration)) OVER (ORDER BY genre ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg_duration
FROM movie AS m 
INNER JOIN 
genre AS g ON m.id = g.movie_id
GROUP BY  genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Top 3 Genres based on most number of movies

WITH TopGenres AS (
    SELECT 
        genre, 
        COUNT(movie_id) AS movie_count
    FROM genre
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3
),
TopMovies AS (
    SELECT 
        g.genre,
        m.year,
        m.title AS movie_name,
        CAST(REPLACE(m.worlwide_gross_income, '$', '') AS UNSIGNED) AS worldwide_gross_income,
        ROW_NUMBER() OVER (PARTITION BY g.genre, m.year ORDER BY CAST(REPLACE(m.worlwide_gross_income, '$', '') AS UNSIGNED) DESC) AS movie_rank
    FROM genre g
    INNER JOIN movie m ON g.movie_id = m.id
    WHERE g.genre IN (SELECT genre FROM TopGenres)
)
SELECT 
    genre, 
    year, 
    movie_name, 
    worldwide_gross_income, 
    movie_rank
FROM TopMovies
WHERE movie_rank <= 5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/

SELECT 
    m.production_company,
    COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM 
    movie AS m
INNER JOIN 
    ratings AS r ON m.id = r.movie_id
WHERE 
    r.median_rating >= 8
    AND POSITION(',' IN m.languages) > 0
    AND m.production_company IS NOT NULL -- Exclude NULL production companies
GROUP BY 
    m.production_company
ORDER BY 
    movie_count DESC
LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/


WITH superhit_drama_movies AS (
    SELECT 
        g.movie_id
    FROM 
        genre g
    JOIN 
        ratings r ON g.movie_id = r.movie_id
    WHERE 
        g.genre = 'Drama' AND r.avg_rating > 8
),
actress_ratings AS (
    SELECT 
        rm.name_id,
        n.name AS actress_name,
        COUNT(DISTINCT rm.movie_id) AS movie_count,
        SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actress_avg_rating,
        SUM(r.total_votes) AS total_votes
    FROM 
        role_mapping rm
    JOIN 
        superhit_drama_movies sdm ON rm.movie_id = sdm.movie_id
    JOIN 
        ratings r ON rm.movie_id = r.movie_id
    JOIN 
        names n ON rm.name_id = n.id
    WHERE 
        rm.category = 'actress'
    GROUP BY 
        rm.name_id, n.name
),
ranked_actresses AS (
    SELECT 
        actress_name,
        total_votes,
        movie_count,
        actress_avg_rating,
        RANK() OVER (
            ORDER BY 
                actress_avg_rating DESC, 
                total_votes DESC, 
                actress_name ASC
        ) AS actress_rank
    FROM 
        actress_ratings
)
SELECT 
    actress_name,
    total_votes,
    movie_count,
    ROUND(actress_avg_rating, 4) AS actress_avg_rating,
    actress_rank
FROM 
    ranked_actresses
WHERE 
    actress_rank <= 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/

WITH top_9_directors
     AS( SELECT dm.name_id, n.name, dm.movie_id, duration, r.avg_rating, total_votes, m.date_published,
                Lead(m.date_published,1) OVER(partition BY dm.name_id ORDER BY m.date_published,movie_id ) AS next_date_published
          FROM director_mapping  AS dm
               INNER JOIN names  AS n
                     ON n.id = dm.name_id
               INNER JOIN movie AS m
                     ON m.id = dm.movie_id
               INNER JOIN ratings AS r
                     ON r.movie_id = m.id ), top_directors AS
( SELECT *,
         Datediff(next_date_published, date_published) AS date_difference
  FROM   top_9_directors )
SELECT   name_id AS director_id,name AS director_name,Count(movie_id) AS number_of_movies,Round(Avg(date_difference),2) AS avg_inter_movie_days,Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes) AS total_votes,Min(avg_rating) AS min_rating,Max(avg_rating) AS max_rating,Sum(duration) AS total_duration
FROM top_directors
GROUP BY director_id
ORDER BY Count(movie_id) DESC 
limit 9;






