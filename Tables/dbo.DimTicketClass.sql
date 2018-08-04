CREATE TABLE [dbo].[DimTicketClass]
(
[DimTicketClassId] [int] NOT NULL IDENTITY(1, 1),
[TicketClassCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketClassName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketClassDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketClassGroup] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketClassType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_DimTicketClass_CreatedDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_DimTicketClass_UpdatedDate] DEFAULT (getdate()),
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_DimTicketClass_DeleteFlag] DEFAULT ((0)),
[DeletedDate] [datetime] NULL,
[DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [dbo].[DimTicketClass] ADD CONSTRAINT [PK_DimTicketClass] PRIMARY KEY CLUSTERED  ([DimTicketClassId])
GO
