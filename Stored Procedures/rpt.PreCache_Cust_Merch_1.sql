SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [rpt].[PreCache_Cust_Merch_1] AS

--this proc is for the top line kpis on the report (row 1) and state chart

		
/*select sum(Quantity) as ItemsPurchased, count(distinct d.FactPointOfSaleId) as TotalOrders, sum(OrderTotal) as TotalRevenue,sum(OrderTotal)/count(distinct d.FactPointOfSaleId) as AvgOrder
FROM (select FactPointOfSaleId, sum(Quantity) as Quantity, SUM(TotalPrice) TotalPrice from FactPointOfSaleDetail group by FactPointOfSaleId) d
JOIN dbo.FactPointOfSale pos on pos.FactPointOfSaleId = d.FactPointOfSaleId
JOIN dbo.DimCustomer dc ON dc.SSID = pos.CustomerId 
JOIN dbo.DimCustomerSSBID a ON a.DimCustomerId = dc.DimCustomerId AND a.SourceSystem = 'Merch'
where pos.DimDateId_SaleDate >= 20150724


--SELECT SUM(ordertotal) FROM dbo.FactPointOfSale WHERE DimDateId_SaleDate >= 20150724
*/

INSERT INTO [rpt].[PreCache_Cust_Merch_1_tbl]
SELECT TOP 20 *, 0 AS isReady

FROM
(
SELECT 
	GROUPING_ID (dc.AddressPrimaryState,dc.AddressPrimaryCountry) GroupID,
	dc.AddressPrimaryState StateAb,
	dc.AddressPrimaryCountry Country,
	st.StateName STATE,
	'#009933' Color,
	COUNT(DISTINCT a.SSB_CRMSYSTEM_CONTACT_ID) AS Customers,
	SUM(Quantity) AS ItemsPurchased, 
	COUNT(DISTINCT d.FactPointOfSaleId) AS TotalOrders, 
	SUM(pos.OrderTotal) AS TotalRevenue,
	SUM(pos.OrderTotal)/COUNT(DISTINCT d.FactPointOfSaleId) AS AvgOrder,
	DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT a.SSB_CRMSYSTEM_CONTACT_ID) DESC) CustRank,
	DENSE_RANK() OVER (ORDER BY SUM(pos.OrderTotal) DESC) RevRank
FROM 
(
	SELECT FactPointOfSaleId, SUM(Quantity) AS Quantity, SUM(TotalPrice) TotalPrice 
	FROM FactPointOfSaleDetail (NOLOCK)
	GROUP BY FactPointOfSaleId
) d
JOIN dbo.FactPointOfSale pos (NOLOCK)
	ON pos.FactPointOfSaleId = d.FactPointOfSaleId
JOIN ods.merch_Order completed
	ON completed.id = pos.ETL_SSID
       AND completed.orderstatusID = 30
JOIN dbo.DimCustomer dc (NOLOCK)
	ON dc.SSID = pos.CustomerId 
JOIN dbo.DimCustomerSSBID a (NOLOCK)
	ON a.DimCustomerId = dc.DimCustomerId AND a.SourceSystem = 'Merch'
LEFT JOIN rpt.StateFullName st (NOLOCK)
	ON dc.AddressPrimaryState = st.StateAbbreviation
WHERE pos.DimDateId_SaleDate >= 20150724
GROUP BY GROUPING SETS ((),(dc.AddressPrimaryState,dc.AddressPrimaryCountry,st.StateName))
)a
ORDER BY a.CustRank


DELETE FROM [rpt].[PreCache_Cust_Merch_1_tbl] 
WHERE isReady = 1

UPDATE [rpt].[PreCache_Cust_Merch_1_tbl]
SET isReady = 1



GO
