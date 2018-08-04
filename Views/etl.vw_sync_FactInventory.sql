SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- View

CREATE VIEW [etl].[vw_sync_FactInventory] AS (

	SELECT f.FactInventoryId, f.ETL_CreatedDate, f.ETL_UpdatedDate, f.DimArenaId, f.DimSeasonId, f.DimEventId, f.DimSeatId, f.SoldDimCustomerId, f.SoldDimDateId,
           f.SoldDimTimeId, f.SoldDimItemId, f.SoldDimPlanId, f.SoldDimPriceCodeId, f.SoldDimSalesCodeId, f.SoldDimPromoId, f.SoldDimTicketClassId, f.SoldDateTime,
           f.SoldDimClassTMId, f.ManifestDimPriceCodeId, f.ManifestDimClassTMId, f.ManifestSeatValue, f.PostedDimPriceCodeId, f.PostedDimClassTMId, f.PostedSeatValue,
           f.SeatStatus, f.IsAvailable, f.IsSaleable, f.IsSold, f.IsHeld, f.IsComp, f.IsAttended, f.ScanDateTime, f.ScanGate, f.TotalRevenue, f.TicketRevenue,
           f.PcTicketValue, f.FullPrice, f.Discount, f.Surcharge, f.PurchasePrice, f.PcPrice, f.PcPrintedPrice, f.PcTicket, f.PcTax, f.PcLicenseFee, f.PcOther1,
           f.PcOther2, f.SeatBlockSize, f.SoldOrderNum, f.SoldOrderLineItem, f.EventDateTime, f.IsResold, f.ResoldDimCustomerId, f.ResoldDimDateId, f.ResoldDimTimeId,
           f.ResoldDateTime, f.ResoldPurchasePrice, f.ResoldFees, f.ResoldTotalAmount, f.SoldDimLedgerId, f.IsHost, f.IsReserved, f.HeldDimPriceCodeId,
           f.HeldDimClassTMId, f.HeldSeatValue, f.FactTicketSalesId
	FROM dbo.FactInventory f (NOLOCK)

)


GO
