SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE PROC [rpt].[PreCache_Cust_Email_9]
AS




--========================================================================================================================
--the commented piece below is now being performed within proc etl.load_epsilonactivities_lastninety, so the resultant
--table need only be referenced 
--========================================================================================================================









--DECLARE	@CutoffDate DATE = DATEADD(dd,-90,GETDATE());

--/*==================================================================================================
--										CTE DECLARATION
--==================================================================================================*/



--SELECT messagename
--INTO #Messages
--FROM ods.Epsilon_Activities (NOLOCK)
--GROUP BY messagename
--HAVING MIN(actiontimestamp) > @cutoffdate

--CREATE NONCLUSTERED INDEX IX_MessageName ON #Messages(MessageName)

--SELECT customerKey
--INTO #Optouts
--FROM ods.Epsilon_Profile_Updates pdu (NOLOCK)
--WHERE EmailChannelOptOutFlag = 'Y'

--CREATE NONCLUSTERED INDEX IX_CustomerKey ON #Optouts(CustomerKey)

--SELECT CustomerKey
--	  ,CASE WHEN CHARINDEX('_',RIGHT(a.MessageName,LEN(a.MessageName)-7)) = 0 THEN RIGHT(a.MessageName,LEN(a.MessageName)-7) 
--	  		ELSE LEFT(RIGHT(a.MessageName,LEN(a.MessageName)-7),CHARINDEX('_',RIGHT(a.MessageName,LEN(a.MessageName)-7))-1) 
--	   END AS Preference
--	  ,CASE WHEN action LIKE '%Unsubscribe%' THEN 'OPT OUT'
--	  		WHEN action = 'delivered' THEN 'SEND'
--	  		ELSE action 
--	   END AS Action
--	  ,a.MessageName
--	  ,CONCAT(a.MessageName,customerKey) MessageID
--	  ,LinkName
--INTO #Base
--FROM ods.Epsilon_Activities a (NOLOCK)
--	JOIN #Messages b ON a.messagename = b.messagename

--CREATE NONCLUSTERED INDEX IX_CustomerKey ON #Base(CustomerKey)
--CREATE NONCLUSTERED INDEX IX_Preference ON #Base(Preference)
--CREATE NONCLUSTERED INDEX IX_Action ON #Base(Action)


SELECT CASE WHEN Preference IN ('MERCH','SNU', 'NEWS', 'MKTG','HF', 'SPONSOR','BREAKINGNEWS','REACTIVATION' ) THEN Preference
			 WHEN Preference = 'HFEvents' THEN 'HF'
			 WHEN MessageName = 'PC_Welcome' THEN 'WELCOME'
			 ELSE 'OTHER'
		END AS Preference
		,COUNT(DISTINCT CASE WHEN action = 'SEND' THEN MessageName END) AS numSent
		,COUNT(CASE WHEN action = 'SEND' THEN MessageName END) AS numDelivered 
		,COUNT(DISTINCT CASE WHEN action = 'OPEN' THEN MessageID END) AS numOpened
		,COUNT(DISTINCT CASE WHEN action = 'CLICK' THEN MessageID END) AS numClicked
		,COUNT(CASE WHEN action = 'OPT OUT' THEN MessageName END) AS numOptOut
INTO #output
FROM ods.Epsilon_Activities_LastNinety base
GROUP BY CASE WHEN Preference IN ('MERCH','SNU', 'NEWS', 'MKTG','HF', 'SPONSOR','BREAKINGNEWS','REACTIVATION') THEN Preference
			   WHEN Preference = 'HFEvents' THEN 'HF'
			   WHEN MessageName = 'PC_Welcome' THEN 'WELCOME'
			   ELSE 'OTHER'
		  END
/*==================================================================================================
											OUTPUT
==================================================================================================*/

INSERT INTO rpt.PreCache_Cust_Email_9_tbl

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
ORDER BY SortOrder, Preference

DELETE rpt.PreCache_Cust_Email_9_tbl WHERE IsReady = 1
UPDATE rpt.PreCache_Cust_Email_9_tbl SET IsReady = 1


DROP TABLE #output


GO
