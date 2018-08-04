SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROC [rpt].[PreCache_Cust_DB_1] AS

IF OBJECT_ID('tempdb..#countHelper') IS NOT NULL DROP TABLE #countHelper
IF OBJECT_ID('tempdb..#temp')IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#output')IS NOT NULL DROP TABLE #output


DECLARE @startDate DATE = (SELECT MIN(CreatedDate) FROM dbo.DimCustomer (NOLOCK) WHERE createdDate <> '19000101')
DECLARE @InsertDate DATE = @startDate

/*============================================================================================
										COUNT HELPER
============================================================================================*/


CREATE TABLE #countHelper (
DisplayName VARCHAR(20)
,DateID INT
)

WHILE EOMONTH(@InsertDate) <= EOMONTH(GETDATE())
BEGIN

INSERT #countHelper
        ( DisplayName, DateID )
VALUES	(CONCAT(DATENAME(MONTH,@InsertDate),' ',YEAR(@InsertDate)), 100*YEAR(@InsertDate) + MONTH(@InsertDate))

SET @InsertDate = DATEADD(MONTH,1,@InsertDate)

END


/*============================================================================================
										BASE SET
============================================================================================*/


SELECT SSB_CRMSYSTEM_CONTACT_ID
	  ,RANK() OVER( PARTITION BY SSB_CRMSYSTEM_CONTACT_ID ORDER BY CreatedDate ) AS SourceRank
	  ,100*YEAR(x.CreatedDate) + MONTH(x.CreatedDate) AS DateID
INTO #temp
FROM (  SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID
			   ,dc.SourceSystem
			   ,MIN(dc.CreatedDate) AS CreatedDate
		FROM dbo.dimcustomerssbid ssbid
			JOIN dimcustomer dc ON dc.DimCustomerId = ssbid.DimCustomerId
		WHERE dc.createdDate <> '19000101'
		GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
				,dc.SourceSystem)x

/*============================================================================================
										  OUTPUT
============================================================================================*/

SELECT  DateID
	   ,COUNT(CASE WHEN SourceRank = 1 THEN SSB_CRMSYSTEM_CONTACT_ID END) TotalCount
	   ,COUNT(CASE WHEN SourceRank = 2 THEN SSB_CRMSYSTEM_CONTACT_ID END) CrossoverCount
INTO #output
FROM #temp
GROUP BY DateID

INSERT INTO [rpt].[PreCache_Cust_DB_1_tbl]

SELECT helper.DisplayName
	   ,helper.DateID AS SortOrder		
	   ,SUM(output.TotalCount) AS TotalCount
	   ,SUM(output.CrossoverCount) AS CrossoverCount
	   ,0 AS IsReady
FROM #countHelper helper
	LEFT JOIN #output output ON output.DateID <= helper.DateID
GROUP BY helper.DisplayName, helper.DateID
ORDER BY SortOrder

DELETE FROM [rpt].[PreCache_Cust_DB_1_tbl] WHERE IsReady = 1
UPDATE [rpt].[PreCache_Cust_DB_1_tbl]	   SET ISready = 1

/*============================================================================================
										CLEAN UP
============================================================================================*/


DROP TABLE #countHelper
DROP TABLE #temp
DROP TABLE #output





GO
