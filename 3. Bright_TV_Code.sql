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
