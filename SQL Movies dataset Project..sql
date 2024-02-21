-- Retrieve data using text query (SELECT, WHERE, DISTINCT, LIKE)

-- Q1 Simply print all the movies 
	SELECT * from movies;

-- Q2 Get movie title and industry for all the movies
	SELECT title, industry from movies;

-- Q3 Print all moves from Hollywood 
	SELECT * from movies where industry="Hollywood";
  
-- Q4 Print all moves from Bollywood 
	SELECT * from movies where industry="Bollywood";

-- Q5 Get all the unique industries in the movies database
	SELECT DISTINCT industry from movies;

-- Q6 Select all movies that starts with THOR
	SELECT * from movies where title LIKE 'THOR%';

-- Q7 Select all movies that have 'America' word in it. That means to select all captain America movies
	SELECT * from movies where title LIKE '%America%';

-- Q8 How many hollywood movies are present in the database?
	SELECT COUNT(*) from movies where industry="Hollywood";

-- Q9 Print all  movies where we don't know the value of the studio
	SELECT * FROM movies WHERE studio='';

-- Retrieve data using numeric query (BETWEEN, IN, ORDER BY, LIMIT, OFFSET)

-- Q10 Which movies had greater than 9 imdb rating?
	SELECT * from movies where imdb_rating>9;

-- Q11 Movies with rating between 6 and 8
	SELECT * from movies where imdb_rating>=6 and imdb_rating <=8;
						-- (OR)
	SELECT * from movies where imdb_rating BETWEEN 6 AND 8;

-- Q12 Select all movies whose release year can be 2018 or 2019 or 2022
	-- Approach1:
	SELECT * from movies where release_year=2022 
	or release_year=2019 or release_year=2018;

	-- Approach2:
	SELECT * from movies where release_year IN (2018,2019,2022);

-- Q13 All movies where imdb rating is not available (imagine the movie is just released)
	SELECT * from movies where imdb_rating IS NULL;

-- Q14 All movies where imdb rating is available 
	SELECT * from movies where imdb_rating IS NOT NULL;

-- Q15 Print all bollywood movies ordered by their imdb rating
	SELECT * 
        from movies WHERE industry = "bollywood"
        ORDER BY imdb_rating ASC;

-- Q16 Print first 5 bollywood movies with highest rating
	SELECT * 
        from movies WHERE industry = "bollywood"
        ORDER BY imdb_rating DESC LIMIT 5;

-- Q17 Select movies starting from second highest rating movie till next 5 movies for bollywood
	SELECT * 
        from movies WHERE industry = "bollywood"
        ORDER BY imdb_rating DESC LIMIT 5 OFFSET 1;

-- Summary Analytics Using (COUNT, MAX, MIN, AVG, GROUP BY)
 
-- Q18 How many total movies do we have in our movies table?
	SELECT COUNT(*) from movies;
	
-- Q19 Select highest imdb rating for bollywood movies
	SELECT MAX(imdb_rating) from movies where industry="Bollywood";

-- Q20 Select lowest imdb rating for bollywood movies
	SELECT MIN(imdb_rating) from movies where industry="Bollywood";

-- Q21 Print average rating of Marvel Studios movies
	SELECT AVG(imdb_rating) from movies where studio="Marvel Studios";
	SELECT ROUND(AVG(imdb_rating),2) from movies where studio="Marvel Studios";

-- Q22 Print min, max, avg rating of Marvel Studios movies
	SELECT 
           MIN(imdb_rating) as min_rating, 
           MAX(imdb_rating) as max_rating, 
           ROUND(AVG(imdb_rating),2) as avg_rating
        FROM movies 
        WHERE studio="Marvel Studios";

-- Q23 Print count of movies by industry
	SELECT 
           industry, count(industry) 
        FROM movies
        GROUP BY industry;

-- Q24 Same thing but add average rating
	SELECT 
            industry, 
            count(industry) as movie_count,
            avg(imdb_rating) as avg_rating
	FROM movies
	GROUP BY industry;

-- Q25 Count number of movies released by a given production studio
	SELECT 
	    studio, count(studio) as movies_count 
        from movies WHERE studio != ''
	GROUP BY studio
	ORDER BY movies_count DESC;

-- Q26 What is the average rating of movies per studio and also order them by average rating in descending format?
	SELECT 
	   studio, 
	   count(studio) as cnt, 
	   round(avg(imdb_rating), 1) as avg_rating 
	from movies WHERE studio != ''
	GROUP BY studio
        order by avg_rating DESC;

-- HAVING Clause

-- Q27 Print all the years where more than 2 movies were released
	SELECT 
           release_year, 
           count(*) as movies_count
	FROM movies    
	GROUP BY release_year
	HAVING movies_count>2
	ORDER BY movies_count DESC;

-- Calculated Columns (IF, CASE, YEAR, CURYEAR)

-- Q28 Print actor name, their birth_year and age
	SELECT 
           name, birth_year, (YEAR(CURDATE())-birth_year) as age
	FROM actors;

-- Q29 Print profit for every movie
	SELECT 
	    *, 
           (revenue-budget) as profit 
	from financials;

-- Q30 Print revenue of all movies in INR currency
	SELECT 
           movie_id, 
	   revenue, 
           currency, 
           unit,
           IF (currency='USD', revenue*77, revenue) as revenue_inr
	FROM financials;

-- Q31 Get all the unique units from financial table
	select 
	   distinct unit 
	From financials;

-- Q32 Print revenue in millions 
	SELECT 
           movie_id, revenue, currency, unit,
           CASE
              WHEN unit="Thousands" THEN revenue/1000
              WHEN unit="Billions" THEN revenue*1000
             ELSE revenue
           END as revenue_mln
	FROM financials
    
-- Q33 Print revenue in millions of all movies in INR currency
	SELECT *,
			 CASE
				WHEN currency ="USD" THEN ROUND(revenue*77)
				WHEN unit="Thousands" THEN ROUND(revenue/1000)
				WHEN unit="Billions" THEN ROUND(revenue*1000)
			  ELSE revenue
             END as revenue_in_mln_inr
	FROM financials
    
-- SQL Joins (INNER, LEFT, RIGHT, FULL)

-- Q34 Print all movies along with their title, budget, revenue, currency and unit. [INNER JOIN]
	SELECT 
            m.movie_id, title, budget, revenue, currency, unit 
	FROM movies m
	INNER JOIN financials f
	ON m.movie_id=f.movie_id;

-- Q35 Perform LEFT JOIN on above discussed scenario
	SELECT 
            m.movie_id, title, budget, revenue, currency, unit 
	FROM movies m
	LEFT JOIN financials f
	ON m.movie_id=f.movie_id;

-- Q36 Perform RIGHT JOIN on above discussed scenario
	SELECT 
            m.movie_id, title, budget, revenue, currency, unit 
	FROM movies m
	RIGHT JOIN financials f
	ON m.movie_id=f.movie_id;

-- Q37 Perform FULL JOIN using 'Union' on above two tables [movies, financials]
	SELECT 
            m.movie_id, title, budget, revenue, currency, unit 
	FROM movies m
	LEFT JOIN financials f
	ON m.movie_id=f.movie_id

	UNION

	SELECT 
            m.movie_id, title, budget, revenue, currency, unit 
	FROM movies m
	RIGHT JOIN financials f
	ON m.movie_id=f.movie_id;

-- Q38 Interchanging the position of Left and Right Tables
	Select 
	    m.movie_id, title, revenue 
	from movies m 
        left join financials f
        on m.movie_id = f.movie_id;

    
	Select 
	    m.movie_id, title, revenue 
	from financials f 
        left join movies m
        on m.movie_id = f.movie_id;

-- Q39 Replacing 'ON' with 'USING' while joining conditions
	Select 
	   m.movie_id, title, revenue 
	from movies m 
        left join financials f
	USING (movie_id);
      
-- Q40 Interchanging the position of Left and Right Tables with 'USING' conditions
	Select 
	    m.movie_id, title, revenue 
	from movies m 
        left join financials f
        USING (movie_id);
	
	Select 
	    m.movie_id, title, revenue 
	from financials f 
        left join movies m
       USING (movie_id);     
      
-- Analytics on Tables

-- Q41 Find profit for all movies 
	SELECT 
           m.movie_id, title, budget, revenue, currency, unit, 
	   (revenue-budget) as profit 
	FROM movies m
	JOIN financials f
	ON m.movie_id=f.movie_id;

-- Q42 Find profit for all movies in bollywood
	SELECT 
           m.movie_id, title, budget, revenue, currency, unit, 
	   (revenue-budget) as profit 
	FROM movies m
	JOIN financials f
	ON m.movie_id=f.movie_id
	WHERE m.industry="Bollywood";

-- Q43 Find profit of all bollywood movies and sort them by profit amount (Make sure the profit be in millions for better comparisons)
	SELECT 
    	    m.movie_id, title revenue, currency, unit, 
            CASE 
                WHEN unit="Thousands" THEN ROUND((revenue-budget)/1000,2)
        	WHEN unit="Billions" THEN ROUND((revenue-budget)*1000,2)
                ELSE revenue-budget
            END as profit_mln
	FROM movies m
	JOIN financials f 
	ON m.movie_id=f.movie_id
	WHERE m.industry="Bollywood"
	ORDER BY profit_mln DESC;

-- Join More Than Two Tables

-- Q44 Show comma separated actor names for each movie
	SELECT 
            m.title, group_concat(name separator " | ") as actors
	FROM movies m
	JOIN movie_actor ma ON m.movie_id=ma.movie_id
	JOIN actors a ON a.actor_id=ma.actor_id
	GROUP BY m.movie_id;

-- Q45 Print actor name and all the movies they are part of
	SELECT 
            a.name, GROUP_CONCAT(m.title SEPARATOR ' | ') as movies
	FROM actors a
	JOIN movie_actor ma ON a.actor_id=ma.actor_id
	JOIN movies m ON ma.movie_id=m.movie_id
	GROUP BY a.actor_id;

-- Q46 Print actor name and how many movies they acted in
	SELECT 
            a.name, 
            GROUP_CONCAT(m.title SEPARATOR ' | ') as movies,
            COUNT(m.title) as num_movies
	FROM actors a
	JOIN movie_actor ma ON a.actor_id=ma.actor_id
	JOIN movies m ON ma.movie_id=m.movie_id
	GROUP BY a.actor_id
	ORDER BY num_movies DESC;

-- Subqueries

-- Q47 Select a movie with highest imdb_rating
	-- without subquery
	select * from movies order by imdb_rating desc limit 1;
	
	-- with subquery
	select * from movies where imdb_rating=(select max(imdb_rating) from movies);

-- Q48 Select a movie with highest and lowest imdb_rating
	-- without subquery
	select * from movies where imdb_rating in (1.9, 9.3);

	-- with subquery
	select * from movies where imdb_rating in (
        				(select min(imdb_rating) from movies), 
    					(select max(imdb_rating) from movies)
						);

-- Q49 Select all the actors whose age is greater than 70 and less than 85
	select 
	    actor_name, age
	FROM 
  	    (Select
                name as actor_name,
                (year(curdate()) - birth_year) as age
    	     From actors
            ) AS actors_age_table
	WHERE age > 70 AND age < 85;

-- ANY, ALL Operators

-- Q50 select actors who acted in any of these movies (101,110, 121)
	select * From actors WHERE actor_id = ANY(select actor_id From movie_actor where movie_id IN (101, 110, 121));

-- Q51 select all movies whose rating is greater than *any* of the marvel movies rating
	select * from movies where imdb_rating > ANY(select imdb_rating from movies where studio="Marvel studios");

-- Q52 Above, can be achieved in another way too (sub query, min)
	select * from movies where imdb_rating > (select min(imdb_rating) from movies where studio="Marvel studios");

-- Q53 select all movies whose rating is greater than *all* of the marvel movies rating
	select * from movies where imdb_rating > ALL(select imdb_rating from movies where studio="Marvel studios");

-- Q54 Above, can be achieved in another way too (sub query, max)
	select * from movies where imdb_rating > (select max(imdb_rating) from movies where studio="Marvel studios");

-- Co-Related Subquery

-- Q55 Get the actor id, actor name and the total number of movies they acted in.
	SELECT 
           actor_id, 
           name, 
	   (SELECT COUNT(*) FROM movie_actor WHERE actor_id = actors.actor_id) as movies_count
	FROM actors
	ORDER BY movies_count DESC;

-- Q56 Above, can be achieved by using Joins too!
	select 
	    a.actor_id, 
	    a.name, 
	    count(*) as movie_count
	from movie_actor ma
	join actors a
	on a.actor_id=ma.actor_id
	group by actor_id
	order by movie_count desc;

-- Common Table Expression (CTE)

-- Q57 Select all the actors whose age is greater than 70 and less than 85 [Previously, we have used sub-queries to solve this. Now we use CTE's]
	with actors_age as 
	   (select
                name as actor_name,
                year(curdate()) - birth_year as age
            from actors
	    )
	select actor_name, age from actors_age where age > 70 and age < 85;


-- Q58 Movies that produced 500% profit and their rating was less than average rating for all movies
	with 
	   x as 
	      (select 
		   *, 
                   (revenue-budget)*100/budget as pct_profit
               from financials),
    	   y as 
	      (select * from movies where imdb_rating < (select avg(imdb_rating) from movies))
	select 
	    x.movie_id, y.title, x.pct_profit, y.imdb_rating
	from x
	join y
	on x.movie_id=y.movie_id
	where x.pct_profit > 500;


-- Q59 Above, can be achieved using sub-query too (But, code readability is less here compared to CTE's)
	select 
	   x.movie_id, y.title, x.pct_profit, y.imdb_rating
	from ( 
              select
                  *, 
                  (revenue-budget)*100/budget as pct_profit
              from financials
	     ) x
	join 
	     (select * from movies where imdb_rating < (select avg(imdb_rating) from movies)) y
	on x.movie_id=y.movie_id
	where pct_profit>500;

-- Insert Statement

-- Q60 Simple insert for new record in movies
	INSERT INTO movies VALUES (141, "Bahuhbali 3", "Bollywood", 2030, 9.0, "Arka Media Works", 2);

-- Q61 Insert with NULL or DEFAULT values
	INSERT INTO movies VALUES (142, "Thor 10", "Hollywood", NULL, DEFAULT, "Marvel Studios", 5);

-- Q62 Same insert with column names
	INSERT INTO movies (movie_id, title, industry, language_id) VALUES (143, "Pushpa 5", "Bollywood", 2);

-- Q63 Insert with invalid language_id. Foreign key constraint fails
	INSERT INTO movies (movie_id, title, industry, language_id) VALUES (144, "Pushpa 6", "Bollywood", 10);

-- Q64 Insert multiple rows
	INSERT INTO movies 
    	     (movie_id, title, industry, language_id)
	VALUES 
    	     (145, "Inception 2", "Hollywood", 5),
             (146, "Inception 3", "Hollywood", 5),
             (147, "Inception 4", "Hollywood", 5);

-- Update and Delete

-- Q65 Say THOR 10 movie is released in 2050, and you want to update the rating now :)
	UPDATE movies 
	SET imdb_rating=8, release_year=2050
	WHERE movie_id=142;

-- Q66 Update multiple records. [Update all studios with 'Warner Bros. Pictures' for all the Inception movies records] 
	UPDATE movies 
	SET studio='Warner Bros. Pictures'
	WHERE title like "Inception %";

-- Q67 Delete all new inception movies
	DELETE FROM movies 
	WHERE  title like "Inception %";

-- Q68 Another delete to restore the database to normal again
	DELETE FROM movies 
	WHERE movie_id in (141, 142, 143);