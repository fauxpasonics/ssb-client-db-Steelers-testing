SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*****	Revision History

DCH on 2016-02-18:	Added ETL_UpdatedDate and Deleted conditions to the derived table in the #SrcData build.



*****/


CREATE PROCEDURE [etl].[LoadFactPointOfSale]

AS 

BEGIN


SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
, SSID, DimDateId_SaleDate, DimDateId_PaymentDate, DimDateId_ShipmentDate, DimDateId_DeliveryDate, DimAccountId, DimEventHeaderId, DimStoreId, DimRevenueCenterId, DimWorkstationId, DimEmployeeId, SaleDate, PaymentDate, ShipmentDate, DeliveryDate, SubTotal, Tax, Shipping, Other, Discount, GiftCardAmtApplied, OrderTotal, Refund, OrderId, PaymentMethod, ShippingMethod, CustomerId, CurrencyType, SourceSystem
INTO #SrcData
FROM (
	SELECT SSID, DimDateId_SaleDate, DimDateId_PaymentDate, DimDateId_ShipmentDate, DimDateId_DeliveryDate, DimAccountId, DimEventHeaderId, DimStoreId, DimRevenueCenterId, DimWorkstationId, DimEmployeeId, SaleDate, PaymentDate, ShipmentDate, DeliveryDate, SubTotal, Tax, Shipping, Other, Discount, GiftCardAmtApplied, OrderTotal, Refund, OrderId, PaymentMethod, ShippingMethod, CustomerId, CurrencyType, SourceSystem
	, ROW_NUMBER() OVER(PARTITION BY SSID ORDER BY ETL_ID) RowRank
	FROM ods.vw_Merch_LoadFactPointOfSale
	WHERE ETL_UpdatedDate > DATEADD(day,-3,GETDATE())
	OR Deleted = 1
) a
WHERE RowRank = 1
;


UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),CustomerId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),DeliveryDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),DimAccountId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimDateId_DeliveryDate)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimDateId_PaymentDate)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimDateId_SaleDate)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimDateId_ShipmentDate)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimEmployeeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimEventHeaderId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimRevenueCenterId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimStoreId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimWorkstationId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),Discount)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),GiftCardAmtApplied)),'DBNULL_NUMBER') + ISNULL(RTRIM(OrderId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),OrderTotal)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),Other)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PaymentDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),Refund)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),SaleDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),ShipmentDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),Shipping)),'DBNULL_NUMBER') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),SubTotal)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),Tax)),'DBNULL_NUMBER'))
;


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (SSID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)
;


MERGE dbo.FactPointOfSale AS myTarget
USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.ETL_SSID = mySource.SSID

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.PaymentMethod,'') <> ISNULL(myTarget.PaymentMethod,'') OR ISNULL(mySource.ShippingMethod,'') <> ISNULL(myTarget.ShippingMethod,'') OR ISNULL(mySource.CurrencyType,'') <> ISNULL(myTarget.CurrencyType,'') 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = GETDATE()
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[DimDateId_SaleDate] = mySource.[DimDateId_SaleDate]
     , myTarget.[DimDateId_PaymentDate] = mySource.[DimDateId_PaymentDate]
     , myTarget.[DimDateId_ShipmentDate] = mySource.[DimDateId_ShipmentDate]
     , myTarget.[DimDateId_DeliveryDate] = mySource.[DimDateId_DeliveryDate]
     , myTarget.[DimAccountId] = mySource.[DimAccountId]
     , myTarget.[DimEventHeaderId] = mySource.[DimEventHeaderId]
     , myTarget.[DimStoreId] = mySource.[DimStoreId]
     , myTarget.[DimRevenueCenterId] = mySource.[DimRevenueCenterId]
     , myTarget.[DimWorkstationId] = mySource.[DimWorkstationId]
     , myTarget.[DimEmployeeId] = mySource.[DimEmployeeId]
     , myTarget.[SaleDate] = mySource.[SaleDate]
     , myTarget.[PaymentDate] = mySource.[PaymentDate]
     , myTarget.[ShipmentDate] = mySource.[ShipmentDate]
     , myTarget.[DeliveryDate] = mySource.[DeliveryDate]
     , myTarget.[SubTotal] = mySource.[SubTotal]
     , myTarget.[Tax] = mySource.[Tax]
     , myTarget.[Shipping] = mySource.[Shipping]
     , myTarget.[Other] = mySource.[Other]
     , myTarget.[Discount] = mySource.[Discount]
     , myTarget.[GiftCardAmtApplied] = mySource.[GiftCardAmtApplied]
     , myTarget.[OrderTotal] = mySource.[OrderTotal]
     , myTarget.[Refund] = mySource.[Refund]
     , myTarget.[OrderId] = mySource.[OrderId]
     , myTarget.[PaymentMethod] = mySource.[PaymentMethod]
     , myTarget.[ShippingMethod] = mySource.[ShippingMethod]
     , myTarget.[CustomerId] = mySource.[CustomerId]
     , myTarget.[CurrencyType] = mySource.[CurrencyType]


WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_DeltaHashKey]
     ,[ETL_SSID]
     ,[DimDateId_SaleDate]
     ,[DimDateId_PaymentDate]
     ,[DimDateId_ShipmentDate]
     ,[DimDateId_DeliveryDate]
     ,[DimAccountId]
     ,[DimEventHeaderId]
     ,[DimStoreId]
     ,[DimRevenueCenterId]
     ,[DimWorkstationId]
     ,[DimEmployeeId]
     ,[SaleDate]
     ,[PaymentDate]
     ,[ShipmentDate]
     ,[DeliveryDate]
     ,[SubTotal]
     ,[Tax]
     ,[Shipping]
     ,[Other]
     ,[Discount]
     ,[GiftCardAmtApplied]
     ,[OrderTotal]
     ,[Refund]
     ,[OrderId]
     ,[PaymentMethod]
     ,[ShippingMethod]
     ,[CustomerId]
     ,[CurrencyType]
     )
VALUES
     (GETDATE() --ETL_CreatedDate
     ,GETDATE() --ETL_UpdateddDate
     ,mySource.[ETL_DeltaHashKey]
	 ,mySource.SSID
     ,mySource.[DimDateId_SaleDate]
     ,mySource.[DimDateId_PaymentDate]
     ,mySource.[DimDateId_ShipmentDate]
     ,mySource.[DimDateId_DeliveryDate]
     ,mySource.[DimAccountId]
     ,mySource.[DimEventHeaderId]
     ,mySource.[DimStoreId]
     ,mySource.[DimRevenueCenterId]
     ,mySource.[DimWorkstationId]
     ,mySource.[DimEmployeeId]
     ,mySource.[SaleDate]
     ,mySource.[PaymentDate]
     ,mySource.[ShipmentDate]
     ,mySource.[DeliveryDate]
     ,mySource.[SubTotal]
     ,mySource.[Tax]
     ,mySource.[Shipping]
     ,mySource.[Other]
     ,mySource.[Discount]
     ,mySource.[GiftCardAmtApplied]
     ,mySource.[OrderTotal]
     ,mySource.[Refund]
     ,mySource.[OrderId]
     ,mySource.[PaymentMethod]
     ,mySource.[ShippingMethod]
     ,mySource.[CustomerId]
     ,mySource.[CurrencyType]
     )
;

END





GO
