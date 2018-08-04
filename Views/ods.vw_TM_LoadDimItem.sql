SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [ods].[vw_TM_LoadDimItem] as (

	select *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),DimSeasonId)),'DBNULL_INT') + ISNULL(RTRIM(ItemClass),'DBNULL_TEXT') + ISNULL(RTRIM(ItemCode),'DBNULL_TEXT') + ISNULL(RTRIM(ItemDesc),'DBNULL_TEXT') + ISNULL(RTRIM(ItemName),'DBNULL_TEXT') + ISNULL(RTRIM(ItemStatus),'DBNULL_TEXT') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT') + ISNULL(RTRIM(SSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_event_id)),'DBNULL_INT') + ISNULL(RTRIM(SSUpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SSUpdatedDate)),'DBNULL_DATETIME')) DeltaHashKey
	from (
		SELECT 
			isnull(s.DimSeasonId,-1) as [DimSeasonId]
			, i.event_name as [ItemCode]
			, i.team as [ItemName]
			, i.event_name_long as [ItemDesc]
			, case when i.[plan] = 'Y' then 'Plan' else 'Event' end [ItemClass]
			, null as [ItemStatus]
			, cast(null as nvarchar(255)) [SSCreatedBy]
			, i.Upd_date [SSUpdatedBy]
			, i.Add_date [SSCreatedDate]
			, i.Upd_date [SSUpdatedDate]		
			, i.event_id as [SSID]
			, i.event_id as [SSID_event_id]
			, CAST((SELECT etl.fnGetClientSetting('TM-SourceStyem')) AS NVARCHAR(255)) as [SourceSystem]			
		FROM ods.TM_Evnt i
		LEFT OUTER JOIN dbo.DimSeason s on i.season_id = s.SSID AND s.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
	) a

)








GO
