SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[LoadHeldSeats]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_HeldSeats),'0');	

	/*Set ExecutionId to new guid to group log records together*/
	DECLARE @ExecutionId uniqueidentifier = newid();
	DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);

	/*Load Options into a temp table*/
	SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

	/*Extract Options, default values set if the option is not specified*/
	DECLARE @LogLevel int = ISNULL((SELECT TRY_PARSE(OptionValue as int) FROM #Options WHERE OptionKey = 'LogLevel'),2)
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

MERGE ods.TM_HeldSeats AS target
USING 
(SELECT [event_id]
      ,[event_name]
      ,[section_id]
      ,[section_name]
      ,[ga]
      ,[print_section_name]
      ,[print_row_and_seat]
      ,[row_id]
      ,[row_name]
      ,[seat_num]
      ,[num_seats]
      ,[last_seat]
      ,[seat_increment]
      ,[class_id]
      ,[class_name]
      ,[class_code]
      ,[kill]
      ,[dist_status]
      ,[dist_name]
      ,[class_color]
      ,[eip_pricing]
      ,[price_code]
      ,[price_code_desc]
      ,[price_code_group]
      ,[price]
      ,[printed_price]
      ,[pc_ticket]
      ,[pc_tax]
      ,[pc_licfee]
      ,[pc_other1]
      ,[pc_other2]
      ,[tax_rate_a]
      ,[tax_rate_b]
      ,[tax_rate_c]
      ,[pc_color]
      ,[pricing_method]
      ,[block_full_price]
      ,[block_purchase_price]
      ,[orig_price_code]
      ,[comp_code]
      ,[comp_name]
      ,[disc_code]
      ,[disc_amount]
      ,[surchg_code]
      ,[surchg_amount]
      ,[direction]
      ,[quality]
      ,[attribute]
      ,[aisle]
      ,[buy]
      ,[tag]
      ,[consignment]
      ,[acct_id]
      ,[name]
      ,[group_flag]
      ,[group_sales_id]
      ,[group_sales_name]
      ,[group_sales_status]
      ,[order_num]
      ,[order_line_item]
      ,[request_line_item]
      ,[usr]
      ,[datetime]
      ,[hours_held]
      ,[rerate_surchg_on_acct_chg]
      ,[sell_location]
      ,[sales_source_id]
      ,[sales_source_date]
      ,[request_source]
      ,[plan_event_name]
      ,[plan_event_id]
      ,[plan_datetime]
      ,[season_id]
      ,[section_type]
      ,[section_sort]
      ,[row_sort]
      ,[row_index]
      ,[block_id]
      ,[config_id]
      ,[event_date]
      ,[event_time]
      ,[event_day]
      ,[event_sort]
      ,[total_events]
      ,[team]
      ,[enabled]
      ,[sellable]
      ,[event_type_code]
      ,[event_type]
      ,[fse]
      ,[tm_section_name]
      ,[tm_row_name]
      ,[tm_event_name]
      ,[gate]
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
      ,[print_ticket_ind]
      ,[sell_type]
      ,[status]
      ,[ticket_type_code]
      ,[ticket_type]
      ,[orig_event_id]
      ,[orig_event_name]
      ,[flex_plan_event_ids]
      ,[plan_type]
      ,[parent_plan_type]
      ,[acct_rep_id]
      ,[contract_id]
      ,[grouping_id]
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
      ,[prev_loc_id]
      ,[reserved_ind]
      ,[release_datetime]
      ,[hold_source]
      ,[invoice_id]
      ,[invoice_date]
      ,[invoice_due_date]
      ,[ticket_type_category]
      ,[comp_requested_b]
      ,[comp_approved_by]
      ,[comp_comment]
      ,[offer_id]
      ,[offer_name]
      ,[ledger_id]
      ,[ledger_code]
      ,[merchant_id]
      ,[merchant_code]
      ,[merchant_color]
	  ,[SourceFileName]
      ,[SrcHashKey]
  FROM [src].[vw_TM_HeldSeats]
  WHERE MergeRank = 1
) as source
     ON source.season_id = target.season_id
    AND source.event_id = target.event_id
    AND source.section_id = target.section_id
    AND source.row_id = target.row_id
    AND source.seat_num = target.seat_num
    AND source.last_seat = target.last_seat
WHEN MATCHED AND @DisableUpdate <> 'true' AND source.SrcHashKey <> target.HashKey and 
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET 
    [event_name] = source.[event_name],
    [section_name] = source.[section_name],
    [ga] = source.[ga],
    [print_section_name] = source.[print_section_name],
    [print_row_and_seat] = source.[print_row_and_seat],
    [row_name] = source.[row_name],
    [num_seats] = source.[num_seats],
    [seat_increment] = source.[seat_increment],
    [class_id] = source.[class_id],
    [class_name] = source.[class_name],
    [class_code] = source.[class_code],
    [kill] = source.[kill],
    [dist_status] = source.[dist_status],
    [dist_name] = source.[dist_name],
    [class_color] = source.[class_color],
    [eip_pricing] = source.[eip_pricing],
    [price_code] = source.[price_code],
    [price_code_desc] = source.[price_code_desc],
    [price_code_group] = source.[price_code_group],
    [price] = source.[price],
    [printed_price] = source.[printed_price],
    [pc_ticket] = source.[pc_ticket],
    [pc_tax] = source.[pc_tax],
    [pc_licfee] = source.[pc_licfee],
    [pc_other1] = source.[pc_other1],
    [pc_other2] = source.[pc_other2],
    [tax_rate_a] = source.[tax_rate_a],
    [tax_rate_b] = source.[tax_rate_b],
    [tax_rate_c] = source.[tax_rate_c],
    [pc_color] = source.[pc_color],
    [pricing_method] = source.[pricing_method],
    [block_full_price] = source.[block_full_price],
    [block_purchase_price] = source.[block_purchase_price],
    [orig_price_code] = source.[orig_price_code],
    [comp_code] = source.[comp_code],
    [comp_name] = source.[comp_name],
    [disc_code] = source.[disc_code],
    [disc_amount] = source.[disc_amount],
    [surchg_code] = source.[surchg_code],
    [surchg_amount] = source.[surchg_amount],
    [direction] = source.[direction],
    [quality] = source.[quality],
    [attribute] = source.[attribute],
    [aisle] = source.[aisle],
    [buy] = source.[buy],
    [tag] = source.[tag],
    [consignment] = source.[consignment],
    [acct_id] = source.[acct_id],
    [name] = source.[name],
    [group_flag] = source.[group_flag],
    [group_sales_id] = source.[group_sales_id],
    [group_sales_name] = source.[group_sales_name],
    [group_sales_status] = source.[group_sales_status],
    [order_num] = source.[order_num],
    [order_line_item] = source.[order_line_item],
    [request_line_item] = source.[request_line_item],
    [usr] = source.[usr],
    [datetime] = source.[datetime],
    [hours_held] = source.[hours_held],
    [rerate_surchg_on_acct_chg] = source.[rerate_surchg_on_acct_chg],
    [sell_location] = source.[sell_location],
    [sales_source_id] = source.[sales_source_id],
    [sales_source_date] = source.[sales_source_date],
    [request_source] = source.[request_source],
    [plan_event_name] = source.[plan_event_name],
    [plan_event_id] = source.[plan_event_id],
    [plan_datetime] = source.[plan_datetime],
    [section_type] = source.[section_type],
    [section_sort] = source.[section_sort],
    [row_sort] = source.[row_sort],
    [row_index] = source.[row_index],
    [block_id] = source.[block_id],
    [config_id] = source.[config_id],
    [event_date] = source.[event_date],
    [event_time] = source.[event_time],
    [event_day] = source.[event_day],
    [event_sort] = source.[event_sort],
    [total_events] = source.[total_events],
    [team] = source.[team],
    [enabled] = source.[enabled],
    [sellable] = source.[sellable],
    [event_type_code] = source.[event_type_code],
    [event_type] = source.[event_type],
    [fse] = source.[fse],
    [tm_section_name] = source.[tm_section_name],
    [tm_row_name] = source.[tm_row_name],
    [tm_event_name] = source.[tm_event_name],
    [gate] = source.[gate],
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
    [print_ticket_ind] = source.[print_ticket_ind],
    [sell_type] = source.[sell_type],
    [status] = source.[status],
    [ticket_type_code] = source.[ticket_type_code],
    [ticket_type] = source.[ticket_type],
    [orig_event_id] = source.[orig_event_id],
    [orig_event_name] = source.[orig_event_name],
    [flex_plan_event_ids] = source.[flex_plan_event_ids],
    [plan_type] = source.[plan_type],
    [parent_plan_type] = source.[parent_plan_type],
    [acct_rep_id] = source.[acct_rep_id],
    [contract_id] = source.[contract_id],
    [grouping_id] = source.[grouping_id],
    [other_info_1] = source.[other_info_1],
    [other_info_2] = source.[other_info_2],
    [other_info_3] = source.[other_info_3],
    [other_info_4] = source.[other_info_4],
    [other_info_5] = source.[other_info_5],
    [other_info_6] = source.[other_info_6],
    [other_info_7] = source.[other_info_7],
    [other_info_8] = source.[other_info_8],
    [other_info_9] = source.[other_info_9],
    [other_info_10] = source.[other_info_10],
    [prev_loc_id] = source.[prev_loc_id],
    [reserved_ind] = source.[reserved_ind],
    [release_datetime] = source.[release_datetime],
    [hold_source] = source.[hold_source],
    [invoice_id] = source.[invoice_id],
    [invoice_date] = source.[invoice_date],
    [invoice_due_date] = source.[invoice_due_date],
    [ticket_type_category] = source.[ticket_type_category],
    [comp_requested_b] = source.[comp_requested_b],
    [comp_approved_by] = source.[comp_approved_by],
    [comp_comment] = source.[comp_comment],
    [offer_id] = source.[offer_id],
    [offer_name] = source.[offer_name],
    [ledger_id] = source.[ledger_id],
    [ledger_code] = source.[ledger_code],
    [merchant_id] = source.[merchant_id],
    [merchant_code] = source.[merchant_code],
    [merchant_color] = source.[merchant_color],
	[SourceFileName]			= source.[SourceFileName],
	[UpdateDate]				= @RunTime,
    [HashKey] = source.[SrcHashKey]
WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT
    (
        season_id, 
        event_id, 
        section_id, 
        row_id, 
        seat_num, 
        last_seat, 
        [event_name], 
        [section_name], 
        [ga], 
        [print_section_name], 
        [print_row_and_seat], 
        [row_name], 
        [num_seats], 
        [seat_increment], 
        [class_id], 
        [class_name], 
        [class_code], 
        [kill], 
        [dist_status], 
        [dist_name], 
        [class_color], 
        [eip_pricing], 
        [price_code], 
        [price_code_desc], 
        [price_code_group], 
        [price], 
        [printed_price], 
        [pc_ticket], 
        [pc_tax], 
        [pc_licfee], 
        [pc_other1], 
        [pc_other2], 
        [tax_rate_a], 
        [tax_rate_b], 
        [tax_rate_c], 
        [pc_color], 
        [pricing_method], 
        [block_full_price], 
        [block_purchase_price], 
        [orig_price_code], 
        [comp_code], 
        [comp_name], 
        [disc_code], 
        [disc_amount], 
        [surchg_code], 
        [surchg_amount], 
        [direction], 
        [quality], 
        [attribute], 
        [aisle], 
        [buy], 
        [tag], 
        [consignment], 
        [acct_id], 
        [name], 
        [group_flag], 
        [group_sales_id], 
        [group_sales_name], 
        [group_sales_status], 
        [order_num], 
        [order_line_item], 
        [request_line_item], 
        [usr], 
        [datetime], 
        [hours_held], 
        [rerate_surchg_on_acct_chg], 
        [sell_location], 
        [sales_source_id], 
        [sales_source_date], 
        [request_source], 
        [plan_event_name], 
        [plan_event_id], 
        [plan_datetime], 
        [section_type], 
        [section_sort], 
        [row_sort], 
        [row_index], 
        [block_id], 
        [config_id], 
        [event_date], 
        [event_time], 
        [event_day], 
        [event_sort], 
        [total_events], 
        [team], 
        [enabled], 
        [sellable], 
        [event_type_code], 
        [event_type], 
        [fse], 
        [tm_section_name], 
        [tm_row_name], 
        [tm_event_name], 
        [gate], 
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
        [print_ticket_ind], 
        [sell_type], 
        [status], 
        [ticket_type_code], 
        [ticket_type], 
        [orig_event_id], 
        [orig_event_name], 
        [flex_plan_event_ids], 
        [plan_type], 
        [parent_plan_type], 
        [acct_rep_id], 
        [contract_id], 
        [grouping_id], 
        [other_info_1], 
        [other_info_2], 
        [other_info_3], 
        [other_info_4], 
        [other_info_5], 
        [other_info_6], 
        [other_info_7], 
        [other_info_8], 
        [other_info_9], 
        [other_info_10], 
        [prev_loc_id], 
        [reserved_ind], 
        [release_datetime], 
        [hold_source], 
        [invoice_id], 
        [invoice_date], 
        [invoice_due_date], 
        [ticket_type_category], 
        [comp_requested_b], 
        [comp_approved_by], 
        [comp_comment], 
        [offer_id], 
        [offer_name], 
        [ledger_id], 
        [ledger_code], 
        [merchant_id], 
        [merchant_code], 
        [merchant_color], 
		[SourceFileName],
	  [InsertDate],
	  [UpdateDate],	  
        [HashKey]
    )
    VALUES (
        source.season_id, 
        source.event_id, 
        source.section_id, 
        source.row_id, 
        source.seat_num, 
        source.last_seat, 
        source.[event_name], 
        source.[section_name], 
        source.[ga], 
        source.[print_section_name], 
        source.[print_row_and_seat], 
        source.[row_name], 
        source.[num_seats], 
        source.[seat_increment], 
        source.[class_id], 
        source.[class_name], 
        source.[class_code], 
        source.[kill], 
        source.[dist_status], 
        source.[dist_name], 
        source.[class_color], 
        source.[eip_pricing], 
        source.[price_code], 
        source.[price_code_desc], 
        source.[price_code_group], 
        source.[price], 
        source.[printed_price], 
        source.[pc_ticket], 
        source.[pc_tax], 
        source.[pc_licfee], 
        source.[pc_other1], 
        source.[pc_other2], 
        source.[tax_rate_a], 
        source.[tax_rate_b], 
        source.[tax_rate_c], 
        source.[pc_color], 
        source.[pricing_method], 
        source.[block_full_price], 
        source.[block_purchase_price], 
        source.[orig_price_code], 
        source.[comp_code], 
        source.[comp_name], 
        source.[disc_code], 
        source.[disc_amount], 
        source.[surchg_code], 
        source.[surchg_amount], 
        source.[direction], 
        source.[quality], 
        source.[attribute], 
        source.[aisle], 
        source.[buy], 
        source.[tag], 
        source.[consignment], 
        source.[acct_id], 
        source.[name], 
        source.[group_flag], 
        source.[group_sales_id], 
        source.[group_sales_name], 
        source.[group_sales_status], 
        source.[order_num], 
        source.[order_line_item], 
        source.[request_line_item], 
        source.[usr], 
        source.[datetime], 
        source.[hours_held], 
        source.[rerate_surchg_on_acct_chg], 
        source.[sell_location], 
        source.[sales_source_id], 
        source.[sales_source_date], 
        source.[request_source], 
        source.[plan_event_name], 
        source.[plan_event_id], 
        source.[plan_datetime], 
        source.[section_type], 
        source.[section_sort], 
        source.[row_sort], 
        source.[row_index], 
        source.[block_id], 
        source.[config_id], 
        source.[event_date], 
        source.[event_time], 
        source.[event_day], 
        source.[event_sort], 
        source.[total_events], 
        source.[team], 
        source.[enabled], 
        source.[sellable], 
        source.[event_type_code], 
        source.[event_type], 
        source.[fse], 
        source.[tm_section_name], 
        source.[tm_row_name], 
        source.[tm_event_name], 
        source.[gate], 
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
        source.[print_ticket_ind], 
        source.[sell_type], 
        source.[status], 
        source.[ticket_type_code], 
        source.[ticket_type], 
        source.[orig_event_id], 
        source.[orig_event_name], 
        source.[flex_plan_event_ids], 
        source.[plan_type], 
        source.[parent_plan_type], 
        source.[acct_rep_id], 
        source.[contract_id], 
        source.[grouping_id], 
        source.[other_info_1], 
        source.[other_info_2], 
        source.[other_info_3], 
        source.[other_info_4], 
        source.[other_info_5], 
        source.[other_info_6], 
        source.[other_info_7], 
        source.[other_info_8], 
        source.[other_info_9], 
        source.[other_info_10], 
        source.[prev_loc_id], 
        source.[reserved_ind], 
        source.[release_datetime], 
        source.[hold_source], 
        source.[invoice_id], 
        source.[invoice_date], 
        source.[invoice_due_date], 
        source.[ticket_type_category], 
        source.[comp_requested_b], 
        source.[comp_approved_by], 
        source.[comp_comment], 
        source.[offer_id], 
        source.[offer_name], 
        source.[ledger_id], 
        source.[ledger_code], 
        source.[merchant_id], 
        source.[merchant_code], 
        source.[merchant_color], 
		source.[SourceFileName],
	  @RunTime,
	  @RunTime,
        source.[SrcHashKey]
    )
	WHEN NOT MATCHED BY SOURCE AND @DisableDelete <> 'true' THEN
		DELETE
	;

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
