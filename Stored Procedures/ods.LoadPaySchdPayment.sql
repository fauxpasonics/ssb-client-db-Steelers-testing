SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[LoadPaySchdPayment]
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

MERGE ods.TM_PaySchdPayment AS myTarget

USING (SELECT * FROM [src].[vw_TM_PaySchdPayment]) mySource

     ON mySource.payment_Schedule_id = myTarget.payment_Schedule_id
	 AND mySource.payment_number = myTarget.payment_number
	 
WHEN MATCHED AND @DisableUpdate = 'false' AND mySource.HashKey <> myTarget.HashKey

THEN UPDATE SET 

	myTarget.UpdateDate = @RunTime
	, myTarget.HashKey = mySource.HashKey

	, myTarget.payment_Schedule_id = mySource.payment_Schedule_id
	, myTarget.payment_number = mySource.payment_number
	, myTarget.due_date = mySource.due_date
	, myTarget.percent_due = mySource.percent_due
	, myTarget.payment_description = mySource.payment_description	
	, myTarget.SourceFileName = mySource.SourceFileName
	

WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT (payment_Schedule_id, payment_number, due_date, percent_due, payment_description, InsertDate, UpdateDate, SourceFileName, HashKey)
    VALUES (

		mySource.payment_Schedule_id
		, mySource.payment_number
		, mySource.due_date
		, mySource.percent_due
		, mySource.payment_description
			
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
