CREATE TABLE [segmentation].[SegmentationFlatData805ac938-7ad4-4b34-b1d6-95cac64b624d]
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
ALTER TABLE [segmentation].[SegmentationFlatData805ac938-7ad4-4b34-b1d6-95cac64b624d] ADD CONSTRAINT [pk_SegmentationFlatData805ac938-7ad4-4b34-b1d6-95cac64b624d] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData805ac938-7ad4-4b34-b1d6-95cac64b624d] ON [segmentation].[SegmentationFlatData805ac938-7ad4-4b34-b1d6-95cac64b624d] ([_rn])
GO
