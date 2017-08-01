/*CREATE TABLE movie_tbl (
mID int(3) auto_increment primary key,
title varchar(256) NOT NULL,
year int(4) NOT NULL,
director varchar(256))

CREATE TABLE reviewer_tbl (
rID int(3) auto_increment primary key,
name varchar(256))

CREATE TABLE rating_tbl (
rID int(3),
mID int(3),
stars int(1),
ratingDate Date)*/


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
insert into rating_tbl values(208, 104, 3, '2011-01-02');

#########################QUESTION 1##################################

SELECT title as Title, max(stars) - min(stars) as 'Star Difference'
FROM movie_tbl as movie left join rating_tbl as rating
ON movie.mID = rating.mID
group by movie.mID*/

########################QUESTION 2####################################

/*SELECT movie.year, average
FROM movie_tbl as movie join (SELECT title, year, avg(stars) as average
						FROM movie_tbl as movie left join rating_tbl as rating
						ON movie.mID = rating.mID
						group by movie.mID) as average_ratings
ON movie.year = average_ratings.year
group by movie.year < 1980*/

########################QUESTION 3####################################

/*SELECT director as Director, title
FROM movie_tbl
WHERE director in (SELECT a.director FROM movie_tbl as a
		group by a.director
		having count(a.director) > 1)
order by director, title*/

########################QUESTION 4####################################

/*SELECT movie.title, avg(stars)
FROM rating_tbl as rating join movie_tbl as movie
ON movie.mID = rating.mID
GROUP BY rating.mID
HAVING avg(stars) = (SELECT max(averages.average)
					FROM (SELECT movie.title, avg(stars) as average
							FROM movie_tbl as movie left join rating_tbl as rating
							ON movie.mID = rating.mID
							group by movie.mID) as averages)*/

########################QUESTION 5####################################

/*SELECT movie.title, avg(stars)
FROM rating_tbl as rating join movie_tbl as movie
ON movie.mID = rating.mID
GROUP BY rating.mID
HAVING avg(stars) = (SELECT min(averages.average)
					FROM (SELECT movie.title, avg(stars) as average
							FROM movie_tbl as movie left join rating_tbl as rating
							ON movie.mID = rating.mID
							group by movie.mID) as averages)*/

########################QUESTION 6####################################

SELECT DISTINCT movie.director, movie.title, max(rating.stars)
FROM movie_tbl as movie join rating_tbl as rating
ON movie.mID = rating.mID
GROUP BY movie.director
HAVING movie.director in (SELECT Distinct director 
						FROM movie_tbl as movie join rating_tbl as rating
						ON movie.mID = rating.mID
						WHERE director IS NOT NULL)
ORDER BY movie.director;

########################QUESTION 7####################################






