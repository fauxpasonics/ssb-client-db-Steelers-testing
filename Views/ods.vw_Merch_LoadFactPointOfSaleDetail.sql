SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [ods].[vw_Merch_LoadFactPointOfSaleDetail]
AS


SELECT MOI.ETL_ID,
	MOI.Id AS SSID,
	POS.FactPointOfSaleId,
	COALESCE(DP.DimProductId, MOI.ProductID, -1) AS DimProductId,
	MOI.Quantity,
	MOI.UnitPriceExclTax AS UnitPrice,
	MOI.DiscountAmountExclTax AS Discount,
	MOI.PriceExclTax AS TotalPrice,
	MOI.AttributeDescription AS ItemAttribute,
	MOI.ETL_UpdatedDate,
	'Merch' AS SourceSystem
FROM ods.Merch_OrderItem MOI
JOIN dbo.FactPointOfSale POS
	ON MOI.OrderId = POS.ETL_SSID
LEFT JOIN dbo.DimPOSProduct DP
	ON MOI.ProductID = DP.ETL_SSID
;





GO
