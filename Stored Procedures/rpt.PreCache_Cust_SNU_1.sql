SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE PROC [rpt].[PreCache_Cust_SNU_1]
AS

DECLARE @SeasonYear INT = CASE WHEN 100*MONTH(GETDATE())+DAY(GETDATE()) > 308 THEN YEAR(GETDATE())
							   ELSE YEAR(GETDATE()) - 1
						  END
DECLARE @SeasonStart DATE = CAST(CONCAT(@SeasonYear,'0309') AS DATE)


INSERT INTO [rpt].[PreCache_Cust_SNU_1_tbl]
(
    [LifetimeMembers],
    [LifetimeMembersThisSeason],
    [LifetimeMembersPastMonth],
    [LifetimeMembersPastWeek],
    [ActiveMembers],
    [EngagedMembers],
	[SeasonYear],
    [IsReady]
)


SELECT COUNT(DISTINCT CASE WHEN status <> 'inactive' THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS LifetimeMembers, -- active plus paused
	   COUNT(DISTINCT CASE WHEN status = 'active' AND CAST(enrolled_at  AS DATE) >= @SeasonStart THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS LifetimeMembersThisSeason,
	   COUNT(DISTINCT CASE WHEN status = 'active' AND CAST(enrolled_at  AS DATE) BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND GETDATE() THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS LifetimeMembersPastMonth,
	   COUNT(DISTINCT CASE WHEN status = 'active' AND DATEDIFF(WEEK,c.enrolled_at,GETDATE())=0 THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS LifetimeMembersPastWeek,
	   COUNT(DISTINCT CASE WHEN status = 'active' THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS ActiveMembers, --just active
	   COUNT(DISTINCT CASE WHEN status = 'active' AND engaged.loyalty_customer_id IS NOT NULL THEN SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS EngagedMembers,
	   @SeasonYear AS Seasonyear
	   ,0 AS IsReady
FROM dimcustomerssbid (NOLOCK) sb 
JOIN [ods].[Steelers_500f_Customer] (NOLOCK) c ON sb.SSID = CAST(c.loyalty_id AS VARCHAR(200))
LEFT JOIN ( SELECT loyalty_customer_id
			FROM [ods].[Steelers_500f_Events] (NOLOCK) e 
			WHERE  DATEDIFF(DAY,e.transaction_date,GETDATE()) < 61
				   AND e.transaction_date >= '20160808' 
				   AND e.points > 0 
				   AND e.type NOT IN ('profile_bonus'
									  ,'facebook_boost'
									  ,'twitter_boost'
									  ,'instagram_boost'
									  ,'season_ticket_holder')
			GROUP BY e.loyalty_customer_id
			) engaged ON sb.SSID = engaged.loyalty_customer_id
WHERE sourcesystem = '500f' 

DELETE FROM [rpt].[PreCache_Cust_SNU_1_tbl] 
WHERE isReady = 1

UPDATE [rpt].[PreCache_Cust_SNU_1_tbl]
SET IsReady = 1










GO
