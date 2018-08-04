SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[ods_Sync_Epsilon_ADU]
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
Date:     03/10/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Epsilon_ADU),'0');	
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
,  MAILING_NAME, PROFILE_KEY, EMAIL_ADDR, CONTENT, SOURCE_CODE, ACTION_CODE, SUB_ACTION_CODE, ACTION_DTTM, UNIQUE_FLAG, LINK_NAME, LINK_TAG, ABUSE_DOMAIN, ABUSEOPT_FLG, ABUSE_SUB
INTO #SrcData
FROM (
	SELECT  MAILING_NAME, PROFILE_KEY, EMAIL_ADDR, CONTENT, SOURCE_CODE, ACTION_CODE, SUB_ACTION_CODE, ACTION_DTTM, UNIQUE_FLAG, LINK_NAME, LINK_TAG, ABUSE_DOMAIN, ABUSEOPT_FLG, ABUSE_SUB
	, ROW_NUMBER() OVER(PARTITION BY MAILING_NAME, PROFILE_KEY, EMAIL_ADDR, CONTENT, SOURCE_CODE, ACTION_CODE, SUB_ACTION_CODE, ACTION_DTTM ORDER BY ETL_ID) RowRank
	FROM src.Epsilon_ADU
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(ABUSE_DOMAIN),'DBNULL_TEXT') + ISNULL(RTRIM(ABUSE_SUB),'DBNULL_TEXT') + ISNULL(RTRIM(ABUSEOPT_FLG),'DBNULL_TEXT') + ISNULL(RTRIM(ACTION_CODE),'DBNULL_TEXT') + ISNULL(RTRIM(ACTION_DTTM),'DBNULL_TEXT') + ISNULL(RTRIM(CONTENT),'DBNULL_TEXT') + ISNULL(RTRIM(EMAIL_ADDR),'DBNULL_TEXT') + ISNULL(RTRIM(LINK_NAME),'DBNULL_TEXT') + ISNULL(RTRIM(LINK_TAG),'DBNULL_TEXT') + ISNULL(RTRIM(MAILING_NAME),'DBNULL_TEXT') + ISNULL(RTRIM(PROFILE_KEY),'DBNULL_TEXT') + ISNULL(RTRIM(SOURCE_CODE),'DBNULL_TEXT') + ISNULL(RTRIM(SUB_ACTION_CODE),'DBNULL_TEXT') + ISNULL(RTRIM(UNIQUE_FLAG),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (MAILING_NAME, PROFILE_KEY, EMAIL_ADDR, CONTENT, SOURCE_CODE, ACTION_CODE, SUB_ACTION_CODE, ACTION_DTTM)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Epsilon_ADU AS myTarget
USING (
	SELECT * FROM #SrcData
) AS mySource
	ON myTarget.MAILING_NAME = mySource.MAILING_NAME 
	AND myTarget.PROFILE_KEY = mySource.PROFILE_KEY 
	AND myTarget.EMAIL_ADDR = mySource.EMAIL_ADDR 
	AND myTarget.CONTENT = mySource.CONTENT 
	AND myTarget.SOURCE_CODE = mySource.SOURCE_CODE 
	AND myTarget.ACTION_CODE = mySource.ACTION_CODE 
	AND myTarget.SUB_ACTION_CODE = mySource.SUB_ACTION_CODE 
	AND myTarget.ACTION_DTTM = mySource.ACTION_DTTM

WHEN MATCHED
-- AND @DisableUpdate = 'false'
AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[MAILING_NAME] = mySource.[MAILING_NAME]
     , myTarget.[PROFILE_KEY] = mySource.[PROFILE_KEY]
     , myTarget.[EMAIL_ADDR] = mySource.[EMAIL_ADDR]
     , myTarget.[CONTENT] = mySource.[CONTENT]
     , myTarget.[SOURCE_CODE] = mySource.[SOURCE_CODE]
     , myTarget.[ACTION_CODE] = mySource.[ACTION_CODE]
     , myTarget.[SUB_ACTION_CODE] = mySource.[SUB_ACTION_CODE]
     , myTarget.[ACTION_DTTM] = mySource.[ACTION_DTTM]
     , myTarget.[UNIQUE_FLAG] = mySource.[UNIQUE_FLAG]
     , myTarget.[LINK_NAME] = mySource.[LINK_NAME]
     , myTarget.[LINK_TAG] = mySource.[LINK_TAG]
     , myTarget.[ABUSE_DOMAIN] = mySource.[ABUSE_DOMAIN]
     , myTarget.[ABUSEOPT_FLG] = mySource.[ABUSEOPT_FLG]
     , myTarget.[ABUSE_SUB] = mySource.[ABUSE_SUB]
     
--WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target --AND @DisableInsert = 'false'
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[MAILING_NAME]
     ,[PROFILE_KEY]
     ,[EMAIL_ADDR]
     ,[CONTENT]
     ,[SOURCE_CODE]
     ,[ACTION_CODE]
     ,[SUB_ACTION_CODE]
     ,[ACTION_DTTM]
     ,[UNIQUE_FLAG]
     ,[LINK_NAME]
     ,[LINK_TAG]
     ,[ABUSE_DOMAIN]
     ,[ABUSEOPT_FLG]
     ,[ABUSE_SUB]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[MAILING_NAME]
     ,mySource.[PROFILE_KEY]
     ,mySource.[EMAIL_ADDR]
     ,mySource.[CONTENT]
     ,mySource.[SOURCE_CODE]
     ,mySource.[ACTION_CODE]
     ,mySource.[SUB_ACTION_CODE]
     ,mySource.[ACTION_DTTM]
     ,mySource.[UNIQUE_FLAG]
     ,mySource.[LINK_NAME]
     ,mySource.[LINK_TAG]
     ,mySource.[ABUSE_DOMAIN]
     ,mySource.[ABUSEOPT_FLG]
     ,mySource.[ABUSE_SUB]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Epsilon_ADU WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Epsilon_ADU WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
