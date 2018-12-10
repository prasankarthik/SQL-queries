-- Queries the can extract useful information from database
-- To give context to the data, this is the database system designed by Professor Hoyos for the Recruitment center in our school
-- Hence the database has Candidate, Interview, Interviewer, Position, Company tables

--Queries utilizing the Join command to combine two tables and extract data

--Find all candidates who were interviewed for second round (Round Number = 2)
--Internship position. Show each candidate’s details which includes candidate ID,
--candidate name, phone number, candidate experience, and relevant experience.

SELECT DISTINCT C.CandidateID, C.CLName, C.CPhone, C.CExperience, C.CRelevantExp
FROM Candidate C INNER JOIN Interview I
ON C.CandidateID = I.CandidateID
WHERE I.RoundNumber = 2

--Find all positions whose interviews were conducted by "Amy May"(interviewer).
--Show the PositionId, position level, position name and position availability.

SELECT P.PositionID, P.PositionLevel, P.PositionName, P.PositionAvailable
FROM Interviewer I LEFT OUTER JOIN Interview IV
ON I.InterviewerID = IV.InterviewerID
INNER JOIN Position P
ON IV.PositionID = P.PositionID
WHERE I.IFName = 'Amy' AND I.ILName='May'

--Find all interviewers who conducted one or more second-round interviews. Show the
--Interviewer details like Interviewer ID, Interviewer phone, Intervieweremail,
--Interviewer address and schedule.

--I am using a subquery - first querying to find out which interviewers have conducted second round interviews
--Then using it in the main query to extract the necessary attributes about the interviewer

SELECT InterviewerID, IPhone, IEmail, CONCAT(IstreetNo,' ', IStreetName, ' ', ICity,' Zip-',IZip), ISchedule
FROM Interviewer 
WHERE InterviewerID IN
(SELECT DISTINCT I.InterviewerID
FROM Interview IV RIGHT OUTER JOIN Interviewer I
ON IV.InterviewerID = I.InterviewerID
WHERE IV.RoundNumber = 2)

--Find all candidates who interviewed for the position “Advisory Consultant”. Show
--Candidate details and interview details.


SELECT DISTINCT C.CFName, C.CLName
FROM Candidate C INNER JOIN Interview IV
ON C.CandidateID = IV.CandidateID
INNER JOIN Position P
ON IV.PositionID = P.PositionID
WHERE P.PositionName = 'Advisory Consultant'

--Find positions for all the interviews that were conducted on September 28th, 2013.
--Show the PositionId, position level, position name and position availability.

SELECT P.PositionName
FROM Interview IV LEFT OUTER JOIN Position P
ON IV.PositionID = P.PositionID
WHERE MONTH(IV.InterviewDate) = 09 AND DAY(IV.InterviewDate) = 28 AND YEAR(IV.InterviewDate) = 2013

--Find all positions for which no interviews were conducted, and delete them from the
--Position table.

--Using a subquery to find the positions and then deleting


DELETE FROM Position
WHERE PositionID NOT IN (SELECT DISTINCT P.PositionID
FROM Position P RIGHT OUTER JOIN Interview IV
ON P.PositionID = IV.PositionID)


--Find the interviewer who conducted the interview for candidate "Heather Cameron".
--Update this interviewer's phone number to 315-400-5000.

--Using a subquery to find the interviewer and then updating his contact number

UPDATE Interviewer 
SET IPhone = 3154005000 
WHERE InterviewerID IN
(SELECT I.InterviewerID
FROM Candidate C INNER JOIN Interview IV
on C.CandidateID = IV.CandidateID
INNER JOIN Interviewer I
on IV.InterviewerID = I.InterviewerID
WHERE C.CFName = 'Heather' AND C.CLName = 'Cameron')


--Count the number of candidate in each zip code. Show the zip code and the number of candidates in each zip code. 

SELECT CZip,count(CandidateID) AS Count 
FROM Candidate 
GROUP BY CZip

--Sort interview table by number of the round number. Show interview ID and round number

SELECT InterviewID, RoundNumber 
FROM Interview 
ORDER BY RoundNumber DESC

--Sort interview by interview date. Show interview ID, Interviewer ID and the interview dateSELECT InterviewID, InterviewerID, InterviewDate FROM Interview ORDER BY InterviewDate DESC
--For each candidate, calculate the average, min, and max round number of the interviews that this candidate had. Show CandidateId, average Round Number, min
--Round Number, and max Round Number. 

SELECT CandidateID, AVG(RoundNumber) AS Average, MIN(RoundNumber) AS Minimum, MAX(RoundNumber) AS Maximum
FROM Interview 
GROUP BY CandidateID

--Find all candidates whose average round number of interviews is below 3 (i.e. average
--round number equals 1 or 2). Show the CandidateID and average round number. 

SELECT CandidateID, AVG(RoundNumber) AS Average 
FROM Interview GROUP BY CandidateID
HAVING AVG(RoundNumber) < 3
