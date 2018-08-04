SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [rpt].[PreCache_Cust_Email_7]
AS


SELECT emailChannelOptStatusDate OPTOUT_DATE
INTO #base
FROM ods.epsilon_profile_updates
WHERE EmailChannelOptOutFlag = 'Y'
	  AND NOT emailChannelOptStatusDate < '20161001' --filter out records from August when conversion took place

INSERT INTO [rpt].[PreCache_Cust_Email_7_tbl]

SELECT EOMONTH(OPTOUT_DATE) SortOrder
	   ,DATENAME(MONTH,OPTOUT_DATE) OptOut_Month
	   ,COUNT(*) OptOuts
	   ,0 AS IsReady
FROM #base  
GROUP BY EOMONTH(OPTOUT_DATE) 
	    ,DATENAME(MONTH,OPTOUT_DATE) 
ORDER BY SortOrder

DELETE FROM [rpt].[PreCache_Cust_Email_7_tbl]
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_Email_7_tbl]
SET IsReady = 1

DROP TABLE #base





GO
