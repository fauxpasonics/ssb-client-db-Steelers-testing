SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [rpt].[PreCache_Cust_SNU_5]
 AS

IF OBJECT_ID('tempdb..#base')IS NOT NULL DROP TABLE #base
IF OBJECT_ID('tempdb..#tierRank')IS NOT NULL DROP TABLE #tierRank

CREATE TABLE #tierRank(
top_tier_name VARCHAR(20)
,priority INT
)

INSERT INTO #tierRank
        ( top_tier_name, priority )
VALUES  ('Starter', 4)
		,('Veteran', 3)
		,('Pro Bowl', 2)
		,('Hall of Fame', 1)

SELECT sb.SSB_CRMSYSTEM_CONTACT_ID
	   , CASE WHEN c.top_tier_name = '' THEN 'UNKNOWN' ELSE c.top_tier_name END top_tier_name
	   , RANK() OVER(PARTITION BY sb.SSB_CRMSYSTEM_CONTACT_ID ORDER BY ISNULL(tr.priority,5)) priority
INTO #base
FROM dimcustomerssbid sb 
	JOIN [ods].[Steelers_500f_Customer] c ON sb.SSID = CAST(c.loyalty_id AS VARCHAR(200))
	LEFT JOIN #tierRank tr ON tr.top_tier_name = c.top_tier_name
	LEFT JOIN ods.Steelers_500f_Events e ON c.loyalty_id = e.loyalty_customer_id
WHERE  1=1 
	  --AND c.top_tier_name <> '' 
	  AND c.status = 'active'
	  AND sb.SourceSystem = '500f'

INSERT INTO [rpt].[PreCache_Cust_SNU_5_tbl]

SELECT  top_tier_name detail
		,COUNT(DISTINCT SSB_CRMSYSTEM_CONTACT_ID) AS CustCount
		,CASE WHEN top_tier_name LIKE '%starter%' THEN '#000'
			 WHEN top_tier_name LIKE '%veteran%'  THEN '#000'
			 WHEN top_tier_name LIKE '%pro%' THEN '#000'
			 ELSE '#fff' 
		END AS Color
		,CASE WHEN top_tier_name LIKE '%starter%' THEN '1'
			 WHEN top_tier_name LIKE '%veteran%' THEN '2'
			 WHEN top_tier_name LIKE '%pro%' THEN '3'
			 ELSE '4' 
		 END AS Sorter
		 ,5 AS Size
		 ,0 AS IsReady
FROM #base
WHERE priority = 1
GROUP BY top_tier_name

DELETE FROM [rpt].[PreCache_Cust_SNU_5_tbl]
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_SNU_5_tbl]
SET IsReady = 1


DROP TABLE #base
DROP TABLE #tierRank

GO
