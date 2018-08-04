SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_LoadFactTicketSales]
(
	@BatchId INT = 0,
	@LoadDate DATETIME = NULL,
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN


DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @LogEventDefault NVARCHAR(255) = 'Processing Status'

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

BEGIN TRY

IF (@LoadDate IS NULL)
BEGIN
	SET @LoadDate = GETDATE() - 1
END

DECLARE @SourceSystem NVARCHAR(255) = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Start', @ExecutionId


SELECT tkt.*
, CAST(CASE WHEN tkt.order_num IS NULL THEN 1 ELSE 0 END AS BIT) ssbIsHost
, REPLACE(tkt.price_code, '*','') ssbPriceCode
INTO #WorkingSet
FROM ods.TM_vw_Ticket tkt
LEFT OUTER JOIN dbo.DimItem dItem ON CASE WHEN tkt.plan_event_id = 0 THEN tkt.event_id ELSE tkt.plan_event_id END = dItem.SSID_event_id AND dItem.SourceSystem = @SourceSystem AND dItem.DimItemId > 0
WHERE ISNULL(dItem.Config_IsFactSalesEligible,1) = 1 AND ISNULL(dItem.Config_IsClosed,0) = 0
and tkt.UpdateDate >= @LoadDate


EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Working Set Temp Table Loaded', @ExecutionId

DECLARE @WorkingSetCountLogMessage NVARCHAR(2000) = 'Working Set Temp Table Record Count: ' + CONVERT(NVARCHAR(25), (SELECT COUNT(*) FROM #WorkingSet))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, @WorkingSetCountLogMessage, @ExecutionId


CREATE NONCLUSTERED INDEX IDX_event_id ON #WorkingSet (event_id)
CREATE NONCLUSTERED INDEX IDX_plan_event_id ON #WorkingSet (plan_event_id)
CREATE NONCLUSTERED INDEX IDX_acct_id ON #WorkingSet (acct_id)
CREATE NONCLUSTERED INDEX IDX_acct_Rep_id ON #WorkingSet (acct_Rep_id, orig_acct_rep_id)
CREATE NONCLUSTERED INDEX IDX_sell_location ON #WorkingSet (sell_location)
CREATE NONCLUSTERED INDEX IDX_ssbIsHost ON #WorkingSet (ssbIsHost)
CREATE NONCLUSTERED INDEX IDX_ssbPriceCode ON #WorkingSet (ssbPriceCode)
CREATE NONCLUSTERED INDEX IDX_promo_code ON #WorkingSet (promo_code)
CREATE NONCLUSTERED INDEX IDX_price_code ON #WorkingSet (price_code)
CREATE NONCLUSTERED INDEX IDX_ledger_id ON #WorkingSet (ledger_id)
CREATE NONCLUSTERED INDEX IDX_srs ON #WorkingSet (section_id, row_id, seat_num)


EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Working Set Temp Table Indexes Built', @ExecutionId



SELECT a.DimClassTMId, a.ClassName
INTO #DimClassTM_Lookup
FROM (
	SELECT DimClassTMId, ETL_SourceSystem, ETL_SSID_class_id, ClassName
	, ROW_NUMBER() OVER(PARTITION BY ClassName ORDER BY ETL_UpdatedDate) RowRank
	FROM dbo.DimClassTM (NOLOCK)
	WHERE ETL_SourceSystem = @SourceSystem AND DimClassTMId > 0
) a 
WHERE a.RowRank = 1

CREATE NONCLUSTERED INDEX IDX_Key ON #DimClassTM_Lookup (ClassName)


SELECT a.DimSalesCodeId, a.SalesCodeName
INTO #DimSalesCode_Lookup
FROM (
	SELECT DimSalesCodeId, SourceSystem, SSID_sell_location_id, SalesCodeName
	, ROW_NUMBER() OVER (PARTITION BY SalesCodeName ORDER BY UpdatedDate DESC) RowRank
	FROM dbo.DimSalesCode (nolock)
	WHERE SourceSystem = @SourceSystem AND DimSalesCodeId > 0
) a 
WHERE RowRank = 1	

CREATE NONCLUSTERED INDEX IDX_Key ON #DimSalesCode_Lookup (SalesCodeName)


CREATE TABLE #stgFactTicketSales
(
	[DimDateId] [int] NOT NULL,
	[DimDateId_OrigSale] [int] NOT NULL,
	[DimTimeId] [int] NOT NULL,
	[DimCustomerId] [bigint] NOT NULL,
	[DimArenaId] [int] NOT NULL,
	[DimSeasonId] [int] NOT NULL,
	[DimItemId] [int] NOT NULL,
	[DimEventId] [int] NOT NULL,
	[DimPlanId] [int] NOT NULL,
	[DimPriceCodeMasterId] [int] NOT NULL,
	[DimPriceCodeId] [int] NOT NULL,
	[DimSeatIdStart] [int] NOT NULL,
	[DimLedgerId] [int] NOT NULL,
	[DimClassTMId] [int] NOT NULL,
	[DimSalesCodeId] [int] NOT NULL,
	[DimPromoId] [int] NOT NULL,
	DimTicketTypeId [int] NOT NULL, 
	DimPlanTypeId [int] NOT NULL,
	DimSeatTypeId [int] NOT NULL,
	[DimTicketClassId] [int] NOT NULL,
	[DimTicketClassId2] [int] NOT NULL,
	[DimTicketClassId3] [int] NOT NULL,
	[DimTicketClassId4] [int] NOT NULL,
	[DimTicketClassId5] [int] NOT NULL,
	[DimCustomerIdSalesRep] [bigint] NOT NULL,
	[DimCustomerId_TransSalesRep] [bigint] NOT NULL,
	[OrderNum] [bigint] NULL,
	[OrderLineItem] [int] NULL,
	[OrderLineItemSeq] [int] NULL,
	[QtySeat] [int] NOT NULL,
	[QtySeatFSE] [decimal](18, 6) NULL,
	[TotalRevenue] [decimal](18, 6) NOT NULL,
	[TicketRevenue] [decimal](18, 6) NOT NULL,
	[PcTicketValue] [decimal](18, 6) NOT NULL,
	[FullPrice] [decimal](18, 6) NOT NULL,
	[BlockDiscountCalc] [decimal](18, 6) NOT NULL,
	[BlockDiscountArchtics] [decimal](18, 6) NOT NULL,
	[Discount] [decimal](18, 6) NOT NULL,
	[BlockSurcharge] [decimal](18, 6) NOT NULL,
	[Surcharge] [decimal](18, 6) NOT NULL,
	[PurchasePrice] [decimal](18, 6) NOT NULL,
	[BlockFullPrice] [decimal](18, 6) NOT NULL,
	[BlockPurchasePrice] [decimal](18, 6) NOT NULL,
	[PcPrice] [decimal](18, 6) NOT NULL,
	[PcPrintedPrice] [decimal](18, 6) NOT NULL,
	[PcTicket] [decimal](18, 6) NOT NULL,
	[PcTax] [decimal](18, 6) NOT NULL,
	[PcLicenseFee] [decimal](18, 6) NOT NULL,
	[PcOther1] [decimal](18, 6) NOT NULL,
	[PcOther2] [decimal](18, 6) NOT NULL,
	[PaidAmount] [decimal](18, 6) NOT NULL,
	[OwedAmount] [decimal](18, 6) NOT NULL,
	[PaidStatus] [nvarchar](1) NOT NULL,
	[IsPremium] [bit] NULL,
	[IsDiscount] [bit] NOT NULL,
	[IsComp] [int] NOT NULL,
	[IsHost] [bit] NOT NULL,
	[IsPlan] [bit] NULL,
	[IsPartial] [bit] NULL,
	[IsSingleEvent] [bit] NULL,
	[IsGroup] [bit] NOT NULL,
	[IsBroker] [bit] NULL,
	[IsRenewal] [bit] NOT NULL,
	[IsExpanded] [bit] NOT NULL,
	[IsAutoRenewalNextSeason] [bit] NOT NULL,
	[DiscountCode] [nvarchar](255) NULL,
	[SurchargeCode] [nvarchar](255) NULL,
	[PricingMethod] [nvarchar](255) NULL,
	[CompCode] [int] NULL,
	[CompName] [nvarchar](255) NULL,
	[GroupSalesName] [nvarchar](255) NULL,
	[GroupFlag] [nvarchar](255) NULL,
	[ClassName] [nvarchar](255) NULL,
	[TicketType] [nvarchar](255) NULL,
	[TranType] [nvarchar](255) NULL,
	[SalesSource] [nvarchar](255) NULL,
	[RetailTicketType] [nvarchar](255) NULL,
	[RetailQualifiers] [nvarchar](255) NULL,
	[OtherInfo1] [nvarchar](255) NULL,
	[OtherInfo2] [nvarchar](255) NULL,
	[OtherInfo3] [nvarchar](255) NULL,
	[OtherInfo4] [nvarchar](255) NULL,
	[OtherInfo5] [nvarchar](255) NULL,
	[OtherInfo6] [nvarchar](255) NULL,
	[OtherInfo7] [nvarchar](255) NULL,
	[OtherInfo8] [nvarchar](255) NULL,
	[OtherInfo9] [nvarchar](255) NULL,
	[OtherInfo10] [nvarchar](255) NULL,
	[TicketSeqId] [bigint] NULL,
	[SSCreatedBy] [nvarchar](255) NULL,
	[SSUpdatedBy] [nvarchar](255) NULL,
	[SSCreatedDate] [datetime] NULL,
	[SSUpdatedDate] [datetime] NULL,
	[SSID] [nvarchar](255) NULL,
	[SSID_event_id] [int] NULL,
	[SSID_section_id] [int] NULL,
	[SSID_row_id] [int] NULL,
	[SSID_seat_num] [int] NULL,
	[SSID_acct_id] [int] NULL,
	[SSID_price_code] [nvarchar](4) NULL,
	[DeltaHashKey] [binary](32) NULL
)



INSERT INTO #stgFactTicketSales (
	DimDateId, DimDateId_OrigSale, DimTimeId, DimCustomerId, DimArenaId, DimSeasonId, DimItemId, DimEventId, DimPlanId, DimPriceCodeMasterId, DimPriceCodeId, DimSeatIdStart
	, DimLedgerId, DimClassTMId, DimSalesCodeId, DimPromoId, DimTicketTypeId, DimPlanTypeId, DimSeatTypeId, DimTicketClassId, DimTicketClassId2, DimTicketClassId3, DimTicketClassId4, DimTicketClassId5, DimCustomerIdSalesRep, DimCustomerId_TransSalesRep
	, OrderNum, OrderLineItem, OrderLineItemSeq, QtySeat, QtySeatFSE, TotalRevenue, TicketRevenue, PcTicketValue, FullPrice, BlockDiscountCalc, BlockDiscountArchtics, Discount, BlockSurcharge, Surcharge
	, PurchasePrice, BlockFullPrice, BlockPurchasePrice, PcPrice, PcPrintedPrice, PcTicket, PcTax, PcLicenseFee, PcOther1, PcOther2, PaidAmount, OwedAmount, PaidStatus
	, IsPremium, IsDiscount, IsComp, IsHost, IsPlan, IsPartial, IsSingleEvent, IsGroup, IsBroker, IsRenewal, IsExpanded, IsAutoRenewalNextSeason, DiscountCode, SurchargeCode
	, PricingMethod, CompCode, CompName, GroupSalesName, GroupFlag, ClassName, TicketType, TranType, SalesSource, RetailTicketType, RetailQualifiers
	, OtherInfo1, OtherInfo2, OtherInfo3, OtherInfo4, OtherInfo5, OtherInfo6, OtherInfo7, OtherInfo8, OtherInfo9, OtherInfo10
	, TicketSeqId, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_event_id, SSID_section_id, SSID_row_id, SSID_seat_num, SSID_acct_id, SSID_price_code, DeltaHashKey
)

SELECT 
	CONVERT(VARCHAR, tkt.add_datetime, 112) DimDateId
	, CONVERT(VARCHAR, tkt.add_datetime, 112) DimDateId_OrigSale
	, datediff(second, cast(tkt.add_datetime as date), tkt.add_datetime) DimTimeId
	, isnull(dCustomer.DimCustomerId, -1) DimCustomerId
	, isnull(dSeason.DimArenaId, -1) DimArenaId
	, isnull(dSeason.DimSeasonId, -1) DimSeasonId
	, isnull(dItem.DimItemId, -1) DimItemId
	, case when tkt.event_id = tkt.plan_event_id THEN 0 else isnull(dEvent.DimEventId, -1) end DimEventId
	, case when ISNULL(tkt.plan_event_id,0) = 0 then 0 else isnull(dPlan.DimPlanId, -1) end	DimPlanId
	, ISNULL(dpcm.DimPriceCodeMasterId, -1) DimPriceCodeMasterId
	, isnull(isnull(dPriceCode.DimPriceCodeId, dPriceCodePlan.DimPriceCodeId), -1) DimPriceCodeId
	, isnull(dSeat.DimSeatId, -1) DimSeatIdStart
	, ISNULL(CASE 
		WHEN tkt.ssbIsHost = 1 THEN 0
		WHEN tkt.ssbIsHost = 0 and tkt.ledger_id = 0 THEN 1
		WHEN tkt.ssbIsHost = 0 AND tkt.ledger_id IS NOT NULL THEN dLedger.DimLedgerId
		WHEN tkt.ssbIsHost = 0 AND tkt.ledger_id IS NULL AND dPriceCode.LedgerCode IS NOT NULL THEN dLedgerEventPC.DimLedgerId
		WHEN tkt.ssbIsHost = 0 AND tkt.ledger_id IS NULL AND dPriceCodePlan.LedgerCode IS NOT NULL THEN dLedgerPlanPC.DimLedgerId
		ELSE -1
	END, 0) DimLedgerId
	, case when isnull(tkt.class_name,'') = '' then 0 else ISNULL(dctm.DimClassTMId, -1) end DimClassTMId
	, CASE WHEN ISNULL(tkt.sell_location,'') = '' THEN 0 ELSE COALESCE(dSalesCode.DimSalesCodeId, dSalesCodeName.DimSalesCodeId, -1) END DimSalesCodeId
	, case when isnull(tkt.promo_code,'') = '' then 0 else isnull(dPromo.DimPromoId, -1) end DimPromoId
	
	, -1 DimTicketTypeId
	, -1 DimPlanTypeId
	, -1 DimSeatTypeId

	, -1 DimTicketClassId
	, -1 DimTicketClassId2
	, -1 DimTicketClassId3
	, -1 DimTicketClassId4
	, -1 DimTicketClassId5
	
	, COALESCE(dCustomerTransSalesRep.DimCustomerId, dCustomerSalesRep.DimCustomerId, -1) DimCustomerIdSalesRep
	, ISNULL(dCustomerTransSalesRep.DimCustomerId, 0) DimCustomerId_TransSalesRep

	, tkt.order_num OrderNum
	, tkt.order_line_item as OrderLineItem
	, tkt.order_line_item_seq as OrderLineItemSeq
	
	, tkt.num_seats as QtySeat
	
	, CASE WHEN dPlan.DimPlanId > 0 THEN (SELECT * FROM master.dbo.GetQtyFSE(dEvent.DimEventId, dPlan.PlanEventCnt, dSeason.Config_SeasonEventCntFSE, tkt.num_seats)) ELSE 0 END as QtySeatFSE
	
	, ISNULL(tkt.block_purchase_price, 0) as TotalRevenue
	
	, ISNULL(CASE 
		WHEN tkt.pc_ticket = 0 THEN 0
		WHEN ((tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2) * tkt.num_seats) >= tkt.block_purchase_price THEN 0
		WHEN ((tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2 + tkt.pc_ticket) * tkt.num_seats) >= tkt.block_purchase_price THEN tkt.block_purchase_price - ((tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2) * tkt.num_seats)
		ELSE tkt.pc_ticket * tkt.num_seats 
	END, 0) TicketRevenue

	, ISNULL((dPriceCode.price * tkt.num_seats), 0) PcTicketValue
	
	, ISNULL(tkt.full_price, 0) as FullPrice
	
	, ISNULL(CASE 
		WHEN tkt.block_purchase_price = 0 THEN tkt.block_purchase_price
		WHEN tkt.SSBIsHost = 0 AND tkt.disc_amount > 0 THEN (tkt.disc_amount * tkt.num_seats)
		WHEN tkt.SSBIsHost = 1 AND tkt.purchase_price < ISNULL(dPriceCode.price,0) THEN ((ISNULL(dPriceCode.price,0) * tkt.num_seats) - tkt.block_purchase_price)
		ELSE 0
	END, 0) BlockDiscountCalc

	, ISNULL((tkt.disc_amount * tkt.num_seats), 0) AS BlockDiscountArchtics
	, ISNULL(tkt.disc_amount, 0) as Discount
	, ISNULL((tkt.surchg_amount * tkt.num_seats), 0) AS BlockSurcharge
	, ISNULL(tkt.surchg_amount, 0) as Surcharge
	, ISNULL(tkt.purchase_price, 0) as PurchasePrice
	, ISNULL((tkt.full_price * tkt.num_seats), 0) as BlockFullPrice
	, ISNULL(tkt.block_purchase_price, 0) as BlockPurchasePrice 

	, ISNULL(isnull(dPriceCode.Price, dPriceCodePlan.Price), 0) * tkt.num_seats AS PcPrice
	, ISNULL(isnull(dPriceCode.PrintedPrice, dPriceCodePlan.PrintedPrice), 0) * tkt.num_seats AS PcPrintedPrice	

	, ISNULL(CASE 
		WHEN tkt.pc_ticket = 0 THEN 0
		WHEN ((tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2) * tkt.num_seats) >= tkt.block_purchase_price THEN 0
		WHEN ((tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2 + tkt.pc_ticket) * tkt.num_seats) >= tkt.block_purchase_price THEN tkt.block_purchase_price - ((tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2) * tkt.num_seats)
		ELSE tkt.pc_ticket * tkt.num_seats 
	END, 0) PcTicket

	, ISNULL(CASE 
		WHEN tkt.pc_tax = 0 THEN 0
		WHEN ((tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2 + tkt.pc_ticket) * tkt.num_seats) >= tkt.block_purchase_price THEN 0
		WHEN (tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2 + tkt.pc_ticket + tkt.pc_tax) >= tkt.block_purchase_price THEN tkt.block_purchase_price - (tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2 + tkt.pc_ticket)
		ELSE tkt.pc_tax * tkt.num_seats 
	END, 0) PcTax

	, ISNULL(CASE 
		WHEN tkt.pc_licfee = 0 THEN 0
		WHEN ((tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2 + tkt.pc_ticket + tkt.pc_tax) * tkt.num_seats) >= tkt.block_purchase_price THEN 0
		WHEN (tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2 + tkt.pc_ticket + tkt.pc_tax + tkt.pc_licfee) >= tkt.block_purchase_price THEN tkt.block_purchase_price - (tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2 + tkt.pc_ticket + tkt.pc_tax + tkt.pc_licfee)
		ELSE tkt.pc_licfee * tkt.num_seats 
	END, 0) PcLicenseFee
	
	, ISNULL(CASE 
		WHEN tkt.pc_other1 = 0 THEN 0
		WHEN ((tkt.surchg_amount) * tkt.num_seats) >= tkt.block_purchase_price THEN 0
		WHEN (tkt.surchg_amount + tkt.pc_other1) >= tkt.block_purchase_price THEN tkt.block_purchase_price - (tkt.surchg_amount)
		ELSE tkt.pc_other1 * tkt.num_seats 
	END, 0) PcOther1

	, ISNULL(CASE 
		WHEN tkt.pc_other2 = 0 THEN 0
		WHEN ((tkt.surchg_amount + tkt.pc_other1) * tkt.num_seats) >= tkt.block_purchase_price THEN 0
		WHEN (tkt.surchg_amount + tkt.pc_other1 + tkt.pc_other2) >= tkt.block_purchase_price THEN tkt.block_purchase_price - ((tkt.surchg_amount + tkt.pc_other1) * tkt.num_seats)
		ELSE tkt.pc_other2 * tkt.num_seats 
	END, 0) PcOther2

	, CASE 
		WHEN tkt.block_purchase_price = 0 OR ((CAST(paid_amount AS DECIMAL(18,6)) + CAST(owed_amount AS DECIMAL(18,6))) = 0) THEN CAST(0 AS DECIMAL(18,6))
		WHEN tkt.Paid = 'Y' then CAST(tkt.block_purchase_price AS DECIMAL(18,6))
		WHEN tkt.Paid = 'N' then CAST(0 AS DECIMAL(18,6))				 
		WHEN tkt.Paid = 'P' then CAST(tkt.block_purchase_price AS DECIMAL(18,6)) * (CAST(paid_amount AS DECIMAL(18,6)) / (CAST(paid_amount AS DECIMAL(18,6)) + CAST(owed_amount AS DECIMAL(18,6))))
		ELSE CAST(ISNULL(tkt.paid_amount, 0) AS DECIMAL(18,6))
	END PaidAmount
	, CASE 
		WHEN tkt.block_purchase_price = 0 OR ((CAST(paid_amount AS DECIMAL(18,6)) + CAST(owed_amount AS DECIMAL(18,6))) = 0) THEN CAST(0 AS DECIMAL(18,6))
		WHEN tkt.Paid = 'Y' then CAST(0 AS DECIMAL(18,6))
		WHEN tkt.Paid = 'N' then CAST(tkt.block_purchase_price AS DECIMAL(18,6))	
		WHEN tkt.Paid = 'P' then CAST(tkt.block_purchase_price AS DECIMAL(18,6)) * (CAST(owed_amount AS DECIMAL(18,6)) / (CAST(paid_amount AS DECIMAL(18,6)) + CAST(owed_amount AS DECIMAL(18,6))))
		ELSE CAST(tkt.owed_amount AS DECIMAL(18,6))
	END OwedAmount

	, ISNULL(tkt.paid, 'N') as PaidStatus

	, 0 [IsPremium]
	, CASE 
		WHEN tkt.SSBIsHost = 0 AND tkt.disc_amount > 0 THEN 1
		WHEN tkt.SSBIsHost = 1 AND tkt.purchase_price < ISNULL(dPriceCode.price,0) THEN 1
		ELSE 0
	END IsDiscount
		
	, CAST(CASE WHEN tkt.comp_code > 0 THEN 1 ELSE 0 END AS bit) as IsComp
	, tkt.ssbIsHost as IsHost
			
	, CASE WHEN ISNULL(tkt.plan_event_id,0) > 0 THEN 1 ELSE 0 END AS IsPlan
	, CASE WHEN ISNULL(tkt.plan_event_id,0) > 0 AND ISNULL(dPlan.PlanFSE,0) < 1 THEN 1 ELSE 0 END AS IsPartial
	
	, CASE WHEN ISNULL(tkt.plan_event_id,0) = 0 AND tkt.group_flag <> 'Y' THEN 1 ELSE 0 END AS IsSingleEvent
	, CAST(CASE WHEN tkt.group_flag = 'Y' THEN 1 ELSE 0 END AS bit) as IsGroup

	, 0 AS IsBroker
	, 0 as IsRenewal

	, CAST(CASE WHEN tkt.expanded = 'Y' THEN 1 ELSE 0 END AS bit) as IsExpanded
	, CAST(CASE WHEN tkt.renewal_ind = 'Y' THEN 1 ELSE 0 END AS bit) as IsAutoRenewalNextSeason
	
	, tkt.disc_code as DiscountCode
	, tkt.surchg_code_desc as SurchargeCode
	, tkt.pricing_method as PricingMethod
	, tkt.comp_code as CompCode
	, tkt.comp_name as CompName
	, tkt.group_sales_name as GroupSalesName
	, tkt.group_flag as GroupFlag
	, tkt.class_name as ClassName
	, tkt.ticket_type as TicketType
	, tkt.tran_type as TranType
	, tkt.sales_source_name as SalesSource
	, tkt.retail_ticket_type as RetailTicketType
	, tkt.retail_qualifiers as RetailQualifiers
	, tkt.other_info_1 as OtherInfo1
	, tkt.other_info_2 as OtherInfo2
	, tkt.other_info_3 as OtherInfo3
	, tkt.other_info_4 as OtherInfo4
	, tkt.other_info_5 as OtherInfo5
	, tkt.other_info_6 as OtherInfo6
	, tkt.other_info_7 as OtherInfo7
	, tkt.other_info_8 as OtherInfo8
	, tkt.other_info_9 as OtherInfo9
	, tkt.other_info_10 as OtherInfo10
	, tkt.ticket_seq_id as TicketSeqId
	, tkt.add_user as SSCreatedBy
	, tkt.upd_user as SSUpdatedBy
	, tkt.add_datetime as SSCreatedDate
	, tkt.upd_datetime as SSUpdatedDate
	, CONVERT(NVARCHAR, tkt.event_id) + ':' + CONVERT(NVARCHAR, tkt.section_id) + ':' + CONVERT(NVARCHAR, tkt.row_id) + ':' + CONVERT(NVARCHAR, tkt.seat_num) as SSID
	, tkt.event_id as SSID_event_id
	, tkt.section_id as SSID_section_id
	, tkt.row_id as SSID_row_id
	, tkt.seat_num as SSID_seat_num
	, tkt.acct_id as SSID_acct_id
	, tkt.ssbPriceCode as SSID_price_code

	, CAST(NULL AS BINARY(32)) DeltaHashKey	

	--SELECT COUNT(*)
	FROM #WorkingSet tkt
	
	LEFT OUTER JOIN dbo.DimEvent (nolock) dEvent ON tkt.event_id = dEvent.SSID_event_id AND dEvent.SourceSystem = @SourceSystem AND dEvent.DimEventId > 0
	LEFT OUTER JOIN dbo.DimItem (nolock) dItem ON CASE WHEN ISNULL(tkt.plan_event_id,0) = 0 THEN tkt.event_id ELSE tkt.plan_event_id END = dItem.SSID_event_id AND dItem.SourceSystem = @SourceSystem AND dItem.DimItemId > 0		
	LEFT OUTER JOIN dbo.DimPlan (nolock) dPlan ON tkt.plan_event_id = dPlan.SSID_event_id AND dPlan.SourceSystem = @SourceSystem AND dPlan.DimPlanId > 0
	LEFT OUTER JOIN dbo.DimSeason (nolock) dSeason ON ISNULL(dEvent.DimSeasonId, dItem.DimSeasonId) = dSeason.DimSeasonId AND dSeason.SourceSystem = @SourceSystem AND dSeason.DimSeasonId > 0	
	
	LEFT OUTER JOIN dbo.DimCustomer (nolock) dCustomer ON tkt.acct_id = dCustomer.AccountId AND dCustomer.SourceSystem = @SourceSystem AND dCustomer.CustomerType = 'Primary' AND dCustomer.DimCustomerId > 0 AND dCustomer.IsDeleted = 0
		
	LEFT OUTER JOIN dbo.DimCustomer (nolock) dCustomerSalesRep ON tkt.acct_rep_id = dCustomerSalesRep.AccountId AND dCustomerSalesRep.SourceSystem = @SourceSystem AND dCustomerSalesRep.CustomerType = 'Primary' AND dCustomerSalesRep.DimCustomerId > 0 AND dCustomerSalesRep.IsDeleted = 0
	LEFT OUTER JOIN dbo.DimCustomer (nolock) dCustomerTransSalesRep ON tkt.orig_acct_rep_id = dCustomerTransSalesRep.AccountId AND dCustomerTransSalesRep.SourceSystem = @SourceSystem AND dCustomerTransSalesRep.CustomerType = 'Primary' AND dCustomerTransSalesRep.DimCustomerId > 0 AND dCustomerTransSalesRep.IsDeleted = 0
	
	LEFT OUTER JOIN dbo.DimSeat (nolock) dSeat ON dSeason.ManifestId = dSeat.SSID_manifest_id AND tkt.section_id = dSeat.SSID_section_id AND tkt.row_id = dSeat.SSID_row_id AND tkt.seat_num = dSeat.SSID_seat AND dSeat.SourceSystem = @SourceSystem AND dseat.DimSeatId > 0	
	LEFT OUTER JOIN dbo.DimPromo (nolock) dPromo ON tkt.promo_code = dPromo.ETL_SSID_promo_code AND dPromo.DimPromoID > 0	
	
	LEFT OUTER JOIN #DimClassTM_Lookup dctm ON tkt.class_name = dctm.ClassName
	
	LEFT OUTER JOIN dbo.DimSalesCode (NOLOCK) dSalesCode ON tkt.sell_location = CAST(dSalesCode.SSID_sell_location_id AS NVARCHAR(255)) AND dSalesCode.SourceSystem = @SourceSystem AND dSalesCode.DimSalesCodeId > 0
	LEFT OUTER JOIN #DimSalesCode_Lookup dSalesCodeName ON tkt.sell_location = dSalesCodeName.SalesCodeName


	LEFT OUTER JOIN dbo.DimPriceCodeMaster (nolock) dpcm ON tkt.ssbPriceCode = dpcm.PriceCode AND dpcm.DimPriceCodeMasterId > 0
	LEFT OUTER JOIN dbo.DimPriceCode (nolock) dPriceCode ON tkt.event_id = dPriceCode.SSID_event_id AND tkt.ssbPriceCode = dPriceCode.SSID_price_code AND dPriceCode.SourceSystem = @SourceSystem AND dPriceCode.DimPriceCodeId > 0
	LEFT OUTER JOIN dbo.DimPriceCode (nolock) dPriceCodePlan ON tkt.plan_event_id = dPriceCodePlan.SSID_event_id AND tkt.ssbPriceCode = dPriceCodePlan.SSID_price_code AND dPriceCodePlan.SourceSystem = @SourceSystem AND dPriceCodePlan.DimPriceCodeId > 0

	LEFT OUTER JOIN dbo.DimLedger (nolock) dLedger ON dLedger.ETL_SSID_ledger_id = tkt.ledger_id AND dLedger.DimLedgerId > 0 AND dLedger.ETL_SourceSystem = @SourceSystem
	LEFT OUTER JOIN dbo.DimLedger (nolock) dLedgerEventPC ON dLedgerEventPC.LedgerCode = dPriceCode.LedgerCode AND dLedgerEventPC.DimLedgerId > 0 AND dLedgerEventPC.ETL_SourceSystem = @SourceSystem
	LEFT OUTER JOIN dbo.DimLedger (nolock) dLedgerPlanPC ON dLedgerPlanPC.LedgerCode = dPriceCodePlan.LedgerCode AND dLedgerPlanPC.DimLedgerId > 0 AND dLedgerPlanPC.ETL_SourceSystem = @SourceSystem		
		
	
	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Stg Temp Table Load Complete', @ExecutionId


	DECLARE @StgFactTicketSalesCountLogMessage NVARCHAR(2000) = 'Stg Temp Table Record Count: ' + CONVERT(NVARCHAR(25), (SELECT COUNT(*) FROM #stgFactTicketSales))

	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, @StgFactTicketSalesCountLogMessage, @ExecutionId

	
	CREATE NONCLUSTERED INDEX IDX_LoadKey ON #stgFactTicketSales (SSID_event_id, SSID_section_id, SSID_row_id, SSID_seat_num)

	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Stg Temp Table IDX_LoadKey Built', @ExecutionId


	IF EXISTS (SELECT * FROM sys.procedures WHERE [object_id] = OBJECT_ID('etl.Cust_FactTicketSalesProcessing'))
	BEGIN
		EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Custom Rule Processing Start', @ExecutionId
		
		EXEC etl.Cust_FactTicketSalesProcessing

		EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Custom Rule Processing Complete', @ExecutionId
	END
	

	UPDATE #stgFactTicketSales
	SET DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),BlockDiscountArchtics)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),BlockDiscountCalc)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),BlockFullPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),BlockPurchasePrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),BlockSurcharge)),'DBNULL_NUMBER') + ISNULL(RTRIM(ClassName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),CompCode)),'DBNULL_INT') + ISNULL(RTRIM(CompName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),DimArenaId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimClassTMId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimCustomerId)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),DimCustomerIdSalesRep)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),DimDateId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimDateId_OrigSale)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimEventId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimItemId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimLedgerId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimPlanId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimPlanId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimPriceCodeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimPriceCodeMasterId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimPromoId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimSalesCodeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimSeasonId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimSeatIdStart)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimSeatTypeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimTicketClassId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimTicketClassId2)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimTicketClassId3)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimTicketClassId4)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimTicketClassId5)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimTicketTypeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimTimeId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),Discount)),'DBNULL_NUMBER') + ISNULL(RTRIM(DiscountCode),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),FullPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(GroupFlag),'DBNULL_TEXT') + ISNULL(RTRIM(GroupSalesName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),IsAutoRenewalNextSeason)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsBroker)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsComp)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),IsDiscount)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsExpanded)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsGroup)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsHost)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsPartial)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsPlan)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsPremium)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsRenewal)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsSingleEvent)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),OrderLineItem)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),OrderLineItemSeq)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),OrderNum)),'DBNULL_BIGINT') + ISNULL(RTRIM(OtherInfo1),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo10),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo2),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo3),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo4),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo5),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo6),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo7),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo8),'DBNULL_TEXT') + ISNULL(RTRIM(OtherInfo9),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),OwedAmount)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PaidAmount)),'DBNULL_NUMBER') + ISNULL(RTRIM(PaidStatus),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),PcLicenseFee)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcOther1)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcOther2)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcPrintedPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcTicket)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcTicketValue)),'DBNULL_NUMBER') + ISNULL(RTRIM(PricingMethod),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),PurchasePrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),QtySeat)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),QtySeatFSE)),'DBNULL_NUMBER') + ISNULL(RTRIM(RetailQualifiers),'DBNULL_TEXT') + ISNULL(RTRIM(RetailTicketType),'DBNULL_TEXT') + ISNULL(RTRIM(SalesSource),'DBNULL_TEXT') + ISNULL(RTRIM(SSCreatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SSCreatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(SSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_acct_id)),'DBNULL_INT') + ISNULL(RTRIM(SSID_price_code),'DBNULL_TEXT') + ISNULL(RTRIM(SSUpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SSUpdatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),Surcharge)),'DBNULL_NUMBER') + ISNULL(RTRIM(SurchargeCode),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),TicketRevenue)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),TicketSeqId)),'DBNULL_BIGINT') + ISNULL(RTRIM(TicketType),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),TotalRevenue)),'DBNULL_NUMBER') + ISNULL(RTRIM(TranType),'DBNULL_TEXT'))

	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Stg Ticket Sales DeltaHashKey Set', @ExecutionId

	CREATE NONCLUSTERED INDEX IDX_DeltaHashKey ON #stgFactTicketSales (DeltaHashKey)

	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Stg Ticket Sales DeltaHashKey Index Built', @ExecutionId			


MERGE dbo.FactTicketSales AS mytarget

USING (select * from #stgFactTicketSales) as mySource

     ON
		myTarget.SourceSystem = @SourceSystem
		and myTarget.SSID_event_id = mySource.SSID_event_id
		and myTarget.SSID_section_id = mySource.SSID_section_id
		and myTarget.SSID_row_id = mySource.SSID_row_id
		and myTarget.SSID_seat_num = mySource.SSID_seat_num

WHEN MATCHED AND isnull(mySource.DeltaHashKey,-1) <> isnull(myTarget.DeltaHashKey, -1)
THEN UPDATE SET 

	myTarget.UpdatedBy = 'CI'
	, myTarget.UpdatedDate = @RunTime
	, myTarget.DeltaHashKey = mySource.DeltaHashKey

	, myTarget.DimDateId = mySource.DimDateId
	, myTarget.DimDateId_OrigSale = mySource.DimDateId_OrigSale
	, myTarget.DimTimeId = mySource.DimTimeId
	, myTarget.DimCustomerId = mySource.DimCustomerId
	, myTarget.DimArenaId = mySource.DimArenaId
	, myTarget.DimSeasonId = mySource.DimSeasonId
	, myTarget.DimItemId = mySource.DimItemId
	, myTarget.DimEventId = mySource.DimEventId
	, myTarget.DimPlanId = mySource.DimPlanId
	, myTarget.DimPriceCodeMasterId = mySource.DimPriceCodeMasterId
	, myTarget.DimPriceCodeId = mySource.DimPriceCodeId
	, myTarget.DimSeatIdStart = mySource.DimSeatIdStart
	, myTarget.DimLedgerId = mySource.DimLedgerId
	, myTarget.DimClassTMId = mySource.DimClassTMId
	, myTarget.DimSalesCodeId = mySource.DimSalesCodeId
	, myTarget.DimPromoId = mySource.DimPromoId

	, myTarget.DimTicketTypeId = mySource.DimTicketTypeId
	, myTarget.DimPlanTypeId = mySource.DimPlanTypeId
	, myTarget.DimSeatTypeId = mySource.DimSeatTypeId

	, myTarget.DimTicketClassId = mySource.DimTicketClassId
	, myTarget.DimTicketClassId2 = mySource.DimTicketClassId2
	, myTarget.DimTicketClassId3 = mySource.DimTicketClassId3
	, myTarget.DimTicketClassId4 = mySource.DimTicketClassId4
	, myTarget.DimTicketClassId5 = mySource.DimTicketClassId5
	, myTarget.DimCustomerIdSalesRep = mySource.DimCustomerIdSalesRep
	, myTarget.DimCustomerId_TransSalesRep = mySource.DimCustomerId_TransSalesRep
	, myTarget.OrderNum = mySource.OrderNum
	, myTarget.OrderLineItem = mySource.OrderLineItem
	, myTarget.OrderLineItemSeq = mySource.OrderLineItemSeq
	, myTarget.QtySeat = mySource.QtySeat
	, myTarget.QtySeatFSE = mySource.QtySeatFSE
	, myTarget.TotalRevenue = mySource.TotalRevenue
	, myTarget.TicketRevenue = mySource.TicketRevenue
	, myTarget.PcTicketValue = mySource.PcTicketValue
	, myTarget.FullPrice = mySource.FullPrice
	, myTarget.BlockDiscountCalc = mySource.BlockDiscountCalc
	, myTarget.BlockDiscountArchtics = mySource.BlockDiscountArchtics
	, myTarget.Discount = mySource.Discount
	, myTarget.BlockSurcharge = mySource.BlockSurcharge
	, myTarget.Surcharge = mySource.Surcharge
	, myTarget.PurchasePrice = mySource.PurchasePrice
	, myTarget.BlockFullPrice = mySource.BlockFullPrice
	, myTarget.BlockPurchasePrice = mySource.BlockPurchasePrice
	, myTarget.PcPrice = mySource.PcPrice
	, myTarget.PcPrintedPrice = mySource.PcPrintedPrice
	, myTarget.PcTicket = mySource.PcTicket
	, myTarget.PcTax = mySource.PcTax
	, myTarget.PcLicenseFee = mySource.PcLicenseFee
	, myTarget.PcOther1 = mySource.PcOther1
	, myTarget.PcOther2 = mySource.PcOther2
	, myTarget.PaidAmount = mySource.PaidAmount
	, myTarget.OwedAmount = mySource.OwedAmount
	, myTarget.PaidStatus = mySource.PaidStatus
	, myTarget.IsPremium = mySource.IsPremium
	, myTarget.IsDiscount = mySource.IsDiscount
	, myTarget.IsComp = mySource.IsComp
	, myTarget.IsHost = mySource.IsHost
	, myTarget.IsPlan = mySource.IsPlan
	, myTarget.IsPartial = mySource.IsPartial
	, myTarget.IsSingleEvent = mySource.IsSingleEvent
	, myTarget.IsGroup = mySource.IsGroup
	, myTarget.IsBroker = mySource.IsBroker
	, myTarget.IsRenewal = mySource.IsRenewal
	, myTarget.IsExpanded = mySource.IsExpanded
	, myTarget.IsAutoRenewalNextSeason = mySource.IsAutoRenewalNextSeason
	, myTarget.DiscountCode = mySource.DiscountCode
	, myTarget.SurchargeCode = mySource.SurchargeCode
	, myTarget.PricingMethod = mySource.PricingMethod
	, myTarget.CompCode = mySource.CompCode
	, myTarget.CompName = mySource.CompName
	, myTarget.GroupSalesName = mySource.GroupSalesName
	, myTarget.GroupFlag = mySource.GroupFlag
	, myTarget.ClassName = mySource.ClassName
	, myTarget.TicketType = mySource.TicketType
	, myTarget.TranType = mySource.TranType
	, myTarget.SalesSource = mySource.SalesSource
	, myTarget.RetailTicketType = mySource.RetailTicketType
	, myTarget.RetailQualifiers = mySource.RetailQualifiers
	, myTarget.OtherInfo1 = mySource.OtherInfo1
	, myTarget.OtherInfo2 = mySource.OtherInfo2
	, myTarget.OtherInfo3 = mySource.OtherInfo3
	, myTarget.OtherInfo4 = mySource.OtherInfo4
	, myTarget.OtherInfo5 = mySource.OtherInfo5
	, myTarget.OtherInfo6 = mySource.OtherInfo6
	, myTarget.OtherInfo7 = mySource.OtherInfo7
	, myTarget.OtherInfo8 = mySource.OtherInfo8
	, myTarget.OtherInfo9 = mySource.OtherInfo9
	, myTarget.OtherInfo10 = mySource.OtherInfo10
	, myTarget.TicketSeqId = mySource.TicketSeqId
	, myTarget.SSCreatedBy = mySource.SSCreatedBy
	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy
	, myTarget.SSCreatedDate = mySource.SSCreatedDate
	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate
	, myTarget.SSID = mySource.SSID
	, myTarget.SSID_event_id = mySource.SSID_event_id
	, myTarget.SSID_section_id = mySource.SSID_section_id
	, myTarget.SSID_row_id = mySource.SSID_row_id
	, myTarget.SSID_seat_num = mySource.SSID_seat_num
	, myTarget.SSID_acct_id = mySource.SSID_acct_id
	, myTarget.SSID_price_code = mySource.SSID_price_code

WHEN NOT MATCHED THEN INSERT
    (
		DimDateId, DimDateId_OrigSale, DimTimeId, DimCustomerId, DimArenaId, DimSeasonId, DimItemId, DimEventId, DimPlanId, DimPriceCodeMasterId, DimPriceCodeId, DimSeatIdStart, DimLedgerId, DimClassTMId, DimSalesCodeId, DimPromoId, DimTicketTypeId, DimPlanTypeId, DimSeatTypeId, DimTicketClassId, DimTicketClassId2, DimTicketClassId3, DimTicketClassId4, DimTicketClassId5, DimCustomerIdSalesRep, DimCustomerId_TransSalesRep, OrderNum, OrderLineItem, OrderLineItemSeq, QtySeat, QtySeatFSE, TotalRevenue, TicketRevenue, PcTicketValue, FullPrice, BlockDiscountCalc, BlockDiscountArchtics, Discount, BlockSurcharge, Surcharge, PurchasePrice, BlockFullPrice, BlockPurchasePrice, PcPrice, PcPrintedPrice, PcTicket, PcTax, PcLicenseFee, PcOther1, PcOther2, PaidAmount, OwedAmount, PaidStatus, IsPremium, IsDiscount, IsComp, IsHost, IsPlan, IsPartial, IsSingleEvent, IsGroup, IsBroker, IsRenewal, IsExpanded, IsAutoRenewalNextSeason, DiscountCode, SurchargeCode, PricingMethod, CompCode, CompName, GroupSalesName, GroupFlag, ClassName, TicketType, TranType, SalesSource, RetailTicketType, RetailQualifiers, OtherInfo1, OtherInfo2, OtherInfo3, OtherInfo4, OtherInfo5, OtherInfo6, OtherInfo7, OtherInfo8, OtherInfo9, OtherInfo10, TicketSeqId, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_event_id, SSID_section_id, SSID_row_id, SSID_seat_num, SSID_acct_id, SSID_price_code, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate
    )
    VALUES (
		
		mySource.DimDateId
		, mySource.DimDateId_OrigSale
		, mySource.DimTimeId
		, mySource.DimCustomerId
		, mySource.DimArenaId
		, mySource.DimSeasonId
		, mySource.DimItemId
		, mySource.DimEventId
		, mySource.DimPlanId
		, mySource.DimPriceCodeMasterId
		, mySource.DimPriceCodeId
		, mySource.DimSeatIdStart
		, mySource.DimLedgerId
		, mySource.DimClassTMId
		, mySource.DimSalesCodeId
		, mySource.DimPromoId
		, mySource.DimTicketTypeId
		, mySource.DimPlanTypeId
		, mySource.DimSeatTypeId
		, mySource.DimTicketClassId
		, mySource.DimTicketClassId2
		, mySource.DimTicketClassId3
		, mySource.DimTicketClassId4
		, mySource.DimTicketClassId5
		, mySource.DimCustomerIdSalesRep
		, mySource.DimCustomerId_TransSalesRep
		, mySource.OrderNum
		, mySource.OrderLineItem
		, mySource.OrderLineItemSeq
		, mySource.QtySeat
		, mySource.QtySeatFSE
		, mySource.TotalRevenue
		, mySource.TicketRevenue
		, mySource.PcTicketValue
		, mySource.FullPrice
		, mySource.BlockDiscountCalc
		, mySource.BlockDiscountArchtics
		, mySource.Discount
		, mySource.BlockSurcharge
		, mySource.Surcharge
		, mySource.PurchasePrice
		, mySource.BlockFullPrice
		, mySource.BlockPurchasePrice
		, mySource.PcPrice
		, mySource.PcPrintedPrice
		, mySource.PcTicket
		, mySource.PcTax
		, mySource.PcLicenseFee
		, mySource.PcOther1
		, mySource.PcOther2
		, mySource.PaidAmount
		, mySource.OwedAmount
		, mySource.PaidStatus
		, mySource.IsPremium
		, mySource.IsDiscount
		, mySource.IsComp
		, mySource.IsHost
		, mySource.IsPlan
		, mySource.IsPartial
		, mySource.IsSingleEvent
		, mySource.IsGroup
		, mySource.IsBroker
		, mySource.IsRenewal
		, mySource.IsExpanded
		, mySource.IsAutoRenewalNextSeason
		, mySource.DiscountCode
		, mySource.SurchargeCode
		, mySource.PricingMethod
		, mySource.CompCode
		, mySource.CompName
		, mySource.GroupSalesName
		, mySource.GroupFlag
		, mySource.ClassName
		, mySource.TicketType
		, mySource.TranType
		, mySource.SalesSource
		, mySource.RetailTicketType
		, mySource.RetailQualifiers
		, mySource.OtherInfo1
		, mySource.OtherInfo2
		, mySource.OtherInfo3
		, mySource.OtherInfo4
		, mySource.OtherInfo5
		, mySource.OtherInfo6
		, mySource.OtherInfo7
		, mySource.OtherInfo8
		, mySource.OtherInfo9
		, mySource.OtherInfo10
		, mySource.TicketSeqId
		, mySource.SSCreatedBy
		, mySource.SSUpdatedBy
		, mySource.SSCreatedDate
		, mySource.SSUpdatedDate
		, mySource.SSID
		, mySource.SSID_event_id
		, mySource.SSID_section_id
		, mySource.SSID_row_id
		, mySource.SSID_seat_num
		, mySource.SSID_acct_id
		, mySource.SSID_price_code

		, @SourceSystem --SourceSystem
		, mySource.DeltaHashKey
		, 'CI' --CreatedBy
		, 'CI' --UpdatedBy
		, @RunTime --CreatedDate
		, @RunTime --UpdatedDate
		, 0 --IsDeleted
		, null --DeleteDate

    );

	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'FactTicketSales Merge Complete', @ExecutionId


	DECLARE @FactTicketSalesInsertCountLogMessage NVARCHAR(2000) = 'FactTicketSales Insert Record Count: ' + CONVERT(NVARCHAR(25), (SELECT COUNT(*) FROM dbo.FactTicketSales WHERE CreatedDate = UpdatedDate AND UpdatedDate >= @RunTime))

	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, @FactTicketSalesInsertCountLogMessage, @ExecutionId
	

	DECLARE @FactTicketSalesUpdateCountLogMessage NVARCHAR(2000) = 'FactTicketSales Update Record Count: ' + CONVERT(NVARCHAR(25), (SELECT COUNT(*) FROM dbo.FactTicketSales WHERE CreatedDate <> UpdatedDate AND CreatedDate >= @RunTime))

	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, @FactTicketSalesUpdateCountLogMessage, @ExecutionId

	
END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.LogEventRecordDB @Batchid, 'Error', @ProcedureName, 'Fact Load', 'Exception', @ErrorMessage, @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH


	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Complete', @ExecutionId


END

GO
