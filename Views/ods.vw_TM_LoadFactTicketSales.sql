SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- View

CREATE VIEW [ods].[vw_TM_LoadFactTicketSales] AS (

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'dbo.FactTicketSales', 'FactTicketSalesId, ETL_SourceSystem, ETL_DeltaHashKey, ETL_CreatedBy, ETL_UpdatedBy, ETL_CreatedDate, ETL_UpdatedDate, ETL_IsDeleted, ETL_DeleteDate', ''
*/

SELECT *
, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),BlockFullPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),BlockPurchasePrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),CompCode)),'DBNULL_INT') + ISNULL(RTRIM(CompName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),DimArenaId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimClassTMId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimCustomerId)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),DimCustomerIdSalesRep)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),DimDateId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimEventId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimItemId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimLedgerId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimPlanId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimPriceCodeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimPriceCodeMasterId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimPromoId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimSalesCodeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimSeasonId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimSeatIdStart)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimTicketClassId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimTimeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),Discount)),'DBNULL_NUMBER') + ISNULL(RTRIM(DiscountCode),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),DiscountTotal)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),FullPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(GroupFlag),'DBNULL_TEXT') + ISNULL(RTRIM(GroupSalesName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),IsAutoRenewalNextSeason)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsComp)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsExpanded)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsHost)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsRenewal)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),OrderLineItem)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),OrderLineItemSeq)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),OrderNum)),'DBNULL_BIGINT') + ISNULL(RTRIM(OtherInfo1),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo10),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo2),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo3),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo4),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo5),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo6),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo7),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo8),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo9),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),PcLicenseFee)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcOther1)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcOther2)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcPrintedPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcTicket)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcTicketValue)),'DBNULL_NUMBER') + ISNULL(RTRIM(PricingMethod),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),PurchasePrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),QtySeat)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),QtySeatFSE)),'DBNULL_NUMBER') + ISNULL(RTRIM(RetailQualifiers),'DBNULL_TEXT') + ISNULL(RTRIM(RetailTicketType),'DBNULL_TEXT') + ISNULL(RTRIM(SalesSource),'DBNULL_TEXT') + ISNULL(RTRIM(SSCreatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SSCreatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(SSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_acct_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_event_id)),'DBNULL_INT') + ISNULL(RTRIM(SSID_price_code),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_row_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_seat_num)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_section_id)),'DBNULL_INT') + ISNULL(RTRIM(SSUpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SSUpdatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),Surcharge)),'DBNULL_NUMBER') + ISNULL(RTRIM(SurchargeCode),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SurchargeTotal)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),TicketRevenue)),'DBNULL_NUMBER') + ISNULL(RTRIM(TicketType),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),TotalRevenue)),'DBNULL_NUMBER') + ISNULL(RTRIM(TranType),'DBNULL_TEXT')) ETL_DeltaHashKey
FROM (

	SELECT
	CAST(tkt.event_id AS nvarchar(25)) + ':' + CAST(tkt.section_id AS NVARCHAR(25)) + ':' + CAST(tkt.row_id AS NVARCHAR(25)) + ':' + CAST(tkt.seat_num AS NVARCHAR(25)) AS SSID
	, tkt.event_id AS SSID_event_id
	, CAST(tkt.section_id AS INT) AS SSID_section_id
	, CAST(tkt.row_id AS INT) AS SSID_row_id
	, tkt.seat_num AS SSID_seat_num
	, tkt.acct_id AS SSID_acct_id
	, tkt.price_code AS SSID_price_code

	, CONVERT(VARCHAR, tkt.add_datetime, 112) DimDateId
	, datediff(second, cast(tkt.add_datetime as date), tkt.add_datetime) DimTimeId
	, isnull(dCustomer.DimCustomerId, -1) DimCustomerId
	, isnull(dSeason.DimArenaId, -1) DimArenaId
	, isnull(dSeason.DimSeasonId, -1) DimSeasonId
	, isnull(dItem.DimItemId, -1) DimItemId
	, case when tkt.plan_event_id = tkt.event_id then 0 else isnull(dEvent.DimEventId, -1) end DimEventId
	, case when tkt.plan_event_id = 0 then 0 else isnull(dPlan.DimPlanId, -1) end	DimPlanId
	, isnull(dpcm.DimPriceCodeMasterId, -1) DimPriceCodeMasterId
	, isnull(isnull(dPriceCode.DimPriceCodeId, dPriceCodePlan.DimPriceCodeId), -1) DimPriceCodeId
	, isnull(dSeat.DimSeatId, -1) DimSeatIdStart
	, case when isnull(tkt.sell_location,'') = '' then 0 else isnull(dSalesCode.DimSalesCodeId, -1) end DimSalesCodeId
	, case when isnull(tkt.promo_code,'') = '' then 0 else isnull(dPromo.DimPromoId, -1) end DimPromoId		
	, ISNULL(dctm.DimClassTMId, -1) DimClassTMId
	, CASE WHEN tkt.ledger_id = 0 THEN 1 else ISNULL(dLedger.DimLedgerId, -1) end DimLedgerId
	, -1 DimTicketClassId
	, case when isnull(tkt.acct_Rep_id,'') = '' then 0 else isnull(dCustomerSalesRep.DimCustomerId, 0) end DimCustomerIdSalesRep

	, tkt.order_num as OrderNum
	, tkt.order_line_item as OrderLineItem
	, tkt.order_line_item_seq as OrderLineItemSeq
	, tkt.num_seats as QtySeat
	, CASE WHEN dPlan.DimPlanId > 0 THEN (SELECT * FROM master.dbo.GetQtyFSE(dEvent.DimEventId, dPlan.PlanEventCnt, dSeason.Config_SeasonEventCntFSE, tkt.num_seats)) ELSE 0 END as QtySeatFSE
	, tkt.block_purchase_price as TotalRevenue

	, case 
		when isnull(tkt.block_purchase_price, 0) <= 0 or isnull(dPriceCode.DimPriceCodeId, 0) <= 0 then 0
		when isnull(dPriceCode.TotalEvents, 0) > 0 and tkt.SourceTable = 'tkt' then (tkt.block_purchase_price - ((dPriceCode.PcOther1 + dPriceCode.PcOther2 + dPriceCode.PcTax + dPriceCode.PcLicenseFee) / dPriceCode.TotalEvents))
		else isnull(tkt.block_purchase_price - (dPriceCode.PcOther1 + dPriceCode.PcOther2 + dPriceCode.PcTax + dPriceCode.PcLicenseFee), 0)
	end TicketRevenue

	, case 
		when isnull(dPriceCode.TotalEvents, 0) > 0 and tkt.SourceTable = 'tkt' then ((isnull(dPriceCode.PcTicket,0) * tkt.num_seats) / dPriceCode.TotalEvents)
		else (isnull(dPriceCode.PcTicket,0) * tkt.num_seats)
	end PcTicketValue

	, tkt.full_price as FullPrice
	, tkt.disc_amount as Discount
	, (tkt.disc_amount * tkt.num_seats) as DiscountTotal
	, tkt.surchg_amount as Surcharge
	, (tkt.surchg_amount * tkt.num_seats) as SurchargeTotal
	, tkt.purchase_price as PurchasePrice
	, (tkt.full_price * num_seats) as BlockFullPrice
	, tkt.block_purchase_price as BlockPurchasePrice

	, CASE 
		WHEN ISNULL(dPriceCode.TotalEvents, 0) > 0 AND tkt.SourceTable = 'tkt' THEN ((dPriceCode.Price * tkt.num_seats) / dPriceCode.TotalEvents)
		ELSE (ISNULL(dPriceCode.Price, 0) * tkt.num_seats)
	END PcPrice
	, CASE 
		WHEN ISNULL(dPriceCode.TotalEvents, 0) > 0 AND tkt.SourceTable = 'tkt' THEN ((dPriceCode.PrintedPrice * tkt.num_seats) / dPriceCode.TotalEvents)
		ELSE (ISNULL(dPriceCode.PrintedPrice, 0) * tkt.num_seats)
	END PcPrintedPrice
	, CASE 
		WHEN ISNULL(dPriceCode.TotalEvents, 0) > 0 AND tkt.SourceTable = 'tkt' THEN ((dPriceCode.PcTicket * tkt.num_seats) / dPriceCode.TotalEvents)
		ELSE (ISNULL(dPriceCode.PcTicket, 0) * tkt.num_seats)
	END PcTicket
	, CASE 
		WHEN ISNULL(dPriceCode.TotalEvents, 0) > 0 AND tkt.SourceTable = 'tkt' THEN ((dPriceCode.PcTax * tkt.num_seats) / dPriceCode.TotalEvents)
		ELSE (ISNULL(dPriceCode.PcTax, 0) * tkt.num_seats)
	END PcTax
	, CASE 
		WHEN ISNULL(dPriceCode.TotalEvents, 0) > 0 AND tkt.SourceTable = 'tkt' THEN ((dPriceCode.PcLicenseFee * tkt.num_seats) / dPriceCode.TotalEvents)
		ELSE (ISNULL(dPriceCode.PcLicenseFee, 0) * tkt.num_seats)
	END PcLicenseFee	
	, CASE 
		WHEN ISNULL(dPriceCode.TotalEvents, 0) > 0 AND tkt.SourceTable = 'tkt' THEN ((dPriceCode.PcOther1 * tkt.num_seats) / dPriceCode.TotalEvents)
		ELSE (ISNULL(dPriceCode.PcOther1, 0) * tkt.num_seats)
	END PcOther1
	, CASE 
		WHEN ISNULL(dPriceCode.TotalEvents, 0) > 0 AND tkt.SourceTable = 'tkt' THEN ((dPriceCode.PcOther2 * tkt.num_seats) / dPriceCode.TotalEvents)
		ELSE (ISNULL(dPriceCode.PcOther2, 0) * tkt.num_seats)
	END PcOther2

	, CAST(CASE WHEN tkt.expanded = 'Y' THEN 1 ELSE 0 END AS bit) AS IsExpanded
	, CAST(CASE WHEN ISNULL(order_num,0) = 0 THEN 1 ELSE 0 END AS bit) AS IsHost
	, 0 AS IsRenewal
	, CAST(CASE WHEN tkt.renewal_ind = 'Y' THEN 1 ELSE 0 END AS bit) AS IsAutoRenewalNextSeason
	, tkt.disc_code AS DiscountCode
	, tkt.surchg_code AS SurchargeCode
	, tkt.pricing_method AS PricingMethod
	, CAST(CASE WHEN tkt.comp_code > 0 THEN 1 ELSE 0 END AS bit) AS isComp
	, tkt.comp_code AS CompCode
	, tkt.comp_name AS CompName
	, tkt.group_flag AS GroupFlag
	, tkt.group_sales_name GroupSalesName 
	, tkt.ticket_type AS TicketType
	, tkt.tran_type AS TranType
	, tkt.sales_source_name AS SalesSource
	, tkt.retail_ticket_type AS RetailTicketType
	, tkt.retail_qualifiers AS RetailQualifiers
	, tkt.other_info_1 AS OtherInfo1
	, tkt.other_info_2 AS OtherInfo2
	, tkt.other_info_3 AS OtherInfo3
	, tkt.other_info_4 AS OtherInfo4
	, tkt.other_info_5 AS OtherInfo5
	, tkt.other_info_6 AS OtherInfo6
	, tkt.other_info_7 AS OtherInfo7
	, tkt.other_info_8 AS OtherInfo8
	, tkt.other_info_9 AS OtherInfo9
	, tkt.other_info_10 AS OtherInfo10
	, tkt.add_user AS SSCreatedBy
	, tkt.upd_user AS SSUpdatedBy
	, tkt.add_datetime AS SSCreatedDate
	, tkt.upd_datetime AS SSUpdatedDate


	FROM ods.TM_vw_Ticket tkt		
	LEFT OUTER JOIN dbo.DimItem dItem ON CASE WHEN tkt.plan_event_id = 0 THEN tkt.event_id ELSE tkt.plan_event_id END = dItem.SSID_event_id AND dItem.SourceSystem = 'TM'
	LEFT OUTER JOIN dbo.DimSeason dSeason ON dItem.DimSeasonId = dSeason.DimSeasonId AND dSeason.SourceSystem = 'TM'
	LEFT OUTER JOIN dbo.DimEvent dEvent ON tkt.event_id = dEvent.SSID_event_id AND dEvent.SourceSystem = 'TM'
	LEFT OUTER JOIN dbo.DimCustomer dCustomer ON tkt.acct_id = dCustomer.AccountId AND dCustomer.SourceSystem = 'TM' AND dCustomer.CustomerType = 'Primary'
	LEFT OUTER JOIN dbo.DimCustomer dCustomerSalesRep ON tkt.acct_Rep_id = dCustomerSalesRep.AccountId AND dCustomerSalesRep.SourceSystem = 'TM' AND dCustomerSalesRep.CustomerType = 'Primary'
	LEFT OUTER JOIN dbo.DimPlan dPlan ON tkt.plan_event_id = dPlan.SSID_event_id AND dPlan.SourceSystem = 'TM'
	--LEFT OUTER JOIN dbo.DimSalesCode dSalesCode ON tkt.ssbIsHost = dSalesCode.IsHost AND tkt.sell_location = dSalesCode.SalesCodeName AND dSalesCode.SourceSystem = 'TM'
	LEFT OUTER JOIN dbo.DimSalesCode dSalesCode ON tkt.sell_location = dSalesCode.SSID_sell_location_id AND dSalesCode.SourceSystem = 'TM'
	LEFT OUTER JOIN dbo.DimPromo dPromo ON tkt.promo_code = dPromo.ETL_SSID_promo_code
	LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ClassName = tkt.class_name AND dctm.ETL_SourceSystem = 'TM'
	LEFT OUTER JOIN dbo.DimLedger dLedger ON tkt.ledger_id = dLedger.ETL_SSID_ledger_id
	LEFT OUTER JOIN dbo.DimPriceCodeMaster dpcm ON tkt.ssbPriceCode = dpcm.PriceCode
	LEFT OUTER JOIN dbo.DimPriceCode dPriceCode ON tkt.event_id = dPriceCode.SSID_event_id AND tkt.ssbPriceCode = dPriceCode.SSID_price_code AND dPriceCode.SourceSystem = 'TM'
	LEFT OUTER JOIN dbo.DimPriceCode dPriceCodePlan ON tkt.plan_event_id = dPriceCodePlan.SSID_event_id AND tkt.ssbPriceCode = dPriceCodePlan.SSID_price_code AND dPriceCodePlan.SourceSystem = 'TM'	
	LEFT OUTER JOIN dbo.DimSeat dSeat ON dSeason.ManifestId = dSeat.SSID_manifest_id AND tkt.section_id = dSeat.SSID_section_id AND tkt.row_id = dSeat.SSID_row_id AND tkt.seat_num = dSeat.SSID_seat AND dSeat.SourceSystem = 'TM'


) a

)















GO
