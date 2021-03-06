CREATE TABLE [src].[Merch_OrderItem]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[LastTimeStamp] [binary] (8) NULL,
[Id] [int] NOT NULL,
[OrderItemGuid] [uniqueidentifier] NULL,
[OrderId] [int] NULL,
[ProductId] [int] NULL,
[Quantity] [int] NULL,
[UnitPriceInclTax] [numeric] (18, 4) NULL,
[UnitPriceExclTax] [numeric] (18, 4) NULL,
[PriceInclTax] [numeric] (18, 4) NULL,
[PriceExclTax] [numeric] (18, 4) NULL,
[DiscountAmountInclTax] [numeric] (18, 4) NULL,
[DiscountAmountExclTax] [numeric] (18, 4) NULL,
[OriginalProductCost] [numeric] (18, 4) NULL,
[AttributeDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttributesXml] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DownloadCount] [int] NULL,
[IsDownloadActivated] [bit] NULL,
[LicenseDownloadId] [int] NULL,
[ItemWeight] [numeric] (18, 4) NULL,
[RentalStartDateUtc] [datetime] NULL,
[RentalEndDateUtc] [datetime] NULL,
[ProductSku] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
