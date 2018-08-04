SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO















CREATE PROC [rpt].[PreCache_Cust_DB_8] AS

DECLARE @LowerDateBound DATE = dateADD(year,-1,GETDATE())

/*==========================================================================================
											STH
==========================================================================================*/

SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID
INTO #STH
FROM dbo.DimCustomerSSBID ssbid 
	JOIN DimCustomer dc on dc.dimcustomerid = ssbid.dimcustomerid
	JOIN rpt.STH_Accounts_2017 sth on sth.acct_id = dc.AccountID
WHERE dc.customerType = 'Primary'

/*==========================================================================================
											SPEND
==========================================================================================*/


SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	   ,SUM(ISNULL(fts.REV,0) + ISNULL(merch.REV,0) + ISNULL(events.Extattribute12,0)) AS AnnualSpend
INTO #spend
FROM dbo.DimCustomerSSBID ssbid
	LEFT JOIN (SELECT fts.DimCustomerId
					  ,SUM(BlockPurchasePrice) REV
			   FROM dbo.FactTicketSales	fts
				  JOIN dbo.dimevent de ON de.dimeventid = fts.dimeventid
				  JOIN rpt.cust_db_overview_8_events e ON e.eventCode = de.eventCode
			   GROUP BY fts.DimCustomerId
			   ) fts ON fts.DimCustomerId = ssbid.DimCustomerId
	LEFT JOIN (SELECT CAST(customerid AS NVARCHAR(100)) customerid
					  ,SUM(mo.OrderTotal) REV
			   FROM ods.Merch_Order mo
			   WHERE mo.PaidDateUtc >= @LowerDateBound 
				     AND mo.StoreId = 1
			   GROUP BY mo.CustomerId
			   )merch ON merch.CustomerId = ssbid.SSID			
						 AND ssbid.SourceSystem = 'merch'
	LEFT JOIN dimcustomer events ON events.dimcustomerid = ssbid.dimcustomerid
									AND events.sourcesystem = 'Events'
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
HAVING SUM(ISNULL(fts.REV,0) + ISNULL(merch.REV,0) + ISNULL(events.Extattribute12,0)) > 0

/*==========================================================================================
											OUTPUT
==========================================================================================*/

INSERT INTO [rpt].[PreCache_Cust_DB_8_tbl]

SELECT CASE WHEN AnnualSpend < 41 THEN '$1-$40'
			WHEN AnnualSpend < 101 THEN '$41-$100'
			WHEN AnnualSpend < 201 THEN '$101-$200'
			WHEN AnnualSpend < 501 THEN '$201-$500'
			WHEN AnnualSpend < 1001 THEN '$501-$1000'
			WHEN AnnualSpend < 5001 THEN '$1001-$5000'
			ELSE '> $5000'
	   END AS SpendGroup 
	   ,CASE WHEN AnnualSpend < 41  THEN 1
			WHEN AnnualSpend < 101  THEN 2
			WHEN AnnualSpend < 201  THEN 3
			WHEN AnnualSpend < 501  THEN 4
			WHEN AnnualSpend < 1001 THEN 5
			WHEN AnnualSpend < 5001 THEN 6
			ELSE  7
	   END AS SortOrder
	   ,COUNT(sth.SSB_CRMSYSTEM_CONTACT_ID) AS Count_STH
	   ,COUNT(CASE WHEN sth.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN spend.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS Count_NonSTH
	   ,0 AS IsReady
FROM #spend spend
	LEFT JOIN #STH sth ON sth.SSB_CRMSYSTEM_CONTACT_ID = spend.SSB_CRMSYSTEM_CONTACT_ID
GROUP BY CASE WHEN AnnualSpend < 41 THEN '$1-$40'
			WHEN AnnualSpend < 101 THEN '$41-$100'
			WHEN AnnualSpend < 201 THEN '$101-$200'
			WHEN AnnualSpend < 501 THEN '$201-$500'
			WHEN AnnualSpend < 1001 THEN '$501-$1000'
			WHEN AnnualSpend < 5001 THEN '$1001-$5000'
			ELSE '> $5000'
	   END 
	   ,CASE WHEN AnnualSpend < 41  THEN 1
			WHEN AnnualSpend < 101  THEN 2
			WHEN AnnualSpend < 201  THEN 3
			WHEN AnnualSpend < 501  THEN 4
			WHEN AnnualSpend < 1001 THEN 5
			WHEN AnnualSpend < 5001 THEN 6
			ELSE  7
	   END
ORDER BY SortOrder

DELETE FROM [rpt].[PreCache_Cust_DB_8_tbl] WHERE IsReady = 1
UPDATE [rpt].[PreCache_Cust_DB_8_tbl] SET IsReady = 1

DROP TABLE #STH
DROP TABLE #spend







GO
