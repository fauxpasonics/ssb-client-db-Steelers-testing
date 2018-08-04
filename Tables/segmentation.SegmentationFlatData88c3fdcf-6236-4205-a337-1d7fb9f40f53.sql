CREATE TABLE [segmentation].[SegmentationFlatData88c3fdcf-6236-4205-a337-1d7fb9f40f53]
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
ALTER TABLE [segmentation].[SegmentationFlatData88c3fdcf-6236-4205-a337-1d7fb9f40f53] ADD CONSTRAINT [pk_SegmentationFlatData88c3fdcf-6236-4205-a337-1d7fb9f40f53] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData88c3fdcf-6236-4205-a337-1d7fb9f40f53] ON [segmentation].[SegmentationFlatData88c3fdcf-6236-4205-a337-1d7fb9f40f53] ([_rn])
GO
