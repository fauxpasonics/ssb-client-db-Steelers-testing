CREATE TABLE [segmentation].[SegmentationFlatDataece6399e-e77b-4ad8-b36e-4a9bfd31e147]
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
ALTER TABLE [segmentation].[SegmentationFlatDataece6399e-e77b-4ad8-b36e-4a9bfd31e147] ADD CONSTRAINT [pk_SegmentationFlatDataece6399e-e77b-4ad8-b36e-4a9bfd31e147] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDataece6399e-e77b-4ad8-b36e-4a9bfd31e147] ON [segmentation].[SegmentationFlatDataece6399e-e77b-4ad8-b36e-4a9bfd31e147] ([_rn])
GO
