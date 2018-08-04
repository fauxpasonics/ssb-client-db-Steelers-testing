SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[FactInventory_UpdateResoldSeats]

AS
BEGIN
-- bmackley -- 11/7/2014 - Proc erroring on te_purchase_price and te_buyer_fees_hidden on conversion to int from nvarchar. Casted them as money and processed worked.
-- Drop Table #Tex_Seats
SELECT * INTO #Tex_Seats
FROM (
	SELECT tex.event_id, tex.section_id, tex.row_id, sl.Seat, tex.assoc_acct_id, tex.add_datetime
	, (CAST(tex.te_purchase_price as MONEY) / tex.num_seats) ResoldPurchasePrice
	, (CAST(tex.te_buyer_fees_hidden AS MONEY) / tex.num_seats) ResoldFees
	, ROW_NUMBER() OVER(PARTITION BY tex.event_id, tex.section_id, tex.row_id, sl.Seat ORDER BY tex.add_datetime desc) AS RowRank	
	FROM ods.TM_Tex tex
	INNER LOOP JOIN dbo.Lkp_SeatList sl ON sl.Seat >= tex.seat_num  AND sl.Seat < (tex.seat_num + tex.num_seats)
	WHERE activity = 'ES' AND tex.add_datetime > (GETDATE() - 3)
) a
WHERE RowRank = 1


CREATE NONCLUSTERED INDEX [IDX_01] ON #Tex_Seats
(
	[event_id] ASC
)	

CREATE NONCLUSTERED INDEX [IDX_02] ON #Tex_Seats
(
	[assoc_acct_id] ASC
)	

CREATE NONCLUSTERED INDEX [IDX_03] ON #Tex_Seats
(
	[section_id] ASC,
	[row_id] ASC,
	[seat] ASC
)	


SELECT de.DimEventId, dst.DimSeatId, dc.DimCustomerId ResoldDimCustomerId
, CONVERT(VARCHAR(25), tex.add_datetime, 112) ResoldDimDateId
, datediff(second, cast(tex.add_datetime as date), tex.add_datetime) ResoldDimTimeId
, tex.add_datetime ResoldDateTime
, tex.ResoldPurchasePrice
, tex.ResoldFees
, (tex.ResoldPurchasePrice + tex.ResoldFees) ResoldTotalAmount
	INTO #Tex_Update
FROM #Tex_Seats tex
INNER JOIN dbo.DimEvent de ON de.SSID_event_id = tex.event_id AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
INNER JOIN dbo.DimSeat dst 
ON	dst.ManifestId = de.ManifestId
	AND dst.SSID_section_id = tex.section_id
	AND dst.SSID_row_id = tex.row_id
	AND dst.Seat = tex.Seat
	AND dst.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
LEFT OUTER JOIN dbo.DimCustomer (NOLOCK) dc ON dc.AccountId = tex.assoc_acct_id AND dc.CustomerType = 'Primary' AND dc.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))


CREATE NONCLUSTERED INDEX [IDX_01] ON #Tex_Update
(
	[DimEventId] ASC,
	[DimSeatId] ASC
)


UPDATE fi
SET
	fi.IsResold = 1
	, fi.ResoldDimCustomerId = tex.ResoldDimCustomerId
	, fi.ResoldDimDateId = tex.ResoldDimDateId
	, fi.ResoldDimTimeId = tex.ResoldDimTimeId
	, fi.ResoldDateTime = tex.ResoldDateTime
	, fi.ResoldPurchasePrice = tex.ResoldPurchasePrice
	, fi.ResoldFees = tex.ResoldFees
	, fi.ResoldTotalAmount = tex.ResoldTotalAmount
	, fi.ETL_UpdatedDate = GETDATE()
FROM dbo.FactInventory fi
INNER JOIN #Tex_Update tex ON tex.DimEventId = fi.DimEventId AND tex.DimSeatId = fi.DimSeatId


END
GO
