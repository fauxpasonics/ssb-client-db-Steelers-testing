SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_DimGameInfo] as (
	SELECT [DimGameInfoId]
     ,[Outcome]
     ,[PistonsScore]
     ,[OpponentScore]
     ,[RecordToDateWin]
     ,[RecordToDateLoss]
     ,[OpponentRecordToDateWin]
     ,[OpponentRecordToDateLoss]
     ,[Qtr1StartTime]
     ,[Qtr1EndTime]
     ,[Qtr2StartTime]
     ,[Qtr2EndTime]
     ,[Qtr3StartTime]
     ,[Qtr3EndTime]
     ,[Qtr4StartTime]
     ,[Qtr4EndTime]
     ,[OvertimePeriods]
     ,[CreatedBy]
     ,[UpdatedBy]
     ,[CreatedDate]
     ,[UpdatedDate]
     ,[IsDeleted]
     ,[DeleteDate]
     ,[SSID]
     ,[SourceSystem]
     FROM dbo.DimGameInfo (NOLOCK)
)
GO
