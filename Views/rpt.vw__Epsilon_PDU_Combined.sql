SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [rpt].[vw__Epsilon_PDU_Combined]

AS 

SELECT PROFILE_KEY
	   ,JOIN_DATE
	   ,OPTOUT_FLG
	   ,CASE WHEN OPTOUT_FLG = 1 THEN OPTOUT_DATE END OPTOUT_DATE
	   ,UNDELIVERABLE
	   ,PREF_NEWSLETTER
	   ,PREF_SNU
	   ,PREF_MERCH
	   ,PREF_PARTNER_OFFERS
	   ,PREF_HEINZ_FIELD
	   ,PREF_TEAM_EVENTS
	   ,PREF_CONCERTS
FROM (  SELECT	COALESCE(new.PROFILE_KEY, old.PROFILE_KEY) PROFILE_KEY
			   ,COALESCE(old.JOIN_DATE,new.JOIN_DATE) JOIN_DATE
			   ,COALESCE(new.OPTOUT_DATE,old.OPTOUT_DATE) OPTOUT_DATE
			   ,COALESCE(new.OPTOUT_FLG,old.OPTOUT_FLG) OPTOUT_FLG
			   ,COALESCE(new.UNDELIVERABLE, old.UNDELIVERABLE) UNDELIVERABLE
			   ,COALESCE(new.PREF_NEWSLETTER, old.PREF_NEWSLETTER) PREF_NEWSLETTER
			   ,COALESCE(new.PREF_SNU, old.PREF_SNU) PREF_SNU
			   ,COALESCE(new.PREF_MERCH, old.PREF_MERCH) PREF_MERCH
			   ,COALESCE(new.PREF_PARTNER_OFFERS, old.PREF_PARTNER_OFFERS) PREF_PARTNER_OFFERS
			   ,COALESCE(new.PREF_HEINZ_FIELD, old.PREF_HEINZ_FIELD) PREF_HEINZ_FIELD
			   ,COALESCE(new.PREF_TEAM_EVENTS, old.PREF_TEAM_EVENTS) PREF_TEAM_EVENTS
			   ,COALESCE(new.PREF_CONCERTS, old.PREF_CONCERTS) PREF_CONCERTS		      
		FROM (  SELECT  CustomerKey AS PROFILE_KEY
					   ,CAST(JoinDate AS DATE) JOIN_DATE
					   ,EmailChannelOptStatusDate AS OPTOUT_DATE
					   ,CASE WHEN EmailChannelOptOutFlag = 'Y' THEN 1 ELSE 0 END AS OPTOUT_FLG
					   ,CASE WHEN EmailAddressDeliveryStatus = 'G' THEN 0 ELSE 1 END AS UNDELIVERABLE
					   ,CASE WHEN PREF_TEAM_NEWS       = 'Y' THEN 1 ELSE 0 END  PREF_NEWSLETTER                                                                  
					   ,CASE WHEN PREF_SNU             = 'Y' THEN 1 ELSE 0 END  PREF_SNU                                                                         
					   ,CASE WHEN PREF_MERCH           = 'Y' THEN 1 ELSE 0 END  PREF_MERCH                                                                       
					   ,CASE WHEN PREF_PARTNER_OFFERS  = 'Y' THEN 1 ELSE 0 END  PREF_PARTNER_OFFERS                                                              
					   ,CASE WHEN PREF_HEINZ_FIELD     = 'Y' THEN 1 ELSE 0 END  PREF_HEINZ_FIELD                                                                 
					   ,CASE WHEN PREF_TEAM_EVENTS     = 'Y' THEN 1 ELSE 0 END  PREF_TEAM_EVENTS                                                                 
					   ,CASE WHEN PREF_CONCERTS        = 'Y' THEN 1 ELSE 0 END  PREF_CONCERTS                                                                 
				FROM [ods].[Epsilon_Profile_Updates]
				) new
			FULL JOIN ( SELECT  PK AS PROFILE_KEY
							   ,CAST(LEFT(CREATED_DTTM,8) AS DATE) JOIN_DATE
							   ,CAST(LEFT(NULLIF(OPTOUT_DTTM,''),8) AS DATE)  OPTOUT_DATE
							   ,OPTOUT_FLG 
							   ,CASE WHEN NUM_FTD > 3 THEN 1 ELSE 0 END AS UNDELIVERABLE
							   ,CASE WHEN PREF_NEWSLETTER      = 'Y' THEN 1 ELSE 0 END  PREF_NEWSLETTER                                                                  
							   ,CASE WHEN PREF_SNU             = 'Y' THEN 1 ELSE 0 END  PREF_SNU                                                                         
							   ,CASE WHEN PREF_MERCH           = 'Y' THEN 1 ELSE 0 END  PREF_MERCH                                                                       
							   ,CASE WHEN PREF_PARTNER_OFFERS  = 'Y' THEN 1 ELSE 0 END  PREF_PARTNER_OFFERS                                                              
							   ,CASE WHEN PREF_HEINZ_FIELD     = 'Y' THEN 1 ELSE 0 END  PREF_HEINZ_FIELD                                                                 
							   ,0  PREF_TEAM_EVENTS                                                                 
							   ,0  PREF_CONCERTS   
						FROM ods.Epsilon_PDU
					  )old ON new.PROFILE_KEY = old.PROFILE_KEY

	   )combined













GO
