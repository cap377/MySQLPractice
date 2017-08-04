# MOVIES WITH THEIR AVERAGE RATING
CREATE VIEW movies_reviews_view AS
SELECT mID, title, year, director, stars
FROM movie_tbl NATURAL JOIN rating_tbl;

SELECT mID, title, year, avg(stars) FROM movies_reviews_view GROUP BY mID;

# QUESTION 1 UNLIKED STUDENTS
CREATE VIEW unliked_students_view AS
SELECT *
FROM Highschooler
WHERE ID NOT IN (SELECT ID1 FROM Likes)
AND ID NOT IN (SELECT ID2 FROM Likes);

SELECT * FROM unliked_students_view;

# QUESTION 2 MUTUAL FRIENDS
CREATE VIEW mutual_friend_view AS
SELECT 
    A.name AS Highschooler1,
    B.name AS Highschooler2,
    C.name AS 'Friend in common'
FROM
    Highschooler AS A,
    Highschooler AS B,
    Highschooler AS C
WHERE
    A.ID != B.ID AND A.ID != C.ID
        AND B.ID != C.ID
        AND A.ID IN (SELECT 
            ID2
        FROM
            Likes
        WHERE
            B.ID = ID1)
        AND A.ID NOT IN (SELECT 
            ID1
        FROM
            Friend
        WHERE
            ID2 = B.ID)
        AND A.ID IN (SELECT 
            ID1
        FROM
            Friend
        WHERE
            ID2 = C.ID)
        AND B.ID IN (SELECT 
            ID1
        FROM
            Friend
        WHERE
            ID2 = C.ID);
            
SELECT * FROM mutual_friend_view;

# QUESTION 3 NUMBER OF REPEATING FIRST NAMES
CREATE VIEW repeating_names_view AS
SELECT 
    name, (COUNT(ID)) - (COUNT(DISTINCT name)) AS 'Times Repeated'
FROM
    Highschooler;
    
SELECT * FROM repeating_names_view;