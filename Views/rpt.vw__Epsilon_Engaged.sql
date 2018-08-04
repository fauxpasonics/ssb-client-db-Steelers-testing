SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [rpt].[vw__Epsilon_Engaged]

AS 

SELECT DISTINCT	PROFILE_KEY
FROM (  SELECT epsilon.PROFILE_KEY
		FROM ods.Epsilon_ADU epsilon
			JOIN dbo.Epsilon_actionCode_Lookup Codelookup ON Codelookup.ACTION_CODE = epsilon.ACTION_CODE
		WHERE Codelookup.CLASS IN ('CLICK','OPEN')
			  AND CAST(LEFT(ACTION_DTTM,8) AS DATE) > DATEADD(DAY,-60,CAST(GETDATE() AS DATE))

		UNION ALL

		SELECT CustomerKey
		FROM ods.Epsilon_Activities
		WHERE ActionTimestamp > DATEADD(DAY,-60,CAST(GETDATE() AS DATE))
			  AND Action IN ('CLICK', 'OPEN')
	 )combined



GO
