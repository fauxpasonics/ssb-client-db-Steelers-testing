SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [rpt].[PreCache_Cust_Merch_MarketFreq]
AS

INSERT INTO [rpt].[PreCache_Cust_Merch_MarketFreq_tbl]

SELECT z.MonthYear
	, z.MonthAbbrv
	, SUM(z.InMarket) AS InMarket
	, SUM(z.OutMarket) AS OutMarket
	, SUM(z.RepeatCust) AS RepeatCust
	, SUM(z.NotRepeat) AS NotRepeat
	, 0 AS IsReady
FROM
(
SELECT 
	DATENAME(MONTH, pos.SaleDate) + ' ' + DATENAME(YEAR, pos.SaleDate) AS MonthYear
	, LEFT(DATENAME(MONTH, pos.SaleDate), 3) + ' ' + DATENAME(YEAR, pos.SaleDate) AS MonthAbbrv	
	, CASE WHEN dc.AddressPrimaryZip = mkt.ZIP THEN 1 ELSE 0 END AS InMarket
	, CASE WHEN mkt.ZIP IS NULL THEN 1 ELSE 0 END AS OutMarket
	, CASE WHEN COUNT(*) OVER (PARTITION BY dc.SSID) > 1 THEN 1 ELSE 0 END AS RepeatCust	
	, CASE WHEN COUNT(*) OVER (PARTITION BY dc.SSID) <= 1 THEN 1 ELSE 0 END AS NotRepeat	
FROM dimcustomer dc

JOIN dbo.FactPointOfSale pos 
	ON pos.CustomerId = dc.SSID
JOIN ods.Merch_Order completed ON completed.id = pos.ETL_SSID
								  AND completed.OrderStatusId = 30
JOIN (
	--gets sale quantity
	SELECT FactPointOfSaleId
		, SUM(Quantity) AS Quantity		
	FROM FactPointOfSaleDetail 
	GROUP BY FactPointOfSaleId
	) d 
	ON d.FactPointOfSaleId = pos.FactPointOfSaleId

--gets in market
LEFT JOIN adhoc.InMarketZip mkt 
	ON mkt.Zip = dc.AddressPrimaryZip

WHERE SourceSystem = 'Merch'
) z
GROUP BY z.MonthYear, z.MonthAbbrv

DELETE FROM [rpt].[PreCache_Cust_Merch_MarketFreq_tbl]
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_Merch_MarketFreq_tbl]
SET IsReady = 1


GO
