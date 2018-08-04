SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [rpt].[vw_DimTeam] as (select * from dbo.DimTeam (nolock)) 


GO
