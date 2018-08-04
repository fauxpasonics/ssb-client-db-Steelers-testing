CREATE TABLE [zzz].[archive__TM_ListCode_bkp_700Rollout]
(
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[value] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sort_seq] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE NONCLUSTERED INDEX [IDX_CreatedDate] ON [zzz].[archive__TM_ListCode_bkp_700Rollout] ([CreatedDate])
GO
CREATE NONCLUSTERED INDEX [IDX_TMListCode_SourceFileName] ON [zzz].[archive__TM_ListCode_bkp_700Rollout] ([SourceFileName])
GO
