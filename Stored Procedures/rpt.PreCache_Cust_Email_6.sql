SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROC [rpt].[PreCache_Cust_Email_6] 
AS

INSERT INTO [rpt].[PreCache_Cust_Email_6_tbl] 

SELECT SUM(optout_FLG) OPTOUT
	   ,SUM(undeliverable) Total_Num_FTD
	   ,0 AS IsReady
FROM [rpt].[vw__Epsilon_PDU_Harmony]

DELETE FROM [rpt].[PreCache_Cust_Email_6_tbl] 
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_Email_6_tbl] 
SET IsReady = 1


GO
