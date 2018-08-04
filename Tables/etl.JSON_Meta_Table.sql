CREATE TABLE [etl].[JSON_Meta_Table]
(
[JSON_Meta_Table_ID] [int] NOT NULL IDENTITY(1, 1),
[Schema] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL CONSTRAINT [DF__JSON_Meta__Activ__4B4A1C3B] DEFAULT ((0)),
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__JSON_Meta__Creat__4C3E4074] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[CreatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__JSON_Meta__Creat__4D3264AD] DEFAULT (suser_sname()),
[LastUpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__JSON_Meta__LastU__4E2688E6] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[LastUpdatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__JSON_Meta__LastU__4F1AAD1F] DEFAULT (suser_sname())
)
GO
ALTER TABLE [etl].[JSON_Meta_Table] ADD CONSTRAINT [PK__JSON_Met__590D662E0AF82420] PRIMARY KEY CLUSTERED  ([JSON_Meta_Table_ID])
GO
ALTER TABLE [etl].[JSON_Meta_Table] ADD CONSTRAINT [UQ__JSON_Met__276CE6ED2E4BB467] UNIQUE NONCLUSTERED  ([Schema], [Name])
GO
