SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_DimEventHeader] as (
	SELECT [DimEventHeaderId]
     ,[DimArenaId]
     ,[DimSeasonHeaderId]
     ,[OpponentDimTeamId]
     ,[DimGameInfoId]
     ,[EventName]
     ,[EventDesc]
     ,[EventHierarchyL1]
     ,[EventHierarchyL2]
     ,[EventHierarchyL3]
     ,[EventHierarchyL4]
     ,[EventHierarchyL5]
     ,[EventDate]
     ,[EventTime]
     ,[EventDateTime]
     ,[EventOpenTime]
     ,[EventFinishTime]
     ,[EventSeasonNumber]
     ,[HomeGameNumber]
     ,[GameNumber]
     ,[IsSportingEvent]
     ,[CreatedBy]
     ,[UpdatedBy]
     ,[CreatedDate]
     ,[UpdatedDate]
     ,[IsDeleted]
     ,[DeleteDate]
     FROM dbo.DimEventHeader (NOLOCK)
)
GO
