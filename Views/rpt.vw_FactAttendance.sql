SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [rpt].[vw_FactAttendance] AS (SELECT * FROM dbo.FactAttendance (nolock))
GO
