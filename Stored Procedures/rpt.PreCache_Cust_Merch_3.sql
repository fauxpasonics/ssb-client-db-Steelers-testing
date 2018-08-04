SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [rpt].[PreCache_Cust_Merch_3]
AS


DECLARE @bom INT ,
    @eom INT

SELECT  @bom = MIN(DimDateId) ,
        @eom = MAX(DimDateId)
FROM    DimDate
WHERE   MONTH(GETDATE()) = MonthNumber
        AND YEAR(GETDATE()) = CalYear
		
INSERT INTO [rpt].[PreCache_Cust_Merch_3_tbl]

SELECT  ProductName	
		, Qty	
		, alltime.ProdRank	
		, MonthProductName	
		, MonthQty
		, 0 AS IsReady	
FROM    ( SELECT    * ,
                    ROW_NUMBER() OVER ( ORDER BY Qty DESC ) AS ProdRank
            FROM      ( SELECT    ProductName ,
                                SUM(Quantity) AS Qty
                        FROM      FactPointOfSaleDetail f
                                JOIN DimPOSProduct d ON f.DimProductId = d.DimProductID
                        GROUP BY  ProductName
                    ) orders
        ) alltime
        LEFT JOIN ( SELECT  * ,
                            ROW_NUMBER() OVER ( ORDER BY MonthQty DESC ) AS ProdRank
                    FROM    ( SELECT    ProductName AS MonthProductName ,
                                        SUM(Quantity) AS MonthQty
                                FROM      FactPointOfSaleDetail f
                                        JOIN FactPointOfSale pos ON f.FactPointOfSaleId = pos.FactPointOfSaleId
										JOIN ods.Merch_Order completed ON completed.id = pos.ETL_SSID
																		  AND completed.OrderStatusId = 30
                                        JOIN DimPOSProduct d ON f.DimProductId = d.DimProductID
                                WHERE     pos.DimDateId_SaleDate BETWEEN @bom AND @eom
                                GROUP BY  ProductName
                            ) orders
                    ) thismonth ON alltime.ProdRank = thismonth.ProdRank
WHERE   alltime.ProdRank <= 5

DELETE FROM [rpt].[PreCache_Cust_Merch_3_tbl]
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_Merch_3_tbl]
SET IsReady = 1


GO
