SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadTex]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_Tex),'0');	

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

MERGE ods.TM_Tex AS target
USING 
(
    SELECT [event_name]
        ,[section_name]
      ,[row_name]
      ,[event_date]
      ,[event_time]
      ,[seat_num]
      ,[num_seats]
      ,[last_seat]
      ,[seat_increment]
      ,[event_id]
      ,[section_id]
      ,[row_id]
      ,[owner_acct_id]
      ,[Company_name]
      ,[Owner_name]
      ,[Orig_purchase_price]
      ,[order_num]
      ,[order_line_item]
      ,[order_line_item_seq]
      ,[plan_event_id]
      ,[plan_event_name]
      ,[add_datetime]
      ,[add_user]
      ,[assoc_acct_id]
      ,[forward_to_name]
      ,[forward_to_email_addr]
      ,[te_seller_credit_amount]
      ,[te_seller_fees]
      ,[te_posting_price]
      ,[te_buyer_fees_hidden]
      ,[te_purchase_price]
      ,[te_buyer_fees_not_hidden]
      ,[inet_delivery_fee]
      ,[inet_transaction_amount]
      ,[delivery_method]
      ,[activity]
      ,[activity_name]
      ,[season_name]
      ,[season_id]
      ,[season_year]
      ,[org_id]
      ,[org_name]
	  ,[SourceFileName]
      ,[SrcHashKey]
  FROM [src].[vw_TM_Tex]
  WHERE MergeRank = 1
) as source
     ON source.event_id = target.event_id
    AND source.section_id = target.section_id
    AND source.row_id = target.row_id
    AND source.season_id = target.season_id
    AND source.seat_num = target.seat_num
    AND source.num_seats = target.num_seats
    AND source.add_datetime = target.add_datetime
WHEN MATCHED AND @DisableUpdate <> 'true' AND source.SrcHashKey <> target.HashKey and 
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET
    [event_name] = source.[event_name],
    [section_name] = source.[section_name],
    [row_name] = source.[row_name],
    [event_date] = source.[event_date],
    [event_time] = source.[event_time],
    [last_seat] = source.[last_seat],
    [seat_increment] = source.[seat_increment],
    [owner_acct_id] = source.[owner_acct_id],
    [Company_name] = source.[Company_name],
    [Owner_name] = source.[Owner_name],
    [Orig_purchase_price] = source.[Orig_purchase_price],
    [order_num] = source.[order_num],
    [order_line_item] = source.[order_line_item],
    [order_line_item_seq] = source.[order_line_item_seq],
    [plan_event_id] = source.[plan_event_id],
    [plan_event_name] = source.[plan_event_name],
    [add_user] = source.[add_user],
    [assoc_acct_id] = source.[assoc_acct_id],
    [forward_to_name] = source.[forward_to_name],
    [forward_to_email_addr] = source.[forward_to_email_addr],
    [te_seller_credit_amount] = source.[te_seller_credit_amount],
    [te_seller_fees] = source.[te_seller_fees],
    [te_posting_price] = source.[te_posting_price],
    [te_buyer_fees_hidden] = source.[te_buyer_fees_hidden],
    [te_purchase_price] = source.[te_purchase_price],
    [te_buyer_fees_not_hidden] = source.[te_buyer_fees_not_hidden],
    [inet_delivery_fee] = source.[inet_delivery_fee],
    [inet_transaction_amount] = source.[inet_transaction_amount],
    [delivery_method] = source.[delivery_method],
    [activity] = source.[activity],
    [activity_name] = source.[activity_name],
    [season_name] = source.[season_name],
    [season_year] = source.[season_year],
    [org_id] = source.[org_id],
    [org_name] = source.[org_name],
	[SourceFileName]			= source.[SourceFileName]
	  ,[UpdateDate]				= @RunTime,
    [HashKey] = source.[SrcHashKey]
WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT
    (
        event_id, 
        section_id, 
        row_id, 
        season_id, 
        seat_num, 
        num_seats, 
        add_datetime, 
        [event_name], 
        [section_name], 
        [row_name], 
        [event_date], 
        [event_time], 
        [last_seat], 
        [seat_increment], 
        [owner_acct_id], 
        [Company_name], 
        [Owner_name], 
        [Orig_purchase_price], 
        [order_num], 
        [order_line_item], 
        [order_line_item_seq], 
        [plan_event_id], 
        [plan_event_name], 
        [add_user], 
        [assoc_acct_id], 
        [forward_to_name], 
        [forward_to_email_addr], 
        [te_seller_credit_amount], 
        [te_seller_fees], 
        [te_posting_price], 
        [te_buyer_fees_hidden], 
        [te_purchase_price], 
        [te_buyer_fees_not_hidden], 
        [inet_delivery_fee], 
        [inet_transaction_amount], 
        [delivery_method], 
        [activity], 
        [activity_name], 
        [season_name], 
        [season_year], 
        [org_id], 
        [org_name], 
		[SourceFileName]
	  ,[InsertDate]
	  ,[UpdateDate],
        [HashKey]
    )
    VALUES (
        source.event_id, 
        source.section_id, 
        source.row_id, 
        source.season_id, 
        source.seat_num, 
        source.num_seats, 
        source.add_datetime, 
        source.[event_name], 
        source.[section_name], 
        source.[row_name], 
        source.[event_date], 
        source.[event_time], 
        source.[last_seat], 
        source.[seat_increment], 
        source.[owner_acct_id], 
        source.[Company_name], 
        source.[Owner_name], 
        source.[Orig_purchase_price], 
        source.[order_num], 
        source.[order_line_item], 
        source.[order_line_item_seq], 
        source.[plan_event_id], 
        source.[plan_event_name], 
        source.[add_user], 
        source.[assoc_acct_id], 
        source.[forward_to_name], 
        source.[forward_to_email_addr], 
        source.[te_seller_credit_amount], 
        source.[te_seller_fees], 
        source.[te_posting_price], 
        source.[te_buyer_fees_hidden], 
        source.[te_purchase_price], 
        source.[te_buyer_fees_not_hidden], 
        source.[inet_delivery_fee], 
        source.[inet_transaction_amount], 
        source.[delivery_method], 
        source.[activity], 
        source.[activity_name], 
        source.[season_name], 
        source.[season_year], 
        source.[org_id], 
        source.[org_name], 
		source.[SourceFileName]
	  ,@RunTime
	  ,@RunTime,
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
