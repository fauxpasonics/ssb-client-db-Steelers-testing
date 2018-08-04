SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[LoadAudit_Export]
(
	@BatchId bigint = 0,
	@Options nvarchar(MAX) = null
)
as
BEGIN
SET NOCOUNT ON;
	/*
	Log Level value optionally specified in the @Options parameter, if not provided set to 3
	Log Level 1 = Error Logging, 2 = Error + Warnings, 3 = Error + Warnings + Info, 0 = None(use for dev only)
	*/
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_Audit_Export),'0');	

	/*Set ExecutionId to new guid to group log records together*/
	DECLARE @ExecutionId uniqueidentifier = newid();
	DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);

	/*Load Options into a temp table*/
	SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

	/*Extract Options, default values set if the option is not specified*/
	DECLARE @LogLevel int = ISNULL((SELECT TRY_PARSE(OptionValue as int) FROM #Options WHERE OptionKey = 'LogLevel'),3)

	if (@LogLevel >= 3)
	begin 
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Load', 'Start', 'Starting Load', @ExecutionId
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Load', 'Src Row Count', @SrcRowCount, @ExecutionId
	END	

	/*Put all logic inside of try block*/
	BEGIN TRY

	DECLARE @RunTime datetime = GETDATE();

	DELETE
	FROM src.TM_Audit_Export
	WHERE event_name = 'event_name'; -- included for now until headers appear at top of file

	INSERT INTO ods.TM_Audit_Export (event_name, price_code, price_code_Desc, [Plan], Single, [Group], Comp, Held
		,Avail, [Kill], Revenue, pc_price_code, AuditHostSold, AuditArchticsSold, TicketArchticsSold, TicketHostSold, TicketAvailSold
		,DiffHostSold, DiffArchticsSold, event_id, export_datetime, source_id, InsertDate, SourceFileName)
	SELECT [event_name]
		  ,[price_code]
		  ,[price_code_Desc]
		  ,[Plan]
		  ,[Single]
		  ,[Group]
		  ,[Comp]
		  ,[Held]
		  ,[Avail]
		  ,[Kill]
		  ,[Revenue]
		  ,[pc_price_code]
		  ,[AuditHostSold]
		  ,[AuditArchticsSold]
		  ,[TicketArchticsSold]
		  ,[TicketHostSold]
		  ,[TicketAvailSold]
		  ,[DiffHostSold]
		  ,[DiffArchticsSold]
		  ,[event_id]
		  ,[export_datetime]
		  ,[source_id]
		  ,@RunTime
		  ,[SourceFileName]
	  FROM [src].[vw_TM_Audit_Export]

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
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Load', 'Complete', 'Completed Load', @ExecutionId
	END

END


GO
