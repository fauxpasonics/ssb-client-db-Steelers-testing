SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [rpt].[vw__Epsilon_ADU_Combined]

AS 

SELECT PROFILE_KEY
	   ,CASE WHEN CHARINDEX('_',RIGHT(MAILING_NAME,LEN(MAILING_NAME)-7)) = 0 THEN RIGHT(MAILING_NAME,LEN(MAILING_NAME)-7) 
			 ELSE LEFT(RIGHT(MAILING_NAME,LEN(MAILING_NAME)-7),CHARINDEX('_',RIGHT(MAILING_NAME,LEN(MAILING_NAME)-7))-1) 
		END AS Preference
	   ,ACTION_DATE ActionDate
	   ,ActionCode.CLASS Action
	   ,adu.MAILING_NAME MessageName
FROM ods.Epsilon_ADU_mod adu
	JOIN dbo.Epsilon_ActionCode_Lookup ActionCode ON ActionCode.ACTION_CODE = adu.ACTION_CODE
													 AND ActionCode.SOURCE_CODE = adu.SOURCE_CODE

UNION ALL

SELECT CustomerKey
	   ,CASE WHEN CHARINDEX('_',RIGHT(MessageName,LEN(MessageName)-7)) = 0 THEN RIGHT(MessageName,LEN(MessageName)-7) 
			 ELSE LEFT(RIGHT(MessageName,LEN(MessageName)-7),CHARINDEX('_',RIGHT(MessageName,LEN(MessageName)-7))-1) 
		END AS Preference
	   ,CAST(ActionTimestamp AS DATE) ActionDate
	   ,CASE WHEN action LIKE '%Unsubscribe%' THEN 'OPT OUT'
			 WHEN action = 'delivered' THEN 'SEND'
			 ELSE action 
		END AS Action
	   ,MessageName
FROM ods.Epsilon_Activities






GO
