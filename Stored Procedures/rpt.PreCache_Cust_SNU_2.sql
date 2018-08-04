SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROC [rpt].[PreCache_Cust_SNU_2]
AS

DECLARE @SeasonYear INT = CASE WHEN 100*month(getdate())+day(getdate()) > 308 THEN YEAR(GETDATE())
							   ELSE YEAR(GETDATE()) - 1
						  END

 IF OBJECT_ID('tempdb..#snumembers') IS NOT NULL DROP TABLE #snumembers
 IF OBJECT_ID('tempdb..#TM') IS NOT NULL DROP TABLE #TM
 IF OBJECT_ID('tempdb..#Merch') IS NOT NULL DROP TABLE #Merch
 IF OBJECT_ID('tempdb..#fts') IS NOT NULL DROP TABLE #fts
 
/*========================================================================================
										   SNU
========================================================================================*/

SELECT DISTINCT
        SSB_CRMSYSTEM_CONTACT_ID 
		,CASE WHEN engaged.loyalty_customer_id IS NOT NULL THEN 1 ELSE 0 END AS engaged
        ,email
INTO    #SnuMembers
FROM    DimCustomerSSBID (NOLOCK) ssbid
        JOIN [ods].[Steelers_500f_Customer] (NOLOCK) c ON ssbid.SSID = c.loyalty_id
		LEFT JOIN ( SELECT DISTINCT loyalty_customer_id
					FROM [ods].[Steelers_500f_Events] e 
					WHERE  DATEDIFF(DAY,e.transaction_date,GETDATE()) < 60
						   AND e.transaction_date >= '20160808' 
						   AND e.points > 0 
						   AND e.type NOT IN ('profile_bonus'
											  ,'facebook_boost'
											  ,'twitter_boost'
											  ,'instagram_boost'
											  ,'season_ticket_holder')
					GROUP BY e.loyalty_customer_id
					) engaged ON c.loyalty_id = engaged.loyalty_customer_id
WHERE   SourceSystem = '500f'
        AND status = 'active'

/*========================================================================================
										TICKETING
========================================================================================*/


SELECT fts.DimCustomerId
		,CASE WHEN sth.dimcustomerid IS NOT NULL THEN 'STH' 
				ELSE 'Single'
		END CustomerType
		,SUM(fts.QtySeat) qty
		,SUM(fts.BlockPurchasePrice) rev
INTO #fts
FROM dbo.FactTicketSales fts
	JOIN dbo.DimSeason dimseason ON dimseason.DimSeasonId = fts.DimSeasonId
	LEFT JOIN [rpt].[vw_STH_Accounts] sth ON sth.dimcustomerid = fts.dimcustomerid
WHERE SeasonName LIKE '%heinz%'
	  AND SeasonName LIKE '%season%'
	  AND seasonname NOT LIKE '%suite%'
	  AND seasonname NOT LIKE '%post%'
	  AND dimseason.SeasonYear = @SeasonYear
GROUP BY fts.DimCustomerId
		,CASE WHEN sth.dimcustomerid IS NOT NULL THEN 'STH' 
				ELSE 'Single'
		END


/*========================================================================================
										OUTPUT
========================================================================================*/



SELECT 
	 SUM(CASE WHEN sm.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN fts.qty END) qtyseats
	,SUM(CASE WHEN sm.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN fts.rev END) TotalSpend
	,COUNT(DISTINCT 
		  CASE WHEN fts.customerType = 'Single' 
					AND (ISNULL(sm.engaged,0) = 1 OR (ISNULL(sm2.engaged,0) = 1))
			   THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS SingleGameEngaged
	,COUNT(DISTINCT 
		  CASE WHEN fts.customerType = 'Single' 
					AND (sm.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR sm2.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) 
			   THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS SingleGame
	,COUNT(DISTINCT CASE WHEN fts.customerType = 'Single' THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS SingleGameTotal
	,COUNT(DISTINCT 
		  CASE WHEN dc.CustomerStatus = 'waiting'
					AND (ISNULL(sm.engaged,0) = 1 OR (ISNULL(sm2.engaged,0) = 1))
			   THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS WaitListEngaged
	,COUNT(DISTINCT 
		  CASE WHEN dc.CustomerStatus = 'waiting'
					AND (sm.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR sm2.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) 
			   THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS WaitList
	,COUNT(DISTINCT CASE WHEN dc.CustomerStatus = 'waiting' THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS WaitListTotal
	,COUNT(DISTINCT 
		  CASE WHEN fts.customerType = 'STH'
					AND (ISNULL(sm.engaged,0) = 1 OR (ISNULL(sm2.engaged,0) = 1))
			   THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS STH_Engaged
	,COUNT(DISTINCT 
		  CASE WHEN fts.customerType = 'STH'
					AND (sm.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR sm2.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) 
			   THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS STH_Count
	,COUNT(DISTINCT CASE WHEN fts.customerType = 'STH' THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS STH_Total
INTO #TM
FROM dbo.DimCustomer (NOLOCK) dc
JOIN dbo.DimCustomerSSBID (NOLOCK) ssbid ON ssbid.DimCustomerId = dc.DimCustomerId
LEFT JOIN #SnuMembers sm (NOLOCK) ON sm.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID 
LEFT JOIN #SnuMembers sm2 ON sm2.email = dc.EmailPrimary
LEFT JOIN #fts (NOLOCK) fts ON fts.DimCustomerId = dc.DimCustomerId



SELECT 0 AS qtymerch, 0 AS merchrev
INTO #Merch

INSERT INTO [rpt].[PreCache_Cust_SNU_2_tbl]

SELECT 
FORMAT(qtyseats,'#,###') AS qtyseats,
FORMAT(TotalSpend,'C') AS TotalSpend,
FORMAT(STH_Engaged,'#,###') AS STH_Engaged,
FORMAT(STH_Count,'#,###') AS STH_Count,
FORMAT(STH_Total,'#,###') AS STH_Total,
FORMAT(qtymerch,'#,###') AS qtymerch,
FORMAT(SingleGameEngaged,'#,###') AS SingleGameEngaged,
FORMAT(SingleGame,'#,###') AS SingleGame,
FORMAT(SingleGameTotal,'#,###') AS SingleGameTotal,
FORMAT(WaitListEngaged,'#,###') AS WaitListEngaged,
FORMAT(WaitList,'#,###') AS WaitList, 
FORMAT(WaitListTotal,'#,###') AS WaitListTotal,
FORMAT(merchrev,'C') AS merchrev,
0 AS IsReady
FROM #TM CROSS JOIN #Merch

DELETE FROM [rpt].[PreCache_Cust_SNU_2_tbl] WHERE IsReady = 1
UPDATE [rpt].[PreCache_Cust_SNU_2_tbl] SET IsReady = 1
 


 DROP TABLE #snumembers
 DROP TABLE #TM
 DROP TABLE #Merch
 DROP TABLE #fts
 
 



GO
