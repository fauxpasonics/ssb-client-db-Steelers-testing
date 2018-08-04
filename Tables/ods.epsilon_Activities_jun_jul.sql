CREATE TABLE [ods].[epsilon_Activities_jun_jul]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionTimestamp] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkURL] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceTransactionID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrgId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeploymentID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceCategory] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceSubcategory] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeviceType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConversionTransactionId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConversionAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConversionQuantity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConversionOrderId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConversionCategory] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConversionSubcategory] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConversionDateTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UndeliveredCategory] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_Action] ON [ods].[epsilon_Activities_jun_jul] ([Action])
GO
CREATE NONCLUSTERED INDEX [IX_ActionTimeStamp] ON [ods].[epsilon_Activities_jun_jul] ([ActionTimestamp])
GO
CREATE NONCLUSTERED INDEX [IX_CustomerKey] ON [ods].[epsilon_Activities_jun_jul] ([CustomerKey])
GO
CREATE NONCLUSTERED INDEX [IX_ServiceTransactionID] ON [ods].[epsilon_Activities_jun_jul] ([ServiceTransactionID])
GO
