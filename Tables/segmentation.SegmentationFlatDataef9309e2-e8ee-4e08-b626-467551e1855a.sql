CREATE TABLE [segmentation].[SegmentationFlatDataef9309e2-e8ee-4e08-b626-467551e1855a]
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
ALTER TABLE [segmentation].[SegmentationFlatDataef9309e2-e8ee-4e08-b626-467551e1855a] ADD CONSTRAINT [pk_SegmentationFlatDataef9309e2-e8ee-4e08-b626-467551e1855a] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDataef9309e2-e8ee-4e08-b626-467551e1855a] ON [segmentation].[SegmentationFlatDataef9309e2-e8ee-4e08-b626-467551e1855a] ([_rn])
GO
