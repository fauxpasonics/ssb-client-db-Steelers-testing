SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [rpt].[vw__Epsilon_Emailable]

AS 


SELECT PROFILE_KEY
FROM rpt.vw__Epsilon_PDU_Combined
WHERE OPTOUT_FLG = 0
	  AND UNDELIVERABLE = 0

GO
