SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Sync_FactAttendanceRealtime] AS ( SELECT * FROM dbo.FactAttendance (NOLOCK) )
GO
