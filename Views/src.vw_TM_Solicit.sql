SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [src].[vw_TM_Solicit]
as
SELECT [solicitation_id]
      ,[solicitation_name]
      ,[solicitation_desc]
      ,[status]
      ,[reason]
      ,[upd_user]
      ,[upd_datetime]
      ,[acct_id]
      ,[name_last]
      ,[name_last_first_mi]
      ,[email_addr]
      ,[campaign_id]
      ,[campaign_name]
      ,[drive_year]
      ,[item_id]
      ,[item_name]
      ,[list_id]
      ,[list_name]
      ,[list_count]
      ,[solicitation_goal]
      ,[solicitation_cost]
      ,[contact_type_code]
      ,[contact_type]
      ,[solicitation_category]
      ,[solicitation_category_name]
      ,[start_datetime]
      ,[end_datetime]
      ,[drop_datetime]
      ,[sent_datetime]
      ,[sent_count]
      ,[mm_email_id]
      ,[mm_cell_id]
      ,[mm_user_email]
      ,[solicitation_status]
      ,[benefits]
      ,[attachment_filename]
	  ,[SourceFileName]
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM([solicitation_id]),'DBNULL_TEXT') + ISNULL(RTRIM([solicitation_name]),'DBNULL_TEXT') + ISNULL(RTRIM([solicitation_desc]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([status]),'DBNULL_TEXT') + ISNULL(RTRIM([reason]),'DBNULL_TEXT') + ISNULL(RTRIM([upd_user]),'DBNULL_TEXT') + ISNULL(RTRIM([upd_datetime]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([acct_id]),'DBNULL_TEXT') + ISNULL(RTRIM([name_last]),'DBNULL_TEXT') + ISNULL(RTRIM([name_last_first_mi]),'DBNULL_TEXT') + ISNULL(RTRIM([email_addr]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([campaign_id]),'DBNULL_TEXT') + ISNULL(RTRIM([campaign_name]),'DBNULL_TEXT') + ISNULL(RTRIM([drive_year]),'DBNULL_TEXT') + ISNULL(RTRIM([item_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([item_name]),'DBNULL_TEXT') + ISNULL(RTRIM([list_id]),'DBNULL_TEXT') + ISNULL(RTRIM([list_name]),'DBNULL_TEXT') + ISNULL(RTRIM([list_count]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([solicitation_goal]),'DBNULL_TEXT') + ISNULL(RTRIM([solicitation_cost]),'DBNULL_TEXT') + ISNULL(RTRIM([contact_type_code]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([contact_type]),'DBNULL_TEXT') + ISNULL(RTRIM([solicitation_category]),'DBNULL_TEXT') + ISNULL(RTRIM([solicitation_category_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([start_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([end_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([drop_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([sent_datetime]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([sent_count]),'DBNULL_TEXT') + ISNULL(RTRIM([mm_email_id]),'DBNULL_TEXT') + ISNULL(RTRIM([mm_cell_id]),'DBNULL_TEXT') + ISNULL(RTRIM([mm_user_email]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([solicitation_status]),'DBNULL_TEXT') + ISNULL(RTRIM([benefits]),'DBNULL_TEXT') + ISNULL(RTRIM([attachment_filename]),'DBNULL_TEXT')) SrcHashKey
	, ROW_NUMBER() OVER(PARTITION BY solicitation_id ORDER BY solicitation_id) AS MergeRank
  FROM [src].[TM_Solicit]








GO
