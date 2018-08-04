CREATE TABLE [ods].[Merch_GiftCardUsageHistory]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[LastTimeStamp] [binary] (8) NULL,
[Id] [int] NULL,
[GiftCardId] [int] NULL,
[UsedWithOrderId] [int] NULL,
[UsedValue] [numeric] (18, 4) NULL,
[CreatedOnUtc] [datetime] NULL
)
GO
