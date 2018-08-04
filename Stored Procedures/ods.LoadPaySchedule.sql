SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[LoadPaySchedule]
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

	UPDATE src.TM_PaySchedule
	SET start_date = NULL
	WHERE start_date = ''

MERGE ods.TM_PaySchedule AS myTarget

USING (SELECT * FROM [src].[vw_TM_PaySchedule]) mySource

     ON mySource.payment_Schedule_id = myTarget.payment_Schedule_id
	 
WHEN MATCHED AND @DisableUpdate = 'false' AND mySource.HashKey <> myTarget.HashKey

THEN UPDATE SET 

	myTarget.UpdateDate = @RunTime
	, myTarget.HashKey = mySource.HashKey

	, myTarget.acct_id = mySource.acct_id
	, myTarget.payment_schedule_id = mySource.payment_schedule_id
	, myTarget.invoice_id = mySource.invoice_id
	, myTarget.payment_plan_id = mySource.payment_plan_id
	, myTarget.comments = mySource.comments
	, myTarget.add_user = mySource.add_user
	, myTarget.add_datetime = mySource.add_datetime
	, myTarget.payment_plan_name = mySource.payment_plan_name
	, myTarget.periods = mySource.periods
	, myTarget.last_period_paid = mySource.last_period_paid
	, myTarget.purchase_amount = mySource.purchase_amount
	, myTarget.paid_amount = mySource.paid_amount
	, myTarget.percent_due = mySource.percent_due
	, myTarget.percent_paid = mySource.percent_paid
	, myTarget.compliant = mySource.compliant
	, myTarget.invoice_desc = mySource.invoice_desc
	, myTarget.effective_Date = mySource.effective_Date
	, myTarget.expiration_date = mySource.expiration_date
	, myTarget.inet_effective_Date = mySource.inet_effective_Date
	, myTarget.inet_expiration_Date = mySource.inet_expiration_Date
	, myTarget.inet_plan_name = mySource.inet_plan_name
	, myTarget.payment_plan_type = mySource.payment_plan_type
	, myTarget.last_payment_number = mySource.last_payment_number
	, myTarget.period_type = mySource.period_type
	, myTarget.start_date = mySource.start_date
	, myTarget.SourceFileName = mySource.SourceFileName
	

WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT (acct_id, payment_schedule_id, invoice_id, payment_plan_id, comments, add_user, add_datetime, payment_plan_name, periods, last_period_paid, purchase_amount, paid_amount, percent_due, percent_paid, compliant, invoice_desc, effective_Date, expiration_date, inet_effective_Date, inet_expiration_Date, inet_plan_name, payment_plan_type, last_payment_number, period_type, start_date, InsertDate, UpdateDate, SourceFileName, HashKey)
    VALUES (

		mySource.acct_id
		, mySource.payment_schedule_id
		, mySource.invoice_id
		, mySource.payment_plan_id
		, mySource.comments
		, mySource.add_user
		, mySource.add_datetime
		, mySource.payment_plan_name
		, mySource.periods
		, mySource.last_period_paid
		, mySource.purchase_amount
		, mySource.paid_amount
		, mySource.percent_due
		, mySource.percent_paid
		, mySource.compliant
		, mySource.invoice_desc
		, mySource.effective_Date
		, mySource.expiration_date
		, mySource.inet_effective_Date
		, mySource.inet_expiration_Date
		, mySource.inet_plan_name
		, mySource.payment_plan_type
		, mySource.last_payment_number
		, mySource.period_type
		, mySource.start_date
			
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
