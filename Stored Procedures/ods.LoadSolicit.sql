SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadSolicit]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_Solicit),'0');	

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

MERGE ods.TM_Solicit AS target
USING (SELECT 
	   [solicitation_id]
      ,[solicitation_name]
      ,[solicitation_desc]
      ,[status]
      ,[reason]
      ,[upd_user]
      ,[upd_datetime]
      ,[acct_id]
      ,[name_last]
      ,[name_last_first_mi]
      ,[email_addr]
      ,[campaign_id]
      ,[campaign_name]
      ,[drive_year]
      ,[item_id]
      ,[item_name]
      ,[list_id]
      ,[list_name]
      ,[list_count]
      ,[solicitation_goal]
      ,[solicitation_cost]
      ,[contact_type_code]
      ,[contact_type]
      ,[solicitation_category]
      ,[solicitation_category_name]
      ,[start_datetime]
      ,[end_datetime]
      ,[drop_datetime]
      ,[sent_datetime]
      ,[sent_count]
      ,[mm_email_id]
      ,[mm_cell_id]
      ,[mm_user_email]
      ,[solicitation_status]
      ,[benefits]
      ,[attachment_filename]
	  ,[SourceFileName]
      ,[SrcHashKey]
  FROM [src].[vw_TM_Solicit]
  WHERE MergeRank = 1
) as source
     ON source.[solicitation_id] = target.[solicitation_id]
WHEN MATCHED AND @DisableUpdate <> 'true' AND source.SrcHashKey <> target.HashKey and 
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET
    [solicitation_name] = source.[solicitation_name],
    [solicitation_desc] = source.[solicitation_desc],
    [status] = source.[status],
    [reason] = source.[reason],
    [upd_user] = source.[upd_user],
    [upd_datetime] = source.[upd_datetime],
    [acct_id] = source.[acct_id],
    [name_last] = source.[name_last],
    [name_last_first_mi] = source.[name_last_first_mi],
    [email_addr] = source.[email_addr],
    [campaign_id] = source.[campaign_id],
    [campaign_name] = source.[campaign_name],
    [drive_year] = source.[drive_year],
    [item_id] = source.[item_id],
    [item_name] = source.[item_name],
    [list_id] = source.[list_id],
    [list_name] = source.[list_name],
    [list_count] = source.[list_count],
    [solicitation_goal] = source.[solicitation_goal],
    [solicitation_cost] = source.[solicitation_cost],
    [contact_type_code] = source.[contact_type_code],
    [contact_type] = source.[contact_type],
    [solicitation_category] = source.[solicitation_category],
    [solicitation_category_name] = source.[solicitation_category_name],
    [start_datetime] = source.[start_datetime],
    [end_datetime] = source.[end_datetime],
    [drop_datetime] = source.[drop_datetime],
    [sent_datetime] = source.[sent_datetime],
    [sent_count] = source.[sent_count],
    [mm_email_id] = source.[mm_email_id],
    [mm_cell_id] = source.[mm_cell_id],
    [mm_user_email] = source.[mm_user_email],
    [solicitation_status] = source.[solicitation_status],
    [benefits] = source.[benefits],
    [attachment_filename] = source.[attachment_filename],
	[SourceFileName]			= source.[SourceFileName],
	  [UpdateDate]				= @RunTime,
    [HashKey] = source.[SrcHashKey]
WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT
    (   [solicitation_id], 
        [solicitation_name], 
        [solicitation_desc], 
        [status], 
        [reason], 
        [upd_user], 
        [upd_datetime], 
        [acct_id], 
        [name_last], 
        [name_last_first_mi], 
        [email_addr], 
        [campaign_id], 
        [campaign_name], 
        [drive_year], 
        [item_id], 
        [item_name], 
        [list_id], 
        [list_name], 
        [list_count], 
        [solicitation_goal], 
        [solicitation_cost], 
        [contact_type_code], 
        [contact_type], 
        [solicitation_category], 
        [solicitation_category_name], 
        [start_datetime], 
        [end_datetime], 
        [drop_datetime], 
        [sent_datetime], 
        [sent_count], 
        [mm_email_id], 
        [mm_cell_id], 
        [mm_user_email], 
        [solicitation_status], 
        [benefits], 
        [attachment_filename],
		[SourceFileName],
	[InsertDate],
	[UpdateDate], 
        [HashKey]
    )
    VALUES (
        source.[solicitation_id], 
        source.[solicitation_name], 
        source.[solicitation_desc], 
        source.[status], 
        source.[reason], 
        source.[upd_user], 
        source.[upd_datetime], 
        source.[acct_id], 
        source.[name_last], 
        source.[name_last_first_mi], 
        source.[email_addr], 
        source.[campaign_id], 
        source.[campaign_name], 
        source.[drive_year], 
        source.[item_id], 
        source.[item_name], 
        source.[list_id], 
        source.[list_name], 
        source.[list_count], 
        source.[solicitation_goal], 
        source.[solicitation_cost], 
        source.[contact_type_code], 
        source.[contact_type], 
        source.[solicitation_category], 
        source.[solicitation_category_name], 
        source.[start_datetime], 
        source.[end_datetime], 
        source.[drop_datetime], 
        source.[sent_datetime], 
        source.[sent_count], 
        source.[mm_email_id], 
        source.[mm_cell_id], 
        source.[mm_user_email], 
        source.[solicitation_status], 
        source.[benefits], 
        source.[attachment_filename],
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
