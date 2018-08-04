CREATE TABLE [src].[Merch_Store]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[Id] [int] NULL,
[Name] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Url] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SslEnabled] [bit] NULL,
[SecureUrl] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hosts] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NULL,
[CompanyName] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyAddress] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyPhoneNumber] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyVat] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastTimeStamp] [binary] (8) NULL
)
GO
