SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadAttend]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_Attend),'0');	

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


MERGE [ods].[TM_Attend] AS target
USING (
    SELECT [acct_id]
          ,[event_id]
      ,[section_id]
      ,[row_id]
      ,[seat_num]
      ,[scan_date]
      ,[scan_time]
      ,[gate]
	  ,[barcode]
	  ,[SourceFileName]
      ,[SrcHashKey]
  FROM [src].[vw_TM_Attend]
  where MergeRank = 1
) Source
     ON source.[event_id] = Target.[event_id]
    AND source.[section_id] = Target.[section_id]
    AND source.[row_id] = Target.[row_id]
    AND source.[seat_num] = Target.[seat_num]
WHEN MATCHED AND @DisableUpdate <> 'true' AND source.SrcHashKey <> target.HashKey --and 
	--LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
	--	LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET 
    [acct_id] = Source.[acct_id],
    [scan_date] = Source.[scan_date],
    [scan_time] = Source.[scan_time],
    [gate] = Source.[gate],
	[barcode] = Source.[barcode],
	[SourceFileName]			= source.[SourceFileName],
	[UpdateDate]				= @RunTime,
    [HashKey] = Source.[SrcHashKey]
WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
	INSERT
    (
        [event_id], 
        [section_id], 
        [row_id], 
        [seat_num], 
        [acct_id], 
        [scan_date], 
        [scan_time], 
        [gate], 
		[barcode],
		[SourceFileName],
	  [InsertDate],
	  [UpdateDate],
        [HashKey]
    )
    VALUES (
        source.[event_id], 
        source.[section_id], 
        source.[row_id], 
        source.[seat_num], 
        source.[acct_id], 
        source.[scan_date], 
        source.[scan_time], 
        source.[gate], 
		Source.[barcode],
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
