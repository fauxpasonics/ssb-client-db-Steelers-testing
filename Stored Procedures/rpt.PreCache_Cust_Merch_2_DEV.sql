SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [rpt].[PreCache_Cust_Merch_2_DEV]
AS

DECLARE @SeasonYear INT = CASE WHEN 100*month(getdate())+day(getdate()) > 308 THEN YEAR(GETDATE())
							   ELSE YEAR(GETDATE()) - 1
						  END;

WITH CTE_Merch
AS (
		SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
			 , dc.EmailPrimary
			 , pos.SaleDate
			 , sum(pos.OrderTotal) OrderTotal
			 , sum(posd.Quantity) Quantity
			 , COUNT(distinct pos.FactPointOfSaleId) as Orders
		FROM dimcustomerssbid ssbid (NOLOCK)
			JOIN dimcustomer dc ON dc.dimcustomerid = ssbid.dimcustomerid
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
	 )

,CTE_InMarket 
 AS ( SELECT cr.SSB_CRMSYSTEM_CONTACT_ID
	  FROM mdm.compositerecord cr (NOLOCK) 
	  JOIN adhoc.InMarketZip mkt (NOLOCK)  ON cr.AddressPrimaryZip = mkt.Zip
	)

,CTE_SNU
AS (SELECT SSB_CRMSYSTEM_CONTACT_ID, MAX(enrolled_at) JoinDate
	FROM ods.steelers_500f_Customer snu (NOLOCK) 
		 JOIN dimcustomerSSBID ssbid (NOLOCK)  ON ssbid.SSID = snu.loyalty_id
	WHERE ssbid.sourcesystem = '500f'
		  AND snu.status = 'active'
	GROUP BY SSB_CRMSYSTEM_CONTACT_ID
	)

--,CTE_Ticketing
--AS (SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
--		  ,SUM(CASE WHEN fts.CustomerType = 'STH' THEN 1 ELSE 0 END) AS STH
--		  ,SUM(CASE WHEN fts.CustomerType = 'Single' THEN 1 ELSE 0 END) AS SG
--		  ,SUM(CASE WHEN dc.CustomerStatus = 'waiting' THEN 1 ELSE 0 END) AS Waitlist
--	FROM dimcustomerssbid ssbid (NOLOCK) 
--		JOIN dimcustomer dc (NOLOCK)  ON dc.dimcustomerid = ssbid.dimcustomerid
--		LEFT JOIN 	(   SELECT dc.dimcustomerid
--							  ,CASE WHEN sth.dimcustomerid IS NOT NULL THEN 'STH'
--						  			ELSE 'Single'
--							   END CustomerType
--						FROM dimcustomer dc (NOLOCK)  
--							LEFT JOIN (SELECT DISTINCT dimcustomerid 
--										from factticketsales fts (NOLOCK) 
--			   							join dimseason ds (NOLOCK)  on ds.dimseasonid= fts.dimseasonid
--										where dimtickettypeid = 4 AND seasonyear = @seasonYear
--										)single on single.dimcustomerid = dc.dimcustomerid 
--							LEFT JOIN (select dimcustomerid
--										FROM dimcustomer dc (NOLOCK) 
--										JOIN [rpt].[STH_Accounts_2017] sth (NOLOCK) on sth.acct_id = dc.accountid
--										WHERE customertype = 'Primary'
--												AND dc.sourcesystem = 'TM'
--										) sth on sth.dimcustomerid = dc.dimcustomerid 
--						WHERE single.dimcustomerid is not null or sth.dimcustomerid is not null
--					)fts ON fts.DimCustomerId = ssbid.DimCustomerId
--	WHERE dc.sourcesystem = 'TM' 
--		  AND (fts.dimcustomerid IS NOT NULL OR dc.customerStatus = 'Waiting')
--	GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
--	)

,CTE_Ticketing
AS (SELECT SSB_CRMSYSTEM_CONTACT_ID
		  ,CASE WHEN STH = 1 THEN 'STH'
				WHEN Waitlist = 1 THEN 'Waiting'
				ELSE 'Single'
		   END AS CustomerType
	FROM (  SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
				  ,SUM(CASE WHEN fts.CustomerType = 'STH' THEN 1 ELSE 0 END) AS STH
				  ,SUM(CASE WHEN fts.CustomerType = 'Single' THEN 1 ELSE 0 END) AS SG
				  ,SUM(CASE WHEN dc.CustomerStatus = 'waiting' THEN 1 ELSE 0 END) AS Waitlist
			FROM dimcustomerssbid ssbid (NOLOCK) 
				JOIN dimcustomer dc (NOLOCK)  ON dc.dimcustomerid = ssbid.dimcustomerid
				LEFT JOIN 	(   SELECT dc.dimcustomerid
									  ,CASE WHEN sth.dimcustomerid IS NOT NULL THEN 'STH'
						  					ELSE 'Single'
									   END CustomerType
								FROM dimcustomer dc (NOLOCK)  
									LEFT JOIN (SELECT DISTINCT dimcustomerid 
												from factticketsales fts (NOLOCK) 
			   									join dimseason ds (NOLOCK)  on ds.dimseasonid= fts.dimseasonid
												where dimtickettypeid = 4 AND seasonyear = @seasonYear
												)single on single.dimcustomerid = dc.dimcustomerid 
									LEFT JOIN (select dimcustomerid
												FROM dimcustomer dc (NOLOCK) 
												JOIN [rpt].[STH_Accounts_2017] sth (NOLOCK) on sth.acct_id = dc.accountid
												WHERE customertype = 'Primary'
														AND dc.sourcesystem = 'TM'
												) sth on sth.dimcustomerid = dc.dimcustomerid 
								WHERE single.dimcustomerid is not null or sth.dimcustomerid is not null
							)fts ON fts.DimCustomerId = ssbid.DimCustomerId
			WHERE dc.sourcesystem = 'TM' 
				  AND (fts.dimcustomerid IS NOT NULL OR dc.customerStatus = 'Waiting')
			GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
		  )x
	)

,CTE_Repeats
AS (SELECT ssbid.ssb_CRMSYSTEM_CONTACT_ID
	FROM dimcustomerssbid ssbid (NOLOCK)
		JOIN dimcustomer dc (NOLOCK) ON dc.dimcustomerid = ssbid.dimcustomerid
		JOIN dbo.FactPointOfSale pos (NOLOCK) ON pos.CustomerId = dc.SSID
		JOIN ods.merch_Order completed (NOLOCK) ON completed.id = pos.ETL_SSID
													AND completed.orderstatusID = 30
	where pos.DimDateId_SaleDate >= 20150724
			AND dc.sourcesystem = 'Merch'
	GROUP BY SSB_CRMSYSTEM_CONTACT_ID
	HAVING COUNT(*) > 1
	)
,CTE_Digest
AS (SELECT DISTINCT ssb_CRMSYSTEM_CONTACT_ID
	FROM dimcustomerssbid ssbid (NOLOCK)
	WHERE sourcesystem = 'Digest'
	)

--INSERT INTO [rpt].[PreCache_Cust_Merch_2_tbl]

SELECT  case grouping_id(CONVERT(varchar(7), SaleDate, 120)) when 1 then 'Total' else 'Detail' END AS DataType
		,ISNULL(CONVERT(VARCHAR(7), Merch.SaleDate, 120),'TOTAL') SaleMonth
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
		, FORMAT(ISNULL(SUM(CASE WHEN (SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) THEN Merch.OrderTotal ELSE 0 END),0),'C') AS SNU_Rev
		, FORMAT(ISNULL(COUNT(DISTINCT CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END),0),'#,###') AS SNU_Cnt
		, FORMAT(ISNULL(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Quantity ELSE 0 END)/NULLIF(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN 1.0 ELSE 0 END),0),0),'#,###.#') AS SNU_Items
		, FORMAT(ISNULL(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN OrderTotal ELSE 0 END)/NULLIF(SUM(CASE WHEN  SNU.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN Merch.Orders ELSE 0 END),0),0),'C') AS SNU_Avg				
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
		,COUNT(DISTINCT Merch.SSB_CRMSYSTEM_CONTACT_ID) AS UniqueBuyers
		,0 AS isReady 
FROM CTE_Merch merch
	LEFT JOIN CTE_Ticketing ticketing ON ticketing.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
	LEFT JOIN CTE_SNU SNU ON SNU.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
	LEFT JOIN CTE_InMarket InMarket ON InMarket.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
	LEFT JOIN CTE_Repeats Repeats ON Repeats.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
	LEFT JOIN CTE_Digest Digest ON Digest.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
GROUP BY GROUPING SETS((),CONVERT(varchar(7), SaleDate, 120))
ORDER BY grouping_id(CONVERT(VARCHAR(7), SaleDate, 120)) DESC, SaleMonth ASC

--DELETE FROM [rpt].[PreCache_Cust_Merch_2_tbl] WHERE ISReady = 1

--UPDATE [rpt].[PreCache_Cust_Merch_2_tbl]
--SET isReady = 1
GO
