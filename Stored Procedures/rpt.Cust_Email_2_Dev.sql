SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [rpt].[Cust_Email_2_Dev]
AS


--DROP TABLE #tempcust
--DROP TABLE #EmailableEpsilonProfiles
--DROP TABLE #SnuMembers

SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID, a.SSID, a.DimCustomerId,dc.CustomerStatus, dc.EmailPrimary
INTO #tempcust
FROM dbo.DimCustomerSSBID a (NOLOCK)
JOIN dbo.DimCustomer dc ON dc.DimCustomerId = a.DimCustomerId

--Emailable Temp table
SELECT DISTINCT a.SSB_CRMSYSTEM_CONTACT_ID, x.PK, LEFT(x.CREATED_DTTM,8) CreatedDateId
INTO #EmailableEpsilonProfiles
FROM ods.Epsilon_PDU x
JOIN #tempcust a ON x.PK = a.SSID
	WHERE x.OPTOUT_FLG <> 1 AND x.NUM_FTD = 0
	--DROP TABLE #EmailableEpsilonProfiles


SELECT *----Separate into 2 subqueries
FROM
((
 --Emailable ticketing counts
 SELECT 
 COUNT(DISTINCT CASE WHEN fts.PlanCode = '15FS' AND (e.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR z.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) THEN a.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS STH_Count,
	COUNT(DISTINCT CASE WHEN plancode = '15FS' THEN a.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS STH_Total,
		COUNT(DISTINCT CASE WHEN fts.DimTicketTypeId = 4 AND (e.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR z.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) THEN a.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS SingleGame,
	COUNT(DISTINCT CASE WHEN fts.DimTicketTypeId = 4 THEN a.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS SingleGameTotal,
	COUNT(DISTINCT CASE WHEN a.CustomerStatus = 'waiting' AND (e.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL OR z.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL) THEN a.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS WaitList,
	COUNT(DISTINCT CASE WHEN a.CustomerStatus = 'waiting' THEN a.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS WaitListTotal

FROM  #tempcust a 
--JOIN dbo.DimCustomer dc ON dc.DimCustomerId = a.DimCustomerId
 LEFT JOIN #EmailableEpsilonProfiles z ON z.PK = a.EmailPrimary 
LEFT JOIN #EmailableEpsilonProfiles e ON e.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN rpt.vw_FactTicketSeat fts ON a.DimCustomerId = fts.SoldDimCustomerId

)a
CROSS JOIN
(
SELECT*
FROM 
(--emailable total accounts
SELECT 	
COUNT(DISTINCT CASE WHEN CONVERT(DATE, z.createddateid) > '03/09/2016' THEN z.PK ELSE NULL END) AS EmailableThisSeason,
	COUNT(DISTINCT CASE WHEN CONVERT(DATE, z.createddateid) > CONVERT(VARCHAR,GETDATE()-30,101) THEN z.PK ELSE NULL END) AS EmailablePastMonth,
	COUNT(DISTINCT CASE WHEN CONVERT(DATE, z.createddateid) > CONVERT(VARCHAR,GETDATE()-7,101) THEN z.PK ELSE NULL END) AS EmailablePastWeek
	--, CONVERT(DATE, z.createddateid)
FROM  #EmailableEpsilonProfiles z
	)y
)c
)
CROSS JOIN
(
 --Emailable Merch Buyers --
SELECT SUM(x.Merch_Buyer) AS Merch_Buyer_Count, SUM(TotalPrice) AS Merch_Rev
FROM
	(
	SELECT DISTINCT b.SSB_CRMSYSTEM_CONTACT_ID, COUNT(DISTINCT b.SSB_CRMSYSTEM_CONTACT_ID) Merch_Buyer, SUM(posd.TotalPrice) TotalPrice
	FROM  #tempcust b --dbo.DimCustomerSSBID b 
	JOIN dbo.FactPointOfSale POS ON b.SSID = POS.CustomerId
	JOIN #EmailableEpsilonProfiles z ON z.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID
	JOIN dbo.FactPointOfSaleDetail posd ON posd.FactPointOfSaleId = POS.FactPointOfSaleId
	LEFT JOIN dbo.DimPOSProduct pro ON pro.DimProductID = posd.DimProductId
	--WHERE z.OPTOUT_FLG <> 1
	GROUP BY b.SSB_CRMSYSTEM_CONTACT_ID
	 )x
)b




/*
count(distinct case when status <> 'inactive' and cast(enrolled_at  as date) > '03/09/2016' then SSB_CRMSYSTEM_CONTACT_ID else null end) as LifetimeMembersThisSeason,
count(distinct case when status <> 'inactive' and cast(enrolled_at  as date) > convert(varchar,getdate()-30,101) then SSB_CRMSYSTEM_CONTACT_ID else null end) as LifetimeMembersPastMonth,
count(distinct case when status <> 'inactive' and cast(enrolled_at  as date) > convert(varchar,getdate()-7,101) then SSB_CRMSYSTEM_CONTACT_ID else null end) as LifetimeMembersPastWeek,

*/


GO
