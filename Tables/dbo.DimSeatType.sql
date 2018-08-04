CREATE TABLE [dbo].[DimSeatType]
(
[DimSeatTypeId] [int] NOT NULL IDENTITY(1, 1),
[SeatTypeCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeatTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeatTypeDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[IsDeleted] [bit] NOT NULL,
[DeletedDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[DimSeatType] ADD CONSTRAINT [PK_DimSeatType] PRIMARY KEY CLUSTERED  ([DimSeatTypeId])
GO
