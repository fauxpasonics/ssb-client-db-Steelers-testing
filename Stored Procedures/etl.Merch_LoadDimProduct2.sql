SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Merch_LoadDimProduct2] 


AS
BEGIN

DECLARE @RunTime datetime = getdate()

MERGE dbo.DimProduct AS mytarget

USING (select *,
		HASHBYTES('sha2_256',	ISNULL(RTRIM(ProductDescription),'DBNULL_TEXT')
								+ ISNULL(RTRIM(ProductCategory),'DBNULL_TEXT')
								+ ISNULL(RTRIM(ProductSKU),'DBNULL_TEXT')
								+ ISNULL(RTRIM(ProductPrice),'DBNULL_TEXT')
								+ ISNULL(RTRIM(Gtin),'DBNULL_TEXT')
					) as DeltaHashKey
		from ods.vw_Merch_LoadDimProduct) as mySource
     ON
		myTarget.SourceSystem = mySource.SourceSystem
		and myTarget.SSID = mySource.SSID

WHEN MATCHED AND isnull(mySource.DeltaHashKey,-1) <> isnull(myTarget.DeltaHashKey, -1)
THEN UPDATE SET 

	myTarget.ProductDescription = mySource.ProductDescription
	, myTarget.ProductCategory = mySource.ProductCategory
	, myTarget.ProductSKU = mySource.ProductSKU
	, myTarget.ProductPrice = mySource.ProductPrice
	, myTarget.Gtin = mySource.Gtin
	, myTarget.IsGiftCard = mySource.IsGiftCard
	, myTarget.SSID_ProductTypeId = mySource.SSID_ProductTypeId
	, myTarget.SSID_ParentGroupedProductId = mySource.SSID_ParentGroupedProductId
	, myTarget.SSID_ProductCategoryMappingId = mySource.SSID_ProductCategoryMappingId
	, myTarget.SSID_CategoryId = mySource.SSID_CategoryId
	, myTarget.SSID_GiftCardTypeId = mySource.SSID_GiftCardTypeId
	, myTarget.SourceSystem = mySource.SourceSystem
	, myTarget.DeltaHashKey = mySource.DeltaHashKey
	, UpdatedBy = 'CI'
	, UpdatedDate = @RunTime


WHEN NOT MATCHED THEN INSERT
    (
	ProductDescription, ProductCategory, ProductSKU, ProductPrice, Gtin, IsGiftCard, SSID, SSID_ProductTypeId,
	SSID_ParentGroupedProductId, SSID_ProductCategoryMappingId, SSID_CategoryId, SSID_GiftCardTypeId, SourceSystem,
	DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate
	)
    VALUES (
		mySource.ProductDescription
		, mySource.ProductCategory
		, mySource.ProductSKU
		, mySource.ProductPrice
		, mySource.Gtin
		, mySource.IsGiftCard
		, mySource.SSID
		, mySource.SSID_ProductTypeId
		, mySource.SSID_ParentGroupedProductId
		, mySource.SSID_ProductCategoryMappingId
		, mySource.SSID_CategoryId
		, mySource.SSID_GiftCardTypeId
		, mySource.SourceSystem
		, mySource.DeltaHashKey
		, 'CI' --CreatedBy
		, 'CI' --UpdatedBy
		, @RunTime --CreatedDate
		, @RunTime --UpdatedDate
		, 0 --IsDeleted
		, NULL --DeleteDate

    );


END

GO
