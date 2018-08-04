SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [ods].[vw_TM_LoadDimSeat] AS (

	SELECT *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(VARCHAR(10),DefaultClass)),'DBNULL_INT') + ISNULL(RTRIM(DefaultPriceCode),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),DimArenaId)),'DBNULL_INT') + ISNULL(RTRIM(ManifestId),'DBNULL_TEXT') + ISNULL(RTRIM(RowName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),RowSort)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),Seat)),'DBNULL_INT') + ISNULL(RTRIM(SectionDesc),'DBNULL_TEXT') + ISNULL(RTRIM(SectionName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),SectionSort)),'DBNULL_INT') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT') + ISNULL(RTRIM(SSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),SSID_manifest_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),SSID_row_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),SSID_seat)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),SSID_section_id)),'DBNULL_INT') + ISNULL(RTRIM(SSUpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),SSUpdatedDate)),'DBNULL_DATETIME')) DeltaHashKey
	FROM (
		SELECT 
		da.DimArenaId
		, ms.manifest_id ManifestId
		, ms.section_name SectionName
		, ms.section_desc SectionDesc
		, 0 SectionSort
		, ms.row_name RowName
		, 0 RowSort
		, sl.Seat Seat
		, ms.default_class DefaultClass
		, ms.def_price_code DefaultPriceCode
		, CAST(NULL AS NVARCHAR(255)) SSCreatedBy
		, CAST(NULL AS NVARCHAR(255)) SSUpdatedBy
		, CAST(NULL AS DATETIME) SSCreatedDate
		, CAST(NULL AS DATETIME) SSUpdatedDate
		, NULL SSID
		, ms.manifest_id SSID_manifest_id
		, ms.section_id SSID_section_id
		, ms.row_id SSID_row_id
		, sl.Seat SSID_seat
		, CAST((SELECT etl.fnGetClientSetting('TM-SourceStyem')) AS NVARCHAR(255)) SourceSystem

		, ROW_NUMBER() OVER	(PARTITION BY ms.manifest_id, ms.section_id, ms.row_id, sl.Seat ORDER BY ms.UpdateDate DESC) RowRank

		FROM ods.TM_ManifestSeat ms
		INNER JOIN dbo.DimArena da ON ms.arena_id = da.SSID AND da.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		INNER LOOP JOIN dbo.Lkp_SeatList sl ON sl.seat >= ms.seat_num AND sl.Seat < (ms.seat_num + ms.num_seats)

	) a
	WHERE RowRank = 1

) 








GO
