SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadRetailEvent]
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
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Start', 'Starting Merge Load', @ExecutionId
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
	END	

	/*Put all merge logic inside of try block*/
	BEGIN TRY

	DECLARE @RunTime datetime = GETDATE();

MERGE ods.TM_RetailEvent AS myTarget

USING (SELECT * FROM [src].[vw_TM_RetailEvent]) mySource

     ON mySource.[retail_event_id] = myTarget.[retail_event_id]

WHEN MATCHED AND @DisableUpdate = 'false' AND mySource.HashKey <> myTarget.HashKey

THEN UPDATE SET 

	myTarget.UpdateDate = @RunTime
	, myTarget.HashKey = mySource.HashKey

	, myTarget.retail_event_id = mySource.retail_event_id
	, myTarget.[host_name] = mySource.[host_name]
	, myTarget.host_event_code = mySource.host_event_code
	, myTarget.host_event_id = mySource.host_event_id
	, myTarget.event_date = mySource.event_date
	, myTarget.event_time = mySource.event_time
	, myTarget.attraction_id = mySource.attraction_id
	, myTarget.attraction_name = mySource.attraction_name
	, myTarget.major_category_id = mySource.major_category_id
	, myTarget.major_category_name = mySource.major_category_name
	, myTarget.minor_category_id = mySource.minor_category_id
	, myTarget.minor_category_name = mySource.minor_category_name
	, myTarget.venue_id = mySource.venue_id
	, myTarget.venue_name = mySource.venue_name
	, myTarget.primary_act_id = mySource.primary_act_id
	, myTarget.primary_act = mySource.primary_act
	, myTarget.secondary_act_id = mySource.secondary_act_id
	, myTarget.secondary_act = mySource.secondary_act
	, myTarget.SourceFileName = mySource.SourceFileName



WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT (retail_event_id, [host_name], host_event_code, host_event_id, event_date, event_time, attraction_id, attraction_name, major_category_id, major_category_name, minor_category_id, minor_category_name, venue_id, venue_name, primary_act_id, primary_act, secondary_act_id, secondary_act, InsertDate, UpdateDate, SourceFileName, HashKey)
    VALUES (

		mySource.retail_event_id
		, mySource.[host_name]
		, mySource.host_event_code
		, mySource.host_event_id
		, mySource.event_date
		, mySource.event_time
		, mySource.attraction_id
		, mySource.attraction_name
		, mySource.major_category_id
		, mySource.major_category_name
		, mySource.minor_category_id
		, mySource.minor_category_name
		, mySource.venue_id
		, mySource.venue_name
		, mySource.primary_act_id
		, mySource.primary_act
		, mySource.secondary_act_id
		, mySource.secondary_act

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
