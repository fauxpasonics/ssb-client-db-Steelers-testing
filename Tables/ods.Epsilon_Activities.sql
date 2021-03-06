CREATE TABLE [ods].[Epsilon_Activities]
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
CREATE NONCLUSTERED INDEX [IDX_Action] ON [ods].[Epsilon_Activities] ([Action])
GO
CREATE NONCLUSTERED INDEX [IDX_ActionTimestamp] ON [ods].[Epsilon_Activities] ([ActionTimestamp])
GO
CREATE NONCLUSTERED INDEX [IDX_CustomerKey] ON [ods].[Epsilon_Activities] ([CustomerKey])
GO
CREATE NONCLUSTERED INDEX [IX_File] ON [ods].[Epsilon_Activities] ([ETL_FileName])
GO
CREATE NONCLUSTERED INDEX [IDX_MessageName] ON [ods].[Epsilon_Activities] ([MessageName])
GO
