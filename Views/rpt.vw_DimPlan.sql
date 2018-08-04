SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [rpt].[vw_DimPlan] as (select * from dbo.DimPlan (nolock) where IsDeleted = 0) 
GO
