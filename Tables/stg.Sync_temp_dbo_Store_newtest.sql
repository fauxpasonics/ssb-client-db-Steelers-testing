CREATE TABLE [stg].[Sync_temp_dbo_Store_newtest]
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
[ETL_Sync_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [stg].[Sync_temp_dbo_Store_newtest] ADD CONSTRAINT [PK__Sync_tem__19364FD23273A4C0] PRIMARY KEY CLUSTERED  ([ETL_Sync_Id])
GO
