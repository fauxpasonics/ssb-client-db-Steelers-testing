SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [rpt].[vw_DimItem] as (select * from dbo.DimItem (nolock) where IsDeleted = 0) 

GO
