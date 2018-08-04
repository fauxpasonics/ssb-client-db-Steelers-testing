SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE PROC [rpt].[PreCache_Cust_Email_4]

AS 


IF OBJECT_ID('tempdb..#base')IS NOT NULL DROP TABLE #base

SELECT ssbid.SSID
	   ,DATEDIFF(YEAR,NULLIF(cr.Birthday,'1900-01-01'),GETDATE()) age
	   ,CASE WHEN engaged.profile_key IS NOT NULL THEN 1 ELSE 0 END AS engaged
INTO #base
FROM dbo.DimCustomerSSBID ssbid 
	JOIN mdm.compositerecord cr ON cr.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID
	JOIN rpt.vw__Epsilon_emailable_Harmony emailable ON emailable.PROFILE_KEY = ssbid.SSID			
	LEFT JOIN rpt.vw__Epsilon_Engaged_Harmony engaged ON engaged.PROFILE_KEY = ssbid.SSID
WHERE ssbid.SourceSystem = 'Epsilon' 

INSERT [rpt].[PreCache_Cust_Email_4_tbl]

SELECT CASE WHEN age < 18 THEN 'Under 18'
            WHEN age BETWEEN 18 AND 29 THEN 'Between 18 and 29'
            WHEN age BETWEEN 30 AND 39 THEN 'Between 30 and 39'
            WHEN age BETWEEN 40 AND 49 THEN 'Between 40 and 49'
            WHEN age BETWEEN 50 AND 59 THEN 'Between 50 and 59'
            WHEN age BETWEEN 60 AND 69 THEN 'Between 60 and 69'
            WHEN age > 70			   THEN 'Over 70'
            ELSE 'Unknown'
        END AS AgeBracket 
		,COUNT(DISTINCT CASE WHEN engaged = 1 THEN SSID ELSE NULL END) EngagedMembers
		,COUNT(DISTINCT CASE WHEN engaged = 0 THEN SSID ELSE NULL END) NonEngagedMembers
		,0 AS IsReady
FROM #base
GROUP BY CASE WHEN age < 18 THEN 'Under 18'
              WHEN age BETWEEN 18 AND 29 THEN 'Between 18 and 29'
              WHEN age BETWEEN 30 AND 39 THEN 'Between 30 and 39'
              WHEN age BETWEEN 40 AND 49 THEN 'Between 40 and 49'
              WHEN age BETWEEN 50 AND 59 THEN 'Between 50 and 59'
              WHEN age BETWEEN 60 AND 69 THEN 'Between 60 and 69'
              WHEN age > 70			   THEN 'Over 70'
              ELSE 'Unknown'
        END

DELETE  rpt.PreCache_Cust_Email_4_tbl WHERE isReady = 1
UPDATE  rpt.PreCache_Cust_Email_4_tbl SET isReady = 1

DROP TABLE #base










GO
