SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadEvnt]
(
	@BatchId bigint = 0,
	@Options nvarchar(MAX) = null
)
as
BEGIN

--SET NOCOUNT ON;
	/*
	Log Level value optionally specified in the @Options parameter, if not provided set to 3
	Log Level 1 = Error Logging, 2 = Error + Warnings, 3 = Error + Warnings + Info, 0 = None(use for dev only)

	Optionally can disable merge crud options with true value for (DisableInsert, DisableUpdate, DisableDelete)
	*/
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_Evnt),'0');	

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

	MERGE ods.TM_Evnt AS target
	USING 
	(SELECT [event_name]
		  ,[event_date]
		  ,[event_time]
		  ,[event_day]
		  ,[Team]
		  ,[plan_abv]
		  ,[event_report_group]
		  ,[plan_Type]
		  ,[Enabled]
		  ,[Returnable]
		  ,[Min_events]
		  ,[total_events]
		  ,[FSE]
		  ,[Dsps_allowed]
		  ,[exchange_price_opt]
		  ,[Season_name]
		  ,[event_name_long]
		  ,[Tm_event_name]
		  ,[Event_sort]
		  ,[Game_Numbe]
		  ,[Barcode_Status]
		  ,[Print_Ticket_Ind]
		  ,[Add_date]
		  ,[Upd_user]
		  ,[Upd_date]
		  ,[Event_id]
		  ,[MaxEventDate]
		  ,[Event_Type]
		  ,[Arena_name]
		  ,[Major_Category]
		  ,[Minor_Category]
		  ,[Org_Name]
		  ,[Plan]
		  ,[Season_id]
		  ,[SourceFileName]
		  ,[SrcHashKey]
	  FROM [src].[vw_TM_Evnt]
	  WHERE MergeRank = 1
	)
	 Source
		 ON source.[Event_id] = Target.[Event_id]
	WHEN MATCHED AND @DisableUpdate = 'false' AND source.SrcHashKey <> target.HashKey and 
		LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
			LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
	THEN UPDATE SET 
		[event_name] = source.[event_name],
		[event_date] = source.[event_date],
		[event_time] = source.[event_time],
		[event_day] = source.[event_day],
		[Team] = source.[Team],
		[plan_abv] = source.[plan_abv],
		[event_report_group] = source.[event_report_group],
		[plan_Type] = source.[plan_Type],
		[Enabled] = source.[Enabled],
		[Returnable] = source.[Returnable],
		[Min_events] = source.[Min_events],
		[total_events] = source.[total_events],
		[FSE] = source.[FSE],
		[Dsps_allowed] = source.[Dsps_allowed],
		[exchange_price_opt] = source.[exchange_price_opt],
		[Season_name] = source.[Season_name],
		[event_name_long] = source.[event_name_long],
		[Tm_event_name] = source.[Tm_event_name],
		[Event_sort] = source.[Event_sort],
		[Game_Numbe] = source.[Game_Numbe],
		[Barcode_Status] = source.[Barcode_Status],
		[Print_Ticket_Ind] = source.[Print_Ticket_Ind],
		[Add_date] = source.[Add_date],
		[Upd_user] = source.[Upd_user],
		[Upd_date] = source.[Upd_date],
		[MaxEventDate] = source.[MaxEventDate],
		[Event_Type] = source.[Event_Type],
		[Arena_name] = source.[Arena_name],
		[Major_Category] = source.[Major_Category],
		[Minor_Category] = source.[Minor_Category],
		[Org_Name] = source.[Org_Name],
		[Plan] = source.[Plan],
		[Season_id] = source.[Season_id],
		[SourceFileName]			= source.[SourceFileName],
		[UpdateDate]				= @RunTime,
		[HashKey] = source.[SrcHashKey]
	WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
	INSERT
		(
			[Event_id], 
			[event_name], 
			[event_date], 
			[event_time], 
			[event_day], 
			[Team],
			[plan_abv], 
			[event_report_group], 
			[plan_Type],
			[Enabled], 
			[Returnable], 
			[Min_events], 
			[total_events], 
			[FSE], 
			[Dsps_allowed], 
			[exchange_price_opt], 
			[Season_name], 
			[event_name_long], 
			[Tm_event_name], 
			[Event_sort], 
			[Game_Numbe], 
			[Barcode_Status], 
			[Print_Ticket_Ind], 
			[Add_date], 
			[Upd_user], 
			[Upd_date], 
			[MaxEventDate], 
			[Event_Type], 
			[Arena_name], 
			[Major_Category], 
			[Minor_Category], 
			[Org_Name], 
			[Plan],
			[Season_id],
			[SourceFileName],
		  [InsertDate],
		  [UpdateDate],	  
			[HashKey]
		)
		VALUES (
			source.[Event_id], 
			source.[event_name], 
			source.[event_date], 
			source.[event_time], 
			source.[event_day], 
			source.[Team], 
			source.[plan_abv],
			source.[event_report_group], 
			source.[plan_Type],
			source.[Enabled], 
			source.[Returnable], 
			source.[Min_events], 
			source.[total_events], 
			source.[FSE], 
			source.[Dsps_allowed], 
			source.[exchange_price_opt], 
			source.[Season_name], 
			source.[event_name_long], 
			source.[Tm_event_name], 
			source.[Event_sort], 
			source.[Game_Numbe], 
			source.[Barcode_Status], 
			source.[Print_Ticket_Ind], 
			source.[Add_date], 
			source.[Upd_user], 
			source.[Upd_date], 
			source.[MaxEventDate], 
			source.[Event_Type], 
			source.[Arena_name], 
			source.[Major_Category], 
			source.[Minor_Category], 
			source.[Org_Name], 
			source.[Plan],
			source.[Season_id],
			source.[SourceFileName],
		  @RunTime,
		  @RunTime,
			source.[SrcHashKey]
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
