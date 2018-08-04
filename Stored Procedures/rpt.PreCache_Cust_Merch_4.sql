SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROC [rpt].[PreCache_Cust_Merch_4]
AS

INSERT INTO [rpt].[PreCache_Cust_Merch_4_tbl]

SELECT 
	CASE WHEN pos.OrderTotal <= 25 THEN 1
	WHEN pos.OrderTotal > 25 AND pos.OrderTotal <= 75 THEN 2
	WHEN pos.OrderTotal > 75 AND pos.OrderTotal <= 99 THEN 3
	WHEN pos.OrderTotal > 99 AND pos.OrderTotal <= 199 THEN 4
	WHEN pos.OrderTotal > 199 AND pos.OrderTotal <= 499 THEN 5
	WHEN pos.OrderTotal > 499 AND pos.OrderTotal <= 999 THEN 6
	ELSE 7 END AS BinSort,
	CASE WHEN pos.OrderTotal <= 25 THEN '<$26'
	WHEN pos.OrderTotal > 25 AND pos.OrderTotal <= 75 THEN '$26-$75'
	WHEN pos.OrderTotal > 75 AND pos.OrderTotal <= 99 THEN '$76-$99'
	WHEN pos.OrderTotal > 99 AND pos.OrderTotal <= 199 THEN '$100-$199'
	WHEN pos.OrderTotal > 199 AND pos.OrderTotal <= 499 THEN '$200-$499'
	WHEN pos.OrderTotal > 499 AND pos.OrderTotal <= 999 THEN '$500-$999'
	ELSE '$1000+' END AS BinLabel,
	--d.FactPointOfSaleId,
	COUNT(DISTINCT d.factpointofsaleid) Count,
	0 AS IsReady
FROM 
(
	SELECT FactPointOfSaleId, SUM(Quantity) AS Quantity, SUM(TotalPrice) TotalPrice 
	FROM FactPointOfSaleDetail (NOLOCK)
	GROUP BY FactPointOfSaleId
) d
JOIN dbo.FactPointOfSale pos (NOLOCK)
	ON pos.FactPointOfSaleId = d.FactPointOfSaleId
JOIN ods.Merch_Order completed ON completed.id = pos.ETL_SSID
								  AND completed.OrderStatusId = 30
JOIN dbo.DimCustomer dc (NOLOCK)
	ON dc.SSID = pos.CustomerId 
JOIN dbo.DimCustomerSSBID a (NOLOCK)
	ON a.DimCustomerId = dc.DimCustomerId AND a.SourceSystem = 'Merch'
WHERE pos.DimDateId_SaleDate >= 20150724
GROUP BY CASE WHEN pos.OrderTotal <= 25 THEN '<$26'
	WHEN pos.OrderTotal > 25 AND pos.OrderTotal <= 75 THEN '$26-$75'
	WHEN pos.OrderTotal > 75 AND pos.OrderTotal <= 99 THEN '$76-$99'
	WHEN pos.OrderTotal > 99 AND pos.OrderTotal <= 199 THEN '$100-$199'
	WHEN pos.OrderTotal > 199 AND pos.OrderTotal <= 499 THEN '$200-$499'
	WHEN pos.OrderTotal > 499 AND pos.OrderTotal <= 999 THEN '$500-$999'
	ELSE '$1000+' END,
	CASE WHEN pos.OrderTotal <= 25 THEN 1
	WHEN pos.OrderTotal > 25 AND pos.OrderTotal <= 75 THEN 2
	WHEN pos.OrderTotal > 75 AND pos.OrderTotal <= 99 THEN 3
	WHEN pos.OrderTotal > 99 AND pos.OrderTotal <= 199 THEN 4
	WHEN pos.OrderTotal > 199 AND pos.OrderTotal <= 499 THEN 5
	WHEN pos.OrderTotal > 499 AND pos.OrderTotal <= 999 THEN 6
	ELSE 7 END
ORDER BY binsort 

DELETE FROM [rpt].[PreCache_Cust_Merch_4_tbl]
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_Merch_4_tbl]
SET IsReady = 1


GO
