USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT Count(*) count,
       'movie'  table_name
FROM   movie
UNION
SELECT Count(*)  count,
       'ratings' table_name
FROM   ratings
UNION
SELECT Count(*) count,
       'names'  table_name
FROM   names
UNION
SELECT Count(*) count,
       'genre'  table_name
FROM   genre
UNION
SELECT Count(*)       count,
       'role_mapping' table_name
FROM   role_mapping
UNION
SELECT Count(*)           count,
       'director_mapping' table_name
FROM   director_mapping; 

/* Insights: The number of rows in movie and ratings is 7997 i.e. one to one mapping, names has 25735 rows, genre has 14662 rows, 
role_mapping has 15615 rows, director_mapping has 3867 rows*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT "id" column_name
FROM   dual
WHERE  EXISTS(SELECT 1
              FROM   movie
              WHERE  id IS NULL)
UNION ALL
SELECT "title" column_name
FROM   dual
WHERE  EXISTS(SELECT 1
              FROM   movie
              WHERE  title IS NULL)
UNION ALL
SELECT "year" column_name
FROM   dual
WHERE  EXISTS(SELECT 1
              FROM   movie
              WHERE  year IS NULL)
UNION ALL
SELECT "date_published" column_name
FROM   dual
WHERE  EXISTS(SELECT 1
              FROM   movie
              WHERE  date_published IS NULL)
UNION ALL
SELECT "duration" column_name
FROM   dual
WHERE  EXISTS(SELECT 1
              FROM   movie
              WHERE  duration IS NULL)
UNION ALL
SELECT "country" column_name
FROM   dual
WHERE  EXISTS(SELECT 1
              FROM   movie
              WHERE  country IS NULL)
UNION ALL
SELECT "worlwide_gross_income" column_name
FROM   dual
WHERE  EXISTS(SELECT 1
              FROM   movie
              WHERE  worlwide_gross_income IS NULL)
UNION ALL
SELECT "languages" column_name
FROM   dual
WHERE  EXISTS(SELECT 1
              FROM   movie
              WHERE  languages IS NULL)
UNION ALL
SELECT "production_company" column_name
FROM   dual
WHERE  EXISTS(SELECT 1
              FROM   movie
              WHERE  production_company IS NULL); 
              
-- Insights: 4 columns namely country, worlwide_gross_income, languages and production_company has null values
              
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
-- Type your code below:

SELECT year as Year,
       Count(id) number_of_movies
FROM   movie
GROUP  BY year;

-- Insights: Year 2017 has maximum number of movies published i.e. 3052, followed by 2018 having 2944 movies published and 2019 having 2001 movies published

SELECT Month(date_published) month_num,
       Count(id)              number_of_movies
FROM   movie
GROUP  BY month_num
ORDER BY count(id) desc; 

-- Insights: March has the highest number of movies published followed by September and January.

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT Count(id) number_of_movies
FROM   movie
WHERE  ( country LIKE '%USA%'
          OR country LIKE '%India%' )
       AND year = 2019; 

-- Insights: 1059 movies were published in USA and  India in the year 2019.

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM   genre; 


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT g.genre,
       count(m.id) number_of_movies
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY g.genre
ORDER  BY count(m.id) DESC
LIMIT  1; 
-- Insights: Drama genre has highest number of movies published. 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH GENRE_INFO
     AS (SELECT genre,
                movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(genre) = 1)
SELECT g.genre,
       Count(m.id) number_of_movies
FROM   movie m
       INNER JOIN GENRE_INFO g
               ON m.id = g.movie_id; 

-- Insights: Drama genre has 3289 movies which only belong to that genre




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
-- Type your code below:
SELECT g.genre,
       ROUND(Avg(m.duration),2) avg_duration
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY g.genre; 

-- Insight: Drama has highest avg_duration of movies with an avg_duration of 106.77 mins.





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
-- Type your code below:

WITH GENRE_RANKING
     AS (SELECT gen.genre,
                Count(mov.id)                    movie_count,
                DENSE_RANK()
                  OVER(
                    ORDER BY Count(mov.id) DESC) genre_rank
         FROM   movie mov
                INNER JOIN genre gen
                        ON mov.id = gen.movie_id
         GROUP  BY gen.genre
         ORDER  BY Count(mov.id) DESC)
SELECT *
FROM   GENRE_RANKING
WHERE  genre = 'Thriller'; 

-- Insight : Thriller genre has rank 3








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
-- Type your code below:
SELECT Min(avg_rating)    min_avg_rating,
       Max(avg_rating)    max_avg_rating,
       Min(total_votes)   min_total_votes,
       Max(total_votes)   max_total_votes,
       Min(median_rating) min_median_rating,
       Max(median_rating) max_median_rating
FROM   ratings; 

-- Insight: Min avg_rating is 1.0 and max avg_rating is 10. Min total_votes are 100 and max total_votes are 725138.
--          Min median_rating is 1 and max median_rating is 10 
    

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
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH RATING_INFO
     AS (SELECT m.title,
                r.avg_rating,
                DENSE_RANK()
                  OVER (
                    ORDER BY r.avg_rating DESC) movie_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id)
SELECT *
FROM   RATING_INFO
WHERE  movie_rank <= 10; 

-- Insight : Kirket and Love in Kilnerry has rank 1 with avg_rating as 10.0,
--           followed by Gini Helida Kathe having rank 2 with an avg_rating 9.8
--           and Runam having rank 3 with an avg_rating 9.7.





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
-- Type your code below:
-- Order by is good to have
SELECT median_rating,
       Count(movie_id) movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 

-- Insight: median rating 7 has highest number of movies.







/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
       Count(id)                    AS movie_count,
       DENSE_RANK()
         OVER(
           ORDER BY Count(id) DESC) prod_company_rank
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  r.avg_rating > 8
       AND production_company IS NOT NULL
GROUP  BY production_company; 

-- Insight: Dream Warrior Pictures and National theatre Live both production companies have 3 hit movies with avg_rating > 8.






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
-- Type your code below:
SELECT g.genre,
       Count(m.id) movie_count
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  Month(m.date_published) = 3
       AND m.year = 2017
       AND m.country LIKE '%USA%'
       AND r.total_votes > 1000
GROUP  BY g.genre
ORDER  BY movie_count DESC; 

-- Insight : During March 2017, Drama genre had maximum number of movies (24) published in USA having more than 1000 votes.







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
-- Type your code below:
SELECT m.title,
       r.avg_rating,
       g.genre
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.title LIKE 'The%'
       AND r.avg_rating > 8
ORDER BY r.avg_rating DESC;

SELECT m.title,
       r.median_rating,
       g.genre
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.title LIKE 'The%'
       AND r.median_rating > 8
       ORDER BY r.avg_rating DESC;

-- Insight : The Brighton Miracle, The Colour of Darkness and The Blue Elephant 2 are the top three movies based on avg_rating as well as median_rating.





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT Count(m.id) movie_count
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND r.median_rating = 8; 
-- Insight: Of the movies published between 1 April 2018 and 1 April 2019, 361 movies had median rating as 8.






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT Sum(r.total_votes)no_of_votes,
       "german"          language
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.languages LIKE '%German%'
UNION
SELECT Sum(r.total_votes)no_of_votes,
       "italian"         language
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.languages LIKE '%Italian%'; 
-- Insight: German movie received more votes than italian movies. 





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
-- Type your code below:
SELECT (SELECT Count(*)
        FROM   names
        WHERE  NAME IS NULL)             name_nulls,
       (SELECT Count(*)
        FROM   names
        WHERE  height IS NULL)           height_nulls,
       (SELECT Count(*)
        FROM   names
        WHERE  date_of_birth IS NULL)    date_of_birth_nulls,
       (SELECT Count(*)
        FROM   names
        WHERE  known_for_movies IS NULL) known_for_movies_nulls
FROM   dual; 

-- Insight: Only name column doesnt have null values.


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
-- Type your code below:

WITH top_3_genres
     AS (SELECT g.genre,
                DENSE_RANK()
                  OVER(
                    ORDER BY Count(m.id) DESC) genre_rank
         FROM   movie m
                INNER JOIN genre g
                        ON g.movie_id = m.id
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         WHERE  r.avg_rating > 8
         GROUP  BY g.genre),
     top_3_directors
     AS (SELECT n.NAME,
                Count(d.movie_id)              movie_count,
                DENSE_RANK()
                  OVER(
                    ORDER BY Count(m.id) DESC) director_rank
         FROM   names n
                INNER JOIN director_mapping d
                        ON n.id = d.name_id
                INNER JOIN movie m
                        ON d.movie_id = m.id
                INNER JOIN genre g
                        ON g.movie_id = m.id
         WHERE  g.genre IN (SELECT genre
                            FROM   top_3_genres
                            WHERE  genre_rank <= 3)
                AND m.id IN (SELECT movie_id
                             FROM   ratings
                             WHERE  avg_rating > 8)
         GROUP  BY n.NAME)
SELECT NAME,
       movie_count
FROM   top_3_directors
WHERE  director_rank <= 3; 

/*Insight: James Mangold,Anthony Russo and Joe Russo are the top 3 diretcors based on number of movies from top 3 genres 
having avg_rating > 8 */





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
-- Type your code below:
WITH ACTOR_INFO
     AS (SELECT n.NAME                         actor_name,
                Count(rm.movie_id)             movie_count,
                DENSE_RANK()
                  OVER(
                    ORDER BY Count(m.id) DESC) actor_rank
         FROM   names n
                INNER JOIN role_mapping rm
                        ON n.id = rm.name_id
                INNER JOIN movie m
                        ON rm.movie_id = m.id
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         WHERE  rm.category = 'Actor'
                AND r.median_rating >= 8
         GROUP  BY n.NAME)
SELECT actor_name,
       movie_count
FROM   ACTOR_INFO
WHERE  actor_rank <= 2; 

-- Insight: The top 2 actors based on number of movies having avg_rating>=8 are Mammootty and Mohanlal.




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
-- Type your code below:
WITH PROD_COMP_INFO
     AS (SELECT m.production_company,
                Sum(r.total_votes)                    vote_count,
                DENSE_RANK()
                  OVER(
                    ORDER BY Sum(r.total_votes) DESC) prod_comp_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         GROUP  BY m.production_company)
SELECT *
FROM   PROD_COMP_INFO
WHERE  prod_comp_rank <= 3; 

-- Insights : Marvel Studios is the top production company based on toal_votes.





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
-- Type your code below:
SELECT n.NAME                     											actor_name,
       Sum(r.total_votes)         											total_votes,
	   Count(rm.movie_id)        		 									movie_count,
       Round(Sum(r.total_votes * r.avg_rating) / Sum(r.total_votes), 2)     actor_avg_rating,
       DENSE_RANK()
         OVER(
           ORDER BY Sum(r.total_votes*r.avg_rating)/Sum(r.total_votes) DESC,
         Sum(r.total_votes) DESC) actor_rank
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN movie m
               ON rm.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  rm.category = 'Actor'
       AND m.country LIKE '%India%'
GROUP  BY n.NAME
HAVING Count(rm.movie_id) >= 5; 
/* Insights: Vijay Sethupati is the top actor in Indian movies terms of weighted avg of rating based on total votes 
             having done atleast 5 Indian Movies.*/







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
-- Type your code below:
with actress_info as (SELECT n.NAME                                      actoress_name,
       Sum(r.total_votes)                                                total_votes,
       Count(rm.movie_id)                                                movie_count,
       ROUND(SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes),2)       actress_avg_rating,
       RANK()
         OVER(
           ORDER BY SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes) DESC, Sum(r.total_votes) DESC) actress_rank
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN movie m
               ON rm.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  rm.category = 'Actress'
       AND m.country like '%India%'
       AND m.languages like '%Hindi%'
GROUP  BY n.NAME
HAVING Count(rm.movie_id) >= 3)
select * from actress_info where actress_rank <=5; 

/* Insights: Taapsee Pannu is the top actress in Hindi Indian movies in terms of weigthed avg of rating based on votes having done atleast
             3 indian movies*/



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT m.title,
       ( CASE
           WHEN r.avg_rating > 8 THEN 'Superhit movies'
           WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
           WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
           WHEN r.avg_rating < 5 THEN 'Flop movies'
         END ) rating_category
FROM   ratings r
       INNER JOIN movie m
               ON m.id = r.movie_id
       INNER JOIN genre g
               ON g.movie_id = m.id
                  AND g.genre = 'Thriller'; 






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
-- Type your code below:
SELECT g.genre, Round(Avg(m.duration),2)      AS avg_duration,
           Round(Sum(m.duration) OVER W1,2)   AS running_total_duration,
           Round(Avg(m.duration) OVER W2,2)   AS moving_avg_duration
FROM       genre g
INNER JOIN movie m
ON         m.id=g.movie_id
GROUP BY   g.genre WINDOW w1 AS (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
           w2                AS (ORDER BY genre ROWS UNBOUNDED PRECEDING);








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
-- Type your code below:
/*Observation : Since worlwide_gross_income is not in numeric type and also contains different currencies we will have to make it uniform.
Strategy: Using case statement and CTE to format data in the column worlwide_gross_income. Replacing null values with 0, removing INR 
and $ sign. Converting USD values to INR by taking USD conversion rate as 80 INR approximately. Converting the result to decimal. */
-- Top 3 Genres based on most number of movies

WITH TOP_3_GENRES
     AS (SELECT genre,
                RANK()
                  OVER(
                    ORDER BY Count(movie_id) DESC) genre_rank
         FROM   genre
         GROUP  BY genre),
    WORLD_WIDE_INCOME AS (
    Select (CASE WHEN substr(worlwide_gross_income,1,1)= '$' THEN
		CAST(replace(worlwide_gross_income, '$','') AS DECIMAL(10))*80
        WHEN substr(worlwide_gross_income,1,1)= 'I' THEN
		CAST(replace(worlwide_gross_income, 'INR','') AS DECIMAL(10))
        WHEN worlwide_gross_income IS NULL THEN 0
    END) AS
                worlwide_gross_income, id from movie
		),
     MOVIE_INFO
     AS (SELECT g.genre,
                m.year,
                m.title                                movie_name,
                w.worlwide_gross_income                worldwide_gross_income,
                DENSE_RANK()
                  OVER(
                    PARTITION BY m.year
                    ORDER BY w.worlwide_gross_income DESC) movie_rank
         FROM   movie m,
                genre g,
                TOP_3_GENRES t3g,
                WORLD_WIDE_INCOME w
         WHERE  m.id = g.movie_id
                AND g.genre = t3g.genre
                AND w.id = m.id
                AND genre_rank <= 3)
SELECT *
FROM   MOVIE_INFO
WHERE  movie_rank <= 5; 

-- Insight : Highest grossing movie of 2017 is The Fate of the Furious, for 2018 is Bohemian Rhapsody and for 2019 is Avengers: Endgame.





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
-- Type your code below:
WITH PROD_COMP_INFO
     AS (SELECT production_company,
                COUNT(id)                    movie_count,
                DENSE_RANK()
                  OVER(
                    ORDER BY COUNT(id) DESC) prod_comp_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         WHERE  POSITION(',' IN languages) > 0
                AND production_company IS NOT NULL
                AND r.median_rating >= 8
         GROUP  BY production_company)
SELECT *
FROM   PROD_COMP_INFO
WHERE  prod_comp_rank <= 2; 

-- Insight : Star Cinema is the top production company in terms of number of hit multilingual movies having meidan_rating >= 8.



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH ACTRESS_INFO
     AS (SELECT n.name                         actress_name,
                r.total_votes,
                Count(m.id)                    movie_count,
                r.avg_rating                   actress_avg_rating,
                DENSE_RANK()
                  OVER(
                    ORDER BY Count(m.id) DESC) actress_rank
         FROM   ratings r
                INNER JOIN movie m
                        ON r.movie_id = m.id
                INNER JOIN role_mapping rm
                        ON rm.movie_id = m.id
                INNER JOIN names n
                        ON rm.name_id = n.id
         WHERE  r.avg_rating > 8
                AND rm.category = 'Actress'
                AND m.id IN (SELECT movie_id
                             FROM   genre
                             WHERE  genre = 'Drama')
         GROUP  BY n.NAME)
SELECT *
FROM   ACTRESS_INFO
WHERE  actress_rank <= 3; 

-- Insight : Top 3 actresses in terms of movies having avg_rating>8 are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence





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
-- Type you code below:
WITH NEXT_PUBLISH_DATE_INFO
     AS (SELECT dm.name_id,
                m.date_published,
                LEAD(m.date_published, 1)
                  OVER(
                    PARTITION BY dm.name_id
                    ORDER BY m.date_published, m.id) next_date_published
         FROM   director_mapping dm
                INNER JOIN movie m
                        ON m.id = dm.movie_id),
     DIRECTOR_SUMMARY
     AS (SELECT dm.name_id                                                     director_id,
                n.name                                                         director_name,
                Count(m.id)                                                    number_of_movies,
                Sum(r.total_votes*r.avg_rating)/Sum(r.total_votes)             avg_rating,
                Sum(r.total_votes)                                             total_votes,
				Min(r.avg_rating)                                              min_rating,
                Max(r.avg_rating)                                              max_rating,
                Sum(duration)                                                  total_duration,
                DENSE_RANK()
                  OVER(
                    ORDER BY Count(m.id) DESC) director_rank
         FROM   names n
                INNER JOIN director_mapping dm
                        ON dm.name_id = n.id
                INNER JOIN movie m
                        ON m.id = dm.movie_id
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         GROUP  BY name_id)
SELECT ds.director_id,
       ds.director_name,
       ds.number_of_movies,
       Round(Avg(Datediff(npdi.next_date_published, npdi.date_published)),2) AS
       avg_inter_movie_days,
       Round(ds.avg_rating,2) as avg_rating,
       ds.total_votes,
       ds.min_rating,
       ds.max_rating,
       ds.total_duration
FROM   DIRECTOR_SUMMARY ds,
       NEXT_PUBLISH_DATE_INFO npdi
WHERE  npdi.next_date_published IS NOT NULL
       AND npdi.name_id = ds.director_id
       AND ds.director_rank <= 9
GROUP  BY ds.director_id; 

/* Insight : Count of movies is same for multiple directors hence the query returned 217 rows.
Top 9 directors from the results are A.L. Vijay, Andrew Jones, Ozgur Bakar, Justin Price, Sion Sono, Chris Stokes, Jesse V. Johnson,
Steven Soderbergh and Sam Liu
*/


