SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_DimPriceCodeMaster] as (
	SELECT [DimPriceCodeMasterId]
     ,[ETL_CreatedBy]
     ,[ETL_UpdatedBy]
     ,[ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[PriceCode]
     ,[PC1]
     ,[PC2]
     ,[PC3]
     ,[PC4]
     FROM dbo.DimPriceCodeMaster (NOLOCK)
)
GO
