CREATE TABLE [dbo].[FactInventory]
(
[FactInventoryId] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NULL,
[ETL_UpdatedDate] [datetime] NULL,
[DimArenaId] [int] NOT NULL,
[DimSeasonId] [int] NOT NULL,
[DimEventId] [int] NOT NULL,
[DimSeatId] [int] NOT NULL,
[SoldDimCustomerId] [bigint] NULL,
[SoldDimDateId] [int] NULL,
[SoldDimTimeId] [int] NULL,
[SoldDimItemId] [int] NULL,
[SoldDimPlanId] [int] NULL,
[SoldDimPriceCodeId] [int] NULL,
[SoldDimSalesCodeId] [int] NULL,
[SoldDimPromoId] [int] NULL,
[SoldDimTicketClassId] [int] NULL,
[SoldDateTime] [datetime] NULL,
[SoldDimClassTMId] [int] NULL,
[ManifestDimPriceCodeId] [int] NOT NULL,
[ManifestDimClassTMId] [int] NOT NULL,
[ManifestSeatValue] [numeric] (18, 6) NOT NULL,
[PostedDimPriceCodeId] [int] NULL,
[PostedDimClassTMId] [int] NULL,
[PostedSeatValue] [numeric] (18, 6) NULL,
[SeatStatus] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsAvailable] [bit] NOT NULL,
[IsSaleable] [bit] NOT NULL,
[IsSold] [bit] NOT NULL,
[IsHeld] [bit] NOT NULL,
[IsComp] [bit] NOT NULL,
[IsAttended] [bit] NOT NULL,
[ScanDateTime] [datetime] NULL,
[ScanGate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalRevenue] [decimal] (18, 6) NOT NULL,
[TicketRevenue] [decimal] (18, 6) NOT NULL,
[PcTicketValue] [decimal] (18, 6) NOT NULL,
[FullPrice] [decimal] (18, 6) NOT NULL,
[Discount] [decimal] (18, 6) NOT NULL,
[Surcharge] [decimal] (18, 6) NOT NULL,
[PurchasePrice] [decimal] (18, 6) NOT NULL,
[PcPrice] [decimal] (18, 6) NOT NULL,
[PcPrintedPrice] [decimal] (18, 6) NOT NULL,
[PcTicket] [decimal] (18, 6) NOT NULL,
[PcTax] [decimal] (18, 6) NOT NULL,
[PcLicenseFee] [decimal] (18, 6) NOT NULL,
[PcOther1] [decimal] (18, 6) NOT NULL,
[PcOther2] [decimal] (18, 6) NOT NULL,
[SeatBlockSize] [int] NOT NULL,
[SoldOrderNum] [int] NULL,
[SoldOrderLineItem] [int] NULL,
[EventDateTime] [datetime] NOT NULL,
[IsResold] [int] NULL,
[ResoldDimCustomerId] [int] NULL,
[ResoldDimDateId] [int] NULL,
[ResoldDimTimeId] [int] NULL,
[ResoldDateTime] [datetime] NULL,
[ResoldPurchasePrice] [decimal] (18, 6) NULL,
[ResoldFees] [decimal] (18, 6) NULL,
[ResoldTotalAmount] [decimal] (18, 6) NULL,
[SoldDimLedgerId] [int] NULL,
[IsHost] [bit] NULL,
[IsReserved] [bit] NOT NULL,
[HeldDimPriceCodeId] [int] NULL,
[HeldDimClassTMId] [int] NULL,
[HeldSeatValue] [decimal] (18, 6) NULL,
[FactTicketSalesId] [bigint] NULL
)
GO
ALTER TABLE [dbo].[FactInventory] ADD CONSTRAINT [PK_FactInventory] PRIMARY KEY CLUSTERED  ([FactInventoryId])
GO
CREATE NONCLUSTERED INDEX [IDX_DimEventId_DimSeatId] ON [dbo].[FactInventory] ([DimEventId], [DimSeatId])
GO
CREATE NONCLUSTERED INDEX [IX_DimSeasonId] ON [dbo].[FactInventory] ([DimSeasonId]) INCLUDE ([DimEventId], [DimSeatId], [FactTicketSalesId], [ManifestDimClassTMId], [ManifestDimPriceCodeId], [SoldDimCustomerId], [SoldDimPlanId])
GO
CREATE NONCLUSTERED INDEX [IX_ETL_UpdatedDate] ON [dbo].[FactInventory] ([ETL_UpdatedDate] DESC)
GO
CREATE NONCLUSTERED INDEX [IDX_FactTicketSalesId] ON [dbo].[FactInventory] ([FactTicketSalesId])
GO
CREATE NONCLUSTERED INDEX [IDX_IsAttended] ON [dbo].[FactInventory] ([IsAttended])
GO
CREATE NONCLUSTERED INDEX [IDX_IsAvailable_IsSaleable] ON [dbo].[FactInventory] ([IsAvailable], [IsSaleable])
GO
CREATE NONCLUSTERED INDEX [IDX_FactInventory_IsHeld] ON [dbo].[FactInventory] ([IsHeld])
GO
CREATE NONCLUSTERED INDEX [IDX_IsSold] ON [dbo].[FactInventory] ([IsSold])
GO
CREATE NONCLUSTERED INDEX [IX_FactInventory__IsSold] ON [dbo].[FactInventory] ([IsSold]) INCLUDE ([DimEventId], [DimSeasonId], [DimSeatId], [SoldDimDateId], [SoldDimPlanId])
GO
CREATE NONCLUSTERED INDEX [IX_FactInventory__ManifestDimPriceCodeId] ON [dbo].[FactInventory] ([ManifestDimPriceCodeId]) INCLUDE ([DimEventId], [DimSeasonId], [DimSeatId])
GO
CREATE NONCLUSTERED INDEX [IDX_FactoryInverntory_PostedDimPriceCodeId] ON [dbo].[FactInventory] ([PostedDimPriceCodeId])
GO
CREATE NONCLUSTERED INDEX [IDX_SoldDimCustomerId] ON [dbo].[FactInventory] ([SoldDimCustomerId])
GO
