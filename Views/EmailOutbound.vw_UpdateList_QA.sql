SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [EmailOutbound].[vw_UpdateList_QA]
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
	   ,cust.EVENTS_ATTENDED																AS EVENTS_ATTENDED
	   ,cust.CONTESTS_ENTERED																AS CONTESTS_ENTERED
	   ,cust.IS_WIFI_CUSTOMER																AS IS_WIFI_CUSTOMER
	   ,cust.IS_MOBILE_APP_CUSTOMER															AS IS_MOBILE_APP_CUSTOMER
	   --,cust.PREF_TEAM_NEWS																AS PREF_TEAM_NEWS
	   --,cust.PREF_TEAM_EVENTS																AS PREF_TEAM_EVENTS
	   --,cust.PREF_CONCERTS																AS PREF_CONCERTS
	   --,cust.PREF_HEINZ_FIELD																AS PREF_HEINZ_FIELD
	   --,cust.PREF_MERCH																	AS PREF_MERCH
	   --,cust.PREF_PARTNER_OFFERS															AS PREF_PARTNER_OFFERS
	   ,cust.PRO_SHOP_PURCHASER																AS PRO_SHOP_PURCHASER
	   ,CAST(cust.PRO_SHOP_LAST_ORDER_DATE AS DATETIME)										AS PRO_SHOP_LAST_ORDER_DATE
	   ,cust.NFL_SHOP_PURCHASER																AS NFL_SHOP_PURCHASER
	   ,CASE WHEN std.First_Name									<> pdu.FirstName					THEN 1 ELSE 0 END		QA_FirstName				
	   ,CASE WHEN std.Last_Name										<> pdu.LastName							THEN 1 ELSE 0 END 	QA_LastName					
	   ,CASE WHEN std.Gender										<> pdu.GENDER						THEN 1 ELSE 0 END 		QA_GENDER					
	   ,CASE WHEN CAST(std.Birth_Date AS DATETIME)					<> pdu.DOB							THEN 1 ELSE 0 END 		QA_DOB						
	   ,CASE WHEN cust.DOB_DAY										<> pdu.DOB_DAY						THEN 1 ELSE 0 END 		QA_DOB_DAY					
	   ,CASE WHEN cust.DOB_MONTH									<> pdu.DOB_MONTH					THEN 1 ELSE 0 END 		QA_DOB_MONTH				
	   ,CASE WHEN cust.DOB_YEAR										<> pdu.DOB_YEAR							THEN 1 ELSE 0 END 	QA_DOB_YEAR					
	   ,CASE WHEN std.Address_City									<> pdu.City							THEN 1 ELSE 0 END 		QA_City						
	   ,CASE WHEN std.Address_State									<> pdu.State							THEN 1 ELSE 0 END 	QA_State					
	   ,CASE WHEN std.Address_Zip									<> pdu.PostalCode					THEN 1 ELSE 0 END 		QA_PostalCode				
	   ,CASE WHEN std.Address_Country								<> pdu.Country						THEN 1 ELSE 0 END 		QA_Country					
	   ,CASE WHEN std.Record_Source									<> pdu.RECORD_SOURCE					THEN 1 ELSE 0 END 	QA_RECORD_SOURCE			
	   ,CASE WHEN cust.PREF_SNU										<> pdu.PREF_SNU							THEN 1 ELSE 0 END 	QA_PREF_SNU					
	   ,CASE WHEN CAST(cust.SNU_ENROLLED_AT AS DATETIME)			<> pdu.SNU_ENROLLED_AT				THEN 1 ELSE 0 END 		QA_SNU_ENROLLED_AT			
	   ,CASE WHEN cust.SNU_STATUS									<> pdu.SNU_STATUS					THEN 1 ELSE 0 END 		QA_SNU_STATUS				
	   ,CASE WHEN cust.SNU_TIER										<> pdu.SNU_TIER							THEN 1 ELSE 0 END 	QA_SNU_TIER					
	   ,CASE WHEN cust.SNU_TIER_PREVIOUS_SEASON						<> pdu.SNU_TIER_PREVIOUS_SEASON			THEN 1 ELSE 0 END 	QA_SNU_TIER_PREVIOUS_SEASON	
	   ,CASE WHEN cust.SNU_CURRENT_YARDS							<> pdu.SNU_CURRENT_YARDS			THEN 1 ELSE 0 END 		QA_SNU_CURRENT_YARDS		
	   ,CASE WHEN CAST(cust.SNU_LAST_ACTIVITY_DATE AS DATETIME)		<> pdu.SNU_LAST_ACTIVITY_DATE			THEN 1 ELSE 0 END 	QA_SNU_LAST_ACTIVITY_DATE	
	   ,CASE WHEN cust.CURRENT_STH									<> pdu.CURRENT_STH					THEN 1 ELSE 0 END 		QA_CURRENT_STH				
	   ,CASE WHEN cust.CURRENT_SUITE								<> pdu.CURRENT_SUITE				THEN 1 ELSE 0 END 		QA_CURRENT_SUITE			
	   ,CASE WHEN cust.CURRENT_WL									<> pdu.CURRENT_WL					THEN 1 ELSE 0 END 		QA_CURRENT_WL				
	   ,CASE WHEN cust.TM_SINGLE_BUYER								<> pdu.TM_SINGLE_BUYER				THEN 1 ELSE 0 END 		QA_TM_SINGLE_BUYER			
	   ,CASE WHEN cust.TM_CONCERT									<> pdu.TM_CONCERT					THEN 1 ELSE 0 END 		QA_TM_CONCERT				
	   ,CASE WHEN cust.EVENTS_ATTENDED								<> pdu.EVENTS_ATTENDED				THEN 1 ELSE 0 END 		QA_EVENTS_ATTENDED			
	   ,CASE WHEN cust.CONTESTS_ENTERED								<> pdu.CONTESTS_ENTERED					THEN 1 ELSE 0 END 	QA_CONTESTS_ENTERED			
	   ,CASE WHEN cust.IS_WIFI_CUSTOMER								<> pdu.IS_WIFI_CUSTOMER					THEN 1 ELSE 0 END 	QA_IS_WIFI_CUSTOMER			
	   ,CASE WHEN cust.IS_MOBILE_APP_CUSTOMER						<> pdu.IS_MOBILE_APP_CUSTOMER		THEN 1 ELSE 0 END 		QA_IS_MOBILE_APP_CUSTOMER	
	   ,CASE WHEN cust.PRO_SHOP_PURCHASER							<> pdu.PRO_SHOP_PURCHASER			THEN 1 ELSE 0 END 		QA_PRO_SHOP_PURCHASER		
	   ,CASE WHEN CAST(cust.PRO_SHOP_LAST_ORDER_DATE AS DATETIME)	<> pdu.PRO_SHOP_LAST_ORDER_DATE		THEN 1 ELSE 0 END		QA_PRO_SHOP_LAST_ORDER_DATE
FROM EmailOutbound.Upsert_Standard std
	JOIN EmailOutbound.upsert_custom cust ON cust.email = std.email
	JOIN ods.Epsilon_Profile_Updates pdu ON pdu.CustomerKey = std.Email
WHERE Is_New_Record = 0
	  AND (	ISNULL(std.First_Name,'')                               <> ISNULL(pdu.FirstName,'') 
			OR ISNULL(std.Last_Name,'')                             <> ISNULL(pdu.LastName,'') 
			OR ISNULL(std.Gender,'')                                <> ISNULL(pdu.Gender,'') 
			OR ISNULL(std.Birth_Date,'1900-01-01')                  <> ISNULL(CAST(pdu.DOB AS DATE),'1900-01-01') 
			OR ISNULL(cust.DOB_DAY,'')                              <> ISNULL(pdu.DOB_DAY,'') 
			OR ISNULL(cust.DOB_MONTH,'')                            <> ISNULL(pdu.DOB_MONTH,'') 
			OR ISNULL(cust.DOB_YEAR,'')                             <> ISNULL(pdu.DOB_YEAR,'') 
			OR ISNULL(std.Address_City,'')                          <> ISNULL(pdu.City,'') 
			OR ISNULL(std.Address_State,'')                         <> ISNULL(pdu.State,'') 
			OR ISNULL(std.Address_Zip,'')                           <> ISNULL(pdu.PostalCode,'') 
			OR ISNULL(std.Address_Country,'')                       <> ISNULL(pdu.Country,'') 
			OR ISNULL(std.Record_Source,'')                         <> ISNULL(pdu.Record_Source,'') 
			OR ISNULL(cust.PREF_SNU,'')                             <> ISNULL(pdu.PREF_SNU,'') 
			OR ISNULL(cust.SNU_ENROLLED_AT,'1900-01-01')            <> ISNULL(CAST(pdu.SNU_ENROLLED_AT AS DATETIME),'1900-01-01') 
			OR ISNULL(cust.SNU_STATUS,'')                           <> ISNULL(pdu.SNU_STATUS,'') 
			OR ISNULL(cust.SNU_TIER,'')                             <> ISNULL(pdu.SNU_TIER,'') 
			OR ISNULL(cust.SNU_TIER_PREVIOUS_SEASON,'')             <> ISNULL(pdu.SNU_TIER_PREVIOUS_SEASON,'') 
			OR ISNULL(cust.SNU_CURRENT_YARDS,'')                    <> ISNULL(pdu.SNU_CURRENT_YARDS,'') 
			OR ISNULL(cust.SNU_LAST_ACTIVITY_DATE,'1900-01-01')     <> ISNULL(CAST(pdu.SNU_LAST_ACTIVITY_DATE AS DATETIME),'1900-01-01') 
			OR ISNULL(cust.CURRENT_STH,'')                          <> ISNULL(pdu.CURRENT_STH,'') 
			OR ISNULL(cust.CURRENT_SUITE,'')                        <> ISNULL(pdu.CURRENT_SUITE,'') 
			OR ISNULL(cust.CURRENT_WL,'')                           <> ISNULL(pdu.CURRENT_WL,'') 
			OR ISNULL(cust.TM_SINGLE_BUYER,'')                      <> ISNULL(pdu.TM_SINGLE_BUYER,'') 
			OR ISNULL(cust.TM_CONCERT,'')                           <> ISNULL(pdu.TM_CONCERT,'') 
			OR ISNULL(cust.EVENTS_ATTENDED,'')                      <> ISNULL(pdu.EVENTS_ATTENDED,'') 
			OR ISNULL(cust.CONTESTS_ENTERED,'')                     <> ISNULL(pdu.CONTESTS_ENTERED,'') 
			OR ISNULL(cust.IS_WIFI_CUSTOMER,'')                     <> ISNULL(pdu.IS_WIFI_CUSTOMER,'') 
			OR ISNULL(cust.IS_MOBILE_APP_CUSTOMER,'')               <> ISNULL(pdu.IS_MOBILE_APP_CUSTOMER,'') 
			OR ISNULL(cust.PRO_SHOP_PURCHASER,'')                   <> ISNULL(pdu.PRO_SHOP_PURCHASER,'') 
			OR ISNULL(cust.PRO_SHOP_LAST_ORDER_DATE,'1900-01-01')   <> ISNULL(CAST(pdu.PRO_SHOP_LAST_ORDER_DATE AS DATETIME),'1900-01-01'))
GO
