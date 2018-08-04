CREATE TABLE [src].[Merch_DiscountUsageHistory]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[Id] [int] NOT NULL,
[DiscountId] [int] NOT NULL,
[OrderId] [int] NOT NULL,
[CreatedOnUtc] [datetime] NOT NULL,
[LastTimeStamp] [binary] (8) NULL
)
GO
