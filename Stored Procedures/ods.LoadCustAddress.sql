SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadCustAddress]
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

MERGE ods.TM_CustAddress AS myTarget

USING (SELECT * FROM [src].[vw_TM_CustAddress]) mySource

     ON mySource.[acct_id] = myTarget.[acct_id]
	 AND mySource.[cust_name_id] = myTarget.[cust_name_id]
	 AND mySource.[cust_address_id] = myTarget.[cust_address_id]

WHEN MATCHED AND @DisableUpdate = 'false' AND mySource.HashKey <> myTarget.HashKey

THEN UPDATE SET 

	myTarget.UpdateDate = @RunTime
	, myTarget.HashKey = mySource.HashKey

	, myTarget.cust_name_id = mySource.cust_name_id
	, myTarget.cust_address_id = mySource.cust_address_id
	, myTarget.address_type = mySource.address_type
	, myTarget.address_type_name = mySource.address_type_name
	, myTarget.acct_id = mySource.acct_id
	, myTarget.primary_ind = mySource.primary_ind
	, myTarget.street_addr_1 = mySource.street_addr_1
	, myTarget.street_addr_2 = mySource.street_addr_2
	, myTarget.city = mySource.city
	, myTarget.state = mySource.state
	, myTarget.zip = mySource.zip
	, myTarget.country = mySource.country
	, myTarget.county = mySource.county
	, myTarget.solicit_mail = mySource.solicit_mail
	, myTarget.solicit_mail_registry = mySource.solicit_mail_registry
	, myTarget.carrier_route = mySource.carrier_route
	, myTarget.seasonal = mySource.seasonal
	, myTarget.start_date = mySource.start_date
	, myTarget.end_date = mySource.end_date
	, myTarget.city_state_zip = mySource.city_state_zip
	, myTarget.name_prefix = mySource.name_prefix
	, myTarget.name_prefix2 = mySource.name_prefix2
	, myTarget.name_first = mySource.name_first
	, myTarget.name_middle = mySource.name_middle
	, myTarget.name_last = mySource.name_last
	, myTarget.name_suffix = mySource.name_suffix
	, myTarget.name_title = mySource.name_title
	, myTarget.company_name = mySource.company_name
	, myTarget.nick_name = mySource.nick_name
	, myTarget.maiden_name = mySource.maiden_name
	, myTarget.salutation = mySource.salutation
	, myTarget.name_last_first_mi = mySource.name_last_first_mi
	, myTarget.full_name = mySource.full_name
	, myTarget.primary_code = mySource.primary_code
	, myTarget.address_type_primary_ind = mySource.address_type_primary_ind
	, myTarget.name_type = mySource.name_type
	, myTarget.owner_name = mySource.owner_name
	, myTarget.owner_name_full = mySource.owner_name_full
	, myTarget.SourceFileName = mySource.SourceFileName





WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT (cust_name_id, cust_address_id, address_type, address_type_name, acct_id, primary_ind, street_addr_1, street_addr_2, city, state, zip, country, county, solicit_mail, solicit_mail_registry, carrier_route, seasonal, start_date, end_date, city_state_zip, name_prefix, name_prefix2, name_first, name_middle, name_last, name_suffix, name_title, company_name, nick_name, maiden_name, salutation, name_last_first_mi, full_name, primary_code, address_type_primary_ind, name_type, owner_name, owner_name_full, InsertDate, UpdateDate, SourceFileName, HashKey)
    VALUES (
		
		mySource.cust_name_id
		, mySource.cust_address_id
		, mySource.address_type
		, mySource.address_type_name
		, mySource.acct_id
		, mySource.primary_ind
		, mySource.street_addr_1
		, mySource.street_addr_2
		, mySource.city
		, mySource.state
		, mySource.zip
		, mySource.country
		, mySource.county
		, mySource.solicit_mail
		, mySource.solicit_mail_registry
		, mySource.carrier_route
		, mySource.seasonal
		, mySource.start_date
		, mySource.end_date
		, mySource.city_state_zip
		, mySource.name_prefix
		, mySource.name_prefix2
		, mySource.name_first
		, mySource.name_middle
		, mySource.name_last
		, mySource.name_suffix
		, mySource.name_title
		, mySource.company_name
		, mySource.nick_name
		, mySource.maiden_name
		, mySource.salutation
		, mySource.name_last_first_mi
		, mySource.full_name
		, mySource.primary_code
		, mySource.address_type_primary_ind
		, mySource.name_type
		, mySource.owner_name
		, mySource.owner_name_full
	
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
