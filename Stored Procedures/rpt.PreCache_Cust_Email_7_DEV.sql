SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












CREATE PROC [rpt].[PreCache_Cust_Email_7_DEV]
AS

DECLARE	@CutoffDate DATE = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)

SELECT OPTOUT_DATE
INTO #base
FROM rpt.vw__epsilon_PDU_Combined
WHERE OPTOUT_FLG = 1
	  AND OPTOUT_DATE >= @CutoffDate

INSERT INTO [rpt].[PreCache_Cust_Email_7_tbl]

SELECT DATEPART(MONTH,OPTOUT_DATE) SortOrder
	   ,DATENAME(MONTH,OPTOUT_DATE) OptOut_Month
	   ,COUNT(*) OptOuts
	   ,0 AS IsReady
FROM #base  
GROUP BY DATEPART(MONTH,OPTOUT_DATE) 
	    ,DATENAME(MONTH,OPTOUT_DATE) 


DELETE FROM [rpt].[PreCache_Cust_Email_7_tbl]
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_Email_7_tbl]
SET IsReady = 1

DROP TABLE #base



GO
