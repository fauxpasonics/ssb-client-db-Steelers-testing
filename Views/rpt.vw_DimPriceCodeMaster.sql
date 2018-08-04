SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [rpt].[vw_DimPriceCodeMaster] as (select * from dbo.DimPriceCodeMaster (nolock)) 
GO
