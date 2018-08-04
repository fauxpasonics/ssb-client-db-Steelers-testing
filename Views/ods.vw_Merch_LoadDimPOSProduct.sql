SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [ods].[vw_Merch_LoadDimPOSProduct]
AS


SELECT 'Merch' AS SourceSystem, MP.ETL_ID, MP.Id AS ETL_SSID, MP.ETL_DeltaHashKey,
	MP.ProductTypeId, MP.Name AS ProductName, MP.Sku, CONVERT(DECIMAL(8,2),MP.Price) AS Price,
	MP.ETL_UpdatedDate
FROM ods.Merch_Product MP
;




GO
