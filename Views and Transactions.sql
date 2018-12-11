-- View is a virtual table based on a result of sql statement
-- View can be used to combine data from multiple tables and can be accessed when necessary
-- We can access the most recent data, when a view is called

--I have created views for various scenarios

--interviews_summary: for all the candidates, find their interviews and the
--corresponding interviewers. This view should show the candidate ID, candidate
--name, interview ID, interviewer ID, and interviewer name.

CREATE VIEW Interview_Summary AS
SELECT C.CandidateID, C.CFName, C.CLName, I.InterviewID, Iv.InterviewerID, Iv.IFName, Iv.ILName
FROM Interview I INNER JOIN Candidate C
ON I.CandidateID = C.CandidateID
INNER JOIN Interviewer Iv
ON Iv.InterviewerID = I.InterviewerID

--position_summary: find the total number of positions available for each company in
--the second half of 2013 (Jul, Aug, Sep, Oct, Nov, Dec).

CREATE VIEW Postion_Summary AS
SELECT C.CompanyID, C.CompanyName, COUNT(P.PositionID) AS Number_of_open_position
FROM Position P INNER JOIN Company C
ON P.CompanyID = C.CompanyID
INNER JOIN Interview I
ON I.PositionID = P.PositionID
WHERE P.PositionAvailable = 'Yes' 
AND YEAR(I.InterviewDate) = 2013 AND MONTH(I.InterviewDate) in (7,8,9,10,11,12)
GROUP BY C.CompanyID, C.CompanyName

--maximum_candidate_interview_summary: find the candidate who had the largest
--number of interviews.

CREATE VIEW Maximum_Candidate_Interview_Summary AS
SELECT TOP 1 WITH TIES C.CandidateID, COUNT(I.InterviewID) AS Max_Count
FROM Candidate C RIGHT OUTER JOIN Interview I
ON C.CandidateID = I.CandidateID
GROUP BY C.CandidateID
ORDER BY COUNT(I.InterviewID) DESC

--minimum_interviewer_prescription_summary: find the interviewer who had the
--lowest number of interviews

CREATE VIEW Minimum_Interviewer_Prescription_Summary AS
SELECT TOP 1 WITH TIES IR.InterviewerID, COUNT(I.InterviewID) AS Min_Count
FROM Interviewer IR LEFT OUTER JOIN Interview I
ON IR.InterviewerID = I.InterviewerID
GROUP BY IR.InterviewerID
ORDER BY COUNT(I.InterviewID) ASC

--position_interview_summary: find the position for which the largest number of
--interviews were conducted.
CREATE VIEW Position_Interview_Summary AS
SELECT TOP 1 WITH TIES P.PositionID, P.PositionName, COUNT(I.InterviewID) AS Max_Count
FROM Position P LEFT OUTER JOIN Interview I
ON P.PositionID = I.PositionID
GROUP BY P.PositionID, P.PositionName
ORDER BY COUNT(I.InterviewID) DESC

---A transaction is a sequence of operations performed (using one or more SQL statements) on a database as a single logical unit of work
-- A transaction adheres to ACID property - Atomicity, Consistent, Isolated, Durable

-- Transactions can be rolled back if all the ought to be executed code block fails

--Create a new interview for a new candidate. New rows should be inserted into the tables Candidate, Interview, and Position.
--ROLLBACK the transaction

SET IMPLICIT_TRANSACTIONS ON;
 BEGIN TRANSACTION;
 
 INSERT INTO Candidate 
 VALUES (11, 'Shah', 'Kantilal', 3154231234, 'shah@syr.edu', 192, 'Westcott St', 'Syracuse', 13210,'Database Developer', 'Database Admin', NULL, 'NY')

 INSERT INTO Position(PositionID, PositionName, PositionLevel, PositionAvailable, CompanyID)
 VALUES(13,'Database Developer', 'Entry', 'Yes', 6);

 INSERT INTO Interviewer(InterviewerID, IFName, ILName, IPhone, IEmail, IStreetNo, IStreetName, ICity, IZip)
 VALUES(11,'Rose', 'Barbara', 3124442222, 'rose@syr.edu', 480, 'Comstock Ave', 'Syracuse', 13210)

 INSERT INTO Interview
 VALUES(22, 1, '2013-11-08', 11, 11, 13)

 ROLLBACK;
  
  
-- Create an interview and commit

BEGIN TRANSACTION;
 
 INSERT INTO Candidate 
 VALUES (11, 'Shah', 'Kantilal', 3154231234, 'shah@syr.edu', 192, 'Westcott St', 'Syracuse', 13210,'Database Developer', 'Database Admin', NULL, 'NY')

 INSERT INTO Position(PositionID, PositionName, PositionLevel, PositionAvailable, CompanyID)
 VALUES(13,'Database Developer', 'Entry', 'Yes', 6);

 INSERT INTO Interviewer(InterviewerID, IFName, ILName, IPhone, IEmail, IStreetNo, IStreetName, ICity, IZip)
 VALUES(11,'Rose', 'Barbara', 3124442222, 'rose@syr.edu', 480, 'Comstock Ave', 'Syracuse', 13210)

 INSERT INTO Interview
 VALUES(22, 1, '2013-11-08', 11, 11, 13)

 COMMIT;

