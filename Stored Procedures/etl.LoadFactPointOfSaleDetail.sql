SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*****	Revision History

DCH on 2016-02-18:	Added ETL_UpdatedDate condition to the derived table in the #SrcData build.



*****/


CREATE PROCEDURE [etl].[LoadFactPointOfSaleDetail]

AS 

BEGIN


SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
,  SSID, FactPointOfSaleId, DimProductId, Quantity, UnitPrice, Discount, TotalPrice, ItemAttribute, SourceSystem
INTO #SrcData
FROM (
	SELECT SSID, FactPointOfSaleId, DimProductId, Quantity, UnitPrice, Discount, TotalPrice, ItemAttribute, SourceSystem
	, ROW_NUMBER() OVER(PARTITION BY SSID ORDER BY ETL_ID) RowRank
	FROM ods.vw_Merch_LoadFactPointOfSaleDetail
	WHERE ETL_UpdatedDate > DATEADD(day,-3,GETDATE())
) a
WHERE RowRank = 1
;


UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),DimProductId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),Discount)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),FactPointOfSaleId)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),Quantity)),'DBNULL_INT') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),TotalPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),UnitPrice)),'DBNULL_NUMBER'))
;


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (SSID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)
;


MERGE dbo.FactPointOfSaleDetail AS myTarget
USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.ETL_SSID = mySource.SSID

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.ItemAttribute,'') <> ISNULL(myTarget.ItemAttribute,'') 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = GETDATE()
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[FactPointOfSaleId] = mySource.[FactPointOfSaleId]
     , myTarget.[DimProductId] = mySource.[DimProductId]
     , myTarget.[Quantity] = mySource.[Quantity]
     , myTarget.[UnitPrice] = mySource.[UnitPrice]
     , myTarget.[Discount] = mySource.[Discount]
     , myTarget.[TotalPrice] = mySource.[TotalPrice]
     , myTarget.[ItemAttribute] = mySource.[ItemAttribute]
     


WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_DeltaHashKey]
     ,[ETL_SSID]
     ,[FactPointOfSaleId]
     ,[DimProductId]
     ,[Quantity]
     ,[UnitPrice]
     ,[Discount]
     ,[TotalPrice]
     ,[ItemAttribute]
     )
VALUES
     (GETDATE() --ETL_CreatedDate
     ,GETDATE() --ETL_UpdateddDate
     ,mySource.[ETL_DeltaHashKey]
	 ,mySource.SSID
     ,mySource.[FactPointOfSaleId]
     ,mySource.[DimProductId]
     ,mySource.[Quantity]
     ,mySource.[UnitPrice]
     ,mySource.[Discount]
     ,mySource.[TotalPrice]
     ,mySource.[ItemAttribute]
     )
;


END






GO
