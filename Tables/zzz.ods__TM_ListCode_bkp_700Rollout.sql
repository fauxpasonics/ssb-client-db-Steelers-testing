CREATE TABLE [zzz].[ods__TM_ListCode_bkp_700Rollout]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[value] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sort_seq] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_ListCode_bkp_700Rollout] ADD CONSTRAINT [PK__TM_ListC__3213E83F177A5732] PRIMARY KEY CLUSTERED  ([id])
GO
