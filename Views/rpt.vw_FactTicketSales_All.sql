SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [rpt].[vw_FactTicketSales_All] AS (

	SELECT FactTicketSalesId, DimDateId, DimDateId_OrigSale, DimTimeId, DimCustomerId, DimArenaId, DimSeasonId, DimItemId, DimEventId, DimPlanId, DimPriceCodeMasterId,
           DimPriceCodeId, DimSeatIdStart, DimLedgerId, DimClassTMId, DimSalesCodeId, DimPromoId, DimTicketTypeId, DimPlanTypeId, DimSeatTypeId, DimTicketClassId,
           DimTicketClassId2, DimTicketClassId3, DimTicketClassId4, DimTicketClassId5, DimCustomerIdSalesRep, DimCustomerId_TransSalesRep, OrderNum, OrderLineItem,
           OrderLineItemSeq, QtySeat, QtySeatFSE, TotalRevenue, TicketRevenue, PcTicketValue, FullPrice, BlockDiscountCalc, BlockDiscountArchtics, Discount,
           BlockSurcharge, Surcharge, PurchasePrice, BlockFullPrice, BlockPurchasePrice, PcPrice, PcPrintedPrice, PcTicket, PcTax, PcLicenseFee, PcOther1, PcOther2,
           PaidAmount, OwedAmount, PaidStatus, IsPremium, IsDiscount, IsComp, IsHost, IsPlan, IsPartial, IsSingleEvent, IsGroup, IsBroker, IsRenewal, IsExpanded,
           IsAutoRenewalNextSeason, DiscountCode, SurchargeCode, PricingMethod, CompCode, CompName, GroupSalesName, GroupFlag, ClassName, TicketType, TranType,
           SalesSource, RetailTicketType, RetailQualifiers, OtherInfo1, OtherInfo2, OtherInfo3, OtherInfo4, OtherInfo5, OtherInfo6, OtherInfo7, OtherInfo8, OtherInfo9,
           OtherInfo10, TicketSeqId, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_event_id, SSID_section_id, SSID_row_id, SSID_seat_num,
           SSID_acct_id, SSID_price_code, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate
	FROM dbo.FactTicketSales (NOLOCK)

		UNION ALL
	
	SELECT FactTicketSalesId, DimDateId, DimDateId_OrigSale, DimTimeId, DimCustomerId, DimArenaId, DimSeasonId, DimItemId, DimEventId, DimPlanId, DimPriceCodeMasterId,
           DimPriceCodeId, DimSeatIdStart, DimLedgerId, DimClassTMId, DimSalesCodeId, DimPromoId, DimTicketTypeId, DimPlanTypeId, DimSeatTypeId, DimTicketClassId,
           DimTicketClassId2, DimTicketClassId3, DimTicketClassId4, DimTicketClassId5, DimCustomerIdSalesRep, DimCustomerId_TransSalesRep, OrderNum, OrderLineItem,
           OrderLineItemSeq, QtySeat, QtySeatFSE, TotalRevenue, TicketRevenue, PcTicketValue, FullPrice, BlockDiscountCalc, BlockDiscountArchtics, Discount,
           BlockSurcharge, Surcharge, PurchasePrice, BlockFullPrice, BlockPurchasePrice, PcPrice, PcPrintedPrice, PcTicket, PcTax, PcLicenseFee, PcOther1, PcOther2,
           PaidAmount, OwedAmount, PaidStatus, IsPremium, IsDiscount, IsComp, IsHost, IsPlan, IsPartial, IsSingleEvent, IsGroup, IsBroker, IsRenewal, IsExpanded,
           IsAutoRenewalNextSeason, DiscountCode, SurchargeCode, PricingMethod, CompCode, CompName, GroupSalesName, GroupFlag, ClassName, TicketType, TranType,
           SalesSource, RetailTicketType, RetailQualifiers, OtherInfo1, OtherInfo2, OtherInfo3, OtherInfo4, OtherInfo5, OtherInfo6, OtherInfo7, OtherInfo8, OtherInfo9,
           OtherInfo10, TicketSeqId, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_event_id, SSID_section_id, SSID_row_id, SSID_seat_num,
           SSID_acct_id, SSID_price_code, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate 
	FROM dbo.FactTicketSalesHistory (NOLOCK)
	
)
GO
