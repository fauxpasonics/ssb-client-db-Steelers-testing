SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [rpt].[vw_DimGameInfo] as (select * from dbo.DimGameInfo (nolock)) 


GO
