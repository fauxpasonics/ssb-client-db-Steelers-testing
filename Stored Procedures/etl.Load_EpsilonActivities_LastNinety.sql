SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROC [etl].[Load_EpsilonActivities_LastNinety] AS

DECLARE	@CutoffDate DATE = DATEADD(dd,-90,GETDATE());
DECLARE @LoadDateTime DATETIME = GETDATE()

--====================================================
--DROP INDEXES
--====================================================

IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_CustomerKey' AND object_id = OBJECT_ID('ods.Epsilon_Activities_LastNinety') )
DROP INDEX IX_CustomerKey ON ods.Epsilon_Activities_LastNinety

IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Preference' AND object_id = OBJECT_ID('ods.Epsilon_Activities_LastNinety') )
DROP INDEX IX_Preference ON ods.Epsilon_Activities_LastNinety

IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Action' AND object_id = OBJECT_ID('ods.Epsilon_Activities_LastNinety') )
DROP INDEX IX_Action ON ods.Epsilon_Activities_LastNinety

IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_MessageID' AND object_id = OBJECT_ID('ods.Epsilon_Activities_LastNinety') )
DROP INDEX IX_MessageID ON ods.Epsilon_Activities_LastNinety

--====================================================
--TRUNCATE AND INSERT
--====================================================

TRUNCATE TABLE ods.Epsilon_Activities_LastNinety

SELECT messagename
INTO #Messages
FROM ods.Epsilon_Activities (NOLOCK)
GROUP BY messagename
HAVING MIN(actiontimestamp) > @cutoffdate

CREATE NONCLUSTERED INDEX IX_MessageName ON #Messages(MessageName)

SELECT customerKey
INTO #Optouts
FROM ods.Epsilon_Profile_Updates pdu (NOLOCK)
WHERE EmailChannelOptOutFlag = 'Y'

CREATE NONCLUSTERED INDEX IX_CustomerKey ON #Optouts(CustomerKey)

INSERT INTO ods.Epsilon_Activities_LastNinety

SELECT a.CustomerKey
	  ,COALESCE(lkp.Preference
			    ,CASE WHEN CHARINDEX('_',RIGHT(a.MessageName,LEN(a.MessageName)-7)) = 0 THEN RIGHT(a.MessageName,LEN(a.MessageName)-7) 
	  			 	  ELSE LEFT(RIGHT(a.MessageName,LEN(a.MessageName)-7),CHARINDEX('_',RIGHT(a.MessageName,LEN(a.MessageName)-7))-1) 
			     END
				) AS Preference
	  ,CASE WHEN action LIKE '%Unsubscribe%' 
				 OR (Action = 'CLICK' AND LinkName = 'unsubscribe' AND optouts.CustomerKey IS NOT NULL) THEN 'OPT OUT'
	  		WHEN action = 'delivered' THEN 'SEND'
	  		ELSE action 
	   END AS Action
	  ,a.MessageName
	  ,CONCAT(a.MessageName,a.customerKey) MessageID
	  ,@LoadDateTime ETL_CreatedDate
FROM ods.Epsilon_Activities a (NOLOCK)
	JOIN #Messages b ON a.messagename = b.messagename
	LEFT JOIN #OptOuts optouts ON optouts.customerkey = a.customerkey
	LEFT JOIN rpt.Epsilon_Preference_Lookup lkp ON lkp.MessageName = a.MessageName

--====================================================
--REBUILD INDEXES
--====================================================

CREATE NONCLUSTERED INDEX IX_CustomerKey ON ods.Epsilon_Activities_LastNinety(CustomerKey)
CREATE NONCLUSTERED INDEX IX_Preference ON ods.Epsilon_Activities_LastNinety(Preference)
CREATE NONCLUSTERED INDEX IX_Action ON ods.Epsilon_Activities_LastNinety(Action)
CREATE NONCLUSTERED INDEX IX_MessageID ON ods.Epsilon_Activities_LastNinety(MessageID)


GO
