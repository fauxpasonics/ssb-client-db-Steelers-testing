CREATE TABLE [dbo].[DimPOSProduct]
(
[DimProductID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_SSID] [int] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductTypeId] [int] NULL,
[ProductName] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sku] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price] [numeric] (18, 4) NULL
)
GO
