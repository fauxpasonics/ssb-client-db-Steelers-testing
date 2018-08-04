SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [rpt].[vw_DimSeasonHeader] AS (SELECT * FROM dbo.DimSeasonHeader (NOLOCK) where IsDeleted = 0) 

GO
