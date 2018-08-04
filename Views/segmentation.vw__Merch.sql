SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [segmentation].[vw__Merch]
AS
    (
SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID ,
        DimCustomer.SourceSystem Source_System,
        CASE WHEN x.loyalty_SSID IS NOT NULL THEN 1 ELSE 0 END AS IsLoyalty,
		CASE WHEN POS.Discount > 0 THEN 1 ELSE 0 END AS IsDiscount,
		CASE WHEN POSD.UnitPrice <= 0 THEN 1 ELSE 0 END AS IsComp,
		NULL AS Promo_Code, --For Steelers [SUBSTRING(detail,PATINDEX('%coupon:%',detail),LEN(detail)) -- from 500feventstable AS]
		NULL AS Tender,
		STORE.NAME Store_Name,
		POS.DimStoreId Store_Id,
        POSD.Quantity Qty_Item,
        POSD.UnitPrice Item_Unit_Price, 
        POSD.TotalPrice Item_Total_Price,
        POSD.ItemAttribute Item_Attribute,
        PRO.ProductName Item_Name,
        PRO.Sku ,
		CAT.NAME Tag_Name, -- tag,
		CAST(POS.SaleDate AS DATE) Sale_Date,
		YEAR(POS.SaleDate) Sale_Year,
		MONTH(POS.SaleDate) Sale_Month
	
FROM    [rpt].[vw_DimCustomer] DimCustomer
        INNER JOIN [rpt].[vw_DimCustomerSSBID] ssbid WITH ( NOLOCK ) ON DimCustomer.dimcustomerid = ssbid.dimcustomerid
        INNER JOIN [rpt].[vw_FactPointOfSale] POS WITH ( NOLOCK ) ON DimCustomer.SSID = POS.CustomerId
        INNER JOIN [rpt].[vw_FactPointOfSaleDetail] POSD WITH ( NOLOCK ) ON POSD.FactPointOfSaleId = POS.FactPointOfSaleId
        INNER JOIN [rpt].[vw_DimPOSProduct] PRO WITH ( NOLOCK ) ON PRO.DimProductID = POSD.DimProductId
		INNER JOIN ods.Merch_Product_Category_Mapping PCM WITH (NOLOCK) ON PCM.ProductId = PRO.ETL_SSID --2017/05/04 AMEITIN changed from POS.ETL_SSID_Id 
		INNER JOIN ods.Merch_Category CAT WITH ( NOLOCK ) ON CAT.Id = PCM.CategoryId
		INNER JOIN ods.Merch_Store STORE WITH ( NOLOCK ) ON STORE.Id = POS.DimStoreId
		LEFT JOIN [ods].[Merch_Order] MO WITH ( NOLOCK ) ON MO.Id = POS.ETL_SSID
		LEFT JOIN [ods].[Merch_SNUOrderInfo] SNUO WITH ( NOLOCK ) ON SNUO.OrderId = POS.ETL_SSID --2017/05/04 AMEITIN changed from POS.ETL_SSID_Id 
		LEFT JOIN (
			SELECT DISTINCT  m.SSID Merch_SSID, l.SSID Loyalty_SSID
			FROM  [rpt].[vw_DimCustomerSSBID] a 
			LEFT JOIN [rpt].[vw_DimCustomerSSBID] m WITH ( NOLOCK ) ON a.SSB_CRMSYSTEM_CONTACT_ID = m.SSB_CRMSYSTEM_CONTACT_ID AND m.SourceSystem = 'Merch'
			LEFT JOIN [rpt].[vw_DimCustomerSSBID] l WITH ( NOLOCK ) ON a.SSB_CRMSYSTEM_CONTACT_ID = l.SSB_CRMSYSTEM_CONTACT_ID AND l.SourceSystem = '500f'
			WHERE l.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL AND m.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL
				   ) x ON x.Merch_SSID = POS.CustomerId
				   )

GO
EXEC sp_addextendedproperty N'ExtendedProperties', '{IsQueryable: false, IsSelectable: false, Properties: {}}', 'SCHEMA', N'segmentation', 'VIEW', N'vw__Merch', 'COLUMN', N'Promo_Code'
GO
EXEC sp_addextendedproperty N'ExtendedProperties', '{IsQueryable: false, IsSelectable: false, Properties: {}}', 'SCHEMA', N'segmentation', 'VIEW', N'vw__Merch', 'COLUMN', N'Tender'
GO
