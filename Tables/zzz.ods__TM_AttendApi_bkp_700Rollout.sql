CREATE TABLE [zzz].[ods__TM_AttendApi_bkp_700Rollout]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NULL,
[ETL__UpdatedDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[section_id] [int] NULL,
[access_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ticket_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seat_num] [int] NULL,
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[valid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seq_num] [int] NULL,
[section_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plan_event_Id] [int] NULL,
[action_time] [time] NULL,
[scan_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_date] [date] NULL,
[print_count] [int] NULL,
[gate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mobile] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_id] [int] NULL,
[source_system] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[result_code] [int] NULL,
[channel_ind] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comp] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[result_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plan_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_id] [int] NULL,
[price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [int] NULL,
[ticket_acct_id] [int] NULL,
[row_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [zzz].[ods__TM_AttendApi_bkp_700Rollout] ADD CONSTRAINT [PK__TM_Atten__C4EA244539A50FEC] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO
CREATE NONCLUSTERED INDEX [IDX_LoadKey] ON [zzz].[ods__TM_AttendApi_bkp_700Rollout] ([event_id], [section_id], [row_id], [seat_num])
GO
CREATE NONCLUSTERED INDEX [IDX_result_code] ON [zzz].[ods__TM_AttendApi_bkp_700Rollout] ([result_code])
GO
