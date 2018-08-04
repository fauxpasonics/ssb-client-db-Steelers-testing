SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Merch_ods_OrderItem]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Merch_OrderItem),'0');	
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
,  LastTimeStamp, Id, OrderItemGuid, OrderId, ProductId, Quantity, UnitPriceInclTax, UnitPriceExclTax, PriceInclTax, PriceExclTax, DiscountAmountInclTax, DiscountAmountExclTax, OriginalProductCost, AttributeDescription, AttributesXml, DownloadCount, IsDownloadActivated, LicenseDownloadId, ItemWeight, RentalStartDateUtc, RentalEndDateUtc, ProductSku
INTO #SrcData
FROM (
	SELECT  LastTimeStamp, Id, OrderItemGuid, OrderId, ProductId, Quantity, UnitPriceInclTax, UnitPriceExclTax, PriceInclTax, PriceExclTax, DiscountAmountInclTax, DiscountAmountExclTax, OriginalProductCost, AttributeDescription, AttributesXml, DownloadCount, IsDownloadActivated, LicenseDownloadId, ItemWeight, RentalStartDateUtc, RentalEndDateUtc, ProductSku
	, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY ETL_ID) RowRank
	FROM src.Merch_OrderItem
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),DiscountAmountExclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),DiscountAmountInclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),DownloadCount)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),Id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),IsDownloadActivated)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),ItemWeight)),'DBNULL_NUMBER') + ISNULL(RTRIM(LastTimeStamp),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),LicenseDownloadId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),OrderId)),'DBNULL_INT') + ISNULL(RTRIM(OrderItemGuid),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),OriginalProductCost)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PriceExclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PriceInclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),ProductId)),'DBNULL_INT') + ISNULL(RTRIM(ProductSku),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),Quantity)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),RentalEndDateUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),RentalStartDateUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),UnitPriceExclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),UnitPriceInclTax)),'DBNULL_NUMBER'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (Id)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Merch_OrderItem AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.Id = mySource.Id

WHEN MATCHED AND @DisableUpdate = 'false' AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.AttributeDescription,'') <> ISNULL(myTarget.AttributeDescription,'') OR ISNULL(mySource.AttributesXml,'') <> ISNULL(myTarget.AttributesXml,'') 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[LastTimeStamp] = mySource.[LastTimeStamp]
     , myTarget.[Id] = mySource.[Id]
     , myTarget.[OrderItemGuid] = mySource.[OrderItemGuid]
     , myTarget.[OrderId] = mySource.[OrderId]
     , myTarget.[ProductId] = mySource.[ProductId]
     , myTarget.[Quantity] = mySource.[Quantity]
     , myTarget.[UnitPriceInclTax] = mySource.[UnitPriceInclTax]
     , myTarget.[UnitPriceExclTax] = mySource.[UnitPriceExclTax]
     , myTarget.[PriceInclTax] = mySource.[PriceInclTax]
     , myTarget.[PriceExclTax] = mySource.[PriceExclTax]
     , myTarget.[DiscountAmountInclTax] = mySource.[DiscountAmountInclTax]
     , myTarget.[DiscountAmountExclTax] = mySource.[DiscountAmountExclTax]
     , myTarget.[OriginalProductCost] = mySource.[OriginalProductCost]
     , myTarget.[AttributeDescription] = mySource.[AttributeDescription]
     , myTarget.[AttributesXml] = mySource.[AttributesXml]
     , myTarget.[DownloadCount] = mySource.[DownloadCount]
     , myTarget.[IsDownloadActivated] = mySource.[IsDownloadActivated]
     , myTarget.[LicenseDownloadId] = mySource.[LicenseDownloadId]
     , myTarget.[ItemWeight] = mySource.[ItemWeight]
     , myTarget.[RentalStartDateUtc] = mySource.[RentalStartDateUtc]
     , myTarget.[RentalEndDateUtc] = mySource.[RentalEndDateUtc]
     , myTarget.[ProductSku] = mySource.[ProductSku]
     
WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target AND @DisableInsert = 'false'
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[LastTimeStamp]
     ,[Id]
     ,[OrderItemGuid]
     ,[OrderId]
     ,[ProductId]
     ,[Quantity]
     ,[UnitPriceInclTax]
     ,[UnitPriceExclTax]
     ,[PriceInclTax]
     ,[PriceExclTax]
     ,[DiscountAmountInclTax]
     ,[DiscountAmountExclTax]
     ,[OriginalProductCost]
     ,[AttributeDescription]
     ,[AttributesXml]
     ,[DownloadCount]
     ,[IsDownloadActivated]
     ,[LicenseDownloadId]
     ,[ItemWeight]
     ,[RentalStartDateUtc]
     ,[RentalEndDateUtc]
     ,[ProductSku]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[LastTimeStamp]
     ,mySource.[Id]
     ,mySource.[OrderItemGuid]
     ,mySource.[OrderId]
     ,mySource.[ProductId]
     ,mySource.[Quantity]
     ,mySource.[UnitPriceInclTax]
     ,mySource.[UnitPriceExclTax]
     ,mySource.[PriceInclTax]
     ,mySource.[PriceExclTax]
     ,mySource.[DiscountAmountInclTax]
     ,mySource.[DiscountAmountExclTax]
     ,mySource.[OriginalProductCost]
     ,mySource.[AttributeDescription]
     ,mySource.[AttributesXml]
     ,mySource.[DownloadCount]
     ,mySource.[IsDownloadActivated]
     ,mySource.[LicenseDownloadId]
     ,mySource.[ItemWeight]
     ,mySource.[RentalStartDateUtc]
     ,mySource.[RentalEndDateUtc]
     ,mySource.[ProductSku]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_OrderItem WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_OrderItem WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
