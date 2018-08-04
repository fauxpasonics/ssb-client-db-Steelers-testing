SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [rpt].[vw_DimPriceCode] as (select * from dbo.DimPriceCode (nolock) where IsDeleted = 0) 
GO
