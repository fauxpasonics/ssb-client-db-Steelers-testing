SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [ods].[vw_TM_LoadDimArena] as (
	
	SELECT *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),Active)),'DBNULL_BIT') + ISNULL(RTRIM(ArenaClass),'DBNULL_TEXT') + ISNULL(RTRIM(ArenaCode),'DBNULL_TEXT') + ISNULL(RTRIM(ArenaDesc),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ArenaEndDate,112)),'DBNULL_DATE') + ISNULL(RTRIM(ArenaName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ArenaStartDate,112)),'DBNULL_DATE') + ISNULL(RTRIM(CONVERT(varchar(10),Capacity)),'DBNULL_INT') + ISNULL(RTRIM(City),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),IsOutdoor)),'DBNULL_BIT') + ISNULL(RTRIM(Latitude),'DBNULL_TEXT') + ISNULL(RTRIM(Longitude),'DBNULL_TEXT') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT') + ISNULL(RTRIM(SSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_arena_id)),'DBNULL_INT') + ISNULL(RTRIM(SSUpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SSUpdatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(State),'DBNULL_TEXT') + ISNULL(RTRIM(StreetAddress),'DBNULL_TEXT') + ISNULL(RTRIM(ZipCode),'DBNULL_TEXT')) DeltaHashKey
	FROM (
		SELECT 
			a.arena_abv [ArenaCode]
			, a.arena_name [ArenaName]
			, a.arena_name [ArenaDesc]
			, null [ArenaClass]
			, null [Capacity]
			, null [IsOutdoor]
			, isnull(a.street_addr_1,'') + ' ' + isnull(a.street_addr_2,'') as [StreetAddress]
			, a.city [City]
			, a.state [State]
			, a.venue_zip [ZipCode]
			, null [Latitude]
			, null [Longitude]
			, cast(null as date) [ArenaStartDate]
			, cast(null as date) [ArenaEndDate]
			, 1 as [Active]
			, cast(null as nvarchar(255)) SSCreatedBy
			, cast(null as nvarchar(255)) SSUpdatedBy
			, cast(null as datetime) SSCreatedDate
			, cast(null as datetime) SSUpdatedDate
			, cast(a.arena_id as nvarchar(255)) [SSID]
			, a.arena_id SSID_arena_id
			, CAST((SELECT etl.fnGetClientSetting('TM-SourceStyem')) AS NVARCHAR(255)) as [SourceSystem]
		FROM ods.TM_Arena a
	) a
	
)
	










GO
