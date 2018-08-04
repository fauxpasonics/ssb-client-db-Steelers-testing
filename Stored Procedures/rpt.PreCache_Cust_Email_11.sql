SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [rpt].[PreCache_Cust_Email_11]

AS 

INSERT INTO [rpt].[PreCache_Cust_Email_11_tbl]

SELECT CASE WHEN ISNULL(cr.AddressPrimaryZip,'') = '' THEN 'UNKNOWN'
			WHEN zip.Zip IS NOT NULL THEN 'In Market'
			ELSE 'Out Of Market'
	   END AS MarketGroup
	   ,COUNT(DISTINCT ssbid.SSID) IdCount
	   ,0 AS IsReady
FROM mdm.compositerecord cr
	JOIN dbo.DimCustomerSSBID ssbid ON ssbid.SSB_CRMSYSTEM_CONTACT_ID = cr.SSB_CRMSYSTEM_CONTACT_ID
	JOIN rpt.vw__Epsilon_Emailable_Harmony emailable ON emailable.PROFILE_KEY = ssbid.SSID
	LEFT JOIN adhoc.InMarketZip zip ON zip.Zip = cr.AddressPrimaryZip
WHERE ssbid.SourceSystem = 'Epsilon'
GROUP BY CASE WHEN ISNULL(cr.AddressPrimaryZip,'') = '' THEN 'UNKNOWN'
			WHEN zip.Zip IS NOT NULL THEN 'In Market'
			ELSE 'Out Of Market'
	     END

DELETE FROM [rpt].[PreCache_Cust_Email_11_tbl]
WHERE isReady = 1

UPDATE [rpt].[PreCache_Cust_Email_11_tbl]
SET isReady = 1







GO
