CREATE TABLE [segmentation].[SegmentationFlatData22d5e26f-90d8-454f-acb4-df1751b58745]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerSourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData22d5e26f-90d8-454f-acb4-df1751b58745] ADD CONSTRAINT [pk_SegmentationFlatData22d5e26f-90d8-454f-acb4-df1751b58745] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData22d5e26f-90d8-454f-acb4-df1751b58745] ON [segmentation].[SegmentationFlatData22d5e26f-90d8-454f-acb4-df1751b58745] ([_rn])
GO
