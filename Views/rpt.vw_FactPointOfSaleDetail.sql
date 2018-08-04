SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [rpt].[vw_FactPointOfSaleDetail] WITH SCHEMABINDING
AS


SELECT FactPointOfSaleDetailId, ETL_CreatedDate, ETL_UpdatedDate, ETL_DeltaHashKey,
	ETL_SSID, FactPointOfSaleId, DimProductId, Quantity, UnitPrice, Discount, TotalPrice, ItemAttribute
FROM dbo.FactPointOfSaleDetail (nolock)


;




GO
