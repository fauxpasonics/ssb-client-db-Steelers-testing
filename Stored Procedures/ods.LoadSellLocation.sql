SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadSellLocation]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_SellLocation),'0');	

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

MERGE ods.TM_SellLocation AS target
USING (
    
    SELECT [sell_location_id]
      ,[sell_location_code]
      ,[sell_location_name]
      ,[sell_location_desc]
      ,[outlet_code]
      ,[org_id]
      ,[active]
      ,[protected]
      ,[sort_order]
      ,[add_user]
      ,[add_datetime]
      ,[upd_user]
      ,[upd_datetime]
	  ,[SourceFileName]
      ,[SrcHashKey]
  FROM [src].[vw_TM_SellLocation]
  WHERE MergeRank = 1
) as Source
     ON source.[sell_location_id] = Target.[sell_location_id]
WHEN MATCHED AND @DisableUpdate <> 'true' AND source.SrcHashKey <> target.HashKey and 
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET 
    [sell_location_code] = Source.[sell_location_code],
    [sell_location_name] = Source.[sell_location_name],
    [sell_location_desc] = Source.[sell_location_desc],
    [outlet_code] = Source.[outlet_code],
    [org_id] = Source.[org_id],
    [active] = Source.[active],
    [protected] = Source.[protected],
    [sort_order] = Source.[sort_order],
    [add_user] = Source.[add_user],
    [add_datetime] = Source.[add_datetime],
    [upd_user] = Source.[upd_user],
    [upd_datetime] = Source.[upd_datetime],
	[SourceFileName]			= source.[SourceFileName],
	[UpdateDate]				= @RunTime,	
    [HashKey] = Source.[SrcHashKey]
WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT
    (
        [sell_location_id], 
        [sell_location_code], 
        [sell_location_name], 
        [sell_location_desc], 
        [outlet_code], 
        [org_id], 
        [active], 
        [protected], 
        [sort_order], 
        [add_user], 
        [add_datetime], 
        [upd_user], 
        [upd_datetime], 
		[SourceFileName],
	  [InsertDate],
	  [UpdateDate],
        [HashKey]
    )
    VALUES (
        source.[sell_location_id], 
        source.[sell_location_code], 
        source.[sell_location_name], 
        source.[sell_location_desc], 
        source.[outlet_code], 
        source.[org_id], 
        source.[active], 
        source.[protected], 
        source.[sort_order], 
        source.[add_user], 
        source.[add_datetime], 
        source.[upd_user], 
        source.[upd_datetime],
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
