SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_LoadDimPromo] 

as
BEGIN

DECLARE @RunTime datetime = getdate()

MERGE dbo.DimPromo AS mytarget

USING (select * from [ods].[vw_TM_LoadDimPromo]) as mySource
     ON mytarget.ETL_SSID_promo_code = mysource.ETL_SSID_promo_code

WHEN MATCHED AND isnull(mySource.ETL_DeltaHashKey,-1) <> isnull(myTarget.ETL_DeltaHashKey, -1)
THEN UPDATE SET 

	myTarget.ETL_UpdatedBy = 'CI'
	, myTarget.ETL_UpdatedDate = @RunTime	
	, myTarget.ETL_SSID = mysource.ETL_SSID
	, myTarget.ETL_SSID_promo_code = mysource.ETL_SSID_promo_code
	, myTarget.ETL_DeltaHashKey = mysource.ETL_DeltaHashKey

	, myTarget.PromoCode = mysource.PromoCode
	, myTarget.PromoName = mysource.PromoName
	, myTarget.promo_inet_name = mysource.promo_inet_name
	, myTarget.promo_inet_desc = mysource.promo_inet_desc
	, myTarget.promo_type = mysource.promo_type
	, myTarget.promo_group_sell_flag = mysource.promo_group_sell_flag
	, myTarget.inet_start_datetime = mysource.inet_start_datetime
	, myTarget.inet_end_datetime = mysource.inet_end_datetime
	, myTarget.archtics_start_datetime = mysource.archtics_start_datetime
	, myTarget.archtics_end_datetime = mysource.archtics_end_datetime
	, myTarget.add_Datetime = mysource.add_Datetime
	, myTarget.add_user = mysource.add_user
	, myTarget.upd_datetime = mysource.upd_datetime



WHEN NOT MATCHED BY TARGET THEN INSERT (ETL_CreatedBy, ETL_UpdatedBy, ETL_CreatedDate, ETL_UpdatedDate, ETL_SSID, ETL_SSID_promo_code, ETL_DeltaHashKey, PromoCode, PromoName, promo_inet_name, promo_inet_desc, promo_type, promo_group_sell_flag, inet_start_datetime, inet_end_datetime, archtics_start_datetime, archtics_end_datetime, add_Datetime, add_user, upd_datetime)

VALUES (
	'CI' --CreatedBy
	, 'CI' --UpdatedBy
	, @RunTime --CreatedDate
	, @RunTime --UpdatedDate
	, mysource.ETL_SSID
	, mysource.ETL_SSID_promo_code
	, mysource.ETL_DeltaHashKey
		
	, mysource.PromoCode
	, mysource.PromoName
	, mysource.promo_inet_name
	, mysource.promo_inet_desc
	, mysource.promo_type
	, mysource.promo_group_sell_flag
	, mysource.inet_start_datetime
	, mysource.inet_end_datetime
	, mysource.archtics_start_datetime
	, mysource.archtics_end_datetime
	, mysource.add_Datetime
	, mysource.add_user
	, mysource.upd_datetime

);

END

GO
