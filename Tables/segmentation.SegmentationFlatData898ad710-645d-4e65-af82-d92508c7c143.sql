CREATE TABLE [segmentation].[SegmentationFlatData898ad710-645d-4e65-af82-d92508c7c143]
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
ALTER TABLE [segmentation].[SegmentationFlatData898ad710-645d-4e65-af82-d92508c7c143] ADD CONSTRAINT [pk_SegmentationFlatData898ad710-645d-4e65-af82-d92508c7c143] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData898ad710-645d-4e65-af82-d92508c7c143] ON [segmentation].[SegmentationFlatData898ad710-645d-4e65-af82-d92508c7c143] ([_rn])
GO
