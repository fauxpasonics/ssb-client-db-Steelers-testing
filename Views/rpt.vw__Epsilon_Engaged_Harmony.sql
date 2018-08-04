SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [rpt].[vw__Epsilon_Engaged_Harmony]

AS 


SELECT DISTINCT CustomerKey	PROFILE_KEY
FROM ods.Epsilon_Activities
WHERE ActionTimestamp > DATEADD(DAY,-60,CAST(GETDATE() AS DATE))
		AND Action IN ('CLICK', 'OPEN')



GO
