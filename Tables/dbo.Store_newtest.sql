CREATE TABLE [dbo].[Store_newtest]
(
[Id] [int] NOT NULL,
[Name] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Url] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SslEnabled] [bit] NOT NULL,
[SecureUrl] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hosts] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NOT NULL,
[CompanyName] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyAddress] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyPhoneNumber] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyVat] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastTimeStamp] [timestamp] NOT NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
