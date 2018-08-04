SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [rpt].[vw_DimArena] as (select * from dbo.DimArena (nolock) where IsDeleted = 0)

GO
