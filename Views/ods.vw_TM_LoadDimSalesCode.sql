SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [ods].[vw_TM_LoadDimSalesCode] as (

	select *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),IsHost)),'DBNULL_BIT') + ISNULL(RTRIM(SalesCode),'DBNULL_TEXT') + ISNULL(RTRIM(SalesCodeClass),'DBNULL_TEXT') + ISNULL(RTRIM(SalesCodeDesc),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SalesCodeEndDate,112)),'DBNULL_DATE') + ISNULL(RTRIM(SalesCodeName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SalesCodeStartDate,112)),'DBNULL_DATE') + ISNULL(RTRIM(SalesCodeStatus),'DBNULL_TEXT') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT') + ISNULL(RTRIM(SSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_sell_location_id)),'DBNULL_INT') + ISNULL(RTRIM(SSUpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SSUpdatedDate)),'DBNULL_DATETIME')) DeltaHashKey
	from (
		SELECT 
			cast(sl.sell_location_code as nvarchar(50)) SalesCode
			, cast(sl.sell_location_name as nvarchar(200)) SalesCodeName
			, cast(sl.sell_location_desc as nvarchar(500)) SalesCodeDesc
			, cast(null as nvarchar(50)) SalesCodeClass
			, cast((case when sl.sell_location_code like '%@%' then 1 else 0 end) as bit) IsHost
			, cast(null as date) SalesCodeStartDate
			, cast(null as date) SalesCodeEndDate
			, cast(case when sl.active = 'Y' then 'Active' else 'Inactive' end as nvarchar(50)) SalesCodeStatus
			, sl.add_user SSCreatedBy
			, sl.upd_user SSUpdatedBy
			, sl.add_datetime SSCreatedDate
			, sl.upd_datetime SSUpdatedDate
			, sl.sell_location_id SSID
			, sl.sell_location_id SSID_sell_location_id
			, CAST((SELECT etl.fnGetClientSetting('TM-SourceStyem')) AS NVARCHAR(255)) SourceSystem

		FROM ods.TM_SellLocation sl
	) a

) 









GO
