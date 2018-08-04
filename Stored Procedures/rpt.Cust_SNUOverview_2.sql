SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [rpt].[Cust_SNUOverview_2]
AS

--Need to Commit changes as of 1050am 8/19/16


SELECT * FROM [rpt].[PreCache_Cust_SNU_2_tbl]	   WHERE IsReady = 1


GO
