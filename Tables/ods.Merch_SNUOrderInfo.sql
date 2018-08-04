CREATE TABLE [ods].[Merch_SNUOrderInfo]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[SnuId] [int] NULL,
[CustomerId] [int] NULL,
[OrderId] [int] NULL,
[CustomerEmailId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsCompleted] [bit] NULL,
[DateCreated] [datetime] NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_CustomerId] ON [ods].[Merch_SNUOrderInfo] ([CustomerId])
GO
CREATE NONCLUSTERED INDEX [IDX_IsCompleted] ON [ods].[Merch_SNUOrderInfo] ([IsCompleted])
GO
CREATE NONCLUSTERED INDEX [IDX_SnuId] ON [ods].[Merch_SNUOrderInfo] ([SnuId])
GO
