CREATE TABLE [dbo].[FactPointOfSaleDetail]
(
[FactPointOfSaleDetailId] [bigint] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FactPointOfSaleId] [bigint] NOT NULL,
[DimProductId] [int] NOT NULL,
[Quantity] [int] NULL,
[UnitPrice] [numeric] (18, 4) NULL,
[Discount] [numeric] (18, 4) NULL,
[TotalPrice] [numeric] (18, 4) NULL,
[ItemAttribute] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[FactPointOfSaleDetail] ADD CONSTRAINT [PK__FactPointOfSaleDetail] PRIMARY KEY CLUSTERED  ([FactPointOfSaleDetailId])
GO
