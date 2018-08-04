SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_DimTeam] as (
	SELECT [DimTeamId]
     ,[TeamCity]
     ,[TeamName]
     ,[TeamFullName]
     ,[Division]
     ,[Conference]
     ,[TeamTier]
     ,[IsRival]
     FROM dbo.DimTeam (NOLOCK)
)
GO
