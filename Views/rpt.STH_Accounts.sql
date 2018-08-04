SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [rpt].[STH_Accounts] AS
SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID,SSBID.DimCustomerId, dc.AccountId
FROM ods.vw_TM_custmember_active sth
	JOIN dbo.DimCustomer dc (NOLOCK) ON dc.AccountId = sth.acct_id
	JOIN dimcustomerssbid ssbid (NOLOCK) ON ssbid.DimCustomerId = dc.DimCustomerId
WHERE dc.SourceSystem = 'tm'
	  AND dc.CustomerType = 'primary'
	  AND sth.membership_name = 'STH'

GO
