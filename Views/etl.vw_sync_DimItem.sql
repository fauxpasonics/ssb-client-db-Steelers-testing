SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_DimItem] as (
	SELECT [DimItemId]
     ,[DimSeasonId]
     ,[ItemCode]
     ,[ItemName]
     ,[ItemDesc]
     ,[ItemClass]
     ,[ItemStatus]
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
     ,[Config_IsFactSalesEligible]
     ,[Config_IsClosed]
     ,[DimSeasonHeaderId]
     FROM dbo.DimItem (NOLOCK)
)
GO
