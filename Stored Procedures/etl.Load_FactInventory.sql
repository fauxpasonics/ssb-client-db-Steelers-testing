SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Load_FactInventory]

AS
BEGIN

/*
------------------------------------------------- Load New Seat Inventory -------------------------------------------------
*/

	INSERT INTO dbo.FactInventory (
		ETL_CreatedDate, ETL_UpdatedDate, DimArenaId, DimSeasonId, DimEventId, DimSeatId
		, ManifestDimPriceCodeId, ManifestDimClassTMId, ManifestSeatValue, IsAvailable, IsSaleable, IsSold, IsHeld, IsComp, IsAttended --9
		, TotalRevenue, TicketRevenue, PcTicketValue, FullPrice, Discount, Surcharge, PurchasePrice, PcPrice, PcPrintedPrice, PcTicket, PcTax, PcLicenseFee, PcOther1, PcOther2, SeatBlockSize, EventDateTime --16
		, IsReserved
	)

	SELECT GETDATE() ETL_CreatedDate, GETDATE() ETL_UpdatedDate
	, ISNULL(de.DimArenaId, -1), ISNULL(de.DimSeasonId, -1), ISNULL(de.DimEventId, -1), ISNULL(dst.DimSeatId, -1)
	, ISNULL(dpc_st.DimPriceCodeId, -1) ManifestDimPriceCodeId
	, ISNULL(dctm.DimClassTMId, -1) ManifestDimClassTMId
	, ISNULL(dpc_st.Price, 0) ManifestSeatValue
	, CASE WHEN dctm.IsKill = 1 THEN 0 ELSE 1 end [IsAvailable]
	, CASE WHEN dctm.IsKill = 1 THEN 0 ELSE 1 end [IsSaleable]
	, 0 [IsSold], 0 [IsHeld], 0 [IsComp], 0 [IsAttended]
	, 0 [TotalRevenue], 0 [TicketRevenue], 0 [PcTicketValue], 0 [FullPrice], 0 [Discount], 0 [Surcharge], 0 [PurchasePrice]
	, 0 [PcPrice], 0 [PcPrintedPrice], 0 [PcTicket], 0 [PcTax], 0 [PcLicenseFee], 0 [PcOther1], 0 [PcOther2]
	, 0 [SeatBlockQty]
	, de.EventDateTime [EventDateTime]
	, 0 IsReserved
	
	--SELECT COUNT(*)
	FROM dbo.DimEvent de
	INNER JOIN dbo.DimSeat dst ON dst.ManifestId = de.ManifestId AND de.SourceSystem = dst.SourceSystem
	LEFT OUTER JOIN dbo.FactInventory fi ON fi.DimEventId = de.DimEventId AND fi.DimSeatId = dst.DimSeatId
	LEFT OUTER JOIN dbo.DimPriceCode dpc_st ON dpc_st.SSID_event_id = de.SSID_event_id AND dpc_st.SSID_price_code = dst.DefaultPriceCode
	LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ETL_SSID_class_id = dst.DefaultClass

	WHERE fi.FactInventoryId IS NULL
		AND de.IsClosed = 0
		AND de.IsInventoryEligible = 1 	
		AND ISNULL(dst.Config_IsFactInventoryEligible,1) <> 0
		AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
	ORDER BY
		de.DimEventId, dst.DimSeatId

	SELECT DISTINCT de.DimEventId 
	INTO #EventList
	FROM dbo.DimEvent de
	WHERE de.IsClosed = 0
	AND de.IsInventoryEligible = 1 	
	AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))


/*
------------------------------------------------- Avail Seats -------------------------------------------------
*/



	SELECT *
	INTO #stgAvailSeats

	FROM (
	
		--Single Game Postings
		SELECT de.DimEventId, dSeat.DimSeatId
		, ISNULL(dctm.DimClassTMId, -1) DimClassTMId, ISNULL(dpc.DimPriceCodeId, -1) DimPriceCodeId
		, ISNULL(avail.Price, 0) PostedSeatValue

		FROM ods.TM_AvailSeats avail
		INNER JOIN dbo.DimEvent de ON avail.event_id = de.SSID_event_id AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ETL_SSID_class_id = avail.class_id --AND dctm.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		LEFT OUTER JOIN dbo.DimPriceCode dpc ON avail.price_code = dpc.PriceCode AND avail.event_id = dpc.SSID_event_id AND dpc.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		INNER LOOP JOIN dbo.Lkp_SeatList sl ON sl.seat BETWEEN avail.seat_num AND (avail.seat_num + avail.num_seats - 1)
		INNER JOIN dbo.DimSeat dSeat ON
			avail.section_id = dSeat.ssid_section_id 
			AND avail.row_id = dSeat.ssid_row_id 
			AND sl.seat = dSeat.Seat
			AND dSeat.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		WHERE de.IsInventoryEligible = 1

		UNION

		--Plan Postings by Event
		SELECT de.DimEventId, dSeat.DimSeatId
		, ISNULL(dctm.DimClassTMId, -1) DimClassTMId, ISNULL(dpc.DimPriceCodeId, -1) DimPriceCodeId
		, ISNULL(dpc.Price, 0) PostedSeatValue

		FROM ods.TM_AvailSeats avail
		INNER JOIN (SELECT DISTINCT plan_event_id, event_id FROM ods.TM_EventsInPlan) eip ON avail.event_id = eip.plan_event_id
		INNER JOIN dbo.DimEvent de ON eip.event_id = de.SSID_event_id AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ETL_SSID_class_id = avail.class_id --AND dctm.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		LEFT OUTER JOIN dbo.DimPriceCode dpc ON avail.price_code = dpc.PriceCode AND avail.event_id = dpc.SSID_event_id AND dpc.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		INNER LOOP JOIN dbo.Lkp_SeatList sl ON sl.seat BETWEEN avail.seat_num AND (avail.seat_num + avail.num_seats - 1)
		INNER JOIN dbo.DimSeat dSeat ON 
			avail.section_id = dSeat.ssid_section_id 
			AND avail.row_id = dSeat.ssid_row_id 
			AND sl.seat = dSeat.Seat
			AND dSeat.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		WHERE de.IsInventoryEligible = 1

	) a

	CREATE NONCLUSTERED INDEX [IDX_BusinessKey] ON #StgAvailSeats (DimEventId, DimSeatId)

	UPDATE f
	SET f.ETL_UpdatedDate = getdate()
	, f.PostedDimPriceCodeId = null
	,f.PostedDimClassTMId = null
	,f.PostedSeatValue = NULL
	FROM dbo.FactInventory f
	LEFT OUTER JOIN #stgAvailSeats sas ON sas.DimEventId = f.DimEventId AND sas.DimSeatId = f.DimSeatId
	WHERE f.PostedDimPriceCodeId IS NOT NULL AND sas.DimSeatId IS null 
	AND f.DimEventId IN (SELECT DimEventId FROM #EventList)

	UPDATE f 
	SET f.ETL_UpdatedDate = getdate()
	, f.PostedDimPriceCodeId = sas.DimPriceCodeId
	, f.PostedDimClassTMId = sas.DimClassTMId
	, f.PostedSeatValue = sas.PostedSeatValue
	, f.IsAvailable = 1
	from #stgAvailSeats sas
	inner join dbo.FactInventory f on sas.DimEventId = f.DimEventId and sas.DimSeatId = f.DimSeatId
	WHERE (
	ISNULL(f.PostedDimPriceCodeId,-987) <> isnull(sas.DimPriceCodeId,-987) 
	OR ISNULL(f.PostedDimClassTMId,-987) <> isnull(sas.DimClassTMId,-987) 
	OR ISNULL(f.PostedSeatValue,-987) <> isnull(sas.PostedSeatValue,-987) 
	OR f.IsAvailable = 0
	)
	AND f.DimEventId IN (SELECT DimEventId FROM #EventList)

/*
------------------------------------------------- Held Seats -------------------------------------------------
*/

	SELECT DimEventId, DimSeatId, HeldDimPriceCodeId, HeldDimClassTMId, HeldSeatValue, IsReserved
	INTO #StgHeldSeats
	FROM (

		SELECT de.DimEventId, dSeat.DimSeatId, ISNULL(dpc.DimPriceCodeId, -1) HeldDimPriceCodeId, ISNULL(dctm.DimClassTMId, -1) HeldDimClassTMId, hs.block_purchase_price HeldSeatValue
		, CAST(CASE WHEN hs.reserved_ind = 'Y' THEN 1 ELSE 0 END AS bit) IsReserved
		from ods.TM_HeldSeats hs
		INNER JOIN dbo.DimEvent de on hs.event_id = de.SSID_event_id AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ETL_SSID_class_id = hs.class_id --AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		LEFT OUTER JOIN dbo.DimPriceCode dpc ON hs.price_code = dpc.PriceCode AND hs.event_id = dpc.SSID_event_id AND dpc.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		INNER LOOP JOIN dbo.Lkp_SeatList sl on sl.seat between hs.seat_num and (hs.seat_num + hs.num_seats - 1)
		INNER JOIN dbo.DimSeat dSeat on --ds.ManifestId = dSeat.ManifestId and 
			hs.section_id = dSeat.ssid_section_id 
			and hs.row_id = dSeat.ssid_row_id 
			and sl.seat = dSeat.Seat
			AND dSeat.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		where de.IsInventoryEligible = 1

			UNION

		SELECT de.DimEventId, dSeat.DimSeatId, ISNULL(dpc.DimPriceCodeId, -1) HeldDimPriceCodeId, ISNULL(dctm.DimClassTMId, -1) HeldDimClassTMId, hs.block_purchase_price HeldSeatValue
		, CAST(CASE WHEN hs.reserved_ind = 'Y' THEN 1 ELSE 0 END AS bit) IsReserved
		from ods.TM_HeldSeats hs
		INNER JOIN (SELECT DISTINCT plan_event_id, event_id FROM ods.TM_EventsInPlan) eip ON hs.event_id = eip.plan_event_id
		INNER JOIN dbo.DimEvent de on hs.event_id = de.SSID_event_id AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ETL_SSID_class_id = hs.class_id --AND dctm.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		LEFT OUTER JOIN dbo.DimPriceCode dpc ON hs.price_code = dpc.PriceCode AND hs.event_id = dpc.SSID_event_id AND dpc.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		INNER LOOP JOIN dbo.Lkp_SeatList sl on sl.seat between hs.seat_num and (hs.seat_num + hs.num_seats - 1)
		INNER JOIN dbo.DimSeat dSeat on --ds.ManifestId = dSeat.ManifestId and 
			hs.section_id = dSeat.ssid_section_id 
			and hs.row_id = dSeat.ssid_row_id 
			and sl.seat = dSeat.Seat
			AND dSeat.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
		where de.IsInventoryEligible = 1

	) a

	CREATE NONCLUSTERED INDEX [IDX_BusinessKey] ON #StgHeldSeats (DimEventId, DimSeatId)


	UPDATE f
	SET f.ETL_UpdatedDate = getdate()
	, f.IsHeld = 0
	, f.IsReserved = 0
	, f.HeldDimPriceCodeId = NULL
    , f.HeldDimClassTMId = NULL
    , f.HeldSeatValue = null
	FROM dbo.FactInventory f
	LEFT OUTER JOIN #StgHeldSeats shs ON shs.DimEventId = f.DimEventId AND shs.DimSeatId = f.DimSeatId
	WHERE f.IsHeld = 1 AND shs.DimSeatId IS null 
	AND f.DimEventId IN (SELECT DimEventId FROM #EventList)

	UPDATE f 
	SET f.ETL_UpdatedDate = getdate()
	, f.IsHeld = 1
	, f.IsReserved = shs.IsReserved
	, f.HeldDimPriceCodeId = shs.HeldDimPriceCodeId
    , f.HeldDimClassTMId = shs.HeldDimClassTMId
    , f.HeldSeatValue = shs.HeldSeatValue
	from #StgHeldSeats shs
	inner join dbo.FactInventory f on shs.DimEventId = f.DimEventId and shs.DimSeatId = f.DimSeatId
	WHERE (
	f.IsHeld = 0
	OR ISNULL(f.HeldDimPriceCodeId,-987) <> isnull(shs.HeldDimPriceCodeId,-987) 
	OR ISNULL(f.HeldDimClassTMId,-987) <> isnull(shs.HeldDimClassTMId,-987) 
	OR ISNULL(f.HeldSeatValue,-987) <> isnull(shs.HeldSeatValue,-987) 
	OR f.IsReserved <> shs.IsReserved
	)
	AND f.DimEventId IN (SELECT DimEventId FROM #EventList)

/*
------------------------------------------------- Sold Seats -------------------------------------------------
*/

SELECT 
	f.FactTicketSalesId
	, f.DimEventId
	, dst.DimSeatId
	, f.DimCustomerId SoldDimCustomerId
	, f.DimDateId SoldDimDateId
	, f.DimTimeId SoldDimTimeId
	, f.DimItemId SoldDimItemId
	, f.DimPlanId SoldDimPlanId
	, f.DimPriceCodeId SoldDimPriceCodeId
	, f.DimSalesCodeId SoldDimSalesCodeId
	, f.DimPromoId SoldDimPromoId
	, f.DimTicketClassId SoldDimTicketClassId
	, f.DimLedgerId SoldDimLedgerId

	, CAST(dd.CalDate AS DATETIME) + CAST(dt.Time24 AS DATETIME) SoldDateTime
	, f.DimClassTMId SoldDimClassTMId

	, 0 IsAvailable
	, 1 IsSold
	, 0 IsHeld
	, f.IsComp

	, f.PurchasePrice TotalRevenue
	, (f.TicketRevenue / CAST(f.QtySeat as decimal(18,6))) TicketRevenue 
	, (f.PcTicket / CAST(f.QtySeat as decimal(18,6))) PcTicketValue
	, f.FullPrice FullPrice
	, (f.Discount / CAST(f.QtySeat as decimal(18,6))) Discount
	, (f.Surcharge / CAST(f.QtySeat as decimal(18,6))) Surcharge
	, f.PurchasePrice PurchasePrice
	, (f.PcPrice / CAST(f.QtySeat as decimal(18,6))) PcPrice
	, (f.PcPrintedPrice / CAST(f.QtySeat as decimal(18,6))) PcPrintedPrice
	, (f.PcTicket / CAST(f.QtySeat as decimal(18,6))) PcTicket
	, (f.PcTax / CAST(f.QtySeat as decimal(18,6))) PcTax
	, (f.PcLicenseFee / CAST(f.QtySeat as decimal(18,6))) PcLicenseFee
	, (f.PcOther1 / CAST(f.QtySeat as decimal(18,6))) PcOther1
	, (f.PcOther2 / CAST(f.QtySeat as decimal(18,6))) PcOther2
	, f.QtySeat SeatBlockSize
	, f.OrderNum SoldOrderNum
	, f.OrderLineItem SoldOrderLineItem
	, f.IsHost

	INTO #StgSeatSales	

	FROM dbo.FactTicketSales (NOLOCK) f
	INNER JOIN dbo.DimEvent de on f.DimEventId = de.DimEventId
	INNER JOIN dbo.DimDate dd ON dd.DimDateId = f.DimDateId
	INNER JOIN dbo.DimTime dt ON dt.DimTimeId = f.DimTimeId
	INNER JOIN dbo.DimPriceCode dpc on f.DimPriceCodeId = dpc.DimPriceCodeId
	INNER JOIN dbo.DimSeat (NOLOCK) dst 
		ON f.SSID_section_id = dst.SSID_section_id 
		AND f.SSID_row_id = dst.SSID_row_id 
		AND dst.Seat between f.SSID_seat_num and (f.SSID_seat_num + f.QtySeat - 1)
		AND f.SourceSystem = dst.SourceSystem

	WHERE de.IsInventoryEligible = 1

	
	CREATE NONCLUSTERED INDEX [IDX_BusinessKey] ON #StgSeatSales (DimEventId, DimSeatId)


/*
------------------------------------------------- Returned Seats -------------------------------------------------
*/


	UPDATE f SET
	f.ETL_UpdatedDate = getdate()
	, f.FactTicketSalesId = null
	, f.SoldDimCustomerId = null
	, f.SoldDimDateId = null
	, f.SoldDimTimeId = null
	, f.SoldDimItemId = null
	, f.SoldDimPlanId = null
	, f.SoldDimPriceCodeId = null 
	, f.SoldDimSalesCodeId = null
	, f.SoldDimPromoId = null
	, f.SoldDimTicketClassId = NULL
    , f.SoldDimLedgerId = null

	, f.SoldDateTime = null
	, f.SoldDimClassTMId = null

	, f.IsAvailable = 1
	, f.IsSold = 0
	, f.IsHeld = 0
	, f.IsComp = 0

	, f.TotalRevenue = 0
	, f.TicketRevenue = 0
	, f.PcTicketValue = 0
	, f.FullPrice = 0
	, f.Discount = 0
	, f.Surcharge = 0
	, f.PurchasePrice = 0
	, f.PcPrice = 0
	, f.PcPrintedPrice = 0
	, f.PcTicket = 0
	, f.PcTax = 0
	, f.PcLicenseFee = 0
	, f.PcOther1 = 0
	, f.PcOther2 = 0
	, f.SeatBlockSize = 0
	, f.SoldOrderNum = 0
	, f.SoldOrderLineItem = 0

	, f.IsHost = null

	FROM dbo.FactInventory (NOLOCK) f
	LEFT outer JOIN #StgSeatSales sales ON sales.DimEventId = f.DimEventId AND sales.DimSeatId = f.DimSeatId
	WHERE f.IsSold = 1 and sales.DimEventId IS null
	AND f.DimEventId IN (SELECT DimEventId FROM #EventList)


	UPDATE f SET
	f.ETL_UpdatedDate = getdate()
	, f.FactTicketSalesId = sales.FactTicketSalesId
	, f.SoldDimCustomerId = sales.SoldDimCustomerId
	, f.SoldDimDateId = sales.SoldDimDateId
	, f.SoldDimTimeId = sales.SoldDimTimeId
	, f.SoldDimItemId = sales.SoldDimItemId
	, f.SoldDimPlanId = sales.SoldDimPlanId
	, f.SoldDimPriceCodeId = sales.SoldDimPriceCodeId
	, f.SoldDimSalesCodeId = sales.SoldDimSalesCodeId
	, f.SoldDimPromoId = sales.SoldDimPromoId
	, f.SoldDimTicketClassId = sales.SoldDimTicketClassId
	, f.SoldDimLedgerId = sales.SoldDimLedgerId

	, f.SoldDateTime = sales.SoldDateTime
	, f.SoldDimClassTMId = sales.SoldDimClassTMId

	, f.IsAvailable = sales.IsAvailable
	, f.IsSold = sales.IsSold
	, f.IsHeld = sales.IsAvailable
	, f.IsComp = sales.IsComp

	, f.TotalRevenue = sales.TotalRevenue
	, f.TicketRevenue = sales.TicketRevenue
	, f.PcTicketValue = sales.PcTicketValue
	, f.FullPrice = sales.FullPrice
	, f.Discount = sales.Discount
	, f.Surcharge = sales.Surcharge
	, f.PurchasePrice = sales.PurchasePrice
	, f.PcPrice = sales.PcPrice
	, f.PcPrintedPrice = sales.PcPrintedPrice
	, f.PcTicket = sales.PcTicket
	, f.PcTax = sales.PcTax
	, f.PcLicenseFee = sales.PcLicenseFee
	, f.PcOther1 = sales.PcOther1
	, f.PcOther2 = sales.PcOther2
	, f.SeatBlockSize = sales.SeatBlockSize
	, f.SoldOrderNum = sales.SoldOrderNum
	, f.SoldOrderLineItem = sales.SoldOrderLineItem

	, f.IsHost = sales.IsHost

	FROM dbo.FactInventory f
	INNER JOIN #StgSeatSales sales ON sales.DimEventId = f.DimEventId AND sales.DimSeatId = f.DimSeatId
	AND f.DimEventId IN (SELECT DimEventId FROM #EventList)


	update dbo.FactInventory
	SET IsAvailable = 0 
	WHERE IsAvailable = 1 AND IsSaleable = 0
	AND DimEventId IN (SELECT DimEventId FROM #EventList)



END


GO
