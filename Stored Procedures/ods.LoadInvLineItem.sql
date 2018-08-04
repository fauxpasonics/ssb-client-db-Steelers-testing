SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[LoadInvLineItem]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_arena),'0');	

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
		EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Start', 'Starting Merge Load', @ExecutionId
		EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
	END	

	/*Put all merge logic inside of try block*/
	BEGIN TRY

	DECLARE @RunTime datetime = GETDATE();

MERGE ods.TM_InvLineItem AS myTarget

USING (SELECT * FROM [src].[vw_TM_InvLineItem]) mySource

     ON mySource.invoice_id = myTarget.invoice_id
	 AND mySource.order_num = myTarget.order_num
	 AND mySource.order_line_item = myTarget.order_line_item
	 AND mySource.order_line_item_seq = myTarget.order_line_item_seq

WHEN MATCHED AND @DisableUpdate = 'false' AND mySource.HashKey <> myTarget.HashKey

THEN UPDATE SET 

	myTarget.UpdateDate = @RunTime
	, myTarget.HashKey = mySource.HashKey

	, myTarget.acct_id = mySource.acct_id
	, myTarget.order_num = mySource.order_num
	, myTarget.order_line_item = mySource.order_line_item
	, myTarget.order_line_item_seq = mySource.order_line_item_seq
	, myTarget.invoice_id = mySource.invoice_id
	, myTarget.amount = mySource.amount
	, myTarget.purchase_amount = mySource.purchase_amount
	, myTarget.gross_invoice_amount = mySource.gross_invoice_amount
	, myTarget.invoice_method = mySource.invoice_method
	, myTarget.item_amount = mySource.item_amount
	, myTarget.status = mySource.status
	, myTarget.required_ind = mySource.required_ind
	, myTarget.opt_out = mySource.opt_out
	, myTarget.opt_out_user = mySource.opt_out_user
	, myTarget.opt_out_datetime = mySource.opt_out_datetime
	, myTarget.SourceFileName = mySource.SourceFileName


WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT (acct_id, order_num, order_line_item, order_line_item_seq, invoice_id, amount, purchase_amount, gross_invoice_amount, invoice_method, item_amount, status, required_ind, opt_out, opt_out_user, opt_out_datetime, InsertDate, UpdateDate, SourceFileName, HashKey)
    VALUES (

		mySource.acct_id
		, mySource.order_num
		, mySource.order_line_item
		, mySource.order_line_item_seq
		, mySource.invoice_id
		, mySource.amount
		, mySource.purchase_amount
		, mySource.gross_invoice_amount
		, mySource.invoice_method
		, mySource.item_amount
		, mySource.status
		, mySource.required_ind
		, mySource.opt_out
		, mySource.opt_out_user
		, mySource.opt_out_datetime
	
		 , @RunTime
		 , @RunTime
		 , mySource.SourceFileName
		 , mySource.[HashKey]
    );

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
				EXEC etl.LogEventRecordDB @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
			end 
			if (@LogLevel >= 3)
			begin 
				EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Complete', 'Completed Merge Load', @ExecutionId
			END

			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

		END
	END CATCH

	if (@LogLevel >= 3)
	begin 
		EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Complete', 'Completed Merge Load', @ExecutionId
	END

END









GO
