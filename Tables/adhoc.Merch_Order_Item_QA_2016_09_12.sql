CREATE TABLE [adhoc].[Merch_Order_Item_QA_2016_09_12]
(
[Id] [int] NULL,
[OrderItemGuid] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderId] [int] NULL,
[ProductId] [smallint] NULL,
[Quantity] [smallint] NULL,
[UnitPriceInclTax] [real] NULL,
[UnitPriceExclTax] [real] NULL,
[PriceInclTax] [real] NULL,
[PriceExclTax] [real] NULL,
[DiscountAmountInclTax] [real] NULL,
[DiscountAmountExclTax] [real] NULL,
[OriginalProductCost] [smallint] NULL,
[AttributeDescription] [varchar] (90) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttributesXml] [varchar] (461) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DownloadCount] [smallint] NULL,
[IsDownloadActivated] [smallint] NULL,
[LicenseDownloadId] [smallint] NULL,
[ItemWeight] [smallint] NULL,
[RentalStartDateUtc] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RentalEndDateUtc] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastTimeStamp] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductSku] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeDeleted] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Deleted] [smallint] NULL
)
GO
