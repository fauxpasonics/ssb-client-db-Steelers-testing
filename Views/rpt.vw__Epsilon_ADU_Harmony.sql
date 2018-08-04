SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [rpt].[vw__Epsilon_ADU_Harmony]

AS 

SELECT CustomerKey PROFILE_KEY
	   ,CASE WHEN CHARINDEX('_',RIGHT(MessageName,LEN(MessageName)-7)) = 0 THEN RIGHT(MessageName,LEN(MessageName)-7) 
			 ELSE LEFT(RIGHT(MessageName,LEN(MessageName)-7),CHARINDEX('_',RIGHT(MessageName,LEN(MessageName)-7))-1) 
		END AS Preference
	   ,CAST(ActionTimestamp AS DATE) ActionDate
	   ,CASE WHEN action LIKE '%Unsubscribe%' THEN 'OPT OUT'
			 WHEN action = 'delivered' THEN 'SEND'
			 ELSE action 
		END AS Action
	   ,MessageName
	   ,MessageID
	   ,LinkName
FROM ods.Epsilon_Activities adu


GO
