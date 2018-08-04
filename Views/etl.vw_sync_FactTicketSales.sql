SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- View

CREATE VIEW [etl].[vw_sync_FactTicketSales] AS (

	SELECT f.FactTicketSalesId, f.DimDateId, f.DimDateId_OrigSale, f.DimTimeId, f.DimCustomerId, f.DimArenaId, f.DimSeasonId, f.DimItemId, f.DimEventId, f.DimPlanId,
           f.DimPriceCodeMasterId, f.DimPriceCodeId, f.DimSeatIdStart, f.DimLedgerId, f.DimClassTMId, f.DimSalesCodeId, f.DimPromoId, f.DimPlanTypeId,
           f.DimTicketTypeId, f.DimSeatTypeId, f.DimTicketClassId, f.DimTicketClassId2, f.DimTicketClassId3, f.DimTicketClassId4, f.DimTicketClassId5,
           f.DimCustomerIdSalesRep, f.DimCustomerId_TransSalesRep, f.OrderNum, f.OrderLineItem, f.OrderLineItemSeq, f.QtySeat, f.QtySeatFSE, f.TotalRevenue,
           f.TicketRevenue, f.PcTicketValue, f.FullPrice, f.BlockDiscountCalc, f.BlockDiscountArchtics, f.Discount, f.BlockSurcharge, f.Surcharge, f.PurchasePrice,
           f.BlockFullPrice, f.BlockPurchasePrice, f.PcPrice, f.PcPrintedPrice, f.PcTicket, f.PcTax, f.PcLicenseFee, f.PcOther1, f.PcOther2, f.PaidAmount, f.OwedAmount,
           f.PaidStatus, f.IsPremium, f.IsDiscount, f.IsComp, f.IsHost, f.IsPlan, f.IsPartial, f.IsSingleEvent, f.IsGroup, f.IsBroker, f.IsRenewal, f.IsExpanded,
           f.IsAutoRenewalNextSeason, f.DiscountCode, f.SurchargeCode, f.PricingMethod, f.CompCode, f.CompName, f.GroupSalesName, f.GroupFlag, f.ClassName,
           f.TicketType, f.TranType, f.SalesSource, f.RetailTicketType, f.RetailQualifiers, f.OtherInfo1, f.OtherInfo2, f.OtherInfo3, f.OtherInfo4, f.OtherInfo5,
           f.OtherInfo6, f.OtherInfo7, f.OtherInfo8, f.OtherInfo9, f.OtherInfo10, f.TicketSeqId, f.SSCreatedBy, f.SSUpdatedBy, f.SSCreatedDate, f.SSUpdatedDate, f.SSID,
           f.SSID_event_id, f.SSID_section_id, f.SSID_row_id, f.SSID_seat_num, f.SSID_acct_id, f.SSID_price_code, f.SourceSystem, f.DeltaHashKey, f.CreatedBy,
           f.UpdatedBy, f.CreatedDate, f.UpdatedDate, f.IsDeleted, f.DeleteDate
	FROM dbo.FactTicketSales f (NOLOCK)


)





GO
