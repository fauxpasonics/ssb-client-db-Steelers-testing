CREATE TABLE [segmentation].[SegmentationFlatData0102fce3-4c6c-42d6-821a-f293963e8992]
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
ALTER TABLE [segmentation].[SegmentationFlatData0102fce3-4c6c-42d6-821a-f293963e8992] ADD CONSTRAINT [pk_SegmentationFlatData0102fce3-4c6c-42d6-821a-f293963e8992] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData0102fce3-4c6c-42d6-821a-f293963e8992] ON [segmentation].[SegmentationFlatData0102fce3-4c6c-42d6-821a-f293963e8992] ([_rn])
GO
