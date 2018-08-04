SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [rpt].[Cust_SNUOverview_EarnedYardsPast180]
AS

SELECT * FROM [rpt].[PreCache_Cust_SNU_180_tbl]	   WHERE IsReady = 1

GO
