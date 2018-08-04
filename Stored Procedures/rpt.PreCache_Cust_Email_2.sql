SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [rpt].[PreCache_Cust_Email_2]
AS


IF OBJECT_ID('tempdb..#fts')IS NOT NULL		  DROP TABLE #fts
IF OBJECT_ID('tempdb..#email')IS NOT NULL	  DROP TABLE #email

DECLARE @SeasonYear INT = CASE WHEN 100*month(getdate())+day(getdate()) > 308 THEN YEAR(GETDATE())
							   ELSE YEAR(GETDATE()) - 1
						  END
DECLARE @SeasonStart DATE = cast(concat(@SeasonYear,'0309') as date)


/*========================================================================================
										Ticketing
========================================================================================*/

SELECT fts.DimCustomerId
	  ,CASE WHEN sth.dimcustomerid IS NOT NULL THEN 'STH'
					 ELSE 'Single'
				END CustomerType	
INTO #fts
FROM dbo.FactTicketSales fts (NOLOCK)
	JOIN dbo.DimSeason dimseason (NOLOCK) ON dimseason.DimSeasonId = fts.DimSeasonId
	LEFT JOIN [rpt].[vw_STH_Accounts] sth (NOLOCK) ON sth.dimcustomerid = fts.dimcustomerid
WHERE SeasonName LIKE '%heinz%'
	  AND SeasonName LIKE '%season%'
	  AND seasonname NOT LIKE '%suite%'
	  AND seasonname NOT LIKE '%post%'
	  AND dimseason.SeasonYear = @SeasonYear


/*========================================================================================
										  Email
========================================================================================*/

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	   ,CASE WHEN engaged.PROFILE_KEY IS NOT NULL THEN 1 ELSE 0 END AS engaged
       ,MAX(pdu.JOIN_DATE) AS CreateDate 
INTO #email
FROM dimcustomerssbid (NOLOCK) ssbid
	JOIN [rpt].[vw__Epsilon_PDU_Harmony] (NOLOCK) pdu ON pdu.PROFILE_KEY = ssbid.SSID
	JOIN [rpt].[vw__Epsilon_Emailable_Harmony] (NOLOCK) emailable ON emailable.PROFILE_KEY = ssbid.SSID
	LEFT JOIN [rpt].[vw__Epsilon_Engaged_Harmony] (NOLOCK) engaged ON engaged.PROFILE_KEY = ssbid.SSID
WHERE ssbid.SourceSystem = 'epsilon'
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
		 ,CASE WHEN engaged.PROFILE_KEY IS NOT NULL THEN 1 ELSE 0 END

/*========================================================================================
										Output
========================================================================================*/

INSERT INTO rpt.PreCache_Cust_Email_2_tbl

SELECT COUNT( DISTINCT CASE WHEN fts.CustomerType = 'STH' AND email.engaged = 1 THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END)STH_Engaged
       ,COUNT(DISTINCT CASE WHEN fts.CustomerType = 'STH' AND email.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END)STH_Count
	   ,COUNT(DISTINCT CASE WHEN fts.CustomerType = 'STH' THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END) STH_Total
	   ,COUNT(DISTINCT CASE WHEN fts.CustomerType = 'Single' AND email.engaged = 1 THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END)SingleGame_Engaged
	   ,COUNT(DISTINCT CASE WHEN fts.CustomerType = 'Single' AND email.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END)SingleGame
	   ,COUNT(DISTINCT CASE WHEN fts.CustomerType = 'Single' THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END)SingleGameTotal
	   ,COUNT(DISTINCT CASE WHEN dc.customerstatus = 'waiting' AND email.engaged = 1 THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END)WaitList_Engaged
	   ,COUNT(DISTINCT CASE WHEN dc.customerstatus = 'waiting' AND email.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END)WaitList
	   ,COUNT(DISTINCT CASE WHEN dc.customerstatus = 'waiting' THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END)WaitListTotal
	   ,COUNT(DISTINCT CASE WHEN email.CreateDate >= @SeasonStart THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END) EmailableThisSeason
	   ,COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH,CreateDate,GETDATE()) = 0 THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END) EmailablePastMonth
	   ,COUNT(DISTINCT CASE WHEN DATEDIFF(WEEK,CreateDate,GETDATE()) = 0 THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END) EmailablePastWeek
	   ,COUNT(DISTINCT CASE WHEN merch.customerID IS NOT NULL AND email.engaged = 1 THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END) Merch_Buyer_Engaged
	   ,COUNT(DISTINCT CASE WHEN merch.customerID IS NOT NULL AND email.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END) Merch_Buyer_Count
	   ,COUNT(DISTINCT CASE WHEN merch.customerID IS NOT NULL THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END) Merch_Buyer_Total
	   ,COUNT(DISTINCT CASE WHEN SNU.loyalty_id IS NOT NULL AND email.engaged = 1 THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END) SNU_Engaged
	   ,COUNT(DISTINCT CASE WHEN SNU.loyalty_id IS NOT NULL AND email.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END) SNU_Count
	   ,COUNT(DISTINCT CASE WHEN SNU.loyalty_id IS NOT NULL THEN ssbid.SSB_CRMSYSTEM_CONTACT_ID END) SNU_Total
	   ,0 AS Isready
FROM dimcustomer (NOLOCK) dc
	JOIN dimcustomerssbid (NOLOCK) ssbid ON ssbid.DimCustomerId = dc.DimCustomerId
	LEFT JOIN #fts fts ON fts.DimCustomerId = ssbid.DimCustomerId
						  AND ssbid.SourceSystem = 'TM'
	LEFT JOIN #email email ON email.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID
	LEFT JOIN ( SELECT pos.CustomerId
				FROM dbo.FactPointOfSale (NOLOCK) pos
					JOIN ods.Merch_Order (NOLOCK) completed ON completed.Id = pos.ETL_SSID
					JOIN dbo.FactPointOfSaleDetail (NOLOCK) posd ON pos.FactPointOfSaleId = posd.FactPointOfSaleId
                WHERE completed.OrderStatusId = 30
					  AND pos.DimDateId_SaleDate >= 20150724
			   )merch ON merch.customerID = ssbid.SSID
						 AND ssbid.SourceSystem = 'merch'										   
	LEFT JOIN [ods].[Steelers_500f_Customer] (NOLOCK) snu ON CAST(snu.loyalty_id AS NVARCHAR(30)) = ssbid.SSID
													AND ssbid.SourceSystem = '500f'
													AND snu.status = 'active'

DELETE rpt.PreCache_Cust_Email_2_tbl WHERE IsReady = 1
UPDATE rpt.PreCache_Cust_Email_2_tbl SET IsReady = 1

DROP TABLE #fts
DROP TABLE #email	












GO
