select * from `workspace`.`bright_tv`.`Viewership` limit 10;

--------------------------------------------------------
--- How many users do I have in TOTAL?
---Answer :4386
-------------------------------------------------------
SELECT COUNT(DISTINCT UserID0) AS TotalUsers
FROM `workspace`.`bright_tv`.`Viewership`;

-------------------------------------------------------
--- We want to know how many channels we have in total
--Answer: 21
-------------------------------------------------------
SELECT COUNT( DISTINCT Channel2) AS Total_Channels
FROM `workspace`.`bright_tv`.`Viewership`;

--------------------------------------
---Checking the date range
--------------------------------------
SELECT MAX(RecordDate2) AS MaxDate
FROM `workspace`.`bright_tv`.`Viewership`;
------Answer: 2016-03-31

SELECT MIN(RecordDate2) AS MinDate
FROM `workspace`.`bright_tv`.`Viewership`;
----Answer: 2016-01-01

SELECT DATEDIFF(DAY,'2016-01-01','2016-03-31') AS Date_Range;
----Answer: 90 Days
      

-----------------------------------------------------
--- Trying different time conversion code
-----------------------------------------------------

---1st code -- This works but it does not change seperate the date and time
SELECT from_utc_timestamp(v.`RecordDate2`, 'Africa/Johannesburg') AS SA_converted_time
FROM `workspace`.`bright_tv`.`Viewership` AS v;

--- 2nd code -- This works, but it only give me the time and not the date
SELECT DATE_FORMAT(RecordDate2 + INTERVAL '2 hour', 'HH:mm:ss') AS SA_Time
FROM `workspace`.`bright_tv`.`Viewership`;


---3rd code -- This works and I prefer this code for  SA date and time
SELECT 
DATE_FORMAT(RecordDate2, 'yyyy-MM-dd') AS DATE,
DATE_FORMAT(RecordDate2 + INTERVAL '2 hour', 'HH:mm:ss') AS SA_Time
FROM `workspace`.`bright_tv`.`Viewership`;

--- 4th code -- This also works but  it does not seperate time and date just like the 1st code
SELECT DATEADD(HOUR, 2,RecordDate2) AS SA_Time
FROM `workspace`.`bright_tv`.`Viewership`;

---------------------------------------------------------------
--- Trying different codes to get the correct Viewing Duration
---------------------------------------------------------------

---1st code This code works, but it displays the minutes in a difficult to read  format

SELECT
    (unix_timestamp(`Duration 2`)- unix_timestamp('1899-12-31 00:00:00')) /60 AS duration_minutes
FROM `workspace`.`bright_tv`.`Viewership`;

---2nd code-- Code displays in the correct and easy to read format.
SELECT DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS Viewing_Time
FROM `workspace`.`bright_tv`.`Viewership`;


----------------------------------------------------------------------------------------------------------
--- User Profile table Sql codes below:

select * from `workspace`.`bright_tv`.`user_profiles` limit 10;
-----------------------------------------------------
----Checking the amount of users per Province
---------------------------------------------------
SELECT Province, COUNT(UserID) AS User_per_Province
FROM  `workspace`.`bright_tv`.`user_profiles`
GROUP BY Province
ORDER BY User_per_Province DESC;

-----------------------------------------------------
--- Checking the amount of users per Gender
----------------------------------------------------
SELECT Gender, COUNT(UserID) AS User_per_Gender
FROM  `workspace`.`bright_tv`.`user_profiles`
GROUP BY Gender
ORDER BY User_per_Gender;

-----------------------------------------------------
--- Checking the amount of users per RACE
----------------------------------------------------

SELECT Race, COUNT(UserID) AS User_per_Race
FROM `workspace`.`bright_tv`.`user_profiles`
GROUP BY Race
ORDER BY User_per_Race DESC;

-----------------------------------------------------
--- Checking the data that contains 'None'
-----------------------------------------------------

SELECT Age, COUNT(UserID) AS Number_of_None
FROM `workspace`.`bright_tv`.`user_profiles`
WHERE Province = 'None'
GROUP BY Age;


SELECT Province, COUNT(UserID) AS Number_of_None
FROM `workspace`.`bright_tv`.`user_profiles`
WHERE Province = 'None'
GROUP BY Province;
---Answer: 702



----------------------------------------------------
---Cleaning data removing none and blanks
--------------------------------------------------------
SELECT UserID,
      CASE 
            WHEN Name IS NULL OR Name = 'None' THEN 'Unkown'
            ELSE Name
            END AS Name,

      CASE 
            WHEN Surname IS NULL OR Surname = 'None' THEN 'Unkown'
            ELSE Surname
            END AS Surname,
      CASE 
            WHEN Email IS NULL OR Email = 'None' THEN 'Unkown'
            ELSE Email
            END AS Email,
      CASE 
            WHEN Gender IS NULL OR Gender = 'None' THEN 'Unkown'
            ELSE Gender
            END AS Gender,
      CASE 
            WHEN Race IS NULL OR Race = 'None' THEN 'Unkown'
            ELSE Race
            END AS Race,

      CASE 
            WHEN Age IS NULL OR AGE = 0 THEN NULL
            ELSE age 
            END AS Age

FROM `workspace`.`bright_tv`.`user_profiles`;


------------------------------------------------------
---Combine the Viewership and User Profile tables using Left Join
---------------------------------------------
SELECT v.userid0,
      v.Channel2,

      DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS Viewing_Duration,
      DATE_FORMAT(RecordDate2, 'yyyy-MM-dd') AS DATE,
      DATE_FORMAT(RecordDate2 + INTERVAL '2 hour', 'HH:mm:ss') AS SA_Time,

            DAYNAME(RecordDate2) AS Day,
            MONTHNAME(RecordDate2) AS Month,
            YEAR(RecordDate2) AS YEAR,

      CASE 
            WHEN Province IS NULL OR Province = 'None' THEN 'Unkown'
            ELSE Province
            END AS Province,
      

      CASE 
            WHEN Gender IS NULL OR Gender = 'None' THEN 'Unkown'
            ELSE Gender
            END AS Gender,
      CASE 
            WHEN Race IS NULL OR Race = 'None' THEN 'Unkown'
            ELSE Race
            END AS Race,

      CASE 
            WHEN Age IS NULL OR AGE = 0 THEN NULL
            ELSE age 
            END AS Age,
-----------------------------------------------------
--- Age classification
----------------------------------------------------
      CASE
            WHEN Age >= 55 THEN 'Senior'
            WHEN Age BETWEEN 35 AND 54 THEN 'Adult'
            WHEN Age BETWEEN 18 AND 34 THEN 'Young Adult'
            WHEN Age BETWEEN 13 AND 17 THEN 'Teenager'
            WHEN Age BETWEEN 0 AND 12 THEN 'Child'
            ELSE 'Unknown'
            END AS age_group



FROM  `workspace`.`bright_tv`.`Viewership` AS V
LEFT JOIN `workspace`.`bright_tv`.`user_profiles` AS U_P
ON V.UserID0 = U_P.UserID;
