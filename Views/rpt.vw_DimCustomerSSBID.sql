SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [rpt].[vw_DimCustomerSSBID] AS (SELECT * FROM dbo.DimCustomerSSBID (NOLOCK))





GO
