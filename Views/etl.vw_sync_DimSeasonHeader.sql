SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_DimSeasonHeader] as (
	SELECT [DimSeasonHeaderId]
     ,[DimArenaId]
     ,[SeasonCode]
     ,[SeasonName]
     ,[SeasonDesc]
     ,[SeasonClass]
     ,[SeasonYear]
     ,[PrevSeasonHeaderId]
     ,[SeasonStartDate]
     ,[SeasonEndDate]
     ,[Active]
     ,[CreatedBy]
     ,[UpdatedBy]
     ,[CreatedDate]
     ,[UpdatedDate]
     ,[IsDeleted]
     ,[DeleteDate]
     ,[Config_Org]
     ,[Config_AccountingYearName]
     ,[Config_AccountingYearStartDate]
     ,[Config_AccountingYearEndDate]
     FROM dbo.DimSeasonHeader (NOLOCK)
)
GO
