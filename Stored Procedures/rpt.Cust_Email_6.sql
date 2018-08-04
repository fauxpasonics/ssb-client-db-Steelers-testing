SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [rpt].[Cust_Email_6]
AS

SELECT * FROM [rpt].[PreCache_Cust_Email_6_tbl] 
WHERE IsReady = 1


GO
