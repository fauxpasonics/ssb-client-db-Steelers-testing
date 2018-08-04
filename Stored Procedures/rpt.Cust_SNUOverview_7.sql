SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






 CREATE PROC [rpt].[Cust_SNUOverview_7]
 AS

 DECLARE @CutoffDate DATE = (SELECT rpt.fn_Cust_SNU_GetCutoffDate())

SELECT  type 
        ,COUNT(DISTINCT e.loyalty_customer_id) AS IdCount
FROM    ods.Steelers_500f_Events e
        JOIN ods.Steelers_500f_Customer c ON c.loyalty_id = e.loyalty_customer_id
WHERE   e.points > 0
        AND c.status = 'active'
		AND e.transaction_date >= @CutoffDate
		AND TYPE NOT IN ( 'profile_bonus'
					     ,'facebook_boost'
					     ,'twitter_boost'
					     ,'instagram_boost')
GROUP BY type
ORDER BY IdCount DESC	

/*
SELECT type, SUM(points)points
FROM ods.Steelers_500f_Events
GROUP BY type
ORDER BY points DESC	
*/





GO
