CREATE TABLE [dbo].[DimPriceCodeMaster]
(
[DimPriceCodeMasterId] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedBy] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_UpdatedBy] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[PriceCode] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC1] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC2] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC3] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC4] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[DimPriceCodeMaster] ADD CONSTRAINT [PK__DimPriceCodeMaster] PRIMARY KEY CLUSTERED  ([DimPriceCodeMasterId])
GO
CREATE NONCLUSTERED INDEX [IX_ETL_UpdatedDate] ON [dbo].[DimPriceCodeMaster] ([ETL_UpdatedDate] DESC)
GO
CREATE NONCLUSTERED INDEX [IDX_PC1] ON [dbo].[DimPriceCodeMaster] ([PC1])
GO
CREATE NONCLUSTERED INDEX [IDX_PC2] ON [dbo].[DimPriceCodeMaster] ([PC2])
GO
CREATE NONCLUSTERED INDEX [IDX_PC3] ON [dbo].[DimPriceCodeMaster] ([PC3])
GO
CREATE NONCLUSTERED INDEX [IDX_PC4] ON [dbo].[DimPriceCodeMaster] ([PC4])
GO
CREATE NONCLUSTERED INDEX [IDX_PriceCode] ON [dbo].[DimPriceCodeMaster] ([PriceCode])
GO
