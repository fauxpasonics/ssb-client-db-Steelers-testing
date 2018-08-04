SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_Ticket_Pacing] 

AS
BEGIN

/*
DROP TABLE #StgSales
DROP TABLE #ExistingSales
*/

DECLARE @RunTime DATETIME = DATEADD(HOUR, (SELECT UTCOffset FROM dbo.DimDate WHERE CalDate = CAST(GETDATE() AS DATE)), GETDATE())

SELECT 
	--CAST(HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),acct_id)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),acct_Rep_id)),'DBNULL_BIGINT') + ISNULL(RTRIM(class_name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),comp_code)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),event_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ledger_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),orig_acct_rep_id)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),plan_event_id)),'DBNULL_INT') + ISNULL(RTRIM(price_code),'DBNULL_TEXT') + ISNULL(RTRIM(pricing_method),'DBNULL_TEXT') + ISNULL(RTRIM(promo_code),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),row_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),seat_num)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),section_id)),'DBNULL_INT') + ISNULL(RTRIM(sell_location),'DBNULL_TEXT') + ISNULL(RTRIM(tran_type),'DBNULL_TEXT')) AS BINARY(32)) ETL_BusinessKey
	CAST(HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),acct_id)),'DBNULL_BIGINT') + '|' +  ISNULL(RTRIM(CONVERT(varchar(10),acct_Rep_id)),'DBNULL_BIGINT') + '|' +  ISNULL(RTRIM(class_name),'DBNULL_TEXT') + '|' +  ISNULL(RTRIM(CONVERT(varchar(10),comp_code)),'DBNULL_INT') + '|' +  ISNULL(RTRIM(CONVERT(varchar(10),event_id)),'DBNULL_INT') + '|' +  ISNULL(RTRIM(CONVERT(varchar(10),ledger_id)),'DBNULL_INT') + '|' +  ISNULL(RTRIM(CONVERT(varchar(10),orig_acct_rep_id)),'DBNULL_BIGINT') + '|' +  ISNULL(RTRIM(CONVERT(varchar(10),plan_event_id)),'DBNULL_INT') + '|' +  ISNULL(RTRIM(price_code),'DBNULL_TEXT') + '|' +  ISNULL(RTRIM(pricing_method),'DBNULL_TEXT') + '|' +  ISNULL(RTRIM(promo_code),'DBNULL_TEXT') + '|' +  ISNULL(RTRIM(CONVERT(varchar(10),row_id)),'DBNULL_INT') + '|' +  ISNULL(RTRIM(CONVERT(varchar(10),seat_num)),'DBNULL_INT') + '|' +  ISNULL(RTRIM(CONVERT(varchar(10),section_id)),'DBNULL_INT') + '|' +  ISNULL(RTRIM(sell_location),'DBNULL_TEXT') + '|' +  ISNULL(RTRIM(tran_type),'DBNULL_TEXT')) AS BINARY(32)) ETL_BusinessKey
	, tkt.acct_id, tkt.acct_Rep_id, tkt.orig_acct_rep_id, tkt.event_id, tkt.plan_event_id, tkt.price_code, tkt.sell_location, tkt.ledger_id, tkt.class_name,
	  tkt.promo_code, tkt.tran_type, tkt.pricing_method, tkt.comp_code, tkt.section_id, tkt.row_id, tkt.seat_num, tkt.num_seats, tkt.block_purchase_price
INTO #StgSales
FROM (
	SELECT tkt.acct_id, tkt.acct_Rep_id, tkt.orig_acct_rep_id, tkt.event_id, tkt.plan_event_id, tkt.price_code, tkt.sell_location, tkt.ledger_id, tkt.class_name, tkt.promo_code
	, tkt.tran_type, tkt.pricing_method, tkt.comp_code
	, CAST(tkt.section_id AS INT) section_id
	, CAST(tkt.row_id AS INT) row_id
	, CAST(tkt.seat_num AS INT) seat_num
	, SUM(CAST(tkt.num_seats AS INT)) num_seats
	, SUM(CAST(tkt.block_purchase_price AS DECIMAL(18,6))) block_purchase_price
	FROM ods.TM_vw_Ticket tkt	
	LEFT OUTER JOIN dbo.DimItem dItem ON CASE WHEN tkt.plan_event_id = 0 THEN tkt.event_id ELSE tkt.plan_event_id END = dItem.SSID_event_id AND dItem.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem')) AND dItem.DimItemId > 0
	WHERE ISNULL(dItem.Config_IsClosed,0) = 0
	AND dItem.Config_IsFactSalesEligible = 1
	GROUP BY tkt.acct_id, tkt.acct_Rep_id, tkt.orig_acct_rep_id, tkt.event_id, tkt.plan_event_id, tkt.price_code, tkt.sell_location, tkt.ledger_id, tkt.class_name, tkt.promo_code
	, tkt.tran_type, tkt.pricing_method, tkt.comp_code
	, CAST(tkt.section_id AS INT)
	, CAST(tkt.row_id AS INT)
	, CAST(tkt.seat_num AS INT)
) tkt
WHERE tkt.num_seats <> 0
or tkt.block_purchase_price <> 0 


CREATE NONCLUSTERED INDEX IDX_ETL_BusinessKey ON #StgSales (ETL_BusinessKey)

SELECT ETL_BusinessKey, acct_id, acct_Rep_id, orig_acct_rep_id, event_id, plan_event_id, price_code, sell_location,
       ledger_id, class_name, promo_code, tran_type, pricing_method, comp_code, section_id, row_id, seat_num
	   , SUM(num_seats) num_seats, SUM(block_purchase_price) block_purchase_price
INTO #ExistingSales
FROM ods.TM_Ticket_Pacing
GROUP BY 
	ETL_BusinessKey, acct_id, acct_Rep_id, orig_acct_rep_id, event_id, plan_event_id, price_code, sell_location,
       ledger_id, class_name, promo_code, tran_type, pricing_method, comp_code, section_id, row_id, seat_num
HAVING SUM(num_seats) <> 0 OR SUM(block_purchase_price) <> 0


CREATE NONCLUSTERED INDEX IDX_ETL_BusinessKey ON #ExistingSales (ETL_BusinessKey)


INSERT INTO ods.TM_Ticket_Pacing (ETL_CreatedDate, ETL_BusinessKey, ETL_DeltaType, acct_id, acct_Rep_id, orig_acct_rep_id, event_id, plan_event_id, price_code, sell_location, ledger_id, class_name, promo_code, tran_type, pricing_method, comp_code, section_id, row_id, seat_num, num_seats, block_purchase_price)

SELECT @RunTime ETL_CreatedDate
	, s.ETL_BusinessKey
	, 'U' ETL_DeltaType
	, s.acct_id, s.acct_Rep_id, s.orig_acct_rep_id, s.event_id, s.plan_event_id, s.price_code, s.sell_location, s.ledger_id
	, s.class_name, s.promo_code, s.tran_type, s.pricing_method, s.comp_code, s.section_id, s.row_id, s.seat_num
	, (s.num_seats - t.num_seats)
	, (s.block_purchase_price - t.block_purchase_price)
FROM #ExistingSales t
INNER JOIN #StgSales s ON t.ETL_BusinessKey = s.ETL_BusinessKey
WHERE ISNULL(t.num_seats,0) <> ISNULL(s.num_seats,0)
OR ISNULL(t.block_purchase_price,0) <> ISNULL(s.block_purchase_price,0)


INSERT INTO ods.TM_Ticket_Pacing (ETL_CreatedDate, ETL_BusinessKey, ETL_DeltaType, acct_id, acct_Rep_id, orig_acct_rep_id, event_id, plan_event_id, price_code, sell_location, ledger_id, class_name, promo_code, tran_type, pricing_method, comp_code, section_id, row_id, seat_num, num_seats, block_purchase_price)

SELECT @RunTime ETL_CreatedDate
	, s.ETL_BusinessKey
	, 'A' ETL_DeltaType
	, s.acct_id, s.acct_Rep_id, s.orig_acct_rep_id, s.event_id, s.plan_event_id, s.price_code, s.sell_location, s.ledger_id
	, s.class_name, s.promo_code, s.tran_type, s.pricing_method, s.comp_code, s.section_id, s.row_id, s.seat_num
	, s.num_seats, s.block_purchase_price
FROM #StgSales s
LEFT OUTER JOIN #ExistingSales t ON t.ETL_BusinessKey = s.ETL_BusinessKey
WHERE t.ETL_BusinessKey IS null  


INSERT INTO ods.TM_Ticket_Pacing (ETL_CreatedDate, ETL_BusinessKey, ETL_DeltaType, acct_id, acct_Rep_id, orig_acct_rep_id, event_id, plan_event_id, price_code, sell_location, ledger_id, class_name, promo_code, tran_type, pricing_method, comp_code, section_id, row_id, seat_num, num_seats, block_purchase_price)

SELECT @RunTime ETL_CreatedDate
	, t.ETL_BusinessKey
	, 'D' ETL_DeltaType
	, t.acct_id, t.acct_Rep_id, t.orig_acct_rep_id, t.event_id, t.plan_event_id, t.price_code, t.sell_location, t.ledger_id
	, t.class_name, t.promo_code, t.tran_type, t.pricing_method, t.comp_code, t.section_id, t.row_id, t.seat_num
	, (t.num_seats * -1) num_seats, (t.block_purchase_price * -1) block_purchase_price
FROM #ExistingSales t
LEFT OUTER JOIN #StgSales s ON t.ETL_BusinessKey = s.ETL_BusinessKey
WHERE s.ETL_BusinessKey IS null  


ALTER INDEX	IDX_ETL_BusinessKey ON ods.TM_Ticket_Pacing REBUILD


END




GO
