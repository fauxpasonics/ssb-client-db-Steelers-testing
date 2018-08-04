SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [rpt].[PreCache_Cust_DB_2] AS

INSERT INTO [rpt].[PreCache_Cust_DB_2_tbl]

SELECT ISNULL(StateLookup.StateCode,'UNKNOWN') StateCode
	   ,COUNT(cr.SSB_CRMSYSTEM_CONTACT_ID) numCustomers
	   ,0 AS IsReady
FROM mdm.compositerecord cr
	LEFT JOIN rpt.StateNameLookup StateLookup ON cr.AddressPrimaryState = StateLookup.MatchName
GROUP BY ISNULL(StateLookup.StateCode,'UNKNOWN')

DELETE FROM [rpt].[PreCache_Cust_DB_2_tbl] WHERE IsReady = 1
UPDATE [rpt].[PreCache_Cust_DB_2_tbl] SET IsReady = 1

GO
