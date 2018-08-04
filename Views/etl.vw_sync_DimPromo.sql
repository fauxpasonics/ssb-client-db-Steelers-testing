SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_DimPromo] as (
	SELECT [DimPromoID]
     ,[ETL_CreatedBy]
     ,[ETL_UpdatedBy]
     ,[ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_SSID]
     ,[ETL_SSID_promo_code]
     ,[ETL_DeltaHashKey]
	 ,[ETL_SourceSystem]
     ,[PromoCode]
     ,[PromoName]
     ,[promo_inet_name]
     ,[promo_inet_desc]
     ,[promo_type]
     ,[promo_group_sell_flag]
     ,[inet_start_datetime]
     ,[inet_end_datetime]
     ,[archtics_start_datetime]
     ,[archtics_end_datetime]
     ,[add_Datetime]
     ,[add_user]
     ,[upd_datetime]
     FROM dbo.DimPromo (NOLOCK)
)
GO
