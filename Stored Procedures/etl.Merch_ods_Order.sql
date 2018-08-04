SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Merch_ods_Order]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Merch_Order),'0');	
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
,  Id, AffiliateId, Deleted, CreatedOnUtc, LastTimeStamp, OrderGuid, StoreId, CustomerId, BillingAddressId, ShippingAddressId, PickUpInStore, OrderStatusId, ShippingStatusId, PaymentStatusId, PaymentMethodSystemName, CustomerCurrencyCode, CurrencyRate, CustomerTaxDisplayTypeId, VatNumber, OrderSubtotalInclTax, OrderSubtotalExclTax, OrderSubTotalDiscountInclTax, OrderSubTotalDiscountExclTax, OrderShippingInclTax, OrderShippingExclTax, PaymentMethodAdditionalFeeInclTax, PaymentMethodAdditionalFeeExclTax, TaxRates, OrderTax, OrderDiscount, OrderTotal, RefundedAmount, RewardPointsWereAdded, CheckoutAttributeDescription, CheckoutAttributesXml, CustomerLanguageId, CustomerIp, AllowStoringCreditCardNumber, CardType, CardName, CardNumber, MaskedCreditCardNumber, CardCvv2, CardExpirationMonth, CardExpirationYear, AuthorizationTransactionId, AuthorizationTransactionCode, AuthorizationTransactionResult, CaptureTransactionId, CaptureTransactionResult, SubscriptionTransactionId, PaidDateUtc, ShippingMethod, ShippingRateComputationMethodSystemName, CustomValuesXml
INTO #SrcData
FROM (
	SELECT  Id, AffiliateId, Deleted, CreatedOnUtc, LastTimeStamp, OrderGuid, StoreId, CustomerId, BillingAddressId, ShippingAddressId, PickUpInStore, OrderStatusId, ShippingStatusId, PaymentStatusId, PaymentMethodSystemName, CustomerCurrencyCode, CurrencyRate, CustomerTaxDisplayTypeId, VatNumber, OrderSubtotalInclTax, OrderSubtotalExclTax, OrderSubTotalDiscountInclTax, OrderSubTotalDiscountExclTax, OrderShippingInclTax, OrderShippingExclTax, PaymentMethodAdditionalFeeInclTax, PaymentMethodAdditionalFeeExclTax, TaxRates, OrderTax, OrderDiscount, OrderTotal, RefundedAmount, RewardPointsWereAdded, CheckoutAttributeDescription, CheckoutAttributesXml, CustomerLanguageId, CustomerIp, AllowStoringCreditCardNumber, CardType, CardName, CardNumber, MaskedCreditCardNumber, CardCvv2, CardExpirationMonth, CardExpirationYear, AuthorizationTransactionId, AuthorizationTransactionCode, AuthorizationTransactionResult, CaptureTransactionId, CaptureTransactionResult, SubscriptionTransactionId, PaidDateUtc, ShippingMethod, ShippingRateComputationMethodSystemName, CustomValuesXml
	, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY ETL_ID) RowRank
	FROM src.Merch_Order
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),AffiliateId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),AllowStoringCreditCardNumber)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),BillingAddressId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedOnUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),CurrencyRate)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),CustomerId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),CustomerLanguageId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),CustomerTaxDisplayTypeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),Deleted)),'DBNULL_BIT') + ISNULL(RTRIM(Id),'DBNULL_TEXT') + ISNULL(RTRIM(LastTimeStamp),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),OrderDiscount)),'DBNULL_NUMBER') + ISNULL(RTRIM(OrderGuid),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),OrderShippingExclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),OrderShippingInclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),OrderStatusId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),OrderSubTotalDiscountExclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),OrderSubTotalDiscountInclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),OrderSubtotalExclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),OrderSubtotalInclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),OrderTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),OrderTotal)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PaidDateUtc)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),PaymentMethodAdditionalFeeExclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PaymentMethodAdditionalFeeInclTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),PaymentStatusId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),PickUpInStore)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),RefundedAmount)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),RewardPointsWereAdded)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),ShippingAddressId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ShippingStatusId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),StoreId)),'DBNULL_INT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (Id)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Merch_Order AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.Id = mySource.Id

WHEN MATCHED AND @DisableUpdate = 'false' AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.PaymentMethodSystemName,'') <> ISNULL(myTarget.PaymentMethodSystemName,'') OR ISNULL(mySource.CustomerCurrencyCode,'') <> ISNULL(myTarget.CustomerCurrencyCode,'') OR ISNULL(mySource.VatNumber,'') <> ISNULL(myTarget.VatNumber,'') OR ISNULL(mySource.TaxRates,'') <> ISNULL(myTarget.TaxRates,'') OR ISNULL(mySource.CheckoutAttributeDescription,'') <> ISNULL(myTarget.CheckoutAttributeDescription,'') OR ISNULL(mySource.CheckoutAttributesXml,'') <> ISNULL(myTarget.CheckoutAttributesXml,'') OR ISNULL(mySource.CustomerIp,'') <> ISNULL(myTarget.CustomerIp,'') OR ISNULL(mySource.CardType,'') <> ISNULL(myTarget.CardType,'') OR ISNULL(mySource.CardName,'') <> ISNULL(myTarget.CardName,'') OR ISNULL(mySource.CardNumber,'') <> ISNULL(myTarget.CardNumber,'') OR ISNULL(mySource.MaskedCreditCardNumber,'') <> ISNULL(myTarget.MaskedCreditCardNumber,'') OR ISNULL(mySource.CardCvv2,'') <> ISNULL(myTarget.CardCvv2,'') OR ISNULL(mySource.CardExpirationMonth,'') <> ISNULL(myTarget.CardExpirationMonth,'') OR ISNULL(mySource.CardExpirationYear,'') <> ISNULL(myTarget.CardExpirationYear,'') OR ISNULL(mySource.AuthorizationTransactionId,'') <> ISNULL(myTarget.AuthorizationTransactionId,'') OR ISNULL(mySource.AuthorizationTransactionCode,'') <> ISNULL(myTarget.AuthorizationTransactionCode,'') OR ISNULL(mySource.AuthorizationTransactionResult,'') <> ISNULL(myTarget.AuthorizationTransactionResult,'') OR ISNULL(mySource.CaptureTransactionId,'') <> ISNULL(myTarget.CaptureTransactionId,'') OR ISNULL(mySource.CaptureTransactionResult,'') <> ISNULL(myTarget.CaptureTransactionResult,'') OR ISNULL(mySource.SubscriptionTransactionId,'') <> ISNULL(myTarget.SubscriptionTransactionId,'') OR ISNULL(mySource.ShippingMethod,'') <> ISNULL(myTarget.ShippingMethod,'') OR ISNULL(mySource.ShippingRateComputationMethodSystemName,'') <> ISNULL(myTarget.ShippingRateComputationMethodSystemName,'') OR ISNULL(mySource.CustomValuesXml,'') <> ISNULL(myTarget.CustomValuesXml,'') 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[Id] = mySource.[Id]
     , myTarget.[AffiliateId] = mySource.[AffiliateId]
     , myTarget.[Deleted] = mySource.[Deleted]
     , myTarget.[CreatedOnUtc] = mySource.[CreatedOnUtc]
     , myTarget.[LastTimeStamp] = mySource.[LastTimeStamp]
     , myTarget.[OrderGuid] = mySource.[OrderGuid]
     , myTarget.[StoreId] = mySource.[StoreId]
     , myTarget.[CustomerId] = mySource.[CustomerId]
     , myTarget.[BillingAddressId] = mySource.[BillingAddressId]
     , myTarget.[ShippingAddressId] = mySource.[ShippingAddressId]
     , myTarget.[PickUpInStore] = mySource.[PickUpInStore]
     , myTarget.[OrderStatusId] = mySource.[OrderStatusId]
     , myTarget.[ShippingStatusId] = mySource.[ShippingStatusId]
     , myTarget.[PaymentStatusId] = mySource.[PaymentStatusId]
     , myTarget.[PaymentMethodSystemName] = mySource.[PaymentMethodSystemName]
     , myTarget.[CustomerCurrencyCode] = mySource.[CustomerCurrencyCode]
     , myTarget.[CurrencyRate] = mySource.[CurrencyRate]
     , myTarget.[CustomerTaxDisplayTypeId] = mySource.[CustomerTaxDisplayTypeId]
     , myTarget.[VatNumber] = mySource.[VatNumber]
     , myTarget.[OrderSubtotalInclTax] = mySource.[OrderSubtotalInclTax]
     , myTarget.[OrderSubtotalExclTax] = mySource.[OrderSubtotalExclTax]
     , myTarget.[OrderSubTotalDiscountInclTax] = mySource.[OrderSubTotalDiscountInclTax]
     , myTarget.[OrderSubTotalDiscountExclTax] = mySource.[OrderSubTotalDiscountExclTax]
     , myTarget.[OrderShippingInclTax] = mySource.[OrderShippingInclTax]
     , myTarget.[OrderShippingExclTax] = mySource.[OrderShippingExclTax]
     , myTarget.[PaymentMethodAdditionalFeeInclTax] = mySource.[PaymentMethodAdditionalFeeInclTax]
     , myTarget.[PaymentMethodAdditionalFeeExclTax] = mySource.[PaymentMethodAdditionalFeeExclTax]
     , myTarget.[TaxRates] = mySource.[TaxRates]
     , myTarget.[OrderTax] = mySource.[OrderTax]
     , myTarget.[OrderDiscount] = mySource.[OrderDiscount]
     , myTarget.[OrderTotal] = mySource.[OrderTotal]
     , myTarget.[RefundedAmount] = mySource.[RefundedAmount]
     , myTarget.[RewardPointsWereAdded] = mySource.[RewardPointsWereAdded]
     , myTarget.[CheckoutAttributeDescription] = mySource.[CheckoutAttributeDescription]
     , myTarget.[CheckoutAttributesXml] = mySource.[CheckoutAttributesXml]
     , myTarget.[CustomerLanguageId] = mySource.[CustomerLanguageId]
     , myTarget.[CustomerIp] = mySource.[CustomerIp]
     , myTarget.[AllowStoringCreditCardNumber] = mySource.[AllowStoringCreditCardNumber]
     , myTarget.[CardType] = mySource.[CardType]
     , myTarget.[CardName] = mySource.[CardName]
     , myTarget.[CardNumber] = mySource.[CardNumber]
     , myTarget.[MaskedCreditCardNumber] = mySource.[MaskedCreditCardNumber]
     , myTarget.[CardCvv2] = mySource.[CardCvv2]
     , myTarget.[CardExpirationMonth] = mySource.[CardExpirationMonth]
     , myTarget.[CardExpirationYear] = mySource.[CardExpirationYear]
     , myTarget.[AuthorizationTransactionId] = mySource.[AuthorizationTransactionId]
     , myTarget.[AuthorizationTransactionCode] = mySource.[AuthorizationTransactionCode]
     , myTarget.[AuthorizationTransactionResult] = mySource.[AuthorizationTransactionResult]
     , myTarget.[CaptureTransactionId] = mySource.[CaptureTransactionId]
     , myTarget.[CaptureTransactionResult] = mySource.[CaptureTransactionResult]
     , myTarget.[SubscriptionTransactionId] = mySource.[SubscriptionTransactionId]
     , myTarget.[PaidDateUtc] = mySource.[PaidDateUtc]
     , myTarget.[ShippingMethod] = mySource.[ShippingMethod]
     , myTarget.[ShippingRateComputationMethodSystemName] = mySource.[ShippingRateComputationMethodSystemName]
     , myTarget.[CustomValuesXml] = mySource.[CustomValuesXml]
     
WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target AND @DisableInsert = 'false'
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[Id]
     ,[AffiliateId]
     ,[Deleted]
     ,[CreatedOnUtc]
     ,[LastTimeStamp]
     ,[OrderGuid]
     ,[StoreId]
     ,[CustomerId]
     ,[BillingAddressId]
     ,[ShippingAddressId]
     ,[PickUpInStore]
     ,[OrderStatusId]
     ,[ShippingStatusId]
     ,[PaymentStatusId]
     ,[PaymentMethodSystemName]
     ,[CustomerCurrencyCode]
     ,[CurrencyRate]
     ,[CustomerTaxDisplayTypeId]
     ,[VatNumber]
     ,[OrderSubtotalInclTax]
     ,[OrderSubtotalExclTax]
     ,[OrderSubTotalDiscountInclTax]
     ,[OrderSubTotalDiscountExclTax]
     ,[OrderShippingInclTax]
     ,[OrderShippingExclTax]
     ,[PaymentMethodAdditionalFeeInclTax]
     ,[PaymentMethodAdditionalFeeExclTax]
     ,[TaxRates]
     ,[OrderTax]
     ,[OrderDiscount]
     ,[OrderTotal]
     ,[RefundedAmount]
     ,[RewardPointsWereAdded]
     ,[CheckoutAttributeDescription]
     ,[CheckoutAttributesXml]
     ,[CustomerLanguageId]
     ,[CustomerIp]
     ,[AllowStoringCreditCardNumber]
     ,[CardType]
     ,[CardName]
     ,[CardNumber]
     ,[MaskedCreditCardNumber]
     ,[CardCvv2]
     ,[CardExpirationMonth]
     ,[CardExpirationYear]
     ,[AuthorizationTransactionId]
     ,[AuthorizationTransactionCode]
     ,[AuthorizationTransactionResult]
     ,[CaptureTransactionId]
     ,[CaptureTransactionResult]
     ,[SubscriptionTransactionId]
     ,[PaidDateUtc]
     ,[ShippingMethod]
     ,[ShippingRateComputationMethodSystemName]
     ,[CustomValuesXml]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[Id]
     ,mySource.[AffiliateId]
     ,mySource.[Deleted]
     ,mySource.[CreatedOnUtc]
     ,mySource.[LastTimeStamp]
     ,mySource.[OrderGuid]
     ,mySource.[StoreId]
     ,mySource.[CustomerId]
     ,mySource.[BillingAddressId]
     ,mySource.[ShippingAddressId]
     ,mySource.[PickUpInStore]
     ,mySource.[OrderStatusId]
     ,mySource.[ShippingStatusId]
     ,mySource.[PaymentStatusId]
     ,mySource.[PaymentMethodSystemName]
     ,mySource.[CustomerCurrencyCode]
     ,mySource.[CurrencyRate]
     ,mySource.[CustomerTaxDisplayTypeId]
     ,mySource.[VatNumber]
     ,mySource.[OrderSubtotalInclTax]
     ,mySource.[OrderSubtotalExclTax]
     ,mySource.[OrderSubTotalDiscountInclTax]
     ,mySource.[OrderSubTotalDiscountExclTax]
     ,mySource.[OrderShippingInclTax]
     ,mySource.[OrderShippingExclTax]
     ,mySource.[PaymentMethodAdditionalFeeInclTax]
     ,mySource.[PaymentMethodAdditionalFeeExclTax]
     ,mySource.[TaxRates]
     ,mySource.[OrderTax]
     ,mySource.[OrderDiscount]
     ,mySource.[OrderTotal]
     ,mySource.[RefundedAmount]
     ,mySource.[RewardPointsWereAdded]
     ,mySource.[CheckoutAttributeDescription]
     ,mySource.[CheckoutAttributesXml]
     ,mySource.[CustomerLanguageId]
     ,mySource.[CustomerIp]
     ,mySource.[AllowStoringCreditCardNumber]
     ,mySource.[CardType]
     ,mySource.[CardName]
     ,mySource.[CardNumber]
     ,mySource.[MaskedCreditCardNumber]
     ,mySource.[CardCvv2]
     ,mySource.[CardExpirationMonth]
     ,mySource.[CardExpirationYear]
     ,mySource.[AuthorizationTransactionId]
     ,mySource.[AuthorizationTransactionCode]
     ,mySource.[AuthorizationTransactionResult]
     ,mySource.[CaptureTransactionId]
     ,mySource.[CaptureTransactionResult]
     ,mySource.[SubscriptionTransactionId]
     ,mySource.[PaidDateUtc]
     ,mySource.[ShippingMethod]
     ,mySource.[ShippingRateComputationMethodSystemName]
     ,mySource.[CustomValuesXml]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_Order WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_Order WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
