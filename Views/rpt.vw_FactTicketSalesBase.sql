SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [rpt].[vw_FactTicketSalesBase] AS ( --Change to ‘RO’ schema for Azure

SELECT

f.SSCreatedDate TransDateTime
, f.SSID_acct_id ArchticsAccountId
, da.ArenaName
, dsh.SeasonName SeasonHeaderName, dsh.SeasonClass SeasonHeaderClass, dsh.SeasonYear SeasonHeaderYear, dsh.Active SeasonHeaderIsActive
, ds.SeasonName, ds.SeasonYear, ds.SeasonClass
, deh.EventName EventHeaderName, deh.EventDesc EventHeaderDesc, deh.EventDateTime EventHeaderDateTime, deh.EventDate EventHeaderDate, deh.EventTime EventHeaderTime, deh.EventHierarchyL1, deh.EventHierarchyL2, deh.EventHierarchyL3
, de.EventCode, de.EventName, de.EventClass, de.EventDateTime, de.EventDate, de.EventTime, de.MajorCategoryTM, de.MinorCategoryTM
, di.ItemCode, di.ItemName
, dpl.PlanCode, dpl.PlanName, dpl.PlanClass, dpl.PlanFse, dpl.PlanEventCnt
, dst.SectionName, dst.RowName, dst.Seat, dst.Config_Location SeatLocationMapping
, dpc.PriceCode, dpc.pc1, dpc.PC2, dpc.PC3, dpc.PC4, dpc.PriceCodeDesc, dpc.PriceCodeGroup

, dtc.TicketClassCode, dtc.TicketClassName
, dtt.TicketTypeCode, dtt.TicketTypeName
, dpt.PlanTypeCode, dpt.PlanTypeName
, dstp.SeatTypeCode, dstp.SeatTypeName
, dctm.ClassName, dctm.DistStatus
, dsc.SalesCode, dsc.SalesCodeName
, dpm.PromoCode, dpm.PromoName

, f.OrderNum, f.OrderLineItem, f.OrderLineItemSeq
, f.QtySeat, f.QtySeatFSE
, f.TotalRevenue, f.TicketRevenue

, f.BlockFullPrice, f.BlockPurchasePrice, f.PcTicket BlockPcTicket, f.PcTax BlockPcTax, f.PcLicenseFee BlockPcLicenseFee, f.PcOther1 BlockPcOther1, f.PcOther2 BlockPcOther2, f.BlockSurcharge
, f.PaidAmount, f.OwedAmount, f.PaidStatus
, f.IsPremium, f.IsComp, f.IsHost, f.IsPlan, f.IsPartial, f.IsSingleEvent, f.IsGroup, f.IsBroker, f.IsRenewal, f.IsExpanded, f.IsAutoRenewalNextSeason

, f.DiscountCode, f.SurchargeCode, f.PricingMethod, f.CompCode, f.CompName, f.GroupSalesName, f.GroupFlag, f.TicketType, f.TranType, f.SalesSource, f.RetailTicketType, f.RetailQualifiers
, f.OtherInfo1, f.OtherInfo2, f.OtherInfo3, f.OtherInfo4, f.OtherInfo5, f.OtherInfo6, f.OtherInfo7, f.OtherInfo8, f.OtherInfo9, f.OtherInfo10

, f.FactTicketSalesId, f.DimDateId, f.DimDateId_OrigSale, f.DimTimeId, f.DimCustomerId, f.DimArenaId, f.DimSeasonId, f.DimItemId, f.DimEventId, f.DimPlanId
, f.DimPriceCodeMasterId, f.DimPriceCodeId, f.DimSeatIdStart, f.DimLedgerId, f.DimClassTMId, f.DimSalesCodeId, f.DimPromoId, f.DimTicketTypeId
, f.DimPlanTypeId, f.DimSeatTypeId, f.DimTicketClassId, f.DimTicketClassId2, f.DimTicketClassId3, f.DimTicketClassId4, f.DimTicketClassId5
, f.DimCustomerIdSalesRep, f.DimCustomerId_TransSalesRep
, f.TicketSeqId, f.SSID_event_id, f.SSID_section_id, f.SSID_row_id, f.SSID_seat_num, f.SSID_acct_id, f.SSID_price_code

--SELECT COUNT(*)
FROM dbo.FactTicketSales (NOLOCK) f
INNER JOIN dbo.DimArena (NOLOCK) da ON f.DimArenaId = da.DimArenaId
INNER JOIN dbo.DimSeason (NOLOCK) ds ON f.DimSeasonId = ds.DimSeasonId
INNER JOIN dbo.DimItem (NOLOCK) di ON f.DimItemId = di.DimItemId
INNER JOIN dbo.DimEvent (NOLOCK) de ON f.DimEventId = de.DimEventId
INNER JOIN dbo.DimEventHeader deh ON de.DimEventHeaderId = deh.DimEventHeaderId
INNER JOIN dbo.DimSeasonHeader dsh ON deh.DimSeasonHeaderId = dsh.DimSeasonHeaderId
INNER JOIN dbo.DimPlan (NOLOCK) dpl ON f.DimPlanId = dpl.DimPlanId
INNER JOIN dbo.DimPriceCode (NOLOCK) dpc ON f.DimPriceCodeId = dpc.DimPriceCodeId
INNER JOIN dbo.DimTicketClass (NOLOCK) dtc ON f.DimTicketClassId = dtc.DimTicketClassId
INNER JOIN dbo.DimTicketType (NOLOCK) dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
INNER JOIN dbo.DimPlanType (NOLOCK) dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
INNER JOIN dbo.DimSeatType (NOLOCK) dstp ON f.DimSeatTypeId = dstp.DimSeatTypeId
INNER JOIN dbo.DimClassTM (NOLOCK) dctm ON f.DimClassTMId = dctm.DimClassTMId
INNER JOIN dbo.DimSalesCode (NOLOCK) dsc ON f.DimSalesCodeId = dsc.DimSalesCodeId
INNER JOIN dbo.DimPromo (NOLOCK) dpm ON f.DimPromoId = dpm.DimPromoID
INNER JOIN dbo.DimSeat (NOLOCK) dst ON f.DimSeatIdStart = dst.DimSeatId


)












GO
