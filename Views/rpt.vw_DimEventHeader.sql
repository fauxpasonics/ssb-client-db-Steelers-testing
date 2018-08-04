SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [rpt].[vw_DimEventHeader] as (select * from dbo.DimEventHeader (nolock) where IsDeleted = 0) 

GO
