SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_ods_Epsilon_Activities]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.Epsilon_Activities),'0');	
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
,  ETL_FileName, Action, EmailAddress, MessageID, ActionTimestamp, CustomerKey, MessageName, LinkName, LinkURL, ServiceTransactionID, OrgId, DeploymentID, DeviceCategory, DeviceSubcategory, DeviceType, EventName, ConversionTransactionId, ConversionAmount, ConversionQuantity, ConversionOrderId, ConversionCategory, ConversionSubcategory, ConversionDateTime, UndeliveredCategory
INTO #SrcData
FROM (
	SELECT  ETL_FileName, Action, EmailAddress, MessageID, ActionTimestamp, CustomerKey, MessageName, LinkName, LinkURL, ServiceTransactionID, OrgId, DeploymentID, DeviceCategory, DeviceSubcategory, DeviceType, EventName, ConversionTransactionId, ConversionAmount, ConversionQuantity, ConversionOrderId, ConversionCategory, ConversionSubcategory, ConversionDateTime, UndeliveredCategory
	, ROW_NUMBER() OVER(PARTITION BY CustomerKey,ActionTimestamp,ServiceTransactionID ORDER BY ETL_ID) RowRank
	FROM stg.Epsilon_Activities
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(Action),'DBNULL_TEXT') + ISNULL(RTRIM(ActionTimestamp),'DBNULL_TEXT') + ISNULL(RTRIM(ConversionAmount),'DBNULL_TEXT') + ISNULL(RTRIM(ConversionCategory),'DBNULL_TEXT') + ISNULL(RTRIM(ConversionDateTime),'DBNULL_TEXT') + ISNULL(RTRIM(ConversionOrderId),'DBNULL_TEXT') + ISNULL(RTRIM(ConversionQuantity),'DBNULL_TEXT') + ISNULL(RTRIM(ConversionSubcategory),'DBNULL_TEXT') + ISNULL(RTRIM(ConversionTransactionId),'DBNULL_TEXT') + ISNULL(RTRIM(CustomerKey),'DBNULL_TEXT') + ISNULL(RTRIM(DeploymentID),'DBNULL_TEXT') + ISNULL(RTRIM(DeviceCategory),'DBNULL_TEXT') + ISNULL(RTRIM(DeviceSubcategory),'DBNULL_TEXT') + ISNULL(RTRIM(DeviceType),'DBNULL_TEXT') + ISNULL(RTRIM(EmailAddress),'DBNULL_TEXT') + ISNULL(RTRIM(EventName),'DBNULL_TEXT') + ISNULL(RTRIM(LinkName),'DBNULL_TEXT') + ISNULL(RTRIM(LinkURL),'DBNULL_TEXT') + ISNULL(RTRIM(MessageID),'DBNULL_TEXT') + ISNULL(RTRIM(MessageName),'DBNULL_TEXT') + ISNULL(RTRIM(OrgId),'DBNULL_TEXT') + ISNULL(RTRIM(ServiceTransactionID),'DBNULL_TEXT') + ISNULL(RTRIM(UndeliveredCategory),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (CustomerKey,ActionTimestamp,ServiceTransactionID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Epsilon_Activities AS myTarget
USING #SrcData AS mySource
ON myTarget.CustomerKey = mySource.CustomerKey and myTarget.ActionTimestamp = mySource.ActionTimestamp and myTarget.ServiceTransactionID = mySource.ServiceTransactionID

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
	 , myTarget.[ETL_FileName] = mySource.[ETL_FileName]
     , myTarget.[Action] = mySource.[Action]
     , myTarget.[EmailAddress] = mySource.[EmailAddress]
     , myTarget.[MessageID] = mySource.[MessageID]
     , myTarget.[ActionTimestamp] = mySource.[ActionTimestamp]
     , myTarget.[CustomerKey] = mySource.[CustomerKey]
     , myTarget.[MessageName] = mySource.[MessageName]
     , myTarget.[LinkName] = mySource.[LinkName]
     , myTarget.[LinkURL] = mySource.[LinkURL]
     , myTarget.[ServiceTransactionID] = mySource.[ServiceTransactionID]
     , myTarget.[OrgId] = mySource.[OrgId]
     , myTarget.[DeploymentID] = mySource.[DeploymentID]
     , myTarget.[DeviceCategory] = mySource.[DeviceCategory]
     , myTarget.[DeviceSubcategory] = mySource.[DeviceSubcategory]
     , myTarget.[DeviceType] = mySource.[DeviceType]
     , myTarget.[EventName] = mySource.[EventName]
     , myTarget.[ConversionTransactionId] = mySource.[ConversionTransactionId]
     , myTarget.[ConversionAmount] = mySource.[ConversionAmount]
     , myTarget.[ConversionQuantity] = mySource.[ConversionQuantity]
     , myTarget.[ConversionOrderId] = mySource.[ConversionOrderId]
     , myTarget.[ConversionCategory] = mySource.[ConversionCategory]
     , myTarget.[ConversionSubcategory] = mySource.[ConversionSubcategory]
     , myTarget.[ConversionDateTime] = mySource.[ConversionDateTime]
     , myTarget.[UndeliveredCategory] = mySource.[UndeliveredCategory]
     

WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ETL_FileName]
     ,[Action]
     ,[EmailAddress]
     ,[MessageID]
     ,[ActionTimestamp]
     ,[CustomerKey]
     ,[MessageName]
     ,[LinkName]
     ,[LinkURL]
     ,[ServiceTransactionID]
     ,[OrgId]
     ,[DeploymentID]
     ,[DeviceCategory]
     ,[DeviceSubcategory]
     ,[DeviceType]
     ,[EventName]
     ,[ConversionTransactionId]
     ,[ConversionAmount]
     ,[ConversionQuantity]
     ,[ConversionOrderId]
     ,[ConversionCategory]
     ,[ConversionSubcategory]
     ,[ConversionDateTime]
     ,[UndeliveredCategory]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0		--ETL_IsDeleted
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
	 ,mySource.[ETL_FileName]
     ,mySource.[Action]
     ,mySource.[EmailAddress]
     ,mySource.[MessageID]
     ,mySource.[ActionTimestamp]
     ,mySource.[CustomerKey]
     ,mySource.[MessageName]
     ,mySource.[LinkName]
     ,mySource.[LinkURL]
     ,mySource.[ServiceTransactionID]
     ,mySource.[OrgId]
     ,mySource.[DeploymentID]
     ,mySource.[DeviceCategory]
     ,mySource.[DeviceSubcategory]
     ,mySource.[DeviceType]
     ,mySource.[EventName]
     ,mySource.[ConversionTransactionId]
     ,mySource.[ConversionAmount]
     ,mySource.[ConversionQuantity]
     ,mySource.[ConversionOrderId]
     ,mySource.[ConversionCategory]
     ,mySource.[ConversionSubcategory]
     ,mySource.[ConversionDateTime]
     ,mySource.[UndeliveredCategory]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Epsilon_Activities WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Epsilon_Activities WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
