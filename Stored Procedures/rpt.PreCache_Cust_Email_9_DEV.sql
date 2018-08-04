SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE PROC [rpt].[PreCache_Cust_Email_9_DEV]
AS 

IF OBJECT_ID('tempdb..#base') IS NOT NULL   DROP TABLE #base
IF OBJECT_ID('tempdb..#output') IS NOT NULL DROP TABLE #output

DECLARE	@CutoffDate DATE = DATEADD(dd,-90,GETDATE())

SELECT CustomerKey
	   ,CASE WHEN CHARINDEX('_',RIGHT(a.MessageName,LEN(a.MessageName)-7)) = 0 THEN RIGHT(a.MessageName,LEN(a.MessageName)-7) 
			 ELSE LEFT(RIGHT(a.MessageName,LEN(a.MessageName)-7),CHARINDEX('_',RIGHT(a.MessageName,LEN(a.MessageName)-7))-1) 
		END AS Preference
	   ,CASE WHEN action LIKE '%Unsubscribe%' THEN 'OPT OUT'
			 WHEN action = 'delivered' THEN 'SEND'
			 ELSE action 
		END AS Action
	   ,a.MessageName
	   ,CONCAT(a.MessageName,customerKey) MessageID
	   ,LinkName
into #base
FROM ods.Epsilon_Activities a (NOLOCK)
	LEFT JOIN ( select DISTINCT messagename
			   from ods.Epsilon_Activities (NOLOCK)
			   where actiontimestamp <= @cutoffdate
			   )b on a.messagename = b.messagename
where b.messagename is null


SELECT CASE WHEN Preference IN ('MERCH','SNU', 'NEWS', 'MKTG','HF', 'SPONSOR','BREAKINGNEWS') THEN Preference
			 WHEN Preference = 'HFEvents' THEN 'HF'
			 WHEN MessageName = 'PC_Welcome' THEN 'WELCOME'
			ELSE 'OTHER'
	   END AS Preference
	   ,COUNT(DISTINCT CASE WHEN action = 'SEND' THEN MessageName END) AS numSent
	   ,COUNT(CASE WHEN action = 'SEND' THEN MessageName END) AS numDelivered
	   ,COUNT(DISTINCT CASE WHEN action = 'OPEN' THEN MessageID END) AS numOpened
	   ,COUNT(DISTINCT CASE WHEN action = 'CLICK' THEN MessageID END) AS numClicked
	   ,COUNT(CASE WHEN action = 'OPT OUT' 
						OR (Action = 'CLICK' AND LinkName = 'Unsubscribe' and optouts.customerkey IS NOT NULL )
				   THEN MessageName END) AS numOptOut
INTO #output
FROM #base base	
	LEFT JOIN (select customerKey
			   FROM ods.Epsilon_Profile_Updates pdu (NOLOCK)
			   WHERE EmailChannelOptOutFlag = 'Y'
			   )optouts on optouts.customerkey = base.customerkey																			
GROUP BY CASE WHEN Preference IN ('MERCH','SNU', 'NEWS', 'MKTG','HF', 'SPONSOR','BREAKINGNEWS') THEN Preference
			 WHEN Preference = 'HFEvents' THEN 'HF'
			 WHEN MessageName = 'PC_Welcome' THEN 'WELCOME'
			ELSE 'OTHER'
	   END 

--INSERT INTO rpt.PreCache_Cust_Email_9_tbl

SELECT CASE WHEN Preference = 'OTHER' THEN 1 ELSE 0 END SortOrder
	  ,Preference
	  ,numSent
	  ,numDelivered
	  ,numOpened
	  ,CAST(ISNULL(1.0*numOpened/numDelivered,0) AS DECIMAL(5,4)) openRate
	  ,numClicked
	  ,CAST(ISNULL(1.0*numClicked/numDelivered,0) AS DECIMAL(5,4)) ClickRate
	  ,CAST(ISNULL(1.0*numClicked/numOpened,0) AS DECIMAL(5,4)) ClickOpenRate
	  ,numOptOut
	  ,CAST(ISNULL(1.0*numOptOut/numDelivered,0) AS DECIMAL(5,4)) OptOutRate
	  ,0 IsReady
FROM #output
WHERE Preference <> 'HF'
ORDER BY SortOrder, Preference

--DELETE rpt.PreCache_Cust_Email_9_tbl WHERE IsReady = 1
--UPDATE rpt.PreCache_Cust_Email_9_tbl SET IsReady = 1


DROP TABLE #base
DROP TABLE #output






GO
