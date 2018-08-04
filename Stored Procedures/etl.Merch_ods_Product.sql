SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Merch_ods_Product]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Merch_Product),'0');	
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
,  LastTimeStamp, Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, Name, ShortDescription, FullDescription, AdminComment, ProductTemplateId, VendorId, ShowOnHomePage, MetaKeywords, MetaDescription, MetaTitle, AllowCustomerReviews, ApprovedRatingSum, NotApprovedRatingSum, ApprovedTotalReviews, NotApprovedTotalReviews, SubjectToAcl, LimitedToStores, Sku, ManufacturerPartNumber, Gtin, IsGiftCard, GiftCardTypeId, RequireOtherProducts, RequiredProductIds, AutomaticallyAddRequiredProducts, IsDownload, DownloadId, UnlimitedDownloads, MaxNumberOfDownloads, DownloadExpirationDays, DownloadActivationTypeId, HasSampleDownload, SampleDownloadId, HasUserAgreement, UserAgreementText, IsRecurring, RecurringCycleLength, RecurringCyclePeriodId, RecurringTotalCycles, IsRental, RentalPriceLength, RentalPricePeriodId, IsShipEnabled, IsFreeShipping, ShipSeparately, AdditionalShippingCharge, DeliveryDateId, IsTaxExempt, TaxCategoryId, IsTelecommunicationsOrBroadcastingOrElectronicServices, ManageInventoryMethodId, UseMultipleWarehouses, WarehouseId, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, LowStockActivityId, NotifyAdminForQuantityBelow, BackorderModeId, AllowBackInStockSubscriptions, OrderMinimumQuantity, OrderMaximumQuantity, AllowedQuantities, AllowAddingOnlyExistingAttributeCombinations, DisableBuyButton, DisableWishlistButton, AvailableForPreOrder, PreOrderAvailabilityStartDateTimeUtc, CallForPrice, Price, OldPrice, ProductCost, SpecialPrice, SpecialPriceStartDateTimeUtc, SpecialPriceEndDateTimeUtc, CustomerEntersPrice, MinimumCustomerEnteredPrice, MaximumCustomerEnteredPrice, HasTierPrices, HasDiscountsApplied, Weight, Length, Width, Height, AvailableStartDateTimeUtc, AvailableEndDateTimeUtc, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, Video, SizeChartId, AvailabilityId
INTO #SrcData
FROM (
	SELECT  LastTimeStamp, Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, Name, ShortDescription, FullDescription, AdminComment, ProductTemplateId, VendorId, ShowOnHomePage, MetaKeywords, MetaDescription, MetaTitle, AllowCustomerReviews, ApprovedRatingSum, NotApprovedRatingSum, ApprovedTotalReviews, NotApprovedTotalReviews, SubjectToAcl, LimitedToStores, Sku, ManufacturerPartNumber, Gtin, IsGiftCard, GiftCardTypeId, RequireOtherProducts, RequiredProductIds, AutomaticallyAddRequiredProducts, IsDownload, DownloadId, UnlimitedDownloads, MaxNumberOfDownloads, DownloadExpirationDays, DownloadActivationTypeId, HasSampleDownload, SampleDownloadId, HasUserAgreement, UserAgreementText, IsRecurring, RecurringCycleLength, RecurringCyclePeriodId, RecurringTotalCycles, IsRental, RentalPriceLength, RentalPricePeriodId, IsShipEnabled, IsFreeShipping, ShipSeparately, AdditionalShippingCharge, DeliveryDateId, IsTaxExempt, TaxCategoryId, IsTelecommunicationsOrBroadcastingOrElectronicServices, ManageInventoryMethodId, UseMultipleWarehouses, WarehouseId, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, LowStockActivityId, NotifyAdminForQuantityBelow, BackorderModeId, AllowBackInStockSubscriptions, OrderMinimumQuantity, OrderMaximumQuantity, AllowedQuantities, AllowAddingOnlyExistingAttributeCombinations, DisableBuyButton, DisableWishlistButton, AvailableForPreOrder, PreOrderAvailabilityStartDateTimeUtc, CallForPrice, Price, OldPrice, ProductCost, SpecialPrice, SpecialPriceStartDateTimeUtc, SpecialPriceEndDateTimeUtc, CustomerEntersPrice, MinimumCustomerEnteredPrice, MaximumCustomerEnteredPrice, HasTierPrices, HasDiscountsApplied, Weight, Length, Width, Height, AvailableStartDateTimeUtc, AvailableEndDateTimeUtc, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, Video, SizeChartId, AvailabilityId
	, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY ETL_ID) RowRank
	FROM src.Merch_Product
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),AdditionalShippingCharge)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),AllowAddingOnlyExistingAttributeCombinations)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),AllowBackInStockSubscriptions)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),AllowCustomerReviews)),'DBNULL_BIT') + ISNULL(RTRIM(AllowedQuantities),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ApprovedRatingSum)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ApprovedTotalReviews)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),AutomaticallyAddRequiredProducts)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),AvailabilityId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),AvailableEndDateTimeUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),AvailableForPreOrder)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),AvailableStartDateTimeUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),BackorderModeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),CallForPrice)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedOnUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),CustomerEntersPrice)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),Deleted)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DeliveryDateId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DisableBuyButton)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DisableWishlistButton)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DisplayOrder)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DisplayStockAvailability)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DisplayStockQuantity)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DownloadActivationTypeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DownloadExpirationDays)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DownloadId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),GiftCardTypeId)),'DBNULL_INT') + ISNULL(RTRIM(Gtin),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),HasDiscountsApplied)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),HasSampleDownload)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),HasTierPrices)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),HasUserAgreement)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),Height)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),Id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),IsDownload)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsFreeShipping)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsGiftCard)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsRecurring)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsRental)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsShipEnabled)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsTaxExempt)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsTelecommunicationsOrBroadcastingOrElectronicServices)),'DBNULL_BIT') + ISNULL(RTRIM(LastTimeStamp),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),Length)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),LimitedToStores)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),LowStockActivityId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ManageInventoryMethodId)),'DBNULL_INT') + ISNULL(RTRIM(ManufacturerPartNumber),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),MaximumCustomerEnteredPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),MaxNumberOfDownloads)),'DBNULL_INT') + ISNULL(RTRIM(MetaKeywords),'DBNULL_TEXT') + ISNULL(RTRIM(MetaTitle),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),MinimumCustomerEnteredPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),MinStockQuantity)),'DBNULL_INT') + ISNULL(RTRIM(Name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),NotApprovedRatingSum)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),NotApprovedTotalReviews)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),NotifyAdminForQuantityBelow)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),OldPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),OrderMaximumQuantity)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),OrderMinimumQuantity)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ParentGroupedProductId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),PreOrderAvailabilityStartDateTimeUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),Price)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),ProductCost)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),ProductTemplateId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ProductTypeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),Published)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),RecurringCycleLength)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),RecurringCyclePeriodId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),RecurringTotalCycles)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),RentalPriceLength)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),RentalPricePeriodId)),'DBNULL_INT') + ISNULL(RTRIM(RequiredProductIds),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),RequireOtherProducts)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),SampleDownloadId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ShipSeparately)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),ShowOnHomePage)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),SizeChartId)),'DBNULL_INT') + ISNULL(RTRIM(Sku),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SpecialPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),SpecialPriceEndDateTimeUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),SpecialPriceStartDateTimeUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),StockQuantity)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),SubjectToAcl)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),TaxCategoryId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),UnlimitedDownloads)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),UpdatedOnUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),UseMultipleWarehouses)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),VendorId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),VisibleIndividually)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),WarehouseId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),Weight)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),Width)),'DBNULL_NUMBER'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (Id)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Merch_Product AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.Id = mySource.Id

WHEN MATCHED AND @DisableUpdate = 'false' AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.ShortDescription,'') <> ISNULL(myTarget.ShortDescription,'') OR ISNULL(mySource.FullDescription,'') <> ISNULL(myTarget.FullDescription,'') OR ISNULL(mySource.AdminComment,'') <> ISNULL(myTarget.AdminComment,'') OR ISNULL(mySource.MetaDescription,'') <> ISNULL(myTarget.MetaDescription,'') OR ISNULL(mySource.UserAgreementText,'') <> ISNULL(myTarget.UserAgreementText,'') OR ISNULL(mySource.Video,'') <> ISNULL(myTarget.Video,'') 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[LastTimeStamp] = mySource.[LastTimeStamp]
     , myTarget.[Id] = mySource.[Id]
     , myTarget.[ProductTypeId] = mySource.[ProductTypeId]
     , myTarget.[ParentGroupedProductId] = mySource.[ParentGroupedProductId]
     , myTarget.[VisibleIndividually] = mySource.[VisibleIndividually]
     , myTarget.[Name] = mySource.[Name]
     , myTarget.[ShortDescription] = mySource.[ShortDescription]
     , myTarget.[FullDescription] = mySource.[FullDescription]
     , myTarget.[AdminComment] = mySource.[AdminComment]
     , myTarget.[ProductTemplateId] = mySource.[ProductTemplateId]
     , myTarget.[VendorId] = mySource.[VendorId]
     , myTarget.[ShowOnHomePage] = mySource.[ShowOnHomePage]
     , myTarget.[MetaKeywords] = mySource.[MetaKeywords]
     , myTarget.[MetaDescription] = mySource.[MetaDescription]
     , myTarget.[MetaTitle] = mySource.[MetaTitle]
     , myTarget.[AllowCustomerReviews] = mySource.[AllowCustomerReviews]
     , myTarget.[ApprovedRatingSum] = mySource.[ApprovedRatingSum]
     , myTarget.[NotApprovedRatingSum] = mySource.[NotApprovedRatingSum]
     , myTarget.[ApprovedTotalReviews] = mySource.[ApprovedTotalReviews]
     , myTarget.[NotApprovedTotalReviews] = mySource.[NotApprovedTotalReviews]
     , myTarget.[SubjectToAcl] = mySource.[SubjectToAcl]
     , myTarget.[LimitedToStores] = mySource.[LimitedToStores]
     , myTarget.[Sku] = mySource.[Sku]
     , myTarget.[ManufacturerPartNumber] = mySource.[ManufacturerPartNumber]
     , myTarget.[Gtin] = mySource.[Gtin]
     , myTarget.[IsGiftCard] = mySource.[IsGiftCard]
     , myTarget.[GiftCardTypeId] = mySource.[GiftCardTypeId]
     , myTarget.[RequireOtherProducts] = mySource.[RequireOtherProducts]
     , myTarget.[RequiredProductIds] = mySource.[RequiredProductIds]
     , myTarget.[AutomaticallyAddRequiredProducts] = mySource.[AutomaticallyAddRequiredProducts]
     , myTarget.[IsDownload] = mySource.[IsDownload]
     , myTarget.[DownloadId] = mySource.[DownloadId]
     , myTarget.[UnlimitedDownloads] = mySource.[UnlimitedDownloads]
     , myTarget.[MaxNumberOfDownloads] = mySource.[MaxNumberOfDownloads]
     , myTarget.[DownloadExpirationDays] = mySource.[DownloadExpirationDays]
     , myTarget.[DownloadActivationTypeId] = mySource.[DownloadActivationTypeId]
     , myTarget.[HasSampleDownload] = mySource.[HasSampleDownload]
     , myTarget.[SampleDownloadId] = mySource.[SampleDownloadId]
     , myTarget.[HasUserAgreement] = mySource.[HasUserAgreement]
     , myTarget.[UserAgreementText] = mySource.[UserAgreementText]
     , myTarget.[IsRecurring] = mySource.[IsRecurring]
     , myTarget.[RecurringCycleLength] = mySource.[RecurringCycleLength]
     , myTarget.[RecurringCyclePeriodId] = mySource.[RecurringCyclePeriodId]
     , myTarget.[RecurringTotalCycles] = mySource.[RecurringTotalCycles]
     , myTarget.[IsRental] = mySource.[IsRental]
     , myTarget.[RentalPriceLength] = mySource.[RentalPriceLength]
     , myTarget.[RentalPricePeriodId] = mySource.[RentalPricePeriodId]
     , myTarget.[IsShipEnabled] = mySource.[IsShipEnabled]
     , myTarget.[IsFreeShipping] = mySource.[IsFreeShipping]
     , myTarget.[ShipSeparately] = mySource.[ShipSeparately]
     , myTarget.[AdditionalShippingCharge] = mySource.[AdditionalShippingCharge]
     , myTarget.[DeliveryDateId] = mySource.[DeliveryDateId]
     , myTarget.[IsTaxExempt] = mySource.[IsTaxExempt]
     , myTarget.[TaxCategoryId] = mySource.[TaxCategoryId]
     , myTarget.[IsTelecommunicationsOrBroadcastingOrElectronicServices] = mySource.[IsTelecommunicationsOrBroadcastingOrElectronicServices]
     , myTarget.[ManageInventoryMethodId] = mySource.[ManageInventoryMethodId]
     , myTarget.[UseMultipleWarehouses] = mySource.[UseMultipleWarehouses]
     , myTarget.[WarehouseId] = mySource.[WarehouseId]
     , myTarget.[StockQuantity] = mySource.[StockQuantity]
     , myTarget.[DisplayStockAvailability] = mySource.[DisplayStockAvailability]
     , myTarget.[DisplayStockQuantity] = mySource.[DisplayStockQuantity]
     , myTarget.[MinStockQuantity] = mySource.[MinStockQuantity]
     , myTarget.[LowStockActivityId] = mySource.[LowStockActivityId]
     , myTarget.[NotifyAdminForQuantityBelow] = mySource.[NotifyAdminForQuantityBelow]
     , myTarget.[BackorderModeId] = mySource.[BackorderModeId]
     , myTarget.[AllowBackInStockSubscriptions] = mySource.[AllowBackInStockSubscriptions]
     , myTarget.[OrderMinimumQuantity] = mySource.[OrderMinimumQuantity]
     , myTarget.[OrderMaximumQuantity] = mySource.[OrderMaximumQuantity]
     , myTarget.[AllowedQuantities] = mySource.[AllowedQuantities]
     , myTarget.[AllowAddingOnlyExistingAttributeCombinations] = mySource.[AllowAddingOnlyExistingAttributeCombinations]
     , myTarget.[DisableBuyButton] = mySource.[DisableBuyButton]
     , myTarget.[DisableWishlistButton] = mySource.[DisableWishlistButton]
     , myTarget.[AvailableForPreOrder] = mySource.[AvailableForPreOrder]
     , myTarget.[PreOrderAvailabilityStartDateTimeUtc] = mySource.[PreOrderAvailabilityStartDateTimeUtc]
     , myTarget.[CallForPrice] = mySource.[CallForPrice]
     , myTarget.[Price] = mySource.[Price]
     , myTarget.[OldPrice] = mySource.[OldPrice]
     , myTarget.[ProductCost] = mySource.[ProductCost]
     , myTarget.[SpecialPrice] = mySource.[SpecialPrice]
     , myTarget.[SpecialPriceStartDateTimeUtc] = mySource.[SpecialPriceStartDateTimeUtc]
     , myTarget.[SpecialPriceEndDateTimeUtc] = mySource.[SpecialPriceEndDateTimeUtc]
     , myTarget.[CustomerEntersPrice] = mySource.[CustomerEntersPrice]
     , myTarget.[MinimumCustomerEnteredPrice] = mySource.[MinimumCustomerEnteredPrice]
     , myTarget.[MaximumCustomerEnteredPrice] = mySource.[MaximumCustomerEnteredPrice]
     , myTarget.[HasTierPrices] = mySource.[HasTierPrices]
     , myTarget.[HasDiscountsApplied] = mySource.[HasDiscountsApplied]
     , myTarget.[Weight] = mySource.[Weight]
     , myTarget.[Length] = mySource.[Length]
     , myTarget.[Width] = mySource.[Width]
     , myTarget.[Height] = mySource.[Height]
     , myTarget.[AvailableStartDateTimeUtc] = mySource.[AvailableStartDateTimeUtc]
     , myTarget.[AvailableEndDateTimeUtc] = mySource.[AvailableEndDateTimeUtc]
     , myTarget.[DisplayOrder] = mySource.[DisplayOrder]
     , myTarget.[Published] = mySource.[Published]
     , myTarget.[Deleted] = mySource.[Deleted]
     , myTarget.[CreatedOnUtc] = mySource.[CreatedOnUtc]
     , myTarget.[UpdatedOnUtc] = mySource.[UpdatedOnUtc]
     , myTarget.[Video] = mySource.[Video]
     , myTarget.[SizeChartId] = mySource.[SizeChartId]
     , myTarget.[AvailabilityId] = mySource.[AvailabilityId]
     
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
     ,[ProductTypeId]
     ,[ParentGroupedProductId]
     ,[VisibleIndividually]
     ,[Name]
     ,[ShortDescription]
     ,[FullDescription]
     ,[AdminComment]
     ,[ProductTemplateId]
     ,[VendorId]
     ,[ShowOnHomePage]
     ,[MetaKeywords]
     ,[MetaDescription]
     ,[MetaTitle]
     ,[AllowCustomerReviews]
     ,[ApprovedRatingSum]
     ,[NotApprovedRatingSum]
     ,[ApprovedTotalReviews]
     ,[NotApprovedTotalReviews]
     ,[SubjectToAcl]
     ,[LimitedToStores]
     ,[Sku]
     ,[ManufacturerPartNumber]
     ,[Gtin]
     ,[IsGiftCard]
     ,[GiftCardTypeId]
     ,[RequireOtherProducts]
     ,[RequiredProductIds]
     ,[AutomaticallyAddRequiredProducts]
     ,[IsDownload]
     ,[DownloadId]
     ,[UnlimitedDownloads]
     ,[MaxNumberOfDownloads]
     ,[DownloadExpirationDays]
     ,[DownloadActivationTypeId]
     ,[HasSampleDownload]
     ,[SampleDownloadId]
     ,[HasUserAgreement]
     ,[UserAgreementText]
     ,[IsRecurring]
     ,[RecurringCycleLength]
     ,[RecurringCyclePeriodId]
     ,[RecurringTotalCycles]
     ,[IsRental]
     ,[RentalPriceLength]
     ,[RentalPricePeriodId]
     ,[IsShipEnabled]
     ,[IsFreeShipping]
     ,[ShipSeparately]
     ,[AdditionalShippingCharge]
     ,[DeliveryDateId]
     ,[IsTaxExempt]
     ,[TaxCategoryId]
     ,[IsTelecommunicationsOrBroadcastingOrElectronicServices]
     ,[ManageInventoryMethodId]
     ,[UseMultipleWarehouses]
     ,[WarehouseId]
     ,[StockQuantity]
     ,[DisplayStockAvailability]
     ,[DisplayStockQuantity]
     ,[MinStockQuantity]
     ,[LowStockActivityId]
     ,[NotifyAdminForQuantityBelow]
     ,[BackorderModeId]
     ,[AllowBackInStockSubscriptions]
     ,[OrderMinimumQuantity]
     ,[OrderMaximumQuantity]
     ,[AllowedQuantities]
     ,[AllowAddingOnlyExistingAttributeCombinations]
     ,[DisableBuyButton]
     ,[DisableWishlistButton]
     ,[AvailableForPreOrder]
     ,[PreOrderAvailabilityStartDateTimeUtc]
     ,[CallForPrice]
     ,[Price]
     ,[OldPrice]
     ,[ProductCost]
     ,[SpecialPrice]
     ,[SpecialPriceStartDateTimeUtc]
     ,[SpecialPriceEndDateTimeUtc]
     ,[CustomerEntersPrice]
     ,[MinimumCustomerEnteredPrice]
     ,[MaximumCustomerEnteredPrice]
     ,[HasTierPrices]
     ,[HasDiscountsApplied]
     ,[Weight]
     ,[Length]
     ,[Width]
     ,[Height]
     ,[AvailableStartDateTimeUtc]
     ,[AvailableEndDateTimeUtc]
     ,[DisplayOrder]
     ,[Published]
     ,[Deleted]
     ,[CreatedOnUtc]
     ,[UpdatedOnUtc]
     ,[Video]
     ,[SizeChartId]
     ,[AvailabilityId]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[LastTimeStamp]
     ,mySource.[Id]
     ,mySource.[ProductTypeId]
     ,mySource.[ParentGroupedProductId]
     ,mySource.[VisibleIndividually]
     ,mySource.[Name]
     ,mySource.[ShortDescription]
     ,mySource.[FullDescription]
     ,mySource.[AdminComment]
     ,mySource.[ProductTemplateId]
     ,mySource.[VendorId]
     ,mySource.[ShowOnHomePage]
     ,mySource.[MetaKeywords]
     ,mySource.[MetaDescription]
     ,mySource.[MetaTitle]
     ,mySource.[AllowCustomerReviews]
     ,mySource.[ApprovedRatingSum]
     ,mySource.[NotApprovedRatingSum]
     ,mySource.[ApprovedTotalReviews]
     ,mySource.[NotApprovedTotalReviews]
     ,mySource.[SubjectToAcl]
     ,mySource.[LimitedToStores]
     ,mySource.[Sku]
     ,mySource.[ManufacturerPartNumber]
     ,mySource.[Gtin]
     ,mySource.[IsGiftCard]
     ,mySource.[GiftCardTypeId]
     ,mySource.[RequireOtherProducts]
     ,mySource.[RequiredProductIds]
     ,mySource.[AutomaticallyAddRequiredProducts]
     ,mySource.[IsDownload]
     ,mySource.[DownloadId]
     ,mySource.[UnlimitedDownloads]
     ,mySource.[MaxNumberOfDownloads]
     ,mySource.[DownloadExpirationDays]
     ,mySource.[DownloadActivationTypeId]
     ,mySource.[HasSampleDownload]
     ,mySource.[SampleDownloadId]
     ,mySource.[HasUserAgreement]
     ,mySource.[UserAgreementText]
     ,mySource.[IsRecurring]
     ,mySource.[RecurringCycleLength]
     ,mySource.[RecurringCyclePeriodId]
     ,mySource.[RecurringTotalCycles]
     ,mySource.[IsRental]
     ,mySource.[RentalPriceLength]
     ,mySource.[RentalPricePeriodId]
     ,mySource.[IsShipEnabled]
     ,mySource.[IsFreeShipping]
     ,mySource.[ShipSeparately]
     ,mySource.[AdditionalShippingCharge]
     ,mySource.[DeliveryDateId]
     ,mySource.[IsTaxExempt]
     ,mySource.[TaxCategoryId]
     ,mySource.[IsTelecommunicationsOrBroadcastingOrElectronicServices]
     ,mySource.[ManageInventoryMethodId]
     ,mySource.[UseMultipleWarehouses]
     ,mySource.[WarehouseId]
     ,mySource.[StockQuantity]
     ,mySource.[DisplayStockAvailability]
     ,mySource.[DisplayStockQuantity]
     ,mySource.[MinStockQuantity]
     ,mySource.[LowStockActivityId]
     ,mySource.[NotifyAdminForQuantityBelow]
     ,mySource.[BackorderModeId]
     ,mySource.[AllowBackInStockSubscriptions]
     ,mySource.[OrderMinimumQuantity]
     ,mySource.[OrderMaximumQuantity]
     ,mySource.[AllowedQuantities]
     ,mySource.[AllowAddingOnlyExistingAttributeCombinations]
     ,mySource.[DisableBuyButton]
     ,mySource.[DisableWishlistButton]
     ,mySource.[AvailableForPreOrder]
     ,mySource.[PreOrderAvailabilityStartDateTimeUtc]
     ,mySource.[CallForPrice]
     ,mySource.[Price]
     ,mySource.[OldPrice]
     ,mySource.[ProductCost]
     ,mySource.[SpecialPrice]
     ,mySource.[SpecialPriceStartDateTimeUtc]
     ,mySource.[SpecialPriceEndDateTimeUtc]
     ,mySource.[CustomerEntersPrice]
     ,mySource.[MinimumCustomerEnteredPrice]
     ,mySource.[MaximumCustomerEnteredPrice]
     ,mySource.[HasTierPrices]
     ,mySource.[HasDiscountsApplied]
     ,mySource.[Weight]
     ,mySource.[Length]
     ,mySource.[Width]
     ,mySource.[Height]
     ,mySource.[AvailableStartDateTimeUtc]
     ,mySource.[AvailableEndDateTimeUtc]
     ,mySource.[DisplayOrder]
     ,mySource.[Published]
     ,mySource.[Deleted]
     ,mySource.[CreatedOnUtc]
     ,mySource.[UpdatedOnUtc]
     ,mySource.[Video]
     ,mySource.[SizeChartId]
     ,mySource.[AvailabilityId]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_Product WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_Product WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
