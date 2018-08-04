SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[LoadJournal]
(
	@BatchId bigint = 0,
	@Options nvarchar(MAX) = null
)
as
BEGIN

	/*
	Log Level value optionally specified in the @Options parameter, if not provided set to 3
	Log Level 1 = Error Logging, 2 = Error + Warnings, 3 = Error + Warnings + Info, 0 = None(use for dev only)

	Optionally can disable merge crud options with true value for (DisableInsert, DisableUpdate, DisableDelete)
	*/
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_Journal),'0');	

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


	if (@LogLevel >= 3)
	begin 
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Start', 'Starting Merge Load', @ExecutionId
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
	END	

	/*Put all merge logic inside of try block*/
	BEGIN TRY

	DECLARE @RunTime datetime = GETDATE();

MERGE ods.TM_Journal as myTarget

USING (SELECT * FROM src.vw_TM_Journal) as mySource ON 

	mySource.[journal_Seq_id] = myTarget.[journal_Seq_id]

WHEN MATCHED AND @DisableUpdate <> 'true' AND mySource.HashKey <> myTarget.HashKey
	
THEN UPDATE SET 

	myTarget.UpdateDate = @RunTime
	, myTarget.HashKey = mySource.HashKey

	, myTarget.acct_id = mySource.acct_id
	, myTarget.stamp = mySource.stamp
	, myTarget.seq = mySource.seq
	, myTarget.type = mySource.type
	, myTarget.type_desc = mySource.type_desc
	, myTarget.debit = mySource.debit
	, myTarget.credit = mySource.credit
	, myTarget.invoice_amount = mySource.invoice_amount
	, myTarget.event_id = mySource.event_id
	, myTarget.order_num = mySource.order_num
	, myTarget.order_line_item = mySource.order_line_item
	, myTarget.order_line_item_seq = mySource.order_line_item_seq
	, myTarget.cc_type = mySource.cc_type
	, myTarget.payment_type_desc = mySource.payment_type_desc
	, myTarget.payment_schedule_id = mySource.payment_schedule_id
	, myTarget.invoice_id = mySource.invoice_id
	, myTarget.journal_Seq_id = mySource.journal_Seq_id
	, myTarget.add_user = mySource.add_user
	, myTarget.upd_user = mySource.upd_user
	, myTarget.SourceFileName = mySource.SourceFileName
	, myTarget.credit_applied = mySource.credit_applied
	, myTarget.batch_tag = mySource.batch_tag
	, myTarget.batch_id = mySource.batch_id
	, myTarget.cc_num_masked = mySource.cc_num_masked
	, myTarget.surchg_amount = mySource.surchg_amount
	, myTarget.surchg_code = mySource.surchg_code
	, myTarget.disc_amount = mySource.disc_amount
	, myTarget.disc_code = mySource.disc_code
	, myTarget.ledger_code = mySource.ledger_code
	, myTarget.merchant_code = mySource.merchant_code
	, myTarget.plan_event_name = mySource.plan_event_name
	, myTarget.event_name = mySource.event_name
	, myTarget.section_name = mySource.section_name
	, myTarget.row_name = mySource.row_name
	, myTarget.seat_num = mySource.seat_num
	, myTarget.last_seat = mySource.last_seat
	, myTarget.sell_location = mySource.sell_location
	, myTarget.info = mySource.info
	, myTarget.posted_date = mySource.posted_date

WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT (acct_id, stamp, seq, type, type_desc, debit, credit, invoice_amount, event_id, order_num, order_line_item, order_line_item_seq, cc_type, payment_type_desc, payment_schedule_id, invoice_id, journal_Seq_id, add_user, upd_user, InsertDate, UpdateDate, SourceFileName, HashKey, credit_applied, batch_tag, batch_id, cc_num_masked, surchg_amount, surchg_code, disc_amount, disc_code, ledger_code, merchant_code, plan_event_name, event_name, section_name, row_name, seat_num, last_seat, sell_location, info, posted_date)
VALUES
(	  

		mySource.acct_id
		, mySource.stamp
		, mySource.seq
		, mySource.type
		, mySource.type_desc
		, mySource.debit
		, mySource.credit
		, mySource.invoice_amount
		, mySource.event_id
		, mySource.order_num
		, mySource.order_line_item
		, mySource.order_line_item_seq
		, mySource.cc_type
		, mySource.payment_type_desc
		, mySource.payment_schedule_id
		, mySource.invoice_id
		, mySource.journal_Seq_id
		, mySource.add_user
		, mySource.upd_user

		, @RunTime
		, @RunTime		
		, mySource.SourceFileName
		, mySource.[HashKey]
		
		, mySource.credit_applied
		, mySource.batch_tag
		, mySource.batch_id
		, mySource.cc_num_masked
		, mySource.surchg_amount
		, mySource.surchg_code
		, mySource.disc_amount
		, mySource.disc_code
		, mySource.ledger_code
		, mySource.merchant_code
		, mySource.plan_event_name
		, mySource.event_name
		, mySource.section_name
		, mySource.row_name
		, mySource.seat_num
		, mySource.last_seat
		, mySource.sell_location
		, mySource.info
		, mySource.posted_date

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
