SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Merch_ods_Address]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Merch_Address),'0');	
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
,  Id, CreatedOnUtc, FirstName, LastName, Email, Company, CountryId, StateProvinceId, City, Address1, Address2, ZipPostalCode, PhoneNumber, FaxNumber, CustomAttributes, AutoIndex
INTO #SrcData
FROM (
	SELECT  Id, CreatedOnUtc, FirstName, LastName, Email, Company, CountryId, StateProvinceId, City, Address1, Address2, ZipPostalCode, PhoneNumber, FaxNumber, CustomAttributes, AutoIndex
	, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY ETL_ID) RowRank
	FROM src.Merch_Address
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),AutoIndex)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),CountryId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedOnUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),Id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),StateProvinceId)),'DBNULL_INT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (Id)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Merch_Address AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.Id = mySource.Id

WHEN MATCHED AND @DisableUpdate = 'false' AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.FirstName,'') <> ISNULL(myTarget.FirstName,'') OR ISNULL(mySource.LastName,'') <> ISNULL(myTarget.LastName,'') OR ISNULL(mySource.Email,'') <> ISNULL(myTarget.Email,'') OR ISNULL(mySource.Company,'') <> ISNULL(myTarget.Company,'') OR ISNULL(mySource.City,'') <> ISNULL(myTarget.City,'') OR ISNULL(mySource.Address1,'') <> ISNULL(myTarget.Address1,'') OR ISNULL(mySource.Address2,'') <> ISNULL(myTarget.Address2,'') OR ISNULL(mySource.ZipPostalCode,'') <> ISNULL(myTarget.ZipPostalCode,'') OR ISNULL(mySource.PhoneNumber,'') <> ISNULL(myTarget.PhoneNumber,'') OR ISNULL(mySource.FaxNumber,'') <> ISNULL(myTarget.FaxNumber,'') OR ISNULL(mySource.CustomAttributes,'') <> ISNULL(myTarget.CustomAttributes,'') 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[Id] = mySource.[Id]
     , myTarget.[CreatedOnUtc] = mySource.[CreatedOnUtc]
     , myTarget.[FirstName] = mySource.[FirstName]
     , myTarget.[LastName] = mySource.[LastName]
     , myTarget.[Email] = mySource.[Email]
     , myTarget.[Company] = mySource.[Company]
     , myTarget.[CountryId] = mySource.[CountryId]
     , myTarget.[StateProvinceId] = mySource.[StateProvinceId]
     , myTarget.[City] = mySource.[City]
     , myTarget.[Address1] = mySource.[Address1]
     , myTarget.[Address2] = mySource.[Address2]
     , myTarget.[ZipPostalCode] = mySource.[ZipPostalCode]
     , myTarget.[PhoneNumber] = mySource.[PhoneNumber]
     , myTarget.[FaxNumber] = mySource.[FaxNumber]
     , myTarget.[CustomAttributes] = mySource.[CustomAttributes]
     , myTarget.[AutoIndex] = mySource.[AutoIndex]
     
WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target AND @DisableInsert = 'false'
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[Id]
     ,[CreatedOnUtc]
     ,[FirstName]
     ,[LastName]
     ,[Email]
     ,[Company]
     ,[CountryId]
     ,[StateProvinceId]
     ,[City]
     ,[Address1]
     ,[Address2]
     ,[ZipPostalCode]
     ,[PhoneNumber]
     ,[FaxNumber]
     ,[CustomAttributes]
     ,[AutoIndex]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[Id]
     ,mySource.[CreatedOnUtc]
     ,mySource.[FirstName]
     ,mySource.[LastName]
     ,mySource.[Email]
     ,mySource.[Company]
     ,mySource.[CountryId]
     ,mySource.[StateProvinceId]
     ,mySource.[City]
     ,mySource.[Address1]
     ,mySource.[Address2]
     ,mySource.[ZipPostalCode]
     ,mySource.[PhoneNumber]
     ,mySource.[FaxNumber]
     ,mySource.[CustomAttributes]
     ,mySource.[AutoIndex]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_Address WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_Address WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
