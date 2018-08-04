SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [ods].[vw_Merch_LoadFactPointOfSale]
AS


SELECT MO.ETL_ID,
	MO.Id AS SSID,
	ISNULL(DD1.DimDateId,-1) AS DimDateId_SaleDate,
	ISNULL(DD2.DimDateId,-1) AS DimDateId_PaymentDate,
	ISNULL(DD3.DimDateId,-1) AS DimDateId_ShipmentDate,
	ISNULL(DD4.DimDateId,-1) AS DimDateId_DeliveryDate,
	ISNULL(DA.DimAccountId,-1) AS DimAccountId,
	0 AS DimEventHeaderId, 
	ISNULL(DS.DimStoreId,-1) AS DimStoreId,
	0 AS DimRevenueCenterId,
	0 AS DimWorkstationId,
	0 AS DimEmployeeId,
	MO.CreatedOnUtc AS SaleDate,
	MO.PaidDateUtc AS PaymentDate,
	MS.ShippedDateUtc AS ShipmentDate,
	MS.DeliveryDateUtc AS DeliveryDate,
	MO.OrderSubtotalExclTax AS SubTotal,
	MO.OrderTax AS Tax,
	MO.OrderShippingExclTax AS Shipping,
	MO.PaymentMethodAdditionalFeeExclTax AS Other,
	MO.OrderSubTotalDiscountExclTax AS Discount,
	ISNULL(GC.GiftCardValue,0) AS GiftCardAmtApplied,
	MO.OrderTotal,
	MO.RefundedAmount AS Refund,
	CONVERT(NVARCHAR(255),MO.OrderGuid) AS OrderId,
	MO.PaymentMethodSystemName AS PaymentMethod,
	MO.ShippingMethod,
	MO.CustomerId,
	MO.CustomerCurrencyCode AS CurrencyType,
	MO.Deleted,
	MO.ETL_UpdatedDate,
	'Merch' AS SourceSystem
FROM ods.Merch_Order MO
LEFT JOIN (SELECT DISTINCT OrderId, MAX(ShippedDateUtc) ShippedDateUtc, MAX(DeliveryDateUtc) DeliveryDateUtc
			FROM ods.Merch_Shipment
			GROUP BY OrderId) MS
	ON MO.Id = MS.OrderId
LEFT JOIN dbo.DimPOSAccount DA
	ON MO.CustomerId = DA.ETL_SSID_Id
LEFT JOIN dbo.DimStore DS
	ON MO.StoreId = DS.ETL_SSID_Id
LEFT JOIN (SELECT UsedWithOrderId AS OrderId, SUM(UsedValue) AS GiftCardValue
			FROM ods.Merch_GiftCardUsageHistory
			GROUP BY UsedWithOrderId) GC
	ON MO.Id = GC.OrderId
LEFT JOIN dbo.DimDate DD1
	ON CONVERT(DATE,MO.CreatedOnUtc) = DD1.CalDate
LEFT JOIN dbo.DimDate DD2
	ON CONVERT(DATE,MO.PaidDateUtc) = DD2.CalDate
LEFT JOIN dbo.DimDate DD3
	ON CONVERT(DATE,MS.ShippedDateUtc) = DD3.CalDate
LEFT JOIN dbo.DimDate DD4
	ON CONVERT(DATE,MS.DeliveryDateUtc) = DD4.CalDate
WHERE ISNULL(DS.ETL_SSID_Id,0) = 1		-- Steelers store
--AND DA.SourceSystem = 'Merch'
;















GO
