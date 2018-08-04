SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*============================================================================================================
CREATED BY:		Jeff Barberio
CREATED DATE:	8/1/2017
PY VERSION:		N/A
USED BY:		Epsilon Outbound Integration
UPDATES:		8/1 jbarberio - broke load set out into standard/custom
				10/8 jbarberio - updated columns to match agreed-upon formats by SSB/Steelers/Epsilon
DESCRIPTION:	This view filters the upsert set for new records to be inserted
=============================================================================================================*/

CREATE VIEW [EmailOutbound].[vw_InsertList]
AS

SELECT  LOWER(std.Email)																	AS EmailAddress
	   ,LOWER(std.Email)																	AS CustomerKey
	   ,NULLIF(std.First_Name	,'')														AS FirstName
	   ,NULLIF(std.Last_Name	,'')														AS LastName
	   ,CASE WHEN std.GENDER IN ('M','F') THEN std.GENDER END								AS GENDER
	   ,std.Birth_Date																		AS DOB
	   ,NULLIF(cust.DOB_DAY		,'')														AS DOB_DAY
	   ,NULLIF(cust.DOB_MONTH	,'')														AS DOB_MONTH
	   ,NULLIF(cust.DOB_YEAR	,'')														AS DOB_YEAR
	   ,NULLIF(std.Address_City		,'')													AS City
	   ,CASE WHEN LEN(std.Address_State) = 2 THEN std.Address_State END						AS [State]
	   ,CASE WHEN ISNUMERIC(LEFT(std.Address_Zip,5)) = 1 THEN LEFT(std.Address_Zip,5) END	AS PostalCode
	   ,CASE WHEN LEN(std.Address_Country) = 2 THEN std.Address_Country END					AS Country
	   ,std.Record_Source																	AS RECORD_SOURCE
	   ,cust.PREF_SNU																		AS PREF_SNU
	   ,CAST(cust.SNU_ENROLLED_AT AS DATETIME)												AS SNU_ENROLLED_AT
	   ,cust.SNU_STATUS																		AS SNU_STATUS
	   ,cust.SNU_TIER																		AS SNU_TIER
	   ,cust.SNU_TIER_PREVIOUS_SEASON														AS SNU_TIER_PREVIOUS_SEASON
	   ,cust.SNU_CURRENT_YARDS																AS SNU_CURRENT_YARDS
	   ,CAST(cust.SNU_LAST_ACTIVITY_DATE AS DATETIME)										AS SNU_LAST_ACTIVITY_DATE
	   ,cust.CURRENT_STH																	AS CURRENT_STH
	   ,cust.CURRENT_SUITE																	AS CURRENT_SUITE
	   ,cust.CURRENT_WL																		AS CURRENT_WL
	   ,cust.TM_SINGLE_BUYER																AS TM_SINGLE_BUYER
	   ,cust.TM_CONCERT																		AS TM_CONCERT
	   ,NULLIF(cust.EVENTS_ATTENDED	,'')													AS EVENTS_ATTENDED
	   ,NULLIF(cust.CONTESTS_ENTERED,'')													AS CONTESTS_ENTERED
	   ,cust.IS_WIFI_CUSTOMER																AS IS_WIFI_CUSTOMER
	   ,cust.IS_MOBILE_APP_CUSTOMER															AS IS_MOBILE_APP_CUSTOMER
	   ,cust.PREF_TEAM_NEWS																	AS PREF_TEAM_NEWS
	   ,cust.PREF_TEAM_EVENTS																AS PREF_TEAM_EVENTS
	   ,cust.PREF_CONCERTS																	AS PREF_CONCERTS
	   ,cust.PREF_HEINZ_FIELD																AS PREF_HEINZ_FIELD
	   ,cust.PREF_MERCH																		AS PREF_MERCH
	   ,cust.PREF_PARTNER_OFFERS															AS PREF_PARTNER_OFFERS
	   ,cust.PRO_SHOP_PURCHASER																AS PRO_SHOP_PURCHASER
	   ,CAST(cust.PRO_SHOP_LAST_ORDER_DATE AS DATETIME)										AS PRO_SHOP_LAST_ORDER_DATE
	   ,cust.NFL_SHOP_PURCHASER																AS NFL_SHOP_PURCHASER
FROM EmailOutbound.Upsert_Standard std
	JOIN EmailOutbound.upsert_custom cust ON cust.email = std.email
WHERE Is_New_Record = 1



GO
