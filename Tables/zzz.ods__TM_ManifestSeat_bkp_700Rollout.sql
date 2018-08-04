CREATE TABLE [zzz].[ods__TM_ManifestSeat_bkp_700Rollout]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[arena_id] [int] NULL,
[manifest_id] [int] NULL,
[section_id] [int] NULL,
[section_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_type_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ga] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_id] [int] NULL,
[row_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seat_num] [int] NULL,
[num_seats] [int] NULL,
[last_seat] [int] NULL,
[seat_increment] [int] NULL,
[default_class] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[class_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[def_price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tm_section_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tm_row_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_info1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_info2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_info3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_info4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_info5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_info1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_info2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_info3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_info4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_info5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[manifest_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[arena_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[org_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[org_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF__TM_Manife__Inser__382F5661] DEFAULT (getdate()),
[UpdateDate] [datetime] NULL CONSTRAINT [DF__TM_Manife__Updat__39237A9A] DEFAULT (getdate()),
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_ManifestSeat_bkp_700Rollout] ADD CONSTRAINT [PK__TM_Manif__3213E83F5C4D7DE3] PRIMARY KEY CLUSTERED  ([id])
GO
CREATE NONCLUSTERED INDEX [IDX_BusinessKey] ON [zzz].[ods__TM_ManifestSeat_bkp_700Rollout] ([manifest_id], [section_id], [row_id], [seat_num])
GO
