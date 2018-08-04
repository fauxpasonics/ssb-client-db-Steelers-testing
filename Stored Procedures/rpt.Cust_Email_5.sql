SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [rpt].[Cust_Email_5]
AS
SELECT * FROM [rpt].[PreCache_Cust_Email_5_tbl]
WHERE IsReady = 1

GO
