 
--In this project, the tables EmployeeDemographics and EmployeeSalary will be created and interrogated in order to get the information that is needed. 
--The tables are related to each other and contain demographic and salary details about the employees of a company.

 --Creating the tables

CREATE  TABLE  EmployeeDemographics (EmployeeID  int,
FirstName  varchar(50), LastName  varchar(50), Age  int,
Gender  varchar(50)
)


CREATE  TABLE  EmployeeSalary (EmployeeID  int,
JobTitle  varchar(50), Salary  int
)

 --Inserting the data

Insert  into  EmployeeDemographics  VALUES (1001,  'Jim',  'Halpert',  30,  'Male'),
(1002,  'Pam',  'Beasley',  30,  'Female'),
(1003,  'Dwight',  'Schrute',  29,  'Male'),
(1004,  'Angela',  'Martin',  31,  'Female'),
(1005,  'Toby',  'Flenderson',  32,  'Male'),
(1006,  'Michael',  'Scott',  35,  'Male'),
(1007,  'Meredith',  'Palmer',  32,  'Female'),
(1008,  'Stanley',  'Hudson',  38,  'Male'),
(1009,  'Kevin',  'Malone',  31,  'Male')

Insert  Into  EmployeeSalary  VALUES (1001,  'Salesman',  45000),
(1002,  'Receptionist',  36000),
(1003,  'Salesman',  63000),
(1004,  'Accountant',  47000),
(1005,  'HR',  50000),
(1006,  'Regional  Manager',  65000),
(1007,  'Supplier  Relations',  41000),
(1008,  'Salesman',  48000),
(1009,  'Accountant',  42000
 
 --Now, let’s see the tables

SELECT  *  FROM  EmployeeDemographics

SELECT  *  FROM  EmployeeSalary


 --Let’s find out what is the highest salary in the company, what is the lower and what is the average salary of the company

SELECT  MAX(Salary)  as  MaxSalary FROM  EmployeeSalary

SELECT  MIN(Salary)  as  MinSalary FROM  EmployeeSalary

SELECT  AVG(Salary)  as  AvgSalary FROM  EmployeeSalary


 --Getting all the details about an employee (for exemple: Jim)

SELECT  *  
FROM  EmployeeDemographics  INNER  JOIN  EmployeeSalary 
ON  EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID 
WHERE  FirstName='Jim'


 --How many employees older that 30 does the company has?

SELECT  COUNT(Age)  AS  '30+'
FROM  EmployeeDemographics WHERE Age>30


 --Men older than 30 and salary higher that 50000:
SELECT *
FROM  EmployeeDemographics  INNER  JOIN  EmployeeSalary
ON  EmployeeDemographics.EmployeeID  =  EmployeeSalary.EmployeeID 
WHERE  Age>=30  AND  Gender='Male'  AND  Salary>50000


--How many female and male employee are in the company?
SELECT  Gender,  COUNT(Gender) 
FROM  EmployeeDemographics 
GROUP  BY  Gender

 
--Ordering the employees desc by age:

SELECT  *  FROM  EmployeeDemographics 
ORDER BY 4 DESC


 --Inserting new values

Insert  into  EmployeeDemographics  VALUES 
(1011,  'Ryan',  'Howard',  26,  'Male'),
(NULL,  'Holly','Flax',  NULL,  'Male'),
(1013,  'Darryl',  'Philbin',  NULL,  'Male')

SELECT  *  FROM  EmployeeDemographics

 
Insert  into  EmployeeSalary  VALUES 
(1010,  NULL,  47000),
(NULL,  'Salesman',  43000) 

SELECT  *  FROM  EmployeeSalary


 --Joining tables
--Select only the employees that have both ID and Job Title

SELECT *
FROM  EmployeeDemographics  INNER  JOIN  EmployeeSalary
ON  EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID

--Sum all salaries

SELECT  SUM(Salary)  as  SalaryTotal
FROM  EmployeeDemographics  RIGHT  OUTER  JOIN  EmployeeSalary
ON  EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID

 
 --Pay Raise

--The company wants to increase employees’ salaries as below:
--Salesman: 10%
--Accountant: 5%
--Others: 3%
--Calculation of the new salaries:

SELECT  FirstName,  LastName,  JobTitle,  Salary, 
CASE
WHEN  JobTitle='Salesman'  THEN  Salary  +  (Salary  *  0.1) 
WHEN  JobTitle='Accountant'  THEN  Salary  +  (Salary  *  0.05) 
ELSE  Salary  +  (Salary  *  0.03)
END  AS  SalaryRaise
FROM  EmployeeDemographics  JOIN  EmployeeSalary
ON  EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID


--Creating a procedure that shows the name and the salary of the employees

CREATE  PROCEDURE  SalaryP AS
SELECT  FirstName,  LastName,  Salary
FROM  EmployeeDemographics  INNER  JOIN  EmployeeSalary
ON  EmployeeDemographics.EmployeeID  =  EmployeeSalary.EmployeeID 

EXEC  SalaryP
 

--How many job description HR has to prepare?

SELECT  COUNT(DISTINCT  JobTitle)
FROM  EmployeeSalary

 --Who has salary higher that 60000?

SELECT  FirstName  FROM  EmployeeDemographics WHERE  EmployeeID  IN
(SELECT  EmployeeID  FROM  EmployeeSalary WHERE  Salary>60000)

--OR

SELECT  *  FROM  EmployeeSalary WHERE  Salary  LIKE  '[6#0]%'


--Creating the JobFile: JobTitle+Salary

SELECT  JobTitle  +  ',  '  +  ltrim(str(Salary))  AS  JobFile 
FROM  EmployeeSalary
WHERE  JobTitle  IS  NOT  NULL

 
--Show the JobTitle with more than one employee

SELECT  JobTitle,  COUNT(EmployeeID)  as  'No  of  Employees'  
FROM  EmployeeSalary 
GROUP  BY  JobTitle
HAVING  COUNT(EmployeeID)>1

 --Creating 2 separate tables for Male and Female

SELECT  *  INTO  EmployeeDemographics1 
FROM  EmployeeDemographics
WHERE  Gender='Male'

SELECT  *  INTO  EmployeeDemographics2 
FROM  EmployeeDemographics
WHERE 1=0

INSERT  INTO  EmployeeDemographics2 
SELECT  *  FROM  EmployeeDemographics 
WHERE  Gender='Female'

SELECT  *  FROM  EmployeeDemographics1

SELECT  *  FROM  EmployeeDemographics2


--Employees’ Feelings considering the Salary:

SELECT  Salary, 
CASE
WHEN  Salary>60000  THEN  'Happy' 
WHEN  Salary<40000  THEN  'Sad'
ELSE  'Satisfied' 
END  AS  Feeling
FROM  EmployeeSalary 
Order  by  Salary  desc

