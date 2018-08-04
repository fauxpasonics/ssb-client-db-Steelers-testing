SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROC [rpt].[PreCache_Cust_DB_3] AS

INSERT INTO [rpt].[PreCache_Cust_DB_3_tbl]

SELECT TOP 20 *,0 AS IsReady 
FROM  ( SELECT CountryLookup.DisplayName
			   ,COUNT(cr.SSB_CRMSYSTEM_CONTACT_ID) numCustomers
		FROM mdm.compositerecord cr
			JOIN rpt.CountryNameLookup CountryLookup ON cr.AddressPrimaryCountry = CountryLookup.MatchName
		GROUP BY CountryLookup.DisplayName
	   )x
ORDER BY x.numCustomers DESC	

DELETE FROM [rpt].[PreCache_Cust_DB_3_tbl] WHERE isReady = 1
UPDATE [rpt].[PreCache_Cust_DB_3_tbl] SET IsReady = 1

GO
