SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [rpt].[Cust_MerchOverview_3] AS

SELECT * FROM [rpt].[PreCache_Cust_Merch_3_tbl]	WHERE IsReady = 1


GO
