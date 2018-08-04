SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[Load_ods_Epsilon_Profile_Updates]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\dhorstman
Date:     09/26/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.Epsilon_Profile_Updates),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

/*Extract Options, default values set if the option is not specified*/	
DECLARE @DisableInsert nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableInsert'),'false')
DECLARE @DisableUpdate nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableUpdate'),'false')
DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')


BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId


UPDATE stg.Epsilon_Profile_Updates
SET FirstName = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(FirstName,'Ã',''),'¿',''),'Â',''),'¯',''),'½',''),
	LastName = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LastName,'Ã',''),'¿',''),'Â',''),'¯',''),'½',''),
	AddressLine1 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(AddressLine1,'Ã',''),'¿',''),'Â',''),'¯',''),'½',''),
	AddressLine2 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(AddressLine2,'Ã',''),'¿',''),'Â',''),'¯',''),'½',''),
	City = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(City,'Ã',''),'¿',''),'Â',''),'¯',''),'½',''),
	Country = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Country,'Ã',''),'¿',''),'Â',''),'¯',''),'½',''),
	State = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(State,'Ã',''),'¿',''),'Â',''),'¯',''),'½',''),
	PostalCode = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PostalCode,'Ã',''),'¿',''),'Â',''),'¯',''),'½','')
;

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
,  ETL_FileName, CustomerKey, EmailAddress, EmailAddressDeliveryStatus, EmailChannelOptOutFlag, EmailAddressDeliveryStatusDate, EmailChannelOptStatusDate, ModifiedDate, JoinDate, FAN_CLUB_2013, LEGENDS_2013, STH_2013, SUITES_2013, WAITLIST_2013, FAN_CLUB_2014, LEGENDS_Q1_2014, LEGENDS_Q2_2014, LEGENDS_Q3_2014, LEGENDS_Q4_2014, STH_Q1_2014, STH_Q2_2014, STH_Q3_2014, STH_Q4_2014, SUITES_Q1_2014, SUITES_Q2_2014, SUITES_Q3_2014, SUITES_Q4_2014, WL_Q1_2014, WL_Q2_2014, WL_Q3_2014, WL_Q4_2014, FAN_CLUB_2015, STH_Q1_2015, STH_Q2_2015, STH_Q3_2015, STH_Q4_2015, SUITES_Q1_2015, SUITES_Q2_2015, SUITES_Q3_2015, SUITES_Q4_2015, WL_Q1_2015, WL_Q2_2015, WL_Q3_2015, WL_Q4_2015, STH_Q1_2016, STH_Q2_2016, SUITES_Q1_2016, SUITES_Q2_2016, WL_Q1_2016, WL_Q2_2016, ATTEND_5K, AddressLine1, AddressLine2, City, Country, CRUISE_ATTEND, DOB, DOB_DAY, DOB_MONTH, DOB_YEAR, DRAFT_PICK_CONTEST, FAVORITEPLAYER, FirstName, GENDER, HEINZ_FIELD_EVENTS, LastName, MENS_FANTASY_CAMP, MENS_FANTASY_CAMP_ATTEND, PREF_5K, PREF_COUNTRY_CONCERTS, PREF_FAN_CLUBS, PREF_HEINZ_FIELD, PREF_LADIES_EVENTS, PREF_MERCH, PREF_NEWSLETTER, PREF_PARTNER_OFFERS, PREF_ROCK_CONCERTS, PREF_SNU, PREF_TEAM_EVENTS, PREF_TR_CAMP, PREF_UPDATE_DT, PREF_YOUTH_CAMPS, PREF_TEAM_NEWS, PREF_CONCERTS, PURCHASEMERCHANDISE, RECORD_SOURCE, SNU_STATUS, State, STH_ACCOUNT_ID, TICKET_TYPE, PostalCode, SNU_ENROLLED_AT, SNU_TIER, SNU_TIER_PREVIOUS_SEASON, SNU_CURRENT_YARDS, SNU_LAST_ACTIVITY_DATE, CURRENT_STH, CURRENT_SUITE, CURRENT_WL, TM_SINGLE_BUYER, TM_CONCERT, EVENTS_ATTENDED, CONTESTS_ENTERED, IS_WIFI_CUSTOMER, IS_MOBILE_APP_CUSTOMER, PRO_SHOP_PURCHASER, PRO_SHOP_LAST_ORDER_DATE, NFL_SHOP_PURCHASER
INTO #SrcData
FROM (
	SELECT  ETL_FileName, CustomerKey, EmailAddress, EmailAddressDeliveryStatus, EmailChannelOptOutFlag, EmailAddressDeliveryStatusDate, EmailChannelOptStatusDate, ModifiedDate, JoinDate, FAN_CLUB_2013, LEGENDS_2013, STH_2013, SUITES_2013, WAITLIST_2013, FAN_CLUB_2014, LEGENDS_Q1_2014, LEGENDS_Q2_2014, LEGENDS_Q3_2014, LEGENDS_Q4_2014, STH_Q1_2014, STH_Q2_2014, STH_Q3_2014, STH_Q4_2014, SUITES_Q1_2014, SUITES_Q2_2014, SUITES_Q3_2014, SUITES_Q4_2014, WL_Q1_2014, WL_Q2_2014, WL_Q3_2014, WL_Q4_2014, FAN_CLUB_2015, STH_Q1_2015, STH_Q2_2015, STH_Q3_2015, STH_Q4_2015, SUITES_Q1_2015, SUITES_Q2_2015, SUITES_Q3_2015, SUITES_Q4_2015, WL_Q1_2015, WL_Q2_2015, WL_Q3_2015, WL_Q4_2015, STH_Q1_2016, STH_Q2_2016, SUITES_Q1_2016, SUITES_Q2_2016, WL_Q1_2016, WL_Q2_2016, ATTEND_5K, AddressLine1, AddressLine2, City, Country, CRUISE_ATTEND, DOB, DOB_DAY, DOB_MONTH, DOB_YEAR, DRAFT_PICK_CONTEST, FAVORITEPLAYER, FirstName, GENDER, HEINZ_FIELD_EVENTS, LastName, MENS_FANTASY_CAMP, MENS_FANTASY_CAMP_ATTEND, PREF_5K, PREF_COUNTRY_CONCERTS, PREF_FAN_CLUBS, PREF_HEINZ_FIELD, PREF_LADIES_EVENTS, PREF_MERCH, PREF_NEWSLETTER, PREF_PARTNER_OFFERS, PREF_ROCK_CONCERTS, PREF_SNU, PREF_TEAM_EVENTS, PREF_TR_CAMP, PREF_UPDATE_DT, PREF_YOUTH_CAMPS, PREF_TEAM_NEWS, PREF_CONCERTS, PURCHASEMERCHANDISE, RECORD_SOURCE, SNU_STATUS, State, STH_ACCOUNT_ID, TICKET_TYPE, PostalCode, SNU_ENROLLED_AT, SNU_TIER, SNU_TIER_PREVIOUS_SEASON, SNU_CURRENT_YARDS, SNU_LAST_ACTIVITY_DATE, CURRENT_STH, CURRENT_SUITE, CURRENT_WL, TM_SINGLE_BUYER, TM_CONCERT, EVENTS_ATTENDED, CONTESTS_ENTERED, IS_WIFI_CUSTOMER, IS_MOBILE_APP_CUSTOMER, PRO_SHOP_PURCHASER, PRO_SHOP_LAST_ORDER_DATE, NFL_SHOP_PURCHASER
	, ROW_NUMBER() OVER(PARTITION BY CustomerKey ORDER BY ETL_ID) RowRank
	FROM stg.Epsilon_Profile_Updates
) a
WHERE RowRank = 1
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(AddressLine1),'DBNULL_TEXT') + ISNULL(RTRIM(AddressLine2),'DBNULL_TEXT') + ISNULL(RTRIM(ATTEND_5K),'DBNULL_TEXT') + ISNULL(RTRIM(City),'DBNULL_TEXT') + ISNULL(RTRIM(Country),'DBNULL_TEXT') + ISNULL(RTRIM(CRUISE_ATTEND),'DBNULL_TEXT') + ISNULL(RTRIM(CustomerKey),'DBNULL_TEXT') + ISNULL(RTRIM(DOB),'DBNULL_TEXT') + ISNULL(RTRIM(DOB_DAY),'DBNULL_TEXT') + ISNULL(RTRIM(DOB_MONTH),'DBNULL_TEXT') + ISNULL(RTRIM(DOB_YEAR),'DBNULL_TEXT') + ISNULL(RTRIM(DRAFT_PICK_CONTEST),'DBNULL_TEXT') + ISNULL(RTRIM(EmailAddress),'DBNULL_TEXT') + ISNULL(RTRIM(EmailAddressDeliveryStatus),'DBNULL_TEXT') + ISNULL(RTRIM(EmailAddressDeliveryStatusDate),'DBNULL_TEXT') + ISNULL(RTRIM(EmailChannelOptOutFlag),'DBNULL_TEXT') + ISNULL(RTRIM(EmailChannelOptStatusDate),'DBNULL_TEXT') + ISNULL(RTRIM(FAN_CLUB_2013),'DBNULL_TEXT') + ISNULL(RTRIM(FAN_CLUB_2014),'DBNULL_TEXT') + ISNULL(RTRIM(FAN_CLUB_2015),'DBNULL_TEXT') + ISNULL(RTRIM(FAVORITEPLAYER),'DBNULL_TEXT') + ISNULL(RTRIM(FirstName),'DBNULL_TEXT') + ISNULL(RTRIM(GENDER),'DBNULL_TEXT') + ISNULL(RTRIM(HEINZ_FIELD_EVENTS),'DBNULL_TEXT') + ISNULL(RTRIM(JoinDate),'DBNULL_TEXT') + ISNULL(RTRIM(LastName),'DBNULL_TEXT') + ISNULL(RTRIM(LEGENDS_2013),'DBNULL_TEXT') + ISNULL(RTRIM(LEGENDS_Q1_2014),'DBNULL_TEXT') + ISNULL(RTRIM(LEGENDS_Q2_2014),'DBNULL_TEXT') + ISNULL(RTRIM(LEGENDS_Q3_2014),'DBNULL_TEXT') + ISNULL(RTRIM(LEGENDS_Q4_2014),'DBNULL_TEXT') + ISNULL(RTRIM(MENS_FANTASY_CAMP),'DBNULL_TEXT') + ISNULL(RTRIM(MENS_FANTASY_CAMP_ATTEND),'DBNULL_TEXT') + ISNULL(RTRIM(ModifiedDate),'DBNULL_TEXT') + ISNULL(RTRIM(PostalCode),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_5K),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_CONCERTS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_COUNTRY_CONCERTS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_FAN_CLUBS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_HEINZ_FIELD),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_LADIES_EVENTS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_MERCH),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_NEWSLETTER),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_PARTNER_OFFERS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_ROCK_CONCERTS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_SNU),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_TEAM_EVENTS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_TEAM_NEWS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_TR_CAMP),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_UPDATE_DT),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_YOUTH_CAMPS),'DBNULL_TEXT') + ISNULL(RTRIM(PURCHASEMERCHANDISE),'DBNULL_TEXT') + ISNULL(RTRIM(RECORD_SOURCE),'DBNULL_TEXT') + ISNULL(RTRIM(SNU_STATUS),'DBNULL_TEXT') + ISNULL(RTRIM(State),'DBNULL_TEXT') + ISNULL(RTRIM(STH_2013),'DBNULL_TEXT') + ISNULL(RTRIM(STH_ACCOUNT_ID),'DBNULL_TEXT') + ISNULL(RTRIM(STH_Q1_2014),'DBNULL_TEXT') + ISNULL(RTRIM(STH_Q1_2015),'DBNULL_TEXT') + ISNULL(RTRIM(STH_Q1_2016),'DBNULL_TEXT') + ISNULL(RTRIM(STH_Q2_2014),'DBNULL_TEXT') + ISNULL(RTRIM(STH_Q2_2015),'DBNULL_TEXT') + ISNULL(RTRIM(STH_Q2_2016),'DBNULL_TEXT') + ISNULL(RTRIM(STH_Q3_2014),'DBNULL_TEXT') + ISNULL(RTRIM(STH_Q3_2015),'DBNULL_TEXT') + ISNULL(RTRIM(STH_Q4_2014),'DBNULL_TEXT') + ISNULL(RTRIM(STH_Q4_2015),'DBNULL_TEXT') + ISNULL(RTRIM(SUITES_2013),'DBNULL_TEXT') + ISNULL(RTRIM(SUITES_Q1_2014),'DBNULL_TEXT') + ISNULL(RTRIM(SUITES_Q1_2015),'DBNULL_TEXT') + ISNULL(RTRIM(SUITES_Q1_2016),'DBNULL_TEXT') + ISNULL(RTRIM(SUITES_Q2_2014),'DBNULL_TEXT') + ISNULL(RTRIM(SUITES_Q2_2015),'DBNULL_TEXT') + ISNULL(RTRIM(SUITES_Q2_2016),'DBNULL_TEXT') + ISNULL(RTRIM(SUITES_Q3_2014),'DBNULL_TEXT') + ISNULL(RTRIM(SUITES_Q3_2015),'DBNULL_TEXT') + ISNULL(RTRIM(SUITES_Q4_2014),'DBNULL_TEXT') + ISNULL(RTRIM(SUITES_Q4_2015),'DBNULL_TEXT') + ISNULL(RTRIM(TICKET_TYPE),'DBNULL_TEXT') + ISNULL(RTRIM(WAITLIST_2013),'DBNULL_TEXT') + ISNULL(RTRIM(WL_Q1_2014),'DBNULL_TEXT') + ISNULL(RTRIM(WL_Q1_2015),'DBNULL_TEXT') + ISNULL(RTRIM(WL_Q1_2016),'DBNULL_TEXT') + ISNULL(RTRIM(WL_Q2_2014),'DBNULL_TEXT') + ISNULL(RTRIM(WL_Q2_2015),'DBNULL_TEXT') + ISNULL(RTRIM(WL_Q2_2016),'DBNULL_TEXT') + ISNULL(RTRIM(WL_Q3_2014),'DBNULL_TEXT') + ISNULL(RTRIM(WL_Q3_2015),'DBNULL_TEXT') + ISNULL(RTRIM(WL_Q4_2014),'DBNULL_TEXT') + ISNULL(RTRIM(WL_Q4_2015),'DBNULL_TEXT') + ISNULL(RTRIM(SNU_ENROLLED_AT),'DBNULL_TEXT') + ISNULL(RTRIM(SNU_TIER),'DBNULL_TEXT') + ISNULL(RTRIM(SNU_TIER_PREVIOUS_SEASON),'DBNULL_TEXT') + ISNULL(RTRIM(SNU_CURRENT_YARDS),'DBNULL_TEXT') + ISNULL(RTRIM(SNU_LAST_ACTIVITY_DATE),'DBNULL_TEXT') + ISNULL(RTRIM(CURRENT_STH),'DBNULL_TEXT') + ISNULL(RTRIM(CURRENT_SUITE),'DBNULL_TEXT') + ISNULL(RTRIM(CURRENT_WL),'DBNULL_TEXT') + ISNULL(RTRIM(TM_SINGLE_BUYER),'DBNULL_TEXT') + ISNULL(RTRIM(TM_CONCERT),'DBNULL_TEXT') + ISNULL(RTRIM(EVENTS_ATTENDED),'DBNULL_TEXT') + ISNULL(RTRIM(CONTESTS_ENTERED),'DBNULL_TEXT') + ISNULL(RTRIM(IS_WIFI_CUSTOMER),'DBNULL_TEXT') + ISNULL(RTRIM(IS_MOBILE_APP_CUSTOMER),'DBNULL_TEXT') + ISNULL(RTRIM(PRO_SHOP_PURCHASER),'DBNULL_TEXT') + ISNULL(RTRIM(PRO_SHOP_LAST_ORDER_DATE),'DBNULL_TEXT') + ISNULL(RTRIM(NFL_SHOP_PURCHASER),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (CustomerKey)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId


--	The merge did not perform well when using a non-numeric value as a key, so it was broken down into separate UPDATE and INSERT statements.
UPDATE myTarget 
SET myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
	 , myTarget.[ETL_FileName] = mySource.[ETL_FileName]
     , myTarget.[CustomerKey] = mySource.[CustomerKey]
     , myTarget.[EmailAddress] = mySource.[EmailAddress]
     , myTarget.[EmailAddressDeliveryStatus] = mySource.[EmailAddressDeliveryStatus]
     , myTarget.[EmailChannelOptOutFlag] = mySource.[EmailChannelOptOutFlag]
     , myTarget.[EmailAddressDeliveryStatusDate] = mySource.[EmailAddressDeliveryStatusDate]
     , myTarget.[EmailChannelOptStatusDate] = mySource.[EmailChannelOptStatusDate]
     , myTarget.[ModifiedDate] = mySource.[ModifiedDate]
     , myTarget.[JoinDate] = mySource.[JoinDate]
     , myTarget.[FAN_CLUB_2013] = mySource.[FAN_CLUB_2013]
     , myTarget.[LEGENDS_2013] = mySource.[LEGENDS_2013]
     , myTarget.[STH_2013] = mySource.[STH_2013]
     , myTarget.[SUITES_2013] = mySource.[SUITES_2013]
     , myTarget.[WAITLIST_2013] = mySource.[WAITLIST_2013]
     , myTarget.[FAN_CLUB_2014] = mySource.[FAN_CLUB_2014]
     , myTarget.[LEGENDS_Q1_2014] = mySource.[LEGENDS_Q1_2014]
     , myTarget.[LEGENDS_Q2_2014] = mySource.[LEGENDS_Q2_2014]
     , myTarget.[LEGENDS_Q3_2014] = mySource.[LEGENDS_Q3_2014]
     , myTarget.[LEGENDS_Q4_2014] = mySource.[LEGENDS_Q4_2014]
     , myTarget.[STH_Q1_2014] = mySource.[STH_Q1_2014]
     , myTarget.[STH_Q2_2014] = mySource.[STH_Q2_2014]
     , myTarget.[STH_Q3_2014] = mySource.[STH_Q3_2014]
     , myTarget.[STH_Q4_2014] = mySource.[STH_Q4_2014]
     , myTarget.[SUITES_Q1_2014] = mySource.[SUITES_Q1_2014]
     , myTarget.[SUITES_Q2_2014] = mySource.[SUITES_Q2_2014]
     , myTarget.[SUITES_Q3_2014] = mySource.[SUITES_Q3_2014]
     , myTarget.[SUITES_Q4_2014] = mySource.[SUITES_Q4_2014]
     , myTarget.[WL_Q1_2014] = mySource.[WL_Q1_2014]
     , myTarget.[WL_Q2_2014] = mySource.[WL_Q2_2014]
     , myTarget.[WL_Q3_2014] = mySource.[WL_Q3_2014]
     , myTarget.[WL_Q4_2014] = mySource.[WL_Q4_2014]
     , myTarget.[FAN_CLUB_2015] = mySource.[FAN_CLUB_2015]
     , myTarget.[STH_Q1_2015] = mySource.[STH_Q1_2015]
     , myTarget.[STH_Q2_2015] = mySource.[STH_Q2_2015]
     , myTarget.[STH_Q3_2015] = mySource.[STH_Q3_2015]
     , myTarget.[STH_Q4_2015] = mySource.[STH_Q4_2015]
     , myTarget.[SUITES_Q1_2015] = mySource.[SUITES_Q1_2015]
     , myTarget.[SUITES_Q2_2015] = mySource.[SUITES_Q2_2015]
     , myTarget.[SUITES_Q3_2015] = mySource.[SUITES_Q3_2015]
     , myTarget.[SUITES_Q4_2015] = mySource.[SUITES_Q4_2015]
     , myTarget.[WL_Q1_2015] = mySource.[WL_Q1_2015]
     , myTarget.[WL_Q2_2015] = mySource.[WL_Q2_2015]
     , myTarget.[WL_Q3_2015] = mySource.[WL_Q3_2015]
     , myTarget.[WL_Q4_2015] = mySource.[WL_Q4_2015]
     , myTarget.[STH_Q1_2016] = mySource.[STH_Q1_2016]
     , myTarget.[STH_Q2_2016] = mySource.[STH_Q2_2016]
     , myTarget.[SUITES_Q1_2016] = mySource.[SUITES_Q1_2016]
     , myTarget.[SUITES_Q2_2016] = mySource.[SUITES_Q2_2016]
     , myTarget.[WL_Q1_2016] = mySource.[WL_Q1_2016]
     , myTarget.[WL_Q2_2016] = mySource.[WL_Q2_2016]
     , myTarget.[ATTEND_5K] = mySource.[ATTEND_5K]
     , myTarget.[AddressLine1] = mySource.[AddressLine1]
     , myTarget.[AddressLine2] = mySource.[AddressLine2]
     , myTarget.[City] = mySource.[City]
     , myTarget.[Country] = mySource.[Country]
     , myTarget.[CRUISE_ATTEND] = mySource.[CRUISE_ATTEND]
     , myTarget.[DOB] = mySource.[DOB]
     , myTarget.[DOB_DAY] = mySource.[DOB_DAY]
     , myTarget.[DOB_MONTH] = mySource.[DOB_MONTH]
     , myTarget.[DOB_YEAR] = mySource.[DOB_YEAR]
     , myTarget.[DRAFT_PICK_CONTEST] = mySource.[DRAFT_PICK_CONTEST]
     , myTarget.[FAVORITEPLAYER] = mySource.[FAVORITEPLAYER]
     , myTarget.[FirstName] = mySource.[FirstName]
     , myTarget.[GENDER] = mySource.[GENDER]
     , myTarget.[HEINZ_FIELD_EVENTS] = mySource.[HEINZ_FIELD_EVENTS]
     , myTarget.[LastName] = mySource.[LastName]
     , myTarget.[MENS_FANTASY_CAMP] = mySource.[MENS_FANTASY_CAMP]
     , myTarget.[MENS_FANTASY_CAMP_ATTEND] = mySource.[MENS_FANTASY_CAMP_ATTEND]
     , myTarget.[PREF_5K] = mySource.[PREF_5K]
     , myTarget.[PREF_COUNTRY_CONCERTS] = mySource.[PREF_COUNTRY_CONCERTS]
     , myTarget.[PREF_FAN_CLUBS] = mySource.[PREF_FAN_CLUBS]
     , myTarget.[PREF_HEINZ_FIELD] = mySource.[PREF_HEINZ_FIELD]
     , myTarget.[PREF_LADIES_EVENTS] = mySource.[PREF_LADIES_EVENTS]
     , myTarget.[PREF_MERCH] = mySource.[PREF_MERCH]
     , myTarget.[PREF_NEWSLETTER] = mySource.[PREF_NEWSLETTER]
     , myTarget.[PREF_PARTNER_OFFERS] = mySource.[PREF_PARTNER_OFFERS]
     , myTarget.[PREF_ROCK_CONCERTS] = mySource.[PREF_ROCK_CONCERTS]
     , myTarget.[PREF_SNU] = mySource.[PREF_SNU]
     , myTarget.[PREF_TEAM_EVENTS] = mySource.[PREF_TEAM_EVENTS]
     , myTarget.[PREF_TR_CAMP] = mySource.[PREF_TR_CAMP]
     , myTarget.[PREF_UPDATE_DT] = mySource.[PREF_UPDATE_DT]
     , myTarget.[PREF_YOUTH_CAMPS] = mySource.[PREF_YOUTH_CAMPS]
     , myTarget.[PREF_TEAM_NEWS] = mySource.[PREF_TEAM_NEWS]
     , myTarget.[PREF_CONCERTS] = mySource.[PREF_CONCERTS]
     , myTarget.[PURCHASEMERCHANDISE] = mySource.[PURCHASEMERCHANDISE]
     , myTarget.[RECORD_SOURCE] = mySource.[RECORD_SOURCE]
     , myTarget.[SNU_STATUS] = mySource.[SNU_STATUS]
     , myTarget.[State] = mySource.[State]
     , myTarget.[STH_ACCOUNT_ID] = mySource.[STH_ACCOUNT_ID]
     , myTarget.[TICKET_TYPE] = mySource.[TICKET_TYPE]
     , myTarget.[PostalCode] = mySource.[PostalCode]
	 , myTarget.[SNU_ENROLLED_AT] = mySource.[SNU_ENROLLED_AT]
	 , myTarget.[SNU_TIER] = mySource.[SNU_TIER]
	 , myTarget.[SNU_TIER_PREVIOUS_SEASON] = mySource.[SNU_TIER_PREVIOUS_SEASON]
	 , myTarget.[SNU_CURRENT_YARDS] = mySource.[SNU_CURRENT_YARDS]
	 , myTarget.[SNU_LAST_ACTIVITY_DATE] = mySource.[SNU_LAST_ACTIVITY_DATE]
	 , myTarget.[CURRENT_STH] = mySource.[CURRENT_STH]
	 , myTarget.[CURRENT_SUITE] = mySource.[CURRENT_SUITE]
	 , myTarget.[CURRENT_WL] = mySource.[CURRENT_WL]
	 , myTarget.[TM_SINGLE_BUYER] = mySource.[TM_SINGLE_BUYER]
	 , myTarget.[TM_CONCERT] = mySource.[TM_CONCERT]
	 , myTarget.[EVENTS_ATTENDED] = mySource.[EVENTS_ATTENDED]
	 , myTarget.[CONTESTS_ENTERED] = mySource.[CONTESTS_ENTERED]
	 , myTarget.[IS_WIFI_CUSTOMER] = mySource.[IS_WIFI_CUSTOMER]
	 , myTarget.[IS_MOBILE_APP_CUSTOMER] = mySource.[IS_MOBILE_APP_CUSTOMER]
	 , myTarget.[PRO_SHOP_PURCHASER] = mySource.[PRO_SHOP_PURCHASER]
	 , myTarget.[PRO_SHOP_LAST_ORDER_DATE] = mySource.[PRO_SHOP_LAST_ORDER_DATE]
	 , myTarget.[NFL_SHOP_PURCHASER] = mySource.[NFL_SHOP_PURCHASER]
from ods.Epsilon_Profile_Updates AS myTarget
join #SrcData AS mySource
ON myTarget.CustomerKey = mySource.CustomerKey
WHERE ISNULL(myTarget.ETL_DeltaHashKey,-1) <> ISNULL(mySource.ETL_DeltaHashKey,-1)
;


INSERT ods.Epsilon_Profile_Updates
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ETL_FileName]
     ,[CustomerKey]
     ,[EmailAddress]
     ,[EmailAddressDeliveryStatus]
     ,[EmailChannelOptOutFlag]
     ,[EmailAddressDeliveryStatusDate]
     ,[EmailChannelOptStatusDate]
     ,[ModifiedDate]
     ,[JoinDate]
     ,[FAN_CLUB_2013]
     ,[LEGENDS_2013]
     ,[STH_2013]
     ,[SUITES_2013]
     ,[WAITLIST_2013]
     ,[FAN_CLUB_2014]
     ,[LEGENDS_Q1_2014]
     ,[LEGENDS_Q2_2014]
     ,[LEGENDS_Q3_2014]
     ,[LEGENDS_Q4_2014]
     ,[STH_Q1_2014]
     ,[STH_Q2_2014]
     ,[STH_Q3_2014]
     ,[STH_Q4_2014]
     ,[SUITES_Q1_2014]
     ,[SUITES_Q2_2014]
     ,[SUITES_Q3_2014]
     ,[SUITES_Q4_2014]
     ,[WL_Q1_2014]
     ,[WL_Q2_2014]
     ,[WL_Q3_2014]
     ,[WL_Q4_2014]
     ,[FAN_CLUB_2015]
     ,[STH_Q1_2015]
     ,[STH_Q2_2015]
     ,[STH_Q3_2015]
     ,[STH_Q4_2015]
     ,[SUITES_Q1_2015]
     ,[SUITES_Q2_2015]
     ,[SUITES_Q3_2015]
     ,[SUITES_Q4_2015]
     ,[WL_Q1_2015]
     ,[WL_Q2_2015]
     ,[WL_Q3_2015]
     ,[WL_Q4_2015]
     ,[STH_Q1_2016]
     ,[STH_Q2_2016]
     ,[SUITES_Q1_2016]
     ,[SUITES_Q2_2016]
     ,[WL_Q1_2016]
     ,[WL_Q2_2016]
     ,[ATTEND_5K]
     ,[AddressLine1]
     ,[AddressLine2]
     ,[City]
     ,[Country]
     ,[CRUISE_ATTEND]
     ,[DOB]
     ,[DOB_DAY]
     ,[DOB_MONTH]
     ,[DOB_YEAR]
     ,[DRAFT_PICK_CONTEST]
     ,[FAVORITEPLAYER]
     ,[FirstName]
     ,[GENDER]
     ,[HEINZ_FIELD_EVENTS]
     ,[LastName]
     ,[MENS_FANTASY_CAMP]
     ,[MENS_FANTASY_CAMP_ATTEND]
     ,[PREF_5K]
     ,[PREF_COUNTRY_CONCERTS]
     ,[PREF_FAN_CLUBS]
     ,[PREF_HEINZ_FIELD]
     ,[PREF_LADIES_EVENTS]
     ,[PREF_MERCH]
     ,[PREF_NEWSLETTER]
     ,[PREF_PARTNER_OFFERS]
     ,[PREF_ROCK_CONCERTS]
     ,[PREF_SNU]
     ,[PREF_TEAM_EVENTS]
     ,[PREF_TR_CAMP]
     ,[PREF_UPDATE_DT]
     ,[PREF_YOUTH_CAMPS]
     ,[PREF_TEAM_NEWS]
     ,[PREF_CONCERTS]
     ,[PURCHASEMERCHANDISE]
     ,[RECORD_SOURCE]
     ,[SNU_STATUS]
     ,[State]
     ,[STH_ACCOUNT_ID]
     ,[TICKET_TYPE]
     ,[PostalCode]
	 ,[SNU_ENROLLED_AT]
	 ,[SNU_TIER]
	 ,[SNU_TIER_PREVIOUS_SEASON]
	 ,[SNU_CURRENT_YARDS]
	 ,[SNU_LAST_ACTIVITY_DATE]
	 ,[CURRENT_STH]
	 ,[CURRENT_SUITE]
	 ,[CURRENT_WL]
	 ,[TM_SINGLE_BUYER]
	 ,[TM_CONCERT]
	 ,[EVENTS_ATTENDED]
	 ,[CONTESTS_ENTERED]
	 ,[IS_WIFI_CUSTOMER]
	 ,[IS_MOBILE_APP_CUSTOMER]
	 ,[PRO_SHOP_PURCHASER]
	 ,[PRO_SHOP_LAST_ORDER_DATE]
	 ,[NFL_SHOP_PURCHASER]
     )
select @RunTime	--ETL_CreatedDate
     ,@RunTime	--ETL_UpdateddDate
     ,0			--ETL_IsDeleted
     ,NULL		--ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
	 ,mySource.[ETL_FileName]
     ,mySource.[CustomerKey]
     ,mySource.[EmailAddress]
     ,mySource.[EmailAddressDeliveryStatus]
     ,mySource.[EmailChannelOptOutFlag]
     ,mySource.[EmailAddressDeliveryStatusDate]
     ,mySource.[EmailChannelOptStatusDate]
     ,mySource.[ModifiedDate]
     ,mySource.[JoinDate]
     ,mySource.[FAN_CLUB_2013]
     ,mySource.[LEGENDS_2013]
     ,mySource.[STH_2013]
     ,mySource.[SUITES_2013]
     ,mySource.[WAITLIST_2013]
     ,mySource.[FAN_CLUB_2014]
     ,mySource.[LEGENDS_Q1_2014]
     ,mySource.[LEGENDS_Q2_2014]
     ,mySource.[LEGENDS_Q3_2014]
     ,mySource.[LEGENDS_Q4_2014]
     ,mySource.[STH_Q1_2014]
     ,mySource.[STH_Q2_2014]
     ,mySource.[STH_Q3_2014]
     ,mySource.[STH_Q4_2014]
     ,mySource.[SUITES_Q1_2014]
     ,mySource.[SUITES_Q2_2014]
     ,mySource.[SUITES_Q3_2014]
     ,mySource.[SUITES_Q4_2014]
     ,mySource.[WL_Q1_2014]
     ,mySource.[WL_Q2_2014]
     ,mySource.[WL_Q3_2014]
     ,mySource.[WL_Q4_2014]
     ,mySource.[FAN_CLUB_2015]
     ,mySource.[STH_Q1_2015]
     ,mySource.[STH_Q2_2015]
     ,mySource.[STH_Q3_2015]
     ,mySource.[STH_Q4_2015]
     ,mySource.[SUITES_Q1_2015]
     ,mySource.[SUITES_Q2_2015]
     ,mySource.[SUITES_Q3_2015]
     ,mySource.[SUITES_Q4_2015]
     ,mySource.[WL_Q1_2015]
     ,mySource.[WL_Q2_2015]
     ,mySource.[WL_Q3_2015]
     ,mySource.[WL_Q4_2015]
     ,mySource.[STH_Q1_2016]
     ,mySource.[STH_Q2_2016]
     ,mySource.[SUITES_Q1_2016]
     ,mySource.[SUITES_Q2_2016]
     ,mySource.[WL_Q1_2016]
     ,mySource.[WL_Q2_2016]
     ,mySource.[ATTEND_5K]
     ,mySource.[AddressLine1]
     ,mySource.[AddressLine2]
     ,mySource.[City]
     ,mySource.[Country]
     ,mySource.[CRUISE_ATTEND]
     ,mySource.[DOB]
     ,mySource.[DOB_DAY]
     ,mySource.[DOB_MONTH]
     ,mySource.[DOB_YEAR]
     ,mySource.[DRAFT_PICK_CONTEST]
     ,mySource.[FAVORITEPLAYER]
     ,mySource.[FirstName]
     ,mySource.[GENDER]
     ,mySource.[HEINZ_FIELD_EVENTS]
     ,mySource.[LastName]
     ,mySource.[MENS_FANTASY_CAMP]
     ,mySource.[MENS_FANTASY_CAMP_ATTEND]
     ,mySource.[PREF_5K]
     ,mySource.[PREF_COUNTRY_CONCERTS]
     ,mySource.[PREF_FAN_CLUBS]
     ,mySource.[PREF_HEINZ_FIELD]
     ,mySource.[PREF_LADIES_EVENTS]
     ,mySource.[PREF_MERCH]
     ,mySource.[PREF_NEWSLETTER]
     ,mySource.[PREF_PARTNER_OFFERS]
     ,mySource.[PREF_ROCK_CONCERTS]
     ,mySource.[PREF_SNU]
     ,mySource.[PREF_TEAM_EVENTS]
     ,mySource.[PREF_TR_CAMP]
     ,mySource.[PREF_UPDATE_DT]
     ,mySource.[PREF_YOUTH_CAMPS]
     ,mySource.[PREF_TEAM_NEWS]
     ,mySource.[PREF_CONCERTS]
     ,mySource.[PURCHASEMERCHANDISE]
     ,mySource.[RECORD_SOURCE]
     ,mySource.[SNU_STATUS]
     ,mySource.[State]
     ,mySource.[STH_ACCOUNT_ID]
     ,mySource.[TICKET_TYPE]
     ,mySource.[PostalCode]
	 ,mySource.[SNU_ENROLLED_AT]
	 ,mySource.[SNU_TIER]
	 ,mySource.[SNU_TIER_PREVIOUS_SEASON]
	 ,mySource.[SNU_CURRENT_YARDS]
	 ,mySource.[SNU_LAST_ACTIVITY_DATE]
	 ,mySource.[CURRENT_STH]
	 ,mySource.[CURRENT_SUITE]
	 ,mySource.[CURRENT_WL]
	 ,mySource.[TM_SINGLE_BUYER]
	 ,mySource.[TM_CONCERT]
	 ,mySource.[EVENTS_ATTENDED]
	 ,mySource.[CONTESTS_ENTERED]
	 ,mySource.[IS_WIFI_CUSTOMER]
	 ,mySource.[IS_MOBILE_APP_CUSTOMER]
	 ,mySource.[PRO_SHOP_PURCHASER]
	 ,mySource.[PRO_SHOP_LAST_ORDER_DATE]
	 ,mySource.[NFL_SHOP_PURCHASER]
from #SrcData as mySource
left join ods.Epsilon_Profile_Updates AS myTarget
ON myTarget.CustomerKey = mySource.CustomerKey
WHERE myTarget.CustomerKey IS NULL
;


EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Epsilon_Profile_Updates WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Epsilon_Profile_Updates WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Insert Row Count', @MergeInsertRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Update Row Count', @MergeUpdateRowCount, @ExecutionId


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.LogEventRecordDB @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId


END




GO
