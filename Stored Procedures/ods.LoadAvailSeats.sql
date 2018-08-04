SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[LoadAvailSeats]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_AvailSeats),'0');	

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

CREATE NONCLUSTERED INDEX [IDX_BusinessKey] ON [src].[TM_AvailSeats]
(
	[event_id] ASC
)
INCLUDE ([section_id], [row_id], [seat_num])
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


	/* Only events that were active in the incremental period are included in the file. Therefore only records that have fallen out for the included set of events should be deleted */
	IF (@DisableDelete <> 'true')
	BEGIN
	
		SELECT DISTINCT event_id INTO #srcEvents
		FROM src.TM_AvailSeats
		
		DELETE ods
		FROM ods.TM_AvailSeats ods
		LEFT OUTER JOIN src.TM_AvailSeats src
		     ON src.event_id = ods.event_id
			AND src.section_id = ods.section_id
			AND src.row_id = ods.row_id
			AND src.seat_num = ods.seat_num
		WHERE ods.event_id IN (SELECT event_id FROM #srcEvents)
		AND src.event_id IS NULL

	END


MERGE ods.TM_AvailSeats AS target
USING (SELECT [event_id]
      ,[event_name]
      ,[section_id]
      ,[section_name]
      ,[ga]
      ,[print_section_name]
      ,[row_id]
      ,[row_name]
      ,[seat_num]
      ,[num_seats]
      ,[last_seat]
      ,[seat_increment]
      ,[class_id]
      ,[actual_class_id]
      ,[class_name]
      ,[class_code]
      ,[kill]
      ,[dist_status]
      ,[dist_name]
      ,[class_color]
      ,[price_code]
      ,[tm_price_level]
      ,[price_code_desc]
      ,[ticket_type_code]
      ,[full_price_ticket_type_code]
      ,[ticket_type]
      ,[price_code_group]
      ,[price]
      ,[block_full_price]
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
      ,[direction]
      ,[quality]
      ,[attribute]
      ,[aisle]
      ,[season_id]
      ,[section_type]
      ,[section_sort]
      ,[row_sort]
      ,[row_index]
      ,[block_id]
      ,[config_id]
      ,[plan_type]
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
      ,[onsale_datetime]
      ,[offsale_datetime]
      ,[tm_section_name]
      ,[tm_row_name]
      ,[tm_event_name]
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
      ,[block_purchase_price]
      ,[sell_type]
      ,[status]
      ,[display_status]
      ,[pc_onsale_datetime]
      ,[pc_offsale_datetime]
      ,[unsold_type]
      ,[unsold_qual_id]
      ,[reserved]
	  ,[SourceFileName]
      ,[SrcHashKey]
  FROM [src].[vw_TM_AvailSeats]
  where MergeRank = 1
) as source
     ON source.event_id = target.event_id
    AND source.section_id = target.section_id
    AND source.row_id = target.row_id
    AND source.seat_num = target.seat_num
WHEN MATCHED AND @DisableUpdate <> 'true' AND source.SrcHashKey <> target.HashKey and 
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET  
    [event_name] = source.[event_name],
    [section_name] = source.[section_name],
    [ga] = source.[ga],
    [print_section_name] = source.[print_section_name],
    [row_name] = source.[row_name],
    [num_seats] = source.[num_seats],
    [seat_increment] = source.[seat_increment],
    [class_id] = source.[class_id],
    [actual_class_id] = source.[actual_class_id],
    [class_name] = source.[class_name],
    [class_code] = source.[class_code],
    [kill] = source.[kill],
    [dist_status] = source.[dist_status],
    [dist_name] = source.[dist_name],
    [class_color] = source.[class_color],
    [price_code] = source.[price_code],
    [tm_price_level] = source.[tm_price_level],
    [price_code_desc] = source.[price_code_desc],
    [ticket_type_code] = source.[ticket_type_code],
    [full_price_ticket_type_code] = source.[full_price_ticket_type_code],
    [ticket_type] = source.[ticket_type],
    [price_code_group] = source.[price_code_group],
    [price] = source.[price],
    [block_full_price] = source.[block_full_price],
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
    [direction] = source.[direction],
    [quality] = source.[quality],
    [attribute] = source.[attribute],
    [aisle] = source.[aisle],
    [section_type] = source.[section_type],
    [section_sort] = source.[section_sort],
    [row_sort] = source.[row_sort],
    [row_index] = source.[row_index],
    [block_id] = source.[block_id],
    [config_id] = source.[config_id],
    [plan_type] = source.[plan_type],
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
    [onsale_datetime] = source.[onsale_datetime],
    [offsale_datetime] = source.[offsale_datetime],
    [tm_section_name] = source.[tm_section_name],
    [tm_row_name] = source.[tm_row_name],
    [tm_event_name] = source.[tm_event_name],
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
    [block_purchase_price] = source.[block_purchase_price],
    [sell_type] = source.[sell_type],
    [status] = source.[status],
    [display_status] = source.[display_status],
    [pc_onsale_datetime] = source.[pc_onsale_datetime],
    [pc_offsale_datetime] = source.[pc_offsale_datetime],
    [unsold_type] = source.[unsold_type],
    [unsold_qual_id] = source.[unsold_qual_id],
    [reserved] = source.[reserved],
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
        [row_name], 
        [num_seats], 
        [seat_increment], 
        [class_id], 
        [actual_class_id], 
        [class_name], 
        [class_code], 
        [kill], 
        [dist_status], 
        [dist_name], 
        [class_color], 
        [price_code], 
        [tm_price_level], 
        [price_code_desc], 
        [ticket_type_code], 
        [full_price_ticket_type_code], 
        [ticket_type], 
        [price_code_group], 
        [price], 
        [block_full_price], 
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
        [direction], 
        [quality], 
        [attribute], 
        [aisle], 
        [section_type], 
        [section_sort], 
        [row_sort], 
        [row_index], 
        [block_id], 
        [config_id], 
        [plan_type], 
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
        [onsale_datetime], 
        [offsale_datetime], 
        [tm_section_name], 
        [tm_row_name], 
        [tm_event_name], 
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
        [block_purchase_price], 
        [sell_type], 
        [status], 
        [display_status], 
        [pc_onsale_datetime], 
        [pc_offsale_datetime], 
        [unsold_type], 
        [unsold_qual_id], 
        [reserved], 
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
        source.[row_name], 
        source.[num_seats], 
        source.[seat_increment], 
        source.[class_id], 
        source.[actual_class_id], 
        source.[class_name], 
        source.[class_code], 
        source.[kill], 
        source.[dist_status], 
        source.[dist_name], 
        source.[class_color], 
        source.[price_code], 
        source.[tm_price_level], 
        source.[price_code_desc], 
        source.[ticket_type_code], 
        source.[full_price_ticket_type_code], 
        source.[ticket_type], 
        source.[price_code_group], 
        source.[price], 
        source.[block_full_price], 
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
        source.[direction], 
        source.[quality], 
        source.[attribute], 
        source.[aisle], 
        source.[section_type], 
        source.[section_sort], 
        source.[row_sort], 
        source.[row_index], 
        source.[block_id], 
        source.[config_id], 
        source.[plan_type], 
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
        source.[onsale_datetime], 
        source.[offsale_datetime], 
        source.[tm_section_name], 
        source.[tm_row_name], 
        source.[tm_event_name], 
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
        source.[block_purchase_price], 
        source.[sell_type], 
        source.[status], 
        source.[display_status], 
        source.[pc_onsale_datetime], 
        source.[pc_offsale_datetime], 
        source.[unsold_type], 
        source.[unsold_qual_id], 
        source.[reserved], 
		source.[SourceFileName],
		@RunTime,
		@RunTime,
        source.[SrcHashKey]
    )
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
