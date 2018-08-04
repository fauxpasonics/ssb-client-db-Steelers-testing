SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE PROC [rpt].[PreCache_Cust_DB_6] AS



INSERT INTO [rpt].[PreCache_Cust_DB_6_tbl]

SELECT SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS 'Male'
	  ,SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS 'Female'
	  ,SUM(CASE WHEN NOT Gender IN ('M','F') OR Gender IS NULL THEN 1 ELSE 0 END) AS 'UNKNOWN'
	  ,COUNT(*) TotalCount
	  ,0 AS IsReady
FROM mdm.compositerecord

DELETE FROM [rpt].[PreCache_Cust_DB_6_tbl] WHERE IsReady = 1
UPDATE [rpt].[PreCache_Cust_DB_6_tbl] SET IsReady = 1

GO
