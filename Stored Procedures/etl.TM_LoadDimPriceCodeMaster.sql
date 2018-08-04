SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_LoadDimPriceCodeMaster] 

as
BEGIN

	DECLARE @RunTime datetime = getdate()



	CREATE TABLE #NewPriceCodes (PriceCode NVARCHAR(4))

	INSERT INTO #NewPriceCodes (PriceCode)
	
	SELECT PriceCode
	FROM (		
		SELECT DISTINCT price_code PriceCode
		FROM ods.TM_PriceCode

			UNION

		SELECT DISTINCT REPLACE(price_code, '*', '') PriceCode
		FROM ods.TM_Ticket

			UNION

		SELECT DISTINCT REPLACE(price_code, '*', '') PriceCode
		FROM ods.TM_AvailSeats

			UNION

		SELECT DISTINCT REPLACE(price_code, '*', '') PriceCode
		FROM ods.TM_HeldSeats

	) a

	EXCEPT 

	SELECT DISTINCT PriceCode
	FROM dbo.DimPriceCodeMaster


	INSERT INTO dbo.DimPriceCodeMaster (priceCode, PC1, PC2, PC3, PC4, ETL_CreatedBy, ETL_UpdatedBy, ETL_CreatedDate, ETL_UpdatedDate)

	SELECT PriceCode
	, CASE WHEN LEN(PriceCode) >= 1 THEN  SUBSTRING(PriceCode,1,1) END AS PC1
	, CASE WHEN LEN(PriceCode) >= 2 THEN  SUBSTRING(PriceCode,2,1) END AS PC2
	, CASE WHEN LEN(PriceCode) >= 3 THEN  SUBSTRING(PriceCode,3,1) END AS PC3
	, CASE WHEN LEN(PriceCode) >= 4 THEN  SUBSTRING(PriceCode,4,1) END AS PC4
	, 'CI'
	, 'CI'
	, @RunTime
	, @RunTime
	FROM #NewPriceCodes





END



GO
