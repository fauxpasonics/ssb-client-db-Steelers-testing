SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_DimArena] as (
	SELECT [DimArenaId]
     ,[ArenaCode]
     ,[ArenaName]
     ,[ArenaDesc]
     ,[ArenaClass]
     ,[Capacity]
     ,[IsOutdoor]
     ,[StreetAddress]
     ,[City]
     ,[State]
     ,[ZipCode]
     ,[Latitude]
     ,[Longitude]
     ,[ArenaStartDate]
     ,[ArenaEndDate]
     ,[Active]
     ,[SSCreatedBy]
     ,[SSUpdatedBy]
     ,[SSCreatedDate]
     ,[SSUpdatedDate]
     ,[SSID]
     ,[SSID_arena_id]
     ,[SourceSystem]
     ,[DeltaHashKey]
     ,[CreatedBy]
     ,[UpdatedBy]
     ,[CreatedDate]
     ,[UpdatedDate]
     ,[IsDeleted]
     ,[DeleteDate]
     FROM dbo.DimArena (NOLOCK)
)
GO
