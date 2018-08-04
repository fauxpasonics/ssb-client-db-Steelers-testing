SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [rpt].[Cust_MerchOverview_4] AS

SELECT * FROM [rpt].[PreCache_Cust_Merch_4_tbl]	WHERE IsReady = 1


GO
