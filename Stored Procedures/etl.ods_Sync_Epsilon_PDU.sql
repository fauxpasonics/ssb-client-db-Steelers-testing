SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[ods_Sync_Epsilon_PDU]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = NULL
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\dhorstman
Date:     03/10/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Epsilon_PDU),'0');	
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

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
,  PK, EM, NUM_SENT, NUM_FTD, NUM_CLICK, OPTOUT_FLG, LAST_SENT_DTTM, FTD_DTTM, CLICK_DTTM, HTML_OPEN_DTTM, OPTOUT_DTTM, MODIFIED_DTTM, CREATED_DTTM, [2013_FAN_CLUB], [2013_LEGENDS], [2013_STH], [2013_SUITES], [2013_WAITLIST], [2014_FAN_CLUB], [2014_LEGENDS_Q1], [2014_LEGENDS_Q2], [2014_LEGENDS_Q3], [2014_LEGENDS_Q4], [2014_STH_Q1], [2014_STH_Q2], [2014_STH_Q3], [2014_STH_Q4], [2014_SUITES_Q1], [2014_SUITES_Q2], [2014_SUITES_Q3], [2014_SUITES_Q4], [2014_WL_Q1], [2014_WL_Q2], [2014_WL_Q3], [2014_WL_Q4], [2015_FAN_CLUB], [2015_STH_Q1], [2015_STH_Q2], [2015_STH_Q3], [2015_STH_Q4], [2015_SUITES_Q1], [2015_SUITES_Q2], [2015_SUITES_Q3], [2015_SUITES_Q4], [2015_WL_Q1], [2015_WL_Q2], [2015_WL_Q3], [2015_WL_Q4], [2016_STH_Q1], [2016_STH_Q2], [2016_SUITES_Q1], [2016_SUITES_Q2], [2016_WL_Q1], [2016_WL_Q2], [5K_ATTEND], ADDRESS1, ADDRESS2, CITY, COUNTRY, CRUISE_ATTEND, DOB, DOB_DAY, DOB_MONTH, DOB_YEAR, DRAFT_PICK_CONTEST, FAVORITEPLAYER, FIRSTNAME, GENDER, HEINZ_FIELD_EVENTS, LASTNAME, MENS_FANTASY_CAMP, MENS_FANTASY_CAMP_ATTEND, PREF_5K, PREF_COUNTRY_CONCERTS, PREF_FAN_CLUBS, PREF_HEINZ_FIELD, PREF_LADIES_EVENTS, PREF_MERCH, PREF_NEWSLETTER, PREF_PARTNER_OFFERS, PREF_ROCK_CONCERTS, PREF_SNU, PREF_TEAM_EVENTS, PREF_TR_CAMP, PREF_UPDATE_DT, PREF_YOUTH_CAMPS, PURCHASEMERCHANDISE, RECORD_SOURCE, SNU_STATUS, STATE, STH_ACCOUNT_ID, TICKET_TYPE, ZIPCODE
INTO #SrcData
FROM (
	SELECT  PK, EM, NUM_SENT, NUM_FTD, NUM_CLICK, OPTOUT_FLG, LAST_SENT_DTTM, FTD_DTTM, CLICK_DTTM, HTML_OPEN_DTTM, OPTOUT_DTTM, MODIFIED_DTTM, CREATED_DTTM, [2013_FAN_CLUB], [2013_LEGENDS], [2013_STH], [2013_SUITES], [2013_WAITLIST], [2014_FAN_CLUB], [2014_LEGENDS_Q1], [2014_LEGENDS_Q2], [2014_LEGENDS_Q3], [2014_LEGENDS_Q4], [2014_STH_Q1], [2014_STH_Q2], [2014_STH_Q3], [2014_STH_Q4], [2014_SUITES_Q1], [2014_SUITES_Q2], [2014_SUITES_Q3], [2014_SUITES_Q4], [2014_WL_Q1], [2014_WL_Q2], [2014_WL_Q3], [2014_WL_Q4], [2015_FAN_CLUB], [2015_STH_Q1], [2015_STH_Q2], [2015_STH_Q3], [2015_STH_Q4], [2015_SUITES_Q1], [2015_SUITES_Q2], [2015_SUITES_Q3], [2015_SUITES_Q4], [2015_WL_Q1], [2015_WL_Q2], [2015_WL_Q3], [2015_WL_Q4], [2016_STH_Q1], [2016_STH_Q2], [2016_SUITES_Q1], [2016_SUITES_Q2], [2016_WL_Q1], [2016_WL_Q2], [5K_ATTEND], ADDRESS1, ADDRESS2, CITY, COUNTRY, CRUISE_ATTEND, DOB, DOB_DAY, DOB_MONTH, DOB_YEAR, DRAFT_PICK_CONTEST, FAVORITEPLAYER, FIRSTNAME, GENDER, HEINZ_FIELD_EVENTS, LASTNAME, MENS_FANTASY_CAMP, MENS_FANTASY_CAMP_ATTEND, PREF_5K, PREF_COUNTRY_CONCERTS, PREF_FAN_CLUBS, PREF_HEINZ_FIELD, PREF_LADIES_EVENTS, PREF_MERCH, PREF_NEWSLETTER, PREF_PARTNER_OFFERS, PREF_ROCK_CONCERTS, PREF_SNU, PREF_TEAM_EVENTS, PREF_TR_CAMP, PREF_UPDATE_DT, PREF_YOUTH_CAMPS, PURCHASEMERCHANDISE, RECORD_SOURCE, SNU_STATUS, STATE, STH_ACCOUNT_ID, TICKET_TYPE, ZIPCODE
	, ROW_NUMBER() OVER(PARTITION BY PK ORDER BY ETL_ID) RowRank
	FROM src.Epsilon_PDU
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM([2013_FAN_CLUB]),'DBNULL_TEXT') + ISNULL(RTRIM([2013_LEGENDS]),'DBNULL_TEXT') + ISNULL(RTRIM([2013_STH]),'DBNULL_TEXT') + ISNULL(RTRIM([2013_SUITES]),'DBNULL_TEXT') + ISNULL(RTRIM([2013_WAITLIST]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_FAN_CLUB]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_LEGENDS_Q1]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_LEGENDS_Q2]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_LEGENDS_Q3]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_LEGENDS_Q4]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_STH_Q1]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_STH_Q2]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_STH_Q3]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_STH_Q4]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_SUITES_Q1]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_SUITES_Q2]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_SUITES_Q3]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_SUITES_Q4]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_WL_Q1]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_WL_Q2]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_WL_Q3]),'DBNULL_TEXT') + ISNULL(RTRIM([2014_WL_Q4]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_FAN_CLUB]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_STH_Q1]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_STH_Q2]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_STH_Q3]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_STH_Q4]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_SUITES_Q1]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_SUITES_Q2]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_SUITES_Q3]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_SUITES_Q4]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_WL_Q1]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_WL_Q2]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_WL_Q3]),'DBNULL_TEXT') + ISNULL(RTRIM([2015_WL_Q4]),'DBNULL_TEXT') + ISNULL(RTRIM([2016_STH_Q1]),'DBNULL_TEXT') + ISNULL(RTRIM([2016_STH_Q2]),'DBNULL_TEXT') + ISNULL(RTRIM([2016_SUITES_Q1]),'DBNULL_TEXT') + ISNULL(RTRIM([2016_SUITES_Q2]),'DBNULL_TEXT') + ISNULL(RTRIM([2016_WL_Q1]),'DBNULL_TEXT') + ISNULL(RTRIM([2016_WL_Q2]),'DBNULL_TEXT') + ISNULL(RTRIM([5K_ATTEND]),'DBNULL_TEXT') + ISNULL(RTRIM(ADDRESS1),'DBNULL_TEXT') + ISNULL(RTRIM(ADDRESS2),'DBNULL_TEXT') + ISNULL(RTRIM(CITY),'DBNULL_TEXT') + ISNULL(RTRIM(CLICK_DTTM),'DBNULL_TEXT') + ISNULL(RTRIM(COUNTRY),'DBNULL_TEXT') + ISNULL(RTRIM(CREATED_DTTM),'DBNULL_TEXT') + ISNULL(RTRIM(CRUISE_ATTEND),'DBNULL_TEXT') + ISNULL(RTRIM(DOB),'DBNULL_TEXT') + ISNULL(RTRIM(DOB_DAY),'DBNULL_TEXT') + ISNULL(RTRIM(DOB_MONTH),'DBNULL_TEXT') + ISNULL(RTRIM(DOB_YEAR),'DBNULL_TEXT') + ISNULL(RTRIM(DRAFT_PICK_CONTEST),'DBNULL_TEXT') + ISNULL(RTRIM(EM),'DBNULL_TEXT') + ISNULL(RTRIM(FAVORITEPLAYER),'DBNULL_TEXT') + ISNULL(RTRIM(FIRSTNAME),'DBNULL_TEXT') + ISNULL(RTRIM(FTD_DTTM),'DBNULL_TEXT') + ISNULL(RTRIM(GENDER),'DBNULL_TEXT') + ISNULL(RTRIM(HEINZ_FIELD_EVENTS),'DBNULL_TEXT') + ISNULL(RTRIM(HTML_OPEN_DTTM),'DBNULL_TEXT') + ISNULL(RTRIM(LAST_SENT_DTTM),'DBNULL_TEXT') + ISNULL(RTRIM(LASTNAME),'DBNULL_TEXT') + ISNULL(RTRIM(MENS_FANTASY_CAMP),'DBNULL_TEXT') + ISNULL(RTRIM(MENS_FANTASY_CAMP_ATTEND),'DBNULL_TEXT') + ISNULL(RTRIM(MODIFIED_DTTM),'DBNULL_TEXT') + ISNULL(RTRIM(NUM_CLICK),'DBNULL_TEXT') + ISNULL(RTRIM(NUM_FTD),'DBNULL_TEXT') + ISNULL(RTRIM(NUM_SENT),'DBNULL_TEXT') + ISNULL(RTRIM(OPTOUT_DTTM),'DBNULL_TEXT') + ISNULL(RTRIM(OPTOUT_FLG),'DBNULL_TEXT') + ISNULL(RTRIM(PK),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_5K),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_COUNTRY_CONCERTS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_FAN_CLUBS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_HEINZ_FIELD),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_LADIES_EVENTS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_MERCH),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_NEWSLETTER),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_PARTNER_OFFERS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_ROCK_CONCERTS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_SNU),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_TEAM_EVENTS),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_TR_CAMP),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_UPDATE_DT),'DBNULL_TEXT') + ISNULL(RTRIM(PREF_YOUTH_CAMPS),'DBNULL_TEXT') + ISNULL(RTRIM(PURCHASEMERCHANDISE),'DBNULL_TEXT') + ISNULL(RTRIM(RECORD_SOURCE),'DBNULL_TEXT') + ISNULL(RTRIM(SNU_STATUS),'DBNULL_TEXT') + ISNULL(RTRIM(STATE),'DBNULL_TEXT') + ISNULL(RTRIM(STH_ACCOUNT_ID),'DBNULL_TEXT') + ISNULL(RTRIM(TICKET_TYPE),'DBNULL_TEXT') + ISNULL(RTRIM(ZIPCODE),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (PK)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Epsilon_PDU AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.PK = mySource.PK

WHEN MATCHED 
--AND @DisableUpdate = 'false' AND (
AND (
	ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[PK] = mySource.[PK]
     , myTarget.[EM] = mySource.[EM]
     , myTarget.[NUM_SENT] = mySource.[NUM_SENT]
     , myTarget.[NUM_FTD] = mySource.[NUM_FTD]
     , myTarget.[NUM_CLICK] = mySource.[NUM_CLICK]
     , myTarget.[OPTOUT_FLG] = mySource.[OPTOUT_FLG]
     , myTarget.[LAST_SENT_DTTM] = mySource.[LAST_SENT_DTTM]
     , myTarget.[FTD_DTTM] = mySource.[FTD_DTTM]
     , myTarget.[CLICK_DTTM] = mySource.[CLICK_DTTM]
     , myTarget.[HTML_OPEN_DTTM] = mySource.[HTML_OPEN_DTTM]
     , myTarget.[OPTOUT_DTTM] = mySource.[OPTOUT_DTTM]
     , myTarget.[MODIFIED_DTTM] = mySource.[MODIFIED_DTTM]
     , myTarget.[CREATED_DTTM] = mySource.[CREATED_DTTM]
     , myTarget.[2013_FAN_CLUB] = mySource.[2013_FAN_CLUB]
     , myTarget.[2013_LEGENDS] = mySource.[2013_LEGENDS]
     , myTarget.[2013_STH] = mySource.[2013_STH]
     , myTarget.[2013_SUITES] = mySource.[2013_SUITES]
     , myTarget.[2013_WAITLIST] = mySource.[2013_WAITLIST]
     , myTarget.[2014_FAN_CLUB] = mySource.[2014_FAN_CLUB]
     , myTarget.[2014_LEGENDS_Q1] = mySource.[2014_LEGENDS_Q1]
     , myTarget.[2014_LEGENDS_Q2] = mySource.[2014_LEGENDS_Q2]
     , myTarget.[2014_LEGENDS_Q3] = mySource.[2014_LEGENDS_Q3]
     , myTarget.[2014_LEGENDS_Q4] = mySource.[2014_LEGENDS_Q4]
     , myTarget.[2014_STH_Q1] = mySource.[2014_STH_Q1]
     , myTarget.[2014_STH_Q2] = mySource.[2014_STH_Q2]
     , myTarget.[2014_STH_Q3] = mySource.[2014_STH_Q3]
     , myTarget.[2014_STH_Q4] = mySource.[2014_STH_Q4]
     , myTarget.[2014_SUITES_Q1] = mySource.[2014_SUITES_Q1]
     , myTarget.[2014_SUITES_Q2] = mySource.[2014_SUITES_Q2]
     , myTarget.[2014_SUITES_Q3] = mySource.[2014_SUITES_Q3]
     , myTarget.[2014_SUITES_Q4] = mySource.[2014_SUITES_Q4]
     , myTarget.[2014_WL_Q1] = mySource.[2014_WL_Q1]
     , myTarget.[2014_WL_Q2] = mySource.[2014_WL_Q2]
     , myTarget.[2014_WL_Q3] = mySource.[2014_WL_Q3]
     , myTarget.[2014_WL_Q4] = mySource.[2014_WL_Q4]
     , myTarget.[2015_FAN_CLUB] = mySource.[2015_FAN_CLUB]
     , myTarget.[2015_STH_Q1] = mySource.[2015_STH_Q1]
     , myTarget.[2015_STH_Q2] = mySource.[2015_STH_Q2]
     , myTarget.[2015_STH_Q3] = mySource.[2015_STH_Q3]
     , myTarget.[2015_STH_Q4] = mySource.[2015_STH_Q4]
     , myTarget.[2015_SUITES_Q1] = mySource.[2015_SUITES_Q1]
     , myTarget.[2015_SUITES_Q2] = mySource.[2015_SUITES_Q2]
     , myTarget.[2015_SUITES_Q3] = mySource.[2015_SUITES_Q3]
     , myTarget.[2015_SUITES_Q4] = mySource.[2015_SUITES_Q4]
     , myTarget.[2015_WL_Q1] = mySource.[2015_WL_Q1]
     , myTarget.[2015_WL_Q2] = mySource.[2015_WL_Q2]
     , myTarget.[2015_WL_Q3] = mySource.[2015_WL_Q3]
     , myTarget.[2015_WL_Q4] = mySource.[2015_WL_Q4]
     , myTarget.[2016_STH_Q1] = mySource.[2016_STH_Q1]
     , myTarget.[2016_STH_Q2] = mySource.[2016_STH_Q2]
     , myTarget.[2016_SUITES_Q1] = mySource.[2016_SUITES_Q1]
     , myTarget.[2016_SUITES_Q2] = mySource.[2016_SUITES_Q2]
     , myTarget.[2016_WL_Q1] = mySource.[2016_WL_Q1]
     , myTarget.[2016_WL_Q2] = mySource.[2016_WL_Q2]
     , myTarget.[5K_ATTEND] = mySource.[5K_ATTEND]
     , myTarget.[ADDRESS1] = mySource.[ADDRESS1]
     , myTarget.[ADDRESS2] = mySource.[ADDRESS2]
     , myTarget.[CITY] = mySource.[CITY]
     , myTarget.[COUNTRY] = mySource.[COUNTRY]
     , myTarget.[CRUISE_ATTEND] = mySource.[CRUISE_ATTEND]
     , myTarget.[DOB] = mySource.[DOB]
     , myTarget.[DOB_DAY] = mySource.[DOB_DAY]
     , myTarget.[DOB_MONTH] = mySource.[DOB_MONTH]
     , myTarget.[DOB_YEAR] = mySource.[DOB_YEAR]
     , myTarget.[DRAFT_PICK_CONTEST] = mySource.[DRAFT_PICK_CONTEST]
     , myTarget.[FAVORITEPLAYER] = mySource.[FAVORITEPLAYER]
     , myTarget.[FIRSTNAME] = mySource.[FIRSTNAME]
     , myTarget.[GENDER] = mySource.[GENDER]
     , myTarget.[HEINZ_FIELD_EVENTS] = mySource.[HEINZ_FIELD_EVENTS]
     , myTarget.[LASTNAME] = mySource.[LASTNAME]
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
     , myTarget.[PURCHASEMERCHANDISE] = mySource.[PURCHASEMERCHANDISE]
     , myTarget.[RECORD_SOURCE] = mySource.[RECORD_SOURCE]
     , myTarget.[SNU_STATUS] = mySource.[SNU_STATUS]
     , myTarget.[STATE] = mySource.[STATE]
     , myTarget.[STH_ACCOUNT_ID] = mySource.[STH_ACCOUNT_ID]
     , myTarget.[TICKET_TYPE] = mySource.[TICKET_TYPE]
     , myTarget.[ZIPCODE] = mySource.[ZIPCODE]
     
--WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY TARGET --AND @DisableInsert = 'false'
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[PK]
     ,[EM]
     ,[NUM_SENT]
     ,[NUM_FTD]
     ,[NUM_CLICK]
     ,[OPTOUT_FLG]
     ,[LAST_SENT_DTTM]
     ,[FTD_DTTM]
     ,[CLICK_DTTM]
     ,[HTML_OPEN_DTTM]
     ,[OPTOUT_DTTM]
     ,[MODIFIED_DTTM]
     ,[CREATED_DTTM]
     ,[2013_FAN_CLUB]
     ,[2013_LEGENDS]
     ,[2013_STH]
     ,[2013_SUITES]
     ,[2013_WAITLIST]
     ,[2014_FAN_CLUB]
     ,[2014_LEGENDS_Q1]
     ,[2014_LEGENDS_Q2]
     ,[2014_LEGENDS_Q3]
     ,[2014_LEGENDS_Q4]
     ,[2014_STH_Q1]
     ,[2014_STH_Q2]
     ,[2014_STH_Q3]
     ,[2014_STH_Q4]
     ,[2014_SUITES_Q1]
     ,[2014_SUITES_Q2]
     ,[2014_SUITES_Q3]
     ,[2014_SUITES_Q4]
     ,[2014_WL_Q1]
     ,[2014_WL_Q2]
     ,[2014_WL_Q3]
     ,[2014_WL_Q4]
     ,[2015_FAN_CLUB]
     ,[2015_STH_Q1]
     ,[2015_STH_Q2]
     ,[2015_STH_Q3]
     ,[2015_STH_Q4]
     ,[2015_SUITES_Q1]
     ,[2015_SUITES_Q2]
     ,[2015_SUITES_Q3]
     ,[2015_SUITES_Q4]
     ,[2015_WL_Q1]
     ,[2015_WL_Q2]
     ,[2015_WL_Q3]
     ,[2015_WL_Q4]
     ,[2016_STH_Q1]
     ,[2016_STH_Q2]
     ,[2016_SUITES_Q1]
     ,[2016_SUITES_Q2]
     ,[2016_WL_Q1]
     ,[2016_WL_Q2]
     ,[5K_ATTEND]
     ,[ADDRESS1]
     ,[ADDRESS2]
     ,[CITY]
     ,[COUNTRY]
     ,[CRUISE_ATTEND]
     ,[DOB]
     ,[DOB_DAY]
     ,[DOB_MONTH]
     ,[DOB_YEAR]
     ,[DRAFT_PICK_CONTEST]
     ,[FAVORITEPLAYER]
     ,[FIRSTNAME]
     ,[GENDER]
     ,[HEINZ_FIELD_EVENTS]
     ,[LASTNAME]
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
     ,[PURCHASEMERCHANDISE]
     ,[RECORD_SOURCE]
     ,[SNU_STATUS]
     ,[STATE]
     ,[STH_ACCOUNT_ID]
     ,[TICKET_TYPE]
     ,[ZIPCODE]
     )
VALUES
     (@RunTime	--ETL_CreatedDate
     ,@RunTime	--ETL_UpdateddDate
     ,0			--ETL_IsDeleted
     ,NULL		--ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[PK]
     ,mySource.[EM]
     ,mySource.[NUM_SENT]
     ,mySource.[NUM_FTD]
     ,mySource.[NUM_CLICK]
     ,mySource.[OPTOUT_FLG]
     ,mySource.[LAST_SENT_DTTM]
     ,mySource.[FTD_DTTM]
     ,mySource.[CLICK_DTTM]
     ,mySource.[HTML_OPEN_DTTM]
     ,mySource.[OPTOUT_DTTM]
     ,mySource.[MODIFIED_DTTM]
     ,mySource.[CREATED_DTTM]
     ,mySource.[2013_FAN_CLUB]
     ,mySource.[2013_LEGENDS]
     ,mySource.[2013_STH]
     ,mySource.[2013_SUITES]
     ,mySource.[2013_WAITLIST]
     ,mySource.[2014_FAN_CLUB]
     ,mySource.[2014_LEGENDS_Q1]
     ,mySource.[2014_LEGENDS_Q2]
     ,mySource.[2014_LEGENDS_Q3]
     ,mySource.[2014_LEGENDS_Q4]
     ,mySource.[2014_STH_Q1]
     ,mySource.[2014_STH_Q2]
     ,mySource.[2014_STH_Q3]
     ,mySource.[2014_STH_Q4]
     ,mySource.[2014_SUITES_Q1]
     ,mySource.[2014_SUITES_Q2]
     ,mySource.[2014_SUITES_Q3]
     ,mySource.[2014_SUITES_Q4]
     ,mySource.[2014_WL_Q1]
     ,mySource.[2014_WL_Q2]
     ,mySource.[2014_WL_Q3]
     ,mySource.[2014_WL_Q4]
     ,mySource.[2015_FAN_CLUB]
     ,mySource.[2015_STH_Q1]
     ,mySource.[2015_STH_Q2]
     ,mySource.[2015_STH_Q3]
     ,mySource.[2015_STH_Q4]
     ,mySource.[2015_SUITES_Q1]
     ,mySource.[2015_SUITES_Q2]
     ,mySource.[2015_SUITES_Q3]
     ,mySource.[2015_SUITES_Q4]
     ,mySource.[2015_WL_Q1]
     ,mySource.[2015_WL_Q2]
     ,mySource.[2015_WL_Q3]
     ,mySource.[2015_WL_Q4]
     ,mySource.[2016_STH_Q1]
     ,mySource.[2016_STH_Q2]
     ,mySource.[2016_SUITES_Q1]
     ,mySource.[2016_SUITES_Q2]
     ,mySource.[2016_WL_Q1]
     ,mySource.[2016_WL_Q2]
     ,mySource.[5K_ATTEND]
     ,mySource.[ADDRESS1]
     ,mySource.[ADDRESS2]
     ,mySource.[CITY]
     ,mySource.[COUNTRY]
     ,mySource.[CRUISE_ATTEND]
     ,mySource.[DOB]
     ,mySource.[DOB_DAY]
     ,mySource.[DOB_MONTH]
     ,mySource.[DOB_YEAR]
     ,mySource.[DRAFT_PICK_CONTEST]
     ,mySource.[FAVORITEPLAYER]
     ,mySource.[FIRSTNAME]
     ,mySource.[GENDER]
     ,mySource.[HEINZ_FIELD_EVENTS]
     ,mySource.[LASTNAME]
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
     ,mySource.[PURCHASEMERCHANDISE]
     ,mySource.[RECORD_SOURCE]
     ,mySource.[SNU_STATUS]
     ,mySource.[STATE]
     ,mySource.[STH_ACCOUNT_ID]
     ,mySource.[TICKET_TYPE]
     ,mySource.[ZIPCODE]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ods.Epsilon_PDU WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ods.Epsilon_PDU WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Insert Row Count', @MergeInsertRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Update Row Count', @MergeUpdateRowCount, @ExecutionId


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
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
