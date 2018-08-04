CREATE TABLE [segmentation].[SegmentationFlatData4a1970fa-fa60-435c-b279-f8e5d4023974]
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
ALTER TABLE [segmentation].[SegmentationFlatData4a1970fa-fa60-435c-b279-f8e5d4023974] ADD CONSTRAINT [pk_SegmentationFlatData4a1970fa-fa60-435c-b279-f8e5d4023974] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData4a1970fa-fa60-435c-b279-f8e5d4023974] ON [segmentation].[SegmentationFlatData4a1970fa-fa60-435c-b279-f8e5d4023974] ([_rn])
GO
