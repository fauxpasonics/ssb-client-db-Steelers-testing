CREATE TABLE [dbo].[DimStore]
(
[DimStoreId] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeleteDate] [datetime] NULL,
[ETL_SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_SSID_Id] [int] NOT NULL,
[StoreName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoreAddress1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoreAddress2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoreAddress3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoreCity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoreState] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoreZip1] [smallint] NULL,
[StoreZip2] [smallint] NULL,
[StorePhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoreWebsite] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[DimStore] ADD CONSTRAINT [PK_DimStore] PRIMARY KEY CLUSTERED  ([DimStoreId])
GO
