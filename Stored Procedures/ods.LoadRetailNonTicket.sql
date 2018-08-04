SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadRetailNonTicket]
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

MERGE ods.TM_RetailNonTicket AS myTarget

USING (SELECT * FROM [src].[vw_TM_RetailNonTicket]) mySource

     ON mySource.retail_event_id = myTarget.retail_event_id
	 AND mySource.event_id = myTarget.event_id
	 AND mySource.event_name = myTarget.event_name
	 AND mySource.section_name = myTarget.section_name
	 AND mySource.row_name = myTarget.row_name
	 AND mySource.first_seat = myTarget.first_seat
	 AND mySource.num_seats = myTarget.num_seats
	 AND mySource.refund_flag = myTarget.refund_flag

WHEN MATCHED AND @DisableUpdate = 'false' AND mySource.HashKey <> myTarget.HashKey

THEN UPDATE SET 

	myTarget.UpdateDate = @RunTime
	, myTarget.HashKey = mySource.HashKey

	, myTarget.event_name = mySource.event_name
	, myTarget.section_name = mySource.section_name
	, myTarget.row_name = mySource.row_name
	, myTarget.first_seat = mySource.first_seat
	, myTarget.last_seat = mySource.last_seat
	, myTarget.num_seats = mySource.num_seats
	, myTarget.seat_increment = mySource.seat_increment
	, myTarget.retail_system_name = mySource.retail_system_name
	, myTarget.acct_id = mySource.acct_id
	, myTarget.retail_event_id = mySource.retail_event_id
	, myTarget.retail_acct_num = mySource.retail_acct_num
	, myTarget.retail_acct_add_date = mySource.retail_acct_add_date
	, myTarget.came_from_code = mySource.came_from_code
	, myTarget.retail_price_level = mySource.retail_price_level
	, myTarget.retail_ticket_type = mySource.retail_ticket_type
	, myTarget.retail_qualifiers = mySource.retail_qualifiers
	, myTarget.retail_purchase_price = mySource.retail_purchase_price
	, myTarget.transaction_datetime = mySource.transaction_datetime
	, myTarget.retail_opcode = mySource.retail_opcode
	, myTarget.retail_operator_type = mySource.retail_operator_type
	, myTarget.refund_flag = mySource.refund_flag
	, myTarget.add_user = mySource.add_user
	, myTarget.add_datetime = mySource.add_datetime
	, myTarget.owner_name = mySource.owner_name
	, myTarget.owner_name_full = mySource.owner_name_full
	, myTarget.retail_event_code = mySource.retail_event_code
	, myTarget.event_date = mySource.event_date
	, myTarget.event_time = mySource.event_time
	, myTarget.attraction_name = mySource.attraction_name
	, myTarget.major_category_name = mySource.major_category_name
	, myTarget.minor_category_name = mySource.minor_category_name
	, myTarget.venue_name = mySource.venue_name
	, myTarget.primary_act = mySource.primary_act
	, myTarget.secondary_act = mySource.secondary_act
	, myTarget.event_id = mySource.event_id

	, myTarget.SourceFileName = mySource.SourceFileName

WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT (event_name, section_name, row_name, first_seat, last_seat, num_seats, seat_increment, retail_system_name, acct_id, retail_event_id, retail_acct_num, retail_acct_add_date, came_from_code, retail_price_level, retail_ticket_type, retail_qualifiers, retail_purchase_price, transaction_datetime, retail_opcode, retail_operator_type, refund_flag, add_user, add_datetime, owner_name, owner_name_full, retail_event_code, event_date, event_time, attraction_name, major_category_name, minor_category_name, venue_name, primary_act, secondary_act, event_id, InsertDate, UpdateDate, SourceFileName, HashKey)
    VALUES (

		mySource.event_name
		, mySource.section_name
		, mySource.row_name
		, mySource.first_seat
		, mySource.last_seat
		, mySource.num_seats
		, mySource.seat_increment
		, mySource.retail_system_name
		, mySource.acct_id
		, mySource.retail_event_id
		, mySource.retail_acct_num
		, mySource.retail_acct_add_date
		, mySource.came_from_code
		, mySource.retail_price_level
		, mySource.retail_ticket_type
		, mySource.retail_qualifiers
		, mySource.retail_purchase_price
		, mySource.transaction_datetime
		, mySource.retail_opcode
		, mySource.retail_operator_type
		, mySource.refund_flag
		, mySource.add_user
		, mySource.add_datetime
		, mySource.owner_name
		, mySource.owner_name_full
		, mySource.retail_event_code
		, mySource.event_date
		, mySource.event_time
		, mySource.attraction_name
		, mySource.major_category_name
		, mySource.minor_category_name
		, mySource.venue_name
		, mySource.primary_act
		, mySource.secondary_act
		, mySource.event_id

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
