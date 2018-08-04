CREATE TABLE [zzz].[ods__TM_PaySchedule_bkp_700Rollout]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[acct_id] [int] NULL,
[payment_schedule_id] [int] NULL,
[invoice_id] [int] NULL,
[payment_plan_id] [int] NULL,
[comments] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_datetime] [datetime] NULL,
[payment_plan_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[periods] [int] NULL,
[last_period_paid] [int] NULL,
[purchase_amount] [decimal] (18, 6) NULL,
[paid_amount] [decimal] (18, 6) NULL,
[percent_due] [decimal] (18, 6) NULL,
[percent_paid] [decimal] (18, 6) NULL,
[compliant] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[effective_Date] [datetime] NULL,
[expiration_date] [datetime] NULL,
[inet_effective_Date] [datetime] NULL,
[inet_expiration_Date] [datetime] NULL,
[inet_plan_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[payment_plan_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_payment_number] [int] NULL,
[period_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[start_date] [datetime] NULL,
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_PaySchedule_bkp_700Rollout] ADD CONSTRAINT [PK__TM_PaySc__3213E83F4A417355] PRIMARY KEY CLUSTERED  ([id])
GO
