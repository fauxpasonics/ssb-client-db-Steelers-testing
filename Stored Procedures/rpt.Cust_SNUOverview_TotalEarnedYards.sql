SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [rpt].[Cust_SNUOverview_TotalEarnedYards]
AS

SELECT * FROM [rpt].[PreCache_Cust_SNU_Total_tbl]  WHERE IsReady = 1


GO
