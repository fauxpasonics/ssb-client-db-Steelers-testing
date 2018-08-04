CREATE TABLE [zzz].[ods__TM_Note_bkp_700Rollout]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[note_id] [bigint] NULL,
[acct_id] [bigint] NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_datetime] [datetime] NULL,
[note_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_Datetime] [datetime] NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_subcategory] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_response] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[task_stage_text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_start_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_end_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_probability_to_close] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_probability_to_close_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF__TM_Note__InsertD__3A179ED3] DEFAULT (getdate()),
[UpdateDate] [datetime] NULL CONSTRAINT [DF__TM_Note__UpdateD__3B0BC30C] DEFAULT (getdate()),
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_Note_bkp_700Rollout] ADD CONSTRAINT [PK__TM_Note__3213E83FDF8239A5] PRIMARY KEY CLUSTERED  ([id])
GO
CREATE NONCLUSTERED INDEX [IDX_TM_Note_noteid_taskstageseqnum] ON [zzz].[ods__TM_Note_bkp_700Rollout] ([note_id], [task_stage_seq_num])
GO
