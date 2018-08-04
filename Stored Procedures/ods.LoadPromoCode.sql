SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadPromoCode]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_PromoCode),'0');	

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

MERGE ods.TM_PromoCode AS target
USING
(SELECT [promo_code_id]
      ,[promo_code]
      ,[promo_code_name]
      ,[acct_id]
      ,[promo_inet_name]
      ,[promo_inet_desc]
      ,[promo_type]
      ,[promo_group_sell_flag]
      ,[promo_active_flag]
      ,[add_user]
      ,[inet_start_datetime]
      ,[inet_end_datetime]
      ,[archtics_start_datetime]
      ,[archtics_end_datetime]
      ,[event_id]
      ,[event_name]
      ,[tm_event_name]
      ,[add_Datetime]
      ,[upd_datetime]
      ,[SourceFileName]
	  ,[SrcHashKey]
  FROM [src].[vw_TM_PromoCode]
  WHERE MergeRank = 1
) as Source
     ON source.[promo_code_id] = target.[promo_code_id] and source.event_id = target.event_id

WHEN MATCHED AND @DisableUpdate <> 'true' AND source.SrcHashKey <> target.HashKey and 
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET 
    [promo_code] = Source.[promo_code],
    [promo_code_name] = Source.[promo_code_name],
    [acct_id] = Source.[acct_id],
    [promo_inet_name] = Source.[promo_inet_name],
    [promo_inet_desc] = Source.[promo_inet_desc],
    [promo_type] = Source.[promo_type],
    [promo_group_sell_flag] = Source.[promo_group_sell_flag],
    [promo_active_flag] = Source.[promo_active_flag],
    [add_user] = Source.[add_user],
    [inet_start_datetime] = Source.[inet_start_datetime],
    [inet_end_datetime] = Source.[inet_end_datetime],
    [archtics_start_datetime] = Source.[archtics_start_datetime],
    [archtics_end_datetime] = Source.[archtics_end_datetime],
    [event_id] = Source.[event_id],
    [event_name] = Source.[event_name],
    [tm_event_name] = Source.[tm_event_name],
    [add_Datetime] = Source.[add_Datetime],
    [upd_datetime] = Source.[upd_datetime],
	[SourceFileName]			= source.[SourceFileName],
	[UpdateDate]				= @RunTime,	  
    [HashKey] = Source.[SrcHashKey]
WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT
    (
        [promo_code_id], 
        [promo_code], 
        [promo_code_name], 
        [acct_id], 
        [promo_inet_name], 
        [promo_inet_desc], 
        [promo_type], 
        [promo_group_sell_flag], 
        [promo_active_flag], 
        [add_user], 
        [inet_start_datetime], 
        [inet_end_datetime], 
        [archtics_start_datetime], 
        [archtics_end_datetime], 
        [event_id], 
        [event_name], 
        [tm_event_name], 
        [add_Datetime], 
        [upd_datetime],
		[SourceFileName],
	  [InsertDate],
	  [UpdateDate], 
        [HashKey]
    )
    VALUES (
        source.[promo_code_id], 
        source.[promo_code], 
        source.[promo_code_name], 
        source.[acct_id], 
        source.[promo_inet_name], 
        source.[promo_inet_desc], 
        source.[promo_type], 
        source.[promo_group_sell_flag], 
        source.[promo_active_flag], 
        source.[add_user], 
        source.[inet_start_datetime], 
        source.[inet_end_datetime], 
        source.[archtics_start_datetime], 
        source.[archtics_end_datetime], 
        source.[event_id], 
        source.[event_name], 
        source.[tm_event_name], 
        source.[add_Datetime], 
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
