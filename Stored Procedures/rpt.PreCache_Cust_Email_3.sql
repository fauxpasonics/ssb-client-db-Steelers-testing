SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [rpt].[PreCache_Cust_Email_3]
AS


IF OBJECT_ID('tempdb..#tempcust')IS NOT NULL DROP TABLE #tempcust


SELECT  SSB_CRMSYSTEM_CONTACT_ID 
		,ssbid.SSID
        ,CASE WHEN engaged.profile_KEY IS NOT NULL THEN 1
                ELSE 0
        END AS Engaged
INTO    #tempcust
FROM    dbo.DimCustomerSSBID ssbid ( NOLOCK )
	JOIN rpt.vw__Epsilon_emailable_Harmony emailable ON emailable.PROFILE_KEY = ssbid.SSID		
	LEFT JOIN rpt.vw__Epsilon_Engaged_Harmony engaged ON engaged.PROFILE_KEY = ssbid.SSID
WHERE   ssbid.SourceSystem = 'Epsilon' 


INSERT INTO [rpt].[PreCache_Cust_Email_3_tbl]

SELECT  CASE WHEN c.AddressPrimaryCountry IN ( 'US', ' US', 'United States', 'United Sta' )
                    AND c.AddressPrimaryState IN ( 'PA', 'WV', 'OH', 'CA', 'FL', 'NY',
                                                    'VA', 'TX', 'NJ',  'NC', 'MD' )
                THEN c.AddressPrimaryState
                WHEN c.AddressPrimaryCountry IN ( 'US', ' US', 'United States', 'United Sta' )
                    AND ( c.AddressPrimaryState IS NULL
                        OR c.AddressPrimaryState = ''
                        ) THEN 'US Unknown State'
                WHEN c.AddressPrimaryCountry IN ( 'US', ' US', 'United States', 'United Sta' )
                    AND NOT c.AddressPrimaryState IN ( 'PA', 'WV', 'OH', 'CA', 'FL',
                                                        'NY', 'VA', 'TX', 'NJ', 'NC', 'MD' )
                THEN 'Other US'
                WHEN c.AddressPrimaryCountry IN ( 'GB', 'United Kingdom', 'United Kin' )
                THEN 'Great Britain'
                WHEN c.AddressPrimaryCountry IN ( 'MX', 'Mexico' )
                THEN 'Mexico'
                WHEN c.AddressPrimaryCountry IN ( 'CA', 'Canada' )
                THEN 'Canada'
                WHEN c.AddressPrimaryCountry IS NULL OR c.AddressPrimaryCountry = '' THEN 'Unknown'
                ELSE 'Other INTL'
        END AS Location 
		,COUNT(DISTINCT CASE WHEN engaged = 1 THEN sb.SSID ELSE NULL END) AS EngagedMembers
		,COUNT(DISTINCT CASE WHEN engaged = 0 THEN sb.SSID ELSE NULL END) AS NonEngagedMembers
        ,0 AS IsReady 
FROM    mdm.compositerecord c 
        JOIN #tempcust sb ON sb.SSB_CRMSYSTEM_CONTACT_ID = c.SSB_CRMSYSTEM_CONTACT_ID
GROUP BY CASE WHEN c.AddressPrimaryCountry IN ( 'US', ' US', 'United States', 'United Sta' )
                    AND c.AddressPrimaryState IN ( 'PA', 'WV', 'OH', 'CA', 'FL', 'NY',
                                                    'VA', 'TX', 'NJ',  'NC', 'MD' )
                THEN c.AddressPrimaryState
                WHEN c.AddressPrimaryCountry IN ( 'US', ' US', 'United States', 'United Sta' )
                    AND ( c.AddressPrimaryState IS NULL OR c.AddressPrimaryState = '' ) 
				THEN 'US Unknown State'
                WHEN c.AddressPrimaryCountry IN ( 'US', ' US', 'United States', 'United Sta' )
                    AND NOT c.AddressPrimaryState IN ( 'PA', 'WV', 'OH', 'CA', 'FL',
                                                        'NY', 'VA', 'TX', 'NJ', 'NC', 'MD' )
                THEN 'Other US'
                WHEN c.AddressPrimaryCountry IN ( 'GB', 'United Kingdom', 'United Kin' )
                THEN 'Great Britain'
                WHEN c.AddressPrimaryCountry IN ( 'MX', 'Mexico' )
                THEN 'Mexico'
                WHEN c.AddressPrimaryCountry IN ( 'CA', 'Canada' )
                THEN 'Canada'
                WHEN c.AddressPrimaryCountry IS NULL OR c.AddressPrimaryCountry = '' THEN 'Unknown'
                ELSE 'Other INTL'
        END



DELETE FROM rpt.PreCache_Cust_Email_3_tbl 
WHERE   IsReady = 1

UPDATE  rpt.PreCache_Cust_Email_3_tbl
SET     IsReady = 1

DROP TABLE #tempcust







GO
