SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [ods].[LoadTkt]
(
	@BatchId bigint = 0,
	@Options nvarchar(MAX) = null
)
as
BEGIN
--SET NOCOUNT ON;


	--Set to null rather than blank, because once cast as int '' becomes 0
	UPDATE src.TM_Tkt
	SET orig_acct_rep_id = NULL
	WHERE orig_acct_rep_id = ''

	/*
	Log Level value optionally specified in the @Options parameter, if not provided set to 3
	Log Level 1 = Error Logging, 2 = Error + Warnings, 3 = Error + Warnings + Info, 0 = None(use for dev only)

	Optionally can disable merge crud options with true value for (DisableInsert, DisableUpdate, DisableDelete)
	*/
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_tkt),'0');	

	/*Set ExecutionId to new guid to group log records together*/
	DECLARE @ExecutionId uniqueidentifier = newid();
	DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);

	/*Load Options into a temp table*/
	SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

	/*Extract Options, default values set if the option is not specified*/
	DECLARE @LogLevel int = ISNULL((SELECT TRY_PARSE(OptionValue as int) FROM #Options WHERE OptionKey = 'LogLevel'),3)
	DECLARE @DisableInsert nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableInsert'),'false')
	DECLARE @DisableUpdate nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableUpdate'),'false')
	DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'false')

	PRINT @LogLevel


	if (@LogLevel >= 3)
	begin 
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Start', 'Starting Merge Load', @ExecutionId
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
	END	

	/*Put all merge logic inside of try block*/
	BEGIN TRY

	DECLARE @RunTime datetime = GETDATE();


	SELECT a.event_id, a.section_id, a.row_id, a.seat_num, a.last_Seat, a.num_seats, MIN(tkt.seat_num) Min_seat_num, COUNT(*) cnt
	INTO #MultiBlockSeatsTkt
	FROM (
		SELECT *
		, ROW_NUMBER() OVER(PARTITION BY event_id, section_id, row_id, seat_num, ticket_status ORDER BY upd_datetime DESC, seq_num) MergeRank
		FROM src.TM_Tkt	
		WHERE ticket_status = 'A'
	) a 
	INNER JOIN ods.TM_Tkt tkt 
		ON a.event_id = tkt.event_id
		AND tkt.section_id = a.section_id
		AND tkt.row_id = a.row_id
		AND tkt.seat_num >= a.seat_num
		AND tkt.seat_num <= a.last_Seat
	WHERE a.MergeRank = 1 AND tkt.ticket_status = 'A'
	GROUP BY a.event_id, a.section_id, a.row_id, a.seat_num, a.last_Seat, a.num_seats
	HAVING COUNT(*) > 1


	DELETE tkt
	FROM #MultiBlockSeatsTkt a
	INNER JOIN ods.TM_Tkt tkt 
		ON a.event_id = tkt.event_id
		AND tkt.section_id = a.section_id
		AND tkt.row_id = a.row_id
		AND tkt.seat_num >= a.seat_num
		AND tkt.seat_num <= a.last_Seat
	WHERE tkt.seat_num <> a.Min_seat_num



/*
The process first loads 'A' Active tickets using the event, seat, and ticket status as the key, then loads returns with the event, seat, ticket status, acct, and update time.
this is done to capture all distinct return records for historical purposes.  It is possible that the same seat at an event is purchased multiple times and returned multiple times.
*/

MERGE ods.TM_Tkt as myTarget

USING (SELECT * FROM src.vw_TM_Tkt) AS mySource ON 

	mySource.event_id = myTarget.event_id 
		AND mySource.section_id = myTarget.section_id 
		AND mySource.row_id = myTarget.row_id
		AND mySource.seat_num = myTarget.seat_num 
		AND mySource.ticket_status = myTarget.ticket_status

WHEN MATCHED AND @DisableUpdate <> 'true' AND mySource.HashKey <> myTarget.HashKey
THEN UPDATE SET

	myTarget.UpdateDate = @RunTime
	, myTarget.HashKey = mySource.HashKey

	, myTarget.event_name = mySource.event_name
	, myTarget.section_name = mySource.section_name
	, myTarget.row_name = mySource.row_name
	, myTarget.num_seats = mySource.num_seats
	, myTarget.ticket_status = mySource.ticket_status
	, myTarget.acct_id = mySource.acct_id
	, myTarget.upd_datetime = mySource.upd_datetime
	, myTarget.seq_num = mySource.seq_num
	, myTarget.block_purchase_price = mySource.block_purchase_price
	, myTarget.order_num = mySource.order_num
	, myTarget.order_line_item = mySource.order_line_item
	, myTarget.order_line_item_seq = mySource.order_line_item_seq
	, myTarget.info = mySource.info
	, myTarget.total_events = mySource.total_events
	, myTarget.price_code = mySource.price_code
	, myTarget.pricing_method = mySource.pricing_method
	, myTarget.comp_code = mySource.comp_code
	, myTarget.comp_name = mySource.comp_name
	, myTarget.Paid = mySource.Paid
	, myTarget.disc_code = mySource.disc_code
	, myTarget.disc_amount = mySource.disc_amount
	, myTarget.surchg_code = mySource.surchg_code
	, myTarget.surchg_amount = mySource.surchg_amount
	, myTarget.group_flag = mySource.group_flag
	, myTarget.upd_user = mySource.upd_user
	, myTarget.class_name = mySource.class_name
	, myTarget.sell_location = mySource.sell_location
	, myTarget.full_price = mySource.full_price
	, myTarget.purchase_price = mySource.purchase_price
	, myTarget.sales_source_name = mySource.sales_source_name
	, myTarget.sales_source_date = mySource.sales_source_date
	, myTarget.Ticket_Type = mySource.Ticket_Type
	, myTarget.Price_code_desc = mySource.Price_code_desc
	, myTarget.event_id = mySource.event_id
	, myTarget.plan_event_id = mySource.plan_event_id
	, myTarget.plan_event_name = mySource.plan_event_name
	, myTarget.seat_num = mySource.seat_num
	, myTarget.last_Seat = mySource.last_Seat
	, myTarget.other_info_1 = mySource.other_info_1
	, myTarget.other_info_2 = mySource.other_info_2
	, myTarget.other_info_3 = mySource.other_info_3
	, myTarget.other_info_4 = mySource.other_info_4
	, myTarget.other_info_5 = mySource.other_info_5
	, myTarget.other_info_6 = mySource.other_info_6
	, myTarget.other_info_7 = mySource.other_info_7
	, myTarget.other_info_8 = mySource.other_info_8
	, myTarget.other_info_9 = mySource.other_info_9
	, myTarget.other_info_10 = mySource.other_info_10
	, myTarget.acct_Rep_id = mySource.acct_Rep_id
	, myTarget.acct_rep_full_name = mySource.acct_rep_full_name
	, myTarget.tran_type = mySource.tran_type
	, myTarget.section_id = mySource.section_id
	, myTarget.row_id = mySource.row_id
	, myTarget.promo_code = mySource.promo_code
	, myTarget.retail_ticket_type = mySource.retail_ticket_type
	, myTarget.retail_qualifiers = mySource.retail_qualifiers
	, myTarget.paid_amount = mySource.paid_amount
	, myTarget.owed_amount = mySource.owed_amount
	, myTarget.add_datetime = mySource.add_datetime
	, myTarget.add_user = mySource.add_user
	, myTarget.renewal_ind = mySource.renewal_ind
	, myTarget.SourceFileName = mySource.SourceFileName
	, myTarget.return_reason = mySource.return_reason
	, myTarget.return_reason_desc = mySource.return_reason_desc
	, myTarget.expanded = mySource.expanded
	, myTarget.delivery_method = mySource.delivery_method
	, myTarget.delivery_method_name = mySource.delivery_method_name
	, myTarget.delivery_instructions = mySource.delivery_instructions
	, myTarget.delivery_name_first = mySource.delivery_name_first
	, myTarget.delivery_name_last = mySource.delivery_name_last
	, myTarget.delivery_addr1 = mySource.delivery_addr1
	, myTarget.delivery_addr2 = mySource.delivery_addr2
	, myTarget.delivery_addr3 = mySource.delivery_addr3
	, myTarget.delivery_city = mySource.delivery_city
	, myTarget.delivery_state = mySource.delivery_state
	, myTarget.delivery_zip = mySource.delivery_zip
	, myTarget.delivery_zip_formatted = mySource.delivery_zip_formatted
	, myTarget.delivery_country = mySource.delivery_country
	, myTarget.delivery_phone = mySource.delivery_phone
	, myTarget.delivery_phone_formatted = mySource.delivery_phone_formatted
	, myTarget.delivered_date = mySource.delivered_date
	, myTarget.group_sales_name = mySource.group_sales_name

	, myTarget.ledger_id = mySource.ledger_id
	, myTarget.pc_ticket = mySource.pc_ticket
	, myTarget.pc_tax = mySource.pc_tax
	, myTarget.pc_licfee = mySource.pc_licfee
	, myTarget.pc_other1 = mySource.pc_other1
	, myTarget.pc_other2 = mySource.pc_other2
	, myTarget.tax_rate_a = mySource.tax_rate_a
	, myTarget.tax_rate_b = mySource.tax_rate_b
	, myTarget.tax_rate_c = mySource.tax_rate_c

	, myTarget.orig_acct_rep_id = mySource.orig_acct_rep_id 
	, myTarget.ticket_seq_id = mySource.ticket_seq_id

	, myTarget.ssbPriceCode = mySource.ssbPriceCode
	, myTarget.ssbIsHost = mySource.ssbIsHost

WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT (event_name, section_name, row_name, num_seats, ticket_status, acct_id, upd_datetime, seq_num, block_purchase_price, order_num, order_line_item, order_line_item_seq, info, total_events, price_code, pricing_method, comp_code, comp_name, Paid, disc_code, disc_amount, surchg_code, surchg_amount, group_flag, upd_user, class_name, sell_location, full_price, purchase_price, sales_source_name, sales_source_date, Ticket_Type, Price_code_desc, event_id, plan_event_id, plan_event_name, seat_num, last_Seat, other_info_1, other_info_2, other_info_3, other_info_4, other_info_5, other_info_6, other_info_7, other_info_8, other_info_9, other_info_10, acct_Rep_id, acct_rep_full_name, tran_type, section_id, row_id, promo_code, retail_ticket_type, retail_qualifiers, paid_amount, owed_amount, add_datetime, add_user, renewal_ind, InsertDate, UpdateDate, SourceFileName, HashKey, ssbPriceCode, ssbIsHost, return_reason, return_reason_desc, expanded, delivery_method, delivery_method_name, delivery_instructions, delivery_name_first, delivery_name_last, delivery_addr1, delivery_addr2, delivery_addr3, delivery_city, delivery_state, delivery_zip, delivery_zip_formatted, delivery_country, delivery_phone, delivery_phone_formatted, delivered_date, group_sales_name, ledger_id, pc_ticket, pc_tax, pc_licfee, pc_other1, pc_other2, tax_rate_a, tax_rate_b, tax_rate_c, orig_acct_rep_id, ticket_seq_id)
VALUES (

	mySource.event_name
	, mySource.section_name
	, mySource.row_name
	, mySource.num_seats
	, mySource.ticket_status
	, mySource.acct_id
	, mySource.upd_datetime
	, mySource.seq_num
	, mySource.block_purchase_price
	, mySource.order_num
	, mySource.order_line_item
	, mySource.order_line_item_seq
	, mySource.info
	, mySource.total_events
	, mySource.price_code
	, mySource.pricing_method
	, mySource.comp_code
	, mySource.comp_name
	, mySource.Paid
	, mySource.disc_code
	, mySource.disc_amount
	, mySource.surchg_code
	, mySource.surchg_amount
	, mySource.group_flag
	, mySource.upd_user
	, mySource.class_name
	, mySource.sell_location
	, mySource.full_price
	, mySource.purchase_price
	, mySource.sales_source_name
	, mySource.sales_source_date
	, mySource.Ticket_Type
	, mySource.Price_code_desc
	, mySource.event_id
	, mySource.plan_event_id
	, mySource.plan_event_name
	, mySource.seat_num
	, mySource.last_Seat
	, mySource.other_info_1
	, mySource.other_info_2
	, mySource.other_info_3
	, mySource.other_info_4
	, mySource.other_info_5
	, mySource.other_info_6
	, mySource.other_info_7
	, mySource.other_info_8
	, mySource.other_info_9
	, mySource.other_info_10
	, mySource.acct_Rep_id
	, mySource.acct_rep_full_name
	, mySource.tran_type
	, mySource.section_id
	, mySource.row_id
	, mySource.promo_code
	, mySource.retail_ticket_type
	, mySource.retail_qualifiers
	, mySource.paid_amount
	, mySource.owed_amount
	, mySource.add_datetime
	, mySource.add_user
	, mySource.renewal_ind

	, @RunTime
	, @RunTime		
	, mySource.SourceFileName
	, mySource.HashKey

	, mySource.ssbPriceCode
	, mySource.ssbIsHost
	
	, mySource.return_reason
	, mySource.return_reason_desc
	, mySource.expanded
	, mySource.delivery_method
	, mySource.delivery_method_name
	, mySource.delivery_instructions
	, mySource.delivery_name_first
	, mySource.delivery_name_last
	, mySource.delivery_addr1
	, mySource.delivery_addr2
	, mySource.delivery_addr3
	, mySource.delivery_city
	, mySource.delivery_state
	, mySource.delivery_zip
	, mySource.delivery_zip_formatted
	, mySource.delivery_country
	, mySource.delivery_phone
	, mySource.delivery_phone_formatted
	, mySource.delivered_date
	, mySource.group_sales_name

	, mySource.ledger_id
	, mySource.pc_ticket
	, mySource.pc_tax
	, mySource.pc_licfee
	, mySource.pc_other1
	, mySource.pc_other2
	, mySource.tax_rate_a
	, mySource.tax_rate_b
	, mySource.tax_rate_c

	, mySource.orig_acct_rep_id
	, mySource.ticket_seq_id
) ;




MERGE ods.TM_Tkt as myTarget

USING (SELECT * FROM src.vw_TM_Tkt_Returns) AS mySource ON 

	mySource.event_id = myTarget.event_id 
	AND mySource.section_id = myTarget.section_id 
	AND mySource.row_id = myTarget.row_id
	AND mySource.seat_num = myTarget.seat_num 
	AND mySource.ticket_status = myTarget.ticket_status 
	AND mySource.acct_id = myTarget.acct_id 
	AND mySource.upd_datetime = myTarget.upd_datetime 

WHEN MATCHED AND @DisableUpdate <> 'true' AND mySource.HashKey <> myTarget.HashKey
THEN UPDATE SET

	myTarget.UpdateDate = @RunTime
	, myTarget.HashKey = mySource.HashKey

	, myTarget.event_name = mySource.event_name
	, myTarget.section_name = mySource.section_name
	, myTarget.row_name = mySource.row_name
	, myTarget.num_seats = mySource.num_seats
	, myTarget.ticket_status = mySource.ticket_status
	, myTarget.acct_id = mySource.acct_id
	, myTarget.upd_datetime = mySource.upd_datetime
	, myTarget.seq_num = mySource.seq_num
	, myTarget.block_purchase_price = mySource.block_purchase_price
	, myTarget.order_num = mySource.order_num
	, myTarget.order_line_item = mySource.order_line_item
	, myTarget.order_line_item_seq = mySource.order_line_item_seq
	, myTarget.info = mySource.info
	, myTarget.total_events = mySource.total_events
	, myTarget.price_code = mySource.price_code
	, myTarget.pricing_method = mySource.pricing_method
	, myTarget.comp_code = mySource.comp_code
	, myTarget.comp_name = mySource.comp_name
	, myTarget.Paid = mySource.Paid
	, myTarget.disc_code = mySource.disc_code
	, myTarget.disc_amount = mySource.disc_amount
	, myTarget.surchg_code = mySource.surchg_code
	, myTarget.surchg_amount = mySource.surchg_amount
	, myTarget.group_flag = mySource.group_flag
	, myTarget.upd_user = mySource.upd_user
	, myTarget.class_name = mySource.class_name
	, myTarget.sell_location = mySource.sell_location
	, myTarget.full_price = mySource.full_price
	, myTarget.purchase_price = mySource.purchase_price
	, myTarget.sales_source_name = mySource.sales_source_name
	, myTarget.sales_source_date = mySource.sales_source_date
	, myTarget.Ticket_Type = mySource.Ticket_Type
	, myTarget.Price_code_desc = mySource.Price_code_desc
	, myTarget.event_id = mySource.event_id
	, myTarget.plan_event_id = mySource.plan_event_id
	, myTarget.plan_event_name = mySource.plan_event_name
	, myTarget.seat_num = mySource.seat_num
	, myTarget.last_Seat = mySource.last_Seat
	, myTarget.other_info_1 = mySource.other_info_1
	, myTarget.other_info_2 = mySource.other_info_2
	, myTarget.other_info_3 = mySource.other_info_3
	, myTarget.other_info_4 = mySource.other_info_4
	, myTarget.other_info_5 = mySource.other_info_5
	, myTarget.other_info_6 = mySource.other_info_6
	, myTarget.other_info_7 = mySource.other_info_7
	, myTarget.other_info_8 = mySource.other_info_8
	, myTarget.other_info_9 = mySource.other_info_9
	, myTarget.other_info_10 = mySource.other_info_10
	, myTarget.acct_Rep_id = mySource.acct_Rep_id
	, myTarget.acct_rep_full_name = mySource.acct_rep_full_name
	, myTarget.tran_type = mySource.tran_type
	, myTarget.section_id = mySource.section_id
	, myTarget.row_id = mySource.row_id
	, myTarget.promo_code = mySource.promo_code
	, myTarget.retail_ticket_type = mySource.retail_ticket_type
	, myTarget.retail_qualifiers = mySource.retail_qualifiers
	, myTarget.paid_amount = mySource.paid_amount
	, myTarget.owed_amount = mySource.owed_amount
	, myTarget.add_datetime = mySource.add_datetime
	, myTarget.add_user = mySource.add_user
	, myTarget.renewal_ind = mySource.renewal_ind
	, myTarget.SourceFileName = mySource.SourceFileName
	, myTarget.return_reason = mySource.return_reason
	, myTarget.return_reason_desc = mySource.return_reason_desc
	, myTarget.expanded = mySource.expanded
	, myTarget.delivery_method = mySource.delivery_method
	, myTarget.delivery_method_name = mySource.delivery_method_name
	, myTarget.delivery_instructions = mySource.delivery_instructions
	, myTarget.delivery_name_first = mySource.delivery_name_first
	, myTarget.delivery_name_last = mySource.delivery_name_last
	, myTarget.delivery_addr1 = mySource.delivery_addr1
	, myTarget.delivery_addr2 = mySource.delivery_addr2
	, myTarget.delivery_addr3 = mySource.delivery_addr3
	, myTarget.delivery_city = mySource.delivery_city
	, myTarget.delivery_state = mySource.delivery_state
	, myTarget.delivery_zip = mySource.delivery_zip
	, myTarget.delivery_zip_formatted = mySource.delivery_zip_formatted
	, myTarget.delivery_country = mySource.delivery_country
	, myTarget.delivery_phone = mySource.delivery_phone
	, myTarget.delivery_phone_formatted = mySource.delivery_phone_formatted
	, myTarget.delivered_date = mySource.delivered_date
	, myTarget.group_sales_name = mySource.group_sales_name

	, myTarget.ledger_id = mySource.ledger_id
	, myTarget.pc_ticket = mySource.pc_ticket
	, myTarget.pc_tax = mySource.pc_tax
	, myTarget.pc_licfee = mySource.pc_licfee
	, myTarget.pc_other1 = mySource.pc_other1
	, myTarget.pc_other2 = mySource.pc_other2
	, myTarget.tax_rate_a = mySource.tax_rate_a
	, myTarget.tax_rate_b = mySource.tax_rate_b
	, myTarget.tax_rate_c = mySource.tax_rate_c

	, myTarget.orig_acct_rep_id = mySource.orig_acct_rep_id 
	, myTarget.ticket_seq_id = mySource.ticket_seq_id

	, myTarget.ssbPriceCode = mySource.ssbPriceCode
	, myTarget.ssbIsHost = mySource.ssbIsHost

WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT (event_name, section_name, row_name, num_seats, ticket_status, acct_id, upd_datetime, seq_num, block_purchase_price, order_num, order_line_item, order_line_item_seq, info, total_events, price_code, pricing_method, comp_code, comp_name, Paid, disc_code, disc_amount, surchg_code, surchg_amount, group_flag, upd_user, class_name, sell_location, full_price, purchase_price, sales_source_name, sales_source_date, Ticket_Type, Price_code_desc, event_id, plan_event_id, plan_event_name, seat_num, last_Seat, other_info_1, other_info_2, other_info_3, other_info_4, other_info_5, other_info_6, other_info_7, other_info_8, other_info_9, other_info_10, acct_Rep_id, acct_rep_full_name, tran_type, section_id, row_id, promo_code, retail_ticket_type, retail_qualifiers, paid_amount, owed_amount, add_datetime, add_user, renewal_ind, InsertDate, UpdateDate, SourceFileName, HashKey, ssbPriceCode, ssbIsHost, return_reason, return_reason_desc, expanded, delivery_method, delivery_method_name, delivery_instructions, delivery_name_first, delivery_name_last, delivery_addr1, delivery_addr2, delivery_addr3, delivery_city, delivery_state, delivery_zip, delivery_zip_formatted, delivery_country, delivery_phone, delivery_phone_formatted, delivered_date, group_sales_name, ledger_id, pc_ticket, pc_tax, pc_licfee, pc_other1, pc_other2, tax_rate_a, tax_rate_b, tax_rate_c, orig_acct_rep_id, ticket_seq_id)
VALUES (

	mySource.event_name
	, mySource.section_name
	, mySource.row_name
	, mySource.num_seats
	, mySource.ticket_status
	, mySource.acct_id
	, mySource.upd_datetime
	, mySource.seq_num
	, mySource.block_purchase_price
	, mySource.order_num
	, mySource.order_line_item
	, mySource.order_line_item_seq
	, mySource.info
	, mySource.total_events
	, mySource.price_code
	, mySource.pricing_method
	, mySource.comp_code
	, mySource.comp_name
	, mySource.Paid
	, mySource.disc_code
	, mySource.disc_amount
	, mySource.surchg_code
	, mySource.surchg_amount
	, mySource.group_flag
	, mySource.upd_user
	, mySource.class_name
	, mySource.sell_location
	, mySource.full_price
	, mySource.purchase_price
	, mySource.sales_source_name
	, mySource.sales_source_date
	, mySource.Ticket_Type
	, mySource.Price_code_desc
	, mySource.event_id
	, mySource.plan_event_id
	, mySource.plan_event_name
	, mySource.seat_num
	, mySource.last_Seat
	, mySource.other_info_1
	, mySource.other_info_2
	, mySource.other_info_3
	, mySource.other_info_4
	, mySource.other_info_5
	, mySource.other_info_6
	, mySource.other_info_7
	, mySource.other_info_8
	, mySource.other_info_9
	, mySource.other_info_10
	, mySource.acct_Rep_id
	, mySource.acct_rep_full_name
	, mySource.tran_type
	, mySource.section_id
	, mySource.row_id
	, mySource.promo_code
	, mySource.retail_ticket_type
	, mySource.retail_qualifiers
	, mySource.paid_amount
	, mySource.owed_amount
	, mySource.add_datetime
	, mySource.add_user
	, mySource.renewal_ind

	, @RunTime
	, @RunTime		
	, mySource.SourceFileName
	, mySource.HashKey

	, mySource.ssbPriceCode
	, mySource.ssbIsHost
	
	, mySource.return_reason
	, mySource.return_reason_desc
	, mySource.expanded
	, mySource.delivery_method
	, mySource.delivery_method_name
	, mySource.delivery_instructions
	, mySource.delivery_name_first
	, mySource.delivery_name_last
	, mySource.delivery_addr1
	, mySource.delivery_addr2
	, mySource.delivery_addr3
	, mySource.delivery_city
	, mySource.delivery_state
	, mySource.delivery_zip
	, mySource.delivery_zip_formatted
	, mySource.delivery_country
	, mySource.delivery_phone
	, mySource.delivery_phone_formatted
	, mySource.delivered_date
	, mySource.group_sales_name

	, mySource.ledger_id
	, mySource.pc_ticket
	, mySource.pc_tax
	, mySource.pc_licfee
	, mySource.pc_other1
	, mySource.pc_other2
	, mySource.tax_rate_a
	, mySource.tax_rate_b
	, mySource.tax_rate_c

	, mySource.orig_acct_rep_id
	, mySource.ticket_seq_id

) ;


	END TRY

	BEGIN CATCH 
		/*Log Error*/
		if (@LogLevel >= 1)
		begin 
			DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
			DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
			DECLARE @ErrorState INT = ERROR_STATE();
			
			if (@LogLevel >= 1)
			begin
				EXEC etl.LogEventRecord @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
			end 
			if (@LogLevel >= 3)
			begin 
				EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Complete', 'Completed Merge Load', @ExecutionId
			END

			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

		END
	END CATCH

	if (@LogLevel >= 3)
	begin 
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Complete', 'Completed Merge Load', @ExecutionId
	END

END



GO
