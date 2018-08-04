SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadCustRep]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_CustRep),'0');	

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


delete o
from ods.tm_custrep o
inner join src.tm_custrep s on o.acct_id = s.acct_id



MERGE ods.TM_CustRep AS target

USING 
(
	SELECT acct_id, acct_rep_id, acct_rep_type, acct_rep_type_name, rep_cust_name_id, rep_name_first, rep_name_middle, rep_name_last, rep_name_title, rep_company_name, rep_nick_name, rep_name_last_first_mi, rep_full_name, rep_user_id, rep_email_addr, rep_phone, rep_phone_formatted, SourceFileName, SrcHashKey
	FROM [src].[vw_TM_CustRep]
	WHERE MergeRank = 1
) source
     
	 ON source.[acct_id] = Target.[acct_id] and source.acct_rep_id = target.acct_rep_id and source.acct_rep_type = target.acct_rep_type

WHEN MATCHED AND @DisableUpdate <> 'true' AND source.SrcHashKey <> target.HashKey and 
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET 
target.acct_id  = source.acct_id, 
target.acct_rep_id  = source.acct_rep_id, 
target.acct_rep_type  = source.acct_rep_type, 
target.acct_rep_type_name  = source.acct_rep_type_name, 
target.rep_cust_name_id  = source.rep_cust_name_id, 
target.rep_name_first  = source.rep_name_first, 
target.rep_name_middle  = source.rep_name_middle, 
target.rep_name_last  = source.rep_name_last, 
target.rep_name_title  = source.rep_name_title, 
target.rep_company_name  = source.rep_company_name, 
target.rep_nick_name  = source.rep_nick_name, 
target.rep_name_last_first_mi = source.rep_name_last_first_mi, 
target.rep_full_name  = source.rep_full_name, 
target.rep_user_id  = source.rep_user_id, 
target.rep_email_addr  = source.rep_email_addr, 
target.rep_phone  = source.rep_phone, 
target.rep_phone_formatted  = source.rep_phone_formatted, 
target.SourceFileName  = source.SourceFileName, 
target.HashKey = source.SrcHashKey,

target.UpdatedDate = @RunTime
    
WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN 
INSERT
(
	acct_id, acct_rep_id, acct_rep_type, acct_rep_type_name, rep_cust_name_id, rep_name_first, rep_name_middle, rep_name_last, rep_name_title, rep_company_name, rep_nick_name, rep_name_last_first_mi, rep_full_name, rep_user_id, rep_email_addr, rep_phone, rep_phone_formatted, InsertDate, UpdatedDate, SourceFileName, HashKey
)
    VALUES (
		source.acct_id 
		, source.acct_rep_id 
		, source.acct_rep_type 
		, source.acct_rep_type_name 
		, source.rep_cust_name_id 
		, source.rep_name_first 
		, source.rep_name_middle 
		, source.rep_name_last 
		, source.rep_name_title 
		, source.rep_company_name 
		, source.rep_nick_name 
		, source.rep_name_last_first_mi 
		, source.rep_full_name 
		, source.rep_user_id 
		, source.rep_email_addr 
		, source.rep_phone 
		, source.rep_phone_formatted 
		, @RunTime
		, @RunTime
		, source.SourceFileName 
		, source.SrcHashKey

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
