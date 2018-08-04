SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[LoadPriceCode]
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
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_PriceCode),'0');	

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

MERGE ods.TM_PriceCode AS target
USING
(SELECT [season_id]
      ,[event_id]
      ,[event_name]
      ,[event_date]
      ,[event_time]
      ,[event_day]
      ,[plan_type]
      ,[team]
      ,[enabled]
      ,[event_sellable]
      ,[pc_sellable]
      ,[inet_pc_sellable]
      ,[total_events]
      ,[price_code]
      ,[price]
      ,[parent_price_code]
      ,[ticket_type_code]
      ,[full_price_ticket_type_code]
      ,[tt_code]
      ,[ticket_type]
      ,[ticket_type_desc]
      ,[ticket_type_category]
      ,[comp_ind]
      ,[default_host_offer_id]
      ,[ticket_type_relationship]
      ,[upd_user]
      ,[upd_datetime]
      ,[pricing_method]
      ,[tm_price_level]
      ,[tm_ticket_type]
      ,[ticket_template_override]
      ,[ticket_template]
      ,[code]
      ,[price_code_group]
      ,[price_code_desc]
      ,[price_code_info1]
      ,[price_code_info2]
      ,[price_code_info3]
      ,[price_code_info4]
      ,[price_code_info5]
      ,[color]
      ,[printed_price]
      ,[pc_ticket]
      ,[pc_tax]
      ,[pc_licfee]
      ,[pc_other1]
      ,[pc_other2]
      ,[tax_rate_a]
      ,[tax_rate_b]
      ,[tax_rate_c]
      ,[onsale_datetime]
      ,[offsale_datetime]
      ,[inet_onsale_datetime]
      ,[inet_offsale_datetime]
      ,[inet_price_code_name]
      ,[inet_offer_text]
      ,[inet_full_price]
      ,[inet_min_tickets_per_tran]
      ,[inet_max_tickets_per_tran]
      ,[tid_family_id]
      ,[on_purch_add_to_acct_group_id]
      ,[tm_event_name]
      ,[auto_add_membership_name]
      ,[required_membership_list]
      ,[card_template_override]
      ,[card_template]
      ,[ledger_id]
      ,[ledger_code]
      ,[merchant_id]
      ,[merchant_code]
      ,[merchant_color]
      ,[membership_reqd_for_purchase]
      ,[membership_id_for_membership_event]
      ,[membership_name]
      ,[membership_expiration_date]
      ,[club_group_enabled]
      ,[season_name]
      ,[season_year]
      ,[org_id]
      ,[org_name]
	  ,[SourceFileName]
      ,[SrcHashKey]
  FROM [src].[vw_TM_PriceCode]
  WHERE MergeRank = 1
) as source
     ON source.season_id = target.season_id
    AND source.event_id = target.event_id
    AND source.price_code = target.price_code
WHEN MATCHED AND @DisableUpdate <> 'true' AND source.SrcHashKey <> target.HashKey and 
	LEFT((SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(source.SourceFileName, PATINDEX('%[0-9]%', source.SourceFileName), LEN(source.SourceFileName)))+'a')-1) > 
		LEFT((SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName))),PATINDEX('%[^0-9]%', (SELECT SUBSTRING(target.SourceFileName, PATINDEX('%[0-9]%', target.SourceFileName), LEN(target.SourceFileName)))+'a')-1)
THEN UPDATE SET 
    [event_name] = source.[event_name],
    [event_date] = source.[event_date],
    [event_time] = source.[event_time],
    [event_day] = source.[event_day],
    [plan_type] = source.[plan_type],
    [team] = source.[team],
    [enabled] = source.[enabled],
    [event_sellable] = source.[event_sellable],
    [pc_sellable] = source.[pc_sellable],
    [inet_pc_sellable] = source.[inet_pc_sellable],
    [total_events] = source.[total_events],
    [price] = source.[price],
    [parent_price_code] = source.[parent_price_code],
    [ticket_type_code] = source.[ticket_type_code],
    [full_price_ticket_type_code] = source.[full_price_ticket_type_code],
    [tt_code] = source.[tt_code],
    [ticket_type] = source.[ticket_type],
    [ticket_type_desc] = source.[ticket_type_desc],
    [ticket_type_category] = source.[ticket_type_category],
    [comp_ind] = source.[comp_ind],
    [default_host_offer_id] = source.[default_host_offer_id],
    [ticket_type_relationship] = source.[ticket_type_relationship],
    [upd_user] = source.[upd_user],
    [upd_datetime] = source.[upd_datetime],
    [pricing_method] = source.[pricing_method],
    [tm_price_level] = source.[tm_price_level],
    [tm_ticket_type] = source.[tm_ticket_type],
    [ticket_template_override] = source.[ticket_template_override],
    [ticket_template] = source.[ticket_template],
    [code] = source.[code],
    [price_code_group] = source.[price_code_group],
    [price_code_desc] = source.[price_code_desc],
    [price_code_info1] = source.[price_code_info1],
    [price_code_info2] = source.[price_code_info2],
    [price_code_info3] = source.[price_code_info3],
    [price_code_info4] = source.[price_code_info4],
    [price_code_info5] = source.[price_code_info5],
    [color] = source.[color],
    [printed_price] = source.[printed_price],
    [pc_ticket] = source.[pc_ticket],
    [pc_tax] = source.[pc_tax],
    [pc_licfee] = source.[pc_licfee],
    [pc_other1] = source.[pc_other1],
    [pc_other2] = source.[pc_other2],
    [tax_rate_a] = source.[tax_rate_a],
    [tax_rate_b] = source.[tax_rate_b],
    [tax_rate_c] = source.[tax_rate_c],
    [onsale_datetime] = source.[onsale_datetime],
    [offsale_datetime] = source.[offsale_datetime],
    [inet_onsale_datetime] = source.[inet_onsale_datetime],
    [inet_offsale_datetime] = source.[inet_offsale_datetime],
    [inet_price_code_name] = source.[inet_price_code_name],
    [inet_offer_text] = source.[inet_offer_text],
    [inet_full_price] = source.[inet_full_price],
    [inet_min_tickets_per_tran] = source.[inet_min_tickets_per_tran],
    [inet_max_tickets_per_tran] = source.[inet_max_tickets_per_tran],
    [tid_family_id] = source.[tid_family_id],
    [on_purch_add_to_acct_group_id] = source.[on_purch_add_to_acct_group_id],
    [tm_event_name] = source.[tm_event_name],
    [auto_add_membership_name] = source.[auto_add_membership_name],
    [required_membership_list] = source.[required_membership_list],
    [card_template_override] = source.[card_template_override],
    [card_template] = source.[card_template],
    [ledger_id] = source.[ledger_id],
    [ledger_code] = source.[ledger_code],
    [merchant_id] = source.[merchant_id],
    [merchant_code] = source.[merchant_code],
    [merchant_color] = source.[merchant_color],
    [membership_reqd_for_purchase] = source.[membership_reqd_for_purchase],
    [membership_id_for_membership_event] = source.[membership_id_for_membership_event],
    [membership_name] = source.[membership_name],
    [membership_expiration_date] = source.[membership_expiration_date],
    [club_group_enabled] = source.[club_group_enabled],
    [season_name] = source.[season_name],
    [season_year] = source.[season_year],
    [org_id] = source.[org_id],
    [org_name] = source.[org_name],
	[SourceFileName]			= source.[SourceFileName],
	[UpdateDate]				= @RunTime,	
    [HashKey] = source.[SrcHashKey]
WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT
    (
        season_id, 
        event_id, 
        price_code, 
        [event_name], 
        [event_date], 
        [event_time], 
        [event_day], 
        [plan_type], 
        [team], 
        [enabled], 
        [event_sellable], 
        [pc_sellable], 
        [inet_pc_sellable], 
        [total_events], 
        [price], 
        [parent_price_code], 
        [ticket_type_code], 
        [full_price_ticket_type_code], 
        [tt_code], 
        [ticket_type], 
        [ticket_type_desc], 
        [ticket_type_category], 
        [comp_ind], 
        [default_host_offer_id], 
        [ticket_type_relationship], 
        [upd_user], 
        [upd_datetime], 
        [pricing_method], 
        [tm_price_level], 
        [tm_ticket_type], 
        [ticket_template_override], 
        [ticket_template], 
        [code], 
        [price_code_group], 
        [price_code_desc], 
        [price_code_info1], 
        [price_code_info2], 
        [price_code_info3], 
        [price_code_info4], 
        [price_code_info5], 
        [color], 
        [printed_price], 
        [pc_ticket], 
        [pc_tax], 
        [pc_licfee], 
        [pc_other1], 
        [pc_other2], 
        [tax_rate_a], 
        [tax_rate_b], 
        [tax_rate_c], 
        [onsale_datetime], 
        [offsale_datetime], 
        [inet_onsale_datetime], 
        [inet_offsale_datetime], 
        [inet_price_code_name], 
        [inet_offer_text], 
        [inet_full_price], 
        [inet_min_tickets_per_tran], 
        [inet_max_tickets_per_tran], 
        [tid_family_id], 
        [on_purch_add_to_acct_group_id], 
        [tm_event_name], 
        [auto_add_membership_name], 
        [required_membership_list], 
        [card_template_override], 
        [card_template], 
        [ledger_id], 
        [ledger_code], 
        [merchant_id], 
        [merchant_code], 
        [merchant_color], 
        [membership_reqd_for_purchase], 
        [membership_id_for_membership_event], 
        [membership_name], 
        [membership_expiration_date], 
        [club_group_enabled], 
        [season_name], 
        [season_year], 
        [org_id], 
        [org_name], 
		[SourceFileName],
	  [InsertDate],
	  [UpdateDate],	
        [HashKey]
    )
    VALUES (
        source.season_id, 
        source.event_id, 
        source.price_code, 
        source.[event_name], 
        source.[event_date], 
        source.[event_time], 
        source.[event_day], 
        source.[plan_type], 
        source.[team], 
        source.[enabled], 
        source.[event_sellable], 
        source.[pc_sellable], 
        source.[inet_pc_sellable], 
        source.[total_events], 
        source.[price], 
        source.[parent_price_code], 
        source.[ticket_type_code], 
        source.[full_price_ticket_type_code], 
        source.[tt_code], 
        source.[ticket_type], 
        source.[ticket_type_desc], 
        source.[ticket_type_category], 
        source.[comp_ind], 
        source.[default_host_offer_id], 
        source.[ticket_type_relationship], 
        source.[upd_user], 
        source.[upd_datetime], 
        source.[pricing_method], 
        source.[tm_price_level], 
        source.[tm_ticket_type], 
        source.[ticket_template_override], 
        source.[ticket_template], 
        source.[code], 
        source.[price_code_group], 
        source.[price_code_desc], 
        source.[price_code_info1], 
        source.[price_code_info2], 
        source.[price_code_info3], 
        source.[price_code_info4], 
        source.[price_code_info5], 
        source.[color], 
        source.[printed_price], 
        source.[pc_ticket], 
        source.[pc_tax], 
        source.[pc_licfee], 
        source.[pc_other1], 
        source.[pc_other2], 
        source.[tax_rate_a], 
        source.[tax_rate_b], 
        source.[tax_rate_c], 
        source.[onsale_datetime], 
        source.[offsale_datetime], 
        source.[inet_onsale_datetime], 
        source.[inet_offsale_datetime], 
        source.[inet_price_code_name], 
        source.[inet_offer_text], 
        source.[inet_full_price], 
        source.[inet_min_tickets_per_tran], 
        source.[inet_max_tickets_per_tran], 
        source.[tid_family_id], 
        source.[on_purch_add_to_acct_group_id], 
        source.[tm_event_name], 
        source.[auto_add_membership_name], 
        source.[required_membership_list], 
        source.[card_template_override], 
        source.[card_template], 
        source.[ledger_id], 
        source.[ledger_code], 
        source.[merchant_id], 
        source.[merchant_code], 
        source.[merchant_color], 
        source.[membership_reqd_for_purchase], 
        source.[membership_id_for_membership_event], 
        source.[membership_name], 
        source.[membership_expiration_date], 
        source.[club_group_enabled], 
        source.[season_name], 
        source.[season_year], 
        source.[org_id], 
        source.[org_name],
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
