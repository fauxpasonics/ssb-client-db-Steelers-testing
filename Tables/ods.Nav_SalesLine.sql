CREATE TABLE [ods].[Nav_SalesLine]
(
[DocumentNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LineNo] [int] NOT NULL,
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
[ETL_CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__Nav_Sales__ETL_C__3EAF3B2C] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Nav_Sales__ETL_C__3FA35F65] DEFAULT (suser_sname()),
[ETL_UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__Nav_Sales__ETL_U__4097839E] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Nav_Sales__ETL_U__418BA7D7] DEFAULT (suser_sname())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----------- CREATE TRIGGER -----------
CREATE TRIGGER [ods].[Snapshot_Nav_SalesLineUpdate] ON [ods].[Nav_SalesLine]
AFTER UPDATE, DELETE

AS
BEGIN

DECLARE @ETL_UpdatedOn DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS DATETIME2(0))))
DECLARE @ETL_UpdatedBy NVARCHAR(400) = (SELECT SYSTEM_USER)

UPDATE t SET
[ETL_UpdatedOn] = @ETL_UpdatedOn
,[ETL_UpdatedBy] = @ETL_UpdatedBy
FROM [ods].[Nav_SalesLine] t
	JOIN inserted i ON  t.[DocumentNo] = i.[DocumentNo] AND t.[LineNo] = i.[LineNo]

INSERT INTO [ods].[Snapshot_Nav_SalesLine] ([DocumentNo],[LineNo],[ItemNo],[Description],[Quantity],[UnitPrice],[LineDiscountPercent],[LineDiscountAmount],[Amount],[AmountIncludingTax],[DropShipment],[TaxLiable],[LineAmount],[VariantCode],[Category],[SubCategory],[AppliedRuleIDs],[DepartmentDescription],[CategoryDescription],[SubCategoryDescription],[Department],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate])
SELECT a.*,dateadd(s,-1,@ETL_UpdatedOn)
FROM deleted a

END
GO
ALTER TABLE [ods].[Nav_SalesLine] ADD CONSTRAINT [PK__Nav_Sale__6854CD8A9B95E43D] PRIMARY KEY CLUSTERED  ([DocumentNo], [LineNo])
GO
