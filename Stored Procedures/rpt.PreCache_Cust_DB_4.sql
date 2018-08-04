SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROC [rpt].[PreCache_Cust_DB_4] AS

INSERT INTO [rpt].[PreCache_Cust_DB_4_tbl]

SELECT CASE WHEN ISNULL(cr.AddressPrimaryZip,'') = '' THEN 'UNKNOWN'
			WHEN InMarket.zip IS NOT NULL THEN 'In Market'
			ELSE 'Out Of Market'
	   END AS InMarket
	   ,COUNT(cr.SSB_CRMSYSTEM_CONTACT_ID) numCustomers
	   ,0 AS IsReady
FROM mdm.compositerecord cr
	LEFT JOIN adhoc.InMarketZip InMarket ON cr.AddressPrimaryZip = InMarket.Zip
GROUP BY CASE WHEN ISNULL(cr.AddressPrimaryZip,'') = '' THEN 'UNKNOWN'
			WHEN InMarket.zip IS NOT NULL THEN'In Market'
			ELSE 'Out Of Market'
	   END

DELETE FROM [rpt].[PreCache_Cust_DB_4_tbl] WHERE IsReady = 1
UPDATE [rpt].[PreCache_Cust_DB_4_tbl] SET IsReady = 1


GO
