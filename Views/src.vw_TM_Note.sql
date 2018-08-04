SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [src].[vw_TM_Note]
as
SELECT [note_id]
      ,[acct_id]
      ,[add_user]
      ,[add_datetime]
      ,[note_type]
      ,[upd_Datetime]
      ,[upd_user]
      ,[contact_category]
      ,[contact_subcategory]
      ,[contact_response]
      ,[contact_type]
      ,[task_Type]
      ,[text]
      ,[priority]
      ,[alert_id]
      ,[alert_name]
	  ,[task_stage_seq_num]
      ,[task_activity_code]
      ,[task_result_code]
      ,[task_stage_status_code]
      ,[task_activity]
      ,[task_result]
      ,[task_stage_status]
      ,[task_assigned_to_user_id]
      ,[task_assigned_to_dept_id]
      ,[task_dept_name]
      ,[task_assignee_notified]
      ,[task_duration]
      ,[task_stage_text]
      ,[task_start_date]
      ,[task_end_date]
      ,[task_probability_to_close]
      ,[task_probability_to_close_name]
	  ,[SourceFileName]
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),[note_id])),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),[acct_id])),'DBNULL_BIGINT') + ISNULL(RTRIM([add_user]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM(CONVERT(varchar(25),[add_datetime])),'DBNULL_DATETIME') + ISNULL(RTRIM([note_type]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),[upd_Datetime])),'DBNULL_DATETIME') + 
	  ISNULL(RTRIM([upd_user]),'DBNULL_TEXT') + ISNULL(RTRIM([contact_category]),'DBNULL_TEXT') + ISNULL(RTRIM([contact_subcategory]),'DBNULL_TEXT') + ISNULL(RTRIM([contact_response]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([contact_type]),'DBNULL_TEXT') + ISNULL(RTRIM([task_Type]),'DBNULL_TEXT') + ISNULL(RTRIM([priority]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([alert_id]),'DBNULL_TEXT') + ISNULL(RTRIM([alert_name]),'DBNULL_TEXT') + ISNULL(RTRIM([task_stage_seq_num]),'DBNULL_TEXT') + ISNULL(RTRIM([task_activity_code]),'DBNULL_TEXT')
	   + ISNULL(RTRIM([task_result_code]),'DBNULL_TEXT') + ISNULL(RTRIM([task_stage_status_code]),'DBNULL_TEXT') + ISNULL(RTRIM([task_activity]),'DBNULL_TEXT') + ISNULL(RTRIM([task_result]),'DBNULL_TEXT')
	    + ISNULL(RTRIM([task_stage_status]),'DBNULL_TEXT') + ISNULL(RTRIM([task_assigned_to_user_id]),'DBNULL_TEXT') + ISNULL(RTRIM([task_assigned_to_dept_id]),'DBNULL_TEXT') + ISNULL(RTRIM([task_dept_name]),'DBNULL_TEXT')
		 + ISNULL(RTRIM([task_assignee_notified]),'DBNULL_TEXT') + ISNULL(RTRIM([task_duration]),'DBNULL_TEXT') + ISNULL(RTRIM([task_start_date]),'DBNULL_TEXT')
		  + ISNULL(RTRIM([task_end_date]),'DBNULL_TEXT') + ISNULL(RTRIM([task_probability_to_close]),'DBNULL_TEXT') + ISNULL(RTRIM([task_probability_to_close_name]),'DBNULL_TEXT')) SrcHashKey
	, ROW_NUMBER() OVER(PARTITION BY note_id, task_stage_seq_num ORDER BY upd_Datetime) AS MergeRank
  FROM  [src].[TM_Note]











GO
