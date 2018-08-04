SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROC [rpt].[PreCache_Cust_SNU_Total]
AS

INSERT INTO [rpt].[PreCache_Cust_SNU_Total_tbl]


SELECT  COUNT(x.SSB_CRMSYSTEM_CONTACT_ID) AS ActiveMembers 
	   ,NULL AS Members
	   ,CASE WHEN balance = 0  THEN '0 Yards'
				WHEN balance BETWEEN 5 AND 49 THEN '5-49 Yards'
                WHEN balance BETWEEN 50 AND 99 THEN '50-99 Yards'
                WHEN balance BETWEEN 100 AND 149 THEN '100-149 Yards'
                WHEN balance BETWEEN 150 AND 199 THEN '150-199 Yards'
                WHEN balance BETWEEN 200 AND 249 THEN '200-249 Yards'
                WHEN balance BETWEEN 250 AND 299 THEN '250-299 Yards'
                WHEN balance BETWEEN 300 AND 349 THEN '300-349 Yards'
                WHEN balance BETWEEN 350 AND 399 THEN '350-399 Yards'
                WHEN balance BETWEEN 400 AND 449 THEN '400-449 Yards'
				ELSE '450 + Yards'
        END AS TotalYards 
       ,CASE	WHEN balance = 0  THEN 0
				WHEN balance BETWEEN 5 AND 49 THEN 1
                WHEN balance BETWEEN 50 AND 99 THEN 2
                WHEN balance BETWEEN 100 AND 149 THEN 3
                WHEN balance BETWEEN 150 AND 199 THEN 4
                WHEN balance BETWEEN 200 AND 249 THEN 5
                WHEN balance BETWEEN 250 AND 299 THEN 6
                WHEN balance BETWEEN 300 AND 349 THEN 7
                WHEN balance BETWEEN 350 AND 399 THEN 8
                WHEN balance BETWEEN 400 AND 449 THEN 9
				ELSE 10
        END AS SortOrder,
		0 AS IsReady
FROM    (SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
			   ,snu.balance
			   ,RANK() OVER(PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID ORDER BY snu.balance DESC, snu.enrolled_at DESC, NEWID()) rnk
		 FROM ods.Steelers_500f_Customer snu (NOLOCK)
			JOIN dimcustomerssbid ssbid (NOLOCK) ON ssbid.ssid = snu.loyalty_id
		 WHERE ssbid.SourceSystem = '500f'
			   AND snu.status = 'active'
		 )x
WHERE rnk = 1
GROUP BY CASE WHEN balance = 0  THEN '0 Yards'
				WHEN balance BETWEEN 5 AND 49 THEN '5-49 Yards'
                WHEN balance BETWEEN 50 AND 99 THEN '50-99 Yards'
                WHEN balance BETWEEN 100 AND 149 THEN '100-149 Yards'
                WHEN balance BETWEEN 150 AND 199 THEN '150-199 Yards'
                WHEN balance BETWEEN 200 AND 249 THEN '200-249 Yards'
                WHEN balance BETWEEN 250 AND 299 THEN '250-299 Yards'
                WHEN balance BETWEEN 300 AND 349 THEN '300-349 Yards'
                WHEN balance BETWEEN 350 AND 399 THEN '350-399 Yards'
                WHEN balance BETWEEN 400 AND 449 THEN '400-449 Yards'
				ELSE '450 + Yards'
        END 
       ,CASE	WHEN balance = 0  THEN 0
				WHEN balance BETWEEN 5 AND 49 THEN 1
                WHEN balance BETWEEN 50 AND 99 THEN 2
                WHEN balance BETWEEN 100 AND 149 THEN 3
                WHEN balance BETWEEN 150 AND 199 THEN 4
                WHEN balance BETWEEN 200 AND 249 THEN 5
                WHEN balance BETWEEN 250 AND 299 THEN 6
                WHEN balance BETWEEN 300 AND 349 THEN 7
                WHEN balance BETWEEN 350 AND 399 THEN 8
                WHEN balance BETWEEN 400 AND 449 THEN 9
				ELSE 10
        END
		ORDER BY SortOrder

DELETE FROM [rpt].[PreCache_Cust_SNU_Total_tbl]
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_SNU_Total_tbl]
SET IsReady = 1



GO
