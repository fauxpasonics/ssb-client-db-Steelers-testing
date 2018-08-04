SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [segmentation].[vw__Epsilon]
AS

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	  --,customerkey
	  ,CAST(pdu.JoinDate AS DATE) AS JoinDate
	  ,CAST(pdu.EmailChannelOptStatusDate AS DATE) AS EmailChannelOptStatusDate
	  ,CASE WHEN pdu.EmailChannelOptOutFlag = 'Y' THEN 1 ELSE 0 END AS EmailChannelOptOutFlag
	  ,pdu.EmailAddressDeliveryStatus
	  ,CASE WHEN pdu.PREF_TEAM_NEWS = 'Y' THEN 1 ELSE 0 END AS PREF_TEAM_NEWS
	  ,CASE WHEN pdu.PREF_SNU = 'Y' THEN 1 ELSE 0 END AS PREF_SNU
	  ,CASE WHEN pdu.PREF_MERCH = 'Y' THEN 1 ELSE 0 END AS PREF_MERCH
	  ,CASE WHEN pdu.PREF_PARTNER_OFFERS = 'Y' THEN 1 ELSE 0 END AS PREF_PARTNER_OFFERS
	  ,CASE WHEN pdu.PREF_HEINZ_FIELD = 'Y' THEN 1 ELSE 0 END AS PREF_HEINZ_FIELD
	  ,CASE WHEN pdu.PREF_TEAM_EVENTS = 'Y' THEN 1 ELSE 0 END AS PREF_TEAM_EVENTS
	  ,CASE WHEN pdu.PREF_CONCERTS = 'Y' THEN 1 ELSE 0 END AS PREF_CONCERTS
	  ,CASE WHEN emailable.PROFILE_KEY IS NULL THEN 0 ELSE 1 END AS IsEmailable
	  ,CASE WHEN engaged.PROFILE_KEY IS NULL THEN 0 ELSE 1 END AS IsEngaged
FROM ods.Epsilon_Profile_Updates pdu WITH (NOLOCK)
	JOIN dbo.DimCustomerSSBID ssbid WITH (NOLOCK) ON ssbid.SourceSystem = 'Epsilon' AND ssbid.ssid = pdu.customerKey
	LEFT JOIN  rpt.vw__Epsilon_Emailable_Harmony emailable WITH (NOLOCK) ON emailable.PROFILE_KEY = pdu.CustomerKey
	LEFT JOIN rpt.vw__Epsilon_Engaged_Harmony engaged WITH (NOLOCK) ON engaged.PROFILE_KEY = pdu.CustomerKey



GO
