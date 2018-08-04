SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [rpt].[vw__Epsilon_PDU_Harmony]

AS 

SELECT  CustomerKey AS PROFILE_KEY
		,CAST(JoinDate AS DATE) JOIN_DATE
		,CASE WHEN EmailChannelOptOutFlag = 'Y' THEN CAST(EmailChannelOptStatusDate AS DATE) END OPTOUT_DATE
		,CASE WHEN EmailChannelOptOutFlag = 'Y' THEN 1 ELSE 0 END AS OPTOUT_FLG
		,CASE WHEN EmailAddressDeliveryStatus = 'U' THEN 1 ELSE 0 END AS UNDELIVERABLE
		,CASE WHEN PREF_TEAM_NEWS       = 'Y' THEN 1 ELSE 0 END  PREF_NEWSLETTER                                                                  
		,CASE WHEN PREF_SNU             = 'Y' THEN 1 ELSE 0 END  PREF_SNU                                                                         
		,CASE WHEN PREF_MERCH           = 'Y' THEN 1 ELSE 0 END  PREF_MERCH                                                                       
		,CASE WHEN PREF_PARTNER_OFFERS  = 'Y' THEN 1 ELSE 0 END  PREF_PARTNER_OFFERS                                                              
		,CASE WHEN PREF_HEINZ_FIELD     = 'Y' THEN 1 ELSE 0 END  PREF_HEINZ_FIELD                                                                 
		,CASE WHEN PREF_TEAM_EVENTS     = 'Y' THEN 1 ELSE 0 END  PREF_TEAM_EVENTS                                                                 
		,CASE WHEN PREF_CONCERTS        = 'Y' THEN 1 ELSE 0 END  PREF_CONCERTS                                                                 
FROM [ods].[Epsilon_Profile_Updates]












GO
