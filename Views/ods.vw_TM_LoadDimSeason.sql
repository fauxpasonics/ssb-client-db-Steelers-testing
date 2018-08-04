SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [ods].[vw_TM_LoadDimSeason] as (

	select *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),Active)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DimArenaId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ManifestId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),PrevSeasonId)),'DBNULL_INT') + ISNULL(RTRIM(SeasonClass),'DBNULL_TEXT') + ISNULL(RTRIM(SeasonCode),'DBNULL_TEXT') + ISNULL(RTRIM(SeasonDesc),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SeasonEndDate,112)),'DBNULL_DATE') + ISNULL(RTRIM(SeasonName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SeasonStartDate,112)),'DBNULL_DATE') + ISNULL(RTRIM(SeasonYear),'DBNULL_TEXT') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_season_id)),'DBNULL_INT') + ISNULL(RTRIM(SSUpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SSUpdatedDate)),'DBNULL_DATETIME')) DeltaHashKey
	from (
		SELECT
			isnull(a.DimArenaId, -1) DimArenaId
			, null as SeasonCode
			, s.name as SeasonName
			, null as SeasonDesc
			, null as SeasonClass
			, s.season_year as SeasonYear
			, null as PrevSeasonId
			, cast(null as datetime) as SeasonStartDate
			, cast(null as datetime) as SeasonEndDate
			, s.manifest_id as ManifestId
			, 1 as Active
			, cast(null as nvarchar(255)) SSCreatedBy
			, s.upd_user SSUpdatedBy
			, s.add_datetime SSCreatedDate
			, s.upd_datetime SSUpdatedDate
			, s.season_id as [SSID]
			, s.season_id as [SSID_season_id]
			, CAST((SELECT etl.fnGetClientSetting('TM-SourceStyem')) AS NVARCHAR(255)) as [SourceSystem]
		
		FROM ods.TM_Season s
		LEFT OUTER JOIN dbo.DimArena a on s.arena_id = a.SSID AND a.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
	) a
)








GO
