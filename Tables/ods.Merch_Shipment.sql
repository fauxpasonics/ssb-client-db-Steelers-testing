CREATE TABLE [ods].[Merch_Shipment]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
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
