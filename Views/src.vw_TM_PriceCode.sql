SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [src].[vw_TM_PriceCode]
as

SELECT [season_id]
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
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(VARCHAR(10),[season_id])),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[event_id])),'DBNULL_BIGINT') + ISNULL(RTRIM([event_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM(CONVERT(VARCHAR(25),[event_date])),'DBNULL_DATETIME') + ISNULL(RTRIM([event_time]),'DBNULL_TEXT') + ISNULL(RTRIM([event_day]),'DBNULL_TEXT') + ISNULL(RTRIM([plan_type]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([team]),'DBNULL_TEXT') + ISNULL(RTRIM([enabled]),'DBNULL_TEXT') + ISNULL(RTRIM([event_sellable]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_sellable]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([inet_pc_sellable]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[total_events])),'DBNULL_BIGINT') + ISNULL(RTRIM([price_code]),'DBNULL_TEXT') + ISNULL(RTRIM([price]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([parent_price_code]),'DBNULL_TEXT') + ISNULL(RTRIM([ticket_type_code]),'DBNULL_TEXT') + ISNULL(RTRIM([full_price_ticket_type_code]),'DBNULL_TEXT') + ISNULL(RTRIM([tt_code]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([ticket_type]),'DBNULL_TEXT') + ISNULL(RTRIM([ticket_type_desc]),'DBNULL_TEXT') + ISNULL(RTRIM([ticket_type_category]),'DBNULL_TEXT') + ISNULL(RTRIM([comp_ind]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM(CONVERT(VARCHAR(10),[default_host_offer_id])),'DBNULL_BIGINT') + ISNULL(RTRIM([ticket_type_relationship]),'DBNULL_TEXT') + ISNULL(RTRIM([upd_user]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM(CONVERT(VARCHAR(25),[upd_datetime])),'DBNULL_DATETIME') + ISNULL(RTRIM([pricing_method]),'DBNULL_TEXT') + ISNULL(RTRIM([tm_price_level]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([tm_ticket_type]),'DBNULL_TEXT') + ISNULL(RTRIM([ticket_template_override]),'DBNULL_TEXT') + ISNULL(RTRIM([ticket_template]),'DBNULL_TEXT') + ISNULL(RTRIM([code]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([price_code_group]),'DBNULL_TEXT') + ISNULL(RTRIM([price_code_desc]),'DBNULL_TEXT') + ISNULL(RTRIM([price_code_info1]),'DBNULL_TEXT') + ISNULL(RTRIM([price_code_info2]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([price_code_info3]),'DBNULL_TEXT') + ISNULL(RTRIM([price_code_info4]),'DBNULL_TEXT') + ISNULL(RTRIM([price_code_info5]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[color])),'DBNULL_BIGINT') + 
	  ISNULL(RTRIM([printed_price]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_ticket]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_tax]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_licfee]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([pc_other1]),'DBNULL_TEXT') + ISNULL(RTRIM([pc_other2]),'DBNULL_TEXT') + ISNULL(RTRIM([tax_rate_a]),'DBNULL_TEXT') + ISNULL(RTRIM([tax_rate_b]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([tax_rate_c]),'DBNULL_TEXT') + ISNULL(RTRIM([onsale_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([offsale_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([inet_onsale_datetime]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([inet_offsale_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([inet_price_code_name]),'DBNULL_TEXT') + ISNULL(RTRIM([inet_offer_text]),'DBNULL_TEXT') + ISNULL(RTRIM([inet_full_price]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([inet_min_tickets_per_tran]),'DBNULL_TEXT') + ISNULL(RTRIM([inet_max_tickets_per_tran]),'DBNULL_TEXT') + ISNULL(RTRIM([tid_family_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([on_purch_add_to_acct_group_id]),'DBNULL_TEXT') + ISNULL(RTRIM([tm_event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([auto_add_membership_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([required_membership_list]),'DBNULL_TEXT') + ISNULL(RTRIM([card_template_override]),'DBNULL_TEXT') + ISNULL(RTRIM([card_template]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM(CONVERT(VARCHAR(10),[ledger_id])),'DBNULL_BIGINT') + ISNULL(RTRIM([ledger_code]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[merchant_id])),'DBNULL_BIGINT') + 
	  ISNULL(RTRIM([merchant_code]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[merchant_color])),'DBNULL_BIGINT') + ISNULL(RTRIM([membership_reqd_for_purchase]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([membership_id_for_membership_event]),'DBNULL_TEXT') + ISNULL(RTRIM([membership_name]),'DBNULL_TEXT') + ISNULL(RTRIM([membership_expiration_date]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([club_group_enabled]),'DBNULL_TEXT') + ISNULL(RTRIM([season_name]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[season_year])),'DBNULL_BIGINT') + 
	  ISNULL(RTRIM(CONVERT(VARCHAR(10),[org_id])),'DBNULL_BIGINT') + ISNULL(RTRIM([org_name]),'DBNULL_TEXT')) SrcHashKey
	, ROW_NUMBER() OVER(PARTITION BY season_id, event_id, price_code ORDER BY upd_datetime DESC) AS MergeRank
  FROM [src].[TM_PriceCode]











GO
