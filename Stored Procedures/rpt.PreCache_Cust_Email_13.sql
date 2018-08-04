SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--EXEC [rpt].[Cust_Email_13]

CREATE PROCEDURE [rpt].[PreCache_Cust_Email_13]
AS

IF OBJECT_ID('tempdb..#base')IS NOT NULL DROP TABLE #base

DECLARE @LowerDateBound DATE = DATEADD(MONTH,-12,EOMONTH(GETDATE()))
DECLARE @TotalEmailable INT = (SELECT  COUNT(*) FROM rpt.vw__Epsilon_Emailable emailable)
		
SELECT  ActionDate
	   ,Action
	   ,MessageName MAILING_NAME
INTO #base
FROM rpt.vw__Epsilon_ADU_Combined adu
WHERE  adu.ActionDate > @LowerDateBound

INSERT INTO rpt.PreCache_Cust_Email_13_tbl

SELECT  EOMONTH(ActionDate) AS SortOrder
	   ,DATENAME(MONTH,ActionDate) AS MonthLabel
	   ,CAST(1.0*COUNT(CASE WHEN Action IN ('SEND') THEN MAILING_NAME END)/@TotalEmailable AS DECIMAL(5,3)) AvgEmailSent
	   ,CAST(1.0*COUNT(CASE WHEN Action IN ('OPEN','CLICK') THEN MAILING_NAME END)/@TotalEmailable AS DECIMAL(5,3)) AvgEmailOpenClick
	   ,0 AS IsReady
FROM #base
GROUP BY EOMONTH(ActionDate)
	   ,DATENAME(MONTH,ActionDate)
ORDER BY SortOrder

DELETE FROM rpt.PreCache_Cust_Email_13_tbl
WHERE isReady = 1

UPDATE rpt.PreCache_Cust_Email_13_tbl
SET IsReady = 1

DROP TABLE #base


GO
