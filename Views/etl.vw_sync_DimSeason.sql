SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_sync_DimSeason] AS (
	SELECT [DimSeasonId]
     ,[DimArenaId]
     ,[SeasonCode]
     ,[SeasonName]
     ,[SeasonDesc]
     ,[SeasonClass]
     ,[SeasonYear]
     ,[PrevSeasonId]
     ,[SeasonStartDate]
     ,[SeasonEndDate]
     ,[ManifestId]
     ,[Active]
     ,[SSCreatedBy]
     ,[SSUpdatedBy]
     ,[SSCreatedDate]
     ,[SSUpdatedDate]
     ,[SSID]
     ,[SSID_season_id]
     ,[SourceSystem]
     ,[DeltaHashKey]
     ,[CreatedBy]
     ,[UpdatedBy]
     ,[CreatedDate]
     ,[UpdatedDate]
     ,[IsDeleted]
     ,[DeleteDate]
     ,[Config_IsFactSalesEligible]
     ,[Config_IsMultiYearSeason]
     ,[Config_SeasonOrg]
     ,[Config_DefaultDimSeasonHeaderId]
     ,[Config_SeasonEventCntFSE]
     FROM dbo.DimSeason (NOLOCK)
)
GO
