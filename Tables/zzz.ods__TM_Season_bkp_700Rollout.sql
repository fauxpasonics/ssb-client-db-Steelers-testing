CREATE TABLE [zzz].[ods__TM_Season_bkp_700Rollout]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[season_id] [int] NULL,
[name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[arena_id] [int] NULL,
[manifest_id] [int] NULL,
[add_datetime] [datetime] NULL,
[upd_datetime] [datetime] NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[season_year] [int] NULL,
[org_id] [int] NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF__TM_Season__Inser__41B8C09B] DEFAULT (getdate()),
[UpdateDate] [datetime] NULL CONSTRAINT [DF__TM_Season__Updat__42ACE4D4] DEFAULT (getdate()),
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_Season_bkp_700Rollout] ADD CONSTRAINT [PK__TM_Seaso__3213E83F77AC1294] PRIMARY KEY CLUSTERED  ([id])
GO
