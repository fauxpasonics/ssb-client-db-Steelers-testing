SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [rpt].[vw_DimPOSProduct] WITH SCHEMABINDING
AS


SELECT DimProductID, ETL_CreatedDate, ETL_UpdatedDate, ETL_IsDeleted, ETL_DeletedDate, ETL_SSID, ETL_DeltaHashKey, ETL_SourceSystem,
	ProductTypeId, ProductName, Sku, Price
FROM dbo.DimPOSProduct
;




GO
