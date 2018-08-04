CREATE TABLE [src].[Merch_SNUOrderInfo]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[SnuId] [int] NULL,
[CustomerId] [int] NULL,
[OrderId] [int] NULL,
[CustomerEmailId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsCompleted] [bit] NULL,
[DateCreated] [datetime] NULL
)
GO
