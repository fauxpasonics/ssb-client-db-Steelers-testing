SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [rpt].[vw_DimSalesCode] as (select * from dbo.DimSalesCode (nolock) where IsDeleted = 0) 

GO
