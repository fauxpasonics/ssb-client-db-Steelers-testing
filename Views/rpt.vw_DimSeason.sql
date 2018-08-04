SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [rpt].[vw_DimSeason] as (select * from dbo.DimSeason (nolock) where IsDeleted = 0) 

GO
