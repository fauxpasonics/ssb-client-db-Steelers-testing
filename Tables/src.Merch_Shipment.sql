CREATE TABLE [src].[Merch_Shipment]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[Id] [int] NULL,
[AdminComment] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOnUtc] [datetime] NULL,
[LastTimeStamp] [binary] (8) NULL,
[OrderId] [int] NULL,
[TrackingNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalWeight] [numeric] (18, 4) NULL,
[ShippedDateUtc] [datetime] NULL,
[DeliveryDateUtc] [datetime] NULL
)
GO
