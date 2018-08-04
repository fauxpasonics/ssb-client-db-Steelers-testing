SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Merch_ods_Customer]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Merch_Customer),'0');	
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
,  Id, CustomerGuid, Username, Email, Password, PasswordFormatId, PasswordSalt, AdminComment, IsTaxExempt, AffiliateId, VendorId, HasShoppingCartItems, Active, Deleted, IsSystemAccount, SystemName, LastIpAddress, CreatedOnUtc, LastLoginDateUtc, LastActivityDateUtc, BillingAddress_Id, ShippingAddress_Id, LastTimeStamp
INTO #SrcData
FROM (
	SELECT  Id, CustomerGuid, Username, Email, Password, PasswordFormatId, PasswordSalt, AdminComment, IsTaxExempt, AffiliateId, VendorId, HasShoppingCartItems, Active, Deleted, IsSystemAccount, SystemName, LastIpAddress, CreatedOnUtc, LastLoginDateUtc, LastActivityDateUtc, BillingAddress_Id, ShippingAddress_Id, LastTimeStamp
	, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY ETL_ID) RowRank
	FROM src.Merch_Customer
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),Active)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),AffiliateId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),BillingAddress_Id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedOnUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CustomerGuid),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),Deleted)),'DBNULL_BIT') + ISNULL(RTRIM(Email),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),HasShoppingCartItems)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),Id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),IsSystemAccount)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsTaxExempt)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),LastActivityDateUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),LastLoginDateUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(LastTimeStamp),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),PasswordFormatId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ShippingAddress_Id)),'DBNULL_INT') + ISNULL(RTRIM(Username),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),VendorId)),'DBNULL_INT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (Id)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Merch_Customer AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.Id = mySource.Id

WHEN MATCHED AND @DisableUpdate = 'false' AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.Password,'') <> ISNULL(myTarget.Password,'') OR ISNULL(mySource.PasswordSalt,'') <> ISNULL(myTarget.PasswordSalt,'') OR ISNULL(mySource.AdminComment,'') <> ISNULL(myTarget.AdminComment,'') OR ISNULL(mySource.SystemName,'') <> ISNULL(myTarget.SystemName,'') OR ISNULL(mySource.LastIpAddress,'') <> ISNULL(myTarget.LastIpAddress,'') 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[Id] = mySource.[Id]
     , myTarget.[CustomerGuid] = mySource.[CustomerGuid]
     , myTarget.[Username] = mySource.[Username]
     , myTarget.[Email] = mySource.[Email]
     , myTarget.[Password] = mySource.[Password]
     , myTarget.[PasswordFormatId] = mySource.[PasswordFormatId]
     , myTarget.[PasswordSalt] = mySource.[PasswordSalt]
     , myTarget.[AdminComment] = mySource.[AdminComment]
     , myTarget.[IsTaxExempt] = mySource.[IsTaxExempt]
     , myTarget.[AffiliateId] = mySource.[AffiliateId]
     , myTarget.[VendorId] = mySource.[VendorId]
     , myTarget.[HasShoppingCartItems] = mySource.[HasShoppingCartItems]
     , myTarget.[Active] = mySource.[Active]
     , myTarget.[Deleted] = mySource.[Deleted]
     , myTarget.[IsSystemAccount] = mySource.[IsSystemAccount]
     , myTarget.[SystemName] = mySource.[SystemName]
     , myTarget.[LastIpAddress] = mySource.[LastIpAddress]
     , myTarget.[CreatedOnUtc] = mySource.[CreatedOnUtc]
     , myTarget.[LastLoginDateUtc] = mySource.[LastLoginDateUtc]
     , myTarget.[LastActivityDateUtc] = mySource.[LastActivityDateUtc]
     , myTarget.[BillingAddress_Id] = mySource.[BillingAddress_Id]
     , myTarget.[ShippingAddress_Id] = mySource.[ShippingAddress_Id]
     , myTarget.[LastTimeStamp] = mySource.[LastTimeStamp]
     
WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target AND @DisableInsert = 'false'
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[Id]
     ,[CustomerGuid]
     ,[Username]
     ,[Email]
     ,[Password]
     ,[PasswordFormatId]
     ,[PasswordSalt]
     ,[AdminComment]
     ,[IsTaxExempt]
     ,[AffiliateId]
     ,[VendorId]
     ,[HasShoppingCartItems]
     ,[Active]
     ,[Deleted]
     ,[IsSystemAccount]
     ,[SystemName]
     ,[LastIpAddress]
     ,[CreatedOnUtc]
     ,[LastLoginDateUtc]
     ,[LastActivityDateUtc]
     ,[BillingAddress_Id]
     ,[ShippingAddress_Id]
     ,[LastTimeStamp]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[Id]
     ,mySource.[CustomerGuid]
     ,mySource.[Username]
     ,mySource.[Email]
     ,mySource.[Password]
     ,mySource.[PasswordFormatId]
     ,mySource.[PasswordSalt]
     ,mySource.[AdminComment]
     ,mySource.[IsTaxExempt]
     ,mySource.[AffiliateId]
     ,mySource.[VendorId]
     ,mySource.[HasShoppingCartItems]
     ,mySource.[Active]
     ,mySource.[Deleted]
     ,mySource.[IsSystemAccount]
     ,mySource.[SystemName]
     ,mySource.[LastIpAddress]
     ,mySource.[CreatedOnUtc]
     ,mySource.[LastLoginDateUtc]
     ,mySource.[LastActivityDateUtc]
     ,mySource.[BillingAddress_Id]
     ,mySource.[ShippingAddress_Id]
     ,mySource.[LastTimeStamp]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_Customer WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_Customer WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
