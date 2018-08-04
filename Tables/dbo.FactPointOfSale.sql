CREATE TABLE [dbo].[FactPointOfSale]
(
[FactPointOfSaleId] [bigint] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DimDateId_SaleDate] [int] NOT NULL,
[DimDateId_PaymentDate] [int] NOT NULL,
[DimDateId_ShipmentDate] [int] NOT NULL,
[DimDateId_DeliveryDate] [int] NOT NULL,
[DimAccountId] [bigint] NOT NULL,
[DimEventHeaderId] [int] NOT NULL,
[DimStoreId] [int] NOT NULL,
[DimRevenueCenterId] [int] NOT NULL,
[DimWorkstationId] [int] NOT NULL,
[DimEmployeeId] [int] NOT NULL,
[SaleDate] [datetime] NOT NULL,
[PaymentDate] [datetime] NULL,
[ShipmentDate] [datetime] NULL,
[DeliveryDate] [datetime] NULL,
[SubTotal] [numeric] (18, 4) NULL,
[Tax] [numeric] (18, 4) NULL,
[Shipping] [numeric] (18, 4) NULL,
[Other] [numeric] (18, 4) NULL,
[Discount] [numeric] (18, 4) NULL,
[GiftCardAmtApplied] [numeric] (18, 4) NULL,
[OrderTotal] [numeric] (18, 4) NULL,
[Refund] [numeric] (18, 4) NULL,
[OrderId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentMethod] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingMethod] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[FactPointOfSale] ADD CONSTRAINT [PK__[FactPointOfSale] PRIMARY KEY CLUSTERED  ([FactPointOfSaleId])
GO
