# IMDB Top 1000 TV Series Data Analysis
 **Overview** 

This project involves the analysis of a dataset containing TV shows and their details, sourced from IMDB. The dataset includes information on various attributes such as genres, release years, ratings, votes, and more. Using SQL, the project explores various aspects of the dataset to derive insights on trends, ratings, and the relationships between show features.

**Key Objectives**

The primary objectives of this project are:

-To analyze TV show genres and their distribution across years.

-To investigate ratings and votes, identifying correlations and trends.

-To uncover hidden gems (highly-rated shows with fewer votes).

-To understand the popularity and performance of genres and shows across different decades.

-To identify the most popular and highly rated shows, as well as the ones that received the most votes.

**Key SQL Queries and Insights**

Some of the key analyses performed on the dataset include:

-Basic Statistics: Counting the total number of TV shows, identifying the range of release years, and computing the average rating and number of votes across all shows.

-Genre Analysis: Examining the distribution of genres, identifying the most popular genre based on total votes, and finding the top-rated show for each genre.

-Decade-Based Analysis: Grouping shows by decade and analyzing trends such as the most frequent genres and the average ratings for each decade.

-Hidden Gems: Identifying highly rated shows with fewer votes (hidden gems).

-Correlations: Investigating the relationship between show ratings and the number of votes, including calculating the correlation coefficient.

-Multi-Genre Shows: Analyzing shows with multiple genres and identifying the most common genre combinations and their ratings.

**Project Structure**

The project is structured around SQL queries that process and analyze data from the imdb table in the tv_shows database. The queries are organized to extract meaningful insights about TV shows, including:

Show distribution by genre and decade

Identification of top-rated and most-voted shows

Detailed exploration of genre combinations and ratings

**Technologies Used**

SQL: Used for querying and analyzing the dataset in MySQL.

MySQL Workbench: For executing SQL queries and managing the database.

**About Data**

The dataset was obtained from the Kaggle IMDb Top 1000 TV Series. This dataset contains a list of the 1000 top-rated TV Series on IMDb, ranked by their average user rating, focusing on titles that have received over 10,000 votes. 
The dataset contains 6 columns and 1000 rows:

| Column      | Description      | Data Type     |
|-------------|------------------|---------------|
| id          | Unique identifier for each TV show (primary key)  | VARCHAR(255)  |
| title       |Name of the TV show | VARCHAR(500)|
| genres      |Categories or genres the TV show belongs to (e.g., Comedy, Drama) | VARCHAR(500)  |
|averageRating|Average viewer rating for the TV show (on a scale of 1 to 10) | FLOAT         |
| numVotes    | Number of votes received for the rating | INTEGER       |
| releaseYear | Year the TV show was first released     | INTEGER       |




