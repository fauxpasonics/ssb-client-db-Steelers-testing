SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadNote]
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

	Optionally can disable merge crud options with true value for (DisableInsert, DisableUpdate, DisableDelete)
	*/
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_Note),'0');	

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

MERGE ods.TM_Note AS target
USING 
(SELECT 
	   [note_id]
      ,[acct_id]
      ,[add_user]
      ,[add_datetime]
      ,[note_type]
      ,[upd_Datetime]
      ,[upd_user]
      ,[contact_category]
      ,[contact_subcategory]
      ,[contact_response]
      ,[contact_type]
      ,[task_Type]
      ,[text]
      ,[priority]
      ,[alert_id]
      ,[alert_name]
	  ,[task_stage_seq_num]
      ,[task_activity_code]
      ,[task_result_code]
      ,[task_stage_status_code]
      ,[task_activity]
      ,[task_result]
      ,[task_stage_status]
      ,[task_assigned_to_user_id]
      ,[task_assigned_to_dept_id]
      ,[task_dept_name]
      ,[task_assignee_notified]
      ,[task_duration]
      ,[task_stage_text]
      ,[task_start_date]
      ,[task_end_date]
      ,[task_probability_to_close]
      ,[task_probability_to_close_name]
	  ,[SourceFileName]
	  ,[SrcHashKey]
  FROM [src].[vw_TM_Note]
  WHERE MergeRank = 1
)
as Source
     ON source.[note_id] = Target.[note_id] and target.task_stage_seq_num = source.task_stage_seq_num
WHEN MATCHED AND @DisableUpdate <> 'true' AND (source.SrcHashKey <> target.HashKey or isnull(source.text,'') <> isnull(target.text,'') or isnull(source.task_stage_text,'') <> isnull(target.task_stage_text,'')) AND
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)


THEN UPDATE SET 
    [acct_id]				= Source.[acct_id],
    [add_user]				= Source.[add_user],
    [add_datetime]			= Source.[add_datetime],
    [note_type]				= Source.[note_type],
    [upd_Datetime]			= Source.[upd_Datetime],
    [upd_user]				= Source.[upd_user],
    [contact_category]		= Source.[contact_category],
    [contact_subcategory]	= Source.[contact_subcategory],
    [contact_response]		= Source.[contact_response],
    [contact_type]			= Source.[contact_type],
    [task_Type]				= Source.[task_Type],
    [text]					= Source.[text],
    [priority]				= Source.[priority],
    [alert_id]				= Source.[alert_id],
    [alert_name]			= Source.[alert_name],
	[task_activity_code]	= source.[task_activity_code]
      ,[task_result_code]	= source.[task_result_code]
      ,[task_stage_status_code] = source.[task_stage_status_code]
      ,[task_activity] = source.[task_activity]
      ,[task_result] = source.[task_result]
      ,[task_stage_status] = source.[task_stage_status]
      ,[task_assigned_to_user_id] = source.[task_assigned_to_user_id]
      ,[task_assigned_to_dept_id] = source.[task_assigned_to_dept_id]
      ,[task_dept_name] = source.[task_dept_name]
      ,[task_assignee_notified] = source.[task_assignee_notified]
      ,[task_duration] = source.[task_duration]
      ,[task_stage_text] = source.[task_stage_text]
      ,[task_start_date] = source.[task_start_date]
      ,[task_end_date] = source.[task_end_date]
      ,[task_probability_to_close] = source.[task_probability_to_close]
      ,[task_probability_to_close_name] = source.[task_probability_to_close_name],
	  [SourceFileName]			= source.[SourceFileName],
	[UpdateDate]				= @RunTime	 
	,[HashKey]				= Source.[SrcHashKey]

WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT
    (
        [note_id], 
        [acct_id], 
        [add_user], 
        [add_datetime], 
        [note_type], 
        [upd_Datetime], 
        [upd_user], 
        [contact_category], 
        [contact_subcategory], 
        [contact_response], 
        [contact_type], 
        [task_Type], 
        [text], 
        [priority], 
        [alert_id], 
        [alert_name],
		[task_stage_seq_num]
      ,[task_activity_code]
      ,[task_result_code]
      ,[task_stage_status_code]
      ,[task_activity]
      ,[task_result]
      ,[task_stage_status]
      ,[task_assigned_to_user_id]
      ,[task_assigned_to_dept_id]
      ,[task_dept_name]
      ,[task_assignee_notified]
      ,[task_duration]
      ,[task_stage_text]
      ,[task_start_date]
      ,[task_end_date]
      ,[task_probability_to_close]
      ,[task_probability_to_close_name],
	  [SourceFileName],
	  [InsertDate],
	  [UpdateDate],
		[HashKey]
    )
    VALUES (
        source.[note_id], 
        source.[acct_id], 
        source.[add_user], 
        source.[add_datetime], 
        source.[note_type], 
        source.[upd_Datetime], 
        source.[upd_user], 
        source.[contact_category], 
        source.[contact_subcategory], 
        source.[contact_response], 
        source.[contact_type], 
        source.[task_Type], 
        source.[text], 
        source.[priority], 
        source.[alert_id], 
        source.[alert_name],
		source.[task_stage_seq_num]
      ,source.[task_activity_code]
      ,source.[task_result_code]
      ,source.[task_stage_status_code]
      ,source.[task_activity]
      ,source.[task_result]
      ,source.[task_stage_status]
      ,source.[task_assigned_to_user_id]
      ,source.[task_assigned_to_dept_id]
      ,source.[task_dept_name]
      ,source.[task_assignee_notified]
      ,source.[task_duration]
      ,source.[task_stage_text]
      ,source.[task_start_date]
      ,source.[task_end_date]
      ,source.[task_probability_to_close]
      ,source.[task_probability_to_close_name]
	  ,source.[SourceFileName]
	  ,@RunTime
	  ,@RunTime
		,source.[SrcHashKey]

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
