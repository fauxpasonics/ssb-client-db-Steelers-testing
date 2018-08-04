SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [rpt].[Cust_SNUOverview_1_BAK]
AS




SELECT COUNT(DISTINCT CASE WHEN status <> 'inactive' THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS LifetimeMembers,
COUNT(DISTINCT CASE WHEN status <> 'inactive' AND CAST(enrolled_at  AS DATE) > '03/09/2016' THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS LifetimeMembersThisSeason,
COUNT(DISTINCT CASE WHEN status <> 'inactive' AND CAST(enrolled_at  AS DATE) > CONVERT(VARCHAR,GETDATE()-30,101) THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS LifetimeMembersPastMonth,
COUNT(DISTINCT CASE WHEN status <> 'inactive' AND CAST(enrolled_at  AS DATE) > CONVERT(VARCHAR,GETDATE()-7,101) THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS LifetimeMembersPastWeek,
COUNT(DISTINCT CASE WHEN status = 'active' THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS ActiveMembers,
COUNT(DISTINCT CASE WHEN status = 'active' AND x.loyalty_customer_id IS NOT NULL THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS EngagedMembers
FROM dimcustomerssbid sb 
JOIN 
[ods].[Steelers_500f_Customer] c ON sb.SSID = CAST(c.loyalty_id AS VARCHAR(200))
LEFT JOIN 
(
SELECT loyalty_customer_id
FROM [ods].[Steelers_500f_Events] e JOIN
[dbo].[500f Activity Types] a ON a.TransactionType = e.type AND a.Detail = e.Detail
WHERE a.class = 'active'
AND e.transaction_date > GETDATE()-365
GROUP BY e.loyalty_customer_id
HAVING COUNT(*) >= 3
) x ON sb.SSID = x.loyalty_customer_id
WHERE sourcesystem = '500f' 

GO
