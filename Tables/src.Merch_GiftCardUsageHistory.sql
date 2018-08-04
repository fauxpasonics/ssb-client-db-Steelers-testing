CREATE TABLE [src].[Merch_GiftCardUsageHistory]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[LastTimeStamp] [binary] (8) NULL,
[Id] [int] NULL,
[GiftCardId] [int] NULL,
[UsedWithOrderId] [int] NULL,
[UsedValue] [numeric] (18, 4) NULL,
[CreatedOnUtc] [datetime] NULL
)
GO
