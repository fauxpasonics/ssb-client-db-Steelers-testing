SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create VIEW [rpt].[Epsilon_NoActivity] AS

SELECT pdu.*
FROM rpt.vw__Epsilon_Emailable emailable
	JOIN ods.Epsilon_Profile_Updates pdu on emailable.PROFILE_KEY = pdu.CustomerKey
	LEFT JOIN ( SELECT DISTINCT PROFILE_KEY
				FROM [rpt].[vw__Epsilon_ADU_Combined]
				WHERE Action IN ('CLICK','OPEN')
				GROUP BY PROFILE_KEY
			   )activity ON emailable.PROFILE_KEY = activity.PROFILE_KEY 
WHERE activity.PROFILE_KEY IS NULL

--SELECT case when pdu.customerkey IS NULL THEN 0 ELSE 1 END isCurrent
--	  ,COUNT(*)
--FROM rpt.vw__Epsilon_Emailable emailable
--	LEFT JOIN ( SELECT DISTINCT PROFILE_KEY
--				FROM [rpt].[vw__Epsilon_ADU_Combined]
--				WHERE Action IN ('CLICK','OPEN')
--				GROUP BY PROFILE_KEY
--			   )activity ON emailable.PROFILE_KEY = activity.PROFILE_KEY 
--	LEFT JOIN ods.Epsilon_Profile_Updates pdu on emailable.PROFILE_KEY = pdu.CustomerKey
--WHERE activity.PROFILE_KEY IS NULL
--GROUP BY case when pdu.customerkey IS NULL THEN 0 ELSE 1 END
GO
