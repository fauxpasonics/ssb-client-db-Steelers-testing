SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROC [rpt].[PreCache_Cust_SNU_3]
AS

INSERT INTO    [rpt].[PreCache_Cust_SNU_3_tbl]

SELECT  SUM(ActiveMembers) AS EngagedMembers ,
        SUM(Members - ActiveMembers) AS NonEngagedMembers ,
        CASE WHEN age < 18 THEN 'Under 18'
             WHEN age BETWEEN 18 AND 29 THEN 'Between 18 and 29'
             WHEN age BETWEEN 30 AND 39 THEN 'Between 30 and 39'
             WHEN age BETWEEN 40 AND 49 THEN 'Between 40 and 49'
             WHEN age BETWEEN 50 AND 59 THEN 'Between 50 and 59'
             WHEN age BETWEEN 60 AND 69 THEN 'Between 60 and 69'
             WHEN age BETWEEN 70 AND 115 THEN 'Over 70'
             ELSE 'Unknown'
        END AS AgeBracket ,
        0 AS IsReady
FROM    ( SELECT    DATEDIFF(YEAR, NULLIF(cr.Birthday,'1900-01-01'), GETDATE()) age ,
                    COUNT(DISTINCT CASE WHEN engaged.loyalty_customer_id IS NOT NULL
                                        THEN cr.SSB_CRMSYSTEM_CONTACT_ID
                                        ELSE NULL
                                   END) AS ActiveMembers ,
                    COUNT(DISTINCT cr.SSB_CRMSYSTEM_CONTACT_ID) AS Members
			FROM    [ods].[Steelers_500f_Customer] c
					JOIN  dimcustomerssbid sb ON sb.SSID = CAST(c.loyalty_id AS VARCHAR(200))
					JOIN mdm.compositerecord cr ON cr.SSB_CRMSYSTEM_CONTACT_ID = sb.SSB_CRMSYSTEM_CONTACT_ID
					LEFT JOIN ( SELECT loyalty_customer_id
								FROM [ods].[Steelers_500f_Events] e 
								WHERE  DATEDIFF(DAY,e.transaction_date,GETDATE()) <= 60
										AND e.transaction_date >= '20160808' 
										AND e.points > 0 
										AND e.type NOT IN ('profile_bonus'
															,'facebook_boost'
															,'twitter_boost'
															,'instagram_boost'
															,'season_ticket_holder')
									GROUP BY e.loyalty_customer_id) engaged ON sb.SSID = engaged.loyalty_customer_id
          WHERE  sb.sourcesystem = '500f'
				 AND c.status = 'active'
          GROUP BY  DATEDIFF(YEAR, NULLIF(cr.Birthday,'1900-01-01'), GETDATE())
        ) s
GROUP BY CASE WHEN age < 18 THEN 'Under 18'
              WHEN age BETWEEN 18 AND 29 THEN 'Between 18 and 29'
              WHEN age BETWEEN 30 AND 39 THEN 'Between 30 and 39'
              WHEN age BETWEEN 40 AND 49 THEN 'Between 40 and 49'
              WHEN age BETWEEN 50 AND 59 THEN 'Between 50 and 59'
              WHEN age BETWEEN 60 AND 69 THEN 'Between 60 and 69'
              WHEN age BETWEEN 70 AND 115 THEN 'Over 70'
              ELSE 'Unknown'
         END

DELETE FROM [rpt].[PreCache_Cust_SNU_3_tbl]
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_SNU_3_tbl]
SET IsReady = 1






GO
