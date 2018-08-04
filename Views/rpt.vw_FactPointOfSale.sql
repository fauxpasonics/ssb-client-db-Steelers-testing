SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [rpt].[vw_FactPointOfSale] WITH SCHEMABINDING
AS


SELECT FactPointOfSaleId, ETL_CreatedDate, ETL_UpdatedDate, ETL_DeltaHashKey, ETL_SSID,
	DimDateId_SaleDate, DimDateId_PaymentDate, DimDateId_ShipmentDate, DimDateId_DeliveryDate, DimAccountId, DimEventHeaderId, DimStoreId, DimRevenueCenterId,
	DimWorkstationId, DimEmployeeId, SaleDate, PaymentDate, ShipmentDate, DeliveryDate, SubTotal, Tax, Shipping, Other, Discount, GiftCardAmtApplied, OrderTotal,
	Refund, OrderId, PaymentMethod, ShippingMethod, CustomerId, CurrencyType
FROM dbo.FactPointOfSale (nolock)


;




GO
