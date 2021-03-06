CREATE DATABASE Assignment01;

USE Assignment01;

CREATE TABLE EmployeeDetails(
		EmpId INT NOT NULL PRIMARY KEY,
        FullName VARCHAR(30),
        ManagerId INT ,
        FOREIGN KEY (ManagerId) REFERENCES EmployeeDetails(EmpId),    
        DateOfJoining DATE
        )ENGINE INNODB;

CREATE TABLE EmployeeSalary(
		EmpId INT REFERENCES EmployeeDetails(EmpId),
        Project VARCHAR(30),
        Salary INT
        );   

SELECT * FROM EmployeeDetails;

SELECT * FROM EmployeeSalary;
     
#1).to fetch total number of employees working on project ‘Microsoft Office’ 
SELECT COUNT(EmployeeDetails.EmpId) 
FROM EmployeeDetails,EmployeeSalary 
WHERE EmployeeDetails.EmpId = EmployeeSalary.EmpId
AND EmployeeSalary.Project = "Micosoft Office";
        
#2).to fetch name of the employee with maximum salary 
SELECT EmployeeDetails.FullName 
FROM EmployeeDetails
JOIN EmployeeSalary
WHERE EmployeeDetails.EmpId = EmployeeSalary.EmpId
AND EmployeeSalary.Salary = ( SELECT MAX(EmployeeSalary.salary)
FROM EmployeeSalary);

#3).to fetch employees who joined between 1 Jan 2016 and 1 Oct 2017 
SELECT * FROM EmployeeDetails WHERE(DateOfJoining BETWEEN '2016-01-01' AND '2017-09-01'); 

#4).to fetch first two records of EmployeeDetails 
SELECT * FROM EmployeeDetails LIMIT 2;

#5).to fetch employees with salary above 10000 
SELECT * FROM EmployeeDetails,EmployeeSalary WHERE Salary > 10000; 

#6).to fetch ManagerId and how many sub-ordinates they have 
SELECT ManagerId,COUNT(ManagerId) 
FROM EmployeeDetails 
GROUP BY ManagerId;

#7).to fetch employee names and their manager names 
SELECT e1.FullName EmployeeName, e2.FullName AS ManagerName
FROM EmployeeDetails e1
INNER JOIN EmployeeDetails e2
ON e1.ManagerId = e2.EmpId;

#8).to fetch employees with no project assigned 
SELECT * 
FROM EmployeeDetails
JOIN EmployeeSalary
ON EmployeeDetails.EmpId = EmployeeSalary.EmpId
AND EmployeeSalary.Project Is NULL
OR EmployeeSalary.Project='';

INSERT INTO EmployeeDetails VALUES(12,"Mariya Weth",4,'2013-02-01'); 

INSERT INTO EmployeeSalary VALUES(12,null,40000); 

#9).to update joining date of ‘Rahul Dravid’ to ’03/10/2014’ 
UPDATE EmployeeDetails SET DateOfJoining='2014-10-03' WHERE FullName = "Isla Jake";

#10).to insert your favourite employee details and their salary details in above tables 
INSERT INTO EmployeeDetails VALUES(11,"Monica Michel",6,'2011-08-15');
INSERT INTO EmployeeSalary VALUES(11,"Google",38000);

#11). to fetch all employees even if they don’t have any project assignment; sort the results based on ‘DateOfJoining’; display recently joined employees first 
SELECT * FROM EmployeeDetails 
ORDER BY EmployeeDetails.DateOfJoining DESC;

#12).to display following columns: FullName, ManagerName, Project, Salary 
SELECT e1.FullName EmployeeName, e2.FullName AS ManagerName,
case when EmployeeSalary.Project Is null or EmployeeSalary.Project = '' 
then 'No Project' 
else EmployeeSalary.Project 
end,
EmployeeSalary.Salary
FROM EmployeeDetails e1
INNER JOIN EmployeeDetails e2
ON e1.ManagerId = e2.EmpId
left join EmployeeSalary
on e1.EmpId =EmployeeSalary.EmpId;

#13).to fetch employees who are not part of project ‘Facebook' 
SELECT EmployeeDetails.EmpId,EmployeeDetails.FullName
FROM EmployeeDetails
JOIN EmployeeSalary
ON EmployeeDetails.EmpId = EmployeeSalary.EmpId
AND EmployeeSalary.Project NOT IN('Facebook');

#14).display your name and date of birth 
SELECT 'Pallavi Deshmukh','1997-03-28';

#15).display today’s date and your age in years 
SELECT CURDATE(),TIMESTAMPDIFF(YEAR,'1997-03-28',CURDATE());

UPDATE EmployeeSalary SET Project=NULL WHERE EmpId=3;

##############################################################################
STORED PROCEDURE

DELIMITER //
CREATE PROCEDURE GetSpecificEmployees3(IN ProjectName varchar(20))
BEGIN
	SELECT EmployeeDetails.EmpId,EmployeeDetails.FullName
	FROM EmployeeDetails
	JOIN EmployeeSalary
	ON EmployeeDetails.EmpId = EmployeeSalary.EmpId
	AND EmployeeSalary.Project = 'Facebook';
END //



CALL GetSpecificEmployees3(@increment);

SET @increment ="Facebook";
##############################################################################

##############################################################################
# VIEW

CREATE VIEW employees as
SELECT e1.FullName EmployeeName, e2.FullName AS ManagerName,
case when EmployeeSalary.Project IS NULL or EmployeeSalary.Project = '' 
then 'No Project' 
else EmployeeSalary.Project 
end,
EmployeeSalary.Salary
FROM EmployeeDetails e1
INNER JOIN EmployeeDetails e2
ON e1.ManagerId = e2.EmpId
left join EmployeeSalary
on e1.EmpId =EmployeeSalary.EmpId;

SELECT * FROM employees;

##############################################################################

##############################################################################
UserDefined Functions

DELIMITER $$
CREATE FUNCTION GetInformation2(ProjectName varchar(10)) 
RETURNS INTEGER
BEGIN
	 DECLARE b integer;
    SELECT count(EmployeeDetails.EmpId) INTO b
	FROM EmployeeDetails
	JOIN EmployeeSalary
	ON EmployeeDetails.EmpId = EmployeeSalary.EmpId
	AND EmployeeSalary.Project NOT IN(ProjectName);
    return b;
END$$



SELECT GetInformation2("Facebook");
  

##############################################################################


SET SQL_SAFE_UPDATES=0;







DELIMITER //
CREATE PROCEDURE GetSpecificEmployees2(IN ProjectName varchar(20))
BEGIN
	SELECT * FROM EmployeeDetails;
    END //
    
    CALL GetSpecificEmployees2(@Facbook);


DELIMITER //
CREATE PROCEDURE GetSpecificEmployees()
BEGIN
	SELECT * FROM EmployeeDetails;
END //





