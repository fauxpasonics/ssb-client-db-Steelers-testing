SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[LoadDimPOSProduct]
AS 

BEGIN

SELECT SourceSystem, ETL_SSID, ETL_DeltaHashKey, ProductTypeId, ProductName, Sku, Price
INTO #SrcData
FROM (
	SELECT SourceSystem, ETL_SSID, ETL_DeltaHashKey, ProductTypeId, ProductName, Sku, Price
	, ROW_NUMBER() OVER(PARTITION BY ETL_SSID ORDER BY ETL_ID) RowRank
	FROM ods.vw_Merch_LoadDimPOSProduct
	WHERE ETL_UpdatedDate > DATEADD(day,-3,GETDATE())
) a
WHERE RowRank = 1;

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(ETL_DeltaHashKey),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ETL_SSID)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),Price)),'DBNULL_NUMBER') + ISNULL(RTRIM(ProductName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ProductTypeId)),'DBNULL_INT') + ISNULL(RTRIM(Sku),'DBNULL_TEXT') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT'));

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ETL_SSID);
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey);

MERGE dbo.DimPOSProduct AS myTarget
USING (
	SELECT * FROM #SrcData
) AS mySource
ON myTarget.ETL_SSID = mySource.ETL_SSID

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = GETDATE()
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[ProductTypeId] = mySource.[ProductTypeId]
     , myTarget.[ProductName] = mySource.[ProductName]
     , myTarget.[Sku] = mySource.[Sku]
     , myTarget.[Price] = mySource.[Price]

WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_SSID]
     ,[ETL_DeltaHashKey]
     ,[ETL_SourceSystem]
     ,[ProductTypeId]
     ,[ProductName]
     ,[Sku]
     ,[Price]
     )
VALUES
     (GETDATE() --ETL_CreatedDate
     ,GETDATE() --ETL_UpdatedDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.ETL_SSID
     ,mySource.[ETL_DeltaHashKey]
	 ,mySource.SourceSystem
     ,mySource.[ProductTypeId]
     ,mySource.[ProductName]
     ,mySource.[Sku]
     ,mySource.[Price]
     )
;


END




GO
