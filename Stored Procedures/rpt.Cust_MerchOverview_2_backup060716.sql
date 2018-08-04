SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [rpt].[Cust_MerchOverview_2_backup060716]
AS

SELECT DISTINCT a.SSB_CRMSYSTEM_CONTACT_ID, dc.SSID, dc.EmailPrimary, a.SourceSystem, a.DimCustomerId, dc.CustomerStatus
              INTO #tempcust
              FROM dbo.DimCustomer dc
              JOIN dbo.DimCustomerSSBID a ON a.DimCustomerId = dc.DimCustomerId 


SELECT dc.SSB_CRMSYSTEM_CONTACT_ID, dc.EmailPrimary, pos.SaleDate, sum(pos.OrderTotal) OrderTotal, sum(d.Quantity) Quantity,
		count(distinct pos.FactPointOfSaleId) as Orders
		INTO #MerchSSBIDs
		FROM 
		(SELECT * FROM #tempcust WHERE SourceSystem = 'Merch') dc
		JOIN dbo.FactPointOfSale pos ON dc.SSID = pos.CustomerId 
		join (select FactPointOfSaleId, sum(Quantity) as Quantity from FactPointOfSaleDetail group by FactPointOfSaleId) d on pos.FactPointOfSaleId = d.FactPointOfSaleId
		where pos.DimDateId_SaleDate >= 20150724
		group by dc.SSB_CRMSYSTEM_CONTACT_ID, dc.EmailPrimary, pos.SaleDate
		--ORDER BY a.SSB_CRMSYSTEM_CONTACT_ID
	

		SELECT m.SSB_CRMSYSTEM_CONTACT_ID, m.EmailPrimary, C.AddressPrimaryZip, 1 InMarket
		INTO #InMarket
		FROM mdm.compositerecord C
		JOIN #MerchSSBIDs m ON m.SSB_CRMSYSTEM_CONTACT_ID = C.SSB_CRMSYSTEM_CONTACT_ID
		JOIN adhoc.InMarketZip mkt ON C.AddressPrimaryZip = mkt.Zip

		SELECT DISTINCT a.SSB_CRMSYSTEM_CONTACT_ID, dc.SSID, dc.EmailPrimary, 1 IsSNU
		INTO #LoyaltySSBIDs
		FROM dbo.DimCustomer dc
		JOIN dbo.DimCustomerSSBID a ON a.DimCustomerId = dc.DimCustomerId AND a.SourceSystem = '500f'

		SELECT DISTINCT a.SSB_CRMSYSTEM_CONTACT_ID, dc.SSID, dc.EmailPrimary, 1 IsDigest
		INTO #DigestSSBIDs
		FROM dbo.DimCustomer dc
		JOIN dbo.DimCustomerSSBID a ON a.DimCustomerId = dc.DimCustomerId AND a.SourceSystem = 'Digest'

		SELECT DISTINCT a.SSB_CRMSYSTEM_CONTACT_ID, dc.EmailPrimary, CASE WHEN dp.PlanCode = '15FS' THEN 1 ELSE 0 END as STH
		, CASE WHEN dc.CustomerStatus = 'waiting' THEN 1 ELSE 0 END AS Waitlist
		, CASE WHEN FTS.DimTicketTypeId = 4 THEN 1 ELSE 0 END AS SG
		INTO #Ticketing
		FROM dbo.DimCustomer dc
		LEFT JOIN dbo.DimCustomerSSBID a ON a.DimCustomerId = dc.DimCustomerId AND a.SourceSystem = 'TM'
		LEFT JOIN dbo.FactTicketSales FTS ON FTS.DimCustomerId = dc.DimCustomerId
		LEFT JOIN dbo.DimPlan dp ON dp.DimPlanId = FTS.DimPlanId
		WHERE dc.SourceSystem = 'tm' AND a.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL AND  (CASE WHEN dp.PlanCode = '15FS' THEN 1 ELSE 0 END =1 
		OR CASE WHEN dc.CustomerStatus = 'waiting' THEN 1 ELSE 0 END =1 OR CASE WHEN FTS.DimTicketTypeId = 4 THEN 1 ELSE 0 END = 1)
		GROUP BY  CASE WHEN dp.PlanCode = '15FS' THEN 1  ELSE 0 END ,
                  CASE WHEN dc.CustomerStatus = 'waiting' THEN 1 ELSE 0 END ,
                  CASE WHEN FTS.DimTicketTypeId = 4 THEN 1 ELSE 0 END ,
                  a.SSB_CRMSYSTEM_CONTACT_ID , dc.EmailPrimary
				 ORDER BY a.SSB_CRMSYSTEM_CONTACT_ID

		/*SELECT DISTINCT m.SSB_CRMSYSTEM_CONTACT_ID, COUNT(m.SSB_CRMSYSTEM_CONTACT_ID) cnt
		,CASE WHEN COUNT( m.SSB_CRMSYSTEM_CONTACT_ID) > 1 THEN 1 ELSE 0 END AS Repeat_cnt 
		, CASE WHEN COUNT( m.SSB_CRMSYSTEM_CONTACT_ID) = 1 THEN 1 ELSE 0 END AS New_cnt
		, ISNULL(mkt.InMarket,0) InMarket
		, CASE WHEN l.IsSNU <> 0 AND l2.IsSNU <> 0 THEN 1 ELSE 0 END AS IsSNU
		INTO #Merch_Repeat_New_SSBIDs
		FROM #MerchSSBIDs m
		GROUP BY m.SSB_CRMSYSTEM_CONTACT_ID
		ORDER BY m.SSB_CRMSYSTEM_CONTACT_ID
		DROP TABLE #Merch_Repeat_New_SSBIDs*/

		SELECT DISTINCT m.SSB_CRMSYSTEM_CONTACT_ID, COUNT(m.SSB_CRMSYSTEM_CONTACT_ID) cnt
		,CASE WHEN COUNT( m.SSB_CRMSYSTEM_CONTACT_ID) > 1 THEN 1 ELSE 0 END as Repeat_cnt 
		, CASE WHEN COUNT( m.SSB_CRMSYSTEM_CONTACT_ID) = 1 THEN 1 ELSE 0 END as New_cnt
		, ISNULL(mkt.InMarket,0) InMarket
		, CASE WHEN l.IsSNU <> 0 AND l2.IsSNU <> 0 THEN 1 ELSE 0 END AS IsSNU
		, ISNULL(t.STH,0) STH
		, ISNULL(t.Waitlist,0) Waitlist
		, ISNULL(t.SG,0) SG
		, ISNULL(d.IsDigest,0) Digest
		, SUM(m.OrderTotal) AcctTotalSpend
		INTO #Merch_Repeat_New_SSBIDs
		FROM #MerchSSBIDs m
		LEFT JOIN #InMarket mkt ON mkt.SSB_CRMSYSTEM_CONTACT_ID = m.SSB_CRMSYSTEM_CONTACT_ID
		LEFT JOIN #LoyaltySSBIDs l ON l.SSB_CRMSYSTEM_CONTACT_ID = m.SSB_CRMSYSTEM_CONTACT_ID
		LEFT JOIN #LoyaltySSBIDs l2 ON l2.EmailPrimary = m.EmailPrimary
		LEFT JOIN #Ticketing t ON t.SSB_CRMSYSTEM_CONTACT_ID = m.SSB_CRMSYSTEM_CONTACT_ID
		LEFT JOIN #DigestSSBIDs d ON d.SSB_CRMSYSTEM_CONTACT_ID = m.SSB_CRMSYSTEM_CONTACT_ID
		GROUP BY m.SSB_CRMSYSTEM_CONTACT_ID, mkt.InMarket, ISNULL(t.STH,0), CASE WHEN l.IsSNU <> 0 AND l2.IsSNU <> 0 THEN 1 ELSE 0 END
		, ISNULL(t.Waitlist,0), ISNULL(t.SG,0), ISNULL(d.IsDigest,0)--, SSID
		--HAVING COUNT(SSB_CRMSYSTEM_CONTACT_ID) > 1
		ORDER BY m.SSB_CRMSYSTEM_CONTACT_ID




		/*
		SELECT CONVERT(varchar(7), m.SaleDate, 120) SaleMonth, SUM(OrderTotal) TotalSpend
		FROM #MerchSSBIDs m
		WHERE OrderTotal IS NOT NULL
		GROUP BY CONVERT(varchar(7), m.SaleDate, 120) 
		ORDER BY SaleMonth
		*/
		

		SELECT 
		case grouping_id(CONVERT(varchar(7), SaleDate, 120)) when 1 then 'Total' else 'Detail' END AS DataType
		,ISNULL(CONVERT(VARCHAR(7), m.SaleDate, 120),'Before 2015-07') SaleMonth
		, FORMAT(SUM(CASE WHEN x.STH = 1 THEN m.OrderTotal ELSE 0 END),'C') AS STH_Rev
		, COUNT(DISTINCT CASE WHEN  x.STH = 1 THEN m.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS STH_Cnt
		, FORMAT(SUM(CASE WHEN  x.STH = 1 THEN Quantity ELSE 0 END)/SUM(CASE WHEN  x.STH = 1 THEN 1.0 ELSE 0 END),'#,###.#') AS STH_Items
		, FORMAT(SUM(CASE WHEN  x.STH = 1 THEN OrderTotal ELSE 0 END)/SUM(CASE WHEN  x.STH = 1 THEN Orders ELSE 0 END),'C') AS STH_Avg
		, FORMAT(SUM(CASE WHEN x.Waitlist = 1 THEN m.OrderTotal ELSE 0 END),'C') AS Waitlist_Rev
		, COUNT(DISTINCT CASE WHEN  x.Waitlist = 1 THEN m.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS Waitlist_Cnt
		, FORMAT(SUM(CASE WHEN  x.Waitlist = 1 THEN Quantity ELSE 0 END)/SUM(CASE WHEN  x.Waitlist = 1 THEN 1.0 ELSE 0 END),'#,###.#') AS Waitlist_Items
		, FORMAT(SUM(CASE WHEN  x.Waitlist = 1 THEN OrderTotal ELSE 0 END)/SUM(CASE WHEN  x.Waitlist = 1 THEN Orders ELSE 0 END),'C') AS Waitlist_Avg		
		, FORMAT(SUM(CASE WHEN x.SG = 1 THEN m.OrderTotal ELSE 0 END),'C') AS SG_Rev
		, COUNT(DISTINCT CASE WHEN  x.SG = 1 THEN m.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS SG_Cnt
		, FORMAT(SUM(CASE WHEN  x.SG = 1 THEN Quantity ELSE 0 END)/SUM(CASE WHEN  x.SG = 1 THEN 1.0 ELSE 0 END),'#,###.#') AS SG_Items
		, FORMAT(SUM(CASE WHEN  x.SG = 1 THEN OrderTotal ELSE 0 END)/SUM(CASE WHEN  x.SG = 1 THEN Orders ELSE 0 END),'C') AS SG_Avg				
		, FORMAT(SUM(CASE WHEN (x.IsSNU = 1) THEN m.OrderTotal ELSE 0 END),'C') AS SNU_Rev
		, COUNT(DISTINCT CASE WHEN  x.IsSNU = 1 THEN m.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS SNU_Cnt
		, FORMAT(SUM(CASE WHEN  x.IsSnu = 1 THEN Quantity ELSE 0 END)/SUM(CASE WHEN  x.IsSnu = 1 THEN 1.0 ELSE 0 END),'#,###.#') AS SNU_Items
		, FORMAT(SUM(CASE WHEN  x.IsSnu = 1 THEN OrderTotal ELSE 0 END)/SUM(CASE WHEN  x.IsSnu = 1 THEN Orders ELSE 0 END),'C') AS SNU_Avg				
		, FORMAT(SUM(CASE WHEN x.IsSNU <> 1 THEN m.OrderTotal ELSE 0 END),'C') AS IsSnuNon_SNU_Rev
		, SUM(CASE WHEN  x.IsSNU <> 1 THEN 1 ELSE 0 END) AS Non_SNU_Cnt
		, FORMAT(SUM(CASE WHEN x.DIGEST = 1 THEN m.OrderTotal ELSE 0 END),'C') AS Digest_Rev
		, COUNT(DISTINCT CASE WHEN  x.DIGEST = 1 THEN m.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS Digest_Cnt
		, FORMAT(SUM(CASE WHEN  x.DIGEST = 1 THEN Quantity ELSE 0 END)/SUM(CASE WHEN  x.DIGEST = 1 THEN 1.0 ELSE 0 END),'#,###.#') AS Digest_Items
		, FORMAT(SUM(CASE WHEN  x.DIGEST = 1 THEN OrderTotal ELSE 0 END)/SUM(CASE WHEN  x.DIGEST = 1 THEN Orders ELSE 0 END),'C') AS Digest_Avg						
		, FORMAT(SUM(CASE WHEN x.InMarket = 1 THEN m.OrderTotal ELSE 0 END),'C') AS In_Market_Rev
		, COUNT(DISTINCT CASE WHEN  x.InMarket = 1 THEN m.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS In_Market_Cnt
		, FORMAT(SUM(CASE WHEN  x.InMarket = 1 THEN Quantity ELSE 0 END)/SUM(CASE WHEN  x.InMarket = 1 THEN 1.0 ELSE 0 END),'#,###.#') AS In_Market_Items
		, FORMAT(SUM(CASE WHEN  x.InMarket = 1 THEN OrderTotal ELSE 0 END)/SUM(CASE WHEN  x.InMarket = 1 THEN Orders ELSE 0 END),'C') AS In_Market_Avg								
		, FORMAT(SUM(CASE WHEN x.InMarket <> 1 THEN m.OrderTotal ELSE 0 END),'C') AS Out_of_Market_Rev
		, SUM(CASE WHEN  x.InMarket <> 1 THEN 1 ELSE 0 END) AS Out_of_Market_Cnt
		, FORMAT(SUM(CASE WHEN  x.InMarket <> 1 THEN Quantity ELSE 0 END)/SUM(CASE WHEN  x.InMarket <> 1 THEN 1.0 ELSE 0 END),'#,###.#') AS Out_of_Market_Items
		, FORMAT(SUM(CASE WHEN  x.InMarket <> 1 THEN OrderTotal ELSE 0 END)/SUM(CASE WHEN  x.InMarket <> 1 THEN Orders ELSE 0 END),'C') AS Out_of_Market_Avg										
		, FORMAT(SUM(CASE WHEN x.New_cnt = 1 THEN m.OrderTotal ELSE 0 END),'C') AS New_Buyer_Rev
		, COUNT(DISTINCT CASE WHEN  x.New_cnt = 1 THEN m.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS New_Cnt
		, FORMAT(SUM(CASE WHEN  x.New_cnt = 1 THEN Quantity ELSE 0 END)/SUM(CASE WHEN  x.New_Cnt = 1 THEN 1.0 ELSE 0 END),'#,###.#') AS New_Buyer_Items
		, FORMAT(SUM(CASE WHEN  x.New_cnt = 1 THEN OrderTotal ELSE 0 END)/SUM(CASE WHEN  x.New_cnt = 1 THEN Orders ELSE 0 END),'C') AS New_Buyer_Avg										
		, FORMAT(SUM(CASE WHEN x.Repeat_cnt = 1 THEN m.OrderTotal ELSE 0 END),'C') AS Repeat_Buyer_Rev
		, COUNT(DISTINCT CASE WHEN  x.Repeat_cnt = 1 THEN m.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS Repeat_Cnt
		, FORMAT(SUM(CASE WHEN  x.Repeat_cnt = 1 THEN Quantity ELSE 0 END)/SUM(CASE WHEN  x.Repeat_Cnt = 1 THEN 1.0 ELSE 0 END),'#,###.#') AS Repeat_Buyer_Items
		, FORMAT(SUM(CASE WHEN  x.Repeat_cnt = 1 THEN OrderTotal ELSE 0 END)/SUM(CASE WHEN  x.Repeat_cnt = 1 THEN Orders ELSE 0 END),'C') AS Repeat_Buyer_Avg												
		, SUM(Orders) Orders
		, SUM(m.OrderTotal) TotalRevenue
		FROM #MerchSSBIDs m
		LEFT JOIN #Merch_Repeat_New_SSBIDs x ON x.SSB_CRMSYSTEM_CONTACT_ID = m.SSB_CRMSYSTEM_CONTACT_ID
		--WHERE OrderTotal IS NOT NULL AND x.STH IS NOT NULL AND waitlist IS NOT NULL AND x.SG IS NOT NULL AND CASE WHEN x.IsSNU <> 0 AND x.IsSNU <> 0 THEN 1 ELSE null END IS NOT NULL AND x.Digest IS NOT NULL AND x.InMarket IS NOT NULL
		GROUP BY 
		GROUPING SETS((),CONVERT(varchar(7), SaleDate, 120))
		ORDER BY grouping_id(CONVERT(VARCHAR(7), SaleDate, 120)) DESC, SaleMonth ASC


GO
