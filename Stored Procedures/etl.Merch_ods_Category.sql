SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Merch_ods_Category]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Merch_Category),'0');	
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
,  LastTimeStamp, Id, Name, ShowOnHomePage, MetaKeywords, MetaDescription, MetaTitle, SubjectToAcl, LimitedToStores, HasDiscountsApplied, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, Description, CategoryTemplateId, ParentCategoryId, PictureId, PageSize, AllowCustomersToSelectPageSize, PageSizeOptions, PriceRanges, IncludeInTopMenu
INTO #SrcData
FROM (
	SELECT  LastTimeStamp, Id, Name, ShowOnHomePage, MetaKeywords, MetaDescription, MetaTitle, SubjectToAcl, LimitedToStores, HasDiscountsApplied, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, Description, CategoryTemplateId, ParentCategoryId, PictureId, PageSize, AllowCustomersToSelectPageSize, PageSizeOptions, PriceRanges, IncludeInTopMenu
	, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY ETL_ID) RowRank
	FROM src.Merch_Category
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),AllowCustomersToSelectPageSize)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),CategoryTemplateId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedOnUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),Deleted)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DisplayOrder)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),HasDiscountsApplied)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),Id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),IncludeInTopMenu)),'DBNULL_BIT') + ISNULL(RTRIM(LastTimeStamp),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),LimitedToStores)),'DBNULL_BIT') + ISNULL(RTRIM(MetaKeywords),'DBNULL_TEXT') + ISNULL(RTRIM(MetaTitle),'DBNULL_TEXT') + ISNULL(RTRIM(Name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),PageSize)),'DBNULL_INT') + ISNULL(RTRIM(PageSizeOptions),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ParentCategoryId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),PictureId)),'DBNULL_INT') + ISNULL(RTRIM(PriceRanges),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),Published)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),ShowOnHomePage)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),SubjectToAcl)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),UpdatedOnUtc)),'DBNULL_DATETIME'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (Id)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Merch_Category AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.Id = mySource.Id

WHEN MATCHED AND @DisableUpdate = 'false' AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.MetaDescription,'') <> ISNULL(myTarget.MetaDescription,'') OR ISNULL(mySource.Description,'') <> ISNULL(myTarget.Description,'') 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[LastTimeStamp] = mySource.[LastTimeStamp]
     , myTarget.[Id] = mySource.[Id]
     , myTarget.[Name] = mySource.[Name]
     , myTarget.[ShowOnHomePage] = mySource.[ShowOnHomePage]
     , myTarget.[MetaKeywords] = mySource.[MetaKeywords]
     , myTarget.[MetaDescription] = mySource.[MetaDescription]
     , myTarget.[MetaTitle] = mySource.[MetaTitle]
     , myTarget.[SubjectToAcl] = mySource.[SubjectToAcl]
     , myTarget.[LimitedToStores] = mySource.[LimitedToStores]
     , myTarget.[HasDiscountsApplied] = mySource.[HasDiscountsApplied]
     , myTarget.[DisplayOrder] = mySource.[DisplayOrder]
     , myTarget.[Published] = mySource.[Published]
     , myTarget.[Deleted] = mySource.[Deleted]
     , myTarget.[CreatedOnUtc] = mySource.[CreatedOnUtc]
     , myTarget.[UpdatedOnUtc] = mySource.[UpdatedOnUtc]
     , myTarget.[Description] = mySource.[Description]
     , myTarget.[CategoryTemplateId] = mySource.[CategoryTemplateId]
     , myTarget.[ParentCategoryId] = mySource.[ParentCategoryId]
     , myTarget.[PictureId] = mySource.[PictureId]
     , myTarget.[PageSize] = mySource.[PageSize]
     , myTarget.[AllowCustomersToSelectPageSize] = mySource.[AllowCustomersToSelectPageSize]
     , myTarget.[PageSizeOptions] = mySource.[PageSizeOptions]
     , myTarget.[PriceRanges] = mySource.[PriceRanges]
     , myTarget.[IncludeInTopMenu] = mySource.[IncludeInTopMenu]
     
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
     ,[Name]
     ,[ShowOnHomePage]
     ,[MetaKeywords]
     ,[MetaDescription]
     ,[MetaTitle]
     ,[SubjectToAcl]
     ,[LimitedToStores]
     ,[HasDiscountsApplied]
     ,[DisplayOrder]
     ,[Published]
     ,[Deleted]
     ,[CreatedOnUtc]
     ,[UpdatedOnUtc]
     ,[Description]
     ,[CategoryTemplateId]
     ,[ParentCategoryId]
     ,[PictureId]
     ,[PageSize]
     ,[AllowCustomersToSelectPageSize]
     ,[PageSizeOptions]
     ,[PriceRanges]
     ,[IncludeInTopMenu]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[LastTimeStamp]
     ,mySource.[Id]
     ,mySource.[Name]
     ,mySource.[ShowOnHomePage]
     ,mySource.[MetaKeywords]
     ,mySource.[MetaDescription]
     ,mySource.[MetaTitle]
     ,mySource.[SubjectToAcl]
     ,mySource.[LimitedToStores]
     ,mySource.[HasDiscountsApplied]
     ,mySource.[DisplayOrder]
     ,mySource.[Published]
     ,mySource.[Deleted]
     ,mySource.[CreatedOnUtc]
     ,mySource.[UpdatedOnUtc]
     ,mySource.[Description]
     ,mySource.[CategoryTemplateId]
     ,mySource.[ParentCategoryId]
     ,mySource.[PictureId]
     ,mySource.[PageSize]
     ,mySource.[AllowCustomersToSelectPageSize]
     ,mySource.[PageSizeOptions]
     ,mySource.[PriceRanges]
     ,mySource.[IncludeInTopMenu]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_Category WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_Category WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
