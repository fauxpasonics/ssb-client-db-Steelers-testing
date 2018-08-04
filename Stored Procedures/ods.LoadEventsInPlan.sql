SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadEventsInPlan]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_EventsInPlan),'0');	

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

MERGE ods.TM_EventsInPlan AS target
USING 
(
    SELECT [plan_group_id]
          ,[plan_group_name]
      ,[plan_event_id]
      ,[plan_event_name]
      ,[plan_total_events]
      ,[plan_type]
      ,[event_id]
      ,[event_name]
      ,[event_Date]
      ,[event_time]
      ,[team]
      ,[game_number]
      ,[total_events]
      ,[tm_event_name]
      ,[child_is_plan]
      ,[season_id]
	  ,[SourceFileName]
      ,[SrcHashKey]
  FROM [src].[vw_TM_EventsInPlan]
  WHERE MergeRank = 1
) as source

     ON source.[plan_group_id] = target.[plan_group_id]
    AND source.[plan_event_id] = target.[plan_event_id]
    AND source.[event_id] = target.[event_id]
    AND source.[season_id] = target.[season_id]
WHEN MATCHED AND @DisableUpdate <> 'true' AND source.SrcHashKey <> target.HashKey and 
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET 
    [plan_group_name] = source.[plan_group_name],
    [plan_event_name] = source.[plan_event_name],
    [plan_total_events] = source.[plan_total_events],
    [plan_type] = source.[plan_type],
    [event_name] = source.[event_name],
    [event_Date] = source.[event_Date],
    [event_time] = source.[event_time],
    [team] = source.[team],
    [game_number] = source.[game_number],
    [total_events] = source.[total_events],
    [tm_event_name] = source.[tm_event_name],
    [child_is_plan] = source.[child_is_plan],
	[SourceFileName]			= source.[SourceFileName],
	[UpdateDate]				= @RunTime,
    [HashKey] = source.[SrcHashKey]
WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT
    (
        [plan_group_id], 
        [plan_event_id], 
        [event_id], 
        [season_id], 
        [plan_group_name], 
        [plan_event_name], 
        [plan_total_events], 
        [plan_type], 
        [event_name], 
        [event_Date], 
        [event_time], 
        [team], 
        [game_number], 
        [total_events], 
        [tm_event_name], 
        [child_is_plan], 
		[SourceFileName],
	  [InsertDate],
	  [UpdateDate],	  
        [HashKey]
    )
    VALUES (
        source.[plan_group_id], 
        source.[plan_event_id], 
        source.[event_id], 
       source.[season_id], 
        source.[plan_group_name], 
        source.[plan_event_name], 
       source.[plan_total_events], 
        source.[plan_type], 
        source.[event_name], 
        source.[event_Date], 
        source.[event_time], 
        source.[team], 
        source.[game_number], 
        source.[total_events], 
       source.[tm_event_name], 
        source.[child_is_plan],
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
