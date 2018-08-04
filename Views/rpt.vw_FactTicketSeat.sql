SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [rpt].[vw_FactTicketSeat] AS (

SELECT
    
	dd.CalDate SaleDate, dt.Time24 SaleTime, ( CAST(dd.CalDate AS DATETIME) + CAST(dt.Time24 AS DATETIME) ) SaleDateTime
    , dc.AccountId
	
	, da.ArenaCode, da.ArenaName
	, fts.sourcesystem
	, dsh.SeasonCode SeasonHeaderCode, dsh.SeasonName SeasonHeaderName, dsh.SeasonDesc SeasonHeaderDesc, dsh.SeasonClass SeasonHeaderClass, dsh.SeasonYear SeasonHeaderYear, dsh.Active SeasonHeaderIsActive
	, ds.SeasonName, ds.SeasonYear, ds.SeasonClass, ds.Active SeasonIsActive
	, deh.EventName EventHeaderName, deh.EventDesc EventHeaderDesc, deh.EventDate EventHeaderDate, deh.EventTime EventHeaderTime, deh.EventDateTime EventHeaderDateTime, deh.EventOpenTime EventHeaderOpenTime, deh.EventFinishTime EventHeaderFinishTime, deh.EventSeasonNumber EventSeasonNumber, deh.HomeGameNumber EventHeaderHomeNumber, deh.GameNumber EventHeaderGameNumber, deh.EventHierarchyL1, deh.EventHierarchyL2, deh.EventHierarchyL3, deh.EventHierarchyL4, deh.EventHierarchyL5
    , de.EventCode, de.EventName, de.EventDate, de.EventTime, de.EventDateTime, de.EventClass, de.MajorCategoryTM, de.MinorCategoryTM
	, di.ItemCode, di.ItemName, di.ItemClass ItemPlanOrEvent
	, dpl.PlanCode, dpl.PlanName, dpl.PlanDesc, dpl.PlanClass, dpl.PlanFse, dpl.PlanType, dpl.PlanEventCnt
	, dpc.PriceCode, dpc.PC1, dpc.PC2, dpc.pc3, dpc.PC4, dpc.PriceCodeDesc, dpc.PriceCodeGroup
	, dst.SectionName, dst.RowName, dst.Seat
	, dst.Config_Location SeatLocationMapping
	, dtc.TicketClassCode, dtc.TicketClassName
	, tt.TicketTypeCode, tt.TicketTypeName
	, pt.PlanTypeCode, pt.PlanTypeName
	, dstp.SeatTypeCode, dstp.SeatTypeName
	, dctm.ClassName, dctm.DistStatus
	, dsc.SalesCode, dsc.SalesCodeName
	, dpm.PromoCode, dpm.PromoName
	
	, dpc_Manifest.PriceCode ManifestedPriceCode
	, dctm_Manifest.ClassName ManifestedClassName
	, fi.ManifestSeatValue ManifestedSeatValue

	, dpc_Posted.PriceCode PostedPriceCode
	, dctm_Posted.ClassName PostedClassName
	, fi.PostedSeatValue

	, dpc_Held.PriceCode HeldPriceCode
	, dctm_Held.ClassName HeldClassName
	, fi.HeldSeatValue

	, fi.IsSaleable
	, fi.IsAvailable
	, fi.IsHeld
	, fi.IsReserved
	
	, fi.IsSold
	, fi.IsHost
	, fi.IsComp

	, fts.CompCode, fts.CompName
	
	, fts.IsPremium
	, fts.IsSingleEvent
	, fts.IsPlan
	, fts.IsPartial
    , fts.IsGroup
	, fts.IsRenewal

	, fi.TotalRevenue, fi.PcTicketValue, fi.Surcharge, fi.PcTicket, fi.PcTax, fi.PcLicenseFee, fi.PcOther1, fi.PcOther2

	, fi.IsAttended
	, fi.ScanDateTime
	, fi.ScanGate

	, ( fts.QtySeatFSE / CAST(fts.QtySeat AS DECIMAL(18,6)) ) QtySeatFSE
	, ( fts.PaidAmount / CAST(fts.QtySeat AS DECIMAL(18,6)) ) PaidAmount
	, ( fts.OwedAmount / CAST(fts.QtySeat AS DECIMAL(18,6)) ) OwedAmount

	, fts.OrderNum OrderNum
	, fts.OrderLineItem OrderLineItem
	, fts.RetailTicketType, fts.RetailQualifiers

	, fi.IsResold
	, ( CAST(dd_resold.CalDate AS DATETIME) + CAST(dt_resold.Time24 AS DATETIME) ) ResoldDateTime
	, fi.ResoldPurchasePrice
	, fi.ResoldFees
	, fi.ResoldTotalAmount

	, ds.Config_SeasonOrg Org

	, fi.FactInventoryId, fi.FactTicketSalesId, fi.DimSeasonId, fi.DimEventId, fi.DimSeatId, fi.SoldDimPriceCodeId, fi.SoldDimItemId, fi.SoldDimPlanId, fi.SoldDimCustomerId
	, fi.SoldDimDateId, fi.SoldDimTimeId, fi.SoldDimClassTMId, fi.SoldDimSalesCodeId, fi.SoldDimPromoId, fts.DimPlanTypeId, fts.DimTicketTypeId, fts.DimSeatTypeId
	, fi.ResoldDimCustomerId
	, dsh.DimSeasonHeaderId, dsh.PrevSeasonHeaderId
	, deh.DimEventHeaderId, ds.PrevSeasonId
	, de.SSID_event_id
	, dst.SSID_section_id
	, dst.SSID_row_id
	, dst.SSID_seat



--SELECT COUNT(*)



--FROM (SELECT * FROM rpt.vw_FactInventory WHERE DimEventId = 341) fi
FROM dbo.FactInventory (NOLOCK) fi

INNER JOIN dbo.DimSeason (NOLOCK) ds ON fi.DimSeasonId = ds.DimSeasonId
INNER JOIN dbo.DimArena (NOLOCK) da ON ds.DimArenaId = da.DimArenaId
INNER JOIN dbo.DimEvent (NOLOCK) de ON fi.DimEventId = de.DimEventId
INNER JOIN dbo.DimEventHeader (NOLOCK) deh ON de.DimEventHeaderId = deh.DimEventHeaderId
INNER JOIN dbo.DimSeasonHeader (NOLOCK) dsh ON deh.DimSeasonHeaderId = dsh.DimSeasonHeaderId
INNER JOIN dbo.DimSeat (NOLOCK) dst ON fi.DimSeatId = dst.DimSeatId

INNER JOIN dbo.DimPriceCode (NOLOCK) dpc_Manifest ON fi.ManifestDimPriceCodeId = dpc_Manifest.DimPriceCodeId
INNER JOIN dbo.DimClassTM (NOLOCK) dctm_Manifest ON fi.ManifestDimClassTMId = dctm_Manifest.DimClassTMId

LEFT OUTER JOIN dbo.DimPriceCode (NOLOCK) dpc_Posted ON fi.PostedDimPriceCodeId = dpc_Posted.DimPriceCodeId
LEFT OUTER JOIN dbo.DimClassTM (NOLOCK) dctm_Posted ON fi.PostedDimClassTMId = dctm_Posted.DimClassTMId

LEFT OUTER JOIN dbo.DimPriceCode (NOLOCK) dpc_Held ON fi.HeldDimPriceCodeId = dpc_Held.DimPriceCodeId
LEFT OUTER JOIN dbo.DimClassTM (NOLOCK) dctm_Held ON fi.HeldDimClassTMId = dctm_Held.DimClassTMId



LEFT OUTER JOIN dbo.FactTicketSales (NOLOCK) fts ON fi.FactTicketSalesId = fts.FactTicketSalesId

    LEFT OUTER JOIN dbo.DimPriceCode (NOLOCK) dpc ON fi.SoldDimPriceCodeId = dpc.DimPriceCodeId
    LEFT OUTER JOIN dbo.DimItem (NOLOCK) di ON fi.SoldDimItemId = di.DimItemId
    LEFT OUTER JOIN dbo.DimPlan (NOLOCK) dpl ON fi.SoldDimPlanId = dpl.DimPlanId 
    LEFT OUTER JOIN dbo.DimCustomer (NOLOCK) dc ON fi.SoldDimCustomerId = dc.DimCustomerId
    
    LEFT OUTER JOIN dbo.DimDate (NOLOCK) dd ON fi.SoldDimDateId = dd.DimDateId
    LEFT OUTER JOIN dbo.DimTime (NOLOCK) dt ON fi.SoldDimTimeId = dt.DimTimeId

	LEFT OUTER JOIN dbo.DimDate (NOLOCK) dd_resold ON fi.ResoldDimDateId = dd_resold.DimDateId
    LEFT OUTER JOIN dbo.DimTime (NOLOCK) dt_resold ON fi.ResoldDimTimeId = dt_resold.DimTimeId

    LEFT OUTER JOIN dbo.DimClassTM (NOLOCK) dctm ON fi.SoldDimClassTMId = dctm.DimClassTMId
    LEFT OUTER JOIN dbo.DimSalesCode (NOLOCK) dsc ON fi.SoldDimSalesCodeId = dsc.DimSalesCodeId
	LEFT OUTER JOIN dbo.DimPromo (NOLOCK) dpm ON fi.SoldDimPromoId = dpm.DimPromoID
    LEFT OUTER JOIN dbo.DimPlanType (NOLOCK) pt ON fts.DimPlanTypeId = pt.DimPlanTypeId
    LEFT OUTER JOIN dbo.DimTicketType (NOLOCK) tt ON fts.DimTicketTypeId = tt.DimTicketTypeId
    LEFT OUTER JOIN dbo.DimSeatType (NOLOCK) dstp ON fts.DimSeatTypeId = dstp.DimSeatTypeId
	LEFT OUTER JOIN dbo.DimTicketClass (NOLOCK) dtc ON fts.DimTicketClassId = dtc.DimTicketClassId
    
WHERE fi.DimSeasonId IN (76,78, 105,112)

)



GO
