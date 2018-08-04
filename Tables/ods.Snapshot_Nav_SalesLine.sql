CREATE TABLE [ods].[Snapshot_Nav_SalesLine]
(
[Nav_SalesLineSK] [int] NOT NULL IDENTITY(1, 1),
[DocumentNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineNo] [int] NULL,
[ItemNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NULL,
[UnitPrice] [numeric] (18, 2) NULL,
[LineDiscountPercent] [numeric] (18, 2) NULL,
[LineDiscountAmount] [numeric] (18, 2) NULL,
[Amount] [numeric] (18, 2) NULL,
[AmountIncludingTax] [numeric] (18, 2) NULL,
[DropShipment] [bit] NULL,
[TaxLiable] [bit] NULL,
[LineAmount] [numeric] (18, 2) NULL,
[VariantCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubCategory] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AppliedRuleIDs] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartmentDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CategoryDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubCategoryDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Department] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NULL,
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_UpdatedOn] [datetime] NULL,
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordEndDate] [datetime] NULL
)
GO
ALTER TABLE [ods].[Snapshot_Nav_SalesLine] ADD CONSTRAINT [PK__Snapshot__D0D53119D2F66461] PRIMARY KEY CLUSTERED  ([Nav_SalesLineSK])
GO
