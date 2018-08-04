SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [src].[vw_TM_PromoCode]
as
SELECT [promo_code_id]
      ,[promo_code]
      ,[promo_code_name]
      ,[acct_id]
      ,[promo_inet_name]
      ,[promo_inet_desc]
      ,[promo_type]
      ,[promo_group_sell_flag]
      ,[promo_active_flag]
      ,[add_user]
      ,[inet_start_datetime]
      ,[inet_end_datetime]
      ,[archtics_start_datetime]
      ,[archtics_end_datetime]
      ,[event_id]
      ,[event_name]
      ,[tm_event_name]
      ,[add_Datetime]
      ,[upd_datetime]
	  ,[SourceFileName]
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM([promo_code_id]),'DBNULL_TEXT') + ISNULL(RTRIM([promo_code]),'DBNULL_TEXT') + ISNULL(RTRIM([promo_code_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([acct_id]),'DBNULL_TEXT') + ISNULL(RTRIM([promo_inet_name]),'DBNULL_TEXT') + ISNULL(RTRIM([promo_inet_desc]),'DBNULL_TEXT') + ISNULL(RTRIM([promo_type]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([promo_group_sell_flag]),'DBNULL_TEXT') + ISNULL(RTRIM([promo_active_flag]),'DBNULL_TEXT') + ISNULL(RTRIM([add_user]),'DBNULL_TEXT') + ISNULL(RTRIM([inet_start_datetime]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([inet_end_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([archtics_start_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([archtics_end_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([event_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([tm_event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([add_Datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([upd_datetime]),'DBNULL_TEXT')) SrcHashKey
	, ROW_NUMBER() OVER(PARTITION BY event_id, promo_code_id ORDER BY upd_datetime) AS MergeRank
  FROM [src].[TM_PromoCode]








GO
