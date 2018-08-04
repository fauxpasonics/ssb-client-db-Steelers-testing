SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ods].[vw_TM_LoadDimPlan] as (
	
	SELECT *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),DimSeasonId)),'DBNULL_INT') + ISNULL(RTRIM(PlanClass),'DBNULL_TEXT') + ISNULL(RTRIM(PlanCode),'DBNULL_TEXT') + ISNULL(RTRIM(PlanDesc),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),PlanEndDate,112)),'DBNULL_DATE') + ISNULL(RTRIM(CONVERT(varchar(10),PlanEventCnt)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),PlanFse)),'DBNULL_NUMBER') + ISNULL(RTRIM(PlanName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),PlanStartDate,112)),'DBNULL_DATE') + ISNULL(RTRIM(PlanStatus),'DBNULL_TEXT') + ISNULL(RTRIM(PlanType),'DBNULL_TEXT') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT') + ISNULL(RTRIM(SSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_event_id)),'DBNULL_INT') + ISNULL(RTRIM(SSUpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SSUpdatedDate)),'DBNULL_DATETIME')) DeltaHashKey
	from (
		SELECT 
			isnull(ds.DimSeasonId, -1) as [DimSeasonId]
			, p.event_name as [PlanCode]
			, p.team as [PlanName]
			, p.event_name_long as [PlanDesc]
			, p.plan_abv as [PlanClass]      
			, p.FSE as [PlanFse]
			, p.plan_type as [PlanType]
			, p.total_events as [PlanEventCnt]
			, cast(null as date) as [PlanStartDate]
			, cast(null as date) as [PlanEndDate]
			, null as [PlanStatus]
			, cast(null as nvarchar(255)) as [SSCreatedBy]
			, p.upd_user as [SSUpdatedBy]
			, p.add_date as [SSCreatedDate]
			, p.upd_date as [SSUpdatedDate]
			, cast(p.event_id as nvarchar(255)) as [SSID]
			, p.event_id as [SSID_event_id]
			, p.id as [odsPlanId]
			, CAST((SELECT etl.fnGetClientSetting('TM-SourceStyem')) AS NVARCHAR(255)) as [SourceSystem]

		  FROM ods.TM_Evnt p
		  LEFT OUTER JOIN dbo.DimSeason ds on p.season_id = ds.SSID AND ds.SourceSystem = CAST((SELECT etl.fnGetClientSetting('TM-SourceStyem')) AS NVARCHAR(255))
		  --LEFT OUTER JOIN dbo.SSBETLXref x on x.srcFieldValue = p.event_name and x.srcField = 'event_name'
		  
		  WHERE p.plan_type <> 'N'
	  ) a

) 



GO
