SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [rpt].[Cust_Email_9]
AS 
SELECT * FROM [rpt].[PreCache_Cust_Email_9_tbl] WHERE isReady = 1 ORDER BY sortOrder
GO
