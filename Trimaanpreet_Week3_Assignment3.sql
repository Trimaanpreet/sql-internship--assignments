-- WEEK - 3 ASSIGNMENT - Trimaanpreet Kaur

-- Create a new database for the SQL challenges

CREATE DATABASE SQLChallenges;
GO
USE SQLChallenges;
GO

-- Task 1: Projects Table
IF OBJECT_ID('Projects') IS NOT NULL DROP TABLE Projects;
CREATE TABLE Projects (
    Task_ID INT PRIMARY KEY,
    Start_Date DATE,
    End_Date DATE
);

-- Insert sample data for Projects
INSERT INTO Projects (Task_ID, Start_Date, End_Date) VALUES
(1, '2015-10-01', '2015-10-02'),
(2, '2015-10-02', '2015-10-03'),
(3, '2015-10-03', '2015-10-04'),
(4, '2015-10-13', '2015-10-14'),
(5, '2015-10-14', '2015-10-15'),
(6, '2015-10-28', '2015-10-29'),
(7, '2015-10-30', '2015-10-31');

-- Task 2/11: Students, Friends, Packages Tables
IF OBJECT_ID('Students') IS NOT NULL DROP TABLE Students;
IF OBJECT_ID('Friends') IS NOT NULL DROP TABLE Friends;
IF OBJECT_ID('Packages') IS NOT NULL DROP TABLE Packages;

CREATE TABLE Students (
    ID INT PRIMARY KEY,
    Name VARCHAR(50)
);

CREATE TABLE Friends (
    ID INT PRIMARY KEY,
    Friend_ID INT
);

CREATE TABLE Packages (
    ID INT PRIMARY KEY,
    Salary FLOAT
);

-- Insert sample data for Students, Friends, Packages
INSERT INTO Students (ID, Name) VALUES
(1, 'Ashley'),
(2, 'Samantha'),
(3, 'Julia'),
(4, 'Scarlet');

INSERT INTO Friends (ID, Friend_ID) VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 1);

INSERT INTO Packages (ID, Salary) VALUES
(1, 15.20),
(2, 10.06),
(3, 11.55),
(4, 12.12);

-- Task 3: Functions Table
IF OBJECT_ID('Functions') IS NOT NULL DROP TABLE Functions;
CREATE TABLE Functions (
    X INT,
    Y INT
);

-- Insert sample data for Functions
INSERT INTO Functions (X, Y) VALUES
(20, 20),
(20, 20),
(20, 21),
(23, 22),
(22, 23),
(21, 20);

-- Task 4: Contests, Colleges, Challenges, View_Stats, Submission_Stats Tables
IF OBJECT_ID('Contests') IS NOT NULL DROP TABLE Contests;
IF OBJECT_ID('Colleges') IS NOT NULL DROP TABLE Colleges;
IF OBJECT_ID('Challenges') IS NOT NULL DROP TABLE Challenges;
IF OBJECT_ID('View_Stats') IS NOT NULL DROP TABLE View_Stats;
IF OBJECT_ID('Submission_Stats') IS NOT NULL DROP TABLE Submission_Stats;

CREATE TABLE Contests (
    contest_id INT PRIMARY KEY,
    hacker_id INT,
    name VARCHAR(50)
);

CREATE TABLE Colleges (
    college_id INT PRIMARY KEY,
    contest_id INT
);

CREATE TABLE Challenges (
    challenge_id INT PRIMARY KEY,
    college_id INT
);

CREATE TABLE View_Stats (
    challenge_id INT,
    total_views INT,
    total_unique_views INT
);

CREATE TABLE Submission_Stats (
    challenge_id INT,
    total_submissions INT,
    total_accepted_submissions INT
);

-- Insert sample data for Task 4
INSERT INTO Contests (contest_id, hacker_id, name) VALUES
(66406, 17973, 'Rose'),
(66556, 79153, 'Angela'),
(94828, 80275, 'Frank');

INSERT INTO Colleges (college_id, contest_id) VALUES
(11219, 66406),
(32473, 66556),
(56685, 94828);

INSERT INTO Challenges (challenge_id, college_id) VALUES
(18765, 11219),
(47127, 11219),
(60292, 32473),
(72974, 56685);

INSERT INTO View_Stats (challenge_id, total_views, total_unique_views) VALUES
(47127, 26, 19),
(47127, 15, 14),
(18765, 43, 10),
(18765, 72, 13),
(75516, 35, 17),
(60292, 11, 10),
(72974, 41, 15),
(75516, 75, 11);

INSERT INTO Submission_Stats (challenge_id, total_submissions, total_accepted_submissions) VALUES
(75516, 34, 12),
(47127, 27, 10),
(47127, 56, 18),
(75516, 74, 12),
(75516, 83, 8),
(72974, 68, 24),
(72974, 82, 14),
(47127, 28, 11);

-- Task 5: Hackers, Submissions Tables
IF OBJECT_ID('Hackers') IS NOT NULL DROP TABLE Hackers;
IF OBJECT_ID('Submissions') IS NOT NULL DROP TABLE Submissions;

CREATE TABLE Hackers (
    hacker_id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Submissions (
    submission_date DATE,
    submission_id INT PRIMARY KEY,
    hacker_id INT,
    score INT
);

-- Insert sample data for Task 5
INSERT INTO Hackers (hacker_id, name) VALUES
(15758, 'Rose'),
(20703, 'Angela'),
(36396, 'Frank'),
(38289, 'Patrick'),
(44065, 'Lisa'),
(53473, 'Kimberly'),
(62529, 'Bonnie'),
(79722, 'Michael');

INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 36396, 70),
('2016-03-02', 34928, 20703, 0),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50344, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 45),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 0),
('2016-03-05', 76487, 62529, 0),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 90006, 36396, 40),
('2016-03-06', 90404, 20703, 0);

-- Task 6: STATION Table
IF OBJECT_ID('STATION') IS NOT NULL DROP TABLE STATION;
CREATE TABLE STATION (
    ID INT PRIMARY KEY,
    CITY VARCHAR(21),
    STATE VARCHAR(2),
    LAT_N FLOAT,
    LONG_W FLOAT
);

-- Note: No sample data provided, so query will be included without data

-- Task 7: No table needed (Prime numbers query)

-- Task 8: OCCUPATIONS Table
IF OBJECT_ID('OCCUPATIONS') IS NOT NULL DROP TABLE OCCUPATIONS;
CREATE TABLE OCCUPATIONS (
    Name VARCHAR(50),
    Occupation VARCHAR(50)
);

-- Insert sample data for OCCUPATIONS
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES
('Samantha', 'Doctor'),
('Julia', 'Actor'),
('Maria', 'Actor'),
('Meera', 'Singer'),
('Ashely', 'Professor'),
('Ketty', 'Professor'),
('Christeen', 'Professor'),
('Jane', 'Actor'),
('Jenny', 'Doctor'),
('Priya', 'Singer');

-- Task 9: BST Table
IF OBJECT_ID('BST') IS NOT NULL DROP TABLE BST;
CREATE TABLE BST (
    N INT PRIMARY KEY,
    P INT
);

-- Insert sample data for BST
INSERT INTO BST (N, P) VALUES
(1, 2),
(3, 2),
(6, 8),
(9, 8),
(2, 5),
(8, 5),
(5, NULL);

-- Task 10: Company, Lead_Manager, Senior_Manager, Manager, Employee Tables
IF OBJECT_ID('Employee') IS NOT NULL DROP TABLE Employee;
IF OBJECT_ID('Manager') IS NOT NULL DROP TABLE Manager;
IF OBJECT_ID('Senior_Manager') IS NOT NULL DROP TABLE Senior_Manager;
IF OBJECT_ID('Lead_Manager') IS NOT NULL DROP TABLE Lead_Manager;
IF OBJECT_ID('Company') IS NOT NULL DROP TABLE Company;

CREATE TABLE Company (
    company_code VARCHAR(10) PRIMARY KEY,
    founder VARCHAR(50)
);

CREATE TABLE Lead_Manager (
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);

CREATE TABLE Senior_Manager (
    senior_manager_code VARCHAR(10),
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);

CREATE TABLE Manager (
    manager_code VARCHAR(10),
    senior_manager_code VARCHAR(10),
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);

CREATE TABLE Employee (
    employee_code VARCHAR(10),
    manager_code VARCHAR(10),
    senior_manager_code VARCHAR(10),
    lead_manager_code VARCHAR(10),
    company_code VARCHAR(10)
);

-- Insert sample data for Task 10
INSERT INTO Company (company_code, founder) VALUES
('C1', 'Monika'),
('C2', 'Samantha');

INSERT INTO Lead_Manager (lead_manager_code, company_code) VALUES
('LM1', 'C1'),
('LM2', 'C2');

INSERT INTO Senior_Manager (senior_manager_code, lead_manager_code, company_code) VALUES
('SM1', 'LM1', 'C1'),
('SM2', 'LM1', 'C1'),
('SM3', 'LM2', 'C2');

INSERT INTO Manager (manager_code, senior_manager_code, lead_manager_code, company_code) VALUES
('M1', 'SM1', 'LM1', 'C1'),
('M2', 'SM3', 'LM2', 'C2'),
('M3', 'SM3', 'LM2', 'C2');

INSERT INTO Employee (employee_code, manager_code, senior_manager_code, lead_manager_code, company_code) VALUES
('E1', 'M1', 'SM1', 'LM1', 'C1'),
('E2', 'M1', 'SM1', 'LM1', 'C1'),
('E3', 'M2', 'SM3', 'LM2', 'C2'),
('E4', 'M3', 'SM3', 'LM2', 'C2');

-- Queries for Tasks 1-11

-- Task 1: Projects - Group consecutive tasks into projects
-- Identifies projects by grouping tasks where End_Date of one equals Start_Date of the next
-- Task 1: Group consecutive tasks into projects
-- Step 1: Compute LAG(End_Date) separately to avoid nesting window functions
WITH TaskConnections AS (
    SELECT 
        Task_ID,
        Start_Date,
        End_Date,
        CASE 
            WHEN LAG(End_Date) OVER (ORDER BY Start_Date) = Start_Date 
            THEN 0 
            ELSE Task_ID 
        END AS GroupFlag
    FROM Projects
),
-- Step 2: Assign project groups using ROW_NUMBER
ProjectGroups AS (
    SELECT 
        Task_ID,
        Start_Date,
        End_Date,
        ROW_NUMBER() OVER (ORDER BY Start_Date) - 
        ROW_NUMBER() OVER (PARTITION BY GroupFlag ORDER BY Start_Date) AS ProjectGroup
    FROM TaskConnections
)
-- Step 3: Aggregate to get project start/end dates and duration
SELECT 
    MIN(Start_Date) AS Start_Date,
    MAX(End_Date) AS End_Date,
    DATEDIFF(day, MIN(Start_Date), MAX(End_Date)) AS Duration
FROM ProjectGroups
GROUP BY ProjectGroup
ORDER BY Duration, MIN(Start_Date);

-- Task 2/11: Students whose friends have higher salaries
-- Joins Students, Friends, and Packages to compare salaries
SELECT s1.Name
FROM Students s1
JOIN Friends f ON s1.ID = f.ID
JOIN Packages p1 ON s1.ID = p1.ID
JOIN Packages p2 ON f.Friend_ID = p2.ID
WHERE p2.Salary > p1.Salary
ORDER BY p2.Salary;

-- Task 3: Symmetric pairs in Functions
-- Finds pairs where (X1, Y1) and (X2, Y2) satisfy X1 = Y2 and X2 = Y1
SELECT DISTINCT f1.X, f1.Y
FROM Functions f1
JOIN Functions f2 ON f1.X = f2.Y AND f1.Y = f2.X
WHERE f1.X <= f1.Y
ORDER BY f1.X;

-- Task 4: Aggregate contest statistics
-- Sums submissions and views, excludes contests with all zeros
SELECT 
    c.contest_id,
    c.hacker_id,
    c.name,
    COALESCE(SUM(ss.total_submissions), 0) AS total_submissions,
    COALESCE(SUM(ss.total_accepted_submissions), 0) AS total_accepted_submissions,
    COALESCE(SUM(vs.total_views), 0) AS total_views,
    COALESCE(SUM(vs.total_unique_views), 0) AS total_unique_views
FROM Contests c
JOIN Colleges col ON c.contest_id = col.contest_id
JOIN Challenges ch ON col.college_id = ch.college_id
LEFT JOIN View_Stats vs ON ch.challenge_id = vs.challenge_id
LEFT JOIN Submission_Stats ss ON ch.challenge_id = ss.challenge_id
GROUP BY c.contest_id, c.hacker_id, c.name
HAVING COALESCE(SUM(ss.total_submissions), 0) > 0
    OR COALESCE(SUM(ss.total_accepted_submissions), 0) > 0
    OR COALESCE(SUM(vs.total_views), 0) > 0
    OR COALESCE(SUM(vs.total_unique_views), 0) > 0
ORDER BY c.contest_id;

-- Task 5: Unique hackers and top submitter per day
-- Counts unique hackers and finds the hacker with most submissions (lowest ID for ties)
WITH DailySubmissions AS (
    SELECT 
        submission_date,
        hacker_id,
        COUNT(*) AS submission_count,
        ROW_NUMBER() OVER (PARTITION BY submission_date ORDER BY COUNT(*) DESC, hacker_id) AS rn
    FROM Submissions
    GROUP BY submission_date, hacker_id
),
UniqueHackers AS (
    SELECT 
        submission_date,
        COUNT(DISTINCT hacker_id) AS unique_hackers
    FROM Submissions
    GROUP BY submission_date
)
SELECT 
    uh.submission_date,
    uh.unique_hackers,
    ds.hacker_id,
    h.name
FROM UniqueHackers uh
JOIN DailySubmissions ds ON uh.submission_date = ds.submission_date
JOIN Hackers h ON ds.hacker_id = h.hacker_id
WHERE ds.rn = 1
ORDER BY uh.submission_date;

-- Task 6: Manhattan Distance in STATION
-- Calculates Manhattan Distance between min/max LAT_N and LONG_W
SELECT ROUND(
    ABS(MIN(LAT_N) - MAX(LAT_N)) + 
    ABS(MIN(LONG_W) - MAX(LONG_W)), 
    4
) AS manhattan_distance
FROM STATION;

-- Task 7: Prime numbers <= 1000
-- Generates prime numbers using a number table and divisibility check
WITH Numbers AS (
    SELECT n = number FROM master..spt_values 
    WHERE type = 'P' AND number BETWEEN 2 AND 1000
),
Primes AS (
    SELECT n
    FROM Numbers n
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Numbers d 
        WHERE d.n <= SQRT(n.n) AND d.n > 1 AND n.n % d.n = 0
    )
)
SELECT STRING_AGG(n, '&') AS prime_numbers
FROM Primes;

-- Task 8: Pivot OCCUPATIONS
-- Pivots names under each occupation, sorted alphabetically
WITH RankedNames AS (
    SELECT 
        Name,
        Occupation,
        ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
    FROM OCCUPATIONS
)
SELECT 
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM RankedNames
GROUP BY rn
ORDER BY rn;

-- Task 9: Binary Tree Node Types
-- Classifies nodes as Root, Leaf, or Inner
SELECT 
    N,
    CASE 
        WHEN P IS NULL THEN 'Root'
        WHEN N NOT IN (SELECT P FROM BST WHERE P IS NOT NULL) THEN 'Leaf'
        ELSE 'Inner'
    END AS NodeType
FROM BST
ORDER BY N;

-- Task 10: Company Hierarchy Counts
-- Counts employees at each level per company
SELECT 
    c.company_code,
    c.founder,
    COUNT(DISTINCT lm.lead_manager_code) AS lead_managers,
    COUNT(DISTINCT sm.senior_manager_code) AS senior_managers,
    COUNT(DISTINCT m.manager_code) AS managers,
    COUNT(DISTINCT e.employee_code) AS employees
FROM Company c
LEFT JOIN Lead_Manager lm ON c.company_code = lm.company_code
LEFT JOIN Senior_Manager sm ON c.company_code = sm.company_code
LEFT JOIN Manager m ON c.company_code = m.company_code
LEFT JOIN Employee e ON c.company_code = e.company_code
GROUP BY c.company_code, c.founder
ORDER BY c.company_code;

-- Task 11: Same as Task 2, query repeated for clarity
SELECT s1.Name
FROM Students s1
JOIN Friends f ON s1.ID = f.ID
JOIN Packages p1 ON s1.ID = p1.ID
JOIN Packages p2 ON f.Friend_ID = p2.ID
WHERE p2.Salary > p1.Salary
ORDER BY p2.Salary;


-- Task 12: Create JobFamilyCosts table for cost ratio by country
IF OBJECT_ID('JobFamilyCosts') IS NOT NULL DROP TABLE JobFamilyCosts;
CREATE TABLE JobFamilyCosts (
    JobFamilyID INT PRIMARY KEY,
    JobFamily VARCHAR(50),
    Country VARCHAR(10),
    Cost FLOAT
);

-- Task 13: Create BUCosts and BURevenues tables
IF OBJECT_ID('BUCosts') IS NOT NULL DROP TABLE BUCosts;
IF OBJECT_ID('BURevenues') IS NOT NULL DROP TABLE BURevenues;

CREATE TABLE BUCosts (
    BU_ID INT,
    BU_Name VARCHAR(50),
    CostMonth DATE,
    Cost FLOAT
);

CREATE TABLE BURevenues (
    BU_ID INT,
    BU_Name VARCHAR(50),
    RevenueMonth DATE,
    Revenue FLOAT
);

-- Insert sample data for Task 13
INSERT INTO BUCosts (BU_ID, BU_Name, CostMonth, Cost) VALUES
(1, 'Sales', '2025-01-01', 100000),
(1, 'Sales', '2025-02-01', 110000),
(2, 'Engineering', '2025-01-01', 150000),
(2, 'Engineering', '2025-02-01', 160000);

INSERT INTO BURevenues (BU_ID, BU_Name, RevenueMonth, Revenue) VALUES
(1, 'Sales', '2025-01-01', 500000),
(1, 'Sales', '2025-02-01', 550000),
(2, 'Engineering', '2025-01-01', 300000),
(2, 'Engineering', '2025-02-01', 320000);

-- Task 14 & 15 & 19: Create Employees table for headcounts, top salaries, and salary error
IF OBJECT_ID('Employees') IS NOT NULL DROP TABLE Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    SubBand VARCHAR(20),
    Salary FLOAT
);

-- Insert sample data for Employees
INSERT INTO Employees (EmployeeID, SubBand, Salary) VALUES
(1, 'Senior', 75000),
(2, 'Senior', 72000),
(3, 'Mid', 60000),
(4, 'Mid', 58000),
(5, 'Junior', 50000),
(6, 'Junior', 48000),
(7, 'Senior', 80000);

-- Task 18: Create EmployeeCosts table for weighted average cost
IF OBJECT_ID('EmployeeCosts') IS NOT NULL DROP TABLE EmployeeCosts;
CREATE TABLE EmployeeCosts (
    EmployeeID INT,
    CostMonth DATE,
    Cost FLOAT
);

-- Insert sample data for Task 18
INSERT INTO EmployeeCosts (EmployeeID, CostMonth, Cost) VALUES
(1, '2025-01-01', 7500),
(2, '2025-01-01', 7200),
(3, '2025-01-01', 6000),
(1, '2025-02-01', 7600),
(2, '2025-02-01', 7300),
(3, '2025-02-01', 6100);

-- Task 20: Create SourceEmployees and TargetEmployees tables
IF OBJECT_ID('SourceEmployees') IS NOT NULL DROP TABLE SourceEmployees;
IF OBJECT_ID('TargetEmployees') IS NOT NULL DROP TABLE TargetEmployees;

CREATE TABLE SourceEmployees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary FLOAT
);

CREATE TABLE TargetEmployees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary FLOAT
);

-- Insert sample data for SourceEmployees
INSERT INTO SourceEmployees (EmployeeID, Name, Salary) VALUES
(1, 'Alice', 75000),
(2, 'Bob', 72000),
(3, 'Charlie', 60000);

-- Insert some overlapping data in TargetEmployees
INSERT INTO TargetEmployees (EmployeeID, Name, Salary) VALUES
(1, 'Alice', 75000);

-- Queries for Tasks 12–20

-- Task 12: Ratio of cost of job family (India vs. International)
-- Calculates percentage of costs for India and International per job family
SELECT 
    JobFamily,
    ROUND(SUM(CASE WHEN Country = 'India' THEN Cost ELSE 0 END) / SUM(Cost) * 100, 2) AS India_Cost_Percentage,
    ROUND(SUM(CASE WHEN Country != 'India' THEN Cost ELSE 0 END) / SUM(Cost) * 100, 2) AS International_Cost_Percentage
FROM JobFamilyCosts
GROUP BY JobFamily;

-- Task 13: Cost-to-revenue ratio by BU month-on-month
-- Joins costs and revenues, computes monthly ratio
SELECT 
    c.BU_Name,
    c.CostMonth,
    ROUND(SUM(c.Cost) / NULLIF(SUM(r.Revenue), 0), 2) AS Cost_Revenue_Ratio
FROM BUCosts c
JOIN BURevenues r ON c.BU_ID = r.BU_ID AND c.CostMonth = r.RevenueMonth
GROUP BY c.BU_Name, c.CostMonth
ORDER BY c.CostMonth, c.BU_Name;

-- Task 14: Headcounts by sub band and percentage (no joins/subqueries)
-- Uses window function to calculate total headcount
SELECT 
    SubBand,
    COUNT(*) AS Headcount,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM Employees
GROUP BY SubBand;

-- Task 15: Top 5 employees by salary (without ORDER BY)
-- Uses TOP WITH TIES to avoid ORDER BY in final select
WITH TopSalaries AS (
    SELECT DISTINCT Salary
    FROM Employees
    WHERE Salary IN (
        SELECT DISTINCT TOP 5 Salary
        FROM Employees
        ORDER BY Salary DESC
    )
)
SELECT EmployeeID, Salary
FROM Employees
WHERE Salary IN (SELECT Salary FROM TopSalaries);

-- Task 16: Swap two columns in Functions table (no temp variable)
-- Uses arithmetic to swap X and Y
UPDATE Functions
SET X = X + Y, Y = X - Y, X = X - Y;

-- Task 17: Create user and assign DB_owner
-- Creates login and user, grants full permissions
CREATE LOGIN NewUser WITH PASSWORD = 'StrongP@ssw0rd!2025';
CREATE USER NewUser FOR LOGIN NewUser;
ALTER ROLE db_owner ADD MEMBER NewUser;

-- Task 18: Weighted average cost of employees month-on-month
-- Calculates total cost divided by number of employees per month
SELECT 
    CostMonth,
    ROUND(SUM(Cost) / COUNT(DISTINCT EmployeeID), 2) AS Weighted_Avg_Cost
FROM EmployeeCosts
GROUP BY CostMonth
ORDER BY CostMonth;

-- Task 19: Salary miscalculation error (broken 0 key)
-- Calculates difference between actual and miscalculated (zeros removed) average salaries
SELECT CEILING(
    (SELECT AVG(Salary) FROM Employees) -
    (SELECT AVG(CAST(REPLACE(CAST(Salary AS VARCHAR), '0', '') AS FLOAT)) 
     FROM Employees)
) AS Error;

-- Task 20: Copy new data from SourceEmployees to TargetEmployees
-- Copies records where EmployeeID doesn't exist in TargetEmployees
INSERT INTO TargetEmployees (EmployeeID, Name, Salary)
SELECT EmployeeID, Name, Salary
FROM SourceEmployees s
WHERE NOT EXISTS (
    SELECT 1 FROM TargetEmployees t
    WHERE t.EmployeeID = s.EmployeeID
);