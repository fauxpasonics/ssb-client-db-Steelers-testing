CREATE TABLE [zzz].[archive__TM_Note_bkp_700Rollout]
(
[note_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_datetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[note_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_Datetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_subcategory] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_response] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[priority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alert_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alert_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_stage_seq_num] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_activity_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_result_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_stage_status_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_activity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_result] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_stage_status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_assigned_to_user_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_assigned_to_dept_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_dept_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_assignee_notified] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_duration] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_stage_text] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_start_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_end_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_probability_to_close] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_probability_to_close_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__TM_Note__Created__41EDCAC5] DEFAULT (getdate())
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE NONCLUSTERED INDEX [IDX_CreatedDate] ON [zzz].[archive__TM_Note_bkp_700Rollout] ([CreatedDate])
GO
CREATE NONCLUSTERED INDEX [IDX_SourceFileName] ON [zzz].[archive__TM_Note_bkp_700Rollout] ([SourceFileName])
GO
