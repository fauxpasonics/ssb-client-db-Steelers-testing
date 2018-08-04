SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [rpt].[PreCache_Cust_SNU_2_bkp]
AS


/*========================================================================================
										   SNU
========================================================================================*/

SELECT DISTINCT
        SSB_CRMSYSTEM_CONTACT_ID ,
        email
INTO    #SnuMembers
FROM    DimCustomerSSBID (NOLOCK) sb
        JOIN [ods].[Steelers_500f_Customer] (NOLOCK) c ON sb.SSID = c.loyalty_id
WHERE   SourceSystem = '500f'
        AND status = 'active'

/*========================================================================================
										TICKETING
========================================================================================*/


SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	   ,CASE WHEN fts.DimTicketTypeId = 4 THEN 1 ELSE 0 END AS Single
	   ,CASE WHEN dp.PlanCode = '16FS' THEN 1 ELSE 0 END AS STH
	   ,fts.QtySeat qty
	   ,fts.BlockPurchasePrice rev
INTO #fts
FROM dbo.FactTicketSales fts
	JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.DimSeasonId
	JOIN dbo.DimPlan dp ON dp.DimPlanId = fts.DimPlanId
	JOIN dbo.DimCustomerSSBID ssbid ON ssbid.DimCustomerId = fts.DimCustomerId
WHERE ds.SeasonYear = 2016
	  AND ( fts.DimTicketTypeId = 4
	    	OR dp.PlanCode = '16FS')

/*========================================================================================
										OUTPUT
========================================================================================*/



SELECT 
	SUM(CASE WHEN sm.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN fts.qty END) qtyseats,
	SUM(CASE WHEN sm.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN fts.rev END) TotalSpend, 
	COUNT(DISTINCT CASE WHEN fts.single = 1 AND (sm.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR sm2.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) THEN b.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS SingleGame,
	COUNT(DISTINCT CASE WHEN fts.single = 1 THEN b.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS SingleGameTotal,
	COUNT(DISTINCT CASE WHEN a.CustomerStatus = 'waiting' AND (sm.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR sm2.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) THEN b.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS WaitList,
	COUNT(DISTINCT CASE WHEN a.CustomerStatus = 'waiting' THEN b.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS WaitListTotal,
	COUNT(DISTINCT CASE WHEN fts.sth = 1 AND (sm.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR sm2.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) THEN b.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS STH_Count,
	COUNT(DISTINCT CASE WHEN fts.sth = 1 THEN b.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS STH_Total
INTO #TM
FROM dbo.DimCustomer (NOLOCK) a
JOIN dbo.DimCustomerSSBID (NOLOCK) b ON b.DimCustomerId = a.DimCustomerId
LEFT JOIN #SnuMembers sm (NOLOCK) ON sm.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID 
LEFT JOIN #SnuMembers sm2 ON sm2.email = a.EmailPrimary
LEFT JOIN #fts (NOLOCK) fts ON fts.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID



SELECT 0 AS qtymerch, 0 AS merchrev
INTO #Merch

INSERT INTO [rpt].[PreCache_Cust_SNU_2_tbl]

SELECT 
FORMAT(qtyseats,'#,###') AS qtyseats,
FORMAT(TotalSpend,'C') AS TotalSpend,
FORMAT(STH_Count,'#,###') AS STH_Count,
FORMAT(STH_Total,'#,###') AS STH_Total,
FORMAT(qtymerch,'#,###') AS qtymerch,
FORMAT(SingleGame,'#,###') AS SingleGame,
FORMAT(SingleGameTotal,'#,###') AS SingleGameTotal,
FORMAT(WaitList,'#,###') AS WaitList, 
FORMAT(WaitListTotal,'#,###') AS WaitListTotal,
FORMAT(merchrev,'C') AS merchrev,
0 AS IsReady
 FROM #TM CROSS JOIN #Merch

 DELETE FROM [rpt].[PreCache_Cust_SNU_2_tbl]
 WHERE IsReady = 1

 UPDATE [rpt].[PreCache_Cust_SNU_2_tbl]
 SET IsReady = 1
 


 DROP TABLE #snumembers
 DROP TABLE #TM
 DROP TABLE #Merch
 
 

GO
