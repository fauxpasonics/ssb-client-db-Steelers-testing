CREATE TABLE [dbo].[DimTicketType]
(
[DimTicketTypeId] [int] NOT NULL IDENTITY(1, 1),
[TicketTypeCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketTypeDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketTypeClass] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[IsDeleted] [bit] NOT NULL,
[DeletedDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[DimTicketType] ADD CONSTRAINT [PK_DimTicketType] PRIMARY KEY CLUSTERED  ([DimTicketTypeId])
GO
