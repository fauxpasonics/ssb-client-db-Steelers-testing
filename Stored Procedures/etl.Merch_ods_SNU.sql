SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Merch_ods_SNU]
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
Date:     12/01/2015
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Merch_SNU),'0');	
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
,  Id, SnuId, Email, Name, Status, UnSubscribed, UnsubscribedSms, CreatedAt, UpdatedAt, Balance, LifetimeBalance, LastActivity, ImageUrl, TopTierName, ExternalCustomerId, LastRewardEventId, SubscriptionType, Channel, SubChannel, SubChannelDetail, LastRewardDate, DateEnrolled, LastTimeStamp
INTO #SrcData
FROM (
	SELECT  Id, SnuId, Email, Name, Status, UnSubscribed, UnsubscribedSms, CreatedAt, UpdatedAt, Balance, LifetimeBalance, LastActivity, ImageUrl, TopTierName, ExternalCustomerId, LastRewardEventId, SubscriptionType, Channel, SubChannel, SubChannelDetail, LastRewardDate, DateEnrolled, LastTimeStamp
	, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY ETL_ID) RowRank
	FROM src.Merch_SNU
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),Balance)),'DBNULL_INT') + ISNULL(RTRIM(Channel),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedAt)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),DateEnrolled)),'DBNULL_DATETIME') + ISNULL(RTRIM(ExternalCustomerId),'DBNULL_TEXT') + ISNULL(RTRIM(Id),'DBNULL_TEXT') + ISNULL(RTRIM(ImageUrl),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),LastActivity)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),LastRewardDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(LastRewardEventId),'DBNULL_TEXT') + ISNULL(RTRIM(LastTimeStamp),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),LifetimeBalance)),'DBNULL_INT') + ISNULL(RTRIM(Name),'DBNULL_TEXT') + ISNULL(RTRIM(SnuId),'DBNULL_TEXT') + ISNULL(RTRIM(Status),'DBNULL_TEXT') + ISNULL(RTRIM(SubChannel),'DBNULL_TEXT') + ISNULL(RTRIM(SubChannelDetail),'DBNULL_TEXT') + ISNULL(RTRIM(SubscriptionType),'DBNULL_TEXT') + ISNULL(RTRIM(TopTierName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),UnSubscribed)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),UnsubscribedSms)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),UpdatedAt)),'DBNULL_DATETIME'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (Id)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Merch_SNU AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.Id = mySource.Id

WHEN MATCHED AND @DisableUpdate = 'false' AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.Email,'') <> ISNULL(myTarget.Email,'') 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[Id] = mySource.[Id]
     , myTarget.[LastTimeStamp] = mySource.[LastTimeStamp]
     , myTarget.[SnuId] = mySource.[SnuId]
     , myTarget.[Email] = mySource.[Email]
     , myTarget.[Name] = mySource.[Name]
     , myTarget.[Status] = mySource.[Status]
     , myTarget.[UnSubscribed] = mySource.[UnSubscribed]
     , myTarget.[UnsubscribedSms] = mySource.[UnsubscribedSms]
     , myTarget.[CreatedAt] = mySource.[CreatedAt]
     , myTarget.[UpdatedAt] = mySource.[UpdatedAt]
     , myTarget.[Balance] = mySource.[Balance]
     , myTarget.[LifetimeBalance] = mySource.[LifetimeBalance]
     , myTarget.[LastActivity] = mySource.[LastActivity]
     , myTarget.[ImageUrl] = mySource.[ImageUrl]
     , myTarget.[TopTierName] = mySource.[TopTierName]
     , myTarget.[ExternalCustomerId] = mySource.[ExternalCustomerId]
     , myTarget.[LastRewardEventId] = mySource.[LastRewardEventId]
     , myTarget.[SubscriptionType] = mySource.[SubscriptionType]
     , myTarget.[Channel] = mySource.[Channel]
     , myTarget.[SubChannel] = mySource.[SubChannel]
     , myTarget.[SubChannelDetail] = mySource.[SubChannelDetail]
     , myTarget.[LastRewardDate] = mySource.[LastRewardDate]
     , myTarget.[DateEnrolled] = mySource.[DateEnrolled]
     
WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target AND @DisableInsert = 'false'
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[Id]
     ,[LastTimeStamp]
     ,[SnuId]
     ,[Email]
     ,[Name]
     ,[Status]
     ,[UnSubscribed]
     ,[UnsubscribedSms]
     ,[CreatedAt]
     ,[UpdatedAt]
     ,[Balance]
     ,[LifetimeBalance]
     ,[LastActivity]
     ,[ImageUrl]
     ,[TopTierName]
     ,[ExternalCustomerId]
     ,[LastRewardEventId]
     ,[SubscriptionType]
     ,[Channel]
     ,[SubChannel]
     ,[SubChannelDetail]
     ,[LastRewardDate]
     ,[DateEnrolled]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[Id]
     ,mySource.[LastTimeStamp]
     ,mySource.[SnuId]
     ,mySource.[Email]
     ,mySource.[Name]
     ,mySource.[Status]
     ,mySource.[UnSubscribed]
     ,mySource.[UnsubscribedSms]
     ,mySource.[CreatedAt]
     ,mySource.[UpdatedAt]
     ,mySource.[Balance]
     ,mySource.[LifetimeBalance]
     ,mySource.[LastActivity]
     ,mySource.[ImageUrl]
     ,mySource.[TopTierName]
     ,mySource.[ExternalCustomerId]
     ,mySource.[LastRewardEventId]
     ,mySource.[SubscriptionType]
     ,mySource.[Channel]
     ,mySource.[SubChannel]
     ,mySource.[SubChannelDetail]
     ,mySource.[LastRewardDate]
     ,mySource.[DateEnrolled]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_SNU WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_SNU WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
