SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [segmentation].[vw__Merch_RFM]
AS
    (

SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID ,
        DimCustomer.SourceSystem Source_System,
        CASE WHEN x.loyalty_SSID IS NOT NULL THEN 1 ELSE 0 END AS IsLoyalty,
		--STORE.NAME Store_Name,
        SUM(POSD.Quantity) Total_Merch_Qty,
        SUM(POSD.TotalPrice) Total_Merch_Spend,
        --PRO.ProductName Item_Name,
		--CAT.NAME Tag_Name, -- tag,
		--CAST(POS.SaleDate AS DATE) Sale_Date,
		--YEAR(POS.SaleDate) Sale_Year,
		--MONTH(POS.SaleDate) Sale_Month
		 CASE WHEN POS.SaleDate = '' THEN NULL ELSE CAST(MAX(POS.SaleDate) AS DATE) END AS Most_Recent_Sale_Date
		, CASE WHEN POS.SaleDate = '' THEN NULL ELSE YEAR(MAX(POS.SaleDate)) END AS Most_Recent_Sale_Year
		, CASE WHEN POS.SaleDate = '' THEN NULL ELSE MONTH(MAX(POS.SaleDate)) END AS Most_Recent_Sale_Month
		--, CASE WHEN POS.SaleDate >= DATEADD(DAY, -30, GETDATE()) THEN 1 ELSE 0 END AS Has_Merch_Purchase_In_Last_30_Days
		, CASE WHEN POS.SaleDate >= DATEADD(day, -30, getdate()) THEN SUM(POSD.Quantity) ELSE 0  END AS Merch_Qty_In_Last_30_Days -- How do I limit to total QTY in last 30 days?
		, CASE WHEN POS.SaleDate >= DATEADD(day, -30, getdate()) THEN SUM(POSD.TotalPrice) ELSE 0 END AS Merch_Spend_In_Last_30_Days -- How do I limit to total spend in last 30 days?
		--, CASE WHEN POS.SaleDate >= DATEADD(DAY, -60, GETDATE()) THEN 1 ELSE 0 END AS Has_Merch_Purchase_In_Last_60_Days
		, CASE WHEN POS.SaleDate >= DATEADD(day, -60, getdate()) THEN SUM(POSD.Quantity) ELSE 0  END AS Merch_Qty_In_Last_60_Days -- How do I limit to total QTY in last 60 days?
		, CASE WHEN POS.SaleDate >= DATEADD(day, -60, getdate()) THEN SUM(POSD.TotalPrice) ELSE 0 END AS Merch_Spend_In_Last_60_Days -- How do I limit to total spend in last 60 days?
		--, CASE WHEN POS.SaleDate >= DATEADD(DAY, -90, GETDATE()) THEN 1 ELSE 0 END AS Has_Merch_Purchase_In_Last_90_Days
		, CASE WHEN POS.SaleDate >= DATEADD(day, -90, getdate()) THEN SUM(POSD.Quantity) ELSE 0   END AS Merch_Qty_In_Last_90_Days -- How do I limit to total QTY in last 90 days?
		, CASE WHEN POS.SaleDate >= DATEADD(day, -90, getdate()) THEN SUM(POSD.TotalPrice) ELSE 0 END AS Merch_Spend_In_Last_90_Days -- How do I limit to total spend in last 90 days?
		--, CASE WHEN POS.SaleDate >= DATEADD(YEAR, -1, GETDATE()) THEN 1 ELSE 0 END AS Has_Merch_Purchase_In_Last_365_Days
		, CASE WHEN POS.SaleDate >= DATEADD(YEAR, -1, getdate()) THEN SUM(POSD.Quantity) ELSE 0  END AS Merch_Qty_In_Last_365_Days -- How do I limit to total QTY in last 180 days?
		, CASE WHEN POS.SaleDate >= DATEADD(YEAR, -1, getdate()) THEN SUM(POSD.TotalPrice) ELSE 0  END AS Merch_Spend_In_Last_365_Days -- How do I limit to total spend in last 180 days?
	
FROM    [rpt].[vw_DimCustomer] DimCustomer
        INNER JOIN [rpt].[vw_DimCustomerSSBID] ssbid WITH ( NOLOCK ) ON DimCustomer.dimcustomerid = ssbid.dimcustomerid
        INNER JOIN [rpt].[vw_FactPointOfSale] POS WITH ( NOLOCK ) ON DimCustomer.SSID = POS.CustomerId
        INNER JOIN [rpt].[vw_FactPointOfSaleDetail] POSD WITH ( NOLOCK ) ON POSD.FactPointOfSaleId = POS.FactPointOfSaleId
        INNER JOIN [rpt].[vw_DimPOSProduct] PRO WITH ( NOLOCK ) ON PRO.DimProductID = POSD.DimProductId
		INNER JOIN ods.Merch_Product_Category_Mapping PCM WITH (NOLOCK) ON PCM.ProductId = PRO.ETL_SSID
		INNER JOIN ods.Merch_Category CAT WITH ( NOLOCK ) ON CAT.Id = PCM.CategoryId
		INNER JOIN ods.Merch_Store STORE WITH ( NOLOCK ) ON STORE.Id = POS.DimStoreId
		LEFT JOIN [ods].[Merch_Order] MO WITH ( NOLOCK ) ON MO.Id = POS.ETL_SSID
		LEFT JOIN [ods].[Merch_SNUOrderInfo] SNUO WITH ( NOLOCK ) ON SNUO.OrderId = POS.ETL_SSID
		LEFT JOIN (
			SELECT DISTINCT  m.SSID Merch_SSID, l.SSID Loyalty_SSID
			FROM  [rpt].[vw_DimCustomerSSBID] a 
			LEFT JOIN [rpt].[vw_DimCustomerSSBID] m WITH ( NOLOCK ) ON a.SSB_CRMSYSTEM_CONTACT_ID = m.SSB_CRMSYSTEM_CONTACT_ID AND m.SourceSystem = 'Merch'
			LEFT JOIN [rpt].[vw_DimCustomerSSBID] l WITH ( NOLOCK ) ON a.SSB_CRMSYSTEM_CONTACT_ID = l.SSB_CRMSYSTEM_CONTACT_ID AND l.SourceSystem = '500f'
			WHERE l.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL AND m.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL
				   ) x ON x.Merch_SSID = POS.CustomerId
		GROUP BY CASE WHEN x.loyalty_SSID IS NOT NULL THEN 1
                 ELSE 0
                 END ,
                 POS.SaleDate  ,
                 YEAR(POS.SaleDate),
                MONTH(POS.SaleDate) ,
                 ssbid.SSB_CRMSYSTEM_CONTACT_ID ,
                 DimCustomer.SourceSystem 
             -- HAVING COUNT(DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID) > 1

				   )



GO
