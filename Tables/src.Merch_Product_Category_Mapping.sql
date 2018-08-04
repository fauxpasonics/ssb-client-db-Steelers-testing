CREATE TABLE [src].[Merch_Product_Category_Mapping]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[LastTimeStamp] [binary] (8) NULL,
[Id] [int] NULL,
[DisplayOrder] [int] NULL,
[ProductId] [int] NULL,
[CategoryId] [int] NULL,
[IsFeaturedProduct] [bit] NULL
)
GO
