SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [rpt].[Cust_Email_12]
AS 
SELECT * FROM [rpt].[PreCache_Cust_Email_12_tbl] WHERE isReady = 1 ORDER BY sortOrder


GO
