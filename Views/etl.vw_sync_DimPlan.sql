SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_DimPlan] as (
	SELECT [DimPlanId]
     ,[DimSeasonId]
     ,[PlanCode]
     ,[PlanName]
     ,[PlanDesc]
     ,[PlanClass]
     ,[PlanFse]
     ,[PlanType]
     ,[PlanEventCnt]
     ,[PlanStartDate]
     ,[PlanEndDate]
     ,[PlanStatus]
     ,[SSCreatedBy]
     ,[SSUpdatedBy]
     ,[SSCreatedDate]
     ,[SSUpdatedDate]
     ,[SSID]
     ,[SSID_event_id]
     ,[SourceSystem]
     ,[DeltaHashKey]
     ,[CreatedBy]
     ,[UpdatedBy]
     ,[CreatedDate]
     ,[UpdatedDate]
     ,[IsDeleted]
     ,[DeleteDate]
     ,[FullSeasonEventCnt]
     FROM dbo.DimPlan (NOLOCK)
)
GO
