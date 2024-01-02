DROP DATABASE IF EXISTS coursework;

CREATE DATABASE coursework;

USE coursework;


-- Query 1: Retrieve distinct students with their undergraduate details and associated course
-- This query joins the Student, Undergraduate, and Course tables to get student details, their undergraduate information, and the associated course.
SELECT DISTINCT Student.URN, Student.Stu_FName, Undergraduate.UG_URN
FROM Student 
INNER JOIN Undergraduate ON Student.URN = Undergraduate.UG_URN 
INNER JOIN Course ON Student.Stu_Course = Course.Crs_Code;

-- Query 2: Retrieve the count of students for each course
-- This query calculates the count of students for each course using the GROUP BY clause.
SELECT Stu_Course, COUNT(URN) as StudentCount
FROM Student
GROUP BY Stu_Course;






-- Query 3: Retrieve the course titles with the maximum enrollment
-- This query uses a subquery to find the maximum enrollment and retrieves the course titles with that enrollment.
SELECT Crs_Title FROM Course WHERE Crs_Enrollment = (
    SELECT MAX(Crs_Enrollment) FROM Course
);
-- Query 4: Retrieve projects, their sponsors, and the total funding for each project
-- This query joins the Project and Sponsor tables to get project details along with their sponsors and total funding.
SELECT Project.Prj_title, Sponsor.Sponsor_name, Project.Funding
FROM Project
JOIN Sponsor ON Project.Prj_title = Sponsor.Prj_title;













-- If you want to do some more queries as the extra challenge task you can include them here

-- Extra Query (5.4): Retrieve blogs with comprehensive information about students, projects, and hobbies
-- This query provides detailed information about blogs, students, projects, and associated hobbies.
SELECT b.*, s.Stu_FName, s.Stu_LName, p.Prj_title, p.Start_date, p.Funding, h.Hobby_name
FROM Blog b
JOIN Stu_proj sp ON b.URN = sp.URN
JOIN Student s ON b.URN = s.URN
JOIN Project p ON sp.Prj_title = p.Prj_title
LEFT JOIN Stu_hobby sh ON b.URN = sh.URN
LEFT JOIN Hobby h ON sh.Hobby_name = h.Hobby_name;

-- Query 5: Retrieve blogs with project details and associated hobbies
-- This query retrieves blogs along with their project details and related hobbies using JOINs and LEFT JOINs.
SELECT b.*, p.Start_date, p.Funding, h.Hobby_name
FROM Blog b
JOIN Stu_proj sp ON b.URN = sp.URN
JOIN Project p ON sp.Prj_title = p.Prj_title
LEFT JOIN Stu_hobby sh ON b.URN = sh.URN
LEFT JOIN Hobby h ON sh.Hobby_name = h.Hobby_name;

