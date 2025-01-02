-- Create a new database
CREATE DATABASE tv_shows;

-- Switch to the new database
USE tv_shows;

-- Create the table structure
CREATE TABLE imdb (
    id VARCHAR(20) PRIMARY KEY,
    title VARCHAR(500),
    genres VARCHAR(500),
    averageRating FLOAT,
    numVotes INT,
    releaseYear INT
);

-- Create temporary table
CREATE TEMPORARY TABLE temp_imdb (
    id VARCHAR(255),
    title VARCHAR(500),
    genres VARCHAR(500),
    averageRating FLOAT,
    numVotes INT,
    releaseYear INT
);

-- Load data in the temporary table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IMDb Top 1000 TV Series.csv'
INTO TABLE temp_imdb
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, title, genres, averageRating, numVotes, releaseYear);

-- Data Cleaning

--  Retrieves all rows where the id appears more than once, ordered by id
SELECT * 
FROM temp_imdb 
WHERE id IN (
    SELECT id 
    FROM temp_imdb 
    GROUP BY id 
    HAVING COUNT(*) > 1
)
ORDER BY id;

-- Retrieve all records from temporary table imdb
SELECT * FROM temp_imdb;

-- Checking for null values
SELECT * FROM temp_imdb
WHERE id IS NULL OR title IS NULL OR averageRating IS NULL;

-- Delete records where id or title have null values
DELETE FROM temp_imdb
WHERE id IS NULL OR title IS NULL;

-- Inputing the records in main table from temp table. 
USE tv_shows;
INSERT INTO tv_shows.imdb (id, title, genres, averageRating, numVotes, releaseYear)
SELECT id, title, genres, averageRating, numVotes, releaseYear
FROM temp_imdb
WHERE id NOT IN (SELECT id FROM imdb);

-- Retrieve all records from the main table imdb
select * FROM imdb;

-- Describe the table
describe imdb;

-- SQL Data Analysis 

USE tv_shows;
SELECT * FROM tv_shows.imdb;

#1. Count the total number of records (TV shows) in the dataset:
SELECT COUNT(*) AS total_shows
FROM imdb;

#2. List all unique genres available in the dataset:
SELECT DISTINCT genres
FROM imdb;

#3. Identify the range of release years:
SELECT MIN(releaseYear) AS earliest_year, MAX(releaseYear) AS latest_year
FROM imdb;

#4. The average rating and average number of votes across all shows:
SELECT AVG(averageRating) AS avg_rating, AVG(numVotes) AS avg_votes
FROM imdb;

#5. Count the number of shows for each genre:
SELECT genres, COUNT(*) AS show_count
FROM imdb
GROUP BY genres
ORDER BY show_count DESC;

#6. Find the average rating for each genre
SELECT genres, AVG(averageRating) AS avg_rating
FROM imdb
GROUP BY genres
ORDER BY avg_rating DESC;

#7. Identify the most popular genre based on total votes:
SELECT genres, SUM(numVotes) AS total_votes
FROM imdb
GROUP BY genres
ORDER BY total_votes DESC
LIMIT 1;

#8. List the top 5 highest-rated shows:
SELECT id, title, averageRating
FROM imdb
ORDER BY averageRating DESC
LIMIT 5;

#9. List the top 5 most-voted shows:
SELECT id, title, numVotes
FROM imdb
ORDER BY numVotes DESC
LIMIT 5;

#10. Find the 5 lowest-rated shows:
SELECT id, title, averageRating
FROM imdb
ORDER BY averageRating ASC
LIMIT 5;

#11. Identify shows that have both high ratings (>=9) and high votes (>=50,000):
SELECT id, title, averageRating, numVotes
FROM imdb
WHERE averageRating >= 9 AND numVotes >= 50000
ORDER BY numVotes DESC;

#12. Find the number of shows released in each decade:
SELECT FLOOR(releaseYear / 10) * 10 AS decade, COUNT(*) AS show_count
FROM imdb
GROUP BY decade
ORDER BY decade;

#13. Calculate the average rating for each decade:
SELECT FLOOR(releaseYear / 10) * 10 AS decade, AVG(averageRating) AS avg_rating
FROM imdb
GROUP BY decade
ORDER BY decade;

#14. Shows with multiple genres (counting the commas in the genre column):
SELECT id, title, genres, (LENGTH(genres) - LENGTH(REPLACE(genres, ',', '')) + 1) AS genre_count
FROM imdb
ORDER BY genre_count DESC;

#15. Identify "hidden gems" (highly rated shows with low votes):
SELECT id, title, averageRating, numVotes
FROM imdb
WHERE averageRating >= 9 AND numVotes < 20000
ORDER BY averageRating DESC;

#16. Correlation check: Is there a relationship between ratings and votes?
SELECT averageRating, numVotes
FROM imdb;

#--finding correlation coefficient
SELECT 
    (COUNT(*) * SUM(averageRating * numVotes) - SUM(averageRating) * SUM(numVotes)) /
    SQRT(
        (COUNT(*) * SUM(POW(averageRating, 2)) - POW(SUM(averageRating), 2)) *
        (COUNT(*) * SUM(POW(numVotes, 2)) - POW(SUM(numVotes), 2))
    ) AS correlation_coefficient
FROM imdb;


 #17. What are the top 3 genres for each decade based on average rating?
SELECT g1.decade, g1.genres, g1.avg_rating
FROM (
    SELECT 
        FLOOR(releaseYear / 10) * 10 AS decade, 
        genres, 
        AVG(averageRating) AS avg_rating
    FROM imdb
    GROUP BY FLOOR(releaseYear / 10) * 10, genres
) g1
LEFT JOIN (
    SELECT 
        FLOOR(releaseYear / 10) * 10 AS decade, 
        genres, 
        AVG(averageRating) AS avg_rating
    FROM imdb
    GROUP BY FLOOR(releaseYear / 10) * 10, genres
) g2
ON g1.decade = g2.decade 
   AND g1.avg_rating < g2.avg_rating
GROUP BY g1.decade, g1.genres, g1.avg_rating
HAVING COUNT(g2.avg_rating) < 3
ORDER BY g1.decade, g1.avg_rating DESC;

#18. Most frequent genre combinations (split genres and count pairs): 
SELECT genres, COUNT(*) AS combination_count
FROM imdb
WHERE genres IS NOT NULL
GROUP BY genres
ORDER BY combination_count DESC
LIMIT 5;

#--splitting genres
SELECT genre, COUNT(*) AS genre_count
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(genres, ',', numbers.n), ',', -1)) AS genre
    FROM imdb
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    ) numbers ON CHAR_LENGTH(genres) - CHAR_LENGTH(REPLACE(genres, ',', '')) + 1 >= numbers.n
    WHERE genres IS NOT NULL
) genre_split
GROUP BY genre
ORDER BY genre_count DESC
LIMIT 5;

#19. Top-rated shows for each genre:
SELECT imdb.genres, imdb.title, imdb.averageRating
FROM imdb
JOIN (
    SELECT genres, MAX(averageRating) AS max_rating
    FROM imdb
    GROUP BY genres
) AS genre_max
ON imdb.genres = genre_max.genres AND imdb.averageRating = genre_max.max_rating
ORDER BY imdb.averageRating DESC;

#20. Identify shows that belong to "Comedy" and "Family" genres:
SELECT id, title, genres, averageRating
FROM imdb
WHERE genres LIKE '%Comedy%' AND genres LIKE '%Family%'
ORDER BY averageRating DESC;

-----------------------------------------------------------------------------------------
