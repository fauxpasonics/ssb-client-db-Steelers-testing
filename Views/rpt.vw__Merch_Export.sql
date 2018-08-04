SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [rpt].[vw__Merch_Export]

AS 


select pos.*
FROM dbo.FactPointOfSale pos
	JOIN ods.Merch_Order completed ON completed.Id = pos.ETL_SSID
	JOIN dbo.FactPointOfSaleDetail posd ON pos.FactPointOfSaleId = posd.FactPointOfSaleId
	JOIN dimcustomerSSBID ssbid  ON pos.customerID = ssbid.SSID
									AND ssbid.SourceSystem = 'merch'
	JOIN (  select merch.SSB_CRMSYSTEM_CONTACT_ID
			FROM (  SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID
					FROM dbo.FactPointOfSale pos
						JOIN ods.Merch_Order completed ON completed.Id = pos.ETL_SSID
						JOIN dbo.FactPointOfSaleDetail posd ON pos.FactPointOfSaleId = posd.FactPointOfSaleId
						JOIN dimcustomerSSBID ssbid  ON pos.customerID = ssbid.SSID
														AND ssbid.SourceSystem = 'merch'
					WHERE completed.OrderStatusId = 30
						  AND pos.DimDateId_SaleDate >= 20150724
				 ) merch
				 LEFT JOIN (select DISTINCT SSB_CRMSYSTEM_CONTACT_ID 
	 					   FROM rpt.vw__epsilon_emailable_Harmony harmony
	 						JOIN dimcustomerssbid ssbid on ssbid.SSID = harmony.PROFILE_KEY
	 					   WHERE ssbid.sourcesystem = 'Epsilon'
	 					   )emailable on emailable.SSB_CRMSYSTEM_CONTACT_ID = merch.SSB_CRMSYSTEM_CONTACT_ID
			WHERE emailable.SSB_CRMSYSTEM_CONTACT_ID IS NULL
		 ) ne on ne.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID
WHERE completed.OrderStatusId = 30
	  AND pos.DimDateId_SaleDate >= 20150724
--ORDER BY pos.DimDateId_SaleDate



GO
