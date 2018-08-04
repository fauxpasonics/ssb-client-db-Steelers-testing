SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadManifestSeat]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_ManifestSeat),'0');	

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

MERGE ods.TM_ManifestSeat AS target
USING 
(SELECT [arena_id]
      ,[manifest_id]
      ,[section_id]
      ,[section_name]
      ,[section_desc]
      ,[section_type]
      ,[section_type_name]
      ,[gate]
      ,[ga]
      ,[row_id]
      ,[row_name]
      ,[row_desc]
      ,[seat_num]
      ,[num_seats]
      ,[last_seat]
      ,[seat_increment]
      ,[default_class]
      ,[class_name]
      ,[def_price_code]
      ,[tm_section_name]
      ,[tm_row_name]
      ,[section_info1]
      ,[section_info2]
      ,[section_info3]
      ,[section_info4]
      ,[section_info5]
      ,[row_info1]
      ,[row_info2]
      ,[row_info3]
      ,[row_info4]
      ,[row_info5]
      ,[manifest_name]
      ,[arena_name]
      ,[org_id]
      ,[org_name]
	  ,[SourceFileName]
      ,[SrcHashKey]
  FROM [src].[vw_TM_ManifestSeat]
  WHERE MergeRank = 1
)
source
     ON source.[arena_id] = target.[arena_id]
    AND source.[manifest_id] = target.[manifest_id]
    AND source.[section_id] = target.[section_id]
    AND source.[row_id] = target.[row_id]
    AND source.[seat_num] = target.[seat_num]
WHEN MATCHED AND @DisableUpdate <> 'true' AND source.SrcHashKey <> target.HashKey and 
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET 
    [section_name] = source.[section_name],
    [section_desc] = source.[section_desc],
    [section_type] = source.[section_type],
    [section_type_name] = source.[section_type_name],
    [gate] = source.[gate],
    [ga] = source.[ga],
    [row_name] = source.[row_name],
    [row_desc] = source.[row_desc],
    [num_seats] = source.[num_seats],
    [last_seat] = source.[last_seat],
    [seat_increment] = source.[seat_increment],
    [default_class] = source.[default_class],
    [class_name] = source.[class_name],
    [def_price_code] = source.[def_price_code],
    [tm_section_name] = source.[tm_section_name],
    [tm_row_name] = source.[tm_row_name],
    [section_info1] = source.[section_info1],
    [section_info2] = source.[section_info2],
    [section_info3] = source.[section_info3],
    [section_info4] = source.[section_info4],
    [section_info5] = source.[section_info5],
    [row_info1] = source.[row_info1],
    [row_info2] = source.[row_info2],
    [row_info3] = source.[row_info3],
    [row_info4] = source.[row_info4],
    [row_info5] = source.[row_info5],
    [manifest_name] = source.[manifest_name],
    [arena_name] = source.[arena_name],
    [org_id] = source.[org_id],
    [org_name] = source.[org_name],
	[SourceFileName]			= source.[SourceFileName],
	[UpdateDate]				= @RunTime,
    [HashKey] = source.[SrcHashKey]
WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT
    (
        [arena_id], 
        [manifest_id], 
        [section_id], 
        [row_id], 
        [seat_num], 
        [section_name], 
        [section_desc], 
        [section_type], 
        [section_type_name], 
        [gate], 
        [ga], 
        [row_name], 
        [row_desc], 
        [num_seats], 
        [last_seat], 
        [seat_increment], 
        [default_class], 
        [class_name], 
        [def_price_code], 
        [tm_section_name], 
        [tm_row_name], 
        [section_info1], 
        [section_info2], 
        [section_info3], 
        [section_info4], 
        [section_info5], 
        [row_info1], 
        [row_info2], 
        [row_info3], 
        [row_info4], 
        [row_info5], 
        [manifest_name], 
        [arena_name], 
        [org_id], 
        [org_name], 
		[SourceFileName],
	  [InsertDate],
	  [UpdateDate],	  
        [HashKey]
    )
    VALUES (
        source.[arena_id], 
        source.[manifest_id], 
        source.[section_id], 
        source.[row_id], 
        source.[seat_num], 
        source.[section_name], 
        source.[section_desc], 
        source.[section_type], 
        source.[section_type_name], 
        source.[gate], 
        source.[ga], 
        source.[row_name], 
        source.[row_desc], 
        source.[num_seats], 
        source.[last_seat], 
        source.[seat_increment], 
        source.[default_class], 
        source.[class_name], 
        source.[def_price_code], 
        source.[tm_section_name], 
        source.[tm_row_name], 
        source.[section_info1], 
        source.[section_info2], 
        source.[section_info3], 
        source.[section_info4], 
        source.[section_info5], 
        source.[row_info1], 
        source.[row_info2], 
        source.[row_info3], 
        source.[row_info4], 
        source.[row_info5], 
        source.[manifest_name], 
        source.[arena_name], 
        source.[org_id], 
        source.[org_name], 
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
