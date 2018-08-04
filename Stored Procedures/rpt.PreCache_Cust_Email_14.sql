SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [rpt].[PreCache_Cust_Email_14]

AS 

DECLARE	@CutoffDate DATE = DATEADD(dd,-90,GETDATE())

INSERT INTO [rpt].[PreCache_Cust_Email_14_tbl]

SELECT CASE WHEN x.numSent = 0				 THEN 0
			WHEN x.numSent BETWEEN 1 AND 5	 THEN 1          
			WHEN x.numSent BETWEEN 6 AND 15  THEN 2
			WHEN x.numSent BETWEEN 16 AND 30 THEN 3
			WHEN x.numSent BETWEEN 31 AND 45 THEN 4
			WHEN x.numSent BETWEEN 46 AND 60 THEN 5
			ELSE 6
	   END SortOrder
	   ,CASE WHEN x.numSent = 0				 THEN '0'
			WHEN x.numSent BETWEEN 1 AND 5	 THEN '1-5'          
			WHEN x.numSent BETWEEN 6 AND 15  THEN '6-15'
			WHEN x.numSent BETWEEN 16 AND 30 THEN '16-30'
			WHEN x.numSent BETWEEN 31 AND 45 THEN '31-45'
			WHEN x.numSent BETWEEN 46 AND 60 THEN '46-60'
			ELSE '> 60'
	   END AS CountBucket
	   ,COUNT(x.SSID) AS numCustomers
	   ,0 AS IsReady 
FROM (  SELECT dc.SSID
	   ,ISNULL(adu.numSent,0) numSent
FROM dimcustomerssbid dc
	JOIN rpt.vw__Epsilon_Emailable_Harmony emailable ON emailable.PROFILE_KEY = dc.SSID
	LEFT JOIN (SELECT adu.PROFILE_KEY
						,COUNT(DISTINCT adu.MessageName)numSent
				FROM [rpt].[vw__Epsilon_ADU_Harmony] adu 
				WHERE adu.ActionDate > @CutoffDate
						AND action = 'SEND'
				GROUP BY adu.PROFILE_KEY
				) adu ON adu.PROFILE_KEY = emailable.PROFILE_KEY
		
	  )x
GROUP BY CASE WHEN x.numSent = 0			 THEN 0
			WHEN x.numSent BETWEEN 1 AND 5	 THEN 1          
			WHEN x.numSent BETWEEN 6 AND 15  THEN 2
			WHEN x.numSent BETWEEN 16 AND 30 THEN 3
			WHEN x.numSent BETWEEN 31 AND 45 THEN 4
			WHEN x.numSent BETWEEN 46 AND 60 THEN 5
			ELSE 6
	   END
	   ,CASE WHEN x.numSent = 0				 THEN '0'
			WHEN x.numSent BETWEEN 1 AND 5	 THEN '1-5'          
			WHEN x.numSent BETWEEN 6 AND 15  THEN '6-15'
			WHEN x.numSent BETWEEN 16 AND 30 THEN '16-30'
			WHEN x.numSent BETWEEN 31 AND 45 THEN '31-45'
			WHEN x.numSent BETWEEN 46 AND 60 THEN '46-60'
			ELSE '> 60'
	   END

DELETE FROM [rpt].[PreCache_Cust_Email_14_tbl] WHERE IsReady = 1
UPDATE [rpt].[PreCache_Cust_Email_14_tbl] SET IsReady = 1









GO
