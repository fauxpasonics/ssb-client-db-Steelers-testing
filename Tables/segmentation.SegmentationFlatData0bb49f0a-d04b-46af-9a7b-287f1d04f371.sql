CREATE TABLE [segmentation].[SegmentationFlatData0bb49f0a-d04b-46af-9a7b-287f1d04f371]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source_System] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsLoyalty] [int] NOT NULL,
[Total_Merch_Qty] [int] NULL,
[Total_Merch_Spend] [numeric] (38, 4) NULL,
[Most_Recent_Sale_Date] [date] NULL,
[Most_Recent_Sale_Year] [int] NULL,
[Most_Recent_Sale_Month] [int] NULL,
[Merch_Qty_In_Last_30_Days] [int] NULL,
[Merch_Spend_In_Last_30_Days] [numeric] (38, 4) NULL,
[Merch_Qty_In_Last_60_Days] [int] NULL,
[Merch_Spend_In_Last_60_Days] [numeric] (38, 4) NULL,
[Merch_Qty_In_Last_90_Days] [int] NULL,
[Merch_Spend_In_Last_90_Days] [numeric] (38, 4) NULL,
[Merch_Qty_In_Last_365_Days] [int] NULL,
[Merch_Spend_In_Last_365_Days] [numeric] (38, 4) NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData0bb49f0a-d04b-46af-9a7b-287f1d04f371] ADD CONSTRAINT [pk_SegmentationFlatData0bb49f0a-d04b-46af-9a7b-287f1d04f371] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData0bb49f0a-d04b-46af-9a7b-287f1d04f371] ON [segmentation].[SegmentationFlatData0bb49f0a-d04b-46af-9a7b-287f1d04f371] ([_rn])
GO
