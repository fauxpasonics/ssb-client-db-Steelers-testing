SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [rpt].[PreCache_Cust_SNU_2_DEV]
AS


--SELECT * FROM rpt.PreCache_Cust_SNU_2_tbl

DECLARE @SeasonYear INT = CASE WHEN 100*month(getdate())+day(getdate()) > 308 THEN YEAR(GETDATE())
							   ELSE YEAR(GETDATE()) - 1
						  END

 IF OBJECT_ID('tempdb..#snumembers') IS NOT NULL	DROP TABLE #snumembers
 IF OBJECT_ID('tempdb..#TM') IS NOT NULL			DROP TABLE #TM
 IF OBJECT_ID('tempdb..#Merch') IS NOT NULL			DROP TABLE #Merch
 IF OBJECT_ID('tempdb..#fts') IS NOT NULL			DROP TABLE #fts
 
/*========================================================================================
										   SNU
========================================================================================*/

SELECT DISTINCT
        SSB_CRMSYSTEM_CONTACT_ID 
		,CASE WHEN engaged.loyalty_customer_id IS NOT NULL THEN 1 ELSE 0 END AS engaged
        ,dc.EmailPrimary
INTO    #SnuMembers
FROM    dbo.vwDimCustomer_ModAcctId (NOLOCK) dc
        JOIN [ods].[Steelers_500f_Customer] (NOLOCK) c ON dc.SSID = c.loyalty_id
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


--SELECT fts.DimCustomerId
--		,CASE WHEN sth.dimcustomerid IS NOT NULL THEN 'STH' 
--				ELSE 'Single'
--		END CustomerType
--		,SUM(fts.QtySeat) qty
--		,SUM(fts.BlockPurchasePrice) rev
--INTO #fts
--FROM dbo.FactTicketSales fts
--	JOIN dbo.DimSeason dimseason ON dimseason.DimSeasonId = fts.DimSeasonId
--	LEFT JOIN [rpt].[vw_STH_Accounts] sth ON sth.dimcustomerid = fts.dimcustomerid
--WHERE SeasonName LIKE '%heinz%'
--	  AND SeasonName LIKE '%season%'
--	  AND seasonname NOT LIKE '%suite%'
--	  AND seasonname NOT LIKE '%post%'
--	  AND dimseason.SeasonYear = @SeasonYear
--GROUP BY fts.DimCustomerId
--		,CASE WHEN sth.dimcustomerid IS NOT NULL THEN 'STH' 
--				ELSE 'Single'
--		END

SELECT dc.DimCustomerId
		,CASE WHEN sth.DimCustomerId IS NOT NULL THEN 'STH'	ELSE 'Waitlist' END	CustomerType
		,ISNULL(fts.QtySeat,0)				qty
		,ISNULL(fts.BlockPurchasePrice,0)	rev
INTO #fts
FROM dbo.DimCustomer dc
	LEFT JOIN [rpt].[vw_STH_Accounts] sth ON sth.DimCustomerId = dc.DimCustomerId
	LEFT JOIN [ods].[vw_TM_CustMember_Active] waitlist ON waitlist.acct_id = dc.AccountId
														  AND dc.CustomerType = 'Primary'
														  AND waitlist.membership_name = 'WAITING LIST'
	LEFT JOIN (SELECT dimcustomerid
					 ,SUM(fts.QtySeat)				QtySeat			
					 ,SUM(fts.BlockPurchasePrice)	BlockPurchasePrice
			   FROM dbo.FactTicketSales fts
				JOIN dbo.DimSeason dimseason ON dimseason.DimSeasonId = fts.DimSeasonId
				WHERE SeasonName LIKE '%heinz%'
					  AND SeasonName LIKE '%season%'
					  AND seasonname NOT LIKE '%suite%'
					  AND seasonname NOT LIKE '%post%'
					  AND dimseason.SeasonYear = @SeasonYear
			   GROUP BY dimcustomerid
			   )fts ON fts.DimCustomerId = sth.DimCustomerId
WHERE sth.DimCustomerId IS NOT NULL OR waitlist.acct_id IS NOT NULL

/*========================================================================================
										OUTPUT
========================================================================================*/

SELECT 
	 SUM(CASE WHEN SNU_Guid.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN fts.qty END) qtyseats
	,SUM(CASE WHEN SNU_Guid.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN fts.rev END) TotalSpend
	,COUNT(DISTINCT 
		  CASE WHEN fts.customerType = 'Single' 
					AND (ISNULL(SNU_Guid.engaged,0) = 1 OR (ISNULL(SNU_Email.engaged,0) = 1))
			   THEN dc.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS SingleGameEngaged
	,COUNT(DISTINCT 
		  CASE WHEN fts.customerType = 'Single' 
					AND (SNU_Guid.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR SNU_Email.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) 
			   THEN dc.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS SingleGame
	,COUNT(DISTINCT CASE WHEN fts.customerType = 'Single' THEN dc.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS SingleGameTotal
	,COUNT(DISTINCT 
		  CASE WHEN fts.CustomerType = 'Waitlist'
					AND (ISNULL(SNU_Guid.engaged,0) = 1 OR (ISNULL(SNU_Email.engaged,0) = 1))
			   THEN dc.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS WaitListEngaged
	,COUNT(DISTINCT 
		  CASE WHEN fts.CustomerType = 'Waitlist'
					AND (SNU_Guid.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR SNU_Email.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) 
			   THEN dc.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS WaitList
	,COUNT(DISTINCT CASE WHEN fts.CustomerType = 'Waitlist' THEN dc.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS WaitListTotal
	,COUNT(DISTINCT 
		  CASE WHEN fts.customerType = 'STH'
					AND (ISNULL(SNU_Guid.engaged,0) = 1 OR (ISNULL(SNU_Email.engaged,0) = 1))
			   THEN dc.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS STH_Engaged
	,COUNT(DISTINCT 
		  CASE WHEN fts.customerType = 'STH'
					AND (SNU_Guid.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR SNU_Email.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) 
			   THEN dc.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL 
		  END) AS STH_Count
	,COUNT(DISTINCT CASE WHEN fts.customerType = 'STH' THEN dc.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS STH_Total
INTO #TM
FROM dbo.vwDimCustomer_ModAcctId dc
LEFT JOIN #SnuMembers SNU_Guid (NOLOCK) ON SNU_Guid.SSB_CRMSYSTEM_CONTACT_ID = dc.SSB_CRMSYSTEM_CONTACT_ID 
LEFT JOIN #SnuMembers SNU_Email ON SNU_Email.EmailPrimary = dc.EmailPrimary
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
