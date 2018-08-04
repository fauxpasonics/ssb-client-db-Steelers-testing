SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE PROC [rpt].[PreCache_Cust_DB_5] AS



IF OBJECT_ID('tempdb..#base')IS NOT NULL DROP TABLE #base


SELECT SSB_CRMSYSTEM_CONTACT_ID
	   ,DATEDIFF(YEAR,NULLIF(cr.Birthday, '1900-01-01'),GETDATE()) age
INTO #base
FROM mdm.compositerecord cr


INSERT INTO [rpt].[PreCache_Cust_DB_5_tbl]

SELECT CASE WHEN age < 18 THEN 'Under 18'
            WHEN age BETWEEN 18 AND 29 THEN 'Between 18 and 29'
            WHEN age BETWEEN 30 AND 39 THEN 'Between 30 and 39'
            WHEN age BETWEEN 40 AND 49 THEN 'Between 40 and 49'
            WHEN age BETWEEN 50 AND 59 THEN 'Between 50 and 59'
            WHEN age BETWEEN 60 AND 69 THEN 'Between 60 and 69'
            WHEN age > 70			   THEN 'Over 70'
            ELSE 'Unknown'
        END AS AgeBracket 
		,COUNT(SSB_CRMSYSTEM_CONTACT_ID) AgeCount
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

DELETE FROM [rpt].[PreCache_Cust_DB_5_tbl] WHERE IsReady = 1
UPDATE [rpt].[PreCache_Cust_DB_5_tbl] SET IsReady = 1

DROP TABLE #base











GO
