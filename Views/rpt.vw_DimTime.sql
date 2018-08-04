SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [rpt].[vw_DimTime] as (select * from dbo.DimTime (nolock)) 


GO
