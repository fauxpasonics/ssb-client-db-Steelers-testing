CREATE TABLE [dbo].[DimItem]
(
[DimItemId] [int] NOT NULL IDENTITY(1, 1),
[DimSeasonId] [int] NOT NULL,
[ItemCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemDesc] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemClass] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSCreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSUpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSCreatedDate] [datetime] NULL,
[SSUpdatedDate] [datetime] NULL,
[SSID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSID_event_id] [int] NULL,
[SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeltaHashKey] [binary] (32) NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_DimItem_CreateDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_DimItem_UpdateDate] DEFAULT (getdate()),
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_DimItem_DeleteFlag] DEFAULT ((0)),
[DeleteDate] [datetime] NULL,
[Config_IsFactSalesEligible] [bit] NULL,
[Config_IsClosed] [bit] NULL,
[DimSeasonHeaderId] [int] NULL
)
GO
ALTER TABLE [dbo].[DimItem] ADD CONSTRAINT [PK_DimItem] PRIMARY KEY CLUSTERED  ([DimItemId])
GO
CREATE NONCLUSTERED INDEX [IDX_Config_IsClosed] ON [dbo].[DimItem] ([Config_IsClosed])
GO
CREATE NONCLUSTERED INDEX [IDX_Config_IsFactSalesEligible] ON [dbo].[DimItem] ([Config_IsFactSalesEligible])
GO
CREATE NONCLUSTERED INDEX [IDX_DimSeasonId] ON [dbo].[DimItem] ([DimSeasonId])
GO
CREATE NONCLUSTERED INDEX [IDX_ItemCode] ON [dbo].[DimItem] ([ItemCode])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LoadKey] ON [dbo].[DimItem] ([SourceSystem], [SSID_event_id])
GO
CREATE NONCLUSTERED INDEX [IX_UpdatedDate] ON [dbo].[DimItem] ([UpdatedDate] DESC)
GO
