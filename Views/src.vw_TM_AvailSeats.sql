SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [src].[vw_TM_AvailSeats]
as
SELECT [event_id]
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
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(VARCHAR(10),[event_id])),'DBNULL_BIGINT') + ISNULL(RTRIM([event_name]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[section_id])),'DBNULL_BIGINT') +
	   ISNULL(RTRIM([section_name]),'DBNULL_TEXT') + ISNULL(RTRIM([ga]),'DBNULL_TEXT') + ISNULL(RTRIM([print_section_name]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[row_id])),'DBNULL_BIGINT') +
	    ISNULL(RTRIM([row_name]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[seat_num])),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[num_seats])),'DBNULL_BIGINT') +
		 ISNULL(RTRIM(CONVERT(VARCHAR(10),[last_seat])),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[seat_increment])),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[class_id])),'DBNULL_BIGINT') + 
		 ISNULL(RTRIM(CONVERT(VARCHAR(10),[actual_class_id])),'DBNULL_BIGINT') + ISNULL(RTRIM([class_name]),'DBNULL_TEXT') + ISNULL(RTRIM([class_code]),'DBNULL_TEXT') + ISNULL(RTRIM([kill]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([dist_status]),'DBNULL_TEXT') + ISNULL(RTRIM([dist_name]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[class_color])),'DBNULL_BIGINT') + ISNULL(RTRIM([price_code]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([tm_price_level]),'DBNULL_TEXT') + ISNULL(RTRIM([price_code_desc]),'DBNULL_TEXT') + ISNULL(RTRIM([ticket_type_code]),'DBNULL_TEXT') + ISNULL(RTRIM([full_price_ticket_type_code]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([ticket_type]),'DBNULL_TEXT') + ISNULL(RTRIM([price_code_group]),'DBNULL_TEXT') + ISNULL(RTRIM([price]),'DBNULL_TEXT') + ISNULL(RTRIM([block_full_price]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([printed_price]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_ticket]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_tax]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_licfee]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([pc_other1]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_other2]),'DBNULL_TEXT') + ISNULL(RTRIM([tax_rate_a]),'DBNULL_TEXT') + ISNULL(RTRIM([tax_rate_b]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([tax_rate_c]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[pc_color])),'DBNULL_BIGINT') + ISNULL(RTRIM([direction]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM(CONVERT(VARCHAR(10),[quality])),'DBNULL_BIGINT') + ISNULL(RTRIM([attribute]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[aisle])),'DBNULL_BIGINT') + 
		 ISNULL(RTRIM(CONVERT(VARCHAR(10),[season_id])),'DBNULL_BIGINT') + ISNULL(RTRIM([section_type]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[section_sort])),'DBNULL_BIGINT') + 
		 ISNULL(RTRIM(CONVERT(VARCHAR(10),[row_sort])),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[row_index])),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[block_id])),'DBNULL_BIGINT') + 
		 ISNULL(RTRIM(CONVERT(VARCHAR(10),[config_id])),'DBNULL_BIGINT') + ISNULL(RTRIM([plan_type]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),[event_date])),'DBNULL_DATETIME') + 
		 ISNULL(RTRIM([event_time]),'DBNULL_TEXT') + ISNULL(RTRIM([event_day]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[event_sort])),'DBNULL_BIGINT') + 
		 ISNULL(RTRIM(CONVERT(VARCHAR(10),[total_events])),'DBNULL_BIGINT') + ISNULL(RTRIM([team]),'DBNULL_TEXT') + ISNULL(RTRIM([enabled]),'DBNULL_TEXT') + ISNULL(RTRIM([sellable]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([event_type_code]),'DBNULL_TEXT') + ISNULL(RTRIM([event_type]),'DBNULL_TEXT') + ISNULL(RTRIM([onsale_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([offsale_datetime]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([tm_section_name]),'DBNULL_TEXT') + ISNULL(RTRIM([tm_row_name]),'DBNULL_TEXT') + ISNULL(RTRIM([tm_event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([section_info1]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([section_info2]),'DBNULL_TEXT') + ISNULL(RTRIM([section_info3]),'DBNULL_TEXT') + ISNULL(RTRIM([section_info4]),'DBNULL_TEXT') + ISNULL(RTRIM([section_info5]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([row_info1]),'DBNULL_TEXT') + ISNULL(RTRIM([row_info2]),'DBNULL_TEXT') + ISNULL(RTRIM([row_info3]),'DBNULL_TEXT') + ISNULL(RTRIM([row_info4]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([row_info5]),'DBNULL_TEXT') + ISNULL(RTRIM([print_ticket_ind]),'DBNULL_TEXT') + ISNULL(RTRIM([block_purchase_price]),'DBNULL_TEXT') + ISNULL(RTRIM([sell_type]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([status]),'DBNULL_TEXT') + ISNULL(RTRIM([display_status]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_onsale_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_offsale_datetime]),'DBNULL_TEXT') + 
		 ISNULL(RTRIM([unsold_type]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[unsold_qual_id])),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[reserved])),'DBNULL_BIGINT')) SrcHashKey
	, ROW_NUMBER() OVER(PARTITION BY event_id, section_id, row_id, seat_num ORDER BY [enabled] desc) AS MergeRank
  FROM [src].[TM_AvailSeats]










GO
