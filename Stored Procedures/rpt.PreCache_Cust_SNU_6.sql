SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROC [rpt].[PreCache_Cust_SNU_6]
 AS

INSERT INTO [rpt].[PreCache_Cust_SNU_6_tbl]

SELECT CASE WHEN ISNULL(cr.AddressPrimaryZip,'') = '' THEN 'UNKNOWN'
		    WHEN inmarket.zip IS NULL THEN 'Out of Market'
			ELSE 'In Market'
	   END AS MarketGroup
	   ,COUNT(DISTINCT cr.SSB_CRMSYSTEM_CONTACT_ID)IdCount
	   ,0 AS IsReady
FROM (SELECT COALESCE(ssid.DimCustomerId, email.DimCustomerId) dimcustomerID
	  FROM ods.Steelers_500f_Customer customer
		   LEFT JOIN dimcustomer ssid ON ssid.ssid = customer.loyalty_id
										 AND ssid.SourceSystem = '500f'
		   LEFT JOIN dimcustomer email ON email.EmailPrimary = customer.email
										  AND email.SourceSystem = '500f'
	  WHERE customer.status = 'Active'
	  ) dc
	JOIN dbo.DimCustomerSSBID ssbid ON ssbid.DimCustomerId = dc.DimCustomerId									   
	JOIN mdm.compositerecord cr ON ssbid.SSB_CRMSYSTEM_CONTACT_ID = cr.SSB_CRMSYSTEM_CONTACT_ID
	LEFT JOIN adhoc.InMarketZip inmarket ON inmarket.zip = cr.AddressPrimaryZip
GROUP BY CASE WHEN ISNULL(cr.AddressPrimaryZip,'') = '' THEN 'UNKNOWN'
		    WHEN inmarket.zip IS NULL THEN 'Out of Market'
			ELSE 'In Market'
	   END

DELETE FROM [rpt].[PreCache_Cust_SNU_6_tbl]
WHERE IsReady = 1

UPDATE [rpt].[PreCache_Cust_SNU_6_tbl]
SET IsReady = 1



GO
