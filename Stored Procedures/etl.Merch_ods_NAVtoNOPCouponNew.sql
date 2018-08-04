SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Merch_ods_NAVtoNOPCouponNew]
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
Date:     02/05/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Merch_NAVtoNOPCouponNew),'0');	
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
,  Id, NopCouponId, Description, StoreId, NavCouponCode, IsActive, IsOneTimeUse, IsConsumed, DateAdded, LastTimeStamp, LastUpdate
INTO #SrcData
FROM (
	SELECT  Id, NopCouponId, Description, StoreId, NavCouponCode, IsActive, IsOneTimeUse, IsConsumed, DateAdded, LastTimeStamp, LastUpdate
	, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY ETL_ID) RowRank
	FROM src.Merch_NAVtoNOPCouponNew
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),DateAdded)),'DBNULL_DATETIME') + ISNULL(RTRIM(Description),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),Id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),IsActive)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsConsumed)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsOneTimeUse)),'DBNULL_BIT') + ISNULL(RTRIM(LastTimeStamp),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),LastUpdate)),'DBNULL_DATETIME') + ISNULL(RTRIM(NavCouponCode),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),NopCouponId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),StoreId)),'DBNULL_INT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (Id)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Merch_NAVtoNOPCouponNew AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.Id = mySource.Id

WHEN MATCHED AND @DisableUpdate = 'false' AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[Id] = mySource.[Id]
     , myTarget.[NopCouponId] = mySource.[NopCouponId]
     , myTarget.[Description] = mySource.[Description]
     , myTarget.[StoreId] = mySource.[StoreId]
     , myTarget.[NavCouponCode] = mySource.[NavCouponCode]
     , myTarget.[IsActive] = mySource.[IsActive]
     , myTarget.[IsOneTimeUse] = mySource.[IsOneTimeUse]
     , myTarget.[IsConsumed] = mySource.[IsConsumed]
     , myTarget.[DateAdded] = mySource.[DateAdded]
     , myTarget.[LastTimeStamp] = mySource.[LastTimeStamp]
     , myTarget.[LastUpdate] = mySource.[LastUpdate]
     
--WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target AND @DisableInsert = 'false'
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[Id]
     ,[NopCouponId]
     ,[Description]
     ,[StoreId]
     ,[NavCouponCode]
     ,[IsActive]
     ,[IsOneTimeUse]
     ,[IsConsumed]
     ,[DateAdded]
     ,[LastTimeStamp]
     ,[LastUpdate]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[Id]
     ,mySource.[NopCouponId]
     ,mySource.[Description]
     ,mySource.[StoreId]
     ,mySource.[NavCouponCode]
     ,mySource.[IsActive]
     ,mySource.[IsOneTimeUse]
     ,mySource.[IsConsumed]
     ,mySource.[DateAdded]
     ,mySource.[LastTimeStamp]
     ,mySource.[LastUpdate]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_NAVtoNOPCouponNew WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_NAVtoNOPCouponNew WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
