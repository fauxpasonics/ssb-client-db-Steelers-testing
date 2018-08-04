SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [src].[vw_TM_HeldSeats]
AS

SELECT [event_id]
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
	  , CASE WHEN [price] = '' THEN '0' ELSE [price] END [price]
      , CASE WHEN [printed_price] = '' THEN '0' ELSE [printed_price] END [printed_price]
	  , CASE WHEN [pc_ticket] = '' THEN '0' ELSE [pc_ticket] END [pc_ticket]
	  , CASE WHEN [pc_tax] = '' THEN '0' ELSE [pc_tax] END [pc_tax]
	  , CASE WHEN [pc_licfee] = '' THEN '0' ELSE [pc_licfee] END [pc_licfee]
	  , CASE WHEN [pc_other1] = '' THEN '0' ELSE [pc_other1] END [pc_other1]
	  , CASE WHEN [pc_other2] = '' THEN '0' ELSE [pc_other2] END [pc_other2]
	  , CASE WHEN [tax_rate_a] = '' THEN '0' ELSE [tax_rate_a] END [tax_rate_a]
	  , CASE WHEN [tax_rate_b] = '' THEN '0' ELSE [tax_rate_b] END [tax_rate_b]
	  , CASE WHEN [tax_rate_c] = '' THEN '0' ELSE [tax_rate_c] END [tax_rate_c]
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
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM([event_id]),'DBNULL_TEXT') + ISNULL(RTRIM([event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([section_id]),'DBNULL_TEXT') + ISNULL(RTRIM([section_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([ga]),'DBNULL_TEXT') + ISNULL(RTRIM([print_section_name]),'DBNULL_TEXT') + ISNULL(RTRIM([print_row_and_seat]),'DBNULL_TEXT') + ISNULL(RTRIM([row_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([row_name]),'DBNULL_TEXT') + ISNULL(RTRIM([seat_num]),'DBNULL_TEXT') + ISNULL(RTRIM([num_seats]),'DBNULL_TEXT') + ISNULL(RTRIM([last_seat]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([seat_increment]),'DBNULL_TEXT') + ISNULL(RTRIM([class_id]),'DBNULL_TEXT') + ISNULL(RTRIM([class_name]),'DBNULL_TEXT') + ISNULL(RTRIM([class_code]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([kill]),'DBNULL_TEXT') + ISNULL(RTRIM([dist_status]),'DBNULL_TEXT') + ISNULL(RTRIM([dist_name]),'DBNULL_TEXT') + ISNULL(RTRIM([class_color]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([eip_pricing]),'DBNULL_TEXT') + ISNULL(RTRIM([price_code]),'DBNULL_TEXT') + ISNULL(RTRIM([price_code_desc]),'DBNULL_TEXT') + ISNULL(RTRIM([price_code_group]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([price]),'DBNULL_TEXT') + ISNULL(RTRIM([printed_price]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_ticket]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_tax]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([pc_licfee]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_other1]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_other2]),'DBNULL_TEXT') + ISNULL(RTRIM([tax_rate_a]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([tax_rate_b]),'DBNULL_TEXT') + ISNULL(RTRIM([tax_rate_c]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_color]),'DBNULL_TEXT') + ISNULL(RTRIM([pricing_method]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([block_full_price]),'DBNULL_TEXT') + ISNULL(RTRIM([block_purchase_price]),'DBNULL_TEXT') + ISNULL(RTRIM([orig_price_code]),'DBNULL_TEXT') + ISNULL(RTRIM([comp_code]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([comp_name]),'DBNULL_TEXT') + ISNULL(RTRIM([disc_code]),'DBNULL_TEXT') + ISNULL(RTRIM([disc_amount]),'DBNULL_TEXT') + ISNULL(RTRIM([surchg_code]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([surchg_amount]),'DBNULL_TEXT') + ISNULL(RTRIM([direction]),'DBNULL_TEXT') + ISNULL(RTRIM([quality]),'DBNULL_TEXT') + ISNULL(RTRIM([attribute]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([aisle]),'DBNULL_TEXT') + ISNULL(RTRIM([buy]),'DBNULL_TEXT') + ISNULL(RTRIM([tag]),'DBNULL_TEXT') + ISNULL(RTRIM([consignment]),'DBNULL_TEXT') + ISNULL(RTRIM([acct_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([name]),'DBNULL_TEXT') + ISNULL(RTRIM([group_flag]),'DBNULL_TEXT') + ISNULL(RTRIM([group_sales_id]),'DBNULL_TEXT') + ISNULL(RTRIM([group_sales_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([group_sales_status]),'DBNULL_TEXT') + ISNULL(RTRIM([order_num]),'DBNULL_TEXT') + ISNULL(RTRIM([order_line_item]),'DBNULL_TEXT') + ISNULL(RTRIM([request_line_item]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([usr]),'DBNULL_TEXT') + ISNULL(RTRIM([datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([hours_held]),'DBNULL_TEXT') + ISNULL(RTRIM([rerate_surchg_on_acct_chg]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([sell_location]),'DBNULL_TEXT') + ISNULL(RTRIM([sales_source_id]),'DBNULL_TEXT') + ISNULL(RTRIM([sales_source_date]),'DBNULL_TEXT') + ISNULL(RTRIM([request_source]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([plan_event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([plan_event_id]),'DBNULL_TEXT') + ISNULL(RTRIM([plan_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([season_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([section_type]),'DBNULL_TEXT') + ISNULL(RTRIM([section_sort]),'DBNULL_TEXT') + ISNULL(RTRIM([row_sort]),'DBNULL_TEXT') + ISNULL(RTRIM([row_index]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([block_id]),'DBNULL_TEXT') + ISNULL(RTRIM([config_id]),'DBNULL_TEXT') + ISNULL(RTRIM([event_date]),'DBNULL_TEXT') + ISNULL(RTRIM([event_time]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([event_day]),'DBNULL_TEXT') + ISNULL(RTRIM([event_sort]),'DBNULL_TEXT') + ISNULL(RTRIM([total_events]),'DBNULL_TEXT') + ISNULL(RTRIM([team]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([enabled]),'DBNULL_TEXT') + ISNULL(RTRIM([sellable]),'DBNULL_TEXT') + ISNULL(RTRIM([event_type_code]),'DBNULL_TEXT') + ISNULL(RTRIM([event_type]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([fse]),'DBNULL_TEXT') + ISNULL(RTRIM([tm_section_name]),'DBNULL_TEXT') + ISNULL(RTRIM([tm_row_name]),'DBNULL_TEXT') + ISNULL(RTRIM([tm_event_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([gate]),'DBNULL_TEXT') + ISNULL(RTRIM([section_info1]),'DBNULL_TEXT') + ISNULL(RTRIM([section_info2]),'DBNULL_TEXT') + ISNULL(RTRIM([section_info3]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([section_info4]),'DBNULL_TEXT') + ISNULL(RTRIM([section_info5]),'DBNULL_TEXT') + ISNULL(RTRIM([row_info1]),'DBNULL_TEXT') + ISNULL(RTRIM([row_info2]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([row_info3]),'DBNULL_TEXT') + ISNULL(RTRIM([row_info4]),'DBNULL_TEXT') + ISNULL(RTRIM([row_info5]),'DBNULL_TEXT') + ISNULL(RTRIM([print_ticket_ind]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([sell_type]),'DBNULL_TEXT') + ISNULL(RTRIM([status]),'DBNULL_TEXT') + ISNULL(RTRIM([ticket_type_code]),'DBNULL_TEXT') + ISNULL(RTRIM([ticket_type]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([orig_event_id]),'DBNULL_TEXT') + ISNULL(RTRIM([orig_event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([flex_plan_event_ids]),'DBNULL_TEXT') + ISNULL(RTRIM([plan_type]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([parent_plan_type]),'DBNULL_TEXT') + ISNULL(RTRIM([acct_rep_id]),'DBNULL_TEXT') + ISNULL(RTRIM([contract_id]),'DBNULL_TEXT') + ISNULL(RTRIM([grouping_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([other_info_1]),'DBNULL_TEXT') + ISNULL(RTRIM([other_info_2]),'DBNULL_TEXT') + ISNULL(RTRIM([other_info_3]),'DBNULL_TEXT') + ISNULL(RTRIM([other_info_4]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([other_info_5]),'DBNULL_TEXT') + ISNULL(RTRIM([other_info_6]),'DBNULL_TEXT') + ISNULL(RTRIM([other_info_7]),'DBNULL_TEXT') + ISNULL(RTRIM([other_info_8]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([other_info_9]),'DBNULL_TEXT') + ISNULL(RTRIM([other_info_10]),'DBNULL_TEXT') + ISNULL(RTRIM([prev_loc_id]),'DBNULL_TEXT') + ISNULL(RTRIM([reserved_ind]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([release_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([hold_source]),'DBNULL_TEXT') + ISNULL(RTRIM([invoice_id]),'DBNULL_TEXT') + ISNULL(RTRIM([invoice_date]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([invoice_due_date]),'DBNULL_TEXT') + ISNULL(RTRIM([ticket_type_category]),'DBNULL_TEXT') + ISNULL(RTRIM([comp_requested_b]),'DBNULL_TEXT') + ISNULL(RTRIM([comp_approved_by]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([comp_comment]),'DBNULL_TEXT') + ISNULL(RTRIM([offer_id]),'DBNULL_TEXT') + ISNULL(RTRIM([offer_name]),'DBNULL_TEXT') + ISNULL(RTRIM([ledger_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([ledger_code]),'DBNULL_TEXT') + ISNULL(RTRIM([merchant_id]),'DBNULL_TEXT') + ISNULL(RTRIM([merchant_code]),'DBNULL_TEXT') + ISNULL(RTRIM([merchant_color]),'DBNULL_TEXT')) SrcHashKey
	, ROW_NUMBER() OVER(PARTITION BY season_id, event_id, section_id, row_id, seat_num, last_seat ORDER BY season_id) AS MergeRank
  FROM [src].[TM_HeldSeats]




GO
