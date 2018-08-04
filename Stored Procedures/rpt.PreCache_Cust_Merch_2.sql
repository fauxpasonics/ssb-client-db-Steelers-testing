SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [rpt].[PreCache_Cust_Merch_2]
AS


DECLARE @SeasonYear INT = CASE WHEN 100*month(getdate())+day(getdate()) > 308 THEN YEAR(GETDATE())
							   ELSE YEAR(GETDATE()) - 1
						  END

/*====================================================================================================
												MERCH
====================================================================================================*/

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
		, dc.EmailPrimary
		, pos.SaleDate
		, sum(pos.OrderTotal) OrderTotal
		, sum(posd.Quantity) Quantity
		, COUNT(distinct pos.FactPointOfSaleId) as Orders
INTO #Merch
FROM dimcustomerssbid ssbid (NOLOCK)
	JOIN dimcustomer dc (NOLOCK) ON dc.dimcustomerid = ssbid.dimcustomerid
	JOIN dbo.FactPointOfSale pos (NOLOCK) ON pos.CustomerId = dc.SSID
	JOIN ods.merch_Order completed (NOLOCK) ON completed.id = pos.ETL_SSID
												AND completed.orderstatusID = 30
	join (SELECT factpointofsaleID
				, SUM(quantity) Quantity
			FROM FactPointOfSaleDetail posd (NOLOCK) 
			GROUP BY factpointofsaleID
			) posd ON pos.FactPointOfSaleId = posd.FactPointOfSaleId
where pos.DimDateId_SaleDate >= 20150724
		AND dc.sourcesystem = 'Merch'
group by ssbid.SSB_CRMSYSTEM_CONTACT_ID
		, dc.EmailPrimary
		, pos.SaleDate

/*====================================================================================================
												InMarket
====================================================================================================*/


SELECT cr.SSB_CRMSYSTEM_CONTACT_ID
INTO #InMarket 
FROM mdm.compositerecord cr (NOLOCK) 
JOIN adhoc.InMarketZip mkt (NOLOCK)  ON cr.AddressPrimaryZip = mkt.Zip

	
/*====================================================================================================
												  SNU
====================================================================================================*/

SELECT SSB_CRMSYSTEM_CONTACT_ID, MAX(enrolled_at) JoinDate
INTO #SNU
FROM ods.steelers_500f_Customer snu (NOLOCK) 
		JOIN dimcustomerSSBID ssbid (NOLOCK)  ON ssbid.SSID = CAST(snu.loyalty_id AS NVARCHAR(100))
WHERE ssbid.sourcesystem = '500f'
		AND snu.status = 'active'
GROUP BY SSB_CRMSYSTEM_CONTACT_ID


/*====================================================================================================
												TICKETING
====================================================================================================*/


SELECT SSB_CRMSYSTEM_CONTACT_ID
	  ,CASE WHEN x.STH > 0 THEN 'STH'
			WHEN Waitlist > 0 THEN 'Waitlist'
			ELSE 'Single'
	   END CustomerType
INTO #Ticketing
FROM (
		SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
				,SUM(CASE WHEN fts.CustomerType = 'STH' THEN 1 ELSE 0 END) AS STH
				,SUM(CASE WHEN fts.CustomerType = 'Single' THEN 1 ELSE 0 END) AS SG
				,SUM(CASE WHEN dc.CustomerStatus = 'waiting' THEN 1 ELSE 0 END) AS Waitlist
		FROM dimcustomerssbid ssbid (NOLOCK) 
			JOIN dimcustomer dc (NOLOCK)  ON dc.dimcustomerid = ssbid.dimcustomerid
			LEFT JOIN 	(	SELECT fts.DimCustomerId
								  ,CASE WHEN sth.dimcustomerid IS NOT NULL THEN 'STH'
												 ELSE 'Single'
											END CustomerType	
							FROM dbo.FactTicketSales fts
								JOIN dbo.DimSeason dimseason ON dimseason.DimSeasonId = fts.DimSeasonId
								LEFT JOIN [rpt].[vw_STH_Accounts] sth ON sth.dimcustomerid = fts.dimcustomerid
							WHERE SeasonName LIKE '%heinz%'
								  AND SeasonName LIKE '%season%'
								  AND seasonname NOT LIKE '%suite%'
								  AND seasonname NOT LIKE '%post%'
								  AND dimseason.SeasonYear = @SeasonYear
						)fts ON fts.DimCustomerId = ssbid.DimCustomerId
		WHERE dc.sourcesystem = 'TM' 
				AND (fts.dimcustomerid IS NOT NULL OR dc.customerStatus = 'Waiting')
		GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
	)x 

/*====================================================================================================
												 REPEATS
====================================================================================================*/


SELECT ssbid.ssb_CRMSYSTEM_CONTACT_ID
INTO #Repeats
FROM dimcustomerssbid ssbid (NOLOCK)
	JOIN dimcustomer dc (NOLOCK) ON dc.dimcustomerid = ssbid.dimcustomerid
	JOIN dbo.FactPointOfSale pos (NOLOCK) ON pos.CustomerId = dc.SSID
	JOIN ods.merch_Order completed (NOLOCK) ON completed.id = pos.ETL_SSID
												AND completed.orderstatusID = 30
where pos.DimDateId_SaleDate >= 20150724
		AND dc.sourcesystem = 'Merch'
GROUP BY SSB_CRMSYSTEM_CONTACT_ID
HAVING COUNT(*) > 1


/*====================================================================================================
												DIGEST
====================================================================================================*/

SELECT DISTINCT ssb_CRMSYSTEM_CONTACT_ID
INTO #Digest
FROM dimcustomerssbid ssbid (NOLOCK)
WHERE sourcesystem = 'Digest'

/*====================================================================================================
												INDEXES
====================================================================================================*/	

CREATE NONCLUSTERED INDEX IX_SSB_CRMSYSTEM_CONTACT_ID ON  #Merch     (SSB_CRMSYSTEM_CONTACT_ID) 
CREATE NONCLUSTERED INDEX IX_SaleDate ON  #Merch     (SaleDate)
CREATE NONCLUSTERED INDEX IX_SSB_CRMSYSTEM_CONTACT_ID ON  #Ticketing (SSB_CRMSYSTEM_CONTACT_ID) 
CREATE NONCLUSTERED INDEX IX_CustomerType ON  #Ticketing (CustomerType)
CREATE NONCLUSTERED INDEX IX_SSB_CRMSYSTEM_CONTACT_ID ON  #SNU       (SSB_CRMSYSTEM_CONTACT_ID) 
CREATE NONCLUSTERED INDEX IX_JoinDate ON  #SNU       (JoinDate)
CREATE NONCLUSTERED INDEX IX_SSB_CRMSYSTEM_CONTACT_ID ON  #InMarket  (SSB_CRMSYSTEM_CONTACT_ID) 
CREATE NONCLUSTERED INDEX IX_SSB_CRMSYSTEM_CONTACT_ID ON  #Repeats   (SSB_CRMSYSTEM_CONTACT_ID) 
CREATE NONCLUSTERED INDEX IX_SSB_CRMSYSTEM_CONTACT_ID ON  #Digest    (SSB_CRMSYSTEM_CONTACT_ID) 

/*====================================================================================================
												OUTPUT
====================================================================================================*/

INSERT INTO [rpt].[PreCache_Cust_Merch_2_tbl]

SELECT  CASE GROUPING_ID(CONVERT(VARCHAR(7), SaleDate, 120)) WHEN 1 THEN 'Total' ELSE 'Detail' END AS DataType
		, ISNULL(CONVERT(VARCHAR(7), Merch.SaleDate, 120),'TOTAL') SaleMonth
		, FORMAT(ISNULL(SUM(CASE WHEN ISNULL(ticketing.CustomerType,'') = 'STH' THEN Merch.OrderTotal ELSE 0 END),0),'C') AS STH_Rev
		, FORMAT(ISNULL(COUNT(DISTINCT CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'STH' THEN Merch.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END),0),'#,###') AS STH_Cnt
		, FORMAT(ISNULL(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'STH' THEN Quantity ELSE 0 END)/NULLIF(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'STH' THEN 1.0 ELSE 0 END),0),0),'#,###.#') AS STH_Items
		, FORMAT(ISNULL(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'STH' THEN OrderTotal ELSE 0 END)/NULLIF(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'STH' THEN Merch.Orders ELSE 0 END),0),0),'C') AS STH_Avg
		, FORMAT(ISNULL(SUM(CASE WHEN ISNULL(ticketing.CustomerType,'') = 'Waitlist' THEN Merch.OrderTotal ELSE 0 END),0),'C') AS Waitlist_Rev
		, FORMAT(ISNULL(COUNT(DISTINCT CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'Waitlist' THEN Merch.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END),0),'#,###') AS Waitlist_Cnt
		, FORMAT(ISNULL(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'Waitlist' THEN Quantity ELSE 0 END)/NULLIF(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'Waitlist' THEN 1.0 ELSE 0 END),0),0),'#,###.#') AS Waitlist_Items
		, FORMAT(ISNULL(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'Waitlist' THEN OrderTotal ELSE 0 END)/NULLIF(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'Waitlist' THEN Orders ELSE 0 END),0),0),'C') AS Waitlist_Avg	
		, FORMAT(ISNULL(SUM(CASE WHEN ISNULL(ticketing.CustomerType,'') = 'Single' THEN Merch.OrderTotal ELSE 0 END),0),'C') AS SG_Rev
		, FORMAT(ISNULL(COUNT(DISTINCT CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'Single' THEN Merch.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END),0),'#,###') AS SG_Cnt
		, FORMAT(ISNULL(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'Single' THEN Quantity ELSE 0 END)/NULLIF(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'Single' THEN 1.0 ELSE 0 END),0),0),'#,###.#') AS SG_Items
		, FORMAT(ISNULL(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'Single' THEN OrderTotal ELSE 0 END)/NULLIF(SUM(CASE WHEN  ISNULL(ticketing.CustomerType,'') = 'Single' THEN Merch.Orders ELSE 0 END),0),0),'C') AS SG_Avg				
		, FORMAT(ISNULL(SUM(CASE WHEN (SNU.SSB_CRMSYSTEM_CONTACT_ID IS NULL) THEN Merch.OrderTotal ELSE 0 END),0),'C') AS SNU_Rev
		, FORMAT(ISNULL(COUNT(DISTINCT CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN Merch.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END),0),'#,###') AS SNU_Cnt
		, FORMAT(ISNULL(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN Quantity ELSE 0 END)/NULLIF(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN 1.0 ELSE 0 END),0),0),'#,###.#') AS SNU_Items
		, FORMAT(ISNULL(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN OrderTotal ELSE 0 END)/NULLIF(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN Merch.Orders ELSE 0 END),0),0),'C') AS SNU_Avg				
		, FORMAT(ISNULL(SUM(CASE WHEN SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.OrderTotal ELSE 0 END),0),'C') AS IsSnuNon_SNU_Rev
		, FORMAT(ISNULL(COUNT(DISTINCT CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END),0),'#,###') AS Non_SNU_Cnt
		, FORMAT(ISNULL(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Quantity ELSE 0 END)/NULLIF(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1.0 ELSE 0 END),0),0),'#,###.#') AS Non_SNU_Items
		, FORMAT(ISNULL(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN OrderTotal ELSE 0 END)/NULLIF(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.Orders ELSE 0 END),0),0),'C') AS Non_SNU_Avg
		, FORMAT(ISNULL(SUM(CASE WHEN digest.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.OrderTotal ELSE 0 END),0),'C') AS Digest_Rev
		, FORMAT(ISNULL(COUNT(DISTINCT CASE WHEN  digest.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END),0),'#,###') AS Digest_Cnt
		, FORMAT(ISNULL(SUM(CASE WHEN  digest.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Quantity ELSE 0 END)/NULLIF(SUM(CASE WHEN  digest.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1.0 ELSE 0 END),0),0),'#,###.#') AS Digest_Items
		, FORMAT(ISNULL(SUM(CASE WHEN  digest.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN OrderTotal ELSE 0 END)/NULLIF(SUM(CASE WHEN  digest.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.Orders ELSE 0 END),0),0),'C') AS Digest_Avg						
		, FORMAT(ISNULL(SUM(CASE WHEN InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.OrderTotal ELSE 0 END),0),'C') AS In_Market_Rev
		, FORMAT(ISNULL(COUNT(DISTINCT CASE WHEN  InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END),0),'#,###') AS In_Market_Cnt
		, FORMAT(ISNULL(SUM(CASE WHEN  InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Quantity ELSE 0 END)/NULLIF(SUM(CASE WHEN  InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1.0 ELSE 0 END),0),0),'#,###.#') AS In_Market_Items
		, FORMAT(ISNULL(SUM(CASE WHEN  InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN OrderTotal ELSE 0 END)/NULLIF(SUM(CASE WHEN  InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.Orders ELSE 0 END),0),0),'C') AS In_Market_Avg								
		, FORMAT(ISNULL(SUM(CASE WHEN InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN Merch.OrderTotal ELSE 0 END),0),'C') AS Out_of_Market_Rev
		, FORMAT(ISNULL(COUNT(DISTINCT CASE WHEN  InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN Merch.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END),0),'#,###') AS Out_of_Market_Cnt
		, FORMAT(ISNULL(SUM(CASE WHEN  InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN Quantity ELSE 0 END)/NULLIF(SUM(CASE WHEN  InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN 1.0 ELSE 0 END),0),0),'#,###.#') AS Out_of_Market_Items
		, FORMAT(ISNULL(SUM(CASE WHEN  InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN OrderTotal ELSE 0 END)/NULLIF(SUM(CASE WHEN  InMarket.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN Merch.Orders ELSE 0 END),0),0),'C') AS Out_of_Market_Avg										
		, FORMAT(ISNULL(SUM(CASE WHEN Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN Merch.OrderTotal ELSE 0 END),0),'C') AS New_Buyer_Rev
		, FORMAT(ISNULL(COUNT(DISTINCT CASE WHEN  Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN Merch.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END),0),'#,###') AS New_Cnt
		, FORMAT(ISNULL(SUM(CASE WHEN  Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN Quantity ELSE 0 END)/NULLIF(SUM(CASE WHEN  Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN 1.0 ELSE 0 END),0),0),'#,###.#') AS New_Buyer_Items
		, FORMAT(ISNULL(SUM(CASE WHEN  Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN OrderTotal ELSE 0 END)/NULLIF(SUM(CASE WHEN  Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN Merch.Orders ELSE 0 END),0),0),'C') AS New_Buyer_Avg										
		, FORMAT(ISNULL(SUM(CASE WHEN Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.OrderTotal ELSE 0 END),0),'C') AS Repeat_Buyer_Rev
		, FORMAT(ISNULL(COUNT(DISTINCT CASE WHEN  Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END),0),'#,###') AS Repeat_Cnt
		, FORMAT(ISNULL(SUM(CASE WHEN  Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Quantity ELSE 0 END)/NULLIF(SUM(CASE WHEN  Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1.0 ELSE 0 END),0),0),'#,###.#') AS Repeat_Buyer_Items
		, FORMAT(ISNULL(SUM(CASE WHEN  Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN OrderTotal ELSE 0 END)/NULLIF(SUM(CASE WHEN  Repeats.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.Orders ELSE 0 END),0),0),'C') AS Repeat_Buyer_Avg												
		, SUM(Orders) Orders
		, SUM(Merch.OrderTotal) TotalRevenue
		, COUNT(DISTINCT Merch.SSB_CRMSYSTEM_CONTACT_ID) AS UniqueBuyers
		, 0 AS isReady 
FROM #Merch merch
	LEFT JOIN #Ticketing ticketing ON ticketing.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
	LEFT JOIN #SNU SNU ON SNU.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
							 AND snu.joinDate >= merch.SaleDate
	LEFT JOIN #InMarket InMarket ON InMarket.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
	LEFT JOIN #Repeats Repeats ON Repeats.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
	LEFT JOIN #Digest Digest ON Digest.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
GROUP BY GROUPING SETS((),CONVERT(VARCHAR(7), SaleDate, 120))
ORDER BY GROUPING_ID(CONVERT(VARCHAR(7), SaleDate, 120)) DESC, SaleMonth ASC

DELETE FROM [rpt].[PreCache_Cust_Merch_2_tbl] WHERE ISReady = 1

UPDATE [rpt].[PreCache_Cust_Merch_2_tbl]
SET isReady = 1


DROP TABLE #Merch        
DROP TABLE #Ticketing
DROP TABLE #SNU          	
DROP TABLE #InMarket     
DROP TABLE #Repeats      
DROP TABLE #Digest   

    
GO
