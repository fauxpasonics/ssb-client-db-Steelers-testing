CREATE TABLE [ods].[Merch_DiscountUsageHistory]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[Id] [int] NOT NULL,
[DiscountId] [int] NOT NULL,
[OrderId] [int] NOT NULL,
[CreatedOnUtc] [datetime] NOT NULL,
[LastTimeStamp] [binary] (8) NULL
)
GO
