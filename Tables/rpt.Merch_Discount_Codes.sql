CREATE TABLE [rpt].[Merch_Discount_Codes]
(
[DiscountID] [int] NOT NULL,
[Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiscountType] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiscountPercentage] [decimal] (4, 3) NULL,
[DiscountAmount] [numeric] (18, 2) NULL,
[IsFreeItem] [bit] NULL
)
GO
ALTER TABLE [rpt].[Merch_Discount_Codes] ADD CONSTRAINT [PK_Merch_Discount_Codes_DiscountID] PRIMARY KEY CLUSTERED  ([DiscountID])
GO
