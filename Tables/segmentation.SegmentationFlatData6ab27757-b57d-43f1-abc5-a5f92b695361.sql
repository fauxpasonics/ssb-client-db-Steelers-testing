CREATE TABLE [segmentation].[SegmentationFlatData6ab27757-b57d-43f1-abc5-a5f92b695361]
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
ALTER TABLE [segmentation].[SegmentationFlatData6ab27757-b57d-43f1-abc5-a5f92b695361] ADD CONSTRAINT [pk_SegmentationFlatData6ab27757-b57d-43f1-abc5-a5f92b695361] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData6ab27757-b57d-43f1-abc5-a5f92b695361] ON [segmentation].[SegmentationFlatData6ab27757-b57d-43f1-abc5-a5f92b695361] ([_rn])
GO
