/*
CREATE TABLE Highschooler (
	ID int(6) primary key,
    name varchar(255) NOT NULL,
    grade int(12));
    
CREATE TABLE Friend (
	ID1 int(6) NOT NULL,
    ID2 int(6) NOT NULL);
    
CREATE TABLE Likes (
	ID1 int(6) NOT NULL,
    ID2 int(6) NOT NULL);
    
INSERT INTO Highschooler VALUES(1, 'Jordan', 9);
INSERT INTO Highschooler VALUES(2, 'Gabriel', 9);
INSERT INTO Highschooler VALUES(3, 'Tiffany', 9);
INSERT INTO Highschooler VALUES(4, 'Cassandra', 9);
INSERT INTO Highschooler VALUES(5, 'Kris', 10);
INSERT INTO Highschooler VALUES(6, 'Haley', 10);
INSERT INTO Highschooler VALUES(7, 'Andrew', 10);
INSERT INTO Highschooler VALUES(8, 'Brittany', 10);
INSERT INTO Highschooler VALUES(9, 'Alexis', 11);
INSERT INTO Highschooler VALUES(10, 'Austin', 11);
INSERT INTO Highschooler VALUES(11, 'Gabriel', 11);
INSERT INTO Highschooler VALUES(12, 'Jessica', 11);
INSERT INTO Highschooler VALUES(13, 'Jordan', 12);
INSERT INTO Highschooler VALUES(14, 'John', 12);
INSERT INTO Highschooler VALUES(15, 'Kyle', 12);
INSERT INTO Highschooler VALUES(16, 'Logan', 12);

INSERT INTO Friend VALUES(1, 2);
INSERT INTO Friend VALUES(2, 1);

INSERT INTO Friend VALUES(1, 3);
INSERT INTO Friend VALUES(3, 1);

INSERT INTO Friend VALUES(4, 2);
INSERT INTO Friend VALUES(2, 4);

INSERT INTO Friend VALUES(7, 2);
INSERT INTO Friend VALUES(2, 7);

INSERT INTO Friend VALUES(5, 6);
INSERT INTO Friend VALUES(6, 5);

INSERT INTO Friend VALUES(5, 8);
INSERT INTO Friend VALUES(8, 5);

INSERT INTO Friend VALUES(6, 8);
INSERT INTO Friend VALUES(8, 6);

INSERT INTO Friend VALUES(3, 9);
INSERT INTO Friend VALUES(9, 3);

INSERT INTO Friend VALUES(5, 7);
INSERT INTO Friend VALUES(7, 5);

INSERT INTO Friend VALUES(4, 9);
INSERT INTO Friend VALUES(9, 4);

INSERT INTO Friend VALUES(9, 11);
INSERT INTO Friend VALUES(11, 9);

INSERT INTO Friend VALUES(9, 12);
INSERT INTO Friend VALUES(12, 9);

INSERT INTO Friend VALUES(11, 12);
INSERT INTO Friend VALUES(12, 11);

INSERT INTO Friend VALUES(7, 10);
INSERT INTO Friend VALUES(10, 7);

INSERT INTO Friend VALUES(10, 15);
INSERT INTO Friend VALUES(15, 10);

INSERT INTO Friend VALUES(13, 15);
INSERT INTO Friend VALUES(15, 13);

INSERT INTO Friend VALUES(13, 16);
INSERT INTO Friend VALUES(16, 13);

INSERT INTO Friend VALUES(14, 16);
INSERT INTO Friend VALUES(16, 14);

INSERT INTO Friend VALUES(7, 13);
INSERT INTO Friend VALUES(13, 7);

INSERT INTO Friend VALUES(12, 15);
INSERT INTO Friend VALUES(15, 12);

INSERT INTO Likes VALUES(4, 2);
INSERT INTO Likes VALUES(2, 4);
INSERT INTO Likes VALUES(9, 5);
INSERT INTO Likes VALUES(11, 9);
INSERT INTO Likes VALUES(7, 4);
INSERT INTO Likes VALUES(8, 5);
INSERT INTO Likes VALUES(14, 6);
INSERT INTO Likes VALUES(10, 13);
INSERT INTO Likes VALUES(12, 15);
INSERT INTO Likes VALUES(15, 12);

SELECT * FROM Highschooler;
SELECT * FROM Friend;
SELECT * FROM Likes;
*/

######################## QUERIES ######################################
#
#######################################################################

######################## QUESTION 1 ###################################

SELECT *
FROM Highschooler
WHERE ID NOT IN (SELECT ID1 FROM Likes)
AND ID NOT IN (SELECT ID2 FROM Likes);

######################## QUESTION 2 ###################################

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

######################## QUESTION 3 ###################################

SELECT 
    (COUNT(ID)) - (COUNT(DISTINCT name)) AS Difference
FROM
    Highschooler;

######################## QUESTION 4 ###################################

SELECT 
    (SELECT 
            COUNT(*)
        FROM
            Friend) / (SELECT 
            COUNT(ID)
        FROM
            Highschooler) AS 'Friend Average';

######################## QUESTION 5 ###################################

SELECT count(*) as 'Friends of Cassandra'
FROM Friend 
WHERE ID1 IN (SELECT ID2 
			FROM Friend 
			WHERE ID2 IN 
			(SELECT ID2 
				FROM Friend 
                WHERE ID1 = 4)
			)
ORDER BY ID1;

######################## QUESTION 6 ###################################

SELECT name, grade
FROM Highschooler
WHERE (SELECT COUNT(*) FROM Friend WHERE ID = ID1) = 
(SELECT MAX((SELECT COUNT(*) FROM Friend WHERE ID = ID1)) FROM Highschooler);


######################## TRIGGERS & CONSTRAINS ########################
#
#######################################################################

######################## QUESTION 1 ###################################

DELIMITER //
CREATE TRIGGER makeFriendly
AFTER INSERT ON Highschooler
FOR EACH ROW
BEGIN
    IF new.name = 'Friendly'
    THEN
    INSERT INTO Likes 
        SELECT new.id 
        FROM Highschooler as h
        WHERE new.grade = h.grade AND NOT (new.id = h.id);
    END IF;
END; //
DELIMITER ;

######################## QUESTION 2 ###################################

DELIMITER //
CREATE TRIGGER checkGrade
BEFORE INSERT ON Highschooler
FOR EACH ROW
BEGIN
	IF new.grade IS NULL
		THEN SET new.grade = 9;
    ELSEIF (new.grade < 9 OR new.grade > 12)
		THEN SET new.grade = NULL;
    END IF;
END; //
DELIMITER ;

######################## QUESTION 3 ###################################