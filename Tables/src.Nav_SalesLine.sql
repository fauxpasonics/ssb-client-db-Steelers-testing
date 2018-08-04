CREATE TABLE [src].[Nav_SalesLine]
(
[SK] [bigint] NULL,
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[L1_AllData_odata.metadata] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[L2_AllData_value_] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentNo] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineNo] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[No] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnitPrice] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineDiscountPercent] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineDiscountAmount] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmountIncludingTax] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DropShipment] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxLiable] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineAmount] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VariantCode] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubCategory] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AppliedRuleIDs] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartmentDescription] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CategoryDescription] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubCategoryDescription] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Department] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[L3_AllData_value_ETag] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO