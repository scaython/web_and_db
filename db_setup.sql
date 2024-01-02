-- Active: 1699633890613@@127.0.0.1@3306@coursework
DROP DATABASE IF EXISTS coursework;

CREATE DATABASE coursework;

USE coursework;

-- This is the Course table
 
DROP TABLE IF EXISTS Course;

CREATE TABLE Course (
Crs_Code 	INT UNSIGNED NOT NULL,
Crs_Title 	VARCHAR(255) NOT NULL,
Crs_Enrollment INT UNSIGNED,
PRIMARY KEY (Crs_code));


INSERT INTO Course VALUES 
(100,'BSc Computer Science', 150),
(101,'BSc Computer Information Technology', 20),
(200, 'MSc Data Science', 100),
(201, 'MSc Security', 30),
(210, 'MSc Electrical Engineering', 70),
(211, 'BSc Physics', 100);


-- This is the student table definition


DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
URN INT UNSIGNED NOT NULL,
Stu_FName 	VARCHAR(255) NOT NULL,
Stu_LName 	VARCHAR(255) NOT NULL,
Stu_DOB 	DATE,
Stu_Phone 	VARCHAR(12),
Stu_Course	INT UNSIGNED NOT NULL,
Stu_Type 	ENUM('UG', 'PG'),
PRIMARY KEY (URN),
FOREIGN KEY (Stu_Course) REFERENCES Course (Crs_Code)
ON DELETE RESTRICT);


INSERT INTO Student VALUES
(612345, 'Sara', 'Khan', '2002-06-20', '01483112233', 100, 'UG'),
(612346, 'Pierre', 'Gervais', '2002-03-12', '01483223344', 100, 'UG'),
(612347, 'Patrick', 'O-Hara', '2001-05-03', '01483334455', 100, 'UG'),
(612348, 'Iyabo', 'Ogunsola', '2002-04-21', '01483445566', 100, 'UG'),
(612349, 'Omar', 'Sharif', '2001-12-29', '01483778899', 100, 'UG'),
(612350, 'Yunli', 'Guo', '2002-06-07', '01483123456', 100, 'UG'),
(612351, 'Costas', 'Spiliotis', '2002-07-02', '01483234567', 100, 'UG'),
(612352, 'Tom', 'Jones', '2001-10-24',  '01483456789', 101, 'UG'),
(612353, 'Simon', 'Larson', '2002-08-23', '01483998877', 101, 'UG'),
(612354, 'Sue', 'Smith', '2002-05-16', '01483776655', 101, 'UG');

DROP TABLE IF EXISTS Undergraduate;

CREATE TABLE Undergraduate (
UG_URN 	INT UNSIGNED NOT NULL,
UG_Credits   INT NOT NULL,
CHECK (60 <= UG_Credits <= 150),
PRIMARY KEY (UG_URN),
FOREIGN KEY (UG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);

INSERT INTO Undergraduate VALUES
(612345, 120),
(612346, 90),
(612347, 150),
(612348, 120),
(612349, 120),
(612350, 60),
(612351, 60),
(612352, 90),
(612353, 120),
(612354, 90);

DROP TABLE IF EXISTS Postgraduate;

CREATE TABLE Postgraduate (
PG_URN 	INT UNSIGNED NOT NULL,
Thesis  VARCHAR(512) NOT NULL,
PRIMARY KEY (PG_URN),
FOREIGN KEY (PG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);


-- Please add your table definitions below this line.......

DROP TABLE IF EXISTS Hobby;

CREATE TABLE Hobby(
    Hobby_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (Hobby_name) 
    
);

DROP TABLE IF EXISTS Stu_hobby;
CREATE TABLE Stu_hobby(
    URN INT UNSIGNED NOT NULL,
    Hobby_name VARCHAR(50) NOT NULL,
    Skill_lvl ENUM ('BASIC', 'INTERMEDIATE', 'ADVANCED'),
    PRIMARY KEY ( URN, Hobby_name),
    FOREIGN KEY (URN) REFERENCES Student(URN),
    FOREIGN KEY (Hobby_name) REFERENCES Hobby(Hobby_name) 
);

DROP TABLE IF EXISTS Blog;
CREATE TABLE Blog(
    BlogID INT UNSIGNED NOT NULL,
    URN INT UNSIGNED NOT NULL,
    Title VARCHAR(75) NOT NULL,
    Date DATE,
    Article VARCHAR(512) NOT NULL,
    PRIMARY KEY (BlogID),
    FOREIGN KEY (URN) REFERENCES Student(URN)
);

DROP TABLE IF EXISTS Project;

CREATE TABLE Project(
    Prj_title VARCHAR(75) NOT NULL,
    Start_date DATE,
    Funding INT NOT NULL,
    PRIMARY KEY (Prj_title)
);
DROP TABLE IF EXISTS Sponsor;

CREATE TABLE Sponsor(
     Prj_title VARCHAR(75) NOT NULL,
     Sponsor_name VARCHAR(75) NOT NULL,
     PRIMARY KEY (Prj_title,Sponsor_name),
     FOREIGN KEY (Prj_title) REFERENCES Project(Prj_title)
);

DROP TABLE IF EXISTS Stu_proj;

CREATE Table Stu_proj(
    Prj_title VARCHAR(75) NOT NULL,
    URN INT UNSIGNED NOT NULL,
    Role VARCHAR(25),
    PRIMARY KEY ( Prj_title, URN),
    FOREIGN KEY (Prj_title) REFERENCES Project(Prj_title),
    FOREIGN KEY (URN) REFERENCES Student(URN)
);

-- Mock data generation

-- Mock entries for Hobby table
INSERT INTO Hobby (Hobby_name) VALUES 
    ('Reading'),
    ('Hiking'),
    ('Chess'),
    ('Taichi'),
    ('Ballroom Dancing'),
    ('Football'),
    ('Tennis'),
    ('Rugby'),
    ('Climbing'),
    ('Rowing');

-- Mock entries for Stu_hobby table
INSERT INTO Stu_hobby (URN, Hobby_name, Skill_lvl) VALUES 
    (612345, 'Reading', 'ADVANCED'),
    (612350, 'Hiking', 'BASIC'),
    (612351, 'Chess', 'ADVANCED'),
    (612352, 'Taichi', 'INTERMEDIATE'),
    (612353, 'Ballroom Dancing', 'BASIC'),
    (612354, 'Football', 'ADVANCED');

-- Mock entries for Blog table
INSERT INTO Blog (BlogID, URN, Title, Date, Article) VALUES 
    (1, 612345, 'My First Blog', '2023-01-15', 'This is my first blog post.'),
    (2, 612346, 'Gardening Tips', '2023-02-01', 'Sharing some tips on maintaining a garden.'),
    (3, 612347, 'Artistic Creations', '2023-03-10', 'Exploring different forms of art.'),
    (4, 612349, 'Sports Achievements', '2023-04-05', 'Recapping recent sports achievements.'),
    (5, 612350, 'Hiking Adventures', '2023-05-20', 'Exploring nature through hiking.'),
    (6, 612351, 'Chess Strategies', '2023-06-12', 'Discussing chess strategies.'),
    (7, 612352, 'Taichi Benefits', '2023-07-02', 'Exploring the health benefits of Taichi.'),
    (8, 612353, 'Dance Night', '2023-08-15', 'Sharing experiences from a ballroom dancing event.'),
    (9, 612354, 'Football Highlights', '2023-09-10', 'Highlighting memorable football moments.');

-- Mock entries for Project table
INSERT INTO Project (Prj_title, Start_date, Funding) VALUES 
    ('Data Analysis Project', '2023-01-20', 50000),
    ('Security Enhancement Project', '2023-02-10', 70000),
    ('Electrical Engineering Research', '2023-03-01', 30000),
    ('Hiking Trails Mapping', '2023-04-15', 40000),
    ('Chess Tactics Study', '2023-05-05', 35000),
    ('Taichi Wellness App', '2023-06-20', 60000),
    ('Ballroom Dancing Showcase', '2023-07-15', 80000),
    ('Football Skills Development', '2023-08-01', 45000),
    ('Rowing Challenge', '2023-09-25', 55000);

-- Mock entries for Sponsor table
INSERT INTO Sponsor (Prj_title, Sponsor_name) VALUES 
    ('Data Analysis Project', 'TechCorp'),
    ('Security Enhancement Project', 'SecureTech'),
    ('Electrical Engineering Research', 'PowerTech'),
    ('Hiking Trails Mapping', 'OutdoorGear'),
    ('Chess Tactics Study', 'MindMasters'),
    ('Taichi Wellness App', 'HealthTech'),
    ('Ballroom Dancing Showcase', 'DanceElegance'),
    ('Football Skills Development', 'SportsAcademy'),
    ('Rowing Challenge', 'RowingClub');

-- Mock entries for Stu_proj table
INSERT INTO Stu_proj (Prj_title, URN, Role) VALUES 
    ('Data Analysis Project', 612345, 'Analyst'),
    ('Security Enhancement Project', 612347, 'Researcher'),
    ('Electrical Engineering Research', 612350, 'Assistant'),
    ('Hiking Trails Mapping', 612350, 'Coordinator'),
    ('Chess Tactics Study', 612351, 'Researcher'),
    ('Taichi Wellness App', 612352, 'Developer'),
    ('Ballroom Dancing Showcase', 612353, 'Coordinator'),
    ('Football Skills Development', 612354, 'Trainer'),
    ('Rowing Challenge', 612354, 'Coordinator');
