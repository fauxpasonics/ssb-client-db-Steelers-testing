CREATE TABLE [zzz].[ods__TM_CustRep_bkp_700Rollout]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[acct_id] [int] NULL,
[acct_rep_id] [int] NULL,
[acct_rep_type] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_rep_type_name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_cust_name_id] [int] NULL,
[rep_name_first] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_name_middle] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_name_last] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_name_title] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_company_name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_nick_name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_name_last_first_mi] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_full_name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_user_id] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_email_addr] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_phone] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_phone_formatted] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL,
[UpdatedDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_CustRep_bkp_700Rollout] ADD CONSTRAINT [PK_TM_CustRep] PRIMARY KEY CLUSTERED  ([id])
GO
