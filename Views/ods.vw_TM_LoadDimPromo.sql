SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [ods].[vw_TM_LoadDimPromo] AS (

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'dbo.DimPromo', 'DimPromoCodeID, ETL_CreatedBy, ETL_UpdatedBy, ETL_CreatedDate, ETL_UpdatedDate, ETL_SourceSystem, ETL_SSID, ETL_SSID_PromoCode_ID, ETL_DeltaHashKey'
*/

	SELECT *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),add_Datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(add_user),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),archtics_end_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),archtics_start_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),inet_end_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),inet_start_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(promo_group_sell_flag),'DBNULL_TEXT') + ISNULL(RTRIM(promo_inet_desc),'DBNULL_TEXT') + ISNULL(RTRIM(promo_inet_name),'DBNULL_TEXT') + ISNULL(RTRIM(promo_type),'DBNULL_TEXT') + ISNULL(RTRIM(PromoCode),'DBNULL_TEXT') + ISNULL(RTRIM(PromoName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),upd_datetime)),'DBNULL_DATETIME')) ETL_DeltaHashKey
	FROM (
		
		SELECT promo_code PromoCode
		, MIN(promo_code_name) PromoName
		, MIN(promo_inet_name) promo_inet_name
		, MIN(promo_inet_desc) promo_inet_desc
		, MIN(promo_type) promo_type
		, MIN(promo_group_sell_flag) promo_group_sell_flag
		, MIN(inet_start_datetime) inet_start_datetime
		, MAX(inet_end_datetime) inet_end_datetime
		, MIN(archtics_start_datetime) archtics_start_datetime
		, MAX(archtics_end_datetime) archtics_end_datetime
		, MAX(add_Datetime) add_Datetime
		, MIN(add_user) add_user
		, MAX(upd_datetime) upd_datetime
		, promo_code ETL_SSID
		, promo_code ETL_SSID_promo_code
		FROM ods.TM_PromoCode
		GROUP BY promo_code

	
	) a

)





GO
