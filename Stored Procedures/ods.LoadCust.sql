SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[LoadCust]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_Cust),'0');	

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

MERGE ods.TM_Cust as TARGET
USING (
SELECT [acct_id]
      ,[cust_name_id]
      ,[Relationship_type]
      ,[Primary_code]
      ,[rec_status]
      ,[acct_type_desc]
      ,[salutation]
      ,[company_name]
      ,[name_first]
      ,[name_mi]
      ,[name_last]
      ,[name_title]
      ,[street_addr_1]
      ,[street_addr_2]
      ,[city]
      ,[state]
      ,[zip]
      ,[country]
      ,[phone_day]
      ,[phone_eve]
      ,[phone_fax]
      ,[Tag]
      ,[acct_rep_num]
      ,[acct_rep_name]
      ,[priority]
      ,[points]
      ,[points_ytd]
      ,[points_itd]
      ,[email_addr]
      ,[add_date]
      ,[add_user]
      ,[upd_date]
      ,[upd_user]
      ,[birth_date]
      ,[Since_date]
      ,[old_acct_id]
      ,[household_id]
      ,[fan_loyalty_id]
      ,[ext_system1_id]
      ,[ext_system2_id]
      ,[other_info_1]
      ,[other_info_2]
      ,[other_info_3]
      ,[other_info_4]
      ,[other_info_5]
      ,[other_info_6]
      ,[other_info_7]
      ,[other_info_8]
      ,[other_info_9]
      ,[other_info_10]
      ,[source]
      ,[source_name]
      ,[source_desc]
      ,[pin]
      ,[gender]
      ,[solicit_phone_day]
      ,[Solicit_phone_eve]
      ,[solicit_phone_fax]
      ,[Solicit_email]
      ,[solicit_addr]
      ,[marital_Status]
      ,[Sic_Code]
      ,[Sic_Name]
      ,[Industry]
      ,[phone_cell]
      ,[solicit_phone_cell]
      ,[email_addr2]
      ,[Source_list_name]
      ,[Maiden_Name]
	  ,[SourceFileName]
	  ,[name_type] 
	  ,[SrcHashKey] as HashKey
FROM src.vw_TM_Cust
where MergeRank = 1
) as SOURCE ON source.acct_id = target.acct_id and SOURCE.cust_name_id = TARGET.cust_name_id

WHEN MATCHED AND @DisableUpdate <> 'true' AND source.HashKey <> target.HashKey and 
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET 
	   target.[acct_id]				= source.[acct_id]
      ,target.[cust_name_id]		= source.[cust_name_id]
      ,target.[Relationship_type]	= source.[Relationship_type]
      ,target.[Primary_code]		= source.[Primary_code]
      ,target.[rec_status]			= source.[rec_status]
      ,target.[acct_type_desc]		= source.[acct_type_desc]
      ,target.[salutation]			= source.[salutation]
      ,target.[company_name]		= source.[company_name]
      ,target.[name_first]			= source.[name_first]
      ,target.[name_mi]				= source.[name_mi]
      ,target.[name_last]			= source.[name_last]
      ,target.[name_title]			= source.[name_title]
      ,target.[street_addr_1]		= source.[street_addr_1]
      ,target.[street_addr_2]		= source.[street_addr_2]
      ,target.[city]				= source.[city]	
      ,target.[state]				= source.[state]
      ,target.[zip]					= source.[zip]
      ,target.[country]				= source.[country]
      ,target.[phone_day]			= source.[phone_day]
      ,target.[phone_eve]			= source.[phone_eve]
      ,target.[phone_fax]			= source.[phone_fax]
      ,target.[Tag]					= source.[Tag]
      ,target.[acct_rep_num]		= source.[acct_rep_num]
      ,target.[acct_rep_name]		= source.[acct_rep_name]
      ,target.[priority]			= source.[priority]
      ,target.[points]				= source.[points]
      ,target.[points_ytd]			= source.[points_ytd]
      ,target.[points_itd]			= source.[points_itd]
      ,target.[email_addr]			= source.[email_addr]
      ,target.[add_date]			= source.[add_date]
      ,target.[add_user]			= source.[add_user]
      ,target.[upd_date]			= source.[upd_date]
      ,target.[upd_user]			= source.[upd_user]
      ,target.[birth_date]			= source.[birth_date]
      ,target.[Since_date]			= source.[Since_date]
      ,target.[old_acct_id]			= source.[old_acct_id]
      ,target.[household_id]		= source.[household_id]
      ,target.[fan_loyalty_id]		= source.[fan_loyalty_id]
      ,target.[ext_system1_id]		= source.[ext_system1_id]
      ,target.[ext_system2_id]		= source.[ext_system2_id]
      ,target.[other_info_1]		= source.[other_info_1]
      ,target.[other_info_2]		= source.[other_info_2]
      ,target.[other_info_3]		= source.[other_info_3]
      ,target.[other_info_4]		= source.[other_info_4]
      ,target.[other_info_5]		= source.[other_info_5]
      ,target.[other_info_6]		= source.[other_info_6]
      ,target.[other_info_7]		= source.[other_info_7]
      ,target.[other_info_8]		= source.[other_info_8]
      ,target.[other_info_9]		= source.[other_info_9]
      ,target.[other_info_10]		= source.[other_info_10]
      ,target.[source]				= source.[source]
      ,target.[source_name]			= source.[source_name]
      ,target.[source_desc]			= source.[source_desc]
      ,target.[pin]					= source.[pin]
      ,target.[gender]				= source.[gender]
      ,target.[solicit_phone_day]	= source.[solicit_phone_day]
      ,target.[Solicit_phone_eve]	= source.[Solicit_phone_eve]
      ,target.[solicit_phone_fax]	= source.[solicit_phone_fax]
      ,target.[Solicit_email]		= source.[Solicit_email]
      ,target.[solicit_addr]		= source.[solicit_addr]
      ,target.[marital_Status]		= source.[marital_Status]
      ,target.[Sic_Code]			= source.[Sic_Code]
      ,target.[Sic_Name]			= source.[Sic_Name]
      ,target.[Industry]			= source.[Industry]
      ,target.[phone_cell]			= source.[phone_cell]
      ,target.[solicit_phone_cell]	= source.[solicit_phone_cell]
      ,target.[email_addr2]			= source.[email_addr2]
      ,target.[Source_list_name]	= source.[Source_list_name]
      ,target.[Maiden_Name]			= source.[Maiden_Name]
	  ,target.[SourceFileName]		= source.[SourceFileName]
	  ,target.[UpdateDate]			= @RunTime
	  ,target.[HashKey]				= source.[HashKey]
	  ,target.[name_type]			= source.[name_type]

WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT
(	   [acct_id]
      ,[cust_name_id]
      ,[Relationship_type]
      ,[Primary_code]
      ,[rec_status]
      ,[acct_type_desc]
      ,[salutation]
      ,[company_name]
      ,[name_first]
      ,[name_mi]
      ,[name_last]
      ,[name_title]
      ,[street_addr_1]
      ,[street_addr_2]
      ,[city]
      ,[state]
      ,[zip]
      ,[country]
      ,[phone_day]
      ,[phone_eve]
      ,[phone_fax]
      ,[Tag]
      ,[acct_rep_num]
      ,[acct_rep_name]
      ,[priority]
      ,[points]
      ,[points_ytd]
      ,[points_itd]
      ,[email_addr]
      ,[add_date]
      ,[add_user]
      ,[upd_date]
      ,[upd_user]
      ,[birth_date]
      ,[Since_date]
      ,[old_acct_id]
      ,[household_id]
      ,[fan_loyalty_id]
      ,[ext_system1_id]
      ,[ext_system2_id]
      ,[other_info_1]
      ,[other_info_2]
      ,[other_info_3]
      ,[other_info_4]
      ,[other_info_5]
      ,[other_info_6]
      ,[other_info_7]
      ,[other_info_8]
      ,[other_info_9]
      ,[other_info_10]
      ,[source]
      ,[source_name]
      ,[source_desc]
      ,[pin]
      ,[gender]
      ,[solicit_phone_day]
      ,[Solicit_phone_eve]
      ,[solicit_phone_fax]
      ,[Solicit_email]
      ,[solicit_addr]
      ,[marital_Status]
      ,[Sic_Code]
      ,[Sic_Name]
      ,[Industry]
      ,[phone_cell]
      ,[solicit_phone_cell]
      ,[email_addr2]
      ,[Source_list_name]
      ,[Maiden_Name]
	  ,[SourceFileName]
	  ,[InsertDate]
	  ,[UpdateDate]
	  ,[HashKey] 
	  ,[name_type]
	  )
VALUES
(	   source.[acct_id]
      ,source.[cust_name_id]
      ,source.[Relationship_type]
      ,source.[Primary_code]
      ,source.[rec_status]
      ,source.[acct_type_desc]
      ,source.[salutation]
      ,source.[company_name]
      ,source.[name_first]
      ,source.[name_mi]
      ,source.[name_last]
      ,source.[name_title]
      ,source.[street_addr_1]
      ,source.[street_addr_2]
      ,source.[city]
      ,source.[state]
      ,source.[zip]
      ,source.[country]
      ,source.[phone_day]
      ,source.[phone_eve]
      ,source.[phone_fax]
      ,source.[Tag]
      ,source.[acct_rep_num]
      ,source.[acct_rep_name]
      ,source.[priority]
      ,source.[points]
      ,source.[points_ytd]
      ,source.[points_itd]
      ,source.[email_addr]
      ,source.[add_date]
      ,source.[add_user]
      ,source.[upd_date]
      ,source.[upd_user]
      ,source.[birth_date]
      ,source.[Since_date]
      ,source.[old_acct_id]
      ,source.[household_id]
      ,source.[fan_loyalty_id]
      ,source.[ext_system1_id]
      ,source.[ext_system2_id]
      ,source.[other_info_1]
      ,source.[other_info_2]
      ,source.[other_info_3]
      ,source.[other_info_4]
      ,source.[other_info_5]
      ,source.[other_info_6]
      ,source.[other_info_7]
      ,source.[other_info_8]
      ,source.[other_info_9]
      ,source.[other_info_10]
      ,source.[source]
      ,source.[source_name]
      ,source.[source_desc]
      ,source.[pin]
      ,source.[gender]
      ,source.[solicit_phone_day]
      ,source.[Solicit_phone_eve]
      ,source.[solicit_phone_fax]
      ,source.[Solicit_email]
      ,source.[solicit_addr]
      ,source.[marital_Status]
      ,source.[Sic_Code]
      ,source.[Sic_Name]
      ,source.[Industry]
      ,source.[phone_cell]
      ,source.[solicit_phone_cell]
      ,source.[email_addr2]
      ,source.[Source_list_name]
      ,source.[Maiden_Name]
	  ,source.[SourceFileName]
	  ,@RunTime
	  ,@RunTime
	  ,source.[HashKey]
	  ,source.name_type
) ;

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
