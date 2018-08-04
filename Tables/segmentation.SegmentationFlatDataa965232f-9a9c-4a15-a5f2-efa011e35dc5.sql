CREATE TABLE [segmentation].[SegmentationFlatDataa965232f-9a9c-4a15-a5f2-efa011e35dc5]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source_System] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsLoyalty] [int] NOT NULL,
[IsDiscount] [int] NOT NULL,
[IsComp] [int] NOT NULL,
[Promo_Code] [int] NULL,
[Tender] [int] NULL,
[Store_Name] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Store_Id] [int] NOT NULL,
[Qty_Item] [int] NULL,
[Item_Unit_Price] [numeric] (18, 4) NULL,
[Item_Total_Price] [numeric] (18, 4) NULL,
[Item_Attribute] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item_Name] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sku] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tag_Name] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sale_Date] [date] NULL,
[Sale_Year] [int] NULL,
[Sale_Month] [int] NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatDataa965232f-9a9c-4a15-a5f2-efa011e35dc5] ADD CONSTRAINT [pk_SegmentationFlatDataa965232f-9a9c-4a15-a5f2-efa011e35dc5] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDataa965232f-9a9c-4a15-a5f2-efa011e35dc5] ON [segmentation].[SegmentationFlatDataa965232f-9a9c-4a15-a5f2-efa011e35dc5] ([_rn])
GO
