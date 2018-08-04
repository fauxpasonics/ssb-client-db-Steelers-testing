SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROC [rpt].[PreCache_Cust_SNU_4]
 AS
 
 SELECT DISTINCT sb.SSB_CRMSYSTEM_CONTACT_ID,
 CASE WHEN c.status = 'active' AND engaged.loyalty_customer_id IS NOT NULL THEN sb.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END AS Engaged
 , CASE WHEN c.status = 'active' AND engaged.loyalty_customer_id IS NULL THEN sb.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END AS NonEngaged
INTO #engtemp
FROM dimcustomerssbid sb 
JOIN [ods].[Steelers_500f_Customer] c ON sb.SSID = CAST(c.loyalty_id AS VARCHAR(200))
LEFT JOIN ( SELECT loyalty_customer_id
			FROM [ods].[Steelers_500f_Events] e 
			WHERE  DATEDIFF(DAY,e.transaction_date,GETDATE()) < 60
				   AND e.transaction_date >= '20160808' 
				   AND e.points > 0 
				   AND e.type NOT IN ('profile_bonus'
									  ,'facebook_boost'
									  ,'twitter_boost'
									  ,'instagram_boost'
									  ,'season_ticket_holder')
			GROUP BY e.loyalty_customer_id
			) engaged ON sb.SSID = engaged.loyalty_customer_id
WHERE sourcesystem = '500f' AND c.status = 'active'
--DROP TABLE #engtemp

INSERT INTO [rpt].[PreCache_Cust_SNU_4_tbl]


SELECT CASE WHEN c.AddressPrimaryCountry IN ('US',' US','United States', 'United Sta') AND c.AddressPrimaryState IN ('PA','WV','OH','CA','FL','NY','VA','TX','NJ','NC','MD') THEN c.AddressPrimaryState
			WHEN c.AddressPrimaryCountry IN ('US',' US','United States', 'United Sta') AND (c.AddressPrimaryState IS NULL OR c.AddressPrimaryState = '') THEN 'US Unknown State'
			WHEN c.AddressPrimaryCountry IN ('US',' US','United States', 'United Sta') AND  c.AddressPrimaryState NOT IN ('PA','WV','OH','CA','FL','NY','VA','TX','NJ','NC','MD') THEN 'Other US'
			WHEN c.AddressPrimaryCountry IN ('GB','United Kingdom', 'United Kin') THEN 'Great Britain'
			WHEN c.AddressPrimaryCountry IN ('MX','Mexico') THEN 'Mexico'
			WHEN c.AddressPrimaryCountry IN ('CA','Canada') THEN 'Canada'
			WHEN c.AddressPrimaryCountry IS NULL OR c.AddressPrimaryCountry= '' THEN 'Unknown'
			ELSE 'Other INTL' 
	   END AS Location,
	   COUNT(DISTINCT CASE WHEN e.Engaged IS NOT NULL THEN c.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS EngagedMembers,
	   COUNT(DISTINCT c.SSB_CRMSYSTEM_CONTACT_ID) - COUNT(DISTINCT CASE WHEN e.Engaged IS NOT NULL THEN c.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS NonEngagedMembers,
	   0 AS IsReady
FROM mdm.compositerecord c 
	JOIN #engtemp e ON c.SSB_CRMSYSTEM_CONTACT_ID = e.SSB_CRMSYSTEM_CONTACT_ID
GROUP BY CASE WHEN c.AddressPrimaryCountry IN ('US',' US','United States', 'United Sta') AND c.AddressPrimaryState IN ('PA','WV','OH','CA','FL','NY','VA','TX','NJ','NC','MD') THEN c.AddressPrimaryState
			  WHEN c.AddressPrimaryCountry IN ('US',' US','United States', 'United Sta') AND (c.AddressPrimaryState IS NULL OR c.AddressPrimaryState = '') THEN 'US Unknown State'
			  WHEN c.AddressPrimaryCountry IN ('US',' US','United States', 'United Sta') AND NOT c.AddressPrimaryState IN ('PA','WV','OH','CA','FL','NY','VA','TX','NJ','NC','MD') THEN 'Other US'
			  WHEN c.AddressPrimaryCountry IN ('GB','United Kingdom', 'United Kin') THEN 'Great Britain'
			  WHEN c.AddressPrimaryCountry IN ('MX','Mexico') THEN 'Mexico'
			  WHEN c.AddressPrimaryCountry IN ('CA','Canada') THEN 'Canada'
			  WHEN c.AddressPrimaryCountry IS NULL OR c.AddressPrimaryCountry= '' THEN 'Unknown'
			  ELSE 'Other INTL' 
		  END

DELETE FROM [rpt].[PreCache_Cust_SNU_4_tbl]
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_SNU_4_tbl]
SET IsReady = 1





GO
