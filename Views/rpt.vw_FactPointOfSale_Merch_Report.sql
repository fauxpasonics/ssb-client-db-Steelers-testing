SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [rpt].[vw_FactPointOfSale_Merch_Report]
AS

SELECT POS.[FactPointOfSaleId]
      ,POS.[ETL_CreatedDate]
      ,POS.[ETL_UpdatedDate]
      ,POS.[ETL_IsDeleted]
      ,POS.[ETL_DeleteDate]
      ,POS.[ETL_SourceSystem]
      ,POS.[ETL_DeltaHashKey]
      ,POS.[ETL_SSID]
      ,POS.[ETL_SSID_Id]
      ,POS.[DimDateId_SaleDate]
      ,POS.[DimDateId_PaymentDate]
      ,POS.[DimDateId_ShipmentDate]
      ,POS.[DimDateId_DeliveryDate]
      ,POS.[DimAccountId]
      ,POS.[DimEventHeaderId]
      ,POS.[DimStoreId]
      ,POS.[DimRevenueCenterId]
      ,POS.[DimWorkstationId]
      ,POS.[DimEmployeeId]
	  ,MO.PickUpInStore
	  ,MO.OrderStatusId
	  ,MO.ShippingStatusId
	  ,MO.PaymentStatusId
      ,POS.[SaleDate]
      ,POS.[PaymentDate]
      ,POS.[ShipmentDate]
      ,POS.[DeliveryDate]
      ,POS.[SubTotal]
      ,POS.[Tax]
      ,POS.[Shipping]
      ,POS.[Other]
      ,POS.[Discount]
      ,POS.[GiftCardAmtApplied]
      ,POS.[OrderTotal]
      ,POS.[Refund]
      ,POS.[OrderId]
      ,POS.[PaymentMethod]
      ,POS.[ShippingMethod]
      ,POS.[CustomerId]
      ,POS.[CurrencyType]
  FROM [dbo].[FactPointOfSale] POS WITH (NOLOCK)
LEFT JOIN ods.Merch_Order mo WITH (NOLOCK) ON mo.id = POS.ETL_SSID_Id
WHERE POS.DimStoreId = 1 
;








GO
