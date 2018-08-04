SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [rpt].[vw_DimTicketClass] as (select * from dbo.DimTicketClass (nolock) where IsDeleted = 0) 

GO
