
CREATE VIEW EmployeeReporter AS
SELECT EmpD.EmpId AS EmployeeId
	 , EmpD.FullName AS EmployeeName
	 , EmpD.ManagerId AS ManagerId
	 , EmpS.FullName AS ManagerName
FROM EmployeeDetails EmpD
JOIN EmployeeDetails EmpS
	ON EmpD.ManagerId = EmpS.EmpId;

SELECT * FROM EmployeeReporter;


SELECT EmpR.EmployeeName AS EmployeeName
	 , EmpR.EmployeeName AS ManagerName
     , IF(EmpS.Project = '' OR EmpS.Project IS NULL, GetProjectName(EmpS.Project), EmpS.Project)  
	 , EmpS.Salary
FROM EmployeeReporter AS EmpR
LEFT JOIN EmployeeSalary AS EmpS
	ON EmpR.EmployeeId = EmpS.EmpId;

SELECT GetProjectName('');


DELIMITER $$
CREATE FUNCTION GetProjectName(ProjectName varchar(10)) 
RETURNS VARCHAR(10)
BEGIN
	DECLARE project VARCHAR(10);
    SET project = 
		CASE WHEN ProjectName IS NULL OR ProjectName = '' 
			THEN 'No Project' 
            ELSE ProjectName 
		END;
	RETURN project;
END$$


DELIMITER //
CREATE PROCEDURE GetEmployees(IN ProjectName VARCHAR(10))
BEGIN

	SELECT EmpR.EmployeeName AS EmployeeName
		 , EmpR.EmployeeName AS ManagerName
		 , IF(EmpS.Project = '' OR EmpS.Project IS NULL, GetProjectName(EmpS.Project), EmpS.Project)  
		 , EmpS.Salary
	FROM EmployeeReporter AS EmpR
	LEFT JOIN EmployeeSalary AS EmpS
		ON EmpR.EmployeeId = EmpS.EmpId
			AND EmpS.Project = ProjectName;
        
END //

CALL GetEmployees('Facebook')
