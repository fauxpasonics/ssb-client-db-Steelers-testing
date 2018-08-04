SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [rpt].[vw_DimDate] as (select * from dbo.DimDate (nolock)) 


GO
