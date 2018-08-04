SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--EXEC [rpt].[Cust_DB_Overview_7]

CREATE PROC [rpt].[PreCache_Cust_DB_7] AS

--Look at a rolling 12 months starting 4/1/16
DECLARE @LowerDateBound DATE = CASE WHEN '2016-04-01' > DATEADD(MONTH,-12,GETDATE()) THEN '2016-04-01'
									ELSE DATEADD(MONTH,-12,GETDATE())
							   END

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	   , dc.SourceSystem
	   , RANK() OVER(PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID ORDER BY CAST(dc.CreatedDate AS DATE), rnk.SourceRank) AS JoinRank
INTO #output
FROM dbo.DimCustomerSSBID ssbid
	JOIN dimcustomer dc ON dc.DimCustomerId = ssbid.DimCustomerId
	LEFT JOIN rpt.Cust_DB_Overview_7_SourceRank rnk ON rnk.SourceSystem = dc.SourceSystem
	LEFT JOIN (SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
					 ,MIN(dc.CreatedDate) JoinDate
			   FROM dbo.DimCustomerSSBID ssbid
					JOIN dbo.DimCustomer dc ON dc.DimCustomerId = ssbid.DimCustomerId
			   GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
			   HAVING MIN(dc.CreatedDate) <= @LowerDateBound
			   )x ON x.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID
WHERE x.SSB_CRMSYSTEM_CONTACT_ID IS NULL

INSERT INTO [rpt].[PreCache_Cust_DB_7_tbl]

SELECT sourcesystem
	  ,COUNT(DISTINCT SSB_CRMSYSTEM_CONTACT_ID) numCustomers
	  ,0 AS IsReady
FROM #output
WHERE JoinRank = 1
GROUP BY SourceSystem
HAVING COUNT(DISTINCT SSB_CRMSYSTEM_CONTACT_ID) > 1

DELETE FROM [rpt].[PreCache_Cust_DB_7_tbl] WHERE IsReady = 1
UPDATE [rpt].[PreCache_Cust_DB_7_tbl] SET IsReady = 1

DROP TABLE #output





GO
