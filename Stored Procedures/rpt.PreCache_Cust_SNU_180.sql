SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [rpt].[PreCache_Cust_SNU_180]
AS

IF OBJECT_ID('tempdb..#yardGroups')IS NOT NULL DROP TABLE #yardGroups
IF OBJECT_ID('tempdb..#YardsEarned')IS NOT NULL DROP TABLE #YardsEarned


SELECT x.SSB_CRMSYSTEM_CONTACT_ID, ISNULL(DATEDIFF(DAY,x.LastTransaction,GETDATE()),-1) AS DaysSinceTrans
INTO #YardsEarned
FROM (  SELECT sb.SSB_CRMSYSTEM_CONTACT_ID
			   , MAX(e.transaction_date) LastTransaction
		FROM dimcustomerssbid sb 
			 JOIN [ods].[Steelers_500f_Customer] c ON sb.SSID = CAST(c.loyalty_id AS VARCHAR(200))
			 LEFT JOIN ods.Steelers_500f_Events e ON c.loyalty_id = e.loyalty_customer_id
													 AND e.transaction_date >= '20160808' 
													 AND e.points > 0 
													 AND e.type NOT IN ('profile_bonus'
											 							,'facebook_boost'
											 							,'twitter_boost'
											 							,'instagram_boost'
											 							,'season_ticket_holder')
		WHERE sourcesystem = '500f'		
			  AND c.status = 'active'
		GROUP BY sb.SSB_CRMSYSTEM_CONTACT_ID
	  )x

CREATE TABLE #yardGroups(
minDays INT
,maxDays INT
,Label VARCHAR(50)
,SortOrder INT
)

INSERT INTO #yardGroups
        ( minDays ,
          maxDays ,
          Label ,
          SortOrder
        )
VALUES   (0, 30, 'Earned Yards Within 30 days', 1)
		,(31, 60, 'Earned Yards 31 - 60 days', 2)
		,(61, 90, 'Earned Yards 61 - 90 days', 3)
		,(91, 180, 'Earned Yards 91 - 180 days', 4)
		,(181, 365, 'Earned Yards 181 - 365 days', 5) --20180727 jbarberio adjusted to include an additional bucket
		,(365, NULL, 'Earned Yards After 365 days', 6)		  --20180727 jbarberio adjusted to include an additional bucket
		,(-1, -1, 'None Earned', 7)


INSERT INTO [rpt].[PreCache_Cust_SNU_180_tbl]

SELECT groups.SortOrder
	   ,groups.Label
	   ,ISNULL(COUNT(DISTINCT SSB_CRMSYSTEM_CONTACT_ID),0) AS ActiveCount
	   ,NULL AS TotalCount
	   ,0 AS IsReady
FROM #yardGroups groups
	LEFT JOIN #YardsEarned earned ON earned.DaysSinceTrans BETWEEN groups.minDays AND groups.maxDays
									 OR (earned.DaysSinceTrans > 365 AND groups.label = 'Earned Yards After 365 days') --20180802 jbarberio adjusted this statement to account for additional bucket
GROUP BY groups.SortOrder
		 ,groups.Label


DELETE FROM [rpt].[PreCache_Cust_SNU_180_tbl]
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_SNU_180_tbl]
SET IsReady = 1


DROP TABLE #yardGroups
DROP TABLE #YardsEarned

GO
