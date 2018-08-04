SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ods].[vw_TM_LoadDimEvent] AS (
	
	SELECT *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(VARCHAR(10),Attendance)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),Capacity)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),DimArenaId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),DimEventHeaderId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),DimSeasonId)),'DBNULL_INT') + ISNULL(RTRIM(EventClass),'DBNULL_TEXT') + ISNULL(RTRIM(EventCode),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),EventDate,112)),'DBNULL_DATE') + ISNULL(RTRIM(CONVERT(VARCHAR(25),EventDateTime)),'DBNULL_DATETIME') + ISNULL(RTRIM(EventDesc),'DBNULL_TEXT') + ISNULL(RTRIM(EventName),'DBNULL_TEXT') + ISNULL(RTRIM(EventStatus),'DBNULL_TEXT') + ISNULL(RTRIM(EventTime),'DBNULL_TEXT') + ISNULL(RTRIM(MajorCategoryTM),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),ManifestId)),'DBNULL_INT') + ISNULL(RTRIM(MinorCategoryTM),'DBNULL_TEXT') + ISNULL(RTRIM(ScanEventId),'DBNULL_TEXT') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT') + ISNULL(RTRIM(SSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),SSID_event_id)),'DBNULL_INT') + ISNULL(RTRIM(SSUpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),SSUpdatedDate)),'DBNULL_DATETIME')) DeltaHashKey
	FROM (
		SELECT  
			ISNULL(s.DimArenaId, -1) AS [DimArenaId]
			, ISNULL(s.DimSeasonId, -1) AS [DimSeasonId]
			, -1 AS [DimEventHeaderId]
			, e.Event_name AS [EventCode]
			, e.team AS [EventName]
			, e.event_name_long AS [EventDesc]
			, NULL AS [EventClass]
			, (CAST(event_date AS DATETIME) + CAST(event_time AS DATETIME)) AS [EventDateTime]
			, CAST(e.event_date AS DATE) AS [EventDate]
			, e.event_time [EventTime]
			, NULL AS [EventStatus]
			, NULL AS [Capacity]
			, NULL AS [Attendance]
			, e.Tm_event_name AS [ScanEventId]
			, s.ManifestId
			, e.Major_Category MajorCategoryTM
			, e.Minor_Category MinorCategoryTM
			, e.Event_id AS [SSID]
			, e.Event_id AS [SSID_event_id]
			, NULL AS [SSCreatedBy]
			, e.upd_user AS [SSUpdatedBy]
			, e.add_date AS [SSCreatedDate]
			, e.upd_date AS [SSUpdatedDate]
			, CAST((SELECT etl.fnGetClientSetting('TM-SourceStyem')) AS NVARCHAR(255)) AS [SourceSystem]
		--SELECT *
		FROM ods.TM_Evnt e
		LEFT OUTER JOIN dbo.DimSeason s ON e.season_id = s.SSID AND s.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		
		WHERE e.[Plan] = 'N'
	  ) a

)



GO
