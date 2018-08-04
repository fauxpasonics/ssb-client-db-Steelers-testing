CREATE TABLE [ods].[Merch_Address]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[Id] [int] NULL,
[CreatedOnUtc] [datetime] NULL,
[FirstName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryId] [int] NULL,
[StateProvinceId] [int] NULL,
[City] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipPostalCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FaxNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomAttributes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AutoIndex] [int] NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_MerchAddress_Id] ON [ods].[Merch_Address] ([Id])
GO
