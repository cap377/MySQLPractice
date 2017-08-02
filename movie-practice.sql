/*CREATE TABLE movie_tbl (
mID int(3) auto_increment primary key,
title varchar(256) NOT NULL,
year int(4) NOT NULL,
director varchar(256));

CREATE TABLE reviewer_tbl (
rID int(3) auto_increment primary key,
name varchar(256));

CREATE TABLE rating_tbl (
rID int(3),
mID int(3),
stars int(1),
ratingDate Date);*/


/*insert into movie_tbl values(101, 'Gone with the Wind', 1939, 'Victor Fleming');
insert into movie_tbl values(102, 'Star Wars', 1977, 'George Lucas');
insert into movie_tbl values(103, 'The Sound of Music', 1965, 'Robert Wise');
insert into movie_tbl values(104, 'E.T.', 1982, 'Steven Spielberg');
insert into movie_tbl values(105, 'Titanic', 1997, 'James Cameron');
insert into movie_tbl values(106, 'Snow White', 1937, null);
insert into movie_tbl values(107, 'Avatar', 2009, 'James Cameron');
insert into movie_tbl values(108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

insert into reviewer_tbl values(201, 'Sarah Martinez');
insert into reviewer_tbl values(202, 'Daniel Lewis');
insert into reviewer_tbl values(203, 'Brittany Harris');
insert into reviewer_tbl values(204, 'Mike Anderson');
insert into reviewer_tbl values(205, 'Chris Jackson');
insert into reviewer_tbl values(206, 'Elizabeth Thomas');
insert into reviewer_tbl values(207, 'James Cameron');
insert into reviewer_tbl values(208, 'Ashley White');

insert into rating_tbl values(201, 101, 2, '2011-01-22');
insert into rating_tbl values(201, 101, 4, '2011-01-27');
insert into rating_tbl values(202, 106, 4, null);
insert into rating_tbl values(203, 103, 2, '2011-01-20');
insert into rating_tbl values(203, 108, 4, '2011-01-12');
insert into rating_tbl values(203, 108, 2, '2011-01-30');
insert into rating_tbl values(204, 101, 3, '2011-01-09');
insert into rating_tbl values(205, 103, 3, '2011-01-27');
insert into rating_tbl values(205, 104, 2, '2011-01-22');
insert into rating_tbl values(205, 108, 4, null);
insert into rating_tbl values(206, 107, 3, '2011-01-15');
insert into rating_tbl values(206, 106, 5, '2011-01-19');
insert into rating_tbl values(207, 107, 5, '2011-01-20');
insert into rating_tbl values(208, 104, 3, '2011-01-02');*/

######################### QUESTION 1 ##################################

SELECT 
    title AS Title, MAX(stars) - MIN(stars) AS 'Star Difference'
FROM
    movie_tbl AS movie
        LEFT JOIN
    rating_tbl AS rating ON movie.mID = rating.mID
GROUP BY movie.mID;

######################## QUESTION 2 ####################################

SELECT 
    (SELECT 
            AVG(average)
        FROM
            (SELECT 
                title, year, AVG(stars) AS average
            FROM
                movie_tbl AS movie
            LEFT JOIN rating_tbl AS rating ON movie.mID = rating.mID
            GROUP BY movie.mID) AS averages
        WHERE
            year < 1980) - (SELECT 
            AVG(average)
        FROM
            (SELECT 
                title, year, AVG(stars) AS average
            FROM
                movie_tbl AS movie
            LEFT JOIN rating_tbl AS rating ON movie.mID = rating.mID
            GROUP BY movie.mID) AS averages
        WHERE
            year >= 1980) AS Difference;

######################## QUESTION 3 ####################################

SELECT 
    director AS Director, title
FROM
    movie_tbl
WHERE
    director IN (SELECT 
            a.director
        FROM
            movie_tbl AS a
        GROUP BY a.director
        HAVING COUNT(a.director) > 1)
ORDER BY director , title;

######################## QUESTION 4 ####################################

SELECT 
    movie.title, AVG(stars)
FROM
    rating_tbl AS rating
        NATURAL JOIN
    movie_tbl AS movie
GROUP BY rating.mID
HAVING AVG(stars) = (SELECT 
        MAX(averages.average)
    FROM
        (SELECT 
            movie.title, AVG(stars) AS average
        FROM
            movie_tbl AS movie
        NATURAL JOIN rating_tbl AS rating
        GROUP BY movie.mID) AS averages);

######################## QUESTION 5 ####################################

SELECT 
    movie.title, AVG(stars)
FROM
    rating_tbl AS rating
        NATURAL JOIN
    movie_tbl AS movie
GROUP BY rating.mID
HAVING AVG(stars) = (SELECT 
        MIN(averages.average)
    FROM
        (SELECT 
            movie.title, AVG(stars) AS average
        FROM
            movie_tbl AS movie
        NATURAL JOIN rating_tbl AS rating
        GROUP BY movie.mID) AS averages);

######################## QUESTION 6 ####################################

SELECT DISTINCT
    movie.director, movie.title, MAX(rating.stars)
FROM
    movie_tbl AS movie
        JOIN
    rating_tbl AS rating ON movie.mID = rating.mID
GROUP BY movie.director
HAVING movie.director IN (SELECT DISTINCT
        director
    FROM
        movie_tbl AS movie
            JOIN
        rating_tbl AS rating ON movie.mID = rating.mID
    WHERE
        director IS NOT NULL)
ORDER BY movie.director;

######################## QUESTION 7 ####################################

SELECT 
    *
FROM
    movie_tbl AS movie
        NATURAL JOIN
    rating_tbl AS rating
        NATURAL JOIN
    reviewer_tbl AS review
WHERE
    director = name;

######################## QUESTION 8 ####################################

SELECT 
    CONCAT(name, ' - ', title)
FROM
    reviewer_tbl
        NATURAL JOIN
    rating_tbl
        NATURAL JOIN
    movie_tbl
ORDER BY name , title;

######################## QUESTION 9 ####################################

SELECT DISTINCT
    review.name AS name1, review2.name AS name2, rating.mID
FROM
    reviewer_tbl AS review,
    rating_tbl AS rating,
    reviewer_tbl AS review2,
    rating_tbl AS rating2
WHERE
    review.name < review2.name
        AND rating.mID = rating2.mID
        AND rating.rID = review.rID
        AND review2.rID = rating2.rID
ORDER BY rating.mID;

######################## QUESTION 10 ####################################

SELECT 
    name, title, stars
FROM
    rating_tbl
        NATURAL JOIN
    reviewer_tbl
        NATURAL JOIN
    movie_tbl
WHERE
    stars IN (SELECT 
            MIN(stars)
        FROM
            rating_tbl);